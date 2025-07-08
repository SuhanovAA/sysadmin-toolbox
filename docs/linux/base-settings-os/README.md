# Bash prompt (file bash-prompt.sh)

![Preview .bashrc](./images/bashrc-path.PNG)

The setup information from the site was used [Bash prompt manual](https://wiki.archlinux.org/title/Bash/Prompt_customization).

1. Download and start the bash-prompt.sh file from the repository
    ```bash
    wget https://raw.githubusercontent.com/SuhanovAA/sysadmin-toolbox/refs/heads/main/linux-scripts/bash-prompt.sh
    chmod +x bash-prompt.sh
    ./bash-prompt.sh
    ```
    or
    ```bash
    curl -O https://raw.githubusercontent.com/SuhanovAA/sysadmin-toolbox/refs/heads/main/linux-scripts/bash-prompt.sh
    chmod +x bash-prompt.sh
    ./bash-prompt.sh
    ```
    
    
2. Add the following code to your `~/.bashrc` file:

    ```bash
    # My console view (PS1)
    RED='\[\e[31m\]'
    GREEN='\[\e[32m\]'
    YELLOW='\[\e[33m\]'
    BLUE='\[\e[34m\]'
    RESET='\[\e[0m\]'

    PS1="${GREEN}\u${RESET}@${YELLOW}\h${RESET}:${BLUE}\w${RESET}\$ "

    export PS1
    ```

    and execute in terminal:
    
    ```bash 
    source ~/.bashrc 
    ```    