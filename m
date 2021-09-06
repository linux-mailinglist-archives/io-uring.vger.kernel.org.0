Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBD8401D8F
	for <lists+io-uring@lfdr.de>; Mon,  6 Sep 2021 17:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243028AbhIFPYT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 11:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbhIFPYT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 11:24:19 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A1AC061575
        for <io-uring@vger.kernel.org>; Mon,  6 Sep 2021 08:23:14 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id d6so9728104wrc.11
        for <io-uring@vger.kernel.org>; Mon, 06 Sep 2021 08:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a0eu3hPCqTxl2HIZHRdIbOrCbpU03oTcOI40P++LMpY=;
        b=mX3VGBCe3WIjvqc3zy0nhM95qGMkq4xUL0Vaymg0EF12GcLoguVeuZyzuYJBS3MhYX
         JPsbTWEeE7liTzQuw5saSBQHQyqg4y+WSfy9Dzqq9dEYeCBcaIFNHBUPDMo326U0QiEU
         whv3V3aIzwESDhOMixgdAb+1E4Zfrr4kUeMl9VerT3A7A+3ISBxdJGaoYhu2wlLkaL0Q
         vIdWiWOqgS0mFHnUR6BjzFri4EPXiBitlAHm7TPcQO2pgrFVQB3irDTn1lCK7IlAMLWV
         uHg4v7KcA1DDTqai7CNUUGWyDYn/Sawo2a7coigmahQ2RwN6E07FTtI91FP8CIPj9DRK
         KMnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a0eu3hPCqTxl2HIZHRdIbOrCbpU03oTcOI40P++LMpY=;
        b=VOOaLIYyQyyJl720BsT3y9mhHMfpqoTRwkgIbbs9JvDuJSAjLqCKNhJyEXKAuyneuA
         MF/wGLf6QPlb40we2WULiPMMI5o4G7bkREuPMKc+flhllb8xSogM/qtzkxm1Nb7OWCP4
         kedEr6lMBiRszvqVOe7CFnCzmfCGjPsTNyAgTJ78M1+nta6m/Po/W/MgUoUgFS7xHTTK
         NPSJ2zW8SYjWMIW0HtjHs9WZpwSKArnotsA6SIX1uG7WBgz3VnKW3iBp21ErZcCUpXuF
         yofRt2XK8zYS94mrP6ChEE4DtzDWiO5v175Gr6awG4fj1aXhFJ5zXTLkr4SuQH+Omsf+
         ceKQ==
X-Gm-Message-State: AOAM530S6vZnFGcDihctEcIaoOKba/202x4+MAOAX274tsRm4eeF/ug6
        jxluD0NJkOP18lBAvNsXFWBfZpp2D9Q=
X-Google-Smtp-Source: ABdhPJy8RPOqP0W2fCmCJqLFRd41TqRPHmxnoaJb0EO57nrxWxgORaMyWmcJrYV3Kt96pyXz7AaNAw==
X-Received: by 2002:a5d:504f:: with SMTP id h15mr14323367wrt.69.1630941792711;
        Mon, 06 Sep 2021 08:23:12 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.4])
        by smtp.gmail.com with ESMTPSA id p3sm8025300wrx.82.2021.09.06.08.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 08:23:12 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix bug of wrong BUILD_BUG_ON check
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210906151208.206851-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <f3857fde-7b3d-3d4f-9248-18a5387b8f79@gmail.com>
Date:   Mon, 6 Sep 2021 16:22:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210906151208.206851-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/6/21 4:12 PM, Hao Xu wrote:
> Some check should be large than not equal or large than.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2bde732a1183..3a833037af43 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -10637,13 +10637,13 @@ static int __init io_uring_init(void)
>  		     sizeof(struct io_uring_rsrc_update2));
>  
>  	/* ->buf_index is u16 */
> -	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
> +	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS > (1u << 16));
>  
>  	/* should fit into one byte */
> -	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
> +	BUILD_BUG_ON(SQE_VALID_FLAGS > (1 << 8));

0xff = 255 is the largest number fitting in u8,
1<<8 = 256.

let SQE_VALID_FLAGS = 256,
(256 > (1<<8)) == (256 > 256) == false,  even though it can't
be represented by u8.


>  	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
> -	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
> +	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
>  
>  	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
>  				SLAB_ACCOUNT);
> 

-- 
Pavel Begunkov
