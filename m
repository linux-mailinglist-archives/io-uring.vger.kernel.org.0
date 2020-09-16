Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C02126CD53
	for <lists+io-uring@lfdr.de>; Wed, 16 Sep 2020 22:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgIPU6H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Sep 2020 16:58:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726357AbgIPQwV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Sep 2020 12:52:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600275084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QS+wO1bOb/MZuessqndV980gLlA0r3NSlKNgcyqbDF8=;
        b=Nj7nvcnSG02biRrNSAW8U5uPCIV/mZ3VGW5PkyXfsYfsCqotlKwP7ePon/2GS7ojVSkYTl
        oeoKGtzS7oo9gNqpLkFCEzDqMfKbT/WLqV6Pf3kLBP3Q0t/SHnAz1N54y+bJhXtK0J4B8Y
        Z/R/RvjAGP30WLxSeSgWmOJtFqpi10U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-fIqzzWSuPbaV0gnv8ucXqQ-1; Wed, 16 Sep 2020 08:30:18 -0400
X-MC-Unique: fIqzzWSuPbaV0gnv8ucXqQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 407BCEDA6C;
        Wed, 16 Sep 2020 12:30:17 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-13-242.pek2.redhat.com [10.72.13.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9972068D77;
        Wed, 16 Sep 2020 12:30:15 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 2/3] generic: fsx IO_URING soak tests
Date:   Wed, 16 Sep 2020 20:30:04 +0800
Message-Id: <20200916123005.2139-3-zlang@redhat.com>
In-Reply-To: <20200916123005.2139-1-zlang@redhat.com>
References: <20200916123005.2139-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After fsx supports IO_URING read/write, add a test to do IO_URING
soak test of fsx.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 common/rc             | 16 ++++++++++++
 tests/generic/609     | 58 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/609.out |  2 ++
 tests/generic/group   |  1 +
 4 files changed, 77 insertions(+)
 create mode 100755 tests/generic/609
 create mode 100644 tests/generic/609.out

diff --git a/common/rc b/common/rc
index aa5a7409..b6b39eba 100644
--- a/common/rc
+++ b/common/rc
@@ -1984,6 +1984,22 @@ _require_aiodio()
     _require_odirect
 }
 
+# this test requires that the kernel supports IO_URING
+_require_io_uring()
+{
+	$here/src/feature -R
+	case $? in
+	0)
+		;;
+	1)
+		_notrun "kernel does not support IO_URING"
+		;;
+	*)
+		_fail "unexpected error testing for IO_URING support"
+		;;
+	esac
+}
+
 # this test requires that a test program exists under src/
 # $1 - command (require)
 #
diff --git a/tests/generic/609 b/tests/generic/609
new file mode 100755
index 00000000..1d9b6fed
--- /dev/null
+++ b/tests/generic/609
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat Inc.  All Rights Reserved.
+#
+# FS QA Test 609
+#
+# IO_URING soak buffered fsx test
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
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_io_uring
+
+# Run fsx for a million ops or more
+nr_ops=$((100000 * TIME_FACTOR))
+op_sz=$((128000 * LOAD_FACTOR))
+file_sz=$((600000 * LOAD_FACTOR))
+fsx_file=$TEST_DIR/fsx.$seq
+
+fsx_args=(-S 0)
+fsx_args+=(-U)
+fsx_args+=(-q)
+fsx_args+=(-N $nr_ops)
+fsx_args+=(-p $((nr_ops / 100)))
+fsx_args+=(-o $op_sz)
+fsx_args+=(-l $file_sz)
+
+run_fsx "${fsx_args[@]}" | sed -e '/^fsx.*/d'
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/609.out b/tests/generic/609.out
new file mode 100644
index 00000000..0d75b384
--- /dev/null
+++ b/tests/generic/609.out
@@ -0,0 +1,2 @@
+QA output created by 609
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index aa969bcb..cf50f4a1 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -611,3 +611,4 @@
 606 auto attr quick dax
 607 auto attr quick dax
 608 auto attr quick dax
+609 auto rw io_uring
-- 
2.20.1

