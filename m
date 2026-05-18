Return-Path: <io-uring+bounces-13410-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IA7BLmkyC2qHEgUAu9opvQ
	(envelope-from <io-uring+bounces-13410-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:38:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E9495701E3
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6897C30309BF
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 15:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BFE5404894;
	Mon, 18 May 2026 15:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="rzKyhOwo"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEED43F9F30;
	Mon, 18 May 2026 15:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779118586; cv=none; b=VYph8eeQ2JbKjglzlcJ9Vxd+TR8Zpa7mtVVZ4AjSzF9ruP0J6MFX5bLitndAF2yD9DUS3cP/Wz69IFprFFQ370dlc/qWuSGnDW+EKq+QEyxQLtWxgO4nI64/1gjOWnSEMMiXrCLkN0YYmXZPGP4Si0r6RJm56gaF6V9l52BdhjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779118586; c=relaxed/simple;
	bh=rx5ZGSwADz9+97vNY1/vB/EeG1yWsBC9hvcrCStUViY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z2dVAyMGzrUoN1AbvY7eXnTI/zIUlvo2oToznjHOJpbTOxhQ57Bcccx8amu9uP2P0dkbWZp0UWKqafGqHPPHTJ1FUJrBJ201v7/usee8qr2nWJACVvEACMFqkSWvhEzsyOu2TEBwGhMDZk1GE2TlWE0aehfT9t/Ra3LrWBc2094=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=rzKyhOwo; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64HMOPmM3955565;
	Mon, 18 May 2026 08:36:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=hwqumWOzgPDProtcQ8OjlXWX4FPuHrxZC2c7JY1jCf4=; b=rzKyhOwoxstT
	E4UDitAETRES32TDAWirHt9EmQkhIs58QxOJ7rjzkDzbTDsIR5GNIYZ3DeQbc07i
	XTE8QLPVBdvKGHcJY6YtRwQoPYcypibPe+X5fLas0N6Af5yuToJKkzh4vWy9CDzP
	Dd6P8+cL234bZb7viIyiAXtI5RYjIpwMusAIpmtBrdxn/3jZreNBzHRsrU0HFM8T
	n98kOCclCNs3RWKzJvrkEmqyZEsykgmkTnELlp1RpA4JtyyPe6k//LQ1FMlX0uef
	ENtcEAKcMBA2P4MymFhApH66AcwDQIuDxAEVd1neCCfZFYeC3FxP1xW6ZthOANyh
	XKyVng/8lw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4e6kw122hp-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 18 May 2026 08:36:15 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Mon, 18 May
 2026 15:36:13 +0000
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
Subject: [PATCH v2 1/6] io_uring/zcrx: add ctx pointer to zcrx
Date: Mon, 18 May 2026 08:35:24 -0700
Message-ID: <20260518153532.2835502-2-cleger@meta.com>
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
X-Proofpoint-ORIG-GUID: HhJnrQDkYkAQuQY_ijdKSS3pd1qQMUIB
X-Authority-Analysis: v=2.4 cv=P/MKQCAu c=1 sm=1 tr=0 ts=6a0b31ef cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=NGcC8JguVDcA:10 a=M51BFTxLslgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=8elwO82fXORLTBIkMd32:22 a=pGLkceISAAAA:8
 a=VabnemYjAAAA:8 a=Df7pRbWtbhPDAoH00hYA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDE1MyBTYWx0ZWRfX+IuMgyKPH/Ge
 7JsSAPMW1ojtKw/twnxLXkjcyRPeJ5sq+fPXDisRd89POq3mEZXqmietxbCaaBpNReXFk7zs8af
 ww3rBRwt8nBYMJawth4zn+ZLhmWRSpD6S88wErRlqsvhQOjeUyR0Yj8mvrvXLpHr12XoHQxYBNY
 A0nOrGzaS+7SSQGLtOkdlMOZFpj8zt0VDFlORkRVl72BIbeYnCsHV3y2Dgicp2WvHfw34ULrxBT
 JnYD0Z/zsaaw3MD0D39+HOnRKBe8Er+FxH+RgqNVuuvQqvUaBvoZED1+R0UocmT8sKGlRZNd64A
 tEnzZHbC3v7L5x66RlSGIZe+bRthluTpjMfR0xZBMGe9xxWJTRqrPjgZx5FaWAldh23blnFbudJ
 al5L6D6nmpN4mulaLNvl7E6BUzt9pl6Y3Xz8LwfKiyLSNJ+Zv1nlHpGcaWgbyfyj2Bd44QQfd6s
 O4YjK10SlhzyzZVtr1w==
X-Proofpoint-GUID: HhJnrQDkYkAQuQY_ijdKSS3pd1qQMUIB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-18_03,2026-05-18_01,2025-10-01_01
X-Spamd-Result: default: False [1.55 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MIXED_CHARSET(0.71)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13410-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,meta.com:email,meta.com:mid,meta.com:dkim]
X-Rspamd-Queue-Id: 7E9495701E3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Pavel Begunkov <asml.silence@gmail.com>

zcrx will need to have a pointer to an owning ctx to communicate
different events. Reference the ctx while it's attached to zcrx, and
rely on zcrx termination to drop the ctx to avoid circular ref deps.

Co-developed-by: Vishwanath Seshagiri <vishs@meta.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 39 +++++++++++++++++++++++++++++++--------
 io_uring/zcrx.h |  3 +++
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 3f9632e7790a..34faf90423f4 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -44,6 +44,17 @@ static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *nio
 	return container_of(owner, struct io_zcrx_area, nia);
 }
 
+static bool zcrx_set_ring_ctx(struct io_zcrx_ifq *zcrx,
+			      struct io_ring_ctx *ctx)
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
@@ -531,6 +542,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 		return NULL;
 
 	ifq->if_rxq = -1;
+	spin_lock_init(&ifq->ctx_lock);
 	spin_lock_init(&ifq->rq.lock);
 	mutex_init(&ifq->pp_lock);
 	refcount_set(&ifq->refs, 1);
@@ -580,6 +592,8 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 		return;
 	if (WARN_ON_ONCE(ifq->netdev != NULL))
 		return;
+	if (WARN_ON_ONCE(ifq->master_ctx))
+		return;
 
 	if (ifq->area)
 		io_zcrx_free_area(ifq, ifq->area);
@@ -656,17 +670,24 @@ static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
 	}
 }
 
-static void zcrx_unregister_user(struct io_zcrx_ifq *ifq)
+static void zcrx_unregister_user(struct io_zcrx_ifq *ifq, struct io_ring_ctx *ctx)
 {
+	scoped_guard(spinlock_bh, &ifq->ctx_lock) {
+		if (ctx && ifq->master_ctx == ctx) {
+			ifq->master_ctx = NULL;
+			percpu_ref_put(&ctx->refs);
+		}
+	}
+
 	if (refcount_dec_and_test(&ifq->user_refs)) {
 		io_close_queue(ifq);
 		io_zcrx_scrub(ifq);
 	}
 }
 
-static void zcrx_unregister(struct io_zcrx_ifq *ifq)
+static void zcrx_unregister(struct io_zcrx_ifq *ifq, struct io_ring_ctx *ctx)
 {
-	zcrx_unregister_user(ifq);
+	zcrx_unregister_user(ifq, ctx);
 	io_put_zcrx_ifq(ifq);
 }
 
@@ -686,7 +707,7 @@ static int zcrx_box_release(struct inode *inode, struct file *file)
 
 	if (WARN_ON_ONCE(!ifq))
 		return -EFAULT;
-	zcrx_unregister(ifq);
+	zcrx_unregister(ifq, NULL);
 	return 0;
 }
 
@@ -711,7 +732,7 @@ static int zcrx_export(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
 	file = anon_inode_create_getfile("[zcrx]", &zcrx_box_fops,
 					 ifq, O_CLOEXEC, NULL);
 	if (IS_ERR(file)) {
-		zcrx_unregister(ifq);
+		zcrx_unregister(ifq, NULL);
 		return PTR_ERR(file);
 	}
 
@@ -787,7 +808,7 @@ static int import_zcrx(struct io_ring_ctx *ctx,
 	scoped_guard(mutex, &ctx->mmap_lock)
 		xa_erase(&ctx->zcrx_ctxs, id);
 err:
-	zcrx_unregister(ifq);
+	zcrx_unregister(ifq, ctx);
 	return ret;
 }
 
@@ -932,12 +953,14 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
 		ret = -EFAULT;
 		goto err;
 	}
+
+	zcrx_set_ring_ctx(ifq, ctx);
 	return 0;
 err:
 	scoped_guard(mutex, &ctx->mmap_lock)
 		xa_erase(&ctx->zcrx_ctxs, id);
 ifq_free:
-	zcrx_unregister(ifq);
+	zcrx_unregister(ifq, ctx);
 	return ret;
 }
 
@@ -967,7 +990,7 @@ void io_terminate_zcrx(struct io_ring_ctx *ctx)
 			break;
 		set_zcrx_entry_mark(ctx, id);
 		id++;
-		zcrx_unregister_user(ifq);
+		zcrx_unregister_user(ifq, ctx);
 	}
 }
 
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 9e1a6a1b11e8..6b565d0bf6da 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -73,6 +73,9 @@ struct io_zcrx_ifq {
 	 */
 	struct mutex			pp_lock;
 	struct io_mapped_region		rq_region;
+
+	spinlock_t			ctx_lock;
+	struct io_ring_ctx		*master_ctx;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.53.0-Meta


