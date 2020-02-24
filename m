Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0CD316A010
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 09:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbgBXIds (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 03:33:48 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37266 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgBXIdr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 03:33:47 -0500
Received: by mail-wr1-f65.google.com with SMTP id l5so5016225wrx.4;
        Mon, 24 Feb 2020 00:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=bd6+MsJgJb6j62/7s4OD3XWNsdcKTbXmu9jaTIjzZIo=;
        b=RzvpyPT7XAfDTmJLUy6D2/fxHiX102cueGX5Eeh3v9YLVLxOAydfMUyOvk9nyr1jb9
         HHgDmMN2AGrMD8xc55FY8k8VUTfvn//IeXHRCyoPVCxCxrI/8i0cUf4XdV5wXDcqp77t
         pr7waXrGbBUb21oeW3LmewSW9TyQudTFXEKv+DpibQ2mpcMRN8RGauwezVbVaCjb+aHE
         ArbPV5kq838uG4BEjpzrkbDYbUrOx06/hVvJdW0xf17ixB3oqt0nbl3JiPzugn12nVdg
         /mdFTkdfSP+7mEGpf0sej7V0uevbPMv0RPRGOcuGYnkUiVfbMC+lXB32ivKmj4MhJuSe
         nEZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bd6+MsJgJb6j62/7s4OD3XWNsdcKTbXmu9jaTIjzZIo=;
        b=pX3etl+1mzs27h8vbcvfCYHASKKh8EgW45svQsOhgxbb2H3hma1wTznaW3lNa0TXBo
         dOqpV70R6L6NdwpSr8VBbX1cxGzKqWonGA9KXNnhxhlVeJBFoBkfZI9zqqE57CqZDwr1
         2G8iWvzwEBwtt6dw7eJrmltK6W20Gwm42KZKq19pYsmig32PfoFJGQA1MUYMDmzJigga
         drZ6U5uEvVcHRK94CJ7k3aJ63sfGLGHK7CVSg7Keb/XOL9QeMurQCJrZMYB2+iJ6iFK7
         xN75zxtTn42KrHEzGubQZGRugGZZGicLWvkrxGZM+0k4JaDWWxhT8fS2zkNPekIZBR5E
         p3Ug==
X-Gm-Message-State: APjAAAVzbghTnlUU9G5CwowVXT2tS54OuyG5tOB5xStiRR1YYR+q0f8E
        UfavoO5SUwkXhiTjMoW7gIc=
X-Google-Smtp-Source: APXvYqznhW+GMtJiZMeOBcGVAcnunZYfNP2neR3xzE3tjQ1BC3S/2aqQIEX3JmybTbPPRp6qm+andg==
X-Received: by 2002:a5d:4085:: with SMTP id o5mr64689573wrp.321.1582533225042;
        Mon, 24 Feb 2020 00:33:45 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id p15sm16695353wma.40.2020.02.24.00.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 00:33:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/3] io_uring: add interface for getting files
Date:   Mon, 24 Feb 2020 11:32:44 +0300
Message-Id: <038c211a59c0dfb2408a8d6f717af5336aaf0b50.1582530525.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582530525.git.asml.silence@gmail.com>
References: <cover.1582530525.git.asml.silence@gmail.com>
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
 fs/io_uring.c | 72 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 29 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b149b6e080c5..443870e0dc46 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1258,6 +1258,15 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	return NULL;
 }
 
+static inline void io_put_file(struct io_kiocb *req, struct file *file,
+			  bool fixed)
+{
+	if (fixed)
+		percpu_ref_put(&req->ctx->file_data->refs);
+	else
+		fput(file);
+}
+
 static void __io_req_do_free(struct io_kiocb *req)
 {
 	if (likely(!io_is_fallback_req(req)))
@@ -1268,18 +1277,12 @@ static void __io_req_do_free(struct io_kiocb *req)
 
 static void __io_req_aux_free(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		io_cleanup_req(req);
 
 	kfree(req->io);
-	if (req->file) {
-		if (req->flags & REQ_F_FIXED_FILE)
-			percpu_ref_put(&ctx->file_data->refs);
-		else
-			fput(req->file);
-	}
+	if (req->file)
+		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 
 	io_req_work_drop_env(req);
 }
@@ -1849,7 +1852,7 @@ static void io_file_put(struct io_submit_state *state)
  * assuming most submissions are for one file, or at least that each file
  * has more than one submission.
  */
-static struct file *io_file_get(struct io_submit_state *state, int fd)
+static struct file *__io_file_get(struct io_submit_state *state, int fd)
 {
 	if (!state)
 		return fget(fd);
@@ -4567,41 +4570,52 @@ static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 	return table->files[index & IORING_FILE_TABLE_MASK];;
 }
 
-static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
-			   const struct io_uring_sqe *sqe)
+static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
+			int fd, struct file **out_file, bool fixed)
 {
 	struct io_ring_ctx *ctx = req->ctx;
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
+		file = __io_file_get(state, fd);
+		if (unlikely(!file))
 			return -EBADF;
 	}
 
+	*out_file = file;
 	return 0;
 }
 
+static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
+			   const struct io_uring_sqe *sqe)
+{
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
+	return io_file_get(state, req, fd, &req->file, fixed);
+}
+
 static int io_grab_files(struct io_kiocb *req)
 {
 	int ret = -EBADF;
@@ -4846,8 +4860,8 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	}
 
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
-	req->flags |= sqe_flags & (IOSQE_IO_DRAIN|IOSQE_IO_HARDLINK|
-					IOSQE_ASYNC);
+	req->flags |= sqe_flags & (IOSQE_IO_DRAIN | IOSQE_IO_HARDLINK |
+					IOSQE_ASYNC | IOSQE_FIXED_FILE);
 
 	ret = io_req_set_file(state, req, sqe);
 	if (unlikely(ret)) {
-- 
2.24.0

