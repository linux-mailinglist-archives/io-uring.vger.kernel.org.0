Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D205813D1
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 15:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238591AbiGZNG7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 09:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238614AbiGZNG6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 09:06:58 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A727325587
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 06:06:44 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id k12so2340005wrm.13
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 06:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WsVYZGFpjz88FNa+KzUdOaBIHWTb7FdRdEf4ZSbcdiY=;
        b=k2ZVulBtf4MfMdsag7hzmjLwgNopcjZlO6Vte1ERW3/mloAN18SPeKFnxPoiVqVF7S
         frREtiPSehOAw/+h1ikr6a0R9CrahanLVLL6xu7XTWsH7LyKaVn2etCFkuzhhvbPKaye
         N91konYNbukBfFoCGgUZzP9gFlIYyxn7jPQ5OKVtI/wXoyvm2QN1XyQZ8pdvKNVkKbqL
         3zPMqqMZsIuusIFaqIxahx6gFj3gekkH+TQ+MF/0YA1HwrHm3WyWiGuwRZrqzQf98VHh
         U1C+S5tHf+DRqX1n/rScjNZmdDF4DKoBqA+kCtiOuEzL2gUjaS6g2c3wwEK3JjWaq67p
         M/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WsVYZGFpjz88FNa+KzUdOaBIHWTb7FdRdEf4ZSbcdiY=;
        b=6jdG3/n8ngdsNng2A6WUyyg59j5esq1eII9+PB52OlMfRup6ila2XtPEHklzCFZ6q5
         SptOPQO6S435DsCrnHxurnw8iC8rDxibYWYr/HenBzIZSvcqkLs6YsUGAu+8qArnSnVs
         u5MGfLUBjUmo0LGw8ynLuKd5D2dgChXHah5wdampOH6DjKY1X8LeHClk3gqWOCOR7sBO
         87RyqQj0Fwh0uBXUPMoAnjQY7dyyZNHyOoUIwyg0hAlBirLGaq6PFScE4OnKentTbFT+
         iilMoSz7UUZunyw0kUrwrbLH58glbf62mdiaPu9hhO89pH1Nmv85Yuqtc9DkDtMPotOv
         /h+w==
X-Gm-Message-State: AJIora9ym7RwHevaq76fdb9zhxJlKDC/pDmqMXuSQzDT4Vc/Ghk3YLHF
        2Wm8nb+GI8dH/M1lpALp5r0HrmUaCCfxMw==
X-Google-Smtp-Source: AGRyM1tCmvRPHPZKSHbMtf3pLB5DFTCO00ekPbexEuTo06yjOxb8wYn93B854BWUBEwFnyf9gTnMmA==
X-Received: by 2002:a5d:6d8a:0:b0:21d:a6f3:f458 with SMTP id l10-20020a5d6d8a000000b0021da6f3f458mr11142094wrs.574.1658840802500;
        Tue, 26 Jul 2022 06:06:42 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.8.threembb.co.uk. [188.28.126.8])
        by smtp.gmail.com with ESMTPSA id f9-20020adfb609000000b0021e519eba9bsm14329124wre.42.2022.07.26.06.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 06:06:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next] io_uring/zc: notification completion optimisation
Date:   Tue, 26 Jul 2022 14:06:29 +0100
Message-Id: <9e010125175e80baf51f0ca63bdc7cc6a4a9fa56.1658838783.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We want to use all optimisations that we have for io_uring requests like
completion batching, memory caching and more but for zc notifications.
Fortunately, notification perfectly fit the request model so we can
overlay them onto struct io_kiocb and use all the infratructure.

Most of the fields of struct io_notif natively fits into io_kiocb, so we
replace struct io_notif with struct io_kiocb carrying struct
io_notif_data in the cmd cache line. Then we adapt io_alloc_notif() to
use io_alloc_req()/io_alloc_req_refill(), and kill leftovers of hand
coded caching. __io_notif_complete_tw() is converted to use io_uring's
tw infra.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

With 16B UDP, extra notification per request and with dummy netdev it
improved qps by 4-5%, or 90% -> 94.7% if we consider notification-less
mode as a base line. Using NIC it shows nice batching and the measured
perf change is b/w 1-2%.

 include/linux/io_uring_types.h |   7 --
 io_uring/io_uring.c            |   3 -
 io_uring/net.c                 |   4 +-
 io_uring/notif.c               | 159 +++++++++++----------------------
 io_uring/notif.h               |  42 +++------
 5 files changed, 67 insertions(+), 148 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 144493cbadb5..f7fab3758cb9 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -249,9 +249,6 @@ struct io_ring_ctx {
 		struct xarray		io_bl_xa;
 		struct list_head	io_buffers_cache;
 
-		/* struct io_notif cache, protected by uring_lock */
-		struct list_head	notif_list;
-
 		struct io_hash_table	cancel_table_locked;
 		struct list_head	cq_overflow_list;
 		struct io_alloc_cache	apoll_cache;
@@ -262,10 +259,6 @@ struct io_ring_ctx {
 	struct io_wq_work_list	locked_free_list;
 	unsigned int		locked_free_nr;
 
-	/* struct io_notif cache protected by completion_lock */
-	struct list_head	notif_list_locked;
-	unsigned int		notif_locked_nr;
-
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 822819d0f607..b54218da075c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -321,8 +321,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
-	INIT_LIST_HEAD(&ctx->notif_list);
-	INIT_LIST_HEAD(&ctx->notif_list_locked);
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -2466,7 +2464,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 	WARN_ON_ONCE(ctx->notif_slots || ctx->nr_notif_slots);
 
-	io_notif_cache_purge(ctx);
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 
diff --git a/io_uring/net.c b/io_uring/net.c
index 8276b9537194..32fc3da04e41 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -946,7 +946,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_sendzc *zc = io_kiocb_to_cmd(req);
 	struct io_notif_slot *notif_slot;
-	struct io_notif *notif;
+	struct io_kiocb *notif;
 	struct msghdr msg;
 	struct iovec iov;
 	struct socket *sock;
@@ -1005,7 +1005,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
 	msg.msg_flags = msg_flags;
-	msg.msg_ubuf = &notif->uarg;
+	msg.msg_ubuf = &io_notif_to_data(notif)->uarg;
 	msg.sg_from_iter = io_sg_from_iter;
 	ret = sock_sendmsg(sock, &msg);
 
diff --git a/io_uring/notif.c b/io_uring/notif.c
index e986a0ed958c..b5f989dff9de 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -9,140 +9,79 @@
 #include "notif.h"
 #include "rsrc.h"
 
-static void __io_notif_complete_tw(struct callback_head *cb)
+static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
 {
-	struct io_notif *notif = container_of(cb, struct io_notif, task_work);
-	struct io_rsrc_node *rsrc_node = notif->rsrc_node;
+	struct io_notif_data *nd = io_notif_to_data(notif);
 	struct io_ring_ctx *ctx = notif->ctx;
 
-	if (notif->account_pages && ctx->user) {
-		__io_unaccount_mem(ctx->user, notif->account_pages);
-		notif->account_pages = 0;
+	if (nd->account_pages && ctx->user) {
+		__io_unaccount_mem(ctx->user, nd->account_pages);
+		nd->account_pages = 0;
 	}
-	if (likely(notif->task)) {
-		io_put_task(notif->task, 1);
-		notif->task = NULL;
-	}
-
-	io_cq_lock(ctx);
-	io_fill_cqe_aux(ctx, notif->tag, 0, notif->seq, true);
-
-	list_add(&notif->cache_node, &ctx->notif_list_locked);
-	ctx->notif_locked_nr++;
-	io_cq_unlock_post(ctx);
-
-	io_rsrc_put_node(rsrc_node, 1);
-	percpu_ref_put(&ctx->refs);
+	io_req_task_complete(notif, locked);
 }
 
-static inline void io_notif_complete(struct io_notif *notif)
+static inline void io_notif_complete(struct io_kiocb *notif)
+	__must_hold(&notif->ctx->uring_lock)
 {
-	__io_notif_complete_tw(&notif->task_work);
-}
-
-static void io_notif_complete_wq(struct work_struct *work)
-{
-	struct io_notif *notif = container_of(work, struct io_notif, commit_work);
+	bool locked = true;
 
-	io_notif_complete(notif);
+	__io_notif_complete_tw(notif, &locked);
 }
 
 static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 					  struct ubuf_info *uarg,
 					  bool success)
 {
-	struct io_notif *notif = container_of(uarg, struct io_notif, uarg);
-
-	if (!refcount_dec_and_test(&uarg->refcnt))
-		return;
-
-	if (likely(notif->task)) {
-		init_task_work(&notif->task_work, __io_notif_complete_tw);
-		if (likely(!task_work_add(notif->task, &notif->task_work,
-					  TWA_SIGNAL)))
-			return;
-	}
-
-	INIT_WORK(&notif->commit_work, io_notif_complete_wq);
-	queue_work(system_unbound_wq, &notif->commit_work);
-}
-
-static void io_notif_splice_cached(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
-{
-	spin_lock(&ctx->completion_lock);
-	list_splice_init(&ctx->notif_list_locked, &ctx->notif_list);
-	ctx->notif_locked_nr = 0;
-	spin_unlock(&ctx->completion_lock);
-}
-
-void io_notif_cache_purge(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
-{
-	io_notif_splice_cached(ctx);
+	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
+	struct io_kiocb *notif = cmd_to_io_kiocb(nd);
 
-	while (!list_empty(&ctx->notif_list)) {
-		struct io_notif *notif = list_first_entry(&ctx->notif_list,
-						struct io_notif, cache_node);
-
-		list_del(&notif->cache_node);
-		kfree(notif);
+	if (refcount_dec_and_test(&uarg->refcnt)) {
+		notif->io_task_work.func = __io_notif_complete_tw;
+		io_req_task_work_add(notif);
 	}
 }
 
-static inline bool io_notif_has_cached(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
-{
-	if (likely(!list_empty(&ctx->notif_list)))
-		return true;
-	if (data_race(READ_ONCE(ctx->notif_locked_nr) <= IO_NOTIF_SPLICE_BATCH))
-		return false;
-	io_notif_splice_cached(ctx);
-	return !list_empty(&ctx->notif_list);
-}
-
-struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
+struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
 				struct io_notif_slot *slot)
 	__must_hold(&ctx->uring_lock)
 {
-	struct io_notif *notif;
-
-	if (likely(io_notif_has_cached(ctx))) {
-		notif = list_first_entry(&ctx->notif_list,
-					 struct io_notif, cache_node);
-		list_del(&notif->cache_node);
-	} else {
-		notif = kzalloc(sizeof(*notif), GFP_ATOMIC | __GFP_ACCOUNT);
-		if (!notif)
-			return NULL;
-		/* pre-initialise some fields */
-		notif->ctx = ctx;
-		notif->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
-		notif->uarg.callback = io_uring_tx_zerocopy_callback;
-		notif->account_pages = 0;
-	}
-
-	notif->seq = slot->seq++;
-	notif->tag = slot->tag;
+	struct io_kiocb *notif;
+	struct io_notif_data *nd;
+
+	if (unlikely(!io_alloc_req_refill(ctx)))
+		return NULL;
+	notif = io_alloc_req(ctx);
+	notif->opcode = IORING_OP_NOP;
+	notif->flags = 0;
+	notif->file = NULL;
+	notif->task = current;
+	io_get_task_refs(1);
+	notif->rsrc_node = NULL;
+	io_req_set_rsrc_node(notif, ctx, 0);
+	notif->cqe.user_data = slot->tag;
+	notif->cqe.flags = slot->seq++;
+	notif->cqe.res = 0;
+
+	nd = io_notif_to_data(notif);
+	nd->account_pages = 0;
+	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
+	nd->uarg.callback = io_uring_tx_zerocopy_callback;
 	/* master ref owned by io_notif_slot, will be dropped on flush */
-	refcount_set(&notif->uarg.refcnt, 1);
-	percpu_ref_get(&ctx->refs);
-	notif->rsrc_node = ctx->rsrc_node;
-	io_charge_rsrc_node(ctx);
+	refcount_set(&nd->uarg.refcnt, 1);
 	return notif;
 }
 
 void io_notif_slot_flush(struct io_notif_slot *slot)
 	__must_hold(&ctx->uring_lock)
 {
-	struct io_notif *notif = slot->notif;
+	struct io_kiocb *notif = slot->notif;
+	struct io_notif_data *nd = io_notif_to_data(notif);
 
 	slot->notif = NULL;
 
-	if (WARN_ON_ONCE(in_interrupt()))
-		return;
 	/* drop slot's master ref */
-	if (refcount_dec_and_test(&notif->uarg.refcnt))
+	if (refcount_dec_and_test(&nd->uarg.refcnt))
 		io_notif_complete(notif);
 }
 
@@ -156,18 +95,22 @@ __cold int io_notif_unregister(struct io_ring_ctx *ctx)
 
 	for (i = 0; i < ctx->nr_notif_slots; i++) {
 		struct io_notif_slot *slot = &ctx->notif_slots[i];
+		struct io_kiocb *notif = slot->notif;
+		struct io_notif_data *nd;
 
-		if (!slot->notif)
+		if (!notif)
+			continue;
+		nd = io_kiocb_to_cmd(notif);
+		slot->notif = NULL;
+		if (!refcount_dec_and_test(&nd->uarg.refcnt))
 			continue;
-		if (WARN_ON_ONCE(slot->notif->task))
-			slot->notif->task = NULL;
-		io_notif_slot_flush(slot);
+		notif->io_task_work.func = __io_notif_complete_tw;
+		io_req_task_work_add(notif);
 	}
 
 	kvfree(ctx->notif_slots);
 	ctx->notif_slots = NULL;
 	ctx->nr_notif_slots = 0;
-	io_notif_cache_purge(ctx);
 	return 0;
 }
 
@@ -180,6 +123,8 @@ __cold int io_notif_register(struct io_ring_ctx *ctx,
 	struct io_uring_notification_register reg;
 	unsigned i;
 
+	BUILD_BUG_ON(sizeof(struct io_notif_data) > 64);
+
 	if (ctx->nr_notif_slots)
 		return -EBUSY;
 	if (size != sizeof(reg))
diff --git a/io_uring/notif.h b/io_uring/notif.h
index d6f366b1518b..0819304d7e00 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -10,27 +10,10 @@
 #define IO_NOTIF_SPLICE_BATCH	32
 #define IORING_MAX_NOTIF_SLOTS (1U << 10)
 
-struct io_notif {
+struct io_notif_data {
+	struct file		*file;
 	struct ubuf_info	uarg;
-	struct io_ring_ctx	*ctx;
-	struct io_rsrc_node	*rsrc_node;
-
-	/* complete via tw if ->task is non-NULL, fallback to wq otherwise */
-	struct task_struct	*task;
-
-	/* cqe->user_data, io_notif_slot::tag if not overridden */
-	u64			tag;
-	/* see struct io_notif_slot::seq */
-	u32			seq;
-	/* hook into ctx->notif_list and ctx->notif_list_locked */
-	struct list_head	cache_node;
-
 	unsigned long		account_pages;
-
-	union {
-		struct callback_head	task_work;
-		struct work_struct	commit_work;
-	};
 };
 
 struct io_notif_slot {
@@ -39,7 +22,7 @@ struct io_notif_slot {
 	 * time and keeps one reference to it. Flush releases the reference and
 	 * lazily replaces it with a new notifier.
 	 */
-	struct io_notif		*notif;
+	struct io_kiocb		*notif;
 
 	/*
 	 * Default ->user_data for this slot notifiers CQEs
@@ -56,13 +39,17 @@ struct io_notif_slot {
 int io_notif_register(struct io_ring_ctx *ctx,
 		      void __user *arg, unsigned int size);
 int io_notif_unregister(struct io_ring_ctx *ctx);
-void io_notif_cache_purge(struct io_ring_ctx *ctx);
 
 void io_notif_slot_flush(struct io_notif_slot *slot);
-struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
+struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
 				struct io_notif_slot *slot);
 
-static inline struct io_notif *io_get_notif(struct io_ring_ctx *ctx,
+static inline struct io_notif_data *io_notif_to_data(struct io_kiocb *notif)
+{
+	return io_kiocb_to_cmd(notif);
+}
+
+static inline struct io_kiocb *io_get_notif(struct io_ring_ctx *ctx,
 					    struct io_notif_slot *slot)
 {
 	if (!slot->notif)
@@ -83,16 +70,13 @@ static inline struct io_notif_slot *io_get_notif_slot(struct io_ring_ctx *ctx,
 static inline void io_notif_slot_flush_submit(struct io_notif_slot *slot,
 					      unsigned int issue_flags)
 {
-	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		slot->notif->task = current;
-		io_get_task_refs(1);
-	}
 	io_notif_slot_flush(slot);
 }
 
-static inline int io_notif_account_mem(struct io_notif *notif, unsigned len)
+static inline int io_notif_account_mem(struct io_kiocb *notif, unsigned len)
 {
 	struct io_ring_ctx *ctx = notif->ctx;
+	struct io_notif_data *nd = io_notif_to_data(notif);
 	unsigned nr_pages = (len >> PAGE_SHIFT) + 2;
 	int ret;
 
@@ -100,7 +84,7 @@ static inline int io_notif_account_mem(struct io_notif *notif, unsigned len)
 		ret = __io_account_mem(ctx->user, nr_pages);
 		if (ret)
 			return ret;
-		notif->account_pages += nr_pages;
+		nd->account_pages += nr_pages;
 	}
 	return 0;
 }
-- 
2.37.0

