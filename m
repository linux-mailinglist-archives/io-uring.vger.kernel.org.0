Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3906F5D1D
	for <lists+io-uring@lfdr.de>; Wed,  3 May 2023 19:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjECRkJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 May 2023 13:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjECRkI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 May 2023 13:40:08 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6B96598
        for <io-uring@vger.kernel.org>; Wed,  3 May 2023 10:40:06 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-33151fcce8cso684195ab.0
        for <io-uring@vger.kernel.org>; Wed, 03 May 2023 10:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683135606; x=1685727606;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rAR4HAaB9X5cijFTEy0cFEkjGf75VHtCTtJrQj+BVAQ=;
        b=ibZe1WPJYQgtiFeO65cR8JCozWKAETKYp/TCEU07MKa2L8vTAKpZpbnvJOAH+HDAFv
         6emVdnxXhGAkr8+S4ydT3zyEboiWpZAodtlPXYF1K+Ax3mYEnv0LXJzQWuXaFCuV/0bR
         vyuhFbmcSahJiZt/bORNSwiA1bvHCEel2xe5UQc0pXhBQZXvsXXq0qp26OixxvGcnEFt
         bCttzmA4EWPrFrgYAJdd4S1hG2IVavwkDXhbMez8XqDQKjJ0hDvp5GhhF211drfjeBIU
         +5Pz2zsdqJaW/65k7mznOZaQwpT0FTUTGnKmKzX0s234FbB3NET754uXV+5RAOsl/uSD
         awHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683135606; x=1685727606;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rAR4HAaB9X5cijFTEy0cFEkjGf75VHtCTtJrQj+BVAQ=;
        b=F4g327Qj9nU0kPhfVBnnbUbkgpE8Tuq1w721eypeMxAzRK5jzl9TKOAotliWRC7IMP
         pYEg3keP/ruwMW5fu4/zZ9As7AtcfX0jGMTe7z9na/XTixYKEA8LaETKIk1s38APss0u
         z3c+IWFT+FF3i7g1sKAeW4x+5whwx6dJSwfHrEJBy4/rDLfNroW1uMr99wu8fAqVI6dA
         sWCebF19WnxMXvTtb1ZgJoe/jtVyAdN8hH2bpi87JqobToH68awBsilpaXkEyZw9K7A/
         emc2IkDW4niJgr2fvbYL4TYmCkNprSxjTwNyka+wq2Td/ZZIG5HuveZJCBGre/v1+uAY
         KenQ==
X-Gm-Message-State: AC+VfDy8PHl9TPDBvMKN66U+rxIu8Zxmz95ouEcpfiiIq2Gppe1PlYwE
        zFXIgEWgN0YF80dzpx4AQfFXFA==
X-Google-Smtp-Source: ACHHUZ5+PK3G/5z9HFQHOXahaEaoWC1TBAgICEOV9uA/yDe3cL1QVTfwEY7gIBC8l7iFCqpJ7XvkKw==
X-Received: by 2002:a05:6e02:1baa:b0:32a:8792:7248 with SMTP id n10-20020a056e021baa00b0032a87927248mr4398514ili.2.1683135606224;
        Wed, 03 May 2023 10:40:06 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c10-20020a92bd0a000000b0032e188cc7a1sm7704061ile.44.2023.05.03.10.40.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 10:40:05 -0700 (PDT)
Message-ID: <acd78dcf-f145-d7d3-a30d-4b6694089023@kernel.dk>
Date:   Wed, 3 May 2023 11:40:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v12 2/5] io-uring: add napi busy poll support
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
        kernel-team@fb.com
Cc:     ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230502165332.2075091-1-shr@devkernel.io>
 <20230502165332.2075091-3-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230502165332.2075091-3-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/2/23 10:53?AM, Stefan Roesch wrote:
> diff --git a/io_uring/napi.c b/io_uring/napi.c
> new file mode 100644
> index 000000000000..76bcabeb7ef0
> --- /dev/null
> +++ b/io_uring/napi.c
> +static bool io_napi_busy_loop_should_end(void *data,
> +					 unsigned long start_time)
> +{
> +	struct io_wait_queue *iowq = data;
> +
> +	if (signal_pending(current))
> +		return true;
> +	if (io_should_wake(iowq))
> +		return true;
> +	if (io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to))
> +		return true;
> +
> +	return false;
> +}
> +
> +static bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
> +				   void *loop_end_arg)
> +{
> +	struct io_napi_entry *e;
> +	bool (*loop_end)(void *, unsigned long) = NULL;
> +	bool is_stale = false;
> +
> +	if (loop_end_arg)
> +		loop_end = io_napi_busy_loop_should_end;
> +
> +	list_for_each_entry_rcu(e, &ctx->napi_list, list) {
> +		napi_busy_loop(e->napi_id, loop_end, loop_end_arg,
> +			       ctx->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
> +
> +		if (time_after(jiffies, e->timeout))
> +			is_stale = true;
> +	}
> +
> +	return is_stale;
> +}
> +
> +static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
> +				       struct io_wait_queue *iowq)
> +{
> +	unsigned long start_time = busy_loop_current_time();
> +	void *loop_end_arg = NULL;
> +	bool is_stale = false;
> +
> +	/* Singular lists use a different napi loop end check function and are
> +	 * only executed once.
> +	 */
> +	if (list_is_singular(&ctx->napi_list))
> +		loop_end_arg = iowq;
> +
> +	rcu_read_lock();
> +	do {
> +		is_stale = __io_napi_do_busy_loop(ctx, loop_end_arg);
> +	} while (!io_napi_busy_loop_should_end(iowq, start_time) && !loop_end_arg);
> +	rcu_read_unlock();
> +
> +	io_napi_remove_stale(ctx, is_stale);
> +}

I mentioned this in our out-of-band discussions on this patch set, and
we cannot call napi_busy_loop() under rcu_read_lock() if loop_end and
loop_end_arg is set AND loop_end() doesn't always return true. Because
otherwise we can end up with napi_busy_loop() doing:

	if (unlikely(need_resched())) {
		if (napi_poll)
			busy_poll_stop(napi, have_poll_lock, prefer_busy_poll, budget);
		preempt_enable();
		rcu_read_unlock();
		cond_resched();
		if (loop_end(loop_end_arg, start_time))
			return;
		goto restart;
	}

and hence we're now scheduling with rcu read locking disabled. So we
need to handle that case appropriately as well.

-- 
Jens Axboe

