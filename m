Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E44B207994
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2020 18:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404815AbgFXQwL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Jun 2020 12:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405226AbgFXQvy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Jun 2020 12:51:54 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB50C061573;
        Wed, 24 Jun 2020 09:51:54 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g75so2956545wme.5;
        Wed, 24 Jun 2020 09:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=G/jzq3QOfbBtu5O5mfX8exac2PYcVHQBcbTwCgdBYnI=;
        b=Mmijw7T/sfO9YzXeLhtxpLhgyY1Y5QHzNU2BKk0KUE1J+l6D63nEqm50LRzqNsd7Bv
         h1kIJwoGrQhUiO3/b+2u7dg4JnMWcQCWld4+bH85+TfHk//UtNK9gox93OWKPPv0xU9Q
         2JUM2pYRypoAxVVLU6Qpjg0QQmdOFbHMeDMxaL+6uQ0CNEBHjubTJQBa4zEs63jkWP0P
         ZqsUKiEvReZJ6c3TEDK4UXiJoyoAKxo/lj8pHsXLg5NI8zg2WPSAri+q6eE+bdyivN20
         uNbrbJ14K0tHXjHjT+Ls1VWbQEmKz4FF279j15J2ygG3Ixs8znBww6ciDbSJJz1OyYLe
         dyVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G/jzq3QOfbBtu5O5mfX8exac2PYcVHQBcbTwCgdBYnI=;
        b=LicaMjB+lrGoUIAg29T8FzXEBoj0mQlItUEJcYr2nuM/FVseF5PmTEPsMaS1b6vsmm
         KCBKWbh5aHSBRdEkgYyeEIZcJxGDJEOgxuLOgrubELYyuPgd3YZgLXYv1PTzV8sRaXVJ
         F2fKwAZqa3OgV4h/roiShTFUIbMv7KoeYc1wfycPvCht6SUk3RVuXMzHSa1fF3koRfdN
         m9u8/gZC64KG0i3Sv6+Q4LAlpV2UX3MhxH1a5UsT9DSbdHW0xQu+rXZ2wRbr1gFckpil
         p7YrXDwq3LIk4Pt2FF7mv7A/qHbfAu919X0e5PqJXTeRH+uIuWmecA7x1/ibU/ldfrLF
         wsZQ==
X-Gm-Message-State: AOAM531fKJ/ERXJUQBshey2qYXPIhU1YW5TZAQw+/qrfM8WzDyvfjdNk
        FLVYcFdHlvSuwIeWxjtn/l0=
X-Google-Smtp-Source: ABdhPJzUrraqoW09AK7kPgaShgjjwO5zGbKt5JGdmjLqgEeqA+/P98qVWu7xPA19iBiJ31jB9j6j7g==
X-Received: by 2002:a1c:96ce:: with SMTP id y197mr32383758wmd.55.1593017512999;
        Wed, 24 Jun 2020 09:51:52 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id z16sm18138182wrr.35.2020.06.24.09.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 09:51:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] io_uring: fix NULL-mm for linked reqs
Date:   Wed, 24 Jun 2020 19:50:09 +0300
Message-Id: <5e29e933792c363ae4da4d96dd9a041430260f83.1593016907.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593016907.git.asml.silence@gmail.com>
References: <cover.1593016907.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_queue_sqe() tries to handle all request of a link,
so it's not enough to grab mm in io_sq_thread_acquire_mm()
based just on the head.

Don't check req->needs_mm and do it always.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 578ec2e39712..df0dba607966 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2000,10 +2000,9 @@ static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
 	}
 }
 
-static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
-				   struct io_kiocb *req)
+static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 {
-	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
+	if (!current->mm) {
 		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
 			return -EFAULT;
 		kthread_use_mm(ctx->sqo_mm);
@@ -2012,6 +2011,14 @@ static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
 	return 0;
 }
 
+static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
+				   struct io_kiocb *req)
+{
+	if (!io_op_defs[req->opcode].needs_mm)
+		return 0;
+	return __io_sq_thread_acquire_mm(ctx);
+}
+
 #ifdef CONFIG_BLOCK
 static bool io_resubmit_prep(struct io_kiocb *req, int error)
 {
@@ -2788,7 +2795,7 @@ static void io_async_buf_retry(struct callback_head *cb)
 	ctx = req->ctx;
 
 	__set_current_state(TASK_RUNNING);
-	if (!io_sq_thread_acquire_mm(ctx, req)) {
+	if (!__io_sq_thread_acquire_mm(ctx)) {
 		mutex_lock(&ctx->uring_lock);
 		__io_queue_sqe(req, NULL);
 		mutex_unlock(&ctx->uring_lock);
-- 
2.24.0

