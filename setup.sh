for dir in ./*; do
    dir=${dir%*/}
    dir=${dir##*/}
    if [ -d "$dir" ]; then
        cd $dir
        docker compose up -d
        cd -
    fi
done