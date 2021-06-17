Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EDF3ABA5E
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 19:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhFQRQr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 13:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbhFQRQr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 13:16:47 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F795C06175F
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:38 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id i94so7615562wri.4
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kYXcWFHIWml6lT6YudJcDnbMugRqQoMa7R+kVX+eNgY=;
        b=Apa1Pw1xuqC1f6KOXW5yne2xffAMOeyiWcrkkMRGM/bkxAtr8EDXLOLj62R/8L6PC4
         YgJeNBRvdhdHe3VRX254b5r/tzqXQKZyRKs913PePjS6JObMOkkuXfPN1IrWpa3miPWm
         5yk+KQ9VSm7ACfWyqSnoRpNNPewhDZyrYppnwUCwoaxehRwqeOee11POxKVvag3rr4gC
         MaiUFabbWNpAvmokzszUBG9pg9pz8U3o845Pjd0NmaU7PZd+CuMKhEPfN+cNl84jV7zU
         6w+h9U09KXkZVYidF820VzsmrdYbNANQ2eXi49nH/RMuROqejq5y5dhfWpGgXyu5xOni
         lV0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kYXcWFHIWml6lT6YudJcDnbMugRqQoMa7R+kVX+eNgY=;
        b=pAOq9inQj2ptO2Ze0QuwhJVDyIu4jG/W1hv0TuAnYx1ay53Q+gQqfJ9l7x+Ttg2nVT
         F15a7iiSjSaVtUWCkvYioEenQZ8Ds/uk0fiVIpMv5gw3wvGg2JyEHbhQfpJsBhpjImET
         YCpbjs7eFFT9NfeRfWwVmM0SmFlUG+2dADWBvC+KWhmiUwavorXSdUk/5/ciHC8+KvXX
         vQMFunHUa5hT0qZQtED9srfZz6xSjYC5ApxTkR91P1KiH1AfGQhDtaANeaMeZhvdMPo6
         GFM10kRfoVFibM3+8P5QQ0Y4IHivnLuCPvCAxw4f0zXu3yEhJhliBfbWeeoMcvip1gmD
         hz8Q==
X-Gm-Message-State: AOAM533A9toiVdl8woc22BXLKTnDNo3+pXaSKOtULKehx7xKTWqOmyL1
        fWlSWwExzWkZBntk5HyecyU=
X-Google-Smtp-Source: ABdhPJxT5AnIbDk+hTAs30bfbGfb9Xxmgqw8shGeWw+FTGJrs79Si6wqQouXDcveOLTHHNtIlY7v9w==
X-Received: by 2002:adf:f689:: with SMTP id v9mr718214wrp.314.1623950076734;
        Thu, 17 Jun 2021 10:14:36 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id g17sm6208033wrp.61.2021.06.17.10.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:14:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/12] io_uring: track request creds with a flag
Date:   Thu, 17 Jun 2021 18:14:02 +0100
Message-Id: <5f8baeb8d3b909487f555542350e2eac97005556.1623949695.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623949695.git.asml.silence@gmail.com>
References: <cover.1623949695.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently, if req->creds is not NULL, then there are creds assigned.
Track the invariant with a new flag in req->flags. No need to clear the
field at init, and also cleanup can be efficiently moved into
io_clean_op().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2bac5cd4dc91..d0d56243c135 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -718,6 +718,7 @@ enum {
 	REQ_F_COMPLETE_INLINE_BIT,
 	REQ_F_REISSUE_BIT,
 	REQ_F_DONT_REISSUE_BIT,
+	REQ_F_CREDS_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_ASYNC_READ_BIT,
 	REQ_F_ASYNC_WRITE_BIT,
@@ -771,6 +772,8 @@ enum {
 	REQ_F_ASYNC_WRITE	= BIT(REQ_F_ASYNC_WRITE_BIT),
 	/* regular file */
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
+	/* has creds assigned */
+	REQ_F_CREDS		= BIT(REQ_F_CREDS_BIT),
 };
 
 struct async_poll {
@@ -1236,8 +1239,10 @@ static void io_prep_async_work(struct io_kiocb *req)
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!req->creds)
+	if (!(req->flags & REQ_F_CREDS)) {
+		req->flags |= REQ_F_CREDS;
 		req->creds = get_current_cred();
+	}
 
 	req->work.list.next = NULL;
 	req->work.flags = 0;
@@ -1623,7 +1628,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 static inline bool io_req_needs_clean(struct io_kiocb *req)
 {
 	return req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP |
-				REQ_F_POLLED | REQ_F_INFLIGHT);
+				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS);
 }
 
 static void io_req_complete_state(struct io_kiocb *req, long res,
@@ -1747,10 +1752,6 @@ static void io_dismantle_req(struct io_kiocb *req)
 		percpu_ref_put(req->fixed_rsrc_refs);
 	if (req->async_data)
 		kfree(req->async_data);
-	if (req->creds) {
-		put_cred(req->creds);
-		req->creds = NULL;
-	}
 }
 
 /* must to be called somewhat shortly after putting a request */
@@ -6133,6 +6134,10 @@ static void io_clean_op(struct io_kiocb *req)
 		atomic_dec(&tctx->inflight_tracked);
 		req->flags &= ~REQ_F_INFLIGHT;
 	}
+	if (req->flags & REQ_F_CREDS) {
+		put_cred(req->creds);
+		req->flags &= ~REQ_F_CREDS;
+	}
 }
 
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
@@ -6141,7 +6146,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	const struct cred *creds = NULL;
 	int ret;
 
-	if (req->creds && req->creds != current_cred())
+	if ((req->flags & REQ_F_CREDS) && req->creds != current_cred())
 		creds = override_creds(req->creds);
 
 	switch (req->opcode) {
@@ -6534,7 +6539,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	atomic_set(&req->refs, 2);
 	req->task = current;
 	req->result = 0;
-	req->creds = NULL;
 
 	/* enforce forwards compatibility on users */
 	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
@@ -6556,6 +6560,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (!req->creds)
 			return -EINVAL;
 		get_cred(req->creds);
+		req->flags |= REQ_F_CREDS;
 	}
 	state = &ctx->submit_state;
 
-- 
2.31.1

