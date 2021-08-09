Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60DB3E4533
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbhHIMF2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235332AbhHIMF2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:28 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EBEC0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:07 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id l18so21115696wrv.5
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SNsOWV/mL3WrpyrtHMkRrpZX51tGbvIL0xlYFXDOTLA=;
        b=Ns/tZwVMEpG5e7v3lxaVNwAhT2tOvXWT9+Xv/bUaJjdMDjDGhMowIpzONFauehH9JL
         x6Hig2p2LhhZ6G+/lIIP54tqvs3wmCrbo5AKIjmTyVIX3yZmh1JD929qgxr5xnc/ZBP6
         xwHs7LG9tyHM7I/HiXdbSqM3QZvoWSc4auxQd80J27a//9wiDJK+KjBrnka2XPDGT+ol
         j21R4vBJ9FV5GSFq4Avh2nCibrfFyerQxpWvVyTG3Fh6nBiKz3NvibROdr2NvsxKAJeB
         vpzSb/xQHG7wiC9hvgkFDvLe3peDk0V4OavqDfetmO8/lj5TsScPhhUqyZgzaD0ptbly
         jNwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SNsOWV/mL3WrpyrtHMkRrpZX51tGbvIL0xlYFXDOTLA=;
        b=bRZhhrOJIZGpbTQbkiC2YsPGWEgMY/GhRz+4RSVoq8J8JMzwHvAtFWjYg1Kke8qR1l
         13bedwV1qmKI4BPfWzkGpy/h+krhk2oyVluklPOoeaUS67OQDv6aWa/BgTb4o/RiYGAH
         tmVHHijEbaTwjQruKhUKw4SLW5tCtsaSkTRt2sekP4IoJq3u/DkNrSjEnXxl8WQsUgy5
         w8bFzMFs6PVIK7IynFwMq7f7iTiv37SzmZN2sc8q9JgD4u2KnCRGoNryocKrG9A5oUVY
         N/s5xxTuod1hFJPoBobR47J9cYvTVj6S+xdSbRxChjtaYBV5FsYx8cyY86quId6cAUxy
         C68g==
X-Gm-Message-State: AOAM531xm7oPv/A3q+ReTP20ugKMAGm5CD83BGj3P2gxkPeXKojVmbqf
        J8KbrZ7lwXa5pc81tD70tNC7bSJoKVE=
X-Google-Smtp-Source: ABdhPJxMccoIv3IX41U0T1mLRtdYIHqIgQbusqvUci8Ahw8SGKTl7M057d37rRWuj2dj6McQinYaXQ==
X-Received: by 2002:a5d:5302:: with SMTP id e2mr11265013wrv.47.1628510706599;
        Mon, 09 Aug 2021 05:05:06 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/28] io_uring: rename io_file_supports_async()
Date:   Mon,  9 Aug 2021 13:04:03 +0100
Message-Id: <33d55b5ce43aa1884c637c1957f1e30d30dc3bec.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_file_supports_async() checks whether a file supports nowait
operations, so "async" in the name is misleading. Rename it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 900c1a4d6a0a..d34bba222039 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -718,8 +718,8 @@ enum {
 	REQ_F_DONT_REISSUE_BIT,
 	REQ_F_CREDS_BIT,
 	/* keep async read/write and isreg together and in order */
-	REQ_F_ASYNC_READ_BIT,
-	REQ_F_ASYNC_WRITE_BIT,
+	REQ_F_NOWAIT_READ_BIT,
+	REQ_F_NOWAIT_WRITE_BIT,
 	REQ_F_ISREG_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
@@ -765,9 +765,9 @@ enum {
 	/* don't attempt request reissue, see io_rw_reissue() */
 	REQ_F_DONT_REISSUE	= BIT(REQ_F_DONT_REISSUE_BIT),
 	/* supports async reads */
-	REQ_F_ASYNC_READ	= BIT(REQ_F_ASYNC_READ_BIT),
+	REQ_F_NOWAIT_READ	= BIT(REQ_F_NOWAIT_READ_BIT),
 	/* supports async writes */
-	REQ_F_ASYNC_WRITE	= BIT(REQ_F_ASYNC_WRITE_BIT),
+	REQ_F_NOWAIT_WRITE	= BIT(REQ_F_NOWAIT_WRITE_BIT),
 	/* regular file */
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
 	/* has creds assigned */
@@ -2628,7 +2628,7 @@ static bool io_bdev_nowait(struct block_device *bdev)
  * any file. For now, just ensure that anything potentially problematic is done
  * inline.
  */
-static bool __io_file_supports_async(struct file *file, int rw)
+static bool __io_file_supports_nowait(struct file *file, int rw)
 {
 	umode_t mode = file_inode(file)->i_mode;
 
@@ -2661,14 +2661,14 @@ static bool __io_file_supports_async(struct file *file, int rw)
 	return file->f_op->write_iter != NULL;
 }
 
-static bool io_file_supports_async(struct io_kiocb *req, int rw)
+static bool io_file_supports_nowait(struct io_kiocb *req, int rw)
 {
-	if (rw == READ && (req->flags & REQ_F_ASYNC_READ))
+	if (rw == READ && (req->flags & REQ_F_NOWAIT_READ))
 		return true;
-	else if (rw == WRITE && (req->flags & REQ_F_ASYNC_WRITE))
+	else if (rw == WRITE && (req->flags & REQ_F_NOWAIT_WRITE))
 		return true;
 
-	return __io_file_supports_async(req->file, rw);
+	return __io_file_supports_nowait(req->file, rw);
 }
 
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -3292,7 +3292,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		kiocb->ki_flags |= IOCB_NOWAIT;
 
 	/* If the file doesn't support async, just async punt */
-	if (force_nonblock && !io_file_supports_async(req, READ)) {
+	if (force_nonblock && !io_file_supports_nowait(req, READ)) {
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
 		return ret ?: -EAGAIN;
 	}
@@ -3399,7 +3399,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		kiocb->ki_flags |= IOCB_NOWAIT;
 
 	/* If the file doesn't support async, just async punt */
-	if (force_nonblock && !io_file_supports_async(req, WRITE))
+	if (force_nonblock && !io_file_supports_nowait(req, WRITE))
 		goto copy_iov;
 
 	/* file path doesn't support NOWAIT for non-direct_IO */
@@ -5209,7 +5209,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	}
 
 	/* if we can't nonblock try, then no point in arming a poll handler */
-	if (!io_file_supports_async(req, rw))
+	if (!io_file_supports_nowait(req, rw))
 		return IO_APOLL_ABORTED;
 
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
@@ -6347,9 +6347,9 @@ static void io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file
 {
 	unsigned long file_ptr = (unsigned long) file;
 
-	if (__io_file_supports_async(file, READ))
+	if (__io_file_supports_nowait(file, READ))
 		file_ptr |= FFS_ASYNC_READ;
-	if (__io_file_supports_async(file, WRITE))
+	if (__io_file_supports_nowait(file, WRITE))
 		file_ptr |= FFS_ASYNC_WRITE;
 	if (S_ISREG(file_inode(file)->i_mode))
 		file_ptr |= FFS_ISREG;
@@ -6369,7 +6369,7 @@ static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
 	file = (struct file *) (file_ptr & FFS_MASK);
 	file_ptr &= ~FFS_MASK;
 	/* mask in overlapping REQ_F and FFS bits */
-	req->flags |= (file_ptr << REQ_F_ASYNC_READ_BIT);
+	req->flags |= (file_ptr << REQ_F_NOWAIT_READ_BIT);
 	io_req_set_rsrc_node(req);
 	return file;
 }
-- 
2.32.0

