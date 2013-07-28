function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return
  
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is anything staged?
  if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS=" $STATUS"
  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(my_current_branch)$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function my_current_branch() {
  echo $(current_branch || echo "(no branch)")
}

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[red]%}(ssh) "
  fi
}
# Outputs a symbol for the repository type
function repos_type {
  git branch >/dev/null 2>/dev/null && echo '' && return
  hg root >/dev/null 2>/dev/null && echo '[ ☿ ]' && return
  echo ''
}
start1="%{$fg_bold[green]%}╭─%{$reset_color%}"
start2="%{$fg_bold[green]%}╰─≻%{$reset_color%}"
lft="%{$fg_bold[green]%}─[%{$reset_color%}"
lft2="%{$fg_bold[green]%}[%{$reset_color%}"
rgt="%{$fg_bold[green]%}] %{$reset_color%}"
rgte="%{$fg_bold[green]%}]%{$reset_color%}"
myuser="%{$fg[green]%}%n%{$reset_color%}"
myhost="%{$fg[yellow]%}%m%{$reset_color%}"
mypath="%{$fg_bold[blue]%}%${PWD/#$HOME/~}%{$reset_color%}"

# Current time 12-hour format
mytime="%{$fg[white]%}%t%{$reset_color%}"

# Return code of last command executed
myreturn="%{$fg[yellow]%}%?%{$reset_color%}"

# Number of terminals opened
myamount="%{$fg[yellow]%}%L%{$reset_color%}"

PROMPT='${start1}${lft} ${myuser}@${myhost} ${rgt}${lft2} ${mypath} ${rgte}$(my_git_prompt) $(ssh_connection) $(repos_type)
$start2'
RPS1="${myreturn}"

#Git Repo Info Accessed By "$(git_prompt_info)"
ZSH_THEME_PROMPT_RETURNCODE_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[green]%}[ %{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✕"
ZSH_THEME_GIT_PROMPT_SUFFIX=" %{$fg_bold[green]%}]%{$reset_color%}"
