Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D353654B144
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356534AbiFNMel (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245682AbiFNMe1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:34:27 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2678647569
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:31:07 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id i17-20020a7bc951000000b0039c4760ec3fso835953wml.0
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4yIX3gVkG6/uT9LgOTEi4hy6UN+9Z2Jm3ZZftf3P9LE=;
        b=EUEp4I6zysGh3HKV/yU/NMXoI/J5mnVoMPshnzcRU6kglCYT8ogf7x4mLl2FLHqnja
         3KtTNT8N6CH4GwnONnWOQq5EYO0IPtPTMn9c1jEOCWw+uuHRKPOX1edPbhspeMgjQnRp
         Qem5AIjpiC0zDhkSUk2jAMqEjLAyBgsLalkLni9xHm+zIXc9f6BujWyEY0pihFrS66Qc
         BRGuIWRDcXuFSkpCnTxNWYrf9kiNzoy3mZanhFbwcrQ/kxh4jQIgmQAoD0PVqGPl/h7Y
         QqcR5Kl+jYtRi7QdiqtrgSNYDI0Hnq+5AUX1IC4qsBrGZwwf8aqUL6itIURPn++aBCWy
         fRjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4yIX3gVkG6/uT9LgOTEi4hy6UN+9Z2Jm3ZZftf3P9LE=;
        b=kr4CjJKRKSlyZXkwGOWWl/mupAO7dct/0ITZ+MZ7z/5B1agqXI0rFMoo7ZllFvdBeI
         EBR61TWrDLkk1lk1xxBX7JHICUcpTwx+Ax2FnsR4VqcBvkZYufT2kxd6bR549mGOZu4E
         HDhEqjUlbkesqyZJHLTpr7ZjGaN9gazcJg/bmgCUOl01EqbX2DtaiARXOxedErlcTjMz
         3jF+wJUvv10V/PqBAkUhWjsbVmecwEBDpJUUN1Kf8lIVy49O9ZXnsBTLS3Mmlo611l9g
         ObRd6cp8Dnp4IZNU5l/6eTIDqUmxPHH2UpzUTIuyGBaVerfV9V4i1eiOrvSlPJjNQOpu
         WX6A==
X-Gm-Message-State: AOAM533imeGgE4uSSMb/4l9lceVckwiLWh7HcANNoz3c4dH9gpjdUmXE
        U6jXsFd1an7yyq3FO6DW3dm8dw+I+DqBuQ==
X-Google-Smtp-Source: ABdhPJypoaHFONLPmF/fTnI7La52VETRFWoJPRz3VXXtMvblgjCctzBHZ8ASiVtzg1bnfMhGY2Sf8Q==
X-Received: by 2002:a7b:c3d1:0:b0:39c:64d0:b8c2 with SMTP id t17-20020a7bc3d1000000b0039c64d0b8c2mr3971358wmj.195.1655209866143;
        Tue, 14 Jun 2022 05:31:06 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:31:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 25/25] io_uring: mutex locked poll hashing
Date:   Tue, 14 Jun 2022 13:30:03 +0100
Message-Id: <ac44487e47e0a992fdb26d8e33b46c08f69f3a16.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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

Currently we do two extra spin lock/unlock pairs to add a poll/apoll
request to the cancellation hash table and remove it from there.

On the submission side we often already hold ->uring_lock and tw
completion is likely to hold it as well. Add a second cancellation hash
table protected by ->uring_lock. In concerns for latency because of a
need to have the mutex locked on the completion side, use the new table
only in following cases:

1) IORING_SETUP_SINGLE_ISSUER: only one task grabs uring_lock, so there
   is no contention and so the main tw hander will always end up
   grabbing it before calling into callbacks.

2) IORING_SETUP_SQPOLL: same as with single issuer, only one task is
   using ->uring_lock.

3) apoll: we normally grab the lock on the completion side anyway to
   execute the request, so it's free.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c       |   9 +++-
 io_uring/io_uring_types.h |   4 ++
 io_uring/poll.c           | 111 ++++++++++++++++++++++++++++++--------
 3 files changed, 102 insertions(+), 22 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 64a945fe47f5..169947b3679e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -731,6 +731,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	hash_bits = clamp(hash_bits, 1, 8);
 	if (io_alloc_hash_table(&ctx->cancel_table, hash_bits))
 		goto err;
+	if (io_alloc_hash_table(&ctx->cancel_table_locked, hash_bits))
+		goto err;
 
 	ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
 	if (!ctx->dummy_ubuf)
@@ -773,6 +775,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 err:
 	kfree(ctx->dummy_ubuf);
 	kfree(ctx->cancel_table.hbs);
+	kfree(ctx->cancel_table_locked.hbs);
 	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
@@ -3056,6 +3059,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->hash_map)
 		io_wq_put_hash(ctx->hash_map);
 	kfree(ctx->cancel_table.hbs);
+	kfree(ctx->cancel_table_locked.hbs);
 	kfree(ctx->dummy_ubuf);
 	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
@@ -3217,12 +3221,13 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		__io_cqring_overflow_flush(ctx, true);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
+	if (ctx->rings)
+		io_poll_remove_all(ctx, NULL, true);
 	mutex_unlock(&ctx->uring_lock);
 
 	/* failed during ring init, it couldn't have issued any requests */
 	if (ctx->rings) {
 		io_kill_timeouts(ctx, NULL, true);
-		io_poll_remove_all(ctx, NULL, true);
 		/* if we failed setting up the ctx, we might not have any rings */
 		io_iopoll_try_reap_events(ctx);
 	}
@@ -3347,7 +3352,9 @@ static __cold void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		}
 
 		ret |= io_cancel_defer_files(ctx, task, cancel_all);
+		mutex_lock(&ctx->uring_lock);
 		ret |= io_poll_remove_all(ctx, task, cancel_all);
+		mutex_unlock(&ctx->uring_lock);
 		ret |= io_kill_timeouts(ctx, task, cancel_all);
 		if (task)
 			ret |= io_run_task_work();
diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index d1ce3735aca1..6c3c3c88223a 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -189,6 +189,7 @@ struct io_ring_ctx {
 		struct xarray		io_bl_xa;
 		struct list_head	io_buffers_cache;
 
+		struct io_hash_table	cancel_table_locked;
 		struct list_head	cq_overflow_list;
 		struct list_head	apoll_cache;
 		struct xarray		personalities;
@@ -323,6 +324,7 @@ enum {
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
+	REQ_F_HASH_LOCKED_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -388,6 +390,8 @@ enum {
 	REQ_F_APOLL_MULTISHOT	= BIT(REQ_F_APOLL_MULTISHOT_BIT),
 	/* recvmsg special flag, clear EPOLLIN */
 	REQ_F_CLEAR_POLLIN	= BIT(REQ_F_CLEAR_POLLIN_BIT),
+	/* hashed into ->cancel_hash_locked */
+	REQ_F_HASH_LOCKED	= BIT(REQ_F_HASH_LOCKED_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, bool *locked);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index db7357de7f8c..5eb805b97f5d 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -93,6 +93,26 @@ static void io_poll_req_delete(struct io_kiocb *req, struct io_ring_ctx *ctx)
 	spin_unlock(lock);
 }
 
+static void io_poll_req_insert_locked(struct io_kiocb *req)
+{
+	struct io_hash_table *table = &req->ctx->cancel_table_locked;
+	u32 index = hash_long(req->cqe.user_data, table->hash_bits);
+
+	hlist_add_head(&req->hash_node, &table->hbs[index].list);
+}
+
+static void io_poll_tw_hash_eject(struct io_kiocb *req, bool *locked)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (req->flags & REQ_F_HASH_LOCKED) {
+		io_tw_lock(ctx, locked);
+		hash_del(&req->hash_node);
+	} else {
+		io_poll_req_delete(req, ctx);
+	}
+}
+
 static void io_init_poll_iocb(struct io_poll *poll, __poll_t events,
 			      wait_queue_func_t wake_func)
 {
@@ -217,7 +237,6 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	ret = io_poll_check_events(req, locked);
@@ -234,7 +253,8 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 	}
 
 	io_poll_remove_entries(req);
-	io_poll_req_delete(req, ctx);
+	io_poll_tw_hash_eject(req, locked);
+
 	io_req_set_res(req, req->cqe.res, 0);
 	io_req_task_complete(req, locked);
 }
@@ -248,7 +268,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 		return;
 
 	io_poll_remove_entries(req);
-	io_poll_req_delete(req, req->ctx);
+	io_poll_tw_hash_eject(req, locked);
 
 	if (!ret)
 		io_req_task_submit(req, locked);
@@ -442,7 +462,10 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 		return 0;
 	}
 
-	io_poll_req_insert(req);
+	if (req->flags & REQ_F_HASH_LOCKED)
+		io_poll_req_insert_locked(req);
+	else
+		io_poll_req_insert(req);
 
 	if (mask && (poll->events & EPOLLET)) {
 		/* can't multishot if failed, just queue the event we've got */
@@ -480,6 +503,15 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	__poll_t mask = POLLPRI | POLLERR | EPOLLET;
 	int ret;
 
+	/*
+	 * apoll requests already grab the mutex to complete in the tw handler,
+	 * so removal from the mutex-backed hash is free, use it by default.
+	 */
+	if (issue_flags & IO_URING_F_UNLOCKED)
+		req->flags &= ~REQ_F_HASH_LOCKED;
+	else
+		req->flags |= REQ_F_HASH_LOCKED;
+
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
 	if (!file_can_poll(req->file))
@@ -528,13 +560,10 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	return IO_APOLL_OK;
 }
 
-/*
- * Returns true if we found and killed one or more poll requests
- */
-__cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
-			       bool cancel_all)
+static __cold bool io_poll_remove_all_table(struct task_struct *tsk,
+					    struct io_hash_table *table,
+					    bool cancel_all)
 {
-	struct io_hash_table *table = &ctx->cancel_table;
 	unsigned nr_buckets = 1U << table->hash_bits;
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
@@ -557,6 +586,17 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	return found;
 }
 
+/*
+ * Returns true if we found and killed one or more poll requests
+ */
+__cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
+			       bool cancel_all)
+	__must_hold(&ctx->uring_lock)
+{
+	return io_poll_remove_all_table(tsk, &ctx->cancel_table, cancel_all) |
+	       io_poll_remove_all_table(tsk, &ctx->cancel_table_locked, cancel_all);
+}
+
 static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 				     struct io_cancel_data *cd,
 				     struct io_hash_table *table,
@@ -616,13 +656,15 @@ static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 	return NULL;
 }
 
-static bool io_poll_disarm(struct io_kiocb *req)
+static int io_poll_disarm(struct io_kiocb *req)
 {
+	if (!req)
+		return -ENOENT;
 	if (!io_poll_get_ownership(req))
-		return false;
+		return -EALREADY;
 	io_poll_remove_entries(req);
 	hash_del(&req->hash_node);
-	return true;
+	return 0;
 }
 
 static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
@@ -646,7 +688,16 @@ static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		   unsigned issue_flags)
 {
-	return __io_poll_cancel(ctx, cd, &ctx->cancel_table);
+	int ret;
+
+	ret = __io_poll_cancel(ctx, cd, &ctx->cancel_table);
+	if (ret != -ENOENT)
+		return ret;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	ret = __io_poll_cancel(ctx, cd, &ctx->cancel_table_locked);
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
 }
 
 static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
@@ -721,6 +772,16 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 
 	ipt.pt._qproc = io_poll_queue_proc;
 
+	/*
+	 * If sqpoll or single issuer, there is no contention for ->uring_lock
+	 * and we'll end up holding it in tw handlers anyway.
+	 */
+	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
+	    (req->ctx->flags & (IORING_SETUP_SQPOLL | IORING_SETUP_SINGLE_ISSUER)))
+		req->flags |= REQ_F_HASH_LOCKED;
+	else
+		req->flags &= ~REQ_F_HASH_LOCKED;
+
 	ret = __io_arm_poll_handler(req, poll, &ipt, poll->events);
 	if (ipt.error) {
 		return ipt.error;
@@ -745,20 +806,28 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	bool locked;
 
 	preq = io_poll_find(ctx, true, &cd, &ctx->cancel_table, &bucket);
-	if (preq)
-		ret2 = io_poll_disarm(preq);
+	ret2 = io_poll_disarm(preq);
 	if (bucket)
 		spin_unlock(&bucket->lock);
-
-	if (!preq) {
-		ret = -ENOENT;
+	if (!ret2)
+		goto found;
+	if (ret2 != -ENOENT) {
+		ret = ret2;
 		goto out;
 	}
-	if (!ret2) {
-		ret = -EALREADY;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	preq = io_poll_find(ctx, true, &cd, &ctx->cancel_table_locked, &bucket);
+	ret2 = io_poll_disarm(preq);
+	if (bucket)
+		spin_unlock(&bucket->lock);
+	io_ring_submit_unlock(ctx, issue_flags);
+	if (ret2) {
+		ret = ret2;
 		goto out;
 	}
 
+found:
 	if (poll_update->update_events || poll_update->update_user_data) {
 		/* only mask one event flags, keep behavior flags */
 		if (poll_update->update_events) {
-- 
2.36.1

