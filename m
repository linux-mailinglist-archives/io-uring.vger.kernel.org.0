Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD269175296
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2020 05:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgCBES3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 23:18:29 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:52968 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726811AbgCBES3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 23:18:29 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TrLQbs1_1583122698;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TrLQbs1_1583122698)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 02 Mar 2020 12:18:23 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] __io_uring_get_cqe: eliminate unnecessary io_uring_enter() syscalls
Date:   Mon,  2 Mar 2020 12:18:11 +0800
Message-Id: <20200302041811.13330-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When user applis programming mode, like sumbit one sqe and wait its
completion event, __io_uring_get_cqe() will result in many unnecessary
syscalls, see below test program:

    int main(int argc, char *argv[])
    {
            struct io_uring ring;
            int fd, ret;
            struct io_uring_sqe *sqe;
            struct io_uring_cqe *cqe;
            struct iovec iov;
            off_t offset, filesize = 0;
            void *buf;

            if (argc < 2) {
                    printf("%s: file\n", argv[0]);
                    return 1;
            }

            ret = io_uring_queue_init(4, &ring, 0);
            if (ret < 0) {
                    fprintf(stderr, "queue_init: %s\n", strerror(-ret));
                    return 1;
            }

            fd = open(argv[1], O_RDONLY | O_DIRECT);
            if (fd < 0) {
                    perror("open");
                    return 1;
            }

            if (posix_memalign(&buf, 4096, 4096))
                    return 1;
            iov.iov_base = buf;
            iov.iov_len = 4096;

            offset = 0;
            do {
                    sqe = io_uring_get_sqe(&ring);
                    if (!sqe) {
                            printf("here\n");
                            break;
                    }
                    io_uring_prep_readv(sqe, fd, &iov, 1, offset);

                    ret = io_uring_submit(&ring);
                    if (ret < 0) {
                            fprintf(stderr, "io_uring_submit: %s\n", strerror(-ret));
                            return 1;
                    }

                    ret = io_uring_wait_cqe(&ring, &cqe);
                    if (ret < 0) {
                            fprintf(stderr, "io_uring_wait_cqe: %s\n", strerror(-ret));
                            return 1;
                    }

                    if (cqe->res <= 0) {
                            if (cqe->res < 0) {
                                    fprintf(stderr, "got eror: %d\n", cqe->res);
                                    ret = 1;
                            }
                            io_uring_cqe_seen(&ring, cqe);
                            break;
                    }
                    offset += cqe->res;
                    filesize += cqe->res;
                    io_uring_cqe_seen(&ring, cqe);
            } while (1);

            printf("filesize: %ld\n", filesize);
            close(fd);
            io_uring_queue_exit(&ring);
            return 0;
    }

dd if=/dev/zero of=testfile bs=4096 count=16
./test  testfile
and use bpftrace to trace io_uring_enter syscalls, in original codes,
[lege@localhost ~]$ sudo bpftrace -e "tracepoint:syscalls:sys_enter_io_uring_enter {@c[tid] = count();}"
Attaching 1 probe...
@c[11184]: 49
Above test issues 49 syscalls, it's counterintuitive. After looking
into the codes, it's because __io_uring_get_cqe issue one more syscall,
indded when __io_uring_get_cqe issues the first syscall, one cqe should
already be ready, we don't need to wait again.

To fix this issue, after the first syscall, set wait_nr to be zero, with
tihs patch, bpftrace shows the number of io_uring_enter syscall is 33.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 src/queue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/queue.c b/src/queue.c
index ef2cc2b..99a4a0c 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -53,6 +53,8 @@ int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 		if (wait_nr || submit)
 			ret = __sys_io_uring_enter(ring->ring_fd, submit,
 						   wait_nr, flags, sigmask);
+		if (wait_nr)
+			wait_nr = 0;
 		if (ret < 0)
 			err = -errno;
 		submit -= ret;
-- 
2.17.2

