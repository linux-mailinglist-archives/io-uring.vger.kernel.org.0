Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092215F0237
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 03:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiI3B0b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 21:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiI3B0a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 21:26:30 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C214313A073
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 18:26:28 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id b21so2705318plz.7
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 18:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Cg6k590d1gYe1qvzLK8US59eUH7WJXJdcnukMaAq5JQ=;
        b=h1bgzldX+/L9fXhKSk/XewnvXXMCnpgpXGG+N2Vrmw1HCHa2Ue3P1gJ7lte3NhLNQQ
         opK+geSBRBxre64a+lTdmBjopIL/SaVrmYu2tOsXNhLUrZzsi+1uC/7omK6b5UzWoMrU
         0s+n2Jt5Y7fRUSttfrhG9F9OFaCS+v/BB4zpkWDUFBPy7qgp0BYAj0/rj4sUlDwL5mqi
         lf6Dj936AuSMLz8c2Ts/9Gp1dt93hERti9oZ7/X4OSGNgSrMxOaiDlqtnUbMvvbdaS98
         8LuBaifjg5iqEfMuaYIueKFg4evNfIFH/KNja02Zt80LaLRRT/RSyj0XAI3hKP5OV+gV
         vUdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Cg6k590d1gYe1qvzLK8US59eUH7WJXJdcnukMaAq5JQ=;
        b=WXUd5pj2XUIbhoTFh1NYH0tY6GYp7fyn3t+TB869GZiwwFfuzx2ZAqhIet0zhB9cZH
         D7soJmIyePBKxjSNozm+zTCe/Xc4Ze47+HrD6zChnrAr23C3G5zjLVs4W5c7B1LiarBz
         fJEK4bxjzpi8p8ZsX05rB7w5kMZRswRLmERwxLXM0qHZNsLKVmuslXtY+BKnu9lX4MZW
         NBEde5/L0t0atK61q2v2dKOFWiNh3nang+OzarDwnE1HhMCXyKzbcU+O7MCf46n57I2M
         yLBtNxiYUlK+0KXAXttiD1lJkrMWRC1XfuXLYzfAraRPXzFzZB6CtBiwfctdHCIVGDx6
         ZISA==
X-Gm-Message-State: ACrzQf3zX+G0fswKfIiVd4h0If3lmlEqelo6ogiI7nofX0PkET3ZoKMS
        iSDkiEyVbwwOlSX4l6W3zLX+9g==
X-Google-Smtp-Source: AMsMyM54XYNL60ZKYJnXrSIFgmbWTCJkL3I8OdtaVHNuzxN6EhKViW84Cz8nyS9OLFnrbEHSDcY+kw==
X-Received: by 2002:a17:90b:3b47:b0:202:a81f:4059 with SMTP id ot7-20020a17090b3b4700b00202a81f4059mr19768268pjb.150.1664501188259;
        Thu, 29 Sep 2022 18:26:28 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s10-20020a63e80a000000b0042fe1914e26sm558361pgh.37.2022.09.29.18.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 18:26:27 -0700 (PDT)
Message-ID: <eaa47591-10e0-426a-6345-2881963be080@kernel.dk>
Date:   Thu, 29 Sep 2022 19:26:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH for-next v11 02/13] io_uring: introduce fixed buffer
 support for io_uring_cmd
Content-Language: en-US
To:     Anuj Gupta <anuj20.g@samsung.com>, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20220929120632.64749-1-anuj20.g@samsung.com>
 <CGME20220929121637epcas5p2ff344c7951037f79d117d000e405dd45@epcas5p2.samsung.com>
 <20220929120632.64749-3-anuj20.g@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220929120632.64749-3-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/29/22 6:06 AM, Anuj Gupta wrote:
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 6a6d69523d75..faefa9f6f259 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -4,6 +4,7 @@
>  #include <linux/file.h>
>  #include <linux/io_uring.h>
>  #include <linux/security.h>
> +#include <linux/nospec.h>
>  
>  #include <uapi/linux/io_uring.h>
>  
> @@ -77,8 +78,21 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>  
> -	if (sqe->rw_flags || sqe->__pad1)
> +	if (sqe->__pad1)
>  		return -EINVAL;
> +
> +	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);

After reading this and checking for IORING_URING_CMD_FIXED, this should
have a:

	if (iocmd->flags & ~IORING_URING_CMD_FIXED)
		return -EINVAL;

to ensure we can safely add more flags in the future. Apart from that,
this looks good.

-- 
Jens Axboe
