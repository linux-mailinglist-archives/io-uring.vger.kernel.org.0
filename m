Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BED40C2F5
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 11:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhIOJwF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 05:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbhIOJwD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 05:52:03 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC36C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 02:50:45 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x6so2837174wrv.13
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 02:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qq9v/CwEi+Cj5N2T1q5iB6l2liWe4S8uEZuGQPeZuHg=;
        b=kkE+oYwYGiPG6gA+SHnxxx6CL0qx1gAm+dD3ndHRka69ssjr6TWOUDFnEnjt5X0vSf
         JHX6IWlxtrcydUMlprcihOl1+o8L+E+cpQ16kt9UOqewdPeyKmV/Jf5Ykaua3xeTkllZ
         iEoBf0MrpY005g9oE7v3+JZY/Hfyy0duXBYFRL6laINsvNt/xDUTUwFQHh1r8I8oL/FG
         lf/Z7wyksvYLdQXXiDgxIIG0gE3caxzLJXjihc0FPq2GFjU1F2lr00x4bk61xino1o/L
         vqfJKIu65WMFavOUu5gH9WjwmZev1M5b029nvqdFoX2brLMJCaKJmT+ov0SaiVJeSOdi
         Hs+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qq9v/CwEi+Cj5N2T1q5iB6l2liWe4S8uEZuGQPeZuHg=;
        b=PzqC81XFi2ZROVI7cmT/pNBFkgVpXtxOLZVmyvWuhHga3hSGUAfkL8k2Cr2gk2NBGM
         9JlU3VE/XMR6gEbeMLko4dYOqDSr8SjJRB92xHQEWBISfEHylMy4wQHz9U8GD99mpeL7
         Jj9u28FIB7kNoCBTch4EVmsk/5Mk6Fg+kl6z7ospbBOPReVxv79X6jYcQ3L2YT83tKtq
         gCxYkVnp+bjpmC8iAF8Mcv+wq1ea6YbaZW8vRFr26yMrn54Az/H27IEluzckOf+JiU/Y
         aK5oxVtUD02Cu4QR9dimLnA7gDm9Dw8C0vNbdLdpZMfdAlq9SClCVcnR4hjBjln28Laq
         IqSA==
X-Gm-Message-State: AOAM533s/0A/iqaxT4KNQzh7XgWd5XgwE1up2wTJhcscomD7r2YHyiqj
        cQYdaiJgHiEjhAPvyJLhhGmZMCXr7Ro=
X-Google-Smtp-Source: ABdhPJwIjwrfGwwY/DIZuDZsjxiH9djjhOfTMydsSTISo/hGtjYqnOok5htaDsD9wdeOsuwbgN3luw==
X-Received: by 2002:adf:eb4b:: with SMTP id u11mr4075768wrn.327.1631699443858;
        Wed, 15 Sep 2021 02:50:43 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.239])
        by smtp.gmail.com with ESMTPSA id c14sm13304319wrr.58.2021.09.15.02.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 02:50:43 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210912162345.51651-1-haoxu@linux.alibaba.com>
 <20210912162345.51651-3-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: fix race between poll completion and
 cancel_hash insertion
Message-ID: <8f4826c9-2234-bea2-cd1c-88a4a8b8d914@gmail.com>
Date:   Wed, 15 Sep 2021 10:50:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210912162345.51651-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
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

Sounds like a valid concern. And the code looks good, but one
of two patches crashed the kernel somewhere in io_read().

./232c93d07b74-test

will be retesting


> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> Didn't find the exact commit to add Fixes: for..

That's ok. Maybe you can find which kernel versions are
affected? So we can add stable and specify where it should
be backported? E.g.

Cc: stable@vger.kernel.org # 5.12+


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
>  	spin_unlock(&ctx->completion_lock);
>  
>  	if (!READ_ONCE(apoll->poll.canceled))
> 

-- 
Pavel Begunkov
