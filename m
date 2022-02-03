Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396C54A8A51
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 18:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352966AbiBCRlQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 12:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352964AbiBCRlQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 12:41:16 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD803C06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 09:41:15 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m26so2668575wms.0
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 09:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aQIq64tbZTT3r2lCTTr4R6nk7XQ2BemxKkJ9jTfWYWY=;
        b=J9b3Mh2dhIqNB/LNgDXyEUo+TLMDSnIbwyIsvwGHbK21Tz9yzTQiFM88EIUzsDtnyw
         +kJIL+/UhIAEh12lAuaWX5nXKdl392Nay9xMHSMN8FWT3NVstd0zl2UJTnCUzgUG2Fmy
         fUJOyYZYBsT1EYfs5pN255zXG0DaCG57y55c53U4aBE1VsGXjEewIBrt2tb0WaZXLmrJ
         o4JUxew5KFCFSoMEgrc20fMp7LcGDet+FIrpdMM3AkYkNyMiZY3LBDV/DPRh6Wn99ADO
         j8WNjeNvIyaLLfYcHxX5EXNUywoCyCJnpzV64g43lDER990XZ2zi8yQLhK66Ab1u/m6l
         rMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aQIq64tbZTT3r2lCTTr4R6nk7XQ2BemxKkJ9jTfWYWY=;
        b=QnDjULyhi99je9ScP2ZjYJ8ZCIgzVF4G/2aMfaf+5nmoHQxYCV0ylmFSk94SDGJF3y
         e+W/GdQx+CtvSdQR8hTUI0fOGwMvQBYCDaDDyQoG3HOkT3b9v8UVcBNjxeS/IIG2W3if
         Il/+MMOVupe43Y7/LaYaEPdPraJJ4cRgMslqeHcY7jFUKAJhX7zHENalPVL+xu/5cLV2
         HDymUB6Kz3se1DV92LxPvIldrAwOvGXDtJP5ykh1A/usUi0bFN8bwMXwDXMFkXjldyIl
         Gv+tkaV7aUfCxb34mh5qcLO6JCdDTauj0+0wtE25HoD/Lgx+WSu9pOCwj4aJah40Xbhb
         TG3g==
X-Gm-Message-State: AOAM532BgG3arvmztwKD006s+v7oHy/XrlntDwO8oTW5mbez2OAVOUQY
        eEjWb46dVJ4zuPZbxmQwPv/LgvydQv4HMg==
X-Google-Smtp-Source: ABdhPJwZvfTpAjDtXMHfz+Tu1VG07UcHqWgt8rGdJH5n89L9VDk4GhL25DuWPfFzuC0OQb3pPCbGag==
X-Received: by 2002:a05:600c:3ac5:: with SMTP id d5mr10996921wms.107.1643910074221;
        Thu, 03 Feb 2022 09:41:14 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id r2sm10166178wmq.24.2022.02.03.09.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 09:41:13 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v3 2/3] io_uring: avoid ring quiesce while registering/unregistering eventfd
Date:   Thu,  3 Feb 2022 17:41:07 +0000
Message-Id: <20220203174108.668549-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220203174108.668549-1-usama.arif@bytedance.com>
References: <20220203174108.668549-1-usama.arif@bytedance.com>
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
 fs/io_uring.c | 91 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 66 insertions(+), 25 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 21531609a9c6..47d48020ae27 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -326,6 +326,10 @@ struct io_submit_state {
 	struct blk_plug		plug;
 };
 
+struct io_ev_fd {
+	struct eventfd_ctx	*cq_ev_fd;
+};
+
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
@@ -399,7 +403,8 @@ struct io_ring_ctx {
 	struct {
 		unsigned		cached_cq_tail;
 		unsigned		cq_entries;
-		struct eventfd_ctx	*cq_ev_fd;
+		struct io_ev_fd	__rcu	*io_ev_fd;
+		struct mutex		ev_fd_lock;
 		struct wait_queue_head	cq_wait;
 		unsigned		cq_extra;
 		atomic_t		cq_timeouts;
@@ -1448,6 +1453,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
+	mutex_init(&ctx->ev_fd_lock);
 	init_waitqueue_head(&ctx->cq_wait);
 	spin_lock_init(&ctx->completion_lock);
 	spin_lock_init(&ctx->timeout_lock);
@@ -1726,13 +1732,24 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 	return &rings->cqes[tail & mask];
 }
 
-static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
+static void io_eventfd_signal(struct io_ring_ctx *ctx)
 {
-	if (likely(!ctx->cq_ev_fd))
-		return false;
+	struct io_ev_fd *ev_fd;
+
+	rcu_read_lock();
+	/* rcu_dereference ctx->io_ev_fd once and use it for both for checking and eventfd_signal */
+	ev_fd = rcu_dereference(ctx->io_ev_fd);
+
+	if (likely(!ev_fd))
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
@@ -1751,8 +1768,7 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 	 */
 	if (wq_has_sleeper(&ctx->cq_wait))
 		wake_up_all(&ctx->cq_wait);
-	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
+	io_eventfd_signal(ctx);
 }
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
@@ -1764,8 +1780,7 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 		if (waitqueue_active(&ctx->cq_wait))
 			wake_up_all(&ctx->cq_wait);
 	}
-	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
+	io_eventfd_signal(ctx);
 }
 
 /* Returns true if there are no backlogged entries after the flush */
@@ -9353,35 +9368,59 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 
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
 
-	return 0;
+	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
+	ret = 0;
+
+out:
+	mutex_unlock(&ctx->ev_fd_lock);
+	return ret;
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
+	if (!ev_fd) {
+		ret = -ENXIO;
+		goto out;
 	}
+	synchronize_rcu();
+	eventfd_ctx_put(ev_fd->cq_ev_fd);
+	kfree(ev_fd);
+	rcu_assign_pointer(ctx->io_ev_fd, NULL);
+	ret = 0;
 
-	return -ENXIO;
+out:
+	mutex_unlock(&ctx->ev_fd_lock);
+	return ret;
 }
 
 static void io_destroy_buffers(struct io_ring_ctx *ctx)
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

