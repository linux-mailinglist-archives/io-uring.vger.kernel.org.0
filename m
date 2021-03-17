Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1358E33F589
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 17:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhCQQaS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 12:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbhCQQaB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 12:30:01 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E592BC06175F
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:50 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id t7so2066922ilq.5
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jO4oiPILsaLvISvBx5PhxlqmUgNbtPcV1DaNI/siKFc=;
        b=JXGCyd1Lyvf0tCw5tfQLnUUAl4iblI+3PU0oeAdY8X3Qd1PhgR2mu52p8xsiU+OivP
         5XUK+BZilW5z+jxhysGwHpPEAgpcjZR0feZPLO1R2m3lSct8ZUTOG0kJ6W/hYYK6AVLV
         An2t9e5DH2qcnleJDjM4mNuX5z5xElsnY/1hnXTIgFCUt6wFCh6gJfOLQmMaxLFyYNiJ
         wpM+lwedTXjXYfTAEAQJetDl+pAulmDK/R4m1sr0gn9yRa7uoGRUCMNYTE0ktRRUgtML
         Fvbzv7bWEOaxZRz4jvKMgCqrJebpe6mvsZ3BDZPXgBEgLHET5whgYDfVNHvJL9UTS/av
         VezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jO4oiPILsaLvISvBx5PhxlqmUgNbtPcV1DaNI/siKFc=;
        b=R8DQ1g+pS3HJilC/xXg0fOCKd2AdVcSETEq7/IWKbMltSp3csKV9xyWWkD4v+zubx1
         tEGb8u9us74qyRnTQhcbkbgmmtfwWIVf7EGTNF5+G8Zmax0OERrD90K9FW1uyMD6wiqW
         yu0bW0U/uSBA9pQpg/4kwqVnp1yZ4weTu1cnqvRZ46vE3oC0dgmwzvkyXCpAHKUNDMgG
         8loFAr+0VT0jBdLuRqZjneu9d4RwBWqumbb+YIKbuoSFfj1ZsXC7iU4HiRxGzH70jsng
         Ei/xq+/F3D2Kl+lysP1mw/TnstBP1deGOAFH/YgluG/Tbbhzm/cf7THfbWU5pLxDDUVS
         4PuQ==
X-Gm-Message-State: AOAM531+CGp9mebML1/22ouMtWB5A5HQtnCJGF+RgDBKYmOSVQOZE/4i
        H6v507qq1ZZdnpngUaBH7MIxqJMLVgLKmA==
X-Google-Smtp-Source: ABdhPJxq6CvieWl6g7syNTv/HWXt+k06uefGyeaBWE5nMv5BbmYPJxKgaLDtVO/xaymTp0Yavn1rOw==
X-Received: by 2002:a05:6e02:c7:: with SMTP id r7mr8022292ilq.288.1615998590158;
        Wed, 17 Mar 2021 09:29:50 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h1sm11164271ilo.64.2021.03.17.09.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:29:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/9] io_uring: terminate multishot poll for CQ ring overflow
Date:   Wed, 17 Mar 2021 10:29:41 -0600
Message-Id: <20210317162943.173837-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317162943.173837-1-axboe@kernel.dk>
References: <20210317162943.173837-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we hit overflow and fail to allocate an overflow entry for the
completion, terminate the multishot poll mode.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e4a3fa8b1863..8a37a62c04f9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1029,6 +1029,7 @@ static void io_rsrc_put_work(struct work_struct *work);
 static void io_req_task_queue(struct io_kiocb *req);
 static void io_submit_flush_completions(struct io_comp_state *cs,
 					struct io_ring_ctx *ctx);
+static bool io_poll_remove_waitqs(struct io_kiocb *req);
 static int io_req_prep_async(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
@@ -1504,7 +1505,7 @@ static inline void req_ref_get(struct io_kiocb *req)
 	atomic_inc(&req->refs);
 }
 
-static void __io_cqring_fill_event(struct io_kiocb *req, long res,
+static bool __io_cqring_fill_event(struct io_kiocb *req, long res,
 				   unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1522,7 +1523,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res,
 		WRITE_ONCE(cqe->user_data, req->user_data);
 		WRITE_ONCE(cqe->res, res);
 		WRITE_ONCE(cqe->flags, cflags);
-		return;
+		return true;
 	}
 	if (!ctx->cq_overflow_flushed &&
 	    !atomic_read(&req->task->io_uring->in_idle)) {
@@ -1540,7 +1541,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res,
 		ocqe->cqe.res = res;
 		ocqe->cqe.flags = cflags;
 		list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
-		return;
+		return true;
 	}
 overflow:
 	/*
@@ -1549,6 +1550,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res,
 	 * on the floor.
 	 */
 	WRITE_ONCE(ctx->rings->cq_overflow, ++ctx->cached_cq_overflow);
+	return false;
 }
 
 static void io_cqring_fill_event(struct io_kiocb *req, long res)
@@ -4917,14 +4919,14 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 		error = -ECANCELED;
 		req->poll.events |= EPOLLONESHOT;
 	}
-	if (error || (req->poll.events & EPOLLONESHOT)) {
-		io_poll_remove_double(req);
+	if (!error)
+		error = mangle_poll(mask);
+	if (!__io_cqring_fill_event(req, error, flags) ||
+	    (req->poll.events & EPOLLONESHOT)) {
+		io_poll_remove_waitqs(req);
 		req->poll.done = true;
 		flags = 0;
 	}
-	if (!error)
-		error = mangle_poll(mask);
-	__io_cqring_fill_event(req, error, flags);
 	io_commit_cqring(ctx);
 	return !(flags & IORING_CQE_F_MORE);
 }
@@ -5217,6 +5219,8 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 {
 	bool do_complete = false;
 
+	if (!poll->head)
+		return false;
 	spin_lock(&poll->head->lock);
 	WRITE_ONCE(poll->canceled, true);
 	if (!list_empty(&poll->wait.entry)) {
-- 
2.31.0

