Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E947A4EB27A
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 19:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240046AbiC2RJg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 13:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240045AbiC2RJf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 13:09:35 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DA8258FFB
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 10:07:51 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id 125so21762237iov.10
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 10:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9t/7+eWvRPGljuzOXJ2IQu4eV32VAZFMTn+Xj/DFHow=;
        b=c8GG5aqbAet5NSKG3mzT5JCqEiI7W6sMgYx8XyGea0TD49V1OjYsYbVYkkpTopE+OA
         ixXnOt28w2b0DggYkNIpbhy9gjD1Ix4/P8AWYyVu3lZRRJOgjwD8lXTrf+/1X5J2laGo
         m4OHOspgPF/qBDP2RpQwsqbb35fo7tb7J16aDzsT2m4ve+GnWx87Fv1XXC+jd5d4Rb42
         r67bjbOl5FMnQz8NuagSZBMAy/5ctVjmSP51wkf9zncC8sI+jLmYOw4tiDUaUbWBitKU
         CXOidKoBILIlmeYdrEjCZuovgNys1FXc34a3BuMgj7fUJh1MT7y0oMGdY+4+YFN7wuJ1
         rRsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9t/7+eWvRPGljuzOXJ2IQu4eV32VAZFMTn+Xj/DFHow=;
        b=eJh6ZM6Md3QarlOkCtT4bRvRzgJ12VNW0rikPfFLtpZ0MzlIsRLMu4ICA7AP7LHUgB
         P2Bs5psSMzmTRVQqGFmzeq1xorGgULFUP4Fgk+Wb4zgp6JEMPh5cuydE9nqBvYHAGh3n
         5er1tdPvxU+zCUVLs1RBGO+J9zuCl0lUP7sKvXQyD4sQGM3RFn9XFjLM8YR3D3nWVHVJ
         q+QyOjvbxUpspMFTMeaOOT7/dFjf77Zrp9B01guwnKJ5qmPEPNemS7ghDqu5tbJFDzvA
         icxqUPf94Y/G/7oTek1bVPztur19A/ck07c1nvEEYSAOjVTZLeH5nmOPy1vIFZ7ZIMZm
         zQYQ==
X-Gm-Message-State: AOAM530TWGemX4llXzRZoZWnkYUYtAAM9xwl5PH+BFj+BtWOLC1twiKA
        h7eNMgoaWI8FREPLXWB1JbkdT8yMmHHDQu6y
X-Google-Smtp-Source: ABdhPJyDDssPO/L1WfaKRXVTWkH5ouB6rqwNRnY1byknhnsbB/1sabdFeLjVyvpiNuWqysG/9P+YIQ==
X-Received: by 2002:a02:cd12:0:b0:321:29bd:b5ae with SMTP id g18-20020a02cd12000000b0032129bdb5aemr16047858jaq.83.1648573670903;
        Tue, 29 Mar 2022 10:07:50 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v3-20020a5d9483000000b00640d3d4acabsm9383069ioj.44.2022.03.29.10.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 10:07:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: defer file assignment for links
Date:   Tue, 29 Mar 2022 11:07:42 -0600
Message-Id: <20220329170742.164434-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220329170742.164434-1-axboe@kernel.dk>
References: <20220329170742.164434-1-axboe@kernel.dk>
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
 fs/io_uring.c | 44 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 52fa0613b442..067ca76651b0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -784,6 +784,7 @@ enum {
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
 	REQ_F_PARTIAL_IO_BIT,
+	REQ_F_DEFERRED_FILE_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -848,6 +849,8 @@ enum {
 	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
 	/* request has already done partial IO */
 	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
+	/* request has file assignment deferred */
+	REQ_F_DEFERRED_FILE	= BIT(REQ_F_DEFERRED_FILE_BIT),
 };
 
 struct async_poll {
@@ -2096,6 +2099,21 @@ static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
 	return __io_fill_cqe(ctx, user_data, res, cflags);
 }
 
+static void io_assign_file(struct io_kiocb *req)
+{
+	if (req->file || !io_op_defs[req->opcode].needs_file)
+		return;
+	if (!(req->flags & REQ_F_DEFERRED_FILE)) {
+		req_set_fail(req);
+		return;
+	}
+	req->flags &= ~REQ_F_DEFERRED_FILE;
+	req->file = io_file_get(req->ctx, req, req->result,
+				req->flags & REQ_F_FIXED_FILE);
+	if (!req->file)
+		req_set_fail(req);
+}
+
 static void __io_req_complete_post(struct io_kiocb *req, s32 res,
 				   u32 cflags)
 {
@@ -2112,6 +2130,7 @@ static void __io_req_complete_post(struct io_kiocb *req, s32 res,
 			if (req->flags & IO_DISARM_MASK)
 				io_disarm_next(req);
 			if (req->link) {
+				io_assign_file(req->link);
 				io_req_task_queue(req->link);
 				req->link = NULL;
 			}
@@ -2423,7 +2442,11 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
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
@@ -2626,6 +2649,10 @@ static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 
 static void io_req_task_queue(struct io_kiocb *req)
 {
+	if (unlikely(req->flags & REQ_F_FAIL)) {
+		io_req_task_queue_fail(req, -ECANCELED);
+		return;
+	}
 	req->io_task_work.func = io_req_task_submit;
 	io_req_task_work_add(req, false);
 }
@@ -2640,8 +2667,10 @@ static inline void io_queue_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = io_req_find_next(req);
 
-	if (nxt)
+	if (nxt) {
+		io_assign_file(req);
 		io_req_task_queue(nxt);
+	}
 }
 
 static void io_free_req(struct io_kiocb *req)
@@ -7722,6 +7751,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	if (io_op_defs[opcode].needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
+		int fd = READ_ONCE(sqe->fd);
 
 		/*
 		 * Plug now if we have more than 2 IO left after this, and the
@@ -7733,10 +7763,14 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			blk_start_plug_nr_ios(&state->plug, state->submit_nr);
 		}
 
-		req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
+		req->file = io_file_get(ctx, req, fd,
 					(sqe_flags & IOSQE_FIXED_FILE));
-		if (unlikely(!req->file))
-			return -EBADF;
+		if (unlikely(!req->file)) {
+			if (!ctx->submit_state.link.head)
+				return -EBADF;
+			req->result = fd;
+			req->flags |= REQ_F_DEFERRED_FILE;
+		}
 	}
 
 	personality = READ_ONCE(sqe->personality);
-- 
2.35.1

