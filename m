Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C134D73B60F
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 13:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbjFWLYn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 07:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjFWLYl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 07:24:41 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D38199D
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:40 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-98cd280cf94so55251566b.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687519478; x=1690111478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Urqbe8d5meDgYTnTRdNWXyukQbW5jl8lzicwvsbbj8=;
        b=BlFLKrNfu9YuetzcJ6pYXL0/P5086YczEzPViXFSCda153kbwVni6ryb3dXOuwtCa0
         4Ur3ptLboIv8OKxjQOKFyneYCfAgbcG7T5JixKr0lFTdZMJr0KVEsI9yhpnCRimDeF0R
         HCiIHp1vzrseJKhPhgsGg52HaEHS/7hudlJK1hkJFWURvw5dO6h1Z7vlmPEwXRpgoQHZ
         SA/14Vvbc1XMkFPBUCmEGOxxPT8YSW3VDcizQVRNDgysuqWKBspK2KSmgBJUGIpN2vpS
         o4u+Q9vbsIRbPG/KT/P8UTOUTqnVMy0Hcqdau2WPEWy92ha0nBJEbtclPsQFF/zezTLB
         BCDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519478; x=1690111478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Urqbe8d5meDgYTnTRdNWXyukQbW5jl8lzicwvsbbj8=;
        b=I8r1/rkmu/jEWgIJ6OZnOEW3MsP1xjewR8/WBqKobA7/K4KW8XQGat0QUvXyq3s8BY
         WveiOD82fgyce50HzAkXNWCFMfbiiKYMZIzbpJSLgynJdG6UbWfM58QtATpJocGz8CQ3
         2Q42sdEvP4WU1SO3CkV5IYrINaIvCEWZQ9pz4Y4SIoQyFKUJ1o4UsTNj+Nx7DasltfMJ
         MXrCR3gbc9ii8RagIMlbOw3oj95cO/aZLmM8xPIkB1vswZJYvtML4fJHp6WOTCrukPHb
         qclI6Shr5iASF1qoHzQrsVR9ehpM9E8a+H3ptEtz7La3A9xzOJxve2A9ug6EfgOMHWnc
         nDjQ==
X-Gm-Message-State: AC+VfDzlVNFfqWpVjSb3vtPwPIpx4q8FSK6EDAnqc8ZVmPzC12x7Z2H2
        F79WGTOw/UBnNCwl+3sWxdFHkWQxPAc=
X-Google-Smtp-Source: ACHHUZ4cVgt35XsgJNsGPKbc/lCn7nv+dHmx5nq27y4lmJ7XQrVwQT02pTpjp3bRFIDt/UeILkS10A==
X-Received: by 2002:a17:906:64db:b0:98d:5ae2:f1c with SMTP id p27-20020a17090664db00b0098d5ae20f1cmr2174893ejn.34.1687519478377;
        Fri, 23 Jun 2023 04:24:38 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7d95])
        by smtp.gmail.com with ESMTPSA id h10-20020a1709067cca00b00969f44bbef3sm5959769ejp.11.2023.06.23.04.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:24:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 04/11] io_uring: move io_clean_op()
Date:   Fri, 23 Jun 2023 12:23:24 +0100
Message-Id: <1b7163b2ba7c3a8322d972c79c1b0a9301b3057e.1687518903.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1687518903.git.asml.silence@gmail.com>
References: <cover.1687518903.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move io_clean_op() up in the source file and remove the forward
declaration, as the function doesn't have tricky dependencies
anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 67 ++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 50fe345bdced..4d8613996644 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -146,7 +146,6 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 bool cancel_all);
 
-static void io_clean_op(struct io_kiocb *req);
 static void io_queue_sqe(struct io_kiocb *req);
 static void io_move_task_work_from_local(struct io_ring_ctx *ctx);
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
@@ -367,6 +366,39 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 	return false;
 }
 
+static void io_clean_op(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_BUFFER_SELECTED) {
+		spin_lock(&req->ctx->completion_lock);
+		io_put_kbuf_comp(req);
+		spin_unlock(&req->ctx->completion_lock);
+	}
+
+	if (req->flags & REQ_F_NEED_CLEANUP) {
+		const struct io_cold_def *def = &io_cold_defs[req->opcode];
+
+		if (def->cleanup)
+			def->cleanup(req);
+	}
+	if ((req->flags & REQ_F_POLLED) && req->apoll) {
+		kfree(req->apoll->double_poll);
+		kfree(req->apoll);
+		req->apoll = NULL;
+	}
+	if (req->flags & REQ_F_INFLIGHT) {
+		struct io_uring_task *tctx = req->task->io_uring;
+
+		atomic_dec(&tctx->inflight_tracked);
+	}
+	if (req->flags & REQ_F_CREDS)
+		put_cred(req->creds);
+	if (req->flags & REQ_F_ASYNC_DATA) {
+		kfree(req->async_data);
+		req->async_data = NULL;
+	}
+	req->flags &= ~IO_REQ_CLEAN_FLAGS;
+}
+
 static inline void io_req_track_inflight(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_INFLIGHT)) {
@@ -1823,39 +1855,6 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	spin_unlock(&ctx->completion_lock);
 }
 
-static void io_clean_op(struct io_kiocb *req)
-{
-	if (req->flags & REQ_F_BUFFER_SELECTED) {
-		spin_lock(&req->ctx->completion_lock);
-		io_put_kbuf_comp(req);
-		spin_unlock(&req->ctx->completion_lock);
-	}
-
-	if (req->flags & REQ_F_NEED_CLEANUP) {
-		const struct io_cold_def *def = &io_cold_defs[req->opcode];
-
-		if (def->cleanup)
-			def->cleanup(req);
-	}
-	if ((req->flags & REQ_F_POLLED) && req->apoll) {
-		kfree(req->apoll->double_poll);
-		kfree(req->apoll);
-		req->apoll = NULL;
-	}
-	if (req->flags & REQ_F_INFLIGHT) {
-		struct io_uring_task *tctx = req->task->io_uring;
-
-		atomic_dec(&tctx->inflight_tracked);
-	}
-	if (req->flags & REQ_F_CREDS)
-		put_cred(req->creds);
-	if (req->flags & REQ_F_ASYNC_DATA) {
-		kfree(req->async_data);
-		req->async_data = NULL;
-	}
-	req->flags &= ~IO_REQ_CLEAN_FLAGS;
-}
-
 static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
 			   unsigned int issue_flags)
 {
-- 
2.40.0

