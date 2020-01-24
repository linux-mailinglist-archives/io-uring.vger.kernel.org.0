Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 798A1149057
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbgAXVlj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:41:39 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36506 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbgAXVli (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:41:38 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so886952wma.1;
        Fri, 24 Jan 2020 13:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XYLYywIIbQRgww0cL3Bd1Q+9CNBhTIhFWg4JoxsXZ/k=;
        b=OpOrTZ3igrj0Zzj9m6Lcv/oddzH7DzWIw8rWc6hYxwEy7r84F6ykIxnxFpJ+RsMji2
         ACvfpRSLhBER2aHb1tiBxtP1k7Tcdm5caAbd1gGwdUGsUXblKw+k4WQ1QDHK62b4h5mo
         T6/RgA4PlEpiRCoGKD6JFcE1t+rqTz57/s0dYWJ3wnyKHlxWyN0yIXMKe4S83Pt3j7PV
         kORK5BcE7epx9fnXvacGxU5olPHGDth0cxrro0QSGGR6E5NFkZd3Bkl+Xn9KO9XBqmhX
         G40xe0SV9pjPbWeo3DmDLb7osuYul7XL2rR9DTxlM4YzXKfGwwDr5veDstKyWbjvcLqE
         SA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XYLYywIIbQRgww0cL3Bd1Q+9CNBhTIhFWg4JoxsXZ/k=;
        b=fyG5h0odTZ4N0bmmWTiZRT3+7oW9lJyW/GEhzgp2bNseH1DlNYhx39FQLgcT34L/pK
         Mqpt9Mijaj0aUQ1DzKu5tqrS8Bpgn6dHEr3QXu3eIPaI9PVMbyHb55VLkWTkX9qo2JKy
         r6aCF+tcbxwwXqfYEGQ/HqOg02LJbJin11NgMCaeWUU+Ccz9+wbaU4wrNgPObIq/nFAG
         eSLTLhu7PIV99Ca6x8t9SK4h3w3qeuKJlIsQTMGPoHjCPWL3SQ6vlSquVwvFHFgpPPf/
         VpftiLOOt5f+txtunBhQfelJf8k4xOPwm16wzoZJoV3IOGN1KKSzK52NM7Ea7TZL7aCr
         nPIg==
X-Gm-Message-State: APjAAAX2sYSgLMs8f7ha5TlR9sG6UmBVNJE4hM4btcSucxRDvqLzw1pP
        YLrDTCCxCoLdSWVMVBP2mEU=
X-Google-Smtp-Source: APXvYqwn3I+3Zigt4IOVGd55EWwIRV9sXsW6+Q95Gj2DibN9AKsh283HuYNDn268lVf5yC6Ik4wxBw==
X-Received: by 2002:a7b:cc69:: with SMTP id n9mr1048966wmj.164.1579902096114;
        Fri, 24 Jan 2020 13:41:36 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id f16sm9203055wrm.65.2020.01.24.13.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:41:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] io_uring: place io_submit_state into ctx
Date:   Sat, 25 Jan 2020 00:40:26 +0300
Message-Id: <95b6b6c4a8db82446156f2eb2627114de21417cb.1579901866.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579901866.git.asml.silence@gmail.com>
References: <cover.1579901866.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_submit_state is used only during submmission and holding
ctx->uring_lock, so only one instance is used at a time. Move it into
struct io_ring_ctx, so it:
- doesn't consume on-stack memory
- persists across io_uring_enter
- available without passing it through the call-stack

The last point is very useful to make opcode handlers manage their
resources themselfs, like splice would. Also, it's a base for other
hackish optimisations in the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 75 +++++++++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 35 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 63a14002e395..c1d905b33b29 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -197,6 +197,27 @@ struct fixed_file_data {
 	struct completion		done;
 };
 
+#define IO_PLUG_THRESHOLD		2
+#define IO_IOPOLL_BATCH			8
+
+struct io_submit_state {
+	/*
+	 * io_kiocb alloc cache
+	 */
+	void			*reqs[IO_IOPOLL_BATCH];
+	unsigned int		free_reqs;
+	unsigned int		cur_req;
+
+	/*
+	 * File reference cache
+	 */
+	struct file		*file;
+	unsigned int		fd;
+	unsigned int		has_refs;
+	unsigned int		used_refs;
+	unsigned int		ios_left;
+};
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -308,6 +329,9 @@ struct io_ring_ctx {
 		spinlock_t		inflight_lock;
 		struct list_head	inflight_list;
 	} ____cacheline_aligned_in_smp;
+
+	/* protected by uring_lock */
+	struct io_submit_state		submit_state;
 };
 
 /*
@@ -573,27 +597,6 @@ struct io_kiocb {
 	struct io_wq_work	work;
 };
 
-#define IO_PLUG_THRESHOLD		2
-#define IO_IOPOLL_BATCH			8
-
-struct io_submit_state {
-	/*
-	 * io_kiocb alloc cache
-	 */
-	void			*reqs[IO_IOPOLL_BATCH];
-	unsigned		int free_reqs;
-	unsigned		int cur_req;
-
-	/*
-	 * File reference cache
-	 */
-	struct file		*file;
-	unsigned int		fd;
-	unsigned int		has_refs;
-	unsigned int		used_refs;
-	unsigned int		ios_left;
-};
-
 struct io_op_def {
 	/* needs req->io allocated for deferral/async */
 	unsigned		async_ctx : 1;
@@ -1118,11 +1121,11 @@ static struct io_kiocb *io_get_fallback_req(struct io_ring_ctx *ctx)
 	return NULL;
 }
 
-static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
-				   struct io_submit_state *state)
+static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx)
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct io_kiocb *req;
+	struct io_submit_state *state = &ctx->submit_state;
 
 	if (!state->free_reqs) {
 		size_t sz;
@@ -4418,10 +4421,10 @@ static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 	return table->files[index & IORING_FILE_TABLE_MASK];;
 }
 
-static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
-			   const struct io_uring_sqe *sqe)
+static int io_req_set_file(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_submit_state *state = &ctx->submit_state;
 	unsigned flags;
 	int fd;
 
@@ -4658,7 +4661,7 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
 static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			  struct io_submit_state *state, struct io_kiocb **link)
+			  struct io_kiocb **link)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned int sqe_flags;
@@ -4675,7 +4678,7 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	req->flags |= sqe_flags & (IOSQE_IO_DRAIN|IOSQE_IO_HARDLINK|
 					IOSQE_ASYNC);
 
-	ret = io_req_set_file(state, req, sqe);
+	ret = io_req_set_file(req, sqe);
 	if (unlikely(ret)) {
 err_req:
 		io_cqring_add_event(req, ret);
@@ -4746,8 +4749,10 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 /*
  * Batched submission is done, ensure local IO is flushed out.
  */
-static void io_submit_state_end(struct io_submit_state *state)
+static void io_submit_end(struct io_ring_ctx *ctx)
 {
+	struct io_submit_state *state = &ctx->submit_state;
+
 	io_file_put(state);
 	if (state->free_reqs)
 		kmem_cache_free_bulk(req_cachep, state->free_reqs,
@@ -4757,9 +4762,10 @@ static void io_submit_state_end(struct io_submit_state *state)
 /*
  * Start submission side cache.
  */
-static void io_submit_state_start(struct io_submit_state *state,
-				  unsigned int max_ios)
+static void io_submit_start(struct io_ring_ctx *ctx, unsigned int max_ios)
 {
+	struct io_submit_state *state = &ctx->submit_state;
+
 	state->free_reqs = 0;
 	state->file = NULL;
 	state->ios_left = max_ios;
@@ -4826,7 +4832,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			  struct mm_struct **mm, bool async)
 {
 	struct blk_plug plug;
-	struct io_submit_state state;
 	struct io_kiocb *link = NULL;
 	int i, submitted = 0;
 	bool mm_fault = false;
@@ -4844,7 +4849,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 
-	io_submit_state_start(&state, nr);
+	io_submit_start(ctx, nr);
 	if (nr > IO_PLUG_THRESHOLD)
 		blk_start_plug(&plug);
 
@@ -4855,7 +4860,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
 
-		req = io_get_req(ctx, &state);
+		req = io_get_req(ctx);
 		if (unlikely(!req)) {
 			if (!submitted)
 				submitted = -EAGAIN;
@@ -4888,7 +4893,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
-		if (!io_submit_sqe(req, sqe, &state, &link))
+		if (!io_submit_sqe(req, sqe, &link))
 			break;
 	}
 
@@ -4897,7 +4902,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	if (link)
 		io_queue_link_head(link);
 
-	io_submit_state_end(&state);
+	io_submit_end(ctx);
 	if (nr > IO_PLUG_THRESHOLD)
 		blk_finish_plug(&plug);
 
-- 
2.24.0

