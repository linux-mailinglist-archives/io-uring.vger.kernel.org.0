Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60DA514F466
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 23:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgAaWQw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 17:16:52 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46072 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgAaWQt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 17:16:49 -0500
Received: by mail-wr1-f68.google.com with SMTP id a6so10376647wrx.12;
        Fri, 31 Jan 2020 14:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qnyUc6ol87k8+efpVeEpe7PR5Szno0jpYJYIrJc5/NI=;
        b=g9njLTaNFaO0QIt4QHgnSwDWvQgubQIAU6zPZVqvO+0FzmKIfflLHNmYUO+lr9mNfU
         pUVCFVhPTeyZys15k54WaJn7IOuk14M4NF37ZqLdZsAR8kHpH4QpqMbN7qaXCy8qkA+C
         I2HnAMjI6gwPDdCwmYTyOc3A0nt0+E/EjgCdx0AkDodQAVxUsT0sqRYuT6c2/jdQRXV7
         aH3vTnLmhro6eD2VSDOlXaHCXmNr87LQCwcp/IWh3GpuXgA7YvpPvuaWTAK6QeJYc2Ja
         x4oDrZX3LqDnVhf0v5jyMuhma4pShQdZ3NbdOUD5n0HNJLB5UTNzSKngsjnOmsMhqeJx
         GjeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qnyUc6ol87k8+efpVeEpe7PR5Szno0jpYJYIrJc5/NI=;
        b=IeTInHWyWROrxkXfSHm/1ZIPtk8D7Sb2O6hb53OH/J2aczdW4yPBYgrVOcAmR3Wygt
         D1WOQwwbNQtPt2UWt24eVBEjMkBvm3uDrncGRTk/YVvyApI5UwCTd7L3z+kx62a5L4RG
         rtjfcZamhno0kT0OjsCbYQQGLpGWShofheJEYmsWPcntOMleG6waOWcWwYuhuOd/Lg97
         u34gs3Vfdftc/pvhb+lO8m7jpHm0Cc1f4LgF/PoB8+ra6vxEnPq0xYht7sk7UamzUg7b
         SQvLOvFkvzDTVRkHhEMW2U2hnF0YjBQMp4mfNR/SrQw2ceS8rhdtjSZgAUSC8FDsW02v
         uaZg==
X-Gm-Message-State: APjAAAUrze8Abcmxu+ZtsqDdDd/L7xqpCf2dMCbGVbsFbHNYnCGwMblm
        MnDQkNd3eCOHP+rV0lqzZaI=
X-Google-Smtp-Source: APXvYqw63tAwR5aBfC2d8a73AYspsQaLn7Job68gOmGLNLRZB/3SXQ+kUH1rp8lIqmG/QcanDykJbg==
X-Received: by 2002:adf:d4c7:: with SMTP id w7mr117403wrk.101.1580509008279;
        Fri, 31 Jan 2020 14:16:48 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id e6sm12328001wme.3.2020.01.31.14.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 14:16:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/6] io_uring: move ring_fd into io_submit_state
Date:   Sat,  1 Feb 2020 01:15:52 +0300
Message-Id: <b5f01a0c66b53f5bdc503fb0fbda848dbd6d3ece.1580508735.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1580508735.git.asml.silence@gmail.com>
References: <cover.1580508735.git.asml.silence@gmail.com>
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
index 6109969709ff..725e852e22c5 100644
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
@@ -2822,7 +2823,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	req->close.fd = READ_ONCE(sqe->fd);
 	if (req->file->f_op == &io_uring_fops ||
-	    req->close.fd == req->ctx->ring_fd)
+	    req->close.fd == req->ctx->submit_state.ring_fd)
 		return -EBADF;
 
 	return 0;
@@ -4517,10 +4518,11 @@ static int io_grab_files(struct io_kiocb *req)
 {
 	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_submit_state *state = &ctx->submit_state;
 
 	if (req->work.files)
 		return 0;
-	if (!ctx->ring_file)
+	if (!state->ring_file)
 		return -EBADF;
 
 	rcu_read_lock();
@@ -4531,7 +4533,7 @@ static int io_grab_files(struct io_kiocb *req)
 	 * the fd has changed since we started down this path, and disallow
 	 * this operation if it has.
 	 */
-	if (fcheck(ctx->ring_fd) == ctx->ring_file) {
+	if (fcheck(state->ring_fd) == state->ring_file) {
 		list_add(&req->inflight_entry, &ctx->inflight_list);
 		req->flags |= REQ_F_INFLIGHT;
 		req->work.files = current->files;
@@ -4839,13 +4841,17 @@ static void io_submit_end(struct io_ring_ctx *ctx)
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
@@ -4926,13 +4932,10 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
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

