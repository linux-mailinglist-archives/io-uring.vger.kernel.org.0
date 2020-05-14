Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FA01D41A0
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 01:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgENXXU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 May 2020 19:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbgENXXT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 May 2020 19:23:19 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3410C061A0C
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 16:23:18 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t40so139300pjb.3
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 16:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wjG1lc1bQIYiVS1BuBLq1uMxeCbBrQdLDqyIOMduOHQ=;
        b=R5+NwnukmxCP2C38/95bmPHc8NoW27nlpqLO91MUrMATI6hgM83dHNIKMHmQGgRtnb
         oRI0+/44FMACV20JgNfzhFHh0Rx6LUCxQuyVidKy4W+kekimawqT4wG6O07B0uMcR8T+
         AQJcJbEz6wc8IUzI/5xCwMLzVExRyYFnCcJgjhhsH5Ff16CTlnhGvU0wPVQzjWTjFoh7
         3BehCCQJbaFWrcMjfqve1Mg5A4PdxkuftTKPRM46VxsPPPyvjCSdFPYs4ydTr/Bl5Wu/
         p4Nk13JDBlJXHphPjR7yrmTOnq86DWMWHCI6xTfTiVoUmPd38N7axyZmz0MMMp6cbsU/
         3UmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wjG1lc1bQIYiVS1BuBLq1uMxeCbBrQdLDqyIOMduOHQ=;
        b=SXOb44yGvMy56lnLvh7CtqPfK0epTxFB7hjrfpqHotYzJit2xMknEF4s+c/DKmuFo3
         CkhmI6EKNW04u7ZvnScND1rFBBE7uC557O+mFs8loXct+lOHceQK74KKuvtf24KI7CcS
         U0mQ7K6b37NYFH9wU2eZUf69k2y+0tioHZK8tg+DR9Q2osbWya1f2q3cGEFSOdhnAZ5i
         hmXrqFCHy48ym+fVB+wZZjGL97Ty9U1efMFpIQUM6PAxOdPuRwofgHRg+E88wT7cI9k/
         7o4A6ewA2K7BsTJcpvzeIsii/FQSBwNgOcttaOR/h/2HmopOfQZ1EHGfqIV5uoM9PvU5
         yYCw==
X-Gm-Message-State: AOAM532yrS2kw0LrOjqIRZXUag5IMXXPDhpx3WyMUJHs+XLZJ/3Ie0pX
        4wHwA817xYmb3ERwXdghPZgv0Fq1DHY=
X-Google-Smtp-Source: ABdhPJwZEfqD90A0EnaboWHiwpQVUPqjH8dvln8Vg5vWj6AJzWHXLtnntAg0IgSwmnkJ6CW4vdTf4Q==
X-Received: by 2002:a17:902:c68c:: with SMTP id r12mr881314plx.137.1589498597887;
        Thu, 14 May 2020 16:23:17 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21cf::15f4? ([2620:10d:c090:400::5:85d5])
        by smtp.gmail.com with ESMTPSA id f136sm253203pfa.59.2020.05.14.16.23.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 16:23:17 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: name sq thread and ref completions
Message-ID: <82828d81-b5b1-53d4-29a4-aed141f01d1b@kernel.dk>
Date:   Thu, 14 May 2020 17:23:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We used to have three completions, now we just have two. With the two,
let's not allocate them dynamically, just embed then in the ctx and
name them appropriately.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d2e37215d05a..414e940323d4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -279,8 +279,8 @@ struct io_ring_ctx {
 
 	const struct cred	*creds;
 
-	/* 0 is for ctx quiesce/reinit/free, 1 is for sqo_thread started */
-	struct completion	*completions;
+	struct completion	ref_comp;
+	struct completion	sq_thread_comp;
 
 	/* if all else fails... */
 	struct io_kiocb		*fallback_req;
@@ -883,7 +883,7 @@ static void io_ring_ctx_ref_free(struct percpu_ref *ref)
 {
 	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
 
-	complete(&ctx->completions[0]);
+	complete(&ctx->ref_comp);
 }
 
 static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
@@ -899,10 +899,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	if (!ctx->fallback_req)
 		goto err;
 
-	ctx->completions = kmalloc(2 * sizeof(struct completion), GFP_KERNEL);
-	if (!ctx->completions)
-		goto err;
-
 	/*
 	 * Use 5 bits less than the max cq entries, that should give us around
 	 * 32 entries per hash list if totally full and uniformly spread.
@@ -925,8 +921,8 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	ctx->flags = p->flags;
 	init_waitqueue_head(&ctx->cq_wait);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
-	init_completion(&ctx->completions[0]);
-	init_completion(&ctx->completions[1]);
+	init_completion(&ctx->ref_comp);
+	init_completion(&ctx->sq_thread_comp);
 	idr_init(&ctx->io_buffer_idr);
 	idr_init(&ctx->personality_idr);
 	mutex_init(&ctx->uring_lock);
@@ -942,7 +938,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 err:
 	if (ctx->fallback_req)
 		kmem_cache_free(req_cachep, ctx->fallback_req);
-	kfree(ctx->completions);
 	kfree(ctx->cancel_hash);
 	kfree(ctx);
 	return NULL;
@@ -5933,7 +5928,7 @@ static int io_sq_thread(void *data)
 	unsigned long timeout;
 	int ret = 0;
 
-	complete(&ctx->completions[1]);
+	complete(&ctx->sq_thread_comp);
 
 	old_fs = get_fs();
 	set_fs(USER_DS);
@@ -6212,7 +6207,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 static void io_sq_thread_stop(struct io_ring_ctx *ctx)
 {
 	if (ctx->sqo_thread) {
-		wait_for_completion(&ctx->completions[1]);
+		wait_for_completion(&ctx->sq_thread_comp);
 		/*
 		 * The park is a bit of a work-around, without it we get
 		 * warning spews on shutdown with SQPOLL set and affinity
@@ -7241,7 +7236,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 				ring_pages(ctx->sq_entries, ctx->cq_entries));
 	free_uid(ctx->user);
 	put_cred(ctx->creds);
-	kfree(ctx->completions);
 	kfree(ctx->cancel_hash);
 	kmem_cache_free(req_cachep, ctx->fallback_req);
 	kfree(ctx);
@@ -7293,7 +7287,7 @@ static void io_ring_exit_work(struct work_struct *work)
 	if (ctx->rings)
 		io_cqring_overflow_flush(ctx, true);
 
-	wait_for_completion(&ctx->completions[0]);
+	wait_for_completion(&ctx->ref_comp);
 	io_ring_ctx_free(ctx);
 }
 
@@ -7992,7 +7986,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		 * after we've killed the percpu ref.
 		 */
 		mutex_unlock(&ctx->uring_lock);
-		ret = wait_for_completion_interruptible(&ctx->completions[0]);
+		ret = wait_for_completion_interruptible(&ctx->ref_comp);
 		mutex_lock(&ctx->uring_lock);
 		if (ret) {
 			percpu_ref_resurrect(&ctx->refs);
@@ -8069,7 +8063,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		/* bring the ctx back to life */
 		percpu_ref_reinit(&ctx->refs);
 out:
-		reinit_completion(&ctx->completions[0]);
+		reinit_completion(&ctx->ref_comp);
 	}
 	return ret;
 }
-- 
2.26.2

-- 
Jens Axboe

