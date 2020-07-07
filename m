Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935D2216DE8
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 15:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgGGNiZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 09:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgGGNiZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 09:38:25 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02F5C061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 06:38:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z15so33888761wrl.8
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 06:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UEyV0o7zVG1T1/RiVBG1ivyIGLNkJbjKf5rwvw2AT8E=;
        b=ZR2FrtijDUZgpXT+XmKhtREWTgL3N0UFm+OCOIjTcnvOLasInfAE063HqqOp2HgnjT
         sFUPstUQncRG5HLSPBiuushSHN7eTUfV7wlsMGkmLbz04EUWc2LfltyIEqMyf/1h62z8
         i2Pi8thAsCUMNJo6y0M2W3vRlM9avOhIORgN8BOwtdB1Ss0WPXTvfnHKN+r/2LlF4ERD
         qaJ2mq0GrWeExl59nf5bMFPs4L67JoIL87FH4oPyA3XOVymYf6SqYRQoDVgBGCNnwa04
         Uf9P3OC4KjIUp8xXFk8PE8t0+j65CqwYo+jWiYIWYadqtvmRrlTCUQcuwlL6ZMLgHCvi
         3M/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UEyV0o7zVG1T1/RiVBG1ivyIGLNkJbjKf5rwvw2AT8E=;
        b=EXDgQkhrNjFjY54uSJLMXXZex+xr2CxCQIIpiPuktls0rZHTSN8pHABYm/ZRAczBs9
         t8SLFUyjEwnahbOuiy+lR3vBIMbgcVjcYTci2eC1rcxMa3dV8cEuImHI6iycSnNWQscI
         VDWn/cznd2RppF9GeVy+aR5sOo4g8Lt8g6HEz2rqPJey2KscI5ZQ5O3qE+GHd+/IE+W1
         fx2otwlQqxNwjE0uLNgB6wV3gIz5FMb6Cex2LnhHf4XwKNKTRPo2iuhTZqlSjeqydQ50
         j192REdq6iD61sKrmIUcqrxcs0im/xKLalo0un5Gh9/8cfr7cJvDeVH363r8BqDfGO4y
         OPZg==
X-Gm-Message-State: AOAM532yuaIrpgq1i45pYxyOczgO4VxuYYkgOY5xhruXoG/i+gc+y4Uz
        CvHYbCCizTDjidpdmkZ6BXE=
X-Google-Smtp-Source: ABdhPJxMQWzVB4ChWUDzbgWDxGFLuHjXLJ0STiCIUNB8k1YCO8eqHLD36RSX6qCySvI5ACYXpYf/kg==
X-Received: by 2002:adf:e44c:: with SMTP id t12mr27406618wrm.103.1594129103434;
        Tue, 07 Jul 2020 06:38:23 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id 14sm1093663wmk.19.2020.07.07.06.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 06:38:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: don't burn CPU for iopoll on exit
Date:   Tue,  7 Jul 2020 16:36:22 +0300
Message-Id: <17d50328c1696862a16624bc64134839b4b6d5fc.1594128832.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594128832.git.asml.silence@gmail.com>
References: <cover.1594128832.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First of all don't spin in io_ring_ctx_wait_and_kill() on iopoll.
Requests won't complete faster because of that, but only lengthen
io_uring_release().

The same goes for offloaded cleanup in io_ring_exit_work() -- it
already has waiting loop, don't do blocking active spinning.

For that, pass min=0 into io_iopoll_[try_]reap_events(), so it won't
actively spin. Leave the function if io_do_iopoll() there can't
complete a request to sleep in io_ring_exit_work().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9c3f9ccb850d..bcf6bf799a61 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2048,7 +2048,7 @@ static int io_iopoll_getevents(struct io_ring_ctx *ctx, unsigned int *nr_events,
  * We can't just wait for polled events to come to us, we have to actively
  * find and complete them.
  */
-static void io_iopoll_reap_events(struct io_ring_ctx *ctx)
+static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 {
 	if (!(ctx->flags & IORING_SETUP_IOPOLL))
 		return;
@@ -2057,8 +2057,11 @@ static void io_iopoll_reap_events(struct io_ring_ctx *ctx)
 	while (!list_empty(&ctx->poll_list)) {
 		unsigned int nr_events = 0;
 
-		io_do_iopoll(ctx, &nr_events, 1);
+		io_do_iopoll(ctx, &nr_events, 0);
 
+		/* let it sleep and repeat later if can't complete a request */
+		if (nr_events == 0)
+			break;
 		/*
 		 * Ensure we allow local-to-the-cpu processing to take place,
 		 * in this case we need to ensure that we reap all events.
@@ -7634,7 +7637,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		ctx->sqo_mm = NULL;
 	}
 
-	io_iopoll_reap_events(ctx);
 	io_sqe_buffer_unregister(ctx);
 	io_sqe_files_unregister(ctx);
 	io_eventfd_unregister(ctx);
@@ -7701,11 +7703,8 @@ static int io_remove_personalities(int id, void *p, void *data)
 
 static void io_ring_exit_work(struct work_struct *work)
 {
-	struct io_ring_ctx *ctx;
-
-	ctx = container_of(work, struct io_ring_ctx, exit_work);
-	if (ctx->rings)
-		io_cqring_overflow_flush(ctx, true);
+	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
+					       exit_work);
 
 	/*
 	 * If we're doing polled IO and end up having requests being
@@ -7713,11 +7712,11 @@ static void io_ring_exit_work(struct work_struct *work)
 	 * we're waiting for refs to drop. We need to reap these manually,
 	 * as nobody else will be looking for them.
 	 */
-	while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20)) {
-		io_iopoll_reap_events(ctx);
+	do {
 		if (ctx->rings)
 			io_cqring_overflow_flush(ctx, true);
-	}
+		io_iopoll_try_reap_events(ctx);
+	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 	io_ring_ctx_free(ctx);
 }
 
@@ -7733,10 +7732,10 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	if (ctx->io_wq)
 		io_wq_cancel_all(ctx->io_wq);
 
-	io_iopoll_reap_events(ctx);
 	/* if we failed setting up the ctx, we might not have any rings */
 	if (ctx->rings)
 		io_cqring_overflow_flush(ctx, true);
+	io_iopoll_try_reap_events(ctx);
 	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	queue_work(system_wq, &ctx->exit_work);
-- 
2.24.0

