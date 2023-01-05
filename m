Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7692165E9C1
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 12:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbjAELXx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 06:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbjAELXh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 06:23:37 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BB45004E
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 03:23:36 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id k26-20020a05600c1c9a00b003d972646a7dso1050508wms.5
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 03:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4lSEuWpHhhixo5EO/vGuzJZ2U1VkfB0a31lSuCDsCbw=;
        b=VPSsyOnd08u1HQAOyNWdYBB/8cBqmvLad2sn/+kZrDtPMdRxXwjScO+X3nnN1TgQiq
         TYsQwQKkXg0hV9pENKYa3f2F1EetdKH4TxmaDgdcQzZ+8b+ht9p+WM6dl2D/9gPTvYCo
         ATlZ2uYnkUmcNCwRvMr1HMpnO5aoi5G0v8O87V16Gg1PPO1UVMcQDEgBbvXiA5U34uHY
         fQEIAIdw1Puo72W2QCBO/jYCgkYFOfAdVBy7ztqPCiNSqY5HIyB4QjeOeETcGDZl9O8s
         54f665kjzYmLdM88MvSqbkiA12fCHCMM2BPn3JLbAtXLmFPVktatOZLWfNVdhSowCDLU
         iXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4lSEuWpHhhixo5EO/vGuzJZ2U1VkfB0a31lSuCDsCbw=;
        b=ihsI1xB/IlNO5wKh4ACteuv4upHdE/PngPez2ijFjIuib7s7hsTnigAtw6ZE/Izr2y
         ywQB1+mrMkgR6IwsXlLGqMpxvvDHBugVv09vvsM0euEbLE3cY2F1EY0RetM2Sh7mbw5Z
         DJ9qxr7Q6k2E8s8dSn0pyPcL8BgDzCJ0ef5kCGoK2djnko/Xwk8hPGOk1sG1lZAjT/qT
         W+2Y0v03Cup3VFblB4o0BV2YYLuBzWINLoAEuienG4pJ2xQzdhDqkLBeMlLuzgs7qH+S
         pWhwqFD+j4KYHLeG1vjdMsE7A3U11SlQMGOFKfQvs5HlBoUEl80jEeEqrWwt7C14+5+Y
         YOSw==
X-Gm-Message-State: AFqh2koQgp0K7HIwdaOuoVwswS3yAi9/GgjHW6nMOaXQ0yYdmne6T7Sx
        bTGSBw74OaJMl6+Qwyi1WKrTE1Dklqg=
X-Google-Smtp-Source: AMrXdXv/yrKJi4WuNWgt7vpJ6G+yq+HXkShYU552Mgx8qUsSkbz11DYX/L+Ap2ILA/7Y01ZCtTur5Q==
X-Received: by 2002:a05:600c:4fc6:b0:3d3:4a47:52e9 with SMTP id o6-20020a05600c4fc600b003d34a4752e9mr35605624wmq.15.1672917814849;
        Thu, 05 Jan 2023 03:23:34 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:5c5f])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b003c6f1732f65sm2220688wmq.38.2023.01.05.03.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:23:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCHSET REBASE 10/10] io_uring: keep timeout in io_wait_queue
Date:   Thu,  5 Jan 2023 11:22:29 +0000
Message-Id: <e4b48a9e26a3b1cf97c80121e62d4b5ab873d28d.1672916894.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672916894.git.asml.silence@gmail.com>
References: <cover.1672916894.git.asml.silence@gmail.com>
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

Move waiting timeout into io_wait_queue

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 420b022f6c31..a44b3b5813df 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2411,6 +2411,7 @@ struct io_wait_queue {
 	struct io_ring_ctx *ctx;
 	unsigned cq_tail;
 	unsigned nr_timeouts;
+	ktime_t timeout;
 };
 
 static inline bool io_has_work(struct io_ring_ctx *ctx)
@@ -2463,8 +2464,7 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
 
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-					  struct io_wait_queue *iowq,
-					  ktime_t *timeout)
+					  struct io_wait_queue *iowq)
 {
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
@@ -2476,9 +2476,9 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 		return -EINTR;
 	if (unlikely(io_should_wake(iowq)))
 		return 0;
-	if (*timeout == KTIME_MAX)
+	if (iowq->timeout == KTIME_MAX)
 		schedule();
-	else if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
+	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
 	return 0;
 }
@@ -2493,7 +2493,6 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 {
 	struct io_wait_queue iowq;
 	struct io_rings *rings = ctx->rings;
-	ktime_t timeout = KTIME_MAX;
 	int ret;
 
 	if (!io_allowed_run_tw(ctx))
@@ -2519,20 +2518,21 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			return ret;
 	}
 
-	if (uts) {
-		struct timespec64 ts;
-
-		if (get_timespec64(&ts, uts))
-			return -EFAULT;
-		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
-	}
-
 	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
 	iowq.wq.private = current;
 	INIT_LIST_HEAD(&iowq.wq.entry);
 	iowq.ctx = ctx;
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
+	iowq.timeout = KTIME_MAX;
+
+	if (uts) {
+		struct timespec64 ts;
+
+		if (get_timespec64(&ts, uts))
+			return -EFAULT;
+		iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
+	}
 
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
@@ -2540,7 +2540,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
+		ret = io_cqring_wait_schedule(ctx, &iowq);
 		if (ret < 0)
 			break;
 		__set_current_state(TASK_RUNNING);
-- 
2.38.1

