Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987091F723B
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 04:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgFLCaX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Jun 2020 22:30:23 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:41346 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726326AbgFLCaX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Jun 2020 22:30:23 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.JoBwC_1591929020;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U.JoBwC_1591929020)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 12 Jun 2020 10:30:20 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH v3 1/2] io_uring: change the poll events to be 32-bits
Date:   Fri, 12 Jun 2020 10:30:17 +0800
Message-Id: <1591929018-73954-2-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591929018-73954-1-git-send-email-jiufei.xue@linux.alibaba.com>
References: <1591929018-73954-1-git-send-email-jiufei.xue@linux.alibaba.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

poll events should be 32-bits to cover EPOLLEXCLUSIVE.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 fs/io_uring.c                 | 4 ++--
 include/uapi/linux/io_uring.h | 2 +-
 tools/io_uring/liburing.h     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 47790a2..6250227 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4602,7 +4602,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_poll_iocb *poll = &req->poll;
-	u16 events;
+	u32 events;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -8196,7 +8196,7 @@ static int __init io_uring_init(void)
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

