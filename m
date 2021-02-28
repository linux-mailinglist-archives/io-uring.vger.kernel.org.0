Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224953274EC
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhB1WkF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhB1WkE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:40:04 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EFFC06178A
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:23 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id b3so14140994wrj.5
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LmKpOew0sQ+ZGmMBxwwVVcpPZrFAZcDZXQaoXQZ3e/A=;
        b=eVP/sSsqfa3FGrRUbIDP628F2EN1l39WgYo//i9fOOrDFMRAeKZDMeWVWSYO07zKvL
         aeCCOeeBl3WacRbc4goswmC1icxfw4lTj97Nt9qgXMdLKOQNUQBTztJltbICP8gM+mSv
         6fGL+7cvvGIc1BirZYynu17WDpaGAoxzglvfdoAoHTokqp/H2ex8mRE0Men6NqmKoNbC
         FOEGu7wvVGq0KOsP9wotQCIROVgofkqVn3LH39cdgCYrYCKMM1lUvlin0C68I/5UptEm
         qn/bWF78GP0wVcuBWNi1rHbP/kG7keUM9FL+b0cPHATGV+VhhpiOfvt0KYGoDe5JnMQH
         i3Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LmKpOew0sQ+ZGmMBxwwVVcpPZrFAZcDZXQaoXQZ3e/A=;
        b=Spw+uuSe3EKnrqdVQDYQjkctaI9wJL+ay0GvTTr7nL37vSf9Cw3dZfvEqI4TqsCxpF
         72uDMyK+qOrf4WH0EuteXTscwcOGCT2T7XVb3an7RgSpOVUjZmcePKrQolCZabjRyrTt
         MDuwVPIOzhFi5J+UqLrj9YtozJvFfKONu+pZEhy+KMhoKZlPB+J7H+3yWNQUOv9skwN1
         iCgg3bTXGjp/o5by5TJophfskLz42yEdKh/kdiGUFdJbFa+88mBUHGt87p21VXOPnLGO
         +E6PruGPvzlJG3rZWiaOmtn43ha2MPu0zGAFRyRIVsCWVwIXaHZYzj7LsWhgQ207GI9J
         dMqA==
X-Gm-Message-State: AOAM533MYHdagwq1015CS04Q4Daunph3vhyH4HDKOyYl5X/nH1FRaxK3
        AjC9bqvowCzYoKNRbiD0JXA=
X-Google-Smtp-Source: ABdhPJydIoVX5cafqpTV1XBjzipfuGi4ZLq7q83ExbF1xwSRtuVBbG/n2tTcrPlm73Kw36wphMTSsw==
X-Received: by 2002:adf:a2c2:: with SMTP id t2mr13545304wra.47.1614551962340;
        Sun, 28 Feb 2021 14:39:22 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id y62sm22832576wmy.9.2021.02.28.14.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:39:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/12] io_uring: add a helper failing not issued requests
Date:   Sun, 28 Feb 2021 22:35:12 +0000
Message-Id: <94ce1b284ce6c3aa7ef0c0ad7a33fecb43a4368b.1614551467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614551467.git.asml.silence@gmail.com>
References: <cover.1614551467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a simple helper doing CQE posting, marking request for link-failure,
and putting both submission and completion references.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e3c36c1dcfad..75ff9e577592 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1543,8 +1543,8 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 	__io_cqring_fill_event(req, res, 0);
 }
 
-static inline void io_req_complete_post(struct io_kiocb *req, long res,
-					unsigned int cflags)
+static void io_req_complete_post(struct io_kiocb *req, long res,
+				 unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
@@ -1597,6 +1597,13 @@ static inline void io_req_complete(struct io_kiocb *req, long res)
 	__io_req_complete(req, 0, res, 0);
 }
 
+static void io_req_complete_failed(struct io_kiocb *req, long res)
+{
+	req_set_fail_links(req);
+	io_put_req(req);
+	io_req_complete_post(req, res, 0);
+}
+
 static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
@@ -6223,9 +6230,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 			io_put_req(req);
 		}
 	} else {
-		req_set_fail_links(req);
-		io_put_req(req);
-		io_req_complete(req, ret);
+		io_req_complete_failed(req, ret);
 	}
 	if (linked_timeout)
 		io_queue_linked_timeout(linked_timeout);
@@ -6239,9 +6244,7 @@ static void io_queue_sqe(struct io_kiocb *req)
 	if (ret) {
 		if (ret != -EIOCBQUEUED) {
 fail_req:
-			req_set_fail_links(req);
-			io_put_req(req);
-			io_req_complete(req, ret);
+			io_req_complete_failed(req, ret);
 		}
 	} else if (req->flags & REQ_F_FORCE_ASYNC) {
 		ret = io_req_defer_prep(req);
@@ -6352,13 +6355,11 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	ret = io_init_req(ctx, req, sqe);
 	if (unlikely(ret)) {
 fail_req:
-		io_put_req(req);
-		io_req_complete(req, ret);
+		io_req_complete_failed(req, ret);
 		if (link->head) {
 			/* fail even hard links since we don't submit */
 			link->head->flags |= REQ_F_FAIL_LINK;
-			io_put_req(link->head);
-			io_req_complete(link->head, -ECANCELED);
+			io_req_complete_failed(link->head, -ECANCELED);
 			link->head = NULL;
 		}
 		return ret;
@@ -8601,9 +8602,7 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 	while (!list_empty(&list)) {
 		de = list_first_entry(&list, struct io_defer_entry, list);
 		list_del_init(&de->list);
-		req_set_fail_links(de->req);
-		io_put_req(de->req);
-		io_req_complete(de->req, -ECANCELED);
+		io_req_complete_failed(de->req, -ECANCELED);
 		kfree(de);
 	}
 }
-- 
2.24.0

