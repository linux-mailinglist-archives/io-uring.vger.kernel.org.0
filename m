Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7074D4BDE87
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 18:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358360AbiBUMyN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 07:54:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbiBUMyN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 07:54:13 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C961C111
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 04:53:49 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id h125so14205566pgc.3
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 04:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=RzUS5WlhHfT8fkOsV/pbwmDFq9dglyHhvcheyXz8t00=;
        b=qSGeNGUiXONrl5IGuT/42ugTDkl/q0FnTfxV0n4iobnUPHHkkRwp4A7CLRzw5acZdn
         rgBntMkqsT4deuC//Pt5EefPa6p6VfTbb6YJUpIn9d72nvic/cW7w/rUopoutIhxyaq5
         FbXJC8kIcmKEd6jyPup7+WWYezkOvEuBy80L1b5gGXHdwzxRlyH8PXyll7GkiIwN63jD
         IEZmVXY2U2OoojjNLkH8Q4uOsMt/u+2f9LDAXey7RchgRNYTTRRgrDV5zCURcGPLU9ws
         8mbX8XCIVi/TEmgmtIgrx83nVkRR83+r/a3nNMfC/9MoyJZb0XHR3kfZLR1QgzU0fqyd
         DX7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=RzUS5WlhHfT8fkOsV/pbwmDFq9dglyHhvcheyXz8t00=;
        b=UgHYCB4XbTHzDVUYLCQPCaLlQZhhqiVRWeiA47oFuaTLKhGpdDV1VPHy2LeEOyTyrb
         pP7tRSoq6qvX1vV8jU1unGB9Bfh6O2Ltn8bWSHq1uSkJ32XD9a8UjMu19IAkTkqeP1C4
         Ap5/xEREzAouN2bpXtNP+sRKsW0ELi6hupeLrZWupPX7Pq56IKp5aQApnDTA8xiEE2D8
         WjKkpf3EBvwcMjPkG6r4FDkT2gm+QjIC5XjQdUcbT587oyIdLBlZbEYlpWfpAve59Bbi
         adQXjzoXMFyC7tiiHK9dEGowSe38qsteiJ6rmxcowqP1f/FvDYcj0emGiOpztDUrxSmB
         Gttg==
X-Gm-Message-State: AOAM532KxJSBsKlZgkLSvzxbM0QxP2mlwDvO9A4KUUpsWpJImHTNDIDv
        0eEtDa6d7OzK6JQB1NvpLlb4mbMRkscjhw==
X-Google-Smtp-Source: ABdhPJzBteU5lEszrjbHNqNkXMdvJ0o2TS6VAg+18YFEl2ohGfZetj85+vcqCnowsa8M+Czk1g7u4w==
X-Received: by 2002:a63:1405:0:b0:344:3b39:fd27 with SMTP id u5-20020a631405000000b003443b39fd27mr16111971pgl.488.1645448028649;
        Mon, 21 Feb 2022 04:53:48 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k21sm7943494pff.25.2022.02.21.04.53.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 04:53:47 -0800 (PST)
Message-ID: <efa5a678-778a-baca-b81e-6bf41513b5d1@kernel.dk>
Date:   Mon, 21 Feb 2022 05:53:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't convert to jiffies for waiting on timeouts
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If an application calls io_uring_enter(2) with a timespec passed in,
convert that timespec to ktime_t rather than jiffies. The latter does
not provide the granularity the application may expect, and may in
fact provided different granularity on different systems, depending
on what the HZ value is configured at.

Turn the timespec into an absolute ktime_t, and use that with
schedule_hrtimeout() instead.

Link: https://github.com/axboe/liburing/issues/531
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 77b9c7e4793b..e666ca972871 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7693,7 +7693,7 @@ static int io_run_task_work_sig(void)
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
-					  signed long *timeout)
+					  ktime_t timeout)
 {
 	int ret;
 
@@ -7705,8 +7705,9 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	if (test_bit(0, &ctx->check_cq_overflow))
 		return 1;
 
-	*timeout = schedule_timeout(*timeout);
-	return !*timeout ? -ETIME : 1;
+	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
+		return -ETIME;
+	return 1;
 }
 
 /*
@@ -7719,7 +7720,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 {
 	struct io_wait_queue iowq;
 	struct io_rings *rings = ctx->rings;
-	signed long timeout = MAX_SCHEDULE_TIMEOUT;
+	ktime_t timeout = KTIME_MAX;
 	int ret;
 
 	do {
@@ -7735,7 +7736,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 		if (get_timespec64(&ts, uts))
 			return -EFAULT;
-		timeout = timespec64_to_jiffies(&ts);
+		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
 	}
 
 	if (sig) {
@@ -7767,7 +7768,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		}
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
+		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
 		finish_wait(&ctx->cq_wait, &iowq.wq);
 		cond_resched();
 	} while (ret > 0);

-- 
Jens Axboe

