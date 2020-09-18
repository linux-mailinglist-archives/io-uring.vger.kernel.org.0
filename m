Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8434726FAE5
	for <lists+io-uring@lfdr.de>; Fri, 18 Sep 2020 12:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgIRKsF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Sep 2020 06:48:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726326AbgIRKry (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Sep 2020 06:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600426073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zJkJQ8/wZz7pwHTu0MlEjkmXCnuGaZTOlRFgcDcRcHo=;
        b=YryxDfRpyn10KZ8FmjGJWzbwkEWhHntpYeYUEhM6qYJL/7DTZkNczMtJtYXDkIzYR2TUvp
        Cq4NOsUgSJ6VzfC2Lpj2nakd6dOwcdCLaIxzVYy9RziZWCbmiXXiFSPnnIfGDfmyrAGcvN
        wI5N+LLXiO8BB6aj6xH2JkpuvzGr7hk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-Wxw5FRYEOh693exJVSCZ-Q-1; Fri, 18 Sep 2020 06:47:51 -0400
X-MC-Unique: Wxw5FRYEOh693exJVSCZ-Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B7F510074BF
        for <io-uring@vger.kernel.org>; Fri, 18 Sep 2020 10:47:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB25E3782
        for <io-uring@vger.kernel.org>; Fri, 18 Sep 2020 10:47:49 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH 3/5] test: store test output to a log file
Date:   Fri, 18 Sep 2020 12:47:44 +0200
Message-Id: <20200918104746.146747-3-lczerner@redhat.com>
In-Reply-To: <20200918104746.146747-1-lczerner@redhat.com>
References: <20200918104746.146747-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Store test output to a log file for further inspection. Depending on
the test result the log file name for the test will be one of the
following ${test_name}.{log,timeout,failed,skipped}

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 .gitignore       |  4 ++++
 test/runtests.sh | 27 ++++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/.gitignore b/.gitignore
index 8f7f369..9e7865b 100644
--- a/.gitignore
+++ b/.gitignore
@@ -107,6 +107,10 @@
 /test/timeout-overflow
 /test/wakeup-hang
 /test/*.dmesg
+/test/*.log
+/test/*.failed
+/test/*.skipped
+/test/*.timeout
 
 config-host.h
 config-host.mak
diff --git a/test/runtests.sh b/test/runtests.sh
index acefe33..b61cb27 100755
--- a/test/runtests.sh
+++ b/test/runtests.sh
@@ -83,29 +83,42 @@ run_test()
 	# Do we have to exclude the test ?
 	echo $TEST_EXCLUDE | grep -w "$test_name" > /dev/null 2>&1
 	if [ $? -eq 0 ]; then
-		echo "Test skipped"
+		echo "Test skipped by user" | tee ${test_name}.skipped
 		SKIPPED="$SKIPPED <$test_string>"
 		return
 	fi
 
+	# Prepare log file name
+	if [ -n "$dev" ]; then
+		local logfile=$(echo "${test_name}_${dev}" | \
+			    sed 's/\(\/\|_\/\|\/_\)/_/g')
+	else
+		local logfile=${test_name}
+	fi
+
 	# Run the test
-	timeout --preserve-status -s INT -k $TIMEOUT $TIMEOUT ./$test_name $dev
-	local status=$?
+	timeout --preserve-status -s INT -k $TIMEOUT $TIMEOUT \
+		./$test_name $dev 2>&1 | tee ${logfile}.log
+	local status=${PIPESTATUS[0]}
 
 	# Check test status
 	if [ "$status" -eq 124 ]; then
 		echo "Test $test_name timed out (may not be a failure)"
+		mv ${logfile}.log ${logfile}.timeout
 	elif [ "$status" -ne 0 ] && [ "$status" -ne 255 ]; then
 		echo "Test $test_name failed with ret $status"
 		FAILED="$FAILED <$test_string>"
 		RET=1
+		mv ${logfile}.log ${logfile}.failed
 	elif ! _check_dmesg "$dmesg_marker" "$test_name" "$dev"; then
 		echo "Test $test_name failed dmesg check"
 		FAILED="$FAILED <$test_string>"
 		RET=1
+		mv ${logfile}.log ${logfile}.failed
 	elif [ "$status" -eq 255 ]; then
 		echo "Test skipped"
 		SKIPPED="$SKIPPED <$test_string>"
+		mv ${logfile}.log ${logfile}.skipped
 	elif [ -n "$dev" ]; then
 		sleep .1
 		ps aux | grep "\[io_wq_manager\]" > /dev/null
@@ -113,8 +126,16 @@ run_test()
 			MAYBE_FAILED="$MAYBE_FAILED $test_string"
 		fi
 	fi
+
+	# Only leave behing log file with some content in it
+	if [ ! -s "${logfile}.log" ]; then
+		rm -f ${logfile}.log
+	fi
 }
 
+# Clean up all the logs from previous run
+rm -f *.{log,timeout,failed,skipped,dmesg}
+
 # Run all specified tests
 for tst in $TESTS; do
 	run_test $tst
-- 
2.26.2

