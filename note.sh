#!/bin/bash

# todo: edit note
# todo: take notes in different files
# todo: encrypt notes
# todo: sync with github
# todo: take todos

# ENV VARIABLES

directory=$HOME/Documents/note

# FUNCTIONS

addNote() {
  shift
  echo -e "$(</dev/stdin)" | sed 's/$/\\n/' | tr -d '\n' >> $directory/note.md
  echo "" >> $directory/note.md
}

initDirectory() {
  if [ ! -d $directory ]
  then
    mkdir $directory
  fi
}

checkDirectory() {
  if [ ! -d $directory ]
  then
    initDirectory
  fi
}

searchNote() {
  shift 
  keywords=`echo $@ | sed -e "s/ /.*/g"`
  result=`grep -n $keywords $directory/note.md`
  echo ""
  echo -e "$result" # | sed -E 's/^/\t/'
}

removeNote() {
  shift
  sed -i.backup "$@d" $directory/note.md
}

help() {
  echo "Note taking help:"
  echo -e "\tnote a|-a|add [press enter] [write your single/multiple line note]"
  echo -e "\tnote s|-s|search <string>"
  echo -e "\tnote i|-i|init"
  echo -e "\tnote r|-r|remove <line number>"
}

# MAIN

# Inititalize the program
checkDirectory

# Reading the passed arguments and calling the desired function
if [[ $# -gt 0 ]];
then
  case $1 in
  
    a|-a|add)
      addNote $@
      ;;
  
    s|-s|search)
      searchNote $@ 
      ;;

    i|-i|init)
      initDirectory
      ;;

    r|-r|remove)
      removeNote $@
      ;;

    h|-h|help|--help)
      help
      ;;

    *)
      echo "unknown"
      ;;
  esac
fi
