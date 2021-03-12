Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4532033916E
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 16:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhCLPf3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 10:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbhCLPfM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 10:35:12 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A59C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 07:35:12 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id d5so2931258iln.6
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 07:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WhnB1m3TTbV6xEWhl/UHuucgpE4oP41vBoEpHajcwNM=;
        b=j/ahB8ki/LL/EKKy9cwBCBkonfmiaWSAvflB9ivGfu9mwPPgSKgxliC754yjEsoEo6
         ToN6dGeY+GnALIR9oNTeBy6ai0CjpWbLt7ThCjCQ3ufNKF3hsG8iIvcSq8lG1rLli8Su
         g+vCfP4NDM2BacHGWXkTM+SFWwBiKH5W+fOh3thiwKuKy+kQJzSbT23mobBQZm+x5TiE
         1netwxJucSyWXRU3OiVVeRMJe1N+/Xqk+suR/RWS4QYdByYWml14cAQUi2TsEbeJShCi
         z5BcqzHpJ85zg9odXDfDCh6qTqngaKmzgg6cmQaz5sY3DLLh15XKZdZHt70gPRdUof+i
         T4xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WhnB1m3TTbV6xEWhl/UHuucgpE4oP41vBoEpHajcwNM=;
        b=jIr/yVkfMl9sXB8ECeoc7Y1x26tCeBfbfg5+mwPWy7p9scMjDyv8HO6FghWp4NRpqN
         awfrEtohMDCjasaU1eVIbqiPNqVxxZHkWMxrdxz1Urf4SsHEY2MB7Mzkcs+p6CBYanWf
         YyN6l1NhACdjhwNNt0j9lVVK4v/+XdrlibnSJ6TGR+kg14tSzVNZAE0HFRrLDa1njUca
         kQoju9hC7zJPdsu2mVY8CiQENb0TF/aw+s+FnF7KrDONDutCVF7YI2ABXhEylqG7xRH2
         n57PYVbUrz2w+W4Ql6ZrZR8Bc9wATztOx8HjmHxpWdHCoAj05qngrD+1L7im6cQxjJod
         jBkg==
X-Gm-Message-State: AOAM533Nsl1wzpfq3LzP9zvJRMVmmpyYgC2Yh7ZNyFgTlDtF1QjUsoD9
        +ZktZfLo66wRJLHAu7BTG7HEiiPN8/N+CQ==
X-Google-Smtp-Source: ABdhPJxV3nMMVoEQo38FeeShVSk1rzh3ic/EVXX+BuUKQ+2bjEYXGYNRG5zOZ8y7TZx7Yxhe6S1Fiw==
X-Received: by 2002:a05:6e02:1be1:: with SMTP id y1mr3116692ilv.101.1615563311146;
        Fri, 12 Mar 2021 07:35:11 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v4sm3060863ilo.26.2021.03.12.07.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 07:35:10 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: cache async and regular file state for fixed files
Date:   Fri, 12 Mar 2021 08:35:05 -0700
Message-Id: <20210312153505.1791868-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210312153505.1791868-1-axboe@kernel.dk>
References: <20210312153505.1791868-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have to dig quite deep to check for particularly whether or not a
file supports a fast-path nonblock attempt. For fixed files, we can do
this lookup once and cache the state instead.

This adds two new bits to track whether we support async read/write
attempt, and lines up the REQ_F_ISREG bit with those two. The file slot
re-uses the last 3 (or 2, for 32-bit) of the file pointer to cache that
state, and then we mask it in when we go and use a fixed file.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 76 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 64 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c386f72ff73b..c7b5354b8f09 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -673,13 +673,16 @@ enum {
 	REQ_F_CUR_POS_BIT,
 	REQ_F_NOWAIT_BIT,
 	REQ_F_LINK_TIMEOUT_BIT,
-	REQ_F_ISREG_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
 	REQ_F_LTIMEOUT_ACTIVE_BIT,
 	REQ_F_COMPLETE_INLINE_BIT,
+	/* keep async read/write and isreg together and in order */
+	REQ_F_ASYNC_READ_BIT,
+	REQ_F_ASYNC_WRITE_BIT,
+	REQ_F_ISREG_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -709,8 +712,6 @@ enum {
 	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),
 	/* has or had linked timeout */
 	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
-	/* regular file */
-	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
 	/* needs cleanup */
 	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
 	/* already went through poll handler */
@@ -723,6 +724,12 @@ enum {
 	REQ_F_LTIMEOUT_ACTIVE	= BIT(REQ_F_LTIMEOUT_ACTIVE_BIT),
 	/* completion is deferred through io_comp_state */
 	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
+	/* supports async reads */
+	REQ_F_ASYNC_READ	= BIT(REQ_F_ASYNC_READ_BIT),
+	/* supports async writes */
+	REQ_F_ASYNC_WRITE	= BIT(REQ_F_ASYNC_WRITE_BIT),
+	/* regular file */
+	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
 };
 
 struct async_poll {
@@ -2617,7 +2624,7 @@ static bool io_bdev_nowait(struct block_device *bdev)
  * any file. For now, just ensure that anything potentially problematic is done
  * inline.
  */
-static bool io_file_supports_async(struct file *file, int rw)
+static bool __io_file_supports_async(struct file *file, int rw)
 {
 	umode_t mode = file_inode(file)->i_mode;
 
@@ -2650,6 +2657,16 @@ static bool io_file_supports_async(struct file *file, int rw)
 	return file->f_op->write_iter != NULL;
 }
 
+static bool io_file_supports_async(struct io_kiocb *req, int rw)
+{
+	if (rw == READ && (req->flags & REQ_F_ASYNC_READ))
+		return true;
+	else if (rw == WRITE && (req->flags & REQ_F_ASYNC_WRITE))
+		return true;
+
+	return __io_file_supports_async(req->file, rw);
+}
+
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -2658,7 +2675,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	unsigned ioprio;
 	int ret;
 
-	if (S_ISREG(file_inode(file)->i_mode))
+	if (!(req->flags & REQ_F_ISREG) && S_ISREG(file_inode(file)->i_mode))
 		req->flags |= REQ_F_ISREG;
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
@@ -3242,7 +3259,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		kiocb->ki_flags |= IOCB_NOWAIT;
 
 	/* If the file doesn't support async, just async punt */
-	if (force_nonblock && !io_file_supports_async(req->file, READ)) {
+	if (force_nonblock && !io_file_supports_async(req, READ)) {
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
 		return ret ?: -EAGAIN;
 	}
@@ -3348,7 +3365,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		kiocb->ki_flags |= IOCB_NOWAIT;
 
 	/* If the file doesn't support async, just async punt */
-	if (force_nonblock && !io_file_supports_async(req->file, WRITE))
+	if (force_nonblock && !io_file_supports_async(req, WRITE))
 		goto copy_iov;
 
 	/* file path doesn't support NOWAIT for non-direct_IO */
@@ -5114,7 +5131,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	else
 		return false;
 	/* if we can't nonblock try, then no point in arming a poll handler */
-	if (!io_file_supports_async(req->file, rw))
+	if (!io_file_supports_async(req, rw))
 		return false;
 
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
@@ -6083,8 +6100,17 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	}
 }
 
-static inline struct file **io_fixed_file_slot(struct fixed_rsrc_data *file_data,
-					       unsigned i)
+#define FFS_ASYNC_READ		0x1UL
+#define FFS_ASYNC_WRITE		0x2UL
+#ifdef CONFIG_64BIT
+#define FFS_ISREG		0x4UL
+#else
+#define FFS_ISREG		0x0UL
+#endif
+#define FFS_MASK		~(FFS_ASYNC_READ|FFS_ASYNC_WRITE|FFS_ISREG)
+
+static inline void *__io_fixed_file_slot(struct fixed_rsrc_data *file_data,
+					 unsigned i)
 {
 	struct fixed_rsrc_table *table;
 
@@ -6092,6 +6118,17 @@ static inline struct file **io_fixed_file_slot(struct fixed_rsrc_data *file_data
 	return &table->files[i & IORING_FILE_TABLE_MASK];
 }
 
+static inline struct file **io_fixed_file_slot(struct fixed_rsrc_data *file_data,
+					       unsigned i)
+{
+	struct file **file;
+
+	file = __io_fixed_file_slot(file_data, i);
+	if (*file)
+		*file = (struct file *) ((unsigned long) *file & FFS_MASK);
+	return file;
+}
+
 static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 					      int index)
 {
@@ -6105,10 +6142,16 @@ static struct file *io_file_get(struct io_submit_state *state,
 	struct file *file;
 
 	if (fixed) {
+		unsigned long file_ptr;
+
 		if (unlikely((unsigned int)fd >= ctx->nr_user_files))
 			return NULL;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
-		file = io_file_from_index(ctx, fd);
+		file_ptr = (unsigned long) *io_fixed_file_slot(ctx->file_data, fd);
+		file = (struct file *) (file_ptr & FFS_MASK);
+		file_ptr &= ~FFS_MASK;
+		/* mask in overlapping REQ_F and FFS bits */
+		req->flags |= (file_ptr << REQ_F_ASYNC_READ_BIT);
 		io_set_resource_node(req);
 	} else {
 		trace_io_uring_file_get(ctx, fd);
@@ -7432,6 +7475,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		goto out_free;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
+		unsigned long file_ptr;
+
 		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
 			ret = -EFAULT;
 			goto out_fput;
@@ -7456,7 +7501,14 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			fput(file);
 			goto out_fput;
 		}
-		*io_fixed_file_slot(file_data, i) = file;
+		file_ptr = (unsigned long) file;
+		if (__io_file_supports_async(file, READ))
+			file_ptr |= FFS_ASYNC_READ;
+		if (__io_file_supports_async(file, WRITE))
+			file_ptr |= FFS_ASYNC_WRITE;
+		if (S_ISREG(file_inode(file)->i_mode))
+			file_ptr |= FFS_ISREG;
+		*io_fixed_file_slot(file_data, i) = (struct file *) file_ptr;
 	}
 
 	ret = io_sqe_files_scm(ctx);
-- 
2.30.2

