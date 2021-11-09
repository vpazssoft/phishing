#!/usr/bin/env bash
# For this script, the following apply:
# License: https://mypdns.org/mypdns/support/-/wikis/License
# Issues: https://github.com/mitchellkrogza/phishing/issues
# Project: https://github.com/mitchellkrogza/phishing/tree/pyfunceble

set -e

SCRIPT_DIR=$(DIRNAME=$(dirname "$0"); cd "$DIRNAME"; pwd)

# Merging the master branch into the pyfunceble test branch
# We don't need the `git checkout branch` we are already here,
if [ "$(git merge main)" == "Already up to date." ]
then
    echo "Already up to date."
    echo "Continuing work"
else
    echo "There is a merge conflict" && exit 1
fi

# setup and Activate conda

# Get the conda CLI.
source "$HOME/miniconda/etc/profile.d/conda.sh"

hash conda

# First Update Conda
conda update -q conda

conda env update -f "$SCRIPT_DIR/.environment.yml" --prune -q

conda activate phishing

hash pyfunceble

# print pyfunceble version
pyfunceble --version

# Tell the script to install/update the configuration file automatically.
export PYFUNCEBLE_AUTO_CONFIGURATION=yes
export PYFUNCEBLE_CONFIG_DIR="${SCRIPT_DIR}"
export PYFUNCEBLE_OUTPUT_LOCATION="../${SCRIPT_DIR}/${outputDir}/"

pyfunceble -w 40 -f add-domain add-wildcard-domain IP-addr.cidr.list
pyfunceble -w 40 -uf add-link

conda deactivate phishing

conda env remove -n phishing
