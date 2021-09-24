Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015E7417B71
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 21:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346138AbhIXTGr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 15:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhIXTGq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 15:06:46 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D47C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:05:13 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id ee50so39788754edb.13
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k+hcUyrs+3q2EGagOaMLqVdgSyb4eFOX9bp64u5d9To=;
        b=OgwA3Ph6L+4F3cai1DkAB+xdRBf5eDD52eujr1nGEjcrnU3CYgac9mR2QNE7AJrqp4
         AYsg9daSvILurroxF4KQk9oWqeTvu+Lhtlg9DJUhgE6M/SmLJH7ODJpHt+tw8AhyaNAc
         7HMw5QLDSfxx8GxE1wUK8YsYk53MA27Bm7caAuiOEVIXu3GE6T6YNGGROsHsGKpfOKQt
         7qGNLe9jDnjPcqYwBCtY4Tl5X6PuSs+m2ln7fVhuYPHWg0QUwE/CuFKgxbFOI0hctjiG
         oEdnEf+cv6NKNbhvEUpTb8REonhOGeI0ODurYRLVzwS7oSGGegAxLLv3YI4W7QAo2CtB
         NaPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k+hcUyrs+3q2EGagOaMLqVdgSyb4eFOX9bp64u5d9To=;
        b=wvsSrmRpbxZ8RtTqa+h0X3aYV9wdwo1uutXl/cLPmDYDE+7tv/zSjOcpxE8jPOBVtj
         0FHgDWd246tqPsXkRtFu1WlIP0MuK0dPV5y8k1QeJJdVv/WSJWyDhRyxl6xWpGDYhtSH
         Hv6VJmjhkLrK17wdpmYWc8tCL7sH8v0PYwh+i2oCnX8CZKeY0XVVfVhkrOZokeXeo3cg
         AlAGozVI2/Ao0EUbTv4Y1R9vXtSA9sKjibfvQHGtBmKJi/WL/zjMvaIJBUTCIZIEH0Eh
         Y9O9v3ic7mlaAiLtkLWwdlI8xyPdvS28xC1n9V4I5T0QQdHLrQoxpRKHjpGrzZoHyzA8
         z1CQ==
X-Gm-Message-State: AOAM5319o4g16t5aftzW8xPar9WKSipmBHEDogksacaE/c1YZduaNKz/
        62zHbEviPScNj+q6etWJ5MC8QxYlh4U=
X-Google-Smtp-Source: ABdhPJx6QN1mqhYwjYIy6BK2AI7S1f+/f/wu8nMPSUY/pSevd2PGZMh4R4TQAHbDER6etuxN03bSgQ==
X-Received: by 2002:a17:906:a3d2:: with SMTP id ca18mr13060510ejb.274.1632510311893;
        Fri, 24 Sep 2021 12:05:11 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id s3sm5609049ejm.49.2021.09.24.12.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 12:05:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: make OP_CLOSE consistent direct open
Date:   Fri, 24 Sep 2021 20:04:29 +0100
Message-Id: <2b8a74c47ef43bfe03fba1973630f7704851dbdc.1632510251.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From recently open/accept are now able to manipulate fixed file table,
but it's inconsistent that close can't. Close the gap, keep API same as
with open/accept, i.e. via sqe->file_slot.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8317c360f7a4..ad71c7ef7f6d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -503,6 +503,7 @@ struct io_poll_update {
 struct io_close {
 	struct file			*file;
 	int				fd;
+	u32				file_slot;
 };
 
 struct io_timeout_data {
@@ -1099,6 +1100,8 @@ static int io_req_prep_async(struct io_kiocb *req);
 
 static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 				 unsigned int issue_flags, u32 slot_index);
+static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
+
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
 
 static struct kmem_cache *req_cachep;
@@ -4590,12 +4593,16 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
-	    sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
+	    sqe->rw_flags || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
+	req->close.file_slot = READ_ONCE(sqe->file_index);
+	if (req->close.file_slot && req->close.fd)
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -4607,6 +4614,11 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file = NULL;
 	int ret = -EBADF;
 
+	if (req->close.file_slot) {
+		ret = io_close_fixed(req, issue_flags);
+		goto err;
+	}
+
 	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
 	if (close->fd >= fdt->max_fds) {
@@ -8400,6 +8412,44 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 	return ret;
 }
 
+static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
+{
+	unsigned int offset = req->close.file_slot - 1;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_fixed_file *file_slot;
+	struct file *file;
+	int ret, i;
+
+	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+	ret = -ENXIO;
+	if (unlikely(!ctx->file_data))
+		goto out;
+	ret = -EINVAL;
+	if (offset >= ctx->nr_user_files)
+		goto out;
+	ret = io_rsrc_node_switch_start(ctx);
+	if (ret)
+		goto out;
+
+	i = array_index_nospec(offset, ctx->nr_user_files);
+	file_slot = io_fixed_file_slot(&ctx->file_table, i);
+	ret = -EBADF;
+	if (!file_slot->file_ptr)
+		goto out;
+
+	file = (struct file *)(file_slot->file_ptr & FFS_MASK);
+	ret = io_queue_rsrc_removal(ctx->file_data, offset, ctx->rsrc_node, file);
+	if (ret)
+		goto out;
+
+	file_slot->file_ptr = 0;
+	io_rsrc_node_switch(ctx, ctx->file_data);
+	ret = 0;
+out:
+	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+	return ret;
+}
+
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update2 *up,
 				 unsigned nr_args)
-- 
2.33.0

