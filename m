Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073E9662904
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 15:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbjAIOvc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 09:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjAIOvM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 09:51:12 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCA03AB20
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 06:47:36 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id gh17so20716292ejb.6
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 06:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wr/mGWhWn9t52OwGgCmZLcp0xRNtvHfRRAMQOwaF/Jc=;
        b=KbpTwash6f6utPt49IN1XXS2mqVY2NR3N2vXGlV/2dkW3n8JaBhT2i8O9gMG8EuyEN
         +QDcIAJ49Oo7mzhG8Q58rAoaEnTSqpF0BSHJsUvynzMctJUiB9lmWRRiHJOAPgIUzCHo
         S6EMhqYkmfRsXFc8qZy4LwUkGbhWJ1JK8fFL9h/MMYqKZoN3Q8SEIhyqRhmYHFB1DQ08
         dXxwKRPZ53gwBi9hq7cma06y+eekOeI8F4FxJM3lcYfDyFiZ1B6tv6GjazjrGUW5naTV
         ysl4koCLIMxXmVmjjlSlb4mclrfQ+qZnwwyoR+S1j+/y0D4gy8Iyxtn4YfNGwnLwCsXV
         uh8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wr/mGWhWn9t52OwGgCmZLcp0xRNtvHfRRAMQOwaF/Jc=;
        b=ik5CYRqUb/7nMZlrDzQh78E/I+bwv4V9CxWSbvkxt2nfZvbv8pR8vFdpxfouCMGJzC
         5Oqvu43fs/vfiT58pVgoq3l0TCMkIAsTEhRpDEAC4WF8qQmnLbKWqqWR0VReokuos8eF
         sEvwLijvtrKubHykwt32gpEBo1XZ6lqc4VWIm7fcL6y4FRzD8TO2p8tZxz1PHcWrMBPZ
         oHuYs3f0xYuEePCzN2/ePsLPZYBAeUmCaCCCNQwVfhrvm3Ohkr8Y7De8duSmtY2WNY/k
         wcf48TtB+PMZcwrBdz15vkWyvPeqlWtgJYh1qnxWRjUAu2SYbpLO5BDBYin/er/C2z/o
         4BIg==
X-Gm-Message-State: AFqh2kpX0g6RmC2vHL2PSuYwqHxkC6Pss+tIqMMmS3mj5UhrlFMLDRTP
        khc+Kb8Nhp19+wEty8iXFinLRYkxLAo=
X-Google-Smtp-Source: AMrXdXtK/PZZSNK6YMBOvPi/G2ZD+BYjYfNLHoyALHrw4ewgwuLYDx4Uh82hNaSXpE9mdz1dU8S4MQ==
X-Received: by 2002:a17:907:a407:b0:84c:7974:8a73 with SMTP id sg7-20020a170907a40700b0084c79748a73mr46696891ejc.57.1673275655641;
        Mon, 09 Jan 2023 06:47:35 -0800 (PST)
Received: from 127.0.0.1localhost (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906b08b00b0084c62b7b7d8sm3839578ejy.187.2023.01.09.06.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 06:47:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3 06/11] io_uring: separate wq for ring polling
Date:   Mon,  9 Jan 2023 14:46:08 +0000
Message-Id: <dea0be0bf990503443c5c6c337fc66824af7d590.1673274244.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673274244.git.asml.silence@gmail.com>
References: <cover.1673274244.git.asml.silence@gmail.com>
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

Don't use ->cq_wait for ring polling but add a separate wait queue for
it. We need it for following patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 2 +-
 io_uring/io_uring.c            | 3 ++-
 io_uring/io_uring.h            | 9 +++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 8dfb6c4a35d9..0d94ee191c15 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -319,7 +319,7 @@ struct io_ring_ctx {
 	} ____cacheline_aligned_in_smp;
 
 	/* Keep this last, we don't need it for the fast path */
-
+	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
 
 	/* slow path rsrc auxilary data, used by update/register */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c251acf0964e..8d19b0812f30 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -316,6 +316,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->cq_wait);
+	init_waitqueue_head(&ctx->poll_wq);
 	spin_lock_init(&ctx->completion_lock);
 	spin_lock_init(&ctx->timeout_lock);
 	INIT_WQ_LIST(&ctx->iopoll_list);
@@ -2788,7 +2789,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	struct io_ring_ctx *ctx = file->private_data;
 	__poll_t mask = 0;
 
-	poll_wait(file, &ctx->cq_wait, wait);
+	poll_wait(file, &ctx->poll_wq, wait);
 	/*
 	 * synchronizes with barrier from wq_has_sleeper call in
 	 * io_commit_cqring
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index b5975e353aa1..c75bbb94703c 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -220,9 +220,18 @@ static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
 }
 
+static inline void io_poll_wq_wake(struct io_ring_ctx *ctx)
+{
+	if (waitqueue_active(&ctx->poll_wq))
+		__wake_up(&ctx->poll_wq, TASK_NORMAL, 0,
+				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
+}
+
 /* requires smb_mb() prior, see wq_has_sleeper() */
 static inline void __io_cqring_wake(struct io_ring_ctx *ctx)
 {
+	io_poll_wq_wake(ctx);
+
 	/*
 	 * Trigger waitqueue handler on all waiters on our waitqueue. This
 	 * won't necessarily wake up all the tasks, io_should_wake() will make
-- 
2.38.1

