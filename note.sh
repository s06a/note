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

addEditNote() {
  shift
  touch $directory/temp
  vim $directory/temp
  cat $directory/temp | sed 's/$/\\n/' | tr -d '\n' >> $directory/note.md
  echo "" >> $directory/note.md
  rm $directory/temp
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

syncNotes() {
  cd $directory
  cd ..
  if [ ! -d ./note/.git ]
  then
    read -p "Enter your noteSync git clone SSH: " noteSyncAddress
    mv $directory/note.md $directory/note.md.backup
    git clone $noteSyncAddress note
    cat $directory/note.md > $directory/note.md.backup
    cat $directory/note.md.backup | sort | uniq > $directory/note.md
    cd -
    echo nist
  else
    mv $directory/note.md $directory/note.md.backup
    cd ./note
    git pull
    cat $directory/note.md >> $directory/note.md.backup
    cat $directory/note.md.backup | sort | uniq > $directory/note.md
  fi
  git add .
  git commit -m 'add new notes'
  git push
  rm note.md.backup
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

    ae|-ae|add-edit)
      addEditNote $@
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

    --sync)
      syncNotes
      ;;

    *)
      echo "unknown"
      ;;
  esac
fi
