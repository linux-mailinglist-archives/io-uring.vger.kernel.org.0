Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C450E38B9CF
	for <lists+io-uring@lfdr.de>; Fri, 21 May 2021 00:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhETWz7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 May 2021 18:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbhETWz6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 May 2021 18:55:58 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4BFC061574
        for <io-uring@vger.kernel.org>; Thu, 20 May 2021 15:54:36 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j14so17450317wrq.5
        for <io-uring@vger.kernel.org>; Thu, 20 May 2021 15:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j4W0XwPHzftaIPByi4+SpHlIAXCuShpdi1Ir29Kdh3Q=;
        b=phYxYU00E9IZfFr4GCl+k0uFq4TrQ0/j2hDyWXctGpZ9qA42Qki/6yO0PqgEF1R3Sc
         YqF3XtizGngVTo8or05OOVammmOmCLNdZ5cVQKpyscPpVxvqtolfAhINzQk1VDBHxL9b
         4EQNUs9EhXTzYxGN4eEEebdbLx2nQ4w2PO6d2QDdSIODipvmbVpWZcuTFaPxIjFCqwSx
         r1MDp5hD1d756XtNYxPjhxQPam9IjNUoNeK9pccP4/iYXjF4A06Y+yUzd0lmDTz8UXUf
         T7Voc76uTBAnrRHZ4TNggSVf5B/fmDF4Y8urXxcyaqv6fGLBt3mOBOdVwluXLHzo38By
         5aKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j4W0XwPHzftaIPByi4+SpHlIAXCuShpdi1Ir29Kdh3Q=;
        b=sx2SlRZ/Oq+M98pWMGRMW1HDGxd9Rf4dX3FBv4gG1uBWQp7mIC74Z8qxD8SGFycG7n
         pMeVzMfRZJzVn88+3Xxt9WBlbfIun842UFqeMhuZSg3nIabvVWmlpFVLfQ3vBIN/ONTk
         Ef7vHVUxcsGRKQg/i1ij7HPVUrEHf2sQmMLnUzYCS2ZpszImIeAslspH8adDRrkzijzn
         j9sdskaP3zshh5oak0uchrur519LqSVYfFLTJf9QrRTHlNhWUVabtKh+ogs8BHC0OBaj
         1ojZwaNzGK+s7VHHNV8S3mQGHWacYNiAFttrXRJKxx3a/Pix9GZUZ21R9DCoiUflmtjR
         QD6g==
X-Gm-Message-State: AOAM5302l1JPIJgawgvQT4WLaLPwXo7HL8Rfd9E03j1lhNGOMlwkmTGP
        YAIYd6PeCiy0U/e2ie+NmEA=
X-Google-Smtp-Source: ABdhPJwT/PqfIfq6Z3R7itvnD1bO1+DRgwXfijLecjAMNRrqsh7+oi2Eou5G3rDzxLuhAsc//azj8w==
X-Received: by 2002:a5d:4351:: with SMTP id u17mr6246735wrr.47.1621551275469;
        Thu, 20 May 2021 15:54:35 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.182])
        by smtp.gmail.com with ESMTPSA id i1sm4605288wrp.51.2021.05.20.15.54.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 15:54:34 -0700 (PDT)
To:     Drew DeVault <sir@cmpwn.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     noah <goldstein.w.n@gmail.com>
References: <20210518161241.10532-1-sir@cmpwn.com>
 <2bbb982d-c9a4-8029-83e8-3041327e04dc@kernel.dk>
 <CBIEOQ7BRJ0Q.3O3QZBY0ZZPFI@taiga>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] Add IORING_FEAT_FILES_SKIP feature flag
Message-ID: <ffc6e349-3834-a380-fc2c-c58bc15827bf@gmail.com>
Date:   Thu, 20 May 2021 23:54:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CBIEOQ7BRJ0Q.3O3QZBY0ZZPFI@taiga>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/20/21 10:55 PM, Drew DeVault wrote:
> On Thu May 20, 2021 at 9:32 AM EDT, Jens Axboe wrote:
>>> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
>>> index 5a3cb90..091dcf7 100644
>>> --- a/src/include/liburing/io_uring.h
>>> +++ b/src/include/liburing/io_uring.h
>>> @@ -285,6 +285,7 @@ struct io_uring_params {
>>>  #define IORING_FEAT_SQPOLL_NONFIXED	(1U << 7)
>>>  #define IORING_FEAT_EXT_ARG		(1U << 8)
>>>  #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
>>> +#define IORING_FEAT_FILES_SKIP		IORING_FEAT_NATIVE_WORKERS
>>
>> I don't think this is a great idea. It can be used as a "probably we
>> have this feature" in userspace, but I don't like aliasing on the
>> kernel side.
> 
> This patch is for liburing, following the feedback on the kernel patch
> (which didn't alias, but regardless).

This file is a copy (almost) of the kernel's uapi header, so better be
off this file and have naming that wouldn't alias with names in this
header.

I think that's the problem Jens mean. Jens, is it? And I do still
believe it's a better way to not have an itchy one release gap
between actual feature introduction and new feat flag.

-- 
Pavel Begunkov
