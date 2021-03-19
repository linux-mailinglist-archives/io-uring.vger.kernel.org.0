Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22A6342701
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 21:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCSUfi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 16:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhCSUf2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 16:35:28 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4629C06175F
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:28 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso5407629pjb.4
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NTfqarHXyHM9Y5Qfs+wFX8dfZ3lLLfGFPc0fdlVJS9g=;
        b=z7NNKcZSlV8VBrfbhPKJylDGVp0Z7g8ONAnF8Snf84XJkRZz6fSn3H4wyjfQ4RXpio
         jNuwbLQyfFt/1eNCIGbvaPhiPgjgcmMtLXY9Yt07oWVrbt8d6/g08fnTJzSizz/W9jPx
         emoICY/wbkpblmg4aZJxIUu4NknAt8KDz0Ran/7XVjBbXl+h+C6bwKGKbRgHLjvbwJRI
         AYAB3ov6EZx/gSlqw8tytZpFEla2lmBJCcKAGftMsMvkYA/J+IwVFxb253T3FYOaeJBq
         LBTSNqZOuMGaD4uLmYv15OBBHNNPVrcdrWuuqG5HgHCVqjbk1AIqMZNSRfaW5W8o3D7o
         /8fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NTfqarHXyHM9Y5Qfs+wFX8dfZ3lLLfGFPc0fdlVJS9g=;
        b=NAykjrFFbigYL88PTSr7hqITnY2j4CpoJVFlfMUjvQoOh4biFPA3DM7qd97W/pgf7r
         wUH9iV/9+ohwESLQG2JWyGTxM/xLZrqArt136cJfu3w6ogiRNbGDr558KrbDYHV2TP3Y
         6kwPSVXlY0P3vcY+VAHZEvhXkJeSaGb0ic2tuU58yzBKBU+ZHFZ4fiogCm/AAT+nbQoR
         8MeRaVONX8YfM7fmiDkpOHYOHXFYUsi2NZCUiQOy2LM7D1JzZHwuVQBZs647PHCHj8ot
         BBQcuieCr6kAeZDpF85GmVtWauogUGEyfzCNPpysNKIopLtpFOj5DFSh5ZF0scZxPKif
         h3pQ==
X-Gm-Message-State: AOAM533H2G7CL4JqK67QqTO5KlRwyr1Qh/08Sr0jtL8CsnHjSfre6WAQ
        ytwwQ1rja8qTz1HT+SmNa++4MpwIiZrj9Q==
X-Google-Smtp-Source: ABdhPJy/6gvKstpzjJpF+VBSvnpR0GIgZpqRjqdZ6kB5ZWU6EcTkVoD7juEQ/dnH1zhd1wbGCRLuAg==
X-Received: by 2002:a17:903:230e:b029:e6:99d4:e136 with SMTP id d14-20020a170903230eb02900e699d4e136mr16001730plh.26.1616186128095;
        Fri, 19 Mar 2021 13:35:28 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b17sm6253498pfp.136.2021.03.19.13.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 13:35:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/8] io_uring: terminate multishot poll for CQ ring overflow
Date:   Fri, 19 Mar 2021 14:35:14 -0600
Message-Id: <20210319203516.790984-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319203516.790984-1-axboe@kernel.dk>
References: <20210319203516.790984-1-axboe@kernel.dk>
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
index 53378003bd3b..103daef0db34 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1044,6 +1044,7 @@ static void io_rsrc_put_work(struct work_struct *work);
 static void io_req_task_queue(struct io_kiocb *req);
 static void io_submit_flush_completions(struct io_comp_state *cs,
 					struct io_ring_ctx *ctx);
+static bool io_poll_remove_waitqs(struct io_kiocb *req);
 static int io_req_prep_async(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
@@ -1513,7 +1514,7 @@ static inline void req_ref_get(struct io_kiocb *req)
 	atomic_inc(&req->refs);
 }
 
-static void __io_cqring_fill_event(struct io_kiocb *req, long res,
+static bool __io_cqring_fill_event(struct io_kiocb *req, long res,
 				   unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1531,7 +1532,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res,
 		WRITE_ONCE(cqe->user_data, req->user_data);
 		WRITE_ONCE(cqe->res, res);
 		WRITE_ONCE(cqe->flags, cflags);
-		return;
+		return true;
 	}
 	if (!ctx->cq_overflow_flushed &&
 	    !atomic_read(&req->task->io_uring->in_idle)) {
@@ -1549,7 +1550,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res,
 		ocqe->cqe.res = res;
 		ocqe->cqe.flags = cflags;
 		list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
-		return;
+		return true;
 	}
 overflow:
 	/*
@@ -1558,6 +1559,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res,
 	 * on the floor.
 	 */
 	WRITE_ONCE(ctx->rings->cq_overflow, ++ctx->cached_cq_overflow);
+	return false;
 }
 
 static void io_cqring_fill_event(struct io_kiocb *req, long res)
@@ -4905,14 +4907,14 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
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
@@ -5203,6 +5205,8 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 {
 	bool do_complete = false;
 
+	if (!poll->head)
+		return false;
 	spin_lock(&poll->head->lock);
 	WRITE_ONCE(poll->canceled, true);
 	if (!list_empty(&poll->wait.entry)) {
-- 
2.31.0

