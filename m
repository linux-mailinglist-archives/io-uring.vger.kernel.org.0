Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAE150A10E
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 15:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354829AbiDUNsD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 09:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386686AbiDUNsC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 09:48:02 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C73B1C3
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:12 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l62-20020a1c2541000000b0038e4570af2fso3432236wml.5
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KEvqRy0N9PclazQqew6MevxkU4I4mKDIT57s+2Dre5A=;
        b=kp0V/sM4Ip142L3rdZ3bIWaFuG76xsRy/vQE0St/pkES9Dp3qFdm3virATzuJNcY/R
         dLRqpDtNfR3SH07vqrV9ghuaUoDimDwpS8AhdL1EM9yZZU9+28YV/dC3ekri8CXbEIDu
         NAZnqDpcMwq/Ea14ipoAZNp2Mrls8EI+sL7IbXxLXCdfTDVI9d5r95tlpNEAp+hxJyW8
         at9IKavVGD4x/7sAEEHquV54ZlGwEcUWp42AlZz7684CXndSL94ReOwW+457sezq4AYZ
         267e7C8jedda3LejM53ufXnPY2OwKqMftgye5/u1dwrbvyZKkl07m8tnu6SMuD0BtAU6
         HSew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KEvqRy0N9PclazQqew6MevxkU4I4mKDIT57s+2Dre5A=;
        b=sZlomqtEr3IhOURD+BvXl0in2YUgWtK+uEmrDlISUUMd/Buz4z4LYfVdEEyZwdKWBg
         4KDPn0JA1NmhwWpV5/UyicbMkKdDxsNCsEnr2I6eBRQJXJHI6q1pK5iG0Nn+shU150Hf
         DGILBPkQcUK1cAVNG9+ACAzh75GulxD32PzBX92UBIVmC16NUOoxYHerUh0lFW8hCMak
         sYiJdYcKBbu3Lmm5wd560zyoFSKAsRl8vHhWh49MV4Hf2P7rdW7v2jZOnpUmWWVRYEuT
         B3S3xcoHT++A7w+Mc33FsuMg299q5TA2mqQYbnSfeaF0V5uHTAAgkD1Atj4s2Q92Ebbe
         SCmw==
X-Gm-Message-State: AOAM5334S2W6+M+78yxoXUZuio4E5d6t/tsHKgTg3bXQZ9tczL7YOvMV
        6tSHxWx4Fv12+VXVmFVipBKHl55VhRU=
X-Google-Smtp-Source: ABdhPJx1MyNAemEzqgjjRapYesHeLeZ3QFpePFz/bs4lX4OU/gMJvKSNrSuHpiL05eEFeCIK2MTr9g==
X-Received: by 2002:a05:600c:211:b0:38e:d0f2:8a3f with SMTP id 17-20020a05600c021100b0038ed0f28a3fmr8834148wmi.8.1650548711070;
        Thu, 21 Apr 2022 06:45:11 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.218])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm2837821wri.45.2022.04.21.06.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:45:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 03/11] io_uring: ban tw queue for exiting processes
Date:   Thu, 21 Apr 2022 14:44:16 +0100
Message-Id: <4c8fc40551c5b991fc6560cba2ffe37f47375a1e.1650548192.git.asml.silence@gmail.com>
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

We rely on PF_EXITING and task_work infrastructure for preventing adding
new task_work items to a dying task, which is a bit more convoluted than
desired.

Ban new tw items earlier in io_uring_cancel_generic() by relying on
->in_idle. io_req_task_work_add() will check the flag, set REQ_F_FAIL
and push requests to the fallback path. task_work handlers will find it
and cancel requests just as it was with PF_EXITING.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 272a180ab7ee..ec5fe55ab265 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1306,7 +1306,7 @@ static inline void req_ref_get(struct io_kiocb *req)
 
 static inline bool io_should_fail_tw(struct io_kiocb *req)
 {
-	return unlikely(req->task->flags & PF_EXITING);
+	return unlikely(req->flags & REQ_F_FAIL);
 }
 
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
@@ -2577,10 +2577,6 @@ static void tctx_task_work(struct callback_head *cb)
 	}
 
 	ctx_flush_and_put(ctx, &uring_locked);
-
-	/* relaxed read is enough as only the task itself sets ->in_idle */
-	if (unlikely(atomic_read(&tctx->in_idle)))
-		io_uring_drop_tctx_refs(current);
 }
 
 static void io_req_task_work_add(struct io_kiocb *req, bool priority)
@@ -2600,6 +2596,9 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	list = priority ? &tctx->prior_task_list : &tctx->task_list;
 	wq_list_add_tail(&req->io_task_work.node, list);
+	if (unlikely(atomic_read(&tctx->in_idle)))
+		goto cancel_locked;
+
 	running = tctx->task_running;
 	if (!running)
 		tctx->task_running = true;
@@ -2623,12 +2622,13 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 	}
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
-	tctx->task_running = false;
+cancel_locked:
 	node = wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
 	spin_unlock_irqrestore(&tctx->task_lock, flags);
 
 	while (node) {
 		req = container_of(node, struct io_kiocb, io_task_work.node);
+		req_set_fail(req);
 		node = node->next;
 		if (llist_add(&req->io_task_work.fallback_node,
 			      &req->ctx->fallback_llist))
@@ -10352,7 +10352,10 @@ static __cold void io_uring_cancel_generic(bool cancel_all,
 	if (tctx->io_wq)
 		io_wq_exit_start(tctx->io_wq);
 
+	spin_lock_irq(&tctx->task_lock);
 	atomic_inc(&tctx->in_idle);
+	spin_unlock_irq(&tctx->task_lock);
+
 	do {
 		io_uring_drop_tctx_refs(current);
 		/* read completions before cancelations */
-- 
2.36.0

