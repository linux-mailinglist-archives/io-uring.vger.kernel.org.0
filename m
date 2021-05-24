Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4EA238F67C
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 01:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhEXXxE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 19:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEXXxC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 19:53:02 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FB4C061756
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:32 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x7so10575838wrt.12
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=e3gWDMQqg1iYjy4onIm0wRLGJ3XGBaM+kXUZLs/Ftr4=;
        b=WY7UjWRtLxqZP4XSr1j3oIJNQtbiknnE+OhgcMms6OQyzRlw9NYC5FNYVeKoxmcOdp
         SKTqPcYYV1XT3fvhwtJt/4p2+GS+CP7pW9AXshrz1sws6cSY3cVfUUve+YUg/sJYHMGU
         fTfKeyY3E5VXsvFhTe0pCK8feKpss2XjULqOh+EJ6Lo5FQpypvYAbX7D8+pcEYe0j4KV
         BeT48eRERAIy0ScZ+o56m/BfoR+XlCZpJ9v4mTWBubuNyuYs+HKZS8k5iyubb1L+v2DU
         KrE5ZzMFGYDkJV+VQJlcpmp1zmyEMb12tbVMvthDAazGQ/NsEiZ+IN0lgtIeE141K10X
         EgEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e3gWDMQqg1iYjy4onIm0wRLGJ3XGBaM+kXUZLs/Ftr4=;
        b=RzM9S2KxdWCUR9wiROCpw1zDMpnIp+ICkODXCAyac6CYoDNmbjxEaonNWnCr98VNpR
         Jn9Q+n7g/coylMv+efGZG6N1wJ9QYeBfsRLp5DikKCDsIlDSHjVBLwjiZNIUCERBdyMO
         a26VNgLwr1TDtndV6ScGMQWsGXp/X8BKQlBESlD6+uWdmE6j0WcOFntINCA8oIcap0P+
         LyaINIkaj5tYfO8eCt6FbKpiYl32mglugXmllCJ9Of8AMIlw4vPZx9ECPFhVF9qMar5u
         tleL5DDrl01tiRdrrXT0NQG/mLNEawC9BSOkNVdTuJBvqLD6dQ6s9EXv03iyRAc7CX4H
         FYWw==
X-Gm-Message-State: AOAM531ajGt1p1C385wii9w2S1LjmozhQYF1BhWwqihjIGOl24Du/w04
        k2gAXkEnn+UOnq6bKO1yIXs=
X-Google-Smtp-Source: ABdhPJxrvzEUyqJ0vTS+WvpaHhvwuCVqD6TYMnsE0QwPrF8cil9A10cVGO0Fz4yi1/sE/D4Kzkn8hQ==
X-Received: by 2002:a5d:4ac6:: with SMTP id y6mr24213595wrs.414.1621900291402;
        Mon, 24 May 2021 16:51:31 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id f7sm8961069wmq.30.2021.05.24.16.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:51:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/13] io_uring: refactor io_iopoll_req_issued
Date:   Tue, 25 May 2021 00:51:02 +0100
Message-Id: <6a21fba2bdb210ec996ee6699017749c17c45018.1621899872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621899872.git.asml.silence@gmail.com>
References: <cover.1621899872.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A simple refactoring of io_iopoll_req_issued(), move in_async inside so
we don't pass it around and save on double checking it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 057fbc8a190c..df1510adaaf7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2520,9 +2520,14 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
  * find it from a io_do_iopoll() thread before the issuer is done
  * accessing the kiocb cookie.
  */
-static void io_iopoll_req_issued(struct io_kiocb *req, bool in_async)
+static void io_iopoll_req_issued(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	const bool in_async = io_wq_current_is_worker();
+
+	/* workqueue context doesn't hold uring_lock, grab it now */
+	if (unlikely(in_async))
+		mutex_lock(&ctx->uring_lock);
 
 	/*
 	 * Track whether we have multiple files in our lists. This will impact
@@ -2549,14 +2554,19 @@ static void io_iopoll_req_issued(struct io_kiocb *req, bool in_async)
 	else
 		list_add_tail(&req->inflight_entry, &ctx->iopoll_list);
 
-	/*
-	 * If IORING_SETUP_SQPOLL is enabled, sqes are either handled in sq thread
-	 * task context or in io worker task context. If current task context is
-	 * sq thread, we don't need to check whether should wake up sq thread.
-	 */
-	if (in_async && (ctx->flags & IORING_SETUP_SQPOLL) &&
-	    wq_has_sleeper(&ctx->sq_data->wait))
-		wake_up(&ctx->sq_data->wait);
+	if (unlikely(in_async)) {
+		/*
+		 * If IORING_SETUP_SQPOLL is enabled, sqes are either handle
+		 * in sq thread task context or in io worker task context. If
+		 * current task context is sq thread, we don't need to check
+		 * whether should wake up sq thread.
+		 */
+		if ((ctx->flags & IORING_SETUP_SQPOLL) &&
+		    wq_has_sleeper(&ctx->sq_data->wait))
+			wake_up(&ctx->sq_data->wait);
+
+		mutex_unlock(&ctx->uring_lock);
+	}
 }
 
 static inline void io_state_file_put(struct io_submit_state *state)
@@ -6210,23 +6220,11 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (creds)
 		revert_creds(creds);
-
 	if (ret)
 		return ret;
-
 	/* If the op doesn't have a file, we're not polling for it */
-	if ((ctx->flags & IORING_SETUP_IOPOLL) && req->file) {
-		const bool in_async = io_wq_current_is_worker();
-
-		/* workqueue context doesn't hold uring_lock, grab it now */
-		if (in_async)
-			mutex_lock(&ctx->uring_lock);
-
-		io_iopoll_req_issued(req, in_async);
-
-		if (in_async)
-			mutex_unlock(&ctx->uring_lock);
-	}
+	if ((ctx->flags & IORING_SETUP_IOPOLL) && req->file)
+		io_iopoll_req_issued(req);
 
 	return 0;
 }
-- 
2.31.1

