Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23382A6FA1
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 22:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731707AbgKDV1F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 16:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731113AbgKDV1E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 16:27:04 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51BBC0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 13:27:04 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id r10so17631878pgb.10
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 13:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aaj+l/3PDgrXQlxLK9i0UWxfhXRINlUyoPfshuAn5V4=;
        b=Xyl/6Tl00jOnOWcv6anpIgD0RTY9IqwTx5TLQtCuRyUpZ2G3Z+68mQdB6DpqKSVVP1
         1Cc07l0CtE+CfZPIiZc//0fLDXauHAb9O3XJHARrxCUE3AhPksasfv3ZYlGC4vTmmGks
         tgF3oRwEKNscYW1F6xIcgXC7xtQimfMVtS1V/UJPbtZolvZ5IZzg8soLvqsnN8LRES3u
         42DQ+IY/NbXzeRvCR2R3Mree2FPwpIqAnPiw2Yrr4r6R2FOMnJECZviEd6Rnrc2loUJn
         0xBujPvsyCBUxAgjJBJWob475G09NIwuQHiymRttPHHKdxSXpN2SH9OjrcxJVhep70ch
         rx4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aaj+l/3PDgrXQlxLK9i0UWxfhXRINlUyoPfshuAn5V4=;
        b=eP7SH9EJameYAUOWND/wUQCVzYFx94j2sPn7+t3YGIYW1M75WrLAm0b/ddSjqduiv2
         /5j8QW/HsdMkKVusAVWey4o1qK5n/Iz3wnNPAMFQRoNTbiVONX+C1TaBx2N7LdIn4RBI
         fThKGj2ZotPPiGmzHv4iGVss+reQIlM2UhHL0SlNmIbZO3Paew8YXlWD/coTBNjQagI/
         oUaAdQnPcEOzzoQQtuzif4kKKYwA7Y2k1H5moryvQxGwWpKI8KmlQ3IgK0DeQbFujhJv
         yCoECrMpjqKQb5/oBeYz9txbkvRHMSudtEMXuLLK+FDl95Yvzqx4UJXM+fPxT6TvOLAi
         KKuA==
X-Gm-Message-State: AOAM533OJ3ABfIf7p3x6Q+lKMbwYStkLgu1LJa431TnjeNKJ80FuJtqn
        v0zm12FF8zyIollwm15nXHxrhZRpAMdfgg==
X-Google-Smtp-Source: ABdhPJyQ+eM5jsPJhdwCSWThZ1+ta1wOo6hXuR+FKJU8EAKb8ADJFAiytbGjZ8jWbhAz51kxtaWUjw==
X-Received: by 2002:a62:5542:0:b029:156:222c:a630 with SMTP id j63-20020a6255420000b0290156222ca630mr31257317pfb.50.1604525224078;
        Wed, 04 Nov 2020 13:27:04 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o70sm3443515pfg.214.2020.11.04.13.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 13:27:03 -0800 (PST)
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
 <1d7cbae3-c284-e01d-7f7d-2ae2ab9cbb54@kernel.dk>
 <310a29cd-0dc2-69b0-7700-975af8025b71@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b0068ff6-cc9e-64b2-0374-7ceed552c7d5@kernel.dk>
Date:   Wed, 4 Nov 2020 14:27:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <310a29cd-0dc2-69b0-7700-975af8025b71@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/4/20 2:20 PM, Pavel Begunkov wrote:
> On 04/11/2020 20:28, Jens Axboe wrote:
>> On 11/4/20 1:16 PM, Pavel Begunkov wrote:
>>> On 04/11/2020 19:34, Jens Axboe wrote:
>>>> On 11/4/20 12:27 PM, Pavel Begunkov wrote:
>>>>> On 04/11/2020 18:32, Jens Axboe wrote:
>>>>>> On 11/4/20 10:50 AM, Jens Axboe wrote:
>>>>>>> +struct io_uring_getevents_arg {
>>>>>>> +	sigset_t *sigmask;
>>>>>>> +	struct __kernel_timespec *ts;
>>>>>>> +};
>>>>>>> +
>>>>>>
>>>>>> I missed that this is still not right, I did bring it up in your last
>>>>>> posting though - you can't have pointers as a user API, since the size
>>>>>> of the pointer will vary depending on whether this is a 32-bit or 64-bit
>>>>>> arch (or 32-bit app running on 64-bit kernel).
>>>>>
>>>>> Maybe it would be better 
>>>>>
>>>>> 1) to kill this extra indirection?
>>>>>
>>>>> struct io_uring_getevents_arg {
>>>>> -	sigset_t *sigmask;
>>>>> -	struct __kernel_timespec *ts;
>>>>> +	sigset_t sigmask;
>>>>> +	struct __kernel_timespec ts;
>>>>> };
>>>>>
>>>>> then,
>>>>>
>>>>> sigset_t *sig = (...)arg;
>>>>> __kernel_timespec* ts = (...)(arg + offset);
>>>>
>>>> But then it's kind of hard to know which, if any, of them are set... I
>>>> did think about this, and any solution seemed worse than just having the
>>>> extra indirection.
>>>
>>> struct io_uring_getevents_arg {
>>> 	sigset_t sigmask;
>>> 	u32 mask;
>>> 	struct __kernel_timespec ts;
>>> };
>>>
>>> if size > sizeof(sigmask), then use mask to determine that.
>>> Though, not sure how horrid the rest of the code would be.
>>
>> I'm not saying it's not possible, just that I think the end result would
>> be worse in terms of both kernel code and how the user applications (or
>> liburing) would need to use it. I'd rather sacrifice an extra copy for
>> something that's straight forward (and logical) to use, rather than
>> needing weird setups or hoops to jump through. And this mask vs
>> sizeof(mask) thing seems pretty horrendeous to me :-)
> 
> If you think so, I'll spare my time then :)
> 
>>
>>>> Yeah, not doing the extra indirection would save a copy, but don't think
>>>> it's worth it for this path.
>>>
>>> I much more don't like branching like IORING_ENTER_GETEVENTS_TIMEOUT,
>>> from conceptual point. I may try it out to see how it looks like while
>>> it's still for-next.
>>
>> One thing I think we should change is the name,
>> IORING_ENTER_GETEVENTS_TIMEOUT will quickly be a bad name if we end up
>> adding just one more thing to the struct. Would be better to call it
>> IORING_ENTER_EXTRA_DATA or something, meaning that the sigmask pointer
>> is a pointer to the aux data instead of a sigmask. Better name
>> suggestions welcome...
> 
> _EXT_ARG from extended

Yeah I like that, I'll update it

> Also, a minor one -- s/sigsz/argsz/

Yes, might as well.

-- 
Jens Axboe

