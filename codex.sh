IFS=$'\n'

man=$(cat <<EOF
┌─ codex man
│ codex path   - get path of codex.yaml
│ codex build  - build the codex.html
└─
EOF
)


img(){
    real_key=$(echo $1 | ascii2uni -q -a L)
    img=""
    if [ -f "images/$real_key.png" ]; then
        img="<img src=\"images/$real_key.png\">"
    # else
    #     echo "no image for link $real_key" >&2
    fi
    echo "$img"
}
button(){
    echo "<button onclick=\"event.stopPropagation();window.location.href='$2';\">$(img $1)$1</button>"
}
div(){
    echo '<div onclick="fold(event,this)" class="folded">'
    echo "<h2>$(img $1)$1</h2>"
    generate "$2"
    echo "</div>"
}

generate(){
    obj="$*"
    echo "<section>"
    for key in $(echo "$obj" | yq 'keys' | sed 's/^- //');do
        value=$(echo "$obj" | yq e ".[\""$key"\"]")
        type=$(echo "$obj" | yq e ".[\""$key"\"] | type")
        if [ "$type" != "!!map" ];then
            button "$key" "$value"
        fi
    done
    echo "</section>"
    for key in $(echo "$obj" | yq 'keys' | sed 's/^- //');do
        value=$(echo "$obj" | yq e ".[\""$key"\"]")
        type=$(echo "$obj" | yq e ".[\""$key"\"] | type")
        if [ "$type" == "!!map" ];then
            div "$key" "$value"
        fi
    done
}

build(){
    uni2ascii -q -a L codex.yaml > tmp.yaml
    links=$(yq e '.LINKS' tmp.yaml)
    generate "$links" >> tmp.html

    cat src/template.html   > codex.html
    ascii2uni -q -a L tmp.html >> codex.html
    echo "</main>" >> codex.html
    echo "<script>$(cat ./src/index.js)</script>" >> codex.html
    echo "</body>" >> codex.html
    echo "<style>$(cat src/style.css)</style>" >> codex.html
    echo '</html>' >> codex.html

    rm tmp.html
    rm tmp.yaml
}


case $1 in
    "path")
        echo $(dirname "$(realpath "$0")")/codex.yaml
        exit 0
        ;;
    "build")
        build
        echo "built"
        ;;
    "h" | "-h" | "help" | *)
        echo "$man"
        exit 0
        ;;
esac