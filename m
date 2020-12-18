Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14742DE330
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 14:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgLRNRW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 08:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727645AbgLRNRV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 08:17:21 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612D8C061257
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:07 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id t16so2117675wra.3
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jIs13uI2i1iQYEdulBBKmxz29PWYyu6kDSub7G6Hh+s=;
        b=mEUznp8bL+VRncIAbf5zSUhJyoCWT1SqmYq83SqpRhGSgNETyqKPxBoiozDpKWwp6I
         PNnKruEd/+w0OV++OuzbWofpZzBxoGrGlxNIAziMexyKGmRXidJ8Ronni7EB1guLZQb9
         wlDzKOT58/Ym6J2ghHhVzOQPOE/aVe6nVBn43cU++S0T6f1tuj4yyViWy7PRIFccXKLg
         FSpYwNEet1wDEP1u8sZjmfQkcUhgLKk0mKtPTLyhdb2/kzIgFJWmiH/d71q2qu2E+6S0
         6vIVH6XR6CNxGZxXSXKp5TQAJEdmrZTSkEu02Xp0WzqwRC3s8LH7CsspGxxse9jrwmrY
         aapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jIs13uI2i1iQYEdulBBKmxz29PWYyu6kDSub7G6Hh+s=;
        b=I67SGC0RTgh4zvc11ZVIyzsjxvTSQWXbAx2uNGspUs3DFPcIDTxFxkKiKU/lxsvIio
         xm/aEI0pobDL6dOqs/SbAhyAwqUD1M8z/ZrHZJyCxkEckevy4+ukR+5ntf5s9xRWqFuM
         tGW+nZ6zpKdzacL9J0TyfHKcKtQUKb0IVLJxcnYcQa7FnK/CNZA9dUOjls7bLoMbjLe6
         JBFydNcIfkAxrZdQwBmn/Bhs86W34g/Mce1UE7CfyusRHElffbV7EbCATg7UXzFx7qiY
         ooSipevYt2xut3i373RtTFfuqumqme2UF4ChnoXG5cWg6UIUrj64emldXD97/wOZu+zn
         i9JA==
X-Gm-Message-State: AOAM530RtfywB8OdAwQ0iuOFHzLGNBr9YoGV3IMicNPSybbUVww+J1ag
        R+eNp3SxQbgu6N3nYd9V3ew=
X-Google-Smtp-Source: ABdhPJywFve1fS4hUitAYk/gAhbE4GUWSDoDvQ81i0Ltd78AiOvHJz+4GQQDlfqqLA4xSuBHztGKYg==
X-Received: by 2002:adf:9e4d:: with SMTP id v13mr4344065wre.135.1608297361292;
        Fri, 18 Dec 2020 05:16:01 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id b9sm12778595wmd.32.2020.12.18.05.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 05:16:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/8] io_uring: further deduplicate #CQ events calc
Date:   Fri, 18 Dec 2020 13:12:22 +0000
Message-Id: <31f80f5046e939aafb9785cb54d3410784ceeea2.1608296656.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608296656.git.asml.silence@gmail.com>
References: <cover.1608296656.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apparently, there is one more place hand coded calculation of number of
CQ events in the ring. Use __io_cqring_events() helper in
io_get_cqring() as well. Naturally, assembly stays identical.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b74957856e68..1401c1444e77 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1664,21 +1664,25 @@ static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == r->sq_ring_entries;
 }
 
+static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
+{
+	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
+}
+
 static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
 	unsigned tail;
 
-	tail = ctx->cached_cq_tail;
 	/*
 	 * writes to the cq entry need to come after reading head; the
 	 * control dependency is enough as we're using WRITE_ONCE to
 	 * fill the cq entry
 	 */
-	if (tail - READ_ONCE(rings->cq.head) == rings->cq_ring_entries)
+	if (__io_cqring_events(ctx) == rings->cq_ring_entries)
 		return NULL;
 
-	ctx->cached_cq_tail++;
+	tail = ctx->cached_cq_tail++;
 	return &rings->cqes[tail & ctx->cq_mask];
 }
 
@@ -1693,11 +1697,6 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
 	return io_wq_current_is_worker();
 }
 
-static inline unsigned __io_cqring_events(struct io_ring_ctx *ctx)
-{
-	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
-}
-
 static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
 	if (waitqueue_active(&ctx->wait))
-- 
2.24.0

