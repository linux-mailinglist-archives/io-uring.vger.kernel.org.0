Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BF226026B
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 19:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbgIGRZa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 13:25:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23227 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729314AbgIGNWf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 09:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599484950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=83OmKZf2FdZ//V/dEq/UmSuR25O9EgdYpQKvk/BV7eo=;
        b=OOsjfctoG5+DFs7v77zWO64SK3dU8iYg97ixvpwVHiGNXP1QqQ37IMl8Aix9z6xUKCumk3
        vfpfeVhlRKCE/LTWgV8oWQMdMKu0+LJhRgjkFLo3k2fN6qEoZYmhFWI9/q+giK2k7RKD0v
        chbxzvTFA4J82THI6I5lxLy+Sd1tBeE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-KeEJI--OPG6eG9pZuwMj9g-1; Mon, 07 Sep 2020 09:22:29 -0400
X-MC-Unique: KeEJI--OPG6eG9pZuwMj9g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7508F18B9F2C
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 13:22:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4A8C5DAA6
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 13:22:27 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH 1/2] runtests: Small code cleanup
Date:   Mon,  7 Sep 2020 15:22:24 +0200
Message-Id: <20200907132225.4181-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use uppercase for global valiable consistently.
Use lowercase local variables consistently.
Don't use single letter variable names.
Add some comments.

No functional changes.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 test/runtests.sh | 78 +++++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 40 deletions(-)

diff --git a/test/runtests.sh b/test/runtests.sh
index 2cf1eb2..1eb3fda 100755
--- a/test/runtests.sh
+++ b/test/runtests.sh
@@ -2,18 +2,18 @@
 
 TESTS="$@"
 RET=0
-
 TIMEOUT=60
+DMESG_FILTER="cat"
+TEST_DIR=$(dirname $0)
+TEST_FILES=""
 FAILED=""
 MAYBE_FAILED=""
 
-do_kmsg="1"
-if ! [ $(id -u) = 0 ]; then
-	do_kmsg="0"
-fi
+# Only use /dev/kmsg if running as root
+DO_KMSG="1"
+[ "$(id -u)" != "0" ] && DO_KMSG="0"
 
-TEST_DIR=$(dirname $0)
-TEST_FILES=""
+# Include config.local if exists and check TEST_FILES for valid devices
 if [ -f "$TEST_DIR/config.local" ]; then
 	. $TEST_DIR/config.local
 	for dev in $TEST_FILES; do
@@ -29,7 +29,7 @@ _check_dmesg()
 	local dmesg_marker="$1"
 	local seqres="$2.seqres"
 
-	if [[ $do_kmsg -eq 0 ]]; then
+	if [ $DO_KMSG -eq 0 ]; then
 		return 0
 	fi
 
@@ -56,68 +56,66 @@ _check_dmesg()
 
 run_test()
 {
-	T="$1"
-	D="$2"
-	DMESG_FILTER="cat"
+	local test_name="$1"
+	local dev="$2"
 
-	if [ "$do_kmsg" -eq 1 ]; then
-		if [ -z "$D" ]; then
-			local dmesg_marker="Running test $T:"
+	if [ "$DO_KMSG" -eq 1 ]; then
+		if [ -z "$dev" ]; then
+			local dmesg_marker="Running test $test_name:"
 		else
-			local dmesg_marker="Running test $T $D:"
+			local dmesg_marker="Running test $test_name $dev:"
 		fi
 		echo $dmesg_marker | tee /dev/kmsg
 	else
 		local dmesg_marker=""
-		echo Running test $T $D
+		echo Running test $test_name $dev
 	fi
-	timeout --preserve-status -s INT -k $TIMEOUT $TIMEOUT ./$T $D
-	r=$?
-	if [ "${r}" -eq 124 ]; then
-		echo "Test $T timed out (may not be a failure)"
-	elif [ "${r}" -ne 0 ]; then
-		echo "Test $T failed with ret ${r}"
-		if [ -z "$D" ]; then
-			FAILED="$FAILED <$T>"
+	timeout --preserve-status -s INT -k $TIMEOUT $TIMEOUT ./$test_name $dev
+	local status=$?
+	if [ "$status" -eq 124 ]; then
+		echo "Test $test_name timed out (may not be a failure)"
+	elif [ "$status" -ne 0 ]; then
+		echo "Test $test_name failed with ret $status"
+		if [ -z "$dev" ]; then
+			FAILED="$FAILED <$test_name>"
 		else
-			FAILED="$FAILED <$T $D>"
+			FAILED="$FAILED <$test_name $dev>"
 		fi
 		RET=1
-	elif ! _check_dmesg "$dmesg_marker" "$T"; then
-		echo "Test $T failed dmesg check"
-		if [ -z "$D" ]; then
-			FAILED="$FAILED <$T>"
+	elif ! _check_dmesg "$dmesg_marker" "$test_name"; then
+		echo "Test $test_name failed dmesg check"
+		if [ -z "$dev" ]; then
+			FAILED="$FAILED <$test_name>"
 		else
-			FAILED="$FAILED <$T $D>"
+			FAILED="$FAILED <$test_name $dev>"
 		fi
 		RET=1
-	elif [ ! -z "$D" ]; then
+	elif [ ! -z "$dev" ]; then
 		sleep .1
 		ps aux | grep "\[io_wq_manager\]" > /dev/null
-		R="$?"
-		if [ "$R" -eq 0 ]; then
-			MAYBE_FAILED="$MAYBE_FAILED $T"
+		if [ $? -eq 0 ]; then
+			MAYBE_FAILED="$MAYBE_FAILED $test_name"
 		fi
 	fi
 }
 
-for t in $TESTS; do
-	run_test $t
+# Run all specified tests
+for tst in $TESTS; do
+	run_test $tst
 	if [ ! -z "$TEST_FILES" ]; then
 		for dev in $TEST_FILES; do
-			run_test $t $dev
+			run_test $tst $dev
 		done
 	fi
 done
 
-if [ "${RET}" -ne 0 ]; then
+if [ ${RET} -ne 0 ]; then
 	echo "Tests $FAILED failed"
 	exit $RET
 else
 	sleep 1
 	ps aux | grep "\[io_wq_manager\]" > /dev/null
-	R="$?"
-	if [ "$R" -ne 0 ]; then
+	if [ $? -ne 0 ]; then
 		MAYBE_FAILED=""
 	fi
 	if [ ! -z "$MAYBE_FAILED" ]; then
-- 
2.26.2

