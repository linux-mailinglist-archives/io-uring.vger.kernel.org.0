Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68177260D4E
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 10:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbgIHIRQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 04:17:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37261 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729432AbgIHIRP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 04:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599553033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BsxxnwV5VlJSyFgfsGXdxz6pjpOcfy2fMvIBaH0C0Bc=;
        b=ZDtc1o+r++roOjgi7RZY4bC3se58EO14Hw8sXWBGEIaeHYycTAMkvVCD+dKD9A3CGEdF7h
        4JUFIkGtFmgi6TPzJY3H7wxZjyZFdN3QXF5ckaxDzWgogSaUduTRtofoJK2vGBoUe9Lryx
        eo5iTd3DeVixIBdG6NNXjCpD2ujOPmQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24--BbcKTP2MwO7cbsr4zihZw-1; Tue, 08 Sep 2020 04:17:08 -0400
X-MC-Unique: -BbcKTP2MwO7cbsr4zihZw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1EC8802B60
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 08:17:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D7C37ED84
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 08:17:06 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH v2 1/2] runtests: Clean up code in runtests.sh
Date:   Tue,  8 Sep 2020 10:17:02 +0200
Message-Id: <20200908081703.6011-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use uppercase for global and lowecase for local valiable consistently.
Don't use single letter variable names and add some comments.

No functional changes.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: Update description and subject, don't remove quotes around RET variable

 test/runtests.sh | 76 +++++++++++++++++++++++-------------------------
 1 file changed, 37 insertions(+), 39 deletions(-)

diff --git a/test/runtests.sh b/test/runtests.sh
index 2cf1eb2..f860766 100755
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
 
@@ -56,56 +56,55 @@ _check_dmesg()
 
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
@@ -116,8 +115,7 @@ if [ "${RET}" -ne 0 ]; then
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

