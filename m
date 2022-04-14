Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A271501C9D
	for <lists+io-uring@lfdr.de>; Thu, 14 Apr 2022 22:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbiDNU0v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Apr 2022 16:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346291AbiDNU0u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Apr 2022 16:26:50 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8856F2C6
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 13:24:23 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so6754439pjb.1
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 13:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CMfeq2y50ep3iWgYcSAIfpUtrAVsbY3v5bbfxzN6s+Y=;
        b=G4ZcjkIKTN0FC8jAzHRhtqNM3/wqEHtrKns/q53twcefUN+hrU09Yh50jnSCElKILY
         V4MfUjJdFexo7z9bNdFu4sW/DW+Y5nHb2lYoUs7SUZiYWv04NVInuE8L4ZTZ0MXAYOES
         CY9CVYCLyPxKfHt+PuOQlIsDH2sSRG02EET/svYzmxfmWSdun3Dq7AWoRhMIIR7TntZ3
         k2x/CoPxwD8sKIasqfls7qXM7+YQJX2NqwnZeo+RfPm6KCkl/BhvoNCAOTGlxDyMYulC
         F8QrTqwxNdOMU6PEp8N2QrehG+DEZedc3UOzBEOUnSWYr1hTiFZ13e0ezNYWrcGtgG+X
         R/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CMfeq2y50ep3iWgYcSAIfpUtrAVsbY3v5bbfxzN6s+Y=;
        b=HWzpw7wpeXD45EDwss5BQjHzCUoZ3KL1R75cROGkaChfi3uz9Iy2F8gJCj/l2ESdLO
         Y/6lfC0S5LcSk9fzJVmQex7UGlE9Xc5Khq/Gv00IS/3u5sRVJzkUZP62rBD40ZT8rmsD
         b3GeOlZFP22HyUQ9xO4LsUW29mWvfR9gmktVpxBMrKzCP5mTMHHfETSldRav5mYbZIeS
         CwSobzT9RYrg9nz5coNqhIpU7j8kQAHb79CKwTPz6yC5rsEu69+M1groLBJR95YN6ju7
         pBiOVNp0dHj012GKagPagY5/ernd/NcvLNo7Rvj6jsyxufwMTe73ClVMXVs+Wgsz35Pq
         KxYg==
X-Gm-Message-State: AOAM530+/1fzkF89IfzcUridbLULCTN7flSFakZvaJV+TQoveF5MW0yU
        QUEygyUmnivO0b/F7iLA6uIIpXbFUWCxAw==
X-Google-Smtp-Source: ABdhPJyhJvYDfaN2X9BXtWhJHAuFJGZxVMVmSMeAWl7Q/stJmn/6fc3aDKY/wQ9glttMK/3uisl65Q==
X-Received: by 2002:a17:902:bd87:b0:153:ceb:3a6d with SMTP id q7-20020a170902bd8700b001530ceb3a6dmr49301803pls.146.1649967862734;
        Thu, 14 Apr 2022 13:24:22 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id v16-20020a62a510000000b0050759c9a891sm689365pfm.6.2022.04.14.13.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 13:24:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: remove dead 'poll_only' argument to io_poll_cancel()
Date:   Thu, 14 Apr 2022 14:24:16 -0600
Message-Id: <20220414202419.201614-2-axboe@kernel.dk>
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

It's only called from one location, and it always passes in 'false'.
Kill the argument, and just pass in 'false' to io_poll_find().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d3fc0c5b4e82..878d30a31606 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6316,11 +6316,10 @@ static bool io_poll_disarm(struct io_kiocb *req)
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
@@ -6808,7 +6807,7 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
 		return 0;
 
 	spin_lock(&ctx->completion_lock);
-	ret = io_poll_cancel(ctx, sqe_addr, false);
+	ret = io_poll_cancel(ctx, sqe_addr);
 	if (ret != -ENOENT)
 		goto out;
 
-- 
2.35.1

