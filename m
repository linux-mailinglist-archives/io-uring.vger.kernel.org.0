Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026B54A8757
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 16:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351685AbiBCPMK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 10:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351686AbiBCPMI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 10:12:08 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4DAC06173E
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 07:12:07 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id l25so5589583wrb.13
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 07:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gKaSUfzNLWzc9S5eqkGES2e8+ihER08nmitDxKLwVSg=;
        b=TNKYCQA+wbXmtwOR4LwhYEKwX+qlhdU32yu7OhwgLShkj/f14e+F0aBbz7+mn8R5al
         S2Q/FsoNWbSEbjUXxIeMq6gMoTaZt6eSHM6jUaF/jXwHXhbqQh3lXjEvR5G5iY1MBMST
         iz0B3EFwYdtn9nNqvHJpwFPEkL7u5AJZLRN2NH1y15DRG8rA6ResRm6UMCG89l1VYjPR
         iI6/VTJcF1f5rAn+cZ/C30juXtdYppeNYdOywRuBCZcca1wijFUsR42dSvZsWmHP4D9I
         +upsbQmINcFeB4+Zz/PKGlI0atZH3HvivbbZEFvoptnScr2vI/m+G73PrYA928sjVDGh
         F4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gKaSUfzNLWzc9S5eqkGES2e8+ihER08nmitDxKLwVSg=;
        b=mVSJYEjVLMAeD0pDAAPrNlNLL8rrtuSMrN5CIxi+h6lAnmOXo1jIXN7Hnyrd4oigeY
         AcpnnUrPWsfJ1O3lqB/2yYAQ7vfB7lQbgOhTvopazSXeuSxgoYGyMFkHPVJyREpDZ43d
         ED8pjqZ0NdVqOamWN/FWX4dIVFLDmVR/Fy45pBA18Pm78xqKJwPdTp5gY1wI9WyAFpqm
         OxpCMU3YGmOJXuvL9T5EVv0jytUZtLT6vLx6lv5jLw0mW9C25fFZOl9L+4wpqtZpTlEe
         MzNhBIVWp6tE7iKmpYLnRlm3n2dQlCqfrATB4EkdVqCfQJvlrduM1lghUP/cbMTmv3jx
         1bfQ==
X-Gm-Message-State: AOAM533bbxdWx//Bho4JBQDrK3KWNmtGI2bO7LkofFj6IqO67dCJBJ/h
        /PGRrTdD4rnm/QHq4t1H4N3dXyi+yvWxow==
X-Google-Smtp-Source: ABdhPJxPOpL9BnOJQ+Xv6mJwZO0pm8dezDOrnwMvTSOpfbiMQygUPG3WHtzEUtmLozOKp1QlGY7BXg==
X-Received: by 2002:a5d:6d03:: with SMTP id e3mr29832138wrq.536.1643901126162;
        Thu, 03 Feb 2022 07:12:06 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id m14sm25793665wrp.4.2022.02.03.07.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 07:12:05 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH 1/2] io_uring: avoid ring quiesce while registering/unregistering eventfd
Date:   Thu,  3 Feb 2022 15:11:52 +0000
Message-Id: <20220203151153.574032-2-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220203151153.574032-1-usama.arif@bytedance.com>
References: <20220203151153.574032-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is done by creating a new RCU data structure (io_ev_fd) as part of
io_ring_ctx that holds the eventfd_ctx.

The function io_eventfd_signal is executed under rcu_read_lock with a
single rcu_dereference to io_ev_fd so that if another thread unregisters
the eventfd while io_eventfd_signal is still being executed, the
eventfd_signal for which io_eventfd_signal was called completes
successfully.

The process of registering/unregistering eventfd is done under a lock
so multiple threads don't enter a race condition while
registering/unregistering eventfd.

With the above approach ring quiesce can be avoided which is much more
expensive then using RCU lock. On the system tested, io_uring_reigster with
IORING_REGISTER_EVENTFD takes less than 1ms with RCU lock, compared to 15ms
before with ring quiesce.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c | 103 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 80 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e04f718319d..f07cfbb387a6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -326,6 +326,12 @@ struct io_submit_state {
 	struct blk_plug		plug;
 };
 
+struct io_ev_fd {
+	struct eventfd_ctx	*cq_ev_fd;
+	struct io_ring_ctx	*ctx;
+	struct rcu_head		rcu;
+};
+
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
@@ -399,7 +405,8 @@ struct io_ring_ctx {
 	struct {
 		unsigned		cached_cq_tail;
 		unsigned		cq_entries;
-		struct eventfd_ctx	*cq_ev_fd;
+		struct io_ev_fd	__rcu	*io_ev_fd;
+		struct mutex		ev_fd_lock;
 		struct wait_queue_head	cq_wait;
 		unsigned		cq_extra;
 		atomic_t		cq_timeouts;
@@ -1448,6 +1455,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
+	mutex_init(&ctx->ev_fd_lock);
 	init_waitqueue_head(&ctx->cq_wait);
 	spin_lock_init(&ctx->completion_lock);
 	spin_lock_init(&ctx->timeout_lock);
@@ -1726,15 +1734,30 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 	return &rings->cqes[tail & mask];
 }
 
-static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
+static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx, struct io_ev_fd *ev_fd)
 {
-	if (likely(!ctx->cq_ev_fd))
+	if (likely(!ev_fd))
 		return false;
 	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
 		return false;
 	return !ctx->eventfd_async || io_wq_current_is_worker();
 }
 
+static void io_eventfd_signal(struct io_ring_ctx *ctx)
+{
+	struct io_ev_fd *ev_fd;
+
+	rcu_read_lock();
+	ev_fd = rcu_dereference(ctx->io_ev_fd);
+
+	if (!io_should_trigger_evfd(ctx, ev_fd))
+		goto out;
+
+	eventfd_signal(ev_fd->cq_ev_fd, 1);
+out:
+	rcu_read_unlock();
+}
+
 /*
  * This should only get called when at least one event has been posted.
  * Some applications rely on the eventfd notification count only changing
@@ -1751,8 +1774,7 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 	 */
 	if (wq_has_sleeper(&ctx->cq_wait))
 		wake_up_all(&ctx->cq_wait);
-	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
+	io_eventfd_signal(ctx);
 }
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
@@ -1764,8 +1786,7 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 		if (waitqueue_active(&ctx->cq_wait))
 			wake_up_all(&ctx->cq_wait);
 	}
-	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
+	io_eventfd_signal(ctx);
 }
 
 /* Returns true if there are no backlogged entries after the flush */
@@ -9353,35 +9374,67 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 
 static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
 {
+	struct io_ev_fd *ev_fd;
 	__s32 __user *fds = arg;
-	int fd;
+	int fd, ret;
 
-	if (ctx->cq_ev_fd)
-		return -EBUSY;
+	mutex_lock(&ctx->ev_fd_lock);
+	ret = -EBUSY;
+	if (rcu_dereference_protected(ctx->io_ev_fd, lockdep_is_held(&ctx->ev_fd_lock)))
+		goto out;
 
+	ret = -EFAULT;
 	if (copy_from_user(&fd, fds, sizeof(*fds)))
-		return -EFAULT;
+		goto out;
 
-	ctx->cq_ev_fd = eventfd_ctx_fdget(fd);
-	if (IS_ERR(ctx->cq_ev_fd)) {
-		int ret = PTR_ERR(ctx->cq_ev_fd);
+	ret = -ENOMEM;
+	ev_fd = kmalloc(sizeof(*ev_fd), GFP_KERNEL);
+	if (!ev_fd)
+		goto out;
 
-		ctx->cq_ev_fd = NULL;
-		return ret;
+	ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
+	if (IS_ERR(ev_fd->cq_ev_fd)) {
+		ret = PTR_ERR(ev_fd->cq_ev_fd);
+		kfree(ev_fd);
+		goto out;
 	}
+	ev_fd->ctx = ctx;
 
-	return 0;
+	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
+	ret = 0;
+
+out:
+	mutex_unlock(&ctx->ev_fd_lock);
+	return ret;
+}
+
+static void io_eventfd_put(struct rcu_head *rcu)
+{
+	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
+	struct io_ring_ctx *ctx = ev_fd->ctx;
+
+	eventfd_ctx_put(ev_fd->cq_ev_fd);
+	kfree(ev_fd);
+	rcu_assign_pointer(ctx->io_ev_fd, NULL);
 }
 
 static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 {
-	if (ctx->cq_ev_fd) {
-		eventfd_ctx_put(ctx->cq_ev_fd);
-		ctx->cq_ev_fd = NULL;
-		return 0;
+	struct io_ev_fd *ev_fd;
+	int ret;
+
+	mutex_lock(&ctx->ev_fd_lock);
+	ev_fd = rcu_dereference_protected(ctx->io_ev_fd, lockdep_is_held(&ctx->ev_fd_lock));
+	if (ev_fd) {
+		call_rcu(&ev_fd->rcu, io_eventfd_put);
+		ret = 0;
+		goto out;
 	}
+	ret = -ENXIO;
 
-	return -ENXIO;
+out:
+	mutex_unlock(&ctx->ev_fd_lock);
+	return ret;
 }
 
 static void io_destroy_buffers(struct io_ring_ctx *ctx)
@@ -10960,6 +11013,8 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_REGISTER_FILES:
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
+	case IORING_REGISTER_EVENTFD:
+	case IORING_UNREGISTER_EVENTFD:
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
 	case IORING_UNREGISTER_PERSONALITY:
@@ -11171,8 +11226,10 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	mutex_lock(&ctx->uring_lock);
 	ret = __io_uring_register(ctx, opcode, arg, nr_args);
 	mutex_unlock(&ctx->uring_lock);
+	rcu_read_lock();
 	trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs,
-							ctx->cq_ev_fd != NULL, ret);
+				rcu_dereference(ctx->io_ev_fd) != NULL, ret);
+	rcu_read_unlock();
 out_fput:
 	fdput(f);
 	return ret;
-- 
2.25.1

