Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E960B315B06
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbhBJAUX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235141AbhBJALL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:11:11 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D560C06121C
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:31 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id g10so455800wrx.1
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+FQsENqbrv/DcgmqzYb3G8ebEyqdR9Y9RcwjA8uMzJQ=;
        b=uq+WpqqQsEfNR6ssKYzuFi+gNXt4GbHl+ZNQB2cafOpGN8Hnft3ZcvgURQp+Y9SGdf
         KMZgfkUa7vxeGEqFwWD6lWU265pwMr7TuHdlNekN7WBjXhfvx5y96a6wWCAX3Dj1qkiv
         TL1Ry99N3ICyqWAzFyETUhf0LiQ3wJ80DwpHq5pDQ7obP/nwx9FIloRiCqezrFz30OcA
         oWvqlSwGWIs9tDGqKBBHQSkKXmL2Qkz4Im7hSYwXZPziPiWWCgcKceXJAQl4zFIwzVWq
         PoMdcZjmUf/qAiGeispJAdua8n7ZmBS04f4sb/wd2QFZIi5RTa5/deYcOUh499lrE/li
         xAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+FQsENqbrv/DcgmqzYb3G8ebEyqdR9Y9RcwjA8uMzJQ=;
        b=tMr/9/XKGf2HLf6Y+1NnAyGYgCxBcNvaWJOA7npGgiS1YpR//ZFdeAEqjVoagIL399
         xjrZ+9OHgPNeC6bP7wQWAjQxaIX8dyokwmWVo9Qx2DD/FHCFbqqxpZdeQ+LTcxdpyr1r
         cJ9ILsYD7kQfc0jGkAp5ig34SfUW5npE6XMCQrA+uLAErTN+PXd/lswfgb5tTGES+mHH
         SPHPU793psrGL/sZSPj1CW0C7EyP3FjBDQkrQsVwDgKlYzBNEYrR95PtIY+iCGPJ3ND3
         /9jv7aCXA1mAN5ad5Wmp9Q3+kq9bTJfUMTZ9zfpE+3afaeApWls6DSnvpcYrURIWT9Cz
         81+g==
X-Gm-Message-State: AOAM531guBTlWSEvn8RuR5bIyARn1Ca2dmBk7K/C+BxqSs2fn9cWJOj1
        /QYJcluqGi39tLITMpusD+fwvYAOleXeIA==
X-Google-Smtp-Source: ABdhPJzbvqix/Z7OVZxDGmijx5b0X2uBXlQWc7XOMp2nfGKAfjXALx2Hj7UrAEJkFioahrp/UkOG+g==
X-Received: by 2002:adf:9226:: with SMTP id 35mr557402wrj.408.1612915649628;
        Tue, 09 Feb 2021 16:07:29 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:29 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 15/17] io_uring: enable req cache for task_work items
Date:   Wed, 10 Feb 2021 00:03:21 +0000
Message-Id: <827d9e7b7addb98f7cff9f1fae684b2b8f9e6036.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

task_work is run without utilizing the req alloc cache, so any deferred
items don't get to take advantage of either the alloc or free side of it.
With task_work now being wrapped by io_uring, we can use the ctx
completion state to both use the req cache and the completion flush
batching.

With this, the only request type that cannot take advantage of the req
cache is IRQ driven IO for regular files / block devices. Anything else,
including IOPOLL polled IO to those same tyes, will take advantage of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1d55ff827242..f58a5459d6e3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1051,6 +1051,8 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     const struct iovec *fast_iov,
 			     struct iov_iter *iter, bool force);
 static void io_req_task_queue(struct io_kiocb *req);
+static void io_submit_flush_completions(struct io_comp_state *cs,
+					struct io_ring_ctx *ctx);
 
 static struct kmem_cache *req_cachep;
 
@@ -2140,6 +2142,7 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 
 static bool __tctx_task_work(struct io_uring_task *tctx)
 {
+	struct io_ring_ctx *ctx = NULL;
 	struct io_wq_work_list list;
 	struct io_wq_work_node *node;
 
@@ -2154,11 +2157,28 @@ static bool __tctx_task_work(struct io_uring_task *tctx)
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
@@ -2281,7 +2301,7 @@ static void __io_req_task_submit(struct io_kiocb *req)
 	if (!ctx->sqo_dead &&
 	    !__io_sq_thread_acquire_mm(ctx) &&
 	    !__io_sq_thread_acquire_files(ctx))
-		__io_queue_sqe(req, NULL);
+		__io_queue_sqe(req, &ctx->submit_state.comp);
 	else
 		__io_req_task_cancel(req, -EFAULT);
 	mutex_unlock(&ctx->uring_lock);
-- 
2.24.0

