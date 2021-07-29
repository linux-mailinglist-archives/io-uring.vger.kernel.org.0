Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A683DA71D
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237703AbhG2PGl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237738AbhG2PGl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:41 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5DEC0613C1
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:37 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id o5-20020a1c4d050000b02901fc3a62af78so7058598wmh.3
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2AMgfDoqEjVRBuOoXoU5aA1YpKUp8SMRTLQKSaOshss=;
        b=pQeCRoAPlJbzLkjhaerW8haJ7qEyxxbdqVgcB6j27rthSUZZ+en6MQufa/IGNCxhuk
         tUaK9ZePJvDBFBLuqgPp5+Y5kFV1KMZ8y13Z6yQy5Xbo8GRIwF2POlfwv8EDGNPiAZxy
         5a6s1CYSBSfEcWQ8alEQYHfNoCaTfeoa6sn4DhVFm0Z4yStjS5+UgOHSjwMcN+O+/qFt
         6HBU2G6gD4lz2CxwbNa464RwG5P5H3+PHliGnUjTsj6M6grYe/F0OMBeUvLHwdbjLTqp
         IT4cCC1Z14BEQR/Ppf0eg+dcMoFMbNRJzIDofl48yzlXmNfpg2q0kSYTpndOSTsmBssa
         H3kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2AMgfDoqEjVRBuOoXoU5aA1YpKUp8SMRTLQKSaOshss=;
        b=Ewc0qMxzx0VHv9jqgmhNGICcRot8AZk0s8/DRsPJoP54tOPMnmRcxs0NJr7KdvPX1p
         GefunufuD/EP/UPZaPz/g64/kiVEfg19+2C9ltHQNie0GVNpfENUYN1s183odbFlkpng
         4inFYaKC422JfXsMa4TkVhYqxJxFu6y6FqyhsudgD0U4E6nKQsejhQzKw8TpHjZVCi0t
         dXSMosK5jKotiTxVlRLxBMS8eJEl+DfOoTKj8X6dU2TZyIgg8z0ujNCltwiDa3H1lLSS
         5Aabi0WXTgVcH9xcRGVuPCQAWIPCmmF/mk330h0m2YVVQLIDOktXMDZcBWNgzRk0ZUrA
         UoyQ==
X-Gm-Message-State: AOAM531MhUWGYBwTZA5SX5jjmWGbmed4BnNRLxA90gHkrR59mWKvwjHm
        DT3oKeY8M3Q/VGBjvYGplQk=
X-Google-Smtp-Source: ABdhPJxo+8DGwP/RmHVFoQDQh17NrcxGijBR5yl7m7f7Pmr/ZrYIMiKe9qAfFT46GS2BwpNcAQrR0Q==
X-Received: by 2002:a05:600c:4649:: with SMTP id n9mr7658339wmo.168.1627571196255;
        Thu, 29 Jul 2021 08:06:36 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 15/23] io_uring: optimise putting task struct
Date:   Thu, 29 Jul 2021 16:05:42 +0100
Message-Id: <ff25efb7e984512bce96b1e901e4e36791becf38.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We cache all the reference to task + tctx, so if io_put_task() is
called by the corresponding task itself, we can save on atomics and
return the refs right back into the cache.

It's beneficial for all inline completions, and also iopolling, when
polling and submissions are done by the same task, including
SQPOLL|IOPOLL.

Note: io_uring_cancel_generic() can return refs to the cache as well,
so those should be flushed in the loop for tctx_inflight() to work
right.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1a7ad2bfe5e9..7276f784a7fe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2090,10 +2090,12 @@ static inline void io_init_req_batch(struct req_batch *rb)
 static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 				     struct req_batch *rb)
 {
-	if (rb->task)
-		io_put_task(rb->task, rb->task_refs);
 	if (rb->ctx_refs)
 		percpu_ref_put_many(&ctx->refs, rb->ctx_refs);
+	if (rb->task == current)
+		current->io_uring->cached_refs += rb->task_refs;
+	else if (rb->task)
+		io_put_task(rb->task, rb->task_refs);
 }
 
 static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
@@ -9132,9 +9134,11 @@ static void io_uring_drop_tctx_refs(struct task_struct *task)
 	struct io_uring_task *tctx = task->io_uring;
 	unsigned int refs = tctx->cached_refs;
 
-	tctx->cached_refs = 0;
-	percpu_counter_sub(&tctx->inflight, refs);
-	put_task_struct_many(task, refs);
+	if (refs) {
+		tctx->cached_refs = 0;
+		percpu_counter_sub(&tctx->inflight, refs);
+		put_task_struct_many(task, refs);
+	}
 }
 
 /*
@@ -9155,9 +9159,9 @@ static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 	if (tctx->io_wq)
 		io_wq_exit_start(tctx->io_wq);
 
-	io_uring_drop_tctx_refs(current);
 	atomic_inc(&tctx->in_idle);
 	do {
+		io_uring_drop_tctx_refs(current);
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx, !cancel_all);
 		if (!inflight)
@@ -9181,6 +9185,7 @@ static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		}
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
+		io_uring_drop_tctx_refs(current);
 		/*
 		 * If we've seen completions, retry without waiting. This
 		 * avoids a race where a completion comes in before we did
-- 
2.32.0

