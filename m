Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7FB20559C
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 17:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732885AbgFWPQk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 11:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732781AbgFWPQj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 11:16:39 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88493C061573
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 08:16:38 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id w9so5728109ilk.13
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 08:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GrwYO8pAuDiaJ/H17WReOF9BV3SWH9L4TQFIcqgEGmQ=;
        b=GbFNXJMkdreExGCYgdQT8s9CApbWLA9G0g0uHOlNyn9I4onuy16aBGGGDB6a7Gq2+M
         QseDmRGCi7rlarNh661rPI3JHFBdApgjelIXNGUmvfvdMqvc379GPv8wI9ImVqrfGWq4
         lPoCE854W0rFTfIEmhagMLaj4vNTXHuKheiqTJGy0IQYGzwNCmSrEvrBounDGoZSz6Gg
         AOgF1t1ON0aPWoGleUQakUVOL/hFPxj+wlM0IDzFes+icvYmfwDC7ioZsYvmwc4Uo+cS
         OInqbY3Wz4jfD+1daSRn0dLO85/cTwMFDAb2K2x+Mpv9ptmX/oaozarHYDgU0o1r6x2/
         Mj1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GrwYO8pAuDiaJ/H17WReOF9BV3SWH9L4TQFIcqgEGmQ=;
        b=llb/4EHPEDw4uw7vrnWTBCmIGfYwY2FZ1+zf3ZwoqUasT5FaGhIGF2nPykETHcqE9G
         CGr+mWGOUiv7KGBuiNTlPvFN8pt+SDiXUFMKx7syfzgRw9cb5JgAryvo4ftEU7mkopHT
         ZAUntQh7xRbWVzNOMz4UJwUzVHKsB7F9eMaiNLgytYfGFZDsVkCTtVSUUutaNdpCOSJt
         ngq9+wwkAXVENVEOSYdgWo4i2lmEvDPFIZi3SKOeSj4nR/9ki+HlqU8qouWo+xnyXQLr
         VZtB3n5A6Fr+5T577TxRu7qvGxifPegiModfmWJ5Q/1vTIe0ojVKu3wXidZXSBgBbbO7
         CSIw==
X-Gm-Message-State: AOAM5314t+KNBLE+gjDZrJCH9zam4macoCsQjXXzWceYI5ceAT1hFELl
        LNDR77i7WtQhrpaivXiYzt5Y0hLB5Tk=
X-Google-Smtp-Source: ABdhPJwQFix0dIbyiZM7+0iEkFI1wPs2fnwkOoJMn0RrRsgxwOV3iGFSnWRV7s3f458WmW8QLP+IcQ==
X-Received: by 2002:a92:cd49:: with SMTP id v9mr22755643ilq.272.1592925397032;
        Tue, 23 Jun 2020 08:16:37 -0700 (PDT)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k1sm4275180ilr.35.2020.06.23.08.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 08:16:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     xuanzhuo@linux.alibaba.com, Dust.li@linux.alibaba.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: add 'io_comp_state' to struct io_submit_state
Date:   Tue, 23 Jun 2020 09:16:26 -0600
Message-Id: <20200623151629.17197-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623151629.17197-1-axboe@kernel.dk>
References: <20200623151629.17197-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No functional changes in this patch, just in preparation for passing back
pending completions to the caller and completing them in a batched
fashion.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0cdf088c56cd..1da5269c9ef7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -678,6 +678,12 @@ struct io_kiocb {
 
 #define IO_IOPOLL_BATCH			8
 
+struct io_comp_state {
+	unsigned int		nr;
+	struct list_head	list;
+	struct io_ring_ctx	*ctx;
+};
+
 struct io_submit_state {
 	struct blk_plug		plug;
 
@@ -687,6 +693,11 @@ struct io_submit_state {
 	void			*reqs[IO_IOPOLL_BATCH];
 	unsigned int		free_reqs;
 
+	/*
+	 * Batch completion logic
+	 */
+	struct io_comp_state	comp;
+
 	/*
 	 * File reference cache
 	 */
@@ -5999,12 +6010,15 @@ static void io_submit_state_end(struct io_submit_state *state)
  * Start submission side cache.
  */
 static void io_submit_state_start(struct io_submit_state *state,
-				  unsigned int max_ios)
+				  struct io_ring_ctx *ctx, unsigned int max_ios)
 {
 	blk_start_plug(&state->plug);
 #ifdef CONFIG_BLOCK
 	state->plug.nowait = true;
 #endif
+	state->comp.nr = 0;
+	INIT_LIST_HEAD(&state->comp.list);
+	state->comp.ctx = ctx;
 	state->free_reqs = 0;
 	state->file = NULL;
 	state->ios_left = max_ios;
@@ -6139,7 +6153,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 
-	io_submit_state_start(&state, nr);
+	io_submit_state_start(&state, ctx, nr);
 
 	ctx->ring_fd = ring_fd;
 	ctx->ring_file = ring_file;
-- 
2.27.0

