Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D2953E2C5
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 10:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiFFG5o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 02:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiFFG5i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 02:57:38 -0400
Received: from pv50p00im-tydg10021701.me.com (pv50p00im-tydg10021701.me.com [17.58.6.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EFB22B0B
        for <io-uring@vger.kernel.org>; Sun,  5 Jun 2022 23:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1654498656;
        bh=m3+UYrTNkTqeXm1x2N3vUX4pYSMd6jUE8oemcJXFF4w=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=lfLwU6BWXPWIjAeO4taGpd2vMKR/oH98YLDTH06ahiEC5ZEeCuZOOuN2b5t6XB8Cw
         L+Jxkl2bPsrsQdJFV3RAoruPe4FBf3MKenHdTq3/ypLLFBe6iATS14p7iOuCWWsGqe
         1cYPPI7bxQ3SHS66UQ0UYsSPHnY/fiTNL2jMEdaPUvmX4qX0WEOACLk7Loj10veAp5
         qBeRP4RPakIzpPsYPgpuSWky2GgVDn+nNculasb5yRkkH0pkKs66Sf/s7SiNx6FXOL
         fh5UAqh31oMaded1uWcTsiyVKmtXzTUuTwDXzftwYdXIj6ayMnxmlnqk2co9y5l5HL
         Fkzc6Tho5LGLw==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-tydg10021701.me.com (Postfix) with ESMTPSA id 7B2B23A0DF1;
        Mon,  6 Jun 2022 06:57:32 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 3/3] io_uring: switch cancel_hash to use per list spinlock
Date:   Mon,  6 Jun 2022 14:57:16 +0800
Message-Id: <20220606065716.270879-4-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606065716.270879-1-haoxu.linux@icloud.com>
References: <20220606065716.270879-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_02:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=951 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2206060031
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

Use per list lock for cancel_hash, this removes some completion lock
invocation and remove contension between different cancel_hash entries

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/cancel.c         | 15 ++++++++--
 io_uring/cancel.h         |  1 +
 io_uring/fdinfo.c         |  9 ++++--
 io_uring/io_uring.c       |  8 +++--
 io_uring/io_uring_types.h |  2 +-
 io_uring/poll.c           | 62 +++++++++++++++++++++------------------
 6 files changed, 59 insertions(+), 38 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 83cceb52d82d..c3e5b8058b0d 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -6,6 +6,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/namei.h>
+#include <linux/list.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
@@ -93,14 +94,14 @@ int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
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
 
@@ -192,3 +193,13 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+inline void init_hash_table(struct io_hash_bucket *hash_table, unsigned size)
+{
+	unsigned int i;
+
+	for (i = 0; i < size; i++) {
+		spin_lock_init(&hash_table[i].lock);
+		INIT_HLIST_HEAD(&hash_table[i].list);
+	}
+}
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index b9218310611c..f682e9811e68 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -4,6 +4,7 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd);
+inline void init_hash_table(struct io_hash_bucket *hash_table, unsigned size);
 
 struct io_hash_bucket {
 	spinlock_t		lock;
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
index 1572ebe3cff1..b67ab76b9e56 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -725,11 +725,13 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
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
index 2041ee83467d..59231f7345ac 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -230,7 +230,7 @@ struct io_ring_ctx {
 		 * manipulate the list, hence no extra locking is needed there.
 		 */
 		struct io_wq_work_list	iopoll_list;
-		struct hlist_head	*cancel_hash;
+		struct io_hash_bucket	*cancel_hash;
 		unsigned		cancel_hash_bits;
 		bool			poll_multi_queue;
 
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 95e28f32b49c..d40fad768d58 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -19,6 +19,7 @@
 #include "opdef.h"
 #include "kbuf.h"
 #include "poll.h"
+#include "cancel.h"
 
 struct io_poll_update {
 	struct file			*file;
@@ -73,12 +74,22 @@ static struct io_poll *io_poll_get_single(struct io_kiocb *req)
 static void io_poll_req_insert(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct hlist_head *list;
 	u32 index = hash_long(req->cqe.user_data, ctx->cancel_hash_bits);
+	struct io_hash_bucket *hb = &ctx->cancel_hash[index];
 
 	req->hash_index = index;
-	list = &ctx->cancel_hash[index];
-	hlist_add_head(&req->hash_node, list);
+	spin_lock(&hb->lock);
+	hlist_add_head(&req->hash_node, &hb->list);
+	spin_unlock(&hb->lock);
+}
+
+static void io_poll_req_delete(struct io_kiocb *req, struct io_ring_ctx *ctx)
+{
+	spinlock_t *lock = &ctx->cancel_hash[req->hash_index].lock;
+
+	spin_lock(lock);
+	hash_del(&req->hash_node);
+	spin_unlock(lock);
 }
 
 static void io_init_poll_iocb(struct io_poll *poll, __poll_t events,
@@ -222,8 +233,8 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 	}
 
 	io_poll_remove_entries(req);
+	io_poll_req_delete(req, ctx);
 	spin_lock(&ctx->completion_lock);
-	hash_del(&req->hash_node);
 	req->cqe.flags = 0;
 	__io_req_complete_post(req);
 	io_commit_cqring(ctx);
@@ -233,7 +244,6 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 
 static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	ret = io_poll_check_events(req, locked);
@@ -241,9 +251,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 		return;
 
 	io_poll_remove_entries(req);
-	spin_lock(&ctx->completion_lock);
-	hash_del(&req->hash_node);
-	spin_unlock(&ctx->completion_lock);
+	io_poll_req_delete(req, req->ctx);
 
 	if (!ret)
 		io_req_task_submit(req, locked);
@@ -437,9 +445,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 		return 0;
 	}
 
-	spin_lock(&ctx->completion_lock);
 	io_poll_req_insert(req);
-	spin_unlock(&ctx->completion_lock);
 
 	if (mask && (poll->events & EPOLLET)) {
 		/* can't multishot if failed, just queue the event we've got */
@@ -536,32 +542,32 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
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
 
-	list = &ctx->cancel_hash[hash_long(cd->data, ctx->cancel_hash_bits)];
-	hlist_for_each_entry(req, list, hash_node) {
+	u32 index = hash_long(cd->data, ctx->cancel_hash_bits);
+	struct io_hash_bucket *hb = &ctx->cancel_hash[index];
+
+	spin_lock(&hb->lock);
+	hlist_for_each_entry(req, &hb->list, hash_node) {
 		if (cd->data != req->cqe.user_data)
 			continue;
 		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
@@ -571,47 +577,48 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 				continue;
 			req->work.cancel_seq = cd->seq;
 		}
+		spin_unlock(&hb->lock);
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
 			if (cd->seq == req->work.cancel_seq)
 				continue;
 			req->work.cancel_seq = cd->seq;
+			spin_unlock(&hb->lock);
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
 	io_poll_remove_entries(req);
-	hash_del(&req->hash_node);
+	io_poll_req_delete(req, req->ctx);
 	return true;
 }
 
 int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
-	__must_hold(&ctx->completion_lock)
 {
 	struct io_kiocb *req;
 
@@ -720,14 +727,11 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	int ret2, ret = 0;
 	bool locked;
 
-	spin_lock(&ctx->completion_lock);
 	preq = io_poll_find(ctx, true, &cd);
 	if (!preq || !io_poll_disarm(preq)) {
-		spin_unlock(&ctx->completion_lock);
 		ret = preq ? -EALREADY : -ENOENT;
 		goto out;
 	}
-	spin_unlock(&ctx->completion_lock);
 
 	if (poll_update->update_events || poll_update->update_user_data) {
 		/* only mask one event flags, keep behavior flags */
-- 
2.25.1

