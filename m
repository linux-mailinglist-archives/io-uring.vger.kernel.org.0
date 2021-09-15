Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACDC340C36F
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 12:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbhIOKOy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 06:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237460AbhIOKOx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 06:14:53 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A56FC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 03:13:34 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id d207-20020a1c1dd8000000b00307e2d1ec1aso1574002wmd.5
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 03:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tWhLOSCZu0rf9Ubu2f6omedKof6DA6vVn8yoSIa2x1E=;
        b=TwVFdD54PciC4ITwNASFDTowCgPgH5qe5UIVXmdzyBUOhAjvLElVSsZAGb89yFztHE
         aO8o4P86mfrKhvqSE53NR653MD7sx1Oaj35VJynRz85IGdaQ6l8EGWaisBB9x1mPx6Sp
         OHAwqYTzMMpnNiEexmtq32UZxpOsh8MZRC+2+4q0uHXc7v/SRe9aB22hQ5zjLF7zTbFB
         K+uGGQkIDjZ/f4QNmZjvsB8CeaEpX3ppfxfZXSJ/srXYpL4oTQo+ntBT+VWH60Hw9kBy
         Swfc5bOFf2ZBE7eFK/tF6J5IP0D5OoF12s8uakbCKjfzrbeECJexlMKD1l7JGNhIYwUc
         SP4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tWhLOSCZu0rf9Ubu2f6omedKof6DA6vVn8yoSIa2x1E=;
        b=2ByuM3lAeJaNWF5qYeNtLko2iqmYk725Bg25sTtasajfJN+qaCaayE8WnmQAC0TpkJ
         SqdGc0360ANNWzQlmClLqtNx1GX31sAW5v5MiugkemYKilsNSvNUe9g2ZeLKtLg3Wtqi
         RRM8oqOCOxePIN/ZOj+sPOtfbPdX+9FIN3/7ALy+h00QVnOIRoDzEkpNDg+zAJy5N2+g
         Y1Qt1W+LNXyC8mlx+nRqgK3nmRM6Bkehp1Iv+nEtvhLmgyoNwbamGj9uGgNqjng0Wu3j
         GKA2n0lYuqcWAX7vpF6+4U+hjDca1vBmZv+SbSeJCiBhoMkxNcej9ibIbgV6DOecwaEu
         a8sA==
X-Gm-Message-State: AOAM530qT8ka9tVD9ksPgeUMHnoAo/ota/6tk2S8wBV/NlRAVlkmvWZa
        twP/+FcUyiA1QZFOLV/6VkGO3fLq4Dg=
X-Google-Smtp-Source: ABdhPJw/nYcAu25T8k5qhOVfzfgL8Rf6kSaQf0oV3DRv8vXym7jq0c6262Ca3wurgiQDqKwoG4YowQ==
X-Received: by 2002:a05:600c:3203:: with SMTP id r3mr3541793wmp.175.1631700812941;
        Wed, 15 Sep 2021 03:13:32 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.239])
        by smtp.gmail.com with ESMTPSA id v28sm13203340wrv.93.2021.09.15.03.13.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 03:13:32 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: fix race between poll completion and
 cancel_hash insertion
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210912162345.51651-1-haoxu@linux.alibaba.com>
 <20210912162345.51651-3-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <b4d71d4e-187d-c96e-2122-e50362c8ead0@gmail.com>
Date:   Wed, 15 Sep 2021 11:12:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210912162345.51651-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/12/21 5:23 PM, Hao Xu wrote:
> If poll arming and poll completion runs parallelly, there maybe races.
> For instance, run io_poll_add in iowq and io_poll_task_func in original
> context, then:
>              iowq                          original context
>   io_poll_add
>     vfs_poll
>      (interruption happens
>       tw queued to original
>       context)                              io_poll_task_func
>                                               generate cqe
>                                               del from cancel_hash[]
>     if !poll.done
>       insert to cancel_hash[]
> 
> The entry left in cancel_hash[], similar case for fast poll.
> Fix it by set poll.done = true when del from cancel_hash[].
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> Didn't find the exact commit to add Fixes: for..
> 
>  fs/io_uring.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c16f6be3d46b..988679e5063f 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5118,10 +5118,8 @@ static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
>  	}
>  	if (req->poll.events & EPOLLONESHOT)
>  		flags = 0;
> -	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
> -		req->poll.done = true;
> +	if (!io_cqring_fill_event(ctx, req->user_data, error, flags))
>  		flags = 0;
> -	}
>  	if (flags & IORING_CQE_F_MORE)
>  		ctx->cq_extra++;
>  
> @@ -5152,6 +5150,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
>  		if (done) {
>  			io_poll_remove_double(req);
>  			hash_del(&req->hash_node);
> +			req->poll.done = true;
>  		} else {
>  			req->result = 0;
>  			add_wait_queue(req->poll.head, &req->poll.wait);
> @@ -5289,6 +5288,7 @@ static void io_async_task_func(struct io_kiocb *req, bool *locked)
>  
>  	hash_del(&req->hash_node);
>  	io_poll_remove_double(req);
> +	req->poll.done = true;

Only poll request has req->poll. E.g. it overwrites parts of req->rw.kiocb,
I guess .ki_complete in particular.

struct async_poll *apoll = req->apoll;
apoll->poll.done = true;


>  	spin_unlock(&ctx->completion_lock);
>  
>  	if (!READ_ONCE(apoll->poll.canceled))
> 

-- 
Pavel Begunkov
