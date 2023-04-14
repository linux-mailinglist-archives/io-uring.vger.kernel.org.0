Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7745E6E2559
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 16:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDNOMc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 10:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjDNOMb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 10:12:31 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928E3C173
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 07:11:51 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id fy21so2923507ejb.9
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 07:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681481439; x=1684073439;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CQ5sEN9+fUjyEy5VHMOBHFq9LLI3lap8NulOHDqf0RA=;
        b=gLTib1cMtvxMup00vs9h4SoXG0M1MtOnwNdKwydVowfDdhcLsDIFNpYu1yRjINQHFq
         q4kZNM93OURDnSCjgq1kydi8Nc8kV2q1xKmorJ3t/Js49kN2mSs79WNo29J3o8u1hHsw
         aGUiUud7TJozt5m5grJp59OUdjQ0ACCM5U1al12Hfq6Bml0Dx01lisfrGSAd2ihsohRX
         3ZAnq9/7sKDVQCs+VVAsTPM33RjPsc+g70U5AQfjgTdwiUYU/s0sMUgScN/zjdmBeNZq
         IfiJ37X4YFqHLjaqQ9Uqmk6vGDmTkbQILgS5ATmXS6XLZ72rZGz9fDg+1d3QKgLKw+Eq
         9Z4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681481439; x=1684073439;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CQ5sEN9+fUjyEy5VHMOBHFq9LLI3lap8NulOHDqf0RA=;
        b=ljAHGk93mpAir7P8pYowocpNVd03wwKiqCuaAzUSVeTsZAhX1OGbYL0hvcJOKtLkf8
         ixk6qc2KURpm9MbcJkDheY3ed8wZiymuEtWC3FAT0RqqqXS++//QiudgzWiozTNrY9+3
         Qob67iTG03TOee9Rgzm7ADKKCDoasZAtK68HU4ScMITvctUa17toFHlchtDE46pFClm6
         UIg6UBTACZwLQo9hPx11H31qnj6rB/KYlC4dnoayh/226dY0PfZvk2uN0156qjOjjyHE
         nQEK4MiojvrPAFX4LI6Eqo8JY2sCaYLoY31kAoFWnbMlqe/S+8Ku/cdOXiWprkk8WOwC
         uDiQ==
X-Gm-Message-State: AAQBX9cgHvA5LByBgdgWtvwIo8ndV3tBX54O6RbdXTV8j0pC6djWQggm
        zW6l3h6fS6JKkiA2X/iE9jo=
X-Google-Smtp-Source: AKy350ZoOGcRZn90SKOf3MWL3K/juqNa+NscOMHdo1w+6Hx/heF7e+we0S884ShZEHnIWO5PHUWcDg==
X-Received: by 2002:a17:906:4b10:b0:94b:d57e:9d4b with SMTP id y16-20020a1709064b1000b0094bd57e9d4bmr5710782eju.2.1681481438847;
        Fri, 14 Apr 2023 07:10:38 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:b2ce])
        by smtp.gmail.com with ESMTPSA id f1-20020a170906560100b00947499e0e4dsm2481915ejq.146.2023.04.14.07.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 07:10:38 -0700 (PDT)
Message-ID: <29f2da64-1dd7-0ed0-16a6-f8295de05a88@gmail.com>
Date:   Fri, 14 Apr 2023 15:10:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2] io_uring: add support for multishot timeouts
Content-Language: en-US
To:     David Wei <davidhwei@meta.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <20230412222732.1623901-1-davidhwei@meta.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230412222732.1623901-1-davidhwei@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/23 23:27, David Wei wrote:
> A multishot timeout submission will repeatedly generate completions with
> the IORING_CQE_F_MORE cflag set. Depending on the value of the `off' field
> in the submission, these timeouts can either repeat indefinitely until
> cancelled (`off' = 0) or for a fixed number of times (`off' > 0).
> 
> Only noseq timeouts (i.e. not dependent on the number of I/O
> completions) are supported.
> 
> An indefinite timer will be cancelled with EOVERFLOW if the CQ ever
> overflows.

Seems mostly fine, two comments below


> Signed-off-by: David Wei <davidhwei@meta.com>
> ---
>   include/uapi/linux/io_uring.h |  1 +
>   io_uring/timeout.c            | 59 +++++++++++++++++++++++++++++++++--
>   2 files changed, 57 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index f8d14d1c58d3..0716cb17e436 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -250,6 +250,7 @@ enum io_uring_op {
>   #define IORING_TIMEOUT_REALTIME		(1U << 3)
>   #define IORING_LINK_TIMEOUT_UPDATE	(1U << 4)
>   #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
> +#define IORING_TIMEOUT_MULTISHOT	(1U << 6)
>   #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
>   #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
>   /*
> diff --git a/io_uring/timeout.c b/io_uring/timeout.c
> index 5c6c6f720809..61b8488565ce 100644
...
> +static void io_timeout_complete(struct io_kiocb *req, struct io_tw_state *ts)
> +{
> +	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
> +	struct io_timeout_data *data = req->async_data;
> +	struct io_ring_ctx *ctx = req->ctx;
> +
> +	if (!io_timeout_finish(timeout, data)) {
> +		bool filled;
> +		filled = io_aux_cqe(ctx, false, req->cqe.user_data, -ETIME,
> +				      IORING_CQE_F_MORE, false);
> +		if (filled) {
> +			/* re-arm timer */
> +			spin_lock_irq(&ctx->timeout_lock);
> +			list_add(&timeout->list, ctx->timeout_list.prev);
> +			data->timer.function = io_timeout_fn;
> +			hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), data->mode);
> +			spin_unlock_irq(&ctx->timeout_lock);
> +			return;
> +		}
> +		io_req_set_res(req, -EOVERFLOW, 0);

Let's not change the return value. It's considered a normal completion
and we don't change the code for them. And there is IORING_CQE_F_MORE
for userspace to figure out that it has been terminated.


> +	}
> +
> +	io_req_task_complete(req, ts);
> +}
> +
>   static bool io_kill_timeout(struct io_kiocb *req, int status)
>   	__must_hold(&req->ctx->timeout_lock)
>   {
> @@ -212,7 +253,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
>   		req_set_fail(req);
>   
>   	io_req_set_res(req, -ETIME, 0);
> -	req->io_task_work.func = io_req_task_complete;
> +	req->io_task_work.func = io_timeout_complete;
>   	io_req_task_work_add(req);
>   	return HRTIMER_NORESTART;
>   }
> @@ -470,16 +511,28 @@ static int __io_timeout_prep(struct io_kiocb *req,
>   		return -EINVAL;
>   	flags = READ_ONCE(sqe->timeout_flags);
>   	if (flags & ~(IORING_TIMEOUT_ABS | IORING_TIMEOUT_CLOCK_MASK |
> -		      IORING_TIMEOUT_ETIME_SUCCESS))
> +		      IORING_TIMEOUT_ETIME_SUCCESS |
> +		      IORING_TIMEOUT_MULTISHOT)) {
>   		return -EINVAL;
> +	}

Please, don't add braces, they're not needed here.

>   	/* more than one clock specified is invalid, obviously */
>   	if (hweight32(flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
>   		return -EINVAL;
> +	/* multishot requests only make sense with rel values */
> +	if (!(~flags & (IORING_TIMEOUT_MULTISHOT | IORING_TIMEOUT_ABS)))
> +		return -EINVAL;
>   
>   	INIT_LIST_HEAD(&timeout->list);
>   	timeout->off = off;
>   	if (unlikely(off && !req->ctx->off_timeout_used))
>   		req->ctx->off_timeout_used = true;
> +	/*
> +	 * for multishot reqs w/ fixed nr of repeats, target_seq tracks the
> +	 * remaining nr
> +	 */
> +	timeout->repeats = 0;
> +	if ((flags & IORING_TIMEOUT_MULTISHOT) && off > 0)
> +		timeout->repeats = off;
>   
>   	if (WARN_ON_ONCE(req_has_async_data(req)))
>   		return -EFAULT;

-- 
Pavel Begunkov
