Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA41D677E43
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 15:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjAWOmP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 09:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbjAWOmP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 09:42:15 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CA322013
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:14 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id y1so6525644wru.2
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s6KX31iMQuQKOGs2Moo3zwZbCMvMmm5Kx+GJKn6/Oyk=;
        b=bCNuDNKWB2AxAdBBqwIboGbVhHFL8Zv/zh89b9ceGP6n4dTpmHX31eQ1WoQpv+NlSg
         gNpx7XdxdFFwpgv7FqZGpdCSvBMGvM+4uk3ne4aEs/W1qpVjN+FteMtm8CNKRh6c6eRv
         wrn8GM85wbUWKCe8/KeWeU4J0aQ0TXStwTtP8kjZ6H9DU01edJdKpr/glJZx6cPtaYNM
         7G3NpVzeUglNp51NbpTbE8HkadZRwhi2/vFSsVGqPWtteYiY6vSf5YKLXiWTNnbdg7kd
         UZKmFLQ3rWpyoCbs7Aax8ScJkHg5EqJEZOiUVFz0FCTd+cD5ABi0GqlKVXbBZLXwkMH1
         DYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s6KX31iMQuQKOGs2Moo3zwZbCMvMmm5Kx+GJKn6/Oyk=;
        b=od/wov9Yv4y1iYxLB8WGYOWVrUeVKqZI0skSWpt1QowgfivqOiKjfb8D931Z/kS+CJ
         nqjSjxUekQvKidvhwVAeXJOmW45TzQXhkm9BZL6PR1rxKWTOc405Pfd3jYRuoXyQyEhe
         gYg12zqYY6TZ8aLOCdX2vwH4Fxrwo5Vbq6qpTu2HBkKCF4EaZKEQfO8HWxZIePGm7iXQ
         YOXCD8vQl0/ypBF7gzpWIrJOLgA1VR5wY3YpufHucIWMIRxAYVYmHcHiQYN5bNBspN2Z
         +R0DlBIkTtSd2QA+kSVGv59gh+CHR46eSI0E2vOG3aqVXmbrKajNqCFuvz/eAqz7TPTv
         LwrA==
X-Gm-Message-State: AFqh2koPTQmLRvSV58voqmy0dHvClgikmQbc42nbyc55k6F7c33hVJ9v
        Cxn71nu046RpxdildxulHWFpbKXI6Os=
X-Google-Smtp-Source: AMrXdXvoiCdlwlugFbv6NzlT/gXD4L3KrPW8XyyAg0OAA4poQhofOAyG3PISd4sK+ztORqE0tLGVzg==
X-Received: by 2002:a5d:660a:0:b0:2be:5162:c8da with SMTP id n10-20020a5d660a000000b002be5162c8damr13248432wru.16.1674484932548;
        Mon, 23 Jan 2023 06:42:12 -0800 (PST)
Received: from 127.0.0.1localhost (188.30.84.186.threembb.co.uk. [188.30.84.186])
        by smtp.gmail.com with ESMTPSA id d24-20020adfa358000000b00236883f2f5csm3250534wrb.94.2023.01.23.06.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 06:42:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 5/7] io_uring: refactor io_put_task helpers
Date:   Mon, 23 Jan 2023 14:37:17 +0000
Message-Id: <3bf92ebd594769d8a5d648472a8e335f2031d542.1674484266.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1674484266.git.asml.silence@gmail.com>
References: <cover.1674484266.git.asml.silence@gmail.com>
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

Add a helper for putting refs from the target task context, rename
__io_put_task() and add a couple of comments around. Use the remote
version for __io_req_complete_post(), the local is only needed for
__io_submit_flush_completions().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8a99791a507a..faada7e76f2d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -713,7 +713,8 @@ static void io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 		io_cqring_do_overflow_flush(ctx);
 }
 
-static void __io_put_task(struct task_struct *task, int nr)
+/* can be called by any task */
+static void io_put_task_remote(struct task_struct *task, int nr)
 {
 	struct io_uring_task *tctx = task->io_uring;
 
@@ -723,13 +724,19 @@ static void __io_put_task(struct task_struct *task, int nr)
 	put_task_struct_many(task, nr);
 }
 
+/* used by a task to put its own references */
+static void io_put_task_local(struct task_struct *task, int nr)
+{
+	task->io_uring->cached_refs += nr;
+}
+
 /* must to be called somewhat shortly after putting a request */
 static inline void io_put_task(struct task_struct *task, int nr)
 {
 	if (likely(task == current))
-		task->io_uring->cached_refs += nr;
+		io_put_task_local(task, nr);
 	else
-		__io_put_task(task, nr);
+		io_put_task_remote(task, nr);
 }
 
 void io_task_refs_refill(struct io_uring_task *tctx)
@@ -982,7 +989,7 @@ static void __io_req_complete_post(struct io_kiocb *req)
 		 * we don't hold ->completion_lock. Clean them here to avoid
 		 * deadlocks.
 		 */
-		io_put_task(req->task, 1);
+		io_put_task_remote(req->task, 1);
 		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
 	}
@@ -1105,7 +1112,7 @@ __cold void io_free_req(struct io_kiocb *req)
 
 	io_req_put_rsrc(req);
 	io_dismantle_req(req);
-	io_put_task(req->task, 1);
+	io_put_task_remote(req->task, 1);
 
 	spin_lock(&ctx->completion_lock);
 	wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
-- 
2.38.1

