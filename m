Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B6031A4AE
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 19:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhBLSp7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 13:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhBLSp4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 13:45:56 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC6BC061756
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 10:45:16 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id v7so320052wrr.12
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 10:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qvyB/qGQyTr0yye2TOTBB0UzYKUZjvhTHgT0V4QK3iE=;
        b=LPty4KtENFyP2ZI9xdXtEGAGjThiTJqGKmSA6LtEIOqY2BP03iD+zghZx7Wpzq7t3B
         hDyyEuy88CBTo7TWMRDaMs1iNjX8HB9cJKaZgHEfmCCaEG9wCEP52dbPXvQyFEGgoJ43
         L0zp97/yYTOsqMzBkTqEhrhDmc6M7bZIh/BRtIwOkrgOj8V5wYIl+G+RaTNtG0g/YOHn
         fl8+0TUjLxPDyMWwWmNtrLQAS6y/FDAaB2mxUqnkfwuSYPW0NR3TiqqhjjFh1RwA7JIr
         Ok7rLL8vzipvBHHW/hTkkEuiKgVRBkzT9W6X6NWV1PGhLR+1xBjyE2kLu+tS4PQk3mjp
         oZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qvyB/qGQyTr0yye2TOTBB0UzYKUZjvhTHgT0V4QK3iE=;
        b=k8ezpE8YTid1gIGrz/2EVHX5FIslvoNOwaqdsQrBFxwUiiVXJNV2dVLDa/jQjADonK
         6l9Co46lmrrC3xh4AxViQfYnSJQHWHd/isBF7EBRDeywsY33MfneusUKEKU8QSQANSRl
         2WuFWAI10EqvLsDxcEynZs1SeYF6aAHvYXQJ4YKrs2/L1+kZBSg5JvF8A619+Dza/LJz
         DEX9s/gSlG0EWCLyvaOn0JA1MfICPMP1ip9kYFmDNAlEDXJK5UwFDgx2hAqZefp1YfT7
         fpZ1myR5nkiwVc1SqVpNonno/L1R0TJnY1w5Lyb+4QxZG59higxPYGpfdMWMhrlG2qFl
         Oc8Q==
X-Gm-Message-State: AOAM532iuyHLzmdtS5GRjujRloLZg64ZtXerElZ/LIvEVR6QUxMOP5w/
        BgPki3oZmXypVbDsx2J7OsRUtuTICuqezA==
X-Google-Smtp-Source: ABdhPJwS5QxVtj55A/L0NOaZByP+bM6+4Cf01owKHm0jdXIcSz3soKyZrt2JAa8Pod1vcU6KwgOKWw==
X-Received: by 2002:a5d:464f:: with SMTP id j15mr5163998wrs.390.1613155515010;
        Fri, 12 Feb 2021 10:45:15 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id e16sm13452830wrt.36.2021.02.12.10.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 10:45:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: don't check PF_EXITING from syscall
Date:   Fri, 12 Feb 2021 18:41:15 +0000
Message-Id: <e1a79da7b17f8c4982990a7989fdcd2e9ecae70a.1613154861.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613154861.git.asml.silence@gmail.com>
References: <cover.1613154861.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_sq_thread_acquire_mm_files() can find a PF_EXITING task only when
it's called from task_work context. Don't check it in all other cases,
that are when we're in io_uring_enter().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9c58be0579f3..66bbb0dc50af 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1213,8 +1213,6 @@ static int __io_sq_thread_acquire_mm_files(struct io_ring_ctx *ctx,
 static inline int io_sq_thread_acquire_mm_files(struct io_ring_ctx *ctx,
 						struct io_kiocb *req)
 {
-	if (unlikely(current->flags & PF_EXITING))
-		return -EFAULT;
 	if (!(ctx->flags & IORING_SETUP_SQPOLL))
 		return 0;
 	return __io_sq_thread_acquire_mm_files(ctx, req);
@@ -2338,7 +2336,8 @@ static void __io_req_task_submit(struct io_kiocb *req)
 
 	/* ctx stays valid until unlock, even if we drop all ours ctx->refs */
 	mutex_lock(&ctx->uring_lock);
-	if (!ctx->sqo_dead && !io_sq_thread_acquire_mm_files(ctx, req))
+	if (!ctx->sqo_dead && !(current->flags & PF_EXITING) &&
+	    !io_sq_thread_acquire_mm_files(ctx, req))
 		__io_queue_sqe(req);
 	else
 		__io_req_task_cancel(req, -EFAULT);
-- 
2.24.0

