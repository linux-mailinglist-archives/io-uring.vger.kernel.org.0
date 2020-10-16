Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9438A290922
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410544AbgJPQCu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395555AbgJPQCu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:50 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5EDC061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:50 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id az3so1620282pjb.4
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NQHKas0Gn9TS6uvLzDV1Ljy4BFLlxOJy8R0dn53utUs=;
        b=zmBfmmtS3ANAPqHYWUWTwbDKbq644iXyFikjXb3OSqSzVqyN59/NKnGf3FnzLdfhT/
         HGXsFkL9sTai5OIbe+MKN+xuWZCW5rORv2vPVcFPYXrTC1tWNbn850CvyMQarHo68T21
         vvWN7nQnB0e1RUvBm7HZi0cLgZYM7NB6EFF1dl9FG50Oh0wr1xwjgvS3ZRaSgOf3jVrb
         pVDq77+4e77w7YI+I5/4SyGfx86ulxBQl0xADDQeftSpMmJf7oZ6ljSiYAHFnX2bB8WH
         7JN1n8Owxid2fTlbbsRLwB8cAhXjShKFfeWrGdH6mjFL2zTyy4rBWX/4HxI3djgO5aLe
         dOaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NQHKas0Gn9TS6uvLzDV1Ljy4BFLlxOJy8R0dn53utUs=;
        b=qRCCWqPS0AvL1OLzUj294u4akTHLz2doaGJG4Do3pEl7C90CG4ZYJiDogFryRkykQV
         J9V8KyEtWY4jSo7rfZCgwOZbFHBjO2Xg9kDBDjBnVIiw2OYdeQktuGdYFP3a4QlJoMPQ
         nQ3FaqUb7reZo/a4BMuzC2tku9i/4RJsf2nVHKMwrGcCFBXipAomRKsV4/N3aJfCc9dD
         bU/5Y4uusqRqOI75DfQ6Ku+gelg6F6wNetqZqBgvDQD5vga43Q+ZfOsJ9XDnxZYt5/wG
         p+yPAooZMCHta4XEx6c9AL/JmmPzX3tr+wZ45P7QLe/B2UTBVJLN9oYbnwRKa1EcRocT
         I4Lg==
X-Gm-Message-State: AOAM531rch/3P1J2x7pKrsfMRALwCK3fZTPFlhhQJKwD6Voz3fHZd34K
        0m/o1azZ3N3smhW1+mVUGR5mkboJm+4+L3yR
X-Google-Smtp-Source: ABdhPJxrzepPRlSS83cHkVnuYQmfk0IDQGfX3Mx8P7RLnwoT6ZVkbkek3YJdpBHBY1S8VOVhZxJ72w==
X-Received: by 2002:a17:902:8646:b029:d3:b593:2842 with SMTP id y6-20020a1709028646b02900d3b5932842mr4792385plt.46.1602864168343;
        Fri, 16 Oct 2020 09:02:48 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 16/18] io_uring: store io_identity in io_uring_task
Date:   Fri, 16 Oct 2020 10:02:22 -0600
Message-Id: <20201016160224.1575329-17-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is, by definition, a per-task structure. So store it in the
task context, instead of doing carrying it in each io_kiocb. We're being
a bit inefficient if members have changed, as that requires an alloc and
copy of a new io_identity struct. The next patch will fix that up.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c            | 21 +++++++++++----------
 include/linux/io_uring.h |  1 +
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3a85b8348135..bc16327a6481 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -689,7 +689,6 @@ struct io_kiocb {
 	struct hlist_node		hash_node;
 	struct async_poll		*apoll;
 	struct io_wq_work		work;
-	struct io_identity		identity;
 };
 
 struct io_defer_entry {
@@ -1072,8 +1071,7 @@ static inline void io_req_init_async(struct io_kiocb *req)
 
 	memset(&req->work, 0, sizeof(req->work));
 	req->flags |= REQ_F_WORK_INITIALIZED;
-	io_init_identity(&req->identity);
-	req->work.identity = &req->identity;
+	req->work.identity = &current->io_uring->identity;
 }
 
 static inline bool io_async_submit(struct io_ring_ctx *ctx)
@@ -1179,9 +1177,9 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 	}
 }
 
-static void io_put_identity(struct io_kiocb *req)
+static void io_put_identity(struct io_uring_task *tctx, struct io_kiocb *req)
 {
-	if (req->work.identity == &req->identity)
+	if (req->work.identity == &tctx->identity)
 		return;
 	if (refcount_dec_and_test(&req->work.identity->count))
 		kfree(req->work.identity);
@@ -1220,7 +1218,7 @@ static void io_req_clean_work(struct io_kiocb *req)
 		req->work.flags &= ~IO_WQ_WORK_FS;
 	}
 
-	io_put_identity(req);
+	io_put_identity(req->task->io_uring, req);
 }
 
 /*
@@ -1229,6 +1227,7 @@ static void io_req_clean_work(struct io_kiocb *req)
  */
 static bool io_identity_cow(struct io_kiocb *req)
 {
+	struct io_uring_task *tctx = current->io_uring;
 	const struct cred *creds = NULL;
 	struct io_identity *id;
 
@@ -1255,7 +1254,7 @@ static bool io_identity_cow(struct io_kiocb *req)
 	refcount_inc(&id->count);
 
 	/* drop old identity, assign new one. one ref for req, one for tctx */
-	if (req->work.identity != &req->identity &&
+	if (req->work.identity != &tctx->identity &&
 	    refcount_sub_and_test(2, &req->work.identity->count))
 		kfree(req->work.identity);
 
@@ -1266,7 +1265,7 @@ static bool io_identity_cow(struct io_kiocb *req)
 static bool io_grab_identity(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
-	struct io_identity *id = &req->identity;
+	struct io_identity *id = req->work.identity;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (def->needs_fsize && id->fsize != rlimit(RLIMIT_FSIZE))
@@ -1330,10 +1329,11 @@ static bool io_grab_identity(struct io_kiocb *req)
 static void io_prep_async_work(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
-	struct io_identity *id = &req->identity;
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_identity *id;
 
 	io_req_init_async(req);
+	id = req->work.identity;
 
 	if (req->flags & REQ_F_ISREG) {
 		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
@@ -6474,7 +6474,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (unlikely(!iod))
 			return -EINVAL;
 		refcount_inc(&iod->count);
-		io_put_identity(req);
+		io_put_identity(current->io_uring, req);
 		get_cred(iod->creds);
 		req->work.identity = iod;
 		req->work.flags |= IO_WQ_WORK_CREDS;
@@ -7684,6 +7684,7 @@ static int io_uring_alloc_task_context(struct task_struct *task)
 	tctx->in_idle = 0;
 	atomic_long_set(&tctx->req_issue, 0);
 	atomic_long_set(&tctx->req_complete, 0);
+	io_init_identity(&tctx->identity);
 	task->io_uring = tctx;
 	return 0;
 }
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 342cc574d5c0..bd3346194bca 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -24,6 +24,7 @@ struct io_uring_task {
 	struct wait_queue_head	wait;
 	struct file		*last;
 	atomic_long_t		req_issue;
+	struct io_identity	identity;
 
 	/* completion side */
 	bool			in_idle ____cacheline_aligned_in_smp;
-- 
2.28.0

