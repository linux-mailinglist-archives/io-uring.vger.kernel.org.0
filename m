Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C53A438EF2
	for <lists+io-uring@lfdr.de>; Mon, 25 Oct 2021 07:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhJYFlO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 01:41:14 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:37461 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229499AbhJYFlO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 01:41:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UtW1kk9_1635140330;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UtW1kk9_1635140330)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Oct 2021 13:38:50 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [PATCH v3 1/3] io_uring: refactor event check out of __io_async_wake()
Date:   Mon, 25 Oct 2021 13:38:47 +0800
Message-Id: <20211025053849.3139-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
References: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Which is a preparation for following patch, and here try to inline
__io_async_wake(), which is simple and can save a function call.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 736d456e7913..18af9bb9a4bc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5228,13 +5228,9 @@ struct io_poll_table {
 	int error;
 };
 
-static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
+static inline int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, io_req_tw_func_t func)
 {
-	/* for instances that support it check for an event match first: */
-	if (mask && !(mask & poll->events))
-		return 0;
-
 	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
 
 	list_del_init(&poll->wait.entry);
@@ -5508,11 +5504,16 @@ static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 {
 	struct io_kiocb *req = wait->private;
 	struct io_poll_iocb *poll = &req->apoll->poll;
+	__poll_t mask = key_to_poll(key);
 
 	trace_io_uring_poll_wake(req->ctx, req->opcode, req->user_data,
 					key_to_poll(key));
 
-	return __io_async_wake(req, poll, key_to_poll(key), io_async_task_func);
+	/* for instances that support it check for an event match first: */
+	if (mask && !(mask & poll->events))
+		return 0;
+
+	return __io_async_wake(req, poll, mask, io_async_task_func);
 }
 
 static void io_poll_req_insert(struct io_kiocb *req)
@@ -5772,8 +5773,13 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 {
 	struct io_kiocb *req = wait->private;
 	struct io_poll_iocb *poll = &req->poll;
+	__poll_t mask = key_to_poll(key);
+
+	/* for instances that support it check for an event match first: */
+	if (mask && !(mask & poll->events))
+		return 0;
 
-	return __io_async_wake(req, poll, key_to_poll(key), io_poll_task_func);
+	return __io_async_wake(req, poll, mask, io_poll_task_func);
 }
 
 static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
-- 
2.14.4.44.g2045bb6

