#!/bin/bash

if [ -d "/workspace" ] ; then
  ln -sfn /workspace "$HOME/workspace"
fi

