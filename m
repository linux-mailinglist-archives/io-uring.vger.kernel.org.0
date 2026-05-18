Return-Path: <io-uring+bounces-13412-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QCGIDAE0C2qgEgUAu9opvQ
	(envelope-from <io-uring+bounces-13412-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:45:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A35B5703C2
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:45:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4F22830B8619
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 15:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D2947279E;
	Mon, 18 May 2026 15:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="AymUx7Ic"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E3D3FBB68;
	Mon, 18 May 2026 15:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779118596; cv=none; b=G8fODwxoxTFU5Hw0pnLWKHbaMTObwzfRiywW88C0tLvg0p31otjI5M8WoEUHE4ZDGsF6cI60JIWnfxLT1nGFDEXSKbXNPk8moTk7K6Cthp7TZ6T35kbuVcpFs2EiTIpGU31Rov6YvydI6d7r6VQ0XnRqaUTLd/TDgoHz+5nf7fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779118596; c=relaxed/simple;
	bh=tyukqsHNmM5zZKmC/VN1FsZSXO83SY6EK7UWphe2G2A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IwyCgqfGOKzlqfiJwMiBN6D1Qq3Wf37a0zZCXSm1fz1FAlo6TugqWxGLhlBp4HbzKKNTKAcTLw5PzV7cAwtk6LTNsFahTD6S8EcTYIa5JnJUjjuV8Q61y1y7SQNpNLNkZCyL4rvpaNlfJNeBJh+BiwWBsoMonaHl3eEVg5QsnEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=AymUx7Ic; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64I5OeKR2338178;
	Mon, 18 May 2026 08:36:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=pQPxJk4W/DOHrm9nMz0gvk3eSsq4LRgzVMYDbz1BfS0=; b=AymUx7IcViHX
	apHGpEib2gek/XEXRUwmgCWnkHKiiMojssoY8Ui80PvLkUeCJMpTZaiOUj3UPtuQ
	e0cFdrQoxOLPaeMf5LDp46sIzgPqUDq2wYu4/ffdKcXlGb4lSJgUWzADXX5i9hOP
	No7tlbp9tQ5IwjYbOklagXAyrjIcT8h274tb4Dr3INk0hjXDGvUV6o8689nV8UKh
	KqZUIhZ1aunKAmTVbut48yiHbfd8VjgRLlFfP1Taaa74aSxZc8nNZj69nlzrPZPY
	Gm12W77Av8vj7gRVPcmrXmFby/6p5/G8J8faoHj1sUNzJpiGjJckVULLNOQLGAL/
	Mb5vcZsHKQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4e7a5hp7pw-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 18 May 2026 08:36:23 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Mon, 18 May
 2026 15:36:16 +0000
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
Subject: [PATCH v2 2/6] io_uring/zcrx: notify user when out of buffers
Date: Mon, 18 May 2026 08:35:25 -0700
Message-ID: <20260518153532.2835502-3-cleger@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260518153532.2835502-1-cleger@meta.com>
References: <20260518153532.2835502-1-cleger@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=NqXhtcdJ c=1 sm=1 tr=0 ts=6a0b31f7 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=NGcC8JguVDcA:10 a=M51BFTxLslgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=jCddH8ec0KUNCymVuxII:22 a=pGLkceISAAAA:8
 a=VabnemYjAAAA:8 a=XVcddZJZvRb1FB5kz7kA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: RA94Vg0WCFFZBfMEq1n-ssV49B3uTeCx
X-Proofpoint-ORIG-GUID: RA94Vg0WCFFZBfMEq1n-ssV49B3uTeCx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDE1MyBTYWx0ZWRfX1rbe3PSPZYH6
 G15rTN6f+Q2PJUpzalz4Dzev6yByu2B1EeoyESyYUwZG1lZPCVomrLbbwZfO910DktpvR+SuSeA
 +q7PzWYZcTKNCp/JHSgzbzJsx4zVJjpfBXAJ4cfkauVTbVDyR8l9fJauMAOTjhPgLMIYhq79dk4
 00hZtbAgujzPNUTgQdOm3zhUGIYuNchEyUdEKDUgQpNCEqQj4MWv2gzwFXJjPWt9sitLBxJxy5L
 M6vJMdv65a8j+jThsr1jNQJRFv6Y2EJMu+wU1mjW9D5u8ZhnA9OSlTmSCSajR4ksPPttVh8IZy7
 HAc8HprOQf9sRZeehonp/jAvdZhV79Y8Op6qoqJKRJ4TKofonXdDb+Jf01rc3gAneqKT0RdsWfT
 +qTI9GH2KtRMNvLurwTWs8ADTodYUydpQjqYI5FW1aBjTQXO3Y15to4QsCCNr/IWTInbgIbLUXf
 7g4zlIieK/x2DOFvWlA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-18_03,2026-05-18_01,2025-10-01_01
X-Spamd-Result: default: False [1.51 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MIXED_CHARSET(0.67)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13412-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[meta.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,meta.com:email,meta.com:mid,meta.com:dkim]
X-Rspamd-Queue-Id: 9A35B5703C2
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

The only notification type the patch implements is
ZCRX_NOTIF_NO_BUFFERS, but we'll need more of them in the future.

Co-developed-by: Vishwanath Seshagiri <vishs@meta.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring/zcrx.h | 24 ++++++++-
 io_uring/io_uring.c                |  2 +-
 io_uring/io_uring.h                |  1 +
 io_uring/zcrx.c                    | 86 +++++++++++++++++++++++++++++-
 io_uring/zcrx.h                    |  7 ++-
 5 files changed, 115 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring/zcrx.h b/include/uapi/linux/io_uring/zcrx.h
index 5ce02c7a6096..67185566ad3c 100644
--- a/include/uapi/linux/io_uring/zcrx.h
+++ b/include/uapi/linux/io_uring/zcrx.h
@@ -65,6 +65,20 @@ enum zcrx_features {
 	 * value in struct io_uring_zcrx_ifq_reg::rx_buf_len.
 	 */
 	ZCRX_FEATURE_RX_PAGE_SIZE	= 1 << 0,
+	ZCRX_FEATURE_NOTIFICATION	= 1 << 1,
+};
+
+enum zcrx_notification_type {
+	ZCRX_NOTIF_NO_BUFFERS,
+
+	__ZCRX_NOTIF_TYPE_LAST,
+};
+
+struct zcrx_notification_desc {
+	__u64	user_data;
+	__u32	type_mask;
+	__u32	__resv1;
+	__u64	__resv2[10];
 };
 
 /*
@@ -82,12 +96,14 @@ struct io_uring_zcrx_ifq_reg {
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
@@ -101,6 +117,11 @@ struct zcrx_ctrl_export {
 	__u32 		__resv1[11];
 };
 
+struct zcrx_ctrl_arm_notif {
+	__u32		notif_type;
+	__u32		__resv[11];
+};
+
 struct zcrx_ctrl {
 	__u32	zcrx_id;
 	__u32	op; /* see enum zcrx_ctrl_op */
@@ -109,6 +130,7 @@ struct zcrx_ctrl {
 	union {
 		struct zcrx_ctrl_export		zc_export;
 		struct zcrx_ctrl_flush_rq	zc_flush;
+		struct zcrx_ctrl_arm_notif	zc_arm_notif;
 	};
 };
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2ebb0ba37c4f..c5972274cce1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -160,7 +160,7 @@ static void io_poison_cached_req(struct io_kiocb *req)
 	req->apoll = IO_URING_PTR_POISON;
 }
 
-static void io_poison_req(struct io_kiocb *req)
+void io_poison_req(struct io_kiocb *req)
 {
 	io_poison_cached_req(req);
 	req->async_data = IO_URING_PTR_POISON;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e612a66ee80e..de0a3bed58d1 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -213,6 +213,7 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 void io_restriction_clone(struct io_restriction *dst, struct io_restriction *src);
+void io_poison_req(struct io_kiocb *req);
 
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 {
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 34faf90423f4..463fbaead35b 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -768,6 +768,8 @@ static int import_zcrx(struct io_ring_ctx *ctx,
 		return -EINVAL;
 	if (reg->if_rxq || reg->rq_entries || reg->area_ptr || reg->region_ptr)
 		return -EINVAL;
+	if (reg->notif_desc)
+		return -EINVAL;
 	if (reg->flags & ~ZCRX_REG_IMPORT)
 		return -EINVAL;
 
@@ -856,6 +858,7 @@ static int zcrx_register_netdev(struct io_zcrx_ifq *ifq,
 int io_register_zcrx(struct io_ring_ctx *ctx,
 		     struct io_uring_zcrx_ifq_reg __user *arg)
 {
+	struct zcrx_notification_desc notif;
 	struct io_uring_zcrx_area_reg area;
 	struct io_uring_zcrx_ifq_reg reg;
 	struct io_uring_region_desc rd;
@@ -899,10 +902,22 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
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
@@ -954,7 +969,8 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
 		goto err;
 	}
 
-	zcrx_set_ring_ctx(ifq, ctx);
+	if (notif.type_mask)
+		zcrx_set_ring_ctx(ifq, ctx);
 	return 0;
 err:
 	scoped_guard(mutex, &ctx->mmap_lock)
@@ -1127,6 +1143,48 @@ static unsigned io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *if
 	return allocated;
 }
 
+static void zcrx_notif_tw(struct io_tw_req tw_req, io_tw_token_t tw)
+{
+	struct io_kiocb *req = tw_req.req;
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_post_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, 0);
+	percpu_ref_put(&ctx->refs);
+	io_poison_req(req);
+	kmem_cache_free(req_cachep, req);
+}
+
+static void zcrx_send_notif(struct io_zcrx_ifq *ifq, unsigned type)
+{
+	gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO;
+	u32 type_mask = 1 << type;
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
+	req->cqe.res = type;
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
@@ -1143,8 +1201,10 @@ static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
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
@@ -1293,12 +1353,32 @@ static int zcrx_flush_rq(struct io_ring_ctx *ctx, struct io_zcrx_ifq *zcrx,
 	return 0;
 }
 
+static int zcrx_arm_notif(struct io_ring_ctx *ctx, struct io_zcrx_ifq *zcrx,
+			  struct zcrx_ctrl *ctrl)
+{
+	const struct zcrx_ctrl_arm_notif *an = &ctrl->zc_arm_notif;
+	unsigned type_mask;
+
+	if (an->notif_type >= __ZCRX_NOTIF_TYPE_LAST)
+		return -EINVAL;
+	if (!mem_is_zero(&an->__resv, sizeof(an->__resv)))
+		return -EINVAL;
+
+	guard(spinlock_bh)(&zcrx->ctx_lock);
+	type_mask = 1U << an->notif_type;
+	if (type_mask & ~zcrx->fired_notifs)
+		return -EINVAL;
+	zcrx->fired_notifs &= ~type_mask;
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
@@ -1316,6 +1396,8 @@ int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 		return zcrx_flush_rq(ctx, zcrx, &ctrl);
 	case ZCRX_CTRL_EXPORT:
 		return zcrx_export(ctx, zcrx, &ctrl, arg);
+	case ZCRX_CTRL_ARM_NOTIFICATION:
+		return zcrx_arm_notif(ctx, zcrx, &ctrl);
 	}
 
 	return -EOPNOTSUPP;
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 6b565d0bf6da..cca10d0d02ac 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -9,7 +9,9 @@
 #include <net/net_trackers.h>
 
 #define ZCRX_SUPPORTED_REG_FLAGS	(ZCRX_REG_IMPORT | ZCRX_REG_NODEV)
-#define ZCRX_FEATURES			(ZCRX_FEATURE_RX_PAGE_SIZE)
+#define ZCRX_FEATURES			(ZCRX_FEATURE_RX_PAGE_SIZE |\
+					 ZCRX_FEATURE_NOTIFICATION)
+#define ZCRX_NOTIF_TYPE_MASK		(1U << ZCRX_NOTIF_NO_BUFFERS)
 
 struct io_zcrx_mem {
 	unsigned long			size;
@@ -76,6 +78,9 @@ struct io_zcrx_ifq {
 
 	spinlock_t			ctx_lock;
 	struct io_ring_ctx		*master_ctx;
+	u32				allowed_notif_mask;
+	u32				fired_notifs;
+	u64				notif_data;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.53.0-Meta


