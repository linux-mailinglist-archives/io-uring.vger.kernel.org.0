Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59976EFF13
	for <lists+io-uring@lfdr.de>; Thu, 27 Apr 2023 03:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242675AbjD0B7q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Apr 2023 21:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbjD0B7o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Apr 2023 21:59:44 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BD03AA3
        for <io-uring@vger.kernel.org>; Wed, 26 Apr 2023 18:59:42 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-24b39cb710dso1039146a91.0
        for <io-uring@vger.kernel.org>; Wed, 26 Apr 2023 18:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682560782; x=1685152782;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CWQuzQLSS5emVnenlShyZIaIdBKkRXi7v9McaRIrhdw=;
        b=5IRssbeSYF/aDuI0SVKlBEU8Y6Spi9UvFx7hPSzUhfqGXpQdAGmyqUAiR/1t0ZHJyo
         A+zjMTabH2ApUr0wmfwsYNX5geZOVsPP1Q04wifOkRTPA3bOO7C2ByffkD1dONxoKBsm
         JoPbk3xtowsui9Y0EV/ihwHC5QF07+uyXmGQffL6xQjEwAp3ECyga/z33B3KOzephTrT
         JaM1b4fYgtzzp0vddycxL0iKshI9F7FpmdoT2PD4QZJwfoDcMCRxppIxXoZ1aTCG8q/c
         yBeoE+3nVaTTumw4w0FO1b6k13B1qd+Mc+zHhP0TrbbXVFJe2zJjSD56LLBGeFR65fxn
         eWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682560782; x=1685152782;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CWQuzQLSS5emVnenlShyZIaIdBKkRXi7v9McaRIrhdw=;
        b=MRP0XPMGwEpsOpKL5HqBzOQiFJhlkjXrjkdFHaQmIP+afkkx9qPb1cdygra4D7C6uI
         VsNNmRhrNBgepOysue5Jpaz35Ks16d5G7ENHvLMkxhQLqXgoV/CPWdNceB1NICC8ZbbT
         rwU1V4+zBLAldmHtXJ8FoPlSBUjYyEr0dz2o5OdW/60UM1EVYaWTlC1BWACBbNMmKL2a
         oykZfcIED0PAMwTdePeKezttY7J9wdOyksdn8aR2jgOtDFlexw8JnYJrYitvZQHJyLZB
         cEjZyTL4wyVA2nbe4WvweVgDSUqBt0vBOOhaTQdKqMinyRM4yjGV5IHLzfIJYNKSylzC
         LUCg==
X-Gm-Message-State: AC+VfDw+NVO2CSQdFggvO7CGV+eqHQCvx00PR2PaCOFCMXoQNypO/xU1
        hSYPDjlRe1g9JuraSh18xb75eQ==
X-Google-Smtp-Source: ACHHUZ7m5cCJFwronzoU1KNiCBwYzTrNcVgg6oqq5mMUhhdZ5zmsxSZUk4ipN4fGV3/9uD2IwrcfqA==
X-Received: by 2002:a17:90a:12:b0:247:a17:9258 with SMTP id 18-20020a17090a001200b002470a179258mr198727pja.2.1682560781688;
        Wed, 26 Apr 2023 18:59:41 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s2-20020a170902988200b0019a7d58e595sm10452488plp.143.2023.04.26.18.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 18:59:41 -0700 (PDT)
Message-ID: <8b9fe290-6a6d-6453-682e-2ad2a38e611c@kernel.dk>
Date:   Wed, 26 Apr 2023 19:59:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v10 2/5] io-uring: add napi busy poll support
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
        kernel-team@fb.com
Cc:     ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230425181845.2813854-1-shr@devkernel.io>
 <20230425181845.2813854-3-shr@devkernel.io>
 <ddb2704e-f3a2-c430-0e76-2642580ad1b5@kernel.dk>
 <dbf750fb-5a7b-8d10-d71b-4def3441e821@kernel.dk>
In-Reply-To: <dbf750fb-5a7b-8d10-d71b-4def3441e821@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/23 7:50?PM, Jens Axboe wrote:
> On 4/26/23 7:41?PM, Jens Axboe wrote:
>>> +static void io_napi_multi_busy_loop(struct list_head *napi_list,
>>> +		struct io_wait_queue *iowq)
>>> +{
>>> +	unsigned long start_time = busy_loop_current_time();
>>> +
>>> +	do {
>>> +		if (list_is_singular(napi_list))
>>> +			break;
>>> +		if (!__io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
>>> +			break;
>>> +	} while (!io_napi_busy_loop_should_end(iowq, start_time));
>>> +}
>>
>> Do we need to check for an empty list here?
>>
>>> +static void io_napi_blocking_busy_loop(struct list_head *napi_list,
>>> +		struct io_wait_queue *iowq)
>>> +{
>>> +	if (!list_is_singular(napi_list))
>>> +		io_napi_multi_busy_loop(napi_list, iowq);
>>> +
>>> +	if (list_is_singular(napi_list)) {
>>> +		struct io_napi_ht_entry *ne;
>>> +
>>> +		ne = list_first_entry(napi_list, struct io_napi_ht_entry, list);
>>> +		napi_busy_loop(ne->napi_id, io_napi_busy_loop_should_end, iowq,
>>> +			iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
>>> +	}
>>> +}
>>
>> Presumably io_napi_multi_busy_loop() can change the state of the list,
>> which is why we have if (cond) and then if (!cond) here? Would probably
>> warrant a comment as it looks a bit confusing.
> 
> Doesn't look like that's the case? We just call into
> io_napi_multi_busy_loop() -> napi_busy_loop() which doesn't touch it. So
> the state should be the same?
> 
> We also check if the list isn't singular before we call it, and then
> io_napi_multi_busy_loop() breaks out of the loop if it is. And we know
> it's not singular when calling, and I don't see what changes it.
> 
> Unless I'm missing something, which is quite possible, this looks overly
> convoluted and has extra pointless checks?

All the cleanups/fixes I ended up doing are below. Not all for this
patch probably, just for the series overall. Not tested at all, so
please just go over them and see what makes sense and let me know which
hunks you don't agree with.


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a4c9a404f631..390f54c546d6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2617,29 +2617,17 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
 	iowq.timeout = KTIME_MAX;
 
-	if (!io_napi(ctx)) {
-		if (uts) {
-			struct timespec64 ts;
+	if (uts) {
+		struct timespec64 ts;
 
-			if (get_timespec64(&ts, uts))
-				return -EFAULT;
-			iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
-		}
-	} else {
-		if (uts) {
-			struct timespec64 ts;
-
-			if (get_timespec64(&ts, uts))
-				return -EFAULT;
-
-			io_napi_adjust_timeout(ctx, &iowq, &ts);
-			iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
-		} else {
-			io_napi_adjust_timeout(ctx, &iowq, NULL);
-		}
-		io_napi_busy_loop(ctx, &iowq);
+		if (get_timespec64(&ts, uts))
+			return -EFAULT;
+		iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
+		io_napi_adjust_timeout(ctx, &iowq, &ts);
 	}
 
+	io_napi_busy_loop(ctx, &iowq);
+
 	trace_io_uring_cqring_wait(ctx, min_events);
 
 	do {
diff --git a/io_uring/napi.c b/io_uring/napi.c
index ca12ff5f5611..50b2bdb10417 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -60,8 +60,8 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct file *file)
 	spin_unlock(&ctx->napi_lock);
 }
 
-static inline void adjust_timeout(unsigned int poll_to, struct timespec64 *ts,
-		unsigned int *new_poll_to)
+static void adjust_timeout(unsigned int poll_to, struct timespec64 *ts,
+			  unsigned int *new_poll_to)
 {
 	struct timespec64 pollto = ns_to_timespec64(1000 * (s64)poll_to);
 
@@ -95,12 +95,17 @@ static bool io_napi_busy_loop_should_end(void *p, unsigned long start_time)
 {
 	struct io_wait_queue *iowq = p;
 
-	return signal_pending(current) ||
-	       io_should_wake(iowq) ||
-	       io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to);
+	if (signal_pending(current))
+		return true;
+	if (io_should_wake(iowq))
+		return true;
+	if (io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to))
+		return true;
+	return false;
 }
 
-static bool __io_napi_busy_loop(struct list_head *napi_list, bool prefer_busy_poll)
+static bool __io_napi_do_busy_loop(struct list_head *napi_list,
+				   bool prefer_busy_poll)
 {
 	struct io_napi_ht_entry *e;
 	struct io_napi_ht_entry *n;
@@ -113,38 +118,35 @@ static bool __io_napi_busy_loop(struct list_head *napi_list, bool prefer_busy_po
 	return !list_empty(napi_list);
 }
 
-static void io_napi_multi_busy_loop(struct list_head *napi_list,
-		struct io_wait_queue *iowq)
+static void io_napi_multi_busy_loop(struct list_head *list,
+				   struct io_wait_queue *iowq)
 {
 	unsigned long start_time = busy_loop_current_time();
 
 	do {
-		if (list_is_singular(napi_list))
-			break;
-		if (!__io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
+		if (!__io_napi_do_busy_loop(list, iowq->napi_prefer_busy_poll))
 			break;
 	} while (!io_napi_busy_loop_should_end(iowq, start_time));
 }
 
 static void io_napi_blocking_busy_loop(struct list_head *napi_list,
-		struct io_wait_queue *iowq)
+				       struct io_wait_queue *iowq)
 {
-	if (!list_is_singular(napi_list))
+	if (!list_is_singular(napi_list)) {
 		io_napi_multi_busy_loop(napi_list, iowq);
-
-	if (list_is_singular(napi_list)) {
+	} else {
 		struct io_napi_ht_entry *ne;
 
 		ne = list_first_entry(napi_list, struct io_napi_ht_entry, list);
 		napi_busy_loop(ne->napi_id, io_napi_busy_loop_should_end, iowq,
-			iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
+				iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
 	}
 }
 
 static void io_napi_remove_stale(struct io_ring_ctx *ctx)
 {
-	unsigned int i;
 	struct io_napi_ht_entry *he;
+	unsigned int i;
 
 	hash_for_each(ctx->napi_ht, i, he, node) {
 		if (time_after(jiffies, he->timeout)) {
@@ -152,11 +154,10 @@ static void io_napi_remove_stale(struct io_ring_ctx *ctx)
 			hash_del(&he->node);
 		}
 	}
-
 }
 
 static void io_napi_merge_lists(struct io_ring_ctx *ctx,
-		struct list_head *napi_list)
+				struct list_head *napi_list)
 {
 	spin_lock(&ctx->napi_lock);
 	list_splice(napi_list, &ctx->napi_list);
@@ -186,9 +187,9 @@ void io_napi_init(struct io_ring_ctx *ctx)
  */
 void io_napi_free(struct io_ring_ctx *ctx)
 {
-	unsigned int i;
 	struct io_napi_ht_entry *he;
 	LIST_HEAD(napi_list);
+	unsigned int i;
 
 	spin_lock(&ctx->napi_lock);
 	hash_for_each(ctx->napi_ht, i, he, node)
@@ -206,8 +207,8 @@ void io_napi_free(struct io_ring_ctx *ctx)
 int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 {
 	const struct io_uring_napi curr = {
-		.busy_poll_to = ctx->napi_busy_poll_to,
-		.prefer_busy_poll = ctx->napi_prefer_busy_poll
+		.busy_poll_to		= ctx->napi_busy_poll_to,
+		.prefer_busy_poll	= ctx->napi_prefer_busy_poll
 	};
 	struct io_uring_napi napi;
 
@@ -236,14 +237,12 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 {
 	const struct io_uring_napi curr = {
-		.busy_poll_to = ctx->napi_busy_poll_to,
-		.prefer_busy_poll = ctx->napi_prefer_busy_poll
+		.busy_poll_to		= ctx->napi_busy_poll_to,
+		.prefer_busy_poll	= ctx->napi_prefer_busy_poll
 	};
 
-	if (arg) {
-		if (copy_to_user(arg, &curr, sizeof(curr)))
-			return -EFAULT;
-	}
+	if (arg && copy_to_user(arg, &curr, sizeof(curr)))
+		return -EFAULT;
 
 	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, false);
@@ -251,31 +250,36 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 }
 
 /*
- * io_napi_adjust_timeout() - Add napi id to the busy poll list
+ * __io_napi_adjust_timeout() - Add napi id to the busy poll list
  * @ctx: pointer to io-uring context structure
  * @iowq: pointer to io wait queue
  * @ts: pointer to timespec or NULL
  *
  * Adjust the busy loop timeout according to timespec and busy poll timeout.
  */
-void io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
-		struct timespec64 *ts)
+void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
+			      struct io_wait_queue *iowq, struct timespec64 *ts)
 {
+	unsigned int poll_to;
+
+	if (!io_napi(ctx))
+		return;
+
+	poll_to = READ_ONCE(ctx->napi_busy_poll_to);
 	if (ts)
-		adjust_timeout(READ_ONCE(ctx->napi_busy_poll_to), ts,
-			&iowq->napi_busy_poll_to);
+		adjust_timeout(poll_to, ts, &iowq->napi_busy_poll_to);
 	else
-		iowq->napi_busy_poll_to = READ_ONCE(ctx->napi_busy_poll_to);
+		iowq->napi_busy_poll_to = poll_to;
 }
 
 /*
- * io_napi_busy_loop() - execute busy poll loop
+ * __io_napi_busy_loop() - execute busy poll loop
  * @ctx: pointer to io-uring context structure
  * @iowq: pointer to io wait queue
  *
  * Execute the busy poll loop and merge the spliced off list.
  */
-void io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
+void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
 {
 	iowq->napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
 
@@ -302,8 +306,8 @@ void io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
  */
 int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
 {
-	int ret = 0;
 	LIST_HEAD(napi_list);
+	int ret;
 
 	if (!READ_ONCE(ctx->napi_busy_poll_to))
 		return 0;
@@ -312,9 +316,7 @@ int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
 	list_splice_init(&ctx->napi_list, &napi_list);
 	spin_unlock(&ctx->napi_lock);
 
-	if (__io_napi_busy_loop(&napi_list, ctx->napi_prefer_busy_poll))
-		ret = 1;
-
+	ret = __io_napi_do_busy_loop(&napi_list, ctx->napi_prefer_busy_poll);
 	io_napi_merge_lists(ctx, &napi_list);
 	return ret;
 }
diff --git a/io_uring/napi.h b/io_uring/napi.h
index 8da8f032a441..b5e93b3777c0 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -17,9 +17,9 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg);
 
 void __io_napi_add(struct io_ring_ctx *ctx, struct file *file);
 
-void io_napi_adjust_timeout(struct io_ring_ctx *ctx,
+void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
 		struct io_wait_queue *iowq, struct timespec64 *ts);
-void io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq);
+void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq);
 int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx);
 
 static inline bool io_napi(struct io_ring_ctx *ctx)
@@ -27,6 +27,23 @@ static inline bool io_napi(struct io_ring_ctx *ctx)
 	return !list_empty(&ctx->napi_list);
 }
 
+static inline void io_napi_adjust_timeout(struct io_ring_ctx *ctx,
+					  struct io_wait_queue *iowq,
+					  struct timespec64 *ts)
+{
+	if (!io_napi(ctx))
+		return;
+	__io_napi_adjust_timeout(ctx, iowq, ts);
+}
+
+static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
+				     struct io_wait_queue *iowq)
+{
+	if (!io_napi(ctx))
+		return;
+	__io_napi_busy_loop(ctx, iowq);
+}
+
 /*
  * io_napi_add() - Add napi id to the busy poll list
  * @req: pointer to io_kiocb request

-- 
Jens Axboe

