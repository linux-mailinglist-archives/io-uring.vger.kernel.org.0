Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE30417CB6
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348467AbhIXVCo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346541AbhIXVCg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:36 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88991C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:02 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id y12so4721127edo.9
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/JH/NPImfLPvYD566KpDOTHB0Fs67DQ59QKfV2T1/jo=;
        b=E4uVb5ttRXF7+ROWYiKGtOgxbliWsFTq/3VWEmdXhvDBdl/w/Ck+dEmnZZmvzd31ei
         D/BJtPHEWXbEMB32p8V0jmSCw90rLldNuQBYw8EfP7Sdr1Sc6pRCREwrMPANbnnEggRk
         gbAfYefi0OwG2YdVZgkURvDutaf8JOmZHk3f8hwe4N0PSMmGixG0EotMtzJI9TC21fCh
         mAH0CHiNojxO3PtCj1tNnT+VnMtH+cT5FI+HKww+vJn7pBiKZ+1uP5M60el+pfOni82L
         6QV2HZhBGNchPM7qT39SBD3mAzVtmZnM6UFqedE5CyofDzn2xm30hFqjrruhnfcN+lRk
         XQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/JH/NPImfLPvYD566KpDOTHB0Fs67DQ59QKfV2T1/jo=;
        b=1ACXc8lFkknzRmr6QPY4fPBtGDflRLgRWe/0fgDc4x5NKW4SYSitvqWE+a5RtdbM9X
         n0ZYhl5jw7q7acm/W7cogGEqhw89lK+mO+No1IeRt99+FMF0u9MkNa3BLVEPrX19x3xI
         hDqX1KoFu1NdJdgQPE8kJBeHYkHLvz2aAZ/1iL0dWkLB8blZzeNqtRiLAy9Pe1r4mm6R
         EnCJ3wD0+5hWbAqcaRg5ta9lfgMti8Sfuh9kyDsm2dIWEWN1edoNHu50+soffQ0ccSiA
         OLaoO6C+Af/xdZNdZXnvMAIryGifsJ4ZD5guaEqGyALq1guOSe1+u9Fl0T50wH4mwmIr
         cgJQ==
X-Gm-Message-State: AOAM531hT6efQ6GInjogfR+P/mEX6g1jFVUbWZHcUF7toUQmOcjmeiEI
        Md9HZr1GxSWtBfxBhhDkWC7bkfca0Ac=
X-Google-Smtp-Source: ABdhPJxfc3CfVaBsSXGUpS9a5HXhUTTq3CycKrbtf6NX36gTYsQ6DH/KntLqw+uAqqz57naMkvFC0g==
X-Received: by 2002:a17:906:2a0d:: with SMTP id j13mr12869160eje.545.1632517261180;
        Fri, 24 Sep 2021 14:01:01 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:01:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 14/24] io_uring: don't pass tail into io_free_batch_list
Date:   Fri, 24 Sep 2021 21:59:54 +0100
Message-Id: <4a12c84b6d887d980e05f417ba4172d04c64acae.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
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
index 8d2aa0951579..f8640959554b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2270,14 +2270,12 @@ static void io_free_req_work(struct io_kiocb *req, bool *locked)
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
@@ -2324,7 +2322,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
 
-	io_free_batch_list(ctx, &state->compl_reqs);
+	io_free_batch_list(ctx, state->compl_reqs.first);
 	INIT_WQ_LIST(&state->compl_reqs);
 }
 
@@ -2407,7 +2405,6 @@ static inline bool io_run_task_work(void)
 static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
-	struct io_wq_work_list list;
 	int nr_events = 0;
 	bool spin;
 
@@ -2461,10 +2458,9 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 
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

