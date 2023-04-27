Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899916EFF00
	for <lists+io-uring@lfdr.de>; Thu, 27 Apr 2023 03:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242702AbjD0BmC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Apr 2023 21:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242677AbjD0BmB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Apr 2023 21:42:01 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF2735AD
        for <io-uring@vger.kernel.org>; Wed, 26 Apr 2023 18:41:59 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-51f64817809so1064756a12.1
        for <io-uring@vger.kernel.org>; Wed, 26 Apr 2023 18:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682559719; x=1685151719;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hUEDV/4VOs1CwdfcoraZSlEPaUqicG3rwuqerdWJ6uI=;
        b=x4VOJrjfRWdayTJlN3dANzOXiFFRLW2f61/2kD2fyifYIKx2TT1oqawDqFeYh0z7Hx
         aGE4npyVM/Mmjaz9jpb0sK7T8t8hMpch9rgw1y/aGSbX5Rc8W+HZ8avpgqbE3ACoM5Qp
         YEXaYp02mgVnMATBN7FrjUz/cyy89p9cycHMdmeZrcSwmosurGZNKdd0lCZIWTmDB7Ao
         T+93rw88pvXESQBypU+eaTvdQtp06PW62OM5gGGyTFlVHUBVFrfbycAr4L4LyjBflQi/
         TYb+l1CdWadzI4eyVORp3ilFYGSGtgr5eujsJ4RbVzyCRs5lwS8h0VCNRwG0SYLvExP2
         h5rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682559719; x=1685151719;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hUEDV/4VOs1CwdfcoraZSlEPaUqicG3rwuqerdWJ6uI=;
        b=TS8yzSugh+4fA8x6GGt4hrmTUmEsgWZ7UnBJtrh1TlQHI2b/yT7P5swwINyG5i2EYz
         NT4ch7KJ3Vxn1tcrBA6j+oqHoiUxVLltn3TFReHNTWEG1pWdwsTrYQ8FwaKq97uB3OjX
         BKd8icUsgp6ybHbE7tZLf9UI6gbsVdqqclxgTShv60ppO8DM2aH82CVGN+w+zdnHhb/+
         h1zQJYPB1lYgaPciyH5qr1ZmlT7CwVH0qX8WpRttmTyX62rlAQ+fBeaR680/NQoSfw8w
         4VEqVSG2M6f1dCpLWXQoaIwR1ikI3j+3fPivje3tca/okUccL6wBu+nrsXwxPJTTTBxP
         6seg==
X-Gm-Message-State: AC+VfDwkH4ZHtgu3mFGr0TDOpM232Ec8yFSooT7A4GY4EmIfW3z4cdfN
        80tcXq9P4UOES8C0D4ygSKIQnGsaTYtBAVh7CsM=
X-Google-Smtp-Source: ACHHUZ4FYp0o65y87qPxQY4cDHTZNIAbaOQlHOCeLC/f8tlHS0V3muTWA+2sqL5TpuLPLQ4yWr8Cpw==
X-Received: by 2002:a17:90a:1912:b0:23b:4bce:97de with SMTP id 18-20020a17090a191200b0023b4bce97demr157751pjg.4.1682559719272;
        Wed, 26 Apr 2023 18:41:59 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id mh16-20020a17090b4ad000b0024781f5e8besm12195712pjb.26.2023.04.26.18.41.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 18:41:58 -0700 (PDT)
Message-ID: <ddb2704e-f3a2-c430-0e76-2642580ad1b5@kernel.dk>
Date:   Wed, 26 Apr 2023 19:41:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v10 2/5] io-uring: add napi busy poll support
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
        kernel-team@fb.com
Cc:     ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230425181845.2813854-1-shr@devkernel.io>
 <20230425181845.2813854-3-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230425181845.2813854-3-shr@devkernel.io>
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

On 4/25/23 12:18?PM, Stefan Roesch wrote:

Not too much to complain about, just some minor cleanups that would be
nice to do.

> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 1b2a20a42413..2b2ca990ee93 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -277,6 +278,15 @@ struct io_ring_ctx {
>  	struct xarray		personalities;
>  	u32			pers_next;
>  
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	struct list_head	napi_list;	/* track busy poll napi_id */
> +	spinlock_t		napi_lock;	/* napi_list lock */
> +
> +	DECLARE_HASHTABLE(napi_ht, 4);
> +	unsigned int		napi_busy_poll_to; /* napi busy poll default timeout */
> +	bool			napi_prefer_busy_poll;
> +#endif
> +

I don't mind overly long lines if it's warranted, for a comment it is
not. This should just go above the variable.

> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index efbd6c9c56e5..fff8f84eb560 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
>  	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
>  	iowq.timeout = KTIME_MAX;
>  
> -	if (uts) {
> -		struct timespec64 ts;
> +	if (!io_napi(ctx)) {
> +		if (uts) {
> +			struct timespec64 ts;
>  
> -		if (get_timespec64(&ts, uts))
> -			return -EFAULT;
> -		iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
> +			if (get_timespec64(&ts, uts))
> +				return -EFAULT;
> +			iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
> +		}
> +	} else {
> +		if (uts) {
> +			struct timespec64 ts;
> +
> +			if (get_timespec64(&ts, uts))
> +				return -EFAULT;
> +
> +			io_napi_adjust_timeout(ctx, &iowq, &ts);
> +			iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
> +		} else {
> +			io_napi_adjust_timeout(ctx, &iowq, NULL);
> +		}
> +		io_napi_busy_loop(ctx, &iowq);
>  	}

This is a little bit of a mess and has a lot of duplication, that is not
ideal. I'd do something like the end-of-email incremental to avoid that.
Note that it's totally untested...

>  	trace_io_uring_cqring_wait(ctx, min_events);
> +
>  	do {
>  		unsigned long check_cq;
>  

Spurious line addition here.

> diff --git a/io_uring/napi.c b/io_uring/napi.c
> new file mode 100644
> index 000000000000..bb7d2b6b7e90
> --- /dev/null
> +++ b/io_uring/napi.c
> +static inline void adjust_timeout(unsigned int poll_to, struct timespec64 *ts,
> +		unsigned int *new_poll_to)
> +{
> +	struct timespec64 pollto = ns_to_timespec64(1000 * (s64)poll_to);

There's a bunch of these, but I'll just mention it here - io_uring
always just aligns a second line of arguments with the first one. We
should do that here too.

> +	if (timespec64_compare(ts, &pollto) > 0) {
> +		*ts = timespec64_sub(*ts, pollto);
> +		*new_poll_to = poll_to;
> +	} else {
> +		u64 to = timespec64_to_ns(ts);
> +
> +		do_div(to, 1000);

Is this going to complain on 32-bit?

> +static void io_napi_multi_busy_loop(struct list_head *napi_list,
> +		struct io_wait_queue *iowq)
> +{
> +	unsigned long start_time = busy_loop_current_time();
> +
> +	do {
> +		if (list_is_singular(napi_list))
> +			break;
> +		if (!__io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
> +			break;
> +	} while (!io_napi_busy_loop_should_end(iowq, start_time));
> +}

Do we need to check for an empty list here?

> +static void io_napi_blocking_busy_loop(struct list_head *napi_list,
> +		struct io_wait_queue *iowq)
> +{
> +	if (!list_is_singular(napi_list))
> +		io_napi_multi_busy_loop(napi_list, iowq);
> +
> +	if (list_is_singular(napi_list)) {
> +		struct io_napi_ht_entry *ne;
> +
> +		ne = list_first_entry(napi_list, struct io_napi_ht_entry, list);
> +		napi_busy_loop(ne->napi_id, io_napi_busy_loop_should_end, iowq,
> +			iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
> +	}
> +}

Presumably io_napi_multi_busy_loop() can change the state of the list,
which is why we have if (cond) and then if (!cond) here? Would probably
warrant a comment as it looks a bit confusing.

> +/*
> + * io_napi_adjust_timeout() - Add napi id to the busy poll list
> + * @ctx: pointer to io-uring context structure
> + * @iowq: pointer to io wait queue
> + * @ts: pointer to timespec or NULL
> + *
> + * Adjust the busy loop timeout according to timespec and busy poll timeout.
> + */
> +void io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
> +		struct timespec64 *ts)
> +{
> +	if (ts)
> +		adjust_timeout(READ_ONCE(ctx->napi_busy_poll_to), ts,
> +			&iowq->napi_busy_poll_to);
> +	else
> +		iowq->napi_busy_poll_to = READ_ONCE(ctx->napi_busy_poll_to);
> +}

We should probably just pass 'ctx' to adjust_timeout()? Or do

	unsigned int poll_to = READ_ONCE(ctx->napi_busy_poll_to);

at the top and then use that for both. Would get rid of that overly long
line too.


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
index ca12ff5f5611..3a0d0317ceec 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -100,7 +100,8 @@ static bool io_napi_busy_loop_should_end(void *p, unsigned long start_time)
 	       io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to);
 }
 
-static bool __io_napi_busy_loop(struct list_head *napi_list, bool prefer_busy_poll)
+static bool __io_napi_do_busy_loop(struct list_head *napi_list,
+				   bool prefer_busy_poll)
 {
 	struct io_napi_ht_entry *e;
 	struct io_napi_ht_entry *n;
@@ -121,7 +122,7 @@ static void io_napi_multi_busy_loop(struct list_head *napi_list,
 	do {
 		if (list_is_singular(napi_list))
 			break;
-		if (!__io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
+		if (!__io_napi_do_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
 			break;
 	} while (!io_napi_busy_loop_should_end(iowq, start_time));
 }
@@ -251,16 +252,18 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
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
+	if (!io_napi(ctx))
+		return;
 	if (ts)
 		adjust_timeout(READ_ONCE(ctx->napi_busy_poll_to), ts,
 			&iowq->napi_busy_poll_to);
@@ -269,13 +272,13 @@ void io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
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
 
@@ -302,8 +305,8 @@ void io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
  */
 int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
 {
-	int ret = 0;
 	LIST_HEAD(napi_list);
+	int ret;
 
 	if (!READ_ONCE(ctx->napi_busy_poll_to))
 		return 0;
@@ -312,9 +315,7 @@ int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
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

