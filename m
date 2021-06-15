Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38783A8459
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 17:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhFOPu2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 11:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbhFOPu0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 11:50:26 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC756C06175F
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 08:48:19 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a20so18920386wrc.0
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 08:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eB+Lc3B1H1Fv9Mu1T8/qqrbP8by1BCiZntdvvWYcNdg=;
        b=jyyJaEzKYRfyUe/PJ1mgL+c+a/MjwMhm4Vg0tz29U4CUSZJtM/TnazQAeP/lvHes84
         XBgQdFvHxOaAIbEhAqaenlr+GR7LYFWx6p1nISeSVv/kuezQHKJ28lxeHg1PFSevb63V
         RTjHTGtaUfA6oiqfX5g+Ez/bCDiObaMXnuPj6K9+FSnXe6I6X6ksPPvkkBgo+RUsh8tS
         hUmiiuddqCf1U3+5DStBxAJ2EnAZ/bi59Xxy9sf/fCWWJ0EipNZewQtgiPYQd/Ao8uQi
         vWaHMw7p5t3tV0Nnd8JY3ku1lvGCUsK8S3CajDi3ucFUebzmtvaB/6CYclRCXiilaK33
         X6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eB+Lc3B1H1Fv9Mu1T8/qqrbP8by1BCiZntdvvWYcNdg=;
        b=ED94Dj7/U/mtwHgvzq+2rshShVMZXnMYWob9UUi4U0aggRLj8i6r90qv3FXkkJRior
         GfQLNecfLNVl5DIvf+pEN9j24OA76kVmXMWaJccLozFbLKCO3WsA4i0idrWm/4GjJMMU
         xYny6MRjSwU/SR0JtCZhrIQQPbgLhZImMJqs9fU8QyS72KooBer4686hYos4QfvOc2mm
         0YvwKlB+yXZH1vE90lqDA/t/R3PelE/zQM2MekF//Wh9hMGMF/QLBnmUxjf/5Xl+lnDB
         UCAxfr/0CEC0m2kw3l5drGWPruWh4o6jSB+zSVOFIPxVcXae1zrtCuQrr7dPnUIf8+/P
         oFaw==
X-Gm-Message-State: AOAM531M8XLNJtvT6nPPLUbqgEEec6DLmgWPwdW18S7AIUJj5pOE6GEb
        eZy8uWe2HBA9rmNNqksQn/g=
X-Google-Smtp-Source: ABdhPJybE442YbaTvCAIDUq7Eq1JhZLqQlrl434y3Eof67kv2e8cvmogiqZTxnQXDCB8ftbO21NfdQ==
X-Received: by 2002:adf:eed2:: with SMTP id a18mr26024520wrp.147.1623772098437;
        Tue, 15 Jun 2021 08:48:18 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id o3sm20136378wrm.78.2021.06.15.08.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 08:48:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: switch !DRAIN fast path when possible
Date:   Tue, 15 Jun 2021 16:47:56 +0100
Message-Id: <7f37a240857546a94df6348507edddacab150460.1623772051.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623772051.git.asml.silence@gmail.com>
References: <cover.1623772051.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->drain_used is one way, which is not optimal if users use DRAIN but
very rarely. However, we can just clear it in io_drain_req() when all
drained before requests are gone. Also rename the flag to reflect the
change and be more clear about it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 89dafe73b9e4..07f8ef039938 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -352,7 +352,7 @@ struct io_ring_ctx {
 		unsigned int		eventfd_async: 1;
 		unsigned int		restricted: 1;
 		unsigned int		off_timeout_used: 1;
-		unsigned int		drain_used: 1;
+		unsigned int		drain_active: 1;
 	} ____cacheline_aligned_in_smp;
 
 	/* submission data */
@@ -1346,10 +1346,10 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 
 static void io_commit_cqring(struct io_ring_ctx *ctx)
 {
-	if (unlikely(ctx->off_timeout_used || ctx->drain_used)) {
+	if (unlikely(ctx->off_timeout_used || ctx->drain_active)) {
 		if (ctx->off_timeout_used)
 			io_flush_timeouts(ctx);
-		if (ctx->drain_used)
+		if (ctx->drain_active)
 			io_queue_deferred(ctx);
 	}
 	/* order cqe stores with ring update */
@@ -6004,8 +6004,10 @@ static bool io_drain_req(struct io_kiocb *req)
 
 	/* Still need defer if there is pending req in defer list. */
 	if (likely(list_empty_careful(&ctx->defer_list) &&
-		!(req->flags & REQ_F_IO_DRAIN)))
+		!(req->flags & REQ_F_IO_DRAIN))) {
+		ctx->drain_active = false;
 		return false;
+	}
 
 	seq = io_get_sequence(req);
 	/* Still a chance to pass the sequence check */
@@ -6446,7 +6448,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 
 static inline void io_queue_sqe(struct io_kiocb *req)
 {
-	if (unlikely(req->ctx->drain_used) && io_drain_req(req))
+	if (unlikely(req->ctx->drain_active) && io_drain_req(req))
 		return;
 
 	if (likely(!(req->flags & REQ_F_FORCE_ASYNC))) {
@@ -6572,7 +6574,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	}
 
 	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
-		ctx->drain_used = true;
+		ctx->drain_active = true;
 
 		/*
 		 * Taking sequential execution of a link, draining both sides
-- 
2.31.1

