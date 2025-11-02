#!/bin/bash

DOCKER_IMAGE="my-latex-env"
MAIN_FILE=${1:-main.tex}

echo "--- Checking for Docker image: $DOCKER_IMAGE ---"

# This command checks if 'docker images' finds your image
if [[ "$(docker images -q $DOCKER_IMAGE 2> /dev/null)" == "" ]]; then
  echo "--- Image not found. Building '$DOCKER_IMAGE' from Dockerfile... ---"
  echo "--- (This might take a few minutes the first time) ---"

  docker build -t $DOCKER_IMAGE .
  
  if [ $? -ne 0 ]; then
    echo "--- Docker build failed. Exiting. ---"
    exit 1
  fi
  echo "--- Image build successful. ---"
else
  echo "--- Image '$DOCKER_IMAGE' found locally. ---"
fi

echo "--- Compiling $MAIN_FILE using Docker... ---"

docker run --rm -it \
  -v "$(pwd):/workdir" \
  -w /workdir \
  "$DOCKER_IMAGE" \
  sh -c "latexmk -C '$MAIN_FILE' && latexmk -pdf -shell-escape '$MAIN_FILE' && latexmk -c"

echo "--- Compilation finished. ---"