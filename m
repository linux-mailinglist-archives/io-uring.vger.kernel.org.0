Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A52328121
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 15:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbhCAOmu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 09:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236490AbhCAOmm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 09:42:42 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3B5C061756
        for <io-uring@vger.kernel.org>; Mon,  1 Mar 2021 06:42:02 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id o11so10050812iob.1
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 06:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aAY23UbSNz0XIAX5iPeL0iShGqzBU+zC4RKcFv150aA=;
        b=auEURMfO+/VLVsexvrlJOBWEXw3357dUQLG6zMYM5JWA3iG3WPNfwFdoZ0D1y9zPW7
         ZZkJjdJ9kYqEO0Kq2TV4C3xKekRIgW0NUUOujbu47rMWh/NLQUX38YbGQNdgtcrSzHi2
         5kM/tmlyL/nHYopsByE0aCCza/4W2uP+j4TNCttH3EYX90w8HogloXhmSkVbvEH+3wbA
         qPQx/lWWDRQLVFH2G1GXCmrQHJe8siqOyEkrWxxXwIcAJrfihO0cEeXW3XBs81diljfr
         X/oj6toMPf6mtmGeY19wVjMu7qDzHXyw6GY+Um8+F53BuQJW+mBBHUyfX52j21ZgEq7+
         f+LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aAY23UbSNz0XIAX5iPeL0iShGqzBU+zC4RKcFv150aA=;
        b=UQVVzNpCAUDQ6PGcRJ/8w7ELG5SpEzO2ADL+e06x5pqCgghuTmahTjVbBs166O4s1y
         vAbumiUtlGFDEeTH7na7GZ9DgPpslBOCRyBo6ps+Ok5DO3ipygVpgDQfkNKVkoX3YoZC
         gaul2HTR/+Tsk3tK8zkQoGbAPP5t5dzLULana48SfCNN1Qq9qHBQywDozCfDr5EZivPX
         6Kw+hgjjfeP4y70mnF7I2YBkj7NSDLJkh5MdhZAraa9YVnvWWaEoafqjwbv0ggLQZCUd
         Ruug8pe0Nodv7f0O9Q4FgeoF8vNSjwQdT/SSiB9x01cg/uDeJNPSSpPklV9ZzpESymGE
         +7dQ==
X-Gm-Message-State: AOAM533LFjxUzVV2ZruTVj4nf9gGRvmPq63Vl8orhgq4l3vMGZB7sjnZ
        SxoSOUlKsO0E5uqMh0UcnFHpvso/XEYFRQ==
X-Google-Smtp-Source: ABdhPJwcTGDI7LRZF3H7AFRD2jxpGPyeUqNb7MyxC6yQW37qVBi0/kAj+llzRPNFUzvZuir1/fvGCQ==
X-Received: by 2002:a6b:c401:: with SMTP id y1mr6073440ioa.110.1614609721662;
        Mon, 01 Mar 2021 06:42:01 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e2sm10181287iov.26.2021.03.01.06.42.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 06:42:01 -0800 (PST)
Subject: Re: [PATCH 1/2] io_uring: kill sqo_dead and sqo submission halting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1614603610.git.asml.silence@gmail.com>
 <7c5c98128324970ea148f47653333b96d0a04117.1614603610.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8b93fbfc-322f-bbad-29b0-0cc6d319459d@kernel.dk>
Date:   Mon, 1 Mar 2021 07:42:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7c5c98128324970ea148f47653333b96d0a04117.1614603610.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/1/21 6:02 AM, Pavel Begunkov wrote:
> @@ -8697,19 +8691,6 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>  	}
>  }
>  
> -static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
> -{
> -	mutex_lock(&ctx->uring_lock);
> -	ctx->sqo_dead = 1;
> -	if (ctx->flags & IORING_SETUP_R_DISABLED)
> -		io_sq_offload_start(ctx);
> -	mutex_unlock(&ctx->uring_lock);
> -
> -	/* make sure callers enter the ring to get error */
> -	if (ctx->rings)
> -		io_ring_set_wakeup_flag(ctx);
> -}

We need to retain the offload start here for IORING_SETUP_R_DISABLED, or
we'll potentially hang when:

> @@ -8722,7 +8703,6 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
>  	bool did_park = false;
>  
>  	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
> -		io_disable_sqo_submit(ctx);
>  		did_park = io_sq_thread_park(ctx->sq_data);
>  		if (did_park) {
>  			task = ctx->sq_data->thread;

we try and park right here. Maybe we can just do that in
cancel_sqpoll(), will double check.

-- 
Jens Axboe

