Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E1B16A009
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 09:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgBXIbZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 03:31:25 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44286 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgBXIbY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 03:31:24 -0500
Received: by mail-wr1-f65.google.com with SMTP id m16so9233666wrx.11
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 00:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cgnh8o+v9ru/UbAz3auWk3kc/B46g6uzT0rNhyiKTHQ=;
        b=c49+9o57xxuTw86Uf64i3iyHCaSCy3+cFeiCNvzaFH3MM+7+I4k0RysQifgQf5/prE
         FKT32NM+R9Z1Ulbb7bwTqd/5z72kcFeBjfc7rzEd3pqN5VD1XLyJDAaN0aL382PwoL5B
         LohWbkKxtwNBX5vN7Hs4HTMdFcYNkBxMKWCJmeNLYRqr/YqACb9FFiQQg6e15KzGsDHa
         q3E1c+n17N3w8T1BZKe26emLxijDPnhWuJNlg3VlzB5fUqA99gqRfNGjtE71w0hBHUTn
         JCZyDquNB5x5Hu0O+qvBCKk4CyHC+EcopekRShuWhqH/c57jJk7GuBCqzKIqLNq5x89w
         pnMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cgnh8o+v9ru/UbAz3auWk3kc/B46g6uzT0rNhyiKTHQ=;
        b=oFN6CmWMCGOvfhlS72NW/+l6kytiDwbX5h6GsGAiysNvFWILwBhEJeP6DM2xqZ9jcJ
         PatmRxoghi9XXYrA81gfpqCOfrre+2LSMCQeqRpJFRDUvtk6ZViCjxKIH+1mNbQbKSpl
         tp+qAUJeQkMkCWKLhTW2R6PFsTjDUa/pxpE5ig+4ssESl/jPdmRkSqNN4zL/QmE8DDzb
         pzr6eLsvuTz4IMDAywQQDLTVWD6Y9XntZwD5tqXJd7fvtd9uC08353WkOct+qIQn/whx
         c/FNNaXVzBoW5o5HGOWC5Wh0oqcjEGYnzS3n3osrGLzUqszehTn/wEnz15mrTsWwwKO4
         nxdQ==
X-Gm-Message-State: APjAAAW2e65DD7dy0XgxC2u2lkzqUMwU89ou1p/qry8jUt0zP4DgoIMk
        61+mYVPKb8A4MrgmrhjwlmGJ1Qj1
X-Google-Smtp-Source: APXvYqx+e9bWToKKXl27Q8iotvl3RsXQvcOKCG2Pmd8OblMANyB/jnG1jNBVmuuSYSyIaCWBB6uhWQ==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr64049725wrt.367.1582533080775;
        Mon, 24 Feb 2020 00:31:20 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id a16sm17946265wrx.87.2020.02.24.00.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 00:31:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 3/3] io_uring: remove req->in_async
Date:   Mon, 24 Feb 2020 11:30:18 +0300
Message-Id: <ccf8d8b66b9e504bada3e1aed90e7273c5fdc100.1582530396.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582530396.git.asml.silence@gmail.com>
References: <cover.1582530396.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->in_async is not really needed, it only prevents propagation of
@nxt for fast not-blocked submissions. Remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3003e767ced3..b149b6e080c5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -556,7 +556,6 @@ struct io_kiocb {
 	 * llist_node is only used for poll deferred completions
 	 */
 	struct llist_node		llist_node;
-	bool				in_async;
 	bool				needs_fixed_file;
 	u8				opcode;
 
@@ -1974,14 +1973,13 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 	}
 }
 
-static void kiocb_done(struct kiocb *kiocb, ssize_t ret, struct io_kiocb **nxt,
-		       bool in_async)
+static void kiocb_done(struct kiocb *kiocb, ssize_t ret, struct io_kiocb **nxt)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
-	if (in_async && ret >= 0 && kiocb->ki_complete == io_complete_rw)
+	if (ret >= 0 && kiocb->ki_complete == io_complete_rw)
 		*nxt = __io_complete_rw(kiocb, ret);
 	else
 		io_rw_done(kiocb, ret);
@@ -2274,7 +2272,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, nxt, req->in_async);
+			kiocb_done(kiocb, ret2, nxt);
 		} else {
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
@@ -2387,7 +2385,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
 			ret2 = -EAGAIN;
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, nxt, req->in_async);
+			kiocb_done(kiocb, ret2, nxt);
 		} else {
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
@@ -4524,7 +4522,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	}
 
 	if (!ret) {
-		req->in_async = true;
 		do {
 			ret = io_issue_sqe(req, NULL, &nxt, false);
 			/*
@@ -5066,7 +5063,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			*mm = ctx->sqo_mm;
 		}
 
-		req->in_async = async;
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
-- 
2.24.0

