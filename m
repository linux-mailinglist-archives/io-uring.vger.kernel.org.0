Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A3E31A4AD
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 19:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhBLSqA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 13:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhBLSp6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 13:45:58 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7C5C061786
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 10:45:18 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id 7so425827wrz.0
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 10:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KddPuFQOaEHkDE9ME5KkVSVGhu8EsYrkzrFjuaUPH+4=;
        b=hUEWmCsLlb00Bxo23aIS+d1yNa50MsNtwtTEZ+ijPzEA3i7xzFERW+bR19u675peBv
         isLxhFWXADgoCQD1aQpsV1fXF7JEa8NwBRG2f7EY9OhklWoH9S+Jk3M3sdspcXWg38X0
         vjkzxOWiHEtCdu8spksabOgoxNIOn4RgKFNzmvzRkNOvhLB6pJZkiFCUPZ/P5AA/h2Er
         lyCPgR1jbQ/Icn633zs9/3unfjGtipzsze43R7zzowC4IZ+O/NFTCY0D9dW8s+BYP1TO
         byct09sDONr3m5ilCPtkniyZCSs2n2tWrQOnTlxDVsehOPao3c0Uv3/FHB22jdg1RocE
         MZQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KddPuFQOaEHkDE9ME5KkVSVGhu8EsYrkzrFjuaUPH+4=;
        b=iBlrLOn3pEVbKYku74KLel1SiZa5DwIkbl7JljAJcTPrhrFG+XBqMyhPNkL9CKlkk8
         zuQ65VMK0LiOOaM7pbV84HseWN+8CLTO8QahEwAnyQxrIVIb+MhVQqWbLXPnItR9NDqB
         wjJZhipJhj7IbcwOJAU82RJhjMTBXobDs2gFSJMcEPOqLKCwmWawvjAWWVhMPpqUMu1J
         +yWpe85Tjdkj3mHgNo59xaXVtD0l8To854713Old5bceeB+vaQ6jyo793AOTlgI/GCZw
         j2kWdBTB3SdCtierkX2zYujCpyiAKqbfiyyWt9P/SZSx6/fZo9of01oVqqfQ3wcEUMuN
         hIKg==
X-Gm-Message-State: AOAM530AhJHRTyUsCJ4nwueHbV/W1g8Xawpj7n0r/G2IzOEu0rZJxnn2
        /0JO4zUdowNQbz8PTrr9bfw=
X-Google-Smtp-Source: ABdhPJxg0QJ3hjRTPNBm9IfQxMfqTmpTyiW0dSsBw08SLY2inu8/CYhFJP5qiLHmnfcIGNafYuaWjQ==
X-Received: by 2002:adf:a31b:: with SMTP id c27mr4949904wrb.188.1613155516829;
        Fri, 12 Feb 2021 10:45:16 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id e16sm13452830wrt.36.2021.02.12.10.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 10:45:16 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: optimise io_init_req() flags setting
Date:   Fri, 12 Feb 2021 18:41:17 +0000
Message-Id: <223d634f57c37f63d97842945fb0c8e71db70fe2.1613154861.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613154861.git.asml.silence@gmail.com>
References: <cover.1613154861.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Invalid req->flags are tolerated by free/put well, avoid this dancing
needlessly presetting it to zero, and then not even resetting but
modifying it, i.e. "|=".

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 776531f6e18b..2e8cb739c835 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6806,14 +6806,15 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 {
 	struct io_submit_state *state;
 	unsigned int sqe_flags;
-	int id, ret;
+	int id, ret = 0;
 
 	req->opcode = READ_ONCE(sqe->opcode);
+	/* same numerical values with corresponding REQ_F_*, safe to copy */
+	req->flags = sqe_flags = READ_ONCE(sqe->flags);
 	req->user_data = READ_ONCE(sqe->user_data);
 	req->async_data = NULL;
 	req->file = NULL;
 	req->ctx = ctx;
-	req->flags = 0;
 	req->link = NULL;
 	req->fixed_rsrc_refs = NULL;
 	/* one is dropped after submission, the other at completion */
@@ -6821,17 +6822,16 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->task = current;
 	req->result = 0;
 
+	/* enforce forwards compatibility on users */
+	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
+		return -EINVAL;
+
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
 
 	if (unlikely(io_sq_thread_acquire_mm_files(ctx, req)))
 		return -EFAULT;
 
-	sqe_flags = READ_ONCE(sqe->flags);
-	/* enforce forwards compatibility on users */
-	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
-		return -EINVAL;
-
 	if (unlikely(!io_check_restriction(ctx, req, sqe_flags)))
 		return -EACCES;
 
@@ -6854,8 +6854,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		req->work.flags |= IO_WQ_WORK_CREDS;
 	}
 
-	/* same numerical values with corresponding REQ_F_*, safe to copy */
-	req->flags |= sqe_flags;
 	state = &ctx->submit_state;
 
 	/*
@@ -6868,7 +6866,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		state->plug_started = true;
 	}
 
-	ret = 0;
 	if (io_op_defs[req->opcode].needs_file) {
 		bool fixed = req->flags & REQ_F_FIXED_FILE;
 
-- 
2.24.0

