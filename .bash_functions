# .bash_functions

# get current branch in git repo (shamelessly stolen from ezprompt.net)
#
parse_git_branch() {

	local branch=$(git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	if [[ "${branch}" != "" ]]; then
	
		echo "[git: ${branch}$(parse_git_dirty)]"
	else
	
		echo ""
	fi
}

# get current status of git repo (shamelessly stolen from ezprompt.net)
#
parse_git_dirty() {

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
