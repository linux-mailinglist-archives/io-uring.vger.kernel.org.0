Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1841F6102
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2020 06:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgFKEad (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Jun 2020 00:30:33 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:45494 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbgFKEad (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Jun 2020 00:30:33 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04397;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.EqLgj_1591849830;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U.EqLgj_1591849830)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 11 Jun 2020 12:30:30 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH v2] io_uring: add EPOLLEXCLUSIVE flag to aoid thundering herd type behavior
Date:   Thu, 11 Jun 2020 12:30:30 +0800
Message-Id: <1591849830-115806-1-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jiufei Xue <jiufei.xue@alibaba.linux.com>

Applications can use this flag to avoid accept thundering herd.
And poll_events should be changed to 32 bits to cover EPOLLEXCLUSIVE.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 fs/io_uring.c                 | 13 +++++++++----
 include/uapi/linux/io_uring.h |  2 +-
 tools/io_uring/liburing.h     |  2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 47790a2..03951ec 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4289,7 +4289,11 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 
 	pt->error = 0;
 	poll->head = head;
-	add_wait_queue(head, &poll->wait);
+
+	if (poll->events & EPOLLEXCLUSIVE)
+		add_wait_queue_exclusive(head, &poll->wait);
+	else
+		add_wait_queue(head, &poll->wait);
 }
 
 static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
@@ -4602,7 +4606,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_poll_iocb *poll = &req->poll;
-	u16 events;
+	u32 events;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4612,7 +4616,8 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return -EBADF;
 
 	events = READ_ONCE(sqe->poll_events);
-	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
+	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP |
+		       (events & EPOLLEXCLUSIVE);
 
 	get_task_struct(current);
 	req->task = current;
@@ -8196,7 +8201,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
 	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
 	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
-	BUILD_BUG_SQE_ELEM(28, __u16,  poll_events);
+	BUILD_BUG_SQE_ELEM(28, __u32,  poll_events);
 	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
 	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
 	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92c2269..afc7edd 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -31,7 +31,7 @@ struct io_uring_sqe {
 	union {
 		__kernel_rwf_t	rw_flags;
 		__u32		fsync_flags;
-		__u16		poll_events;
+		__u32		poll_events;
 		__u32		sync_range_flags;
 		__u32		msg_flags;
 		__u32		timeout_flags;
diff --git a/tools/io_uring/liburing.h b/tools/io_uring/liburing.h
index 5f305c8..094b9ec 100644
--- a/tools/io_uring/liburing.h
+++ b/tools/io_uring/liburing.h
@@ -145,7 +145,7 @@ static inline void io_uring_prep_write_fixed(struct io_uring_sqe *sqe, int fd,
 }
 
 static inline void io_uring_prep_poll_add(struct io_uring_sqe *sqe, int fd,
-					  short poll_mask)
+					  unsigned poll_mask)
 {
 	memset(sqe, 0, sizeof(*sqe));
 	sqe->opcode = IORING_OP_POLL_ADD;
-- 
1.8.3.1

