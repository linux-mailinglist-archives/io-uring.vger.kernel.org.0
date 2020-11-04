Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373EA2A6F8C
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 22:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgKDVX0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 16:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728815AbgKDVX0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 16:23:26 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6A0C0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 13:23:24 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id p1so4433920wrf.12
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 13:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qUF+YwEN8aSVYsveNlUnGwWxFzY8Gsq5GTFJWft8bck=;
        b=b/tYceFa2OYKWRL1Cuie491KPaxIScFW8qH8Ym3oUcNnC/Z8jP/RaVZCsSFUK/3O54
         g2kdMG9RKLUELl5NuYNLK3E5Ve6JU7N6/PnBSuBc1l+jYCibv98jrEZPk43UNZWYsn3k
         4mxptik/xl4skVHotdwZrCuCYjc3j/wGeqC9da5AgZgNlR3nPmNn/LBts0lV28No15P/
         Yg6AKSfvG1bY3ZPGPxP4PsLPj/bRmkXi7GtFMJ3h/2Tc0Jo9e/MVqy+lm4kqJrNm1OKL
         sA7g0R1NLLkMNaF0ro0MeFHv9cnoo0vHlwP5UXr77bNayvKLRXT9NVGW37FuuI41PonM
         nCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qUF+YwEN8aSVYsveNlUnGwWxFzY8Gsq5GTFJWft8bck=;
        b=SpxM/jX/hXsxggfMhcRNyQGmgRRskOfM8yRTHtHV0d/9rk3VKAkFurSgylCCioGimS
         vIoEEk59mhX5nyYH8yFGLUhZrL3OvKRct2h5ZB5h9YOHULworDaBryCvPbxM8jhyTpPw
         uwCel7tpG1ZH2MEJjD5mt4kSq6VfL25vhVwvw+vswtH06/JJOwYdyLdOq2+ZWTrb2g3a
         rbvaIJjFjyhDa993LtRBEcH/L1Q/rOuWcrfp12EZaZhf8NX6xP8G9INQPR+4aTJZtXH2
         JS2cCwyc67WktMRBokvugau3paQLYIblPUoLqI4VoDywPQCujTEHop7WThMZqQ7+xUd8
         L6Wg==
X-Gm-Message-State: AOAM530XIuatOJ3DJUxFDY/bVT2cdSkbajbRKeKHOqngIeYhwPuNjV3S
        h64xr7yVpPh2T8MknlchNP+0f3p3T8M=
X-Google-Smtp-Source: ABdhPJwnRpt53ke+iYCQl8Omp4rxBdnkMkYvfLXFWVgyd10d5HqeZHG1GvQvo7Mqk6xHTS9wYVJtMA==
X-Received: by 2002:a5d:53d1:: with SMTP id a17mr33824152wrw.368.1604525003126;
        Wed, 04 Nov 2020 13:23:23 -0800 (PST)
Received: from [192.168.1.121] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id 4sm4521744wrp.58.2020.11.04.13.23.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 13:23:22 -0800 (PST)
Subject: Re: [PATCH v3 RESEND] io_uring: add timeout support for
 io_uring_enter()
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, metze@samba.org,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1604307047-50980-1-git-send-email-haoxu@linux.alibaba.com>
 <1604372077-179941-1-git-send-email-haoxu@linux.alibaba.com>
 <c2ae5254-d558-a48f-fca2-0759781bf3e1@kernel.dk>
 <052a2b54-017f-8617-5d1a-074408d164fd@kernel.dk>
 <fa632df8-28c8-a63f-e79a-5996344b8226@gmail.com>
 <b6db7a64-aa37-cdfc-dae3-d8d1d8fa6a7f@kernel.dk>
 <13c05478-5363-cfae-69b1-8022b9736088@gmail.com>
 <1d7cbae3-c284-e01d-7f7d-2ae2ab9cbb54@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <310a29cd-0dc2-69b0-7700-975af8025b71@gmail.com>
Date:   Wed, 4 Nov 2020 21:20:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1d7cbae3-c284-e01d-7f7d-2ae2ab9cbb54@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/11/2020 20:28, Jens Axboe wrote:
> On 11/4/20 1:16 PM, Pavel Begunkov wrote:
>> On 04/11/2020 19:34, Jens Axboe wrote:
>>> On 11/4/20 12:27 PM, Pavel Begunkov wrote:
>>>> On 04/11/2020 18:32, Jens Axboe wrote:
>>>>> On 11/4/20 10:50 AM, Jens Axboe wrote:
>>>>>> +struct io_uring_getevents_arg {
>>>>>> +	sigset_t *sigmask;
>>>>>> +	struct __kernel_timespec *ts;
>>>>>> +};
>>>>>> +
>>>>>
>>>>> I missed that this is still not right, I did bring it up in your last
>>>>> posting though - you can't have pointers as a user API, since the size
>>>>> of the pointer will vary depending on whether this is a 32-bit or 64-bit
>>>>> arch (or 32-bit app running on 64-bit kernel).
>>>>
>>>> Maybe it would be better 
>>>>
>>>> 1) to kill this extra indirection?
>>>>
>>>> struct io_uring_getevents_arg {
>>>> -	sigset_t *sigmask;
>>>> -	struct __kernel_timespec *ts;
>>>> +	sigset_t sigmask;
>>>> +	struct __kernel_timespec ts;
>>>> };
>>>>
>>>> then,
>>>>
>>>> sigset_t *sig = (...)arg;
>>>> __kernel_timespec* ts = (...)(arg + offset);
>>>
>>> But then it's kind of hard to know which, if any, of them are set... I
>>> did think about this, and any solution seemed worse than just having the
>>> extra indirection.
>>
>> struct io_uring_getevents_arg {
>> 	sigset_t sigmask;
>> 	u32 mask;
>> 	struct __kernel_timespec ts;
>> };
>>
>> if size > sizeof(sigmask), then use mask to determine that.
>> Though, not sure how horrid the rest of the code would be.
> 
> I'm not saying it's not possible, just that I think the end result would
> be worse in terms of both kernel code and how the user applications (or
> liburing) would need to use it. I'd rather sacrifice an extra copy for
> something that's straight forward (and logical) to use, rather than
> needing weird setups or hoops to jump through. And this mask vs
> sizeof(mask) thing seems pretty horrendeous to me :-)

If you think so, I'll spare my time then :)

> 
>>> Yeah, not doing the extra indirection would save a copy, but don't think
>>> it's worth it for this path.
>>
>> I much more don't like branching like IORING_ENTER_GETEVENTS_TIMEOUT,
>> from conceptual point. I may try it out to see how it looks like while
>> it's still for-next.
> 
> One thing I think we should change is the name,
> IORING_ENTER_GETEVENTS_TIMEOUT will quickly be a bad name if we end up
> adding just one more thing to the struct. Would be better to call it
> IORING_ENTER_EXTRA_DATA or something, meaning that the sigmask pointer
> is a pointer to the aux data instead of a sigmask. Better name
> suggestions welcome...

_EXT_ARG from extended

Also, a minor one -- s/sigsz/argsz/

-- 
Pavel Begunkov
