if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "     $0 <module_name>"
else   
	CURRENT_BRANCH=$(git status | grep "On branch" | cut -d ' ' -f 4)
	NO_CHANGES=$(git status | grep "nothing to commit" | wc -l)
	if [ $NO_CHANGES -eq 1 ]; then
		git checkout $1
		git fetch remote_$1
		git merge remote_$1 master
		git checkout master
		git merge --squash -s subtree --no-commit $1
		if [ "$CURRENT_BRANCH" != "master" ]; then
			git checkout $CURRENT_BRANCH
			git merge master
		fi
	else
		echo "It is not posible to leave current branch '$CURRENT_BRANCH' because it is dirty. Please commit changes or discard them!"
	fi
fi
