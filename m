Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A89356B11
	for <lists+io-uring@lfdr.de>; Wed,  7 Apr 2021 13:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhDGLY1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 07:24:27 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:46804 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245718AbhDGLYQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 07:24:16 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UUnhk8L_1617794605;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUnhk8L_1617794605)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 07 Apr 2021 19:23:31 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 3/3] io_uring: use REQ_F_MULTI_CQES for multipoll IORING_OP_ADD
Date:   Wed,  7 Apr 2021 19:23:25 +0800
Message-Id: <1617794605-35748-4-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
References: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

leverage REQ_F_MULTI_CQES to suppoort IORING_OP_ADD multishot.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c                 | 13 ++++++++++---
 include/uapi/linux/io_uring.h |  5 -----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a7bd223ce2cc..952ad0ddb2db 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5361,20 +5361,27 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 {
 	struct io_poll_iocb *poll = &req->poll;
 	u32 events, flags;
+	bool multishot = req->flags & REQ_F_MULTI_CQES;
+	u32 update_bits = IORING_POLL_UPDATE_EVENTS |
+		IORING_POLL_UPDATE_USER_DATA;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->len);
-	if (flags & ~(IORING_POLL_ADD_MULTI | IORING_POLL_UPDATE_EVENTS |
-			IORING_POLL_UPDATE_USER_DATA))
+	/*
+	 * can't set REQ_F_MULTI_CQES with UPDATE flags, otherwise we count
+	 * IO_POLL_ADD(IORING_POLL_UPDATE_*)'s cqe to ctx->cq_extra, which
+	 * we shouldn't
+	 */
+	if ((flags & ~update_bits) || (multishot && (flags & update_bits)))
 		return -EINVAL;
 	events = READ_ONCE(sqe->poll32_events);
 #ifdef __BIG_ENDIAN
 	events = swahw32(events);
 #endif
-	if (!(flags & IORING_POLL_ADD_MULTI))
+	if (!multishot)
 		events |= EPOLLONESHOT;
 	poll->update_events = poll->update_user_data = false;
 	if (flags & IORING_POLL_UPDATE_EVENTS) {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 303ac8005572..a3cd943b228e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -166,14 +166,9 @@ enum {
  * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
  * command flags for POLL_ADD are stored in sqe->len.
  *
- * IORING_POLL_ADD_MULTI	Multishot poll. Sets IORING_CQE_F_MORE if
- *				the poll handler will continue to report
- *				CQEs on behalf of the same SQE.
- *
  * IORING_POLL_UPDATE		Update existing poll request, matching
  *				sqe->addr as the old user_data field.
  */
-#define IORING_POLL_ADD_MULTI	(1U << 0)
 #define IORING_POLL_UPDATE_EVENTS	(1U << 1)
 #define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
 
-- 
1.8.3.1

