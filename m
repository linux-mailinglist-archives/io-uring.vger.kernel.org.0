Return-Path: <io-uring+bounces-13115-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OKnZMGOx6GmIOwIAu9opvQ
	(envelope-from <io-uring+bounces-13115-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:30:43 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 949BE44561B
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:30:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 790DD3032197
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 11:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1A003CF687;
	Wed, 22 Apr 2026 11:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="UM1Zouaj"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDC2346E55;
	Wed, 22 Apr 2026 11:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776857362; cv=none; b=b5xV4CGIVJDcqfawXCUK/I1CDEaVxAlHqcFUaghkja46FcOewhrxd+MKT3TAMgn9LmssekPTVtoZreGmoSOjcP1mQWaNEb/AVN6gxwRETRWI4oYKCEb5LxQlX9WX019xtemRpikQCs4WDOcxrhZyKdoIPXYpuuKe+I3AsizfWKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776857362; c=relaxed/simple;
	bh=L/CCGxjelU6Txzv7CCUM65il82JaXXFecSyF45RCBds=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hfFYM3reiuFUarczyPBv9mw/mjUuNPjPisEK0U3WN7utU6HWbSuGoP2jyHAlHe7Y4gB1fgby69TzHVanCYdhGdFe3eaizH4ASM56kT2Ex1YVItMlnL2RbDt7SXjze1egpJUKaHvikNzVjYXJE44jIlbZay0UtS1p1oLh/xn6WSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=UM1Zouaj; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIe1in098496;
	Wed, 22 Apr 2026 04:29:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=5y0psTD6dFRi3Ku/PRitCdFv6ppKOmOvN+Pgt7QkhVw=; b=UM1Zouajk/G/
	Rf/2PIjQNXbBPR9J6MwfEI1/FZ8o3AYSy3iaywa0PGMHfcJbfUFdvYOSVWufrx50
	d5FZ0R4Cg1RdmJ7JsDbzrDdigOtzXUObecEb8W8WHh8iVAEpgUmjwo1ulmK6qhWv
	T9gQ/yJSfpQWzK5wc+1aCa3fbeigETgnyoJR/wcN/Z3kaNpQWX3eXGPMILEdvzKK
	kBcWFY/0jAVcHziTish48ox4q3cayRBfZWYiAo+27qy24izd0bXeNtRmoegSdsCc
	v90KTEnjaKQqZBn/EmZtifX3ZBlHHFNZrPIJOKWRQvZ9RFmNvxP8S1HxO0JitKNB
	q3NXLqIsdQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4dpeq84p4p-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 22 Apr 2026 04:29:11 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1c::1b) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Wed, 22 Apr
 2026 11:29:09 +0000
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>
To: <io-uring@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>,
        "Jens
 Axboe" <axboe@kernel.dk>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
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
        Vishwanath Seshagiri <vishs@fb.com>,
        "Vishwanath
 Seshagiri" <vishs@meta.com>
Subject: [PATCH 1/5] io_uring/zcrx: notify user when out of buffers
Date: Wed, 22 Apr 2026 04:25:12 -0700
Message-ID: <20260422112522.3316660-2-cleger@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260422112522.3316660-1-cleger@meta.com>
References: <20260422112522.3316660-1-cleger@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: wmxlRId0whWjnPbwkrRVbJLeS6ZWv84o
X-Authority-Analysis: v=2.4 cv=X4pi7mTe c=1 sm=1 tr=0 ts=69e8b107 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=A5OVakUREuEA:10 a=M51BFTxLslgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=tpM8CJlwf7uhpglF1g9U:22 a=pGLkceISAAAA:8
 a=VabnemYjAAAA:8 a=JHpVwyOmdC1rrBdYOEsA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDExMCBTYWx0ZWRfX0QN2pJgCf7Ix
 6kDzsK0sufNWYxxPfKfHdyaJEpwK5rsNtZ48pwOyKoudMm9+JJEDZnAeZjhcEEqRzeSYiwxsNVo
 CSarDKBwuNb/3jdsIVp19lbIB3ijFXstxsRsKGFqTBhHu2JU4gHtHIQgWmTKZGukuM7lf+it+JR
 J8+kgZjiNroxAtu549nxNrmY74QsDWRuvCBOS5hicuudx3V6Mevx+urc9jQ4aNq8JXBRipuK3Z8
 l1/m7I9ah0aDlNFVb111wXQEDQAnfvhVw84+pxcUyUQOYd9EJ5AoFV2wS/rZy1TIRUp05vSi2xh
 5Q42JSxCR2WIGHrkMhnrYACC35JaK2VUhpvzk2n/y/So3dK5eUrcIWgp4FWZBu6IuooncquckQm
 IbuDJgRo8NoPro/5EvPZXdYGV4gkTie8b3y30Y+afcQsxLP1Lo0klhjw4XJh9LfClnvKTkV+KGp
 e1we6K4ZKFNuTf5N6/A==
X-Proofpoint-ORIG-GUID: wmxlRId0whWjnPbwkrRVbJLeS6ZWv84o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Spamd-Result: default: False [1.55 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.71)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13115-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[16];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[meta.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.996];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,meta.com:email,meta.com:dkim,meta.com:mid]
X-Rspamd-Queue-Id: 949BE44561B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Pavel Begunkov <asml.silence@gmail.com>

There are currently no easy ways for the user to know if zcrx is out of
buffers and page pool fails to allocate. Add uapi for zcrx to communicate
it back.

It's implemented as a separate CQE, which for now is posted to the creator
ctx. To use it, on registration the user space needs to pass an instance
of struct zcrx_notification_desc, which tells the kernel the user_data
for resulting CQEs and which event types are expected / allowed.

When an allowed event happens, zcrx will post a CQE containing the
specified user_data, and lower bits of cqe->res will be set to the event
mask. Before the kernel could post another notification of the given
type, the user needs to acknowledge that it processed the previous one
by issuing IORING_REGISTER_ZCRX_CTRL with ZCRX_CTRL_ARM_NOTIFICATION.

The only notification type the patch implements yet is
ZCRX_NOTIF_NO_BUFFERS. Next commit adds copy fallback signaling.

Co-developed-by: Vishwanath Seshagiri <vishs@meta.com>
Signed-off-by: Vishwanath Seshagiri <vishs@meta.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring/zcrx.h | 22 ++++++-
 io_uring/zcrx.c                    | 98 +++++++++++++++++++++++++++++-
 io_uring/zcrx.h                    | 11 +++-
 3 files changed, 128 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring/zcrx.h b/include/uapi/linux/io_uring/zcrx.h
index 5ce02c7a6096..b8596d7d47b6 100644
--- a/include/uapi/linux/io_uring/zcrx.h
+++ b/include/uapi/linux/io_uring/zcrx.h
@@ -65,6 +65,18 @@ enum zcrx_features {
 	 * value in struct io_uring_zcrx_ifq_reg::rx_buf_len.
 	 */
 	ZCRX_FEATURE_RX_PAGE_SIZE	= 1 << 0,
+	ZCRX_FEATURE_NOTIFICATION	= 1 << 1,
+};
+
+enum zcrx_notification_type {
+	ZCRX_NOTIF_NO_BUFFERS = 1 << 0,
+};
+
+struct zcrx_notification_desc {
+	__u64	user_data;
+	__u32	type_mask;
+	__u32	__resv1;
+	__u64	__resv2[10];
 };
 
 /*
@@ -82,12 +94,14 @@ struct io_uring_zcrx_ifq_reg {
 	struct io_uring_zcrx_offsets offsets;
 	__u32	zcrx_id;
 	__u32	rx_buf_len;
-	__u64	__resv[3];
+	__u64	notif_desc; /* see struct zcrx_notification_desc */
+	__u64	__resv[2];
 };
 
 enum zcrx_ctrl_op {
 	ZCRX_CTRL_FLUSH_RQ,
 	ZCRX_CTRL_EXPORT,
+	ZCRX_CTRL_ARM_NOTIFICATION,
 
 	__ZCRX_CTRL_LAST,
 };
@@ -101,6 +115,11 @@ struct zcrx_ctrl_export {
 	__u32 		__resv1[11];
 };
 
+struct zcrx_ctrl_arm_notif {
+	__u32		type_mask;
+	__u32		__resv[11];
+};
+
 struct zcrx_ctrl {
 	__u32	zcrx_id;
 	__u32	op; /* see enum zcrx_ctrl_op */
@@ -109,6 +128,7 @@ struct zcrx_ctrl {
 	union {
 		struct zcrx_ctrl_export		zc_export;
 		struct zcrx_ctrl_flush_rq	zc_flush;
+		struct zcrx_ctrl_arm_notif	zc_arm_notif;
 	};
 };
 
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 9a83d7eb4210..35ca28cb6583 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -44,6 +44,16 @@ static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *nio
 	return container_of(owner, struct io_zcrx_area, nia);
 }
 
+static bool zcrx_set_ring_ctx(struct io_zcrx_ifq *zcrx, struct io_ring_ctx *ctx)
+{
+	guard(spinlock_bh)(&zcrx->ctx_lock);
+	if (zcrx->master_ctx)
+		return false;
+	percpu_ref_get(&ctx->refs);
+	zcrx->master_ctx = ctx;
+	return true;
+}
+
 static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
@@ -531,6 +541,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 	ifq->if_rxq = -1;
 	spin_lock_init(&ifq->rq.lock);
+	spin_lock_init(&ifq->ctx_lock);
 	mutex_init(&ifq->pp_lock);
 	refcount_set(&ifq->refs, 1);
 	refcount_set(&ifq->user_refs, 1);
@@ -585,6 +596,11 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 	if (ifq->dev)
 		put_device(ifq->dev);
 
+	scoped_guard(spinlock_bh, &ifq->ctx_lock) {
+		if (ifq->master_ctx)
+			percpu_ref_put(&ifq->master_ctx->refs);
+	}
+
 	io_free_rbuf_ring(ifq);
 	mutex_destroy(&ifq->pp_lock);
 	kfree(ifq);
@@ -738,6 +754,8 @@ static int import_zcrx(struct io_ring_ctx *ctx,
 		return -EINVAL;
 	if (reg->if_rxq || reg->rq_entries || reg->area_ptr || reg->region_ptr)
 		return -EINVAL;
+	if (reg->notif_desc)
+		return -EINVAL;
 	if (reg->flags & ~ZCRX_REG_IMPORT)
 		return -EINVAL;
 
@@ -826,6 +844,7 @@ static int zcrx_register_netdev(struct io_zcrx_ifq *ifq,
 int io_register_zcrx(struct io_ring_ctx *ctx,
 		     struct io_uring_zcrx_ifq_reg __user *arg)
 {
+	struct zcrx_notification_desc notif;
 	struct io_uring_zcrx_area_reg area;
 	struct io_uring_zcrx_ifq_reg reg;
 	struct io_uring_region_desc rd;
@@ -869,10 +888,22 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
 	if (copy_from_user(&area, u64_to_user_ptr(reg.area_ptr), sizeof(area)))
 		return -EFAULT;
 
+	memset(&notif, 0, sizeof(notif));
+	if (reg.notif_desc && copy_from_user(&notif, u64_to_user_ptr(reg.notif_desc),
+					     sizeof(notif)))
+		return -EFAULT;
+	if (notif.type_mask & ~ZCRX_NOTIF_TYPE_MASK)
+		return -EINVAL;
+	if (notif.__resv1 || !mem_is_zero(&notif.__resv2, sizeof(notif.__resv2)))
+		return -EINVAL;
+
 	ifq = io_zcrx_ifq_alloc(ctx);
 	if (!ifq)
 		return -ENOMEM;
 
+	ifq->notif_data = notif.user_data;
+	ifq->allowed_notif_mask = notif.type_mask;
+
 	if (ctx->user) {
 		get_uid(ctx->user);
 		ifq->user = ctx->user;
@@ -923,6 +954,9 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
 		ret = -EFAULT;
 		goto err;
 	}
+
+	if (notif.type_mask)
+		zcrx_set_ring_ctx(ifq, ctx);
 	return 0;
 err:
 	scoped_guard(mutex, &ctx->mmap_lock)
@@ -1089,6 +1123,46 @@ static unsigned io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *if
 	return allocated;
 }
 
+static void zcrx_notif_tw(struct io_tw_req tw_req, io_tw_token_t tw)
+{
+	struct io_kiocb *req = tw_req.req;
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_post_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, 0);
+	percpu_ref_put(&ctx->refs);
+	kfree_rcu(req, rcu_head);
+}
+
+static void zcrx_send_notif(struct io_zcrx_ifq *ifq, u32 type_mask)
+{
+	gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO;
+	struct io_kiocb *req;
+
+	if (!(type_mask & ifq->allowed_notif_mask))
+		return;
+
+	guard(spinlock_bh)(&ifq->ctx_lock);
+	if (!ifq->master_ctx)
+		return;
+	if (type_mask & ifq->fired_notifs)
+		return;
+
+	req = kmem_cache_alloc(req_cachep, gfp);
+	if (unlikely(!req))
+		return;
+
+	ifq->fired_notifs |= type_mask;
+
+	req->opcode = IORING_OP_NOP;
+	req->cqe.user_data = ifq->notif_data;
+	req->cqe.res = type_mask;
+	req->ctx = ifq->master_ctx;
+	percpu_ref_get(&req->ctx->refs);
+	req->tctx = NULL;
+	req->io_task_work.func = zcrx_notif_tw;
+	io_req_task_work_add(req);
+}
+
 static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
 {
 	struct io_zcrx_ifq *ifq = io_pp_to_ifq(pp);
@@ -1105,8 +1179,10 @@ static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
 		goto out_return;
 
 	allocated = io_zcrx_refill_slow(pp, ifq, netmems, to_alloc);
-	if (!allocated)
+	if (!allocated) {
+		zcrx_send_notif(ifq, ZCRX_NOTIF_NO_BUFFERS);
 		return 0;
+	}
 out_return:
 	zcrx_sync_for_device(pp, ifq, netmems, allocated);
 	allocated--;
@@ -1255,12 +1331,30 @@ static int zcrx_flush_rq(struct io_ring_ctx *ctx, struct io_zcrx_ifq *zcrx,
 	return 0;
 }
 
+static int zcrx_arm_notif(struct io_ring_ctx *ctx, struct io_zcrx_ifq *zcrx,
+			  struct zcrx_ctrl *ctrl)
+{
+	const struct zcrx_ctrl_arm_notif *an = &ctrl->zc_arm_notif;
+
+	if (an->type_mask & ~ZCRX_NOTIF_TYPE_MASK)
+		return -EINVAL;
+	if (!mem_is_zero(&an->__resv, sizeof(an->__resv)))
+		return -EINVAL;
+
+	guard(spinlock_bh)(&zcrx->ctx_lock);
+	if (an->type_mask & ~zcrx->fired_notifs)
+		return -EINVAL;
+	zcrx->fired_notifs &= ~an->type_mask;
+	return 0;
+}
+
 int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 {
 	struct zcrx_ctrl ctrl;
 	struct io_zcrx_ifq *zcrx;
 
 	BUILD_BUG_ON(sizeof(ctrl.zc_export) != sizeof(ctrl.zc_flush));
+	BUILD_BUG_ON(sizeof(ctrl.zc_export) != sizeof(ctrl.zc_arm_notif));
 
 	if (nr_args)
 		return -EINVAL;
@@ -1278,6 +1372,8 @@ int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 		return zcrx_flush_rq(ctx, zcrx, &ctrl);
 	case ZCRX_CTRL_EXPORT:
 		return zcrx_export(ctx, zcrx, &ctrl, arg);
+	case ZCRX_CTRL_ARM_NOTIFICATION:
+		return zcrx_arm_notif(ctx, zcrx, &ctrl);
 	}
 
 	return -EOPNOTSUPP;
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 75e0a4e6ef6e..3ddebed06d57 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -9,7 +9,9 @@
 #include <net/net_trackers.h>
 
 #define ZCRX_SUPPORTED_REG_FLAGS	(ZCRX_REG_IMPORT | ZCRX_REG_NODEV)
-#define ZCRX_FEATURES			(ZCRX_FEATURE_RX_PAGE_SIZE)
+#define ZCRX_FEATURES			(ZCRX_FEATURE_RX_PAGE_SIZE |\
+					 ZCRX_FEATURE_NOTIFICATION)
+#define ZCRX_NOTIF_TYPE_MASK		(ZCRX_NOTIF_NO_BUFFERS)
 
 struct io_zcrx_mem {
 	unsigned long			size;
@@ -72,6 +74,13 @@ struct io_zcrx_ifq {
 	 */
 	struct mutex			pp_lock;
 	struct io_mapped_region		rq_region;
+
+	/* Locks the access to notifification context data */
+	spinlock_t			ctx_lock;
+	struct io_ring_ctx		*master_ctx;
+	u32				allowed_notif_mask;
+	u32				fired_notifs;
+	u64				notif_data;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.52.0


