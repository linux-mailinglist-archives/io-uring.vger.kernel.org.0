Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066894EB278
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240042AbiC2RJd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 13:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240040AbiC2RJc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 13:09:32 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92749258FCF
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 10:07:49 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e18so12833701ilr.2
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 10:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UfMEPboT2YVS/T8tD5ArvJUKmHrNAZ2BSs/+fchjnrM=;
        b=wWpRLhd+7rjysLjUroNteiqpskKF2tMW9PERZ1yDobgZL3NYCWlQWpiTIdw9oe14M9
         SqsAm2KELNyXNIGxCC9qSsO27sLsZSdKi7QRY4KotVLzBB2Z4jpecgleg0OpERH+o8Ui
         PgsvY/xF9KLrZHc0bxBqEDy8f5YYy4GxAMnJYB5XZWKdaJD39bTPjWxtfH6NhS15fcHf
         +tL+dy9HUsBuDtNY3Mux/7FYsz6/qCGpkklvWnCjcKoFXAZX9gM6CLAWSOBGf1soycxT
         WnNnhZSDNmEHW794G3cFo48eZ8ZEJeLIoraOoc7vdKKeUMIlHu88aJQVzv2K0BDwwnwK
         ENmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UfMEPboT2YVS/T8tD5ArvJUKmHrNAZ2BSs/+fchjnrM=;
        b=QebSum5hQG+ezTOeYIZWtwgseW9fKS9iWQK8sxK09nhsjk87/V/Gf+knvFVqvdYot2
         piGRckhWwIZbZhzeOXGfmRrr4faSdRbDAkcRouO0mK6dqLAOnYui06bEPK9kRw3pmDnO
         9zFX3cyINhOaSJ7KVbOnroEK01cFiXW0wfYk3AZvLdmR8tEAVb4PntDL9gfFZk00k0lw
         JKMp3ZA+zkJ+RTFQ7u9kMwPINYE5pcH1Hm+Vmge4ZjCvcKPrZZ3aZNEkUdmHez5jm7fz
         NHn6qpB1n3nZAukzd7xOPM4TmYpg0ikzJeLPoRaBtSGjv9ww3jIgzS2h0o4JuD4TkQE+
         qvWg==
X-Gm-Message-State: AOAM530VRUNV0G/YgaQ+03Yp13vpiWgsa7r9lyQA84OYqiSb3puRnWwr
        gpdPnTQK4lb09XOPdcU+HI0OQMcQXYGj6heA
X-Google-Smtp-Source: ABdhPJwZyqNmYq9w/WXuJqEq33KRC5CXHRw6KQ9SOJakRClAkHfMc2AEyawMQI8r1iWw0AGI5Tpshw==
X-Received: by 2002:a92:d486:0:b0:2c7:b549:ede7 with SMTP id p6-20020a92d486000000b002c7b549ede7mr8994272ilg.84.1648573668679;
        Tue, 29 Mar 2022 10:07:48 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v3-20020a5d9483000000b00640d3d4acabsm9383069ioj.44.2022.03.29.10.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 10:07:48 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: defer splice/tee file validity check until command issue
Date:   Tue, 29 Mar 2022 11:07:40 -0600
Message-Id: <20220329170742.164434-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220329170742.164434-1-axboe@kernel.dk>
References: <20220329170742.164434-1-axboe@kernel.dk>
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
index 072a31400e6a..900049cb6a82 100644
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

