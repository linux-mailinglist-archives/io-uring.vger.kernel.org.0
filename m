Return-Path: <io-uring+bounces-13413-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Bu2FAkzC2qgEgUAu9opvQ
	(envelope-from <io-uring+bounces-13413-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:40:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AEF457028A
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8DC12304D34A
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 15:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF04C480350;
	Mon, 18 May 2026 15:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="t//fGip9"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC5B4657F5;
	Mon, 18 May 2026 15:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779118597; cv=none; b=k20yGjqyXmSY+I71CzUNiriZKkyL778QdVgx90/hBmh15RtimqCgIq6ImC20JBF+P3WBW/epGe8nWIEL0hnkLXQ4XXd0CMl1fFThuQSUjJblBnBMwYMrCGWNWKg1N0nBhlk9QI2HBheai3eJoLhEEHcurcX/3dyHQKKADFib3YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779118597; c=relaxed/simple;
	bh=jvp+xIe56wOZuwxAYmxCWXJS3N4zRsG8U/ZIZVspQfw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pNC5qTirjPhHbW8/phhCHHY+buo0/32dBGrCV90weV9jZNVEReNEW0sD221jGoSzSOUaqLklhjjCzTUIm4TbZLZFB3Evx13BIvFxhHoaYsEUxlBPZNb9xsy7sbo0Pm+ygDOK3G4d8VMqCSPRbR7TI24OtLwk3s0CzxZf4yrhgyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=t//fGip9; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64I0721A971899;
	Mon, 18 May 2026 08:36:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=N9cwM3uJpW9AqVLCsjhE16RDghhwc3hL+4K3YJVoltU=; b=t//fGip9UXVO
	0OjmHSE7qme86tB0L1Lp2zEqbn/oAajYvvQhBKDJRgLwCjeS2JyIacAGNgXq2jch
	9E37a7soTaq0t7jf4KDSPdQscWaCNbnD3EvEQ5kQKdI58VE80t/zYooMKRgGT9t3
	JOZS+Fsy5A88AEO8yeteL6n9NfH9KkKfaNPSKwHB3kDwIEoFgVxhrc1f4ldTXuo7
	8ABwBornAuUVjGo6uMaWqgGk4JQI12BJQCPBkEjySmBBlsFC/CMux0CiI1PxH7ny
	sB0H1iZqp8O2RmFPpm+cb5FYnTlv4CHDKQP1E2QBZUAx+knVM7xjCPYLWDsUpkoP
	/1tq1YECag==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4e6np69rcp-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 18 May 2026 08:36:27 -0700 (PDT)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Mon, 18 May
 2026 15:36:25 +0000
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
Subject: [PATCH v2 4/6] io_uring/zcrx: add shared-memory notification statistics
Date: Mon, 18 May 2026 08:35:27 -0700
Message-ID: <20260518153532.2835502-5-cleger@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDE1MyBTYWx0ZWRfX3LiKzmQg7Cdb
 Ao6/ngCD9DhIyfd7EN7/VynYidOUyLhUMKvCn+EK4rm7rn/jEYcjWCiV3J6bPG1aW3rOzQmrlD7
 VsuVhxEDQGpSwaqvkBqcLD+wsiKvtvY3tW/KEVhPSQ16BQclM8iuJuRamIInTKRqKBy86msiLsL
 wnywtQZrujqAdwBaouz05ECcF5sPVnHab3tEltT+tGCj608Hlif+OMBwOdYJYHQ4A0VOtqzt2k3
 Yl6FDFgyNjfvJFLxQEpPGWJ0XaIyZJ1W7MgWdGjVmnQGQ2HULNvLi05o6Mx37Mfg3pMbMbLruF2
 8rSh2PXZfdlsb2VAmo6QOEbxCChW8Pzqm7abWU7eblaSFGEmg8BO3/unkfu+L/aegB31M7Wjcxd
 /9bC/uoG+8FL83+YIYVmXmEZdwQmMxnMPbsRnJsYDS/Z+zwu8oU4yujGnZOxvpAeaXM13o6HjW7
 Cduuhnh9WXjjRDYidpg==
X-Authority-Analysis: v=2.4 cv=Pr2jqQM3 c=1 sm=1 tr=0 ts=6a0b31fb cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=03ozwUkBphtHgyqjj1sw:22
 a=VabnemYjAAAA:8 a=tUABAHM7GXuONXiLVFsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: shiX0prg-5IktwqHiSbTFgmKXKAjOqer
X-Proofpoint-ORIG-GUID: shiX0prg-5IktwqHiSbTFgmKXKAjOqer
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
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
	TAGGED_FROM(0.00)[bounces-13413-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[meta.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,meta.com:mid,meta.com:dkim,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 3AEF457028A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add support for an optional stats struct embedded in the refill queue
region, allowing userspace to monitor copy-fallback in real-time.

Userspace queries the stats struct size and alignment via
IO_URING_QUERY_ZCRX_NOTIF (notif_stats_size / notif_stats_alignment),
then provides a stats_offset in zcrx_notification_desc pointing to a
location within the refill queue region.

The kernel updates the stats counters in-place on every copy-fallback
event.

Signed-off-by: Clément Léger <cleger@meta.com>
---
 include/uapi/linux/io_uring/query.h | 12 +++++++
 include/uapi/linux/io_uring/zcrx.h  | 15 ++++++--
 io_uring/query.c                    | 16 +++++++++
 io_uring/zcrx.c                     | 54 +++++++++++++++++++++++++++--
 io_uring/zcrx.h                     |  1 +
 5 files changed, 94 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/io_uring/query.h b/include/uapi/linux/io_uring/query.h
index 95500759cc13..1a68eca7c6b4 100644
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
+	/* Bitmask of supported ZCRX_NOTIF_* flags */
+	__u32 notif_flags;
+	/* Size of io_uring_zcrx_notif_stats */
+	__u32 notif_stats_size;
+	/* Required alignment for the stats struct within the region (ie stats_offset) */
+	__u32 notif_stats_off_alignment;
+	__u32 __resv1;
+	__u64 __resv2[4];
+};
+
 struct io_uring_query_scq {
 	/* The SQ/CQ rings header size */
 	__u64 hdr_size;
diff --git a/include/uapi/linux/io_uring/zcrx.h b/include/uapi/linux/io_uring/zcrx.h
index 3f7b72b09878..384e185a180c 100644
--- a/include/uapi/linux/io_uring/zcrx.h
+++ b/include/uapi/linux/io_uring/zcrx.h
@@ -75,11 +75,22 @@ enum zcrx_notification_type {
 	__ZCRX_NOTIF_TYPE_LAST,
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
index c1704d088374..d17a83645bcd 100644
--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -9,6 +9,7 @@
 union io_query_data {
 	struct io_uring_query_opcode opcodes;
 	struct io_uring_query_zcrx zcrx;
+	struct io_uring_query_zcrx_notif zcrx_notif;
 	struct io_uring_query_scq scq;
 };
 
@@ -44,6 +45,18 @@ static ssize_t io_query_zcrx(union io_query_data *data)
 	return sizeof(*e);
 }
 
+static ssize_t io_query_zcrx_notif(union io_query_data *data)
+{
+	struct io_uring_query_zcrx_notif *e = &data->zcrx_notif;
+
+	e->notif_flags = ZCRX_NOTIF_TYPE_MASK;
+	e->notif_stats_size = sizeof(struct io_uring_zcrx_notif_stats);
+	e->notif_stats_off_alignment = __alignof__(struct io_uring_zcrx_notif_stats);
+	e->__resv1 = 0;
+	memset(&e->__resv2, 0, sizeof(e->__resv2));
+	return sizeof(*e);
+}
+
 static ssize_t io_query_scq(union io_query_data *data)
 {
 	struct io_uring_query_scq *e = &data->scq;
@@ -83,6 +96,9 @@ static int io_handle_query_entry(union io_query_data *data, void __user *uhdr,
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
index f31f2ca0f7ec..2881ad76bacc 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -415,6 +415,7 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 	io_free_region(ifq->user, &ifq->rq_region);
 	ifq->rq.ring = IO_URING_PTR_POISON;
 	ifq->rq.rqes = IO_URING_PTR_POISON;
+	ifq->notif_stats = IO_URING_PTR_POISON;
 }
 
 static void io_zcrx_free_area(struct io_zcrx_ifq *ifq,
@@ -855,6 +856,33 @@ static int zcrx_register_netdev(struct io_zcrx_ifq *ifq,
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
@@ -908,7 +936,13 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
 		return -EFAULT;
 	if (notif.type_mask & ~ZCRX_NOTIF_TYPE_MASK)
 		return -EINVAL;
-	if (notif.__resv1 || !mem_is_zero(&notif.__resv2, sizeof(notif.__resv2)))
+	if (notif.flags & ~ZCRX_NOTIF_DESC_FLAG_STATS)
+		return -EINVAL;
+	if (!(notif.flags & ZCRX_NOTIF_DESC_FLAG_STATS)) {
+		if (notif.stats_offset)
+			return -EINVAL;
+	}
+	if (!mem_is_zero(&notif.__resv2, sizeof(notif.__resv2)))
 		return -EINVAL;
 
 	ifq = io_zcrx_ifq_alloc(ctx);
@@ -939,6 +973,12 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
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
@@ -1154,6 +1194,11 @@ static void zcrx_notif_tw(struct io_tw_req tw_req, io_tw_token_t tw)
 	kmem_cache_free(req_cachep, req);
 }
 
+static void zcrx_stat_add(__u64 *p, s64 v)
+{
+	WRITE_ONCE(*p, READ_ONCE(*p) + v);
+}
+
 static void zcrx_send_notif(struct io_zcrx_ifq *ifq, unsigned type)
 {
 	gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO;
@@ -1537,8 +1582,13 @@ static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
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
index 203b3049e14b..e1aab76c310d 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -81,6 +81,7 @@ struct io_zcrx_ifq {
 	u32				allowed_notif_mask;
 	u32				fired_notifs;
 	u64				notif_data;
+	struct io_uring_zcrx_notif_stats *notif_stats;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.53.0-Meta


