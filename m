Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD50149053
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgAXVly (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:41:54 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51567 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728884AbgAXVln (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:41:43 -0500
Received: by mail-wm1-f67.google.com with SMTP id t23so871737wmi.1;
        Fri, 24 Jan 2020 13:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XqgdTKdah3368QSUwGpOYHR15bXUS5e6iC57ePDHsAg=;
        b=mReBx6qAl+LWYY84kGbFOMJwzydpIAfb7xmP3eKyrLJLNZ1xXLnysMgxLrqs+m1OZH
         9ef8jyJvIlw3aDzvs0pgYluEYP7Nh9HrtVf17FoXkmwrQuyndN4rjsqsmX4Splosrl13
         eSiFUMSDvI4uP293CAYsAxUXR3VLYByH07oeVy4PZYYgktn3CEq16BywGwRfKqjkFjAM
         fL4tKX0zwKJ1D+H5fPeSBtwakZujTpTMfCChJKydx2cKaSVuWVvVz/TSPAgwFRKMqAZb
         JZocZQepI5haWgQ5X5GZYUNLT4m9obwQfeRkjG3Z5Z3tx02vAetkwkGx+26smTH9KYhl
         8Z/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XqgdTKdah3368QSUwGpOYHR15bXUS5e6iC57ePDHsAg=;
        b=AJogQ65rOTkUq0XeR6txXg4EErNfmQBT0EXeO0pmgZxKCcmklQ1Iz/viKjMtE4BQty
         4lJZVPF92KpCCv21IVOT+//Lh7xMuLzUHp1UoiGU/a0o2fSg5zfkn0zRn22XA2oRrs30
         FIPCFk6OC7tKGgSCv9tbZmSyZhbo/At4B7Yotp7QOlPVLktMNfJJjKz+SN1tBFPoKh63
         ZTRvlGx4zpRjwSOQYbh3Y9Py4HqNEgKDNot2ZePaOVXyZLsEqK8ZyV7lO9Y37AE2PhOT
         WnkJ5Yn37vVPZUaMV9wXqXxWQeiwzUWCY6jco0p63eyr2h+tTmrouiPw6lwXnTAWH3pk
         3dmQ==
X-Gm-Message-State: APjAAAXSfn8BpdjIr+0rv0EtFPMVnIMCBTtxl83t2GY4ALK7lLGG8IXR
        okopSkGH0HiVk5vuEdYoAh4=
X-Google-Smtp-Source: APXvYqxWn96D2GQz/UeZSkOnFQWoIuysZ+hbfpWFPoK7yqDHsR1D72MXo5AsAzK8C/ujgu9iSq64Yw==
X-Received: by 2002:a1c:ac46:: with SMTP id v67mr1016771wme.153.1579902101642;
        Fri, 24 Jan 2020 13:41:41 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id f16sm9203055wrm.65.2020.01.24.13.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:41:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] io_uring: persistent req bulk allocation cache
Date:   Sat, 25 Jan 2020 00:40:30 +0300
Message-Id: <90819c611f4a98ab88ca73deec314fef36fa7383.1579901866.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579901866.git.asml.silence@gmail.com>
References: <cover.1579901866.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Save bulk allocated requests across io_uring_enter(), so lower QD also
could benefit from that. This is not much of an optimisation, and for
current cache sizes would probably affect only offloaded ~QD=1.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f022453e3839..aed19cbe9893 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -834,6 +834,25 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	return NULL;
 }
 
+static void io_init_submit_state(struct io_ring_ctx *ctx)
+{
+	struct io_submit_state *state = &ctx->submit_state;
+
+	state->mm = (ctx->flags & IORING_SETUP_SQPOLL) ? NULL : ctx->sqo_mm;
+
+	state->free_reqs = 0;
+	state->cur_req = 0;
+}
+
+static void io_clear_submit_state(struct io_ring_ctx *ctx)
+{
+	struct io_submit_state *state = &ctx->submit_state;
+
+	if (state->free_reqs)
+		kmem_cache_free_bulk(req_cachep, state->free_reqs,
+					&state->reqs[state->cur_req]);
+}
+
 static inline bool __req_need_defer(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1132,10 +1151,9 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 
 	if (!state->free_reqs) {
-		size_t sz;
+		size_t sz = ARRAY_SIZE(state->reqs);
 		int ret;
 
-		sz = min_t(size_t, state->ios_left, ARRAY_SIZE(state->reqs));
 		ret = kmem_cache_alloc_bulk(req_cachep, gfp, sz, state->reqs);
 
 		/*
@@ -4759,9 +4777,6 @@ static void io_submit_end(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 
 	io_file_put(state);
-	if (state->free_reqs)
-		kmem_cache_free_bulk(req_cachep, state->free_reqs,
-					&state->reqs[state->cur_req]);
 	if (state->link)
 		io_queue_link_head(state->link);
 }
@@ -4774,7 +4789,6 @@ static void io_submit_start(struct io_ring_ctx *ctx, unsigned int max_ios,
 {
 	struct io_submit_state *state = &ctx->submit_state;
 
-	state->free_reqs = 0;
 	state->file = NULL;
 	state->ios_left = max_ios;
 
@@ -5762,12 +5776,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 	int ret;
 
 	init_waitqueue_head(&ctx->sqo_wait);
-	mmgrab(current->mm);
-	ctx->sqo_mm = current->mm;
-
-	ctx->submit_state.mm = NULL;
-	if (!(ctx->flags & IORING_SETUP_SQPOLL))
-		ctx->submit_state.mm = ctx->sqo_mm;
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		ret = -EPERM;
@@ -6143,6 +6151,8 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->sqo_mm)
 		mmdrop(ctx->sqo_mm);
 
+	io_clear_submit_state(ctx);
+
 	io_iopoll_reap_events(ctx);
 	io_sqe_buffer_unregister(ctx);
 	io_sqe_files_unregister(ctx);
@@ -6581,6 +6591,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 	if (ret)
 		goto err;
 
+	mmgrab(current->mm);
+	ctx->sqo_mm = current->mm;
+	io_init_submit_state(ctx);
+
 	ret = io_sq_offload_start(ctx, p);
 	if (ret)
 		goto err;
-- 
2.24.0

