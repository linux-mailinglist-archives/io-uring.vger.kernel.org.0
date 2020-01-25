Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49AA3149793
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 20:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgAYTyh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 14:54:37 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40329 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbgAYTyh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jan 2020 14:54:37 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so6109640wrn.7;
        Sat, 25 Jan 2020 11:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PlpJ2rMQ/s7zWBn3MwylqW0cx/goxzQVTtQC07xG7b4=;
        b=Zk17fxwU390sltureH3jgs4EfjfDj+Bp7UOCxo97ezeOFDIlgS8zlCP7Y9c5wXhOJD
         Hv6Hd5G2xbxlePhoJQu9P1CmBtHetAJCYdc4y3qgekiFDvN4N7Woynu3Hxa11ZfgRUNB
         DP/RN48HkOrh6jG5DzKvXjV9n0oQ2XyJN6i9mgNtxck9h5t/wh7aRVxWTQVr9E4nVypL
         oZqGmRUtEsZq9YiVo+pZ+i41ctMLib05mAMZs7ZPksf4ej564v5JGCfueBqaWNYnaOy+
         rb0Ecybx+x2Cj7LL1zM1vEX368jCueFAsxFar4Vzu15PNrMX+gTRAZ/5qQPnQXD/C6Aj
         Z+CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PlpJ2rMQ/s7zWBn3MwylqW0cx/goxzQVTtQC07xG7b4=;
        b=bCCDaRzUlnZfiO81Ij9dRUp2DBvUono+uqD3aWqlhpWvJ7hMcYxwhfdEohriGS8DML
         FAI/OAEWtPpReX0fEI8Q49J/BwMzJmjiYbx6xAUi5e5JDU5RlrP5HhFNUfNDF/VMYTH1
         6L6jaXDI7Qcjpkctjsy8GDWpdVwl+OytjLfCNENoSeBQyUshxIk8CsLCLg1om25nam5S
         E+q70LeMxIws2GnigODa85wm63j6miCOGgWu3InocXoYZ0/oVvXdYbyUaraNvZiIVdGU
         GbLVcoPqezgg9nW5+a+6zhKwdGslJhK6AXfESl7wfA+9cCfMVjCw+9Eo5kEiPFhafDML
         RZ4Q==
X-Gm-Message-State: APjAAAWNoLRm2e6SEkfyDQcWP4VFN44VgRoY6m8LeV3njf9w8RlHUdwY
        US4BdNVsCuNofhKblRKPUqU=
X-Google-Smtp-Source: APXvYqzXycK+9RNxLxpbbEiwiUSlNFxTSAcDvw9bC/5wem5UVSccws9kSxMRSPkYPqNwJF1X2jct5g==
X-Received: by 2002:a5d:5704:: with SMTP id a4mr12542535wrv.198.1579982074676;
        Sat, 25 Jan 2020 11:54:34 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id m21sm11883712wmi.27.2020.01.25.11.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 11:54:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/8] io_uring: always pass non-null io_submit_state
Date:   Sat, 25 Jan 2020 22:53:39 +0300
Message-Id: <e1f0f8a488e4cb9f48ea576b3fb5ff57e0eb9173.1579981749.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579981749.git.asml.silence@gmail.com>
References: <cover.1579981749.git.asml.silence@gmail.com>
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
index bc1cab6a256a..f4e7575b511d 100644
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
 
@@ -4910,8 +4899,10 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	}
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

