Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DCE219586
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 03:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgGIBPm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 21:15:42 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:38279 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726082AbgGIBPm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 21:15:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U29MME3_1594257339;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U29MME3_1594257339)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Jul 2020 09:15:39 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH v2] io_uring: export cq overflow status to userspace
Date:   Thu,  9 Jul 2020 09:15:29 +0800
Message-Id: <20200709011529.13605-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For those applications which are not willing to use io_uring_enter()
to reap and handle cqes, they may completely rely on liburing's
io_uring_peek_cqe(), but if cq ring has overflowed, currently because
io_uring_peek_cqe() is not aware of this overflow, it won't enter
kernel to flush cqes, below test program can reveal this bug:

static void test_cq_overflow(struct io_uring *ring)
{
        struct io_uring_cqe *cqe;
        struct io_uring_sqe *sqe;
        int issued = 0;
        int ret = 0;

        do {
                sqe = io_uring_get_sqe(ring);
                if (!sqe) {
                        fprintf(stderr, "get sqe failed\n");
                        break;;
                }
                ret = io_uring_submit(ring);
                if (ret <= 0) {
                        if (ret != -EBUSY)
                                fprintf(stderr, "sqe submit failed: %d\n", ret);
                        break;
                }
                issued++;
        } while (ret > 0);
        assert(ret == -EBUSY);

        printf("issued requests: %d\n", issued);

        while (issued) {
                ret = io_uring_peek_cqe(ring, &cqe);
                if (ret) {
                        if (ret != -EAGAIN) {
                                fprintf(stderr, "peek completion failed: %s\n",
                                        strerror(ret));
                                break;
                        }
                        printf("left requets: %d\n", issued);
                        continue;
                }
                io_uring_cqe_seen(ring, cqe);
                issued--;
                printf("left requets: %d\n", issued);
        }
}

int main(int argc, char *argv[])
{
        int ret;
        struct io_uring ring;

        ret = io_uring_queue_init(16, &ring, 0);
        if (ret) {
                fprintf(stderr, "ring setup failed: %d\n", ret);
                return 1;
        }

        test_cq_overflow(&ring);
        return 0;
}

To fix this issue, export cq overflow status to userspace by adding new
IORING_SQ_CQ_OVERFLOW flag, then helper functions() in liburing, such as
io_uring_peek_cqe, can be aware of this cq overflow and do flush accordingly.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c                 | 11 +++++++++--
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d37d7ea5ebe5..32e37c38f274 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1274,6 +1274,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	if (cqe) {
 		clear_bit(0, &ctx->sq_check_overflow);
 		clear_bit(0, &ctx->cq_check_overflow);
+		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
 	}
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	io_cqring_ev_posted(ctx);
@@ -1311,6 +1312,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 		if (list_empty(&ctx->cq_overflow_list)) {
 			set_bit(0, &ctx->sq_check_overflow);
 			set_bit(0, &ctx->cq_check_overflow);
+			ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
 		}
 		req->flags |= REQ_F_OVERFLOW;
 		refcount_inc(&req->refs);
@@ -6080,9 +6082,9 @@ static int io_sq_thread(void *data)
 			}
 
 			/* Tell userspace we may need a wakeup call */
+			spin_lock_irq(&ctx->completion_lock);
 			ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
-			/* make sure to read SQ tail after writing flags */
-			smp_mb();
+			spin_unlock_irq(&ctx->completion_lock);
 
 			to_submit = io_sqring_entries(ctx);
 			if (!to_submit || ret == -EBUSY) {
@@ -6100,13 +6102,17 @@ static int io_sq_thread(void *data)
 				schedule();
 				finish_wait(&ctx->sqo_wait, &wait);
 
+				spin_lock_irq(&ctx->completion_lock);
 				ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
+				spin_unlock_irq(&ctx->completion_lock);
 				ret = 0;
 				continue;
 			}
 			finish_wait(&ctx->sqo_wait, &wait);
 
+			spin_lock_irq(&ctx->completion_lock);
 			ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
+			spin_unlock_irq(&ctx->completion_lock);
 		}
 
 		mutex_lock(&ctx->uring_lock);
@@ -7488,6 +7494,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			if (list_empty(&ctx->cq_overflow_list)) {
 				clear_bit(0, &ctx->sq_check_overflow);
 				clear_bit(0, &ctx->cq_check_overflow);
+				ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
 			}
 			spin_unlock_irq(&ctx->completion_lock);
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92c22699a5a7..7843742b8b74 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -197,6 +197,7 @@ struct io_sqring_offsets {
  * sq_ring->flags
  */
 #define IORING_SQ_NEED_WAKEUP	(1U << 0) /* needs io_uring_enter wakeup */
+#define IORING_SQ_CQ_OVERFLOW	(1U << 1) /* CQ ring is overflown */
 
 struct io_cqring_offsets {
 	__u32 head;
-- 
2.17.2

