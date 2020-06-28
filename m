Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0852620C74E
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 11:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgF1JyW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 05:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgF1JyW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 05:54:22 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA7DC061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:22 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n24so13392880ejd.0
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=52o5QBltC4EUiT5qvM+jN6HqkvrDfPvfP4cFDeAHeGQ=;
        b=Ml0rsbTXGYuU1BQQHKlDfMJE2I7NhNUU+JBN1SuzeOyX+qEzCRzsXunLvguQSck0yt
         OWy5lU9EYUn8dz5/stclcGPlcMmP2MAyQO4r3VfotHTOaq40FgnKGFrRMb2SeFFvcgLL
         EuGFpK+pBxGLKxCl5hvNp1IMXbmGUd9AJOBQmSrvE0qwZpNEaX2+HNSZujFSRG4Gz87I
         /WJtKXLxsHnjahv59Mec46brhvKlqy0VGDkycrm+l0eRc1c2ovNW/T8FeC/LuiPxSB+o
         t5H5wRzjgdssnBtO3wvXjB5dQeOU1DI5+tvhSnu9PWxXq+IMaLPv2iCj/zWHcVTbmkky
         J8IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=52o5QBltC4EUiT5qvM+jN6HqkvrDfPvfP4cFDeAHeGQ=;
        b=CglGT6pGrEg/l6AK2VY8iX4crorV3eaV5z37TfT+MGcgY5TW5ZHlWnD+y6B7FZrjk8
         zxHpcJs6L7MQ1xMin1VTJz2E8RA+tx+a0JYBnMPq+FLWkIoWUlzQGdYhI8qDWQKbN3W5
         GYFab3zNQEyCKaX/F+Gluxv/3qm53F4RjrehtAWDWljq95B8M5u0/znhnEpJzGI93pSa
         jRH2vCtrw6FU3qEkz4VuE5UbPePWInX0/twj0VqcDiQTAGMomkY17hOpyPo4pnXRsDOs
         y84silvhuyaNIFH0lgSkCEdE6g43Mn7NVdgn5TnIMSyteiLLSDdKqXfMIkIXaTR8rzXX
         YMww==
X-Gm-Message-State: AOAM533Fquf1SbRRYenBtuk528QlBNErmkKcGODHvlq9/PZFekEEXtXQ
        lrw7zKfg2NCf3qYwFdUvCCJ/0nLD
X-Google-Smtp-Source: ABdhPJwbkQta8289EQTBlXlstjTys9MzZ/ZfzUanaJqs2W1pEMcLfjgtywRZyRxUpcpSk08aZlJ07A==
X-Received: by 2002:a17:906:6d49:: with SMTP id a9mr9232833ejt.435.1593338060787;
        Sun, 28 Jun 2020 02:54:20 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id w15sm10089490ejk.103.2020.06.28.02.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 02:54:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/10] io_uring: remove inflight batching in free_many()
Date:   Sun, 28 Jun 2020 12:52:30 +0300
Message-Id: <28545f6bafdc56009fe142c9d9fa2b0e36772285.1593337097.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593337097.git.asml.silence@gmail.com>
References: <cover.1593337097.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_free_req_many() is used only for iopoll requests, i.e. reads/writes.
Hence no need to batch inflight unhooking. For safety, it'll be done
by io_dismantle_req(), which replaces __io_req_aux_free(), and looks
more solid and cleaner.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 41 ++++++++---------------------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 52441f2465fe..28a66e85ef9f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1504,7 +1504,7 @@ static inline void io_put_file(struct io_kiocb *req, struct file *file,
 		fput(file);
 }
 
-static void __io_req_aux_free(struct io_kiocb *req)
+static void io_dismantle_req(struct io_kiocb *req)
 {
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		io_cleanup_req(req);
@@ -1514,11 +1514,6 @@ static void __io_req_aux_free(struct io_kiocb *req)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 	__io_put_req_task(req);
 	io_req_work_drop_env(req);
-}
-
-static void __io_free_req(struct io_kiocb *req)
-{
-	__io_req_aux_free(req);
 
 	if (req->flags & REQ_F_INFLIGHT) {
 		struct io_ring_ctx *ctx = req->ctx;
@@ -1530,7 +1525,11 @@ static void __io_free_req(struct io_kiocb *req)
 			wake_up(&ctx->inflight_wait);
 		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	}
+}
 
+static void __io_free_req(struct io_kiocb *req)
+{
+	io_dismantle_req(req);
 	percpu_ref_put(&req->ctx->refs);
 	if (likely(!io_is_fallback_req(req)))
 		kmem_cache_free(req_cachep, req);
@@ -1549,35 +1548,11 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 	if (!rb->to_free)
 		return;
 	if (rb->need_iter) {
-		int i, inflight = 0;
-		unsigned long flags;
-
-		for (i = 0; i < rb->to_free; i++) {
-			struct io_kiocb *req = rb->reqs[i];
-
-			if (req->flags & REQ_F_INFLIGHT)
-				inflight++;
-			__io_req_aux_free(req);
-		}
-		if (!inflight)
-			goto do_free;
-
-		spin_lock_irqsave(&ctx->inflight_lock, flags);
-		for (i = 0; i < rb->to_free; i++) {
-			struct io_kiocb *req = rb->reqs[i];
-
-			if (req->flags & REQ_F_INFLIGHT) {
-				list_del(&req->inflight_entry);
-				if (!--inflight)
-					break;
-			}
-		}
-		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
+		int i;
 
-		if (waitqueue_active(&ctx->inflight_wait))
-			wake_up(&ctx->inflight_wait);
+		for (i = 0; i < rb->to_free; i++)
+			io_dismantle_req(rb->reqs[i]);
 	}
-do_free:
 	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
 	percpu_ref_put_many(&ctx->refs, rb->to_free);
 	rb->to_free = rb->need_iter = 0;
-- 
2.24.0

