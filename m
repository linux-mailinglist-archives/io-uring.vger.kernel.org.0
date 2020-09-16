Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A9C26C4CE
	for <lists+io-uring@lfdr.de>; Wed, 16 Sep 2020 18:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgIPQA4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Sep 2020 12:00:56 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50932 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726377AbgIPP41 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Sep 2020 11:56:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600271779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=idfy7Syf4ATJlYyYq2/4nEP2ORzJWyRGssBVYHwWpOI=;
        b=fWBJXbyxNeLnrA+RVUopArMLmXEyg1OPx/wwEUnJLqrUCMi5wZ86odeRPDT5q0+Q2Oe/Wt
        Q2X27l+90Unr3V5HYEWU3F4KNVhi8VYKe8cKuUFaphsLMxbbZ1kWA00TwMhIdWwk3SkLbe
        XGiHeTOs+IhoPQ3ZV+f/0Ax/bHWFaP8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-HoTBlWikOXKh5LV0qne60Q-1; Wed, 16 Sep 2020 08:30:25 -0400
X-MC-Unique: HoTBlWikOXKh5LV0qne60Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B2A9100A971;
        Wed, 16 Sep 2020 12:30:20 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-13-242.pek2.redhat.com [10.72.13.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B49D368D77;
        Wed, 16 Sep 2020 12:30:18 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 3/3] generic: IO_URING direct IO fsx test
Date:   Wed, 16 Sep 2020 20:30:05 +0800
Message-Id: <20200916123005.2139-4-zlang@redhat.com>
In-Reply-To: <20200916123005.2139-1-zlang@redhat.com>
References: <20200916123005.2139-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

