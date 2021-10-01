Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BDC41EF27
	for <lists+io-uring@lfdr.de>; Fri,  1 Oct 2021 16:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238597AbhJAOKI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 10:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbhJAOKH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 10:10:07 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50538C061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 07:08:23 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b8so753580edk.2
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 07:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QkDCBLjtFyT3dezy+lx15TNNkkbZMYgpUEovCSAZB7o=;
        b=ePt8zy+Hdl/x3Nbo0FOFlfGyQGAZrTulbs14N4QDlxetl7lMVw8ivcP6Ad3KyGbrNc
         o5ITBaIEvGgatT8Cb8G2aRQr1KzzjDsDQA0Yda8a1yZtkfPMqQ1Rj8QLO7UoNqrCUtvC
         8ELmyckGwdgQag8MOCtX8f+7lTWbDQDHlAZdMddAb87bGVqO25BlA/p5/wEWVakCiNMh
         Ya3nAa/6daXtr1QV+g3IM2bn2fPsIsQllC+IDMbYfx3Dd1EYyGk/5edRE8MHCpSfipZA
         kwFxPX1ZcJCdFJa0nykQFv9i9DFr/WWhjLq8gngxHhpi+wmBhZQ2+6otAyD3ZrRLSIaS
         s9kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QkDCBLjtFyT3dezy+lx15TNNkkbZMYgpUEovCSAZB7o=;
        b=CIgr7Y3p46E82d57PxJUZy88iKv9vEz/h840TJ2S3RHmns+SmvUqgdU8Fo7Mqrk9+L
         L1TaYzTXXTtvoL46x8Pzgsc6oxqmYolLEPya7DubCnqLDdPCfoo/EHBtG0e3sJRvwdWF
         pFsYCVwCzHn1uBTChacvdqGHrHXQIMlEMkHlWxSvwv+0O9oRw3tKH2EVHSUxRIUBxkp6
         mictzqgOOQUl1AGNiP56xL+WOQa2ouOyIWC0xP8Ic6xGcSiK3uIzNMP3nNjqHpGgGzqJ
         puPH57GsKcg3CpnNE5Pi0oZPeoWjqNv6TW8l49y7LVuY2GD7HYbcsXnOPzkprsfsZX48
         4aFw==
X-Gm-Message-State: AOAM530nI5nzRzGKM/120xLncJDsIqfFhlOnm+5QNZqdzPKC02fgNeSj
        1aQ+CnkuwphvoIUZMFqJp+XIBrHRRUI=
X-Google-Smtp-Source: ABdhPJzQyXGJH+5WDgCwPD408pCJRHeRCn+h1Bmz1N6jsCFO4IlHoWb0z3EcU2mEQbQRkLZ/al1HPw==
X-Received: by 2002:aa7:d649:: with SMTP id v9mr15164998edr.38.1633097301068;
        Fri, 01 Oct 2021 07:08:21 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id l8sm2978635ejn.103.2021.10.01.07.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 07:08:20 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: kill fasync
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <2f7ca3d344d406d34fa6713824198915c41cea86.1633080236.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <75491111-e4fe-59e3-ab4e-827f1a9ebef2@gmail.com>
Date:   Fri, 1 Oct 2021 15:07:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <2f7ca3d344d406d34fa6713824198915c41cea86.1633080236.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/1/21 10:39 AM, Pavel Begunkov wrote:
> We have never supported fasync properly, it would only fire when there
> is something polling io_uring making it useless. Get rid of fasync bits.

Actually, it looks there is something screwed, let's hold on this


> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 17 ++---------------
>  1 file changed, 2 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c6a82c67a93d..f76a9b6bed2c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -398,7 +398,6 @@ struct io_ring_ctx {
>  		struct wait_queue_head	cq_wait;
>  		unsigned		cq_extra;
>  		atomic_t		cq_timeouts;
> -		struct fasync_struct	*cq_fasync;
>  		unsigned		cq_last_tm_flush;
>  	} ____cacheline_aligned_in_smp;
>  
> @@ -1614,10 +1613,8 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
>  		wake_up(&ctx->sq_data->wait);
>  	if (io_should_trigger_evfd(ctx))
>  		eventfd_signal(ctx->cq_ev_fd, 1);
> -	if (waitqueue_active(&ctx->poll_wait)) {
> +	if (waitqueue_active(&ctx->poll_wait))
>  		wake_up_interruptible(&ctx->poll_wait);
> -		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
> -	}
>  }
>  
>  static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
> @@ -1631,10 +1628,8 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
>  	}
>  	if (io_should_trigger_evfd(ctx))
>  		eventfd_signal(ctx->cq_ev_fd, 1);
> -	if (waitqueue_active(&ctx->poll_wait)) {
> +	if (waitqueue_active(&ctx->poll_wait))
>  		wake_up_interruptible(&ctx->poll_wait);
> -		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
> -	}
>  }
>  
>  /* Returns true if there are no backlogged entries after the flush */
> @@ -9304,13 +9299,6 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
>  	return mask;
>  }
>  
> -static int io_uring_fasync(int fd, struct file *file, int on)
> -{
> -	struct io_ring_ctx *ctx = file->private_data;
> -
> -	return fasync_helper(fd, file, on, &ctx->cq_fasync);
> -}
> -
>  static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
>  {
>  	const struct cred *creds;
> @@ -10155,7 +10143,6 @@ static const struct file_operations io_uring_fops = {
>  	.mmap_capabilities = io_uring_nommu_mmap_capabilities,
>  #endif
>  	.poll		= io_uring_poll,
> -	.fasync		= io_uring_fasync,
>  #ifdef CONFIG_PROC_FS
>  	.show_fdinfo	= io_uring_show_fdinfo,
>  #endif
> 

-- 
Pavel Begunkov
