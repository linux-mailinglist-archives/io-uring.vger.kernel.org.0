Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940ED632B1C
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 18:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiKURfZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 12:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKURfX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 12:35:23 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C9CD22AC
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 09:35:23 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id r81so9140956iod.2
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 09:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NbXbP/OGIS8yFJO36lfD6OzaXaz25L4/fBO6OzyOg4w=;
        b=blKpYCuyCMuL6Rb8tiVkxOP7nZI37FdvBJbxwEyWzprKX1sdqlAY5kZziaE9AhDpT/
         y3vGA6D0/gQcrx6z3DR16iPx9cvV2aZgj0arIZf7g+FnuZ6YrAgsXV9tl7pcAZGDJzI9
         wHwFc/0hzxumZbmgLWsN0fzO3VHJlwFVSTQbts6K7EYtY/4DPNDZII27JtTSDgvHrILA
         HGy14S84BHony3kymD/ZRV6+XMAfkyukbxiuJiN3cVpzLOlj+cF93HVzvNa1L8vaikmD
         LqqCw048zR3lL96IzurZjhpWP1vtC21pKRbL/Wp82/GqOd9Qgt0Si9VTATD8LaVjWf+U
         +YVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NbXbP/OGIS8yFJO36lfD6OzaXaz25L4/fBO6OzyOg4w=;
        b=a8tTU9ClWddg2Lu8Hc+VTBllr81HurzFqIkNXcdfosVBulr6UFANEdntrB/XKN8o4v
         p1gpXmLxmuAxGL3HLPT7Vqxz1lgAi5m3NLboZIHJzs6zAB/5dTDx0AaNudbOYIdAU/Ac
         z9Cj1hGxHB2sAC+Ot+vA2gWyxlQztnte5Yssec9eAUVjrs37PulGX7aINiFPtsHTc/wi
         1kWTQu6ked/E+/Pv8fm0EYc9KLqJKgOLXD3c8nSWeYAkG3MkFlMSyauKYa0LrkrNv0ol
         z3nsAf2cNpl5xswe31xqLXRBIEOUX7HuZRseoE+ytjr7xI4rNqPpNffPdbbEk4iBLqrZ
         5MBg==
X-Gm-Message-State: ANoB5plH849x6rrfKTnZ12fcMZJPQwHPOxnovWGU5MEAbTrDhgjTMRUt
        dLRd7cWHtzwpYo2JyN54PD//RQ==
X-Google-Smtp-Source: AA0mqf44Saq0YN2zfJtZ/lfRbRtCkVg72HIlPrwencgASna47SdqI4iq17YSB9eCXjAMpRIq3Yh4/Q==
X-Received: by 2002:a02:cc84:0:b0:363:aec4:2c0d with SMTP id s4-20020a02cc84000000b00363aec42c0dmr2286408jap.266.1669052122405;
        Mon, 21 Nov 2022 09:35:22 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e16-20020a926910000000b00300e6efca96sm4069975ilc.55.2022.11.21.09.35.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 09:35:22 -0800 (PST)
Message-ID: <529345e2-5e13-0549-0f6b-be8fe091b8ff@kernel.dk>
Date:   Mon, 21 Nov 2022 10:35:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH v4 2/3] io_uring: add api to set / get napi
 configuration.
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, kernel-team@fb.com
Cc:     olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org
References: <20221121172953.4030697-1-shr@devkernel.io>
 <20221121172953.4030697-3-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221121172953.4030697-3-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/21/22 10:29 AM, Stefan Roesch wrote:
> This adds an api to register the busy poll timeout from liburing. To be
> able to use this functionality, the corresponding liburing patch is needed.
> 
> Signed-off-by: Stefan Roesch <shr@devkernel.io>
> ---
>  include/linux/io_uring_types.h |  2 +-
>  include/uapi/linux/io_uring.h  | 11 +++++++
>  io_uring/io_uring.c            | 54 ++++++++++++++++++++++++++++++++++
>  3 files changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 23993b5d3186..67b861305d97 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -274,8 +274,8 @@ struct io_ring_ctx {
>  	struct list_head	napi_list;	/* track busy poll napi_id */
>  	spinlock_t		napi_lock;	/* napi_list lock */
>  
> -	unsigned int		napi_busy_poll_to; /* napi busy poll default timeout */
>  	bool			napi_prefer_busy_poll;
> +	unsigned int		napi_busy_poll_to;
>  #endif

Why is this being moved? Seems unrelated, and it actually creates another
hole rather than filling one as it did before.

-- 
Jens Axboe


