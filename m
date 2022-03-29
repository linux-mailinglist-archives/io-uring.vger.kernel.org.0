Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FF54EB486
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 22:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiC2UQE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 16:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiC2UQC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 16:16:02 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCA1E6177
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 13:14:19 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id k25so22369424iok.8
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 13:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dgTcW+qLJ31ZJgVr2Vm/EfVLJ5hGsj2eMIJ1EWlHpdc=;
        b=kRNjxWxeX2hCrvbLqJcnsBsULdXGJ/EZdBmGAuoh6qhhby4iqAT5gvpU9LX8a9Uscj
         jV5vcAvdeQPLA18Y9VZMWR8IWJtobyL/bPU9WZxCsty5/y9zGsfwF044CeSy/CSwYUVW
         9Afw7bS8JF3f/mfH8fPX0YB12YFizxPVJ+zAoHMudj74YnI91E39n2QLyQpqKmvSv1fq
         Jpcgrcdwlv/UIJsoWjW/XQwuM4+e64hO5YUaOE8DOvTA1X0EDoCUvLuqDw4ubnkVn9j8
         /elc5JxgJPLlphBnjjzJZdk8TieRyPzLsHZ/q92kNCyoWVQCGDT5p+ZHCJ619xb7Dk+r
         KRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dgTcW+qLJ31ZJgVr2Vm/EfVLJ5hGsj2eMIJ1EWlHpdc=;
        b=73C5t+eU8EuEL7VRWoi6covnUIUOxE5EgEfaEs7SfR6Kh1Igfnsnwqfnc0/Mab3HMR
         uaVMV21PiuM7hRGhC9EOFppW7Si5/0FPLQQmdEh8WVrLsoIW8m4ZplaoXDRZ1eNo8R2Q
         CgC4I9SSL/oDmGmp9l0xDTigANgUYKOen7SjZ4HHFQ2vg6MdBE8iE4F7P+wz8QxgMa06
         DPDQ6oJT6DKNjloxWleQ5b4o9rz8wMOfBDWKArD5q31/BL5mJzNriV1a18UeHejLW622
         cKJ6LMpZokw92E0d+T5/FDcdhqUIQbDfxV988e1b2pORXdwwej/cDVPFpVOsI3MZkrtP
         vYsA==
X-Gm-Message-State: AOAM531Megl9eYTrXpnZ3cogibEuR6emzlE2sh3cd5nrsN5roCYFeVSg
        DLmfhXmD9Gfpm0opEdYS6Hu1RpoA/MBDosTv
X-Google-Smtp-Source: ABdhPJy+EhklF7GA763QaDDH53hgn7ATY9BQ2oiic3Fs341SAqSho9eJzixPI6ciuCttOO9sT6CrJA==
X-Received: by 2002:a05:6638:2512:b0:317:d305:b00 with SMTP id v18-20020a056638251200b00317d3050b00mr18062545jat.16.1648584858296;
        Tue, 29 Mar 2022 13:14:18 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v3-20020a5d9483000000b00640d3d4acabsm9606316ioj.44.2022.03.29.13.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 13:14:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: move read/write file prep state into actual opcode handler
Date:   Tue, 29 Mar 2022 14:14:12 -0600
Message-Id: <20220329201413.73871-4-axboe@kernel.dk>
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

In preparation for not necessarily having a file assigned at prep time,
defer any initialization associated with the file to when the opcode
handler is run.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 102 ++++++++++++++++++++++++++------------------------
 1 file changed, 53 insertions(+), 49 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0b89f35378fa..2bd7b83045bc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -593,7 +593,8 @@ struct io_rw {
 	/* NOTE: kiocb has the file as the first member, so don't do it here */
 	struct kiocb			kiocb;
 	u64				addr;
-	u64				len;
+	u32				len;
+	u32				flags;
 };
 
 struct io_connect {
@@ -3177,42 +3178,11 @@ static inline bool io_file_supports_nowait(struct io_kiocb *req)
 
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
 
 	ioprio = READ_ONCE(sqe->ioprio);
 	if (ioprio) {
@@ -3228,6 +3198,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	req->imu = NULL;
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
+	req->rw.flags = READ_ONCE(sqe->rw_flags);
 	req->buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
 }
@@ -3731,13 +3702,6 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
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
@@ -3825,6 +3789,49 @@ static bool need_read_all(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
+static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
+{
+	struct kiocb *kiocb = &req->rw.kiocb;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct file *file = req->file;
+	int ret;
+
+	if (unlikely(!(file->f_mode & mode)))
+		return -EBADF;
+
+	if (!io_req_ffs_set(req))
+		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
+
+	kiocb->ki_flags = iocb_flags(file);
+	ret = kiocb_set_rw_flags(kiocb, req->rw.flags);
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
+		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
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

