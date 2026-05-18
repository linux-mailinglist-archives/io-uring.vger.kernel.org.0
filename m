Return-Path: <io-uring+bounces-13414-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IHa2Jo40C2qgEgUAu9opvQ
	(envelope-from <io-uring+bounces-13414-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:47:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5EA570458
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E1E7E30C7C58
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 15:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9519848165B;
	Mon, 18 May 2026 15:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="XqvpnDc5"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2CF481231;
	Mon, 18 May 2026 15:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779118601; cv=none; b=EOl2NizUbfYApC2/MWv4R6mQC9OUDxtl8dl+bJubH8atTb9dpVPaQwBXt2DShMkVsqppwglmyFLMRqGY+hR5zHPeJHGws2F177dMd3Q+8WIJbOrOm3NuDVwmWSqb/pRt/BVcx5g7mHcwHAqCcVbuu/LAzlbLrNepRP7yXKSkQbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779118601; c=relaxed/simple;
	bh=l707VBbrCSJyGC+nnuNzjTQMnzp+k7ZUIis8WkSHD8g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LT7eoWDkfWLN5ZAKMmgJnM1RTh/SYJ7HF0hgfR7SOfbpheI5KmEF4W0MSFWT+bcHD01au8j8Ljq1d67H+psQGW/gyLutcsGGf8d9eBR9M3FWyK2AylG7Ky84RHJ2G/SaSoI5WY1yr9Hcw3mFup8cUqkwwTWDfvTN6CsKUYlV5TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=XqvpnDc5; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64I3stsp388165;
	Mon, 18 May 2026 08:36:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=UQDbSj0a7z4WLbieDvJ38kqU5oMrF5F2mxE5NnAVQwI=; b=XqvpnDc5NpSF
	9AxkQtI6412YZnzWB70P/WAuV5uJCg1+KJ6OpNBsB36K6SUy8K6FMgisJG/+H5dU
	75z/CggPNy2VtGSdDElAnOxXZ3NzvocrhRcfU8xsZceU9+p8xR24duzKyCYE48+a
	p/cDaGX9LNM+4Z54+GuevWkRUSVNVE7E7mrf8sRVzprg9m0yyCK1ObtsSaD2zWtj
	IrT3/lthLG1FxuNrZ0Y/OIdbKWiTselmQwgVmLD8Hzx4G45Kc3GYv61FoWYfUeZp
	EmRRKKUKmlcRhfMPY70Fwr0t2fYK4YJ3ba62H5+OIQ4bD4i0Z2PYksHZ4BG4JloN
	uJXmE2nQ4Q==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4e6kw122km-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 18 May 2026 08:36:31 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1c::11) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Mon, 18 May
 2026 15:36:29 +0000
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
Subject: [PATCH v2 5/6] Documentation: networking: document zcrx notifications and statistics
Date: Mon, 18 May 2026 08:35:28 -0700
Message-ID: <20260518153532.2835502-6-cleger@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260518153532.2835502-1-cleger@meta.com>
References: <20260518153532.2835502-1-cleger@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: m9ASsOJN8Cqh3sLRQ9-XZTrCN21y2fVv
X-Authority-Analysis: v=2.4 cv=P/MKQCAu c=1 sm=1 tr=0 ts=6a0b31ff cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=8elwO82fXORLTBIkMd32:22
 a=VabnemYjAAAA:8 a=8Z81dfnnkPiAomAV-AkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDE1MyBTYWx0ZWRfXzV2nDNznSNGu
 rbwILdZhyGwuimyfBtnlzraTn2D38QsgP+lLXH+6GqGz1Vmp2U+YvGNCBa3nlwLv89suoXbqcjE
 OM4wgAcab3gUh0pg6SMIxGJV6bF5oAwdh3BokpIdRAXNrW06Zu9tlskM7pYomFGqSz5FtyJrAPm
 oVkhurKlVK1Cg6rMS2Ra4okQwPzBmsl+QtVrZkovjHVCMT14IJJdTqnSEcH0mWqyCJfDEtXHQWl
 +HtKJS6BCmlvK1V1YaaYbgZDna+77OeC+Mg0JcgOYvae7RuuWCsYA3VVqIiW17VqOYRj6lwSher
 m1GFXcscX6mnuoAJ/VIxiZhe6zO+DtYCaSUXiTx+PjOkjjFZy7BflEHRPEL4x4wWchBBVVwIvDM
 hkF4ZDM8kSzWXjrWPkb2/6SxOXwOhTCjGS5WS9IB/GMT1q/Vd1CEndj7b1kV67Tx43ndZCUUi/Q
 GcfszY8dEMtE6WwMrOA==
X-Proofpoint-GUID: m9ASsOJN8Cqh3sLRQ9-XZTrCN21y2fVv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-18_03,2026-05-18_01,2025-10-01_01
X-Spamd-Result: default: False [1.05 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.71)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13414-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[meta.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,meta.com:mid,meta.com:dkim,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 5D5EA570458
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
 Documentation/networking/iou-zcrx.rst | 121 ++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/Documentation/networking/iou-zcrx.rst b/Documentation/networking/iou-zcrx.rst
index 7f3f4b2e6cf2..442760a1ca03 100644
--- a/Documentation/networking/iou-zcrx.rst
+++ b/Documentation/networking/iou-zcrx.rst
@@ -196,6 +196,127 @@ Return buffers back to the kernel to be used again::
   rqe->len = cqe->res;
   IO_URING_WRITE_ONCE(*refill_ring.ktail, ++refill_ring.rq_tail);
 
+Notifications
+-------------
+
+When zero-copy receive encounters conditions that impact performance or
+functionality, the kernel can notify userspace via dedicated CQE notifications.
+The application must register a notification descriptor during
+``IORING_REGISTER_ZCRX_IFQ`` to receive them. Notifications are sent
+individually and are not batched with other CQEs. Each notification CQE reports
+a single notification in ``cqe->res``.
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
+      .notif_type = ZCRX_NOTIF_NO_BUFFERS,
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
+to fit both the refill ring and the stats structure::
+
+  struct io_uring_query_zcrx_notif notif_query = {};
+  struct io_uring_query_hdr hdr = {
+    .query_op = IO_URING_QUERY_ZCRX_NOTIF,
+    .size = sizeof(notif_query),
+    .query_data = (__u64)(unsigned long)&notif_query,
+  };
+
+  io_uring_register(ring_fd, IORING_REGISTER_QUERY, &hdr, 1);
+
+  __u32 notif_stats_size = notif_query.notif_stats_size;
+  __u32 notif_stats_off_alignment = notif_query.notif_stats_off_alignment;
+
+To enable statistics, place the stats structure after the refill ring entries
+within the same mapped region, and set the ``ZCRX_NOTIF_DESC_FLAG_STATS`` flag
+in the notification descriptor::
+
+  /* Compute offset for the stats struct (after refill ring entries) */
+  size_t stats_offset = ALIGN_UP(ring_size, notif_stats_off_alignment);
+  ring_size = stats_offset + notif_stats_size;
+  ring_size = ALIGN_UP(ring_size, PAGE_SIZE);
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
2.53.0-Meta


