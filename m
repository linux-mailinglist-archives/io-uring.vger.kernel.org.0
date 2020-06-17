Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8201FCA8E
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 12:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgFQKNX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Jun 2020 06:13:23 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:36726 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726134AbgFQKNX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Jun 2020 06:13:23 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.rVcze_1592388799;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U.rVcze_1592388799)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 17 Jun 2020 18:13:19 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH v2] change poll_events to 32 bits to cover EPOLLEXCLUSIVE
Date:   Wed, 17 Jun 2020 18:13:19 +0800
Message-Id: <1592388799-102449-1-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 man/io_uring_enter.2            | 3 ++-
 src/include/liburing.h          | 8 ++++++--
 src/include/liburing/io_uring.h | 4 +++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 188398b..e327671 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -125,7 +125,8 @@ struct io_uring_sqe {
     union {
         __kernel_rwf_t  rw_flags;
         __u32    fsync_flags;
-        __u16    poll_events;
+        __u16    poll_events;   /* compatibility */
+        __u32    poll32_events; /* word-reversed for BE */
         __u32    sync_range_flags;
         __u32    msg_flags;
         __u32    timeout_flags;
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 0192b47..c9034fc 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -14,6 +14,7 @@ extern "C" {
 #include <stdbool.h>
 #include <inttypes.h>
 #include <time.h>
+#include <linux/swab.h>
 #include "liburing/compat.h"
 #include "liburing/io_uring.h"
 #include "liburing/barrier.h"
@@ -253,10 +254,13 @@ static inline void io_uring_prep_sendmsg(struct io_uring_sqe *sqe, int fd,
 }
 
 static inline void io_uring_prep_poll_add(struct io_uring_sqe *sqe, int fd,
-					  short poll_mask)
+					  unsigned poll_mask)
 {
 	io_uring_prep_rw(IORING_OP_POLL_ADD, sqe, fd, NULL, 0, 0);
-	sqe->poll_events = poll_mask;
+#if __BYTE_ORDER == __BIG_ENDIAN
+	poll_mask = __swahw32(poll_mask);
+#endif
+	sqe->poll32_events = poll_mask;
 }
 
 static inline void io_uring_prep_poll_remove(struct io_uring_sqe *sqe,
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 92c2269..785a6a4 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -31,7 +31,8 @@ struct io_uring_sqe {
 	union {
 		__kernel_rwf_t	rw_flags;
 		__u32		fsync_flags;
-		__u16		poll_events;
+		__u16 		poll_events;	/* compatibility */
+		__u32		poll32_events;	/* word-reversed for BE */
 		__u32		sync_range_flags;
 		__u32		msg_flags;
 		__u32		timeout_flags;
@@ -248,6 +249,7 @@ struct io_uring_params {
 #define IORING_FEAT_RW_CUR_POS		(1U << 3)
 #define IORING_FEAT_CUR_PERSONALITY	(1U << 4)
 #define IORING_FEAT_FAST_POLL		(1U << 5)
+#define IORING_FEAT_POLL_32BITS		(1U << 6)
 
 /*
  * io_uring_register(2) opcodes and arguments
-- 
1.8.3.1

