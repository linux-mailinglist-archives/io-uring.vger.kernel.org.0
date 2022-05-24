Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BEA533302
	for <lists+io-uring@lfdr.de>; Tue, 24 May 2022 23:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241932AbiEXVhh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 May 2022 17:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241010AbiEXVhg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 May 2022 17:37:36 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB01D7C173
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 14:37:35 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id bo5so17557297pfb.4
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 14:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eigsg0jgxPfxJrEoqU9bXe0cm4Colyzl4UklgE5fKRM=;
        b=0boopjExMrbEH3gBHjkRNj1H7hXrqdeBZ0t7li+Z4NdoGmG4eQufovz40fLE4a5Tx8
         b2zLpm59Nceigu2duVrbpmL6n1BSOM390eAUZMcTN4HmlwAr04P7XXIwgeQH9yqYfEEG
         I/sP/IwmJod2BnSMx8zO6rDHgkPm9Awc9uVpEGDm8vVHRf0dcOWtyifbKAl43QoJ8JFL
         Ui58MDECuO9A6ag0cxc2BNh36PulObS/IguKNndVgJN4GVzVCuWEN6UgD37hQ+FVr60o
         +EosM3mPbNR5AC9E0Z4Kpo8IJq1OGWcWXlETmUdirMxhOuzlazAoyo0el8vIr4YmXFO1
         +gaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eigsg0jgxPfxJrEoqU9bXe0cm4Colyzl4UklgE5fKRM=;
        b=3SRxgfKt+Qw4RphMImvsNb4YnrAE3LmHyx0Cpf6o5uzFAxgKKXwwtnGp87aJ07+sKH
         grrsDlb6UWWAPxkmb77V5QDpT9iDSBKNiZ8mu2wNERl8PAkAqif1PoRzJMlXjxfgOBn5
         9RDtw5mT1un7CeP3jg7evjBbxlY1cRsQwCsJxjSX2Z62IqQqDzaDxbv6NaFMLNstZgqr
         HdA6zNA9TSkxL7x+8OZYFeVLg9Bn9mAwGU7kP+/wUTBVacEkFWngWLu150iYRG4KeYqd
         cUSLGOxtPSbWJGKL80xoo6tFIhVJAoK0nHc4gIl2R61FunDHmspQo+lBpu2H0DVqtvQp
         5WsQ==
X-Gm-Message-State: AOAM533j4t0110E+Y5aYUxGbX4mChsBFKjNn2OvbxF0IRXsLKp60fWL7
        vWAWc6+sJ6x02OFVzw2cOOBp993M6AnmRg==
X-Google-Smtp-Source: ABdhPJxJve3VKBA1f107/UCrLPyaJFA0A3vT7uL/Ua9vXjYlL69BjXtXlhFK8e1yxKDwTQYN6vq2Zw==
X-Received: by 2002:a05:6a00:1350:b0:518:6df7:7747 with SMTP id k16-20020a056a00135000b005186df77747mr23794894pfu.45.1653428254908;
        Tue, 24 May 2022 14:37:34 -0700 (PDT)
Received: from localhost.localdomain ([2600:380:4a61:523:72ca:65a5:f684:5e4])
        by smtp.gmail.com with ESMTPSA id k21-20020a170902761500b0015e8d4eb1easm7834327pll.52.2022.05.24.14.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 14:37:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring: add io_op_defs 'def' pointer in req init and issue
Date:   Tue, 24 May 2022 15:37:24 -0600
Message-Id: <20220524213727.409630-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524213727.409630-1-axboe@kernel.dk>
References: <20220524213727.409630-1-axboe@kernel.dk>
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

Define and set it when appropriate, and use it consistently in the
function rather than using io_op_defs[opcode].

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 01a96fcdb7c6..d2c99176b11a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8301,6 +8301,7 @@ static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
+	const struct io_op_def *def = &io_op_defs[req->opcode];
 	const struct cred *creds = NULL;
 	int ret;
 
@@ -8310,7 +8311,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
 		creds = override_creds(req->creds);
 
-	if (!io_op_defs[req->opcode].audit_skip)
+	if (!def->audit_skip)
 		audit_uring_entry(req->opcode);
 
 	switch (req->opcode) {
@@ -8449,7 +8450,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		break;
 	}
 
-	if (!io_op_defs[req->opcode].audit_skip)
+	if (!def->audit_skip)
 		audit_uring_exit(!ret, ret);
 
 	if (creds)
@@ -8801,12 +8802,14 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       const struct io_uring_sqe *sqe)
 	__must_hold(&ctx->uring_lock)
 {
+	const struct io_op_def *def;
 	unsigned int sqe_flags;
 	int personality;
 	u8 opcode;
 
 	/* req is partially pre-initialised, see io_preinit_req() */
 	req->opcode = opcode = READ_ONCE(sqe->opcode);
+	def = &io_op_defs[opcode];
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags = sqe_flags = READ_ONCE(sqe->flags);
 	req->cqe.user_data = READ_ONCE(sqe->user_data);
@@ -8823,7 +8826,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (sqe_flags & ~SQE_VALID_FLAGS)
 			return -EINVAL;
 		if (sqe_flags & IOSQE_BUFFER_SELECT) {
-			if (!io_op_defs[opcode].buffer_select)
+			if (!def->buffer_select)
 				return -EOPNOTSUPP;
 			req->buf_index = READ_ONCE(sqe->buf_group);
 		}
@@ -8849,12 +8852,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		}
 	}
 
-	if (!io_op_defs[opcode].ioprio && sqe->ioprio)
+	if (!def->ioprio && sqe->ioprio)
 		return -EINVAL;
-	if (!io_op_defs[opcode].iopoll && (ctx->flags & IORING_SETUP_IOPOLL))
+	if (!def->iopoll && (ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	if (io_op_defs[opcode].needs_file) {
+	if (def->needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
 
 		req->cqe.fd = READ_ONCE(sqe->fd);
@@ -8863,7 +8866,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		 * Plug now if we have more than 2 IO left after this, and the
 		 * target is potentially a read/write to block based storage.
 		 */
-		if (state->need_plug && io_op_defs[opcode].plug) {
+		if (state->need_plug && def->plug) {
 			state->plug_started = true;
 			state->need_plug = false;
 			blk_start_plug_nr_ios(&state->plug, state->submit_nr);
-- 
2.35.1

