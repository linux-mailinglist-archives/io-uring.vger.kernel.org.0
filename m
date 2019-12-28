Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5324F12BEA5
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 20:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfL1TTB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 14:19:01 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34309 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfL1TTB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 14:19:01 -0500
Received: by mail-pf1-f195.google.com with SMTP id i6so9514328pfc.1
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 11:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1aP2DhlUaiR2laz32yTO7Onl87ikXez5R0JPZVkT6OU=;
        b=IGNsMUd/eomf7Ei7w4V515Kk/JP0+rZgkW3zFAnljC2/5SWFGul0QDI2t9qtHTmMxy
         1uyFfGQ+X2g9ghhdMv1ZVVPA3CoSDZZ+p7fQ1i0D09Xy+Ccx9GHFnpGxpS9tsAbB7b4g
         34o8706nrN8oyFLkcINrovsMq8Bl1XgY9pnOI2lkOdiFPxbjWQ8O8GJ57OO277IJl9/Y
         bMGxbbAOSY53uw374V750bSEFxriJttSzznXHCykJ9MgM2eRepoqF7gU06eLbYOzstXc
         pdxG5IOygnB7ymJhzA1+oJP+PMxnGSeVOCX/QRqduLjwhrkVXBbOIeuv/Dlq1wiV6wFQ
         L1jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1aP2DhlUaiR2laz32yTO7Onl87ikXez5R0JPZVkT6OU=;
        b=NFDGD4DSPR8hz/5jbZFbDLt07r3JEmpWetK/WLE9cXy6i5MPKd150PKdK5zrimWy+u
         GN1VF4uoD1+AhY1ksiOZkjF5aKjBCzt3sncIl6Q2+YydpslMgKAGkKPXR8ovQDIDSA9/
         vD1D54ACSaU0y/NHFQPy/3075/j0nbZoAwee8KbkzEc5GxR+U//CnD+2gclIJvuVWKOI
         mU4KmPtOVd40UxXiBzDcXWqlT/jataxkuVVM84AmEVfgOh8PAb+9b3klt+yvxXAxQn7l
         AD3MBgewYNXoaNg9HHvXoBx4LQwer2dP5uF29M4cXIIsWpym7KLU3PQ1rG7k43G47ypQ
         LOYg==
X-Gm-Message-State: APjAAAXlYOvK2pHJgG7DdiOZ2CM04CbT9qaaCBpwwgkRMBmBBJf/HU2A
        Db0sZY8bO8Fu/ho2sfxv9R4b7Rn9zVUwJA==
X-Google-Smtp-Source: APXvYqzy6gYPFKvDQ744EIb2Her4AtP7tbDLWvuDdg0LaG0WqzD3Dn+HZG6vo+of6ro1w2ehPflH+Q==
X-Received: by 2002:a63:d406:: with SMTP id a6mr62619563pgh.264.1577560740199;
        Sat, 28 Dec 2019 11:19:00 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id x18sm44988789pfr.26.2019.12.28.11.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 11:18:59 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: wrap multi-req freeing in struct req_batch
Date:   Sat, 28 Dec 2019 12:18:56 -0700
Message-Id: <20191228191857.3868-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191228191857.3868-1-axboe@kernel.dk>
References: <20191228191857.3868-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This cleans up the code a bit, and it allows us to build on top of the
multi-req freeing.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 65 ++++++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 34 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0e6ed31cdb12..2de1e8409ab6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1129,14 +1129,19 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	return NULL;
 }
 
-static void io_free_req_many(struct io_ring_ctx *ctx, void **reqs, int *nr)
+struct req_batch {
+	void *reqs[IO_IOPOLL_BATCH];
+	int to_free;
+};
+
+static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 {
-	if (*nr) {
-		kmem_cache_free_bulk(req_cachep, *nr, reqs);
-		percpu_ref_put_many(&ctx->refs, *nr);
-		percpu_ref_put_many(&ctx->file_data->refs, *nr);
-		*nr = 0;
-	}
+	if (!rb->to_free)
+		return;
+	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
+	percpu_ref_put_many(&ctx->refs, rb->to_free);
+	percpu_ref_put_many(&ctx->file_data->refs, rb->to_free);
+	rb->to_free = 0;
 }
 
 static void __io_req_do_free(struct io_kiocb *req)
@@ -1368,7 +1373,7 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 	return smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
 }
 
-static inline bool io_req_multi_free(struct io_kiocb *req)
+static inline bool io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
 {
 	/*
 	 * If we're not using fixed files, we have to pair the completion part
@@ -1376,8 +1381,12 @@ static inline bool io_req_multi_free(struct io_kiocb *req)
 	 * free for fixed file and non-linked commands.
 	 */
 	if (((req->flags & (REQ_F_FIXED_FILE|REQ_F_LINK)) == REQ_F_FIXED_FILE)
-	    && !io_is_fallback_req(req) && !req->io)
+	    && !io_is_fallback_req(req) && !req->io) {
+		rb->reqs[rb->to_free++] = req;
+		if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
+			io_free_req_many(req->ctx, rb);
 		return true;
+	}
 
 	return false;
 }
@@ -1388,11 +1397,10 @@ static inline bool io_req_multi_free(struct io_kiocb *req)
 static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 			       struct list_head *done)
 {
-	void *reqs[IO_IOPOLL_BATCH];
+	struct req_batch rb;
 	struct io_kiocb *req;
-	int to_free;
 
-	to_free = 0;
+	rb.to_free = 0;
 	while (!list_empty(done)) {
 		req = list_first_entry(done, struct io_kiocb, list);
 		list_del(&req->list);
@@ -1400,19 +1408,13 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		io_cqring_fill_event(req, req->result);
 		(*nr_events)++;
 
-		if (refcount_dec_and_test(&req->refs)) {
-			if (io_req_multi_free(req)) {
-				reqs[to_free++] = req;
-				if (to_free == ARRAY_SIZE(reqs))
-					io_free_req_many(ctx, reqs, &to_free);
-			} else {
-				io_free_req(req);
-			}
-		}
+		if (refcount_dec_and_test(&req->refs) &&
+		    !io_req_multi_free(&rb, req))
+			io_free_req(req);
 	}
 
 	io_commit_cqring(ctx);
-	io_free_req_many(ctx, reqs, &to_free);
+	io_free_req_many(ctx, &rb);
 }
 
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
@@ -3225,30 +3227,25 @@ static void io_poll_complete_work(struct io_wq_work **workptr)
 
 static void __io_poll_flush(struct io_ring_ctx *ctx, struct llist_node *nodes)
 {
-	void *reqs[IO_IOPOLL_BATCH];
 	struct io_kiocb *req, *tmp;
-	int to_free = 0;
+	struct req_batch rb;
 
+	rb.to_free = 0;
 	spin_lock_irq(&ctx->completion_lock);
 	llist_for_each_entry_safe(req, tmp, nodes, llist_node) {
 		hash_del(&req->hash_node);
 		io_poll_complete(req, req->result, 0);
 
-		if (refcount_dec_and_test(&req->refs)) {
-			if (io_req_multi_free(req)) {
-				reqs[to_free++] = req;
-				if (to_free == ARRAY_SIZE(reqs))
-					io_free_req_many(ctx, reqs, &to_free);
-			} else {
-				req->flags |= REQ_F_COMP_LOCKED;
-				io_free_req(req);
-			}
+		if (refcount_dec_and_test(&req->refs) &&
+		    !io_req_multi_free(&rb, req)) {
+			req->flags |= REQ_F_COMP_LOCKED;
+			io_free_req(req);
 		}
 	}
 	spin_unlock_irq(&ctx->completion_lock);
 
 	io_cqring_ev_posted(ctx);
-	io_free_req_many(ctx, reqs, &to_free);
+	io_free_req_many(ctx, &rb);
 }
 
 static void io_poll_flush(struct io_wq_work **workptr)
-- 
2.24.1

