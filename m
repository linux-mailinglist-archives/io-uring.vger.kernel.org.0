Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2144D1F64AD
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2020 11:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgFKJZW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Jun 2020 05:25:22 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:35106 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726560AbgFKJZW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Jun 2020 05:25:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0U.G8I9p_1591867511;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U.G8I9p_1591867511)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 11 Jun 2020 17:25:18 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: fix io_kiocb.flags modification race in IOPOLL mode
Date:   Thu, 11 Jun 2020 17:25:10 +0800
Message-Id: <20200611092510.2963-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While testing io_uring in arm, we found sometimes io_sq_thread() keeps
polling io requests even though there are not inflight io requests in
block layer. After some investigations, found a possible race about
io_kiocb.flags, see below race codes:
  1) in the end of io_write() or io_read()
    req->flags &= ~REQ_F_NEED_CLEANUP;
    kfree(iovec);
    return ret;

  2) in io_complete_rw_iopoll()
    if (res != -EAGAIN)
        req->flags |= REQ_F_IOPOLL_COMPLETED;

In IOPOLL mode, io requests still maybe completed by interrupt, then
above codes are not safe, concurrent modifications to req->flags, which
is not protected by lock or is not atomic modifications. I also had
disassemble io_complete_rw_iopoll() in arm:
   req->flags |= REQ_F_IOPOLL_COMPLETED;
   0xffff000008387b18 <+76>:    ldr     w0, [x19,#104]
   0xffff000008387b1c <+80>:    orr     w0, w0, #0x1000
   0xffff000008387b20 <+84>:    str     w0, [x19,#104]

Seems that the "req->flags |= REQ_F_IOPOLL_COMPLETED;" is  load and
modification, two instructions, which obviously is not atomic.

To fix this issue, add a new iopoll_completed in io_kiocb to indicate
whether io request is completed.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5b0249140ff5..0e57ca627af2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -529,7 +529,6 @@ enum {
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
 	REQ_F_NOWAIT_BIT,
-	REQ_F_IOPOLL_COMPLETED_BIT,
 	REQ_F_LINK_TIMEOUT_BIT,
 	REQ_F_TIMEOUT_BIT,
 	REQ_F_ISREG_BIT,
@@ -574,8 +573,6 @@ enum {
 	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
 	/* must not punt to workers */
 	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),
-	/* polled IO has completed */
-	REQ_F_IOPOLL_COMPLETED	= BIT(REQ_F_IOPOLL_COMPLETED_BIT),
 	/* has linked timeout */
 	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
 	/* timeout request */
@@ -640,6 +637,8 @@ struct io_kiocb {
 	struct io_async_ctx		*io;
 	int				cflags;
 	u8				opcode;
+	/* polled IO has completed */
+	u8				iopoll_completed;
 
 	u16				buf_index;
 
@@ -1798,7 +1797,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		 * If we find a request that requires polling, break out
 		 * and complete those lists first, if we have entries there.
 		 */
-		if (req->flags & REQ_F_IOPOLL_COMPLETED) {
+		if (req->iopoll_completed) {
 			list_move_tail(&req->list, &done);
 			continue;
 		}
@@ -1979,7 +1978,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 		req_set_fail_links(req);
 	req->result = res;
 	if (res != -EAGAIN)
-		req->flags |= REQ_F_IOPOLL_COMPLETED;
+		req->iopoll_completed = 1;
 }
 
 /*
@@ -2012,7 +2011,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	 * For fast devices, IO may have already completed. If it has, add
 	 * it to the front so we find it first.
 	 */
-	if (req->flags & REQ_F_IOPOLL_COMPLETED)
+	if (req->iopoll_completed)
 		list_add(&req->list, &ctx->poll_list);
 	else
 		list_add_tail(&req->list, &ctx->poll_list);
@@ -2140,6 +2139,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->result = 0;
+		req->iopoll_completed = 0;
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
-- 
2.17.2

