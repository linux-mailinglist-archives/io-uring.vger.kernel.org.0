Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5888033A817
	for <lists+io-uring@lfdr.de>; Sun, 14 Mar 2021 22:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhCNVB0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Mar 2021 17:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbhCNVBT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Mar 2021 17:01:19 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B052FC061574
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 14:01:18 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id c76-20020a1c9a4f0000b029010c94499aedso19074447wme.0
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 14:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/FiYccZZiajcMLeWvwq4s8es4O7YRuDw75UyzPUVoww=;
        b=Mdlg7/9qtOADLCWVMP2w2/z28ltHei6Dv+BEN73JIwOiilFhA7Ou8maUQCo27wML/V
         xGZppJKNNAadt2zaEsixxu0SpPvnKORtl1Iv11iv+okBRsN80eWKgFC8NGynBDnEsgxR
         2hlGVfaGS3q4FuPzRsLrPwVwliY4q/D8pnAT8QJ478C0EDz/X+MEWXqEGZVaCeafswQI
         eGuZBICw6ypyJSEPkYHJlyTzcz9UFaxI/oYOehsrOlrRWAQCQ3bLp8OoOi+eMTcbFlHQ
         dVdbrh2+ip/65C65woUHDY9M8re8sRl7nTujdU/SsAXWb91dDdVQIipZ0IkPpGKMPG+Q
         uiOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/FiYccZZiajcMLeWvwq4s8es4O7YRuDw75UyzPUVoww=;
        b=dlUatPXaaluMQA1Ss6NqDqmxdbyyYXiNMr0JjO6ZrbPLoa6EDESHDMYavKRiB3IPKe
         KrBT+YrP2T73kR2EfDUzc5+euwmpbWSiHhuvTGT6T4gbzsLesolDV4Yluj1a0BXdH4+Q
         3FzAjkEULQsilLUHw9tYVxGaP9WVfDAN+2FEvOK5pqVHtGwlF7KDpG8HvoCvkH485OZO
         6PsXz+71812QwxK2oUglWNtVn6D47WeIjRTdtJxr/qVCpl/DonBOHngwAOZV8jy/Uzy5
         jXPKQbo7xCDH/MmsUlfNb99bGy79BZSQRjN2Kzgdj4VOFuFbAQXpuIS7P0oH3ma601K3
         GF8A==
X-Gm-Message-State: AOAM532STu1uEjugOK2xJkEfZxBW2lZUaiIdWA0mpOI1572rAgsxlkdN
        Er7SRnWWMqy4oXhmNTfjhqMNT1DrxgSBAw==
X-Google-Smtp-Source: ABdhPJz/2CWvLU7WFh73ffisxBqauBVTmDuR64YiQVlXf2klgXQn8vOviTkLgFQ5S068yNGYDgwXkA==
X-Received: by 2002:a7b:c4c9:: with SMTP id g9mr23412181wmk.82.1615755677522;
        Sun, 14 Mar 2021 14:01:17 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.154])
        by smtp.gmail.com with ESMTPSA id q15sm16232527wrx.56.2021.03.14.14.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 14:01:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/5] io_uring: fix complete_post use ctx after free
Date:   Sun, 14 Mar 2021 20:57:09 +0000
Message-Id: <101134178939b1262e517ae920e06f5dd04ad77e.1615754923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615754923.git.asml.silence@gmail.com>
References: <cover.1615754923.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If io_req_complete_post() put not a final ref, we can't rely on the
request's ctx ref, and so ctx may potentially be freed while
complete_post() is in io_cqring_ev_posted()/etc.

In that case get an additional ctx reference, and put it in the end, so
protecting following io_cqring_ev_posted(). And also prolong ctx
lifetime until spin_unlock happens, as we do with mutexes, so added
percpu_ref_get() doesn't race with ctx free.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4fd984fa6739..6548445f0d0b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1550,14 +1550,14 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 		io_put_task(req->task, 1);
 		list_add(&req->compl.list, &cs->locked_free_list);
 		cs->locked_free_nr++;
-	} else
-		req = NULL;
+	} else {
+		percpu_ref_get(&ctx->refs);
+	}
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	io_cqring_ev_posted(ctx);
 
-	if (req)
-		percpu_ref_put(&ctx->refs);
+	percpu_ref_put(&ctx->refs);
 }
 
 static void io_req_complete_state(struct io_kiocb *req, long res,
@@ -8373,11 +8373,13 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	/*
 	 * Some may use context even when all refs and requests have been put,
-	 * and they are free to do so while still holding uring_lock, see
-	 * __io_req_task_submit(). Wait for them to finish.
+	 * and they are free to do so while still holding uring_lock or
+	 * completion_lock, see __io_req_task_submit(). Wait for them to finish.
 	 */
 	mutex_lock(&ctx->uring_lock);
 	mutex_unlock(&ctx->uring_lock);
+	spin_lock_irq(&ctx->completion_lock);
+	spin_unlock_irq(&ctx->completion_lock);
 
 	io_sq_thread_finish(ctx);
 	io_sqe_buffers_unregister(ctx);
-- 
2.24.0

