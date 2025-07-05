# Настройка цветного Bash prompt

![Preview .bashrc](./images/bashrc-path.PNG)

The setup information from the site was used [Bash prompt manual](https://wiki.archlinux.org/title/Bash/Prompt_customization).

Add the following code to your `~/.bashrc` file to get a colored prompt with the username, hostname, and current directory:

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
