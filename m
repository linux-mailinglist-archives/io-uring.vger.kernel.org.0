Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434F926FADC
	for <lists+io-uring@lfdr.de>; Fri, 18 Sep 2020 12:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgIRKry (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Sep 2020 06:47:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32071 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726314AbgIRKrw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Sep 2020 06:47:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600426070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MIdL9mIHVMZL8rPsmABCtXHHKC/xdsfHOuSoekDY/5E=;
        b=jMk9KJBqj+J6hKuK2CVb9B/yPosjxvW59VV2vunzQCiXVdGHoSCjuwv7ENyVnIwrSRf0P0
        +t7Sp02wNzpol2AZ1HyZJRytCDXFg7SUvccuunbv+eyax7dmwiBf350LJUm97AUeyTDo9J
        fK2MAyHgaK5H6fqWkr48K6INePOcVj8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-V-VQT4s0Nr6wNUVIvBefoQ-1; Fri, 18 Sep 2020 06:47:49 -0400
X-MC-Unique: V-VQT4s0Nr6wNUVIvBefoQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44D7D81CAFB
        for <io-uring@vger.kernel.org>; Fri, 18 Sep 2020 10:47:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2D1C3782
        for <io-uring@vger.kernel.org>; Fri, 18 Sep 2020 10:47:47 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH 1/5] test: save dmesg output for each test and test file
Date:   Fri, 18 Sep 2020 12:47:42 +0200
Message-Id: <20200918104746.146747-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently the dmesg output for each test will overwritten for every
test file so in the end only the dmesg output of the last test run will
be stored.

Fix it by using the test file name as well as test name in the dmesg log
file.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 test/runtests.sh | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/test/runtests.sh b/test/runtests.sh
index fa240f2..5107a0a 100755
--- a/test/runtests.sh
+++ b/test/runtests.sh
@@ -28,13 +28,18 @@ fi
 _check_dmesg()
 {
 	local dmesg_marker="$1"
-	local seqres="$2.seqres"
+	if [ -n "$3" ]; then
+		local dmesg_log=$(echo "${2}_${3}.dmesg" | \
+				  sed 's/\(\/\|_\/\|\/_\)/_/g')
+	else
+		local dmesg_log="${2}.dmesg"
+	fi
 
 	if [ $DO_KMSG -eq 0 ]; then
 		return 0
 	fi
 
-	dmesg | bash -c "$DMESG_FILTER" | grep -A 9999 "$dmesg_marker" >"${seqres}.dmesg"
+	dmesg | bash -c "$DMESG_FILTER" | grep -A 9999 "$dmesg_marker" >"$dmesg_log"
 	grep -q -e "kernel BUG at" \
 	     -e "WARNING:" \
 	     -e "BUG:" \
@@ -45,12 +50,12 @@ _check_dmesg()
 	     -e "INFO: possible circular locking dependency detected" \
 	     -e "general protection fault:" \
 	     -e "blktests failure" \
-	     "${seqres}.dmesg"
+	     "$dmesg_log"
 	# shellcheck disable=SC2181
 	if [[ $? -eq 0 ]]; then
 		return 1
 	else
-		rm -f "${seqres}.dmesg"
+		rm -f "$dmesg_log"
 		return 0
 	fi
 }
@@ -94,7 +99,7 @@ run_test()
 		echo "Test $test_name failed with ret $status"
 		FAILED="$FAILED <$test_string>"
 		RET=1
-	elif ! _check_dmesg "$dmesg_marker" "$test_name"; then
+	elif ! _check_dmesg "$dmesg_marker" "$test_name" "$dev"; then
 		echo "Test $test_name failed dmesg check"
 		FAILED="$FAILED <$test_string>"
 		RET=1
-- 
2.26.2

