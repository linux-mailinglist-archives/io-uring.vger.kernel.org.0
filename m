Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C250A14979E
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 20:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgAYTyo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 14:54:44 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52543 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAYTyi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jan 2020 14:54:38 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so2763058wmc.2;
        Sat, 25 Jan 2020 11:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=afm40SxQCvyNrOjxhYG3z32ewLGMIWuq2Am+TDiG8oM=;
        b=rjetypRx0Yc7jvFgmOygqi1BSFNIzJ5IHF73iPpCofNL7E67Ozsd6oRhbqUuzdERb4
         BYdzorXyAv9jw4oLLKoIQ/957MxVEzFza70f0nqVwFs5P/YUBtUjqv+m1jw2YQSi6PVR
         I+rhIJ3FefIGYrKRmN/FvSGBwM3dPJTfu2uViyUFI0LY5kZfTV5G/wuJhBG12OyA/1cz
         Na/AIT8p88f6kCE46TRdBPraClZJGOCPu3JhBHl1fIGufRwC3L1ROEclF5hf5SGKBUPI
         Kmh0GgFVRb3fAUGOvy0Ukapwyqb4HAMK7I2e0OHRBclYYufeFMLAUYkBYI/yK4mkFGVK
         6SrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=afm40SxQCvyNrOjxhYG3z32ewLGMIWuq2Am+TDiG8oM=;
        b=M4g/Isy+ZQ2Y/9aCO25jZ6Lgr6alLK9leO+kNr2OVFLcvCA8uRR9/Dql8rBE029pOY
         cc3JqQEt7wKjnNOKodddDC5hczRYjVqIsmurIgPeDdD7oYoGDKzI6ZxcwCeOEWll6Oxi
         8PJBsl3e+Jv8MpgWSPg5z3lxRr3mnAn8FneQRuw5P4IGIgDHmGc6nQ89GRxTrC06qcAx
         GJCCEybI1DF+i9eGhJguZimonu6KJJ6ZtFJ8xbrXaxueNXFIWXngVv4oQzyzloX01L9v
         1nJ+IV6QtuL1XR7hs0d5EPsp3fqXmcL3v0yIlZlEOKx7PUL33qtjNzbEZESYlIUdBBks
         m90g==
X-Gm-Message-State: APjAAAU49jJFjQRJ58DGDD/t+kJMbzJMsCXV0QLn4zmPytNb7+DWIVZI
        6UK2LYZxb1cTWYyLUGmFCNk=
X-Google-Smtp-Source: APXvYqwqR2u73Lv0FVZCCFeEKTn/juoezb71mWWoFTGPf2FOz6xRADDlvWBouJqsyPsX0WwaDrg4ng==
X-Received: by 2002:a1c:5419:: with SMTP id i25mr5508410wmb.150.1579982076652;
        Sat, 25 Jan 2020 11:54:36 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id m21sm11883712wmi.27.2020.01.25.11.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 11:54:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/8] io_uring: place io_submit_state into ctx
Date:   Sat, 25 Jan 2020 22:53:40 +0300
Message-Id: <d4b705af71f076a9cf845aa3fc06d6f9866f84f8.1579981749.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579981749.git.asml.silence@gmail.com>
References: <cover.1579981749.git.asml.silence@gmail.com>
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
index f4e7575b511d..8b159e21a35f 100644
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
 
@@ -4900,7 +4905,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	if (link)
 		io_queue_link_head(link);
 
-	io_submit_state_end(&state);
+	io_submit_end(ctx);
 	if (nr > IO_PLUG_THRESHOLD)
 		blk_finish_plug(&plug);
 
-- 
2.24.0

