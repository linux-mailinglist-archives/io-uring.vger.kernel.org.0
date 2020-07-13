Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DC821E3CC
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2020 01:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgGMXoM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 19:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbgGMXn4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 19:43:56 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFCCC061755;
        Mon, 13 Jul 2020 16:43:55 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id b15so15309185edy.7;
        Mon, 13 Jul 2020 16:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=YH0uX+yW+jK8Au1lkLXVjBoaxRQ+HyERW/pFFwt6Hsk=;
        b=t07mAmKhirCx/V+Xcg1WiBahAgcVl4IZkuUeT3X2bFaPr7hXKLbknij5Hr+fcb2z1C
         aMs09kPJ+GGE2oZ126xzTKbrE45IAXF3TlnzMJF13zYiAifB2I6LZO28jJnucgaPI2rK
         rjdTu7BiAP0wZomw0M7xvAsrgbIZO+Od6FkkUt/KG8Ypv9eG+1n6A0mFsjELkRYEQBEP
         U9Fxjqes2nlLJaOLFm9w6pFP1ciDA37sHeYCvrhFCo3hZceLirbHGahQAQCL0+DDZmXk
         GLX1EOhdJGm1NVaXMaTsFpYgmSFDJS1NmRiE9f1g+e3W7DdPreT796vpxVrMhPEo+Buf
         2Eqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YH0uX+yW+jK8Au1lkLXVjBoaxRQ+HyERW/pFFwt6Hsk=;
        b=VsOxsqRfZmroB5LX8VfPwgeY7W95RMmzztahN8Yt5YRHozywFSpVeshyEVOSrqDboQ
         M6G+7c/fTPL93UdwvSzBsDCn/1TdxenDLHGTd3fEiJ9Kck5DQ8OIYHgyETC4HmfnRzl4
         xNk0+PFNOYxR42JzWEvyTyZDDytLnJTj9gBkRVNRK6CEbZTvzWfbpPVM7dVQmTKtTuuI
         VS2jXrmzf6HuFAyKf1AKEBtp52YH78JySXRy1MAAMMnY1fnXkj9Is0blEBlYCR49DhPW
         huci15zuPP5Jshq6NF9Q12SMIJAwgaIzR2DaB+erN5iqovxoYPzXn2lMFhhdwYInLozW
         zNnQ==
X-Gm-Message-State: AOAM530Bgsn7sC7Sbcl3JPhDsiLSqWS3LmzPMlPqbvPoG3flRdlzKhee
        dhCgbdJbAChmZk8WvAka8Rk=
X-Google-Smtp-Source: ABdhPJxHnjePamk94xr9FEfbE6hAPptpQNUl6/bdfkM943B5bcwuKkLEODPq+0BAgBWnlnHRMv3NPg==
X-Received: by 2002:aa7:c657:: with SMTP id z23mr1772329edr.265.1594683834276;
        Mon, 13 Jul 2020 16:43:54 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a13sm12964712edk.58.2020.07.13.16.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 16:43:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] io_uring: replace list with array for compl batch
Date:   Tue, 14 Jul 2020 02:41:53 +0300
Message-Id: <cde0ab12ccb5f74f82db265cd8b00bf82f0a1e39.1594683622.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594683622.git.asml.silence@gmail.com>
References: <cover.1594683622.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We limit how much request we batch on the completion path, use a fixed
size array instead of lists for completion batching. That also allows
to split io_submit_flush_completions() into 2 steps: the first is
filling CQEs, and the second actually frees requests.

There are plenty of benefits:
- list head tossing is expensive + removes LIST_INIT in state prep
- doesn't do extra unlock/lock to put a linked request
- filling CQEs first gives better latency
- will be used to handle list entry aliasing and add batch free there

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 609c7da044d7..3277a06e2fb6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -680,11 +680,12 @@ struct io_defer_entry {
 };
 
 #define IO_IOPOLL_BATCH			8
+#define IO_COMPL_BATCH			32
 
 struct io_comp_state {
-	unsigned int		nr;
-	struct list_head	list;
 	struct io_ring_ctx	*ctx;
+	unsigned int		nr;
+	struct io_kiocb		*reqs[IO_COMPL_BATCH];
 };
 
 struct io_submit_state {
@@ -1794,28 +1795,21 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 
 static void io_submit_flush_completions(struct io_comp_state *cs)
 {
+	struct io_kiocb *req;
 	struct io_ring_ctx *ctx = cs->ctx;
+	int i, nr = cs->nr;
 
 	spin_lock_irq(&ctx->completion_lock);
-	while (!list_empty(&cs->list)) {
-		struct io_kiocb *req;
-
-		req = list_first_entry(&cs->list, struct io_kiocb, compl.list);
-		list_del(&req->compl.list);
+	for (i = 0; i < nr; ++i) {
+		req = cs->reqs[i];
 		__io_cqring_fill_event(req, req->result, req->compl.cflags);
-		if (!(req->flags & REQ_F_LINK_HEAD)) {
-			req->flags |= REQ_F_COMP_LOCKED;
-			io_put_req(req);
-		} else {
-			spin_unlock_irq(&ctx->completion_lock);
-			io_put_req(req);
-			spin_lock_irq(&ctx->completion_lock);
-		}
 	}
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
-
 	io_cqring_ev_posted(ctx);
+
+	for (i = 0; i < nr; ++i)
+		io_put_req(cs->reqs[i]);
 	cs->nr = 0;
 }
 
@@ -1829,8 +1823,8 @@ static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags,
 		io_clean_op(req);
 		req->result = res;
 		req->compl.cflags = cflags;
-		list_add_tail(&req->compl.list, &cs->list);
-		if (++cs->nr >= 32)
+		cs->reqs[cs->nr++] = req;
+		if (cs->nr == IO_COMPL_BATCH)
 			io_submit_flush_completions(cs);
 	}
 }
@@ -6118,7 +6112,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
  */
 static void io_submit_state_end(struct io_submit_state *state)
 {
-	if (!list_empty(&state->comp.list))
+	if (state->comp.nr)
 		io_submit_flush_completions(&state->comp);
 	blk_finish_plug(&state->plug);
 	io_state_file_put(state);
@@ -6137,7 +6131,6 @@ static void io_submit_state_start(struct io_submit_state *state,
 	state->plug.nowait = true;
 #endif
 	state->comp.nr = 0;
-	INIT_LIST_HEAD(&state->comp.list);
 	state->comp.ctx = ctx;
 	state->free_reqs = 0;
 	state->file = NULL;
-- 
2.24.0

