Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA944216EE
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbhJDTFp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237495AbhJDTFp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:45 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F094DC061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:03:55 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id bm13so18607370edb.8
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H5JNAGdUaOFE2jqzOu/y+s4fNMvgfxf+4DBiiC7X0Zc=;
        b=TyQP3sV9I24+BW8QECXW04h2GrHQCY28wbcW7FI07y9z5pj2MUsX6as1FRnGdc3NLU
         MvlIxpk9FZCU65R57Z8nsd9d07Tnk7Wl7WRmhb3okcHn56SLCbcma3K1+Ydl7qqtOiZq
         0RN1khD/mCWjYnusfw40jPQylDynMNRizBb6rAvIK3PObwK5gg8O2MYb0I3FWa82Q3Di
         JNEUcxZv3tbHcUDOSknopsaR2kTIFxXa1Xug0WkHMymI9jnSS2vSErkDUKmUSOeSOITe
         iWiqBAzw9+qNnc3wTO4i65kyPtokOyfcmGSlvT1E1VjniWXednNVLsh3TAKH85E5rjjM
         nyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H5JNAGdUaOFE2jqzOu/y+s4fNMvgfxf+4DBiiC7X0Zc=;
        b=O5Y4paN27o+ty4abDwSdF159u3ko8O1ZZck4gPQ/fz40cuZoijEVbizcNyAKKQ1924
         BCJXdWEYQh+rPvVTS2KMITvkIXao3zTTMqyaZeq15OznbJIS+qj+0iayR7O5UD927im0
         SEktNdQZ2CCtoOii3h41Z5BNkgdw770rE48Y1zNA/mwC+X3+ICBx1X7w5mLl6PAxpBWy
         Cn7K7v8720SPxARDAQG9zV5wqtKptdq1srRQoqeWUb8n36RE3OiBM3N8FE13+wmKNHSP
         dL9cizximfOjhDCR9vV7pL43l8kbIeiqQZohhtjBKpMkxhfilwNbs4TXHB2EOtL6sf4v
         BJvw==
X-Gm-Message-State: AOAM533kr7/IynIdNQg5EjeUqC1+gbPIZZrob8t3CsVOloZtvNYcWlpJ
        OMlPMc5agzhiF4Xl3JnT5mnLcKnGKnQ=
X-Google-Smtp-Source: ABdhPJx1n80U8qaVhaRoGln81YVtzMEGJ5JixaHEH1WFXpvEqOOCQS0N2EqQ88+nmYDJ802SEy7C9w==
X-Received: by 2002:a05:6402:4389:: with SMTP id o9mr7842452edc.38.1633374234263;
        Mon, 04 Oct 2021 12:03:54 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:03:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 07/16] io_uring: merge CQ and poll waitqueues
Date:   Mon,  4 Oct 2021 20:02:52 +0100
Message-Id: <00fe603e50000365774cf8435ef5fe03f049c1c9.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->cq_wait and ->poll_wait and waken up in the same manner, use a single
waitqueue for both of them. CQ waiters are queued exclusively, so wake
up should first go over all pollers and that's what we need.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 56c0f7f1610f..b465fba8a0dc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -394,7 +394,6 @@ struct io_ring_ctx {
 		unsigned		cached_cq_tail;
 		unsigned		cq_entries;
 		struct eventfd_ctx	*cq_ev_fd;
-		struct wait_queue_head	poll_wait;
 		struct wait_queue_head	cq_wait;
 		unsigned		cq_extra;
 		atomic_t		cq_timeouts;
@@ -1300,7 +1299,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	ctx->flags = p->flags;
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
-	init_waitqueue_head(&ctx->poll_wait);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
@@ -1621,8 +1619,6 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 		wake_up_all(&ctx->cq_wait);
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
-	if (waitqueue_active(&ctx->poll_wait))
-		wake_up_interruptible(&ctx->poll_wait);
 }
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
@@ -1636,8 +1632,6 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 	}
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
-	if (waitqueue_active(&ctx->poll_wait))
-		wake_up_interruptible(&ctx->poll_wait);
 }
 
 /* Returns true if there are no backlogged entries after the flush */
@@ -9256,7 +9250,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	struct io_ring_ctx *ctx = file->private_data;
 	__poll_t mask = 0;
 
-	poll_wait(file, &ctx->poll_wait, wait);
+	poll_wait(file, &ctx->cq_wait, wait);
 	/*
 	 * synchronizes with barrier from wq_has_sleeper call in
 	 * io_commit_cqring
-- 
2.33.0

