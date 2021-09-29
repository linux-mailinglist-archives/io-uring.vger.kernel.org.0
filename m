Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3D941C334
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 13:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245656AbhI2LQD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 07:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245644AbhI2LQD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 07:16:03 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307A8C06161C
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 04:14:22 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id f78-20020a1c1f51000000b0030cdb3d6079so1448555wmf.3
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 04:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MsSAHStKVmqmTpdmhzG4xJObv/y2gnBF0y0F2EHJMHE=;
        b=hi0uA1oY/O3xv432HUbgATfqU6YwlDBOcyG50Qx8QzFGWdKP5Hjpy2WnfTzuEQThke
         /9+z1I2lDqhFd/XLzpnldVWTuDTmWGYnU4wa7cZ0WGOjy/iS6Iazf5+aVDpp9eORqvgZ
         abWdPgoWr1pI9ye1tlx9qvUqKcK3y0T/XBS8HfhZn1ZggOQLwdvTst1n2LGq5BeJAN28
         XMIeqb9H+eyVqjwPiRa0nQ5ooNC2Zmh2E+EOPY8eOMZ085H0UOaJ8NTWusMfS3+JPXmb
         MmodrYIsCSxtTvoP1Crg/+QBC8DgWsk5HZW/Zw+L6kmkWVeW9hRrOn65i5uXKAJxPu3O
         1EEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MsSAHStKVmqmTpdmhzG4xJObv/y2gnBF0y0F2EHJMHE=;
        b=Ygd/uC47Ao3+1td+8g6dSEyEP8MaDpBEK/GnjRlV9cEhcakTTWeBcfKzILbxPn5kgw
         9WeUUOvBuJr3tgXwItvtszwSkjmATdScRU45SXooNp3XE7NWE73kd3PFr13PtWrFpJuF
         ZQZLfxN76mVSitghPcGcSSy2PhsPbkaVyzTHnJrjo7vuRes8qfyYDJ/xs/UUm75r4Nw+
         UgsfZz/NqfezEVm8U5z6oyT5Spnv5mYGaH3O6mY604hXQW0brCIffXm+P3Ot/6mLRIjH
         Jcckej1np7cf09PG7VDcwnpdECSgMVLOhtQSZs1sX0BK5mEfyVO3X7OZC7D0wNo0CNMT
         Bltg==
X-Gm-Message-State: AOAM532Vr73KbO1MX/egY0VDNJ/owv9J6GGKwmS+T7OavGNLUaw/TKp2
        Js2ikm4FEzoWsf2KUk1e4BU=
X-Google-Smtp-Source: ABdhPJz6QlweQWCneKi8/cOf4PJX0QEsqxT5kkit4ZuF8PCyh9jAqT6yJh1khDCz9ZoAqlGc/EkhYg==
X-Received: by 2002:a05:600c:4f83:: with SMTP id n3mr9657574wmq.114.1632914060817;
        Wed, 29 Sep 2021 04:14:20 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.229])
        by smtp.gmail.com with ESMTPSA id o16sm1951845wrx.11.2021.09.29.04.14.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 04:14:20 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210927123600.234405-1-haoxu@linux.alibaba.com>
 <20210927123600.234405-3-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: fix tw list mess-up by adding tw while it's
 already in tw list
Message-ID: <513c3482-0d46-fd6a-2ee5-fe2b0b060105@gmail.com>
Date:   Wed, 29 Sep 2021 12:13:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210927123600.234405-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/27/21 1:36 PM, Hao Xu wrote:
> For multishot mode, there may be cases like:
> io_poll_task_func()
> -> add_wait_queue()
>                             async_wake()
>                             ->io_req_task_work_add()
>                             this one mess up the running task_work list
>                             since req->io_task_work.node is in use.

By the time req->io_task_work.func() is called, node->next is undefined
and free to use. io_req_task_work_add() will override it without looking
at a prior value and that's fine, as the calling code doesn't touch it
after the callback.

> similar situation for req->io_task_work.fallback_node.
> Fix it by set node->next = NULL before we run the tw, so that when we
> add req back to the wait queue in middle of tw running, we can safely
> re-add it to the tw list.

I might be missing what is the problem you're trying to fix. Does the
above makes sense? It doesn't sound like node->next=NULL can solve
anything.

> Fixes: 7cbf1722d5fc ("io_uring: provide FIFO ordering for task_work")
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d0b358b9b589..f667d6286438 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1250,13 +1250,17 @@ static void io_fallback_req_func(struct work_struct *work)
>  	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
>  						fallback_work.work);
>  	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
> -	struct io_kiocb *req, *tmp;
> +	struct io_kiocb *req;
>  	bool locked = false;
>  
>  	percpu_ref_get(&ctx->refs);
> -	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
> +	req = llist_entry(node, struct io_kiocb, io_task_work.fallback_node);
> +	while (member_address_is_nonnull(req, io_task_work.fallback_node)) {
> +		node = req->io_task_work.fallback_node.next;
> +		req->io_task_work.fallback_node.next = NULL;
>  		req->io_task_work.func(req, &locked);
> -
> +		req = llist_entry(node, struct io_kiocb, io_task_work.fallback_node);
> +	}
>  	if (locked) {
>  		io_submit_flush_completions(ctx);
>  		mutex_unlock(&ctx->uring_lock);
> @@ -2156,6 +2160,7 @@ static void tctx_task_work(struct callback_head *cb)
>  				locked = mutex_trylock(&ctx->uring_lock);
>  				percpu_ref_get(&ctx->refs);
>  			}
> +			node->next = NULL;
>  			req->io_task_work.func(req, &locked);
>  			node = next;
>  		} while (node);
> 

-- 
Pavel Begunkov
