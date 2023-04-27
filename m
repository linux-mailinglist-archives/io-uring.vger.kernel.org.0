Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160AD6F0BD5
	for <lists+io-uring@lfdr.de>; Thu, 27 Apr 2023 20:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244236AbjD0SW3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Apr 2023 14:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244196AbjD0SW2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Apr 2023 14:22:28 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0632210DA
        for <io-uring@vger.kernel.org>; Thu, 27 Apr 2023 11:22:27 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 15B6B5C0110;
        Thu, 27 Apr 2023 14:22:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 27 Apr 2023 14:22:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1682619746; x=1682706146; bh=Y2
        npo3voJKUMCdd4xPN5mwBc7G9JQ0JdhFdNHf6tcsY=; b=b4GuZ/ICIS1TQFULeN
        BIsPZOFJ0M1qU6aj9iKhfEMMvPlzJ+Fv1bTHn30+R0fydbbnBzeICvl0J/sO6wOs
        jrWMXHPiQaBkiB3fLH3nZa1LeWWyZblRpHER7S57BomRpKrkClpNGqOXC04iClML
        akUY7ITzDKC3tifynM07qwfY22QrguoJwB00jpJEXEN01mVMTh3mZB7Evx1JdDL9
        MWrwchJxy1l3sECWERusNtVAZnCLt+HRt9r6zVz5/wYkZGmNy+HZKKnWTcMgBpGP
        O02W/7Fw8jt9yaWkVqXmqM2btAdM0HNujL5x/qlzsL65RQbfkc4Sfo/qMxHt9elB
        tV4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682619746; x=1682706146; bh=Y2npo3voJKUMC
        dd4xPN5mwBc7G9JQ0JdhFdNHf6tcsY=; b=aDv9inAeNIiz9dYoYK1Bw/3Ol/A2C
        ybolyYDbsqtgEsMWZ5wCq4Pmc5y2zUQQOxTyOYEYeycBzTFk5iIUF8WHDeTzdCow
        z/PExZu9PdtK9T1gUTY0wzf6CmOlvnclN4dRo+aD7akPqirZXigOwWX/+l4tTMEp
        KqH+z3JL9SdbEy2xIUF6GJ+S/rBHtQ3EKrLl1m92YSS45wszSBTBW+ou2pHLyW4q
        YHwJl11AQy9HXaA7cnVwvByRWbRgCaR1us/780jrKPMGoJwOqUVnGykAOFuXbJ0v
        /JWF8CjOXh4fwk/CCCBcsHPBLc52MZ6+1Keiwugg8mrkm3Evc4DtUcegA==
X-ME-Sender: <xms:Yb1KZBkiWAm6UH4a4-5iytstwxg-jwSIwDUiUX4m1LThRpvS_F0rOg>
    <xme:Yb1KZM0WK46LsjosNEMszfBtTDWcpLpxA2GuY4IbzKYX9MMN5w1dkUkwa1F4KLwMo
    TPhvz5HvbBRkWsToHw>
X-ME-Received: <xmr:Yb1KZHo7MQFFONWXnapc70cJpLUDNhWLcelCggkNpeYuAWLqimes9jXCfwLTjtT_R-QjmYTJRM_nj4QPDRP3_C7nhOyyrKChHZb9O5RZU2U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduiedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpehffgfhvfevufffjgfkgggtsehttdertddtredtnecuhfhrohhmpefuthgv
    fhgrnhcutfhovghstghhuceoshhhrhesuggvvhhkvghrnhgvlhdrihhoqeenucggtffrrg
    htthgvrhhnpeevlefggffhheduiedtheejveehtdfhtedvhfeludetvdegieekgeeggfdu
    geeutdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hshhhrseguvghvkhgvrhhnvghlrdhioh
X-ME-Proxy: <xmx:Yb1KZBlbwaIsPfFhld43AAZPUGbwf8tRct8B4saVYSu2108W6G65zA>
    <xmx:Yb1KZP0DfOmbY6shlcip-NG2fWHjr97obsxsZPso2yATUG3wIwIbrA>
    <xmx:Yb1KZAudhWn0Lrijx3ezZSMInJxS62PV8lQNUt1AfF-P10_J3pscQA>
    <xmx:Yr1KZKTxccVN3vrhemhKw_AM4O2FuJkTV-kfF32L_7t1hwBB-SX3KA>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Apr 2023 14:22:24 -0400 (EDT)
References: <20230425181845.2813854-1-shr@devkernel.io>
 <20230425181845.2813854-3-shr@devkernel.io>
 <ddb2704e-f3a2-c430-0e76-2642580ad1b5@kernel.dk>
 <dbf750fb-5a7b-8d10-d71b-4def3441e821@kernel.dk>
 <8b9fe290-6a6d-6453-682e-2ad2a38e611c@kernel.dk>
User-agent: mu4e 1.10.1; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com,
        ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v10 2/5] io-uring: add napi busy poll support
Date:   Thu, 27 Apr 2023 11:21:22 -0700
In-reply-to: <8b9fe290-6a6d-6453-682e-2ad2a38e611c@kernel.dk>
Message-ID: <qvqwpm7p9odc.fsf@devbig1114.prn1.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Jens Axboe <axboe@kernel.dk> writes:

> On 4/26/23 7:50?PM, Jens Axboe wrote:
>> On 4/26/23 7:41?PM, Jens Axboe wrote:
>>>> +static void io_napi_multi_busy_loop(struct list_head *napi_list,
>>>> +		struct io_wait_queue *iowq)
>>>> +{
>>>> +	unsigned long start_time = busy_loop_current_time();
>>>> +
>>>> +	do {
>>>> +		if (list_is_singular(napi_list))
>>>> +			break;
>>>> +		if (!__io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
>>>> +			break;
>>>> +	} while (!io_napi_busy_loop_should_end(iowq, start_time));
>>>> +}
>>>
>>> Do we need to check for an empty list here?
>>>
>>>> +static void io_napi_blocking_busy_loop(struct list_head *napi_list,
>>>> +		struct io_wait_queue *iowq)
>>>> +{
>>>> +	if (!list_is_singular(napi_list))
>>>> +		io_napi_multi_busy_loop(napi_list, iowq);
>>>> +
>>>> +	if (list_is_singular(napi_list)) {
>>>> +		struct io_napi_ht_entry *ne;
>>>> +
>>>> +		ne = list_first_entry(napi_list, struct io_napi_ht_entry, list);
>>>> +		napi_busy_loop(ne->napi_id, io_napi_busy_loop_should_end, iowq,
>>>> +			iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
>>>> +	}
>>>> +}
>>>
>>> Presumably io_napi_multi_busy_loop() can change the state of the list,
>>> which is why we have if (cond) and then if (!cond) here? Would probably
>>> warrant a comment as it looks a bit confusing.
>>
>> Doesn't look like that's the case? We just call into
>> io_napi_multi_busy_loop() -> napi_busy_loop() which doesn't touch it. So
>> the state should be the same?
>>
>> We also check if the list isn't singular before we call it, and then
>> io_napi_multi_busy_loop() breaks out of the loop if it is. And we know
>> it's not singular when calling, and I don't see what changes it.
>>
>> Unless I'm missing something, which is quite possible, this looks overly
>> convoluted and has extra pointless checks?
>
> All the cleanups/fixes I ended up doing are below. Not all for this
> patch probably, just for the series overall. Not tested at all, so
> please just go over them and see what makes sense and let me know which
> hunks you don't agree with.
>
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index a4c9a404f631..390f54c546d6 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2617,29 +2617,17 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
>  	iowq.timeout = KTIME_MAX;
>
> -	if (!io_napi(ctx)) {
> -		if (uts) {
> -			struct timespec64 ts;
> +	if (uts) {
> +		struct timespec64 ts;
>
> -			if (get_timespec64(&ts, uts))
> -				return -EFAULT;
> -			iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
> -		}
> -	} else {
> -		if (uts) {
> -			struct timespec64 ts;
> -
> -			if (get_timespec64(&ts, uts))
> -				return -EFAULT;
> -
> -			io_napi_adjust_timeout(ctx, &iowq, &ts);
> -			iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
> -		} else {
> -			io_napi_adjust_timeout(ctx, &iowq, NULL);
> -		}
> -		io_napi_busy_loop(ctx, &iowq);
> +		if (get_timespec64(&ts, uts))
> +			return -EFAULT;
> +		iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
> +		io_napi_adjust_timeout(ctx, &iowq, &ts);
>  	}
>
> +	io_napi_busy_loop(ctx, &iowq);
> +
>  	trace_io_uring_cqring_wait(ctx, min_events);
>
>  	do {
> diff --git a/io_uring/napi.c b/io_uring/napi.c
> index ca12ff5f5611..50b2bdb10417 100644
> --- a/io_uring/napi.c
> +++ b/io_uring/napi.c
> @@ -60,8 +60,8 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct file *file)
>  	spin_unlock(&ctx->napi_lock);
>  }
>
> -static inline void adjust_timeout(unsigned int poll_to, struct timespec64 *ts,
> -		unsigned int *new_poll_to)
> +static void adjust_timeout(unsigned int poll_to, struct timespec64 *ts,
> +			  unsigned int *new_poll_to)
>  {
>  	struct timespec64 pollto = ns_to_timespec64(1000 * (s64)poll_to);
>
> @@ -95,12 +95,17 @@ static bool io_napi_busy_loop_should_end(void *p, unsigned long start_time)
>  {
>  	struct io_wait_queue *iowq = p;
>
> -	return signal_pending(current) ||
> -	       io_should_wake(iowq) ||
> -	       io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to);
> +	if (signal_pending(current))
> +		return true;
> +	if (io_should_wake(iowq))
> +		return true;
> +	if (io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to))
> +		return true;
> +	return false;
>  }
>
> -static bool __io_napi_busy_loop(struct list_head *napi_list, bool prefer_busy_poll)
> +static bool __io_napi_do_busy_loop(struct list_head *napi_list,
> +				   bool prefer_busy_poll)
>  {
>  	struct io_napi_ht_entry *e;
>  	struct io_napi_ht_entry *n;
> @@ -113,38 +118,35 @@ static bool __io_napi_busy_loop(struct list_head *napi_list, bool prefer_busy_po
>  	return !list_empty(napi_list);
>  }
>
> -static void io_napi_multi_busy_loop(struct list_head *napi_list,
> -		struct io_wait_queue *iowq)
> +static void io_napi_multi_busy_loop(struct list_head *list,
> +				   struct io_wait_queue *iowq)
>  {
>  	unsigned long start_time = busy_loop_current_time();
>
>  	do {
> -		if (list_is_singular(napi_list))
> -			break;
> -		if (!__io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
> +		if (!__io_napi_do_busy_loop(list, iowq->napi_prefer_busy_poll))
>  			break;
>  	} while (!io_napi_busy_loop_should_end(iowq, start_time));
>  }
>
>  static void io_napi_blocking_busy_loop(struct list_head *napi_list,
> -		struct io_wait_queue *iowq)
> +				       struct io_wait_queue *iowq)
>  {
> -	if (!list_is_singular(napi_list))
> +	if (!list_is_singular(napi_list)) {
>  		io_napi_multi_busy_loop(napi_list, iowq);
> -
> -	if (list_is_singular(napi_list)) {
> +	} else {
>  		struct io_napi_ht_entry *ne;
>
>  		ne = list_first_entry(napi_list, struct io_napi_ht_entry, list);
>  		napi_busy_loop(ne->napi_id, io_napi_busy_loop_should_end, iowq,
> -			iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
> +				iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
>  	}
>  }
>
>  static void io_napi_remove_stale(struct io_ring_ctx *ctx)
>  {
> -	unsigned int i;
>  	struct io_napi_ht_entry *he;
> +	unsigned int i;
>
>  	hash_for_each(ctx->napi_ht, i, he, node) {
>  		if (time_after(jiffies, he->timeout)) {
> @@ -152,11 +154,10 @@ static void io_napi_remove_stale(struct io_ring_ctx *ctx)
>  			hash_del(&he->node);
>  		}
>  	}
> -
>  }
>
>  static void io_napi_merge_lists(struct io_ring_ctx *ctx,
> -		struct list_head *napi_list)
> +				struct list_head *napi_list)
>  {
>  	spin_lock(&ctx->napi_lock);
>  	list_splice(napi_list, &ctx->napi_list);
> @@ -186,9 +187,9 @@ void io_napi_init(struct io_ring_ctx *ctx)
>   */
>  void io_napi_free(struct io_ring_ctx *ctx)
>  {
> -	unsigned int i;
>  	struct io_napi_ht_entry *he;
>  	LIST_HEAD(napi_list);
> +	unsigned int i;
>
>  	spin_lock(&ctx->napi_lock);
>  	hash_for_each(ctx->napi_ht, i, he, node)
> @@ -206,8 +207,8 @@ void io_napi_free(struct io_ring_ctx *ctx)
>  int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
>  {
>  	const struct io_uring_napi curr = {
> -		.busy_poll_to = ctx->napi_busy_poll_to,
> -		.prefer_busy_poll = ctx->napi_prefer_busy_poll
> +		.busy_poll_to		= ctx->napi_busy_poll_to,
> +		.prefer_busy_poll	= ctx->napi_prefer_busy_poll
>  	};
>  	struct io_uring_napi napi;
>
> @@ -236,14 +237,12 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
>  int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
>  {
>  	const struct io_uring_napi curr = {
> -		.busy_poll_to = ctx->napi_busy_poll_to,
> -		.prefer_busy_poll = ctx->napi_prefer_busy_poll
> +		.busy_poll_to		= ctx->napi_busy_poll_to,
> +		.prefer_busy_poll	= ctx->napi_prefer_busy_poll
>  	};
>
> -	if (arg) {
> -		if (copy_to_user(arg, &curr, sizeof(curr)))
> -			return -EFAULT;
> -	}
> +	if (arg && copy_to_user(arg, &curr, sizeof(curr)))
> +		return -EFAULT;
>
>  	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
>  	WRITE_ONCE(ctx->napi_prefer_busy_poll, false);
> @@ -251,31 +250,36 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
>  }
>
>  /*
> - * io_napi_adjust_timeout() - Add napi id to the busy poll list
> + * __io_napi_adjust_timeout() - Add napi id to the busy poll list
>   * @ctx: pointer to io-uring context structure
>   * @iowq: pointer to io wait queue
>   * @ts: pointer to timespec or NULL
>   *
>   * Adjust the busy loop timeout according to timespec and busy poll timeout.
>   */
> -void io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
> -		struct timespec64 *ts)
> +void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
> +			      struct io_wait_queue *iowq, struct timespec64 *ts)
>  {
> +	unsigned int poll_to;
> +
> +	if (!io_napi(ctx))
> +		return;
> +
> +	poll_to = READ_ONCE(ctx->napi_busy_poll_to);
>  	if (ts)
> -		adjust_timeout(READ_ONCE(ctx->napi_busy_poll_to), ts,
> -			&iowq->napi_busy_poll_to);
> +		adjust_timeout(poll_to, ts, &iowq->napi_busy_poll_to);
>  	else
> -		iowq->napi_busy_poll_to = READ_ONCE(ctx->napi_busy_poll_to);
> +		iowq->napi_busy_poll_to = poll_to;
>  }
>
>  /*
> - * io_napi_busy_loop() - execute busy poll loop
> + * __io_napi_busy_loop() - execute busy poll loop
>   * @ctx: pointer to io-uring context structure
>   * @iowq: pointer to io wait queue
>   *
>   * Execute the busy poll loop and merge the spliced off list.
>   */
> -void io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
> +void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
>  {
>  	iowq->napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
>
> @@ -302,8 +306,8 @@ void io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
>   */
>  int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
>  {
> -	int ret = 0;
>  	LIST_HEAD(napi_list);
> +	int ret;
>
>  	if (!READ_ONCE(ctx->napi_busy_poll_to))
>  		return 0;
> @@ -312,9 +316,7 @@ int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
>  	list_splice_init(&ctx->napi_list, &napi_list);
>  	spin_unlock(&ctx->napi_lock);
>
> -	if (__io_napi_busy_loop(&napi_list, ctx->napi_prefer_busy_poll))
> -		ret = 1;
> -
> +	ret = __io_napi_do_busy_loop(&napi_list, ctx->napi_prefer_busy_poll);
>  	io_napi_merge_lists(ctx, &napi_list);
>  	return ret;
>  }
> diff --git a/io_uring/napi.h b/io_uring/napi.h
> index 8da8f032a441..b5e93b3777c0 100644
> --- a/io_uring/napi.h
> +++ b/io_uring/napi.h
> @@ -17,9 +17,9 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg);
>
>  void __io_napi_add(struct io_ring_ctx *ctx, struct file *file);
>
> -void io_napi_adjust_timeout(struct io_ring_ctx *ctx,
> +void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
>  		struct io_wait_queue *iowq, struct timespec64 *ts);
> -void io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq);
> +void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq);
>  int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx);
>
>  static inline bool io_napi(struct io_ring_ctx *ctx)
> @@ -27,6 +27,23 @@ static inline bool io_napi(struct io_ring_ctx *ctx)
>  	return !list_empty(&ctx->napi_list);
>  }
>
> +static inline void io_napi_adjust_timeout(struct io_ring_ctx *ctx,
> +					  struct io_wait_queue *iowq,
> +					  struct timespec64 *ts)
> +{
> +	if (!io_napi(ctx))
> +		return;
> +	__io_napi_adjust_timeout(ctx, iowq, ts);
> +}
> +
> +static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
> +				     struct io_wait_queue *iowq)
> +{
> +	if (!io_napi(ctx))
> +		return;
> +	__io_napi_busy_loop(ctx, iowq);
> +}
> +
>  /*
>   * io_napi_add() - Add napi id to the busy poll list
>   * @req: pointer to io_kiocb request

Looks good to me, only difference is to callapse
__io_napi_adjust_timeout and adjust_timeout in one function.
