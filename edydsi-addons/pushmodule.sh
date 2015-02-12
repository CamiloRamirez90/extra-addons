if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "     $0 <module_name>"
else   
	CURRENT_BRANCH=$(git status | grep "On branch" | cut -d ' ' -f 4)
	NO_CHANGES=$(git status | grep "nothing to commit" | wc -l)
	if [ $NO_CHANGES -eq 1 ]; then
		git checkout $1
		git merge --squash -s subtree master
		NO_CHANGES=$(git status | grep "nothing to commit" | wc -l)
		if [ $NO_CHANGES -eq 0 ]; then
			git commit -a -m "[UPDATE] from subproject"
			git push remote_$1 HEAD:master
		else
			echo "NO CHANGES. Nothing pushed!"
		fi
		git checkout $CURRENT_BRANCH
	else
		echo "It is not posible to leave current branch $CURRENT_BRANCH because it's dirty. Please commit it or discard changes"
	fi
fi
