Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E224178DF
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344278AbhIXQh7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347556AbhIXQhe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:34 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A847BC0613B4
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:57 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id v24so38250702eda.3
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=abMcxi95/hsxjJx9hpHZMsBHFjMiR3lwaSwingOsX18=;
        b=AxE6abbV8ukkMVTpdd4b8E8clYOQYm6760Qpn/RDGesmn9lbSFFpzSUxSkCftV0c5M
         +7Z6TZ58lOx1Y7zZERZUQLcCbUrjcBLwk3nMqd+6kHecgTMZbB4/MUs5whM0fZb485bR
         4H2P/p+wR/7mp3m9RtW2XO+gjFUOtt6avJOSj6KFdDgLiRCgOfslutpQLeUH1ZUQnbCC
         /4EK/BAbRrZhLDasgo6V7s1MyitMnCfBijjqooc3A4wpMzpNyMddEgBJ1IEb9CFT5UAL
         dmsBNGhfBfXvQN3YHUSO5kdfeHXgt9iLIqjBaA+0y3X5RvuG3fQmX7AkBSWlaDidO8dy
         6k4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=abMcxi95/hsxjJx9hpHZMsBHFjMiR3lwaSwingOsX18=;
        b=NllpJFKAe1xFTzQZS8kSrHrFVE09vr8STHKzYrU/aXGqcFWgAUVQnaXvZOtBuFksk/
         4qZS5mLzZyrOXHj61q95+1rtgN0y4aeq1UEPuSywNDqecUHEZDL45fTNBGQ87QIEF7Do
         +nEP11igFN+ePK5GUxlwBaL5bcIoUCJka6QbPCl/FX9w8HtF8crxuGyS0b/vL0JH9LDC
         /qBOVnStVxvlrSPYi7I8uKQCrxAjYFEy76RNddQDyHtYJKAgEGtI/y2oguLJfr+d6U0U
         VM8cjrpHBRJgwz4rOKIldVCIOys+em4M28Kn46ixaxFJDgD0toaDs2lMjmvc21fkWgGF
         NQ2A==
X-Gm-Message-State: AOAM531R6KJVcptreY/ERhLFCashtfLqofi9LHBklS96K3CnaQeS0N/c
        Fijw0OLSVO7eD9hlyS8+7aaTtK1D4pM=
X-Google-Smtp-Source: ABdhPJxuIlxQcxtvEIrzuvHU1FfXrPUQls4plYWEtRxeQuOT3kwaqEScgzHzFT70WICne7jqgtPoFQ==
X-Received: by 2002:a17:906:8151:: with SMTP id z17mr11927043ejw.468.1632501176283;
        Fri, 24 Sep 2021 09:32:56 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/23] io_uring: add a helper for batch free
Date:   Fri, 24 Sep 2021 17:31:48 +0100
Message-Id: <159c8a3c639572625290f90dd3561a277027a457.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper io_free_batch_list(), which takes a single linked list and
puts/frees all requests from it in an efficient manner. Will be reused
later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f4a7468c4570..e1c8374954fc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2305,12 +2305,31 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	wq_stack_add_head(&req->comp_list, &state->free_list);
 }
 
+static void io_free_batch_list(struct io_ring_ctx *ctx,
+			       struct io_wq_work_list *list)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_wq_work_node *node;
+	struct req_batch rb;
+
+	io_init_req_batch(&rb);
+	node = list->first;
+	do {
+		struct io_kiocb *req = container_of(node, struct io_kiocb,
+						    comp_list);
+
+		node = req->comp_list.next;
+		if (req_ref_put_and_test(req))
+			io_req_free_batch(&rb, req, &ctx->submit_state);
+	} while (node);
+	io_req_free_batch_finish(ctx, &rb);
+}
+
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_submit_state *state = &ctx->submit_state;
-	struct req_batch rb;
 
 	spin_lock(&ctx->completion_lock);
 	wq_list_for_each(node, prev, &state->compl_reqs) {
@@ -2324,18 +2343,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
 
-	io_init_req_batch(&rb);
-	node = state->compl_reqs.first;
-	do {
-		struct io_kiocb *req = container_of(node, struct io_kiocb,
-						    comp_list);
-
-		node = req->comp_list.next;
-		if (req_ref_put_and_test(req))
-			io_req_free_batch(&rb, req, &ctx->submit_state);
-	} while (node);
-
-	io_req_free_batch_finish(ctx, &rb);
+	io_free_batch_list(ctx, &state->compl_reqs);
 	INIT_WQ_LIST(&state->compl_reqs);
 }
 
-- 
2.33.0

