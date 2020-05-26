Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748091E1B82
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 08:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgEZGnu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 02:43:50 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:57380 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726756AbgEZGnu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 02:43:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TzhAn1R_1590475424;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TzhAn1R_1590475424)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 26 May 2020 14:43:46 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH 2/3] io_uring: avoid whole io_wq_work copy for inline requests
Date:   Tue, 26 May 2020 14:43:29 +0800
Message-Id: <20200526064330.9322-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200526064330.9322-1-xiaoguang.wang@linux.alibaba.com>
References: <20200526064330.9322-1-xiaoguang.wang@linux.alibaba.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If requests can be submitted inline, we don't need to copy whole
io_wq_work in io_init_req(), which is an expensive operation. I
use my io_uring_nop_stress to evaluate performance improvement.

In my physical machine, before this patch:
$sudo taskset -c 60 ./io_uring_nop_stress -r 120
total ios: 749093872
IOPS:      6242448

$sudo taskset -c 60 ./io_uring_nop_stress -r 120
total ios: 786083712
IOPS:      6550697

About 4.9% improvement.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io-wq.h    | 13 +++++++++----
 fs/io_uring.c | 33 ++++++++++++++++++++++++++-------
 2 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 5ba12de7572f..11d981a67006 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -94,10 +94,15 @@ struct io_wq_work {
 	pid_t task_pid;
 };
 
-#define INIT_IO_WORK(work, _func)				\
-	do {							\
-		*(work) = (struct io_wq_work){ .func = _func };	\
-	} while (0)						\
+static inline void init_io_work(struct io_wq_work *work,
+		void (*func)(struct io_wq_work **))
+{
+	if (!work->func)
+		*(work) = (struct io_wq_work){ .func = func };
+	else
+		work->func = func;
+}
+
 
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
 {
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 788d960abc69..a54b21e6d921 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1056,6 +1056,13 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 
 static inline void io_req_work_drop_env(struct io_kiocb *req)
 {
+	/*
+	 * Use io_wq_work.func as a flag to determine whether needs to
+	 * drop environment.
+	 */
+	if (!req->work.func)
+		return;
+
 	if (req->work.mm) {
 		mmdrop(req->work.mm);
 		req->work.mm = NULL;
@@ -1600,7 +1607,7 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 	*workptr = &nxt->work;
 	link = io_prep_linked_timeout(nxt);
 	if (link)
-		nxt->work.func = io_link_work_cb;
+		init_io_work(&nxt->work, io_link_work_cb);
 }
 
 /*
@@ -2929,7 +2936,7 @@ static int io_fsync(struct io_kiocb *req, bool force_nonblock)
 {
 	/* fsync always requires a blocking context */
 	if (force_nonblock) {
-		req->work.func = io_fsync_finish;
+		init_io_work(&req->work, io_fsync_finish);
 		return -EAGAIN;
 	}
 	__io_fsync(req);
@@ -2977,7 +2984,7 @@ static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 {
 	/* fallocate always requiring blocking context */
 	if (force_nonblock) {
-		req->work.func = io_fallocate_finish;
+		init_io_work(&req->work, io_fallocate_finish);
 		return -EAGAIN;
 	}
 
@@ -3506,7 +3513,7 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 		/* submission ref will be dropped, take it for async */
 		refcount_inc(&req->refs);
 
-		req->work.func = io_close_finish;
+		init_io_work(&req->work, io_close_finish);
 		/*
 		 * Do manual async queue here to avoid grabbing files - we don't
 		 * need the files, and it'll cause io_close_finish() to close
@@ -3569,7 +3576,7 @@ static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
 {
 	/* sync_file_range always requires a blocking context */
 	if (force_nonblock) {
-		req->work.func = io_sync_file_range_finish;
+		init_io_work(&req->work, io_sync_file_range_finish);
 		return -EAGAIN;
 	}
 
@@ -4038,7 +4045,7 @@ static int io_accept(struct io_kiocb *req, bool force_nonblock)
 
 	ret = __io_accept(req, force_nonblock);
 	if (ret == -EAGAIN && force_nonblock) {
-		req->work.func = io_accept_finish;
+		init_io_work(&req->work, io_accept_finish);
 		return -EAGAIN;
 	}
 	return 0;
@@ -4254,6 +4261,7 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 	}
 
 	hash_del(&req->hash_node);
+	req->work.func = NULL;
 	io_poll_complete(req, req->result, 0);
 	req->flags |= REQ_F_COMP_LOCKED;
 	io_put_req_find_next(req, nxt);
@@ -5038,6 +5046,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	if (!sqe)
 		return 0;
 
+	if (!req->work.func)
+		init_io_work(&req->work, io_wq_submit_work);
+
 	if (io_op_defs[req->opcode].file_table) {
 		ret = io_grab_files(req);
 		if (unlikely(ret))
@@ -5702,6 +5713,9 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			goto exit;
 		}
 punt:
+		if (!req->work.func)
+			init_io_work(&req->work, io_wq_submit_work);
+
 		if (io_op_defs[req->opcode].file_table) {
 			ret = io_grab_files(req);
 			if (ret)
@@ -5954,7 +5968,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	refcount_set(&req->refs, 2);
 	req->task = NULL;
 	req->result = 0;
-	INIT_IO_WORK(&req->work, io_wq_submit_work);
+	/*
+	 * Use io_wq_work.func as a flag to determine whether req->work
+	 * is valid. If req->work.func is NULL, there is no need to drop
+	 * environment when freeing req.
+	 */
+	req->work.func = NULL;
 
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
-- 
2.17.2

