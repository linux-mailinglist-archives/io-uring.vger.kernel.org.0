Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFE4334BDF
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbhCJWor (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233988AbhCJWoi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:38 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5058C061761
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:20 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d23so6023352plq.2
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r9XFkReTLkzFRXIBuwwNwR484zcFdJuoSDjnAE+1n/s=;
        b=ezpbd5wUR6IuEmG7GmW9PJfsSeiOUjb3brHKmMtudZMhoPE6jZnhkw0Q3ffUFnTuiR
         qryfpCbYQEwQQRizba0etH3OVeNcFbm7NtGSvGNF8geBJbGwnjzZV6yaIdleX58E5KSQ
         2au+OJA6m5qEc7blsT4nVZyQOmiMN+FfzVAPKRNfinaMhC+K4jYOm25yh7lLCuvIcfxi
         RMimYZQRPHbe1tjFBwghN4uFUkWAh95svk6BmazvSvKaQbfdXEdNxMZIAkDQLjVGoTe7
         oM4ckblD0HtySVYO6Epk1WID0Q0JbfrrkD/ngDNrc5oCkhNt+zzSwWyoZm9pC+wl/uz8
         7sjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r9XFkReTLkzFRXIBuwwNwR484zcFdJuoSDjnAE+1n/s=;
        b=DYExgC+CjZhYRpSixDlOliT/14vFc9YnhtuBkwOVp4NHFLJanSS/WC4Vz3EZcVSKqW
         w+p5g5kznEASeDIwp6APyzmuta/9UyhvUDUwv4QyFcxlbOQLhoSHDMMPFI+PqZ1JwlyI
         zeH3ZjBQ6B/ZEbNXt4eh4XyPY4SU16WsmkeREcVC462xMNtMctEIyyvw8mdGbI0wXK+t
         jsfzYWWoisLsfrW7CtzoiGoNj+ceKRqQ8d0ejaQiWUFVvO3huD/Z3n/UGcHNQjX0SN+k
         kIb99Bx0XrS0ZHSGg15bsv+u0UqA/M4hlWWO9Ebh58sxQ+HWDwiIEfbQqjIF978d1sQE
         RGBw==
X-Gm-Message-State: AOAM531QbC+Gi4YmYwjxeGJBE+WxUZ94vBc7fEeXv/0vQY9lWHnnUNoP
        tZcya2WtUkJPoOGL1lGp6zkVuZn42ahDQw==
X-Google-Smtp-Source: ABdhPJyBUZkR/eo85P6KXZqCoQDEGylWNZiZroFr2Zp7SXNn+Q5YgR3OZT3InmqjCPZeKGC4DpWCzA==
X-Received: by 2002:a17:903:1cb:b029:e5:f712:c13c with SMTP id e11-20020a17090301cbb02900e5f712c13cmr4931447plh.22.1615416258761;
        Wed, 10 Mar 2021 14:44:18 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:18 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 14/27] io_uring: fix unrelated ctx reqs cancellation
Date:   Wed, 10 Mar 2021 15:43:45 -0700
Message-Id: <20210310224358.1494503-15-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

io-wq now is per-task, so cancellations now should match against
request's ctx.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2a3542b487ff..d4f018f5838d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5573,22 +5573,30 @@ static int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+struct io_cancel_data {
+	struct io_ring_ctx *ctx;
+	u64 user_data;
+};
+
 static bool io_cancel_cb(struct io_wq_work *work, void *data)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_cancel_data *cd = data;
 
-	return req->user_data == (unsigned long) data;
+	return req->ctx == cd->ctx && req->user_data == cd->user_data;
 }
 
-static int io_async_cancel_one(struct io_uring_task *tctx, void *sqe_addr)
+static int io_async_cancel_one(struct io_uring_task *tctx, u64 user_data,
+			       struct io_ring_ctx *ctx)
 {
+	struct io_cancel_data data = { .ctx = ctx, .user_data = user_data, };
 	enum io_wq_cancel cancel_ret;
 	int ret = 0;
 
-	if (!tctx->io_wq)
+	if (!tctx || !tctx->io_wq)
 		return -ENOENT;
 
-	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, sqe_addr, false);
+	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, &data, false);
 	switch (cancel_ret) {
 	case IO_WQ_CANCEL_OK:
 		ret = 0;
@@ -5611,8 +5619,7 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	unsigned long flags;
 	int ret;
 
-	ret = io_async_cancel_one(req->task->io_uring,
-					(void *) (unsigned long) sqe_addr);
+	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
 	if (ret != -ENOENT) {
 		spin_lock_irqsave(&ctx->completion_lock, flags);
 		goto done;
-- 
2.30.2

