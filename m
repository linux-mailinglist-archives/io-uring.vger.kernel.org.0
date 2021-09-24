Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFE64178DB
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347547AbhIXQhl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347471AbhIXQg5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:36:57 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BABC0613A2
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:50 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id v18so2955919edc.11
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=D8Ir7JH/fMRki6/UI94QGVRgXcRNtY5+72tnKqyXohI=;
        b=TPse4cEldKJLnksoXTROa3+aVC6TW4zUfG7cS/Wmd0IfFM4bmPcR4wgUuT/t0cn8qi
         6sQWlkVcq0gJfnqtXZtcS32yEneAE0C6zikIIObTWLqgoIzfCNr4YzCZV0BV3hS2yel6
         d+OL/3EjamOoZ9O6+F90l2PSuD0sQr9VVR+iY+ZsOu5pPWy2b7dBP9eFnt84jrJI2B2v
         aYRerjK66wGebFp5ZXPckawHFIamBApHdY60evr/hRFp+JjG67R6/mKgfduOXsh8jZLN
         G9DwobvEIvZlm/OnXH6NZULK3+EGdpGzFZcfPl3dKkJ14m7Wp3wRcTkWZqzc7DYEV7hm
         qBQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D8Ir7JH/fMRki6/UI94QGVRgXcRNtY5+72tnKqyXohI=;
        b=12eHEz37jmMZiKbSLFLGDRVKg2o4djdmiOzv0iT2u1JWsO94AjnjMXmOlx5GKOL6ju
         hE6cXF+06V7tR9Y0vrebcIvl0k1qymgNkpB2wxRVpJ8WZfMQ2oGlhqxTUoc2kNeKKP3e
         UFkDPgrCOVUUD3p5QYzLywctLMzotmTIry957cbG2MvqFV19VIC3ZMyiSa2U5yjyqZUs
         4KEAgDKCjXf3o5WP7z4ClMFuQSh3nKdEEVmPG6IBNEpEgK4WlJQnVpB6yCGRsGpx/prt
         WP6KbtsmQrx+eSmiagIb4OC3JWCiSIngDeE7gItAb6n52gIXxbRaSEvdRJ8B5sHNzXs/
         tM0A==
X-Gm-Message-State: AOAM532HOQg4yEj0ewC//4qDg5XmN67lJlpNIEuP3IGFMZH1rRL6b84g
        MmU9r0R6qWbmepXUhZYpAhBCbjD357o=
X-Google-Smtp-Source: ABdhPJySTodv5JiBauzFgxzaZYAQm6rtLrL0irdFl4QLCjRDrZEr2N23N8TAgVdjVrxbAfEoE8bf9Q==
X-Received: by 2002:aa7:c78f:: with SMTP id n15mr6184333eds.338.1632501169413;
        Fri, 24 Sep 2021 09:32:49 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/23] io_uring: make io_do_iopoll return number of reqs
Date:   Fri, 24 Sep 2021 17:31:41 +0100
Message-Id: <e71deea0d4530cc8edd4b9963b7993f05579834b.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
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
index b5631dcc4540..13cb40d8ce08 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2427,8 +2427,7 @@ static inline bool io_run_task_work(void)
 /*
  * Find and free completed poll iocbs
  */
-static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			       struct list_head *done)
+static void io_iopoll_complete(struct io_ring_ctx *ctx, struct list_head *done)
 {
 	struct req_batch rb;
 	struct io_kiocb *req;
@@ -2443,7 +2442,6 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 		__io_cqring_fill_event(ctx, req->user_data, req->result,
 					io_put_rw_kbuf(req));
-		(*nr_events)++;
 
 		if (req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
@@ -2454,11 +2452,11 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
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
@@ -2478,6 +2476,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		 */
 		if (READ_ONCE(req->iopoll_completed)) {
 			list_move_tail(&req->inflight_entry, &done);
+			nr_events++;
 			continue;
 		}
 		if (!list_empty(&done))
@@ -2490,14 +2489,16 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
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
@@ -2511,12 +2512,8 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 
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
@@ -2575,8 +2572,12 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
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
@@ -7330,7 +7331,6 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;
 
 	if (!list_empty(&ctx->iopoll_list) || to_submit) {
-		unsigned nr_events = 0;
 		const struct cred *creds = NULL;
 
 		if (ctx->sq_creds != current_cred())
@@ -7338,7 +7338,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 
 		mutex_lock(&ctx->uring_lock);
 		if (!list_empty(&ctx->iopoll_list))
-			io_do_iopoll(ctx, &nr_events, true);
+			io_do_iopoll(ctx, true);
 
 		/*
 		 * Don't submit if refs are dying, good for io_uring_register(),
-- 
2.33.0

