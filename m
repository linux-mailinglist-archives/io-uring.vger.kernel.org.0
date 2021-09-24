Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB743417CA9
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346547AbhIXVC2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhIXVC1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:27 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04B7C061613
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:53 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id bx4so40994050edb.4
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dFH5CheffFzQOxp6pCNxDg575vEGTDrFHU+KzVe7wvg=;
        b=l/qoUifgFOh8F58tgAcP8+9jgVz216snZVzNrKJ9xj48sug4dVClmka65uYfHHT/B6
         YyB8VXaM9uoJWalUBsJvZ3PCkXzeMxNbrYtbkD+YnOvIpDUVy4+zWlIHySOISNz+alZm
         hqocRW94XUoDVCQNcHNZ3CfF5b9gElZv/38B+ZmHJdjQzKLvWCtbCxjH3Eb70lXi5oqz
         J7f7TglcK3Z7VcF/NJvl8RJvLngyXJWgw/9GPrcCuOvWMxrcI/DPwwkQMTK1KZ9fASia
         hw5IEOQhDPhD0ro40l8C7SrAlnzSiNotCU8EHb+GBHc7JYSU4bjvd+pBORuCq/FJgvz6
         koYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dFH5CheffFzQOxp6pCNxDg575vEGTDrFHU+KzVe7wvg=;
        b=FAlezRvGTWKQpknOEOyCLYlq1Rkg6zvAheazOlXugknW5yswX8hrlbkl4AqlOFeIHY
         seARI8/vlUO/zZBMDqzTHSwWZcQuxTRtiDeBpjcZtgjn2LCJMde7xYGw9qdsoCIBncdo
         EGn/jzliqRNpsw6M3ySBJXmsavkjPp+XaED18Kepw9XLGf6aLxg/JJrYUQJUvKB+T2b1
         EutlRXdUq7lLdkxFCh+6httZnBm+pMoqHQ7jV8KPZ7b+cOigzR//TyulIfRtMcqcUaXa
         Ktbj5C9Euk/XA/kUZyupU8OhdDCv/WqNeFwPBX+wiBgjT03Ku5/jTqjZE1bejTP6pVzo
         ooDw==
X-Gm-Message-State: AOAM530CU0zbV/gduE+sT4aj9fKrVTLPgPND3cI2ubEyqqCFkh4X4kTy
        yq7dgnjh/ulF/yOOKTETg+NkgubeHgI=
X-Google-Smtp-Source: ABdhPJxIN86nD++cjOzloqCBuDDomz+OXgYmI+R9eXzNXdbCB3fDWLe76JLZkJc8jq2OE2SA0UrjVw==
X-Received: by 2002:a50:cd87:: with SMTP id p7mr7662150edi.294.1632517252355;
        Fri, 24 Sep 2021 14:00:52 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:00:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 03/24] io_uring: make io_do_iopoll return number of reqs
Date:   Fri, 24 Sep 2021 21:59:43 +0100
Message-Id: <f771a8153a86f16f12ff4272524e9e549c5de40b.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't pass nr_events pointer around but return directly, it's less
expensive than pointer increments.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b615fa7963ae..9c14e9e722ba 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2430,8 +2430,7 @@ static inline bool io_run_task_work(void)
 /*
  * Find and free completed poll iocbs
  */
-static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			       struct list_head *done)
+static void io_iopoll_complete(struct io_ring_ctx *ctx, struct list_head *done)
 {
 	struct req_batch rb;
 	struct io_kiocb *req;
@@ -2446,7 +2445,6 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 		__io_cqring_fill_event(ctx, req->user_data, req->result,
 					io_put_rw_kbuf(req));
-		(*nr_events)++;
 
 		if (req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
@@ -2457,11 +2455,11 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	io_req_free_batch_finish(ctx, &rb);
 }
 
-static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			bool force_nonspin)
+static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
+	int nr_events = 0;
 	bool spin;
 
 	/*
@@ -2481,6 +2479,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		 */
 		if (READ_ONCE(req->iopoll_completed)) {
 			list_move_tail(&req->inflight_entry, &done);
+			nr_events++;
 			continue;
 		}
 		if (!list_empty(&done))
@@ -2493,14 +2492,16 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 			spin = false;
 
 		/* iopoll may have completed current req */
-		if (READ_ONCE(req->iopoll_completed))
+		if (READ_ONCE(req->iopoll_completed)) {
 			list_move_tail(&req->inflight_entry, &done);
+			nr_events++;
+		}
 	}
 
 	if (!list_empty(&done))
-		io_iopoll_complete(ctx, nr_events, &done);
+		io_iopoll_complete(ctx, &done);
 
-	return 0;
+	return nr_events;
 }
 
 /*
@@ -2514,12 +2515,8 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 
 	mutex_lock(&ctx->uring_lock);
 	while (!list_empty(&ctx->iopoll_list)) {
-		unsigned int nr_events = 0;
-
-		io_do_iopoll(ctx, &nr_events, true);
-
 		/* let it sleep and repeat later if can't complete a request */
-		if (nr_events == 0)
+		if (io_do_iopoll(ctx, true) == 0)
 			break;
 		/*
 		 * Ensure we allow local-to-the-cpu processing to take place,
@@ -2578,8 +2575,12 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			    list_empty(&ctx->iopoll_list))
 				break;
 		}
-		ret = io_do_iopoll(ctx, &nr_events, !min);
-	} while (!ret && nr_events < min && !need_resched());
+		ret = io_do_iopoll(ctx, !min);
+		if (ret < 0)
+			break;
+		nr_events += ret;
+		ret = 0;
+	} while (nr_events < min && !need_resched());
 out:
 	mutex_unlock(&ctx->uring_lock);
 	return ret;
@@ -7346,7 +7347,6 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;
 
 	if (!list_empty(&ctx->iopoll_list) || to_submit) {
-		unsigned nr_events = 0;
 		const struct cred *creds = NULL;
 
 		if (ctx->sq_creds != current_cred())
@@ -7354,7 +7354,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 
 		mutex_lock(&ctx->uring_lock);
 		if (!list_empty(&ctx->iopoll_list))
-			io_do_iopoll(ctx, &nr_events, true);
+			io_do_iopoll(ctx, true);
 
 		/*
 		 * Don't submit if refs are dying, good for io_uring_register(),
-- 
2.33.0

