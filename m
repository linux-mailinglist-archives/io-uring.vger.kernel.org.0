Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE29542F7C1
	for <lists+io-uring@lfdr.de>; Fri, 15 Oct 2021 18:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241143AbhJOQMV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Oct 2021 12:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241150AbhJOQMS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Oct 2021 12:12:18 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDA4C06176A
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:11 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id k7so27199512wrd.13
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DhOZPUzZr0nhAu6BV4RbOUrjfCcmps/hIEWky7P4yHw=;
        b=Nh6Y0/LGnfncZp0o1oZIBy0BYhEPSFEFCtk/GkC1QsfHxRmwb794gDM4iWRIcpA0F5
         9qE80YZJQlbmf1R4ZHoqgcYySipkBrdWzcOwsLPMRR+Adm1p/mrLvJiDzhH4wWsEwPIU
         6pTky6LIgpGTeE88IpCFZ0v9p4dJCtY9SqE6+z2wjtGSfdswzqXZdtyVAwakCxY5hhaE
         CqfYX+vDVS9toabn3LpUXsP5umN3Indej8vj5vp9Xz1CAVk9L3NB14B7oBNUPSCG2Ov8
         QftGRcn/lcdXREgJ8C9sgC2mrpOutULa0g6jbeOndsqYJFfVw/vQRLglYUardvwEA3kn
         iPLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DhOZPUzZr0nhAu6BV4RbOUrjfCcmps/hIEWky7P4yHw=;
        b=DZyUiIM2H9VoaxdqgwfLXLsaLgmHd0kECxuaohhh43Xfk1O16E4ORaWqeL6sSYsxcv
         EQvlr/NmqmyMEwKx+07Wtisyd1O+DYvzvOo8+pev98AcSKxqH6601kocYN55K+Y/oD0V
         orID0219FV2ojhexN4BYfp+MhA3Hroy6c2j80zkl0AYQsw3NQU8/IopDQSZPJ+S/qo8b
         8oBasChTQFBeWrmQoiIr7QOGBGlJQfy0TOvuGeEnujAMLbEuc8CqstxccKXWajaoNaN3
         Av4Jxtjk3QlOJn0AFa2NWLKfUMkOX/jy81iIA2GNdie/d5HeRNiEYFmms/ncj7nckukA
         SSBw==
X-Gm-Message-State: AOAM533VeY9BnY7BT5hPy+S0sA72OX1D6ZyM/ZcTeKODIKizl73nMhFV
        ORPNSIH5jdsGzYbaTIczI24um9Gof60=
X-Google-Smtp-Source: ABdhPJwneCHt3RyHlA7DA6y3Chc1Fc0bJ8rrBQAgXVzSpleJWx2C9Shz8UZiOuQY2mQhBL7hKnMz0g==
X-Received: by 2002:a5d:4f8d:: with SMTP id d13mr15044308wru.239.1634314210213;
        Fri, 15 Oct 2021 09:10:10 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.218])
        by smtp.gmail.com with ESMTPSA id c15sm5282811wrs.19.2021.10.15.09.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:10:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 7/8] io_uring: arm poll for non-nowait files
Date:   Fri, 15 Oct 2021 17:09:17 +0100
Message-Id: <6e72153f8de78d836b9b7595a2a6f1c6a9f137b1.1634314022.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634314022.git.asml.silence@gmail.com>
References: <cover.1634314022.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't check if we can do nowait before arming apoll, there are several
reasons for that. First, we don't care much about files that don't
support nowait. Second, it may be useful -- we don't want to be taking
away extra workers from io-wq when it can go in some async. Even if it
will go through io-wq eventually, it make difference in the numbers of
workers actually used. And the last one, it's needed to clean nowait in
future commits.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 65 +++++++++++++++++----------------------------------
 1 file changed, 21 insertions(+), 44 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce9a1b89da3f..c9acb4d2a1ff 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -732,8 +732,7 @@ enum {
 	REQ_F_ARM_LTIMEOUT_BIT,
 	REQ_F_ASYNC_DATA_BIT,
 	/* keep async read/write and isreg together and in order */
-	REQ_F_NOWAIT_READ_BIT,
-	REQ_F_NOWAIT_WRITE_BIT,
+	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
@@ -774,10 +773,8 @@ enum {
 	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
 	/* caller should reissue async */
 	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
-	/* supports async reads */
-	REQ_F_NOWAIT_READ	= BIT(REQ_F_NOWAIT_READ_BIT),
-	/* supports async writes */
-	REQ_F_NOWAIT_WRITE	= BIT(REQ_F_NOWAIT_WRITE_BIT),
+	/* supports async reads/writes */
+	REQ_F_SUPPORT_NOWAIT	= BIT(REQ_F_SUPPORT_NOWAIT_BIT),
 	/* regular file */
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
 	/* has creds assigned */
@@ -1390,18 +1387,13 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 	return false;
 }
 
-#define FFS_ASYNC_READ		0x1UL
-#define FFS_ASYNC_WRITE		0x2UL
-#ifdef CONFIG_64BIT
-#define FFS_ISREG		0x4UL
-#else
-#define FFS_ISREG		0x0UL
-#endif
-#define FFS_MASK		~(FFS_ASYNC_READ|FFS_ASYNC_WRITE|FFS_ISREG)
+#define FFS_NOWAIT		0x1UL
+#define FFS_ISREG		0x2UL
+#define FFS_MASK		~(FFS_NOWAIT|FFS_ISREG)
 
 static inline bool io_req_ffs_set(struct io_kiocb *req)
 {
-	return IS_ENABLED(CONFIG_64BIT) && (req->flags & REQ_F_FIXED_FILE);
+	return req->flags & REQ_F_FIXED_FILE;
 }
 
 static inline void io_req_track_inflight(struct io_kiocb *req)
@@ -2775,7 +2767,7 @@ static bool io_bdev_nowait(struct block_device *bdev)
  * any file. For now, just ensure that anything potentially problematic is done
  * inline.
  */
-static bool __io_file_supports_nowait(struct file *file, int rw)
+static bool __io_file_supports_nowait(struct file *file)
 {
 	umode_t mode = file_inode(file)->i_mode;
 
@@ -2798,24 +2790,14 @@ static bool __io_file_supports_nowait(struct file *file, int rw)
 	/* any ->read/write should understand O_NONBLOCK */
 	if (file->f_flags & O_NONBLOCK)
 		return true;
-
-	if (!(file->f_mode & FMODE_NOWAIT))
-		return false;
-
-	if (rw == READ)
-		return file->f_op->read_iter != NULL;
-
-	return file->f_op->write_iter != NULL;
+	return file->f_mode & FMODE_NOWAIT;
 }
 
-static bool io_file_supports_nowait(struct io_kiocb *req, int rw)
+static inline bool io_file_supports_nowait(struct io_kiocb *req)
 {
-	if (rw == READ && (req->flags & REQ_F_NOWAIT_READ))
-		return true;
-	else if (rw == WRITE && (req->flags & REQ_F_NOWAIT_WRITE))
+	if (likely(req->flags & REQ_F_SUPPORT_NOWAIT))
 		return true;
-
-	return __io_file_supports_nowait(req->file, rw);
+	return __io_file_supports_nowait(req->file);
 }
 
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
@@ -2847,7 +2829,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
 	 */
 	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
-	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req, rw)))
+	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req)))
 		req->flags |= REQ_F_NOWAIT;
 
 	ioprio = READ_ONCE(sqe->ioprio);
@@ -3238,7 +3220,8 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 	 */
 	if (kiocb->ki_flags & IOCB_HIPRI)
 		return -EOPNOTSUPP;
-	if (kiocb->ki_flags & IOCB_NOWAIT)
+	if ((kiocb->ki_flags & IOCB_NOWAIT) &&
+	    !(kiocb->ki_filp->f_flags & O_NONBLOCK))
 		return -EAGAIN;
 
 	while (iov_iter_count(iter)) {
@@ -3478,7 +3461,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req, READ))) {
+		if (unlikely(!io_file_supports_nowait(req))) {
 			ret = io_setup_async_rw(req, iovec, s, true);
 			return ret ?: -EAGAIN;
 		}
@@ -3602,7 +3585,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req, WRITE)))
+		if (unlikely(!io_file_supports_nowait(req)))
 			goto copy_iov;
 
 		/* file path doesn't support NOWAIT for non-direct_IO */
@@ -3634,7 +3617,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	}
 	kiocb->ki_flags |= IOCB_WRITE;
 
-	if (req->file->f_op->write_iter)
+	if (likely(req->file->f_op->write_iter))
 		ret2 = call_write_iter(req->file, kiocb, &s->iter);
 	else if (req->file->f_op->write)
 		ret2 = loop_rw_iter(WRITE, req, &s->iter);
@@ -5613,10 +5596,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 		mask |= POLLOUT | POLLWRNORM;
 	}
 
-	/* if we can't nonblock try, then no point in arming a poll handler */
-	if (!io_file_supports_nowait(req, rw))
-		return IO_APOLL_ABORTED;
-
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 	if (unlikely(!apoll))
 		return IO_APOLL_ABORTED;
@@ -6788,10 +6767,8 @@ static void io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file
 {
 	unsigned long file_ptr = (unsigned long) file;
 
-	if (__io_file_supports_nowait(file, READ))
-		file_ptr |= FFS_ASYNC_READ;
-	if (__io_file_supports_nowait(file, WRITE))
-		file_ptr |= FFS_ASYNC_WRITE;
+	if (__io_file_supports_nowait(file))
+		file_ptr |= FFS_NOWAIT;
 	if (S_ISREG(file_inode(file)->i_mode))
 		file_ptr |= FFS_ISREG;
 	file_slot->file_ptr = file_ptr;
@@ -6810,7 +6787,7 @@ static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
 	file = (struct file *) (file_ptr & FFS_MASK);
 	file_ptr &= ~FFS_MASK;
 	/* mask in overlapping REQ_F and FFS bits */
-	req->flags |= (file_ptr << REQ_F_NOWAIT_READ_BIT);
+	req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
 	io_req_set_rsrc_node(req, ctx);
 	return file;
 }
-- 
2.33.0

