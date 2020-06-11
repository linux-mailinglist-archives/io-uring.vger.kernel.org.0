Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A1E1F6105
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2020 06:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgFKEeM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Jun 2020 00:34:12 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:38991 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbgFKEeM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Jun 2020 00:34:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.Eflrs_1591850040;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U.Eflrs_1591850040)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 11 Jun 2020 12:34:01 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH] change poll_events to 32 bits to cover EPOLLEXCLUSIVE
Date:   Thu, 11 Jun 2020 12:34:00 +0800
Message-Id: <1591850040-118753-1-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jiufei Xue <jiufei.xue@alibaba.linux.com>

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 man/io_uring_enter.2            | 2 +-
 src/include/liburing.h          | 2 +-
 src/include/liburing/io_uring.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 188398b..d0d5538 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -125,7 +125,7 @@ struct io_uring_sqe {
     union {
         __kernel_rwf_t  rw_flags;
         __u32    fsync_flags;
-        __u16    poll_events;
+        __u32    poll_events;
         __u32    sync_range_flags;
         __u32    msg_flags;
         __u32    timeout_flags;
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 0192b47..b1659cc 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -253,7 +253,7 @@ static inline void io_uring_prep_sendmsg(struct io_uring_sqe *sqe, int fd,
 }
 
 static inline void io_uring_prep_poll_add(struct io_uring_sqe *sqe, int fd,
-					  short poll_mask)
+					  unsigned poll_mask)
 {
 	io_uring_prep_rw(IORING_OP_POLL_ADD, sqe, fd, NULL, 0, 0);
 	sqe->poll_events = poll_mask;
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 92c2269..afc7edd 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -31,7 +31,7 @@ struct io_uring_sqe {
 	union {
 		__kernel_rwf_t	rw_flags;
 		__u32		fsync_flags;
-		__u16		poll_events;
+		__u32		poll_events;
 		__u32		sync_range_flags;
 		__u32		msg_flags;
 		__u32		timeout_flags;
-- 
1.8.3.1

