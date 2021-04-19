Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E440A363FA5
	for <lists+io-uring@lfdr.de>; Mon, 19 Apr 2021 12:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhDSKeK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Apr 2021 06:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238670AbhDSKeJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Apr 2021 06:34:09 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57D5C06174A
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 03:33:37 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id g9so17419479wrx.0
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 03:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8z5gMgynMTq3M/ye0h5VAlTL5Ph1o6omEpu2AitnnVc=;
        b=dO6md5mqyyREm13B5xNmcbLmbStopT8m7qFqracTFK/PxDnodw6OPhO0xZxBoo9po+
         65F/7aKusaplNZaE2gA5yDbPI1w4MtVYH/MkxEHY0iryWaJSJ9yrWrDs4XOveVX/QOVH
         /QbvdiEEne1OPa+U5xb2hpuBKyByhbd0h5WZBmBejvtjOKcmCnGS784jIIuWUEbR61bf
         ljrycR0pgD1xWGuBU+7qJ5/ur4zy72t8YkMuJJWgpazTAStD4z5e2eqIZG0vGLmqkcSN
         o51r6hC9zDTvOmlEVqFN0TivQXKH/cyofUwq6H+bqN+6I0SmIAiT7SRo9PVzceR7FTYK
         Nk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8z5gMgynMTq3M/ye0h5VAlTL5Ph1o6omEpu2AitnnVc=;
        b=FS4s3vtDYF8Iz70EUg9OkF7bD5UK44qGnuq3KNUIzvUjpa/uR+8mIu5/QUO4JUc0Rj
         J8quVupUSHb/59/+wvTOynWJQ0v6En1CsaMzZQT0RsMt2DWB3wx8WZBf/z3FQA84oDnP
         ZQVZYuOMnJkOrGADyVZS7dJHDgqyMg84WN7FYlXJeiIBpJijyGEgKF8BGvZEY1/ZeoqU
         3lAP8hKmYLkyBNOl8u0Mm8l3ChU8+fZh8t6Foi1/3mw3dq4jE5P9TfyZHxK1ePKqNxF8
         k4pvGCCMzG8DXPnYeOW2CbD4wxlIRltOf2FZiqrUaYyJpbt88F0XKeK7Ee2GR+KfhlRW
         xrrw==
X-Gm-Message-State: AOAM533IT1Foyl8gEpQyVf/Ux7ihjjl/bconTusXfiV2Phq52D0OfGyE
        fFGCzTUexYoR+N+VLBBDQIuQtY08hM5q3w==
X-Google-Smtp-Source: ABdhPJx6/HOAH0Wh8MY5TTVSdTHM8JWwA36xR8cfKKDxST2Wx8pRv8tYS1gmV4ZHW7eFuLVZGmRAVQ==
X-Received: by 2002:a05:6000:1371:: with SMTP id q17mr13755035wrz.326.1618828416365;
        Mon, 19 Apr 2021 03:33:36 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.103])
        by smtp.gmail.com with ESMTPSA id y11sm20076149wro.37.2021.04.19.03.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 03:33:36 -0700 (PDT)
Subject: Re: [RFC] Patch for null-ptr-deref read in io_uring_create 5.11.12
To:     Palash Oswal <hello@oswalpalash.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <CAGyP=7cWH6PsO=gbF0owuSXV7D18LgK=jP+wiPN-Q=VM29vKTg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <a08121be-f481-e9f8-b28d-3eb5d4fa5b76@gmail.com>
Date:   Mon, 19 Apr 2021 11:33:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CAGyP=7cWH6PsO=gbF0owuSXV7D18LgK=jP+wiPN-Q=VM29vKTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/17/21 8:56 AM, Palash Oswal wrote:
> Hello,
> 
> I have been trying to decipher a bug that my local syzkaller instance
> discovered in the v5.11.12 stable tree. I have more details in [1].
> Could someone please review.

Can be, what is the hash of last commit you used? stable 5.11 is different
now, I'd guess it was fixed by

commit 0298ef969a110ca03654f0cea9b50e3f3b331acc
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon Mar 8 13:20:57 2021 +0000

    io_uring: clean R_DISABLED startup mess



> 
> [1] https://oswalpalash.com/exploring-null-ptr-deref-io-uring-submit/
> Signed-off-by: Palash Oswal <hello@oswalpalash.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8b4213de9e08..00b35079b91a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8995,7 +8995,7 @@ static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
>  {
>      mutex_lock(&ctx->uring_lock);
>      ctx->sqo_dead = 1;
> -    if (ctx->flags & IORING_SETUP_R_DISABLED)
> +    if (ctx->flags & IORING_SETUP_R_DISABLED && ctx->sq_data)
>          io_sq_offload_start(ctx);
>      mutex_unlock(&ctx->uring_lock);
> 

-- 
Pavel Begunkov
