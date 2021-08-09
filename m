Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6661F3E4CF0
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 21:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbhHITTW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 15:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235968AbhHITTU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 15:19:20 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA80EC061796
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 12:18:53 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id u15so11313466wmj.1
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 12:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ee6SZ8mR/zac0b6XUr804HyC7MeWA+5us01c/D4bkAY=;
        b=AgBbYWoxx0+7OVVX/wpuZeT5FdRnpt/MtmYhZ/3BjAUFJBypriUNVyhGb+4GK1DLXi
         YQ064WJ37/M2qIMI9mUxBQbkR7nuHxU0lLoGEl5+v0m+3CrP5inPkp2rpqm1waTRL55U
         Mco4gFgiKMNUq7ajS7uRfZmfrk8gUSY4I7NjUHiU3abDxCSnAK4A4JHakSZuhXH02+3N
         VjLxEof8eMz8EmwKucacApVbwC7Aw+QjMnGR7QP71GkY2VngKpANngJR6qF5HWh3uxx9
         XqACOSRRgCCkxHVHeBs5W3FESMbEQGtVqo1ktQqUbxN1/L04oXEwQ/7jU549k8qZi5wr
         oGZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ee6SZ8mR/zac0b6XUr804HyC7MeWA+5us01c/D4bkAY=;
        b=Fl65CZqCL0BYVkAtDnk4SpY09Dy/pJuos/0Q3kIDIyZGUwmw8nQCgV1Ykln0/O048l
         /9KUrVxd7KwRng/mtPfwiaV8H0eK1rlPBMdFY5Q3d5ZTr/NMrrkkzoI2wGtzBanCgUYC
         Cm4GHnpiQ+QJFUdhZOieWBSA8ewG0MY2f3BA6XhzX+acGwrIhjQgai3tti3pnpF4urPx
         Ozp45xkomVAXM38LpYaAEBiEN9Gg3LtHJiCXnRBt0CHjmE/P8hT1IESxeQBJ8AdJuNds
         7SU/byEXdgJCql0S8QKPMOCWLLT0M7RGtkSbFKWtQFeFKxVUQa5OwKqbRPDBzTUJKZJn
         33LQ==
X-Gm-Message-State: AOAM533AxuddV8z6VFdRNLyYsgQsrQV8ByArN8XSkzpm1PAH1svcJBN2
        mnNnZTK03dA2lX5vZz94hKw=
X-Google-Smtp-Source: ABdhPJxOpYaokpTNhWHLVqwPRLpA8iGLUA82tjelFhC/+fgnUgn5tup3/gtEY9JEAAYGSQar0KOiBw==
X-Received: by 2002:a05:600c:3782:: with SMTP id o2mr630369wmr.137.1628536732386;
        Mon, 09 Aug 2021 12:18:52 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id h11sm13283074wrq.64.2021.08.09.12.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 12:18:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/7] io_uring: use inflight_entry instead of compl.list
Date:   Mon,  9 Aug 2021 20:18:10 +0100
Message-Id: <e430e79d22d70a190d718831bda7bfed1daf8976.1628536684.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628536684.git.asml.silence@gmail.com>
References: <cover.1628536684.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->compl.list is used to cache freed requests, and so can't overlap in
time with req->inflight_entry. So, use inflight_entry to link requests
and remove compl.list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7ad3a1254c59..2cf640dbad4f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -669,7 +669,6 @@ struct io_unlink {
 
 struct io_completion {
 	struct file			*file;
-	struct list_head		list;
 	u32				cflags;
 };
 
@@ -1665,7 +1664,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 		}
 		io_dismantle_req(req);
 		io_put_task(req->task, 1);
-		list_add(&req->compl.list, &ctx->locked_free_list);
+		list_add(&req->inflight_entry, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
 	} else {
 		if (!percpu_ref_tryget(&ctx->refs))
@@ -1756,9 +1755,9 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 	nr = state->free_reqs;
 	while (!list_empty(&cs->free_list)) {
 		struct io_kiocb *req = list_first_entry(&cs->free_list,
-						struct io_kiocb, compl.list);
+					struct io_kiocb, inflight_entry);
 
-		list_del(&req->compl.list);
+		list_del(&req->inflight_entry);
 		state->reqs[nr++] = req;
 		if (nr == ARRAY_SIZE(state->reqs))
 			break;
@@ -1832,7 +1831,7 @@ static void __io_free_req(struct io_kiocb *req)
 	io_put_task(req->task, 1);
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	list_add(&req->compl.list, &ctx->locked_free_list);
+	list_add(&req->inflight_entry, &ctx->locked_free_list);
 	ctx->locked_free_nr++;
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
@@ -2139,7 +2138,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	if (state->free_reqs != ARRAY_SIZE(state->reqs))
 		state->reqs[state->free_reqs++] = req;
 	else
-		list_add(&req->compl.list, &state->comp.free_list);
+		list_add(&req->inflight_entry, &state->comp.free_list);
 }
 
 static void io_submit_flush_completions(struct io_ring_ctx *ctx)
@@ -8626,8 +8625,8 @@ static void io_req_cache_free(struct list_head *list)
 {
 	struct io_kiocb *req, *nxt;
 
-	list_for_each_entry_safe(req, nxt, list, compl.list) {
-		list_del(&req->compl.list);
+	list_for_each_entry_safe(req, nxt, list, inflight_entry) {
+		list_del(&req->inflight_entry);
 		kmem_cache_free(req_cachep, req);
 	}
 }
-- 
2.32.0

