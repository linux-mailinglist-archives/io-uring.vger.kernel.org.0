Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A1154B0F6
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbiFNMd7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243863AbiFNMdm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:42 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E47A4B1FE
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:45 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id e5so4586644wma.0
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=79kYGB1MuhBVdSp/oRQj0eo+ojhHpblZthnUV8e/Yck=;
        b=Ug/njMd0L0l6sDO0E3omxepK8SKj0RH0+yxjCQd4mL9Z0uTBTMdcKy8hjOw8+ttZ5R
         7sIdO0xMS4LeqZLd2SwuC+BKBmKsWVKnD9yubN0U+ViBMjwOI6pEfQHTv/FsGAUDjlkA
         bgAKuFBENiTAV53CbpR7VTGv26a1J3ePfG6zRomRo40J3LEkp1yTyTi1Zgl/UhofMp/I
         9sX/AC1Xc3L0jCqx6C7e8jqDUhOBTOWBaH31mHFTQchHYXSDvhESjYm55wYUjw8VVlxO
         SVHfb+ty4X5JvtjJAsFx/aOZCh1owLH2eG49+2DhXMR0qQQrHyflDNl6AFPpwtPHgwzN
         C1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=79kYGB1MuhBVdSp/oRQj0eo+ojhHpblZthnUV8e/Yck=;
        b=b+HZpyLU8j7QlUhd9fWof15nggKi7MoLZ/Nba/LiQ3s7w/N790ycy3bkyObj/AqZDN
         QoV8sHqsBzeVPN3+6Bk/UXv5c0bujJT+hihdTeiLKaPxiu6Wnl4v5YnHJkgcYJhLqXyL
         gZkPggJil36/5f1ETfAiif81eGtq+KoXWy2YEBV22VNQGw6wYpfPgfO7Jh+SQD4tzaes
         TFCu7YUsFFk8ZXvcmagO2Ion0lQ1FvfYR6I5sBea3tjK3Ogcxl7deDozFHqIVqUdoU6j
         HRil5C+Age/Iui8tWao3azKfLKm3I52UdDR85ZDpog6MQwp0lc8S2Cx3PwRt83pqs8Js
         C/0g==
X-Gm-Message-State: AOAM533g24SfcGniGNZpPbYTtf6+/qTblcA8HjugZ2CXcej8iJod9jkX
        NpxUnsuPeSwGXfQsLnFypapVhNFhVh3QWQ==
X-Google-Smtp-Source: ABdhPJx/Tkrj6dvGiLtf3j2O9F4wwbbQsS8hHFnQBJPENhf+KZjTiFFle02+bKR8K4p/5m2xdhewtw==
X-Received: by 2002:a05:600c:8a6:b0:39c:5682:32d with SMTP id l38-20020a05600c08a600b0039c5682032dmr3884388wmp.126.1655209843581;
        Tue, 14 Jun 2022 05:30:43 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 07/25] io_uring: inline ->registered_rings
Date:   Tue, 14 Jun 2022 13:29:45 +0100
Message-Id: <3b98818d59d19262712dea1893c87dc186a584e8.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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
index 2f5fd1749c4a..2efe6bd16e07 100644
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

