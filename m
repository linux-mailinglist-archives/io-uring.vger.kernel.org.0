Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2211C30E021
	for <lists+io-uring@lfdr.de>; Wed,  3 Feb 2021 17:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhBCQwq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Feb 2021 11:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhBCQwn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Feb 2021 11:52:43 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D52CC061573
        for <io-uring@vger.kernel.org>; Wed,  3 Feb 2021 08:52:02 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id m1so312067wml.2
        for <io-uring@vger.kernel.org>; Wed, 03 Feb 2021 08:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kf706VcSAXbAj2XVDsgmi+g2rWu12h/5oMzwlXif2LU=;
        b=EJm9DdUTHYjBGyzgkXKwqphgNvcdMsMLPRFavqa2NAXNgPS9WWLLeUu40HmAG0R9Uw
         ohNg36XJIZZ9OetmUO026S5Euj5+7dRMEtOCkwXWwn1fMnnXK+EAuwEJ4SgXDujjFgzH
         ZiXGJbjsnMzauEhSyXRs15GooMt2LoC3X5FGp3uR1WDtK4uCbo7BucbwadeXOHXY1bNi
         A1oK9Uak3h/h199mnxA/XXBkdIP01pT3u2uVuh+0PVTV8rQMV8efD7RxVbduz3WoyHhW
         Ty583ZD9X82Op1UYY6Y8uz2RbqVbZgx04vP7BlzepJWBbgpN9Wj96kSUZJQnAiz8Dj9i
         8zZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Kf706VcSAXbAj2XVDsgmi+g2rWu12h/5oMzwlXif2LU=;
        b=mHXsfka1tnztsn9lmWEEH0cl0nwfqE8t6xOCkZif5SKcYXPDCoWF6G5dg7BwfNrZyi
         bi+VXQ+Ck8cDgHOVG9uHEQ0usYnrZ8vxiicKfY1LIq6oYGkWIeub/3QvE/Ft1vpR9Yb7
         T+CB+T5OPKf9YyF6+Lx1912A3odYX0xLV5lijNZPe4JVkTqALTsoBaooVAN0TdF/29FW
         RRCL3MSvspFTTPnGiJrhBg5ulPOQCIi4wE+fvbkh+qXGm7fr479BMYxJZEj9Gyrp7iMm
         AhetjHrzsCnwTV05pz6Seuc+ghCydA5bacs1Ey8/4jJCLvmm5LR30UG2LsZyeZnNi03G
         kW+g==
X-Gm-Message-State: AOAM531UdEZ4viUKxk8E+ZpxkeDSDrqrf1YG3zOl6uFa0UdYFxm4Sg8G
        WoAtsDqXIRPC3N4O1dtVZTcwA7CRk2I=
X-Google-Smtp-Source: ABdhPJyIDQG3lw4ls7iw/BnyuMW6filVFeBmw8TycIde1HSk9O9i5r8e3qkl8n+G20WsmduBX1IQVQ==
X-Received: by 2002:a1c:408a:: with SMTP id n132mr3568275wma.86.1612371121462;
        Wed, 03 Feb 2021 08:52:01 -0800 (PST)
Received: from [192.168.8.171] ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id d23sm3306291wmd.11.2021.02.03.08.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 08:52:00 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix possible deadlock in io_uring_poll
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612295573-221587-1-git-send-email-haoxu@linux.alibaba.com>
 <9d60270f-993b-ba83-29a0-ce6582c383e0@gmail.com>
 <5f0db9bc-700a-e0f5-a77c-9acfe4e56783@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <dd01985d-477a-7af4-36ba-99e4e2f8d339@gmail.com>
Date:   Wed, 3 Feb 2021 16:48:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5f0db9bc-700a-e0f5-a77c-9acfe4e56783@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/02/2021 01:48, Jens Axboe wrote:
> On 2/2/21 5:04 PM, Pavel Begunkov wrote:
>> On 02/02/2021 19:52, Hao Xu wrote:
>>> This might happen if we do epoll_wait on a uring fd while reading/writing
>>> the former epoll fd in a sqe in the former uring instance.
>>> So let's don't flush cqring overflow list when we fail to get the uring
>>> lock. This leads to less accuracy, but is still ok.
>>
>> if (io_cqring_events(ctx) || test_bit(0, &ctx->cq_check_overflow))
>>         mask |= EPOLLIN | EPOLLRDNORM;
>>
>> Instead of flushing. It'd make sense if we define poll as "there might
>> be something, go do your peek/wait with overflow checks". Jens, is that
>> documented anywhere?
> 
> Nope - I actually think that the approach chosen here is pretty good,
> it'll force the app to actually check and hence do what it needs to do.

Do you mean that good is this 2-liner? I pretty like it... unless there
is a userspace app that would be broken with the change...

-- 
Pavel Begunkov
