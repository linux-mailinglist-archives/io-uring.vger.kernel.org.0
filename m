Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B66738215F
	for <lists+io-uring@lfdr.de>; Sun, 16 May 2021 23:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhEPV7z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 May 2021 17:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhEPV7z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 May 2021 17:59:55 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9925C061573
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:38 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id o127so2494867wmo.4
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IL+wDMao23tguWzID1fsZvYRSqOe0ppZ0QJNQQLB470=;
        b=jIseCtKVZpjg838m2cSLjfkPZKxWXcvcTEgMOelZhH67d59i1HIqMiUrd+tRLDsifM
         SiTCLTflPPrfMleOvztmhDES2/ecZqdXEVunUAzPYEKj+ynh8cmsLUZfYOMlUd0JeWb4
         GbfkIz+9+boNA0Imcs1yxb5GoYQX0KRuUp6QQ2L1jw7fgmDmRoNDPC58TgXu7+OUWjL+
         oYUg14S+7yRsiuZ5mlRA0r7zmirwWoaYjju4Gopw+NdvA1YCSpfh4RH85u7KzTHnlsh0
         CcvHYTxdLe1jj95M2fpaIPp4t6q/EWaDOoox2ye9FevQkERAhFk+FegvlfVM+aZ8OiHX
         uCwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IL+wDMao23tguWzID1fsZvYRSqOe0ppZ0QJNQQLB470=;
        b=m3ClgteomZsUdWMgAMBu8Kr1BliE2/gDsNWbwNIgcntZdeKsY+43rT5eCETexXaZnt
         lxlrWNgpLgP+1H1UeMLyJYBQOyZHMcJFQ98wKBC0i882+A62/lddqWtH8MYtXXjuNXKO
         5XIcs2sULf5E1+knruX6KMe1p6ZRd8xtyuaddy9R3VJkTVz1Sscpc4QpedEC7kkIXblP
         dgxJpQS3iF8wvVXEwAXY8T+gi5FGtPDv/k7HdGo8CTZjpurwuyhUVffwH0JrG7T7ob6B
         YNt31M9tT/X5XMuidLXK9JSn7EyP0gve4Mv3Q2j4MLxVFJLXGY2kA1ew7SGfFyrxgHbc
         2Snw==
X-Gm-Message-State: AOAM532TzPqQW97D7qXZOw7giTYrfMEC5Td8JcS/JmxZ1h+TXNUpNrbx
        tUzD8amX2WdIZ5qajwG2GrzWeLCnmJs=
X-Google-Smtp-Source: ABdhPJw3a4L9xj0g4iRqeQJk8K7L7RgnJEi5mkjz252y4zEHgWcUxL1ZFMN183EGby53xX1Lc/+UZw==
X-Received: by 2002:a1c:638b:: with SMTP id x133mr20141946wmb.182.1621202317750;
        Sun, 16 May 2021 14:58:37 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.7])
        by smtp.gmail.com with ESMTPSA id p10sm13666365wmq.14.2021.05.16.14.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 14:58:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 13/13] io_uring: don't bounce submit_state cachelines
Date:   Sun, 16 May 2021 22:58:12 +0100
Message-Id: <290cb5412b76892e8631978ee8ab9db0c6290dd5.1621201931.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621201931.git.asml.silence@gmail.com>
References: <cover.1621201931.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

struct io_submit_state contains struct io_comp_state and so
locked_free_*, that renders cachelines around ->locked_free* being
invalidated on most non-inline completions, that may terrorise caches if
submissions and completions are done by different tasks.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a0b3a9c99044..e387ce687f4d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -298,11 +298,8 @@ struct io_sq_data {
 struct io_comp_state {
 	struct io_kiocb		*reqs[IO_COMPL_BATCH];
 	unsigned int		nr;
-	unsigned int		locked_free_nr;
 	/* inline/task_work completion list, under ->uring_lock */
 	struct list_head	free_list;
-	/* IRQ completion list, under ->completion_lock */
-	struct list_head	locked_free_list;
 };
 
 struct io_submit_link {
@@ -379,6 +376,9 @@ struct io_ring_ctx {
 	} ____cacheline_aligned_in_smp;
 
 	struct io_submit_state		submit_state;
+	/* IRQ completion list, under ->completion_lock */
+	struct list_head	locked_free_list;
+	unsigned int		locked_free_nr;
 
 	struct io_rings	*rings;
 
@@ -1184,7 +1184,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_llist_head(&ctx->rsrc_put_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	INIT_LIST_HEAD(&ctx->submit_state.comp.free_list);
-	INIT_LIST_HEAD(&ctx->submit_state.comp.locked_free_list);
+	INIT_LIST_HEAD(&ctx->locked_free_list);
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -1587,8 +1587,6 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 	 * free_list cache.
 	 */
 	if (req_ref_put_and_test(req)) {
-		struct io_comp_state *cs = &ctx->submit_state.comp;
-
 		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
 			if (req->flags & (REQ_F_LINK_TIMEOUT | REQ_F_FAIL))
 				io_disarm_next(req);
@@ -1599,8 +1597,8 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 		}
 		io_dismantle_req(req);
 		io_put_task(req->task, 1);
-		list_add(&req->compl.list, &cs->locked_free_list);
-		cs->locked_free_nr++;
+		list_add(&req->compl.list, &ctx->locked_free_list);
+		ctx->locked_free_nr++;
 	} else {
 		if (!percpu_ref_tryget(&ctx->refs))
 			req = NULL;
@@ -1655,8 +1653,8 @@ static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 					struct io_comp_state *cs)
 {
 	spin_lock_irq(&ctx->completion_lock);
-	list_splice_init(&cs->locked_free_list, &cs->free_list);
-	cs->locked_free_nr = 0;
+	list_splice_init(&ctx->locked_free_list, &cs->free_list);
+	ctx->locked_free_nr = 0;
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
@@ -1672,7 +1670,7 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 	 * locked cache, grab the lock and move them over to our submission
 	 * side cache.
 	 */
-	if (READ_ONCE(cs->locked_free_nr) > IO_COMPL_BATCH)
+	if (READ_ONCE(ctx->locked_free_nr) > IO_COMPL_BATCH)
 		io_flush_cached_locked_reqs(ctx, cs);
 
 	nr = state->free_reqs;
-- 
2.31.1

