#!/bin/bash

# todo: encrypt notes
# todo: take todos
# todo: render markdown

# ENV VARIABLES

directory=$HOME/Documents/note

# FUNCTIONS

addNote() {
  shift
  echo -e "$(</dev/stdin)" | sed 's/$/\\n/' | tr -d '\n' >> $directory/note
  echo "" >> $directory/note
}

addEditNote() {
  shift
  touch $directory/temp
  vim $directory/temp
  cat $directory/temp | sed 's/$/\\n/' | tr -d '\n' >> $directory/note
  echo "" >> $directory/note
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
    mv $directory/note $directory/note.backup
    git clone $noteSyncAddress note
    cat $directory/note > $directory/note.backup
    cat $directory/note.backup | sort | uniq > $directory/note
  else
    mv $directory/note $directory/note.backup
    cd ./note
    git pull
    cat $directory/note >> $directory/note.backup
    cat $directory/note.backup | sort | uniq > $directory/note
  fi
  git add .
  git commit -m 'add new notes'
  git push
  rm note.backup
}

searchNote() {
  shift 
  if [ ! -z "${@}" ]
  then
    keywords=`echo $@ | sed -e "s/ /.*/g"`
  else
    keywords="."
  fi
  result=`grep -n $keywords $directory/note`
  echo ""
  echo -e "$result" # | sed -E 's/^/\t/'
}

removeNote() {
  shift
  sed -i.backup "$@d" $directory/note
}

#editNote() {
#  shift
#  temp=`sed "$@!d" $directory/note`
#  echo -e "$temp" > $directory/temp
#  vim $directory/temp
#  temp=`cat $directory/temp | sed 's/$/\\n/'`
#  #temp=`cat $directory/temp | sed 's/$/\\n/' | tr -d '\n'`
#  #sed -i $@"s/.*/$temp/" $directory/note
#  echo -e "$temp" >> $directory/note
#  echo "" >> $directory/note
#  sed -i "$@d" $directory/note
#  rm $directory/temp
#}

editNote() {
  shift
  temp=`sed "$@!d" $directory/note`
  echo -e "$temp" > $directory/temp
  vim $directory/temp
  sed -i "$@d" $directory/note
  cat $directory/temp | sed 's/$/\\n/' | tr -d '\n' | sed 's/..$//' >> $directory/note
  echo "" >> $directory/note
  rm $directory/temp
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

    e|-e|edit)
      editNote $@
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

    sync)
      syncNotes
      ;;

    *)
      echo "unknown"
      ;;
  esac
fi
