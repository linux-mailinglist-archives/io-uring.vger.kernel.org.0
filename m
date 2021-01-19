Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10752FBA70
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391714AbhASOzX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394361AbhASNhW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:37:22 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F99CC0613D3
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:38 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id m4so19744024wrx.9
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GIdhOt9ZTh3Agdr4TBIW8TEoAk6IIhqrf9NfWcMkdvU=;
        b=J4f2eCmbEGN+G2e9g8MlfEZvi6INIOu+gbatq4o9q9sLVwKZ6+XHG1EJvcXupTZgEe
         7dHstuR2zLH/eeXc23M5ceLo+stG8ew6qpM8EoqeZdkmn0m9WfI1RGFVYhGC0c6qHIOo
         RkfkHfw+wUqiBmjF2qvAigh3i1N2S7TmvLcdXXOH/2Z9rwnV7dBvgH/+kWhmJhkI8jnS
         OhKX77fibgdTQ5YFQro4o+F0rs3+UIJc090qTRPRKojNMfhosjIpu6NF3yMzWVZvToDE
         MLs/YHjWc4i3TAPNditTgtA82q2vqPfeePEElFcaj0t5qpR+XUnss13GgT95rOeXJZ1Q
         OQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GIdhOt9ZTh3Agdr4TBIW8TEoAk6IIhqrf9NfWcMkdvU=;
        b=J2vVKHDpY06A1+CbuGkBVbG7g0G4jFPZWxa2QOaLb+rxy5QQLDblD7SlzFcKR5vWhY
         +GcbyJt0C/sM7kB0TvG1cbSfj5RLjdaJMlZwvXDjAtOaB6Vewjcc9KHGV61bnUJfx58b
         qOWO0edp2fSBIA/zVUOJUAnYxc7tmvt94QREg8573mB8gb7XMC5pADw/fsP1Hg+ymp3h
         R88At3Nwc/MkS6THIH+cwAByG8/gvem+GOVNXYdlrsK0MzvSNvHjHcP3B9AuuLX88CNB
         5/uBKZHmoswM3Y96zOffby6Yggp7UjejOAXDqtDrq9gjfuB/xc1jNNhtXHg0twAxVdgw
         Xmig==
X-Gm-Message-State: AOAM532OC1E7j1O45zzNmkCRenZJrICVlM46Lkl0NAssZWw3RAhjwV4U
        +NunNLBD3tnIwgFdb4pS3nc=
X-Google-Smtp-Source: ABdhPJwjIHt63IX5n1/H7K5AnsjIWWkaPZpn+xQMPuZBKB6Il2Ymi0O32VB9/zAARprJo3x0c+vRFg==
X-Received: by 2002:a5d:4d86:: with SMTP id b6mr4496658wru.152.1611063397186;
        Tue, 19 Jan 2021 05:36:37 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/14] io_uring: inline __io_commit_cqring()
Date:   Tue, 19 Jan 2021 13:32:38 +0000
Message-Id: <8a3c8b65fb1642d3178a7d2a3e42dc6114ef38c5.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
References: <cover.1611062505.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline it in its only user, that's cleaner

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 36be2b2e0570..5dfda399eb80 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1341,14 +1341,6 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 	return false;
 }
 
-static void __io_commit_cqring(struct io_ring_ctx *ctx)
-{
-	struct io_rings *rings = ctx->rings;
-
-	/* order cqe stores with ring update */
-	smp_store_release(&rings->cq.tail, ctx->cached_cq_tail);
-}
-
 static void io_put_identity(struct io_uring_task *tctx, struct io_kiocb *req)
 {
 	if (req->work.identity == &tctx->__identity)
@@ -1672,7 +1664,9 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 static void io_commit_cqring(struct io_ring_ctx *ctx)
 {
 	io_flush_timeouts(ctx);
-	__io_commit_cqring(ctx);
+
+	/* order cqe stores with ring update */
+	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
 
 	if (unlikely(!list_empty(&ctx->defer_list)))
 		__io_queue_deferred(ctx);
-- 
2.24.0

