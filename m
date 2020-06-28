Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD3720C751
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 11:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgF1JyZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 05:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgF1JyZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 05:54:25 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A162CC061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:24 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id d15so10184507edm.10
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RlO48NTK5CBaWrDgVNaQ7QOYzq2uJZDmDtr9kwMYJDI=;
        b=lFdl2Z/1+kyqqG6yQg3sYQTcE6arjV9bOFrxRBP8+FdvwqVnaSRQa5EfWqNQoioq+T
         WyopzdD878nlDA57G/ecrR3oZGG58NusFKMn4g3JLY3H5PrhmQ9M+Fuvkr5ZylorEuJa
         ShlOVpZ8aJ3sgxipME1cezUmvFYPojCzYyP3JDlKhMcEmzQBfBpuXoV/7AjaWiF6XPbz
         Jq8bV6IWAoFGFFXvjjLj0YppAHUcURf4K5GeYUxRB4PxZ1G1iuLtCAOsHs/0Cdkk3NJm
         ATeKK9JH6oS++0A0+8ZH+eqy7ugQb0F8565CoyUEKfxunMtB5OfGX4ugO8v/uQM3AOW1
         qfmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RlO48NTK5CBaWrDgVNaQ7QOYzq2uJZDmDtr9kwMYJDI=;
        b=I0ekAuDUo1lgdtKMCzJmSEWioc37rwPRW0JSTDqyq0AT4OZqQfTU5fA++efZ3oqt7j
         MKRXv8qE3LvneXlawqHqlpXKHfYVbt86pT5/4wMqYnole5B7izPvKYNk0XPNboS9Tk8p
         If4vuJISJ3iWO8Wl1FfuTQxsylBQpS1nXTOgHyp7y10uqNgFcLxHq3ZWVLRbOWsu7/+j
         Z1fpwCdT+FF4/ms7hQsYV+k9vzYrPMjckUlxRC6Nr3+ENQK+YS8sOkQs2Y7ZV3MTeAwn
         VtomNa0uZ7nPnBCNmMstOcZ0QIDRTNmCKn3lwJJl1gyweP0GeGX8ClM8c+SfGOAmrne2
         6xEg==
X-Gm-Message-State: AOAM532+wZ6fFAIyKXP7NVHQYXxwBzkAKZDlryV+wvFGtigqN3VaBCsF
        pbhhy1sxV5pIZCI9mDcLunkXcxNA
X-Google-Smtp-Source: ABdhPJyfuI/SkwbbcNPZPXs3d8iQOyxlGiw+kmrwAdg6vWVl7LkFr44ur6Hj1YTkxS9/bmbvSVElog==
X-Received: by 2002:a05:6402:94f:: with SMTP id h15mr12289160edz.313.1593338063363;
        Sun, 28 Jun 2020 02:54:23 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id w15sm10089490ejk.103.2020.06.28.02.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 02:54:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/10] io_uring: cosmetic changes for batch free
Date:   Sun, 28 Jun 2020 12:52:33 +0300
Message-Id: <c32444373145d18ff117bfe2689e40fbc238084f.1593337097.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593337097.git.asml.silence@gmail.com>
References: <cover.1593337097.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move all batch free bits close to each other and rename in a consistent
way.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 69 +++++++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 32 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d9dd445e4e57..f64cca727021 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1537,21 +1537,6 @@ static void __io_free_req(struct io_kiocb *req)
 		clear_bit_unlock(0, (unsigned long *) &req->ctx->fallback_req);
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
-
-	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
-	percpu_ref_put_many(&ctx->refs, rb->to_free);
-	rb->to_free = 0;
-}
-
 static bool io_link_cancel_timeout(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1743,6 +1728,41 @@ static void io_free_req(struct io_kiocb *req)
 	__io_free_req(req);
 }
 
+struct req_batch {
+	void *reqs[IO_IOPOLL_BATCH];
+	int to_free;
+};
+
+static void __io_req_free_batch_flush(struct io_ring_ctx *ctx,
+				      struct req_batch *rb)
+{
+	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
+	percpu_ref_put_many(&ctx->refs, rb->to_free);
+	rb->to_free = 0;
+}
+
+static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
+				     struct req_batch *rb)
+{
+	if (rb->to_free)
+		__io_req_free_batch_flush(ctx, rb);
+}
+
+static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
+{
+	if (unlikely(io_is_fallback_req(req))) {
+		io_free_req(req);
+		return;
+	}
+	if (req->flags & REQ_F_LINK_HEAD)
+		io_queue_next(req);
+
+	io_dismantle_req(req);
+	rb->reqs[rb->to_free++] = req;
+	if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
+		__io_req_free_batch_flush(req->ctx, rb);
+}
+
 /*
  * Drop reference to request, return next in chain (if there is one) if this
  * was the last reference to this request.
@@ -1839,21 +1859,6 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 	return smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
 }
 
-static inline void io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
-{
-	if (unlikely(io_is_fallback_req(req))) {
-		io_free_req(req);
-		return;
-	}
-	if (req->flags & REQ_F_LINK_HEAD)
-		io_queue_next(req);
-
-	io_dismantle_req(req);
-	rb->reqs[rb->to_free++] = req;
-	if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
-		io_free_req_many(req->ctx, rb);
-}
-
 static int io_put_kbuf(struct io_kiocb *req)
 {
 	struct io_buffer *kbuf;
@@ -1918,13 +1923,13 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		(*nr_events)++;
 
 		if (refcount_dec_and_test(&req->refs))
-			io_req_multi_free(&rb, req);
+			io_req_free_batch(&rb, req);
 	}
 
 	io_commit_cqring(ctx);
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		io_cqring_ev_posted(ctx);
-	io_free_req_many(ctx, &rb);
+	io_req_free_batch_finish(ctx, &rb);
 
 	if (!list_empty(&again))
 		io_iopoll_queue(&again);
-- 
2.24.0

