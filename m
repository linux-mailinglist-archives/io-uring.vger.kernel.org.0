Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C860E1448BC
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 01:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgAVAGS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 19:06:18 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38926 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgAVAGO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 19:06:14 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so5400409wrt.6;
        Tue, 21 Jan 2020 16:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2cZDDiM3BuMWFJy6YAY+ROsAm9ZEBM0CwAKXBOcjqCM=;
        b=awHCSggm88zDz9YWt1pnOnrUxq06tRrw4lIPbd0oNLLwcEiY5srQxTDUcgfWVnKuKZ
         5Tq4IMh9Vbx++N5YEM/eOwErNVtxM+m8eUqQouWNTbDwdhfRlqTURS9x8jSZJph+8BCY
         1vEABm5avZyzeGXXR9W6/RhxVgyY2yAmtZFZJCNPyPHb4er8GhbnAkrPW7ZTyoFxmAsB
         /HkrqkFcZ/K8DCVmj43oZmt8zwTXWSpkj8/vz3pEywgN6buyS3GaQUP18cC2tKlP3mLS
         DQ9Hdd6o+IYEnZz+DWwDd1OtOsC5qE0+3PAOrnWBlKuRkYaprxenrbRZIIQim5xR2HZh
         FN8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2cZDDiM3BuMWFJy6YAY+ROsAm9ZEBM0CwAKXBOcjqCM=;
        b=UGxtERDFZ42ug3H2EcYAMO21v5zgxvK79ZSgqoMqdyNDwrZAqlnFPM+0zzO3SI9aPF
         /LKtxSgffOlJ6iBCD5kXibTs+hxTDSGGnz1N1lNw7+G1j7aEV7HgsEc7wi11GqiOjXIl
         b4wDR7mYRckYGn1Tm9FACqCszP6FROEAGPtk7M0RWsXW9HNRMsuDsC/tEKjEwMf+MS2N
         qJJ0EYauKi98Qm2YxfYblI/3uWx8rRugY694ra1YtjDV0r1w66ifhZBnXOB0qzlPAUBF
         gIUEZyV3+7b/9AZ58drsz0Ja/OuW2Msd1wT7dzd7wmzjxRajXN5rDrudU5N3rViVs/cc
         nXAA==
X-Gm-Message-State: APjAAAXUGwJmxcfr4Ylakjzu3o0dV22fC/e4oM2G7o6sQgz8xKnLyIOL
        RFDX5fVs0sda+SSSq16+mN+LzMSL
X-Google-Smtp-Source: APXvYqybH+2v7ADk4+RbBKDPW7OBclGAoqOmcYF63BucYYn2KAQGRBNA1rdqHnWyZgkxJS8GdYSy1Q==
X-Received: by 2002:adf:edc4:: with SMTP id v4mr7508248wro.336.1579651572122;
        Tue, 21 Jan 2020 16:06:12 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id o4sm54527068wrw.97.2020.01.21.16.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 16:06:11 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/3] io_uring: add interface for getting files
Date:   Wed, 22 Jan 2020 03:05:18 +0300
Message-Id: <96dc9d5a58450f462a62679e67db85850370a9f6.1579649589.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579649589.git.asml.silence@gmail.com>
References: <cover.1579649589.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Preparation without functional changes. Adds io_get_file(), that allows
to grab files not only into req->file.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 66 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 25 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8f7846cb1ebf..e9e4aee0fb99 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1161,6 +1161,15 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	return NULL;
 }
 
+static inline void io_put_file(struct io_ring_ctx *ctx, struct file *file,
+			  bool fixed)
+{
+	if (fixed)
+		percpu_ref_put(&ctx->file_data->refs);
+	else
+		fput(file);
+}
+
 static void __io_req_do_free(struct io_kiocb *req)
 {
 	if (likely(!io_is_fallback_req(req)))
@@ -1174,12 +1183,8 @@ static void __io_req_aux_free(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	kfree(req->io);
-	if (req->file) {
-		if (req->flags & REQ_F_FIXED_FILE)
-			percpu_ref_put(&ctx->file_data->refs);
-		else
-			fput(req->file);
-	}
+	if (req->file)
+		io_put_file(ctx, req->file, (req->flags & REQ_F_FIXED_FILE));
 }
 
 static void __io_free_req(struct io_kiocb *req)
@@ -4355,41 +4360,52 @@ static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 	return table->files[index & IORING_FILE_TABLE_MASK];;
 }
 
-static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
-			   const struct io_uring_sqe *sqe)
+static int io_get_file(struct io_submit_state *state, struct io_ring_ctx *ctx,
+			int fd, struct file **out_file, bool fixed)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-	unsigned flags;
-	int fd;
-
-	flags = READ_ONCE(sqe->flags);
-	fd = READ_ONCE(sqe->fd);
-
-	if (!io_req_needs_file(req, fd))
-		return 0;
+	struct file *file;
 
-	if (flags & IOSQE_FIXED_FILE) {
+	if (fixed) {
 		if (unlikely(!ctx->file_data ||
 		    (unsigned) fd >= ctx->nr_user_files))
 			return -EBADF;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
-		req->file = io_file_from_index(ctx, fd);
-		if (!req->file)
+		file = io_file_from_index(ctx, fd);
+		if (!file)
 			return -EBADF;
-		req->flags |= REQ_F_FIXED_FILE;
 		percpu_ref_get(&ctx->file_data->refs);
 	} else {
-		if (req->needs_fixed_file)
-			return -EBADF;
 		trace_io_uring_file_get(ctx, fd);
-		req->file = io_file_get(state, fd);
-		if (unlikely(!req->file))
+		file = io_file_get(state, fd);
+		if (unlikely(!file))
 			return -EBADF;
 	}
 
+	*out_file = file;
 	return 0;
 }
 
+static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
+			   const struct io_uring_sqe *sqe)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	unsigned flags;
+	int fd;
+	bool fixed;
+
+	flags = READ_ONCE(sqe->flags);
+	fd = READ_ONCE(sqe->fd);
+
+	if (!io_req_needs_file(req, fd))
+		return 0;
+
+	fixed = (flags & IOSQE_FIXED_FILE);
+	if (unlikely(!fixed && req->needs_fixed_file))
+		return -EBADF;
+
+	return io_get_file(state, ctx, fd, &req->file, fixed);
+}
+
 static int io_grab_files(struct io_kiocb *req)
 {
 	int ret = -EBADF;
-- 
2.24.0

