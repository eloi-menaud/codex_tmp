# codex : Linktree as code
Codex, it's built to be usable as it is.No need to build, configure, run script...

Simply add your links in the `codex.yaml` like so :
```yaml
LINKS: # mandatory key
  link: https://.....
  directory:
    link_1: https://.....
    link_2: https://.....
    directory:
      link: https://.....
  directory_2:
    link: https://.....
```

ad open the `codex.html` will give :

![](doc/exemple.png)

# rules and features
- the root key in `codex.yaml` must be `LINKS:`
- to add _spaces_ in a directory or link name use uderscore`hello_word -> hello word`
- the `codex.yaml` must be in same dir as `codex.html` (cause it uses relative path)

# clean up
after downloading or cloning of the repo yout can remove everything except :
```
codex.yaml
codex.html
logo.svg
fav.ico
```
> you can remove `logo.svg` & `fav.ico`, it will work properly but you will no longer have favicon in tabs and logo in title