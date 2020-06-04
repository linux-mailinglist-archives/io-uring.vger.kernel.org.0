Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B961EE9BF
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2020 19:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgFDRsk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 13:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730094AbgFDRsk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 13:48:40 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6563C08C5C0
        for <io-uring@vger.kernel.org>; Thu,  4 Jun 2020 10:48:38 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u5so3811197pgn.5
        for <io-uring@vger.kernel.org>; Thu, 04 Jun 2020 10:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6DhDBkxGGETbrB7AxN8MMTWj24FupnV7Pw0zc6ln504=;
        b=rAdY3VPGDhpfwOmyh9oKDkwjs34JOyFLbjsyIVh6T6oEBzcQddZIUZsEB3RlnsIzwY
         m7WjlTTTkBMTtkbOHjn1+H3R/OSYaCn9otCoCH/b9AC/Z7wDYiekvZOvidU3GgcDO9Aa
         Cy+D5MVHEvf7kyyNi/DyPkWWarbZ8WY1pInGKGfmPWBRSS6BWxx+eKeOKNDrv+sXHKyL
         Kcyvoeox/OiyvabUaUoo91LNyhgGyNm/h58U0DTUN5P2IhDDIkcWYqfeIjvP0uU6QDUc
         4cw0ztYWmiSMqviojXO6dp3ePVCoQBz4YWH+GfSS4pNNFfsmvCelRuZwycsWrxGy8h2y
         QaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6DhDBkxGGETbrB7AxN8MMTWj24FupnV7Pw0zc6ln504=;
        b=nIVeTZiVb3CjUkLMtJS0E1kQTzyf2K6yI+AtoPq+Eg+xOBC0BpJbrKpwVWHkXa9jRX
         qYi6KHuk05UxRUpislV7z7ZiR2UwZKUHWEtMyS/gbc9VJUO0MriEqJOQFlLDgXG5qrgg
         oCnB236WM6bYhwPUrCnzudQ8zRrRe8JN2aON3oUMNMXtJtWJpSJAXkKvCUEyYB3fJyhk
         W44xTXHHKII3lAMOFGaWp3Z2W25k1N/rRSA7R7qHqM1D0nwoymz1Pc2L2nGXtGJSiRzT
         aFfwtOmbjEWsSt3DFLLOwZPEKtUN37IWQVL+sl3DKhHA5YJDNC24E8ZIvpTU0O+B4f4c
         iykQ==
X-Gm-Message-State: AOAM530ynikeD9e9dGwG1OaHlfTiem1A5BfgKKw9YQqYTGifGbw7e6+8
        1Ha/Low5oUZgMxGlgmp+OL4rg8LIkui4Vw==
X-Google-Smtp-Source: ABdhPJxI+LzTqD+bsprVFs7U+I9PfWsLzDIYhmE48VmuirEwHVS4SkHfemjjS/Ds+UexjV99Ah1dRA==
X-Received: by 2002:aa7:804a:: with SMTP id y10mr5243671pfm.186.1591292918076;
        Thu, 04 Jun 2020 10:48:38 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n9sm6044494pjj.23.2020.06.04.10.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 10:48:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: always plug for any number of IOs
Date:   Thu,  4 Jun 2020 11:48:30 -0600
Message-Id: <20200604174832.12905-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200604174832.12905-1-axboe@kernel.dk>
References: <20200604174832.12905-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently we only plug if we're doing more than two request. We're going
to be relying on always having the plug there to pass down information,
so plug unconditionally.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 70f0f2f940fb..b468fe2e8792 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -669,7 +669,6 @@ struct io_kiocb {
 	};
 };
 
-#define IO_PLUG_THRESHOLD		2
 #define IO_IOPOLL_BATCH			8
 
 struct io_submit_state {
@@ -5910,7 +5909,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			  struct file *ring_file, int ring_fd)
 {
-	struct io_submit_state state, *statep = NULL;
+	struct io_submit_state state;
 	struct io_kiocb *link = NULL;
 	int i, submitted = 0;
 
@@ -5927,10 +5926,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 
-	if (nr > IO_PLUG_THRESHOLD) {
-		io_submit_state_start(&state, nr);
-		statep = &state;
-	}
+	io_submit_state_start(&state, nr);
 
 	ctx->ring_fd = ring_fd;
 	ctx->ring_file = ring_file;
@@ -5945,14 +5941,14 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			io_consume_sqe(ctx);
 			break;
 		}
-		req = io_alloc_req(ctx, statep);
+		req = io_alloc_req(ctx, &state);
 		if (unlikely(!req)) {
 			if (!submitted)
 				submitted = -EAGAIN;
 			break;
 		}
 
-		err = io_init_req(ctx, req, sqe, statep);
+		err = io_init_req(ctx, req, sqe, &state);
 		io_consume_sqe(ctx);
 		/* will complete beyond this point, count as submitted */
 		submitted++;
@@ -5978,8 +5974,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	}
 	if (link)
 		io_queue_link_head(link);
-	if (statep)
-		io_submit_state_end(&state);
+	io_submit_state_end(&state);
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
 	io_commit_sqring(ctx);
-- 
2.27.0

