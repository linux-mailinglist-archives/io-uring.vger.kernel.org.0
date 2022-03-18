Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD014DDAFD
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 14:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbiCRNzN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 09:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236901AbiCRNzL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 09:55:11 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A669019235B
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 06:53:52 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id b19so11820392wrh.11
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 06:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9MjbrP27hKSL+6kpvYfxEYKVlkSriQbA6Ma4JP5m5pg=;
        b=K4g5Z5bCs0xFUeP9nbMkKUDtdzsUaomCKPiQ7i/epYcaiEswSMVQFFgXd1S70L6KBm
         BzfI4nAaBmGKqnyOaJqBwWGpOc1qvfDDQVr9RwQnUYKRF/NL17mHwVaFLaiZLDCYx/BG
         +rbyk2rGYHxVK4zZuoT1t8AoGn5a45423VaOQT1WPWva2EcZ7KFO0AfsuSlD0DHD1eEd
         D1q2jcbU5lTinUPoDN4LBeOjP5gnmjn69TrJDWMeZRvwDHkGBDbAY+C12qTwtStuz9Jg
         s8MXs+4EikAfnyrtawe/pFtrGHn5hvIwRRh/itoI0Mx+wm7OZ9pvt44f2QJrvWYiMO5n
         /nag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9MjbrP27hKSL+6kpvYfxEYKVlkSriQbA6Ma4JP5m5pg=;
        b=V2ksyQIVswPNRA9FWNvfj2mLNbUsriYSb94ebIg3SgfyNP6x8o45DswgQPNqJH9bn6
         s6km5r3PVGtXim8WkOaJARjIA4DHEj3jmCVzWP0wheWUHgS5Lj/gycG9u16Zhgi7W+FX
         xAypYA3fI6F5JOm5YQmLXdyZdcgUU4GwkKC12kP+So38jy0IDm+/bijCuEcpL6//jK/o
         i0ygzx6iaXIc/jAd/MUs5xho74R8yiPDRv7KbhqXst+lnscngVd59j/Db55jJG6UPYOn
         h75sKIRmo+I9kc25V3af6D74Gn4aq98k5TQOjMplIbY8Nf2Idlfna0zlUNFXmV9ygegn
         bQuQ==
X-Gm-Message-State: AOAM533OsvHfO5qYDZaOC7I57n41Wc5sBCKTATf/BR/WxzRh0x+lfGhV
        4orn+CK23BF6i2MPUB5yAJSZTpkIHiGn9w==
X-Google-Smtp-Source: ABdhPJyESyAr62x91KDj1JE4AFNUqfrV6rE1HUauM3H+XbJERUa3pSjNWYnHVZZlf6Zs/VOyF0dDog==
X-Received: by 2002:adf:f20e:0:b0:1f0:7673:be2f with SMTP id p14-20020adff20e000000b001f07673be2fmr8167635wro.19.1647611630857;
        Fri, 18 Mar 2022 06:53:50 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.70])
        by smtp.gmail.com with ESMTPSA id j8-20020a05600c1c0800b0038c8da4d9b8sm1290375wms.30.2022.03.18.06.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 06:53:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/4] io_uring: optimise compl locking for non-shared rings
Date:   Fri, 18 Mar 2022 13:52:23 +0000
Message-Id: <9c91a7dc445420230f7936d7f913eb212c1c07a3.1647610155.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647610155.git.asml.silence@gmail.com>
References: <cover.1647610155.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When only one task submits requests, most of CQEs are expected to be
filled from that task context so we have natural serialisation. That
would mean that in those cases we don't need spinlocking around CQE
posting. One downside is that it also mean that io-wq workers can't emit
CQEs directly but should do it through the original task context using
task_works. That may hurt latency and performance and might matter much
to some workloads, but it's not a huge deal in general as io-wq is a
slow path and there is some additional merit from tw completion
batching.

The feature should be opted-in by the userspace by setting a new
IORING_SETUP_PRIVATE_CQ flag. It doesn't work with IOPOLL, and also for
now only the task that created a ring can submit requests to it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 61 +++++++++++++++++++++++++++++++----
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5f895ad910b6..52a15b29f6e4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2109,6 +2109,12 @@ static void io_req_complete_post(struct io_kiocb *req, s32 res,
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	/* todo cflags */
+	if (ctx->flags & IORING_SETUP_PRIVATE_CQ) {
+		io_req_tw_queue_complete(req, res);
+		return;
+	}
+
 	spin_lock(&ctx->completion_lock);
 	__io_req_complete_post(req, res, cflags);
 	io_commit_cqring(ctx);
@@ -2593,8 +2599,14 @@ static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 		io_req_complete_state(req, res, io_put_kbuf(req, 0));
 		io_req_add_compl_list(req);
 	} else {
-		io_req_complete_post(req, res,
+		struct io_ring_ctx *ctx = req->ctx;
+
+		spin_lock(&ctx->completion_lock);
+		__io_req_complete_post(req, res,
 					io_put_kbuf(req, IO_URING_F_UNLOCKED));
+		io_commit_cqring(ctx);
+		spin_unlock(&ctx->completion_lock);
+		io_cqring_ev_posted(ctx);
 	}
 }
 
@@ -2686,7 +2698,9 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 
 	if (state->flush_cqes) {
-		spin_lock(&ctx->completion_lock);
+		if (!(ctx->flags & IORING_SETUP_PRIVATE_CQ))
+			spin_lock(&ctx->completion_lock);
+
 		wq_list_for_each(node, prev, &state->compl_reqs) {
 			struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
@@ -2705,7 +2719,9 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		}
 
 		io_commit_cqring(ctx);
-		spin_unlock(&ctx->completion_lock);
+		if (!(ctx->flags & IORING_SETUP_PRIVATE_CQ))
+			spin_unlock(&ctx->completion_lock);
+
 		io_cqring_ev_posted(ctx);
 		state->flush_cqes = false;
 	}
@@ -5895,8 +5911,10 @@ static int io_poll_check_events(struct io_kiocb *req)
 	int v;
 
 	/* req->task == current here, checking PF_EXITING is safe */
-	if (unlikely(req->task->flags & PF_EXITING))
+	if (unlikely(req->task->flags & PF_EXITING)) {
 		io_poll_mark_cancelled(req);
+		return -ECANCELED;
+	}
 
 	do {
 		v = atomic_read(&req->poll_refs);
@@ -9165,6 +9183,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	unsigned int done;
 	bool needs_switch = false;
 
+	if (tags && (ctx->flags & IORING_SETUP_PRIVATE_CQ))
+		return -EINVAL;
 	if (!ctx->file_data)
 		return -ENXIO;
 	if (up->offset + nr_args > ctx->nr_user_files)
@@ -9845,6 +9865,9 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 	__u32 done;
 	int i, err;
 
+	if (tags && (ctx->flags & IORING_SETUP_PRIVATE_CQ))
+		return -EINVAL;
+
 	if (!ctx->buf_data)
 		return -ENXIO;
 	if (up->offset + nr_args > ctx->nr_user_bufs)
@@ -10389,6 +10412,23 @@ static __cold void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	}
 }
 
+static __cold int io_uring_check_ctxs(struct io_ring_ctx *ctx)
+{
+	int nr_tctxs = 0, max_tctxs = 1;
+	struct list_head *pos;
+
+	if (!(ctx->flags & IORING_SETUP_PRIVATE_CQ))
+		return 0;
+
+	if (ctx->flags & IORING_SETUP_IOPOLL)
+		return -EINVAL;
+	if (ctx->flags & IORING_SETUP_SQPOLL)
+		max_tctxs++;
+	list_for_each(pos, &ctx->tctx_list)
+		nr_tctxs++;
+	return nr_tctxs < max_tctxs ? 0 : -EINVAL;
+}
+
 static int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx = current->io_uring;
@@ -10417,14 +10457,18 @@ static int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 		node->ctx = ctx;
 		node->task = current;
 
-		ret = xa_err(xa_store(&tctx->xa, (unsigned long)ctx,
+		mutex_lock(&ctx->uring_lock);
+		ret = io_uring_check_ctxs(ctx);
+		if (!ret) {
+			ret = xa_err(xa_store(&tctx->xa, (unsigned long)ctx,
 					node, GFP_KERNEL));
+		}
 		if (ret) {
 			kfree(node);
+			mutex_unlock(&ctx->uring_lock);
 			return ret;
 		}
 
-		mutex_lock(&ctx->uring_lock);
 		list_add(&node->ctx_node, &ctx->tctx_list);
 		mutex_unlock(&ctx->uring_lock);
 	}
@@ -11349,7 +11393,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL))
+			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
+			IORING_SETUP_PRIVATE_CQ))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
@@ -11561,6 +11606,8 @@ static __cold int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 	/* keep it extendible */
 	if (size != sizeof(rr))
 		return -EINVAL;
+	if (rr.tags && (ctx->flags & IORING_SETUP_PRIVATE_CQ))
+		return -EINVAL;
 
 	memset(&rr, 0, sizeof(rr));
 	if (copy_from_user(&rr, arg, size))
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d2be4eb22008..342fab169b83 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -102,6 +102,7 @@ enum {
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 #define IORING_SETUP_SUBMIT_ALL	(1U << 7)	/* continue submit on error */
+#define IORING_SETUP_PRIVATE_CQ	(1U << 8)
 
 enum {
 	IORING_OP_NOP,
-- 
2.35.1

