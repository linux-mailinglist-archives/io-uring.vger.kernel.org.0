Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304B036D950
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 16:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhD1ONc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 10:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhD1ONb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 10:13:31 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07453C061574
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:12:47 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id e15so7045800pfv.10
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WoZ7IOjiJabbvSKELMvmSmtEhKF9UpwT+BiaPHPz4Ls=;
        b=aH9CJORDcjGOSLV8of1Hb4As52AZYB4l0ojsaZuwD313fbSSxKQDeHKUpPVnf38xMZ
         ApiDdmUVek4Sh91Tfo8fVHnCZO3LVU044DxKzEeWDp6+LnSVzm23tA5YT0LvrY0tlTob
         fRZ2gPDs8lFYVJD9k9aVY71K6Npnb1NqiZb91mkBNk6DAvKZQOVoK6ZHQLtja+CoxsIY
         KtGmeTzDTmOuuDwoNPcaQPBpYlHQgcyMVMRXCdSz/DRAL398n3aJmVFiYOBXXUGpfZEn
         yML2D/1y+oeTRnfxk/Of1RBEUP3CtQ9YPab7A0rq3J95Hii24ZE5k83s3tjhDLUk0nT0
         TPjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WoZ7IOjiJabbvSKELMvmSmtEhKF9UpwT+BiaPHPz4Ls=;
        b=Fwin2n3BhPU+5LMVaOxMx2X2hBGtPgb9043+IemSjG5yHWD56LQD0lM+uZd/RnQMf+
         1jT3gYxygS4N+bxQ0LZx6oTyXvggcJ/UHrm5c4vY2Em/8BxwfDA5CiHO7wZkV6zW27WL
         KXvoX7x+Ulp2XuPvLqwIaAbBPZHihiGC4bFzk2GVhGxfkpseLzz89hISHXtqGmFd54E8
         4XbFiALARRGwQ8yaw8ROegOnLyo7wiwVd98RTBpB0wNuysfP0eJnktb597HkakeyLPyI
         UFy2/zn7VUuLa21kPTmDcHxajRL74+LxbvCteqv0cM1QTjEwVeqNVnNemtyIrTAcc3Y6
         od4g==
X-Gm-Message-State: AOAM532Krnbd+Gsfxnj6ttOM4beibTdQt1tBahHmR4PQ5Isqe8m07ZeK
        g88h0oqiKPr7eRNPNtpBGw7yuw==
X-Google-Smtp-Source: ABdhPJzED0twXrPqVF062FWEvHjw+pIfIZ7jzhrCq024mzRIvvNxDbySNfVJRBeFcJl/XzHge/V8Og==
X-Received: by 2002:a63:3204:: with SMTP id y4mr15712387pgy.3.1619619166392;
        Wed, 28 Apr 2021 07:12:46 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id f19sm2783549pga.71.2021.04.28.07.12.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:12:45 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8cb5e446-d19a-4a3f-5b96-5487723024f8@kernel.dk>
Date:   Wed, 28 Apr 2021 08:12:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 7:32 AM, Hao Xu wrote:
> sqes are submitted by sqthread when it is leveraged, which means there
> is IO latency when waking up sqthread. To wipe it out, submit limited
> number of sqes in the original task context.
> Tests result below:
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

Interesting concept! One question:

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

Do we want to wake the sqpoll thread _post_ submitting these ios? The
idea being that if we're submitting now after a while (since the thread
is sleeping), then we're most likely going to be submitting more than
just this single batch. And the wakeup would do the same if done after
the submit, it'd just not interfere with this submit. You could imagine
a scenario where we do the wake and the sqpoll thread beats us to the
submit, and now we're just stuck waiting for the uring_lock and end up
doing nothing.

Maybe you guys already tested this? Also curious if you did, what kind
of requests are being submitted? That can have quite a bit of effect on
how quickly the submit is done.

-- 
Jens Axboe

