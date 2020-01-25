Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F10149795
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 20:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgAYTyl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 14:54:41 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55070 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbgAYTyk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jan 2020 14:54:40 -0500
Received: by mail-wm1-f65.google.com with SMTP id g1so2751171wmh.4;
        Sat, 25 Jan 2020 11:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4OZ7svw6m6C8k/C86I3vgdIUtLFgq0wdc/Gt2pShyRM=;
        b=E+zkxs2ihlBK/65EIgknxK8PrGbZSij4uiusiVxsPmgW1hmxE2pu9IEBkwgYSe+atC
         0HcbW0bIWQUUtji/uw++MtcEFz4CSuZgU/WaOnSZ+PpkM0S9CVbhC3q7SFCswI1puCPy
         W2U+z6B5vPUpxPWRiHRJPQJowGUfBAglGLtfW1O9acgV/vpBFQd4xr/ohUsKk8b/tfdN
         O6jZlhEbxb6tm2U85PQI67B0FVmWwjI7Xkm1Xqnfug8VnxohZ5y53PN+SG2RxbLChWQZ
         4/P0Wq4nG+9yXWC0RiD//bsXhQkEtMPHPQh2Nc/wjIMau4oalu0x/b1vbpmA+YGrr0EJ
         X5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4OZ7svw6m6C8k/C86I3vgdIUtLFgq0wdc/Gt2pShyRM=;
        b=Ji2wJT5nLPhE0m8umIvA+RUdP5y/M8trZYrvEYVZMqmpAhPUt07zLHmI//IaTUTqmk
         j6oNBBcEeqOIAAdKwIvsp/0Yi8pqB/D4zoBynwLVG01e4NbyzOL+2ikkpj4laA1YWmbx
         n+7JJr9ZRlMY3on8On7LMAfU+Lqd+NT3uRnaLhmJ+IiZ74RnP7Z2gc68BhKJoZ4EXTb9
         k8ItP6HzxDtfgzQpJpPRvrkriWCvDJb8NzZh6Ddig3CGOfh0ysgxdV4Z9NuVPEa8V26u
         oDZY07PG58arGxnqGouD8WPP8Ht+QJ1lwms4BZY4PY04VxhtLRVg6W7W6H4yIRg/6ymQ
         TK2g==
X-Gm-Message-State: APjAAAW4AKxFkdlH+mC0Y6N0laWLHaDJaNhPknb/LRBc+drDy57avaof
        2XIpOjlsosgd2UKtYf8YTkk=
X-Google-Smtp-Source: APXvYqySgyxzv+GZNW5oSp4J6ufYZYnowsPg9c5IikT8o3oNDN21Y1ldQotHuOu0Kif54j/4IHd09g==
X-Received: by 2002:a05:600c:23ce:: with SMTP id p14mr4742805wmb.114.1579982079065;
        Sat, 25 Jan 2020 11:54:39 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id m21sm11883712wmi.27.2020.01.25.11.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 11:54:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/8] io_uring: move ring_fd  into io_submit_state
Date:   Sat, 25 Jan 2020 22:53:41 +0300
Message-Id: <99f1a3b886c9e81af8ecda58ba10c71f445cc940.1579981749.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579981749.git.asml.silence@gmail.com>
References: <cover.1579981749.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ring_fd and ring_file are set per submission, so move them into
the submission state.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8b159e21a35f..4597f556d277 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -216,6 +216,9 @@ struct io_submit_state {
 	unsigned int		has_refs;
 	unsigned int		used_refs;
 	unsigned int		ios_left;
+
+	struct file		*ring_file;
+	int			ring_fd;
 };
 
 struct io_ring_ctx {
@@ -274,8 +277,6 @@ struct io_ring_ctx {
 	 */
 	struct fixed_file_data	*file_data;
 	unsigned		nr_user_files;
-	int 			ring_fd;
-	struct file 		*ring_file;
 
 	/* if used, fixed mapped user buffers */
 	unsigned		nr_user_bufs;
@@ -2783,7 +2784,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	req->close.fd = READ_ONCE(sqe->fd);
 	if (req->file->f_op == &io_uring_fops ||
-	    req->close.fd == req->ctx->ring_fd)
+	    req->close.fd == req->ctx->submit_state.ring_fd)
 		return -EBADF;
 
 	return 0;
@@ -4460,8 +4461,9 @@ static int io_grab_files(struct io_kiocb *req)
 {
 	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_submit_state *state = &ctx->submit_state;
 
-	if (!ctx->ring_file)
+	if (!state->ring_file)
 		return -EBADF;
 
 	rcu_read_lock();
@@ -4472,7 +4474,7 @@ static int io_grab_files(struct io_kiocb *req)
 	 * the fd has changed since we started down this path, and disallow
 	 * this operation if it has.
 	 */
-	if (fcheck(ctx->ring_fd) == ctx->ring_file) {
+	if (fcheck(state->ring_fd) == state->ring_file) {
 		list_add(&req->inflight_entry, &ctx->inflight_list);
 		req->flags |= REQ_F_INFLIGHT;
 		req->work.files = current->files;
@@ -4762,13 +4764,17 @@ static void io_submit_end(struct io_ring_ctx *ctx)
 /*
  * Start submission side cache.
  */
-static void io_submit_start(struct io_ring_ctx *ctx, unsigned int max_ios)
+static void io_submit_start(struct io_ring_ctx *ctx, unsigned int max_ios,
+			    struct file *ring_file, int ring_fd)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 
 	state->free_reqs = 0;
 	state->file = NULL;
 	state->ios_left = max_ios;
+
+	state->ring_file = ring_file;
+	state->ring_fd = ring_fd;
 }
 
 static void io_commit_sqring(struct io_ring_ctx *ctx)
@@ -4849,13 +4855,10 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 
-	io_submit_start(ctx, nr);
+	io_submit_start(ctx, nr, ring_file, ring_fd);
 	if (nr > IO_PLUG_THRESHOLD)
 		blk_start_plug(&plug);
 
-	ctx->ring_fd = ring_fd;
-	ctx->ring_file = ring_file;
-
 	for (i = 0; i < nr; i++) {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
-- 
2.24.0

