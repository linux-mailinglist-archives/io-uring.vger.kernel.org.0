Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BCC38DA81
	for <lists+io-uring@lfdr.de>; Sun, 23 May 2021 10:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhEWI22 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 May 2021 04:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbhEWI21 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 May 2021 04:28:27 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE75C061574;
        Sun, 23 May 2021 01:27:00 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z17so25232179wrq.7;
        Sun, 23 May 2021 01:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VnRgGyjPltivJLPVgRyKlZ0TLQYMwBTajDy9FGMry3Q=;
        b=jB68xjHz9ASO/c4S33JI/f0mBUkkVz4exO8LO4tMg8fQ6T0A8P98Lj4xt02Nq9JeHf
         l23O7emZlX3hEmNU+wPv6I1OklZczIn/MxuBOonIOhpf9tqztsHkWzEXkZw7bm2gNhQO
         ZwX7bzqSmE8WJb8D7rTtubDG1RdyZRbSMReL3zUJlFjuvveF1hZTipKjzrWjFBHZHi21
         Xnei5IaENl4ai0SNEQXzvPAEHsxAva5hYsLgSkLaJ0K5cXpzPoBW/hQANh97e1ME8qEP
         HaKpW26BixIAo6cK0ThJrMMEpieqzkiMwSqwe/rzdOVxAloRN97HSfesV7WQV2JN18Rf
         XmHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VnRgGyjPltivJLPVgRyKlZ0TLQYMwBTajDy9FGMry3Q=;
        b=BP15GUWyY7zjqhKwIX3ikqmukt/qwnQ41fB+g6PAp9eVLI0F8sLHZCGc9QCfk3nsNC
         8fG+lRYG1D7Y8SulxZXgZPhni+6vgvS43jqfr6j6gCp4K/d1urUnskhxY/3Ms/YBBi1K
         w8omLIJVPgvj/3tgI0p41ngHbEib3xCEdv9DNvMsEgqvxvVwy89OunmIM6RAyOQp0YXL
         +R8Na5nQfmMUh7fdV33wcyNrMZ+YZVgdTKXAuz5L4frZFfwdItaSHAbcp8HDLmhpzy20
         7A1QQymHvnjNFdwyPpW/uN/YNUEwjoPm5XrpQjwQ0SXZs0oGPcF2U6hr579dTdlUeXmY
         xlNw==
X-Gm-Message-State: AOAM531/1j3CL9M6JzEZcGzYTO5vUjvn/kB4F7bGgdBqP0xlrf0ITIlt
        okEp8UOzM4sRvQQ+hSjSYQbzT8HJBGuRPPqA
X-Google-Smtp-Source: ABdhPJwpt/s1AZpN5Nsv8eGLZIHeDYfX0Q0/Vi13Emn/+cumSafRkq3wMqGUi8r0cLlndaNOY+7bmg==
X-Received: by 2002:a5d:6587:: with SMTP id q7mr2374437wru.99.1621758419296;
        Sun, 23 May 2021 01:26:59 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.65])
        by smtp.gmail.com with ESMTPSA id b8sm8080533wrx.15.2021.05.23.01.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 May 2021 01:26:58 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60a9e208.1c69fb81.1f879.b57bSMTPIN_ADDED_MISSING@mx.google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: Delay io_wq creation to avoid unnecessary
 creation
Message-ID: <870d55a1-97a2-6fa2-24c1-3ac214b19bb4@gmail.com>
Date:   Sun, 23 May 2021 09:26:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <60a9e208.1c69fb81.1f879.b57bSMTPIN_ADDED_MISSING@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/22/21 9:16 PM, Olivier Langlois wrote:
> Create the io_wq when we know that it is needed because the task
> will submit sqes.
> 
> This eliminates a lot iou-mgr threads creation and memory allocation
> in those 2 scenarios:
> 
> - A thread actually calling io_uring_enter() to submit sqes is not
>   the same thread that has created the io_uring instance
>   with io_uring_setup()
> - Every use cases where no sqe submission is performed (most SQPOLL setup)
> 
> The benefits is less memory allocation and less context switching of
> io-mgr threads that will never have anything useful to do and the only cost
> is an extra condition evaluation in io_uring_enter().

1) there is no more io-mgr (5.13)

2) you move that from what is considered slow path into a hotter
place, that is not fine.

So I wouldn't care about it

> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  fs/io_uring.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5f82954004f6..a01ae25d7c60 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7881,6 +7881,18 @@ static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
>  	return io_wq_create(concurrency, &data);
>  }
>  
> +static int io_uring_alloc_wq_offload(struct io_uring_task *tctx,
> +				     struct io_ring_ctx *ctx)
> +{
> +	int ret = 0;
> +
> +	tctx->io_wq = io_init_wq_offload(ctx);
> +	if (IS_ERR(tctx->io_wq))

will be disastrous if you don't clear tctx->io_wq

> +		ret = PTR_ERR(tctx->io_wq);
> +
> +	return ret;
> +}
> +

-- 
Pavel Begunkov
