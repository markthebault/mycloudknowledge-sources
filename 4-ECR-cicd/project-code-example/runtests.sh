#!/bin/bash

CONTAINER_IMAGE=$1

echo "******** RUN TESTS"

result=$(docker run -t --rm ${CONTAINER_IMAGE} | tr -d '\r')
echo Container output: $result

expect=$(echo "Hello first docker project !!!")
echo Value expected: $expect

if [ "$result" = "$expect" ]; then
    echo TEST [SUCCESS]
    exit 0
else
    echo TEST [FAIL]
    exit 1
fi