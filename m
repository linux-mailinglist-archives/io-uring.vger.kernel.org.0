Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754F33E50B1
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 03:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbhHJBnB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 21:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbhHJBnB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 21:43:01 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2CDC0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 18:42:39 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q10so684486wro.2
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 18:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8Eo2MTmPRJGU/+zBB+KZhclCwJtdjc6Qtk1T4B9nPNM=;
        b=ITvqONp380rL+dKX5Cpb23UIh9hnaLKnjW5Mj1W0aSLOVRnJQMe3IAtdippsUZbdRM
         Dl5ywwPuGlQxPrRJMaO/BU/YHM3FKwLAijwAzLMr2bP0J09hAzlfScGmwWSpIdrAYmvI
         EjOQD1oFB3Lp2a0PBkHK7ngdRlbgM8QivYOYUMAPwmmJxruQ7fm/F3FCwTiRsHneoDP4
         RM1uOTKPqPBjn1/Ts0KlPc83RUu60MDKtAd5yQrrzHDxQDHHcTsLFCn/AM5w5Xc56SAc
         d6s4XHOgo2R+Vx6rymLvmDk3BtukRR/CgD+VTNoxH3Pihefbcyv2orKTqyoupjefq7Hw
         Rzxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8Eo2MTmPRJGU/+zBB+KZhclCwJtdjc6Qtk1T4B9nPNM=;
        b=kGr8VyERrn+awfOXcWXty6ihGA/SQLmZzL232fq0FGPrndisDxk0hN/pK2QYb3qp99
         D2WrGWOgtMbenNMiEqXKr4WeW5RICW7gLngfb0k2fCOT+mnovUTdzLRNNG8haFEykais
         W0OBfmJUBGNnykjy6G/gYDjFikaDVyVd4o+Ua71fKa35wFbsZHWVBM9xe0NPK7x7DeBQ
         TfbEvEGUxyhU+5Oc5SI2nM6olXq5VrblN1PxzfYhBy02MRlayixj0NpF8VzTdEwfr1g0
         6obtBLaIiqkvNGwoRWlfNIkDIgS66JJ3NY5xk1fwC5/QqBG3kBcsUfUMcU6BJWXYiTMC
         7Jyw==
X-Gm-Message-State: AOAM530P/qPV1WwDdxiwVrt5p8iT48X5Ty2/lQm6Swj8wcvOvRyqarMQ
        arGeh86oAzSa4cMFje3X80mwdB2GX2Y=
X-Google-Smtp-Source: ABdhPJxK1adFWhig/nQjwX+CSB/SC2Pi8UcqVQXSZ41fa7QZjI9wT2Ii+d/EOe8KXZjanwJUP7KEgw==
X-Received: by 2002:adf:cd10:: with SMTP id w16mr28484705wrm.404.1628559758430;
        Mon, 09 Aug 2021 18:42:38 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g16sm25808995wro.63.2021.08.09.18.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 18:42:38 -0700 (PDT)
To:     Jens Axboe <axboe@fb.com>, io-uring <io-uring@vger.kernel.org>
References: <27997f97-68cc-63c3-863b-b0c460bc42c0@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: be smarter about waking multiple CQ ring
 waiters
Message-ID: <d6f7a325-62ef-ec7f-053d-411354d177f2@gmail.com>
Date:   Tue, 10 Aug 2021 02:42:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <27997f97-68cc-63c3-863b-b0c460bc42c0@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/6/21 9:19 PM, Jens Axboe wrote:
> Currently we only wake the first waiter, even if we have enough entries
> posted to satisfy multiple waiters. Improve that situation so that
> every waiter knows how much the CQ tail has to advance before they can
> be safely woken up.
> 
> With this change, if we have N waiters each asking for 1 event and we get
> 4 completions, then we wake up 4 waiters. If we have N waiters asking
> for 2 completions and we get 4 completions, then we wake up the first
> two. Previously, only the first waiter would've been woken up.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index bf548af0426c..04df4fa3c75e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1435,11 +1435,13 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
>  
>  static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
>  {
> -	/* see waitqueue_active() comment */
> -	smp_mb();
> -
> -	if (waitqueue_active(&ctx->cq_wait))
> -		wake_up(&ctx->cq_wait);
> +	/*
> +	 * wake_up_all() may seem excessive, but io_wake_function() and
> +	 * io_should_wake() handle the termination of the loop and only
> +	 * wake as many waiters as we need to.
> +	 */
> +	if (wq_has_sleeper(&ctx->cq_wait))
> +		wake_up_all(&ctx->cq_wait);
>  	if (ctx->sq_data && waitqueue_active(&ctx->sq_data->wait))
>  		wake_up(&ctx->sq_data->wait);
>  	if (io_should_trigger_evfd(ctx))
> @@ -6968,20 +6970,21 @@ static int io_sq_thread(void *data)
>  struct io_wait_queue {
>  	struct wait_queue_entry wq;
>  	struct io_ring_ctx *ctx;
> -	unsigned to_wait;
> +	unsigned cq_tail;
>  	unsigned nr_timeouts;
>  };
>  
>  static inline bool io_should_wake(struct io_wait_queue *iowq)
>  {
>  	struct io_ring_ctx *ctx = iowq->ctx;
> +	unsigned tail = ctx->cached_cq_tail + atomic_read(&ctx->cq_timeouts);

Seems, adding cq_timeouts can be dropped from here and iowq.cq_tail

>  
>  	/*
>  	 * Wake up if we have enough events, or if a timeout occurred since we
>  	 * started waiting. For timeouts, we always want to return to userspace,
>  	 * regardless of event count.
>  	 */
> -	return io_cqring_events(ctx) >= iowq->to_wait ||

Don't we miss smp_rmb() previously provided my io_cqring_events()?

> +	return tail >= iowq->cq_tail ||

tails might overflow

>  			atomic_read(&ctx->cq_timeouts) != iowq->nr_timeouts;
>  }
>  
> @@ -7045,7 +7048,6 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  			.entry		= LIST_HEAD_INIT(iowq.wq.entry),
>  		},
>  		.ctx		= ctx,
> -		.to_wait	= min_events,
>  	};
>  	struct io_rings *rings = ctx->rings;
>  	signed long timeout = MAX_SCHEDULE_TIMEOUT;
> @@ -7081,6 +7083,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  	}
>  
>  	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
> +	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events +
> +			iowq.nr_timeouts;
>  	trace_io_uring_cqring_wait(ctx, min_events);
>  	do {
>  		/* if we can't even flush overflow, don't wait for more */
> 

-- 
Pavel Begunkov
