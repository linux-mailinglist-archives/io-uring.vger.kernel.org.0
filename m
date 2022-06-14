Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E79554B387
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240190AbiFNOhz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240402AbiFNOht (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:49 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9013D17A9D
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:48 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id i17-20020a7bc951000000b0039c4760ec3fso1007085wml.0
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B+58UuY4vbQY6D/bejFyUsL7Botzww29ZJtrjUE28+I=;
        b=nnDvlSrdFxnGTAdj11qoOPEEmztWZNbrS4SxAZtdFdSH2Tg40EJv+gR5zOT81YPANl
         FL2qtCeAK47tELNVYkYOEFPajLGxR7p4n3s+s5krzrINS8zW/HLqf4ZxApbAxJQnPJs1
         T8CVPRZz/aNrJhdPVhjisDLRl/gmxnOJsIFh6jMjUkhTdXo+z7LfABYzoKfDAM8bk2Ge
         SywqfRFg7RhFY3OK+4esAvK/xqya6HqDn5ed8qKGLe95ZqQu2dhAnRlR5qyjmQ9oS2xb
         aT7lrq78cGCUVVc5wW7Mn973PlIhKzL9UZ4/l0rlcJ4gIR1zvaQ54y4AXJqzk7w0GUYW
         4XjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B+58UuY4vbQY6D/bejFyUsL7Botzww29ZJtrjUE28+I=;
        b=oJ40lw1s1wrZjmxFhtgZw1nY3ZGDw4VL3JayI8m7a5U/nyJOEXpMCjRsAR4PqEPwyW
         DsqZwXJwheCFEFVf8RQneVw7kERwAMHwcxH6kpZKykstErz0PPZ/DtUzYJu5JWXpQKsS
         wVkSuitspwOxO6GpZ1oBAgHnZbKput/XMyh4yFaXm98VZv50Hm6BDiiTqCJtwz1YIqq0
         lNMAoYI451KSQgqcFmczvBOEApXz+OhKHuNxPSNFPlcf5w/1EvOOV8Xka2JeQWuSUdY1
         RYIIyZXFJDFggcrjUR0DO3kt4llza6E1vBtnSo1/vpLB/ukRld+yy8lacQWUg7YibKyf
         H45A==
X-Gm-Message-State: AOAM531xS69ae9k/dDM3ORHkNqYD/SJPjCaP/hBE8pNv64ASV0F7aeO8
        U3iA3W9xutvUEpaTU+wchN+FRuS9Gx2rFg==
X-Google-Smtp-Source: ABdhPJyaOXK98bwRk+u3fXR4be2Ze9eqqef9M1tPBg2D3FKgfbFulbAEFlX2DuAuSARnhYKUlmnCBw==
X-Received: by 2002:a05:600c:3b02:b0:397:5cfb:b849 with SMTP id m2-20020a05600c3b0200b003975cfbb849mr4442520wms.183.1655217466917;
        Tue, 14 Jun 2022 07:37:46 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 07/25] io_uring: inline ->registered_rings
Date:   Tue, 14 Jun 2022 15:36:57 +0100
Message-Id: <6f9e5a5c3bddf92c848664230c9a0ecaf846950e.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There can be only 16 registered rings, no need to allocate an array for
them separately but store it in tctx.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 1 -
 io_uring/tctx.c     | 9 ---------
 io_uring/tctx.h     | 3 ++-
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3fdb368820c9..dbf0dbc87758 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2840,7 +2840,6 @@ void __io_uring_free(struct task_struct *tsk)
 	WARN_ON_ONCE(tctx->io_wq);
 	WARN_ON_ONCE(tctx->cached_refs);
 
-	kfree(tctx->registered_rings);
 	percpu_counter_destroy(&tctx->inflight);
 	kfree(tctx);
 	tsk->io_uring = NULL;
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index f3262eef55d4..6adf659687f8 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -55,16 +55,8 @@ __cold int io_uring_alloc_task_context(struct task_struct *task,
 	if (unlikely(!tctx))
 		return -ENOMEM;
 
-	tctx->registered_rings = kcalloc(IO_RINGFD_REG_MAX,
-					 sizeof(struct file *), GFP_KERNEL);
-	if (unlikely(!tctx->registered_rings)) {
-		kfree(tctx);
-		return -ENOMEM;
-	}
-
 	ret = percpu_counter_init(&tctx->inflight, 0, GFP_KERNEL);
 	if (unlikely(ret)) {
-		kfree(tctx->registered_rings);
 		kfree(tctx);
 		return ret;
 	}
@@ -73,7 +65,6 @@ __cold int io_uring_alloc_task_context(struct task_struct *task,
 	if (IS_ERR(tctx->io_wq)) {
 		ret = PTR_ERR(tctx->io_wq);
 		percpu_counter_destroy(&tctx->inflight);
-		kfree(tctx->registered_rings);
 		kfree(tctx);
 		return ret;
 	}
diff --git a/io_uring/tctx.h b/io_uring/tctx.h
index f4964e40d07e..7684713e950f 100644
--- a/io_uring/tctx.h
+++ b/io_uring/tctx.h
@@ -20,8 +20,9 @@ struct io_uring_task {
 	struct io_wq_work_list	task_list;
 	struct io_wq_work_list	prio_task_list;
 	struct callback_head	task_work;
-	struct file		**registered_rings;
 	bool			task_running;
+
+	struct file		*registered_rings[IO_RINGFD_REG_MAX];
 };
 
 struct io_tctx_node {
-- 
2.36.1

