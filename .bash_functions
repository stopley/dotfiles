# .bash_functions

# get current branch in git repo (shamelessly stolen from ezprompt.net)
#
function parse_git_branch() {

  # don't show the git decoration in the home directory; this is important
  # because I usually manage the configuration files in my home via a git repo
  # and it's usually going to be out of date
  #
  if [[ "${PWD}" == "${HOME}" ]]; then

    echo ""
    return
  fi

  local branch=$(git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  if [[ "${branch}" != "" ]]; then

#    echo "[git: ${branch}$(parse_git_dirty)]"
    echo "[git: ${branch}]"
  else

    echo ""
  fi
}

# get current status of git repo (shamelessly stolen from ezprompt.net)
#
function parse_git_dirty() {

  local status=$(git status 2>&1 | tee)
  local bits=''

  echo -n "${status}" 2>/dev/null | grep "renamed:"                &>/dev/null && bits=">${bits}"
  echo -n "${status}" 2>/dev/null | grep "Your branch is ahead of" &>/dev/null && bits="*${bits}"
  echo -n "${status}" 2>/dev/null | grep "new file:"               &>/dev/null && bits="+${bits}"
  echo -n "${status}" 2>/dev/null | grep "Untracked files"         &>/dev/null && bits="?${bits}"
  echo -n "${status}" 2>/dev/null | grep "deleted:"                &>/dev/null && bits="x${bits}"
  echo -n "${status}" 2>/dev/null | grep "modified:"               &>/dev/null && bits="!${bits}"

  if [[ "${bits}" != "" ]]; then

    echo " ${bits}"
  else

    echo ""
  fi
}

# check that a function exists (shamelessly stolen from https://gist.github.com/mwhite/6887990)
#
function function_exists() {

  declare -f -F ${1} > /dev/null
  return ${?}
}

# list or less
#
function l() {

  # handle special (common?) case for no arguments
  #
  if (( ${#} == 0 )); then

    ll
    return
  fi

  local -a files
  local -a dirs

  local arg
  for arg in "${@}"; do

    if [[ -d "${arg}" ]]; then

      dirs+=("${arg}")
    else

      files+=("${arg}")
    fi
  done

  (( ${#dirs[@]} > 0 )) && ll "${dirs[@]}"

  (( ${#files[@]} > 0 )) && less "${files[@]}"
}
