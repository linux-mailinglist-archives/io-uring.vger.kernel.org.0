Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477F25371C4
	for <lists+io-uring@lfdr.de>; Sun, 29 May 2022 18:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbiE2QUP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 May 2022 12:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiE2QUO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 May 2022 12:20:14 -0400
Received: from pv50p00im-ztdg10012001.me.com (pv50p00im-ztdg10012001.me.com [17.58.6.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A6152B2F
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 09:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1653841213;
        bh=7QVi2hcVYosDzEkZAwLbDWpv2ksnf0djAG7Rtu+UEJ0=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=YCO5fufNeM8LRebsrsw5tR7Q8+i3Fght0er/7egS1XQzA5xldmci99Bgj0Qdw0FAs
         DFXOlgLX8GEpY5KxKX6uVd/vkxFmmPhaQKbNFQwH3A8lCZmcrea5Wr/pWnFxb7l8sU
         1liCiEYIendZZlrRsBfN4LyP3J56DLlQmVhlf3LuUB4a+yAtGriUX81ANJ9/pXX7Qp
         lYI0nttCI21VpNXoAi+jjQ3d4pBYQknVnqUqVydHSeE8DHd6Ulc3pgtLwebPwOGgJr
         dckq5R5CbHmlAayp5KqsKDrsEYypiJnXGRqhpfgg4UkU69akxAZL683pu3dUKxjgKv
         ZFFTboMgeB8WQ==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10012001.me.com (Postfix) with ESMTPSA id 0FA62A0389;
        Sun, 29 May 2022 16:20:10 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/2] io_uring: switch cancel_hash to use per list spinlock
Date:   Mon, 30 May 2022 00:20:00 +0800
Message-Id: <20220529162000.32489-3-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220529162000.32489-1-haoxu.linux@icloud.com>
References: <20220529162000.32489-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-29_03:2022-05-27,2022-05-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=863 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205290095
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

From: Hao Xu <howeyxu@tencent.com>

Use per list lock for cancel_hash, this removes some completion lock
invocation and remove contension between different cancel_hash entries

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/cancel.c         | 12 ++++++++++--
 io_uring/cancel.h         |  1 +
 io_uring/io_uring.c       |  9 +++++++++
 io_uring/io_uring_types.h |  1 +
 io_uring/poll.c           | 30 ++++++++++++++++--------------
 5 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 83cceb52d82d..0b1aa3ab7664 100644
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
 
@@ -192,3 +192,11 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+inline void init_cancel_hash_locks(spinlock_t *cancel_hash_locks, unsigned size)
+{
+	int i;
+
+	for (i = 0; i < size; i++)
+		spin_lock_init(&cancel_hash_locks[i]);
+}
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 4f35d8696325..fdec2595797e 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -4,3 +4,4 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd);
+inline void init_cancel_hash_locks(spinlock_t *cancel_hash_locks, unsigned size);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f31d3446dcbf..6eaa27aea197 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -706,7 +706,14 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 					GFP_KERNEL);
 	if (!ctx->cancel_hash)
 		goto err;
+	ctx->cancel_hash_locks =
+		kmalloc((1U << hash_bits) * sizeof(spinlock_t),
+			GFP_KERNEL);
+	if (!ctx->cancel_hash_locks)
+		goto err;
+
 	__hash_init(ctx->cancel_hash, 1U << hash_bits);
+	init_cancel_hash_locks(ctx->cancel_hash_locks, 1U << hash_bits);
 
 	ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
 	if (!ctx->dummy_ubuf)
@@ -749,6 +756,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 err:
 	kfree(ctx->dummy_ubuf);
 	kfree(ctx->cancel_hash);
+	kfree(ctx->cancel_hash_locks);
 	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
@@ -3045,6 +3053,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->hash_map)
 		io_wq_put_hash(ctx->hash_map);
 	kfree(ctx->cancel_hash);
+	kfree(ctx->cancel_hash_locks);
 	kfree(ctx->dummy_ubuf);
 	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index 7c22cf35a7e2..4619a46f7ecd 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -231,6 +231,7 @@ struct io_ring_ctx {
 		 */
 		struct io_wq_work_list	iopoll_list;
 		struct hlist_head	*cancel_hash;
+		spinlock_t		*cancel_hash_locks;
 		unsigned		cancel_hash_bits;
 		bool			poll_multi_queue;
 
diff --git a/io_uring/poll.c b/io_uring/poll.c
index c8982c5ef0fa..e1b6dd282860 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -73,10 +73,11 @@ static struct io_poll *io_poll_get_single(struct io_kiocb *req)
 static void io_poll_req_insert(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct hlist_head *list;
+	u32 index = hash_long(req->cqe.user_data, ctx->cancel_hash_bits);
 
-	list = &ctx->cancel_hash[hash_long(req->cqe.user_data, ctx->cancel_hash_bits)];
-	hlist_add_head(&req->hash_node, list);
+	spin_lock(&ctx->cancel_hash_locks[index]);
+	hlist_add_head(&req->hash_node, &ctx->cancel_hash[index]);
+	spin_unlock(&ctx->cancel_hash_locks[index]);
 }
 
 static void io_init_poll_iocb(struct io_poll *poll, __poll_t events,
@@ -439,9 +440,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 		return 0;
 	}
 
-	spin_lock(&ctx->completion_lock);
 	io_poll_req_insert(req);
-	spin_unlock(&ctx->completion_lock);
 
 	if (mask && (poll->events & EPOLLET)) {
 		/* can't multishot if failed, just queue the event we've got */
@@ -538,10 +537,10 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	bool found = false;
 	int i;
 
-	spin_lock(&ctx->completion_lock);
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
 		struct hlist_head *list;
 
+		spin_lock(&ctx->cancel_hash_locks[i]);
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
 			if (io_match_task_safe(req, tsk, cancel_all)) {
@@ -550,19 +549,19 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 				found = true;
 			}
 		}
+		spin_unlock(&ctx->cancel_hash_locks[i]);
 	}
-	spin_unlock(&ctx->completion_lock);
 	return found;
 }
 
 static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 				     struct io_cancel_data *cd)
-	__must_hold(&ctx->completion_lock)
 {
 	struct hlist_head *list;
 	struct io_kiocb *req;
 	u32 index = hash_long(cd->data, ctx->cancel_hash_bits);
 
+	spin_lock(&ctx->cancel_hash_locks[index]);
 	list = &ctx->cancel_hash[index];
 	hlist_for_each_entry(req, list, hash_node) {
 		if (cd->data != req->cqe.user_data)
@@ -574,15 +573,16 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 				continue;
 			req->work.cancel_seq = cd->seq;
 		}
+		spin_unlock(&ctx->cancel_hash_locks[index]);
 		cd->flags = index;
 		return req;
 	}
+	spin_unlock(&ctx->cancel_hash_locks[index]);
 	return NULL;
 }
 
 static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 					  struct io_cancel_data *cd)
-	__must_hold(&ctx->completion_lock)
 {
 	struct io_kiocb *req;
 	int i;
@@ -590,6 +590,7 @@ static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
 		struct hlist_head *list;
 
+		spin_lock(&ctx->cancel_hash_locks[i]);
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry(req, list, hash_node) {
 			if (!(cd->flags & IORING_ASYNC_CANCEL_ANY) &&
@@ -598,24 +599,28 @@ static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 			if (cd->seq == req->work.cancel_seq)
 				continue;
 			req->work.cancel_seq = cd->seq;
+			spin_unlock(&ctx->cancel_hash_locks[i]);
 			return req;
 		}
+		spin_unlock(&ctx->cancel_hash_locks[i]);
 	}
 	return NULL;
 }
 
 static bool io_poll_disarm(struct io_kiocb *req, u32 index)
-	__must_hold(&ctx->completion_lock)
 {
+	struct io_ring_ctx *ctx = req->ctx;
+
 	if (!io_poll_get_ownership(req))
 		return false;
 	io_poll_remove_entries(req);
+	spin_lock(&ctx->cancel_hash_locks[index]);
 	hash_del(&req->hash_node);
+	spin_unlock(&ctx->cancel_hash_locks[index]);
 	return true;
 }
 
 int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
-	__must_hold(&ctx->completion_lock)
 {
 	struct io_kiocb *req;
 
@@ -724,14 +729,11 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	int ret2, ret = 0;
 	bool locked;
 
-	spin_lock(&ctx->completion_lock);
 	preq = io_poll_find(ctx, true, &cd);
 	if (!preq || !io_poll_disarm(preq, cd.flags)) {
-		spin_unlock(&ctx->completion_lock);
 		ret = preq ? -EALREADY : -ENOENT;
 		goto out;
 	}
-	spin_unlock(&ctx->completion_lock);
 
 	if (poll_update->update_events || poll_update->update_user_data) {
 		/* only mask one event flags, keep behavior flags */
-- 
2.25.1

