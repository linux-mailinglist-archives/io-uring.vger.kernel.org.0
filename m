Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72E051E7B7
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 16:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380867AbiEGOUP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 10:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354008AbiEGOUO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 10:20:14 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B422141312
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 07:16:26 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id p6so9436069pjm.1
        for <io-uring@vger.kernel.org>; Sat, 07 May 2022 07:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=V53ybjNDIR64uWsnk5UET/HbnU6X5f+PNP2IOjTo9Go=;
        b=PtnlY1gnHBy0DixsZp6Dcxn7UuylJTNR/SHFPHKnGaJ37obj7YFJxB2xz9FmIjN7OL
         FdscGNnHWi3mLy1DXsRVSS1/0g7fuch//nPbj31s3GYfsxn/LeZlokCLxUW59zdWzo18
         Ybc6mKrMnDEZEDPxfLv7bzNmKE8ivaHHYshf0NWd5IcCHY5TggQ4MvtcUIh7A8bV4hWn
         pPOIC8Nsqom/ozaS0Pktka92lEBV+GCjfnY8E0oPEX9HT+XM7EDRAJs7L0qoQ/jRldj6
         ycxIPP9dRVxGAzjBQiR53bGD7jynM1Gu7Zg/jwpAN5lSUiWm8a0PoqkwcGexXv1fobx7
         NvxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V53ybjNDIR64uWsnk5UET/HbnU6X5f+PNP2IOjTo9Go=;
        b=X03fCiQHXkIa8tlL3WNzcYkbeF5Yt4YaQMDdo+QuMHamCTYmtTxM2Dic8omprEwghL
         qKUh9tDEpyDUzpXdQRYpVM9/HKxkJ+GLJDxqnB2SN6k6Q8lXEsiaflvsvsP1hWFuVAfn
         dCgB++W0JbYImZaHc/NIhUWh+pZ3JBXRHQuIc1bEVHFvJXZxaZukNLFnXL9b4y/QQuUb
         wlzGDnWK3EVuGl6uK39rUFjClohMvixrz2dFn3GDp5QcN/wg8vWILY0Opf5jZaSpZ/Yi
         NsbM/UBPIS0tdg5UnVdAzArQA5H7G46ZEQEZrHIRGKtzeRQMSgyZnEub9C/iJXAu/Yyg
         EOCA==
X-Gm-Message-State: AOAM530VEndG7onU1bBFBRY3FXdr0H5lw9xnU1ZZMK1rH+VJsE4vczUE
        /ottT3ZpNZWUlSy8lpoCBnm5TQ==
X-Google-Smtp-Source: ABdhPJzNMImt9jDJpUexhsyBh2o7xe0e4/7BXGyxz7u8kl9rsxaGKNB/MxE0RNmvbC3GIMQOQPQX0g==
X-Received: by 2002:a17:90a:7c4c:b0:1dc:26a1:b82f with SMTP id e12-20020a17090a7c4c00b001dc26a1b82fmr9568656pjl.148.1651932986168;
        Sat, 07 May 2022 07:16:26 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f70200b0015e8d4eb2cbsm3712190plo.277.2022.05.07.07.16.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 07:16:25 -0700 (PDT)
Message-ID: <21e1f932-f5fd-9b7e-2b34-fc3a82bbb297@kernel.dk>
Date:   Sat, 7 May 2022 08:16:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 1/4] io_uring: add IORING_ACCEPT_MULTISHOT for accept
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220507140620.85871-1-haoxu.linux@gmail.com>
 <20220507140620.85871-2-haoxu.linux@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220507140620.85871-2-haoxu.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/22 8:06 AM, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> add an accept_flag IORING_ACCEPT_MULTISHOT for accept, which is to
> support multishot.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Heh, don't add my SOB. Guessing this came from the folding in?

> ---
>  include/uapi/linux/io_uring.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 06621a278cb6..f4d9ca62a5a6 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -223,6 +223,11 @@ enum {
>   */
>  #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
>  
> +/*
> + * accept flags stored in accept_flags
> + */
> +#define IORING_ACCEPT_MULTISHOT	(1U << 15)

Looks like the git send-email is still acting up, this looks like
v2?

-- 
Jens Axboe

