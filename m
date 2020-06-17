Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDBA1FCA37
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 11:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgFQJyC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Jun 2020 05:54:02 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:53648 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726523AbgFQJyC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Jun 2020 05:54:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.rYDBV_1592387638;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U.rYDBV_1592387638)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 17 Jun 2020 17:53:58 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH v4 1/2] io_uring: change the poll type to be 32-bits
Date:   Wed, 17 Jun 2020 17:53:55 +0800
Message-Id: <1592387636-80105-2-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592387636-80105-1-git-send-email-jiufei.xue@linux.alibaba.com>
References: <1592387636-80105-1-git-send-email-jiufei.xue@linux.alibaba.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

poll events should be 32-bits to cover EPOLLEXCLUSIVE.

Explicit word-swap the poll32_events for big endian to make sure the ABI
is not changed.  We call this feature IORING_FEAT_POLL_32BITS,
applications who want to use EPOLLEXCLUSIVE should check the feature bit
first.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 fs/io_uring.c                 | 13 +++++++++----
 include/uapi/linux/io_uring.h |  4 +++-
 tools/io_uring/liburing.h     |  6 +++++-
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 155f3d8..fe935cf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4543,7 +4543,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_poll_iocb *poll = &req->poll;
-	u16 events;
+	u32 events;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4552,7 +4552,10 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	if (!poll->file)
 		return -EBADF;
 
-	events = READ_ONCE(sqe->poll_events);
+	events = READ_ONCE(sqe->poll32_events);
+#ifdef __BIG_ENDIAN
+	events = swahw32(events);
+#endif
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
 
 	get_task_struct(current);
@@ -7865,7 +7868,8 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
-			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL;
+			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
+			IORING_FEAT_POLL_32BITS;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
@@ -8154,7 +8158,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
 	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
 	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
-	BUILD_BUG_SQE_ELEM(28, __u16,  poll_events);
+	BUILD_BUG_SQE_ELEM(28, /* compat */ __u16,  poll_events);
+	BUILD_BUG_SQE_ELEM(28, __u32,  poll32_events);
 	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
 	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
 	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92c2269..8d03396 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -31,7 +31,8 @@ struct io_uring_sqe {
 	union {
 		__kernel_rwf_t	rw_flags;
 		__u32		fsync_flags;
-		__u16		poll_events;
+		__u16		poll_events;	/* compatibility */
+		__u32		poll32_events;	/* word-reversed for BE */
 		__u32		sync_range_flags;
 		__u32		msg_flags;
 		__u32		timeout_flags;
@@ -248,6 +249,7 @@ struct io_uring_params {
 #define IORING_FEAT_RW_CUR_POS		(1U << 3)
 #define IORING_FEAT_CUR_PERSONALITY	(1U << 4)
 #define IORING_FEAT_FAST_POLL		(1U << 5)
+#define IORING_FEAT_POLL_32BITS 	(1U << 6)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/tools/io_uring/liburing.h b/tools/io_uring/liburing.h
index 5f305c8..28a837b 100644
--- a/tools/io_uring/liburing.h
+++ b/tools/io_uring/liburing.h
@@ -10,6 +10,7 @@
 #include <string.h>
 #include "../../include/uapi/linux/io_uring.h"
 #include <inttypes.h>
+#include <linux/swab.h>
 #include "barrier.h"
 
 /*
@@ -145,11 +146,14 @@ static inline void io_uring_prep_write_fixed(struct io_uring_sqe *sqe, int fd,
 }
 
 static inline void io_uring_prep_poll_add(struct io_uring_sqe *sqe, int fd,
-					  short poll_mask)
+					  unsigned poll_mask)
 {
 	memset(sqe, 0, sizeof(*sqe));
 	sqe->opcode = IORING_OP_POLL_ADD;
 	sqe->fd = fd;
+#if __BYTE_ORDER == __BIG_ENDIAN
+	poll_mask = __swahw32(poll_mask);
+#endif
 	sqe->poll_events = poll_mask;
 }
 
-- 
1.8.3.1

