Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6201D1A637C
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 09:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbgDMHUB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 03:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbgDMHUB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 03:20:01 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492FFC008651
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 00:20:01 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01355;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TvMjkZq_1586762393;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TvMjkZq_1586762393)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 13 Apr 2020 15:19:58 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [LIBURING PATCH] sq_ring_needs_enter: check whether there are sqes when SQPOLL is not enabled
Date:   Mon, 13 Apr 2020 15:19:40 +0800
Message-Id: <20200413071940.5156-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Indeed I'm not sure this patch is necessary, robust applications
should not call io_uring_submit when there are not sqes to submmit.
But still try to add this check, I have seen some applications which
call io_uring_submit(), but there are not sqes to submit.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 src/queue.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index e563775..75d707d 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -19,9 +19,10 @@
  * or if IORING_SQ_NEED_WAKEUP is set, so submit thread must be explicitly
  * awakened. For the latter case, we set the thread wakeup flag.
  */
-static inline bool sq_ring_needs_enter(struct io_uring *ring, unsigned *flags)
+static inline bool sq_ring_needs_enter(struct io_uring *ring,
+				unsigned submitted, unsigned *flags)
 {
-	if (!(ring->flags & IORING_SETUP_SQPOLL))
+	if (!(ring->flags & IORING_SETUP_SQPOLL) && submitted)
 		return true;
 	if (IO_URING_READ_ONCE(*ring->sq.kflags) & IORING_SQ_NEED_WAKEUP) {
 		*flags |= IORING_ENTER_SQ_WAKEUP;
@@ -51,7 +52,7 @@ int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 		if (wait_nr)
 			flags = IORING_ENTER_GETEVENTS;
 		if (submit)
-			sq_ring_needs_enter(ring, &flags);
+			sq_ring_needs_enter(ring, submit, &flags);
 		if (wait_nr || submit)
 			ret = __sys_io_uring_enter(ring->ring_fd, submit,
 						   wait_nr, flags, sigmask);
@@ -197,7 +198,7 @@ static int __io_uring_submit(struct io_uring *ring, unsigned submitted,
 	int ret;
 
 	flags = 0;
-	if (sq_ring_needs_enter(ring, &flags) || wait_nr) {
+	if (sq_ring_needs_enter(ring, submitted, &flags) || wait_nr) {
 		if (wait_nr || (ring->flags & IORING_SETUP_IOPOLL))
 			flags |= IORING_ENTER_GETEVENTS;
 
-- 
2.17.2

