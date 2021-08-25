Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AA33F7C84
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 21:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbhHYTEF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 15:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbhHYTEE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 15:04:04 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DE3C061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 12:03:18 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q11so770469wrr.9
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 12:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=By+mnjXrUF4QJ0oL3L+0O/q5Dj2WZD0rSMSqS4D13zE=;
        b=lfEoshKMjB/bmlD7BsZPBuS7ra/S2yblvRAbnkb4HjXjmNVQ/z21jjMb7xDKTFUpjm
         7GfBoWhj6RgQOao1Gp1IzigKKdw3co0R7pd+BdF2d5zqY5SHJN0u6B+XCUUU/cglk/fs
         SSfxVbGsO+acRyzK2evVbp+Ee7ZQ8OlHfSmPgq5+aM8sY0e7kdKFMeb69ZENz0P67yfT
         hu6J+6pdEP0DmludGw7Zf3ZgPPm8p4AnaGa+0+sKfsZr416GIWE9UHDzHO74BOb0+HXo
         54sQradOUa0MBbNN/XzyXpmCNE24psGBHHKhhdfKkrrQk85tDTuvgh0PMO1W4IIJYK26
         AN1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=By+mnjXrUF4QJ0oL3L+0O/q5Dj2WZD0rSMSqS4D13zE=;
        b=WNxOUbvXACnnrws+9bLY+M+fqhJ3AmFw8KD9T6JLw0LzZN/QnuJl7KR2JcyPhmj4O2
         zg58ZlsMCan7WdqXURx8SuRnb96Qw1VOWXvLu/Lg5A99DsTlChRTefPVR3fOG8eG+IWC
         QLK35dVAWHDNWQluoUriR82Szn5U26R2Mh0E7GbNwoJfQhKksJWzFdjqL88TBMngPgnw
         i1BPAixn6JlMxIPyL9mRa3uvpTKjbeNHk3nr+tntwuVWS2LuzTEtN/8nI0/5tr2z4upA
         elmiOf1q2y/ZB4iLLZGEQImpXyiuTZXR89ljfU9qGdING4ud96OliBV9zjLRYgUtV1qY
         OhRg==
X-Gm-Message-State: AOAM530QC6QqDrthSuOtU+3uhdigTD4nIlzWVceAbYXDOMhy+VJvhho8
        EzigAUzikUM2ODqW/0C3nvM=
X-Google-Smtp-Source: ABdhPJws7+TgAwn1NyT+VwHvBHmc9s0nLhcI3AqdjgTNuJ34WOVQRXn44r30Qoq1PqYwYSgBlr33HQ==
X-Received: by 2002:a5d:438a:: with SMTP id i10mr26846202wrq.285.1629918197108;
        Wed, 25 Aug 2021 12:03:17 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id r8sm745891wrj.11.2021.08.25.12.03.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 12:03:16 -0700 (PDT)
Subject: Re: [PATCH for-5.15 v2] io_uring: don't free request to slab
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210825175856.194299-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <fdc23b62-87a1-f539-3f1c-f6d2f4080527@gmail.com>
Date:   Wed, 25 Aug 2021 20:02:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210825175856.194299-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/21 6:58 PM, Hao Xu wrote:
> It's not necessary to free the request back to slab when we fail to
> get sqe, just move it to state->free_list.

Looks good, with that we have a consistent behaviour of retaining
io_kiocb for all cases.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 74b606990d7e..c53b084668fc 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6899,7 +6899,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>  		}
>  		sqe = io_get_sqe(ctx);
>  		if (unlikely(!sqe)) {
> -			kmem_cache_free(req_cachep, req);
> +			list_add(&req->inflight_entry, &ctx->submit_state.free_list);
>  			break;
>  		}
>  		/* will complete beyond this point, count as submitted */
> 

-- 
Pavel Begunkov
