Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BD23A7222
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 00:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhFNWkY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 18:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhFNWkY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 18:40:24 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCAAC061283
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:38:04 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id m3so7747316wms.4
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Ddeb3OlEKvkyzqagKcJjLKsqhw7qY7PVCZwGX7F6Gh4=;
        b=d9xrf9Wm10Th9GLi0kwqgqF5csv2XRiffEy2YwXJZ7FQNXWGjI6hsB5s+9Ti7Yjrh4
         iN7jCFY1xrVrx7rLTY70fnx9FHvbgYMusba9YEUqlFVDfHEMxEy9jMkNfDcYhX4/NoN2
         LoxNSTqUCEeNjxC65x5x8oeen7ZanL3G/AqDYFBqTlo1ydNZssYR7l9hQMu1N09jKGOE
         BBj+WpEg+h2Mpa0kyNpHIZEWO38V/azGb/EdsTwp4hJn1lWgz1AzZwev9QshOeDkFX+i
         CcflfUxi7/ONsRMOtkU1DpPx5vpamohVDg8zWnTYsu0zudG0jLjMv47SCNVvbXdi5QFx
         AZqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ddeb3OlEKvkyzqagKcJjLKsqhw7qY7PVCZwGX7F6Gh4=;
        b=P9KDKEOSl3AqlCNPZqEFRDqv++swWel22hPkY2+e5l2ACGygPFHl2D7EoPHxvpN5Xw
         efP2iI7/oEnRasLdrgX2pfTg2iK0lgNWq9RWvEs0mtAqiMoqAJ7cjewI7xh6dPvIN03R
         w7AFvCqeInyI0a2MQlPzloHYqONLSflnopj6Vw55IRa794MNWpNjBcQhFwJpMkSS7Jp2
         90iHklGefzkyYoG/qgUHTgCdSA4n3cNbn6B6xkdSdeOwvvKTJlBI7PibpWZjHY4Fz6+Z
         CIVem8E/g2wDQVxQ3br2SSBkOaSrTxYB2l7loEJt//cEjgTA0yg+T6uFsGjnw4JRWPzC
         DHTA==
X-Gm-Message-State: AOAM531Eonxuw8zFoLF37h6PR7butEBYRF2107cPIff0qjs6Thl76Clo
        HP6Njy3/GRC5GukQvphtbrM=
X-Google-Smtp-Source: ABdhPJwbkX2c9BaqRTWHbFnmM0AUAVomtcsToUIfbcFrwvbzwNVERGrExLqZZhO7WlTsSveDOhSFdw==
X-Received: by 2002:a1c:3dc2:: with SMTP id k185mr1485760wma.15.1623710282981;
        Mon, 14 Jun 2021 15:38:02 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id x3sm621074wmj.30.2021.06.14.15.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:38:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/12] io_uring: optimise non-drain path
Date:   Mon, 14 Jun 2021 23:37:31 +0100
Message-Id: <98d2fff8c4da5144bb0d08499f591d4768128ea3.1623709150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623709150.git.asml.silence@gmail.com>
References: <cover.1623709150.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Replace drain checks with one-way flag set upon seeing the first
IOSQE_IO_DRAIN request. There are several places where it cuts cycles
well:

1) It's much faster than the fast check with two
conditions in io_drain_req() including pretty complex
list_empty_careful().

2) We can mark io_queue_sqe() inline now, that's a huge win.

3) It replaces timeout and drain checks in io_commit_cqring() with a
single flags test. Also great not touching ->defer_list there without a
reason so limiting cache bouncing.

It adds a small amount of overhead to drain path, but it's negligible.
The main nuisance is that once it meets any DRAIN request in io_uring
instance lifetime it will _always_ go through a slower path, so
drain-less and offset-mode timeout less applications are preferable.
The overhead in that case would be not big, but it's worth to bear in
mind.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 57 +++++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 29b705201ca3..5828ffdbea82 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -352,6 +352,7 @@ struct io_ring_ctx {
 		unsigned int		eventfd_async: 1;
 		unsigned int		restricted: 1;
 		unsigned int		off_timeout_used: 1;
+		unsigned int		drain_used: 1;
 	} ____cacheline_aligned_in_smp;
 
 	/* submission data */
@@ -1299,9 +1300,9 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 	}
 }
 
-static void __io_queue_deferred(struct io_ring_ctx *ctx)
+static void io_queue_deferred(struct io_ring_ctx *ctx)
 {
-	do {
+	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
 
@@ -1310,17 +1311,12 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 		list_del_init(&de->list);
 		io_req_task_queue(de->req);
 		kfree(de);
-	} while (!list_empty(&ctx->defer_list));
+	}
 }
 
 static void io_flush_timeouts(struct io_ring_ctx *ctx)
 {
-	u32 seq;
-
-	if (likely(!ctx->off_timeout_used))
-		return;
-
-	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
 
 	while (!list_empty(&ctx->timeout_list)) {
 		u32 events_needed, events_got;
@@ -1350,13 +1346,14 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 
 static void io_commit_cqring(struct io_ring_ctx *ctx)
 {
-	io_flush_timeouts(ctx);
-
+	if (unlikely(ctx->off_timeout_used || ctx->drain_used)) {
+		if (ctx->off_timeout_used)
+			io_flush_timeouts(ctx);
+		if (ctx->drain_used)
+			io_queue_deferred(ctx);
+	}
 	/* order cqe stores with ring update */
 	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
-
-	if (unlikely(!list_empty(&ctx->defer_list)))
-		__io_queue_deferred(ctx);
 }
 
 static inline bool io_sqring_full(struct io_ring_ctx *ctx)
@@ -6447,9 +6444,9 @@ static void __io_queue_sqe(struct io_kiocb *req)
 		io_queue_linked_timeout(linked_timeout);
 }
 
-static void io_queue_sqe(struct io_kiocb *req)
+static inline void io_queue_sqe(struct io_kiocb *req)
 {
-	if (io_drain_req(req))
+	if (unlikely(req->ctx->drain_used) && io_drain_req(req))
 		return;
 
 	if (likely(!(req->flags & REQ_F_FORCE_ASYNC))) {
@@ -6573,6 +6570,23 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		io_req_complete_failed(req, ret);
 		return ret;
 	}
+
+	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
+		ctx->drain_used = true;
+
+		/*
+		 * Taking sequential execution of a link, draining both sides
+		 * of the link also fullfils IOSQE_IO_DRAIN semantics for all
+		 * requests in the link. So, it drains the head and the
+		 * next after the link request. The last one is done via
+		 * drain_next flag to persist the effect across calls.
+		 */
+		if (link->head) {
+			link->head->flags |= REQ_F_IO_DRAIN;
+			ctx->drain_next = 1;
+		}
+	}
+
 	ret = io_req_prep(req, sqe);
 	if (unlikely(ret))
 		goto fail_req;
@@ -6591,17 +6605,6 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (link->head) {
 		struct io_kiocb *head = link->head;
 
-		/*
-		 * Taking sequential execution of a link, draining both sides
-		 * of the link also fullfils IOSQE_IO_DRAIN semantics for all
-		 * requests in the link. So, it drains the head and the
-		 * next after the link request. The last one is done via
-		 * drain_next flag to persist the effect across calls.
-		 */
-		if (req->flags & REQ_F_IO_DRAIN) {
-			head->flags |= REQ_F_IO_DRAIN;
-			ctx->drain_next = 1;
-		}
 		ret = io_req_prep_async(req);
 		if (unlikely(ret))
 			goto fail_req;
-- 
2.31.1

