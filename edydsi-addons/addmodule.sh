if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "     $0 <full_path_to_module> [<module_name>]"
else   
    CURRENT_BRANCH=$(git status | grep "On branch" | cut -d ' ' -f 4)
    NO_CHANGES=$(git status | grep "nothing to commit" | wc -l)
    if [ $NO_CHANGES -eq 1 ]; then
        FULLPATH=$1
        MODULE=$2
        if [ $# -eq 1 ]; then
            MODULE=${FULLPATH##*/}
        fi
        echo "Adding module $MODULE with path $FULLPATH"
        git remote add remote_$MODULE $FULLPATH
        git fetch remote_$MODULE
        git checkout -b $MODULE remote_$MODULE/master
        git checkout master
        git read-tree --prefix=$MODULE -u $MODULE
        git commit -a -m "[ADD] $MODULE"
        if [ "$CURRENT_BRANCH" != "master" ]; then
            git checkout $CURRENT_BRANCH
            git merge master
        fi
    else
        echo "It is not posible to leave current branch $CURRENT_BRANCH because it's dirty. Please commit it or discard changes"
    fi
fi


