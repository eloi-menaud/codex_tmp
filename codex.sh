IFS=$'\n'

img(){
    real_key=$(echo $1 | ascii2uni -q -a L)
    img=""
    if [ -f "images/$real_key.png" ]; then
        img="<img src=\"images/$real_key.png\">"
    else
        echo "no image for link $real_key" >&2
    fi
    echo "$img"
}
button(){
    echo "<button onclick=\"event.stopPropagation();window.location.href='$2';\">$(img $1)$1</button>"
}
div(){
    echo '<div onclick="fold(event,this)">'
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



uni2ascii -q -a L codex.yaml > tmp.yaml
links=$(yq e '.LINKS' tmp.yaml)
generate "$links" >> tmp.html



cat src/template.html   > codex.html
ascii2uni -q -a L tmp.html >> codex.html
cat <<END_HTML          >> tmp.html
</main>
</body>
</html>
END_HTML

rm tmp.yaml
rm tmp.html