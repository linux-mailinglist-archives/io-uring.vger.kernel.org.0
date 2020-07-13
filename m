Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B84C21E3C3
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2020 01:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGMXnz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 19:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGMXny (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 19:43:54 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0153DC061755;
        Mon, 13 Jul 2020 16:43:54 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id br7so5638351ejb.5;
        Mon, 13 Jul 2020 16:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fXb4jVJW7mmLk6Sy3VEHPZtT/o7C2qEgdAOhqDZkcwI=;
        b=D4Hq3idKmP4ZgV6xUI5b9hx7e+E+AHKbbz1+GKdli07/77L6AqZEmZLdE8Ty6a2OJt
         VAhHGIJjELfknrwa/kx1At1nEZ7P3+SsUHf3vxfIcQGkuSzlU1Es/lLe5H4Nh/Z+aQKr
         +ocO24nOKsQJ8JsrXxz6zDWinHNg+yb94BG6y8MVuj1DiCa3Zati/EXFDx8HX2ag8WPT
         6cPtqXz4/+W+ym7EF5XISpKcfmu/O6aMWHYCtQEYtGqAwMznCWlym0+zzR1yVEDzfjK7
         +cH9AMXTj4QweJS0NPWcmAh6OBxGq1jcb+XmKz6RpVa94aizFm7JAMv3rvF1Tn3t5OGZ
         C1GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fXb4jVJW7mmLk6Sy3VEHPZtT/o7C2qEgdAOhqDZkcwI=;
        b=I18xHvvcqC0EidOJ7lqyGKKW6dualhr4jWiiVKeFCx0YlABxZIiDHnC8dcC/pvdEgv
         fHM1W+jSI0WpYvsLjFVWFcMXkZm4a6VMazyxvIrE7P0K90lsWO0vYYUP7QVZkislOJqj
         jzGUQCYyvG8ywyVde8WGO7Fso8MizFv10aUc+A8J5adIa/qSyN8Bhd3wq6YFPn1GhUxg
         f+1pNbZthaZWb5OOeZklkLzrMQmde5662h23x/CElPuVrWroAbviAODVX0+7gdCwwy7o
         BLdTBzL+Y3RaUaO6N5/KT/UKgk2tOwjUdJ/7vKY3wi2WKj1JFvsqrinp8cbXgayMEpD+
         ZHHg==
X-Gm-Message-State: AOAM531CVHLzeSZMHheYD7piG6k1L1NBUyzkoJmPf3Dx7dt641PYEdLp
        H2W9eETbKJdCJE1UcC79dzUa58PK
X-Google-Smtp-Source: ABdhPJz8KYV2PAY5LiQXK/tmFJuCcy7vv/IG4V91UaHE7WdLgHusSnu62k8bqf2WegStEVs38UeK4A==
X-Received: by 2002:a17:906:3b01:: with SMTP id g1mr2059175ejf.353.1594683832699;
        Mon, 13 Jul 2020 16:43:52 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a13sm12964712edk.58.2020.07.13.16.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 16:43:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] io_uring: move io_req_complete() definition
Date:   Tue, 14 Jul 2020 02:41:52 +0300
Message-Id: <f80a40e508f4e3b10482544060c7a44f4fb96730.1594683622.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594683622.git.asml.silence@gmail.com>
References: <cover.1594683622.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just a preparation patch, moving several functions
(i.e. [__]io_req_complete(), io_submit_flush_completions()) below in
code to avoid extra declarations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 96 +++++++++++++++++++++++++--------------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7038c4f08805..609c7da044d7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1428,54 +1428,6 @@ static void io_cqring_add_event(struct io_kiocb *req, long res, long cflags)
 	io_cqring_ev_posted(ctx);
 }
 
-static void io_submit_flush_completions(struct io_comp_state *cs)
-{
-	struct io_ring_ctx *ctx = cs->ctx;
-
-	spin_lock_irq(&ctx->completion_lock);
-	while (!list_empty(&cs->list)) {
-		struct io_kiocb *req;
-
-		req = list_first_entry(&cs->list, struct io_kiocb, compl.list);
-		list_del(&req->compl.list);
-		__io_cqring_fill_event(req, req->result, req->compl.cflags);
-		if (!(req->flags & REQ_F_LINK_HEAD)) {
-			req->flags |= REQ_F_COMP_LOCKED;
-			io_put_req(req);
-		} else {
-			spin_unlock_irq(&ctx->completion_lock);
-			io_put_req(req);
-			spin_lock_irq(&ctx->completion_lock);
-		}
-	}
-	io_commit_cqring(ctx);
-	spin_unlock_irq(&ctx->completion_lock);
-
-	io_cqring_ev_posted(ctx);
-	cs->nr = 0;
-}
-
-static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags,
-			      struct io_comp_state *cs)
-{
-	if (!cs) {
-		io_cqring_add_event(req, res, cflags);
-		io_put_req(req);
-	} else {
-		io_clean_op(req);
-		req->result = res;
-		req->compl.cflags = cflags;
-		list_add_tail(&req->compl.list, &cs->list);
-		if (++cs->nr >= 32)
-			io_submit_flush_completions(cs);
-	}
-}
-
-static void io_req_complete(struct io_kiocb *req, long res)
-{
-	__io_req_complete(req, res, 0, NULL);
-}
-
 static inline bool io_is_fallback_req(struct io_kiocb *req)
 {
 	return req == (struct io_kiocb *)
@@ -1840,6 +1792,54 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 		__io_req_free_batch_flush(req->ctx, rb);
 }
 
+static void io_submit_flush_completions(struct io_comp_state *cs)
+{
+	struct io_ring_ctx *ctx = cs->ctx;
+
+	spin_lock_irq(&ctx->completion_lock);
+	while (!list_empty(&cs->list)) {
+		struct io_kiocb *req;
+
+		req = list_first_entry(&cs->list, struct io_kiocb, compl.list);
+		list_del(&req->compl.list);
+		__io_cqring_fill_event(req, req->result, req->compl.cflags);
+		if (!(req->flags & REQ_F_LINK_HEAD)) {
+			req->flags |= REQ_F_COMP_LOCKED;
+			io_put_req(req);
+		} else {
+			spin_unlock_irq(&ctx->completion_lock);
+			io_put_req(req);
+			spin_lock_irq(&ctx->completion_lock);
+		}
+	}
+	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+	cs->nr = 0;
+}
+
+static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags,
+			      struct io_comp_state *cs)
+{
+	if (!cs) {
+		io_cqring_add_event(req, res, cflags);
+		io_put_req(req);
+	} else {
+		io_clean_op(req);
+		req->result = res;
+		req->compl.cflags = cflags;
+		list_add_tail(&req->compl.list, &cs->list);
+		if (++cs->nr >= 32)
+			io_submit_flush_completions(cs);
+	}
+}
+
+static void io_req_complete(struct io_kiocb *req, long res)
+{
+	__io_req_complete(req, res, 0, NULL);
+}
+
 /*
  * Drop reference to request, return next in chain (if there is one) if this
  * was the last reference to this request.
-- 
2.24.0

