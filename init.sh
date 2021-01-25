#!/bin/bash

if [ -d "node_modules" ];then
  echo 'Find directoy "node_modules"'
else
  echo 'Directoy "node_modules" not found, create soft link'
  ln -s ../node_modules .
fi

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



