Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C645315AE7
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbhBJASj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbhBJAH6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:07:58 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C30C0613D6
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:17 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id i9so335035wmq.1
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PUzGWKnZRnJ27encEaewDntlf9q6FnglWd8CjDnHapw=;
        b=vdQzd/xUOr/hdbZD/oNLi/+J0z6IgR0TYiD5pCUrIJh0/iPTx9q7/UJioBPwGb4E5x
         fBp8VG6OtCF6qiMOy/0/PImZidV9ysmRxObXPsuOOuMkrEi3qX7HwZPHWmZoaSXnGGxQ
         wRaEaNMK15ULNYngNcHICmuofj5MHfi2Qf0M6mfqotLDTHqSJ/BE1Zr7GknP9xCxFdOc
         rDy8D58HDGsVUKG8X4Bju88snNUfAnjWCjb5SyZqSW+K3k9rmFL+Snza5OhFdJGGNbzC
         gjocqKLDRfIGz/scaNYCd1TCVaGNRd1D1xm6GCr3ifkJebD35GbmMaOrrnI3yB3DR/wa
         luWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PUzGWKnZRnJ27encEaewDntlf9q6FnglWd8CjDnHapw=;
        b=Ndp63R10+AkedfAbTqGV9J9phnYRAsXTIWUCCJoZ+pUud0RoGs3xHs236Q3t9z1j7t
         qMVHoEwg0eka1N811cQ7n+4lIR18mP3UQ4x+irPerASQTO4h4Dw5BLt8YUHPzzgkOgPh
         EyioYbiAKIDYevPUKADS1S0y7TiYxiwtpcS9RT4oGa8KJdnmVOgyFmkHRsTvLU23eSVK
         DIav4kfFblQkwDFonviSpFuql2uhDrO19EGLQ2tCMZQVxa2kDhkLXO/TYoajgco/1R8J
         4/wSfAUb/qNfRb/4ZC0ZNd9crEe9E3wnMi8HTSQhlbr9dAfvzQ2oP51fSJuPjL0YIFF2
         2F0w==
X-Gm-Message-State: AOAM5335KIYQUoJOsS/Rac8tF5khYwIYBFF9Pd5QUjNKxusMqabF0VTi
        pmvZM/mZQpm2bJX07OaYryRTN5RXsSDEhQ==
X-Google-Smtp-Source: ABdhPJxtdzG7zq6J//okTRmIDEXjh1JpPvhXmW1oQeR4YHI64aurBXA4wovi72nYn/yn4R2lIcIfZg==
X-Received: by 2002:a05:600c:2210:: with SMTP id z16mr475763wml.50.1612915636233;
        Tue, 09 Feb 2021 16:07:16 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/17] io_uring: replace force_nonblock with flags
Date:   Wed, 10 Feb 2021 00:03:07 +0000
Message-Id: <78066e8c36251fdad7b4560b7589e01e78540323.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Replace bool force_nonblock with flags. It has a long standing goal of
differentiating context from which we execute. Currently we have some
subtle places where some invariants, like holding of uring_lock, are
subtly inferred.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 178 +++++++++++++++++++++++++++-----------------------
 1 file changed, 96 insertions(+), 82 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9c77fbc0c395..862121c48cee 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -187,6 +187,10 @@ struct io_rings {
 	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
 };
 
+enum io_uring_cmd_flags {
+	IO_URING_F_NONBLOCK		= 1,
+};
+
 struct io_mapped_ubuf {
 	u64		ubuf;
 	size_t		len;
@@ -3477,7 +3481,7 @@ static int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
 		return -EINVAL;
 }
 
-static int io_read(struct io_kiocb *req, bool force_nonblock,
+static int io_read(struct io_kiocb *req, unsigned int issue_flags,
 		   struct io_comp_state *cs)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
@@ -3485,6 +3489,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	struct iov_iter __iter, *iter = &__iter;
 	struct io_async_rw *rw = req->async_data;
 	ssize_t io_size, ret, ret2;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
 	if (rw) {
 		iter = &rw->iter;
@@ -3588,7 +3593,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return io_rw_prep_async(req, WRITE);
 }
 
-static int io_write(struct io_kiocb *req, bool force_nonblock,
+static int io_write(struct io_kiocb *req, unsigned int issue_flags,
 		    struct io_comp_state *cs)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
@@ -3596,6 +3601,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	struct iov_iter __iter, *iter = &__iter;
 	struct io_async_rw *rw = req->async_data;
 	ssize_t ret, ret2, io_size;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
 	if (rw) {
 		iter = &rw->iter;
@@ -3706,12 +3712,12 @@ static int io_renameat_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_renameat(struct io_kiocb *req, bool force_nonblock)
+static int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rename *ren = &req->rename;
 	int ret;
 
-	if (force_nonblock)
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
 	ret = do_renameat2(ren->old_dfd, ren->oldpath, ren->new_dfd,
@@ -3748,12 +3754,12 @@ static int io_unlinkat_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_unlinkat(struct io_kiocb *req, bool force_nonblock)
+static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_unlink *un = &req->unlink;
 	int ret;
 
-	if (force_nonblock)
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
 	if (un->flags & AT_REMOVEDIR)
@@ -3785,13 +3791,13 @@ static int io_shutdown_prep(struct io_kiocb *req,
 #endif
 }
 
-static int io_shutdown(struct io_kiocb *req, bool force_nonblock)
+static int io_shutdown(struct io_kiocb *req, unsigned int issue_flags)
 {
 #if defined(CONFIG_NET)
 	struct socket *sock;
 	int ret;
 
-	if (force_nonblock)
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
 	sock = sock_from_file(req->file);
@@ -3850,7 +3856,7 @@ static int io_tee_prep(struct io_kiocb *req,
 	return __io_splice_prep(req, sqe);
 }
 
-static int io_tee(struct io_kiocb *req, bool force_nonblock)
+static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_splice *sp = &req->splice;
 	struct file *in = sp->file_in;
@@ -3858,7 +3864,7 @@ static int io_tee(struct io_kiocb *req, bool force_nonblock)
 	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
 	long ret = 0;
 
-	if (force_nonblock)
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 	if (sp->len)
 		ret = do_tee(in, out, sp->len, flags);
@@ -3881,7 +3887,7 @@ static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return __io_splice_prep(req, sqe);
 }
 
-static int io_splice(struct io_kiocb *req, bool force_nonblock)
+static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_splice *sp = &req->splice;
 	struct file *in = sp->file_in;
@@ -3890,7 +3896,7 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
 	loff_t *poff_in, *poff_out;
 	long ret = 0;
 
-	if (force_nonblock)
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
 	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
@@ -3943,13 +3949,13 @@ static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_fsync(struct io_kiocb *req, bool force_nonblock)
+static int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
 {
 	loff_t end = req->sync.off + req->sync.len;
 	int ret;
 
 	/* fsync always requires a blocking context */
-	if (force_nonblock)
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
 	ret = vfs_fsync_range(req->file, req->sync.off,
@@ -3975,12 +3981,12 @@ static int io_fallocate_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
+static int io_fallocate(struct io_kiocb *req, unsigned int issue_flags)
 {
 	int ret;
 
 	/* fallocate always requiring blocking context */
-	if (force_nonblock)
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
 				req->sync.len);
@@ -4050,7 +4056,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return __io_openat_prep(req, sqe);
 }
 
-static int io_openat2(struct io_kiocb *req, bool force_nonblock)
+static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct open_flags op;
 	struct file *file;
@@ -4063,7 +4069,7 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 		goto err;
 	nonblock_set = op.open_flag & O_NONBLOCK;
 	resolve_nonblock = req->open.how.resolve & RESOLVE_CACHED;
-	if (force_nonblock) {
+	if (issue_flags & IO_URING_F_NONBLOCK) {
 		/*
 		 * Don't bother trying for O_TRUNC, O_CREAT, or O_TMPFILE open,
 		 * it'll always -EAGAIN
@@ -4080,7 +4086,8 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 
 	file = do_filp_open(req->open.dfd, req->open.filename, &op);
 	/* only retry if RESOLVE_CACHED wasn't already set by application */
-	if ((!resolve_nonblock && force_nonblock) && file == ERR_PTR(-EAGAIN)) {
+	if ((!resolve_nonblock && (issue_flags & IO_URING_F_NONBLOCK)) &&
+	    file == ERR_PTR(-EAGAIN)) {
 		/*
 		 * We could hang on to this 'fd', but seems like marginal
 		 * gain for something that is now known to be a slower path.
@@ -4094,7 +4101,7 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 		put_unused_fd(ret);
 		ret = PTR_ERR(file);
 	} else {
-		if (force_nonblock && !nonblock_set)
+		if ((issue_flags & IO_URING_F_NONBLOCK) && !nonblock_set)
 			file->f_flags &= ~O_NONBLOCK;
 		fsnotify_open(file);
 		fd_install(ret, file);
@@ -4108,9 +4115,9 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	return 0;
 }
 
-static int io_openat(struct io_kiocb *req, bool force_nonblock)
+static int io_openat(struct io_kiocb *req, unsigned int issue_flags)
 {
-	return io_openat2(req, force_nonblock);
+	return io_openat2(req, issue_flags & IO_URING_F_NONBLOCK);
 }
 
 static int io_remove_buffers_prep(struct io_kiocb *req,
@@ -4158,13 +4165,14 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
 	return i;
 }
 
-static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock,
+static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags,
 			     struct io_comp_state *cs)
 {
 	struct io_provide_buf *p = &req->pbuf;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer *head;
 	int ret = 0;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
 	io_ring_submit_lock(ctx, !force_nonblock);
 
@@ -4242,13 +4250,14 @@ static int io_add_buffers(struct io_provide_buf *pbuf, struct io_buffer **head)
 	return i ? i : -ENOMEM;
 }
 
-static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock,
+static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags,
 			      struct io_comp_state *cs)
 {
 	struct io_provide_buf *p = &req->pbuf;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer *head, *list;
 	int ret = 0;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
 	io_ring_submit_lock(ctx, !force_nonblock);
 
@@ -4310,12 +4319,13 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 #endif
 }
 
-static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock,
+static int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags,
 			struct io_comp_state *cs)
 {
 #if defined(CONFIG_EPOLL)
 	struct io_epoll *ie = &req->epoll;
 	int ret;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
 	ret = do_epoll_ctl(ie->epfd, ie->op, ie->fd, &ie->event, force_nonblock);
 	if (force_nonblock && ret == -EAGAIN)
@@ -4347,13 +4357,13 @@ static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #endif
 }
 
-static int io_madvise(struct io_kiocb *req, bool force_nonblock)
+static int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
 	struct io_madvise *ma = &req->madvise;
 	int ret;
 
-	if (force_nonblock)
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
 	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice);
@@ -4379,12 +4389,12 @@ static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_fadvise(struct io_kiocb *req, bool force_nonblock)
+static int io_fadvise(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_fadvise *fa = &req->fadvise;
 	int ret;
 
-	if (force_nonblock) {
+	if (issue_flags & IO_URING_F_NONBLOCK) {
 		switch (fa->advice) {
 		case POSIX_FADV_NORMAL:
 		case POSIX_FADV_RANDOM:
@@ -4420,12 +4430,12 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_statx(struct io_kiocb *req, bool force_nonblock)
+static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_statx *ctx = &req->statx;
 	int ret;
 
-	if (force_nonblock) {
+	if (issue_flags & IO_URING_F_NONBLOCK) {
 		/* only need file table for an actual valid fd */
 		if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
 			req->flags |= REQ_F_NO_FILE_TABLE;
@@ -4455,7 +4465,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_close(struct io_kiocb *req, bool force_nonblock,
+static int io_close(struct io_kiocb *req, unsigned int issue_flags,
 		    struct io_comp_state *cs)
 {
 	struct files_struct *files = current->files;
@@ -4485,7 +4495,7 @@ static int io_close(struct io_kiocb *req, bool force_nonblock,
 	}
 
 	/* if the file has a flush method, be safe and punt to async */
-	if (file->f_op->flush && force_nonblock) {
+	if (file->f_op->flush && (issue_flags & IO_URING_F_NONBLOCK)) {
 		spin_unlock(&files->file_lock);
 		return -EAGAIN;
 	}
@@ -4527,12 +4537,12 @@ static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
+static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 {
 	int ret;
 
 	/* sync_file_range always requires a blocking context */
-	if (force_nonblock)
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
 	ret = sync_file_range(req->file, req->sync.off, req->sync.len,
@@ -4601,7 +4611,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return ret;
 }
 
-static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
+static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags,
 		      struct io_comp_state *cs)
 {
 	struct io_async_msghdr iomsg, *kmsg;
@@ -4624,11 +4634,11 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	flags = req->sr_msg.msg_flags;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
-	else if (force_nonblock)
+	else if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
-	if (force_nonblock && ret == -EAGAIN)
+	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
 		return io_setup_async_msg(req, kmsg);
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
@@ -4643,7 +4653,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	return 0;
 }
 
-static int io_send(struct io_kiocb *req, bool force_nonblock,
+static int io_send(struct io_kiocb *req, unsigned int issue_flags,
 		   struct io_comp_state *cs)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
@@ -4669,12 +4679,12 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	flags = req->sr_msg.msg_flags;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
-	else if (force_nonblock)
+	else if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 
 	msg.msg_flags = flags;
 	ret = sock_sendmsg(sock, &msg);
-	if (force_nonblock && ret == -EAGAIN)
+	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
 		return -EAGAIN;
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
@@ -4822,7 +4832,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	return ret;
 }
 
-static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
+static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags,
 		      struct io_comp_state *cs)
 {
 	struct io_async_msghdr iomsg, *kmsg;
@@ -4830,6 +4840,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	struct io_buffer *kbuf;
 	unsigned flags;
 	int ret, cflags = 0;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
@@ -4878,7 +4889,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	return 0;
 }
 
-static int io_recv(struct io_kiocb *req, bool force_nonblock,
+static int io_recv(struct io_kiocb *req, unsigned int issue_flags,
 		   struct io_comp_state *cs)
 {
 	struct io_buffer *kbuf;
@@ -4889,6 +4900,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	struct iovec iov;
 	unsigned flags;
 	int ret, cflags = 0;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
@@ -4948,10 +4960,11 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_accept(struct io_kiocb *req, bool force_nonblock,
+static int io_accept(struct io_kiocb *req, unsigned int issue_flags,
 		     struct io_comp_state *cs)
 {
 	struct io_accept *accept = &req->accept;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
 	int ret;
 
@@ -4992,12 +5005,13 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 					&io->address);
 }
 
-static int io_connect(struct io_kiocb *req, bool force_nonblock,
+static int io_connect(struct io_kiocb *req, unsigned int issue_flags,
 		      struct io_comp_state *cs)
 {
 	struct io_async_connect __io, *io;
 	unsigned file_flags;
 	int ret;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
 	if (req->async_data) {
 		io = req->async_data;
@@ -5039,13 +5053,13 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return -EOPNOTSUPP;
 }
 
-static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
+static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags,
 		      struct io_comp_state *cs)
 {
 	return -EOPNOTSUPP;
 }
 
-static int io_send(struct io_kiocb *req, bool force_nonblock,
+static int io_send(struct io_kiocb *req, unsigned int issue_flags,
 		   struct io_comp_state *cs)
 {
 	return -EOPNOTSUPP;
@@ -5057,13 +5071,13 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	return -EOPNOTSUPP;
 }
 
-static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
+static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags,
 		      struct io_comp_state *cs)
 {
 	return -EOPNOTSUPP;
 }
 
-static int io_recv(struct io_kiocb *req, bool force_nonblock,
+static int io_recv(struct io_kiocb *req, unsigned int issue_flags,
 		   struct io_comp_state *cs)
 {
 	return -EOPNOTSUPP;
@@ -5074,7 +5088,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return -EOPNOTSUPP;
 }
 
-static int io_accept(struct io_kiocb *req, bool force_nonblock,
+static int io_accept(struct io_kiocb *req, unsigned int issue_flags,
 		     struct io_comp_state *cs)
 {
 	return -EOPNOTSUPP;
@@ -5085,7 +5099,7 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return -EOPNOTSUPP;
 }
 
-static int io_connect(struct io_kiocb *req, bool force_nonblock,
+static int io_connect(struct io_kiocb *req, unsigned int issue_flags,
 		      struct io_comp_state *cs)
 {
 	return -EOPNOTSUPP;
@@ -5963,14 +5977,14 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_files_update(struct io_kiocb *req, bool force_nonblock,
+static int io_files_update(struct io_kiocb *req, unsigned int issue_flags,
 			   struct io_comp_state *cs)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_rsrc_update up;
 	int ret;
 
-	if (force_nonblock)
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
 	up.offset = req->rsrc_update.offset;
@@ -6189,7 +6203,7 @@ static void __io_clean_op(struct io_kiocb *req)
 	}
 }
 
-static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
+static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags,
 			struct io_comp_state *cs)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -6202,15 +6216,15 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 	case IORING_OP_READ:
-		ret = io_read(req, force_nonblock, cs);
+		ret = io_read(req, issue_flags, cs);
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
-		ret = io_write(req, force_nonblock, cs);
+		ret = io_write(req, issue_flags, cs);
 		break;
 	case IORING_OP_FSYNC:
-		ret = io_fsync(req, force_nonblock);
+		ret = io_fsync(req, issue_flags);
 		break;
 	case IORING_OP_POLL_ADD:
 		ret = io_poll_add(req);
@@ -6219,19 +6233,19 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 		ret = io_poll_remove(req);
 		break;
 	case IORING_OP_SYNC_FILE_RANGE:
-		ret = io_sync_file_range(req, force_nonblock);
+		ret = io_sync_file_range(req, issue_flags);
 		break;
 	case IORING_OP_SENDMSG:
-		ret = io_sendmsg(req, force_nonblock, cs);
+		ret = io_sendmsg(req, issue_flags, cs);
 		break;
 	case IORING_OP_SEND:
-		ret = io_send(req, force_nonblock, cs);
+		ret = io_send(req, issue_flags, cs);
 		break;
 	case IORING_OP_RECVMSG:
-		ret = io_recvmsg(req, force_nonblock, cs);
+		ret = io_recvmsg(req, issue_flags, cs);
 		break;
 	case IORING_OP_RECV:
-		ret = io_recv(req, force_nonblock, cs);
+		ret = io_recv(req, issue_flags, cs);
 		break;
 	case IORING_OP_TIMEOUT:
 		ret = io_timeout(req);
@@ -6240,61 +6254,61 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 		ret = io_timeout_remove(req);
 		break;
 	case IORING_OP_ACCEPT:
-		ret = io_accept(req, force_nonblock, cs);
+		ret = io_accept(req, issue_flags, cs);
 		break;
 	case IORING_OP_CONNECT:
-		ret = io_connect(req, force_nonblock, cs);
+		ret = io_connect(req, issue_flags, cs);
 		break;
 	case IORING_OP_ASYNC_CANCEL:
 		ret = io_async_cancel(req);
 		break;
 	case IORING_OP_FALLOCATE:
-		ret = io_fallocate(req, force_nonblock);
+		ret = io_fallocate(req, issue_flags);
 		break;
 	case IORING_OP_OPENAT:
-		ret = io_openat(req, force_nonblock);
+		ret = io_openat(req, issue_flags);
 		break;
 	case IORING_OP_CLOSE:
-		ret = io_close(req, force_nonblock, cs);
+		ret = io_close(req, issue_flags, cs);
 		break;
 	case IORING_OP_FILES_UPDATE:
-		ret = io_files_update(req, force_nonblock, cs);
+		ret = io_files_update(req, issue_flags, cs);
 		break;
 	case IORING_OP_STATX:
-		ret = io_statx(req, force_nonblock);
+		ret = io_statx(req, issue_flags);
 		break;
 	case IORING_OP_FADVISE:
-		ret = io_fadvise(req, force_nonblock);
+		ret = io_fadvise(req, issue_flags);
 		break;
 	case IORING_OP_MADVISE:
-		ret = io_madvise(req, force_nonblock);
+		ret = io_madvise(req, issue_flags);
 		break;
 	case IORING_OP_OPENAT2:
-		ret = io_openat2(req, force_nonblock);
+		ret = io_openat2(req, issue_flags);
 		break;
 	case IORING_OP_EPOLL_CTL:
-		ret = io_epoll_ctl(req, force_nonblock, cs);
+		ret = io_epoll_ctl(req, issue_flags, cs);
 		break;
 	case IORING_OP_SPLICE:
-		ret = io_splice(req, force_nonblock);
+		ret = io_splice(req, issue_flags);
 		break;
 	case IORING_OP_PROVIDE_BUFFERS:
-		ret = io_provide_buffers(req, force_nonblock, cs);
+		ret = io_provide_buffers(req, issue_flags, cs);
 		break;
 	case IORING_OP_REMOVE_BUFFERS:
-		ret = io_remove_buffers(req, force_nonblock, cs);
+		ret = io_remove_buffers(req, issue_flags, cs);
 		break;
 	case IORING_OP_TEE:
-		ret = io_tee(req, force_nonblock);
+		ret = io_tee(req, issue_flags);
 		break;
 	case IORING_OP_SHUTDOWN:
-		ret = io_shutdown(req, force_nonblock);
+		ret = io_shutdown(req, issue_flags);
 		break;
 	case IORING_OP_RENAMEAT:
-		ret = io_renameat(req, force_nonblock);
+		ret = io_renameat(req, issue_flags);
 		break;
 	case IORING_OP_UNLINKAT:
-		ret = io_unlinkat(req, force_nonblock);
+		ret = io_unlinkat(req, issue_flags);
 		break;
 	default:
 		ret = -EINVAL;
@@ -6336,7 +6350,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 
 	if (!ret) {
 		do {
-			ret = io_issue_sqe(req, false, NULL);
+			ret = io_issue_sqe(req, 0, NULL);
 			/*
 			 * We can get EAGAIN for polled IO even though we're
 			 * forcing a sync submission from here, since we can't
@@ -6499,7 +6513,7 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 			old_creds = override_creds(req->work.identity->creds);
 	}
 
-	ret = io_issue_sqe(req, true, cs);
+	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK, cs);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
-- 
2.24.0

