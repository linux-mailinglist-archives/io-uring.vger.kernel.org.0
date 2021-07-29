Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7FB3DA713
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237560AbhG2PGc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237648AbhG2PGc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:32 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9C9C0613C1
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:28 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so1616656wms.2
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7fLCRVrOpugb9yzttz4mIc21mswxT6Zu7xuFLRWHdB4=;
        b=hWZcCtgLMvZgYesUP1kTBNyV0t8zYzbeTabLM9Zc7g2yKw3Lttr//Vi0AxPBcCk4cA
         bHOgRw8jqTGWHWe7lNsGpWxobSGECoRYKRvkuVeyvq0WIP+z61xw23oBkLJ0dydPjuLP
         GmpAX2XgIb40eRBlhK1MmS3JxVbW/2yzWRbddKFXbV9l8wPML/3b6MxpgusaQpze5928
         krRFduKVzidxRng1291/T/v3l4fOPpAF4l/Hf4KbfGZqbK7mZgmVH0b92wnx0mnyHap4
         ThsTP9ju6m/gRyLJ22Bfbk2sfPz2z/Tc9AVcUGoE/6e9exKSyaOUOmU3oNtRJ6sZjbmQ
         548Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7fLCRVrOpugb9yzttz4mIc21mswxT6Zu7xuFLRWHdB4=;
        b=JV6GYIVIqQGD0yHDrf5/vwFjMQ5PQ+hC+lPsGKR/Y6o/ioeHYcitPHubuBXA9UHGH8
         dKfy+h0/Qoci88+UxLNXRzySb/11uM0t/W1vWR98cjBuwWqygvQF8+CE9gjQRf6ZDQaC
         K4WmOaOKtjSKjg5iU8lBgCH0H+TjYlgascwzFk038n4Yoq/Jp7zQaVy8yFU03moMWEyF
         HqtDlNdYGhr+tOPKLHzWEBCeFgLGHEcjaQ8PmpscIqlL5CopT8J95A8vhR2aq9HF9CLj
         D94Q2pQSCMg1p85eULCdPtn2iTF33y+homSKQOCVRoNL/XMRqa9XM+SCoZSzd2Dq+rc/
         RPtQ==
X-Gm-Message-State: AOAM530CuxYyf6pO99SKVt851LxzdNVo2aokIttIURNVSQbLjcEre9zM
        Zf7Tp33dCJQYGjFDxBmYmpHn/UA42JM=
X-Google-Smtp-Source: ABdhPJyuUQlKISqm1tvlcQCZltldK42XHCbYRnQClGW/r/wsft93MG+AuU3oz5b9l8xlEzzuS8ImEQ==
X-Received: by 2002:a05:600c:354e:: with SMTP id i14mr5230538wmq.96.1627571187424;
        Thu, 29 Jul 2021 08:06:27 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/23] io_uring: add more locking annotations for submit
Date:   Thu, 29 Jul 2021 16:05:32 +0100
Message-Id: <0f0bd8a3a85b3a01588f3d00abae75c2ab6a6334.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add more annotations for submission path functions holding ->uring_lock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 87d9a5d54464..a7e7a555ae8e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2121,6 +2121,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 }
 
 static void io_submit_flush_completions(struct io_ring_ctx *ctx)
+	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_comp_state *cs = &ctx->submit_state.comp;
 	int i, nr = cs->nr;
@@ -6450,6 +6451,7 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 }
 
 static void __io_queue_sqe(struct io_kiocb *req)
+	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
 	int ret;
@@ -6493,6 +6495,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 }
 
 static inline void io_queue_sqe(struct io_kiocb *req)
+	__must_hold(&req->ctx->uring_lock)
 {
 	if (unlikely(req->ctx->drain_active) && io_drain_req(req))
 		return;
@@ -6537,6 +6540,7 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       const struct io_uring_sqe *sqe)
+	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state;
 	unsigned int sqe_flags;
@@ -6601,6 +6605,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			 const struct io_uring_sqe *sqe)
+	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_link *link = &ctx->submit_state.link;
 	int ret;
@@ -6733,6 +6738,7 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 }
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
+	__must_hold(&ctx->uring_lock)
 {
 	struct io_uring_task *tctx;
 	int submitted = 0;
-- 
2.32.0

