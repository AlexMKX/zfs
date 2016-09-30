#!/bin/ksh -p
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#

. $STF_SUITE/include/libtest.shlib

#
# DESCRIPTION:
# Verify that the dnodesize dataset property won't accept a value
# other than "legacy" if the large_dnode feature is not enabled.
#

verify_runnable "both"

function cleanup
{
        if datasetexists $LGCYPOOL ; then
                log_must $ZPOOL destroy -f $LGCYPOOL
        fi
}

log_onexit cleanup

log_assert "values other than dnodesize=legacy rejected by legacy pool"

set -A prop_vals "auto" "1k" "2k" "4k" "8k" "16k"

LGCYPOOL=lgcypool
LGCYFS=$LGCYPOOL/legacy
log_must $MKFILE 64M  $TESTDIR/$LGCYPOOL
log_must $ZPOOL create -d $LGCYPOOL $TESTDIR/$LGCYPOOL
log_must $ZFS create $LGCYFS

for val in ${prop_vals[@]} ; do
	log_mustnot $ZFS set dnodesize=$val $LGCYFS
done

log_pass