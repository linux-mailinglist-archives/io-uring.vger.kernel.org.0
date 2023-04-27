Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49676F0ADB
	for <lists+io-uring@lfdr.de>; Thu, 27 Apr 2023 19:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243368AbjD0RbL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Apr 2023 13:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbjD0RbK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Apr 2023 13:31:10 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26014110
        for <io-uring@vger.kernel.org>; Thu, 27 Apr 2023 10:31:08 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C2CAC5C00A3;
        Thu, 27 Apr 2023 13:31:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 27 Apr 2023 13:31:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1682616665; x=1682703065; bh=66
        aVbvCyTdJ7w5j+dhHzebl1ek0vGAhlfqfeNJafaVg=; b=WJ0zYLaW9W+Tvld7Bt
        oJ8HXF/XcruQLgNn+dTZtk0UuiKy3qjAd5iyutG2uK0BO/pBULeTHemr6VTzuCZJ
        6Dukb4yP/5+8SeSK9tpr+uasoXOVOHiYSPKE1UD/XS627U3TEx6aaj2vz7/et4TJ
        XSbXvF4clIQu3K2iqhJ3UrvYkzmjruF6kQXnFxDqhjr9G2o3A14fBkmzTiStDppz
        60I8Ho2TRvFnUo42tLhnB+1Ya68eZgg3+lxjlWoSjv31jBkQ8WVOPrO2VHSC2TFj
        C+4O/U2oEBFOmW3MFpJpEGnBdjhfnq/BZiP6sVJdOmJf7/i8Iv/vXjXXPDC+huvH
        0X+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682616665; x=1682703065; bh=66aVbvCyTdJ7w
        5j+dhHzebl1ek0vGAhlfqfeNJafaVg=; b=jWIT7AHP2whepQcPaUadawgYCJwNj
        7Z+snobVJO5WyXgFay5j4fAovX5VsIFAwAak7jUZ4hpdeRcab7pA+cBQhlH9A+N4
        5ddd9l7NdnvEXZHFxbnoHuziS8diZYmEOi1JjuO47pLRSgICNZYY7nYuq0PBOOTF
        8kR2ODWFzrxY4awfq5hBlnZGPqV1vuKZ/VkvJDC02j/M3mX0YtsvtjNT6dRcV8r0
        BZDRyp1aC90/LxoEOHVsdWDQbFP0x8VoBAnx78zmnXM1Yeb1EIrDp9mh+eFM9eMP
        DlUV/yB6f4lK37rlUZIFtX1IbNwupAmPQ9vyoRWRjc1gC5FJX7LwMlBwQ==
X-ME-Sender: <xms:WLFKZCvMgByVcRBsZFZpaWlPvNp5foC5QPehwBnM9Ja8kOxOUBiwqQ>
    <xme:WLFKZHes36MAe3T3H8DZMlyw7ZwcRwkGAVP-hFuKWU_AQmu6dN1lDainfYq0HW4A_
    d6GX9sF524XHCMAOos>
X-ME-Received: <xmr:WLFKZNywQ-I6SYj_wJVY-lw7zKeDruUOIYEzEfcBDlIrbQn-rYCoWrZfJZ0fOhRhMR4ee6LCVg-ik9Rhc9VyYnZ7uJwZUh6PON_gQiby_cFR9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduiedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpehffgfhvfevufffjgfkgggtsehttdertddtredtnecuhfhrohhmpefuthgv
    fhgrnhcutfhovghstghhuceoshhhrhesuggvvhhkvghrnhgvlhdrihhoqeenucggtffrrg
    htthgvrhhnpeevlefggffhheduiedtheejveehtdfhtedvhfeludetvdegieekgeeggfdu
    geeutdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hshhhrseguvghvkhgvrhhnvghlrdhioh
X-ME-Proxy: <xmx:WLFKZNNhaz8c4WIUgheqg3PPRIcVATP1wP2etlpAr37-51__69S86w>
    <xmx:WLFKZC_9Y99Puowr86mKtyKHXFnZMzMOiXkytmcB4frvXr5Wi6K9zA>
    <xmx:WLFKZFWjRZ3jvIl-lNOku1XlYjCk8svxMIY94RCUQnhD4UgfG8m8vw>
    <xmx:WbFKZGYJyva97o_NrxLtj3FU2Ssj6ejK14WYp8BYNFpPW4m_qUvtmQ>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Apr 2023 13:31:03 -0400 (EDT)
References: <20230425181845.2813854-1-shr@devkernel.io>
 <20230425181845.2813854-3-shr@devkernel.io>
 <ddb2704e-f3a2-c430-0e76-2642580ad1b5@kernel.dk>
User-agent: mu4e 1.10.1; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com,
        ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v10 2/5] io-uring: add napi busy poll support
Date:   Thu, 27 Apr 2023 09:27:02 -0700
In-reply-to: <ddb2704e-f3a2-c430-0e76-2642580ad1b5@kernel.dk>
Message-ID: <qvqw354lb5bl.fsf@devbig1114.prn1.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Jens Axboe <axboe@kernel.dk> writes:

> On 4/25/23 12:18?PM, Stefan Roesch wrote:
>
> Not too much to complain about, just some minor cleanups that would be
> nice to do.
>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 1b2a20a42413..2b2ca990ee93 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -277,6 +278,15 @@ struct io_ring_ctx {
>>  	struct xarray		personalities;
>>  	u32			pers_next;
>>
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	struct list_head	napi_list;	/* track busy poll napi_id */
>> +	spinlock_t		napi_lock;	/* napi_list lock */
>> +
>> +	DECLARE_HASHTABLE(napi_ht, 4);
>> +	unsigned int		napi_busy_poll_to; /* napi busy poll default timeout */
>> +	bool			napi_prefer_busy_poll;
>> +#endif
>> +
>
> I don't mind overly long lines if it's warranted, for a comment it is
> not. This should just go above the variable.
>

Fixed. I was just following what sq_creds was doing a bit earlier in the
file.

>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index efbd6c9c56e5..fff8f84eb560 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>>  	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
>>  	iowq.timeout = KTIME_MAX;
>>
>> -	if (uts) {
>> -		struct timespec64 ts;
>> +	if (!io_napi(ctx)) {
>> +		if (uts) {
>> +			struct timespec64 ts;
>>
>> -		if (get_timespec64(&ts, uts))
>> -			return -EFAULT;
>> -		iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
>> +			if (get_timespec64(&ts, uts))
>> +				return -EFAULT;
>> +			iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
>> +		}
>> +	} else {
>> +		if (uts) {
>> +			struct timespec64 ts;
>> +
>> +			if (get_timespec64(&ts, uts))
>> +				return -EFAULT;
>> +
>> +			io_napi_adjust_timeout(ctx, &iowq, &ts);
>> +			iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
>> +		} else {
>> +			io_napi_adjust_timeout(ctx, &iowq, NULL);
>> +		}
>> +		io_napi_busy_loop(ctx, &iowq);
>>  	}
>
> This is a little bit of a mess and has a lot of duplication, that is not
> ideal. I'd do something like the end-of-email incremental to avoid that.
> Note that it's totally untested...
>
>>  	trace_io_uring_cqring_wait(ctx, min_events);
>> +
>>  	do {
>>  		unsigned long check_cq;
>>
>
> Spurious line addition here.
>

Fixed.

 diff --git a/io_uring/napi.c b/io_uring/napi.c
>> new file mode 100644
>> index 000000000000..bb7d2b6b7e90
>> --- /dev/null
>> +++ b/io_uring/napi.c
>> +static inline void adjust_timeout(unsigned int poll_to, struct timespec64 *ts,
>> +		unsigned int *new_poll_to)
>> +{
>> +	struct timespec64 pollto = ns_to_timespec64(1000 * (s64)poll_to);
>
> There's a bunch of these, but I'll just mention it here - io_uring
> always just aligns a second line of arguments with the first one. We
> should do that here too.
>

Fixed.

>> +	if (timespec64_compare(ts, &pollto) > 0) {
>> +		*ts = timespec64_sub(*ts, pollto);
>> +		*new_poll_to = poll_to;
>> +	} else {
>> +		u64 to = timespec64_to_ns(ts);
>> +
>> +		do_div(to, 1000);
>
> Is this going to complain on 32-bit?
>

My understanding is this should work on 32-bit.

>> +static void io_napi_multi_busy_loop(struct list_head *napi_list,
>> +		struct io_wait_queue *iowq)
>> +{
>> +	unsigned long start_time = busy_loop_current_time();
>> +
>> +	do {
>> +		if (list_is_singular(napi_list))
>> +			break;
>> +		if (!__io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
>> +			break;
>> +	} while (!io_napi_busy_loop_should_end(iowq, start_time));
>> +}
>
> Do we need to check for an empty list here?
>
This function is only called through io_cqring_wait(),
io_napi_busy_loop(). In io_cqring_wait() we check that the napi list is
not empty.

>> +static void io_napi_blocking_busy_loop(struct list_head *napi_list,
>> +		struct io_wait_queue *iowq)
>> +{
>> +	if (!list_is_singular(napi_list))
>> +		io_napi_multi_busy_loop(napi_list, iowq);
>> +
>> +	if (list_is_singular(napi_list)) {
>> +		struct io_napi_ht_entry *ne;
>> +
>> +		ne = list_first_entry(napi_list, struct io_napi_ht_entry, list);
>> +		napi_busy_loop(ne->napi_id, io_napi_busy_loop_should_end, iowq,
>> +			iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
>> +	}
>> +}
>
> Presumably io_napi_multi_busy_loop() can change the state of the list,
> which is why we have if (cond) and then if (!cond) here? Would probably
> warrant a comment as it looks a bit confusing.
>

I added a comment.

>> +/*
>> + * io_napi_adjust_timeout() - Add napi id to the busy poll list
>> + * @ctx: pointer to io-uring context structure
>> + * @iowq: pointer to io wait queue
>> + * @ts: pointer to timespec or NULL
>> + *
>> + * Adjust the busy loop timeout according to timespec and busy poll timeout.
>> + */
>> +void io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
>> +		struct timespec64 *ts)
>> +{
>> +	if (ts)
>> +		adjust_timeout(READ_ONCE(ctx->napi_busy_poll_to), ts,
>> +			&iowq->napi_busy_poll_to);
>> +	else
>> +		iowq->napi_busy_poll_to = READ_ONCE(ctx->napi_busy_poll_to);
>> +}
>
> We should probably just pass 'ctx' to adjust_timeout()? Or do
>
> 	unsigned int poll_to = READ_ONCE(ctx->napi_busy_poll_to);
>
> at the top and then use that for both. Would get rid of that overly long
> line too.
>
>
I think it makes sense to combine the two functions. I'll also add a
variable at the top of the function like your example above.

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
> index ca12ff5f5611..3a0d0317ceec 100644
> --- a/io_uring/napi.c
> +++ b/io_uring/napi.c
> @@ -100,7 +100,8 @@ static bool io_napi_busy_loop_should_end(void *p, unsigned long start_time)
>  	       io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to);
>  }
>
> -static bool __io_napi_busy_loop(struct list_head *napi_list, bool prefer_busy_poll)
> +static bool __io_napi_do_busy_loop(struct list_head *napi_list,
> +				   bool prefer_busy_poll)
>  {
>  	struct io_napi_ht_entry *e;
>  	struct io_napi_ht_entry *n;
> @@ -121,7 +122,7 @@ static void io_napi_multi_busy_loop(struct list_head *napi_list,
>  	do {
>  		if (list_is_singular(napi_list))
>  			break;
> -		if (!__io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
> +		if (!__io_napi_do_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
>  			break;
>  	} while (!io_napi_busy_loop_should_end(iowq, start_time));
>  }
> @@ -251,16 +252,18 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
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
> +	if (!io_napi(ctx))
> +		return;
>  	if (ts)
>  		adjust_timeout(READ_ONCE(ctx->napi_busy_poll_to), ts,
>  			&iowq->napi_busy_poll_to);
> @@ -269,13 +272,13 @@ void io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
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
> @@ -302,8 +305,8 @@ void io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
>   */
>  int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
>  {
> -	int ret = 0;
>  	LIST_HEAD(napi_list);
> +	int ret;
>
>  	if (!READ_ONCE(ctx->napi_busy_poll_to))
>  		return 0;
> @@ -312,9 +315,7 @@ int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
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
>

I'll have a look at the above proposal.
