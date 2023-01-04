Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4BA65CB8C
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 02:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238956AbjADBgn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Jan 2023 20:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238936AbjADBgd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Jan 2023 20:36:33 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BC01789E
        for <io-uring@vger.kernel.org>; Tue,  3 Jan 2023 17:36:23 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id z16so15149748wrw.1
        for <io-uring@vger.kernel.org>; Tue, 03 Jan 2023 17:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fFDXLbYNflMCd8sypY1XNUdOqEMkYaWqbdDlZDpYHjQ=;
        b=cBCkLLDatPVl2vhAVLBpQA23Z1hv0Ir7TP0YYASP5cUUuHQx7PTMq3/+hXQ6uo01ue
         omYpNq/BSr8lM9AhzC9tlmLvM1SSqjEgYstJxfMF6LMbnqRnDmg99RdOyvRg0MV/ytsz
         2HfB/panL5/PP8CRMTiq0dY5vFUqiKi+455GEL1JcBB50TVyYrHaHRgug5Ts8AyASWcp
         Yg8g5o5dOZ9cHFegdshF2MK4k8xp8dKFNZBJVwZwdWl6QUFOcy2QmkhD2RvU203PHFlH
         gkow60KDCHJMA0NUPivDrh5wJfwGbWDsQqTQPocvnaE5MIlbkUxIaGh8f7rYf0RDswDD
         1BHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fFDXLbYNflMCd8sypY1XNUdOqEMkYaWqbdDlZDpYHjQ=;
        b=poRuicVWAC5DNaKwZ3zQUQavOMZHrRFtt3EsDngQbGNq2BPnrOjNMWO9/mq3BbV1D9
         9b5dM3Kq4gooh+Why7dlMmTBu0C1Ua/pnCIPi/tLBX96NK+pTWfP3fs2kFIjSEbczUIT
         veTl+niPvxiVpVoChjxmjNIm1lyBWitD2ermiCgNXFOqTSqKZO4o9+3L79HArPGHPV6o
         LBtzRlH4uRpYdNqzp92Y8Kn0M39WBYeCUE+INEsS/ef/nx6Pr/aj2AkXvai/TbdnpVt6
         41w2WT5fm7Tbp7RCU6QDjlh0q/HPl6diEswvkJHFe8cT8y3cZqaJu9dWj+nRAVqVKAcW
         cxNQ==
X-Gm-Message-State: AFqh2ko7UsBI8v2FWCMXCwUznOgvwvAH6dBEgmIfSXEtza0ByOMVXCwD
        uJs9e2HlAt6quaodtizL5aR4T0KF73g=
X-Google-Smtp-Source: AMrXdXubWmwmozFKsWrbn/OZ8K9pFIMKE40vXlqCnHL9wff91JAqCHUpkEoSXVnv0cRsXEy12N/8Xw==
X-Received: by 2002:adf:e2c9:0:b0:26a:3eee:dde4 with SMTP id d9-20020adfe2c9000000b0026a3eeedde4mr27363978wrj.8.1672796182125;
        Tue, 03 Jan 2023 17:36:22 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id i18-20020a5d5232000000b0028e55b44a99sm14456076wra.17.2023.01.03.17.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 17:36:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 1/1] io_uring: lockdep annotate CQ locking
Date:   Wed,  4 Jan 2023 01:34:57 +0000
Message-Id: <aa3770b4eacae3915d782cc2ab2f395a99b4b232.1672795976.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Locking around CQE posting is complex and depends on options the ring is
created with, add more thorough lockdep annotations checking all
invariants.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  5 ++---
 io_uring/io_uring.h | 15 +++++++++++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6bed44855679..472574192dd6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -731,6 +731,8 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
 	bool is_cqe32 = (ctx->flags & IORING_SETUP_CQE32);
 
+	lockdep_assert_held(&ctx->completion_lock);
+
 	if (is_cqe32)
 		ocq_size += sizeof(struct io_uring_cqe);
 
@@ -820,9 +822,6 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 {
 	struct io_uring_cqe *cqe;
 
-	if (!ctx->task_complete)
-		lockdep_assert_held(&ctx->completion_lock);
-
 	ctx->cq_extra++;
 
 	/*
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e9f0d41ebb99..ab4b2a1c3b7e 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -79,6 +79,19 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
 
+#define io_lockdep_assert_cq_locked(ctx)				\
+	do {								\
+		if (ctx->flags & IORING_SETUP_IOPOLL) {			\
+			lockdep_assert_held(&ctx->uring_lock);		\
+		} else if (!ctx->task_complete) {			\
+			lockdep_assert_held(&ctx->completion_lock);	\
+		} else if (ctx->submitter_task->flags & PF_EXITING) {	\
+			lockdep_assert(current_work());			\
+		} else {						\
+			lockdep_assert(current == ctx->submitter_task);	\
+		}							\
+	} while (0)
+
 static inline void io_req_task_work_add(struct io_kiocb *req)
 {
 	__io_req_task_work_add(req, true);
@@ -92,6 +105,8 @@ void io_cq_unlock_post(struct io_ring_ctx *ctx);
 static inline struct io_uring_cqe *io_get_cqe_overflow(struct io_ring_ctx *ctx,
 						       bool overflow)
 {
+	io_lockdep_assert_cq_locked(ctx);
+
 	if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
 		struct io_uring_cqe *cqe = ctx->cqe_cached;
 
-- 
2.38.1

