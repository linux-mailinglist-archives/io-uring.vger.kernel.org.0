Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A801026FAE1
	for <lists+io-uring@lfdr.de>; Fri, 18 Sep 2020 12:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgIRKr4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Sep 2020 06:47:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42846 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726332AbgIRKr4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Sep 2020 06:47:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600426074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SqlfRhi4ZWdo2O3PRqMV9yeMbIEHwISTubid+QqF4jo=;
        b=L9li//gQcAVmFR7xtdnuhyWinOmGadXLDguf8QVkTaahEHWmSyF87Sr2UKSXdtN/Zyj+mu
        jDOMOXQN7A+GtBxP6tFy1KtX1KlG7r0NFseZaWbV7st6UYb+SVMVai50pIhG6yPKNY7tK6
        vi7b41cVgrucFmIfDdDBSN5e5nrt9Xo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-u_gzvgwdMfaXFHVch5EWhg-1; Fri, 18 Sep 2020 06:47:52 -0400
X-MC-Unique: u_gzvgwdMfaXFHVch5EWhg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F6BF83DC20
        for <io-uring@vger.kernel.org>; Fri, 18 Sep 2020 10:47:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DE223782
        for <io-uring@vger.kernel.org>; Fri, 18 Sep 2020 10:47:50 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH 4/5] test: make test output more readable
Date:   Fri, 18 Sep 2020 12:47:45 +0200
Message-Id: <20200918104746.146747-4-lczerner@redhat.com>
In-Reply-To: <20200918104746.146747-1-lczerner@redhat.com>
References: <20200918104746.146747-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make the result of the test clear and aligned for better readability.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 test/runtests.sh | 101 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 76 insertions(+), 25 deletions(-)

diff --git a/test/runtests.sh b/test/runtests.sh
index b61cb27..ed28ec8 100755
--- a/test/runtests.sh
+++ b/test/runtests.sh
@@ -9,6 +9,7 @@ TEST_FILES=""
 FAILED=""
 SKIPPED=""
 MAYBE_FAILED=""
+TESTNAME_WIDTH=40
 
 # Only use /dev/kmsg if running as root
 DO_KMSG="1"
@@ -60,6 +61,62 @@ _check_dmesg()
 	fi
 }
 
+test_result()
+{
+	local result=$1
+	local logfile=$2
+	local test_string=$3
+	local msg=$4
+
+	[ -n "$msg" ] && msg="($msg)"
+
+	local RES=""
+	local logfile_move=""
+	local logmsg=""
+
+	case $result in
+		pass)
+			RES="OK";;
+		skip)
+			RES="SKIP"
+			SKIPPED="$SKIPPED <$test_string>"
+			logfile_move="${logfile}.skipped"
+			log_msg="Test ${test_string} skipped"
+			;;
+		timeout)
+			RES="TIMEOUT"
+			logfile_move="${logfile}.timeout"
+			log_msg="Test $test_name timed out (may not be a failure)"
+			;;
+		fail)
+			RET=1
+			RES="FAIL"
+			FAILED="$FAILED <$test_string>"
+			logfile_move="${logfile}.failed"
+			log_msg="Test ${test_string} failed"
+			;;
+		*)
+			echo "Unexpected result"
+			exit 1
+			;;
+	esac
+
+	# Print the result of the test
+	printf "\t$RES $msg\n"
+
+	[ "$result" == "pass" ] && return
+
+	# Show the test log in case something went wrong
+	if [ -s "${logfile}.log" ]; then
+		cat "${logfile}.log" | sed 's/^\(.\)/    \1/'
+	fi
+
+	echo "$log_msg $msg" >> ${logfile}.log
+
+	# Rename the log
+	[ -n "${logfile_move}" ] && mv ${logfile}.log ${logfile_move}
+}
+
 run_test()
 {
 	local test_name="$1"
@@ -73,19 +130,12 @@ run_test()
 
 	# Log start of the test
 	if [ "$DO_KMSG" -eq 1 ]; then
-		local dmesg_marker="Running test $test_string:"
-		echo $dmesg_marker | tee /dev/kmsg
+		local dmesg_marker="Running test $test_string"
+		echo $dmesg_marker > /dev/kmsg
+		printf "%-${TESTNAME_WIDTH}s" "$test_string"
 	else
 		local dmesg_marker=""
-		echo Running test $test_name $dev
-	fi
-
-	# Do we have to exclude the test ?
-	echo $TEST_EXCLUDE | grep -w "$test_name" > /dev/null 2>&1
-	if [ $? -eq 0 ]; then
-		echo "Test skipped by user" | tee ${test_name}.skipped
-		SKIPPED="$SKIPPED <$test_string>"
-		return
+		printf "%-${TESTNAME_WIDTH}s" "$test_name $dev"
 	fi
 
 	# Prepare log file name
@@ -96,35 +146,36 @@ run_test()
 		local logfile=${test_name}
 	fi
 
+	# Do we have to exclude the test ?
+	echo $TEST_EXCLUDE | grep -w "$test_name" > /dev/null 2>&1
+	if [ $? -eq 0 ]; then
+		test_skipped "${logfile}" "$test_string" "by user"
+		return
+	fi
+
 	# Run the test
 	timeout --preserve-status -s INT -k $TIMEOUT $TIMEOUT \
-		./$test_name $dev 2>&1 | tee ${logfile}.log
+		./$test_name $dev > ${logfile}.log 2>&1
 	local status=${PIPESTATUS[0]}
 
 	# Check test status
 	if [ "$status" -eq 124 ]; then
-		echo "Test $test_name timed out (may not be a failure)"
-		mv ${logfile}.log ${logfile}.timeout
+		test_result timeout "${logfile}" "${test_string}"
 	elif [ "$status" -ne 0 ] && [ "$status" -ne 255 ]; then
-		echo "Test $test_name failed with ret $status"
-		FAILED="$FAILED <$test_string>"
-		RET=1
-		mv ${logfile}.log ${logfile}.failed
+		test_result fail "${logfile}" "${test_string}" "status = $status"
 	elif ! _check_dmesg "$dmesg_marker" "$test_name" "$dev"; then
-		echo "Test $test_name failed dmesg check"
-		FAILED="$FAILED <$test_string>"
-		RET=1
-		mv ${logfile}.log ${logfile}.failed
+		test_result fail "${logfile}" "${test_string}" "dmesg check"
 	elif [ "$status" -eq 255 ]; then
-		echo "Test skipped"
-		SKIPPED="$SKIPPED <$test_string>"
-		mv ${logfile}.log ${logfile}.skipped
+		test_result skip "${logfile}" "${test_string}"
 	elif [ -n "$dev" ]; then
 		sleep .1
 		ps aux | grep "\[io_wq_manager\]" > /dev/null
 		if [ $? -eq 0 ]; then
 			MAYBE_FAILED="$MAYBE_FAILED $test_string"
 		fi
+		test_result pass "${logfile}" "${test_string}"
+	else
+		test_result pass "${logfile}" "${test_string}"
 	fi
 
 	# Only leave behing log file with some content in it
-- 
2.26.2

