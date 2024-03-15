const fold   = (event,element) => {element.classList.toggle('folded');event.stopPropagation();}
const div    = (name,content)  => {return `<div onclick="fold(event,this)" class="folded"><h2>${name.replace('_',' ')}</h2>${content}</div>`};
const button = (name,link)     => {return `<button onclick="window.location.href ='${link}'">${name.replace('_',' ')}</button>`;};
const image  = (name)          => {return `<img src="images/${name}.png">`}
function is_image(name){
    return fetch(`images/${name}.png`, { method: 'HEAD' })
        .then(response => {
            return response.ok;
            return false;
        })
        .catch(error => {return false;});
}
function generate(key,obj){
    const content = "<section>" +
        Object.keys(obj).reduce((acc, k)=>{
            if(typeof obj[k] === 'string'){
                return acc + button(k,obj[k])
            }
            return acc
        }, '') +
        "</section>" +
        Object.keys(obj).reduce((acc, k)=>{
            if(typeof obj[k] === 'object'){
                return acc + generate(k,obj[k])
            }
            return acc
        }, '')

    return (key=='') ? content : div(key,content)
}

document.addEventListener('DOMContentLoaded', function() {
    fetch('codex.yaml')
    .then(response => response.text())
    .then(text => {
        links_obj = jsyaml.load(text);
        document.getElementById('main').innerHTML = generate('',links_obj["LINKS"]);
        document.querySelectorAll('main div h2').forEach(h2 => {
            const name = h2.innerHTML;
            is_image(name).then(exists => {if (exists){h2.innerHTML = image(name) + name;}})
        })
        document.querySelectorAll('main button').forEach(button => {
            const name = button.innerHTML;
            console.log(name)
            is_image(name).then(exists => {if (exists){button.innerHTML = image(name) + name;}})
        })
    })
});