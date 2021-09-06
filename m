Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC0F40203D
	for <lists+io-uring@lfdr.de>; Mon,  6 Sep 2021 21:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243572AbhIFTGR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 15:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343760AbhIFTFv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 15:05:51 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF31C0613C1
        for <io-uring@vger.kernel.org>; Mon,  6 Sep 2021 12:04:46 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n5so11077100wro.12
        for <io-uring@vger.kernel.org>; Mon, 06 Sep 2021 12:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rLDEnaopW8Wpvvvt30r6PMjkqudAeyqWBRWIFXJ9nx4=;
        b=OQu2qB+h+DZkfGHcTWb4V7t6Twxp4Bi/SUSCLiN1N8phPsuQaH1DZJg1KgDxGaxtDX
         lzo0KUzCT5d2IWwyA0BcL/ZW4rQHdF2VitNbcHh1xTNyenu1e9P6Fcn9dC4DGsG06U6N
         Q2YGBf4o2rJKYqKMfnT2MXVBp9d9GtJIom8EFTGx14g/3Ogwh3ZuEpT/YS69RpsBuVC/
         489t6EWU8xgSsoeCqgFEdP21MWkS08GPYk2uhH5Tl3XGKsFQ2WZ463dsiCUhDdqNcRRe
         sIqGqWZ6t0+2gQg+nS6CoGCnZNfdbEItqQVEwfnZq8QYJN8P8YzT7p3TphS6D8grUzKf
         hX2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rLDEnaopW8Wpvvvt30r6PMjkqudAeyqWBRWIFXJ9nx4=;
        b=Eu7WUVFq9cmlMN8SmYo7GEoTY+cz9RcXBkEZYnQyV5ySB9vbYzscF3iWWYn/NErwX0
         5pEPmeMR43UgYUn+IaKhNPmvZJDnzCmBzKwTqO23k2yPDU2HhCTngj8knGCU5OKK9d23
         olVZsiA9afe4bQkcV1k3MHL4Y3nXyF4IOKkvfjmeNz1aAIfGu+Vqhe/q4BxGZ3AAF5kb
         9g+D2laZGo83O/PzfoXGPyvVSMXRHQVpPoor5zwGAKO8dMpy91LgRPV9DDZAe4dmaL2x
         q1zmACdezIEA+JZW8rzi6TJeq+uwhgqcJX7t19FcNpOHPMOkguODYdqYjLP55ioX+3Ni
         3QgA==
X-Gm-Message-State: AOAM533I2XVNhR3pkBk8PFdrdP+FGgUm+5ubZcvlE7HeF54jtbLfEprr
        R+8RDoeTLbIcWjLaEpZjb3s=
X-Google-Smtp-Source: ABdhPJxJZKufDc6YmfTtWChjeta5bF5BQIsf9css1ngI8AkQJFrZSP/6wLsZnHeItIa7fSBsmpltRw==
X-Received: by 2002:adf:c44b:: with SMTP id a11mr14949579wrg.416.1630955085054;
        Mon, 06 Sep 2021 12:04:45 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.4])
        by smtp.gmail.com with ESMTPSA id z19sm415968wma.0.2021.09.06.12.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 12:04:44 -0700 (PDT)
Subject: Re: [PATCH 4/6] io_uring: let fast poll support multishot
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-5-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <9a8efd19-a320-29a4-7132-7b5ae5b994ff@gmail.com>
Date:   Mon, 6 Sep 2021 20:04:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210903110049.132958-5-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/21 12:00 PM, Hao Xu wrote:
> For operations like accept, multishot is a useful feature, since we can
> reduce a number of accept sqe. Let's integrate it to fast poll, it may
> be good for other operations in the future.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d6df60c4cdb9..dae7044e0c24 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5277,8 +5277,15 @@ static void io_async_task_func(struct io_kiocb *req, bool *locked)
>  		return;
>  	}
>  
> -	hash_del(&req->hash_node);
> -	io_poll_remove_double(req);
> +	if (READ_ONCE(apoll->poll.canceled))
> +		apoll->poll.events |= EPOLLONESHOT;
> +	if (apoll->poll.events & EPOLLONESHOT) {
> +		hash_del(&req->hash_node);
> +		io_poll_remove_double(req);
> +	} else {
> +		add_wait_queue(apoll->poll.head, &apoll->poll.wait);

It looks like it does both io_req_task_submit() and adding back
to the wq, so io_issue_sqe() may be called in parallel with
io_async_task_func(). If so, there will be tons of all kind of
races.

> +	}
> +
>  	spin_unlock(&ctx->completion_lock);
>  
>  	if (!READ_ONCE(apoll->poll.canceled))
> @@ -5366,7 +5373,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>  	struct io_ring_ctx *ctx = req->ctx;
>  	struct async_poll *apoll;
>  	struct io_poll_table ipt;
> -	__poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
> +	__poll_t ret, mask = POLLERR | POLLPRI;
>  	int rw;
>  
>  	if (!req->file || !file_can_poll(req->file))
> @@ -5388,6 +5395,8 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>  		rw = WRITE;
>  		mask |= POLLOUT | POLLWRNORM;
>  	}
> +	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
> +		mask |= EPOLLONESHOT;
>  
>  	/* if we can't nonblock try, then no point in arming a poll handler */
>  	if (!io_file_supports_nowait(req, rw))
> 

-- 
Pavel Begunkov
