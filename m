Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8028C33FAC6
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 23:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCQWK7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 18:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhCQWKe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 18:10:34 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC533C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:33 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id d2so3023552ilm.10
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RExH8A+arcnU9wtWrDJl/UX/i0oSrlS6iszY7ly2uwA=;
        b=RNz9sBybG1lRJUkz3FXFMx8fiUjVoWFRC1nTLCzTPvBPKmbEKOxByeSsfgtNZzcfon
         1ay/hB1LyK/TwEJEQ/9eJEo4MqY3GEqt+fn204sPJngzB43oKf4ttXE1oUGkIyPzwNfS
         XJQ+hnxB7FJYV75ryxgqsTn9ruRyEDZ+0v8V31lOJPvUV7e5HUpKWfQOMfST3b8zC9v5
         HDSymiXiaECir/WHl17cVciQOoDldafqx/6o02y2SSKSQU4T/myUWo9zCZ5XXElnGjiT
         suDBoYczRgt1jZZaMtZ24WWX0oC5HROPvkGHbicC8aGxnZY6e7rzO75Ut+cxhKqObCl9
         EdGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RExH8A+arcnU9wtWrDJl/UX/i0oSrlS6iszY7ly2uwA=;
        b=pU6xzseH5IQnSYzT7Q8yVTCuWWxlxqLbofBiRxSj0BC9B6SgZFZ2eKCfCxMbVdYw/H
         QEgZdnxw79t+CK+D5si7qDH4CqWvYOT3aeOjPAb+GjILUn8LbH7vw8oVPhrRpdr1RubM
         7CSgi87uKDOm1TK72TwA4/ZGC7T8eM4XqZyurS0UMX5g2KSlLRULSoNbKvFbAIzSZWj7
         R73g8OtDq7An+/Ca2+9Xp21XkqYX2IMTKSwTpiMoOLUPl74Fn5+zWVeJ0HNUqg12/iES
         R43MgTkygZMcrRMS8tIG+h5n6xdY2taDgsDe4W4YUmzRUUd7wTqyD2OpKNyKOkKToCtG
         vAIA==
X-Gm-Message-State: AOAM532Cbc+F5aFSyHzyqwll12Hd2pX1oNAd/v0C5npdhIgJ2kC7ka7W
        Ye4SQ7I/yYnpIl6tXZ+paS54wAfFG70dGA==
X-Google-Smtp-Source: ABdhPJz1c0U+eXPv3Hepxz7eU+sunp/vDvsEqafuTssJLTWmQuFyJxmpb0XTc5Q3n2477+PCQjobZQ==
X-Received: by 2002:a92:c607:: with SMTP id p7mr3165678ilm.70.1616019033066;
        Wed, 17 Mar 2021 15:10:33 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r3sm160700ilq.42.2021.03.17.15.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:10:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, hch@lst.de, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] io_uring: split up io_uring_sqe into hdr + main
Date:   Wed, 17 Mar 2021 16:10:20 -0600
Message-Id: <20210317221027.366780-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317221027.366780-1-axboe@kernel.dk>
References: <20210317221027.366780-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for overlaying passthrough commands on the io_uring_sqe
struct, split out the header part as we'll be reusing that for the
new format as well.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 73 ++++++++++++++++++-----------------
 include/uapi/linux/io_uring.h | 11 ++++++
 2 files changed, 48 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5538568f24e9..416e47832468 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2722,7 +2722,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if ((kiocb->ki_flags & IOCB_NOWAIT) || (file->f_flags & O_NONBLOCK))
 		req->flags |= REQ_F_NOWAIT;
 
-	ioprio = READ_ONCE(sqe->ioprio);
+	ioprio = READ_ONCE(sqe->hdr.ioprio);
 	if (ioprio) {
 		ret = ioprio_check_cap(ioprio);
 		if (ret)
@@ -3467,7 +3467,7 @@ static int io_renameat_prep(struct io_kiocb *req,
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 
-	ren->old_dfd = READ_ONCE(sqe->fd);
+	ren->old_dfd = READ_ONCE(sqe->hdr.fd);
 	oldf = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	newf = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	ren->new_dfd = READ_ONCE(sqe->len);
@@ -3514,7 +3514,7 @@ static int io_unlinkat_prep(struct io_kiocb *req,
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 
-	un->dfd = READ_ONCE(sqe->fd);
+	un->dfd = READ_ONCE(sqe->hdr.fd);
 
 	un->flags = READ_ONCE(sqe->unlink_flags);
 	if (un->flags & ~AT_REMOVEDIR)
@@ -3555,7 +3555,7 @@ static int io_shutdown_prep(struct io_kiocb *req,
 #if defined(CONFIG_NET)
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->addr || sqe->rw_flags ||
+	if (sqe->hdr.ioprio || sqe->off || sqe->addr || sqe->rw_flags ||
 	    sqe->buf_index)
 		return -EINVAL;
 
@@ -3711,7 +3711,7 @@ static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->addr || sqe->hdr.ioprio || sqe->buf_index))
 		return -EINVAL;
 
 	req->sync.flags = READ_ONCE(sqe->fsync_flags);
@@ -3744,7 +3744,7 @@ static int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
 static int io_fallocate_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
-	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags)
+	if (sqe->hdr.ioprio || sqe->buf_index || sqe->rw_flags)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -3775,7 +3775,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	const char __user *fname;
 	int ret;
 
-	if (unlikely(sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->hdr.ioprio || sqe->buf_index))
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -3784,7 +3784,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	if (!(req->open.how.flags & O_PATH) && force_o_largefile())
 		req->open.how.flags |= O_LARGEFILE;
 
-	req->open.dfd = READ_ONCE(sqe->fd);
+	req->open.dfd = READ_ONCE(sqe->hdr.fd);
 	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	req->open.filename = getname(fname);
 	if (IS_ERR(req->open.filename)) {
@@ -3900,10 +3900,10 @@ static int io_remove_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
-	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off)
+	if (sqe->hdr.ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off)
 		return -EINVAL;
 
-	tmp = READ_ONCE(sqe->fd);
+	tmp = READ_ONCE(sqe->hdr.fd);
 	if (!tmp || tmp > USHRT_MAX)
 		return -EINVAL;
 
@@ -3970,10 +3970,10 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
-	if (sqe->ioprio || sqe->rw_flags)
+	if (sqe->hdr.ioprio || sqe->rw_flags)
 		return -EINVAL;
 
-	tmp = READ_ONCE(sqe->fd);
+	tmp = READ_ONCE(sqe->hdr.fd);
 	if (!tmp || tmp > USHRT_MAX)
 		return -E2BIG;
 	p->nbufs = tmp;
@@ -4050,12 +4050,12 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_EPOLL)
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->hdr.ioprio || sqe->buf_index)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL)))
 		return -EINVAL;
 
-	req->epoll.epfd = READ_ONCE(sqe->fd);
+	req->epoll.epfd = READ_ONCE(sqe->hdr.fd);
 	req->epoll.op = READ_ONCE(sqe->len);
 	req->epoll.fd = READ_ONCE(sqe->off);
 
@@ -4096,7 +4096,7 @@ static int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
-	if (sqe->ioprio || sqe->buf_index || sqe->off)
+	if (sqe->hdr.ioprio || sqe->buf_index || sqe->off)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4131,7 +4131,7 @@ static int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	if (sqe->ioprio || sqe->buf_index || sqe->addr)
+	if (sqe->hdr.ioprio || sqe->buf_index || sqe->addr)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4169,12 +4169,12 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->hdr.ioprio || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
 
-	req->statx.dfd = READ_ONCE(sqe->fd);
+	req->statx.dfd = READ_ONCE(sqe->hdr.fd);
 	req->statx.mask = READ_ONCE(sqe->len);
 	req->statx.filename = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	req->statx.buffer = u64_to_user_ptr(READ_ONCE(sqe->addr2));
@@ -4208,13 +4208,13 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
+	if (sqe->hdr.ioprio || sqe->off || sqe->addr || sqe->len ||
 	    sqe->rw_flags || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
 
-	req->close.fd = READ_ONCE(sqe->fd);
+	req->close.fd = READ_ONCE(sqe->hdr.fd);
 	return 0;
 }
 
@@ -4277,7 +4277,7 @@ static int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->addr || sqe->hdr.ioprio || sqe->buf_index))
 		return -EINVAL;
 
 	req->sync.off = READ_ONCE(sqe->off);
@@ -4698,7 +4698,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index)
+	if (sqe->hdr.ioprio || sqe->len || sqe->buf_index)
 		return -EINVAL;
 
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -4746,7 +4746,7 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags)
+	if (sqe->hdr.ioprio || sqe->len || sqe->buf_index || sqe->rw_flags)
 		return -EINVAL;
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -5290,7 +5290,7 @@ static int io_poll_remove_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index ||
+	if (sqe->hdr.ioprio || sqe->off || sqe->len || sqe->buf_index ||
 	    sqe->poll_events)
 		return -EINVAL;
 
@@ -5341,7 +5341,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->addr || sqe->ioprio || sqe->off || sqe->len || sqe->buf_index)
+	if (sqe->addr || sqe->hdr.ioprio || sqe->off || sqe->len || sqe->buf_index)
 		return -EINVAL;
 
 	events = READ_ONCE(sqe->poll32_events);
@@ -5466,7 +5466,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len)
+	if (sqe->hdr.ioprio || sqe->buf_index || sqe->len)
 		return -EINVAL;
 
 	tr->addr = READ_ONCE(sqe->addr);
@@ -5525,7 +5525,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len != 1)
+	if (sqe->hdr.ioprio || sqe->buf_index || sqe->len != 1)
 		return -EINVAL;
 	if (off && is_timeout_link)
 		return -EINVAL;
@@ -5677,7 +5677,7 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags)
+	if (sqe->hdr.ioprio || sqe->off || sqe->len || sqe->cancel_flags)
 		return -EINVAL;
 
 	req->cancel.addr = READ_ONCE(sqe->addr);
@@ -5738,7 +5738,7 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->rw_flags)
+	if (sqe->hdr.ioprio || sqe->rw_flags)
 		return -EINVAL;
 
 	req->rsrc_update.offset = READ_ONCE(sqe->off);
@@ -6390,9 +6390,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	unsigned int sqe_flags;
 	int personality, ret = 0;
 
-	req->opcode = READ_ONCE(sqe->opcode);
+	req->opcode = READ_ONCE(sqe->hdr.opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
-	req->flags = sqe_flags = READ_ONCE(sqe->flags);
+	req->flags = sqe_flags = READ_ONCE(sqe->hdr.flags);
 	req->user_data = READ_ONCE(sqe->user_data);
 	req->async_data = NULL;
 	req->file = NULL;
@@ -6445,7 +6445,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (io_op_defs[req->opcode].needs_file) {
 		bool fixed = req->flags & REQ_F_FIXED_FILE;
 
-		req->file = io_file_get(state, req, READ_ONCE(sqe->fd), fixed);
+		req->file = io_file_get(state, req, READ_ONCE(sqe->hdr.fd),
+					fixed);
 		if (unlikely(!req->file))
 			ret = -EBADF;
 	}
@@ -9914,10 +9915,10 @@ static int __init io_uring_init(void)
 #define BUILD_BUG_SQE_ELEM(eoffset, etype, ename) \
 	__BUILD_BUG_VERIFY_ELEMENT(struct io_uring_sqe, eoffset, etype, ename)
 	BUILD_BUG_ON(sizeof(struct io_uring_sqe) != 64);
-	BUILD_BUG_SQE_ELEM(0,  __u8,   opcode);
-	BUILD_BUG_SQE_ELEM(1,  __u8,   flags);
-	BUILD_BUG_SQE_ELEM(2,  __u16,  ioprio);
-	BUILD_BUG_SQE_ELEM(4,  __s32,  fd);
+	BUILD_BUG_SQE_ELEM(0,  __u8,   hdr.opcode);
+	BUILD_BUG_SQE_ELEM(1,  __u8,   hdr.flags);
+	BUILD_BUG_SQE_ELEM(2,  __u16,  hdr.ioprio);
+	BUILD_BUG_SQE_ELEM(4,  __s32,  hdr.fd);
 	BUILD_BUG_SQE_ELEM(8,  __u64,  off);
 	BUILD_BUG_SQE_ELEM(8,  __u64,  addr2);
 	BUILD_BUG_SQE_ELEM(16, __u64,  addr);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2514eb6b1cf2..5609474ccd9f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -14,11 +14,22 @@
 /*
  * IO submission data structure (Submission Queue Entry)
  */
+struct io_uring_sqe_hdr {
+	__u8	opcode;		/* type of operation for this sqe */
+	__u8	flags;		/* IOSQE_ flags */
+	__u16	ioprio;		/* ioprio for the request */
+	__s32	fd;		/* file descriptor to do IO on */
+};
+
 struct io_uring_sqe {
+#ifdef __KERNEL__
+	struct io_uring_sqe_hdr	hdr;
+#else
 	__u8	opcode;		/* type of operation for this sqe */
 	__u8	flags;		/* IOSQE_ flags */
 	__u16	ioprio;		/* ioprio for the request */
 	__s32	fd;		/* file descriptor to do IO on */
+#endif
 	union {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
-- 
2.31.0

