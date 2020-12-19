Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CEA2DF143
	for <lists+io-uring@lfdr.de>; Sat, 19 Dec 2020 20:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgLSTQU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 14:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbgLSTQU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 14:16:20 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE159C061248
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 11:15:39 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id h16so2609307qvu.8
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 11:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SyeU/FRM6L9MHmR1iZ4auH4KHuwiXuCIvSiBiR9Y8t0=;
        b=ZzJ7GqgFZfmw+24OF7sU5FL+Sawpm5EmAIqJBUXQGUU0qgKNmIPW43wrfKoP3Mm10l
         aOFHNr1GG1VqgEvPg+kLjxyBDSw/djiCaW6iefYhtEqczQoG9nM7G1fasCOyQJPVErU5
         KvOjINIdfCjtWVxo9hZCacqRW2K/IJ6Ot+TlA1nu88+5ovzw/6S60GLKKiER9YdWBwkq
         z9ZJyTNF998PDie28l53Mz1wKaCU9LQSdax84ry9+sH1c8olVaaLA9AeYmWcof/CyDZu
         1cfifkKAp5ece7/7idJTaPjhktzhefo56f6+vv4y5O0WPhUhq56gevym6IizFW5Z0tFw
         OxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SyeU/FRM6L9MHmR1iZ4auH4KHuwiXuCIvSiBiR9Y8t0=;
        b=Sbu0mcEPvXCSnCeeyiFtqlHwAqFHuAq+RznFt1UobnO1fKNnjSMCUA3OYKmqzmslKB
         3S9jC8DbYP1Xts84VgVzsmVKh+bxU5zK82GbtUk852qVwjqFtM9YfhFJwyXE5lCjB0bh
         ZFVd+bGp1Ts6TVoSHOsnTQuj8DNw2UFna46uzzLqcjJM6e5zL3OdoOQ+sQ72H2eBXuFd
         ZzXSEZ1jASdxT10b/MePYBLPLg0yPODB84MEHIMaXk6byEYYKJvtOGqqidfcUkDE0Kud
         w8PCtvmon/JZjYE76snDemQ+AVz+3zBUCQhJ/ZV+g8+gxHu9HEOJUJ2hPAhIGpnRyyKu
         QyyA==
X-Gm-Message-State: AOAM530dYngaU2Si7MMogmKt/MZwJ/B7qUObEnVRyHgK2GgE/2O5Fc49
        O36updZr8eQihQDZDvXcetx5mj49nfNaRPOL
X-Google-Smtp-Source: ABdhPJyqP84gFcQJSAgId7VD8y0HA8cBERewEWVfO8brSYe0X5hhiThzfByxHQqvcc+YEDrgJcA0ZQ==
X-Received: by 2002:ad4:4e31:: with SMTP id dm17mr10907318qvb.27.1608405339022;
        Sat, 19 Dec 2020 11:15:39 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id 17sm7335488qtb.17.2020.12.19.11.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 11:15:38 -0800 (PST)
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org,
        Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Subject: [PATCH v2 1/2] io_uring: only increment ->cq_timeouts along with ->cached_cq_tail
Date:   Sat, 19 Dec 2020 14:15:20 -0500
Message-Id: <20201219191521.82029-2-marcelo827@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201219191521.82029-1-marcelo827@gmail.com>
References: <20201219191521.82029-1-marcelo827@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The quantity ->cached_cq_tail - ->cq_timeouts is used to tell how many
non-timeout events have happened, but this subtraction could overflow
if ->cq_timeouts is incremented more times than ->cached_cq_tail.
It's maybe unlikely, but currently this can happen if a timeout event
overflows the cqring, since in that case io_get_cqring() doesn't
increment ->cached_cq_tail, but ->cq_timeouts is incremented by the
caller. Fix it by incrementing ->cq_timeouts inside io_get_cqring().

Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
---
 fs/io_uring.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3690dfdd564..f394bf358022 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1582,8 +1582,6 @@ static void io_kill_timeout(struct io_kiocb *req)
 
 	ret = hrtimer_try_to_cancel(&io->timer);
 	if (ret != -1) {
-		atomic_set(&req->ctx->cq_timeouts,
-			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
 		io_cqring_fill_event(req, 0);
 		io_put_req_deferred(req, 1);
@@ -1664,7 +1662,7 @@ static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == r->sq_ring_entries;
 }
 
-static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
+static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx, u8 opcode)
 {
 	struct io_rings *rings = ctx->rings;
 	unsigned tail;
@@ -1679,6 +1677,10 @@ static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 		return NULL;
 
 	ctx->cached_cq_tail++;
+	if (opcode == IORING_OP_TIMEOUT)
+		atomic_set(&ctx->cq_timeouts,
+			   atomic_read(&ctx->cq_timeouts) + 1);
+
 	return &rings->cqes[tail & ctx->cq_mask];
 }
 
@@ -1728,7 +1730,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 		if (!io_match_task(req, tsk, files))
 			continue;
 
-		cqe = io_get_cqring(ctx);
+		cqe = io_get_cqring(ctx, req->opcode);
 		if (!cqe && !force)
 			break;
 
@@ -1776,7 +1778,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 	 * submission (by quite a lot). Increment the overflow count in
 	 * the ring.
 	 */
-	cqe = io_get_cqring(ctx);
+	cqe = io_get_cqring(ctx, req->opcode);
 	if (likely(cqe)) {
 		WRITE_ONCE(cqe->user_data, req->user_data);
 		WRITE_ONCE(cqe->res, res);
@@ -5618,8 +5620,6 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 	list_del_init(&req->timeout.list);
-	atomic_set(&req->ctx->cq_timeouts,
-		atomic_read(&req->ctx->cq_timeouts) + 1);
 
 	io_cqring_fill_event(req, -ETIME);
 	io_commit_cqring(ctx);
-- 
2.20.1

