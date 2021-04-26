Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB4636B12B
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 11:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhDZKAC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Apr 2021 06:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbhDZKAC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Apr 2021 06:00:02 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38018C061574;
        Mon, 26 Apr 2021 02:59:20 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n127so17827569wmb.5;
        Mon, 26 Apr 2021 02:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k/HVo1sdMZ3lHA1hW8YpJjolWFsIMPFvy/KkOasa9DQ=;
        b=OflZgQ6LhG2mIhJYkEZExU3b4QpdeJzCDW48ELFyPi8jhi8YvnwO6d/n9YBaB/wgxt
         0NMhUV1Qyh5o2o6ZDcg0XSDdMsdzQXHwT8tFR5LWE01OuAyuA1qFYEACUB66Wbf9N1B+
         T7+Rv3ZuZUdXJ/rjo9C/p3PIKltoIMCJajbPQQD8z64p/UmoEZ/8SKqS//fSICO7y8sL
         qj/y/2UjaGncN+xo9N7XkZwrqUqQIl4KqKXi2+uAQ3J/VyrdTbw0riaqt4R+sbMjn6BT
         RHIeCfDKwF4lrajMa/bILMM6yCzy/g26GIwGJZLR/LTEAbFvAlD4NghChQDM1DVL04wl
         8wjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k/HVo1sdMZ3lHA1hW8YpJjolWFsIMPFvy/KkOasa9DQ=;
        b=MfXF+X0lA4mrP6cIsiEJpVAeoE9KK8k1J7UZyr7jIbZeu+nVFEyTTMuvN6kvX9uAsw
         59i17UX3KGVnyhO5/JhJBd9QhKiW6IyQXUa8b7J3mMZmPTW/zKz+lllmIQ5eineR7O1i
         a/ru9cOWJE1cCWi5sn+/QkmsA7iIM1lazsIzj2vAwkkDhoVPbFdGQsLXA93DMoumueR4
         DFXyv5pxstPEtap4ZFNWPZ+CNpEdVaafggxXg7U2CqD6V5pYmB3OfI9PzVcSqWBF7Iib
         jm4mOEo2FqDotavoHoTRpL8LWds5QKcE9Tf2pQY2zEmrIEKiq13Q/oUVfENFyhLEY4eH
         ft0A==
X-Gm-Message-State: AOAM531I+sRwJrji9wNyIfOK5q/zOVN7iVI+AQnMEKSjfbz7Nb8CigSb
        IF4iBb4S0e5zDffCiRbB8xvEygDS+/M=
X-Google-Smtp-Source: ABdhPJwcWlVYuR2sHgjF8N+b6Up7P+Yv60myleEG16/Rq0Vg5KjgsXXgX5dS2NZktsUGZA8rFy2ZpQ==
X-Received: by 2002:a05:600c:3541:: with SMTP id i1mr20237745wmq.97.1619431158793;
        Mon, 26 Apr 2021 02:59:18 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id f8sm16843957wmc.8.2021.04.26.02.59.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 02:59:18 -0700 (PDT)
Subject: Re: [PATCH][next] io_uring: Fix uninitialized variable up.resv
To:     Colin King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210426094735.8320-1-colin.king@canonical.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <ef9d0ed2-a8cd-fc4a-5b02-092d2c151313@gmail.com>
Date:   Mon, 26 Apr 2021 10:59:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210426094735.8320-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/21 10:47 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable up.resv is not initialized and is being checking for a
> non-zero value in the call to _io_register_rsrc_update. Fix this by
> explicitly setting the pointer to 0.

LGTM, thanks Colin


> Addresses-Coverity: ("Uninitialized scalar variable)"
> Fixes: c3bdad027183 ("io_uring: add generic rsrc update with tags")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/io_uring.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f4ec092c23f4..63f610ee274b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5842,6 +5842,7 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
>  	up.data = req->rsrc_update.arg;
>  	up.nr = 0;
>  	up.tags = 0;
> +	up.resv = 0;
>  
>  	mutex_lock(&ctx->uring_lock);
>  	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
> 

-- 
Pavel Begunkov
