Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BB26B5084
	for <lists+io-uring@lfdr.de>; Fri, 10 Mar 2023 20:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjCJTFj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Mar 2023 14:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjCJTFi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Mar 2023 14:05:38 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DA212FD1E;
        Fri, 10 Mar 2023 11:05:37 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so4159318wmq.1;
        Fri, 10 Mar 2023 11:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678475136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LENrqz+1N3GX0KeCDS4dbntNBP6dq4DsXm7GGOPy77w=;
        b=M6sMTq/QsvZMh5dtewF+sgirxavwYBHmBHmzA1zMNhVlmGagWLpbOJ0EqRrZQZaOlW
         /kpTq6eKD75IUg+9IDRCoFAGXg4jXR3eiIh3GNBRP7RkYDYweHXnpd1J0xAKZSCOyRxH
         AWFALIbzqmKuQS70i5R7LDYGqQlGyAgcrOWkPaLgCIYEi5CH/u6N3q4VMcwSbmvucNTG
         xLEs97UHKkgkl8cJTxFScn9glKoTA98R2FFjo8ZIBTgL5uFqOqpl3JpWG8SVqlkOvqum
         ZmoembzKlVNXK8UGxOw4/SdflLLkWuXunAnGKAPHircs/gO3GkF9op5U1zbF3CWFPASc
         dDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678475136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LENrqz+1N3GX0KeCDS4dbntNBP6dq4DsXm7GGOPy77w=;
        b=xadrgGmUJndkf/0SoWVYJQDpVogrX5qthIUh+SPiwpWmlxETdxA7UXgffqPYfICvou
         eXYSX3rDl4Kpmc667FYvtZTCOdY+7O1wlmpZ2TZjhpFoexp3Gs3SgPRCO5n5gOP+BT6Q
         B6NeJqNI+CpFw60YyE+0YRoER/onsXvp2Pf21dsveOEUH3e7fCvOCHcNt2GgJwI6ED01
         mVizEJk8Z8wJ2AEwQDk4x6Mte0o43fs0DFgMubtc7rAfxjlvnfg/LrNglFToPtmcqMQa
         q9vq4SFjq3neeFTNL4IuuOqt4U985y54RJwMwZGMyFNVUUxizLbHB58QANMNnoqsE/0q
         YRxw==
X-Gm-Message-State: AO0yUKUFwlpwmy2vPsswM18kDzLDZsiJcpHwffIdrqFP1DX2XBjUIsgh
        KqSjGU1pCcKCRb4v8negJmWnIZ/oP+Y=
X-Google-Smtp-Source: AK7set8fShzvm6BLhxSTfyUzhDCYJyC8aE6+fOBvX8EP/ADRsR+bHj9HMyFmEuzFw3Y1CAh33KZdLw==
X-Received: by 2002:a05:600c:458f:b0:3eb:38e6:f650 with SMTP id r15-20020a05600c458f00b003eb38e6f650mr3657837wmo.41.1678475135806;
        Fri, 10 Mar 2023 11:05:35 -0800 (PST)
Received: from 127.0.0.1localhost (188.30.129.33.threembb.co.uk. [188.30.129.33])
        by smtp.gmail.com with ESMTPSA id z19-20020a1c4c13000000b003e20cf0408esm647882wmf.40.2023.03.10.11.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 11:05:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [RFC 1/2] io_uring: add tw add flags
Date:   Fri, 10 Mar 2023 19:04:15 +0000
Message-Id: <57980319636088be6f984faacb8f255af65ce888.1678474375.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1678474375.git.asml.silence@gmail.com>
References: <cover.1678474375.git.asml.silence@gmail.com>
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

We pass 'allow_local' into io_req_task_work_add() but will need more
flags. Replace it with a flags bit field and name this allow_local
flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 7 ++++---
 io_uring/io_uring.h | 9 +++++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7625597b5227..42ada470845f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1308,12 +1308,13 @@ static void io_req_local_work_add(struct io_kiocb *req)
 	percpu_ref_put(&ctx->refs);
 }
 
-void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
+void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_uring_task *tctx = req->task->io_uring;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (allow_local && ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+	if (!(flags & IOU_F_TWQ_FORCE_NORMAL) &&
+	    (ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
 		io_req_local_work_add(req);
 		return;
 	}
@@ -1341,7 +1342,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 						    io_task_work.node);
 
 		node = node->next;
-		__io_req_task_work_add(req, false);
+		__io_req_task_work_add(req, IOU_F_TWQ_FORCE_NORMAL);
 	}
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2711865f1e19..cd2e702f206c 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -15,6 +15,11 @@
 #include <trace/events/io_uring.h>
 #endif
 
+enum {
+	/* don't use deferred task_work */
+	IOU_F_TWQ_FORCE_NORMAL			= 1,
+};
+
 enum {
 	IOU_OK			= 0,
 	IOU_ISSUE_SKIP_COMPLETE	= -EIOCBQUEUED,
@@ -48,7 +53,7 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
 	return req->flags & REQ_F_FIXED_FILE;
 }
 
-void __io_req_task_work_add(struct io_kiocb *req, bool allow_local);
+void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
 bool io_is_uring_fops(struct file *file);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
@@ -93,7 +98,7 @@ bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 
 static inline void io_req_task_work_add(struct io_kiocb *req)
 {
-	__io_req_task_work_add(req, true);
+	__io_req_task_work_add(req, 0);
 }
 
 #define io_for_each_link(pos, head) \
-- 
2.39.1

