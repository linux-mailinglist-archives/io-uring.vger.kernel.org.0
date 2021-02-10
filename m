Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7723A3169ED
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 16:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhBJPRf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 10:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbhBJPRO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Feb 2021 10:17:14 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B312C06178B
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 07:16:07 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id e7so2138131ile.7
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 07:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B26h7t5jOWGb4Al77/xqJVozxoNu1g70oR6Gt+u27Bc=;
        b=HqCgBLXp9O/V/Pxfway0/uJJrscHPAsl3zSIkkIHKnDjNgtYdCsYe/UXf5VN2+Fc9h
         KL4ztjjaPJHBGvxXXsf/bn50Iyf6CfN6R8YGUYoaYvDPmkl2xTkZDzoeeEbrbIgL6YvB
         DHvxx/l5QFgKpBYbHEg8nZJ+RFfFTx9pnC5YWR7NPS5fa32Cy/+MhzTRDhVyfcW8GwFQ
         6XZc6O6613q9HA7QckVYlRDSQ5gmPgsB2fwFk8HKuxVJEW/5+iqetzJmfVoduGIomm8+
         v8hYACnHsBlhtDwCSo0H2kYxejR0OtO4vf+C3miBJcdmnexdVdOxjQp99AmHF/smeyne
         kNhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B26h7t5jOWGb4Al77/xqJVozxoNu1g70oR6Gt+u27Bc=;
        b=G87GlbOvSvtwqOHb2NLtr7TVSGQHJvk50GHZNREcJVtLl0yJ99Kc5fO5Rom3twlm8s
         udAU0QUjw9SDHXN1WdPwJfpD+pgdH7kLQp7gLZ33/SX8tMBPT/fU4cuNtkFP7J6032Tx
         hOe4Enp40yIxRoouw1iu6cJYRFmlFf5LG9/DLSB4LT5UCX7EN3BAhEOdbQuqwrOlCTBM
         wXni5jb19I6JWcfaliT4MsEV1Oe7bL8O0jdzNaTiCQs5lW5ddelYmvorHwxRK5fDCrRk
         KIgtHJu6QrY62IYXNibi76jWnMSyPps0iJNs+Jqyevopbww/ZzUjb+StuWCK9K7LFisN
         JGpg==
X-Gm-Message-State: AOAM530qoqH5PsJA9nzaNqBrFWix15rpPWwTIBUqZfu217+92olDo4Ib
        HySMijJoiVLrfjTvXWFAyajuk14/Az531C4U
X-Google-Smtp-Source: ABdhPJy6VtoBL0Mbk9MiX1KSAnWz1PlxH5jaLbjlnlDoa0iOyur9ybQ5MhpyhHNI/Mwffs1Bkjb/hg==
X-Received: by 2002:a92:c941:: with SMTP id i1mr1514561ilq.258.1612970166774;
        Wed, 10 Feb 2021 07:16:06 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e23sm1027952ioc.34.2021.02.10.07.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 07:16:06 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: enable req cache for IRQ driven IO
Date:   Wed, 10 Feb 2021 08:16:02 -0700
Message-Id: <20210210151604.498311-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210210151604.498311-1-axboe@kernel.dk>
References: <20210210151604.498311-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is the last class of requests that cannot utilize the req alloc
cache. Add a per-ctx req cache that is protected by the completion_lock,
and refill our submit side cache when it gets over our batch count.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 71 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e73ca37c6a3b..2c7ff0b1b086 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -272,7 +272,11 @@ struct io_sq_data {
 struct io_comp_state {
 	struct io_kiocb		*reqs[IO_COMPL_BATCH];
 	unsigned int		nr;
+	unsigned int		locked_free_nr;
+	/* inline/task_work completion list, under ->uring_lock */
 	struct list_head	free_list;
+	/* IRQ completion list, under ->completion_lock */
+	struct list_head	locked_free_list;
 };
 
 struct io_submit_state {
@@ -1033,6 +1037,9 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req, int nr);
 static void io_double_put_req(struct io_kiocb *req);
+static void io_dismantle_req(struct io_kiocb *req);
+static void io_put_task(struct task_struct *task, int nr);
+static void io_queue_next(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void __io_queue_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
@@ -1353,6 +1360,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
 	init_llist_head(&ctx->rsrc_put_llist);
 	INIT_LIST_HEAD(&ctx->submit_state.comp.free_list);
+	INIT_LIST_HEAD(&ctx->submit_state.comp.locked_free_list);
 	return ctx;
 err:
 	kfree(ctx->cancel_hash);
@@ -1908,8 +1916,8 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 	__io_cqring_fill_event(req, res, 0);
 }
 
-static void io_req_complete_post(struct io_kiocb *req, long res,
-				 unsigned int cflags)
+static inline void io_req_complete_post(struct io_kiocb *req, long res,
+					unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
@@ -1917,16 +1925,26 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 	__io_cqring_fill_event(req, res, cflags);
 	io_commit_cqring(ctx);
+	/*
+	 * If we're the last reference to this request, add to our locked
+	 * free_list cache.
+	 */
+	if (refcount_dec_and_test(&req->refs)) {
+		struct io_comp_state *cs = &ctx->submit_state.comp;
+
+		io_dismantle_req(req);
+		io_put_task(req->task, 1);
+		list_add(&req->compl.list, &cs->locked_free_list);
+		cs->locked_free_nr++;
+	} else
+		req = NULL;
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	io_cqring_ev_posted(ctx);
-}
-
-static inline void io_req_complete_nostate(struct io_kiocb *req, long res,
-					   unsigned int cflags)
-{
-	io_req_complete_post(req, res, cflags);
-	io_put_req(req);
+	if (req) {
+		io_queue_next(req);
+		percpu_ref_put(&ctx->refs);
+	}
 }
 
 static void io_req_complete_state(struct io_kiocb *req, long res,
@@ -1944,7 +1962,7 @@ static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
 	if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 		io_req_complete_state(req, res, cflags);
 	else
-		io_req_complete_nostate(req, res, cflags);
+		io_req_complete_post(req, res, cflags);
 }
 
 static inline void io_req_complete(struct io_kiocb *req, long res)
@@ -1952,12 +1970,26 @@ static inline void io_req_complete(struct io_kiocb *req, long res)
 	__io_req_complete(req, 0, res, 0);
 }
 
-static bool io_flush_cached_reqs(struct io_submit_state *state)
+static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 {
+	struct io_submit_state *state = &ctx->submit_state;
+	struct io_comp_state *cs = &state->comp;
 	struct io_kiocb *req = NULL;
 
-	while (!list_empty(&state->comp.free_list)) {
-		req = list_first_entry(&state->comp.free_list, struct io_kiocb,
+	/*
+	 * If we have more than a batch's worth of requests in our IRQ side
+	 * locked cache, grab the lock and move them over to our submission
+	 * side cache.
+	 */
+	if (READ_ONCE(cs->locked_free_nr) > IO_COMPL_BATCH) {
+		spin_lock_irq(&ctx->completion_lock);
+		list_splice_init(&cs->locked_free_list, &cs->free_list);
+		cs->locked_free_nr = 0;
+		spin_unlock_irq(&ctx->completion_lock);
+	}
+
+	while (!list_empty(&cs->free_list)) {
+		req = list_first_entry(&cs->free_list, struct io_kiocb,
 					compl.list);
 		list_del(&req->compl.list);
 		state->reqs[state->free_reqs++] = req;
@@ -1978,7 +2010,7 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 		gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 		int ret;
 
-		if (io_flush_cached_reqs(state))
+		if (io_flush_cached_reqs(ctx))
 			goto got_req;
 
 		ret = kmem_cache_alloc_bulk(req_cachep, gfp, IO_REQ_ALLOC_BATCH,
@@ -8748,14 +8780,12 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 	idr_destroy(&ctx->io_buffer_idr);
 }
 
-static void io_req_cache_free(struct io_ring_ctx *ctx)
+static void io_req_cache_free(struct list_head *list)
 {
-	struct io_comp_state *cs = &ctx->submit_state.comp;
-
-	while (!list_empty(&cs->free_list)) {
+	while (!list_empty(list)) {
 		struct io_kiocb *req;
 
-		req = list_first_entry(&cs->free_list, struct io_kiocb, compl.list);
+		req = list_first_entry(list, struct io_kiocb, compl.list);
 		list_del(&req->compl.list);
 		kmem_cache_free(req_cachep, req);
 	}
@@ -8803,7 +8833,8 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	free_uid(ctx->user);
 	put_cred(ctx->creds);
 	kfree(ctx->cancel_hash);
-	io_req_cache_free(ctx);
+	io_req_cache_free(&ctx->submit_state.comp.free_list);
+	io_req_cache_free(&ctx->submit_state.comp.locked_free_list);
 	kfree(ctx);
 }
 
-- 
2.30.0

