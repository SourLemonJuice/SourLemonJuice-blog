#!/bin/env bash

docker run -v .:/site -it --entrypoint bash --rm --network host jekyll-minima:latest
