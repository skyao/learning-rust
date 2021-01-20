#!/bin/bash

if [ ! -d "themes" ];then
  echo "No themes directory, create it"
  mkdir themes
fi

if [ -d "themes/docsy" ];then
  echo 'Find directoy "themes/docsy"'
else
  echo 'Directoy "themes/docsy" not found, create soft link'
  cd themes
  ln -s ../../docsy .
fi



