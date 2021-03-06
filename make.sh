#/bin/sh

if [ -z "$1" ]; then
    echo "image name not set, use 'build.sh <image:tag>'"
    exit
fi

echo "Building docker image $1"
docker build -t $1 .
