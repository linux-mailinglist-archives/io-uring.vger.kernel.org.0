Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA86315AED
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhBJASx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbhBJAJI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:09:08 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C19C06178A
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:20 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id 7so457139wrz.0
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=epcps8D7ZX9Xmzrvprk1RMDToN6x1bSA/4526R/MfbM=;
        b=ItaFU2MOh3hpUIoLNmhXhwkiHzyi83bOdB0yZJUg7VvPM3tsk3yArRdYb1RMmdKTXB
         1YMK5mNvBiJRzYb40kf0jbnLfq+0efj/FCUi0L+/QB4cc3nXKWqUHE9K7BY+XZwDKgps
         0yqrTLdz/PFu3ZEkQEI1SdLoOphIGr66LGppHf5mtTz5e+GPPraO54ccrDvPe97dj+Cm
         Tu5uO52UwMQctud7Fpc/dUW6cU5jg2xYjk4JhhH7nqDZL8wGyOO9buZAzcq+vaq0SlfB
         sg9bdFmYkoQrpK00VV+j5ljOVNo9ulkbDpnf+R1ksz8wKxwHXRzZsyogBfoKy5GDRVtn
         0jSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=epcps8D7ZX9Xmzrvprk1RMDToN6x1bSA/4526R/MfbM=;
        b=Or2E7eGfZhQWgwfgc3i31OZxun3znfGDbl07v+qsfBoBNgmYXGSYZ+plJ9gdpaKmcV
         qFtoot+wBiT/ILU13q24e5HKvo6MTj7XoKrssOyd99hB2+Jr5VzSORC12j8aIuzYcqEs
         zi4mRALGqKO8qt+Mi46DWXZTI3QDFte0d7tfxvOMnd9IV91GhmW6Z2/uIzooVQa1fVT0
         NvrewxWkibBpPGbbUMYwVCwLHkcZjZ08NRUA3W2bw4o0zYa0N42V1eLU74QUGHVTscbO
         rgaz/x+klIKwqq6wuckmlL6ovKgAhvXGfst3BLqBiskLaZ65qeXwE76lLcVtjHm4N+4n
         14DA==
X-Gm-Message-State: AOAM533rE6/H1IkrWXO539ghC2jCzcNslBx8ioM3O3b73aIlQvl6991H
        8P9QOUxOP1BhDJr+J2qf3Fo=
X-Google-Smtp-Source: ABdhPJzFoD7Uws1I0egyTwcrTt0e2iAS4e+8ga6oPhTHmXSJ8OjbZYGbG5HobtR9HEUykxEVRG1oLw==
X-Received: by 2002:a5d:58c2:: with SMTP id o2mr543996wrf.141.1612915638871;
        Tue, 09 Feb 2021 16:07:18 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:18 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/17] io_uring: don't keep submit_state on stack
Date:   Wed, 10 Feb 2021 00:03:10 +0000
Message-Id: <fd53edc6ff6568588f1f45e54cb558960bf6a6a1.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

struct io_submit_state is quite big (168 bytes) and going to grow. It's
better to not keep it on stack as it is now. Move it to context, it's
always protected by uring_lock, so it's fine to have only one instance
of it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 90 ++++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 44 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5b95a3f2b978..0606fa5f9eb0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -264,6 +264,39 @@ struct io_sq_data {
 	unsigned		sq_thread_idle;
 };
 
+#define IO_IOPOLL_BATCH			8
+
+struct io_comp_state {
+	unsigned int		nr;
+	struct list_head	list;
+	struct io_ring_ctx	*ctx;
+};
+
+struct io_submit_state {
+	struct blk_plug		plug;
+
+	/*
+	 * io_kiocb alloc cache
+	 */
+	void			*reqs[IO_IOPOLL_BATCH];
+	unsigned int		free_reqs;
+
+	bool			plug_started;
+
+	/*
+	 * Batch completion logic
+	 */
+	struct io_comp_state	comp;
+
+	/*
+	 * File reference cache
+	 */
+	struct file		*file;
+	unsigned int		fd;
+	unsigned int		file_refs;
+	unsigned int		ios_left;
+};
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -406,6 +439,7 @@ struct io_ring_ctx {
 
 	struct work_struct		exit_work;
 	struct io_restriction		restrictions;
+	struct io_submit_state		submit_state;
 };
 
 /*
@@ -758,39 +792,6 @@ struct io_defer_entry {
 	u32			seq;
 };
 
-#define IO_IOPOLL_BATCH			8
-
-struct io_comp_state {
-	unsigned int		nr;
-	struct list_head	list;
-	struct io_ring_ctx	*ctx;
-};
-
-struct io_submit_state {
-	struct blk_plug		plug;
-
-	/*
-	 * io_kiocb alloc cache
-	 */
-	void			*reqs[IO_IOPOLL_BATCH];
-	unsigned int		free_reqs;
-
-	bool			plug_started;
-
-	/*
-	 * Batch completion logic
-	 */
-	struct io_comp_state	comp;
-
-	/*
-	 * File reference cache
-	 */
-	struct file		*file;
-	unsigned int		fd;
-	unsigned int		file_refs;
-	unsigned int		ios_left;
-};
-
 struct io_op_def {
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
@@ -1997,9 +1998,10 @@ static struct io_kiocb *io_get_fallback_req(struct io_ring_ctx *ctx)
 	return NULL;
 }
 
-static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
-				     struct io_submit_state *state)
+static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 {
+	struct io_submit_state *state = &ctx->submit_state;
+
 	if (!state->free_reqs) {
 		gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 		size_t sz;
@@ -6764,9 +6766,9 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 				IOSQE_BUFFER_SELECT)
 
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
-		       const struct io_uring_sqe *sqe,
-		       struct io_submit_state *state)
+		       const struct io_uring_sqe *sqe)
 {
+	struct io_submit_state *state;
 	unsigned int sqe_flags;
 	int id, ret;
 
@@ -6818,6 +6820,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags |= sqe_flags;
+	state = &ctx->submit_state;
 
 	/*
 	 * Plug now if we have more than 1 IO left after this, and the target
@@ -6844,7 +6847,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 {
-	struct io_submit_state state;
 	struct io_submit_link link;
 	int i, submitted = 0;
 
@@ -6863,7 +6865,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	percpu_counter_add(&current->io_uring->inflight, nr);
 	refcount_add(nr, &current->usage);
 
-	io_submit_state_start(&state, ctx, nr);
+	io_submit_state_start(&ctx->submit_state, ctx, nr);
 	link.head = NULL;
 
 	for (i = 0; i < nr; i++) {
@@ -6876,7 +6878,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 			io_consume_sqe(ctx);
 			break;
 		}
-		req = io_alloc_req(ctx, &state);
+		req = io_alloc_req(ctx);
 		if (unlikely(!req)) {
 			if (!submitted)
 				submitted = -EAGAIN;
@@ -6886,7 +6888,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		/* will complete beyond this point, count as submitted */
 		submitted++;
 
-		err = io_init_req(ctx, req, sqe, &state);
+		err = io_init_req(ctx, req, sqe);
 		if (unlikely(err)) {
 fail_req:
 			io_put_req(req);
@@ -6896,7 +6898,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 					true, ctx->flags & IORING_SETUP_SQPOLL);
-		err = io_submit_sqe(req, sqe, &link, &state.comp);
+		err = io_submit_sqe(req, sqe, &link, &ctx->submit_state.comp);
 		if (err)
 			goto fail_req;
 	}
@@ -6911,8 +6913,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		put_task_struct_many(current, unused);
 	}
 	if (link.head)
-		io_queue_link_head(link.head, &state.comp);
-	io_submit_state_end(&state);
+		io_queue_link_head(link.head, &ctx->submit_state.comp);
+	io_submit_state_end(&ctx->submit_state);
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
 	io_commit_sqring(ctx);
-- 
2.24.0

