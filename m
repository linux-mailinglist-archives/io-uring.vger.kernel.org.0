Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224CE50A10D
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 15:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386677AbiDUNsC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 09:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354829AbiDUNsB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 09:48:01 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894B2AE6C
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:11 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso5911013wme.5
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KV/6vsw+M5Xw9DYQo/hbAxJRPK35QpKGY5cwkiMzVTE=;
        b=nZNph+zafy9MTOQiI+p42ocp9nV+3zn6PzeygVsSiS4DGZspLctoWc9dstlIWK0dCv
         BGNw9xgZXrUOjLdzBnR+uFvEMcWPLBQhjsWOEdbSyRIVCLuWIvTTc37naSw/jrJLNDz1
         xzZMQ7AixoH0j/R51vzNnFf8LRC3zgCxOM7fOAW0i9CNurfhaKFrYLTbkptc5Ot/dbIj
         eb6ODVC86McXOI0iALbVvQQ0guXsjbk3Wfiv2ylJcCinxUheEWLM9d9okM3vzq6ixVtz
         2oZXTL0X+xucvYU+V5T3B0YLo8eaX2AGPvkD8DM58aiPP2ViSH6GIfPlOI2VSBOzSWCt
         L2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KV/6vsw+M5Xw9DYQo/hbAxJRPK35QpKGY5cwkiMzVTE=;
        b=oqgrVUdjy5gfTqdBr3gfsUc53E1E9RcMvg8sCNzPylewES6nHycsSRBhycQGxC5dcG
         WqpTakoPcU+terlxEvVVuF9nBhNv5/HcFnlJFRRo0WXfr8RAX8+V4uvVKvnAweBNlL1Z
         kZU1DAA6FgT15IHDlII2UMu57sxUnOJA/gKbqAWeLkte5/E9V4hJoGsjeOdT9vfJuOw1
         2fKUUowWZL+oNXy6cs7B25+fPySCXORqNmkAzWqDukFyC/A+UpeuPTynMGhzWu00AAGM
         cOAtWDisjU97dXPNdCe33f3mywgjPD6VvaRnuHOAElvihlzX3VC5iTwQoUIET55ivP4W
         3ZaQ==
X-Gm-Message-State: AOAM531HjVxpHB3rrpEC9qY0ROrGmETWZ/8iM0HhFMryDEJOYyHHdoCM
        BrNdgWZ8TV+1sYnXJ5Yh0ThyYuk/g1k=
X-Google-Smtp-Source: ABdhPJwCEmor7y/sRVcw07S3pteP0Ifr5KmSmP/Gp6lfsnfNekv8BYw+L125Q4FVK2rZ4SDzGBIOpA==
X-Received: by 2002:a05:600c:1548:b0:392:8e1a:18c3 with SMTP id f8-20020a05600c154800b003928e1a18c3mr8834100wmg.102.1650548709953;
        Thu, 21 Apr 2022 06:45:09 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.218])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm2837821wri.45.2022.04.21.06.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:45:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 02/11] io_uringg: add io_should_fail_tw() helper
Date:   Thu, 21 Apr 2022 14:44:15 +0100
Message-Id: <36d9e962986e786eac9aaae6704d47791047a7ef.1650548192.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650548192.git.asml.silence@gmail.com>
References: <cover.1650548192.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a simple helper telling a tw handler whether it should cancel
requests, i.e. when the owner task is exiting.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8011a61e6bd4..272a180ab7ee 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1304,6 +1304,11 @@ static inline void req_ref_get(struct io_kiocb *req)
 	atomic_inc(&req->refs);
 }
 
+static inline bool io_should_fail_tw(struct io_kiocb *req)
+{
+	return unlikely(req->task->flags & PF_EXITING);
+}
+
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
@@ -2641,8 +2646,8 @@ static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
 static void io_req_task_submit(struct io_kiocb *req, bool *locked)
 {
 	io_tw_lock(req->ctx, locked);
-	/* req->task == current here, checking PF_EXITING is safe */
-	if (likely(!(req->task->flags & PF_EXITING)))
+
+	if (!io_should_fail_tw(req))
 		io_queue_sqe(req);
 	else
 		io_req_complete_failed(req, -EFAULT);
@@ -5867,8 +5872,7 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
 	struct io_ring_ctx *ctx = req->ctx;
 	int v;
 
-	/* req->task == current here, checking PF_EXITING is safe */
-	if (unlikely(req->task->flags & PF_EXITING))
+	if (io_should_fail_tw(req))
 		return -ECANCELED;
 
 	do {
@@ -7418,7 +7422,7 @@ static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 	int ret = -ENOENT;
 
 	if (prev) {
-		if (!(req->task->flags & PF_EXITING))
+		if (!io_should_fail_tw(req))
 			ret = io_try_cancel_userdata(req, prev->cqe.user_data);
 		io_req_complete_post(req, ret ?: -ETIME, 0);
 		io_put_req(prev);
-- 
2.36.0

