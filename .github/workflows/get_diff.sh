#!/bin/bash

readonly data_folder="../../data"
readonly aws_region=eu-central-2

function print_diff(){
  local from_date=$1
  local to_date=$2
  echo -e "\nDiff from $from_date to $to_date"
  diff -C0 -c "$data_folder/aws-regional-services-$from_date.csv" "$data_folder/aws-regional-services-$to_date.csv" | grep "$aws_region"
}

function main() {
  local start_date=""
  local end_date=""
  local temp_month_and_year="";
  for file in "${data_folder}"/*
  do
    current_date="$(echo "${file}" | grep -Eo '[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}')"
    current_month_and_year="$(echo "${current_date}" | grep -Eo '[[:digit:]]{4}-[[:digit:]]{2}')"

    if [ "$start_date" == "" ];
    then
      start_date=$current_date
      temp_month_and_year=$current_month_and_year
    fi

    if [ "$temp_month_and_year" == "$current_month_and_year" ];
    then
      end_date=$current_date
    else
      print_diff "$start_date" "$end_date"
      start_date=$current_date
      temp_month_and_year=$current_month_and_year
    fi
  done
}


main "$@"