Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C11291696
	for <lists+io-uring@lfdr.de>; Sun, 18 Oct 2020 11:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgJRJUr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Oct 2020 05:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgJRJUq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Oct 2020 05:20:46 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0938C061755
        for <io-uring@vger.kernel.org>; Sun, 18 Oct 2020 02:20:46 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id a72so7413769wme.5
        for <io-uring@vger.kernel.org>; Sun, 18 Oct 2020 02:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LPqBk+sH3WBUxPPrehH1uaB7khKr8H+b/FPEx71/Oys=;
        b=JAot48dN+29sEvAuN6+tDZbo3F4eRr504m9WusakrIU3jj50F85fuDtqyoNNI2RyEJ
         i7rX3uPySCC5jnWgZd9zu+lIKfGn9UOj7I2I+L9zXUvAXsVG+kG3yn1r/uiac2+XcqUH
         csxwhJUAy5zGpueADwmLm0biE9jZ9RL1Bzsw3lwpPBI0aX1uoXtNPUeqUk7Bd700vXCA
         B7XJSU/g8EOmMRUnT5JbWkpZ0ly0It29FTiaSuooIGbqLQnuVKPaOheC9zS+OAV5ed6a
         AIVQZRm9116A4k8hlVnVCbqkfd7IoOCC83cUAOixNzZJek+0y3PRVdMdUZXH3auBPkhg
         lR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LPqBk+sH3WBUxPPrehH1uaB7khKr8H+b/FPEx71/Oys=;
        b=obYIZ8oGu8goeBEDzQ7txKG5Z4CigBtubL10FJk0/w+mlSbtesihATOy+KjgaeSH23
         VMGBLSeQg98E9ccYewZjxX0l86d1y93DbIMQ0oID+0MmTOje/1fMKGH9zSS2Lyh5BL/f
         q5YyUQJxNrRQG4psvORoia7YORDS239wUk/+5mxrpAMKRbRl1qDoGpJKRq6pGfIqKhGX
         KkIIrBNANaDugvYug335aXmTKJ/Nklmdn2KQnZkBKD9gVotVfO3RtsxUAR2WshHsKPJd
         35RuKUASzTfMvPL/HFjkDJlJDIJUmZQ7a0ufwQcYUe1iq/6GMRBosZ0RLMCJaG+FRY5M
         98pQ==
X-Gm-Message-State: AOAM532DK/wZE5k1r6Y9+7Y8wsJYEUFoz/Ol3wfzvXogKMGLvWpSSyDt
        lGPawKbh/IJmMYGeUKxSmByiRXBoCLK7KA==
X-Google-Smtp-Source: ABdhPJzDTVW2nhONlODw+HSpoETgr5SXLVgxFM9BKWhBOqB7JhupC8E75gEOq/vTgNTbiB1UOwDY9Q==
X-Received: by 2002:a7b:c394:: with SMTP id s20mr12011889wmj.176.1603012845353;
        Sun, 18 Oct 2020 02:20:45 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id w11sm12782984wrs.26.2020.10.18.02.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 02:20:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/7] io_uring: kill ref get/drop in personality init
Date:   Sun, 18 Oct 2020 10:17:38 +0100
Message-Id: <3a6b087088de6b9fbc1694201a20f8c0951536de.1603011899.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603011899.git.asml.silence@gmail.com>
References: <cover.1603011899.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't take an identity on personality/creds init only to drop it a few
lines after. Extract a function which prepares req->work but leaves it
without identity.

Note: it's safe to not check REQ_F_WORK_INITIALIZED there because it's
nobody had a chance to init it before io_init_req().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fd2fc72c312c..048db9d3002c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1070,6 +1070,12 @@ static void io_init_identity(struct io_identity *id)
 	refcount_set(&id->count, 1);
 }
 
+static inline void __io_req_init_async(struct io_kiocb *req)
+{
+	memset(&req->work, 0, sizeof(req->work));
+	req->flags |= REQ_F_WORK_INITIALIZED;
+}
+
 /*
  * Note: must call io_req_init_async() for the first time you
  * touch any members of io_wq_work.
@@ -1081,8 +1087,7 @@ static inline void io_req_init_async(struct io_kiocb *req)
 	if (req->flags & REQ_F_WORK_INITIALIZED)
 		return;
 
-	memset(&req->work, 0, sizeof(req->work));
-	req->flags |= REQ_F_WORK_INITIALIZED;
+	__io_req_init_async(req);
 
 	/* Grab a ref if this isn't our static identity */
 	req->work.identity = tctx->identity;
@@ -6497,12 +6502,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (id) {
 		struct io_identity *iod;
 
-		io_req_init_async(req);
 		iod = idr_find(&ctx->personality_idr, id);
 		if (unlikely(!iod))
 			return -EINVAL;
 		refcount_inc(&iod->count);
-		io_put_identity(current->io_uring, req);
+
+		__io_req_init_async(req);
 		get_cred(iod->creds);
 		req->work.identity = iod;
 		req->work.flags |= IO_WQ_WORK_CREDS;
-- 
2.24.0

