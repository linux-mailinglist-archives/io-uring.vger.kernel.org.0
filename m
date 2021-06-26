Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169253B501B
	for <lists+io-uring@lfdr.de>; Sat, 26 Jun 2021 22:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhFZUnm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Jun 2021 16:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhFZUnl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Jun 2021 16:43:41 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC785C061768
        for <io-uring@vger.kernel.org>; Sat, 26 Jun 2021 13:41:18 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id g198so551875wme.5
        for <io-uring@vger.kernel.org>; Sat, 26 Jun 2021 13:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PaASvh3y9JlSyLGvKCCki+DJXGFXlgFHhMGmRHuBsHY=;
        b=LPZmO1ySaRM+4cTM0mQvvfLi8dEJKzvQWItBIGJXQypL7a3F4cqz31m1Kg8uuCMeLL
         y+OCMwFrOFoYgYdvlP+Hmb6SO0gIJbhgfOJalmcJ+9uY23lQmtwgaQhi6jskC1wGSXVh
         fgVXxMEdwzYuHM53BsPSJyh4jRL9DtQiymABMst7f0ZvwjE1q7K+hG+Mk+NQEeQTglOE
         mSX7mxcCKU9AY5jYpSL3/R8HlXsUp9ITcaI4ZWLAK5OlyH2PzWiuzFcu0cZ27kH6Qxq4
         biiBO5R2jX1onTe/JLJfVIA0xHlhDzQ6YkElzgc7pwgZjCJMhlNkwZJmcHdB1jbm7RV/
         UyVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PaASvh3y9JlSyLGvKCCki+DJXGFXlgFHhMGmRHuBsHY=;
        b=HHOP4nRaO8fAEgggPSRKCuCZMaC48JF0Wc69k/Fxe6EE1n0BSP92EUbgTN9+u9AWhu
         uVYt8z3paC/x8vVhb2LwNINkDpz/WII0X3nhVuIKqNvBF2yfe3lzeWes43ZAJT2/IqLc
         kjzpi9FKIN0Dvn4kzWUPs0oXw2EL968GiT5jtgjo5bdx6syhgu8Yye8JfM4yat5Yc+IJ
         JYqmJLguFr+05eABsvp7Ga9pYZ6pEZ5NT5wNpQ1jdyoq3iajakvppCLu+p+cp+UcYrR0
         FSnMOgF1zgJEWg/scsoqtElDM0kX90HSoz8ZYAD44GL9pw7ghmskXwHfAABhH1RTsyIE
         aafw==
X-Gm-Message-State: AOAM530a9mRhL+agppCVzJdfIKsT+U5Mu3vCfqazStpAp4Ng4J85amNK
        7Wnb9leT45k5hu2PnKnc6EQ=
X-Google-Smtp-Source: ABdhPJxCyl5b4FudK7bHLDrTg32Hj/PTFpHDh1tZsbPCfC6NHx1wFXRsfvtoRBlPEMOn85vqFp3UpQ==
X-Received: by 2002:a05:600c:2184:: with SMTP id e4mr17749240wme.40.1624740076739;
        Sat, 26 Jun 2021 13:41:16 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.84])
        by smtp.gmail.com with ESMTPSA id b9sm11272613wrh.81.2021.06.26.13.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 13:41:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/6] io_uring: pre-initialise some of req fields
Date:   Sat, 26 Jun 2021 21:40:49 +0100
Message-Id: <892ba0e71309bba9fe9e0142472330bbf9d8f05d.1624739600.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624739600.git.asml.silence@gmail.com>
References: <cover.1624739600.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Most of requests are allocated from an internal cache, so it's waste of
time fully initialising them every time. Instead, let's pre-init some of
the fields we can during initial allocation (e.g. kmalloc(), see
io_alloc_req()) and keep them valid on request recycling. There are four
of them in this patch:

->ctx is always stays the same
->link is NULL on free, it's an invariant
->result is not even needed to init, just a precaution
->async_data we now clean in io_dismantle_req() as it's likely to
   never be allocated.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 873cfd4a8761..6cfbf72340ab 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1740,7 +1740,7 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 
 	if (!state->free_reqs) {
 		gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
-		int ret;
+		int ret, i;
 
 		if (io_flush_cached_reqs(ctx))
 			goto got_req;
@@ -1758,6 +1758,20 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 				return NULL;
 			ret = 1;
 		}
+
+		/*
+		 * Don't initialise the fields below on every allocation, but
+		 * do that in advance and keep valid on free.
+		 */
+		for (i = 0; i < ret; i++) {
+			struct io_kiocb *req = state->reqs[i];
+
+			req->ctx = ctx;
+			req->link = NULL;
+			req->async_data = NULL;
+			/* not necessary, but safer to zero */
+			req->result = 0;
+		}
 		state->free_reqs = ret;
 	}
 got_req:
@@ -1781,8 +1795,10 @@ static void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req->file);
 	if (req->fixed_rsrc_refs)
 		percpu_ref_put(req->fixed_rsrc_refs);
-	if (req->async_data)
+	if (req->async_data) {
 		kfree(req->async_data);
+		req->async_data = NULL;
+	}
 }
 
 /* must to be called somewhat shortly after putting a request */
@@ -6730,15 +6746,11 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags = sqe_flags = READ_ONCE(sqe->flags);
 	req->user_data = READ_ONCE(sqe->user_data);
-	req->async_data = NULL;
 	req->file = NULL;
-	req->ctx = ctx;
-	req->link = NULL;
 	req->fixed_rsrc_refs = NULL;
 	/* one is dropped after submission, the other at completion */
 	atomic_set(&req->refs, 2);
 	req->task = current;
-	req->result = 0;
 
 	/* enforce forwards compatibility on users */
 	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
-- 
2.32.0

