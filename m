Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C812765CB7F
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 02:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238660AbjADBgF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Jan 2023 20:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238686AbjADBfl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Jan 2023 20:35:41 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49C31401C
        for <io-uring@vger.kernel.org>; Tue,  3 Jan 2023 17:35:39 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so25444571wms.2
        for <io-uring@vger.kernel.org>; Tue, 03 Jan 2023 17:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QGFIbjicKIK/Qdxv35gVFgmC/OqGka09/eak/LPpjaQ=;
        b=BJes8Dy2GruxFCVWmToGCuoUh4qQNthhd3OPW/BccFjCB2vPbDKky5mTNlA9aUAX6u
         /AnXcqCwP0qePRL0W52DzUJ05836uoIL3Pdm5Ludqu0cs57nWsSTGzOven1CFZhQMQxO
         7eM4TafJYdL+RxtvxuZYg5eg5gzF0uIqWAzFUQBDp7b1t2qAHpVnMbdFY2NDe9g6jwLf
         LE6fugjnXOpuhkG5WKsUWwrFJyaIlWfLCXEhApZU9u+IGnIWpbCbJhQILbOczCxvt59n
         X660Z8cawm95pZ2oDYEoXmiIukpknLPeJR0YWP8u8AssqIyhaRflLAk0ARrPPAymKA3F
         VJqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QGFIbjicKIK/Qdxv35gVFgmC/OqGka09/eak/LPpjaQ=;
        b=RmEka8JDlfpYEaq8VH8dgSwI6BJrqCh+5m9FIsbIfXt+0ZLWfFJmw+oxI8V/Or196M
         KUqctBY3HMFaxil6CNSxdu8Zav7O06irP4yz2y3P5NDhoqNN9l4JE2oOSjLUZH5MlroX
         0Cshwbo8ItTRskpV3j8uwIt5wl/ZXkceYq90TUDPlOs/f9WJiWVjZZ13MJ4anx9SsJ3Z
         xHz0fpwg+/plCd+K/CnbQnVKlSFCdlr71dWXzMlH6cAvUIOLvRwzNPuF1OhHD5Bc9d+x
         q8U9WGDLFDvt+Yxnip1W/NA1/do28XnUzUrjOvQUI/v9Uv+kRwS7HIRU5TKe9drn6CH1
         DBiA==
X-Gm-Message-State: AFqh2ko/rhumBCUbMfRvifPYS5hWFQH1KnUEPunNT2NRFHWe85pqWZt/
        8OXkisQGxYukhpxKy8X07Otv6HAr2U4=
X-Google-Smtp-Source: AMrXdXuE/ouHBG+LEgEBKP7KoxTnAUszaA0luuDuIbXniDgYQpEmUQNXBJLd9QLzcE0A2lHgN6uZSg==
X-Received: by 2002:a05:600c:510e:b0:3d3:5885:4d21 with SMTP id o14-20020a05600c510e00b003d358854d21mr31766300wms.17.1672796137957;
        Tue, 03 Jan 2023 17:35:37 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id n1-20020a05600c4f8100b003d96b8e9bcasm47667575wmq.32.2023.01.03.17.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 17:35:37 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 1/1] io_uring: pin context while queueing deferred tw
Date:   Wed,  4 Jan 2023 01:34:02 +0000
Message-Id: <1a79362b9c10b8523ef70b061d96523650a23344.1672795998.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
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

Unlike normal tw, nothing prevents deferred tw to be executed right
after an tw item added to ->work_llist in io_req_local_work_add(). For
instance, the waiting task may get waken up by CQ posting or a normal
tw. Thus we need to pin the ring for the rest of io_req_local_work_add()

Cc: stable@vger.kernel.org
Fixes: c0e0d6ba25f18 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 58ac13b69dc8..6bed44855679 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1236,13 +1236,18 @@ static void io_req_local_work_add(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!llist_add(&req->io_task_work.node, &ctx->work_llist))
+	percpu_ref_get(&ctx->refs);
+
+	if (!llist_add(&req->io_task_work.node, &ctx->work_llist)) {
+		percpu_ref_put(&ctx->refs);
 		return;
+	}
 	/* need it for the following io_cqring_wake() */
 	smp_mb__after_atomic();
 
 	if (unlikely(atomic_read(&req->task->io_uring->in_idle))) {
 		io_move_task_work_from_local(ctx);
+		percpu_ref_put(&ctx->refs);
 		return;
 	}
 
@@ -1252,6 +1257,7 @@ static void io_req_local_work_add(struct io_kiocb *req)
 	if (ctx->has_evfd)
 		io_eventfd_signal(ctx);
 	__io_cqring_wake(ctx);
+	percpu_ref_put(&ctx->refs);
 }
 
 void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
-- 
2.38.1

