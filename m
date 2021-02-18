Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C182331EEFA
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 19:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhBRSwU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 13:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbhBRSgQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 13:36:16 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD95C0617AB
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:50 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id v15so4081056wrx.4
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8YDqziPK1B89z/uxkCaJbSSGoXwNwsVADNtIDLMXYSs=;
        b=ub0NJ6ueXRydPgHQMLGMR7H/wP21piDIY8BJFjuSNu9U5v0Nixotc+rK5ykz2RKrD4
         wT46LruHrrFJHsJfsYCFG4vXarnrzh+z+SNRn3dCDS1X643WOzPD+rtQbgNqHPUxgBPK
         olHggmYKOnhgaWFQytUHD7b4NSDa6Jr0UHOhanRxHsuh7Z0GcWTdfqzEljzrRf4ooSe5
         MPyyGUNgLB22UCby8RPnFM8h/aJfdJvugcq1xepxoMDVmoOnK760qne4E/dxotz7pwhL
         u3bzxZBHu4GgelHlbeqaE6x/osJgc6NsmAcDwXbbEyGF1K6NtMb42bSwhOw729+UST3m
         idOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8YDqziPK1B89z/uxkCaJbSSGoXwNwsVADNtIDLMXYSs=;
        b=GzgQ2Z3Kv1XGa6tBRR1H9RnfcR5l7FtZsFgr0D9mXVSA2Bgh6GpC3MunBrtXcRqcyw
         3Cuq5P21BW1LEsiH7NH0sZmNeyw2Hk0fs0edllsLqX56rjauSK0nOrs5EPqkyNQQrsD8
         dkn6bYfrstfZAjR8bSvcEaSggfy+YWRZGj6unl+4i/WWuVni03RkvDJQFJk+4UU6SgUj
         pbvRFn2XikSLGYI9mTqvD+MT0XcvEfRXxAlB0F+vOuMWtTDgFOPSgrVlso9R7WDEDpOV
         thhluCbtF0p7ZGcJwAdiX4eUaarJcb9PZXFALLuSEUNjJRMl/vNvI3VsSVPTWgZBTGzB
         C3og==
X-Gm-Message-State: AOAM5318CPMmeOm39lFIybPzN491x5a6/tCdEb6o/49hFHD99/ByN2Ul
        vJ/vA2mNSEOAA5mImYQG9r4=
X-Google-Smtp-Source: ABdhPJxhIKP7nrbc/iHzlTblw5x8JVDDMXQOvbnxPESV0zoVflUTYYjmS7fcDze0nWfKI7nb77GMDw==
X-Received: by 2002:a05:6000:c7:: with SMTP id q7mr5575952wrx.364.1613673229276;
        Thu, 18 Feb 2021 10:33:49 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id 36sm4034459wrh.94.2021.02.18.10.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:33:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/11] io_uring: move io_init_req() into io_submit_sqe()
Date:   Thu, 18 Feb 2021 18:29:41 +0000
Message-Id: <21bcfaa01ee0fc5ac450dff7644fd3ea05a67138.1613671791.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613671791.git.asml.silence@gmail.com>
References: <cover.1613671791.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Behaves identically, just move io_init_req() call into the beginning of
io_submit_sqes(). That looks better unloads io_submit_sqes().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1563853caac5..5c9b3b9ff92f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6751,12 +6751,23 @@ struct io_submit_link {
 	struct io_kiocb *last;
 };
 
-static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
+			 const struct io_uring_sqe *sqe,
 			 struct io_submit_link *link)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
+	ret = io_init_req(ctx, req, sqe);
+	if (unlikely(ret)) {
+fail_req:
+		io_put_req(req);
+		io_req_complete(req, ret);
+		return ret;
+	}
+
+	trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
+				true, ctx->flags & IORING_SETUP_SQPOLL);
+
 	/*
 	 * If we already have a head request, queue this one for async
 	 * submittal once the head completes. If we don't have a head but
@@ -6782,7 +6793,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		if (unlikely(ret)) {
 			/* fail even hard links since we don't submit */
 			head->flags |= REQ_F_FAIL_LINK;
-			return ret;
+			goto fail_req;
 		}
 		trace_io_uring_link(ctx, req, head);
 		link->last->link = req;
@@ -6904,7 +6915,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	while (submitted < nr) {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
-		int err;
 
 		req = io_alloc_req(ctx);
 		if (unlikely(!req)) {
@@ -6919,20 +6929,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		}
 		/* will complete beyond this point, count as submitted */
 		submitted++;
-
-		err = io_init_req(ctx, req, sqe);
-		if (unlikely(err)) {
-fail_req:
-			io_put_req(req);
-			io_req_complete(req, err);
+		if (io_submit_sqe(ctx, req, sqe, &link))
 			break;
-		}
-
-		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
-					true, ctx->flags & IORING_SETUP_SQPOLL);
-		err = io_submit_sqe(req, sqe, &link);
-		if (err)
-			goto fail_req;
 	}
 
 	if (unlikely(submitted != nr)) {
-- 
2.24.0

