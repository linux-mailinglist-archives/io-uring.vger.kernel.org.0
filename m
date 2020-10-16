Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04108290924
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410546AbgJPQCw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395555AbgJPQCw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:52 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFCFC061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:51 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id j7so1714400pgk.5
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=InOHJhWH8qF3IH4DcmanO5TmA8z9yelevFtyCOy/z0w=;
        b=yuRXXRZvTeKXuAtSxbjc54OUCi0hxNz9dP5CZxQULGmwW+XVdkauMENIxx1JD6A0/v
         1WPWA1gTBOsdQ2r2UC9G4s19KIiqItagjCTljxWfMOxfQZdUfUIbE/0aWVdQs2410tWu
         wCab5E5vNl12KuQLCll9fvPKkycGgCxcbtEQlBsdIhrYwz6RkZyhymFdqlkLNWpGZFHD
         z4+/AGNQ8SL8Vx+4eQ9poikQD/JgJW+L94U1/gKtIXqAhfq7gSuw5OL7aZGEjWgM/OMb
         ZxRbbib/Qq0DSkHOma0YnpMQyIVAcmN+2rfgiVJzKZBi8/iRz9rYhLOT6ROPsmruygf0
         H6TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=InOHJhWH8qF3IH4DcmanO5TmA8z9yelevFtyCOy/z0w=;
        b=hDDdH1s/MKm3PSdsK5iovz0KkiJaBxEw9eM7mwzLfu4DPGNC9lhyRJKqhT/Isc/xja
         cU9/896OrBHlRu94NTuYB+iSXBvBay5IKXxm2IcKsTcoqbXfUyTNIIETl+w7n3ms4ad+
         Ao4UTLzqVI/gy11mbTi0gpg64qCxCaNHG4NYLaifH1Gr2bE+luv8B5k5XNTGody/TRw+
         7foym3iix8vHHITk9zm7BjPPVSBqVrowgRKMxQ3UPYK3rt2W81YwGf3KOa5shBrwwZ5H
         wlCYBTAi5x8kQoFHpwVCd7S2Wm8d1sBRPC1AgHA53E0cjDy8Tz+pjuUmanlp+syGs4L0
         2bYw==
X-Gm-Message-State: AOAM532QGE9vg1FBFr0m1EYj7RqgNNk4wn1gwZPSngIGTqWLuVEITzsx
        UFjQ4TWT699Kn16nqBw4tiknO3wxIJrUVszM
X-Google-Smtp-Source: ABdhPJxARI3BWjjin/f36TuTb48p0wuKqcRug/NPhvXoM93GMdvQpnv1CZjegtAg8Cwu6on7rda74g==
X-Received: by 2002:a62:1c8f:0:b029:156:6ebd:3361 with SMTP id c137-20020a621c8f0000b02901566ebd3361mr4455394pfc.42.1602864169614;
        Fri, 16 Oct 2020 09:02:49 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:48 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 17/18] io_uring: assign new io_identity for task if members have changed
Date:   Fri, 16 Oct 2020 10:02:23 -0600
Message-Id: <20201016160224.1575329-18-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This avoids doing a copy for each new async IO, if some parts of the
io_identity has changed. We avoid reference counting for the normal
fast path of nothing ever changing.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c            | 19 +++++++++++++++----
 include/linux/io_uring.h |  3 ++-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bc16327a6481..5af6dafcc669 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1066,12 +1066,18 @@ static void io_init_identity(struct io_identity *id)
  */
 static inline void io_req_init_async(struct io_kiocb *req)
 {
+	struct io_uring_task *tctx = current->io_uring;
+
 	if (req->flags & REQ_F_WORK_INITIALIZED)
 		return;
 
 	memset(&req->work, 0, sizeof(req->work));
 	req->flags |= REQ_F_WORK_INITIALIZED;
-	req->work.identity = &current->io_uring->identity;
+
+	/* Grab a ref if this isn't our static identity */
+	req->work.identity = tctx->identity;
+	if (tctx->identity != &tctx->__identity)
+		refcount_inc(&req->work.identity->count);
 }
 
 static inline bool io_async_submit(struct io_ring_ctx *ctx)
@@ -1179,7 +1185,7 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 
 static void io_put_identity(struct io_uring_task *tctx, struct io_kiocb *req)
 {
-	if (req->work.identity == &tctx->identity)
+	if (req->work.identity == &tctx->__identity)
 		return;
 	if (refcount_dec_and_test(&req->work.identity->count))
 		kfree(req->work.identity);
@@ -1254,11 +1260,12 @@ static bool io_identity_cow(struct io_kiocb *req)
 	refcount_inc(&id->count);
 
 	/* drop old identity, assign new one. one ref for req, one for tctx */
-	if (req->work.identity != &tctx->identity &&
+	if (req->work.identity != tctx->identity &&
 	    refcount_sub_and_test(2, &req->work.identity->count))
 		kfree(req->work.identity);
 
 	req->work.identity = id;
+	tctx->identity = id;
 	return true;
 }
 
@@ -7684,7 +7691,8 @@ static int io_uring_alloc_task_context(struct task_struct *task)
 	tctx->in_idle = 0;
 	atomic_long_set(&tctx->req_issue, 0);
 	atomic_long_set(&tctx->req_complete, 0);
-	io_init_identity(&tctx->identity);
+	io_init_identity(&tctx->__identity);
+	tctx->identity = &tctx->__identity;
 	task->io_uring = tctx;
 	return 0;
 }
@@ -7694,6 +7702,9 @@ void __io_uring_free(struct task_struct *tsk)
 	struct io_uring_task *tctx = tsk->io_uring;
 
 	WARN_ON_ONCE(!xa_empty(&tctx->xa));
+	WARN_ON_ONCE(refcount_read(&tctx->identity->count) != 1);
+	if (tctx->identity != &tctx->__identity)
+		kfree(tctx->identity);
 	kfree(tctx);
 	tsk->io_uring = NULL;
 }
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index bd3346194bca..607d14f61132 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -24,7 +24,8 @@ struct io_uring_task {
 	struct wait_queue_head	wait;
 	struct file		*last;
 	atomic_long_t		req_issue;
-	struct io_identity	identity;
+	struct io_identity	__identity;
+	struct io_identity	*identity;
 
 	/* completion side */
 	bool			in_idle ____cacheline_aligned_in_smp;
-- 
2.28.0

