Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100A2216D9F
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 15:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgGGNYg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 09:24:36 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:34776 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726745AbgGGNYg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 09:24:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01419;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U22DYQH_1594128271;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U22DYQH_1594128271)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Jul 2020 21:24:32 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: export cq overflow status to userspace
Date:   Tue,  7 Jul 2020 21:24:20 +0800
Message-Id: <20200707132420.2007-1-xiaoguang.wang@linux.alibaba.com>
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

To fix this issue, export cq overflow status to userspace, then
helper functions() in liburing, such as io_uring_peek_cqe, can be
aware of this cq overflow and do flush accordingly.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c                 | 12 ++++++++++++
 include/uapi/linux/io_uring.h |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d37d7ea5ebe5..30f50d72b6d5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -157,6 +157,14 @@ struct io_rings {
 	 * kernel.
 	 */
 	u32                     cq_flags;
+	/*
+	 * Runtime CQ overflow flags
+	 *
+	 * Written by the kernel, shouldn't be modified by the
+	 * application.
+	 *
+	 */
+	u32                     cq_check_overflow;
 	/*
 	 * Number of completion events lost because the queue was full;
 	 * this should be avoided by the application by making sure
@@ -1274,6 +1282,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	if (cqe) {
 		clear_bit(0, &ctx->sq_check_overflow);
 		clear_bit(0, &ctx->cq_check_overflow);
+		WRITE_ONCE(ctx->rings->cq_check_overflow, 0);
 	}
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	io_cqring_ev_posted(ctx);
@@ -1311,6 +1320,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 		if (list_empty(&ctx->cq_overflow_list)) {
 			set_bit(0, &ctx->sq_check_overflow);
 			set_bit(0, &ctx->cq_check_overflow);
+			WRITE_ONCE(ctx->rings->cq_check_overflow, 1);
 		}
 		req->flags |= REQ_F_OVERFLOW;
 		refcount_inc(&req->refs);
@@ -7488,6 +7498,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			if (list_empty(&ctx->cq_overflow_list)) {
 				clear_bit(0, &ctx->sq_check_overflow);
 				clear_bit(0, &ctx->cq_check_overflow);
+				WRITE_ONCE(ctx->rings->cq_check_overflow, 0);
 			}
 			spin_unlock_irq(&ctx->completion_lock);
 
@@ -7960,6 +7971,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
 	p->cq_off.cqes = offsetof(struct io_rings, cqes);
 	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
+	p->cq_off.check_overflow = offsetof(struct io_rings, cq_check_overflow);
 
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92c22699a5a7..2ae6adc6d22d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -206,7 +206,7 @@ struct io_cqring_offsets {
 	__u32 overflow;
 	__u32 cqes;
 	__u32 flags;
-	__u32 resv1;
+	__u32 check_overflow;
 	__u64 resv2;
 };
 
-- 
2.17.2

