# devcontainer

My personal base image for containerized development environments.

## Developing

Test changes to `Dockerfile` with this command:

```sh
IMG_ID=$(docker build -q .) && docker run --rm -it $IMG_ID; docker rmi $IMG_ID
```
