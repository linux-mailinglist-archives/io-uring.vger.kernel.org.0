Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5800354CEC4
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 18:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356649AbiFOQee (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 12:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356588AbiFOQec (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 12:34:32 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F752BB2D
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:31 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id c21so16145238wrb.1
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+J4OGcbFiS//ULvT34KSE6gEhtpT20A8WEIx4b+yT04=;
        b=l7AN13RpL6JM0hOdb6HJr3+YQOOE1GsLte58b88jPKXvMDRsy23f5R1r+ZNBxNul8v
         U6v7vgqdy8meoUszDCleaKPbZFwJysUMOvk6vX3w1hLvFWoUdx5rq4wVka0XlmNUz6CD
         IYVRyf9pQQhtQ1vQjLUYjyGfA4HWRpNdEj4rgHwqgwHn3BsYPjplRZIupQm+pPtxPd/Y
         V/cDX1tdiFNZOzMtv94CgGijMcPmjdw3devTZB+GIRleN0VlFcYQhxZeZkC4wjWPpU59
         sVze4vIbQjvapSbhDQ0za/NMThTf7pUngf/XVDDv3cSYCbQ3dgc6G0zuQp7XkwqAYGuJ
         zWqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+J4OGcbFiS//ULvT34KSE6gEhtpT20A8WEIx4b+yT04=;
        b=vjdFXcvVuX1s+hOuYhbeNqxfVoPhOBZ6yQJWQMIKM9wKm2dvJmn4zozEmivP/gAx5x
         2bTvUYfuetDda45fOo8fF5Qr6wYWxkzvbKeUZ+wDL8w1D2/TKewZJS4Y7VosKyqJRS6Q
         eA0TooYDwQZ/8C0ElTxuDKPeR0DFP8xXSpPlE3G1aq+f7/aWRxLTE0/WiGe6Rbv2CRkw
         SzjzLUO61tTawH1uaYHsk4q8hvPbdNqeHsSQfmV4w7SNk5zbQLZo22fg/i1KnS1LbsdP
         r9+drZrXtAudDOa8v0I9wDx788KOPzengoTcX1S8vdtKVf0TThJgTeySGDMHB0ZIY6AV
         IveQ==
X-Gm-Message-State: AJIora+F8Y+S/615ZCYUf3Nc27AtpWr+XFvzw3C0GW2+9w8mJ678vW2d
        qGPTox7RMmuJ+Tkn5IrEqRFcTBwzSBDONA==
X-Google-Smtp-Source: AGRyM1sztX+WWvSWqXjczdUpoi/gYlh4meIou0npIjrjtfVqk3dTYT3NdybJKisOnWxHZIfWsD0FYA==
X-Received: by 2002:a5d:4151:0:b0:210:316c:7bed with SMTP id c17-20020a5d4151000000b00210316c7bedmr591170wrq.369.1655310870020;
        Wed, 15 Jun 2022 09:34:30 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a056000038200b0020ff3a2a925sm17894953wrf.63.2022.06.15.09.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:34:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 05/10] io_uring: move small helpers to headers
Date:   Wed, 15 Jun 2022 17:33:51 +0100
Message-Id: <22df99c83723e44cba7e945e8519e64e3642c064.1655310733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655310733.git.asml.silence@gmail.com>
References: <cover.1655310733.git.asml.silence@gmail.com>
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

There is a bunch of inline helpers that will be useful not only to the
core of io_uring, move them to headers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 17 -----------------
 io_uring/io_uring.h | 22 ++++++++++++++++++++++
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 78aee292d109..38b53011e0e9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -615,14 +615,6 @@ struct sock *io_uring_get_socket(struct file *file)
 }
 EXPORT_SYMBOL(io_uring_get_socket);
 
-static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
-{
-	if (!*locked) {
-		mutex_lock(&ctx->uring_lock);
-		*locked = true;
-	}
-}
-
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
@@ -878,15 +870,6 @@ static void io_prep_async_link(struct io_kiocb *req)
 	}
 }
 
-static inline void io_req_add_compl_list(struct io_kiocb *req)
-{
-	struct io_submit_state *state = &req->ctx->submit_state;
-
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		state->flush_cqes = true;
-	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
-}
-
 void io_queue_iowq(struct io_kiocb *req, bool *dont_use)
 {
 	struct io_kiocb *link = io_prep_linked_timeout(req);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ee718f7d54d3..e30e639c2822 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -217,6 +217,28 @@ static inline bool io_run_task_work(void)
 	return false;
 }
 
+static inline void io_req_complete_state(struct io_kiocb *req)
+{
+	req->flags |= REQ_F_COMPLETE_INLINE;
+}
+
+static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
+{
+	if (!*locked) {
+		mutex_lock(&ctx->uring_lock);
+		*locked = true;
+	}
+}
+
+static inline void io_req_add_compl_list(struct io_kiocb *req)
+{
+	struct io_submit_state *state = &req->ctx->submit_state;
+
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		state->flush_cqes = true;
+	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
+}
+
 int io_run_task_work_sig(void);
 void io_req_complete_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
-- 
2.36.1

