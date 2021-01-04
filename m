Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDA32E8F58
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 03:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbhADCET (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jan 2021 21:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbhADCES (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jan 2021 21:04:18 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDEFC061798
        for <io-uring@vger.kernel.org>; Sun,  3 Jan 2021 18:03:02 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id c133so17131370wme.4
        for <io-uring@vger.kernel.org>; Sun, 03 Jan 2021 18:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=U4DSsNxpOApCMyAp18i8NA+mZqWx+0v/iK0juWhRG3g=;
        b=rKW9jzOv8WniF0MG6t4CbWVmtGGpyNn1x7zHNhPaXwf5tAqaNEa4rofeuKxcFWS2DF
         7OsZUrM+DNezVdDZlOttFmL9bxfPgKtoXFDE+bfeKzTAzwc/rcGlfI+JvgQ6tWOahGF9
         xYMA/A868hFMMPN2+cJsCVYapNNqqXXIuAttjlpjHavKDRCLeWEJc4y9HpvGG+UBPDHf
         1Y26PPd/4+cDHZJzFxEcDWIm9qIH/JjSu7xZ8oFhyDawu+arS0eJ3muY1B6eGUlpFJfu
         zVWx4qKbS/D9kqv3l5onk13+0jtaXUgObUraGpWC/gr2Jgj/zSEK3cYeo6nIp1mXGyO/
         Mplg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U4DSsNxpOApCMyAp18i8NA+mZqWx+0v/iK0juWhRG3g=;
        b=DHMk9LXtLHc4RSZwEkF5oK6wjfgYP/k+xGqhP/Vo+D4Q9yBw0cl7ggruGYWKgEr5RQ
         QSq7xWl9LXfDzC6oyO3yqJ3OhP8aEuXTXXMKwl/jNO+W4SNCgsxOj6FWL+rqHHb/iQ2h
         dvCuEp0R2W1VCvZqGwcQT2LmZmZQYGyOQYZAKq+0Da/QUIxpLuf4yRmPrWsjgTIspujp
         UlUNbs0esbispzYbAHsC7EHX2AgGwMkWyyo+kPUBicFENNCbIEGuz8KgvxYIGzYXFUJG
         5EhdZU5wSA2FWRk/P15v/U/llubkWaWr1iG7RYgVdvlM18VUw8BOz7Yslq/jKHmlBFbe
         Hj9g==
X-Gm-Message-State: AOAM531QCMWcRibKXeTdXrayak9f4S5KKLg5P6sCoPQOPyo63unMf972
        b9OHURJUDXVtBrC/C6cMvhI=
X-Google-Smtp-Source: ABdhPJy6oqi3WjtJpAW2vAigUFJsXS3QJ4R88IAsF0s2T77kl/xPGzuOciokGrfGfWEo7/wBpJEKBA==
X-Received: by 2002:a7b:cb4f:: with SMTP id v15mr24608065wmj.123.1609725781083;
        Sun, 03 Jan 2021 18:03:01 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id c4sm96632893wrw.72.2021.01.03.18.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 18:03:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 5/6] io_uring: synchronise IOPOLL on task_submit fail
Date:   Mon,  4 Jan 2021 01:59:18 +0000
Message-Id: <f6c471fbf4be3f7e084435e7bacfeeae65b0270a.1609725418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609725418.git.asml.silence@gmail.com>
References: <cover.1609725418.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_task_submit() might be called for IOPOLL, do the fail path under
uring_lock to comply with IOPOLL synchronisation based solely on it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9c554adf3993..1c32d4700caf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2143,14 +2143,14 @@ static void __io_req_task_submit(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	mutex_lock(&ctx->uring_lock);
 	if (!__io_sq_thread_acquire_mm(ctx) &&
 	    !__io_sq_thread_acquire_files(ctx)) {
-		mutex_lock(&ctx->uring_lock);
 		__io_queue_sqe(req, NULL);
-		mutex_unlock(&ctx->uring_lock);
 	} else {
 		__io_req_task_cancel(req, -EFAULT);
 	}
+	mutex_unlock(&ctx->uring_lock);
 }
 
 static void io_req_task_submit(struct callback_head *cb)
-- 
2.24.0

