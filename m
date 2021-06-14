Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2A43A5B62
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 03:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhFNBkA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 21:40:00 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:45006 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbhFNBkA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 21:40:00 -0400
Received: by mail-wm1-f41.google.com with SMTP id m41-20020a05600c3b29b02901b9e5d74f02so8697597wms.3
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/9Om2s4dnvIqafpA9xWzUVzv7LJgVZBSbBDx0TNmf6w=;
        b=qV1u6gdhI6iwPoQuAzd8h10BoT8ls64zoQp6eVZwpT0xZFExeIswqTizuuJyV7GStZ
         YRNDyRfULAfhSeXQYjv9Go6TLRGK7DyL7GcWjbhUbPo2e5+DspRmKD+G4tOAFSL6ZFYb
         S18TtljkpuAgpcQOO8UzuY1Sm+EE+EQy2RwNi7ODieEGpzN6MAzynCgGBBZsSbr6BTI3
         RlLECjmIbwmt2TfxvEE4d7VcZ/2v+iCS5C/tHqiyOzmRD/PS5wbjOeMre+a3mmMDdY7e
         qOiEMatZnkup72oyIKBquB8hog9aDB7dV1YqzYqPGPRvbe5MioahPn3JKf3x8NBwNlOb
         0KvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/9Om2s4dnvIqafpA9xWzUVzv7LJgVZBSbBDx0TNmf6w=;
        b=KJaABGkL2v27GlWwSmnuUPtAk3JCJO/NiPVt4Y8dXfxRmnbHcdhf4JUxXVU3/uLVcZ
         tkBemgmLE0GQTUB+r6i7s0mWpXRAdosItr5hDRrvnT+bJeA5SsSNFLU2R/K+qGP74vq8
         B85BIaA6mTYOdFkjgcds0bnNe/pjeCYtNqjLrB0Kg1IxGmRXsbQO0VypRWlzOGzM7Afr
         vxQkSrQvqPigLRVPS17lawTUhaSV5gn/g01AuDadtmUrFrNA1MytXR1+7Ncy/wbUMQ8Y
         pF4848r7keg/c8EyfMtkoTvabuhUPIBxlv25YkSIA79kXF6poi6LQ7cp+JfA18SBgPu7
         xYNg==
X-Gm-Message-State: AOAM533R/h6vsG6CS0oiO4xIQTQC0lpXVhiW4lAGmx1lfFJup9o1XpBZ
        oMlpy6D4FdOT+fsHd3IICdA=
X-Google-Smtp-Source: ABdhPJz35NggHwE2C/tuuOZ5WOPf9u/AMV2VHojA5jsQdbO8rJmxW8lwCHH2DJnC5zMGqruMctKF3g==
X-Received: by 2002:a05:600c:4282:: with SMTP id v2mr29691520wmc.18.1623634606813;
        Sun, 13 Jun 2021 18:36:46 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id a9sm6795291wrv.37.2021.06.13.18.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:36:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/13] io_uring: refactor io_iopoll_req_issued
Date:   Mon, 14 Jun 2021 02:36:14 +0100
Message-Id: <1513bfde4f0c835be25ac69a82737ab0668d7665.1623634181.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623634181.git.asml.silence@gmail.com>
References: <cover.1623634181.git.asml.silence@gmail.com>
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
index 485f1f055db3..8fbb48c1ac7a 100644
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

