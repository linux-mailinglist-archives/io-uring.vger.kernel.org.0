Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0FE4DBCDB
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 03:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358437AbiCQCGX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 22:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358429AbiCQCGV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 22:06:21 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD14E1EADC
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:05:04 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id x34so3715749ede.8
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NoeMbX4Af/Bfgj1WiGU6ZJdzhmz6PcoQioQgR1LSgDY=;
        b=BjH0NOtnrvjOegUnFAD+et3cX5BkUXizLF52QH6kWSMYsfkVWaSW3SaffcS+WQfECv
         D3Rbxu5AJ37Sf0dzPxBaxPuAno70kr/4OV0F3A8e8B8DTV6izCkrsTpW2Ix1QJrwRXw2
         9STM382LkeYoaIljqMo5NycbXnwHsJZbBQdDlBnwDY+bpWIAxE1nV0BuGHwedUBoF7uN
         PEoCEckasgu3IJxO+jIKp1ZvSs6sD7cXP5I5ftBot7xOBhgP3ymD7piHPV4zT39vMk6/
         ugNA7JppzYlDNSKgEmwFBhTGsA956YnhrvHmlUt/sNJRFPyPHpxDvcp/SpgirTUtnZMT
         kROQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NoeMbX4Af/Bfgj1WiGU6ZJdzhmz6PcoQioQgR1LSgDY=;
        b=6U7aGLRqIefB9nEbEmBT8l7GRtH/wytetiMEAIayXNQrSh4L+cWKQKLDWPq85OKFw/
         AsgbgDvYW8CLNQ6Yms+BPzO1DxnCLLhCbwMh7iFJ/CUZckY+xQRcTIqVF2oqShQOzXfp
         9BcMweNoGArJa+oL/uDtP4Kdjjmi5KZOlTeEHdhdZDYsmTCiifnbm+JhDiWBGXcnEhYQ
         9/XmLH+QTEleyHTyeYcuOa6w2ijkaqwehEqetq74I0P7xn+qkzwNoYdLokyauXNcd2H4
         fESEwvH8O2QW7RqEMf443M4fb0HW/u8F/wr9LQDjn4nIFqTk0bo6HuJn0wjrrTwJ0XI3
         3A1w==
X-Gm-Message-State: AOAM531KmR4Kbqm604tgCcWWLl+SV8vQlLDV08+VB3WoM9yoG0/Qi+N2
        RsGSj0WbaFQEiPXGHPA3iXUUtwxQ8t081g==
X-Google-Smtp-Source: ABdhPJyL0p4YyiEUPCOvb0qxn1avyJrKwnTXXiTvCygdYzbPPU0SiBCCbUAlrL4626OzMG8Htlim8w==
X-Received: by 2002:aa7:c64d:0:b0:415:eb27:4 with SMTP id z13-20020aa7c64d000000b00415eb270004mr2109416edr.365.1647482703014;
        Wed, 16 Mar 2022 19:05:03 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.67])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7df9a000000b00416b3005c4bsm1876048edy.46.2022.03.16.19.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 19:05:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 7/7] io_uring: fold evfd signalling under a slower path
Date:   Thu, 17 Mar 2022 02:03:42 +0000
Message-Id: <f6168471997decded475a063f92915787975a30b.1647481208.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647481208.git.asml.silence@gmail.com>
References: <cover.1647481208.git.asml.silence@gmail.com>
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

Add ->has_evfd flag, which is true IFF there is an eventfd attached, and
use it to hide io_eventfd_signal() into __io_commit_cqring_flush() and
combine fast checks in a single if. Also, gcc 11.2 wasn't inlining
io_cqring_ev_posted() without this change, so helps with that as well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 60 +++++++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 26 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c75a5767f58d..c026a90a8bd3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -347,6 +347,7 @@ struct io_ring_ctx {
 		unsigned int		off_timeout_used: 1;
 		unsigned int		drain_active: 1;
 		unsigned int		drain_disabled: 1;
+		unsigned int		has_evfd: 1;
 	} ____cacheline_aligned_in_smp;
 
 	/* submission data */
@@ -1174,6 +1175,7 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
 
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
+static void io_eventfd_signal(struct io_ring_ctx *ctx);
 
 static struct kmem_cache *req_cachep;
 
@@ -1777,15 +1779,19 @@ static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
 }
 
-static __cold void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
+static void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
-	spin_lock(&ctx->completion_lock);
-	if (ctx->off_timeout_used)
-		io_flush_timeouts(ctx);
-	if (ctx->drain_active)
-		io_queue_deferred(ctx);
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
+	if (ctx->off_timeout_used || ctx->drain_active) {
+		spin_lock(&ctx->completion_lock);
+		if (ctx->off_timeout_used)
+			io_flush_timeouts(ctx);
+		if (ctx->drain_active)
+			io_queue_deferred(ctx);
+		io_commit_cqring(ctx);
+		spin_unlock(&ctx->completion_lock);
+	}
+	if (ctx->has_evfd)
+		io_eventfd_signal(ctx);
 }
 
 static inline bool io_sqring_full(struct io_ring_ctx *ctx)
@@ -1844,6 +1850,17 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 	rcu_read_unlock();
 }
 
+static inline void io_cqring_wake(struct io_ring_ctx *ctx)
+{
+	/*
+	 * wake_up_all() may seem excessive, but io_wake_function() and
+	 * io_should_wake() handle the termination of the loop and only
+	 * wake as many waiters as we need to.
+	 */
+	if (wq_has_sleeper(&ctx->cq_wait))
+		wake_up_all(&ctx->cq_wait);
+}
+
 /*
  * This should only get called when at least one event has been posted.
  * Some applications rely on the eventfd notification count only changing
@@ -1853,31 +1870,21 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
  */
 static inline void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
-	if (unlikely(ctx->off_timeout_used || ctx->drain_active))
+	if (unlikely(ctx->off_timeout_used || ctx->drain_active ||
+		     ctx->has_evfd))
 		__io_commit_cqring_flush(ctx);
 
-	/*
-	 * wake_up_all() may seem excessive, but io_wake_function() and
-	 * io_should_wake() handle the termination of the loop and only
-	 * wake as many waiters as we need to.
-	 */
-	if (wq_has_sleeper(&ctx->cq_wait))
-		wake_up_all(&ctx->cq_wait);
-	if (unlikely(rcu_dereference_raw(ctx->io_ev_fd)))
-		io_eventfd_signal(ctx);
+	io_cqring_wake(ctx);
 }
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 {
-	if (unlikely(ctx->off_timeout_used || ctx->drain_active))
+	if (unlikely(ctx->off_timeout_used || ctx->drain_active ||
+		     ctx->has_evfd))
 		__io_commit_cqring_flush(ctx);
 
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		if (wq_has_sleeper(&ctx->cq_wait))
-			wake_up_all(&ctx->cq_wait);
-	}
-	if (unlikely(rcu_dereference_raw(ctx->io_ev_fd)))
-		io_eventfd_signal(ctx);
+	if (ctx->flags & IORING_SETUP_SQPOLL)
+		io_cqring_wake(ctx);
 }
 
 /* Returns true if there are no backlogged entries after the flush */
@@ -9859,7 +9866,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 	ev_fd->eventfd_async = eventfd_async;
-
+	ctx->has_evfd = true;
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
 	return 0;
 }
@@ -9879,6 +9886,7 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
 					lockdep_is_held(&ctx->uring_lock));
 	if (ev_fd) {
+		ctx->has_evfd = false;
 		rcu_assign_pointer(ctx->io_ev_fd, NULL);
 		call_rcu(&ev_fd->rcu, io_eventfd_put);
 		return 0;
-- 
2.35.1

