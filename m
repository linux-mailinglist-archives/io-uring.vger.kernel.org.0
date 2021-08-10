Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871BD3E7D9B
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 18:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbhHJQiE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 12:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236115AbhHJQiB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 12:38:01 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9256C0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 09:37:38 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j1so33957894pjv.3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 09:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nUusjBFV2Ut14q88MJK3xVKl638mI0IgVxCmF/I/S6k=;
        b=Wh25/k31+kzXFclORNbK6cXS74VgMUgxByrbFPA4s9ybamXipCciz7wlOtrSii1029
         tzgEJXR0r2xtpbPELxrq6hCsxw9/WnlI9Z0/7MGf38vI/snEh+KSuYBmxsEJGKfe0w/d
         6GXZSU0OnUw4/h+8C9s8EW1pyHpyGp3EIkzpZoX0dUGZSnjtMUrFS4quXPj3XL3ilMP8
         EhzhnejJt/uxBMb4bJyOyMnjGigrORMaZy3VrwxUS2j0Q/rMYXPB+bgY5wes2LH9XLk3
         is7KcGoALG8psoYzEVl1p8TiemU7I0jBzmzv3dc6rke2LoiYEk91X2X9uLuyF7qonylg
         J49Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nUusjBFV2Ut14q88MJK3xVKl638mI0IgVxCmF/I/S6k=;
        b=epvv4+K7pa0xSTyjKsfDmrZo/QX4xJQkP5kPmf8CVeLp49iRMiYKfxcaAC0B4iYPOh
         yrdQNegLOkEdm53VgAUE9AwdFBnyzSMcmPVApava2DdMdVzRZbexmCNaDPo3qntfJDES
         ngVD0vws89krebCu8sC/EezKUVgA/16k9pczWo6peu8rdh/MlghroLEfvKazeRnYN70P
         a1l1nGgQS/eEvCrX9gxiGdWrdjXPH4sBiwnPbstTxODknewOsR7JZNczc8qfrhDQfoR9
         05ifU+FGj6OFxVwMFn0Qgs1w15ae80bTDwRV/CEynihrzRKe28lFCubAmQzkhAu1eU67
         2VQw==
X-Gm-Message-State: AOAM533Cdkc4cP7gD5GT6/ZedfqpsmW2e0ZJS89R2L1dNMm8hxIZXwFN
        3jRUbtZXWD8prNt/JISAr6IXUuP5WCVbbpZq
X-Google-Smtp-Source: ABdhPJz6EnWJULoDCnsAOC2eoRGFiZOXlB8kx3xaMYb9GI8AH3orG2T2vrRgIuA4EVQAlGw141Pfjg==
X-Received: by 2002:a65:434c:: with SMTP id k12mr508920pgq.17.1628613458248;
        Tue, 10 Aug 2021 09:37:38 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id pi14sm3517744pjb.38.2021.08.10.09.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 09:37:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: wire up bio allocation cache
Date:   Tue, 10 Aug 2021 10:37:27 -0600
Message-Id: <20210810163728.265939-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810163728.265939-1-axboe@kernel.dk>
References: <20210810163728.265939-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Initialize a bio allocation cache, and mark it as being used for
IOPOLL. We could use it for non-polled IO as well, but it'd need some
locking and probably would negate much of the win in that case.

We start with IOPOLL, as completions are locked by the ctx lock anyway.
So no further locking is needed there.

This brings an IOPOLL gen2 Optane QD=128 workload from ~3.0M IOPS to
~3.3M IOPS.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f35b54f016f3..60316cfc712a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -324,6 +324,10 @@ struct io_submit_state {
 	/* inline/task_work completion list, under ->uring_lock */
 	struct list_head	free_list;
 
+#ifdef CONFIG_BLOCK
+	struct bio_alloc_cache	bio_cache;
+#endif
+
 	/*
 	 * File reference cache
 	 */
@@ -1201,6 +1205,9 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_llist_head(&ctx->rsrc_put_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	INIT_LIST_HEAD(&ctx->submit_state.free_list);
+#ifdef CONFIG_BLOCK
+	bio_alloc_cache_init(&ctx->submit_state.bio_cache);
+#endif
 	INIT_LIST_HEAD(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	return ctx;
@@ -2267,6 +2274,8 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (READ_ONCE(req->result) == -EAGAIN && resubmit &&
 		    !(req->flags & REQ_F_DONT_REISSUE)) {
 			req->iopoll_completed = 0;
+			/* Don't use cache for async retry, not locking safe */
+			req->rw.kiocb.ki_flags &= ~IOCB_ALLOC_CACHE;
 			req_ref_get(req);
 			io_req_task_queue_reissue(req);
 			continue;
@@ -2684,6 +2693,31 @@ static inline __u64 ptr_to_u64(void *ptr)
 	return (__u64)(unsigned long)ptr;
 }
 
+static void io_mark_alloc_cache(struct io_kiocb *req)
+{
+#ifdef CONFIG_BLOCK
+	struct kiocb *kiocb = &req->rw.kiocb;
+	struct block_device *bdev = NULL;
+
+	if (S_ISBLK(file_inode(kiocb->ki_filp)->i_mode))
+		bdev = I_BDEV(kiocb->ki_filp->f_mapping->host);
+	else if (S_ISREG(file_inode(kiocb->ki_filp)->i_mode))
+		bdev = kiocb->ki_filp->f_inode->i_sb->s_bdev;
+
+	/*
+	 * If the lower level device doesn't support polled IO, then
+	 * we cannot safely use the alloc cache. This really should
+	 * be a failure case for polled IO...
+	 */
+	if (!bdev ||
+	    !test_bit(QUEUE_FLAG_POLL, &bdev_get_queue(bdev)->queue_flags))
+		return;
+
+	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
+	kiocb->ki_bio_cache = &req->ctx->submit_state.bio_cache;
+#endif /* CONFIG_BLOCK */
+}
+
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -2726,6 +2760,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			return -EOPNOTSUPP;
 
 		kiocb->ki_flags |= IOCB_HIPRI;
+		io_mark_alloc_cache(req);
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
 	} else {
@@ -2792,6 +2827,8 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 	if (check_reissue && (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req)) {
+			/* Don't use cache for async retry, not locking safe */
+			req->rw.kiocb.ki_flags &= ~IOCB_ALLOC_CACHE;
 			req_ref_get(req);
 			io_req_task_queue_reissue(req);
 		} else {
@@ -8640,6 +8677,9 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 		state->free_reqs = 0;
 	}
 
+#ifdef CONFIG_BLOCK
+	bio_alloc_cache_destroy(&state->bio_cache);
+#endif
 	io_flush_cached_locked_reqs(ctx, state);
 	io_req_cache_free(&state->free_list);
 	mutex_unlock(&ctx->uring_lock);
-- 
2.32.0

