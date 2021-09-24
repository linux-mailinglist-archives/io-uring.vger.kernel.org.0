Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D5E4178D8
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347565AbhIXQhf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347811AbhIXQgr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:36:47 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE61CC06139F
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:49 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id v10so33636484edj.10
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/uh6i+Ok3qgHY4mfFQAHpjjKLNJCR/w2urT4NB8vp8s=;
        b=YhIrRcRfIuOn10HwdNSM/g8o6zej00jtEJJNY2snQSGvst7c7bZ8R27NYZqdpIHbXs
         BI+yJTW0brB5YECEd+jOzNMtO/pe4jaKqdVc9CNmXW2RqRtpH3rY4m0fFaaSbgxjCAKB
         e2T+HlJk8/JKsKxTpTbbpzMTzlJfMXXQc999Pm5XN7IbJKWlg+T10r4rj3xrABR0mZVt
         3A2yOWzFQcjlZI8i0GGrP6AQcOXpQxwzNGsdO74hsaN/pQfKufdPiPkoU5i1RHiiU8hJ
         zFaE76Lx79Yq0reT4sDvpCwh15/SpmLQaVtSbjYlZ/BxrjnX3Za/xNHFgReJU9BiaIEn
         c5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/uh6i+Ok3qgHY4mfFQAHpjjKLNJCR/w2urT4NB8vp8s=;
        b=ogfIm+q0GuWzE08lhXWPnt9S0tTW1FJtxGHqNe+pQK+wkMCUqETulRbtbXFl90QeGI
         S/0zXXf/863nSkR2lPM0LljtlRwT01wojIyF48ytO8k+9vjh1eT6ll2p6yq8GDIKfs8B
         wYKZ8uGAPaLExyMcqK/zi6G1BkF0sHl86k/xM8ojegiboE1ECihabqrHPOPpTED1U5RG
         pCW4I6TsivdojFzotLsIyJAzpyTPr/prt4wqlRxzp0ZeK/1hdEa+Baf0vNZcA3cTab/Y
         qShAhStyJfJpdKpksYAADax7s7jOc0kHk5ztEZ7fDNvOeyCZC42iYyYyijZv+Izfw9/q
         87bg==
X-Gm-Message-State: AOAM530eBuz9PqHaV32CWe6xQJqWddSP6maBcJwfSPeCaqabz0+bvdE5
        IyELU3lnfUUNNzEQf/AZHdLPr8ywSBY=
X-Google-Smtp-Source: ABdhPJxI60Ldu8Oc1k6UvGMbLBo1dLb2aFYCsp7ArS7MYvJUtCjSSs5dJHCxI7oYBF5RLx9KlmrjXw==
X-Received: by 2002:a17:906:b782:: with SMTP id dt2mr12152969ejb.310.1632501168543;
        Fri, 24 Sep 2021 09:32:48 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/23] io_uring: force_nonspin
Date:   Fri, 24 Sep 2021 17:31:40 +0100
Message-Id: <cd5e593890e6bdbb6eb2430aa124106d2f4e5e97.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't really need to pass the number of requests to complete into
io_do_iopoll(), a flag whether to enforce non-spin mode is enough.

Should be straightforward, maybe except io_iopoll_check(). We pass !min
there, because we do never enter with the number of already reaped
requests is larger than the specified @min, apart from the first
iteration, where nr_events is 0 and so the final check should be
identical.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8d0751fba1c2..b5631dcc4540 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2455,7 +2455,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 }
 
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			long min)
+			bool force_nonspin)
 {
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
@@ -2463,9 +2463,9 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 	/*
 	 * Only spin for completions if we don't have multiple devices hanging
-	 * off our complete list, and we're under the requested amount.
+	 * off our complete list.
 	 */
-	spin = !ctx->poll_multi_queue && *nr_events < min;
+	spin = !ctx->poll_multi_queue && !force_nonspin;
 
 	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, inflight_entry) {
 		struct kiocb *kiocb = &req->rw.kiocb;
@@ -2513,7 +2513,7 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 	while (!list_empty(&ctx->iopoll_list)) {
 		unsigned int nr_events = 0;
 
-		io_do_iopoll(ctx, &nr_events, 0);
+		io_do_iopoll(ctx, &nr_events, true);
 
 		/* let it sleep and repeat later if can't complete a request */
 		if (nr_events == 0)
@@ -2575,7 +2575,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			    list_empty(&ctx->iopoll_list))
 				break;
 		}
-		ret = io_do_iopoll(ctx, &nr_events, min);
+		ret = io_do_iopoll(ctx, &nr_events, !min);
 	} while (!ret && nr_events < min && !need_resched());
 out:
 	mutex_unlock(&ctx->uring_lock);
@@ -7338,7 +7338,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 
 		mutex_lock(&ctx->uring_lock);
 		if (!list_empty(&ctx->iopoll_list))
-			io_do_iopoll(ctx, &nr_events, 0);
+			io_do_iopoll(ctx, &nr_events, true);
 
 		/*
 		 * Don't submit if refs are dying, good for io_uring_register(),
-- 
2.33.0

