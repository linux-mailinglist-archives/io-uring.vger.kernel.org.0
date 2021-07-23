Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDAA3D3BCC
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 16:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhGWNvC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 09:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbhGWNvB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 09:51:01 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC90C061575
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 07:31:35 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id o1so2601066wrp.5
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 07:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eVMgIN/nAzz+ChT6EkluzCShD0Jd+/LswYzIsKYMKpQ=;
        b=gpwXGIpqOISZDaN0r1HkCZ6LS71aZ7fjKOraObDnGDhCLiIFrPO4F5d4J9FCUc+Hu/
         uvb7IrCOYjmTZbdkWMattamq973q/SDWZEo2P0a0adJbbE3Cb2ggV7Y2YDeChRd1n4fN
         CkSiyjnBQqvoTPSojTY5Z5FfWszJvoL136WCw/4SUOsjycZpZXIm+qxxG/eu5WpWpLgY
         nBBSfck/NYTfOYKJmLkx+jw0WbQ0YOYx8lvgHClbHj6UlA6fGxdSuUcElgWuNon+Plin
         8Lb78GrgqWYIG18K5m5JetSWa9qDxk/9CLasa9kKkKavkq/Ob9zsI5nLDQkssX91gr2D
         zhrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eVMgIN/nAzz+ChT6EkluzCShD0Jd+/LswYzIsKYMKpQ=;
        b=mY/VEmjEHloQ6mTgt1HVRQocFdpRUyuekk9fHJcH3VWSD3qtXl6QXuYyHTAsX2zymC
         PjyWTizYS6II/kWXtIdeuPL/ldrOKH/RAOWc9CTfBshDaGh7cD+TMnI8cLJ5rPWH3Tfo
         W8+7SpA8s045KqtjYcF9vyPy9tk8Q3W2oT/eW6Mt8pIhLS168ZVJGiq8JfZ19Mv954o8
         lphKJ2fpe/KtElzpGgl2PWzHKOzsMXoH8uuEmlWItdUOqxA0yZhRbTX3y8iHVZ8IOPQu
         jF41lAGCKAws3V9mkBh27LnJe3llF/CtuR2xMM2dG2NKq0ZdbUXv51Lw0f0K40Rfhv4b
         GttQ==
X-Gm-Message-State: AOAM530EZyMmaQ7nH5LQgnDTWrvOqtFKo7oZzLiNnSmM59tzXs4pIR4V
        qLP+E/5f4+cT6D2GvWwlXwY=
X-Google-Smtp-Source: ABdhPJzLBc3bqIWsH2Z7VZIljeoAaq4H4oy1i1fc2XXbkGu9cb7ntgYJJF1MKKHSbkzttarDxxzzpQ==
X-Received: by 2002:a05:6000:154c:: with SMTP id 12mr5706637wry.393.1627050693826;
        Fri, 23 Jul 2021 07:31:33 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.234.52])
        by smtp.gmail.com with ESMTPSA id n5sm26289676wrp.80.2021.07.23.07.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 07:31:33 -0700 (PDT)
Subject: Re: [PATCH io_uring-5.14 v2] io_uring: remove double poll wait entry
 for pure poll
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210723092227.137526-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <c628d5bc-ee34-bf43-c7bc-5b52cf983cb1@gmail.com>
Date:   Fri, 23 Jul 2021 15:31:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210723092227.137526-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/21 10:22 AM, Hao Xu wrote:
> For pure poll requests, we should remove the double poll wait entry.
> And io_poll_remove_double() is good enough for it compared with
> io_poll_remove_waitqs().

5.14 in the subject hints me that it's a fix. Is it?
Can you add what it fixes or expand on why it's better?


> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> v1-->v2
>   delete redundant io_poll_remove_double()
> 
>  fs/io_uring.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f2fe4eca150b..c5fe8b9e26b4 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4903,7 +4903,6 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
>  	if (req->poll.events & EPOLLONESHOT)
>  		flags = 0;
>  	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
> -		io_poll_remove_waitqs(req);
>  		req->poll.done = true;
>  		flags = 0;
>  	}
> @@ -4926,6 +4925,7 @@ static void io_poll_task_func(struct io_kiocb *req)
>  
>  		done = io_poll_complete(req, req->result);
>  		if (done) {
> +			io_poll_remove_double(req);
>  			hash_del(&req->hash_node);
>  		} else {
>  			req->result = 0;
> @@ -5113,7 +5113,7 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
>  		ipt->error = -EINVAL;
>  
>  	spin_lock_irq(&ctx->completion_lock);
> -	if (ipt->error)
> +	if (ipt->error || (mask && (poll->events & EPOLLONESHOT)))
>  		io_poll_remove_double(req);
>  	if (likely(poll->head)) {
>  		spin_lock(&poll->head->lock);
> @@ -5185,7 +5185,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>  	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
>  					io_async_wake);
>  	if (ret || ipt.error) {
> -		io_poll_remove_double(req);
>  		spin_unlock_irq(&ctx->completion_lock);
>  		if (ret)
>  			return IO_APOLL_READY;
> 

-- 
Pavel Begunkov
