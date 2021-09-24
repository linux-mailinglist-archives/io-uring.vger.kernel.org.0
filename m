Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB7C4178E8
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343896AbhIXQiT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347550AbhIXQh5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:57 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DEAC06129D
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:01 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id dj4so38330597edb.5
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=g+9wxor79FpGahC2xymxZ+0SUOsxdFIdQJialRIb1Ec=;
        b=Rxtu4L96+860MzNeg5x8wcdsFrC5r89+IuFInEUmqLAChcxIlLCGtWPv4yXJx68cDa
         aEuerPUbTqJV2h7bAs/R1glD1Rvm9cLsv6aPTGUiZVjjuL4p7h/EqYU+87W/GBJXkj9C
         ZPmGc3h4f0InZheSewidS3Kxp/4L0C5X7lLrRoDZopsrUZ6OD3kQSCC4dC7i5aHIez6B
         GVpX4ASpwVHZtJpcxHtFL3UL+XYGhXZQ0jlU2rovYRpchKEHdHxY2VwlEM7Liv2yhAzx
         txi6qEObLQpkYody80acIF8PG72Mo90IEhWJRUz9hSSqShtsL29JXdj3HzmrA6MuPtc+
         g75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g+9wxor79FpGahC2xymxZ+0SUOsxdFIdQJialRIb1Ec=;
        b=3LKHHBimDvzVOx2vPZltyGEOuNZH3AdFIogszuXG4Z67qOy0mEjIcMhYVhuLV8CFKw
         oF9+zQoQppn4mghjDmnGkGZDG6XZ36rzm+C8qYXVLDuJYOOHI7SMfVv+MbcXDRd6N0aB
         GCZ1LV8bnPZ9QPRVVV+tiQmgY9WYLwq5ayeFezW3YfaQ1JBwtl39tF9VMM8QLoLNjn/z
         YoF4sAPayvkZMdnuXAa+N04Aigi1FCMkbmiic7RfjL3IhNajOwDXWJQeysD7KQ4egE4R
         5IO5U8qjriqIRjD3yUTunlV+A4b/IoGWcm4XSSEA9NTVzferUjVdwgnJf6E3QJ8/YHsR
         TPGw==
X-Gm-Message-State: AOAM532Z+gpldYzirih1xJQnGDyDgP1eDNmj+Yf7HYV1RNuzFa0ahdjT
        7G76Op0LFSwDXpBW63i8xSmIFCm/hXw=
X-Google-Smtp-Source: ABdhPJwXfJWXTYZ1i8YvedkDuLn3tvCvNHDVFMBC4EmfZwMilmlSiiqq0gWKDgirOn0tumStQc2rBw==
X-Received: by 2002:a17:906:d1d6:: with SMTP id bs22mr12410065ejb.554.1632501179726;
        Fri, 24 Sep 2021 09:32:59 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 14/23] io_uring: don't pass tail into io_free_batch_list
Date:   Fri, 24 Sep 2021 17:31:52 +0100
Message-Id: <87c5633e7220f4dc453521f2e83293aed961ec5f.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_free_batch_list() iterates all requests in the passed in list,
so we don't really need to know the tail but can keep iterating until
meet NULL. Just pass the first node into it and it will be enough.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e1637ea4db4c..1d14d85377b5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2267,14 +2267,12 @@ static void io_free_req_work(struct io_kiocb *req, bool *locked)
 }
 
 static void io_free_batch_list(struct io_ring_ctx *ctx,
-			       struct io_wq_work_list *list)
+				struct io_wq_work_node *node)
 	__must_hold(&ctx->uring_lock)
 {
-	struct io_wq_work_node *node;
 	struct task_struct *task = NULL;
 	int task_refs = 0, ctx_refs = 0;
 
-	node = list->first;
 	do {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
@@ -2321,7 +2319,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
 
-	io_free_batch_list(ctx, &state->compl_reqs);
+	io_free_batch_list(ctx, state->compl_reqs.first);
 	INIT_WQ_LIST(&state->compl_reqs);
 }
 
@@ -2404,7 +2402,6 @@ static inline bool io_run_task_work(void)
 static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
-	struct io_wq_work_list list;
 	int nr_events = 0;
 	bool spin;
 
@@ -2458,10 +2455,9 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 
 	io_commit_cqring(ctx);
 	io_cqring_ev_posted_iopoll(ctx);
-	list.first = start ? start->next : ctx->iopoll_list.first;
-	list.last = prev;
+	pos = start ? start->next : ctx->iopoll_list.first;
 	wq_list_cut(&ctx->iopoll_list, prev, start);
-	io_free_batch_list(ctx, &list);
+	io_free_batch_list(ctx, pos);
 	return nr_events;
 }
 
-- 
2.33.0

