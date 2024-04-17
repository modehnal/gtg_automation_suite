#!/bin/bash
set -x

RUN_START=$(date +%s)
COREDUMP_TARGET="gtg"
TEST_REPORT_FILE="/tmp/report_$1.html"

# Reducing false negatives by repeating tests but not those that are expected to fail.
NON_REPEATING_TESTS=""
is_known_to_fail() {
  [[ $NON_REPEATING_TESTS =~ (^|[[:space:]])$1($|[[:space:]]) ]] && echo "0" || echo "1"
}


# Setup dogtail.
if [ ! -e /tmp/dogtail_setup_done ]; then
  # Install from git.
  python3 -m pip install git+https://gitlab.com/dogtail/dogtail@devel/wayland
  # Make the setup only once.
  touch /tmp/dogtail_setup_done

fi

# Setup qecore.
if [ ! -e /tmp/qecore_setup_done ]; then
  # Specify version, in case of a mistake in the next version, we still need working automation.
  python3 -m pip install qecore==3.24
  # Soft link to make qecore-headless script easily accessible.
  ln -s /usr/local/bin/qecore-headless /usr/bin/qecore-headless
  # Make the setup only once.
  touch /tmp/qecore_setup_done
fi


# Setup ponytail.
if [ ! -e /tmp/ponytail_setup_done ]; then
  dnf install -y https://kojipkgs.fedoraproject.org//packages/gnome-ponytail-daemon/0.0.10/2.fc40/x86_64/gnome-ponytail-daemon-0.0.10-2.fc40.x86_64.rpm https://kojipkgs.fedoraproject.org//packages/gnome-ponytail-daemon/0.0.10/2.fc40/noarch/python3-gnome-ponytail-daemon-0.0.10-2.fc40.noarch.rpm
  # Make the setup only once.
  touch /tmp/ponytail_setup_done
fi


# In attempt to reduce false negatives, repeat tests that are not expected to fail.
MAX_FAIL_COUNT=2
for i in $(seq 1 1 $MAX_FAIL_COUNT); do
  if [[ $(arch) == "x86_64" ]]; then
    # For x86_64 respect the system setting.
    sudo -u test qecore-headless --keep-max --force "behave -t $1 -k -f html-pretty -o $TEST_REPORT_FILE -f plain"; rc=$?
  else
    # Fixing xorg on anything else.
    sudo -u test qecore-headless --session-type xorg --keep-max --force "behave -t $1 -k -f html-pretty -o $TEST_REPORT_FILE -f plain"; rc=$?
  fi

  [ $rc -eq 0 -o $rc -eq 77 ] && break
  [ "$(is_known_to_fail $1)" -eq 0 ] && break

done

exit $rc
