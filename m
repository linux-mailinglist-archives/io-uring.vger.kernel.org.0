Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2A130D029
	for <lists+io-uring@lfdr.de>; Wed,  3 Feb 2021 01:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhBCAI2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 19:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbhBCAI1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 19:08:27 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D45C06174A
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 16:07:46 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id b3so4147143wrj.5
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 16:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1AVXKNlmd0CorYAFYJeob35tuPe9viYHGkNAGUR7fBQ=;
        b=ttJNULoqw0tl1g6mq5qZS/70pPpKa/DyUSPvsFzQztJScVldvYuperT/r0vp25JB8Z
         ZOnjo9XsUt+x+KWq5KKkv8/dqwxrBTlOFz5yppoi4MDBfk4DNumZT94vH68fYjJs3XUz
         1qg4FTWfWp+jASBFN6J4i/Oqei5eOgz6NZk4A0tuiYimZU9hus1DL92kjyKJ4XXMsh7b
         BfN3KShhcJnxVOAQLkHwd3dRiXOlrR+DZouOV+vwkxL/4u7nDcO8vObMKKl0PqylWVjW
         N1Zg3mjHv5ujvI+vJA7deirEBac63N/UQf0quW5vdJLmTTdK6qv2jM4/bZ7Qef30dNXc
         y05g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1AVXKNlmd0CorYAFYJeob35tuPe9viYHGkNAGUR7fBQ=;
        b=ZMxrdJuUod2kEfOzatjNSBR24eQmzI5MWce8saDBWnRs4iXScbuEaMRk49uJRcsXPO
         p1+EOXPTTwg1Go3moIWe37Vy/w6wFAT/KnnTHjq3fpnb6HTWkb4PCfBegXiFhqMhQI0a
         udOG1FHS8QMlZ+HQpHQtxtYN7V+Hb7Tzwnz9z1VS+mOWWPil+LVXyWIERLaKpURI3Dq4
         qz5r73Rj5NrOSikRvCynSmxYxPvq35fFI3qEX3oOIEZdgb8F3eNsvwWFcCvGoBi3lpGd
         hhGjBk+xSOOoyRZ+r03qVojBeXpy5sMRucswpk5gW9vpPNjEdpfdxDYyXIObl1Vwthp5
         0FLw==
X-Gm-Message-State: AOAM530X4RUSWaI6DPQniO+HDTMo2IwtpokpgtwMHbrEe3c1ojnznWGm
        w5eToEyy04lJLCESUc+sGT/mtCVkrP10og==
X-Google-Smtp-Source: ABdhPJyzMTx9d57goXfRy9zMS4amA5iaO9xkPG65edD/RCrVfNMiV0XaDcB3aO1ceK0t+Qic46wRoQ==
X-Received: by 2002:adf:dcc8:: with SMTP id x8mr523306wrm.234.1612310865589;
        Tue, 02 Feb 2021 16:07:45 -0800 (PST)
Received: from [192.168.8.171] ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id x11sm242983wmi.4.2021.02.02.16.07.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 16:07:45 -0800 (PST)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612295573-221587-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: fix possible deadlock in io_uring_poll
Message-ID: <9d60270f-993b-ba83-29a0-ce6582c383e0@gmail.com>
Date:   Wed, 3 Feb 2021 00:04:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1612295573-221587-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/02/2021 19:52, Hao Xu wrote:
> This might happen if we do epoll_wait on a uring fd while reading/writing
> the former epoll fd in a sqe in the former uring instance.
> So let's don't flush cqring overflow list when we fail to get the uring
> lock. This leads to less accuracy, but is still ok.

if (io_cqring_events(ctx) || test_bit(0, &ctx->cq_check_overflow))
        mask |= EPOLLIN | EPOLLRDNORM;

Instead of flushing. It'd make sense if we define poll as "there might
be something, go do your peek/wait with overflow checks". Jens, is that
documented anywhere?

> 
> Reported-by: Abaci <abaci@linux.alibaba.com>
> Fixes: 6c503150ae33 ("io_uring: patch up IOPOLL overflow_flush sync")
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> Here I use mutex_trylock() to fix this issue, but this causes loss of
> accuracy. I think doing cqring overflow flush in a task work maybe a
> better solution. I'm think of this. Any thoughts?
> 
>  fs/io_uring.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 38c6cbe1ab38..866e45d42ac7 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8718,7 +8718,36 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
>  	smp_rmb();
>  	if (!io_sqring_full(ctx))
>  		mask |= EPOLLOUT | EPOLLWRNORM;
> -	io_cqring_overflow_flush(ctx, false, NULL, NULL);
> +
> +	if (test_bit(0, &ctx->cq_check_overflow)) {
> +		bool should_flush = true;
> +		/* iopoll syncs against uring_lock, not completion_lock */
> +		if (ctx->flags & IORING_SETUP_IOPOLL) {
> +			/*
> +			 * avoid ABBA deadlock.
> +			 * there could be contention like below:
> +			 *      CPU0                    CPU1
> +			 *      ----                    ----
> +			 * lock(&ctx->uring_lock);
> +			 *                              lock(&ep->mtx);
> +			 *                              lock(&ctx->uring_lock);
> +			 * lock(&ep->mtx);
> +			 *
> +			 * this might happen if we do epoll_wait on a uring fd while
> +			 * read/write the former epoll fd in a sqe in the former uring
> +			 * instance.
> +			 * We don't flush cqring overflow list when we fail to get the
> +			 * uring lock. This leads to less accuracy, but is still ok.
> +			 */
> +			should_flush = mutex_trylock(&ctx->uring_lock);
> +		}
> +		if (should_flush) {
> +			__io_cqring_overflow_flush(ctx, false, NULL, NULL);
> +			if (ctx->flags & IORING_SETUP_IOPOLL)
> +				mutex_unlock(&ctx->uring_lock);
> +		}
> +	}
> +
>  	if (io_cqring_events(ctx))
>  		mask |= EPOLLIN | EPOLLRDNORM;
>  
> 

-- 
Pavel Begunkov
