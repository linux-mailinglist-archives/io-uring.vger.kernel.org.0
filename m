Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE4D219587
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 03:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgGIBQa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 21:16:30 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:23958 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726082AbgGIBQ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 21:16:29 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U29Mjxe_1594257387;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U29Mjxe_1594257387)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Jul 2020 09:16:27 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [LIBURING v2] Check cq ring overflow status
Date:   Thu,  9 Jul 2020 09:16:20 +0800
Message-Id: <20200709011620.13666-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If cq ring has been overflowed, need to enter kernel to flush cqes.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 src/include/liburing/io_uring.h |  1 +
 src/queue.c                     | 17 +++++++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 6a73522..8302717 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -202,6 +202,7 @@ struct io_sqring_offsets {
  * sq_ring->flags
  */
 #define IORING_SQ_NEED_WAKEUP	(1U << 0) /* needs io_uring_enter wakeup */
+#define IORING_SQ_CQ_OVERFLOW	(1U << 1) /* CQ ring is overflown */
 
 struct io_cqring_offsets {
 	__u32 head;
diff --git a/src/queue.c b/src/queue.c
index 88e0294..1f00251 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -32,6 +32,11 @@ static inline bool sq_ring_needs_enter(struct io_uring *ring,
 	return false;
 }
 
+static inline bool cq_ring_needs_flush(struct io_uring *ring)
+{
+	return IO_URING_READ_ONCE(*ring->sq.kflags) & IORING_SQ_CQ_OVERFLOW;
+}
+
 static int __io_uring_peek_cqe(struct io_uring *ring,
 			       struct io_uring_cqe **cqe_ptr)
 {
@@ -67,22 +72,26 @@ int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 	int ret = 0, err;
 
 	do {
+		bool cq_overflow_flush = false;
 		unsigned flags = 0;
 
 		err = __io_uring_peek_cqe(ring, &cqe);
 		if (err)
 			break;
 		if (!cqe && !to_wait && !submit) {
-			err = -EAGAIN;
-			break;
+			if (!cq_ring_needs_flush(ring)) {
+				err = -EAGAIN;
+				break;
+			}
+			cq_overflow_flush = true;
 		}
 		if (wait_nr && cqe)
 			wait_nr--;
-		if (wait_nr)
+		if (wait_nr || cq_overflow_flush)
 			flags = IORING_ENTER_GETEVENTS;
 		if (submit)
 			sq_ring_needs_enter(ring, submit, &flags);
-		if (wait_nr || submit)
+		if (wait_nr || submit || cq_overflow_flush)
 			ret = __sys_io_uring_enter(ring->ring_fd, submit,
 						   wait_nr, flags, sigmask);
 		if (ret < 0) {
-- 
2.17.2

