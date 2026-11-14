# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit acct-user

DESCRIPTION="User for the KiroCrew gateway"

ACCT_USER_ID=-1
ACCT_USER_GROUPS=( kirocrew )
ACCT_USER_HOME=/var/lib/kirocrew
ACCT_USER_HOME_PERMS=0750

acct-user_add_deps
