Return-Path: <io-uring+bounces-13004-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UHAcDx2s1mmZHAgAu9opvQ
	(envelope-from <io-uring+bounces-13004-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 21:27:25 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F11683C3027
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 21:27:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 65CA43020EF8
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 19:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E71632B981;
	Wed,  8 Apr 2026 19:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="DQmkLQpA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E9E3446CA
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 19:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775676438; cv=none; b=Lj68wNfi+bjjmWooskmE+8SMIWSqxEtPEjpBr3lU1UFo6XhpQ8GiWULYSg/RAYZq8OC49fHuVu/8m8VH9zz/gp+lkNOJvW8YakW6V6/UeSI4HHY8g98WfQ8Gfi5xq3+Gg7iX+kO053TNnzz+y+3pzZlVNG2UB3C+CSeWEeO0U+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775676438; c=relaxed/simple;
	bh=XdfmhQSr8naWWGZQGOuPSIgi32BcnleCWovWQ0XnTwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZnm2EVk3PHf9FAw/zNEVi/UZ2SToz2yxHsBJLojLGcB91TAXI3QE7Bm8SUJ4ijGkqCHRSoqA7OA6y7rvxhFxT7wnhlLFx6bLgXh5CChERxHO1cFMQ2rBqulmrtQAYufwDvcvN1RFfl2p8HcW4B/cVP+mVrfHnJeyjQcXcj7f7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=DQmkLQpA; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d4be94eeacso128654a34.2
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 12:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775676435; x=1776281235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/eU0gjjKAwk5ktI4A91I3AIH73gGrQd4cTD+S5+2jCc=;
        b=DQmkLQpA8aljKXlBhTnqjvusr0wjyzgePMVBEHAF6/pzZRqX+p5M/aGqJHPJybmnON
         g284gv1Q3BzaPPu8wdpeF2FbcurcnLVJTqzc6niZx9abNrqLf7cR82ILZBE1t9ALS/jR
         vbIZ+Kb/F+Emj3h7ue4iw23+OpwU7/DnkBbF38WscMNv5054lzcEWkY8WezpWoN1f0+8
         4EEHVRxd1itbxUHWG2l+aKYEa53zo3rRsoV0i30I/cDJp/vZiqACixFmnCo8nBbwko3z
         SxKa4QtvFea2k+Bvtc5/ylU8QEcbTToOFDbVl1XpKgxYmiTm47dn3OiJTHMTgM2sjzXB
         tjzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775676435; x=1776281235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/eU0gjjKAwk5ktI4A91I3AIH73gGrQd4cTD+S5+2jCc=;
        b=tZMIWblN50MV1GwyeyC5ku1O6MGp1YK3VYtKzvPRxoFJuXKxLQBna1nWH1vX5z3e2Z
         O9QWKf61AnBaMoB8omT5aV/CGon/vyWPlw8kO0be7CjstWYtgw5oTo/ejONkqc7BxTQS
         K8pVUGaISFAOpV1ePjJPnNEVCih2DYytxLRozrsJxRq5roLfVYj6gxMbXAjJnicFvBXo
         v1LSTDXJk/s4zDM9d2rqK4l6Nhx4zCKb2SgUJrz6Kx+hvOt0OCajZpNKXkccccD9Slx6
         GHGwbh2Wiaaew4W0tHFYM2TF1ifYs4oqXp2JpETR9rtwjXPV3BiOdX2hbz5pSiI8O7yZ
         AAYw==
X-Gm-Message-State: AOJu0Yw+UornFViX3upGLaB2Ft8jk3Ne/CXD0GXkYsrXfQVGNfO7TFVQ
	FN2mwyhnsF0/Eztr78nFQ/lcgpsE88ixNQH5oBjc/ibuiGWKvOWqk5jZV823xnVV70SCXOp72l3
	1q39o
X-Gm-Gg: AeBDietcx05F7xOw+LvLzZbHAeGBYIcGizvIFnXacU3es9wm21UsXHsO6eYVcWJbAmz
	HDku5a9J3jLmONm4sTr01XEpXOP/x9P+oBzmaq8t3gPhYYYfVpIVbXVkP0TaHVtGv7Guyjsi/j6
	2ah8t4NdNJiW8y3U3k88TslzMisnu9EoJSmfeTxacSgaGuwjtwYJsgcp/daRO3HyxhVIvrJC8dj
	r2EsITlndVL4YKYvukhFw1Nw6xHkvyOOwM/fj8b0xpeeGMfskqH7I0/KUD37FyUV8zeLj2QyuI7
	+pZUEkpLjXtfQwbQwVlMjQKqwjrFkuVduin9a+rHcvxXGM6Npn5605f7XGJnA90ofWyGDibaqW2
	4ARsKypq8D+b2PJ4Fl8qJ5Mv3PRyMptWwWW27ks+B87RSH0xqlSePE7MX1bovh3OBiRtkKaFrh9
	/zKx1wWQ8JUNdbwX0HUXWRequ++ldfk5uDt6Q7SQZMvQqd5rZ+tuJBL9E/UqonVdabHak=
X-Received: by 2002:a05:6830:6014:b0:7d9:b314:1452 with SMTP id 46e09a7af769-7dbb730994dmr15742965a34.7.1775676435577;
        Wed, 08 Apr 2026 12:27:15 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dbfc1cb79esm3359699a34.15.2026.04.08.12.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 12:27:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/tctx: clean up __io_uring_add_tctx_node() error handling
Date: Wed,  8 Apr 2026 13:24:08 -0600
Message-ID: <20260408192711.396827-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408192711.396827-1-axboe@kernel.dk>
References: <20260408192711.396827-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13004-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,kernel.dk:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F11683C3027
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Refactor __io_uring_add_tctx_node() so that on error it never leaves
current->io_uring pointing at a half-setup tctx. This moves the
assignment of current->io_uring to the end of the function post any
failure points.

Separate out the node installation into io_tctx_install_node() to
further clean this up.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/tctx.c | 60 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index e5cef6a8dde0..61533f30494f 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -108,10 +108,37 @@ __cold struct io_uring_task *io_uring_alloc_task_context(struct task_struct *tas
 	return tctx;
 }
 
+static int io_tctx_install_node(struct io_ring_ctx *ctx,
+				struct io_uring_task *tctx)
+{
+	struct io_tctx_node *node;
+	int ret;
+
+	if (xa_load(&tctx->xa, (unsigned long)ctx))
+		return 0;
+
+	node = kmalloc_obj(*node);
+	if (!node)
+		return -ENOMEM;
+	node->ctx = ctx;
+	node->task = current;
+
+	ret = xa_err(xa_store(&tctx->xa, (unsigned long)ctx,
+				node, GFP_KERNEL));
+	if (ret) {
+		kfree(node);
+		return ret;
+	}
+
+	mutex_lock(&ctx->tctx_lock);
+	list_add(&node->ctx_node, &ctx->tctx_list);
+	mutex_unlock(&ctx->tctx_lock);
+	return 0;
+}
+
 int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx = current->io_uring;
-	struct io_tctx_node *node;
 	int ret;
 
 	if (unlikely(!tctx)) {
@@ -119,14 +146,13 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 		if (IS_ERR(tctx))
 			return PTR_ERR(tctx);
 
-		current->io_uring = tctx;
 		if (ctx->int_flags & IO_RING_F_IOWQ_LIMITS_SET) {
 			unsigned int limits[2] = { ctx->iowq_limits[0],
 						   ctx->iowq_limits[1], };
 
 			ret = io_wq_max_workers(tctx->io_wq, limits);
 			if (ret)
-				return ret;
+				goto err_free;
 		}
 	}
 
@@ -137,25 +163,19 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 	 */
 	if (tctx->io_wq)
 		io_wq_set_exit_on_idle(tctx->io_wq, false);
-	if (!xa_load(&tctx->xa, (unsigned long)ctx)) {
-		node = kmalloc_obj(*node);
-		if (!node)
-			return -ENOMEM;
-		node->ctx = ctx;
-		node->task = current;
-
-		ret = xa_err(xa_store(&tctx->xa, (unsigned long)ctx,
-					node, GFP_KERNEL));
-		if (ret) {
-			kfree(node);
-			return ret;
-		}
 
-		mutex_lock(&ctx->tctx_lock);
-		list_add(&node->ctx_node, &ctx->tctx_list);
-		mutex_unlock(&ctx->tctx_lock);
+	ret = io_tctx_install_node(ctx, tctx);
+	if (!ret) {
+		current->io_uring = tctx;
+		return 0;
 	}
-	return 0;
+	if (!current->io_uring) {
+err_free:
+		io_wq_put_and_exit(tctx->io_wq);
+		percpu_counter_destroy(&tctx->inflight);
+		kfree(tctx);
+	}
+	return ret;
 }
 
 int __io_uring_add_tctx_node_from_submit(struct io_ring_ctx *ctx)
-- 
2.53.0


