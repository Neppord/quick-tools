#! /usr/bin/env bash

COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2
SHA1=$3

function get_status {
  git diff -w --numstat HEAD 
}

# COMMIT_SOURCE is empty if its a new commit,
# don't trigger otherwise.

if [ -z "$COMMIT_SOURCE" ]; then 
  get_status
  get_status | while read added removed file ; do
    if (( $removed == $added )); then
      echo "r rename"
    elif (( $added == 0 )); then
      echo "r remove"
    elif (( $removed < $added )); then
      echo "r extract"
    else
      echo "r inline"
    fi
  done | sort | uniq > $COMMIT_MSG_FILE
fi
