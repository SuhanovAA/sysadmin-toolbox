# Устанавливаем дату и время для логирования
$date = Get-Date -Format "yyyy-MM-dd-HH-mm"
$basePath = "C:\Scripts\Logs\"
$logFile = "$basePath\log.txt"

# Файлы со списками ПК
$File1 = "$basePath\comps.txt"
$File2 = "$basePath\no_answer.txt"
$File3 = "$basePath\result-$date.txt"

# Проверяем существование директории, если нет - создаем
if (-Not (Test-Path $basePath)) {
    New-Item -ItemType Directory -Path $basePath | Out-Null
}

# Загрузка имен компьютеров из AD, если файл отсутствует
if (-Not (Test-Path $File1)) {
    Get-ADComputer -SearchBase 'DC=DC,DC=local' -Filter * |
        Where-Object { $_.Enabled -eq $true } |
        Sort-Object Name |
        Select-Object -ExpandProperty Name |
        Out-File $File1
    "[$date] Создан список компьютеров из AD." | Out-File -Append $logFile
}

# Используем список недоступных ПК, если он есть
if (Test-Path $File2) {
    Get-Content $File2 | Out-File $File1
    "[$date] Используется список компьютеров из $File2." | Out-File -Append $logFile
}

# Устанавливаем новый пароль (без шифрования)
$adminPassword = "PASSWORD"

# Обнуляем списки
$result = @()
$noanswer = @()

foreach ($computerName in Get-Content $File1) {
    $computerName = $computerName.Trim()
    Write-Host "Обрабатывается: $computerName"
    "[$date] Проверка: $computerName" | Out-File -Append $logFile
    
    if (Test-Connection -ComputerName $computerName -Count 2 -Quiet) {
        try {
            "[$date] $computerName отвечает на Ping. Изменение пароля..." | Out-File -Append $logFile
            
            Invoke-Command -ComputerName $computerName -ScriptBlock {
                param ($password)
                $user = [ADSI] "WinNT://./admin,user"
                if ($user) {
                    $user.SetPassword($password)
                }
            } -ArgumentList $adminPassword -ErrorAction Stop
            
            $result += $computerName
            "[$date] Пароль изменен на $computerName" | Out-File -Append $logFile
        } catch {
            "[$date] Ошибка на ${computerName}: $_" | Out-File -Append $logFile
            $noanswer += $computerName
        }
    } else {
        "[$date] $computerName не отвечает на Ping." | Out-File -Append $logFile
        $noanswer += $computerName
    }
}

# Сохраняем результаты
if ($noanswer.Count -gt 0) { Set-Content $File2 $noanswer }
if ($result.Count -gt 0) { Set-Content $File3 $result }
"[$date] Скрипт завершен." | Out-File -Append $logFile
