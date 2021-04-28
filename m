Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174D036D941
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 16:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240154AbhD1OIp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 10:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240081AbhD1OIk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 10:08:40 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC92C061573
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:07:53 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n127so22085539wmb.5
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jjk5qGUL8PhVTsj/6ESwkDIOjBONAfULCYr0mMdjfXg=;
        b=E6ULybswtvzJFwiWrTQEa2LV26S1TrdYKEEh6kyR/Ibz4CIiqk0eqFs/ESa7uyOz6V
         JkLcOLmyYUSOXS0aweRHLwTNaSqrs8IQA0RGwGrb570OMBkn2lx1JGw8jFlr3r28oPOM
         nP7jEAxTFv8PqB0bIRH/5ofGz38FZIhtG1UEo9xrpHkPAEYMDxJDXyS2Mkyj+mvOvmc0
         LjlaQxmZHnRM8eR6aRfsL0UarSKx67/xXvumz77G+GawCmDly8zvOo4GS+f9Dt/iidA3
         T6Y3s8Yq3k43Bay3XHixqfscyExAU4SderKsFwn2d2b4an95fGpadqBCn7XhHsXOy3eK
         Ff9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jjk5qGUL8PhVTsj/6ESwkDIOjBONAfULCYr0mMdjfXg=;
        b=BbKy/fRqLPrNeZzsBfW5mxp0xD5ZJTb+CoNkU2Qy4M0DaDEGDvtB+NKhhZs3NRZz0Y
         VKGw/j9NM3Za9z2YiHFN+i3tuna3Y8eoBasP7eOFx2dZDX1Tm5Vr8Q0KveGtZzSxYMaa
         vtN4+RRv/JJnKzpnz9us03Nk7Wnl1V+ECpbnBD9/2cipLAhnvuwU/97d5fXXHOA08gGE
         uuCLIVagCCoEzcmiDGuM15T5nuicXtI++nHFfIQhYYFbPQjVqMEcfbcYF2JG8Z0gez8a
         Evx8QwCY96pUsKV+6rJOH6Am8ACyr8Z1ZpOQ24EEwNcBpAA/Bi480NVhECwu2wimNHg3
         j7cA==
X-Gm-Message-State: AOAM5318KzA52mMJpD0dutNAMJuKY93kPTQhMi/BdBYR7H/z3AW384iv
        xmC6DEez3iBqd245KJAUQp4=
X-Google-Smtp-Source: ABdhPJxsHkqt9BEp/U43iwiqBJS0Ek8qQfrT3La6iPJnI5dscxQ4f1L7GWhsZesmT6KcbpIiK7n9dg==
X-Received: by 2002:a1c:2587:: with SMTP id l129mr31189533wml.135.1619618869288;
        Wed, 28 Apr 2021 07:07:49 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.35])
        by smtp.gmail.com with ESMTPSA id z14sm47194wrs.96.2021.04.28.07.07.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:07:48 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
Date:   Wed, 28 Apr 2021 15:07:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 2:32 PM, Hao Xu wrote:
> currently unit of io_sq_thread_idle is millisecond, the smallest value
> is 1ms, which means for IOPS > 1000, sqthread will very likely  take
> 100% cpu usage. This is not necessary in some cases, like users may
> don't care about latency much in low IO pressure
> (like 1000 < IOPS < 20000), but cpu resource does matter. So we offer
> an option of nanosecond granularity of io_sq_thread_idle. Some test
> results by fio below:

If numbers justify it, I don't see why not do it in ns, but I'd suggest
to get rid of all the mess and simply convert to jiffies during ring
creation (i.e. nsecs_to_jiffies64()), and leave io_sq_thread() unchanged.

Or is there a reason for having it high precision, i.e. ktime()?

> uring average latency:(us)
> iops\idle	10us	60us	110us	160us	210us	260us	310us	360us	410us	460us	510us
> 2k	        10.93	10.68	10.72	10.7	10.79	10.52	10.59	10.54	10.47	10.39	8.4
> 4k	        10.55	10.48	10.51	10.42	10.35	8.34
> 6k	        10.82	10.5	10.39	8.4
> 8k	        10.44	10.45	10.34	8.39
> 10k	        10.45	10.39	8.33
> 
> uring cpu usage of sqthread:
> iops\idle	10us	60us	110us	160us	210us	260us	310us	360us	410us	460us	510us
> 2k	        4%	14%	24%	34.70%	44.70%	55%	65.10%	75.40%	85.40%	95.70%	100%
> 4k	        7.70%	28.20%	48.50%	69%	90%	100%
> 6k	        11.30%	42%	73%	100%
> 8k	        15.30%	56.30%	97%	100%
> 10k	        19%	70%	100%
> 
> aio average latency:(us)
> iops	latency	99th lat  cpu
> 2k	13.34	14.272    3%
> 4k	13.195	14.016	  7%
> 6k	13.29	14.656	  9.70%
> 8k	13.2	14.656	  12.70%
> 10k	13.2	15	  17%
> 
> fio config is:
> ./run_fio.sh
> fio \
> --ioengine=io_uring --sqthread_poll=1 --hipri=1 --thread=1 --bs=4k \
> --direct=1 --rw=randread --time_based=1 --runtime=300 \
> --group_reporting=1 --filename=/dev/nvme1n1 --sqthread_poll_cpu=30 \
> --randrepeat=0 --cpus_allowed=35 --iodepth=128 --rate_iops=${1} \
> --io_sq_thread_idle=${2}
> 
> in 2k IOPS, if latency of 10.93us is acceptable for an application,
> then they get 100% - 4% = 96% reduction of cpu usage, while the latency
> is smaller than aio(10.93us vs 13.34us).
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
[snip]
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index e1ae46683301..311532ff6ce3 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -98,6 +98,7 @@ enum {
>  #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
>  #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
>  #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
> +#define IORING_SETUP_IDLE_NS	(1U << 7)	/* unit of thread_idle is nano second */
>  
>  enum {
>  	IORING_OP_NOP,
> @@ -259,7 +260,7 @@ struct io_uring_params {
>  	__u32 cq_entries;
>  	__u32 flags;
>  	__u32 sq_thread_cpu;
> -	__u32 sq_thread_idle;
> +	__u64 sq_thread_idle;

breaks userspace API

>  	__u32 features;
>  	__u32 wq_fd;
>  	__u32 resv[3];
> 

-- 
Pavel Begunkov
