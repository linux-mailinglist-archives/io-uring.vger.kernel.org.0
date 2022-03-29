Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB37C4EB279
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 19:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240044AbiC2RJe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 13:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240040AbiC2RJd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 13:09:33 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A35258FF1
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 10:07:50 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id 8so12836257ilq.4
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 10:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QYJcQdMVV6yG/WOGmHaLyG78TKo2EfZZaaRUzF05y3Y=;
        b=EuUDRfzz34TPMuiSNzN2o07cVfO16bLCf1arR+ojESyzONCT28BevBMgNm6AvckLEU
         OjST1xzuGIy+90ixCBj+jAenAjnnYrEpSHOnZAbZ0l97/mDgeWuf1BBBl1LOK10JC7bS
         dBR8UIaBB3wWQ9/xXikNIDEFsnkzHGmg+sWIR5LzzN7DbDorf5JfKQgV9DPCkUBUJJ/b
         mHNlIPjnL93QmLp2M24IQ3SWq1Wto3p+8svjdOWNZjvHyPWIZh++/HHed/B/klhlHqBV
         cHHlw/FJyFx8SwwtQ/oohW+BQF0j0z5BEvGYbndBOnfMV4PjTIETkRyZ4JSYf+CxZZRm
         gUPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QYJcQdMVV6yG/WOGmHaLyG78TKo2EfZZaaRUzF05y3Y=;
        b=kTwZHDmkdy1hHRAWDn+gNLUzgT6dhKszXyToZCJmOFG7OaxY5ih2HvTIAXD+/B9sRN
         5qD6EMxt+y2gAIdXaMWJKqGT7alJz6xGsaGhmFkLx7abeEdKW+qIz64YUWoP2+eugxPg
         h1Q9RU5lLDo+m5qw/Ss+k4PwBDP/pKJIWB13CqvopqiXHnQBl6yzzVea1I0ksIJfwjwP
         S9e9h0EaWWyEwr2r90UsQ5wxFL6kzm4Rz9YhjrF/OKzSuWTmw6sbtp5ma1Q9imyeJfJ6
         n4vtU4rS9IgwNgOi9aBtBC0hkf2CWzgrMbO5NBgM4i6MpWDreml8qNU6IIu5YmWt2H2X
         Mc3g==
X-Gm-Message-State: AOAM533tzrc6Gfst3iBEDdiHvzuhO+SmhPd00I1cK/3O9yVN8c4R19sQ
        6tGAXUdEA2EERqIxRAzD4zZMpEhkKlCq81sn
X-Google-Smtp-Source: ABdhPJwWIH8MnMNEszONpuWKElX+QoltFMGP+bmj1lh5zo98K35UryU7fwMrNh3DSPFLF9pqMPRsGQ==
X-Received: by 2002:a05:6e02:1c2a:b0:2c9:defa:d061 with SMTP id m10-20020a056e021c2a00b002c9defad061mr586917ilh.260.1648573669810;
        Tue, 29 Mar 2022 10:07:49 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v3-20020a5d9483000000b00640d3d4acabsm9383069ioj.44.2022.03.29.10.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 10:07:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: move read/write file prep state into actual opcode handler
Date:   Tue, 29 Mar 2022 11:07:41 -0600
Message-Id: <20220329170742.164434-5-axboe@kernel.dk>
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

In preparation for not necessarily having a file assigned at prep time,
defer any initialization associated with the file to when the opcode
handler is run.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 100 ++++++++++++++++++++++++++------------------------
 1 file changed, 52 insertions(+), 48 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 900049cb6a82..52fa0613b442 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3177,42 +3177,12 @@ static inline bool io_file_supports_nowait(struct io_kiocb *req)
 
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	struct kiocb *kiocb = &req->rw.kiocb;
-	struct file *file = req->file;
 	unsigned ioprio;
 	int ret;
 
-	if (!io_req_ffs_set(req))
-		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
-
 	kiocb->ki_pos = READ_ONCE(sqe->off);
-	kiocb->ki_flags = iocb_flags(file);
-	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
-	if (unlikely(ret))
-		return ret;
-
-	/*
-	 * If the file is marked O_NONBLOCK, still allow retry for it if it
-	 * supports async. Otherwise it's impossible to use O_NONBLOCK files
-	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
-	 */
-	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
-	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req)))
-		req->flags |= REQ_F_NOWAIT;
-
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
-			return -EOPNOTSUPP;
-
-		kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;
-		kiocb->ki_complete = io_complete_rw_iopoll;
-		req->iopoll_completed = 0;
-	} else {
-		if (kiocb->ki_flags & IOCB_HIPRI)
-			return -EINVAL;
-		kiocb->ki_complete = io_complete_rw;
-	}
+	kiocb->ki_flags = READ_ONCE(sqe->rw_flags);
 
 	ioprio = READ_ONCE(sqe->ioprio);
 	if (ioprio) {
@@ -3731,13 +3701,6 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 	return 0;
 }
 
-static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	if (unlikely(!(req->file->f_mode & FMODE_READ)))
-		return -EBADF;
-	return io_prep_rw(req, sqe);
-}
-
 /*
  * This is our waitqueue callback handler, registered through __folio_lock_async()
  * when we initially tried to do the IO with the iocb armed our waitqueue.
@@ -3825,6 +3788,50 @@ static bool need_read_all(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
+static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
+{
+	struct kiocb *kiocb = &req->rw.kiocb;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct file *file = req->file;
+	int rw_flags = kiocb->ki_flags;
+	int ret;
+
+	if (unlikely(!(file->f_mode & mode)))
+		return -EBADF;
+
+	if (!io_req_ffs_set(req))
+		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
+
+	kiocb->ki_flags = iocb_flags(file);
+	ret = kiocb_set_rw_flags(kiocb, rw_flags);
+	if (unlikely(ret))
+		return ret;
+
+	/*
+	 * If the file is marked O_NONBLOCK, still allow retry for it if it
+	 * supports async. Otherwise it's impossible to use O_NONBLOCK files
+	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
+	 */
+	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
+	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req)))
+		req->flags |= REQ_F_NOWAIT;
+
+	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		if (!(kiocb->ki_flags & IOCB_DIRECT))
+			return -EOPNOTSUPP;
+
+		kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;
+		kiocb->ki_complete = io_complete_rw_iopoll;
+		req->iopoll_completed = 0;
+	} else {
+		if (kiocb->ki_flags & IOCB_HIPRI)
+			return -EINVAL;
+		kiocb->ki_complete = io_complete_rw;
+	}
+
+	return 0;
+}
+
 static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw_state __s, *s = &__s;
@@ -3860,6 +3867,9 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_restore(&s->iter, &s->iter_state);
 		iovec = NULL;
 	}
+	ret = io_rw_init_file(req, FMODE_READ);
+	if (unlikely(ret))
+		goto done;
 	req->result = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {
@@ -3963,14 +3973,6 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
-		return -EBADF;
-	req->rw.kiocb.ki_hint = ki_hint_validate(file_write_hint(req->file));
-	return io_prep_rw(req, sqe);
-}
-
 static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw_state __s, *s = &__s;
@@ -3991,6 +3993,9 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_restore(&s->iter, &s->iter_state);
 		iovec = NULL;
 	}
+	ret = io_rw_init_file(req, FMODE_WRITE);
+	if (unlikely(ret))
+		goto done;
 	req->result = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {
@@ -6976,11 +6981,10 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 	case IORING_OP_READ:
-		return io_read_prep(req, sqe);
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
-		return io_write_prep(req, sqe);
+		return io_prep_rw(req, sqe);
 	case IORING_OP_POLL_ADD:
 		return io_poll_add_prep(req, sqe);
 	case IORING_OP_POLL_REMOVE:
-- 
2.35.1

