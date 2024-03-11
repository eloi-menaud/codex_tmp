# If you want to use as default page for new windows & tabs on firefox
## new window
in firefox,
- go to `about:preferences#home`
- search `New Windows and Tabs > Homepage and new windows`
- use `Custom URLs`
- set up the url to be `file://{absolute/path/of/codex.html}`

## new tabs
firefox no longer lets you set a local page as the default page for its new tabs, so you need to use an extension. This extension does not allow you to set a local page that runs its own js. So this page must be hosted locally to use it like normal URL instead of local file.
### 1. install extension
install [New Tab Override](https://addons.mozilla.org/en-US/firefox/addon/new-tab-override/) or [Custom New Tab Page](https://addons.mozilla.org/en-US/firefox/addon/custom-new-tab-page/) or extension like those ones


### 2. run local server to serve codex.html
for exemple, with python server, run :
`nohup python3 -m http.server --directory {absolute/path/to/codex/directory} --bind 127.0.0.1 &`

to stop server :
- `lsof -i :8000` to get PID
- `kill {PID}` to kill process

### 3. set-up the extension
it the extension setting, set url as `http://127.0.0.1:8000/codex.html`