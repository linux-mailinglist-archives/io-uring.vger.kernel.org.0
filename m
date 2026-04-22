Return-Path: <io-uring+bounces-13118-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yPD9Fiey6GmIOwIAu9opvQ
	(envelope-from <io-uring+bounces-13118-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:33:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CA26B4456ED
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:33:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 770CE3069FFC
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 11:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC003D170B;
	Wed, 22 Apr 2026 11:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="sIXq/2qF"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDF53D093B;
	Wed, 22 Apr 2026 11:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776857402; cv=none; b=Y/qaVMrERzOEyIFYA1DJxTCmEMjABiFbJGihLFo+rEW2aMdPdzlK+2wzGdQDCmYTWkTHqECwzK/uyEHP/m9nXKD9/TD8vXXrbXx8WaINXo8amh68QU8xAk7utgEkTYs7iLCnvVnoVjJxLKmJaHorx9x0S3ohuKPgUJC1sPWY1Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776857402; c=relaxed/simple;
	bh=83JslrFf9334MEp6KqDh4ZOAascOu9xrBr4UIjBgfEw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nYI+cnEED0MWP5OfcCAByxWlrFoDDZCb22fLBUa2La6l7lc4jKo6eqO9FTlgqjLDmn/zox4vHRlFNTv6eeWdqOTpExgAQS3AFwr5NYqcB5pNt0eHocUU+xsHY0L8v00Z9Itdult1TX1gAhzjO3iDW3rJnMNn5zlzruTMupNP/Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=sIXq/2qF; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63MAsJdU2107212;
	Wed, 22 Apr 2026 04:29:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=092DUjtk9S7riuWAenbtkpfmunugAPl99EMBelOHirw=; b=sIXq/2qFp0v7
	pGM6pew3fMAhHRNrag/T5eHY9YSO51vmTuM4Qzz2CTz3/+C7ooGSb5wXHUihwjTz
	QDnGQPEo0HV5ZNQJAIg6B31p2XyUa2cy8Utf84sOuJVsLJhTpFfsvHtfeYazxTOF
	OtjLDEjbNMDi7nAD72X60U9OvI9PhJCZSwKfK11vZtc5Igrp1tWJqxnIlBHAdt1M
	nGL+kp1lHVCp3nqI/s9/Kfowf+rZ2nCLnHnvanY7AQFgDoCU5ZU/t+gLf3P/ohFz
	Ejh7k3kF3LYr2GSzyw2g5Q+yh/JR8UHwHTapS15ve80+Yj4+gu7624nukjohhAUT
	F+S6BFkFlQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4dpepgvmmf-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 22 Apr 2026 04:29:51 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1b::30) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Wed, 22 Apr
 2026 11:29:44 +0000
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>
To: <io-uring@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>,
        "Jens
 Axboe" <axboe@kernel.dk>
CC: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        "David S.
 Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Simon Horman
	<horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan
	<skhan@linuxfoundation.org>,
        Vishwanath Seshagiri <vishs@fb.com>
Subject: [PATCH 4/5] Documentation: networking: document zcrx notifications and statistics
Date: Wed, 22 Apr 2026 04:25:15 -0700
Message-ID: <20260422112522.3316660-5-cleger@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260422112522.3316660-1-cleger@meta.com>
References: <20260422112522.3316660-1-cleger@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDExMCBTYWx0ZWRfX+FWo+bobXiwM
 aRbPa1gF05euoviqe6WbFWGell+TWnqk29jHK3NsRsUtBTKQT/EfufsDzcMce+xVmXOJb5k7lhd
 jGgF1MH3Wz+kK/dT0jvGyWYpAHy+Xl8mdxpf9lC2zTMaoQOyorOuwvybcnHbucizDPzwBzV+lXz
 6db9IGWkNApoMAStvSvZph3IhJWJZjDBCl0UgcqF5QFxTQqLUFaNH+M2eqMcMteJ/uuWUwOSmTf
 /l9EmQ9IGQ8XhrWFuc8rRo62gtgHKDD8VVbIE4tO7kbdg3jwNX3UpL2cZ7GzCAJseIsFcrsQsvm
 ADXYwZx02wdUu1Tc6BidZQxsAKzmrZSP6+7QPZR+iNYi44Uy6Nvwyv39T+rXQTf9rd3DutT8yPv
 v2uekyS5HfnuenXKbkaTP9StzaA7lrjB5vm2G6S1y8XuALvdz11brdWVJ/ZBIsQBomH0JPUw0+1
 sNi7STYCCp+o+SBQBxg==
X-Proofpoint-GUID: l_mqzUbBP5GDCXF3nSkDXAkA4t64ClT-
X-Proofpoint-ORIG-GUID: l_mqzUbBP5GDCXF3nSkDXAkA4t64ClT-
X-Authority-Analysis: v=2.4 cv=B8SJFutM c=1 sm=1 tr=0 ts=69e8b12f cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=8elwO82fXORLTBIkMd32:22
 a=VabnemYjAAAA:8 a=8Z81dfnnkPiAomAV-AkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Spamd-Result: default: False [1.11 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.77)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13118-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[meta.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,meta.com:dkim,meta.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CA26B4456ED
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Document the zcrx notification system and shared-memory statistics
that were introduced to let userspace monitor zero-copy receive health.
The notification section covers the two notification types
(ZCRX_NOTIF_NO_BUFFERS, ZCRX_NOTIF_COPY), registration via
zcrx_notification_desc, and the fire-once / re-arm mechanism via
ZCRX_CTRL_ARM_NOTIFICATION. The statistics section covers the optional
shared-memory io_uring_zcrx_notif_stats structure placed in the refill
ring region, including how to query its layout via
IO_URING_QUERY_ZCRX_NOTIF.

Signed-off-by: Clément Léger <cleger@meta.com>
---
 Documentation/networking/iou-zcrx.rst | 106 ++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/Documentation/networking/iou-zcrx.rst b/Documentation/networking/iou-zcrx.rst
index 7f3f4b2e6cf2..b17205fe55aa 100644
--- a/Documentation/networking/iou-zcrx.rst
+++ b/Documentation/networking/iou-zcrx.rst
@@ -196,6 +196,112 @@ Return buffers back to the kernel to be used again::
   rqe->len = cqe->res;
   IO_URING_WRITE_ONCE(*refill_ring.ktail, ++refill_ring.rq_tail);
 
+Notifications
+-------------
+
+When zero-copy receive encounters conditions that affect performance or
+functionality, the kernel can notify userspace via dedicated CQE notifications.
+The application must register a notification descriptor during
+``IORING_REGISTER_ZCRX_IFQ`` to receive them.
+
+Supported features can be detected by checking for ``ZCRX_FEATURE_NOTIFICATION``
+in the features bitmask returned by ``IO_URING_QUERY_ZCRX``.
+
+**Notification types**
+
+``ZCRX_NOTIF_NO_BUFFERS``
+  Fired when the page pool fails to allocate because the zcrx buffer area is
+  exhausted.
+
+``ZCRX_NOTIF_COPY``
+  Fired when a received fragment could not be delivered zero-copy and was
+  instead copied into a buffer.
+
+**Registering notifications**
+
+Allocate and fill a ``struct zcrx_notification_desc``::
+
+  struct zcrx_notification_desc notif = {
+    .user_data = MY_NOTIF_USER_DATA,
+    .type_mask = ZCRX_NOTIF_NO_BUFFERS | ZCRX_NOTIF_COPY,
+  };
+
+  reg.notif_desc = (__u64)(unsigned long)&notif;
+
+``user_data`` is the value that will appear in the notification CQE's
+``user_data`` field. ``type_mask`` selects which notification types the
+application wants to receive.
+
+When a registered event occurs, the kernel posts a CQE with the specified
+``user_data`` and ``cqe->res`` set to a bitmask of the triggered notification
+types.
+
+**Rate limiting**
+
+Each notification type fires once until the application explicitly re-arms it.
+To re-arm, issue ``IORING_REGISTER_ZCRX_CTRL`` with
+``ZCRX_CTRL_ARM_NOTIFICATION``::
+
+  struct zcrx_ctrl ctrl = {
+    .zcrx_id = zcrx_id,
+    .op = ZCRX_CTRL_ARM_NOTIFICATION,
+    .zc_arm_notif = {
+      .type_mask = ZCRX_NOTIF_NO_BUFFERS | ZCRX_NOTIF_COPY,
+    },
+  };
+
+  io_uring_register(ring_fd, IORING_REGISTER_ZCRX_CTRL, &ctrl, 0);
+
+Only notification types that have previously fired can be re-armed.
+
+Notification statistics
+-----------------------
+
+In addition to CQE-based notifications, the kernel can maintain a shared-memory
+statistics structure that is updated on every relevant event. All stats are
+updated regardless of which notification flags were registered.
+
+The statistics structure layout and alignment requirements can be queried via
+``IO_URING_QUERY_ZCRX_NOTIF``. The application must query the structure size
+and alignment requirements so that it allocates enough memory for the region
+to fit both the refill ring and the stats structure.
+
+To enable statistics, place the stats structure after the refill ring entries
+within the same mapped region, and set the ``ZCRX_NOTIF_DESC_FLAG_STATS`` flag
+in the notification descriptor::
+
+  /* Compute offset for the stats struct (after refill ring entries) */
+  size_t stats_offset = ring_size;
+  ring_size += ALIGN_UP(sizeof(struct io_uring_zcrx_notif_stats), PAGE_SIZE);
+
+  /* Map the region with the extra space */
+  ring_ptr = mmap(NULL, ring_size, PROT_READ | PROT_WRITE,
+                  MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+
+  struct zcrx_notification_desc notif = {
+    .user_data = MY_NOTIF_USER_DATA,
+    .type_mask = ZCRX_NOTIF_COPY,
+    .flags = ZCRX_NOTIF_DESC_FLAG_STATS,
+    .stats_offset = stats_offset,
+  };
+
+The ``stats_offset`` must satisfy the alignment reported by
+``notif_stats_off_alignment`` and must point to a location within the mapped
+region that does not overlap with the refill ring header or entries.
+
+Application can read stat counters them at any time::
+
+  volatile struct io_uring_zcrx_notif_stats *stats =
+    (void *)((char *)ring_ptr + stats_offset);
+
+  printf("copy fallbacks: %llu (%llu bytes)\n",
+         IO_URING_READ_ONCE(stats->copy_count),
+	 IO_URING_READ_ONCE(stats->copy_bytes));
+
+``copy_count`` is incremented each time a fragment is copied instead of being
+delivered via zero-copy. ``copy_bytes`` accumulates the total number of bytes
+copied.
+
 Area chunking
 -------------
 
-- 
2.52.0


