Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409A514018D
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 02:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388099AbgAQBqp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 20:46:45 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42117 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgAQBqp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 20:46:45 -0500
Received: by mail-ed1-f67.google.com with SMTP id e10so20781876edv.9;
        Thu, 16 Jan 2020 17:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sOb/SV2XPZ+MT9Y0830giiJE0Po7TMwJifwEW5Nm80w=;
        b=iY2seqg1UJtFEnTHYs/aw9KqnM4pWWmmei5HcKqQ7jfMVSyKbbYuuBelmmYaPC7Yj1
         xqVRmK3XG+UOgyTtnf1utiQEBnO+xnnC9mKhhz+qL8WRRcBtplgIg0jqvpLTaXfzC9Jk
         5J0bzj+CbKfe3snr72xuFPU58h+S4dtLOmsYLY6tUhDASAZUcJpWPBhKW82YAgYwntgH
         E0kjwPvAcAN37S408KgBOtCxvD40LqgUVmCSbPOBTyI+pKQazXETSmvysBW0LLzVuGoX
         lzh6LfbkxgFkH4OXIefpbLx8dOLmNIPeXSLcwpMelcB12pazS/h8uu0rAiAH0erAa7Yc
         Jxtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sOb/SV2XPZ+MT9Y0830giiJE0Po7TMwJifwEW5Nm80w=;
        b=A2poryVuYZKN7gNP/bub778mZURg+giMqodU1daEuU4aqdpZ6Zd5f+/0jHgNTRvulj
         aOOnzIfg9OtxSKZqqufI22Jr+a1sjabEwpsrbOGgy7GkEGFcaMv7C91Vnm4vcC+wa4x6
         5gyqGqeKSyIXczh5N7MXS8595AIllQMilckyPNq8v5BdNdGA3hH9C0lixM83u3ZLmjgl
         Sh8xQpYgVX3HP10viFS5V5ZQdkfDVBMz72Ug32LXDaBNc1SyD9s7WJXX+ioZptcxrJd6
         S1zVVkH9goqg1UjNS6w/FumKbqDP7xz8+xDngMA7PiTVpuhEk0OU7kfOjCy0SOmDYlng
         1mRg==
X-Gm-Message-State: APjAAAVFCXRPKEDSHg4zoLwsaKVOYP/Bex3HAuerkYAzCtCnajGvay4J
        krZInqw8CFbaadqDDBo1tpn1qwAW
X-Google-Smtp-Source: APXvYqzuBW2dDJYcsyuUBvZcd4tLyHSvrb0OY0P0K/KzBqbWqs3xChHAsXjJpOWpw30Ow+5E5Blg0A==
X-Received: by 2002:a05:6402:282:: with SMTP id l2mr1382890edv.187.1579225603122;
        Thu, 16 Jan 2020 17:46:43 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id bm18sm932370edb.97.2020.01.16.17.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 17:46:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: hide uring_fd in ctx
Date:   Fri, 17 Jan 2020 04:45:59 +0300
Message-Id: <2aefced4902f33f2b70aaedc32bc8d60a20efd7a.1579225489.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->ring_fd and req->ring_file are used only during the prep stage
during submission, which is is protected by mutex. There is no need
to store them per-request, place them in ctx.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2ace3f1962ff..9ee01c7422cb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -251,6 +251,8 @@ struct io_ring_ctx {
 	 */
 	struct fixed_file_data	*file_data;
 	unsigned		nr_user_files;
+	int 			ring_fd;
+	struct file 		*ring_file;
 
 	/* if used, fixed mapped user buffers */
 	unsigned		nr_user_bufs;
@@ -475,15 +477,10 @@ struct io_kiocb {
 	};
 
 	struct io_async_ctx		*io;
-	union {
-		/*
-		 * ring_file is only used in the submission path, and
-		 * llist_node is only used for poll deferred completions
-		 */
-		struct file		*ring_file;
-		struct llist_node	llist_node;
-	};
-	int				ring_fd;
+	/*
+	 * llist_node is only used for poll deferred completions
+	 */
+	struct llist_node		llist_node;
 	bool				has_user;
 	bool				in_async;
 	bool				needs_fixed_file;
@@ -1139,7 +1136,6 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 
 got_it:
 	req->io = NULL;
-	req->ring_file = NULL;
 	req->file = NULL;
 	req->ctx = ctx;
 	req->flags = 0;
@@ -2721,7 +2717,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	req->close.fd = READ_ONCE(sqe->fd);
 	if (req->file->f_op == &io_uring_fops ||
-	    req->close.fd == req->ring_fd)
+	    req->close.fd == req->ctx->ring_fd)
 		return -EBADF;
 
 	return 0;
@@ -4382,7 +4378,7 @@ static int io_grab_files(struct io_kiocb *req)
 	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!req->ring_file)
+	if (!ctx->ring_file)
 		return -EBADF;
 
 	rcu_read_lock();
@@ -4393,7 +4389,7 @@ static int io_grab_files(struct io_kiocb *req)
 	 * the fd has changed since we started down this path, and disallow
 	 * this operation if it has.
 	 */
-	if (fcheck(req->ring_fd) == req->ring_file) {
+	if (fcheck(ctx->ring_fd) == ctx->ring_file) {
 		list_add(&req->inflight_entry, &ctx->inflight_list);
 		req->flags |= REQ_F_INFLIGHT;
 		req->work.files = current->files;
@@ -4765,6 +4761,9 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		statep = &state;
 	}
 
+	ctx->ring_fd = ring_fd;
+	ctx->ring_file = ring_file;
+
 	for (i = 0; i < nr; i++) {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
@@ -4797,8 +4796,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			}
 		}
 
-		req->ring_file = ring_file;
-		req->ring_fd = ring_fd;
 		req->has_user = *mm != NULL;
 		req->in_async = async;
 		req->needs_fixed_file = async;
-- 
2.24.0

