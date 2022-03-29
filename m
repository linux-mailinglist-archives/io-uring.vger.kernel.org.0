Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE8E4EB485
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 22:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiC2UQF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 16:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiC2UQE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 16:16:04 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107F4E728D
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 13:14:20 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id q11so22368390iod.6
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 13:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=djxUT2v7ltV7jKEf5L7sjNav8Q2guiyvVvLHOonszaM=;
        b=YH0eSF9iFrxE10wPZt9lixaqGWuwVZz8iD8Y/KAWvKmdZ9ZulzyQyRDJXvLptblF0R
         dnbIGzCyS83vFe9RAzrG2+zY8ev5/jKnBERWd9DaaJnAUuP9/wPeGm4Kt5Tf2z9rRqLd
         MX0yhtzfVnqugT97y/2ZMIX2DFAFTPDbpaFfGuFgTILH28U2fTJTIaabn+9McS/GTRpt
         Df6ytpYLEp69Gbh5cm0QhxHlbnLzsb/LXkm9OJginJt/YSOQbn5haP5Y236QXKvJChL1
         Upvy3ZXrhybuUrAVXdiW/6I/40RAAiQtokVf+a04Uzmzj6fYRBX/+UP++PyBOAiAeqYw
         Q2Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=djxUT2v7ltV7jKEf5L7sjNav8Q2guiyvVvLHOonszaM=;
        b=0u7NDYpdI4G4Sn4l8Zk4nuJO2Hxyd8vvqC2wMpfXs9fVSIXFKBp8s7Qb5yjT5Q/LO2
         faUV/i6i4TKhgdFI0F5L/PAhgzZQrmQ6xkqyr3OqrVELkr0bz/niF7qyhG0UqmBfjiq2
         d4MdM0dIp9cUf9H+SDIbANUKsAOLhJxNSdSk8s5CpoMN339I1pNi7kVTCQ+/eINsQpe2
         EMNWIkhVB+el/K/RskTwgo/DhEX1Ep4IoDLtFPgBuuyGA3tr+TMMDxHeNRrUNs8cJkGh
         j+sa0XsuMEzNUFdpV6i3c2b9C8+Dyb3OaAlaXt3b0QHMqm1jOwJRp/gocOwOYF5siY9s
         Zs9w==
X-Gm-Message-State: AOAM531YDW1Y7a8+EXy2V0son+l1laPWXRKpPZNiY9BiyLQlNJR+lQlM
        k5EkGT+RJtUtrlZvXHjnpxnutfxFZDhZIUJa
X-Google-Smtp-Source: ABdhPJyX5vuhzM3r7uoRXPyN5xkly2NHco7YhOToStzzIgtZisG+wO+wpdSRodkjGZDPSbnjsIuj9w==
X-Received: by 2002:a05:6638:1455:b0:323:6814:5095 with SMTP id l21-20020a056638145500b0032368145095mr6850833jad.62.1648584859210;
        Tue, 29 Mar 2022 13:14:19 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v3-20020a5d9483000000b00640d3d4acabsm9606316ioj.44.2022.03.29.13.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 13:14:18 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: defer file assignment for links
Date:   Tue, 29 Mar 2022 14:14:13 -0600
Message-Id: <20220329201413.73871-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220329201413.73871-1-axboe@kernel.dk>
References: <20220329201413.73871-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If an application uses direct open or accept, it knows in advance what
direct descriptor value it will get as it picks it itself. This allows
combined requests such as:

sqe = io_uring_get_sqe(ring);
io_uring_prep_openat_direct(sqe, ..., file_slot);
sqe->flags |= IOSQE_IO_LINK | IOSQE_CQE_SKIP_SUCCESS;

sqe = io_uring_get_sqe(ring);
io_uring_prep_read(sqe,file_slot, buf, buf_size, 0);
sqe->flags |= IOSQE_FIXED_FILE;

io_uring_submit(ring);

where we prepare both a file open and read, and only get a completion
event for the read when both have completed successfully.

Currently links are fully prepared before the head is issued, but that
fails if the dependent link needs a file assigned that isn't valid until
the head has completed.

Allow deferral of file setup, which makes this documented case work.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 59 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2bd7b83045bc..5af0ed9e3581 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -785,6 +785,7 @@ enum {
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
 	REQ_F_PARTIAL_IO_BIT,
+	REQ_F_DEFERRED_FILE_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -849,6 +850,8 @@ enum {
 	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
 	/* request has already done partial IO */
 	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
+	/* request has file assignment deferred */
+	REQ_F_DEFERRED_FILE	= BIT(REQ_F_DEFERRED_FILE_BIT),
 };
 
 struct async_poll {
@@ -1764,6 +1767,20 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 	}
 }
 
+static void io_assign_file(struct io_kiocb *req)
+{
+	if (req->file || !io_op_defs[req->opcode].needs_file)
+		return;
+	if (req->flags & REQ_F_DEFERRED_FILE) {
+		req->flags &= ~REQ_F_DEFERRED_FILE;
+		req->file = io_file_get(req->ctx, req, req->result,
+					req->flags & REQ_F_FIXED_FILE);
+		req->result = 0;
+	}
+	if (unlikely(!req->file))
+		req_set_fail(req);
+}
+
 static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
 {
 	while (!list_empty(&ctx->defer_list)) {
@@ -1773,6 +1790,7 @@ static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
 		if (req_need_defer(de->req, de->seq))
 			break;
 		list_del_init(&de->list);
+		io_assign_file(de->req);
 		io_req_task_queue(de->req);
 		kfree(de);
 	}
@@ -2113,6 +2131,7 @@ static void __io_req_complete_post(struct io_kiocb *req, s32 res,
 			if (req->flags & IO_DISARM_MASK)
 				io_disarm_next(req);
 			if (req->link) {
+				io_assign_file(req->link);
 				io_req_task_queue(req->link);
 				req->link = NULL;
 			}
@@ -2424,7 +2443,11 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 		__io_req_find_next_prep(req);
 	nxt = req->link;
 	req->link = NULL;
-	return nxt;
+	if (nxt) {
+		io_assign_file(nxt);
+		return nxt;
+	}
+	return NULL;
 }
 
 static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
@@ -2627,6 +2650,10 @@ static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 
 static void io_req_task_queue(struct io_kiocb *req)
 {
+	if (unlikely(req->flags & REQ_F_FAIL)) {
+		io_req_task_queue_fail(req, -ECANCELED);
+		return;
+	}
 	req->io_task_work.func = io_req_task_submit;
 	io_req_task_work_add(req, false);
 }
@@ -2641,8 +2668,10 @@ static inline void io_queue_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = io_req_find_next(req);
 
-	if (nxt)
+	if (nxt) {
+		io_assign_file(req);
 		io_req_task_queue(nxt);
+	}
 }
 
 static void io_free_req(struct io_kiocb *req)
@@ -7107,6 +7136,7 @@ static __cold void io_drain_req(struct io_kiocb *req)
 		spin_unlock(&ctx->completion_lock);
 queue:
 		ctx->drain_active = false;
+		io_assign_file(req);
 		io_req_task_queue(req);
 		return;
 	}
@@ -7365,10 +7395,11 @@ static struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 static void io_wq_submit_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	const struct io_op_def *def = &io_op_defs[req->opcode];
 	unsigned int issue_flags = IO_URING_F_UNLOCKED;
 	bool needs_poll = false;
 	struct io_kiocb *timeout;
-	int ret = 0;
+	int ret = 0, err = -ECANCELED;
 
 	/* one will be dropped by ->io_free_work() after returning to io-wq */
 	if (!(req->flags & REQ_F_REFCOUNT))
@@ -7380,14 +7411,19 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
+	io_assign_file(req);
+	if (unlikely(!req->file && def->needs_file)) {
+		work->flags |= IO_WQ_WORK_CANCEL;
+		err = -EBADF;
+	}
+
 	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (work->flags & IO_WQ_WORK_CANCEL) {
-		io_req_task_queue_fail(req, -ECANCELED);
+		io_req_task_queue_fail(req, err);
 		return;
 	}
 
 	if (req->flags & REQ_F_FORCE_ASYNC) {
-		const struct io_op_def *def = &io_op_defs[req->opcode];
 		bool opcode_poll = def->pollin || def->pollout;
 
 		if (opcode_poll && file_can_poll(req->file)) {
@@ -7722,6 +7758,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	if (io_op_defs[opcode].needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
+		int fd = READ_ONCE(sqe->fd);
 
 		/*
 		 * Plug now if we have more than 2 IO left after this, and the
@@ -7733,10 +7770,16 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			blk_start_plug_nr_ios(&state->plug, state->submit_nr);
 		}
 
-		req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
+		req->file = io_file_get(ctx, req, fd,
 					(sqe_flags & IOSQE_FIXED_FILE));
-		if (unlikely(!req->file))
-			return -EBADF;
+		if (unlikely(!req->file)) {
+			/* unless being deferred, error is final */
+			if (!(ctx->submit_state.link.head ||
+			     (sqe_flags & IOSQE_IO_DRAIN)))
+				return -EBADF;
+			req->result = fd;
+			req->flags |= REQ_F_DEFERRED_FILE;
+		}
 	}
 
 	personality = READ_ONCE(sqe->personality);
-- 
2.35.1

