### docker image for react-hs continuous integration testing.

Related:

- https://github.com/liqula/react-hs
- https://hub.docker.com/r/fisx/react-hs-docker/


### usage

This repo is linked against docker.io/fisx/react-hs-docker and should
be automatically built on every push, but due to resource limiations
this sometimes fails.  If you want to re-build yourself, try this:

```sh
export MY_REPO=...  # (e.g. `fisx/react-hs-docker`.)
git clone ssh://git@github.com/liqula/react-hs-docker
cd react-hs-docker/
docker build --no-cache -t react-hs-docker .
docker login
docker tag react-hs-docker $MY_REPO
docker push $MY_REPO
```
