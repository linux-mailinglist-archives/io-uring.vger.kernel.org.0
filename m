Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3450501CA2
	for <lists+io-uring@lfdr.de>; Thu, 14 Apr 2022 22:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbiDNU0x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Apr 2022 16:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346281AbiDNU0w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Apr 2022 16:26:52 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8869112A
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 13:24:25 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v12so5614184plv.4
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 13:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K4W7WEl83jCoTRnscUpnChJIi8T6KY40IoaO2FqVGXk=;
        b=cmiLEW0FRBoyVHyxh0E+195CvKXVzlRT/HneAZ/Tdr4WrF59L6LX2jB5YOYs/DVO0u
         Mve9nkYyDg+RTHe0AbWb/QbnrnCIhPI3EWIoifOoyrRJV1yBpDSsSmTmYvB4cdcNwaLk
         db1OppGnLESNjd2ZsfhEqvkNqynUMWsUIiTyGnlDlVhJ9USB39doBepm941tee9itw18
         WtBn0+5xLwFG3oucDAjDoMhPmAQPCJdVMoI1HfySIskaroW5WXfR0OV1ihoJdUhRo8Hy
         NnzOkEYz7zXMKki4HJtbcaONtOGqP+rrStDDhRBot9/jFAAm+EbDlooTVFnfQB9AW3gE
         Id2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K4W7WEl83jCoTRnscUpnChJIi8T6KY40IoaO2FqVGXk=;
        b=7Ffg+X0LtZs1t+iyC/mpgqp+O4BctFj5mut577DGww4AK19zEDToy/9q4bkBR5IraO
         T1ogt/JypSJB/48tcIlwx2CtERO53tzJ4T/Cm9wQjK+nO+uYr98A91BuesNWV7PWx5/r
         2GT+o3JVk3l6Hel1yogD3aLiOBTz6ELvO7K3xZH7LhBY35ha8IewML79JxI+UZDT+Sgp
         aVVwlfXgSv87pUlP8DddS3ulBQ/dvtEjwkeZdi/OWGPSHbaYke7u3YQOoN/i+QOfa6nw
         SGQrxBaYf6jJevnY+4ER99BFUcUQkN679u8RFNIvQCgfVgTVtujcVJ5rL0bnKB8fVrAG
         cvuw==
X-Gm-Message-State: AOAM530Sh0fya1RtQMzMHHLz3B6axgGXWzGTkSfIss+3hkowOesqiXCs
        b3+RBoNYYhIB59fdLwCYOTfdkEmWnxtM2Q==
X-Google-Smtp-Source: ABdhPJwORJD725xISCELbs12yw+RXc+6uLaM5xGM677YNBfLGRUjByS0F4Y7KlhXXHPpLhwLR7xf9A==
X-Received: by 2002:a17:90a:ff17:b0:1cb:a182:9b05 with SMTP id ce23-20020a17090aff1700b001cba1829b05mr340739pjb.1.1649967865004;
        Thu, 14 Apr 2022 13:24:25 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id v16-20020a62a510000000b0050759c9a891sm689365pfm.6.2022.04.14.13.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 13:24:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: rename io_cancel_data->user_data to just 'data'
Date:   Thu, 14 Apr 2022 14:24:18 -0600
Message-Id: <20220414202419.201614-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220414202419.201614-1-axboe@kernel.dk>
References: <20220414202419.201614-1-axboe@kernel.dk>
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
index c3955b9709c6..0ef8401b6552 100644
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
@@ -6812,7 +6812,7 @@ static int io_try_cancel_userdata(struct io_kiocb *req,
 		goto out;
 
 	spin_lock_irq(&ctx->timeout_lock);
-	ret = io_timeout_cancel(ctx, cd->user_data);
+	ret = io_timeout_cancel(ctx, cd->data);
 	spin_unlock_irq(&ctx->timeout_lock);
 out:
 	spin_unlock(&ctx->completion_lock);
@@ -6838,8 +6838,8 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -7460,8 +7460,8 @@ static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 	if (prev) {
 		if (!(req->task->flags & PF_EXITING)) {
 			struct io_cancel_data cd = {
-				.ctx		= req->ctx,
-				.user_data	= prev->cqe.user_data,
+				.ctx	= req->ctx,
+				.data	= prev->cqe.user_data,
 			};
 
 			ret = io_try_cancel_userdata(req, &cd);
-- 
2.35.1

