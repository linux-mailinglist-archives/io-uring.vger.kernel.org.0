Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D9E502AFE
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 15:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239827AbiDONiH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 09:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354023AbiDONfy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 09:35:54 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97CF5EDFC
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 06:33:26 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id k14so7328276pga.0
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 06:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8ckQmcTiJ5spl0HMC0qkkSy/ZtkGNYsOJd9N4yoJIbo=;
        b=D+z53gEwsZWNOWyXdQhsRdtcNPv5fIxrNkUKvB6+n86ZIiWQ9E/7S+lUFGbv/yxYbI
         YWN0XtHZITBydmxFB9Ze3wuH0Yh+twNhZfMzwedbIB1hLFKfiPZeZiAXBqrlepekSg81
         eRTVsc6e0Ueig45ZIvEnUuBNHySOK9jYzGxrvZ+Q9MJRnKpVu37V2ZmR6CslWScSo4ks
         4VARX38YQO6QlRva9w6JH7dCBo/8OWQ6o0EIiMMoqvExBB61ihCvOsBFqmIg91lPaSnR
         nM8MGQJG38pX2vp3afkAkzKxLhwqEC8w7Bk31wBLmARROVgJHHWuzz3tN/U3B5NGIsp/
         fAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8ckQmcTiJ5spl0HMC0qkkSy/ZtkGNYsOJd9N4yoJIbo=;
        b=VFBzAcBbFvahxtmapB9IFzYL+4yjVK4fTJ0+PHvVIZRxA5u8a6rwSsyqIwEfcR9rbE
         6MfrRXvxS0qJksis9qLL6D+6c3pHlJyRh8nUqbyUd34mvyBkfyGFI1lhCyucg9s5UCPi
         lefYoRiq/6+yh38e0KIkTzpcr7ZokIGHcEm3coTaze+2HVNOPnfOZjk5bprQw8rN6Cpe
         INR6KecuPak+oPhbD/JU0JuVaFjUUePGkAAK6kDPKjSGoqKfQbcQ9acnyPd3aGui/mnO
         ypfsrUJqla3V04z1m3aA6X1M1R2kDkveLq0hubNUS3IRyLLYommR3mg9aYUgupDa/nBA
         Xgag==
X-Gm-Message-State: AOAM533XUCOXBJQ1LQgQNl6uabxR5bWn1LunQh0WqS6okdyEHHjyh/0U
        yZcon6FkEPXrQDF1Tm3z3Qa3F/SQUDueeA==
X-Google-Smtp-Source: ABdhPJymDqR+syaC7RMyltnEwmtpAJevGqsfo9sLAzJpVimea5DEaewIoRGrLVDRZIKHIIp1zAdHwA==
X-Received: by 2002:a05:6a00:1c63:b0:505:cc7f:a21b with SMTP id s35-20020a056a001c6300b00505cc7fa21bmr8879347pfw.9.1650029605922;
        Fri, 15 Apr 2022 06:33:25 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id n19-20020a635c53000000b0039dc2ea9876sm4576604pgm.49.2022.04.15.06.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 06:33:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: rename io_cancel_data->user_data to just 'data'
Date:   Fri, 15 Apr 2022 07:33:17 -0600
Message-Id: <20220415133319.75077-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415133319.75077-1-axboe@kernel.dk>
References: <20220415133319.75077-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for putting other data in there than just the user_data,
rename it to a data.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a45ab678a455..6dcf3ad7ee99 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6318,13 +6318,13 @@ static bool io_poll_disarm(struct io_kiocb *req)
 
 struct io_cancel_data {
 	struct io_ring_ctx *ctx;
-	u64 user_data;
+	u64 data;
 };
 
 static int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 	__must_hold(&ctx->completion_lock)
 {
-	struct io_kiocb *req = io_poll_find(ctx, cd->user_data, false);
+	struct io_kiocb *req = io_poll_find(ctx, cd->data, false);
 
 	if (!req)
 		return -ENOENT;
@@ -6762,7 +6762,7 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_cancel_data *cd = data;
 
-	return req->ctx == cd->ctx && req->cqe.user_data == cd->user_data;
+	return req->ctx == cd->ctx && req->cqe.user_data == cd->data;
 }
 
 static int io_async_cancel_one(struct io_uring_task *tctx,
@@ -6811,7 +6811,7 @@ static int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
 		goto out;
 
 	spin_lock_irq(&ctx->timeout_lock);
-	ret = io_timeout_cancel(ctx, cd->user_data);
+	ret = io_timeout_cancel(ctx, cd->data);
 	spin_unlock_irq(&ctx->timeout_lock);
 out:
 	spin_unlock(&ctx->completion_lock);
@@ -6837,8 +6837,8 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_cancel_data cd = {
-		.ctx		= ctx,
-		.user_data	= req->cancel.addr,
+		.ctx	= ctx,
+		.data	= req->cancel.addr,
 	};
 	struct io_tctx_node *node;
 	int ret;
@@ -7459,8 +7459,8 @@ static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 	if (prev) {
 		if (!(req->task->flags & PF_EXITING)) {
 			struct io_cancel_data cd = {
-				.ctx		= req->ctx,
-				.user_data	= prev->cqe.user_data,
+				.ctx	= req->ctx,
+				.data	= prev->cqe.user_data,
 			};
 
 			ret = io_try_cancel(req, &cd);
-- 
2.35.1

