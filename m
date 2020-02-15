Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15CBD1600D4
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 23:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgBOWGo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 17:06:44 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34797 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbgBOWGn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 17:06:43 -0500
Received: by mail-wr1-f68.google.com with SMTP id n10so13228148wrm.1;
        Sat, 15 Feb 2020 14:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fc1GAnpw884550NPulN3RKMom4ysjGxVOe69KHdCWnw=;
        b=kPSdhig2gFchvsr1r3rAqyKoR0AGehdQtwyyYqAv6qBhxcOg4P2k/lzlfhK01lLjMv
         zfLvzVRwtNUWcVWx/BOyuAdZBhrK1jOgywqued2MA3ebpS5rAfk6G4fDLT65kqQMs+Pz
         poKWz+EFUStanQRdXaYcAv1eULA8IsJxrO8hXIJv9RR17hKspyJKUdLdlxbHFMI4bxwz
         MA6MSB43VcCno2tY5P4tK8D32QQydR5yWN3OzUrPghKuJl6+vIdHMaXA4pvRj0DUFJco
         PJolMLWgN+2rjMNF7vuYeo08KddxwuboID8w+s7YKyzEXUOtz+P6cfYa+G10jd0gKvZw
         AdeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fc1GAnpw884550NPulN3RKMom4ysjGxVOe69KHdCWnw=;
        b=ThVs1DcRbZBSy8fu7wLhYYb0PI2bDdAcLW539B1Xj6jiWU2xDPlZetKCN5Qpre/Xsr
         cxOc/1uzhDSTm3mqLS8DjesukH4E8NUWAm84eTCbk+qLi4rrd9+X0BNn+yQ4BZxHtRTZ
         EQ4pgqqA2sUcqoCx5zJ6hDaOtnCSbIJaLbyu/FK9d3/Qv9BgppevSewobbx3rq1MaG25
         5a/LTM9G+1Lqm358XgYpww95QoAvwND3XDzCSEdcxSD/GaJQKG7tZxrmKtYYO/H42Pl4
         tLq/sFApm+HDA4iEJPnBkdzf81TWx8/Wmcs4IzCmlxH7K0QA+Y74DfUp2pvTURIgrbw+
         HEbQ==
X-Gm-Message-State: APjAAAXa2aj7RW0nSGYvJBjMNl+5c3M7X0bKaWHsIKk60yqIpeXJQTwk
        JS42mKz1PsPeJgsP/c4zFLA=
X-Google-Smtp-Source: APXvYqySxtg4e/nOZ1ShjkArnqXh4BaopPO8rXz6BEiVXZXuHBZi92RXrMySWTnqbMJmNRzNd8pMXg==
X-Received: by 2002:a5d:534b:: with SMTP id t11mr11675488wrv.120.1581804401041;
        Sat, 15 Feb 2020 14:06:41 -0800 (PST)
Received: from localhost.localdomain ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id v15sm13281923wrf.7.2020.02.15.14.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 14:06:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] io_uring: add interface for getting files
Date:   Sun, 16 Feb 2020 01:05:40 +0300
Message-Id: <f81a1d89d08b9919dc831c4c65b0985af8e45ded.1581802973.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581802973.git.asml.silence@gmail.com>
References: <cover.1581802973.git.asml.silence@gmail.com>
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

