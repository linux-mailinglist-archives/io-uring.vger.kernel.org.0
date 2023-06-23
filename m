Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C423373B613
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 13:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjFWLYp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 07:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjFWLYm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 07:24:42 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311FA2685
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:41 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-987c932883bso62415666b.0
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687519479; x=1690111479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s4MKuIvOtPa6LDaVdjrreVhyD6dBmluphGJKPl09Ii8=;
        b=inDJGp5e3DN9rltz8e6/bqRcSEXMESFBCL1Y2ct291MueGyvzDzDEKqbKPYb+bTU9j
         vfVRfqmbC6+1KOkzIZNfler3AOMIsZBLyYn0fD0L20OKP7jtrgp918E2miLcsJrr+O9E
         FKyXqi12MM/DZN0mX4ltin4I6po40zZY9wpDETdHPSOg7HA2IagYsl0E5kcWQwOGh/kr
         dYvdBcWtYEnbZCSyf1ChouVtqI2ZLC3OKJOoujiBfSflEIGrXW7REGocc34aiAXEWaAJ
         5F5IhGO666NmIkDaUitW9lVX0gf+zfT+3G7UoTf+Zr1YEKhVYiqlfBe9yQGtxajGIX1s
         6Ggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519479; x=1690111479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s4MKuIvOtPa6LDaVdjrreVhyD6dBmluphGJKPl09Ii8=;
        b=hXva9bGhe+CaZcmz/BkATrO7gJhHs/R/mv3DfjYYeXnJp/R+Umn1WlTUXsvlI8QBO7
         uzlctKf8OeT6LByIhbqpevI2FyGHCOiyZWAk2qZkukGiY/rjliUgxe0yhsbtmJ074XQg
         24HebbzEXbqwYij+97/fnG1h6vf+0wUXJKuTlPlHW+0diAYF8c7/UN2SnZJjdi94Qguf
         XQTUjTuj9ak8XtX+jGSD2fh/fPggP+nzWmPeUqHkPYd1Z2ZNs0E9rkMAp3nZ6FW3eOTK
         lVk250GlOWEMKi0O2yD8MF9H1aX3WSB7DyEc8of8rxx1iLfozWmU7v0nnTV/FUijLXbO
         U+Cg==
X-Gm-Message-State: AC+VfDyUS0kjkNgLPV20IbPusyi4mknuIT8Zwxi34z5dhaBqhcHuigJM
        MeGQLzdU+qQzoLBvx/A7XPWMx1koQec=
X-Google-Smtp-Source: ACHHUZ5tTlVmSECfli21N3+80awF0bnPmAZVLwl0p9w6FmBxoIJR6IG2Ew6noi1eGXh4qU5YRDvg2g==
X-Received: by 2002:a17:907:783:b0:982:c8d0:683f with SMTP id xd3-20020a170907078300b00982c8d0683fmr19276297ejb.18.1687519479489;
        Fri, 23 Jun 2023 04:24:39 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7d95])
        by smtp.gmail.com with ESMTPSA id h10-20020a1709067cca00b00969f44bbef3sm5959769ejp.11.2023.06.23.04.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:24:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 06/11] io_uring: remove IOU_F_TWQ_FORCE_NORMAL
Date:   Fri, 23 Jun 2023 12:23:26 +0100
Message-Id: <2e55571e8ff2927ae3cc12da606d204e2485525b.1687518903.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1687518903.git.asml.silence@gmail.com>
References: <cover.1687518903.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Extract a function for non-local task_work_add, and use it directly from
io_move_task_work_from_local(). Now we don't use IOU_F_TWQ_FORCE_NORMAL
and it can be killed.

As a small positive side effect we don't grab task->io_uring in
io_req_normal_work_add anymore, which is not needed for
io_req_local_work_add().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 25 ++++++++++++++-----------
 io_uring/io_uring.h |  5 +----
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3eec5c761d0a..776d1aa73d26 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1317,7 +1317,7 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx)
 	}
 }
 
-static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
+static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned nr_wait, nr_tw, nr_tw_prev;
@@ -1368,19 +1368,11 @@ static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 }
 
-void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
+static void io_req_normal_work_add(struct io_kiocb *req)
 {
 	struct io_uring_task *tctx = req->task->io_uring;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!(flags & IOU_F_TWQ_FORCE_NORMAL) &&
-	    (ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
-		rcu_read_lock();
-		io_req_local_work_add(req, flags);
-		rcu_read_unlock();
-		return;
-	}
-
 	/* task_work already pending, we're done */
 	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
 		return;
@@ -1394,6 +1386,17 @@ void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
 	io_fallback_tw(tctx);
 }
 
+void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
+{
+	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		rcu_read_lock();
+		io_req_local_work_add(req, flags);
+		rcu_read_unlock();
+	} else {
+		io_req_normal_work_add(req);
+	}
+}
+
 static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 {
 	struct llist_node *node;
@@ -1404,7 +1407,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 						    io_task_work.node);
 
 		node = node->next;
-		__io_req_task_work_add(req, IOU_F_TWQ_FORCE_NORMAL);
+		io_req_normal_work_add(req);
 	}
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9718897133db..20ba6df49b1f 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -16,9 +16,6 @@
 #endif
 
 enum {
-	/* don't use deferred task_work */
-	IOU_F_TWQ_FORCE_NORMAL			= 1,
-
 	/*
 	 * A hint to not wake right away but delay until there are enough of
 	 * tw's queued to match the number of CQEs the task is waiting for.
@@ -26,7 +23,7 @@ enum {
 	 * Must not be used wirh requests generating more than one CQE.
 	 * It's also ignored unless IORING_SETUP_DEFER_TASKRUN is set.
 	 */
-	IOU_F_TWQ_LAZY_WAKE			= 2,
+	IOU_F_TWQ_LAZY_WAKE			= 1,
 };
 
 enum {
-- 
2.40.0

