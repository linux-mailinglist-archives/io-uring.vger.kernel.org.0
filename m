Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353FD36946C
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 16:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhDWOMb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Apr 2021 10:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbhDWOMa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Apr 2021 10:12:30 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065AAC061574
        for <io-uring@vger.kernel.org>; Fri, 23 Apr 2021 07:11:54 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id e7so39586925wrs.11
        for <io-uring@vger.kernel.org>; Fri, 23 Apr 2021 07:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t9EbI1PDI6EZj8PQ2N+Xk0uN/rsbxe1bUqf1DKTAJjA=;
        b=pK2WYDLmpdGgSGVkQWhgbaDIJQH3G356nI1USjCpqmlec/X/on7735g2vRPNV4YRW5
         g7L6YeqBaaa5QtTAl3HYE71AK5CpA1FMhNzBmnVPkaqVFrQj8MZ5IYvqmOUVCIeraVkU
         aavqB+xK596sPFweYbDcbCjh2xljFOodEg7mif/oevXQdOqVR82jbpOmfCbZR+vd+Heu
         vPG5A6+FGn+uFBB7dkhJGpVo3bp939yN7HnVacZidj4elmkoXdBShKLiw3FmL5xPjGMJ
         DKM2PXhTY3a5N+R65j4RXNoA6zaeY1UTccLxb/9G1DjeyOFxDhFQK4aAVCSQajXnz7EJ
         6OWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t9EbI1PDI6EZj8PQ2N+Xk0uN/rsbxe1bUqf1DKTAJjA=;
        b=PE0JFG+J7HhL0FVXU2NP7TjeOdn8O9czkGbTyXKqVxc/Qgd9IJqvYHFffmWSl8jz0d
         45Ts5xRhgCpio9dBGIWQqmU2mA+n3IJpRd2xQ7x0ORH6glUkE/AdaKATXlWbR6g5KfdK
         L1VbG/vhXHPMTtmmDB4zmITI/InhI/+XZT17BqZ8yPBkZeKKyfheitWSPyDys+BH4v/Q
         A38et5SyuPoarAjHuGnlRYwPthV5sTZi1KDv24fCVwjW66qYL3/n2TM4U67Rz97QSR49
         CgcH4lk1MV3SnEs/SUcKAf2Jrg5DmJizHimHOCXrKKJNmaAn5H+RcwXmvSAZdunwudtC
         1tJw==
X-Gm-Message-State: AOAM531w3T/gjgmkUt2YCJPZ3nDLhXbizc9Jpc8Afci1GPmZHUoV2rli
        pmsCw5j/8fc1akyLHF9mscJdLneXpKP51g==
X-Google-Smtp-Source: ABdhPJyY3YIFreWKtklukZdNrA503AkQXDWPauakshQdGlRsXV/sZQWpQvW2YCVlr9g6huq+fimlBw==
X-Received: by 2002:adf:ce12:: with SMTP id p18mr5079081wrn.144.1619187112768;
        Fri, 23 Apr 2021 07:11:52 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id e9sm9460892wrs.84.2021.04.23.07.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 07:11:52 -0700 (PDT)
Subject: Re: [PATCH] io_uring: check sqring and iopoll_list before shedule
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619018351-75883-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <88b94017-ab33-510a-b8c7-c1f3c6eb9d70@gmail.com>
Date:   Fri, 23 Apr 2021 15:11:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <1619018351-75883-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/21/21 4:19 PM, Hao Xu wrote:
> do this to avoid race below:
> 
>          userspace                         kernel
> 
>                                |  check sqring and iopoll_list
> submit sqe                     |
> check IORING_SQ_NEED_WAKEUP    |
> (which is not set)    |        |
>                                |  set IORING_SQ_NEED_WAKEUP
> wait cqe                       |  schedule(never wakeup again)

Agree, the flag should be set first.
Haven't tried it, but the patch looks reasonable

> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> Hi all,
> I'm doing some work to reduce cpu usage in low IO pression, and I
> removed timeout logic in io_sq_thread() to do some test with fio-3.26,
> I found that fio hangs in getevents, inifinitely trying to get a cqe,
> While sq-thread is sleeping. It seems there is race situation, and it
> is still there even after I fix the issue described above in the commit
> message. I doubt it is something to do with memory barrier logic
> between userspace and kernel, I'm trying to address it, not many clues
> for now.
> I'll send the fio config and kernel modification I did for test in
> following mail soon.
> 
> Thanks,
> Hao
> 
>  fs/io_uring.c | 36 +++++++++++++++++++-----------------
>  1 file changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index dff34975d86b..042f1149db51 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6802,27 +6802,29 @@ static int io_sq_thread(void *data)
>  			continue;
>  		}
>  
> -		needs_sched = true;
>  		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
> -		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> -			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
> -			    !list_empty_careful(&ctx->iopoll_list)) {
> -				needs_sched = false;
> -				break;
> -			}
> -			if (io_sqring_entries(ctx)) {
> -				needs_sched = false;
> -				break;
> -			}
> -		}
> -
> -		if (needs_sched && !test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state)) {
> +		if (!test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state)) {
>  			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>  				io_ring_set_wakeup_flag(ctx);
>  
> -			mutex_unlock(&sqd->lock);
> -			schedule();
> -			mutex_lock(&sqd->lock);
> +			needs_sched = true;
> +			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> +				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
> +				    !list_empty_careful(&ctx->iopoll_list)) {
> +					needs_sched = false;
> +					break;
> +				}
> +				if (io_sqring_entries(ctx)) {
> +					needs_sched = false;
> +					break;
> +				}
> +			}
> +
> +			if (needs_sched) {
> +				mutex_unlock(&sqd->lock);
> +				schedule();
> +				mutex_lock(&sqd->lock);
> +			}
>  			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>  				io_ring_clear_wakeup_flag(ctx);
>  		}
> 

-- 
Pavel Begunkov
