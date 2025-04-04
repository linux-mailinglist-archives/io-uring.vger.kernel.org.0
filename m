Return-Path: <io-uring+bounces-7385-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AD2CA7B435
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 02:35:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9C4E7A95FD
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 00:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA7F513CA9C;
	Fri,  4 Apr 2025 00:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y/xYUs3X"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAF113BC0C
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 00:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743725954; cv=none; b=AeIuU8S4SwbU4BkRDyOk2P3cJAW/l7z4v1ANB8TBJS4lhhXh61Z0nKvKPzKP9827uq8m216niEZyS2pmbsYUfjlyo7JI31suJ8f45NWh2Cp4oXDUyWZMeAmYbloAgWCGLPJwYw+AEYSLEVboKxuzIbnyZu36NpwuIyvCH7aBvAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743725954; c=relaxed/simple;
	bh=z6dMu/eEgVqVTUgW1qqZ4loC5dlfaiXYKiHF1yu7jg8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RxwaA5urOuqXkqyC9g0emeVMfaCxdanswF/yzxppcCQ8ujqg0Sz7f4adVfACBVxcwcdLbKn7DWh6o/VgMmG+Pi9te/aj+FPMmegOJV/DUeW20+2LLF3tNJkK/Af5GVwF2SzbIJOqsOYpTJzLP6ni9OmWgsXggTqSr9W6K64Fdrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y/xYUs3X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743725951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RVql1DCeypI6m34kdlGpk7A3gYaBbC6Y8RcuEDcjufs=;
	b=Y/xYUs3Xl8bIJUllhq6ZnUQG9XJCT5FKhmuTUJdlNHH4XzCfvsu+8YOlwd1+kji8Ag/nTw
	WTT0qmYv8pQFMsKFZQDq9IhSyySsgEIQcho7cegoJhQ7OzysYva/V7wxjGgHQCdhBO9gUE
	+LCL2gX2OMDgHjK3xg4waepjs/6SUpU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-360-ZxaI2P1MPkCmeyagtBCVrw-1; Thu,
 03 Apr 2025 20:19:07 -0400
X-MC-Unique: ZxaI2P1MPkCmeyagtBCVrw-1
X-Mimecast-MFC-AGG-ID: ZxaI2P1MPkCmeyagtBCVrw_1743725946
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 814C21800258;
	Fri,  4 Apr 2025 00:19:05 +0000 (UTC)
Received: from localhost (unknown [10.72.120.26])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 42DFD1955BC2;
	Fri,  4 Apr 2025 00:19:03 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Uday Shankar <ushankar@purestorage.com>
Subject: [PATCH] selftests: ublk: fix test_stripe_04
Date: Fri,  4 Apr 2025 08:18:49 +0800
Message-ID: <20250404001849.1443064-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Commit 57ed58c13256 ("selftests: ublk: enable zero copy for stripe target")
added test entry of test_stripe_04, but forgot to add the test script.

So fix the test by adding the script file.

Reported-by: Uday Shankar <ushankar@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 .../testing/selftests/ublk/test_stripe_04.sh  | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100755 tools/testing/selftests/ublk/test_stripe_04.sh

diff --git a/tools/testing/selftests/ublk/test_stripe_04.sh b/tools/testing/selftests/ublk/test_stripe_04.sh
new file mode 100755
index 000000000000..1f2b642381d1
--- /dev/null
+++ b/tools/testing/selftests/ublk/test_stripe_04.sh
@@ -0,0 +1,24 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+. "$(cd "$(dirname "$0")" && pwd)"/test_common.sh
+
+TID="stripe_04"
+ERR_CODE=0
+
+_prep_test "stripe" "mkfs & mount & umount on zero copy"
+
+backfile_0=$(_create_backfile 256M)
+backfile_1=$(_create_backfile 256M)
+dev_id=$(_add_ublk_dev -t stripe -z -q 2 "$backfile_0" "$backfile_1")
+_check_add_dev $TID $? "$backfile_0" "$backfile_1"
+
+_mkfs_mount_test /dev/ublkb"${dev_id}"
+ERR_CODE=$?
+
+_cleanup_test "stripe"
+
+_remove_backfile "$backfile_0"
+_remove_backfile "$backfile_1"
+
+_show_result $TID $ERR_CODE
-- 
2.47.1


