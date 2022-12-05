#!/bin/bash
#
# Simple script, to ensure you have the latest versions of deno, deployctl, and other tools used here.
# Copyright 2022 alextorresruiz

set -e

#######################################
# Install or upgrade Deno if not exist.
# Globals:
#   None
# Arguments:
#   None
#######################################
function install_or_upgrade_deno() {
  # Check if deno is installed using homebrew, if not, install it. If yes, upgrade it.
  if ! command -v deno &> /dev/null
  then
    show "deno could not be found, installing it..."
    brew install deno
  else
    show "deno is already installed, upgrading it..."
    brew upgrade deno
  fi
}

#######################################
# Install or upgrade GUM if not exist.
# Globals:
#   None
# Arguments:
#   None
#######################################
function install_gum(){
  if ! command -v gum &> /dev/null
  then
    echo "gum could not be found, installing it..."
    brew install gum
  else
    echo "gum is already installed, upgrading it..."
    brew upgrade gum
  fi
}

#######################################
# Install deployCTL CLI, for interact with Deno Deploy.s
# See more details: https://deno.com/deploy/docs/deployctl#deployctl-cli
# Globals:
#   None
# Arguments:
#   None
#######################################
function install_deployctl_cli(){
  if ! command -v deployctl &> /dev/null
  then
    show "deployctl could not be found, installing it..."
    deno install --allow-read --allow-write --allow-env --allow-net --allow-run --no-check -r -f https://deno.land/x/deploy/deployctl.ts
  else
    show "deployctl is already installed"
  fi
}

function install_denon(){
  if ! command -v denon &> /dev/null
  then
    show "denon could not be found, installing it..."
    deno install -qAf --unstable https://deno.land/x/denon/denon.ts
  else
    show "denon is already installed"
  fi
}

show(){
  local sleepTime
  sleepTime="$2"

  if [ -z "$sleepTime" ]; then
    sleepTime=2
  fi

  gum spin --spinner dot --title "$1" -- sleep "$sleepTime"
}

result() {
  gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	"$1"
}

function main(){
  install_gum
  install_or_upgrade_deno
  install_deployctl_cli
  install_denon

  result "Deno, DeployCTL, and everything was installed! "
}

main "$@"
