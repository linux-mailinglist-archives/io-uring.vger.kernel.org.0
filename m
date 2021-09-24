Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16A14178E4
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245713AbhIXQiB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347432AbhIXQhl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:41 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593D2C0613BB
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:59 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id y12so2083518edo.9
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KcM6Y7F3jlYgmqckxvzXtgME4tE912nzIHTA6y/18Bw=;
        b=EI+kwAs7TgrLERr/8SVpZw5Jsuc49ZfN7h1d0ctzQM7DmOuFCo1DKKUUet9fYrxFLX
         RGuSzyjIzkio8zFNm0Mk7UpJ68mVc9wpOYLc8F7NL4c+Bu0hi+Vwnl9mm/REd8Frjtaf
         mZcf+fhdzF6V02RqT463Yi1iARp8H8XjlEVAHJFYxVrD/2p96jPgQ80uVVZQ/aKv8MYQ
         sNxvLqdI5xXOMvPBgMWDbSO0hi3viGVHHWbp5SplQhhKssaRKqdbzCfKIa/sJNaU3rTp
         havMiJupsXCpSG1XgvOWvx/ZnD6GvSEA5w2PS4lYBXMwyviySqDFCFCsaADgYABhuiuu
         5EcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KcM6Y7F3jlYgmqckxvzXtgME4tE912nzIHTA6y/18Bw=;
        b=GfbAKl5yVy2EdVbe5ccHoBe8SOL0GnrgAI41O2MXUCTlfx7iYqX6O0oTeGGx6BYWKF
         5p2YaqXv+xe5nqfw/CJRqKLRP+mzBgA6sfIPMdXX08mtl/UDRx/xKgda4D/JGwss+Z6T
         kVybxw2fWxXxnQZPKZDb/iBiCOXvEnrLG0jMAvd7WTjnswI7YxhqT1FxnIaSC84Rd5Tl
         5tZ1iPVUDy0qBV2/3cC2bG8qQj8dhM5qHgaBpKNooGGbeKjnrBXv9d3Rn+f76zSTU6Fv
         ImuAXmsQFxC3uKtqoyNdYLLK68+N7InoDPV0Fg3sL3yJffvYeyDVu5ZASIKHZQOSSmPJ
         lAWA==
X-Gm-Message-State: AOAM5324EI9y9VDTFeM5hgT40rlJ7RK95WH4Td06HNysVTOH1VchOQWf
        yRXl7weo4QMv699EkV6JPKA38g/Zdkk=
X-Google-Smtp-Source: ABdhPJxDxcEhnAaAUz/fPzKf8ee68TRZsed1vaTTj1bGxmmBDcKEN5xnbu0GRm9Cs6mugIRSK/xHMQ==
X-Received: by 2002:a17:906:1c07:: with SMTP id k7mr12303327ejg.145.1632501177987;
        Fri, 24 Sep 2021 09:32:57 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/23] io_uring: optimise batch completion
Date:   Fri, 24 Sep 2021 17:31:50 +0100
Message-Id: <da1905bfd0c8edc751761c477d6277cf0b549fe5.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
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
index e5d42ca45bce..70cd32fb4c70 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2423,32 +2423,10 @@ static inline bool io_run_task_work(void)
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
 
@@ -2493,15 +2471,19 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
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

