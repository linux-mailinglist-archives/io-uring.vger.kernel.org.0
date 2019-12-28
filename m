Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC86212BEA6
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 20:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfL1TTC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 14:19:02 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37888 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfL1TTC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 14:19:02 -0500
Received: by mail-pf1-f194.google.com with SMTP id x185so16366666pfc.5
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 11:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=og3LbEnv84zWZ/zZlQQuxPiz0JkuaD3/qneH/XZaGdg=;
        b=GgLv/WKNjjnHqopw55c/Er/22O+wwOXyCaS795IPXjyf3owR0xu6frBALkpCKNjRx9
         DDifMqRhWRewrHnIpH9tIAyiZgdLOLi8t6e9GIU2FB+OZ4gVxXwFcYffJ/kUo1W+FdsF
         Td7Ff4mRANyBLAnhaT6qzovm9jBS+/7bPd6LwHBfxPGtmgt5v7QUBHvG0RHRvBl9kZQq
         7uKDamCAvEJcF6+fK0lLvmVE3mUVUkmmkeIRHz/NP87dOrwIbVyW8jDq/LMa7ylyW20e
         egWmi68dcny+COiMtocHmEtoU121u+aSCQDq9wuhgHPFf5bwKfjHZYSdx6Oge3UMhXw3
         OUYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=og3LbEnv84zWZ/zZlQQuxPiz0JkuaD3/qneH/XZaGdg=;
        b=Hjs3av//ZVeOr9pcJrt6BRfD+mgg9zGx1SmGHvQTeeeEIkd/S0kw8RzjTLf2nSperW
         u+Giy2Uwmm7LxG2Jjj04rKucNYrOmUSLkb9tpvce2kb6JDjq9Pk9ek9hi8+7DUMgSRtV
         /3cMaYEazNp/KrA7WRjIiO1+k+kaHTf5yRQhg6nnScS5U1KhbAJ5PzOnJvf7bMyVNmBo
         YmiVT1Jqggzp2xM+fGeefiu5E9IScdE/fa3zs5o23Pv+Iejd+ldZucKkNYEwBvi0Pwxn
         V3HTbUulul2jg6DnMltNGbYmyTWUaVePvGY0WhybHqfCBRbcNlfWaNMwaNWZnYsnz4O1
         SnsA==
X-Gm-Message-State: APjAAAXiY59S3jJHiO70t9nRYVYeNwunYNPW0Q58oggiAILPI55CE1IJ
        3GUTGZWE0FShcM/xLlDV1IVDSedXsiQY8g==
X-Google-Smtp-Source: APXvYqxB3ODwRvWKdPdp2d19Na+rcHhSIdBNY9JC93PAicKJD786ZGA/J6otFwTgZ4MwZbPC0QnavQ==
X-Received: by 2002:a63:2142:: with SMTP id s2mr61595837pgm.54.1577560741327;
        Sat, 28 Dec 2019 11:19:01 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id x18sm44988789pfr.26.2019.12.28.11.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 11:19:00 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: extend batch freeing to cover more cases
Date:   Sat, 28 Dec 2019 12:18:57 -0700
Message-Id: <20191228191857.3868-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191228191857.3868-1-axboe@kernel.dk>
References: <20191228191857.3868-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently we only batch free if fixed files are used, no links, no aux
data, etc. This extends the batch freeing to only exclude the linked
case and fallback case, and make io_free_req_many() handle the other
cases just fine.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 100 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 69 insertions(+), 31 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2de1e8409ab6..104128e429a6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1129,21 +1129,6 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	return NULL;
 }
 
-struct req_batch {
-	void *reqs[IO_IOPOLL_BATCH];
-	int to_free;
-};
-
-static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
-{
-	if (!rb->to_free)
-		return;
-	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
-	percpu_ref_put_many(&ctx->refs, rb->to_free);
-	percpu_ref_put_many(&ctx->file_data->refs, rb->to_free);
-	rb->to_free = 0;
-}
-
 static void __io_req_do_free(struct io_kiocb *req)
 {
 	if (likely(!io_is_fallback_req(req)))
@@ -1152,7 +1137,7 @@ static void __io_req_do_free(struct io_kiocb *req)
 		clear_bit_unlock(0, (unsigned long *) req->ctx->fallback_req);
 }
 
-static void __io_free_req(struct io_kiocb *req)
+static void __io_req_aux_free(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -1164,7 +1149,14 @@ static void __io_free_req(struct io_kiocb *req)
 		else
 			fput(req->file);
 	}
+}
+
+static void __io_free_req(struct io_kiocb *req)
+{
+	__io_req_aux_free(req);
+
 	if (req->flags & REQ_F_INFLIGHT) {
+		struct io_ring_ctx *ctx = req->ctx;
 		unsigned long flags;
 
 		spin_lock_irqsave(&ctx->inflight_lock, flags);
@@ -1178,6 +1170,56 @@ static void __io_free_req(struct io_kiocb *req)
 	__io_req_do_free(req);
 }
 
+struct req_batch {
+	void *reqs[IO_IOPOLL_BATCH];
+	int to_free;
+	int need_iter;
+};
+
+static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
+{
+	if (!rb->to_free)
+		return;
+	if (rb->need_iter) {
+		int i, inflight = 0;
+		unsigned long flags;
+
+		for (i = 0; i < rb->to_free; i++) {
+			struct io_kiocb *req = rb->reqs[i];
+
+			if (req->flags & REQ_F_FIXED_FILE)
+				req->file = NULL;
+			if (req->flags & REQ_F_INFLIGHT)
+				inflight++;
+			else
+				rb->reqs[i] = NULL;
+			__io_req_aux_free(req);
+		}
+		if (!inflight)
+			goto do_free;
+
+		spin_lock_irqsave(&ctx->inflight_lock, flags);
+		for (i = 0; i < rb->to_free; i++) {
+			struct io_kiocb *req = rb->reqs[i];
+
+			if (req) {
+				list_del(&req->inflight_entry);
+				if (!--inflight)
+					break;
+			}
+		}
+		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
+
+		if (waitqueue_active(&ctx->inflight_wait))
+			wake_up(&ctx->inflight_wait);
+	}
+do_free:
+	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
+	percpu_ref_put_many(&ctx->refs, rb->to_free);
+	percpu_ref_put_many(&ctx->file_data->refs, rb->to_free);
+	rb->to_free = rb->need_iter = 0;
+}
+
 static bool io_link_cancel_timeout(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1375,20 +1417,16 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 
 static inline bool io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
 {
-	/*
-	 * If we're not using fixed files, we have to pair the completion part
-	 * with the file put. Use regular completions for those, only batch
-	 * free for fixed file and non-linked commands.
-	 */
-	if (((req->flags & (REQ_F_FIXED_FILE|REQ_F_LINK)) == REQ_F_FIXED_FILE)
-	    && !io_is_fallback_req(req) && !req->io) {
-		rb->reqs[rb->to_free++] = req;
-		if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
-			io_free_req_many(req->ctx, rb);
-		return true;
-	}
+	if ((req->flags & REQ_F_LINK) || io_is_fallback_req(req))
+		return false;
 
-	return false;
+	if (!(req->flags & REQ_F_FIXED_FILE) || req->io)
+		rb->need_iter++;
+
+	rb->reqs[rb->to_free++] = req;
+	if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
+		io_free_req_many(req->ctx, rb);
+	return true;
 }
 
 /*
@@ -1400,7 +1438,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	struct req_batch rb;
 	struct io_kiocb *req;
 
-	rb.to_free = 0;
+	rb.to_free = rb.need_iter = 0;
 	while (!list_empty(done)) {
 		req = list_first_entry(done, struct io_kiocb, list);
 		list_del(&req->list);
@@ -3230,7 +3268,7 @@ static void __io_poll_flush(struct io_ring_ctx *ctx, struct llist_node *nodes)
 	struct io_kiocb *req, *tmp;
 	struct req_batch rb;
 
-	rb.to_free = 0;
+	rb.to_free = rb.need_iter = 0;
 	spin_lock_irq(&ctx->completion_lock);
 	llist_for_each_entry_safe(req, tmp, nodes, llist_node) {
 		hash_del(&req->hash_node);
-- 
2.24.1

