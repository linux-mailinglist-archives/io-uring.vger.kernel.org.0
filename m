Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFED35B10D
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbhDKAvS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhDKAvS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:18 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C288FC06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:02 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id w7-20020a1cdf070000b0290125f388fb34so4161406wmg.0
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9lCEYPxf4hNnsd0Z6/dDvyyRYtbQnAl3yGpR4xYBRdQ=;
        b=AkL2tIiUyGtymLQLkKA5GPDP1Tees6h5f12BJP8pCwHgeN8xmgCUe1LuK1lw8LT/GD
         UMt4yBSwemfIGhhEABnc0CrIgafbO5uNPMB3quEcouscKLD9X0nhbh5fPMfCR0cpyUPA
         5cyYHTiiDZN9FucgFjsm8wxD2QOupj+kbPX+urUK/1Jha8lxXW6dH6Ozp+V2cS6flL/h
         yIlL2OJfwDMCylVEsvokAwr3kB96xmSCh58IPMRm5GCusv6/PHkCf5sNlooisFX39Wad
         QtRuztv0ddOmnSe/Um+6ijkKMpJI4DXRnqYSpNU3Mz4uvEFSqsh4301k8nG4N/Aua3MC
         se/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9lCEYPxf4hNnsd0Z6/dDvyyRYtbQnAl3yGpR4xYBRdQ=;
        b=g1ifBcuqC6MReVGPfigFeAGwRlhsqc1kLZO9m2wtXEUlNML+p9Wt/n0R0xA89l+iOQ
         mUTPhWBIzlTIgSETpF7GM0nHtO5nFTvJEkAluCUVVoAHMcIlR8RDJozA6s8xb3L8kjXG
         wGnPYqZBBGOqzU/xGuN9btyvcdpeLuooDp5xTAIDTjF8oL8rsz87bB1hyqqrwT9DzzVk
         38ljt2B2EvHzBFWk0Sum864M4HkUdR4hobJSY66Dn2JsqfNZEr1kHYqK39RfBPVRctLC
         e3oWAWGDhcnGeFnTptJhbJBF5L8w3jHGBV28hdY+kFlkp1zstddpn3Nj7Lau6XAMusCf
         Aldg==
X-Gm-Message-State: AOAM532F+ewWUJzblvQL08LG11uxqoaO5ox2H2q7dAHi2T5kmL9kjdi6
        txAWaDNLxkf55qwXVSfmmeLgWYqm9i17kA==
X-Google-Smtp-Source: ABdhPJxCzzZF1GULol8LeV699nN8AWqbPFNDGr2FbhPPeS45b7DNVoHuM2pLB46fq9LqMDWLWOzAzg==
X-Received: by 2002:a05:600c:154a:: with SMTP id f10mr19578440wmg.20.1618102261610;
        Sat, 10 Apr 2021 17:51:01 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:51:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/16] io_uring: optimise fill_event() by inlining
Date:   Sun, 11 Apr 2021 01:46:33 +0100
Message-Id: <a11d59424bf4417aca33f5ec21008bb3b0ebd11e.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are three cases where we much care about performance of
io_cqring_fill_event() -- flushing inline completions, iopoll and
io_req_complete_post(). Inline a hot part of fill_event() into them.

All others are not as important and we don't want to bloat binary for
them, so add a noinline version of the function for all other use
use cases.

nops test(batch=32): 16.932 vs 17.822 KIOPS

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 57 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1a7bfb10d2b2..a8d6ea1ecd2d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1338,7 +1338,7 @@ static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
 	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
 }
 
-static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
+static inline struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
 	unsigned tail;
@@ -1494,26 +1494,11 @@ static inline void req_ref_get(struct io_kiocb *req)
 	atomic_inc(&req->refs);
 }
 
-static bool io_cqring_fill_event(struct io_kiocb *req, long res,
-				 unsigned int cflags)
+static bool io_cqring_event_overflow(struct io_kiocb *req, long res,
+				     unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_uring_cqe *cqe;
 
-	trace_io_uring_complete(ctx, req->user_data, res, cflags);
-
-	/*
-	 * If we can't get a cq entry, userspace overflowed the
-	 * submission (by quite a lot). Increment the overflow count in
-	 * the ring.
-	 */
-	cqe = io_get_cqring(ctx);
-	if (likely(cqe)) {
-		WRITE_ONCE(cqe->user_data, req->user_data);
-		WRITE_ONCE(cqe->res, res);
-		WRITE_ONCE(cqe->flags, cflags);
-		return true;
-	}
 	if (!atomic_read(&req->task->io_uring->in_idle)) {
 		struct io_overflow_cqe *ocqe;
 
@@ -1541,6 +1526,36 @@ static bool io_cqring_fill_event(struct io_kiocb *req, long res,
 	return false;
 }
 
+static inline bool __io_cqring_fill_event(struct io_kiocb *req, long res,
+					     unsigned int cflags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_uring_cqe *cqe;
+
+	trace_io_uring_complete(ctx, req->user_data, res, cflags);
+
+	/*
+	 * If we can't get a cq entry, userspace overflowed the
+	 * submission (by quite a lot). Increment the overflow count in
+	 * the ring.
+	 */
+	cqe = io_get_cqring(ctx);
+	if (likely(cqe)) {
+		WRITE_ONCE(cqe->user_data, req->user_data);
+		WRITE_ONCE(cqe->res, res);
+		WRITE_ONCE(cqe->flags, cflags);
+		return true;
+	}
+	return io_cqring_event_overflow(req, res, cflags);
+}
+
+/* not as hot to bloat with inlining */
+static noinline bool io_cqring_fill_event(struct io_kiocb *req, long res,
+					  unsigned int cflags)
+{
+	return __io_cqring_fill_event(req, res, cflags);
+}
+
 static void io_req_complete_post(struct io_kiocb *req, long res,
 				 unsigned int cflags)
 {
@@ -1548,7 +1563,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	io_cqring_fill_event(req, res, cflags);
+	__io_cqring_fill_event(req, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -2103,7 +2118,7 @@ static void io_submit_flush_completions(struct io_comp_state *cs,
 	spin_lock_irq(&ctx->completion_lock);
 	for (i = 0; i < nr; i++) {
 		req = cs->reqs[i];
-		io_cqring_fill_event(req, req->result, req->compl.cflags);
+		__io_cqring_fill_event(req, req->result, req->compl.cflags);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
@@ -2243,7 +2258,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (req->flags & REQ_F_BUFFER_SELECTED)
 			cflags = io_put_rw_kbuf(req);
 
-		io_cqring_fill_event(req, req->result, cflags);
+		__io_cqring_fill_event(req, req->result, cflags);
 		(*nr_events)++;
 
 		if (req_ref_put_and_test(req))
-- 
2.24.0

