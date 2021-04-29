Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3B736E9BB
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 13:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhD2Lp4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 07:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhD2Lpz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 07:45:55 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE127C06138B;
        Thu, 29 Apr 2021 04:45:07 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 82-20020a1c01550000b0290142562ff7c9so6503311wmb.3;
        Thu, 29 Apr 2021 04:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F/E93CRR5FQ463ng5fsR0yJfZQcAbVR1kzGbCsVjcsM=;
        b=sI9Ui8m9o3qQiQBmaDpT7Kbk4HWncskcTosi2V1YtnxOxHoEhYll9gRZvSTKT/FXdX
         XeiFUu8W2qRNW6IwrOSstna5nTK0/E8+YDtAxIvEtdemwkg40Inx+QGOuXI82k1ObEx3
         +XaxuZEofDivKU4QMDj+o8q9ij+PTdbN+5q0INwOx+W6kGN5zzHIYhLH8IalyGg7Slwv
         QuJh4RDpopDoEXjmLmtzzaTnSwj0zXkjw9sPHB0ALS1Y0wRYNFxx2GOxuFpLmfg7PsJ1
         DZrDGjPRdPctUsqMHrRM/9JeRS8km5kAm8Vnvo1Tk/Dh4xiw8AYBNTBqgNOoOs9DPiBh
         9jUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F/E93CRR5FQ463ng5fsR0yJfZQcAbVR1kzGbCsVjcsM=;
        b=EF/0JwEUblDfDuwUjQMJSl0qjguwEXJdJP1jA1Qs1D0bQe649e0myOtJOKVErhk1pu
         VPckbtW/e6bYRhgjSAqH2xEJqEGnydVLBuBQnMeZHTZ08ZPal6K6VpiPpKl85b9u7cSY
         DK+9xIdaxk6ms5ZFHGqLQPRIO3lppdIYB8CJYmv1RZKhwaxpL1ymgM/39irpXGTk/R9e
         fnRfEaR9xFhLOThOVLOiTADoS0jnJpuvUmqNsY1AgmFb6qZ6ZTueXoRTOePEaAx6uCbO
         pSQsj3zR54sqR6bmcYihGaSNCwdgfPI5lfUFf8k8Xw3qFdzVw4khabL8Jv2q2hn6CVU2
         qf1g==
X-Gm-Message-State: AOAM530WlLus1HFvKm833bn21hWdQYp5H5OsUxjsCCxkQz8CqfyrwTDA
        vDy4nqv4pGP+MHtKJD+kvt4qHNQWfHE=
X-Google-Smtp-Source: ABdhPJxyaXwzqJgFghBRmR1lYh/G//aPzgSelniw6V8gNedEaFZTuBR2679knDVqnMNPUSZBJYYR2A==
X-Received: by 2002:a05:600c:35cc:: with SMTP id r12mr9991089wmq.147.1619696706253;
        Thu, 29 Apr 2021 04:45:06 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id k15sm4379209wro.87.2021.04.29.04.45.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 04:45:05 -0700 (PDT)
Subject: Re: [PATCH][next][V2] io_uring: Fix premature return from loop and
 memory leak
To:     Colin King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210429104602.62676-1-colin.king@canonical.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <5c8db42c-3b5c-be23-1c4e-f7438fe02e54@gmail.com>
Date:   Thu, 29 Apr 2021 12:45:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210429104602.62676-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/21 11:46 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the -EINVAL error return path is leaking memory allocated
> to data. Fix this by not returning immediately but instead setting
> the error return variable to -EINVAL and breaking out of the loop.
> 
> Kudos to Pavel Begunkov for suggesting a correct fix.

Looks good, thanks
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> 
> V2: set ret/err to -EINVAL and break rather than kfree and return,
>     fix both occurrences of this issue.
> 
> ---
>  fs/io_uring.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 47c2f126f885..c783ad83f220 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8417,8 +8417,10 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>  		ret = io_buffer_validate(&iov);
>  		if (ret)
>  			break;
> -		if (!iov.iov_base && tag)
> -			return -EINVAL;
> +		if (!iov.iov_base && tag) {
> +			ret = -EINVAL;
> +			break;
> +		}
>  
>  		ret = io_sqe_buffer_register(ctx, &iov, &ctx->user_bufs[i],
>  					     &last_hpage);
> @@ -8468,8 +8470,10 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>  		err = io_buffer_validate(&iov);
>  		if (err)
>  			break;
> -		if (!iov.iov_base && tag)
> -			return -EINVAL;
> +		if (!iov.iov_base && tag) {
> +			err = -EINVAL;
> +			break;
> +		}
>  		err = io_sqe_buffer_register(ctx, &iov, &imu, &last_hpage);
>  		if (err)
>  			break;
> 

-- 
Pavel Begunkov
