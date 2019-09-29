#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2164,SC2154,SC2155,SC2103

. shunit2/test_helper.sh

testSimple() {
  cd simple

  if ! terraform apply -auto-approve ; then
    fail "terraform did not apply"
    startSkipping
  fi

  cd ..
}

oneTimeTearDown() {
  if [ "$NO_TEARDOWN" != "true" ] ; then
    cd simple
    terraform destroy -auto-approve
    cd ..
  fi
}

. shunit2
