Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E839F2EBDCA
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 13:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbhAFMg6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 07:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbhAFMg5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 07:36:57 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15251C06134C;
        Wed,  6 Jan 2021 04:36:17 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id v14so2316079wml.1;
        Wed, 06 Jan 2021 04:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G/VeKHfcuzWWTxQn3qa7z4hN3mxOZhdJ75TP/eYuzO4=;
        b=jgnuThe/ltuZb6PteMNMmLl2AgeUulUGQraPSdVR4xIslPnqWWqEGulh6d8jFZj7zb
         XYUA3zqHB9CGMhdZEdRe++kSR+Dl32XGjiBnz26E6ov+04Resde4hFse7fveS0oAnXDx
         FKyqJAzjrVHNeW6W0fnLn3NAxbu1tJon5kI1xVaF/4rWztf7NEXp4EvunzsNf+ABhu/b
         R+cGSXbeyGSUuX+N0F+PMojRCcaX6+zR/r9ezcLvFa0URHA7dTetPsBmPjrEvkS/BbGz
         Cj6+I5AHmowuEkIxvMw8cWDinDiNOK3IA/fIu5R7txzfzsdZi1KSzmoR8JxTZUxedOAw
         UxCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=G/VeKHfcuzWWTxQn3qa7z4hN3mxOZhdJ75TP/eYuzO4=;
        b=VAWkwo30JccDIL67qbc++EdkH1eImK/fM2BZ1/OfeCY0OP87rd86S9EOSjK+oJ7TF5
         ecXWUJtUNMpDnEl6ageOWJtCHOglRUBBpuce0pkTEtfssEkdkXJEiGQkJGrificmwxe4
         dvT/d3o4WlTB8T8UFdSUfcggCZ3nE3i/IwmunQ3aD30AYzeg8CAtam01onYGRoMBgUmO
         1r7xgWYAfrmXeNdYI6LyUS3Lp4JgMOZEZ4CVFBpQb9tozXTAUl3x3J1LkEvl7iittAO2
         LkMcRpWdODbU6ayCC5Q5p41xap7Du0tyWKEhJZVdTpbq62EvPSgRXdqZob4FKxlnbj24
         vZRQ==
X-Gm-Message-State: AOAM530YrKW0eT/L143dFNMrBT6VRTnrVx+8uXho6RBPZV1Sie/JWzRF
        cSUSCnwu3ZLEUiIdyEgwpik8E2C1mik=
X-Google-Smtp-Source: ABdhPJyzjiJaerdYEaKYHoL2JpS8qp1nSTl2O+eLuhUDmC/+kMwGgbLGNyjUPFaGVYizt+1DPRkxgw==
X-Received: by 2002:a1c:e1c6:: with SMTP id y189mr3437237wmg.172.1609936575529;
        Wed, 06 Jan 2021 04:36:15 -0800 (PST)
Received: from [192.168.8.102] ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id h13sm3005776wrm.28.2021.01.06.04.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 04:36:15 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix an IS_ERR() vs NULL check
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <X/WCTxIRT4SHLemV@mwanda>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <c88d8500-681d-7503-77ca-ae10d230a11b@gmail.com>
Date:   Wed, 6 Jan 2021 12:32:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <X/WCTxIRT4SHLemV@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 06/01/2021 09:26, Dan Carpenter wrote:
> The alloc_fixed_file_ref_node() function never returns NULL, it returns
> error pointers on error.
> 
> Fixes: 1ffc54220c44 ("io_uring: fix io_sqe_files_unregister() hangs")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

thanks Dan,

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Cc: stable@vger.kernel.org # 5.6+

> ---
>  fs/io_uring.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ca46f314640b..2234ce03034a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7255,8 +7255,8 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>  	if (!data)
>  		return -ENXIO;
>  	backup_node = alloc_fixed_file_ref_node(ctx);
> -	if (!backup_node)
> -		return -ENOMEM;
> +	if (IS_ERR(backup_node))
> +		return PTR_ERR(backup_node);
>  
>  	spin_lock_bh(&data->lock);
>  	ref_node = data->node;
> 

-- 
Pavel Begunkov
