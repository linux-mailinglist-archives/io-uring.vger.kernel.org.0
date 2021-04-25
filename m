Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01D336A78E
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 15:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhDYNd1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 09:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhDYNd1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 09:33:27 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C11C061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:46 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id i21-20020a05600c3555b029012eae2af5d4so3670025wmq.4
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nnhNhGQkVpAobDJ3mIZeuFkl+LPGEeJpZsBSaAgVrJQ=;
        b=VzEQbXWgujbqOZfCT6Z9jsjw3wQbmwGQSylDKMse1nQZLn6t6KmpgESaW6b0ZLHaVh
         +Im5599V41h4RzfazdfL1QgE5o0qbJHVUH8bKadMloUR8JsIAUrVa5qDwhqkOlgIVAKf
         uFQZOVa+vbM6FSej0wqVALCPvxCiQGv0pByJjkepj5kNeRe63ZbwLk/CdpIwjp9WU1g4
         huJ4qZyiKP0gs5IZD2D7S1A5u/o8bOem8nqIi3dmObiar6pnIUU7r9U/QEtRmI13QuLL
         mdU7FwWtnTJ2iIk4TfxMh/BH5YtNHpIdaENkYDULCG49CvZyABAOdY5w0xmV7zknGOm6
         9nXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nnhNhGQkVpAobDJ3mIZeuFkl+LPGEeJpZsBSaAgVrJQ=;
        b=DxPLnDOKak4m2F0QmS+wQ2G9AnrbInlQ/DwV6qtxEZeDYNosqWycpFoVf/Dhsf4rWY
         KoUyJYi6/M8Jp6pt99miFxYGrEy9s9a0+e+WarVTmZzHxavnXVJvLNOx/VW2XaTaV9i5
         YrNA7sNiF4rlXFnT6CM7Yq4e/Ui9idzbiNNi5SBKmYe6ChwO/oI4CCVX0b0TAmE7tJkN
         DPHReifVudWVs2G/nXMztdSEdIArcA6b2TC5MU7v9FK+5tFYOLOgSR7XUbw6AaRhdNTD
         YPWnys1FFjps/ieoNH64p5MSspGKkT/YrwBsfgW0EwKJrd9zmPMyQ2wwaVibcACxt54e
         ppbw==
X-Gm-Message-State: AOAM532hA1GxMhcqlvFaXBm5O9I1d+IfIPWC68DLX4oZOZwT5qF7i3L4
        MtPxEM7+v/F3NgDmm4rQ3MamEtB9lYM=
X-Google-Smtp-Source: ABdhPJwclwsHXSR8YS/C0RzoErxkdMd+T+yPSex6TIoNsBxfX7La64qTVjUKS9Vz3TDg+4tE3bnFKw==
X-Received: by 2002:a1c:7c08:: with SMTP id x8mr15812189wmc.130.1619357565071;
        Sun, 25 Apr 2021 06:32:45 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id a2sm16551552wrt.82.2021.04.25.06.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 06:32:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 10/12] io_uring: prepare fixed rw for dynanic buffers
Date:   Sun, 25 Apr 2021 14:32:24 +0100
Message-Id: <21a2302d07766ae956640b6f753292c45200fe8f.1619356238.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619356238.git.asml.silence@gmail.com>
References: <cover.1619356238.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With dynamic buffer updates, registered buffers in the table may change
at any moment. First of all we want to prevent future races between
updating and importing (i.e. io_import_fixed()), where the latter one
may happen without uring_lock held, e.g. from io-wq.

Save the first loaded io_mapped_ubuf buffer and reuse.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ea725c0cbf79..083917bd7aa6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -839,6 +839,8 @@ struct io_kiocb {
 	struct hlist_node		hash_node;
 	struct async_poll		*apoll;
 	struct io_wq_work		work;
+	/* store used ubuf, so we can prevent reloading */
+	struct io_mapped_ubuf		*imu;
 };
 
 struct io_tctx_node {
@@ -2683,6 +2685,12 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		kiocb->ki_complete = io_complete_rw;
 	}
 
+	if (req->opcode == IORING_OP_READ_FIXED ||
+	    req->opcode == IORING_OP_WRITE_FIXED) {
+		req->imu = NULL;
+		io_req_set_rsrc_node(req);
+	}
+
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
 	req->buf_index = READ_ONCE(sqe->buf_index);
@@ -2748,21 +2756,13 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 	}
 }
 
-static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
+static int __io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
+			     struct io_mapped_ubuf *imu)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	size_t len = req->rw.len;
-	struct io_mapped_ubuf *imu;
-	u16 index, buf_index = req->buf_index;
 	u64 buf_end, buf_addr = req->rw.addr;
 	size_t offset;
 
-	if (unlikely(buf_index >= ctx->nr_user_bufs))
-		return -EFAULT;
-	index = array_index_nospec(buf_index, ctx->nr_user_bufs);
-	imu = ctx->user_bufs[index];
-	buf_addr = req->rw.addr;
-
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
 		return -EFAULT;
 	/* not inside the mapped region */
@@ -2814,6 +2814,22 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 	return 0;
 }
 
+static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_mapped_ubuf *imu = req->imu;
+	u16 index, buf_index = req->buf_index;
+
+	if (likely(!imu)) {
+		if (unlikely(buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
+		index = array_index_nospec(buf_index, ctx->nr_user_bufs);
+		imu = READ_ONCE(ctx->user_bufs[index]);
+		req->imu = imu;
+	}
+	return __io_import_fixed(req, rw, iter, imu);
+}
+
 static void io_ring_submit_unlock(struct io_ring_ctx *ctx, bool needs_lock)
 {
 	if (needs_lock)
@@ -9463,6 +9479,9 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
+	/* always set a rsrc node */
+	io_rsrc_node_switch_start(ctx);
+	io_rsrc_node_switch(ctx, NULL);
 
 	memset(&p->sq_off, 0, sizeof(p->sq_off));
 	p->sq_off.head = offsetof(struct io_rings, sq.head);
-- 
2.31.1

