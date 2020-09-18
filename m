Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E5E26FAFC
	for <lists+io-uring@lfdr.de>; Fri, 18 Sep 2020 12:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIRKyF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Sep 2020 06:54:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40894 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbgIRKyE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Sep 2020 06:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600426443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UYupzTuEkQ/dt9Bvjmzv+cHhmitPGghOvz9Lgv1ccKQ=;
        b=fxz6JouYQosJjt9BYiniNFFhxMafnfAlmZQ4BVmFYxGXrGg72MISDM06gbkSVaQCPAEmvq
        yujmjgjOl1NIIsfpTwUcr4b4X2Glw0D99r6N31J/m5KpR9ThHTuycdZmV5gnJdudQ2MdEt
        A+FfN4zhWH6Gxa5R0++FMGaXF3FF/TU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-ERgssKDPN5u9KVDGySXp0A-1; Fri, 18 Sep 2020 06:47:52 -0400
X-MC-Unique: ERgssKDPN5u9KVDGySXp0A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 019A984E246
        for <io-uring@vger.kernel.org>; Fri, 18 Sep 2020 10:47:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 706493782
        for <io-uring@vger.kernel.org>; Fri, 18 Sep 2020 10:47:51 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH 5/5] test: handle the case when timeout is forced to KILL
Date:   Fri, 18 Sep 2020 12:47:46 +0200
Message-Id: <20200918104746.146747-5-lczerner@redhat.com>
In-Reply-To: <20200918104746.146747-1-lczerner@redhat.com>
References: <20200918104746.146747-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Timeout is used to INTerrupt the test if it is still running after
pre-defined time. If the process does not terminate KILL signal is sent
after a pre-defined time, but the return status is different in that
case (128+9).
Catch it and treat is as test failure with the message that the
process was killed.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 test/runtests.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/test/runtests.sh b/test/runtests.sh
index ed28ec8..b210013 100755
--- a/test/runtests.sh
+++ b/test/runtests.sh
@@ -161,6 +161,8 @@ run_test()
 	# Check test status
 	if [ "$status" -eq 124 ]; then
 		test_result timeout "${logfile}" "${test_string}"
+	elif [ "$status" -eq 137 ]; then
+		test_failed "${logfile}" "${test_string}" "process Killed"
 	elif [ "$status" -ne 0 ] && [ "$status" -ne 255 ]; then
 		test_result fail "${logfile}" "${test_string}" "status = $status"
 	elif ! _check_dmesg "$dmesg_marker" "$test_name" "$dev"; then
-- 
2.26.2

