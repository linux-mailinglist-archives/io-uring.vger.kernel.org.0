Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D325114F467
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 23:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgAaWQw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 17:16:52 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50226 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgAaWQt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 17:16:49 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so9717218wmb.0;
        Fri, 31 Jan 2020 14:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5F9CdvEzjBEYxehOIHhGkFYwSM3N/fEo9anOW0Qd16o=;
        b=aAdSqMnfr0A9F7i2JpX+3v339dXfftxx2mkAKtx2SOQmL9nemQ2mNXd6xbwLG2zQgH
         aL8PQeoiaeTOebrRZrLGw1rXpl0Zq0fmWhTwCYcTA+EGfYgNg7RLBr0aB8x3Qsjy66sL
         CYAMsAv5vnjnUdJRvi3J03zlIlv37hxO94m8CnHKuqfSDyGaVDDd5mWeFpM+lgfC9KtV
         /yaD2R9eYHZwd5s1YgkndzvA8hhORlaQiRWEmPqMgt+o5ex/lTcUi87inhav89MVXySN
         x1OaWtGwyFTTNxUMwygj+/kHsF5M01Pxy9kfYZKS1q6ruZszaNt0X/PjVy87zWiZLq7R
         XUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5F9CdvEzjBEYxehOIHhGkFYwSM3N/fEo9anOW0Qd16o=;
        b=rUdrkWQS9MNJodPEMn4ncUa9153nObBvsymVzS6gM60QqViJUX9wJJ6/tRGR7P55EP
         FMSyV/hoQyy28mOUzeu6axjLj2mwgNYuSq/MREp6wblADMKFGU+avuVdkwoRTEHVoKro
         L1KERlTLhsbegjFOJihWaGe+7bs5SytC00mWCZ2IPQMA1S57GdQnZhoKz1YwiLMrpCaV
         iPpHMDKWI6RdcKV/d4dveb8g36A2E0+zhKDj76Y6fXRBCr7gbo/z0vMK+/7E2668AY+s
         h6eqf7b6wxQ0vF0zy5UP8xTD8ydctSK2wBzSsYnUd6e4Uvs++chATzSbvXTC3yxXiWnV
         u+jw==
X-Gm-Message-State: APjAAAWHtO+5BLbfXYoeMxAw7/6zkiB5XjhwoIwijS2bxVp3xNg6PvLC
        ezOvjYAxkfjtupB6XGd+1kW5/zn9
X-Google-Smtp-Source: APXvYqz030z3C1Bv7yL5KfLZ3ZwOTLlUU9sT9n5biucHRUT7UNuCIfrGcMox2fdJ3sxvOxmHyYIcxw==
X-Received: by 2002:a1c:7205:: with SMTP id n5mr14789930wmc.9.1580509006584;
        Fri, 31 Jan 2020 14:16:46 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id e6sm12328001wme.3.2020.01.31.14.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 14:16:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/6] io_uring: place io_submit_state into ctx
Date:   Sat,  1 Feb 2020 01:15:51 +0300
Message-Id: <fe5b88db210d7925308b42bd67ebf0efa269d378.1580508735.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1580508735.git.asml.silence@gmail.com>
References: <cover.1580508735.git.asml.silence@gmail.com>
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
index 6f3998e6475a..6109969709ff 100644
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
@@ -310,6 +331,9 @@ struct io_ring_ctx {
 		spinlock_t		inflight_lock;
 		struct list_head	inflight_list;
 	} ____cacheline_aligned_in_smp;
+
+	/* protected by uring_lock */
+	struct io_submit_state		submit_state;
 };
 
 /*
@@ -575,27 +599,6 @@ struct io_kiocb {
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
@@ -1158,11 +1161,11 @@ static struct io_kiocb *io_get_fallback_req(struct io_ring_ctx *ctx)
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
@@ -4475,10 +4478,10 @@ static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
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
 
@@ -4717,7 +4720,7 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
 static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			  struct io_submit_state *state, struct io_kiocb **link)
+			  struct io_kiocb **link)
 {
 	const struct cred *old_creds = NULL;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -4748,7 +4751,7 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	req->flags |= sqe_flags & (IOSQE_IO_DRAIN|IOSQE_IO_HARDLINK|
 					IOSQE_ASYNC);
 
-	ret = io_req_set_file(state, req, sqe);
+	ret = io_req_set_file(req, sqe);
 	if (unlikely(ret)) {
 err_req:
 		io_cqring_add_event(req, ret);
@@ -4823,8 +4826,10 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -4834,9 +4839,10 @@ static void io_submit_state_end(struct io_submit_state *state)
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
@@ -4903,7 +4909,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			  struct mm_struct **mm, bool async)
 {
 	struct blk_plug plug;
-	struct io_submit_state state;
 	struct io_kiocb *link = NULL;
 	int i, submitted = 0;
 	bool mm_fault = false;
@@ -4921,7 +4926,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 
-	io_submit_state_start(&state, nr);
+	io_submit_start(ctx, nr);
 	if (nr > IO_PLUG_THRESHOLD)
 		blk_start_plug(&plug);
 
@@ -4932,7 +4937,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
 
-		req = io_get_req(ctx, &state);
+		req = io_get_req(ctx);
 		if (unlikely(!req)) {
 			if (!submitted)
 				submitted = -EAGAIN;
@@ -4965,7 +4970,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
-		if (!io_submit_sqe(req, sqe, &state, &link))
+		if (!io_submit_sqe(req, sqe, &link))
 			break;
 	}
 
@@ -4977,7 +4982,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	if (link)
 		io_queue_link_head(link);
 
-	io_submit_state_end(&state);
+	io_submit_end(ctx);
 	if (nr > IO_PLUG_THRESHOLD)
 		blk_finish_plug(&plug);
 
-- 
2.24.0

