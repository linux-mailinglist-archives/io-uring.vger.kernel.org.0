Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3299126CB82
	for <lists+io-uring@lfdr.de>; Wed, 16 Sep 2020 22:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgIPU26 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Sep 2020 16:28:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726981AbgIPRYN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Sep 2020 13:24:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600276996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=idfy7Syf4ATJlYyYq2/4nEP2ORzJWyRGssBVYHwWpOI=;
        b=bt4mdDFmeRQFNDRxC8YhmBHVySHTVhDrYIT0u5NR1sKhXqMwg3JnqvmMcPS/t+GXm87FJL
        aMoCdxFaj1EDH1N67976yU9WYJ4bM34taPE1gQ11NqZ7GkW356tlWOlyGGYAxPJUZ0CZfv
        lLe47tFPeTChaPpigBykPjsvDqAQzGU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-o9IeegJIM1-JxV9HfxTM3Q-1; Wed, 16 Sep 2020 13:15:06 -0400
X-MC-Unique: o9IeegJIM1-JxV9HfxTM3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DD7018C5233;
        Wed, 16 Sep 2020 17:14:56 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-13-242.pek2.redhat.com [10.72.13.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5370E60BFA;
        Wed, 16 Sep 2020 17:14:55 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 3/3] generic: IO_URING direct IO fsx test
Date:   Thu, 17 Sep 2020 01:14:43 +0800
Message-Id: <20200916171443.29546-4-zlang@redhat.com>
In-Reply-To: <20200916171443.29546-1-zlang@redhat.com>
References: <20200916171443.29546-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After fsx supports IO_URING read/write, add IO_URING direct IO fsx
test with different read/write size and concurrent buffered IO.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 tests/generic/610     | 52 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/610.out |  7 ++++++
 tests/generic/group   |  1 +
 3 files changed, 60 insertions(+)
 create mode 100755 tests/generic/610
 create mode 100644 tests/generic/610.out

diff --git a/tests/generic/610 b/tests/generic/610
new file mode 100755
index 00000000..fc3f4c2a
--- /dev/null
+++ b/tests/generic/610
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 YOUR NAME HERE.  All Rights Reserved.
+#
+# FS QA Test 610
+#
+# IO_URING direct IO fsx test
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_odirect
+_require_io_uring
+
+psize=`$here/src/feature -s`
+bsize=`_min_dio_alignment $TEST_DEV`
+run_fsx -S 0 -U -N 20000           -l 600000 -r PSIZE -w BSIZE -Z -R -W
+run_fsx -S 0 -U -N 20000 -o 8192   -l 600000 -r PSIZE -w BSIZE -Z -R -W
+run_fsx -S 0 -U -N 20000 -o 128000 -l 600000 -r PSIZE -w BSIZE -Z -R -W
+
+# change readbdy/writebdy to double page size
+psize=$((psize * 2))
+run_fsx -S 0 -U -N 20000           -l 600000 -r PSIZE -w PSIZE -Z -R -W
+run_fsx -S 0 -U -N 20000 -o 256000 -l 600000 -r PSIZE -w PSIZE -Z -R -W
+run_fsx -S 0 -U -N 20000 -o 128000 -l 600000 -r PSIZE -w BSIZE -Z -W
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/610.out b/tests/generic/610.out
new file mode 100644
index 00000000..97ad41a3
--- /dev/null
+++ b/tests/generic/610.out
@@ -0,0 +1,7 @@
+QA output created by 610
+fsx -S 0 -U -N 20000 -l 600000 -r PSIZE -w BSIZE -Z -R -W
+fsx -S 0 -U -N 20000 -o 8192 -l 600000 -r PSIZE -w BSIZE -Z -R -W
+fsx -S 0 -U -N 20000 -o 128000 -l 600000 -r PSIZE -w BSIZE -Z -R -W
+fsx -S 0 -U -N 20000 -l 600000 -r PSIZE -w PSIZE -Z -R -W
+fsx -S 0 -U -N 20000 -o 256000 -l 600000 -r PSIZE -w PSIZE -Z -R -W
+fsx -S 0 -U -N 20000 -o 128000 -l 600000 -r PSIZE -w BSIZE -Z -W
diff --git a/tests/generic/group b/tests/generic/group
index cf50f4a1..60280dc2 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -612,3 +612,4 @@
 607 auto attr quick dax
 608 auto attr quick dax
 609 auto rw io_uring
+610 auto rw io_uring
-- 
2.20.1

