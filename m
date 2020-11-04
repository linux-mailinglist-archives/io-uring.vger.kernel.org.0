Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4C52A6EB0
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 21:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730264AbgKDU20 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 15:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728305AbgKDU20 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 15:28:26 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9EDC0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 12:28:26 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id x13so18257430pfa.9
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 12:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PQsd4+jP3yzDo6RhjyCPNMovCuCcflF7wo3kJWvgIww=;
        b=knVWfLvWOuqt61mfuA/BfP5ONek/w0Qsd44+r6YVDYHQKX6b6/9U8ke1cMgEhKQ0Qn
         a0rKzLm3/pSW3Vo8DsEzAFF6uWzsPrjjXR9z+dygw0bvoICXmvz4OAbKigOyZ6if8Te8
         02z7SaM9e9sZ7MoM0GPZ6zq3iVcKesquOsYmrBzZHIS1cTl5qR5VTs6AictcV0LMaMRR
         cYJH0tj837V+G8hMrKl5XIh1p27hp7D+tyvNEbtaMMRMM+JDmHPXKBP1viaC2rWqEMM3
         114hB3Mry9p/i9lmkOIv7FVSFaz0umSP07tdaUatKP5WOH8w4aVXApzIGmIcE3ZMYajU
         Anpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PQsd4+jP3yzDo6RhjyCPNMovCuCcflF7wo3kJWvgIww=;
        b=s8H7ta3BAiU7nFf5tTkwTfIX4NesC9JQoBR51CEwItTrMEId6MkRUv8/9rva38GV6F
         8SnjfMt7r80GjBLkXKHR+JC9n09nym4LfKG6KN4wAU207Ge0+dbXZcrvwgMmlsF41OoD
         +2D/yeMlP6yQmC6B8nWyEBn6Bmzi26PDohgvOLrZHqxIz1k4pekKjSld/K/hJpvTNpv9
         ZjNk9/PiZ2IDm9P8q3k190g9VaxRXmtx77aGWhbDbC4q1eGvS8Ps4Ej/SjDtwVEjYoGz
         P9GeQaHFirhSO5t+4lO3dlFM/MTOTbpvfgUMkPDIW6P2B9ei1pZFEJOBtYDnoffdUCrN
         urqA==
X-Gm-Message-State: AOAM532uELA2rztSLxG6G2XGfHk5cCFaEFdXPAjJc4T3dhDxjPdkW1jL
        erxfCqbFIgJUaIYh7BEPMcCuiw==
X-Google-Smtp-Source: ABdhPJxHdjhoIIWqTxcDXOE+VOXKLF4lNQZZB3Tz3J5gxbGFuufJkZJF0Vch3WP44rsPniJ7RNBVYg==
X-Received: by 2002:a17:90a:a602:: with SMTP id c2mr5984121pjq.224.1604521705676;
        Wed, 04 Nov 2020 12:28:25 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l7sm3326408pja.11.2020.11.04.12.28.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 12:28:25 -0800 (PST)
Subject: Re: [PATCH v3 RESEND] io_uring: add timeout support for
 io_uring_enter()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1d7cbae3-c284-e01d-7f7d-2ae2ab9cbb54@kernel.dk>
Date:   Wed, 4 Nov 2020 13:28:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <13c05478-5363-cfae-69b1-8022b9736088@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/4/20 1:16 PM, Pavel Begunkov wrote:
> On 04/11/2020 19:34, Jens Axboe wrote:
>> On 11/4/20 12:27 PM, Pavel Begunkov wrote:
>>> On 04/11/2020 18:32, Jens Axboe wrote:
>>>> On 11/4/20 10:50 AM, Jens Axboe wrote:
>>>>> +struct io_uring_getevents_arg {
>>>>> +	sigset_t *sigmask;
>>>>> +	struct __kernel_timespec *ts;
>>>>> +};
>>>>> +
>>>>
>>>> I missed that this is still not right, I did bring it up in your last
>>>> posting though - you can't have pointers as a user API, since the size
>>>> of the pointer will vary depending on whether this is a 32-bit or 64-bit
>>>> arch (or 32-bit app running on 64-bit kernel).
>>>
>>> Maybe it would be better 
>>>
>>> 1) to kill this extra indirection?
>>>
>>> struct io_uring_getevents_arg {
>>> -	sigset_t *sigmask;
>>> -	struct __kernel_timespec *ts;
>>> +	sigset_t sigmask;
>>> +	struct __kernel_timespec ts;
>>> };
>>>
>>> then,
>>>
>>> sigset_t *sig = (...)arg;
>>> __kernel_timespec* ts = (...)(arg + offset);
>>
>> But then it's kind of hard to know which, if any, of them are set... I
>> did think about this, and any solution seemed worse than just having the
>> extra indirection.
> 
> struct io_uring_getevents_arg {
> 	sigset_t sigmask;
> 	u32 mask;
> 	struct __kernel_timespec ts;
> };
> 
> if size > sizeof(sigmask), then use mask to determine that.
> Though, not sure how horrid the rest of the code would be.

I'm not saying it's not possible, just that I think the end result would
be worse in terms of both kernel code and how the user applications (or
liburing) would need to use it. I'd rather sacrifice an extra copy for
something that's straight forward (and logical) to use, rather than
needing weird setups or hoops to jump through. And this mask vs
sizeof(mask) thing seems pretty horrendeous to me :-)

>> Yeah, not doing the extra indirection would save a copy, but don't think
>> it's worth it for this path.
> 
> I much more don't like branching like IORING_ENTER_GETEVENTS_TIMEOUT,
> from conceptual point. I may try it out to see how it looks like while
> it's still for-next.

One thing I think we should change is the name,
IORING_ENTER_GETEVENTS_TIMEOUT will quickly be a bad name if we end up
adding just one more thing to the struct. Would be better to call it
IORING_ENTER_EXTRA_DATA or something, meaning that the sigmask pointer
is a pointer to the aux data instead of a sigmask. Better name
suggestions welcome...

-- 
Jens Axboe

