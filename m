Return-Path: <io-uring+bounces-13117-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +B1cM+Sx6GmIOwIAu9opvQ
	(envelope-from <io-uring+bounces-13117-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:32:52 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 539DE4456A8
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:32:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4DFD1304D5D5
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 11:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5585E3D0927;
	Wed, 22 Apr 2026 11:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Y3FHiGy5"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEA53D090B;
	Wed, 22 Apr 2026 11:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776857400; cv=none; b=gLMc7l09/Vi9oalpoH2sPW9Fsa6uqiyCywETuYznxF5PZXQAlb+TBWrTZVMics9biHBQ7s3F17NnJxnxPnjgRBIFeTWMWTiqUVUgY0TM1OaI3NKscdCt+X/8Ox0MDjmgusBIHZDS1njxa+9A+ipnLjZXegJEh6qDEM73VMtIL6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776857400; c=relaxed/simple;
	bh=GimcXQ5Vr7CVHkQ95G4KcAipFyJMm6dpkfIxF3FoFeo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pcclBv/HAVmHMVUYMYdurZFJLXwEEGH/9Kj9WSX/c4dSjeUXPUjFIsfRkpLksaPpFgKS0Ntw9Kl/wubo1t0esG5Vy1xwRE35YGKg+EBdmztvSJg/wDmhAIlYB3PnTL9/1C6DvBRtF7Q/HKPXiQaSy/z9s8Z6hCfBfK0ChRuDkq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Y3FHiGy5; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63MAsJdR2107212;
	Wed, 22 Apr 2026 04:29:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=+1dg+cv4+2vyQ5Kuqxeb+I3OzBBIDzcSrfPOrCeqLDU=; b=Y3FHiGy5Sd9v
	/iOTQC0BFMT2bAtMyxMXaexQGEhKcM2oO/hQkq4zXL2LQsB+IYUdNJftJgFLErM0
	S3N9fVi6FSAgdBp7NJg8y2LCUzqz0M3sfKpryG2+y2eH+c9v8d0aGMEZfWQK8eW2
	wOU+Okk7FuOlHAsemHpYcZzxI1cCGp12iMhjbBXpqq79fsbT+Y8KXDaTuYk3lITv
	chOp2Eak70xNKe8OtLFY1khngdIPZo/Ir6AeGXz1Ec0F78GHAu3cguhzAArQ456O
	QG/EWwuUtdaFnxdAJSIVm92rlAfMXHL/JstqnW4RYd5NaDMo5ChgtRTPCjqFP/xe
	ovfrcGwWEg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4dpepgvmmf-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 22 Apr 2026 04:29:50 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Wed, 22 Apr
 2026 11:29:35 +0000
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
Subject: [PATCH 3/5] io_uring/zcrx: add shared-memory notification statistics
Date: Wed, 22 Apr 2026 04:25:14 -0700
Message-ID: <20260422112522.3316660-4-cleger@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDExMCBTYWx0ZWRfXx6qk8u92gex7
 iVrQBfaC1TY62gDMMFA7kgOubJmwrzcQxbjWz+nQPpiVGf7/hBgInTr158z1WLjquvfVfNYNpQ+
 AHl7t9lRSnglmiUaRhAkBWaeW0T5Igf/2WZqTJepFxnFKSCdQEzD0QkY23ki1mTA/iNogvMhQZW
 GZKDbmnbl63jl652XGeLk2jsHr8+LSHUaeA6OlpGuWXh47jhpaniPhBaQmfSXOK6O9Li71Lv/bn
 Sy3xszo9yrvYPVjYO28dGXqhai3enD29K+uGAKHtDoYVZW5Dg29eZ/rffEHUXWxQyAvvt+5I3Up
 qe05QnjKbP3bN61S1UrbD/nNOZ0wozglbPoy0hO5KAs5KpBNAPde4uj6S0j4bxFgcrgXzbFb7jf
 iH6yAiaLrf/TN9NLlN9VtvirjhHzxAqUPvyeihbWxS9R9BByTscwHhCndE0VMYqSRj3Xm44CSK8
 HrBCogqw3t7siWw8jpA==
X-Proofpoint-GUID: 9m11s-4Q0WIabXoPclC7bbh7V70kZMkH
X-Proofpoint-ORIG-GUID: 9m11s-4Q0WIabXoPclC7bbh7V70kZMkH
X-Authority-Analysis: v=2.4 cv=B8SJFutM c=1 sm=1 tr=0 ts=69e8b12e cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=8elwO82fXORLTBIkMd32:22
 a=VabnemYjAAAA:8 a=tUABAHM7GXuONXiLVFsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13117-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,meta.com:dkim,meta.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 539DE4456A8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add support for an optional stats struct embedded in the refill queue
region, allowing userspace to monitor copy-fallback and no-buffers events
in real-time.

Userspace queries the stats struct size and alignment via
IO_URING_QUERY_ZCRX (notif_stats_size / notif_stats_alignment), then
provides a stats_offset in zcrx_notification_desc pointing to a location
within the refill queue region.

The kernel updates the stats counters in-place using atomic ops on every
copy-fallback and no-buffers event.

Signed-off-by: Clément Léger <cleger@meta.com>
---
 include/uapi/linux/io_uring/query.h | 12 +++++++
 include/uapi/linux/io_uring/zcrx.h  | 15 +++++++--
 io_uring/query.c                    | 14 ++++++++
 io_uring/zcrx.c                     | 50 +++++++++++++++++++++++++++--
 io_uring/zcrx.h                     |  1 +
 5 files changed, 88 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/io_uring/query.h b/include/uapi/linux/io_uring/query.h
index 95500759cc13..738c35c7d05c 100644
--- a/include/uapi/linux/io_uring/query.h
+++ b/include/uapi/linux/io_uring/query.h
@@ -23,6 +23,7 @@ enum {
 	IO_URING_QUERY_OPCODES			= 0,
 	IO_URING_QUERY_ZCRX			= 1,
 	IO_URING_QUERY_SCQ			= 2,
+	IO_URING_QUERY_ZCRX_NOTIF		= 3,
 
 	__IO_URING_QUERY_MAX,
 };
@@ -62,6 +63,17 @@ struct io_uring_query_zcrx {
 	__u64 __resv2;
 };
 
+struct io_uring_query_zcrx_notif {
+	/* Bitmask of supported ZCRX_NOTIF_* flags*/
+	__u32 notif_flags;
+	/* Size of io_uring_zcrx_notif_stats */
+	__u32 notif_stats_size;
+	/* Required alignment for the stats struct within the region (ie stats_offset) */
+	__u32 notif_stats_off_alignment;
+	__u32 resv1;
+	__u64 __resv2[10];
+};
+
 struct io_uring_query_scq {
 	/* The SQ/CQ rings header size */
 	__u64 hdr_size;
diff --git a/include/uapi/linux/io_uring/zcrx.h b/include/uapi/linux/io_uring/zcrx.h
index e0c0079626c8..ae9bbca3004c 100644
--- a/include/uapi/linux/io_uring/zcrx.h
+++ b/include/uapi/linux/io_uring/zcrx.h
@@ -73,11 +73,22 @@ enum zcrx_notification_type {
 	ZCRX_NOTIF_COPY = 1 << 1
 };
 
+enum zcrx_notification_desc_flags {
+	/* If set, stats_offset holds a valid offset to a notif_stats struct */
+	ZCRX_NOTIF_DESC_FLAG_STATS = 1 << 0,
+};
+
+struct io_uring_zcrx_notif_stats {
+	__u64	copy_count;	/* cumulative copy-fallback CQEs */
+	__u64	copy_bytes;	/* cumulative bytes copied */
+};
+
 struct zcrx_notification_desc {
 	__u64	user_data;
 	__u32	type_mask;
-	__u32	__resv1;
-	__u64	__resv2[10];
+	__u32	flags; /* see enum zcrx_notification_desc_flags */
+	__u64	stats_offset; /* offset from the beginning of refill ring region for stats */
+	__u64	__resv2[9];
 };
 
 /*
diff --git a/io_uring/query.c b/io_uring/query.c
index c1704d088374..3591106e139d 100644
--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -9,6 +9,7 @@
 union io_query_data {
 	struct io_uring_query_opcode opcodes;
 	struct io_uring_query_zcrx zcrx;
+	struct io_uring_query_zcrx_notif zcrx_notif;
 	struct io_uring_query_scq scq;
 };
 
@@ -44,6 +45,16 @@ static ssize_t io_query_zcrx(union io_query_data *data)
 	return sizeof(*e);
 }
 
+static ssize_t io_query_zcrx_notif(union io_query_data *data)
+{
+	struct io_uring_query_zcrx_notif *e = &data->zcrx_notif;
+
+	e->notif_flags = ZCRX_NOTIF_TYPE_MASK;
+	e->notif_stats_size = sizeof(struct io_uring_zcrx_notif_stats);
+	e->notif_stats_off_alignment = __alignof__(struct io_uring_zcrx_notif_stats);
+	return sizeof(*e);
+}
+
 static ssize_t io_query_scq(union io_query_data *data)
 {
 	struct io_uring_query_scq *e = &data->scq;
@@ -83,6 +94,9 @@ static int io_handle_query_entry(union io_query_data *data, void __user *uhdr,
 	case IO_URING_QUERY_ZCRX:
 		ret = io_query_zcrx(data);
 		break;
+	case IO_URING_QUERY_ZCRX_NOTIF:
+		ret = io_query_zcrx_notif(data);
+		break;
 	case IO_URING_QUERY_SCQ:
 		ret = io_query_scq(data);
 		break;
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 732e585aa13a..c61f94fb14c3 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -414,6 +414,7 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 	io_free_region(ifq->user, &ifq->rq_region);
 	ifq->rq.ring = NULL;
 	ifq->rq.rqes = NULL;
+	ifq->notif_stats = NULL;
 }
 
 static void io_zcrx_free_area(struct io_zcrx_ifq *ifq,
@@ -841,6 +842,33 @@ static int zcrx_register_netdev(struct io_zcrx_ifq *ifq,
 	return ret;
 }
 
+static int zcrx_validate_notif_stats(struct io_zcrx_ifq *ifq,
+				     const struct io_uring_zcrx_ifq_reg *reg,
+				     const struct zcrx_notification_desc *notif)
+{
+	size_t stats_off = notif->stats_offset;
+	size_t used, end;
+
+	used = reg->offsets.rqes +
+	       sizeof(struct io_uring_zcrx_rqe) * reg->rq_entries;
+
+	if (!IS_ALIGNED(stats_off, __alignof__(struct io_uring_zcrx_notif_stats)))
+		return -EINVAL;
+	if (stats_off < used)
+		return -ERANGE;
+	if (check_add_overflow(stats_off,
+			       sizeof(struct io_uring_zcrx_notif_stats),
+			       &end))
+		return -ERANGE;
+	if (end > io_region_size(&ifq->rq_region))
+		return -ERANGE;
+
+	ifq->notif_stats = io_region_get_ptr(&ifq->rq_region) + stats_off;
+	memset(ifq->notif_stats, 0, sizeof(*ifq->notif_stats));
+
+	return 0;
+}
+
 int io_register_zcrx(struct io_ring_ctx *ctx,
 		     struct io_uring_zcrx_ifq_reg __user *arg)
 {
@@ -894,7 +922,9 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
 		return -EFAULT;
 	if (notif.type_mask & ~ZCRX_NOTIF_TYPE_MASK)
 		return -EINVAL;
-	if (notif.__resv1 || !mem_is_zero(&notif.__resv2, sizeof(notif.__resv2)))
+	if (notif.flags & ~ZCRX_NOTIF_DESC_FLAG_STATS)
+		return -EINVAL;
+	if (!mem_is_zero(&notif.__resv2, sizeof(notif.__resv2)))
 		return -EINVAL;
 
 	ifq = io_zcrx_ifq_alloc(ctx);
@@ -925,6 +955,12 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
 	if (ret)
 		goto err;
 
+	if (notif.flags & ZCRX_NOTIF_DESC_FLAG_STATS) {
+		ret = zcrx_validate_notif_stats(ifq, &reg, &notif);
+		if (ret)
+			goto err;
+	}
+
 	ifq->kern_readable = !(area.flags & IORING_ZCRX_AREA_DMABUF);
 
 	if (!(reg.flags & ZCRX_REG_NODEV)) {
@@ -1133,6 +1169,11 @@ static void zcrx_notif_tw(struct io_tw_req tw_req, io_tw_token_t tw)
 	kfree_rcu(req, rcu_head);
 }
 
+static void zcrx_stat_add(__u64 *p, s64 v)
+{
+	WRITE_ONCE(*p, READ_ONCE(*p) + v);
+}
+
 static void zcrx_send_notif(struct io_zcrx_ifq *ifq, u32 type_mask)
 {
 	gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO;
@@ -1513,8 +1554,13 @@ static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 	int ret;
 
 	ret = io_zcrx_copy_chunk(req, ifq, page, off + skb_frag_off(frag), len);
-	if (ret > 0)
+	if (ret > 0) {
+		if (ifq->notif_stats) {
+			zcrx_stat_add(&ifq->notif_stats->copy_count, 1);
+			zcrx_stat_add(&ifq->notif_stats->copy_bytes, ret);
+		}
 		zcrx_send_notif(ifq, ZCRX_NOTIF_COPY);
+	}
 
 	return ret;
 }
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 1bd63adaa711..0dcf486ff530 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -82,6 +82,7 @@ struct io_zcrx_ifq {
 	u32				allowed_notif_mask;
 	u32				fired_notifs;
 	u64				notif_data;
+	struct io_uring_zcrx_notif_stats *notif_stats;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.52.0


