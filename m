Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959E54240D7
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 17:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239113AbhJFPJe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 11:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239017AbhJFPJd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 11:09:33 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8CBC061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 08:07:41 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v17so9789579wrv.9
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 08:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xfrs0Xwy41pJGfUjg7KkrW0TW2W4QRo2ok0Is1HVatU=;
        b=CaQGvht8IS0qTTAFnHYyFeK3UDtCxfx5CQpvU/Ddxgv1GDBFVcEeHrkpK8LVZN9vKD
         o/SNZdsD5AlrUrj/L7oZp86VG6M7VMaZZMHUZOMOTevXSCFf5hjw4WC7jzK3NVvYUBrA
         xKmWWXQ0ZErxmUbRqckOBCz2J1Tk+ZKkDO3n2Q7ZtLSDDivbPQIZdP/Ivp06oHVzBBd8
         a7s2zJLHnkm63jirpGXB9jvZmbxwHx0js2CxpnvHBJXcDXUekAklTw4WLcwa2GHCCdYP
         VLdgoJIXncPGjFa4XO6DueBa6E/09ZUhvK9obug0K5mnnOZHkKNGE1uQv7/YCVtZ8Jow
         zXGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xfrs0Xwy41pJGfUjg7KkrW0TW2W4QRo2ok0Is1HVatU=;
        b=YRRDKfwhJhkFou0JHTtKD9Qm5k9slbF/dWNqqxTbfjs5c3R/RO4uJX5Ex+A1aUL5P6
         5v+VakkjzNifG7W8S/jZ0e2Q8fU2bIt0U+t6kKUlXVTmIKtPBR6Bgbg4Qng6CenLMH8+
         AamcZ+5/5pKY1yZgogkzZrfK/7HxH2WChCniTT3yLdwIrAD/CoRE+HwnaDcebb4TWyJe
         CbhFwyIMLriXj6IY7CkyrH6S9YGFPVEhob9WD91k956gs8haRM5PCJCPXZJW66z3WJmr
         87wZyZ3CJmsiEhzsWAdh1Kgs/AdOhUdma3HjMV3hmf1ZjHQKJ5+olKUMwy3zUDLG+sG6
         NYww==
X-Gm-Message-State: AOAM533/AWUvAsIZtpeu0HWwkMGpT7/a/j7YfSndTx1KyOs7Pfvfku0X
        sTw24YVMtH6gGjoPgT37cXdbrzpa+TI=
X-Google-Smtp-Source: ABdhPJxvip0IYF6nigfaEyt7HibVaJIdmPZBXWUq1OthHOlYfmeM3oxhQWLAarhrTkT2WErM/I+c/w==
X-Received: by 2002:a1c:7d91:: with SMTP id y139mr10806351wmc.57.1633532859649;
        Wed, 06 Oct 2021 08:07:39 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id o7sm24678368wro.45.2021.10.06.08.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 08:07:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/5] io_uring: optimise out req->opcode reloading
Date:   Wed,  6 Oct 2021 16:06:49 +0100
Message-Id: <6ba869f5f8b7b0f991c87fdf089f0abf87cbe06b.1633532552.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633532552.git.asml.silence@gmail.com>
References: <cover.1633532552.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looking at the assembly, the compiler decided to reload req->opcode in
io_op_defs[opcode].needs_file instead of one it had in a register, so
store it in a temp variable so it can be optimised out. Also move the
personality block later, it's better for spilling/etc. as it only
depends on @sqe, which we're keeping anyway.

By the way, zero req->opcode if it over IORING_OP_LAST, not a problem,
at the moment but is safer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3f8bfa309b16..1f4aa2cdaaa2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6978,9 +6978,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 {
 	unsigned int sqe_flags;
 	int personality;
+	u8 opcode;
 
 	/* req is partially pre-initialised, see io_preinit_req() */
-	req->opcode = READ_ONCE(sqe->opcode);
+	req->opcode = opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags = sqe_flags = READ_ONCE(sqe->flags);
 	req->user_data = READ_ONCE(sqe->user_data);
@@ -6988,14 +6989,16 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->fixed_rsrc_refs = NULL;
 	req->task = current;
 
-	if (unlikely(req->opcode >= IORING_OP_LAST))
+	if (unlikely(opcode >= IORING_OP_LAST)) {
+		req->opcode = 0;
 		return -EINVAL;
+	}
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
 		/* enforce forwards compatibility on users */
 		if (sqe_flags & ~SQE_VALID_FLAGS)
 			return -EINVAL;
 		if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
-		    !io_op_defs[req->opcode].buffer_select)
+		    !io_op_defs[opcode].buffer_select)
 			return -EOPNOTSUPP;
 		if (sqe_flags & IOSQE_IO_DRAIN)
 			io_init_req_drain(req);
@@ -7014,23 +7017,14 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		}
 	}
 
-	personality = READ_ONCE(sqe->personality);
-	if (personality) {
-		req->creds = xa_load(&ctx->personalities, personality);
-		if (!req->creds)
-			return -EINVAL;
-		get_cred(req->creds);
-		req->flags |= REQ_F_CREDS;
-	}
-
-	if (io_op_defs[req->opcode].needs_file) {
+	if (io_op_defs[opcode].needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
 
 		/*
 		 * Plug now if we have more than 2 IO left after this, and the
 		 * target is potentially a read/write to block based storage.
 		 */
-		if (state->need_plug && io_op_defs[req->opcode].plug) {
+		if (state->need_plug && io_op_defs[opcode].plug) {
 			state->plug_started = true;
 			state->need_plug = false;
 			blk_start_plug(&state->plug);
@@ -7042,6 +7036,15 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			return -EBADF;
 	}
 
+	personality = READ_ONCE(sqe->personality);
+	if (personality) {
+		req->creds = xa_load(&ctx->personalities, personality);
+		if (!req->creds)
+			return -EINVAL;
+		get_cred(req->creds);
+		req->flags |= REQ_F_CREDS;
+	}
+
 	return io_req_prep(req, sqe);
 }
 
-- 
2.33.0

