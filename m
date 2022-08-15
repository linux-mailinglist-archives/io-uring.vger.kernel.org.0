Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379BE59303E
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 15:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiHONvs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 09:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiHONvs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 09:51:48 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9725B877
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:51:46 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id az6-20020a05600c600600b003a530cebbe3so3963292wmb.0
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Sc1w/DSzSoBNivQClKNcfo2SZzStoYlHj1Mle1aGVHM=;
        b=AMANIwLM6EDp8RFQLrc07OUbUEnG2KnFyMOLcKaPn8XXVtI8A4uqReUy8XkUyCVP0H
         7guW2nIGDJ03uxrMylHyqX3w17DTt8IhJipJBFuH7zXvDzxrNxEQvCSh7d4T9mQSw8wN
         FOFnDvnEWPQoD87YtT8aev0JZ+2SpUmuy4cmsS8UiYNdmlWFPIIp2YsH+cS5jGLxjrhg
         rvV/h1Wm2M6ZYZyNL5E4ob13jbZEqrOJq5NgFVSHpIX7zCDdwVNW2Loh/hZ9rX4tUNfy
         XHkHrzl30Y36PuWWIavtGj0mZj4rTFAqLZQ1CXe4S5hdRLbScL1/5yzJnEFREBoUvKk6
         Y+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Sc1w/DSzSoBNivQClKNcfo2SZzStoYlHj1Mle1aGVHM=;
        b=Lpz1CBNYLZd1KB5aijmzcZ4NhKfMI/NaWooBx9hCocqPT5/LV+59I2jJDCR5q8K4Y3
         myMdJfg4Oic7HIstIvFnn6nAUlLP2j/9LfAKH92Fcc2oMEssWIdqBCUya6b54JMlST7h
         oT5VftvENUvqDdfl2+roJ//l7Njy5iICxK4Nd1hRQB4xHEcq27VO3wlS95ZaoThUBb0k
         M/+/SHHHwOuh/IaYubX8iqF+PIdCpLJyJawFqk1qjort1HnHgpyvrHxNl/baQgyfyzbi
         feclMUswY3j7UnENsD69bn42cSV6bEb/FeESSKv27jfF3VAl6563XZd/GNf28tA8je6d
         9HYQ==
X-Gm-Message-State: ACgBeo0DCDd36IZk1IpTTCcvUrcyI/BtLqgct4/tAhDcFJQH6rk0TCEO
        QUmXNpogKyFD/Pvs/pkiKQI=
X-Google-Smtp-Source: AA6agR4WTcCVRx3voxH79MfuzEZDrCcm3cDJNO3QQCrd5JEQtDhnI3i840uL5QIz5xzTi182O6EFmA==
X-Received: by 2002:a05:600c:a4c:b0:39c:34d0:fd25 with SMTP id c12-20020a05600c0a4c00b0039c34d0fd25mr10574194wmq.172.1660571505212;
        Mon, 15 Aug 2022 06:51:45 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:886])
        by smtp.gmail.com with ESMTPSA id n32-20020a05600c502000b003a2d47d3051sm11906840wmr.41.2022.08.15.06.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 06:51:44 -0700 (PDT)
Message-ID: <81faed35-08a9-d6eb-4748-7cafb9a63148@gmail.com>
Date:   Mon, 15 Aug 2022 14:50:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH for-next 4/7] io_uring: do not always run task work at the
 start of io_uring_enter
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
References: <20220815130911.988014-1-dylany@fb.com>
 <20220815130911.988014-5-dylany@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220815130911.988014-5-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/22 14:09, Dylan Yudaken wrote:
> It is normally better to wait for task work until after submissions. This
> will allow greater batching if either work arrives in the meanwhile, or if
> the submissions cause task work to be queued up.
> 
> For SQPOLL this also no longer runs task work, but this is handled inside
> the SQPOLL loop anyway.
> 
> For IOPOLL io_iopoll_check will run task work anyway

It's here to free resources (e.g. io_kiocb so can be reused in the
submission) and so, but we don't care much. Running them after
submission doesn't make much difference as either we go to
cq_wait, which will run it for us, or exit and again they'll be
executed.

In short, instead of moving we can just kill it.

> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---
>   io_uring/io_uring.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 8cc4b28b1725..3b08369c3c60 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2990,8 +2990,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>   	struct fd f;
>   	long ret;
>   
> -	io_run_task_work();
> -
>   	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
>   			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
>   			       IORING_ENTER_REGISTERED_RING)))
> @@ -3060,7 +3058,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>   		if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
>   			goto iopoll_locked;
>   		mutex_unlock(&ctx->uring_lock);
> +		io_run_task_work();
> +	} else {
> +		io_run_task_work();
>   	}
> +
>   	if (flags & IORING_ENTER_GETEVENTS) {
>   		int ret2;
>   		if (ctx->syscall_iopoll) {

-- 
Pavel Begunkov
