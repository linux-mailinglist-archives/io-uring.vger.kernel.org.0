Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A8736F25E
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 00:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhD2WDP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 18:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhD2WDO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 18:03:14 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5F0C06138B
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 15:02:27 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h4so59353053wrt.12
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 15:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kyNlNjvQ/w/GUzvjJjynHeFWBdohS+TSm31t+y9gU24=;
        b=dzJsltVeUjd7aWgDo6SzGFDGX+Ne0jya2qqk5mu3pRd2oZ3MqRIeeuouKSmDe6pRdG
         rYd0ex2HhvskK4RDioLA2rvrQw2c/rIEyE08uK4inJfJcDDk17NWjmyJWu9JpDm8Zdjd
         fzxMAULdBcMqu04Ph27JsjC5CmuKS6WXXNuDxvpXIo7exI7diV1Grhh5fRp30r/6dj+w
         LYrGEB57JBANIgHYSfSSDWhEzNCyfAiYybCvaAeGl7ZgLNMajIbLWG3j5nC8Iid2CXly
         bvzTprIPbentWcKJw9TqEZIRzw2oM9ubeKjbTzy09G3vRDKYawhNAO0/h7WVmtzmEtOT
         smVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kyNlNjvQ/w/GUzvjJjynHeFWBdohS+TSm31t+y9gU24=;
        b=cZW1Chbi8slVelwpXSeA9O9bWVmTapPH/iXXlhJjpeizwV812FKGppuM7FNBUO/Kiy
         gLl5OFHp57EOYTW7vYO6oY8Hgp4ffS/gqvgt1l9sHT+wEZ8Sz43rdXhYa+/nwYc5YuDJ
         lOBHchOi+PmSx4qQGPAVSLD0iKSkF3IxFVd2CCXbUb4vPKyKsax7RhOW0OpZkqcz8kK3
         bCq+jULazOMjWoBoXAbdNtE/+LDZRJxQF2TJvGngQaJl3LHJ/c+YGU5r9DyDCs0GVzKg
         i1rEGefZaSnFQNZNYqlWspUQLPdU/XsUwyjDaKr/xjmkMAH3QLBVcvAzwDHnoSj3urrt
         wyjg==
X-Gm-Message-State: AOAM533tBfwufD9yhSGNhYjG6xLat6+IGH3Pu/FFrk6273p9lbKGt+yE
        +Xz1laWGLbN4o+Gla3RDLg5ShiNp/kk=
X-Google-Smtp-Source: ABdhPJymnH1VdPhcKTMDcCDf4I6HeLIw9xtI0KLXTm6CpEMvAynCBAf9zZqXHqKItnIea/Ei4Vm77g==
X-Received: by 2002:a5d:6da9:: with SMTP id u9mr2193996wrs.264.1619733745933;
        Thu, 29 Apr 2021 15:02:25 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id u17sm11339727wmq.30.2021.04.29.15.02.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 15:02:25 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <22ef3e41-07ba-2964-d3d6-57237cab67ff@gmail.com>
Date:   Thu, 29 Apr 2021 23:02:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 2:32 PM, Hao Xu wrote:
> sqes are submitted by sqthread when it is leveraged, which means there
> is IO latency when waking up sqthread. To wipe it out, submit limited
> number of sqes in the original task context.
> Tests result below:

Synchronising needs some patching in case of IOPOLL, as
io_iopoll_req_issued() won't wake up sqpoll task. Added in this patch
wake_up() doesn't help with that because it's placed before submission

> 
> 99th latency:
> iops\idle	10us	60us	110us	160us	210us	260us	310us	360us	410us	460us	510us
> with this patch:
> 2k      	13	13	12	13	13	12	12	11	11	10.304	11.84
> without this patch:
> 2k      	15	14	15	15	15	14	15	14	14	13	11.84
> 
> fio config:
> ./run_fio.sh
> fio \
> --ioengine=io_uring --sqthread_poll=1 --hipri=1 --thread=1 --bs=4k \
> --direct=1 --rw=randread --time_based=1 --runtime=300 \
> --group_reporting=1 --filename=/dev/nvme1n1 --sqthread_poll_cpu=30 \
> --randrepeat=0 --cpus_allowed=35 --iodepth=128 --rate_iops=${1} \
> --io_sq_thread_idle=${2}
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c                 | 29 +++++++++++++++++++++++------
>  include/uapi/linux/io_uring.h |  1 +
>  2 files changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 1871fad48412..f0a01232671e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1252,7 +1252,12 @@ static void io_queue_async_work(struct io_kiocb *req)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
>  	struct io_kiocb *link = io_prep_linked_timeout(req);
> -	struct io_uring_task *tctx = req->task->io_uring;
> +	struct io_uring_task *tctx = NULL;
> +
> +	if (ctx->sq_data && ctx->sq_data->thread)
> +		tctx = ctx->sq_data->thread->io_uring;
> +	else
> +		tctx = req->task->io_uring;
>  
>  	BUG_ON(!tctx);
>  	BUG_ON(!tctx->io_wq);
> @@ -9063,9 +9068,10 @@ static void io_uring_try_cancel(struct files_struct *files)
>  	xa_for_each(&tctx->xa, index, node) {
>  		struct io_ring_ctx *ctx = node->ctx;
>  
> -		/* sqpoll task will cancel all its requests */
> -		if (!ctx->sq_data)
> -			io_uring_try_cancel_requests(ctx, current, files);
> +		/*
> +		 * for sqpoll ctx, there may be requests in task_works etc.
> +		 */
> +		io_uring_try_cancel_requests(ctx, current, files);
>  	}
>  }
>  
> @@ -9271,7 +9277,8 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
>  	io_run_task_work();
>  
>  	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
> -			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG)))
> +			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
> +			       IORING_ENTER_SQ_DEPUTY)))
>  		return -EINVAL;
>  
>  	f = fdget(fd);
> @@ -9304,8 +9311,18 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
>  		if (unlikely(ctx->sq_data->thread == NULL)) {
>  			goto out;
>  		}
> -		if (flags & IORING_ENTER_SQ_WAKEUP)
> +		if (flags & IORING_ENTER_SQ_WAKEUP) {
>  			wake_up(&ctx->sq_data->wait);
> +			if ((flags & IORING_ENTER_SQ_DEPUTY) &&
> +					!(ctx->flags & IORING_SETUP_IOPOLL)) {
> +				ret = io_uring_add_task_file(ctx);
> +				if (unlikely(ret))
> +					goto out;
> +				mutex_lock(&ctx->uring_lock);
> +				io_submit_sqes(ctx, min(to_submit, 8U));
> +				mutex_unlock(&ctx->uring_lock);
> +			}
> +		}
>  		if (flags & IORING_ENTER_SQ_WAIT) {
>  			ret = io_sqpoll_wait_sq(ctx);
>  			if (ret)
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 311532ff6ce3..b1130fec2b7d 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -251,6 +251,7 @@ struct io_cqring_offsets {
>  #define IORING_ENTER_SQ_WAKEUP	(1U << 1)
>  #define IORING_ENTER_SQ_WAIT	(1U << 2)
>  #define IORING_ENTER_EXT_ARG	(1U << 3)
> +#define IORING_ENTER_SQ_DEPUTY	(1U << 4)
>  
>  /*
>   * Passed in for io_uring_setup(2). Copied back with updated info on success
> 

-- 
Pavel Begunkov
