Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46324A9B76
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 15:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359481AbiBDOv1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Feb 2022 09:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359473AbiBDOvZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Feb 2022 09:51:25 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB95C06173D
        for <io-uring@vger.kernel.org>; Fri,  4 Feb 2022 06:51:24 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id j16so11747169wrd.8
        for <io-uring@vger.kernel.org>; Fri, 04 Feb 2022 06:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CkttKNdOSNMa9Axq1SN1XcS0adDHYYOmAEpZi/phyh0=;
        b=bi6MmRZsaJ9wAqMcXzbH8GB8yzGcIBSVOEpMEEok/XSl55fs4Ye2g7KdINgMxb7ESt
         wgxKDplzu7nYqxkQ3mIv+iw3SqzTD/eXkhAxztY0aZiQL6laPj5c1mUfGBiBrgiKoxOa
         bjohi6ZSHoRhzizqMLp97D8ZJDIP5Ett5cu+knj19Flmoca0rsw0/UxknQ5W8fo9KtEF
         Bco1+HZitYEcd7sz0VZXX8R7/oPX7h/7Yk/ENXMaFnIB7ocMKBm4atek9pesScrL/OXK
         Sw32eL/+pOGzFxIsKjrNYWiC1ulTau+5mIKikg/1j2tQYy7LWwCsEOyXGNXjqUJyH9ja
         EtzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CkttKNdOSNMa9Axq1SN1XcS0adDHYYOmAEpZi/phyh0=;
        b=KXWN5RSudeNPIeYiJYK5joEagEDM8sWgVZWJsEKIBlWbj7CaBTHm7CCYfy1DIa/mn4
         VSLQmgxFuB1WTs7z5U6sEpYNv3YRdAxSc5o34EcbQPPlHjhYDX/p6Wex8cDF9Xicqvvh
         +oZs2Oqo1sQu1LA/retppdhoQPbgQ9mqQQP6xJ7MPpSZTazOcCtd2WZgLdM8VPrMH0/9
         V8WnTFWUneLjQ/nKYGUNJeOPV66qF/EEc9mh6EhWTfiFuc6rvJOOkkVllyAUWYQvAQvr
         yFfZfcFrEtXUgRFyTTVxScMZDc+ww+lYXIMzvuiEmMleR1WrmQp8p6dgi6n2axvGZ96E
         pb0A==
X-Gm-Message-State: AOAM5307FzOZsQeXeWMaaZz/S8mVfdKSr9htfQdhXpPyXoh4Twgc1whd
        y9RF/LfRSPSCgf71BSgg2OVI4398c0sCFQ==
X-Google-Smtp-Source: ABdhPJxZZPEf5Vk7WcRS6OgFDfREWzBw5sT237wVW8bTzerK0b/yN0C4AyFWZzfJMFxkhz2lOIuyTg==
X-Received: by 2002:adf:dfcf:: with SMTP id q15mr2772385wrn.276.1643986283443;
        Fri, 04 Feb 2022 06:51:23 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:e94c:d0f2:1084:a0d3])
        by smtp.gmail.com with ESMTPSA id c11sm2552898wri.43.2022.02.04.06.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 06:51:23 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v6 2/5] io_uring: avoid ring quiesce while registering/unregistering eventfd
Date:   Fri,  4 Feb 2022 14:51:14 +0000
Message-Id: <20220204145117.1186568-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220204145117.1186568-1-usama.arif@bytedance.com>
References: <20220204145117.1186568-1-usama.arif@bytedance.com>
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

The process of registering/unregistering eventfd is already done
under uring_lock so multiple threads won't enter a race condition while
registering/unregistering eventfd.

With the above approach ring quiesce can be avoided which is much more
expensive then using RCU lock. On the system tested, io_uring_reigster with
IORING_REGISTER_EVENTFD takes less than 1ms with RCU lock, compared to 15ms
before with ring quiesce.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c | 81 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 61 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 21531609a9c6..ad6361aeaca7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -326,6 +326,11 @@ struct io_submit_state {
 	struct blk_plug		plug;
 };
 
+struct io_ev_fd {
+	struct eventfd_ctx	*cq_ev_fd;
+	struct rcu_head		rcu;
+};
+
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
@@ -399,7 +404,7 @@ struct io_ring_ctx {
 	struct {
 		unsigned		cached_cq_tail;
 		unsigned		cq_entries;
-		struct eventfd_ctx	*cq_ev_fd;
+		struct io_ev_fd	__rcu	*io_ev_fd;
 		struct wait_queue_head	cq_wait;
 		unsigned		cq_extra;
 		atomic_t		cq_timeouts;
@@ -1726,13 +1731,32 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 	return &rings->cqes[tail & mask];
 }
 
-static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
+static void io_eventfd_signal(struct io_ring_ctx *ctx)
 {
-	if (likely(!ctx->cq_ev_fd))
-		return false;
+	struct io_ev_fd *ev_fd;
+
+	/* Return quickly if ctx->io_ev_fd doesn't exist */
+	if (likely(!rcu_dereference_raw(ctx->io_ev_fd)))
+		return;
+
+	rcu_read_lock();
+	/* rcu_dereference ctx->io_ev_fd once and use it for both for checking and eventfd_signal */
+	ev_fd = rcu_dereference(ctx->io_ev_fd);
+
+	/*
+	 * Check again if ev_fd exists incase an io_eventfd_unregister call completed between
+	 * the NULL check of ctx->io_ev_fd at the start of the function and rcu_read_lock.
+	 */
+	if (unlikely(!ev_fd))
+		goto out;
 	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
-		return false;
-	return !ctx->eventfd_async || io_wq_current_is_worker();
+		goto out;
+
+	if (!ctx->eventfd_async || io_wq_current_is_worker())
+		eventfd_signal(ev_fd->cq_ev_fd, 1);
+
+out:
+	rcu_read_unlock();
 }
 
 /*
@@ -1751,8 +1775,7 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 	 */
 	if (wq_has_sleeper(&ctx->cq_wait))
 		wake_up_all(&ctx->cq_wait);
-	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
+	io_eventfd_signal(ctx);
 }
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
@@ -1764,8 +1787,7 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 		if (waitqueue_active(&ctx->cq_wait))
 			wake_up_all(&ctx->cq_wait);
 	}
-	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
+	io_eventfd_signal(ctx);
 }
 
 /* Returns true if there are no backlogged entries after the flush */
@@ -9353,31 +9375,48 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 
 static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
 {
+	struct io_ev_fd *ev_fd;
 	__s32 __user *fds = arg;
-	int fd;
+	int fd, ret;
 
-	if (ctx->cq_ev_fd)
+	ev_fd = rcu_dereference_protected(ctx->io_ev_fd, lockdep_is_held(&ctx->uring_lock));
+	if (ev_fd)
 		return -EBUSY;
 
 	if (copy_from_user(&fd, fds, sizeof(*fds)))
 		return -EFAULT;
 
-	ctx->cq_ev_fd = eventfd_ctx_fdget(fd);
-	if (IS_ERR(ctx->cq_ev_fd)) {
-		int ret = PTR_ERR(ctx->cq_ev_fd);
+	ev_fd = kmalloc(sizeof(*ev_fd), GFP_KERNEL);
+	if (!ev_fd)
+		return -ENOMEM;
 
-		ctx->cq_ev_fd = NULL;
+	ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
+	if (IS_ERR(ev_fd->cq_ev_fd)) {
+		ret = PTR_ERR(ev_fd->cq_ev_fd);
+		kfree(ev_fd);
 		return ret;
 	}
 
-	return 0;
+	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
+	return ret;
+}
+
+static void io_eventfd_put(struct rcu_head *rcu)
+{
+	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
+
+	eventfd_ctx_put(ev_fd->cq_ev_fd);
+	kfree(ev_fd);
 }
 
 static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 {
-	if (ctx->cq_ev_fd) {
-		eventfd_ctx_put(ctx->cq_ev_fd);
-		ctx->cq_ev_fd = NULL;
+	struct io_ev_fd *ev_fd;
+
+	ev_fd = rcu_dereference_protected(ctx->io_ev_fd, lockdep_is_held(&ctx->uring_lock));
+	if (ev_fd) {
+		rcu_assign_pointer(ctx->io_ev_fd, NULL);
+		call_rcu(&ev_fd->rcu, io_eventfd_put);
 		return 0;
 	}
 
@@ -10960,6 +10999,8 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_REGISTER_FILES:
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
+	case IORING_REGISTER_EVENTFD:
+	case IORING_UNREGISTER_EVENTFD:
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
 	case IORING_UNREGISTER_PERSONALITY:
-- 
2.25.1

