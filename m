Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A483260D4D
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 10:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbgIHIRP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 04:17:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50104 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729257AbgIHIRO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 04:17:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599553032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sVOwyYecIwvyo2CCnOIOLnXjm72bgWFV5llOXzD82ek=;
        b=ACs89HWAEKc1ZGmuy23qL6WNJOibyeJFp82EAKfcVH8kv4/TEImUU/z8OijF9rrAy0Ltzz
        gQhe0PhM8t3uKUTzRCdbuf2hAPjRQdv84rurDPZOF0GoboF1xBhNGIWffpw40yLPEB3bXR
        o3D1Ax067ZECM/mcuKly0EWfC/V9QRk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-VRO8V4KxNn-6_BxqV-1dug-1; Tue, 08 Sep 2020 04:17:09 -0400
X-MC-Unique: VRO8V4KxNn-6_BxqV-1dug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 864EF802B66
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 08:17:08 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 010E07ED84
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 08:17:07 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH v2 2/2] runtests: add ability to exclude tests
Date:   Tue,  8 Sep 2020 10:17:03 +0200
Message-Id: <20200908081703.6011-2-lczerner@redhat.com>
In-Reply-To: <20200908081703.6011-1-lczerner@redhat.com>
References: <20200908081703.6011-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add TEST_EXCLUDE configuration option to be able to skip specified
tests. This is usefull in situations when certain tests are causing
problems that are not yet fixed, but I'd still want to see if any of the
changes made didn't break anything else.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: Add proper description

 test/config      |  7 +++++--
 test/runtests.sh | 48 ++++++++++++++++++++++++++++++------------------
 2 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/test/config b/test/config
index 80a5f46..cab2703 100644
--- a/test/config
+++ b/test/config
@@ -1,4 +1,7 @@
-# Define raw test devices (or files) for test cases, if any
-# Copy this to config.local, and uncomment + define test files
+# Copy this to config.local, uncomment and define values
+#
+# Define tests to exclude from running
+# TEST_EXCLUDE=""
 #
+# Define raw test devices (or files) for test cases, if any
 # TEST_FILES="/dev/nvme0n1p2 /data/file"
diff --git a/test/runtests.sh b/test/runtests.sh
index f860766..fa240f2 100755
--- a/test/runtests.sh
+++ b/test/runtests.sh
@@ -7,6 +7,7 @@ DMESG_FILTER="cat"
 TEST_DIR=$(dirname $0)
 TEST_FILES=""
 FAILED=""
+SKIPPED=""
 MAYBE_FAILED=""
 
 # Only use /dev/kmsg if running as root
@@ -58,43 +59,50 @@ run_test()
 {
 	local test_name="$1"
 	local dev="$2"
+	local test_string=$test_name
 
+	# Specify test string to print
+	if [ -n "$dev" ]; then
+		test_string="$test_name $dev"
+	fi
+
+	# Log start of the test
 	if [ "$DO_KMSG" -eq 1 ]; then
-		if [ -z "$dev" ]; then
-			local dmesg_marker="Running test $test_name:"
-		else
-			local dmesg_marker="Running test $test_name $dev:"
-		fi
+		local dmesg_marker="Running test $test_string:"
 		echo $dmesg_marker | tee /dev/kmsg
 	else
 		local dmesg_marker=""
 		echo Running test $test_name $dev
 	fi
+
+	# Do we have to exclude the test ?
+	echo $TEST_EXCLUDE | grep -w "$test_name" > /dev/null 2>&1
+	if [ $? -eq 0 ]; then
+		echo "Test skipped"
+		SKIPPED="$SKIPPED <$test_string>"
+		return
+	fi
+
+	# Run the test
 	timeout --preserve-status -s INT -k $TIMEOUT $TIMEOUT ./$test_name $dev
 	local status=$?
+
+	# Check test status
 	if [ "$status" -eq 124 ]; then
 		echo "Test $test_name timed out (may not be a failure)"
 	elif [ "$status" -ne 0 ]; then
 		echo "Test $test_name failed with ret $status"
-		if [ -z "$dev" ]; then
-			FAILED="$FAILED <$test_name>"
-		else
-			FAILED="$FAILED <$test_name $dev>"
-		fi
+		FAILED="$FAILED <$test_string>"
 		RET=1
 	elif ! _check_dmesg "$dmesg_marker" "$test_name"; then
 		echo "Test $test_name failed dmesg check"
-		if [ -z "$dev" ]; then
-			FAILED="$FAILED <$test_name>"
-		else
-			FAILED="$FAILED <$test_name $dev>"
-		fi
+		FAILED="$FAILED <$test_string>"
 		RET=1
-	elif [ ! -z "$dev" ]; then
+	elif [ -n "$dev" ]; then
 		sleep .1
 		ps aux | grep "\[io_wq_manager\]" > /dev/null
 		if [ $? -eq 0 ]; then
-			MAYBE_FAILED="$MAYBE_FAILED $test_name"
+			MAYBE_FAILED="$MAYBE_FAILED $test_string"
 		fi
 	fi
 }
@@ -109,8 +117,12 @@ for tst in $TESTS; do
 	fi
 done
 
+if [ -n "$SKIPPED" ]; then
+	echo "Tests skipped: $SKIPPED"
+fi
+
 if [ "${RET}" -ne 0 ]; then
-	echo "Tests $FAILED failed"
+	echo "Tests failed: $FAILED"
 	exit $RET
 else
 	sleep 1
-- 
2.26.2

