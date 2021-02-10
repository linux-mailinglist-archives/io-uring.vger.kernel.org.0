Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB011315AFE
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbhBJATo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235107AbhBJAKi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:10:38 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49221C0617A7
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:26 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id 190so326260wmz.0
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1u+U17K4y8WRRzrpJ7Epz2p6YfUDqOszhUKsm/4BsMI=;
        b=Q5lNd6TKQk3p1HJctx1/Akl55Cf6vPSTtgQrTiqTHiwcud1NZ9sEMK7GHQUT8Uz8xt
         640hnDEnvQgT/4jTTwBzDxAdXUtng8kO13WgSTOlWuay1WsfbMmM9OkE3ddOUL8LaPzg
         D9JjVm1DLTehEPSHR+L/7N3nA+VPo6OGMe5CWdSStNMzVU6WciKxYVpPhQcsZhQv1IdB
         vD9/J1Aw7ECmD8eJkN8e4fHzQzKXMm10Zy9Vman+4a2wx3cAzrrjNsGrttrou8z77Von
         VG2eByMP649+47EluGRokk/Lq8gzW3pnHfEiHzrBHxkjVewdKAQFKoNek4kA+RZ12EZQ
         paMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1u+U17K4y8WRRzrpJ7Epz2p6YfUDqOszhUKsm/4BsMI=;
        b=krTITyyK4iZOZlpxFupqkyuNRfCigQKt1/w/t7n4jkZrRHHbhzoKkX7eaWL0btDVJP
         Bu9AxPHmMdF7xkTJE5Bpxuij14JgOq7l7iDoA3GYICvjo7I3wuejXeG34V1Q9yGYPTUE
         rwC1D/Mf7uK88dxVnob6fevoouRkMYmGL/5e9RhYJkUKfAMUa+JXdxSgRme/smUzquqh
         ltfKAHyOEREsVkKM6TW+Qj84YOZNBnG4vlAbL4pINP3Pte53qaun+mys6pmCnjzl+VHV
         NmjbW6hKYsgtIUSIwoiiep7Gw1Nn+FXNGq9Mvr8cAqiPS9f2H2DHP3Yeq6mHhJKVlRHv
         a/hw==
X-Gm-Message-State: AOAM531bQAM98DJhXjeIpE861bGTcjc5oTvDd3VJvA1EhMbOum/XDKng
        vIt8XBgUS2fveHbTHOjOK5s=
X-Google-Smtp-Source: ABdhPJx/JoEU+lIWG4TP45M5DbJKgsqlyon6y9cm7V1tXzl8B6NRdnaQXD1gi1h2WCNniRAdTjWygA==
X-Received: by 2002:a05:600c:1909:: with SMTP id j9mr485089wmq.42.1612915645057;
        Tue, 09 Feb 2021 16:07:25 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/17] io_uring: count ctx refs separately from reqs
Date:   Wed, 10 Feb 2021 00:03:16 +0000
Message-Id: <8138f044ce407f8abaf26a08c0399903803fcc38.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently batch free handles request memory freeing and ctx ref putting
together. Separate them and use different counters, that will be needed
for reusing reqs memory.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index be940db96fb8..c1f7dd17a62f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2233,6 +2233,7 @@ static void io_free_req(struct io_kiocb *req)
 struct req_batch {
 	void *reqs[IO_IOPOLL_BATCH];
 	int to_free;
+	int ctx_refs;
 
 	struct task_struct	*task;
 	int			task_refs;
@@ -2242,6 +2243,7 @@ static inline void io_init_req_batch(struct req_batch *rb)
 {
 	rb->to_free = 0;
 	rb->task_refs = 0;
+	rb->ctx_refs = 0;
 	rb->task = NULL;
 }
 
@@ -2249,7 +2251,6 @@ static void __io_req_free_batch_flush(struct io_ring_ctx *ctx,
 				      struct req_batch *rb)
 {
 	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
-	percpu_ref_put_many(&ctx->refs, rb->to_free);
 	rb->to_free = 0;
 }
 
@@ -2262,6 +2263,8 @@ static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 		io_put_task(rb->task, rb->task_refs);
 		rb->task = NULL;
 	}
+	if (rb->ctx_refs)
+		percpu_ref_put_many(&ctx->refs, rb->ctx_refs);
 }
 
 static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
@@ -2275,6 +2278,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 		rb->task_refs = 0;
 	}
 	rb->task_refs++;
+	rb->ctx_refs++;
 
 	io_dismantle_req(req);
 	rb->reqs[rb->to_free++] = req;
-- 
2.24.0

