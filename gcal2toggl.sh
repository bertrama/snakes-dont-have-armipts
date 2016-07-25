#!/bin/bash

START="$(date -d "today" +%Y-%m-%d)"
END="$(date -d "tomorrow" +%Y-%m-%d)"

while read line ; do
  first=$(echo "$line" | awk '{print $1}')
  if [ x"$first" != x"Length:" ] ; then
    start_time="$first"
    subject=$(echo "$line" | cut -c 8-)
  else
    duration=$(echo "$line" | awk '{print $2}')
    tag=''
    project=''
    case "$subject" in
    LIT\ Developers\ brown\ bag)
      tag="-D"
      project="@Professional development - Me"
      ;;

    Search\ Project\ Check-In)
      tag="-P"
      project="@Search redesign initiative - U-M Library"
      ;;

    Hydra\ Code\ Club)
      tag="-D"
      project="@Professional development - Me"
      ;;
    *)
      #echo "$subject"
    esac
    if [ x"$project" != x"" ] ; then
      toggl \
        'add'
        "$tag" \
        "From Calendar: $subject" \
        ':U-M Library IT Workload Study' \
        "$project" \
        "$start_time" \
        d"$duration"
    fi
  fi
done < <(gcalcli agenda "$START" "$END" --nocolor --military --detail_length 2>/dev/null| cut -c 13- )
