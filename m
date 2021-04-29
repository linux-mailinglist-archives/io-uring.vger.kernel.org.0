Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C1336E8CD
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 12:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240446AbhD2KdJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 06:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240272AbhD2KdH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 06:33:07 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CEEC06138B;
        Thu, 29 Apr 2021 03:32:20 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id b19-20020a05600c06d3b029014258a636e8so6334687wmn.2;
        Thu, 29 Apr 2021 03:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GbXkdlBZbDXm3nWFnvDWM+vsQZ7k+H4Y2BPygrAm+f8=;
        b=tHGtaRl0XFjOkbv9KxHi47FQ9wm57KtVLwyun1Rm2En/FH3CvdTzc0jgzdopPad88h
         wWzKLyb4s4/Sed0RwaHUJnRLFRlxzKu4FgABsVsGOiWF0KvjjGzn94wibriIvwDYsgqw
         Pr4DXwQog/jZXaT6dgUki9BY8iFjh7Bvh0AB4lEnClqGp2Lz/peTakipjt8eLH7Hl2uL
         t+sd1Owl9IfccBYnLRT2s8drPo6wFtDr8I03QLRLiNM3b8wNTVd5tN710Jdk4GE1yQIo
         8GhapvFNclM0E6LHo00At7s8IiW5RJCmBtQ7W0ofq27OQDQss/tghw7aTfJYdhRIj9pc
         sweQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GbXkdlBZbDXm3nWFnvDWM+vsQZ7k+H4Y2BPygrAm+f8=;
        b=oYq60EKEnY64wGauO08Lio01ajOZsNY1okTgJ635Do0NJsWeOOJH3QlnTf0L91rAFE
         h10Namfwh8YCk1qCvt1iLAmJ/13BklvX5P7D/Ouz5U1qZYdXbXDJF3pkWbTDNPVKaGkU
         /8qO+/y4oYOlrdga/jyHIDVNHx6/SrN/E3nv2ITM0fomIE5p7CGp/+GDUW4C+ZZRRVQp
         PFoKCkt2B5kqNAO2aCSJW+QjdEXEy6x6etdcY7GECY6SA7PkdiMIKah0xV844J/irkOy
         BWorIqIWQfTsH6kOnk2IQnmtxX+3vRkLshTvDIs/6RHuC4Z1IC2OOdlLIhGGw7Wmpmrw
         JSmA==
X-Gm-Message-State: AOAM531M4yv06tCnfbaGIqyJ/09eS5K9DJjdm6QisHbORBXHv+AAmRAs
        LyyzDMvPHQy4tKN0ubr2IdsFIBkhs9c=
X-Google-Smtp-Source: ABdhPJy2H3OLhiiKfpmXHW2Z4j4ElI9PQjtTxGeRdK4Q3i5r0ZUXk3VubEyEpAZ/LSDYzFOVQDVCjw==
X-Received: by 2002:a1c:6382:: with SMTP id x124mr9628040wmb.142.1619692339104;
        Thu, 29 Apr 2021 03:32:19 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id n10sm4129299wrw.37.2021.04.29.03.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 03:32:18 -0700 (PDT)
Subject: Re: [PATCH][next] io_uring: Fix memory leak on error return path.
To:     Colin King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210429102654.58943-1-colin.king@canonical.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <6929b598-ac2f-521a-8e96-dbbf295d137a@gmail.com>
Date:   Thu, 29 Apr 2021 11:32:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210429102654.58943-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/21 11:26 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the -EINVAL error return path is leaking memory allocated
> to data. Fix this by kfree'ing data before the return.
> 
> Addresses-Coverity: ("Resource leak")
> Fixes: c3a40789f6ba ("io_uring: allow empty slots for reg buffers")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/io_uring.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 47c2f126f885..beeb477e4f6a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8417,8 +8417,10 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>  		ret = io_buffer_validate(&iov);
>  		if (ret)
>  			break;
> -		if (!iov.iov_base && tag)
> +		if (!iov.iov_base && tag) {> +			kfree(data);
>  			return -EINVAL;
> +		}

Buggy indeed, should have been:

ret = -EINVAL;
break;

Colin, can you resend with the change?

>  
>  		ret = io_sqe_buffer_register(ctx, &iov, &ctx->user_bufs[i],
>  					     &last_hpage);
> 

-- 
Pavel Begunkov
