#!/bin/zsh

# install mini-conda
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    zsh Miniconda3-latest-Linux-x86_64.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
    zsh Miniconda3-latest-MacOSX-x86_64.sh
fi
#rm Miniconda3-latest-MacOSX-x86_64.sh

