Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BBE216DA6
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 15:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgGGNZz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 09:25:55 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:48419 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbgGGNZz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 09:25:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01358;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U222y8y_1594128351;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U222y8y_1594128351)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Jul 2020 21:25:52 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [LIBURING] Check cq ring overflow status
Date:   Tue,  7 Jul 2020 21:25:41 +0800
Message-Id: <20200707132541.2107-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If cq ring has been overflowed, need to enter kernel to flush cqes.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 src/include/liburing.h          |  1 +
 src/include/liburing/io_uring.h |  2 +-
 src/queue.c                     | 22 +++++++++++++++++-----
 src/setup.c                     |  2 ++
 4 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 0505a4f..9f7df1f 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -46,6 +46,7 @@ struct io_uring_cq {
 	unsigned *kring_entries;
 	unsigned *kflags;
 	unsigned *koverflow;
+	unsigned *kcheck_overflow;
 	struct io_uring_cqe *cqes;
 
 	size_t ring_sz;
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 6a73522..15e273b 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -211,7 +211,7 @@ struct io_cqring_offsets {
 	__u32 overflow;
 	__u32 cqes;
 	__u32 flags;
-	__u32 resv1;
+	__u32 check_overflow;
 	__u64 resv2;
 };
 
diff --git a/src/queue.c b/src/queue.c
index 88e0294..36f00bf 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -32,6 +32,14 @@ static inline bool sq_ring_needs_enter(struct io_uring *ring,
 	return false;
 }
 
+static inline bool cq_ring_needs_flush(struct io_uring *ring)
+{
+	if (!ring->cq.kcheck_overflow)
+		return false;
+
+	return IO_URING_READ_ONCE(*ring->cq.kcheck_overflow);
+}
+
 static int __io_uring_peek_cqe(struct io_uring *ring,
 			       struct io_uring_cqe **cqe_ptr)
 {
@@ -68,21 +76,25 @@ int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 
 	do {
 		unsigned flags = 0;
+		bool cq_overflow_flush = false;
 
 		err = __io_uring_peek_cqe(ring, &cqe);
 		if (err)
 			break;
-		if (!cqe && !to_wait && !submit) {
-			err = -EAGAIN;
-			break;
+		if (!cqe) {
+			cq_overflow_flush = cq_ring_needs_flush(ring);
+			if (!to_wait && !submit && !cq_overflow_flush) {
+				err = -EAGAIN;
+				break;
+			}
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
diff --git a/src/setup.c b/src/setup.c
index 860c112..1a03cc3 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -78,6 +78,8 @@ err:
 	cq->cqes = cq->ring_ptr + p->cq_off.cqes;
 	if (p->cq_off.flags)
 		cq->kflags = cq->ring_ptr + p->cq_off.flags;
+	if (p->cq_off.check_overflow)
+		cq->kcheck_overflow = cq->ring_ptr + p->cq_off.check_overflow;
 	return 0;
 }
 
-- 
2.17.2

