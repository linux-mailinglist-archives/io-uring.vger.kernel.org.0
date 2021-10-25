Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CCE439290
	for <lists+io-uring@lfdr.de>; Mon, 25 Oct 2021 11:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhJYJjH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 05:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbhJYJiF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 05:38:05 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DADC061348
        for <io-uring@vger.kernel.org>; Mon, 25 Oct 2021 02:35:43 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id v1-20020a17090a088100b001a21156830bso4448669pjc.1
        for <io-uring@vger.kernel.org>; Mon, 25 Oct 2021 02:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dmstARMYSTJ8DtvpvL8rpNbhDbZD5A9wUdgXGid1a0w=;
        b=WKtnToxcWjgISuj2nrTwT4xxap0aJ8y/p0alvOyLrmBGU33Dwe6YUv3SLuZPfxqCwX
         9TW7ITrmDaBZzs8o9dfFTJ/aF2MkRLO38flHxxOGtR7cEiDWOUTCQdYi+xXjs36UDMec
         C5cBJLQ3C/VTvVY+JXIbRj7jC/r5izLjNUsaacM3vg4WAroP/HMWWC5+jGeWTKuTr7nn
         BFQa1pHqVzh2oAwI9DiQY6hp0Wa/6KFYiCm9Hbl65zMybqX1E+hiKYKHp6QQC7J2tXmZ
         QzFksfPceBppK0mgACefF1M2UkMVW+6M5HWdKLrmeD8jpmsjC3VdpFXOj5yf+YHWwxtN
         F+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dmstARMYSTJ8DtvpvL8rpNbhDbZD5A9wUdgXGid1a0w=;
        b=IIVtBCYkqbWARXX7tqLuUQfDkNRBaWqT0h7YL+u5HWzTp3O7z4KYqHzgUqKKWx2rE9
         OqY0b6+hVKEpspksGfhLgfSwHlcJ29BWcJPjh7Rm9UfGYGRoqqeNDPz5NJJFkUWT4y49
         kaFuKR/4d1+4vqYITv6yysgaZWg6qA0qUu8YSUVmgheWzZiCZ11tHtppPtYtRi5Ezk3v
         c1SeCMevD/kJEy/9xEO6+iH7JLct2fcSWM4owjjWFnUi10nXNUHwGC1RuuZt8m8GcpTY
         q8Z/XNguEsWRCHcbt2rYeI5TIR7eDSRl6k7tXVHmfpeI8uBB1OBlSvSbR1JI4UtnlooZ
         fm/g==
X-Gm-Message-State: AOAM530nL+ch4mdlBQn5N9NliH9PYQBFScvdHo2yOz3F04cZWb+fTPNg
        +iAGf1YT/Z47dOwGfVV9lTE=
X-Google-Smtp-Source: ABdhPJzr//jTjHbUaC9hZPCjUwLZdM9PgFDH+qgJoINyxfgzyha6uC2D5tbRRxbX52e5xB0OS4/Fgw==
X-Received: by 2002:a17:90a:312:: with SMTP id 18mr34974179pje.178.1635154542662;
        Mon, 25 Oct 2021 02:35:42 -0700 (PDT)
Received: from [192.168.1.122] ([122.181.48.19])
        by smtp.gmail.com with ESMTPSA id u193sm15157959pgc.34.2021.10.25.02.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 02:35:42 -0700 (PDT)
Message-ID: <3620362e-171a-079e-1343-2ffdbd903996@gmail.com>
Date:   Mon, 25 Oct 2021 15:05:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v3 1/3] io_uring: refactor event check out of
 __io_async_wake()
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
References: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
 <20211025053849.3139-2-xiaoguang.wang@linux.alibaba.com>
From:   Praveen Kumar <kpraveen.lkml@gmail.com>
In-Reply-To: <20211025053849.3139-2-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25-10-2021 11:08, Xiaoguang Wang wrote:
> Which is a preparation for following patch, and here try to inline
> __io_async_wake(), which is simple and can save a function call.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 736d456e7913..18af9bb9a4bc 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5228,13 +5228,9 @@ struct io_poll_table {
>  	int error;
>  };
>  
> -static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
> +static inline int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
>  			   __poll_t mask, io_req_tw_func_t func)
>  {
> -	/* for instances that support it check for an event match first: */
> -	if (mask && !(mask & poll->events))
> -		return 0;
> -

Is it possible to keep this check as it is, and make the __io_async_wake function inline ONLY ?
As I can see, the callers doing the same checks at different places ?
Also, there could be a possibility that, this check may get missed in new caller APIs introduced in future.

>  	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
>  
>  	list_del_init(&poll->wait.entry);
> @@ -5508,11 +5504,16 @@ static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>  {
>  	struct io_kiocb *req = wait->private;
>  	struct io_poll_iocb *poll = &req->apoll->poll;
> +	__poll_t mask = key_to_poll(key);
>  
>  	trace_io_uring_poll_wake(req->ctx, req->opcode, req->user_data,
>  					key_to_poll(key));
>  
> -	return __io_async_wake(req, poll, key_to_poll(key), io_async_task_func);
> +	/* for instances that support it check for an event match first: */
> +	if (mask && !(mask & poll->events))
> +		return 0;
> +
> +	return __io_async_wake(req, poll, mask, io_async_task_func);
>  }
>  
>  static void io_poll_req_insert(struct io_kiocb *req)
> @@ -5772,8 +5773,13 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>  {
>  	struct io_kiocb *req = wait->private;
>  	struct io_poll_iocb *poll = &req->poll;
> +	__poll_t mask = key_to_poll(key);
> +
> +	/* for instances that support it check for an event match first: */
> +	if (mask && !(mask & poll->events))
> +		return 0;
>  
> -	return __io_async_wake(req, poll, key_to_poll(key), io_poll_task_func);
> +	return __io_async_wake(req, poll, mask, io_poll_task_func);
>  }
>  
>  static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
> 

Regards,

~Praveen.
