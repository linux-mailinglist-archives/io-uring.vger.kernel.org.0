Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB88315AF8
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhBJATJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbhBJAJO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:09:14 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A774C061793
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:23 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id m13so373487wro.12
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=32d/zOmgE/7XKvVRcNKfLOwdQDPHLOFlD4i/XrM1WF4=;
        b=O7jty1tLpJngVEW6rPxpck/8r52FRCfdNzm6e1qXXdDghSAge9hQpaYzOorCUrmS7Q
         8ptGuNzFkqst8IThCfSRMwEEkwMOPAqjSoK4OT0ITZjGvHQPiy/5RM5e1/RlMtSKfZTi
         bmlk88dwGd7tT4ImpuhFimUf4SqHNacNUqIY/f45gzv1IIWPILFQvq5mzPJyItWMtmVg
         cyGyMAZRKxMA05S6Ia+OqFNSi83kz/8+L+0YYXQbohlAm4cdyyT3nyT92pbVAAGPObAk
         XC71vthmkZSQqgPqGmeR9e5UYlpLGsw957altyPyN4yTsRD9Q4w+4Buu3XQBRfdXcp34
         GCWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=32d/zOmgE/7XKvVRcNKfLOwdQDPHLOFlD4i/XrM1WF4=;
        b=WvemBEDMW/FhojT5TZB+hNiCv4O940MyRHQZ43YRiHv1KVos7GU4H7R4mn3xlcAPZm
         k0gc0UKaHfTOmVT20nMCgEQsrNnX1WrtunZSPEly2X0T9PN2BJSPGySqzbZTLKqnjloo
         1UevY3thVahPK1Vbt3h/QTRFUWd86U8qpEYng0xDT0CrMrMhxfZ5iMRe34dQ2f9e543Q
         +vckvxBoHjkEd8dpXjuDrhLvIrSUP71VwriLTvzu8JEW+jt56Utk+b9/CK8SX+P3h3Ve
         pBg/hMmrkAHXH15McInkTe3V4o5Ue3hd3uC4PR1o52YAykaxO+4JjNLCiyF20bacnOvz
         gRuA==
X-Gm-Message-State: AOAM533vrMbiHxiJG503RoPk45A0J+BuBt2hPNifmOhRnZAPcnA7A5Dw
        cghO+uIWioFKu7y9kAQE+kCLdbOTsRrM3Q==
X-Google-Smtp-Source: ABdhPJzqSiIiua+WBlYW/kcCgUDguDlCgyDs1TL6fVSRrBCnSK84ZK5OSXMhZXCDR3+On6TQKeIsFA==
X-Received: by 2002:adf:82d3:: with SMTP id 77mr518201wrc.385.1612915642009;
        Tue, 09 Feb 2021 16:07:22 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/17] io_uring: replace list with array for compl batch
Date:   Wed, 10 Feb 2021 00:03:13 +0000
Message-Id: <328e1394d5f910015d0f197cfc8059cb49b83b9f.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Reincarnation of an old patch that replaces a list in struct
io_compl_batch with an array. It's needed to avoid hooking requests via
their compl.list, because it won't be always available in the future.

It's also nice to split io_submit_flush_completions() to avoid free
under locks and remove unlock/lock with a long comment describing when
it can be done.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7076564aa944..8c5fd348cac5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -265,10 +265,11 @@ struct io_sq_data {
 };
 
 #define IO_IOPOLL_BATCH			8
+#define IO_COMPL_BATCH			32
 
 struct io_comp_state {
 	unsigned int		nr;
-	struct list_head	list;
+	struct io_kiocb		*reqs[IO_COMPL_BATCH];
 };
 
 struct io_submit_state {
@@ -1348,7 +1349,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_llist_head(&ctx->rsrc_put_llist);
 
 	submit_state = &ctx->submit_state;
-	INIT_LIST_HEAD(&submit_state->comp.list);
 	submit_state->comp.nr = 0;
 	submit_state->file_refs = 0;
 	submit_state->free_reqs = 0;
@@ -1933,33 +1933,20 @@ static inline void io_req_complete_nostate(struct io_kiocb *req, long res,
 static void io_submit_flush_completions(struct io_comp_state *cs,
 					struct io_ring_ctx *ctx)
 {
+	int i, nr = cs->nr;
+
 	spin_lock_irq(&ctx->completion_lock);
-	while (!list_empty(&cs->list)) {
-		struct io_kiocb *req;
+	for (i = 0; i < nr; i++) {
+		struct io_kiocb *req = cs->reqs[i];
 
-		req = list_first_entry(&cs->list, struct io_kiocb, compl.list);
-		list_del(&req->compl.list);
 		__io_cqring_fill_event(req, req->result, req->compl.cflags);
-
-		/*
-		 * io_free_req() doesn't care about completion_lock unless one
-		 * of these flags is set. REQ_F_WORK_INITIALIZED is in the list
-		 * because of a potential deadlock with req->work.fs->lock
-		 * We defer both, completion and submission refs.
-		 */
-		if (req->flags & (REQ_F_FAIL_LINK|REQ_F_LINK_TIMEOUT
-				 |REQ_F_WORK_INITIALIZED)) {
-			spin_unlock_irq(&ctx->completion_lock);
-			io_double_put_req(req);
-			spin_lock_irq(&ctx->completion_lock);
-		} else {
-			io_double_put_req(req);
-		}
 	}
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
 
 	io_cqring_ev_posted(ctx);
+	for (i = 0; i < nr; i++)
+		io_double_put_req(cs->reqs[i]);
 	cs->nr = 0;
 }
 
@@ -6529,8 +6516,8 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 	} else if (likely(!ret)) {
 		/* drop submission reference */
 		if (req->flags & REQ_F_COMPLETE_INLINE) {
-			list_add_tail(&req->compl.list, &cs->list);
-			if (++cs->nr >= 32)
+			cs->reqs[cs->nr++] = req;
+			if (cs->nr == IO_COMPL_BATCH)
 				io_submit_flush_completions(cs, req->ctx);
 			req = NULL;
 		} else {
@@ -6669,7 +6656,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 static void io_submit_state_end(struct io_submit_state *state,
 				struct io_ring_ctx *ctx)
 {
-	if (!list_empty(&state->comp.list))
+	if (state->comp.nr)
 		io_submit_flush_completions(&state->comp, ctx);
 	if (state->plug_started)
 		blk_finish_plug(&state->plug);
-- 
2.24.0

