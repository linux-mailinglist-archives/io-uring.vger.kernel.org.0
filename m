Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E9D162F7A
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 20:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgBRTMV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 14:12:21 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45377 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgBRTMV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 14:12:21 -0500
Received: by mail-wr1-f65.google.com with SMTP id g3so25281583wrs.12
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2020 11:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fc1GAnpw884550NPulN3RKMom4ysjGxVOe69KHdCWnw=;
        b=p3qqsi06fnX4OF53mfywrDF+mZLXDM8pgVNfkImdPdmsJivDTxkcFopHJzoVX101ME
         5xI5EbqCuI5Ws6xpJMJGPcahMwTPax7Ub+PFcqewKKjj6o0oSDg3RId86UNpWJqTGeMJ
         yfrB8F1IraR2Mij7GuNLs26da1A1JCW4qH7lojUVWG6bVbTPhvnfPzBQMoohjbCq9SRB
         fQPKDTPZVE0uxWLuK4Zd4z8/kgtnRCFMZX8+GWAh8xtRJnfw/W0d7ENOZ5TwX7z05Fw2
         LbQeitdjTyCUf7tmQrNZ2pMevuLopDNgfX7aB7y3KUlRuGojxfpWly7rYf2Ov2j4a4Y8
         fLYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fc1GAnpw884550NPulN3RKMom4ysjGxVOe69KHdCWnw=;
        b=NARBaw+359peaDC1Kn7nfKx7PIapSX/OXsFLKrd5fPjbgiXgCPZPJh7h/n0YoVbIjd
         rmcx+LpjZE4sUSrr1Y7UrQjG9Ss6erJFHnS7IjCoXoPtqcaIAliMfwd4gsMbXVR1KfM9
         Eu+NjRipU5L7O5z2W0Kwf7bEhhrxhCq1pwzexhLFaVrusHtV2jnHh6li8A+KZvCqrUKH
         1YJA01TDgpS1XH7clcfJvhfYCxJGkpdNfJmFZdEUi8+0YkF0qgTcv93DJLRN1lne/Syu
         VkubdV5+5/edEY54byNUIJap7xj0bL5D1aMScpltCv1zuROPPHzNdoPaZcCrjmGkRjhn
         AjgQ==
X-Gm-Message-State: APjAAAXJGA6uA0boSLIWeg4ybDOs5wlBI3aGNOhcziou2+67KxWnIErV
        T+7Dt9gSuRlNmp3dwZxaCPk=
X-Google-Smtp-Source: APXvYqw10XNt4a+ErTsANMhZfLX9tcXS7ALVbr/N8kUamzvZ4IYsVvr4+H5jmozkuwkwCAgBjU4Mlg==
X-Received: by 2002:adf:f14b:: with SMTP id y11mr7733765wro.90.1582053138902;
        Tue, 18 Feb 2020 11:12:18 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.56])
        by smtp.gmail.com with ESMTPSA id y7sm3862750wmd.1.2020.02.18.11.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 11:12:18 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 2/3] io_uring: add interface for getting files
Date:   Tue, 18 Feb 2020 22:11:23 +0300
Message-Id: <f81a1d89d08b9919dc831c4c65b0985af8e45ded.1582052861.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582052861.git.asml.silence@gmail.com>
References: <cover.1582052861.git.asml.silence@gmail.com>
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
index 5ff7c602ad4d..389db6f5568b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1255,6 +1255,15 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
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
@@ -1268,12 +1277,8 @@ static void __io_req_aux_free(struct io_kiocb *req)
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
 
 	io_req_work_drop_env(req);
 }
@@ -4573,41 +4578,52 @@ static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
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

