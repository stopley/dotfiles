# .bashrc

# prevent default group writes & disallow ANY permissions to others
#
umask 022

# source (a file) if present
#
# $1 - the file to source
#
function sip() {

  [[ -f "${1}" ]] && source "${1}"
}

# source a bunch of crap and then kill the sip function
#
sip /etc/bashrc
sip ~/.bash_aliases
sip ~/.bash_functions
unset sip

# source all of the files in the users .bash_completion.d directory
#
for COMPLETION in $(find -L ~/.bash_completion.d -type f); do

  source "${COMPLETION}"
done
unset COMPLETION

### This Changes The PS1 ### {{{
export PROMPT_COMMAND=__prompt_command      # Func to gen PS1 after CMDs

function __prompt_command() {
  local EXIT="$?"                         # This needs to be first
  PS1=""

  ### Colors to Vars ### {{{
  ## Inspired by http://wiki.archlinux.org/index.php/Color_Bash_Prompt#List_of_colors_for_prompt_and_Bash
  ## Terminal Control Escape Sequences: http://www.termsys.demon.co.uk/vtansi.htm
  ## Consider using some of: https://gist.github.com/bcap/5682077#file-terminal-control-sh
  ## Can unset with `unset -v {,B,U,I,BI,On_,On_I}{Bla,Red,Gre,Yel,Blu,Pur,Cya,Whi} RCol`
  local RCol='\[\e[0m\]'    # Text Reset

  # Regular                    Bold                          Underline                     High Intensity                BoldHigh Intensity             Background                High Intensity Backgrounds
  local Bla='\[\e[0;30m\]';    local BBla='\[\e[1;30m\]';    local UBla='\[\e[4;30m\]';    local IBla='\[\e[0;90m\]';    local BIBla='\[\e[1;90m\]';    local On_Bla='\e[40m';    local On_IBla='\[\e[0;100m\]';
  local Red='\[\e[0;31m\]';    local BRed='\[\e[1;31m\]';    local URed='\[\e[4;31m\]';    local IRed='\[\e[0;91m\]';    local BIRed='\[\e[1;91m\]';    local On_Red='\e[41m';    local On_IRed='\[\e[0;101m\]';
  local Gre='\[\e[0;32m\]';    local BGre='\[\e[1;32m\]';    local UGre='\[\e[4;32m\]';    local IGre='\[\e[0;92m\]';    local BIGre='\[\e[1;92m\]';    local On_Gre='\e[42m';    local On_IGre='\[\e[0;102m\]';
  local Yel='\[\e[0;33m\]';    local BYel='\[\e[1;33m\]';    local UYel='\[\e[4;33m\]';    local IYel='\[\e[0;93m\]';    local BIYel='\[\e[1;93m\]';    local On_Yel='\e[43m';    local On_IYel='\[\e[0;103m\]';
  local Blu='\[\e[0;34m\]';    local BBlu='\[\e[1;34m\]';    local UBlu='\[\e[4;34m\]';    local IBlu='\[\e[0;94m\]';    local BIBlu='\[\e[1;94m\]';    local On_Blu='\e[44m';    local On_IBlu='\[\e[0;104m\]';
  local Pur='\[\e[0;35m\]';    local BPur='\[\e[1;35m\]';    local UPur='\[\e[4;35m\]';    local IPur='\[\e[0;95m\]';    local BIPur='\[\e[1;95m\]';    local On_Pur='\e[45m';    local On_IPur='\[\e[0;105m\]';
  local Cya='\[\e[0;36m\]';    local BCya='\[\e[1;36m\]';    local UCya='\[\e[4;36m\]';    local ICya='\[\e[0;96m\]';    local BICya='\[\e[1;96m\]';    local On_Cya='\e[46m';    local On_ICya='\[\e[0;106m\]';
  local Whi='\[\e[0;37m\]';    local BWhi='\[\e[1;37m\]';    local UWhi='\[\e[4;37m\]';    local IWhi='\[\e[0;97m\]';    local BIWhi='\[\e[1;97m\]';    local On_Whi='\e[47m';    local On_IWhi='\[\e[0;107m\]';
  ### End Color Vars ### }}}

  local -i columns
  columns=`tput cols`
  columns=$(($columns-5))

  if [[ ${columns} != ${WINDOW_COLUMNS} ]]; then
    local build_line=""
    for ((n=0;n<columns;n++))
    do
      build_line+="="
    done

    export WINDOW_LINE=${build_line}
    export WINDOW_COLUMNS=${columns}
  fi

  if [ $EXIT != 0 ]; then
    PS1+="\n${Red}${WINDOW_LINE} [✖]${RCol}\n"      # Add red if exit code non 0
  else
    PS1+="\n${Gre}${WINDOW_LINE} [✔]${RCol}\n"
  fi

  if [[ `uname` == "MINGW64_NT-10.0" ]]; then
    PS1+="\[\033]0;${PWD//[^[:ascii:]]/?}\007\]\n${BGre}\u${BWhi}@${BGre}\h ${BYel}\w${BCya}`__git_ps1`${BWhi}\n(\!) > ${RCol}"
  else
    #  #export PS1="\n\e[0;32m[\t]\e[m \e[0;34m\w\e[m \e[0;31m\$(parse_git_branch)\e[m\n\u@\h (\!) \\$ "
    #  #export PS1+="\[\033]0;${PWD//[^[:ascii:]]/?}\007\]\n\[\033[32m\]\u@\h \[\033[33m\]\w\[\033[36m\]$(parse_git_branch)\[\033[37;1m\]\n(\!) > \[\033[0m\]"
    PS1+="\[\033]0;${PWD//[^[:ascii:]]/?}\007\]\n${BGre}\u${BWhi}@${BGre}\h ${BYel}\w${BCya}$(parse_git_branch)${BWhi}\n(\!) > ${RCol}"
  fi
  #PS1+="${BBlu}\u${RCol}@${BBlu}\h ${Pur}\W${BYel}$ ${RCol}"
}
### End PS1 ### }}}

# set a custom prompt
#
#if [[ `uname` == "MINGW64_NT-10.0" ]]; then
#  export PS1='\[\033]0;${PWD//[^[:ascii:]]/?}\007\]\n\[\033[32m\]\u@\h \[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[37;1m\]\n(\!) > \[\033[0m\]'
#else
#  #export PS1="\n\e[0;32m[\t]\e[m \e[0;34m\w\e[m \e[0;31m\$(parse_git_branch)\e[m\n\u@\h (\!) \\$ "
#  export PS1='\[\033]0;${PWD//[^[:ascii:]]/?}\007\]\n\[\033[32m\]\u@\h \[\033[33m\]\w\[\033[36m\] $(parse_git_branch)\[\033[0m\]\n(\!) > \[\033[0m\]'
#fi

# map git aliases to bash aliases (shamelessly stolen from https://gist.github.com/mwhite/6887990)
#
#if function_exists '__git_aliases'; then
#
#  for al in $(__git_aliases); do
#
#    alias g${al}="git ${al}"
#
#    complete_func=_git_$(__git_aliased_command ${al})
#    function_exists ${complete_fnc} && __git_complete g${al} ${complete_func}
#  done
#  unset al
#fi

# set nano as the editor if it's available
#
#if command -v nano >/dev/null 2>&1; then
#
#  export EDITOR=nano
#  alias pico='nano'
#fi
