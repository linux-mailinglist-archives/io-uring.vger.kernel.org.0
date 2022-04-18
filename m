Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65387505C93
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 18:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240262AbiDRQqr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 12:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237766AbiDRQqp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 12:46:45 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60124326E9
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 09:44:06 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id b5so8886252ile.0
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 09:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NywPTJb191m8SQ3eOQvJuBxq8MsoU/SK/wgmhn+UG4Q=;
        b=onB0/AXTnvFkN0sXc7AgI4LaBiq1pGcCd9QQBFyTtzCy08br7RI+f2bpvhWlD6TaGN
         hYLqtode/5LHu80SxDOgCANVqMO2t6nkCM1F8yhLt9bM4CknuBKolJ+6ooWn4qFRehjN
         SEWAcN+ZNB2WSGGU8PZujssBgcNMr2MPDk0hg5qh/JhzkK1RdOTRMrx58h3lwDTP3yIy
         xklfS6mRhETKUEI9ZC8aisB+2fPIEh1vdznezb0KomWWkE63zlfmqe+ruCWt7xxKFgeh
         4Rm5j+vEvxHQsC8uPuazPiMjQEg7MXITs0p7PIhdAaGAwWLOZHgkGArPNVdrV4Az+OGa
         AWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NywPTJb191m8SQ3eOQvJuBxq8MsoU/SK/wgmhn+UG4Q=;
        b=PmZ6kz+ugjJY1ErL/2daST5fv7c1aKt8cGLXsVf2xgU46PJ3r7xQ2b40AkWQfn5Avm
         Nc+IUPciAIEZydgN4KwOkyBA5CY4R/Kn/PCLX1DC40jCoWHj1jLZkiuPqwxUxP6qmZWl
         vQ31JoNduoDsldpwMdubJVmS5I7EgiJ46hqbI2lfPhDuSFfQK2L0ystKdUNYMdiIipvW
         aakhSFDFbQYr8pJbjFylHp2S+KzG6XV3lWMLjpfh29rYVUxJKQ92h4rTVGpHZ/PFki4L
         H2Q+omPpxl3cLn45JXl6b2BuDqiShzCdiB+RZ4/J4Roa51b/2YUpjsdH07MHgMonECLP
         7VWA==
X-Gm-Message-State: AOAM532CZhrH38vY9pYEzvsmTYqUNbYLJCGGr0M6xDmmBXh9suZ2gSvi
        RHfX+YOxC1qiyci1iVChsCk31aJ2hFKqFQ==
X-Google-Smtp-Source: ABdhPJz7oMsx5MWXHLWP69ugYB7IswNKn7BZokoGpP2PUic9bHR1LT/HB4+d3eZxks4f7bDV7/kEOg==
X-Received: by 2002:a05:6e02:13e6:b0:2ca:a5b3:fa34 with SMTP id w6-20020a056e0213e600b002caa5b3fa34mr5366824ilj.273.1650300245483;
        Mon, 18 Apr 2022 09:44:05 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y19-20020a056e020f5300b002cc33e5997dsm1188926ilj.63.2022.04.18.09.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 09:44:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring: remove dead 'poll_only' argument to io_poll_cancel()
Date:   Mon, 18 Apr 2022 10:43:58 -0600
Message-Id: <20220418164402.75259-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220418164402.75259-1-axboe@kernel.dk>
References: <20220418164402.75259-1-axboe@kernel.dk>
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

It's only called from one location, and it always passes in 'false'.
Kill the argument, and just pass in 'false' to io_poll_find().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6988bdc182e4..c0f8c5b15f2f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6282,11 +6282,10 @@ static bool io_poll_disarm(struct io_kiocb *req)
 	return true;
 }
 
-static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr,
-			  bool poll_only)
+static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
 	__must_hold(&ctx->completion_lock)
 {
-	struct io_kiocb *req = io_poll_find(ctx, sqe_addr, poll_only);
+	struct io_kiocb *req = io_poll_find(ctx, sqe_addr, false);
 
 	if (!req)
 		return -ENOENT;
@@ -6774,7 +6773,7 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
 		return 0;
 
 	spin_lock(&ctx->completion_lock);
-	ret = io_poll_cancel(ctx, sqe_addr, false);
+	ret = io_poll_cancel(ctx, sqe_addr);
 	if (ret != -ENOENT)
 		goto out;
 
-- 
2.35.1

