Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835F836A3A4
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 02:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhDYAEN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Apr 2021 20:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhDYAEL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Apr 2021 20:04:11 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58492C061574
        for <io-uring@vger.kernel.org>; Sat, 24 Apr 2021 17:03:32 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id y124-20020a1c32820000b029010c93864955so3155403wmy.5
        for <io-uring@vger.kernel.org>; Sat, 24 Apr 2021 17:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4bz2irb1eztNR3NeMQ86Ph1SzjfjdpTRqfmILy1bmMc=;
        b=jGO30GUcovd04+8dP+wsPIIKWCkv+eTZ3HHmcf+j3u0xNE/YF4O81IUMjxpJ+YDkzC
         Ub067O8FsV0WhhaLrFaPxKdaZiROrKoC66P3+vsopSyJf61UN6n/p3ZsjLa6cXiKJNEV
         xLLZh+2mzPHpmLYtf4qekxNBWtbKktwTIi75rMKAqEREIWYUxW56QRsDJL/kgTPMlBT1
         JaqPLcG9dj6pJ4Uz9Hc9LlZpBiPqYR32LrVnRFzYfdYNbL4DJcsGCdpZAWQ6t9AL5gsy
         tW7jzqLxjfbZBcMyFEnoxCNU+iE00ICKudIuC4TPYfaFg6ag6pcl5X3LYjMfkpLGOaD0
         D5IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4bz2irb1eztNR3NeMQ86Ph1SzjfjdpTRqfmILy1bmMc=;
        b=DNZ3r8p5nqQSr7aYcbQg6+ZPVgY4ghtf3LpFpCpLjh9mSILUk19INlIYdgffxOujyV
         opzBwvY2u58cjGb1iWcdkkg4P4mhesm0DfucYB1mEIDWtLK/cbnR4YTQX2lMFqQYFmwZ
         6vI7dPstKbuWp6tb7VnHc72WY90qmRV/R+AGwqDsybgVyAdons0fegORmJUb4/s+N9dn
         d18mqFNp0OiEkcqgxDofr7ZAWeHeiniU9439jy0B0lby/cFJw1GH1xbGWC1fRQf8xjz4
         DwcuALsvZGtleFEdEQ/ExF0gnovlaoT0Whc7tLqi3hWAHa/VVZdUU4HlGXXNyG2Lr/SM
         o7fw==
X-Gm-Message-State: AOAM531eAN+EWhENboSs8qrv43tOmFwFn6aw714UvoLZ6p/1Ay+/Y1UD
        ugGoa0+sYRYuTKiBPbvpuJo=
X-Google-Smtp-Source: ABdhPJyUwkn3ziAcCS4VFPxoWfDBH6BXMFnw5c9RKSmuBBGABoe4nm4lT328NaF/vc7homnfBAXZ1A==
X-Received: by 2002:a1c:dd46:: with SMTP id u67mr4367462wmg.66.1619309010843;
        Sat, 24 Apr 2021 17:03:30 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id f1sm14131572wru.60.2021.04.24.17.03.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Apr 2021 17:03:30 -0700 (PDT)
Subject: Re: [PATCH] io_uring: update sq_thread_idle after ctx deleted
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619256380-236460-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <3d5b166a-b093-9bd5-7553-cadff7b2a41b@gmail.com>
Date:   Sun, 25 Apr 2021 01:03:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <1619256380-236460-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/24/21 10:26 AM, Hao Xu wrote:
> we shall update sq_thread_idle anytime we do ctx deletion from ctx_list

looks good, a nit below

> 
> Fixes:734551df6f9b ("io_uring: fix shared sqpoll cancellation hangs")
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 40f38256499c..15f204274761 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8867,6 +8867,7 @@ static void io_sqpoll_cancel_cb(struct callback_head *cb)
>  	if (sqd->thread)
>  		io_uring_cancel_sqpoll(sqd);
>  	list_del_init(&work->ctx->sqd_list);
> +	io_sqd_update_thread_idle(sqd);
>  	complete(&work->completion);
>  }
>  
> @@ -8877,7 +8878,6 @@ static void io_sqpoll_cancel_sync(struct io_ring_ctx *ctx)
>  	struct task_struct *task;
>  
>  	io_sq_thread_park(sqd);
> -	io_sqd_update_thread_idle(sqd);
>  	task = sqd->thread;
>  	if (task) {
>  		init_completion(&work.completion);
> @@ -8886,6 +8886,7 @@ static void io_sqpoll_cancel_sync(struct io_ring_ctx *ctx)
>  		wake_up_process(task);
>  	} else {
>  		list_del_init(&ctx->sqd_list);
> +		io_sqd_update_thread_idle(sqd);

Not actually needed, it's already dying.

>  	}
>  	io_sq_thread_unpark(sqd);
>  
> 

-- 
Pavel Begunkov
