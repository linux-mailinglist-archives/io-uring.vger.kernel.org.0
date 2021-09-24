Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5838417CB2
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346614AbhIXVCm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348455AbhIXVCe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:34 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE34CC061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:00 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id dm26so6657341edb.12
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MyW1S+9gBxhJtXbabKsUDSaMS7ULVhD0ivbFGzUA2Bw=;
        b=f5KhYq4oi/5MyaiNAWUVDANh0sIr2lqS6qsNKcAzccKyv0AKfrMZ38AGy4zXWU5VBa
         ETYayJFl49m6zKXhefKnJoTxR2i0+fNw2wJrT4tuHOeKx0EdtGEKrJsLHfC24d9cQhlR
         4laqQ7nTK04RQGgyOc58LBusmRczktx6FF3zu5xS6IERqzacmopbuCS7LEKbpoEDcFXO
         g/AgXpSDGtRqJiFfjHUOlaNt4AK5b9R28crkM+yZX6WlRc2NQUgXy7TIzJ98V0sEY6gF
         phiuX9ooXsdzW1p+Cy9KEsFK/G3S6tRSyCZA31XHM2//bmAz67FH4waPh9C3Y/hCgdna
         dadg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MyW1S+9gBxhJtXbabKsUDSaMS7ULVhD0ivbFGzUA2Bw=;
        b=gF0ucNVMvCrmncBgCDCALudrhpRGMAw/4pINS16KN1hiNuP2sBsgCOFQ8mqmGmKbbR
         cL3Lxnqs7jeehOx1t2529RWaSEOASz0nsLYDXu/4cW+kqvmSMqiBtZY7zhurCNgxT7A5
         c6IdaiWEKE5Vx9OMUPj5T80EVdEELi7SBo5T6G4RWjVh34IuPnKffR/AAzi+lwL01qCV
         30y4Rvbfrz1daEp6iNeKjEXOc3Mc35j74IE7A3wnlNW/JrHwY6jYiJFOb2fBlBufPjIg
         w2jqmHfmjRPnIzxUEnJvUyP8mzmskEeNSZaL921UPj3nQu6W6sl1u/7VQO7nJDgjs6Ce
         B/sQ==
X-Gm-Message-State: AOAM530ZotZeKtzDpmUHCB34GikT7/joD7GqYgW7p4jTDjIqCbgxa3yi
        AtzeWhPtoHWoX2reKG7w6JqlxUIgBY8=
X-Google-Smtp-Source: ABdhPJxHFMX6KLPPW5uLF7iDmidSubmm5z+dYQwLHblvaq6ddTX6ObaQk5kjV52tcynoaIzAkFjbeQ==
X-Received: by 2002:aa7:cb8a:: with SMTP id r10mr7455756edt.237.1632517259553;
        Fri, 24 Sep 2021 14:00:59 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:00:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 12/24] io_uring: optimise batch completion
Date:   Fri, 24 Sep 2021 21:59:52 +0100
Message-Id: <b37fc6d5954b241e025eead7ab92c6f44a42f229.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First, convert rest of iopoll bits to single linked lists, and also
replace per-request list_add_tail() with splicing a part of slist.

With that, use io_free_batch_list() to put/free requests. The main
advantage of it is that it's now the only user of struct req_batch and
friends, and so they can be inlined. The main overhead there was
per-request call to not-inlined io_req_free_batch(), which is expensive
enough.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cf7fcbdb5563..c9588519e04a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2426,32 +2426,10 @@ static inline bool io_run_task_work(void)
 	return false;
 }
 
-/*
- * Find and free completed poll iocbs
- */
-static void io_iopoll_complete(struct io_ring_ctx *ctx, struct list_head *done)
-{
-	struct req_batch rb;
-	struct io_kiocb *req;
-
-	io_init_req_batch(&rb);
-	while (!list_empty(done)) {
-		req = list_first_entry(done, struct io_kiocb, inflight_entry);
-		list_del(&req->inflight_entry);
-
-		if (req_ref_put_and_test(req))
-			io_req_free_batch(&rb, req, &ctx->submit_state);
-	}
-
-	io_commit_cqring(ctx);
-	io_cqring_ev_posted_iopoll(ctx);
-	io_req_free_batch_finish(ctx, &rb);
-}
-
 static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
-	LIST_HEAD(done);
+	struct io_wq_work_list list;
 	int nr_events = 0;
 	bool spin;
 
@@ -2496,15 +2474,19 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
 		__io_cqring_fill_event(ctx, req->user_data, req->result,
-				       io_put_rw_kbuf(req));
-
-		list_add_tail(&req->inflight_entry, &done);
+					io_put_rw_kbuf(req));
 		nr_events++;
 	}
 
+	if (unlikely(!nr_events))
+		return 0;
+
+	io_commit_cqring(ctx);
+	io_cqring_ev_posted_iopoll(ctx);
+	list.first = start ? start->next : ctx->iopoll_list.first;
+	list.last = prev;
 	wq_list_cut(&ctx->iopoll_list, prev, start);
-	if (nr_events)
-		io_iopoll_complete(ctx, &done);
+	io_free_batch_list(ctx, &list);
 	return nr_events;
 }
 
-- 
2.33.0

