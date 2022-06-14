Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CF854B0EE
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355092AbiFNMea (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243599AbiFNMeA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:34:00 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C88B457A8
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:56 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id w17so3574141wrg.7
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z06udJtnFtpH/wHY1WkD2gKtH1iQkgAVtqfz/r7EviA=;
        b=VZegUOGZPlTj9S3Ck1koofFAlZp5PE61v42Se9GFCDUYhepuBoyjBCFlXxNvh5X3Jl
         51VwYVFkPj50+f0AuPyQN+7ZseoosQag063DJMw1AMhu5E5hQw/vJpc729Opt8PzwSip
         pD/LnagtskLt0h0AR6t7Xl2UxFDnuhueu4tCu0FeNiJvihktSfBC+5i7TKWLMEHybIfC
         hZ3QclRIQy7rrDbzKa8FbV0oVcjMRwYNB7iVUgfDvNBq3wVEad9Vse/khoOa6NvOyABv
         wGW/XX5ErWomjLmWdB0Wn1qFUnz8Bq6kuig9Mm48UkDLj2kUgtw14stIqNisi1lUV4S4
         IY4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z06udJtnFtpH/wHY1WkD2gKtH1iQkgAVtqfz/r7EviA=;
        b=DWhOx3MxI1UZB2UmF53KCfBWDyZrJ2rHTpn9e33Hk/scdtT5YEhgPItEBKEvAb6uRu
         M2W0gBtKCaiJWRJJStaN3a773ayVruGxWi2Y9Gk8Yuu3UcsCXROz+KXxpFutptrE1gkb
         NcwyJ70zYlU/QRP2LWqDkp3PV7AIFQM2G3HWJQzlIv8bO2mhmUsrFn2nXn4eGkkhAyyG
         6O2ZdR9gWjyJSOvmuD1Iy9bQi7DulzYl3dPW2oFAq2Sc4t+VnbADOBdvbU9/Ym/JM69i
         a0IuIZuo/KStM7tC68RYT+JbUGkFnSRD6J4XwWKGBQZilxcj+MxWrmm4wXkqiEJwccjU
         pNdg==
X-Gm-Message-State: AJIora/SlsvY+RJW6nxyeRCRw7/y2gh4cC8UzxhmxE0I2ERPD3TczdSR
        JejYk9aauxIyak468AZhEYPZxEJNMIql2w==
X-Google-Smtp-Source: AGRyM1txsz7RAEkfaiKYtkISzEqgrVREjSB7LeBheZW2lUvu2L8fNnU9hnHRlaezqj3Ak7FtncaV/A==
X-Received: by 2002:adf:f688:0:b0:215:6e4d:4103 with SMTP id v8-20020adff688000000b002156e4d4103mr4612028wrp.372.1655209854095;
        Tue, 14 Jun 2022 05:30:54 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Hao Xu <howeyxu@tencent.com>
Subject: [PATCH for-next 15/25] io_uring: switch cancel_hash to use per entry spinlock
Date:   Tue, 14 Jun 2022 13:29:53 +0100
Message-Id: <2fedbcc47d82f5c98ccf94b6bdcada14f9ebdd59.1655209709.git.asml.silence@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

Add a new io_hash_bucket structure so that each bucket in cancel_hash
has separate spinlock. Use per entry lock for cancel_hash, this removes
some completion lock invocation and remove contension between different
cancel_hash entries.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/cancel.c         | 14 ++++++-
 io_uring/cancel.h         |  6 +++
 io_uring/fdinfo.c         |  9 +++--
 io_uring/io_uring.c       |  8 ++--
 io_uring/io_uring_types.h |  2 +-
 io_uring/poll.c           | 80 ++++++++++++++++++++++++---------------
 6 files changed, 79 insertions(+), 40 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 2e72231882b7..54a5e0a86b61 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -93,14 +93,14 @@ int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
 	if (!ret)
 		return 0;
 
-	spin_lock(&ctx->completion_lock);
 	ret = io_poll_cancel(ctx, cd);
 	if (ret != -ENOENT)
 		goto out;
+	spin_lock(&ctx->completion_lock);
 	if (!(cd->flags & IORING_ASYNC_CANCEL_FD))
 		ret = io_timeout_cancel(ctx, cd);
-out:
 	spin_unlock(&ctx->completion_lock);
+out:
 	return ret;
 }
 
@@ -192,3 +192,13 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+void init_hash_table(struct io_hash_bucket *hash_table, unsigned size)
+{
+	unsigned int i;
+
+	for (i = 0; i < size; i++) {
+		spin_lock_init(&hash_table[i].lock);
+		INIT_HLIST_HEAD(&hash_table[i].list);
+	}
+}
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 4f35d8696325..556a7dcf160e 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -4,3 +4,9 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd);
+void init_hash_table(struct io_hash_bucket *hash_table, unsigned size);
+
+struct io_hash_bucket {
+	spinlock_t		lock;
+	struct hlist_head	list;
+} ____cacheline_aligned_in_smp;
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index fcedde4b4b1e..f941c73f5502 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -13,6 +13,7 @@
 #include "io_uring.h"
 #include "sqpoll.h"
 #include "fdinfo.h"
+#include "cancel.h"
 
 #ifdef CONFIG_PROC_FS
 static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
@@ -157,17 +158,19 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 		mutex_unlock(&ctx->uring_lock);
 
 	seq_puts(m, "PollList:\n");
-	spin_lock(&ctx->completion_lock);
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
-		struct hlist_head *list = &ctx->cancel_hash[i];
+		struct io_hash_bucket *hb = &ctx->cancel_hash[i];
 		struct io_kiocb *req;
 
-		hlist_for_each_entry(req, list, hash_node)
+		spin_lock(&hb->lock);
+		hlist_for_each_entry(req, &hb->list, hash_node)
 			seq_printf(m, "  op=%d, task_works=%d\n", req->opcode,
 					task_work_pending(req->task));
+		spin_unlock(&hb->lock);
 	}
 
 	seq_puts(m, "CqOverflowList:\n");
+	spin_lock(&ctx->completion_lock);
 	list_for_each_entry(ocqe, &ctx->cq_overflow_list, list) {
 		struct io_uring_cqe *cqe = &ocqe->cqe;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bd2aab895e29..4e0f60ffc975 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -717,11 +717,13 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	if (hash_bits <= 0)
 		hash_bits = 1;
 	ctx->cancel_hash_bits = hash_bits;
-	ctx->cancel_hash = kmalloc((1U << hash_bits) * sizeof(struct hlist_head),
-					GFP_KERNEL);
+	ctx->cancel_hash =
+		kmalloc((1U << hash_bits) * sizeof(struct io_hash_bucket),
+			GFP_KERNEL);
 	if (!ctx->cancel_hash)
 		goto err;
-	__hash_init(ctx->cancel_hash, 1U << hash_bits);
+
+	init_hash_table(ctx->cancel_hash, 1U << hash_bits);
 
 	ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
 	if (!ctx->dummy_ubuf)
diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index 3cf06f4a4d2e..0dd3ab7eec4c 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -222,7 +222,7 @@ struct io_ring_ctx {
 		 * manipulate the list, hence no extra locking is needed there.
 		 */
 		struct io_wq_work_list	iopoll_list;
-		struct hlist_head	*cancel_hash;
+		struct io_hash_bucket	*cancel_hash;
 		unsigned		cancel_hash_bits;
 		bool			poll_multi_queue;
 
diff --git a/io_uring/poll.c b/io_uring/poll.c
index be3dd77fa21c..ab4be4173cf3 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -19,6 +19,7 @@
 #include "opdef.h"
 #include "kbuf.h"
 #include "poll.h"
+#include "cancel.h"
 
 struct io_poll_update {
 	struct file			*file;
@@ -73,10 +74,22 @@ static struct io_poll *io_poll_get_single(struct io_kiocb *req)
 static void io_poll_req_insert(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct hlist_head *list;
+	u32 index = hash_long(req->cqe.user_data, ctx->cancel_hash_bits);
+	struct io_hash_bucket *hb = &ctx->cancel_hash[index];
 
-	list = &ctx->cancel_hash[hash_long(req->cqe.user_data, ctx->cancel_hash_bits)];
-	hlist_add_head(&req->hash_node, list);
+	spin_lock(&hb->lock);
+	hlist_add_head(&req->hash_node, &hb->list);
+	spin_unlock(&hb->lock);
+}
+
+static void io_poll_req_delete(struct io_kiocb *req, struct io_ring_ctx *ctx)
+{
+	u32 index = hash_long(req->cqe.user_data, ctx->cancel_hash_bits);
+	spinlock_t *lock = &ctx->cancel_hash[index].lock;
+
+	spin_lock(lock);
+	hash_del(&req->hash_node);
+	spin_unlock(lock);
 }
 
 static void io_init_poll_iocb(struct io_poll *poll, __poll_t events,
@@ -220,8 +233,8 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 	}
 
 	io_poll_remove_entries(req);
+	io_poll_req_delete(req, ctx);
 	spin_lock(&ctx->completion_lock);
-	hash_del(&req->hash_node);
 	req->cqe.flags = 0;
 	__io_req_complete_post(req);
 	io_commit_cqring(ctx);
@@ -231,7 +244,6 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 
 static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	ret = io_poll_check_events(req, locked);
@@ -239,9 +251,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 		return;
 
 	io_poll_remove_entries(req);
-	spin_lock(&ctx->completion_lock);
-	hash_del(&req->hash_node);
-	spin_unlock(&ctx->completion_lock);
+	io_poll_req_delete(req, req->ctx);
 
 	if (!ret)
 		io_req_task_submit(req, locked);
@@ -435,9 +445,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 		return 0;
 	}
 
-	spin_lock(&ctx->completion_lock);
 	io_poll_req_insert(req);
-	spin_unlock(&ctx->completion_lock);
 
 	if (mask && (poll->events & EPOLLET)) {
 		/* can't multishot if failed, just queue the event we've got */
@@ -534,32 +542,31 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	bool found = false;
 	int i;
 
-	spin_lock(&ctx->completion_lock);
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
-		struct hlist_head *list;
+		struct io_hash_bucket *hb = &ctx->cancel_hash[i];
 
-		list = &ctx->cancel_hash[i];
-		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
+		spin_lock(&hb->lock);
+		hlist_for_each_entry_safe(req, tmp, &hb->list, hash_node) {
 			if (io_match_task_safe(req, tsk, cancel_all)) {
 				hlist_del_init(&req->hash_node);
 				io_poll_cancel_req(req);
 				found = true;
 			}
 		}
+		spin_unlock(&hb->lock);
 	}
-	spin_unlock(&ctx->completion_lock);
 	return found;
 }
 
 static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 				     struct io_cancel_data *cd)
-	__must_hold(&ctx->completion_lock)
 {
-	struct hlist_head *list;
 	struct io_kiocb *req;
+	u32 index = hash_long(cd->data, ctx->cancel_hash_bits);
+	struct io_hash_bucket *hb = &ctx->cancel_hash[index];
 
-	list = &ctx->cancel_hash[hash_long(cd->data, ctx->cancel_hash_bits)];
-	hlist_for_each_entry(req, list, hash_node) {
+	spin_lock(&hb->lock);
+	hlist_for_each_entry(req, &hb->list, hash_node) {
 		if (cd->data != req->cqe.user_data)
 			continue;
 		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
@@ -571,21 +578,21 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 		}
 		return req;
 	}
+	spin_unlock(&hb->lock);
 	return NULL;
 }
 
 static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 					  struct io_cancel_data *cd)
-	__must_hold(&ctx->completion_lock)
 {
 	struct io_kiocb *req;
 	int i;
 
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
-		struct hlist_head *list;
+		struct io_hash_bucket *hb = &ctx->cancel_hash[i];
 
-		list = &ctx->cancel_hash[i];
-		hlist_for_each_entry(req, list, hash_node) {
+		spin_lock(&hb->lock);
+		hlist_for_each_entry(req, &hb->list, hash_node) {
 			if (!(cd->flags & IORING_ASYNC_CANCEL_ANY) &&
 			    req->file != cd->file)
 				continue;
@@ -594,12 +601,12 @@ static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 			req->cancel_seq = cd->seq;
 			return req;
 		}
+		spin_unlock(&hb->lock);
 	}
 	return NULL;
 }
 
 static bool io_poll_disarm(struct io_kiocb *req)
-	__must_hold(&ctx->completion_lock)
 {
 	if (!io_poll_get_ownership(req))
 		return false;
@@ -609,17 +616,23 @@ static bool io_poll_disarm(struct io_kiocb *req)
 }
 
 int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
-	__must_hold(&ctx->completion_lock)
 {
 	struct io_kiocb *req;
+	u32 index;
+	spinlock_t *lock;
 
 	if (cd->flags & (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_ANY))
 		req = io_poll_file_find(ctx, cd);
 	else
 		req = io_poll_find(ctx, false, cd);
-	if (!req)
+	if (!req) {
 		return -ENOENT;
+	} else {
+		index = hash_long(req->cqe.user_data, ctx->cancel_hash_bits);
+		lock = &ctx->cancel_hash[index].lock;
+	}
 	io_poll_cancel_req(req);
+	spin_unlock(lock);
 	return 0;
 }
 
@@ -713,18 +726,23 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_poll_update *poll_update = io_kiocb_to_cmd(req);
 	struct io_cancel_data cd = { .data = poll_update->old_user_data, };
 	struct io_ring_ctx *ctx = req->ctx;
+	u32 index = hash_long(cd.data, ctx->cancel_hash_bits);
+	spinlock_t *lock = &ctx->cancel_hash[index].lock;
 	struct io_kiocb *preq;
 	int ret2, ret = 0;
 	bool locked;
 
-	spin_lock(&ctx->completion_lock);
 	preq = io_poll_find(ctx, true, &cd);
-	if (!preq || !io_poll_disarm(preq)) {
-		spin_unlock(&ctx->completion_lock);
-		ret = preq ? -EALREADY : -ENOENT;
+	if (!preq) {
+		ret = -ENOENT;
+		goto out;
+	}
+	ret2 = io_poll_disarm(preq);
+	spin_unlock(lock);
+	if (!ret2) {
+		ret = -EALREADY;
 		goto out;
 	}
-	spin_unlock(&ctx->completion_lock);
 
 	if (poll_update->update_events || poll_update->update_user_data) {
 		/* only mask one event flags, keep behavior flags */
-- 
2.36.1

