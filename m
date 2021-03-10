Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0387334BDE
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbhCJWoq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233990AbhCJWoi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:38 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049F7C061762
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:25 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so731455pjb.0
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E7pBDnyOKTvjcmWBXGez/b08P8CsONQ0eoLZuz7mcSk=;
        b=1Vw7BGEiFTn7NT5AyfqqZRj17igUeTeBCvVirXLZIVSmD17wiWL1989iCPUHs4yg2i
         H+HN2aupZ2wCHOau3Qpim9yfnWU5IOyBGlV/YNvHx5v6p1hvjBehhY/WR212MppZ0bN+
         IBmqHLajj/LJr3RKYBb1IL7F+9hVsIdMS84anKW8AOuhfwhBUa+9v+OJPe7L2RLqlNro
         qUPGXN0e7v85Nq89GnqRymV0tSBMUZyAWWa/znmPpTdg8MqP8NCmns9BVt+KmRZ2HOLf
         ciWcMIiC0S5LWnsjuIEBjbLnLhJAi1Xg7wOwZJoQ43pqQzJFQjEchVmI6Yp1puQ9QVIe
         DmKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E7pBDnyOKTvjcmWBXGez/b08P8CsONQ0eoLZuz7mcSk=;
        b=gODUj1dfcnAYFz9tcGBfOgFmGpWQM2+vmo/9sLAkqGiiP/WxN9M4vsNKdhoh3Cf1fF
         mLCX+VXtacimgaGMpqdxdk3zxPHhBjRwFSXPKNIMptogwACnu8lGqZsPNv7Y/GZF8Afb
         QIB1Is2OPQ40qjSRtQTGDYp8AEzuLjAm/YNIjo131rXoO/mU8F0Z+rJs5Xhxe8EdSCR1
         2Pdlq/RliMgsbEp8dDk4RKuvi8p1uzY2Npu/sC+yRFKp1WI41/bDmMF6BLaasgFC5cUb
         NNdnC6UNZwlddrr+nkh4ex3QpmUs9u1ccb1vUHx0NmKBG0IdySJqfm0ReEqWWsqBoYRw
         ZlSw==
X-Gm-Message-State: AOAM533DLlR7bvMl1PyYD4trPfgTzZi+fuw1PVNlmoebIp3m6qWl0sbR
        JI5MiyvBXg4LW/EFmYthiCfc7WAVUDIogg==
X-Google-Smtp-Source: ABdhPJxzvma9gMIbXMOeK+59rCewa7xoBAT0lk9B0TPOrqkoxpoV/tBEs7g8LYy7z21r0u8DJIsmEA==
X-Received: by 2002:a17:90b:514:: with SMTP id r20mr5783422pjz.145.1615416264330;
        Wed, 10 Mar 2021 14:44:24 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:23 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 20/27] io_uring: fix complete_post races for linked req
Date:   Wed, 10 Mar 2021 15:43:51 -0700
Message-Id: <20210310224358.1494503-21-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Calling io_queue_next() after spin_unlock in io_req_complete_post()
races with the other side extracting and reusing this request. Hand
coded parts of io_req_find_next() considering that io_disarm_next()
and io_req_task_queue() have (and safe) to be called with
completion_lock held.

It already does io_commit_cqring() and io_cqring_ev_posted(), so just
reuse it for post io_disarm_next().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/5672a62f3150ee7c55849f40c0037655c4f2840f.1615250156.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cc9a2cc95608..f7153483a3ac 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -985,6 +985,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_UNLINKAT] = {},
 };
 
+static bool io_disarm_next(struct io_kiocb *req);
 static void io_uring_del_task_file(unsigned long index);
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
@@ -1525,15 +1526,14 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 	__io_cqring_fill_event(req, res, 0);
 }
 
-static inline void io_req_complete_post(struct io_kiocb *req, long res,
-					unsigned int cflags)
+static void io_req_complete_post(struct io_kiocb *req, long res,
+				 unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 	__io_cqring_fill_event(req, res, cflags);
-	io_commit_cqring(ctx);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -1541,19 +1541,26 @@ static inline void io_req_complete_post(struct io_kiocb *req, long res,
 	if (refcount_dec_and_test(&req->refs)) {
 		struct io_comp_state *cs = &ctx->submit_state.comp;
 
+		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
+			if (req->flags & (REQ_F_LINK_TIMEOUT | REQ_F_FAIL_LINK))
+				io_disarm_next(req);
+			if (req->link) {
+				io_req_task_queue(req->link);
+				req->link = NULL;
+			}
+		}
 		io_dismantle_req(req);
 		io_put_task(req->task, 1);
 		list_add(&req->compl.list, &cs->locked_free_list);
 		cs->locked_free_nr++;
 	} else
 		req = NULL;
+	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
-
 	io_cqring_ev_posted(ctx);
-	if (req) {
-		io_queue_next(req);
+
+	if (req)
 		percpu_ref_put(&ctx->refs);
-	}
 }
 
 static void io_req_complete_state(struct io_kiocb *req, long res,
-- 
2.30.2

