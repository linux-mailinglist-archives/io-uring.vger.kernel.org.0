Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8532A2DE332
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 14:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbgLRNRW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 08:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgLRNRW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 08:17:22 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7354FC0611CA
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:14 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id r4so2510876wmh.5
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QjZoX5sp+Bt3UrjWaXyzO3aXE/rG9FtBQxF/8Lxcjn8=;
        b=m2i7A4kWDA9iK0gYWsnEwlBXnPFC9MTjM6AFTXVhxYma/eSouhyz504Hjo2qkTG0Xc
         v4b8vA6Pux6X4rcTmqTOaIFYmBAx/ul4cEkU6aCNtl4Y8+XLBhQ8a93uHwHWBZfks+Kj
         EubsezbcVsKwkBG1V46EKsu53UJyl/1moInJJ4MjJRLFvMw89mlgVUfoemgMPULbEZaV
         u/vWdKkSK+dA5eot57j24d/lHOOE0mtgZ5RzCDg9CCqc/rr7OAvnQFZPRS4Lc/TX5592
         6GB0f0JQatHJkITfgsOzXTStMi3LAxhiFkFHr0ssLdu8uqAHqQgYXsMPQrdZ7A0oBbr1
         gcUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QjZoX5sp+Bt3UrjWaXyzO3aXE/rG9FtBQxF/8Lxcjn8=;
        b=WGpnrbjRnBXbaBJSk2k1NN/DbnH78YXYTbXy9fhUlMmgXVrgL09dRt7PKv7gTlf0qm
         woAR07VVHJNvy6Fpu9KtffQwVdzKatfq7XgqRgfkSZpSVOEJUBHNMrIGtbQW+r7zs7Js
         K5r4Kipd54LzqrkGTS8XPcBKqI5f6aVEYBSjkqKY+f4pLbIDUQmEhPmjW3IZt09kJ7XH
         2UI1syDQ2XmSPwis2xFG0hZTYMtKUqclOeop07cXC16zBqrz1obL0g3j1uYjx160IuFL
         R3fRTqFfMAzOg8nxjjFfb4FwNQjRCumRBY+3dBiJgYoOaZBV2FTD1PnKUers51fFI8Hf
         XOnA==
X-Gm-Message-State: AOAM530JlZ4J+MAkWPmyIfvFa1VcwA1YO6Su/1cLv2lFpikFVqNFkEk4
        JtI9TFSpoSbGIqieHVbT4aM=
X-Google-Smtp-Source: ABdhPJz9Ga37vafNu6e10cr8647rzhRMWo9BHiPPQrkaihHvP2N+sMYoJl4WI/G+urqu6ZgWTmiSiQ==
X-Received: by 2002:a1c:e309:: with SMTP id a9mr4336654wmh.172.1608297367742;
        Fri, 18 Dec 2020 05:16:07 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id b9sm12778595wmd.32.2020.12.18.05.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 05:16:07 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 8/8] io_uring: kill not used anymore inflight_lock
Date:   Fri, 18 Dec 2020 13:12:28 +0000
Message-Id: <ab3040743e31b36329ea92a745078c49f3ff21cf.1608296656.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608296656.git.asml.silence@gmail.com>
References: <cover.1608296656.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ctx->inflight_lock now doesn't protect anything that should be protected
-- tctx->inflight_files is atomic, and inflight list is gone. Time to
eradicate it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 134ea0e3373d..a678920b1c8d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -377,8 +377,6 @@ struct io_ring_ctx {
 		struct hlist_head	*cancel_hash;
 		unsigned		cancel_hash_bits;
 		bool			poll_multi_file;
-
-		spinlock_t		inflight_lock;
 	} ____cacheline_aligned_in_smp;
 
 	struct delayed_work		file_put_work;
@@ -1303,7 +1301,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
-	spin_lock_init(&ctx->inflight_lock);
 	INIT_DELAYED_WORK(&ctx->file_put_work, io_file_put_work);
 	init_llist_head(&ctx->file_put_llist);
 	return ctx;
@@ -1433,7 +1430,6 @@ static bool io_grab_identity(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	struct io_identity *id = req->work.identity;
-	struct io_ring_ctx *ctx = req->ctx;
 
 	if (def->work_flags & IO_WQ_WORK_FSIZE) {
 		if (id->fsize != rlimit(RLIMIT_FSIZE))
@@ -1491,9 +1487,7 @@ static bool io_grab_identity(struct io_kiocb *req)
 		get_nsproxy(id->nsproxy);
 		req->flags |= REQ_F_INFLIGHT;
 
-		spin_lock_irq(&ctx->inflight_lock);
 		atomic_inc(&current->io_uring->inflight_files);
-		spin_unlock_irq(&ctx->inflight_lock);
 		req->work.flags |= IO_WQ_WORK_FILES;
 	}
 
@@ -6088,15 +6082,11 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static void io_req_drop_files(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_task *tctx = req->task->io_uring;
-	unsigned long flags;
 
 	put_files_struct(req->work.identity->files);
 	put_nsproxy(req->work.identity->nsproxy);
-	spin_lock_irqsave(&ctx->inflight_lock, flags);
 	atomic_dec(&tctx->inflight_files);
-	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
 	req->work.flags &= ~IO_WQ_WORK_FILES;
 	if (atomic_read(&tctx->in_idle))
-- 
2.24.0

