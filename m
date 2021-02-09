Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82603156D2
	for <lists+io-uring@lfdr.de>; Tue,  9 Feb 2021 20:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbhBIT3z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 14:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbhBITFc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 14:05:32 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A57C0617AA
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 11:04:26 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id p15so17089589ilq.8
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 11:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4is+6ssySpmLGISzZtnmAfAvCwXgrYHoPNYRixYda8U=;
        b=Y05S4pJeI8n8kbtBVnWERhyfcOBi3B5MIznFTVuL3A9WDWiuWFj2PRe+An2rSvwnRn
         f5gwBa08rARiSrlGUBoA2Fa1ZAZVjD/bue3JtKmJezQWZimAXCWb5yvNqilT6y+bP5EV
         dx/OnvzHFNmjhjgLBclONo8r2qc68QQz9xWJDjVgGlltUL3ZAwZ1viJaX1ct4g4hrNpP
         Ii9cACGBiFJCc36j7K5EOPPnAkivG74Nk3tK2dRDg1butSh4qfumGdYmoJ0Cp/q+c7sd
         76RVD6b75dPQrqq9X/WigasTx3TRN++2eh1jbsmTIk24qHSs9j0PYDm/MmDQi7Lvjz66
         /t/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4is+6ssySpmLGISzZtnmAfAvCwXgrYHoPNYRixYda8U=;
        b=p1P1UPKIM04jbnqYEs1PO9uNTC9p/KVW7Ypim06TqGu9pJW5zT8ZfGkTtDhLn3hvHJ
         G7/TobVIRzGUmaATW+O192eyRwHUJATenmo7nQ3s6jtUb2JcggeVhFlgSXGW1Sw5K85h
         MhXOn6B7krfLQlPf6OAIFIJ3/aCxzbWAUUmNwWUpDUj79G6Bm0skutpAPLqmPiI7HqX5
         vf9cwyCtwKnHp3/7dm5tIJfcLu9R9VrWUwg5bwjn1ON/8DjWdavxyYavkOaU9O/brDfA
         oKY1aZuJKwc8hMey37AQkwWsN2+8TwvM8WC/WSmnlW4C0JvnxxuHRw5vXMlmtPhxRSrX
         t2rQ==
X-Gm-Message-State: AOAM532Y8UoG0qozKrhL7ZSjlc9+P8CKJZchxVtWcI1UadMnDGHkY04u
        Z/6d3GP1ZXVecTCPd8ew59UGHAfP5OPgFlsN
X-Google-Smtp-Source: ABdhPJxeY5HurjN33n7IrNXbIgAoxi0ssbwPLxIergdtPrbqZj/7f2dB4/WD11hzR/yCq7u4i5WcSg==
X-Received: by 2002:a92:b008:: with SMTP id x8mr21533262ilh.297.1612897466226;
        Tue, 09 Feb 2021 11:04:26 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i8sm10645554ilv.57.2021.02.09.11.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 11:04:25 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: enable req cache for task_work items
Date:   Tue,  9 Feb 2021 12:04:18 -0700
Message-Id: <20210209190418.208827-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210209190418.208827-1-axboe@kernel.dk>
References: <20210209190418.208827-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

task_work is run without utilizing the req alloc cache, so any deferred
items don't get to take advantage of either the alloc or free side of it.
With task_work now being wrapped by io_uring, we can use the ctx
completion state to both use the req cache and the completion flush
batching.

With this, the only request type that cannot take advantage of the req
cache is IRQ driven IO for regular files / block devices. Anything else,
including IOPOLL polled IO to those same tyes, will take advantage of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5700b2f75364..8e9a492f548f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1047,6 +1047,8 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     const struct iovec *fast_iov,
 			     struct iov_iter *iter, bool force);
 static void io_req_task_queue(struct io_kiocb *req);
+static void io_submit_flush_completions(struct io_comp_state *cs,
+					struct io_ring_ctx *ctx);
 
 static struct kmem_cache *req_cachep;
 
@@ -2160,6 +2162,7 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 
 static bool __tctx_task_work(struct io_uring_task *tctx)
 {
+	struct io_ring_ctx *ctx = NULL;
 	struct io_wq_work_list list;
 	struct io_wq_work_node *node;
 
@@ -2174,11 +2177,28 @@ static bool __tctx_task_work(struct io_uring_task *tctx)
 	node = list.first;
 	while (node) {
 		struct io_wq_work_node *next = node->next;
+		struct io_ring_ctx *this_ctx;
 		struct io_kiocb *req;
 
 		req = container_of(node, struct io_kiocb, io_task_work.node);
+		this_ctx = req->ctx;
 		req->task_work.func(&req->task_work);
 		node = next;
+
+		if (!ctx) {
+			ctx = this_ctx;
+		} else if (ctx != this_ctx) {
+			mutex_lock(&ctx->uring_lock);
+			io_submit_flush_completions(&ctx->submit_state.comp, ctx);
+			mutex_unlock(&ctx->uring_lock);
+			ctx = this_ctx;
+		}
+	}
+
+	if (ctx && ctx->submit_state.comp.nr) {
+		mutex_lock(&ctx->uring_lock);
+		io_submit_flush_completions(&ctx->submit_state.comp, ctx);
+		mutex_unlock(&ctx->uring_lock);
 	}
 
 	return list.first != NULL;
@@ -2301,7 +2321,7 @@ static void __io_req_task_submit(struct io_kiocb *req)
 	if (!ctx->sqo_dead &&
 	    !__io_sq_thread_acquire_mm(ctx) &&
 	    !__io_sq_thread_acquire_files(ctx))
-		__io_queue_sqe(req, NULL);
+		__io_queue_sqe(req, &ctx->submit_state.comp);
 	else
 		__io_req_task_cancel(req, -EFAULT);
 	mutex_unlock(&ctx->uring_lock);
-- 
2.30.0

