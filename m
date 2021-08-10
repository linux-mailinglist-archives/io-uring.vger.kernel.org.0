Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF16B3E599D
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 14:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbhHJMGz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 08:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238600AbhHJMGz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 08:06:55 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424F2C0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 05:06:33 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r6so3685222wrt.4
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 05:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wKAbz0FoY6WTL6ziW2XkEjESgZeNRPQzBDe2G7wDFFY=;
        b=mk/k7AMiNyWoDWMiPRr3iOnDUIdV0TS9bZnJbSJi63TSM1NX/R1vrlZSxyamWShr50
         zqMOEPQ9+qWErcUD+vEKCwDqBx1b9JNANGpFm/bOHKZLYGnsIWjpIG5x2MJLWnCUcUKt
         q5MDUViXpuSuKlfyO2AzOkdFDclLCq1/1bzk3PyZuFFa7iDr3UfkksaWJjQeGWmfz3Ht
         93d4pGheyQrAm+Zz9W3CpShWYJHCCD+Kpfpwhb8dHwsL/ARfi9Tn/Q/XVbQ3wqjuRZEh
         Iqww9+VUpckT0VpoZg3Ny8lebewQBbPT42CUTrb/r/C6H5u34qKgvlaxrR0Xx1JZ6N64
         tlFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wKAbz0FoY6WTL6ziW2XkEjESgZeNRPQzBDe2G7wDFFY=;
        b=mJcve86eFRuPFAbFTHzjEwTg93s5qIkUDinRUC15IESacqIUZTnQAjnDwOLZxGiMvW
         WFQFJLrlsOnQzm97wmCQ/1H4wTZ05ZwHZIOzsWjKdkxsM8Byida8FIXBhbAQ+t8O2pmS
         mL6y/AYw7VBfB/IEEJioTU/11yhM+fk0k1kQNLEcN7R16u5G3D+gpogHxiiU2145nDiw
         Hv1PxYWyJ+z8r/1KpTvR6UlJEtotzb+tA/Gm5/kAVg52OlYFD3EN/VYL6dT0mm5BW6Hw
         4lb7V2OxBt6+GV0mO1ojX+PJbzmHTbdwBb9ytdjdnqRnY5NSw6tjzcPNbZIUnNf1Wtfk
         lPNg==
X-Gm-Message-State: AOAM530e8N9/BcfJ8n5aLgD0bwGCgryw4uq5B4R+FlqP0+jWPdoVx7R7
        lVIuzY5rB10jOaCOaTKXM0w=
X-Google-Smtp-Source: ABdhPJzj0sMm0sOWwbiLO3IXEHCdcw9y2AUYrQnMpAK4qNnxsSUzrqO6r7mmj3BS25nk6AgKrKy5TQ==
X-Received: by 2002:a5d:4d8e:: with SMTP id b14mr452361wru.422.1628597191812;
        Tue, 10 Aug 2021 05:06:31 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id d15sm24954362wri.96.2021.08.10.05.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:06:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/5] io_uring: delay freeing ->async_data
Date:   Tue, 10 Aug 2021 13:05:51 +0100
Message-Id: <af9b1fee0d3754bca694b7f00c29528427424ec1.1628595748.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628595748.git.asml.silence@gmail.com>
References: <cover.1628595748.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Prepare for upcoming removal of submission references by delaying
->async_data deallocation, preventing kfree()'ing it up until
io_issue_sqe() returns.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e7dabbe885b3..8ca9895535dd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1771,6 +1771,7 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
+	struct io_kiocb *req;
 	int ret, i;
 
 	BUILD_BUG_ON(ARRAY_SIZE(state->reqs) < IO_REQ_ALLOC_BATCH);
@@ -1796,8 +1797,18 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 		io_preinit_req(state->reqs[i], ctx);
 	state->free_reqs = ret;
 got_req:
-	state->free_reqs--;
-	return state->reqs[state->free_reqs];
+	req = state->reqs[--state->free_reqs];
+
+	/*
+	 * io_req_free(), dismantle() and co. don't free ->async_data, that's
+	 * needed to prevent io_issue_sqe() from kfree'ing the memory somewhere
+	 * deep down the stack and accessing it afterwards.
+	 */
+	if (req->async_data) {
+		kfree(req->async_data);
+		req->async_data = NULL;
+	}
+	return req;
 }
 
 static inline void io_put_file(struct file *file)
@@ -1816,10 +1827,6 @@ static void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req->file);
 	if (req->fixed_rsrc_refs)
 		percpu_ref_put(req->fixed_rsrc_refs);
-	if (req->async_data) {
-		kfree(req->async_data);
-		req->async_data = NULL;
-	}
 }
 
 static void __io_free_req(struct io_kiocb *req)
@@ -8614,6 +8621,8 @@ static void io_req_cache_free(struct list_head *list)
 
 	list_for_each_entry_safe(req, nxt, list, inflight_entry) {
 		list_del(&req->inflight_entry);
+		/* see comment in io_alloc_req() */
+		kfree(req->async_data);
 		kmem_cache_free(req_cachep, req);
 	}
 }
@@ -8621,9 +8630,16 @@ static void io_req_cache_free(struct list_head *list)
 static void io_req_caches_free(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
+	struct io_kiocb *req;
+	int i;
 
 	mutex_lock(&ctx->uring_lock);
 
+	/* see comment in io_alloc_req() */
+	for (i = 0; i < state->free_reqs; i++) {
+		req = state->reqs[i];
+		kfree(req->async_data);
+	}
 	if (state->free_reqs) {
 		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
 		state->free_reqs = 0;
-- 
2.32.0

