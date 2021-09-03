Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C013FFE92
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 13:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348353AbhICLC6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 07:02:58 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:45082 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348412AbhICLC5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 07:02:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Un61DbM_1630666849;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Un61DbM_1630666849)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Sep 2021 19:00:59 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 5/6] io_uring: implement multishot mode for accept
Date:   Fri,  3 Sep 2021 19:00:48 +0800
Message-Id: <20210903110049.132958-6-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210903110049.132958-1-haoxu@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Refactor io_accept() to support multishot mode.

theoretical analysis:
  1) when connections come in fast
    - singleshot:
              add accept sqe(userpsace) --> accept inline
                              ^                 |
                              |-----------------|
    - multishot:
             add accept sqe(userspace) --> accept inline
                                              ^     |
                                              |--*--|

    we do accept repeatedly in * place until get EAGAIN

  2) when connections come in at a low pressure
    similar thing like 1), we reduce a lot of userspace-kernel context
    switch and useless vfs_poll()

tests:
Did some tests, which goes in this way:

  server    client(multiple)
  accept    connect
  read      write
  write     read
  close     close

Basically, raise up a number of clients(on same machine with server) to
connect to the server, and then write some data to it, the server will
write those data back to the client after it receives them, and then
close the connection after write return. Then the client will read the
data and then close the connection. Here I test 10000 clients connect
one server, data size 128 bytes. And each client has a go routine for
it, so they come to the server in short time.
test 20 times before/after this patchset, time spent:(unit cycle, which
is the return value of clock())
before:
  1930136+1940725+1907981+1947601+1923812+1928226+1911087+1905897+1941075
  +1934374+1906614+1912504+1949110+1908790+1909951+1941672+1969525+1934984
  +1934226+1914385)/20.0 = 1927633.75
after:
  1858905+1917104+1895455+1963963+1892706+1889208+1874175+1904753+1874112
  +1874985+1882706+1884642+1864694+1906508+1916150+1924250+1869060+1889506
  +1871324+1940803)/20.0 = 1894750.45

(1927633.75 - 1894750.45) / 1927633.75 = 1.65%

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

not sure if we should cancel it when io_cqring_fill_event() reurn false

 fs/io_uring.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dae7044e0c24..eb81d37dce78 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4885,16 +4885,18 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_accept *accept = &req->accept;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
 	bool fixed = !!accept->file_slot;
 	struct file *file;
-	int ret, fd;
+	int ret, ret2 = 0, fd;
 
 	if (req->file->f_flags & O_NONBLOCK)
 		req->flags |= REQ_F_NOWAIT;
 
+retry:
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
 		if (unlikely(fd < 0))
@@ -4906,20 +4908,42 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		if (!fixed)
 			put_unused_fd(fd);
 		ret = PTR_ERR(file);
-		if (ret == -EAGAIN && force_nonblock)
-			return -EAGAIN;
+		if (ret == -EAGAIN && force_nonblock) {
+			if ((req->flags & (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)) ==
+			    (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED))
+				ret = 0;
+			return ret;
+		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
 	} else if (!fixed) {
 		fd_install(fd, file);
 		ret = fd;
+		/*
+		 * if it's in multishot mode, let's return -EAGAIN to make it go
+		 * into fast poll path
+		 */
+		if ((req->flags & REQ_F_APOLL_MULTISHOT) && force_nonblock &&
+		   !(req->flags & REQ_F_POLLED))
+			ret2 = -EAGAIN;
 	} else {
 		ret = io_install_fixed_file(req, file, issue_flags,
 					    accept->file_slot - 1);
 	}
-	__io_req_complete(req, issue_flags, ret, 0);
-	return 0;
+
+	if (req->flags & REQ_F_APOLL_MULTISHOT) {
+		spin_lock(&ctx->completion_lock);
+		if (io_cqring_fill_event(ctx, req->user_data, ret, 0)) {
+			io_commit_cqring(ctx);
+			ctx->cq_extra++;
+		}
+		spin_unlock(&ctx->completion_lock);
+		goto retry;
+	} else {
+		__io_req_complete(req, issue_flags, ret, 0);
+	}
+	return ret2;
 }
 
 static int io_connect_prep_async(struct io_kiocb *req)
-- 
2.24.4

