Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A2B4216EF
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237266AbhJDTFp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237524AbhJDTFo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:44 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF753C061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:03:54 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g10so9262213edj.1
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EiZenRUttRkwknvtQvIElkQis7bMHG3Zv6Xl/DSS3zk=;
        b=ieD9K/Rn6bA+lBoHcLqWJ+N1QwpZOFv1Oimw+cRzXHh5ov01G6Cv4bmtQBFnqk/c+F
         RAaVNjKljp9DhJ6tAuBKDoYm/BVuET624SoU8KUD/gVxeObUFvLH0DYRs2BfM+Olj0sW
         bAaBnhNp6IfRgUNoQCzlnZsgx7ZOTJuG0aFWa2J+6a+HWApoK+5tglkN6NBZf+dQpc2E
         uHyNdp/bybGK3dOSG+gqM/j9chUPS40Dzwlv9PtearQUYcOGexx5pW0R+32x8IzJEQVS
         nblNnvDoLeEUqValWh7WCRFypqGd5br0xF7vYIjC2KCKUKKVbyl2zBVAHlOTBx4mPbR2
         2lZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EiZenRUttRkwknvtQvIElkQis7bMHG3Zv6Xl/DSS3zk=;
        b=a4lQSQIpa0/EAKPX1vPd9VWc9VREGOHk4TlX8Y2/OS08TJLsiv38d+/Hw+nAifPmgh
         cG9ISgKavZ1zsTC/Q4zvtl8oC48pwctfKJDTfwvQWiH++fljB7KzDkjXoOForSGzj71Z
         ZcKdYn0NYTT2rVsh/GQbhNw5dn4RQqmVuFY5qDLmEZzI/lDRkJX1gUepoTJIFmMQpyzT
         IBC7rX7BTeTGLGkXojsSryK/7N3yhSbjkDWUKoa2q0tP6X4Bf7UIOIUO0Pf4xgScMJt/
         ll6xy1QG46HxQGTLJgHN3ObQ09umUrWKP3oQLUNKOC7la0zLtIntZ+DWS6FmANmPHu3c
         sIJw==
X-Gm-Message-State: AOAM530KBhZZhwNusVZkQZiA9UWh5wB+OVjKAtOAM+PYyb1Ng+jLee1k
        ityw6KOKncisNrAASE91MQ8210vc/+s=
X-Google-Smtp-Source: ABdhPJxI2OqNF+ghU+RsJN8aEADXlWn/Oe4xftdFz46CDG8L51d/EW3ohDCy/wH5KDapY6JVPD5U7A==
X-Received: by 2002:a05:6402:21ef:: with SMTP id ce15mr19973588edb.19.1633374231511;
        Mon, 04 Oct 2021 12:03:51 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:03:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 04/16] io_uring: optimise request allocation
Date:   Mon,  4 Oct 2021 20:02:49 +0100
Message-Id: <eda17571bdc7248d8e617b23e7132a5416e4680b.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Even after fully inlining io_alloc_req() my compiler does a NULL check
in the path of successful allocation, no hacks like an empty dereference
help it. Restructure io_alloc_req() by splitting out refilling part, so
the compiler generate a slightly better binary.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 54850696ab6d..377c1cfd5d06 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1912,18 +1912,17 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
  * Because of that, io_alloc_req() should be called only under ->uring_lock
  * and with extra caution to not get a request that is still worked on.
  */
-static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
+static bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	void *reqs[IO_REQ_ALLOC_BATCH];
-	struct io_wq_work_node *node;
 	struct io_kiocb *req;
 	int ret, i;
 
 	if (likely(state->free_list.next || io_flush_cached_reqs(ctx)))
-		goto got_req;
+		return true;
 
 	ret = kmem_cache_alloc_bulk(req_cachep, gfp, ARRAY_SIZE(reqs), reqs);
 
@@ -1934,7 +1933,7 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 	if (unlikely(ret <= 0)) {
 		reqs[0] = kmem_cache_alloc(req_cachep, gfp);
 		if (!reqs[0])
-			return NULL;
+			return false;
 		ret = 1;
 	}
 
@@ -1944,8 +1943,21 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 		io_preinit_req(req, ctx);
 		wq_stack_add_head(&req->comp_list, &state->free_list);
 	}
-got_req:
-	node = wq_stack_extract(&state->free_list);
+	return true;
+}
+
+static inline bool io_alloc_req_refill(struct io_ring_ctx *ctx)
+{
+	if (unlikely(!ctx->submit_state.free_list.next))
+		return __io_alloc_req_refill(ctx);
+	return true;
+}
+
+static inline struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
+{
+	struct io_wq_work_node *node;
+
+	node = wq_stack_extract(&ctx->submit_state.free_list);
 	return container_of(node, struct io_kiocb, comp_list);
 }
 
@@ -7220,12 +7232,12 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
 
-		req = io_alloc_req(ctx);
-		if (unlikely(!req)) {
+		if (unlikely(!io_alloc_req_refill(ctx))) {
 			if (!submitted)
 				submitted = -EAGAIN;
 			break;
 		}
+		req = io_alloc_req(ctx);
 		sqe = io_get_sqe(ctx);
 		if (unlikely(!sqe)) {
 			wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
-- 
2.33.0

