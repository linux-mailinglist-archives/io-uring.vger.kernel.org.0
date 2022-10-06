Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 416EF5F6FD7
	for <lists+io-uring@lfdr.de>; Thu,  6 Oct 2022 23:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiJFU76 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Oct 2022 16:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiJFU75 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Oct 2022 16:59:57 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684AF10FC2
        for <io-uring@vger.kernel.org>; Thu,  6 Oct 2022 13:59:53 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id b204so2269199iof.2
        for <io-uring@vger.kernel.org>; Thu, 06 Oct 2022 13:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UxX2+F1Ms44bne6elzII/AZze0FZiZPJMcKyEJ0D7TA=;
        b=zhbVGVLhUYo6Lc8ujEsBTVbYhfNgQ676QR84RZJQtdSNl9eL9Ns9krm49Klwf09vhV
         AXhxL0J7bvxYZ7q99yVZOs+q/VhTSmW2cUvDqhJ32gLfSJNWCCebEdb2ECbiiB6F64vY
         QWclbbCuiDBoywTzFvNdjeP6AE5Otc63ar0kDtgu3xQ+gKBgZV/WtyHJ8BVdeSmWmcnu
         Bp0kjQ52RJmPyRDoI1WjyWBqJ+ICBDUjWgWnD1iFuDCSaLnGWUaMEWlGMqnPkO5KetZH
         1ivf/R8lG+zqIB007MiCPUuTyCd6d/C2tl91EG67ARrAXcHrpRRmvg9ltPVb1cTz2NzY
         ihiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UxX2+F1Ms44bne6elzII/AZze0FZiZPJMcKyEJ0D7TA=;
        b=QrpR74Xp7JcD6UspRoJWDOdyUnuVWhau0kK0r+OICjGS8e6J2yiovDNz7NNyKjsWRL
         hivthpnLPe7mWqYh1A3rKKwRRF5TqxoPWJg7W2ESrBYr0W6O0XsZuyx3lzuJd1ZIB/re
         QUQFqmGYXq6w0ccrC9lMjLSv4g63gE2PMd27iOe0+SA1++u8tmVFsVMm4ySulk+M/s/B
         Z96C9G+7ZwF4D9ethDNmdYeXdRZ4le+ZeymW6CP45o73GIUYFCdnjy9wjInlqwuwOocY
         i7v6D7gvU5MX/sPxBoLk6BFsGeq9Ss31nL1NzIilbUHU5b63EPhDnZK8fp78fcAT+r2E
         +pTQ==
X-Gm-Message-State: ACrzQf1C2PTq6thzgiOGlHvsA/kt+X2dFOMwaru+pZm4WOEGD4UKQDVH
        vWIduiJy5EGs6Pan5dup3knOYwenHtXQkg==
X-Google-Smtp-Source: AMsMyM7dKh+CZAsartSW/PVLJFSbH9a4uTPQWImZqZTTe0rJjIf9vEVAqyDcmS5yQeGrM3CYnjpXLQ==
X-Received: by 2002:a05:6638:3183:b0:35a:9857:582e with SMTP id z3-20020a056638318300b0035a9857582emr858292jak.100.1665089993169;
        Thu, 06 Oct 2022 13:59:53 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q130-20020a6b2a88000000b006a153f7e34asm225562ioq.6.2022.10.06.13.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Oct 2022 13:59:52 -0700 (PDT)
Message-ID: <0dbacebb-48bc-4254-6ad5-c00e6d54de8b@kernel.dk>
Date:   Thu, 6 Oct 2022 14:59:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 1/1] io_uring: optimise locking for local tw with
 submit_wait
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Dylan Yudaken <dylany@fb.com>
References: <281fc79d98b5d91fe4778c5137a17a2ab4693e5c.1665088876.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <281fc79d98b5d91fe4778c5137a17a2ab4693e5c.1665088876.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/6/22 2:42 PM, Pavel Begunkov wrote:
> Running local task_work requires taking uring_lock, for submit + wait we
> can try to run them right after submit while we still hold the lock and
> save one lock/unlokc pair. The optimisation was implemented in the first
> local tw patches but got dropped for simplicity.
> 
> Suggested-by: Dylan Yudaken <dylany@fb.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/io_uring.c | 12 ++++++++++--
>  io_uring/io_uring.h |  7 +++++++
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 355fc1f3083d..b092473eca1d 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3224,8 +3224,16 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>  			mutex_unlock(&ctx->uring_lock);
>  			goto out;
>  		}
> -		if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
> -			goto iopoll_locked;
> +		if (flags & IORING_ENTER_GETEVENTS) {
> +			if (ctx->syscall_iopoll)
> +				goto iopoll_locked;
> +			/*
> +			 * Ignore errors, we'll soon call io_cqring_wait() and
> +			 * it should handle ownership problems if any.
> +			 */
> +			if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
> +				(void)io_run_local_work_locked(ctx);
> +		}
>  		mutex_unlock(&ctx->uring_lock);
>  	}
>  
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index e733d31f31d2..8504bc1f3839 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -275,6 +275,13 @@ static inline int io_run_task_work_ctx(struct io_ring_ctx *ctx)
>  	return ret;
>  }
>  
> +static inline int io_run_local_work_locked(struct io_ring_ctx *ctx)
> +{
> +	if (llist_empty(&ctx->work_llist))
> +		return 0;
> +	return __io_run_local_work(ctx, true);
> +}

Do you have pending patches that also use this? If not, maybe we
should just keep it in io_uring.c? If you do, then this looks fine
to me rather than needing to shuffle it later.

-- 
Jens Axboe


