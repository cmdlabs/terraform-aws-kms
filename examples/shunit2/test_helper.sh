#!/usr/bin/env bash

usage() {
  printf "Usage: "
  for tf_var in "${vars[@]}" ; do
    printf "$tf_var=... "
  done
  printf "%s\n" "$0"
  exit 1
}

err() {
  echo "ERROR: $*" ; exit 1
}

vars=(
  AGGREGATOR_AWS_ACCESS_KEY_ID
  AGGREGATOR_AWS_SECRET_ACCESS_KEY
  SOURCE_AWS_ACCESS_KEY_ID
  SOURCE_AWS_SECRET_ACCESS_KEY
  TF_VAR_aggregator_account_id
  TF_VAR_source_account_id
)

for tf_var in "${vars[@]}" ; do
  code='[ -z $'"$tf_var"' ] && err "'"$tf_var"' not set"'
  eval "$code"
done

bins=(
  shunit2
  terraform
)

for bin in "${bins[@]}" ; do
  code='if ! command -v '"$bin"' > /dev/null ; then
          err "'"$bin"' not found in $PATH"
        fi'
  eval "$code"
done

switchAccount() {
  local role="$1"
  eval 'export AWS_ACCESS_KEY_ID="$'"$role"'_AWS_ACCESS_KEY_ID"'
  eval 'export AWS_SECRET_ACCESS_KEY="$'"$role"'_AWS_SECRET_ACCESS_KEY"'
}
