Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C4447C50D
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 18:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhLURcv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 12:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhLURcv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 12:32:51 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DC9C061574;
        Tue, 21 Dec 2021 09:32:50 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id bg2-20020a05600c3c8200b0034565c2be15so2260562wmb.0;
        Tue, 21 Dec 2021 09:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6TAi1T4m7vwlDw2N+ktNv0MdRsmpYSgXdgAq3T79/4s=;
        b=XIyM9YOatEk1MZlES9L723GUIGIXTg44gfibPFvoOOK/CnoKAa+yp/E/SsCz2maP/+
         QOdE8MbMb73HqD1P11+kiJPiIl8GXBS1Mk9XbtS7Izu1yr01sEHy4dhuvy8iuIF/Tmvv
         fEMSh3qu1tbLW3z2ntZoybcTYyB+ukZv3hRAcKSkwFa/0kNLCHMYnLlH/E3rxDG39Iqh
         JBFj9gIWryVMtNmLRHlxL+caWeLKqCFmsX8I0hzTtT74gHNsiENrheX+75EnbVCfxo73
         P+2/bHxg+8Tmv7v9qwzCpk+sbnFBSnp0lYp2LhX1zS5fp2MQrgtp+r9MH/NwHMXcNzQt
         tn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6TAi1T4m7vwlDw2N+ktNv0MdRsmpYSgXdgAq3T79/4s=;
        b=frpXknmMYpJoyFhywRYEYRDp5Syf/cpNhy9hU1K0/6RsoefrgonEhIfqu8omZNe5QU
         Arksbesf0MdNFoBSq3PnMP9JUMvPicL/1zFLrIm5nfA13/XATPpbqRmvvC1ZkXyPrV5f
         Qxv+m3a7V3wSdEqNR5257nwbuzFe4XGT6odyjMejfOhl+z9Bqm8a5rQCTpgu1N0qVudT
         tPQLK2TwNd3dy5VfaMPMP56A3wmcvFI0L7JodUHkq4qqvbLUpGj5dBWG5CnOHGwGcouW
         /0BpuvafeND2Xx6IpDZCyeYF/RnV0SlDvoUVNvBbut+3IhadzKp0vfNZiFncZniV+8ZF
         PoWw==
X-Gm-Message-State: AOAM532z+/Nd3qeervoJOsjyv2qGVKcppAFZ2ZeCYugYNwZnuF+45qDz
        PrnIN+e2pYZ7RPyJN3ETZDk=
X-Google-Smtp-Source: ABdhPJycLTMDz3SQnxWj9+MRtDs4mqU0fPH//fyE1Uv88Qh9sFmrISVsGP0t0qu82IQx38T3TUrjgQ==
X-Received: by 2002:a05:600c:5010:: with SMTP id n16mr3599481wmr.139.1640107969342;
        Tue, 21 Dec 2021 09:32:49 -0800 (PST)
Received: from [192.168.8.198] ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id n14sm22052537wrf.69.2021.12.21.09.32.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 09:32:48 -0800 (PST)
Message-ID: <0d38a455-f619-042b-85de-d8194e0f792b@gmail.com>
Date:   Tue, 21 Dec 2021 17:32:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v4 5/5] io_uring: add fgetxattr and getxattr support
Content-Language: en-US
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com
Cc:     viro@zeniv.linux.org.uk
References: <20211215221702.3695098-1-shr@fb.com>
 <20211215221702.3695098-6-shr@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211215221702.3695098-6-shr@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/15/21 22:17, Stefan Roesch wrote:
> This adds support to io_uring for the fgetxattr and getxattr API.

Same comments as with 4/5, only one additional below

> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>   fs/io_uring.c                 | 150 ++++++++++++++++++++++++++++++++++
>   include/uapi/linux/io_uring.h |   2 +
>   2 files changed, 152 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index fc2239635342..c365944a8054 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
[...]
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index dbf473900da2..cd9160272308 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -145,7 +145,9 @@ enum {
>   	IORING_OP_MKDIRAT,
>   	IORING_OP_SYMLINKAT,
>   	IORING_OP_LINKAT,
> +	IORING_OP_FGETXATTR,

Even though it's just one-commit gap, it's not great changing uapi,
e.g. +1 to previous IORING_OP_FSETXATTR. It may actually make more
sense to keep xget and xfget closer together because you're reusing
code for them and compiler may _potentially_ better optimise it,
e.g. ifs in switches.

>   	IORING_OP_FSETXATTR,
> +	IORING_OP_GETXATTR,
>   	IORING_OP_SETXATTR,
>   
>   	/* this goes last, obviously */

-- 
Pavel Begunkov
