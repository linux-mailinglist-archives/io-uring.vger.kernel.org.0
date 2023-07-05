Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCD17484B6
	for <lists+io-uring@lfdr.de>; Wed,  5 Jul 2023 15:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjGENOZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jul 2023 09:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjGENOY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jul 2023 09:14:24 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF521700;
        Wed,  5 Jul 2023 06:14:23 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-51e285ac32eso609444a12.2;
        Wed, 05 Jul 2023 06:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688562862; x=1691154862;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XFnYBZo50so0HQ676SxjQCTp9AZisqWkhoJS2IYjYTw=;
        b=l4rqA1eYjEKzdn2h96nngISv6A4sjkZ1gb3S95Mm/1D2Ep/I5edyyzYMfOH4njcXEp
         5KglOIrUjbxrLMPy2WIPs+XzvNmPIHQZCIXy+USmMI2GCwG9Z9FzA61/7bMGjK4Zb3SM
         SrQE8O3rSIiIKeKgiWSP1hB7F1nVIrHmuVfE+jOn044pB0flmaq7wH9XjkjC+lXwaGkf
         cm9buyaKRRdOL3kuxXiu3ACe2ouWNgXPyWD1oz2A6489VlDCgSZVkXwT8A/yb8uFojUg
         HTIjhU1sgWq8vHLAI6mdRNNlAXYyp8/QiIAxSjTg4RTZGLuYLJ7pv698VBG4/bQ2mSl/
         WWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688562862; x=1691154862;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XFnYBZo50so0HQ676SxjQCTp9AZisqWkhoJS2IYjYTw=;
        b=XMgxB+FB/IbxFHWZfmioVnF4kM9mYrzkdbyQHWQLOOYAYD9GzI1DM8J7bKg5xjctP6
         QrBln4SM5KVzqfgfy0N5U2SL6VJOC31e71JGo0EkoDG9UfADICMUAYUbEHxciNSjH7Zu
         CstmK3SQwAGP/tXfW1PDIgM+UcqLiELGB4JWMHKYNIvJipp2iOL4OIQmbr9r3YvYYEly
         sPipGMaiXbjgM537D3DOSsAvEWcb12RvxmtVeBlpbA4ji5bPRhSBNlKl4KBx0XIOhK1r
         uyQf+DYI+sV/cnWonbW4CLazjKOSrHct6XhFhjz3zRIaEMWHDD+fxRpxRKeYGjNqBGlh
         QgQg==
X-Gm-Message-State: ABy/qLY4uVEDX5VN0PAN4nLRDxQdwfgq9uLJtB3wHsC5QjQZOH3NeHgw
        45hmDOdG5fgnqCYu5F1/8ps=
X-Google-Smtp-Source: APBJJlEOcdmdChoVzz2eCE9KYFG7XIfKIG8ua2jnSO4s0/472yPlq4otyAmaYTN4yHv1cgv9ixxyhQ==
X-Received: by 2002:a50:ee05:0:b0:51d:d4dd:a0e1 with SMTP id g5-20020a50ee05000000b0051dd4dda0e1mr8720700eds.15.1688562861791;
        Wed, 05 Jul 2023 06:14:21 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:4b35])
        by smtp.gmail.com with ESMTPSA id f6-20020aa7d846000000b0051df5eefa20sm6641553eds.76.2023.07.05.06.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 06:14:21 -0700 (PDT)
Message-ID: <d005decd-8d89-fe3f-9d27-ec471eda999f@gmail.com>
Date:   Wed, 5 Jul 2023 14:10:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 07/11] io_uring: add new api to register fixed workers
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
References: <20230609122031.183730-1-hao.xu@linux.dev>
 <20230609122031.183730-8-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230609122031.183730-8-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/23 13:20, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add a new api to register fixed workers. The api is designed to register
> fixed workers for the current task. For simplicity, it doesn't allow
> worker number update. We have a separate unregister api to uninstall all
> the fixed workers. And then we can register different number of fixed
> workers again.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   include/uapi/linux/io_uring.h |  9 ++++
>   io_uring/io-wq.c              | 85 +++++++++++++++++++++++++++++++++++
>   io_uring/io-wq.h              |  1 +
>   io_uring/io_uring.c           | 71 +++++++++++++++++++++++++++++
>   4 files changed, 166 insertions(+)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index f222d263bc55..6dc43be5009d 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
[...]
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index c99a7a0c3f21..bb8342b4a2c6 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -4351,6 +4351,71 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
>   	return ret;
>   }
>   
> +/*
> + * note: this function sets fixed workers for a single task, so every
> + * task which wants to set the fixed workers has to call this function
> + */
> +static __cold int io_register_iowq_fixed_workers(struct io_ring_ctx *ctx,
> +					       void __user *arg, int nr_args)
> +	__must_hold(&ctx->uring_lock)
> +{
> +	struct io_uring_task *tctx = NULL;
> +	struct io_sq_data *sqd = NULL;
> +	struct io_uring_fixed_worker_arg *res;
> +	size_t size;
> +	int i, ret;
> +	bool zero = true;
> +
> +	size = array_size(nr_args, sizeof(*res));
> +	if (size == SIZE_MAX)
> +		return -EOVERFLOW;

I don't think the number of accounting classes is going to
change, just move nr_args check from below here and have
on-stack array of size 2.


struct io_uring_fixed_worker_arg res[IO_WQ_ACCT_NR];

if (nr_args != IO_WQ_ACCT_NR)
	return -EINVAL;

...


> +
> +	res = memdup_user(arg, size);
> +	if (IS_ERR(res))
> +		return PTR_ERR(res);
> +
> +	for (i = 0; i < nr_args; i++) {
> +		if (res[i].nr_workers) {
> +			zero = false;
> +			break;
> +		}
> +	}
> +

-- 
Pavel Begunkov
