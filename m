Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D7C43E101
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 14:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhJ1MbU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 08:31:20 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:43983 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230335AbhJ1MbT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 08:31:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Uu.wxKn_1635424131;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Uu.wxKn_1635424131)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Oct 2021 20:28:51 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [RFC v2 3/3] io_uring: introduce event generation for fixed poll
Date:   Thu, 28 Oct 2021 20:28:50 +0800
Message-Id: <20211028122850.13025-3-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20211028122850.13025-1-xiaoguang.wang@linux.alibaba.com>
References: <20211028122850.13025-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For fast poll feature, if req gets EAGAIN for the first no-wait try,
it'll call vfs_poll later to check whether there is new event happened,
which has non-trivial overhead.

Here introduce event generation mechanism, we can quickly judge whether
new event happens.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6f63aea3e0c0..1e485409c2f7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -223,6 +223,7 @@ struct io_fixed_poll {
 	struct wait_queue_head		*head;
 	struct list_head		list;
 	struct wait_queue_entry		wait;
+	unsigned long			generation;
 	__poll_t			events;
 };
 
@@ -6969,31 +6970,32 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
 }
 
 static inline int io_arm_fixed_poll_handler(struct io_kiocb *req,
-					    struct io_fixed_poll *fixed_poll)
+			struct io_fixed_poll *fixed_poll, unsigned long generation)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct poll_table_struct pt = { ._key = fixed_poll->events };
-	__poll_t result;
+	int ret;
 
 	if (req->flags & REQ_F_FIXED_POLL)
 		return IO_APOLL_ABORTED;
 
 	req->flags |= REQ_F_FIXED_POLL;
-	result = vfs_poll(req->file, &pt) & fixed_poll->events;
-	if (result)
-		return IO_APOLL_READY;
-
 	spin_lock(&ctx->completion_lock);
 	spin_lock_irq(&fixed_poll->head->lock);
-	INIT_LIST_HEAD(&req->fixed_poll_node);
-	list_add_tail(&req->fixed_poll_node, &fixed_poll->list);
-	io_poll_req_insert(req);
+	/* new events happen */
+	if (generation != fixed_poll->generation) {
+		ret = IO_APOLL_READY;
+	} else {
+		INIT_LIST_HEAD(&req->fixed_poll_node);
+		list_add_tail(&req->fixed_poll_node, &fixed_poll->list);
+		io_poll_req_insert(req);
+		ret = IO_APOLL_OK;
+	}
 	spin_unlock_irq(&fixed_poll->head->lock);
 	spin_unlock(&ctx->completion_lock);
-	return IO_APOLL_OK;
+	return ret;
 }
 
-static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
+static void io_queue_sqe_arm_apoll(struct io_kiocb *req, unsigned long generation)
 	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
@@ -7004,7 +7006,7 @@ static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
 		fixed_poll = req->fixed_poll;
 
 	if (fixed_poll)
-		ret = io_arm_fixed_poll_handler(req, fixed_poll);
+		ret = io_arm_fixed_poll_handler(req, fixed_poll, generation);
 	else
 		ret = io_arm_poll_handler(req);
 
@@ -7033,8 +7035,13 @@ static inline void __io_queue_sqe(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_kiocb *linked_timeout;
+	struct io_fixed_poll *fixed_poll = req->flags & REQ_F_FIXED_FILE ? req->fixed_poll : NULL;
+	unsigned long generation;
 	int ret;
 
+	if (fixed_poll)
+		generation = READ_ONCE(fixed_poll->generation);
+
 	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
 
 	if (req->flags & REQ_F_COMPLETE_INLINE) {
@@ -7050,7 +7057,7 @@ static inline void __io_queue_sqe(struct io_kiocb *req)
 		if (linked_timeout)
 			io_queue_linked_timeout(linked_timeout);
 	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
-		io_queue_sqe_arm_apoll(req);
+		io_queue_sqe_arm_apoll(req, generation);
 	} else {
 		io_req_complete_failed(req, ret);
 	}
@@ -8384,6 +8391,7 @@ static int io_fixed_poll_wake(struct wait_queue_entry *wait,
 	if (mask && !(mask & poll->events))
 		return 0;
 
+	poll->generation++;
 	list_for_each_entry_safe(req, nxt, &poll->list, fixed_poll_node) {
 		req->result = mask;
 		req->io_task_work.func = io_fixed_poll_task_func;
-- 
2.14.4.44.g2045bb6

