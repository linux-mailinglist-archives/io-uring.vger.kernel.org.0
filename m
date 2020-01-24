Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA350149049
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgAXVli (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:41:38 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39554 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgAXVlh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:41:37 -0500
Received: by mail-wm1-f65.google.com with SMTP id c84so874139wme.4;
        Fri, 24 Jan 2020 13:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Lg023VI0O3GASl2eju86qzSqs8stL+XkOWB+ZhPjlUU=;
        b=L7tvz/Bn3NrE+8lnN4UxXbyHaeA7MKVUnHsvP2x9G5AzHjP+gZrbQSeTa/QvbPYNkA
         kPF7frc/LMJhnaam5Y9yKbEhUQIU1VO29E13RSm+Ccph8QY701GYpm2fnUI4796At0/e
         0SECSQaungOVZwOdVuLgbN42Y1u51/xPqM9NP6ceg3kfFWHDMcrEI3SGruZjQzu5II0p
         Y38a+OHUcd+/Iy0nnnNKK2tnmLJoJ7yZIIRwDGuUvcX0RbHyCOcEOgJTiRbWaBY/SRoZ
         qEh+AHRdUX+l8VPuJi64JKx8Fh6ygbdaWiIWjdskXyvKsxFFGLmMrl0ckIQGIbz92Q2N
         Xa9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lg023VI0O3GASl2eju86qzSqs8stL+XkOWB+ZhPjlUU=;
        b=rzxbJXjOO4L7eVMsVmLFoJYeTftOd8BCG5SmHDFGbT4TnC18IWXENRtza0uEXgUVil
         HStAO8TFuQdIe1OIpFaNdgwPIaWzXgh/9Mz/qdDnUmBZe0WWIvAP9ozIInjsLEzdQgSl
         OOsiRNbca3A9sQkCvqpDoeSULoK5ZXGTgAsMBqlmtyO2dyI300KnfvSGqCC43jy90EjC
         ocXRQU/yc4WrkPCMSvXDWyFgUbRPFL9bcjlgPpFtqyRP97ZN4Md93hQBTSCYPTUCM/7Y
         21xY7SSlmiYwSp84VmrU2XyMFWEw+zcbUjiFd2x5BXvijDjLuEznmiTdh4FvHkWqSfxf
         EVZw==
X-Gm-Message-State: APjAAAWASAFZdygeyBFR5R/ybwiQsQh0LaQDvNqVyczMpLWwLPwbXzHN
        9NU0lbmVTtgd969oTB9UcRQ=
X-Google-Smtp-Source: APXvYqxHiPkmOsMa97PxmfFPpxQCUkrNHSDaBR0LH3cl14s/uWZxP6M3ChnUJFQRJbnFXJZvceGy0w==
X-Received: by 2002:a7b:cc82:: with SMTP id p2mr1012549wma.159.1579902094810;
        Fri, 24 Jan 2020 13:41:34 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id f16sm9203055wrm.65.2020.01.24.13.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:41:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] io_uring: always pass non-null io_submit_state
Date:   Sat, 25 Jan 2020 00:40:25 +0300
Message-Id: <7780ba2895f42451c76d533855910a9a6740043a.1579901866.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579901866.git.asml.silence@gmail.com>
References: <cover.1579901866.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is more harm than merit from conditionally passing
io_submit_state. Always pass non-null pointer. It shouldn't affect
performance, but even if so the gap will be closed by the following
commits. Also, in prepartion move plugging out of it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c7b38e5f72a1..63a14002e395 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -577,8 +577,6 @@ struct io_kiocb {
 #define IO_IOPOLL_BATCH			8
 
 struct io_submit_state {
-	struct blk_plug		plug;
-
 	/*
 	 * io_kiocb alloc cache
 	 */
@@ -1126,11 +1124,7 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct io_kiocb *req;
 
-	if (!state) {
-		req = kmem_cache_alloc(req_cachep, gfp);
-		if (unlikely(!req))
-			goto fallback;
-	} else if (!state->free_reqs) {
+	if (!state->free_reqs) {
 		size_t sz;
 		int ret;
 
@@ -1771,9 +1765,6 @@ static void io_file_put(struct io_submit_state *state)
  */
 static struct file *io_file_get(struct io_submit_state *state, int fd)
 {
-	if (!state)
-		return fget(fd);
-
 	if (state->file) {
 		if (state->fd == fd) {
 			state->used_refs++;
@@ -4757,7 +4748,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
  */
 static void io_submit_state_end(struct io_submit_state *state)
 {
-	blk_finish_plug(&state->plug);
 	io_file_put(state);
 	if (state->free_reqs)
 		kmem_cache_free_bulk(req_cachep, state->free_reqs,
@@ -4770,7 +4760,6 @@ static void io_submit_state_end(struct io_submit_state *state)
 static void io_submit_state_start(struct io_submit_state *state,
 				  unsigned int max_ios)
 {
-	blk_start_plug(&state->plug);
 	state->free_reqs = 0;
 	state->file = NULL;
 	state->ios_left = max_ios;
@@ -4836,7 +4825,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			  struct file *ring_file, int ring_fd,
 			  struct mm_struct **mm, bool async)
 {
-	struct io_submit_state state, *statep = NULL;
+	struct blk_plug plug;
+	struct io_submit_state state;
 	struct io_kiocb *link = NULL;
 	int i, submitted = 0;
 	bool mm_fault = false;
@@ -4854,10 +4844,9 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 
-	if (nr > IO_PLUG_THRESHOLD) {
-		io_submit_state_start(&state, nr);
-		statep = &state;
-	}
+	io_submit_state_start(&state, nr);
+	if (nr > IO_PLUG_THRESHOLD)
+		blk_start_plug(&plug);
 
 	ctx->ring_fd = ring_fd;
 	ctx->ring_file = ring_file;
@@ -4866,7 +4855,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
 
-		req = io_get_req(ctx, statep);
+		req = io_get_req(ctx, &state);
 		if (unlikely(!req)) {
 			if (!submitted)
 				submitted = -EAGAIN;
@@ -4899,7 +4888,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
-		if (!io_submit_sqe(req, sqe, statep, &link))
+		if (!io_submit_sqe(req, sqe, &state, &link))
 			break;
 	}
 
@@ -4907,8 +4896,10 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		percpu_ref_put_many(&ctx->refs, nr - submitted);
 	if (link)
 		io_queue_link_head(link);
-	if (statep)
-		io_submit_state_end(&state);
+
+	io_submit_state_end(&state);
+	if (nr > IO_PLUG_THRESHOLD)
+		blk_finish_plug(&plug);
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
 	io_commit_sqring(ctx);
-- 
2.24.0

