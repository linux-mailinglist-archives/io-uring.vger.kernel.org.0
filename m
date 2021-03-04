Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABA132C99D
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241365AbhCDBKP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445675AbhCDAfo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:35:44 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38ABC0604DD
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:40 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o6so5498601pjf.5
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=StnqVCldJhjVsxmkTe9CK1mG2kec9g4n7PpvpYj350s=;
        b=fqngTCn8z4vFIM9Ov/GIGdDFsKavODExPsWCsHsjmykfON4g4trMu238LVUn+PJM0g
         4hP0FxCK//Bd6+ljC50SQOzFE9NcLCbilxroAYjnIrWxrGiJvgU+qxw/PYmTi2YptFdN
         /HFFIEsu9/pBXIQvxhhz7ebGqClLe34NvVKw3KtSRRJpvxDJw6hbk+p5BhEYLiwjahkI
         GS8+gwxtOks34nBATxIwDHMuptNLiNfMh4MVtK1Z338iwKT3tiYVI5v5IrVTqnQ8fl3C
         YiX7zi2sc/uRR4q4iDR8/vibaeVf5zVBdJAphkoabStEbKkiF/DzHDHbuOv3ZpdHEm+M
         CxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=StnqVCldJhjVsxmkTe9CK1mG2kec9g4n7PpvpYj350s=;
        b=osUaxr8Sb1mnJs2H6G9rBglGPPzv9nWCqEHikuumpz5dcGpW+G3RGXIjB+mtthkOpq
         FdbiEyH0fcUl/MDUhN9JmiJ1BSX3Xp3wlmHQssa5b6nBMw9tAfunWjmFqfLMtD6VLHGL
         1jldq/7FvqDeE//oc6fe4xkZ+PrNylpwSVEQ9m5YZSm6Sw0geUJBJ3QgWsWwryFGZz79
         2HP1tEtNqD4R9E+KXqe5+omLp6gnNrvn9OhSiuUtLVwExNwrECQ0Ovysw3WeaoTJlFtk
         jVoI0Wdr+t5j1S+c5bN0vcUw43wCmFEQaVVysRqdDpvIGKa29qi8PVX9RhAOBHekRg8F
         yr7g==
X-Gm-Message-State: AOAM533iX+7x5V/JySF2zeHQtw8805nHAoqIec+v7GUfeg6UV49d0RVl
        jFX6RdTuOrBqTPGl9JS0R/HX/WBB6y3O1Lb7
X-Google-Smtp-Source: ABdhPJyUXaVlnLCZDft3nLw3ruAQRXRBTEmZs/g8ESUg4IDJU2Xwve0yniO4f5XGZyg9AcCtke1UfA==
X-Received: by 2002:a17:902:aa49:b029:e4:3825:dcd2 with SMTP id c9-20020a170902aa49b02900e43825dcd2mr1393836plr.39.1614817660072;
        Wed, 03 Mar 2021 16:27:40 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:39 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 29/33] io_uring: inline io_req_clean_work()
Date:   Wed,  3 Mar 2021 17:26:56 -0700
Message-Id: <20210304002700.374417-30-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Inline io_req_clean_work(), less code and easier to analyse
tctx dependencies and refs usage.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d5e546acae7d..ef6f225762e4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1167,22 +1167,6 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 	return false;
 }
 
-static void io_req_clean_work(struct io_kiocb *req)
-{
-	if (req->flags & REQ_F_INFLIGHT) {
-		struct io_ring_ctx *ctx = req->ctx;
-		struct io_uring_task *tctx = req->task->io_uring;
-		unsigned long flags;
-
-		spin_lock_irqsave(&ctx->inflight_lock, flags);
-		list_del(&req->inflight_entry);
-		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
-		req->flags &= ~REQ_F_INFLIGHT;
-		if (atomic_read(&tctx->in_idle))
-			wake_up(&tctx->wait);
-	}
-}
-
 static void io_req_track_inflight(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1671,7 +1655,19 @@ static void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 	if (req->fixed_rsrc_refs)
 		percpu_ref_put(req->fixed_rsrc_refs);
-	io_req_clean_work(req);
+
+	if (req->flags & REQ_F_INFLIGHT) {
+		struct io_ring_ctx *ctx = req->ctx;
+		struct io_uring_task *tctx = req->task->io_uring;
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->inflight_lock, flags);
+		list_del(&req->inflight_entry);
+		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
+		req->flags &= ~REQ_F_INFLIGHT;
+		if (atomic_read(&tctx->in_idle))
+			wake_up(&tctx->wait);
+	}
 }
 
 static inline void io_put_task(struct task_struct *task, int nr)
-- 
2.30.1

