Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED862EC90D
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 04:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbhAGDUE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 22:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbhAGDUE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 22:20:04 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B949C0612F4
        for <io-uring@vger.kernel.org>; Wed,  6 Jan 2021 19:19:23 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id i9so4237186wrc.4
        for <io-uring@vger.kernel.org>; Wed, 06 Jan 2021 19:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/9n4Fh0FnUxBmrZzeim7whS8gMocQu2cYN5rxfNHIFw=;
        b=KxDvO0UBr9AU9cKwIArR8fPeN/AX+m2EELGhPWE/rhm4LcihiUdtZ/L3fYTuFuYxNP
         B1Y2cRsNFoI322L+BNkxNHAv2Kr9onQ2nrtTRl/5tbgXjggXaHs7OcMHXKP9ret6HEx4
         rbyjaI+KHWqSiF971hnQ7ISjIWUYRtz4m7Nh4RDNMlNv8ViBmT6/RjjxbGNbD6PnLI2y
         ndXZENHY8zHx1brg9VVRX0KQ53Nq2BeK0NcZdjP3TKEZEIU8Gehn2wfsCmAaMlSTkfLb
         HLA2ROqWfJnc17rk/ZryLCuBfRvOBAWhFMrQAWTdHG757Vh3jdLfPUKx971y1ItxaKDl
         2LZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/9n4Fh0FnUxBmrZzeim7whS8gMocQu2cYN5rxfNHIFw=;
        b=dXXG7Se4NcHLkCyHl879rJNOYR0jgWzrz0XlFIAbGU37bKUaH2ySeXG7QcasoR8aiT
         pxxDA7POcdZxTh4azFrCQ0ibMPGNcyZ6tiwAhiLMK/RrQaYlUkmP61yNsRPsACHl2Yuw
         GqtLCxjlDpKzu4c5yrD8VJSEmef45um7qf763Xt7J0T+czXZ6vSrYEQdY6MHuw4DtmxM
         SXZ8N51dQbEZS4T4IKJ/4YFEVf0wfeaBCJgB0lu7fXhwHsrlZ7DYaqCn6rYunlwursVy
         gtARCiwgDQ+uD1DD/AZKKIBhuBzLTdPLN4GOKcIqwbwrfve56t33QvJSQBiFg8+9VxAL
         mHjw==
X-Gm-Message-State: AOAM532T+b24GOq8cIrwtG5FoIgyfaf7kgITI+po1P0IbdaRUBFN4cwB
        oNvdEpPSreeZfXd3kC0Qf26b1cIByQt2yQ==
X-Google-Smtp-Source: ABdhPJwyLalAjXrbK4HNnbQctqCgwNubjYKYLpeHsBbuPMhEUJzIwzFMPQbbgj03TMGcZmJx2641GA==
X-Received: by 2002:adf:97dd:: with SMTP id t29mr6753627wrb.357.1609989562413;
        Wed, 06 Jan 2021 19:19:22 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id t1sm6181430wro.27.2021.01.06.19.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 19:19:22 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: synchronise ev_posted() with waitqueues
Date:   Thu,  7 Jan 2021 03:15:43 +0000
Message-Id: <23e9974535690673e92a0e20342fabf61ac108d5.1609988832.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609988832.git.asml.silence@gmail.com>
References: <cover.1609988832.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

waitqueue_active() needs smp_mb() to be in sync with waitqueues
modification, but we miss it in io_cqring_ev_posted*() apart from
cq_wait() case.

Take an smb_mb() out of wq_has_sleeper() making it waitqueue_active(),
and place it a few lines before, so it can synchronise other
waitqueue_active() as well.

The patch doesn't add any additional overhead, so even if there are
no problems currently, it's just safer to have it this way.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 401316fe2ae2..cb57e0360fcb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1700,13 +1700,16 @@ static inline unsigned __io_cqring_events(struct io_ring_ctx *ctx)
 
 static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
+	/* see waitqueue_active() comment */
+	smp_mb();
+
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 	if (ctx->sq_data && waitqueue_active(&ctx->sq_data->wait))
 		wake_up(&ctx->sq_data->wait);
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
-	if (wq_has_sleeper(&ctx->cq_wait)) {
+	if (waitqueue_active(&ctx->cq_wait)) {
 		wake_up_interruptible(&ctx->cq_wait);
 		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
 	}
@@ -1714,13 +1717,16 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 {
+	/* see waitqueue_active() comment */
+	smp_mb();
+
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		if (waitqueue_active(&ctx->wait))
 			wake_up(&ctx->wait);
 	}
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
-	if (wq_has_sleeper(&ctx->cq_wait)) {
+	if (waitqueue_active(&ctx->cq_wait)) {
 		wake_up_interruptible(&ctx->cq_wait);
 		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
 	}
-- 
2.24.0

