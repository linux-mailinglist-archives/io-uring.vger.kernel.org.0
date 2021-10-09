Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083C2427DD6
	for <lists+io-uring@lfdr.de>; Sun, 10 Oct 2021 00:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhJIWR2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Oct 2021 18:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhJIWR1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Oct 2021 18:17:27 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAA8C061570
        for <io-uring@vger.kernel.org>; Sat,  9 Oct 2021 15:15:30 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e3so8152372wrc.11
        for <io-uring@vger.kernel.org>; Sat, 09 Oct 2021 15:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EK3BPqgx00mT7o8aq8dtg5Dt2wePK5Yw4NiInlxseS4=;
        b=TLJd77oRGMXB2Pz1F9iKef77uLKa4JzmBlTC5JTjUx22cpgWVxelY3P9usEcjc2AsG
         BZNECbpBclHj0jIx2eHLiSZjsvRoKH6aaVT4JB+8rFZgqApwk5ED36nwEkG9lLiJ5kQQ
         OYZuCj92JUJPn17Gf6Rp5iSH3uFBRMtgL89rxFOmEgXTSVf8bIpU+OlaXL2igL95dfsd
         /CbYVRq8LdSVIFj9OB5w1n7w/+FU2nfufc9SU5akAxfflkBVYlCRgyu7HKV+j0bLAOPO
         lRx8aKtvgjSDu4l92lyZo6Fhe3SNy6VXWRP4Gn9PbRe0dPDy7IE0WcnFJF9k2zX+Bh1T
         yHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EK3BPqgx00mT7o8aq8dtg5Dt2wePK5Yw4NiInlxseS4=;
        b=1SjhTdIYzltuGXhdpHAUZTTe/UkicaV7XkmPm903oBr7mq6D0Q+b8j5iuWOJXIGXzQ
         Whn1Tqcc5siRKY+6glfL8Q+68BfCeAZHMgKQrZrMMRvioXp8NMNNevhg/5l5girPoZg4
         xMG3ET+jD5j3Dce9BpZxjw9wvrqDU2SQ1n1gIMOpTYkOKDjo2EXwKB6IWpeuhDloxbCQ
         +6mjZ2gr+oYHp0yHJJQmoLBB9JtZJ6aS6xbi4zSOMe7gS/HxZtO916Cs4qFEwb+unl/E
         vUCDgUFjpPsaih7Hnwm9RVgfL2iKqjBUoxyww4HgJ/da0f1g7S4UpADWDPy31v5ln1nW
         Wytg==
X-Gm-Message-State: AOAM531KEVFN77xr/FMCVXVNxttTpakcoDHHFy0pY3pzpecsiT41MrcB
        d4T7GnDiz/zBBbPD2tfrJl8ESxGq8Jc=
X-Google-Smtp-Source: ABdhPJxuUPGlOa5jSSxxGhSCVJ+6FDS6HvxgkAnzWZI6NJidoEyUemdLiGetYhxC8lUKFI9YFkBXNQ==
X-Received: by 2002:a1c:7911:: with SMTP id l17mr3514683wme.138.1633817728670;
        Sat, 09 Oct 2021 15:15:28 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id g70sm3261147wme.29.2021.10.09.15.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 15:15:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: optimise ctx referencing
Date:   Sat,  9 Oct 2021 23:14:41 +0100
Message-Id: <b40d8c5bc77d3c9550df8a319117a374ac85f8f4.1633817310.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633817310.git.asml.silence@gmail.com>
References: <cover.1633817310.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apparently, percpu_ref_put/get() are expensive enough if done per
request, get them in a batch and cache on the submission side to avoid
getting it over and over again. Also, if we're completing under
uring_lock, return refs back into the cache instead of
perfcpu_ref_put(). Pretty similar to how we do tctx->cached_refs
accounting, but fall back to normal putting when we already changed a
rsrc node by the time of free.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 24984b3f4a49..e558a68a371d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -361,6 +361,7 @@ struct io_ring_ctx {
 		 * uring_lock, and updated through io_uring_register(2)
 		 */
 		struct io_rsrc_node	*rsrc_node;
+		int			rsrc_cached_refs;
 		struct io_file_table	file_table;
 		unsigned		nr_user_files;
 		unsigned		nr_user_bufs;
@@ -1175,12 +1176,52 @@ static inline void io_req_set_refcount(struct io_kiocb *req)
 	__io_req_set_refcount(req, 1);
 }
 
+#define IO_RSRC_REF_BATCH	100
+
+static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
+					  struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	struct percpu_ref *ref = req->fixed_rsrc_refs;
+
+	if (ref) {
+		if (ref == &ctx->rsrc_node->refs)
+			ctx->rsrc_cached_refs++;
+		else
+			percpu_ref_put(ref);
+	}
+}
+
+static inline void io_req_put_rsrc(struct io_kiocb *req, struct io_ring_ctx *ctx)
+{
+	if (req->fixed_rsrc_refs)
+		percpu_ref_put(req->fixed_rsrc_refs);
+}
+
+static __cold void io_rsrc_refs_drop(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	if (ctx->rsrc_cached_refs) {
+		percpu_ref_put_many(&ctx->rsrc_node->refs, ctx->rsrc_cached_refs);
+		ctx->rsrc_cached_refs = 0;
+	}
+}
+
+static void io_rsrc_refs_refill(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	ctx->rsrc_cached_refs += IO_RSRC_REF_BATCH;
+	percpu_ref_get_many(&ctx->rsrc_node->refs, IO_RSRC_REF_BATCH);
+}
+
 static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 					struct io_ring_ctx *ctx)
 {
 	if (!req->fixed_rsrc_refs) {
 		req->fixed_rsrc_refs = &ctx->rsrc_node->refs;
-		percpu_ref_get(req->fixed_rsrc_refs);
+		ctx->rsrc_cached_refs--;
+		if (unlikely(ctx->rsrc_cached_refs < 0))
+			io_rsrc_refs_refill(ctx);
 	}
 }
 
@@ -1801,6 +1842,7 @@ static void io_req_complete_post(struct io_kiocb *req, s32 res,
 				req->link = NULL;
 			}
 		}
+		io_req_put_rsrc(req, ctx);
 		io_dismantle_req(req);
 		io_put_task(req->task, 1);
 		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
@@ -1957,14 +1999,13 @@ static inline void io_dismantle_req(struct io_kiocb *req)
 		io_clean_op(req);
 	if (!(flags & REQ_F_FIXED_FILE))
 		io_put_file(req->file);
-	if (req->fixed_rsrc_refs)
-		percpu_ref_put(req->fixed_rsrc_refs);
 }
 
 static __cold void __io_free_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	io_req_put_rsrc(req, ctx);
 	io_dismantle_req(req);
 	io_put_task(req->task, 1);
 
@@ -2271,6 +2312,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 			continue;
 		}
 
+		io_req_put_rsrc_locked(req, ctx);
 		io_queue_next(req);
 		io_dismantle_req(req);
 
@@ -7646,10 +7688,13 @@ static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 
 static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 				struct io_rsrc_data *data_to_kill)
+	__must_hold(&ctx->uring_lock)
 {
 	WARN_ON_ONCE(!ctx->rsrc_backup_node);
 	WARN_ON_ONCE(data_to_kill && !ctx->rsrc_node);
 
+	io_rsrc_refs_drop(ctx);
+
 	if (data_to_kill) {
 		struct io_rsrc_node *rsrc_node = ctx->rsrc_node;
 
@@ -9203,6 +9248,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		ctx->mm_account = NULL;
 	}
 
+	io_rsrc_refs_drop(ctx);
 	/* __io_rsrc_put_work() may need uring_lock to progress, wait w/o it */
 	io_wait_rsrc_data(ctx->buf_data);
 	io_wait_rsrc_data(ctx->file_data);
-- 
2.33.0

