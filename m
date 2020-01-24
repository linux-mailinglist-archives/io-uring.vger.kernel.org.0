Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79241149059
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgAXVmE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:42:04 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34659 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAXVli (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:41:38 -0500
Received: by mail-wm1-f65.google.com with SMTP id s144so4868252wme.1;
        Fri, 24 Jan 2020 13:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fOFHOZZ2wx6aiUkxZCBRIqEIuPor2Hq1154qnUaUt5c=;
        b=Z/Cg0gbdCsO+6CCI26k2fgfcHxLiI+w4k3Dbl3+L/Q3k3e+NhJ4fIY0wWrvWmUeQqV
         Iz5qafra1ghZzjmA+X0wXJFRqZNboCPh1g9Hl+dtItehougMZWNqwZwVR8hJlruxTCAR
         an/3eRYMo713aLxDLrUAliKmBCnFtEQsTGbRfq2/hFus37nRXvR0p5lBf7p3Oetz+h8c
         MmEE4cgehHlUKHapl9HuArManZkQZxnGDU3aG/9rXdYDoWMl6hePF2EfqFAUCJuHl4+n
         AZgNN0gPrGAZp6gBokyHSA4kcEFbbBAaRmBWd5kAQuKyBoHkrMWhWirJ9jdWmMaDfFba
         /8rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fOFHOZZ2wx6aiUkxZCBRIqEIuPor2Hq1154qnUaUt5c=;
        b=eSZIIv87IhTO6/azEZb5CG9dg1jh/+QUWIM0bDgGunuQW3r5DjB0EYb+O+2KJ91t38
         aGtWQIfTtOJPUzqaCLnX8x8c77uAlfWzTMxYarBy8/G5gnYDty7J5oiSGyNjzZGscZv7
         gf+1HHgtpba6K2GRt5RrzYOtzhSvNAVWk7/MhhyNbk70vXk2faVH5c05gJ7wqDM9pr54
         clqxXPkzU2MX/GUce/dqroE0Uy4ubNcYdG+xpSmCeJcZ5blwsupTtGD8akq2LJERlG54
         xS4Mtl5bUqm03p7On0kXXUr7nz1RANUTOrpvYuxzygfVRevSXVZplmFTSsoFJzM3F/rS
         SvJA==
X-Gm-Message-State: APjAAAUGX6VCc1ejRlU8rDsVwSPLml69nGU7/6Bb0zQ5zzAexd6x3I3w
        EajUI7V1WlaVW6oE5NsWbzc=
X-Google-Smtp-Source: APXvYqy3pYf/WDdVQDt9awisHuK2QJwEIkP7giS+EqWMgSRqWHR83SkZSMEaLq+H7/MUNtqP8vhXkg==
X-Received: by 2002:a05:600c:2042:: with SMTP id p2mr1095116wmg.79.1579902097314;
        Fri, 24 Jan 2020 13:41:37 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id f16sm9203055wrm.65.2020.01.24.13.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:41:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] io_uring: move ring_fd  into io_submit_state
Date:   Sat, 25 Jan 2020 00:40:27 +0300
Message-Id: <45c8b99ebc9133588ba8cf265f59c768b87a1f81.1579901866.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579901866.git.asml.silence@gmail.com>
References: <cover.1579901866.git.asml.silence@gmail.com>
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
index c1d905b33b29..951c2fc7b5b7 100644
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

