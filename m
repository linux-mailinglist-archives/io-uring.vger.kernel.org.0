Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774C51DA95E
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 06:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgETEle (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 00:41:34 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:50409 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgETEld (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 00:41:33 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Tz4XTU1_1589949681;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Tz4XTU1_1589949681)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 20 May 2020 12:41:30 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: reset -EBUSY error when io sq thread is waken up
Date:   Wed, 20 May 2020 12:40:59 +0800
Message-Id: <20200520044059.2308-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In io_sq_thread(), currently if we get an -EBUSY error, we will
won't clear it again, which will result in io_sq_thread() will
never have a chance to submit sqes again. Below test program test.c
can reveal this bug:

int main(int argc, char *argv[])
{
        struct io_uring ring;
        int i, fd, ret;
        struct io_uring_sqe *sqe;
        struct io_uring_cqe *cqe;
        struct iovec *iovecs;
        void *buf;
        struct io_uring_params p;

        if (argc < 2) {
                printf("%s: file\n", argv[0]);
                return 1;
        }

        memset(&p, 0, sizeof(p));
        p.flags = IORING_SETUP_SQPOLL;
        ret = io_uring_queue_init_params(4, &ring, &p);
        if (ret < 0) {
                fprintf(stderr, "queue_init: %s\n", strerror(-ret));
                return 1;
        }

        fd = open(argv[1], O_RDONLY | O_DIRECT);
        if (fd < 0) {
                perror("open");
                return 1;
        }

        iovecs = calloc(10, sizeof(struct iovec));
        for (i = 0; i < 10; i++) {
                if (posix_memalign(&buf, 4096, 4096))
                        return 1;
                iovecs[i].iov_base = buf;
                iovecs[i].iov_len = 4096;
        }

        ret = io_uring_register_files(&ring, &fd, 1);
        if (ret < 0) {
                fprintf(stderr, "%s: register %d\n", __FUNCTION__, ret);
                return ret;
        }

        for (i = 0; i < 10; i++) {
                sqe = io_uring_get_sqe(&ring);
                if (!sqe)
                        break;

                io_uring_prep_readv(sqe, 0, &iovecs[i], 1, 0);
                sqe->flags |= IOSQE_FIXED_FILE;

                ret = io_uring_submit(&ring);
                sleep(1);
                printf("submit %d\n", i);
        }

        for (i = 0; i < 10; i++) {
                io_uring_wait_cqe(&ring, &cqe);
                printf("receive: %d\n", i);
                if (cqe->res != 4096) {
                        fprintf(stderr, "ret=%d, wanted 4096\n", cqe->res);
                        ret = 1;
                }
                io_uring_cqe_seen(&ring, cqe);
        }

        close(fd);
        io_uring_queue_exit(&ring);
        return 0;
}
sudo ./test testfile
above command will hang on the tenth request, to fix this bug, when io
sq_thread is waken up, we reset the variable 'ret' to be zero.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6e51140a5722..747de5cdf38a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6045,6 +6045,8 @@ static int io_sq_thread(void *data)
 				finish_wait(&ctx->sqo_wait, &wait);
 
 				ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
+				if (ret == -EBUSY)
+					ret = 0;
 				continue;
 			}
 			finish_wait(&ctx->sqo_wait, &wait);
-- 
2.17.2

