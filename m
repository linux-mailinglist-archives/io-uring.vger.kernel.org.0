Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6344A4240D5
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 17:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239000AbhJFPJb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 11:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239073AbhJFPJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 11:09:31 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A6BC061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 08:07:38 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id k7so9699214wrd.13
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 08:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z/k7F7sJMiNsTqd/0a3553Our4orqA7MLo03RVgbLAE=;
        b=LZMX7sz9UwzyYI8wgmjnlr/V1gFZ06dvM7OLIy1IXk1ZJypqZR1tRvWto5kbQCVWP7
         aif8+nm8kGFOY+/eySueuCNHaG3xCAtXyg/bK5NGS9oSRyh2eDnIB73tnjlFyFlXXUxi
         hJWH0gxP6Pc0b/pcG58mfjkASp4GbtDJUWDFZLg5eYj0CMWD4hDWVtpXajfLw0LZ1tx7
         FvYo1yYIq0RT/eKA4NXi1HnMHDqSqP9bu5WS2C5//zthvn1WewY0mE0gr9pgeHjFjBbf
         TQSwyL4MFtKt4A00OFjMKOq9HmbDwJw6mcGWtTaBJvqEgq6NviDygvPpw1hGAAySPHFE
         rN5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z/k7F7sJMiNsTqd/0a3553Our4orqA7MLo03RVgbLAE=;
        b=eBIyeMpFbAAH9Z4/d3iL88hLXhFmOB/eBE3iFQ2qOM0vkoioHUmH+Nn3IArz2ILA3p
         kpni9NaXFl+gMLmvSrSNDhzAsYkuByqoRNyltPosgWaMrlDIoKMgc0birTDGgXYy4zZ0
         Vb0XdbCyxoXn6Qe2nA0uezqFuci3DdP+lTwBt+uaxE5DXGmf9ERmwNM5DiLXY2quEUbb
         FnUmqvEMCxMrokkYxZTOR4poOX5JGiQdkowUlMuT1u4pwknJPovEhRq1Zq4ZOLk0BFZf
         Ka9s6abCTDP7qN6qOatyY4iQiH8WNeKUB59ZfIjxSSVYiEoigLuYMeNUE1cF0+QAYC2x
         NY0Q==
X-Gm-Message-State: AOAM532/Z2kZGQpgGaCikVNv7AJVEmnUotUb5/9WWDBYW9JKnvAsgDlU
        KWKlND8p42xtOCAZ034/IGsoi7jMZB4=
X-Google-Smtp-Source: ABdhPJzMugMQVl5xanATRwaCjyfCaJjp4hNzet4gWEbnSPpSLayBEOfsVC4QOFl6VRkO9UH9DxwFnw==
X-Received: by 2002:adf:dc43:: with SMTP id m3mr29373537wrj.66.1633532857152;
        Wed, 06 Oct 2021 08:07:37 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id o7sm24678368wro.45.2021.10.06.08.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 08:07:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/5] io_uring: optimise plugging
Date:   Wed,  6 Oct 2021 16:06:46 +0100
Message-Id: <1600d1287bb7d16451d4ef3343252787a5314927.1633532552.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633532552.git.asml.silence@gmail.com>
References: <cover.1633532552.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Plugging is only needed with requests that also need a file, so hide
plugging under a ->needs_file check. Also, place ->needs_file and ->plug
bits into the same byte of io_op_defs, it may matter for compilers, e.g.
only with the change a tested one decided to optimise two memory testb
into a more with two register testb.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 62dc128e9b6b..fabb3580e27c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -894,12 +894,12 @@ struct io_defer_entry {
 struct io_op_def {
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
+	/* should block plug */
+	unsigned		plug : 1;
 	/* hash wq insertion if file is a regular file */
 	unsigned		hash_reg_file : 1;
 	/* unbound wq insertion if file is a non-regular file */
 	unsigned		unbound_nonreg_file : 1;
-	/* opcode is not supported by this kernel */
-	unsigned		not_supported : 1;
 	/* set if opcode supports polled "wait" */
 	unsigned		pollin : 1;
 	unsigned		pollout : 1;
@@ -907,8 +907,8 @@ struct io_op_def {
 	unsigned		buffer_select : 1;
 	/* do prep async if is going to be punted */
 	unsigned		needs_async_setup : 1;
-	/* should block plug */
-	unsigned		plug : 1;
+	/* opcode is not supported by this kernel */
+	unsigned		not_supported : 1;
 	/* size of async data needed, if any */
 	unsigned short		async_size;
 };
@@ -6981,7 +6981,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       const struct io_uring_sqe *sqe)
 	__must_hold(&ctx->uring_lock)
 {
-	struct io_submit_state *state;
 	unsigned int sqe_flags;
 	int personality;
 
@@ -7028,19 +7027,20 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		get_cred(req->creds);
 		req->flags |= REQ_F_CREDS;
 	}
-	state = &ctx->submit_state;
-
-	/*
-	 * Plug now if we have more than 1 IO left after this, and the target
-	 * is potentially a read/write to block based storage.
-	 */
-	if (state->need_plug && io_op_defs[req->opcode].plug) {
-		blk_start_plug(&state->plug);
-		state->plug_started = true;
-		state->need_plug = false;
-	}
 
 	if (io_op_defs[req->opcode].needs_file) {
+		struct io_submit_state *state = &ctx->submit_state;
+
+		/*
+		 * Plug now if we have more than 2 IO left after this, and the
+		 * target is potentially a read/write to block based storage.
+		 */
+		if (state->need_plug && io_op_defs[req->opcode].plug) {
+			state->plug_started = true;
+			state->need_plug = false;
+			blk_start_plug(&state->plug);
+		}
+
 		req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
 					(sqe_flags & IOSQE_FIXED_FILE));
 		if (unlikely(!req->file))
-- 
2.33.0

