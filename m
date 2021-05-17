Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D433A386D98
	for <lists+io-uring@lfdr.de>; Tue, 18 May 2021 01:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbhEQXU5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 May 2021 19:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbhEQXU5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 May 2021 19:20:57 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3FEC061573
        for <io-uring@vger.kernel.org>; Mon, 17 May 2021 16:19:39 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x8so8086920wrq.9
        for <io-uring@vger.kernel.org>; Mon, 17 May 2021 16:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZJE7XAOqOcQAdFJVUX9PMqFD87/E1qfh8IIVsExRo8s=;
        b=uIGLOURRp3X6l7M43SN2vpX9kdhyMI106etwv9PfC7xNl2bNyMctQ/xdM3pYShsqgb
         U8Jd+8iaC0yMfdMCzp7Hmd3yn3zN0SRWd1yHP67YKQXeHQ7J/JOmlsz7NxiH8FjUJhgX
         /fjbNrFOlRPl1XprNH9oZUxMihC0K3nzbPFQUlFqFhfgPXhVUltd9H/JVJ93WbRULNIH
         ETaLdVC+wVhg5NzsvmAeLBmMoSnB6ecvxZ9ZtHkvoYWYvU6X6iEbLef0ywxt0aTJfcWm
         SXCht7m3p4ZJOjms5Fz46TtffSauqi+9XC06mJHjxcrQSU7BVE2ViWgIqd9ITOGMPVah
         FDLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZJE7XAOqOcQAdFJVUX9PMqFD87/E1qfh8IIVsExRo8s=;
        b=FsxnYfMRaDhUiTMoDQG2gQB7/ajm3A2t4eb19WEqFSEvtOgyL1X6xlmtrD5Zg6C8mp
         ZjZSV2WlhOxixDYttibxf2y1FxMymTm3rjux1v/paDURPM5qzNYTxsczyRiUd0SSOlEL
         3WYyfI6rmpRPX7prkqHER1PS7ovBjHUA/RjhIi1dVvtOLr523QPdRT9/dMd3bLhivZGa
         WHR+OW9tNDT60ZQTWO1Em4Ovv5oeZTUyTbODxUd4vRfN2M7YCB1+EWMouuoIOYVJvLcI
         nhPZFF2GOb8QmkU3VD8P6cQwWNYKCzJ8XeDL+YStk+Mf34+W31p5wNFCVKquK9Ml3D/o
         LQAA==
X-Gm-Message-State: AOAM531pm7cXWbeq1MCBaB4sXLFpeOTokDRQTrDgVaK9OHLprfJwO1DC
        7Z0kAEO5EdOEH2faXTFaoJY=
X-Google-Smtp-Source: ABdhPJwoK/kiG3rq+ZQgttOdgyQUsk3Lw1+JSisOQwxj97YKZhfxETFVsI0s3CbQDLXb/8U/xQgq8A==
X-Received: by 2002:adf:fa45:: with SMTP id y5mr2666750wrr.311.1621293578102;
        Mon, 17 May 2021 16:19:38 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.8])
        by smtp.gmail.com with ESMTPSA id a11sm1052085wrr.48.2021.05.17.16.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 16:19:37 -0700 (PDT)
Subject: Re: [PATCH] io_uring: add IORING_FEAT_FILES_SKIP feature flag
To:     Drew DeVault <sir@cmpwn.com>, io-uring@vger.kernel.org
Cc:     noah <goldstein.w.n@gmail.com>, Jens Axboe <axboe@kernel.dk>
References: <20210517192253.23313-1-sir@cmpwn.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <b836b9cd-e91b-7e46-ce29-8f32e24fb6ab@gmail.com>
Date:   Tue, 18 May 2021 00:19:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517192253.23313-1-sir@cmpwn.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/21 8:22 PM, Drew DeVault wrote:
> This signals that the kernel supports IORING_REGISTER_FILES_SKIP.

#define IORING_FEAT_FILES_SKIP IORING_FEAT_NATIVE_WORKERS

Maybe even solely in liburing. Any reason to have them separately?
We keep compatibility anyway

> Signed-off-by: Drew DeVault <sir@cmpwn.com>
> ---
>  fs/io_uring.c                 | 3 ++-
>  include/uapi/linux/io_uring.h | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e481ac8a757a..6338c4892cd2 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -9659,7 +9659,8 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>  			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
>  			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
>  			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
> -			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS;
> +			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
> +			IORING_FEAT_FILES_SKIP;
>  
>  	if (copy_to_user(params, p, sizeof(*p))) {
>  		ret = -EFAULT;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index e1ae46683301..1b0887ab4d07 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -280,6 +280,7 @@ struct io_uring_params {
>  #define IORING_FEAT_SQPOLL_NONFIXED	(1U << 7)
>  #define IORING_FEAT_EXT_ARG		(1U << 8)
>  #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
> +#define IORING_FEAT_FILES_SKIP		(1U << 10)
>  
>  /*
>   * io_uring_register(2) opcodes and arguments
> 

-- 
Pavel Begunkov
