Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7D73024AE
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 13:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbhAYMKx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 07:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbhAYMKU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 07:10:20 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929F2C0611C3
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:20 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id h9so1798306wrr.9
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RwFviHiQikljVa9q/UTl1Bb7vNvtLuFAVTzKv8c7E2U=;
        b=eMjiPbRYLZbmgRXb8BuxkP23SdGgv0OZtbWTN/5a1qDYaFypXtp4JFosajYlDJumwu
         6B6jV+Kuf9zX9QVYVra4212xwIIJkrO4Vky4sNOHw7VUT59NxQYvfzhGo+OX+Rni2P3Q
         v5cJncO/+mxUCfXSEqi2Czgzwlsa/N+M+x/YLnOklCpwqJ5I64UNrieiCz+GAU9QWBks
         b4NM84WgAVOMiRxGefBT0Y3HOBjPEK0U5QoOSVAEZl0+l3tetX5CNfmlS/3k00EPvQQe
         C+DD2kHRjlGb9v1lh4QCVL3d0E8EDuJFTJZAKYJXv83Fdy9x/7mFq/wf5+T15NCFwzQp
         f0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RwFviHiQikljVa9q/UTl1Bb7vNvtLuFAVTzKv8c7E2U=;
        b=MkEX2F1tn5rwWFLKqma5rRkGkWO+9ZzQxnGGfE1lwJIFgAdbjWZ4hmyYMOg+lDGTSo
         9DypZ9bSupD2xxept4epAvmavDsLjH8fY5jB8AVHt0NHfE+tCb040K4b9jpn3+mxsDKl
         lstnmIeEDRWgjwmOcvzUWZ60SmrCpYv27NPJBVUKDNYKeTGAd0fnSgUGDOM/KMDfOV1d
         8ZhWNnbqcqsnbotKSUpEUyKPsBrwd/kDIuwFGCXWCNxwN88xnKSvDCcyRqjdTQlKLABM
         be5aqLXJv4Fw9woK6KeObM1RvwzZqO7jOp5j4n29QYVOtToO0bRTxtnuTAZHyMirMYmW
         2uEw==
X-Gm-Message-State: AOAM532u1nHZEB+HX0wWCVHHJwvGysnGC1QYkuf0BUDUSqlFBCIGbjSa
        41pgcVK+46h7O95anVsMMuV7DKsc/1A=
X-Google-Smtp-Source: ABdhPJzPOz4bbce8gZfGB0x9+cyS1kEuakP6tTYadqIAYty5TJIGrzY9J38SZnI4EehRxV95Gxa/yg==
X-Received: by 2002:a5d:420d:: with SMTP id n13mr499649wrq.320.1611575179410;
        Mon, 25 Jan 2021 03:46:19 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.11])
        by smtp.gmail.com with ESMTPSA id a6sm12571433wru.66.2021.01.25.03.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 03:46:18 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/8] io_uring: replace list with array for compl batch
Date:   Mon, 25 Jan 2021 11:42:25 +0000
Message-Id: <bc4d3be2f60683f6ab149f4f6b87f39c9803de9d.1611573970.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611573970.git.asml.silence@gmail.com>
References: <cover.1611573970.git.asml.silence@gmail.com>
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
index 08d0c8b60c2a..fcd8df43b6bf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -260,10 +260,11 @@ struct io_sq_data {
 };
 
 #define IO_IOPOLL_BATCH			8
+#define IO_COMPL_BATCH			32
 
 struct io_comp_state {
 	unsigned int		nr;
-	struct list_head	list;
+	struct io_kiocb		*reqs[IO_COMPL_BATCH];
 };
 
 struct io_submit_state {
@@ -1338,7 +1339,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_llist_head(&ctx->rsrc_put_llist);
 
 	submit_state = &ctx->submit_state;
-	INIT_LIST_HEAD(&submit_state->comp.list);
 	submit_state->comp.nr = 0;
 	submit_state->file_refs = 0;
 	submit_state->free_reqs = 0;
@@ -1901,33 +1901,20 @@ static void io_req_complete_nostate(struct io_kiocb *req, long res,
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
 
@@ -6565,8 +6552,8 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
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
@@ -6705,7 +6692,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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

