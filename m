Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039664EB489
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 22:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiC2UQF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 16:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiC2UQC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 16:16:02 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F7EE6161
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 13:14:18 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id k25so22369388iok.8
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 13:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u1pY2W0snvN8b8pItA8NDJVMvgn4k4rsChUbsLpgxt8=;
        b=MxK4L9ywJqOV5c4hpRhpYJoLo9zxsBgWkclWGAMCm/MXHdkxUqxaXjv03Pqo9fytLc
         0dXd4L3128Jgss/jA8gn+9r6FU+6AVQrzngU+C4EmG0rq1KQM05BVZwQOZ/yRCLbH3VS
         N8UL3huxz8VQ4623ahM0j+Ga5GXRvW+6limeO3Z7CvbtPzluv4hDbYLTNGgGLg5GBwt8
         yEivBk4TSSV9KDG6+35ocqxxq++U+vZYGjNGK02cJL1/x56BNtzV8PZjeFW55lU/Mve6
         ih4BmNKXdjNNonUKwdRWCXeqnvA9re21f/PkI6vI/dEVW8fPu+T4Ifd+MN7x7d+jQnFN
         njsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u1pY2W0snvN8b8pItA8NDJVMvgn4k4rsChUbsLpgxt8=;
        b=AgoASM7QmXpV6hXxAf9TJSxg3g1iWLz282A86JZX4mwguxIezX7VgQgAIYQnARbBVe
         MbIpNn5iiEJTErvX9IFstfWLplPMXlIroN88BtZyavjw46Nk6HOkvoapTbT0cOjA+ADr
         cBrxGW+fnvlt+VUX/MD/Y3bPilGiIwH1Pz+D6INSHaFh/Gbqw2BBSKdvK2bPBqM6phYl
         Z8EHU4MnuL5YhKDTevjmB0jEqE4sMPzFwlt8bDzN0fWVhiV+YCF08rUPAdqzfYfao0gG
         BMFmBVwArGUKu4v8mG0Ih9rju0MsGzMvjFQtpuhdvKoa2hKdzuZButSpKvu+y/6Qy3LS
         hozA==
X-Gm-Message-State: AOAM530M5fPS9xRd2oUu8NqIH6zOhdrKJ1pehbFutChZ1iwcNA6tOhfK
        LPY2SPc3Ebzmq+/VMKg1bRvl18xbDKGQFFfE
X-Google-Smtp-Source: ABdhPJwHSpC7cWKj+SPWM5ChVopC36GPt6eTGHT59XiAHhMikyWkq9BcqVh2Sa2DjJ7B5dqnhPo1bQ==
X-Received: by 2002:a05:6638:4187:b0:319:dc78:e47c with SMTP id az7-20020a056638418700b00319dc78e47cmr17311939jab.315.1648584857488;
        Tue, 29 Mar 2022 13:14:17 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v3-20020a5d9483000000b00640d3d4acabsm9606316ioj.44.2022.03.29.13.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 13:14:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: defer splice/tee file validity check until command issue
Date:   Tue, 29 Mar 2022 14:14:11 -0600
Message-Id: <20220329201413.73871-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220329201413.73871-1-axboe@kernel.dk>
References: <20220329201413.73871-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for not using the file at prep time, defer checking if this
file refers to a valid io_uring instance until issue time.

This also means we can get rid of the cleanup flag for splice and tee.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 49 +++++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3d0dbcd2f69c..0b89f35378fa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -655,10 +655,10 @@ struct io_epoll {
 
 struct io_splice {
 	struct file			*file_out;
-	struct file			*file_in;
 	loff_t				off_out;
 	loff_t				off_in;
 	u64				len;
+	int				splice_fd_in;
 	unsigned int			flags;
 };
 
@@ -1688,14 +1688,6 @@ static void io_prep_async_work(struct io_kiocb *req)
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
-
-	switch (req->opcode) {
-	case IORING_OP_SPLICE:
-	case IORING_OP_TEE:
-		if (!S_ISREG(file_inode(req->splice.file_in)->i_mode))
-			req->work.flags |= IO_WQ_WORK_UNBOUND;
-		break;
-	}
 }
 
 static void io_prep_async_link(struct io_kiocb *req)
@@ -4369,18 +4361,11 @@ static int __io_splice_prep(struct io_kiocb *req,
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	sp->file_in = NULL;
 	sp->len = READ_ONCE(sqe->len);
 	sp->flags = READ_ONCE(sqe->splice_flags);
-
 	if (unlikely(sp->flags & ~valid_flags))
 		return -EINVAL;
-
-	sp->file_in = io_file_get(req->ctx, req, READ_ONCE(sqe->splice_fd_in),
-				  (sp->flags & SPLICE_F_FD_IN_FIXED));
-	if (!sp->file_in)
-		return -EBADF;
-	req->flags |= REQ_F_NEED_CLEANUP;
+	sp->splice_fd_in = READ_ONCE(sqe->splice_fd_in);
 	return 0;
 }
 
@@ -4395,20 +4380,27 @@ static int io_tee_prep(struct io_kiocb *req,
 static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_splice *sp = &req->splice;
-	struct file *in = sp->file_in;
 	struct file *out = sp->file_out;
 	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
+	struct file *in;
 	long ret = 0;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
+
+	in = io_file_get(req->ctx, req, sp->splice_fd_in,
+				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!in) {
+		ret = -EBADF;
+		goto done;
+	}
+
 	if (sp->len)
 		ret = do_tee(in, out, sp->len, flags);
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		io_put_file(in);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-
+done:
 	if (ret != sp->len)
 		req_set_fail(req);
 	io_req_complete(req, ret);
@@ -4427,15 +4419,22 @@ static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_splice *sp = &req->splice;
-	struct file *in = sp->file_in;
 	struct file *out = sp->file_out;
 	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
 	loff_t *poff_in, *poff_out;
+	struct file *in;
 	long ret = 0;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
+	in = io_file_get(req->ctx, req, sp->splice_fd_in,
+				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!in) {
+		ret = -EBADF;
+		goto done;
+	}
+
 	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
 	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
 
@@ -4444,8 +4443,7 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		io_put_file(in);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-
+done:
 	if (ret != sp->len)
 		req_set_fail(req);
 	io_req_complete(req, ret);
@@ -7165,11 +7163,6 @@ static void io_clean_op(struct io_kiocb *req)
 			kfree(io->free_iov);
 			break;
 			}
-		case IORING_OP_SPLICE:
-		case IORING_OP_TEE:
-			if (!(req->splice.flags & SPLICE_F_FD_IN_FIXED))
-				io_put_file(req->splice.file_in);
-			break;
 		case IORING_OP_OPENAT:
 		case IORING_OP_OPENAT2:
 			if (req->open.filename)
-- 
2.35.1

