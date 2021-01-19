Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1695D2FBA6B
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391668AbhASOyt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394347AbhASNhT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:37:19 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5939EC061757
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:35 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id c12so1231299wrc.7
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dJ05tp8vgoP1wxNPmYpulk1zJOkqd6m1mhJVqI3tIM8=;
        b=iV99LzuD+zjSxAhej/ZQrFHiKUcUbDFcHcmlZ8x/TerVxxgDvrjAtg439pzTrge4kG
         sYb2ewscjlOzZZXHHQZq2wo230xboGxQRf4fBwOBDfKQBY6ZaaWCVEkDE4TODpJfVIZs
         7TEfuysxuDlxMquYGb+Kdkxq9UwA5f4GSrhd25XR2AjrKwPa6WOudYMI5bcyAC0p017r
         YUgEsk4nj93nG7zvBW14B/1wbal/4HfhEdmrgO+VqrEoX3o3hyl7i3Nj2B/sneFcBC7k
         3fNqBW1BjPlJP4tDQDkPc7bvu9KRMhn1vaLztzkJOzcuELovR+eRxqyllPEaOmWhwytt
         eGNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dJ05tp8vgoP1wxNPmYpulk1zJOkqd6m1mhJVqI3tIM8=;
        b=O88GshnmtdBsAiORg7ckY8RUO1OdgsxvuLHNjBaQOATlbNMmtn0KCODmaOYC0HIDor
         3oX3bO4+OUd1kC0Mel1IuZHOvY0rti0vcIN1P4FexlX81HLWt7+XKGK4JPV212lMXE4t
         QMQtP82tnREEGsHLupOpPRhRiQb8OEKqyYpnqMtD/DmzrljuzPR39ML04wNZI8jksEXM
         5rMpUtWOQ2rHtyITlDBzfM6LhL3CXLolNcgBsdij/E85mxKEEpB2I9n/BsKOmZ7IIHHq
         pGFGWWA52HdGYkfgpg1TdacT2VOgEm0vHjXKl+p8QRNqcCqOYzt3jgMXqdayq/dOH255
         aeTw==
X-Gm-Message-State: AOAM530xokwzrhSJ39xIkUJzKq9ThDcS4bBH9ndRcGT0Ea2AVv/EGtNO
        DQatKKVEqX2jpsDV19Oc1HDbawpOCfVWqg==
X-Google-Smtp-Source: ABdhPJx15AqDg3t3dvlnDNGtG+06ehAepWFJu8Cn8yEKpmNDf/M21KuBtyggVz+ZXfbdtwkeccIQmA==
X-Received: by 2002:adf:db51:: with SMTP id f17mr4577577wrj.83.1611063394209;
        Tue, 19 Jan 2021 05:36:34 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:33 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/14] io_uring: refactor io_resubmit_prep()
Date:   Tue, 19 Jan 2021 13:32:35 +0000
Message-Id: <9b6b370cbbde34b467079c42aedca0a6e884a199.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
References: <cover.1611062505.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's awkward to pass return a value into a function for it to return it
back. Check it at the caller site and clean up io_resubmit_prep() a bit.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7f4bc5092b5c..eb8bee704374 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2664,17 +2664,16 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res,
 }
 
 #ifdef CONFIG_BLOCK
-static bool io_resubmit_prep(struct io_kiocb *req, int error)
+static bool io_resubmit_prep(struct io_kiocb *req)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	ssize_t ret = -ECANCELED;
 	struct iov_iter iter;
 	int rw;
 
-	if (error) {
-		ret = error;
-		goto end_req;
-	}
+	/* already prepared */
+	if (req->async_data)
+		return true;
 
 	switch (req->opcode) {
 	case IORING_OP_READV:
@@ -2690,22 +2689,16 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
 	default:
 		printk_once(KERN_WARNING "io_uring: bad opcode in resubmit %d\n",
 				req->opcode);
-		goto end_req;
+		return false;
 	}
 
-	if (!req->async_data) {
-		ret = io_import_iovec(rw, req, &iovec, &iter, false);
-		if (ret < 0)
-			goto end_req;
-		ret = io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
-		if (!ret)
-			return true;
-		kfree(iovec);
-	} else {
+	ret = io_import_iovec(rw, req, &iovec, &iter, false);
+	if (ret < 0)
+		return false;
+	ret = io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
+	if (!ret)
 		return true;
-	}
-end_req:
-	req_set_fail_links(req);
+	kfree(iovec);
 	return false;
 }
 #endif
@@ -2726,12 +2719,12 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 
 	ret = io_sq_thread_acquire_mm_files(req->ctx, req);
 
-	if (io_resubmit_prep(req, ret)) {
+	if (!ret && io_resubmit_prep(req)) {
 		refcount_inc(&req->refs);
 		io_queue_async_work(req);
 		return true;
 	}
-
+	req_set_fail_links(req);
 #endif
 	return false;
 }
-- 
2.24.0

