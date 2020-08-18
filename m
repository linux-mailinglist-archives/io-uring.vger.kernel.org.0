Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83542489A1
	for <lists+io-uring@lfdr.de>; Tue, 18 Aug 2020 17:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgHRPXf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Aug 2020 11:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgHRPXe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Aug 2020 11:23:34 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66345C061389
        for <io-uring@vger.kernel.org>; Tue, 18 Aug 2020 08:23:34 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 128so9906266pgd.5
        for <io-uring@vger.kernel.org>; Tue, 18 Aug 2020 08:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9G5Kcr0RN8SIvV3rxL19Cxt0sAj2hSOhN5BSpfWlJZo=;
        b=kvEKmYaAQYL9bMBFJsapddD1TaAIK3oLUQzqhjc5hDx4Xqgwyzjl62xoS+gAFXW4jv
         3dx7F5pnfuVr0eEVColBjk32TQmgGwlLANcvuWr21rh/vyq6eonoOi67gy0i+PHte6P3
         r32sUJoYAlHzG0xeZPfGY8j2c+XNVv0lisKe7bQpvCwPgafe9tNereXZdqhbm0r1zKyu
         P1KjbeW+YnoQMp8PRbrRKyYLHw4rh4FYE02GjV6zKNjA7dx0fEYfYTa5vjG5oRxHleT9
         brku5silUC56Ldmt4dg/Lz4dUbzPLfWVSP2DYyguKtceaXw7NW4ElEfHXfLMVbajdzZZ
         hVjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9G5Kcr0RN8SIvV3rxL19Cxt0sAj2hSOhN5BSpfWlJZo=;
        b=LI0CBr3pQW0A5UmxRYovVndImidUN8V3lHDlw1Oiac1r49Qf9+VZsp/7t6+nzuJ4VI
         nATIVyRduk0PHM6cdDkIOoYPnMBNj2o8I7LFLRQEZBZj8Q3bz3XWB4zjRxXTjSa4IemO
         NFcNI25r+Q3Hamd/jWVSZ/4vppabbRPHVyVfGb3PCuD/3iWJSi0PLKd1aRL2bV2KwCJb
         B8BgvUzbF7V0ZWPx2rBoc47LhQseZmImyGLgjDXO+5TqaRRIRaSvwAAEqA+lbZsATG4m
         kDwq6JsdJyQOsIIGYDlZlYIjLm3WSc5R3dwX+CgdyJtrccnr3Je0HMp44c7GZLJ/00Mu
         yidQ==
X-Gm-Message-State: AOAM531kU+WJ7wssU9OnWKApABVzkI6AN05C7rOosoREQ+gwJqGzL9cj
        0gA+wvJMitCnv/kZPcCakqx79A==
X-Google-Smtp-Source: ABdhPJxpu5uc0CudSDhck6np8MFhF7xvOohJWl89veKe1OD/0prR3VA50teFISAfMUvbJTilG/ROdA==
X-Received: by 2002:a62:6186:: with SMTP id v128mr15832757pfb.211.1597764213792;
        Tue, 18 Aug 2020 08:23:33 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:9214:36a5:5cec:a06d? ([2605:e000:100e:8c61:9214:36a5:5cec:a06d])
        by smtp.gmail.com with ESMTPSA id n22sm260211pjq.25.2020.08.18.08.23.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 08:23:33 -0700 (PDT)
Subject: Re: [PATCHSET v2 0/2] io_uring: handle short reads internally
From:   Jens Axboe <axboe@kernel.dk>
To:     Anoop C S <anoopcs@cryptolab.net>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     david@fromorbit.com, jmoyer@redhat.com
References: <20200814195449.533153-1-axboe@kernel.dk>
 <4c79f6b2-552c-f404-8298-33beaceb9768@samba.org>
 <8beb2687-5cc3-a76a-0f31-dcfa9fc4b84b@kernel.dk>
 <97c2c3ab-d25b-e6bb-e8aa-a551edecc7b5@kernel.dk>
 <e22220a8-669a-d302-f454-03a35c9582b4@kernel.dk>
 <5f6d3f16-cd0c-9598-4484-6003101eb47a@samba.org>
 <db051fac-da0f-9546-2c32-1756d9e74529@kernel.dk>
 <631dbeff8926dbef4fec5a12281843c8a66565e5.camel@cryptolab.net>
 <4ffd97f6-848d-69ff-f76c-2197abbd5e6d@kernel.dk>
Message-ID: <d9bec86b-50a3-5dbd-ce67-84eebae1dbbc@kernel.dk>
Date:   Tue, 18 Aug 2020 08:23:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4ffd97f6-848d-69ff-f76c-2197abbd5e6d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/18/20 7:53 AM, Jens Axboe wrote:
> On 8/18/20 7:49 AM, Anoop C S wrote:
>> On Tue, 2020-08-18 at 07:44 -0700, Jens Axboe wrote:
>>> On 8/18/20 12:40 AM, Stefan Metzmacher wrote:
>>>> Hi Jens,
>>>>
>>>>>>>> Will this be backported?
>>>>>>>
>>>>>>> I can, but not really in an efficient manner. It depends on
>>>>>>> the async
>>>>>>> buffered work to make progress, and the task_work handling
>>>>>>> retry. The
>>>>>>> latter means it's 5.7+, while the former is only in 5.9+...
>>>>>>>
>>>>>>> We can make it work for earlier kernels by just using the
>>>>>>> thread offload
>>>>>>> for that, and that may be worth doing. That would enable it
>>>>>>> in
>>>>>>> 5.7-stable and 5.8-stable. For that, you just need these two
>>>>>>> patches.
>>>>>>> Patch 1 would work as-is, while patch 2 would need a small
>>>>>>> bit of
>>>>>>> massaging since io_read() doesn't have the retry parts.
>>>>>>>
>>>>>>> I'll give it a whirl just out of curiosity, then we can
>>>>>>> debate it after
>>>>>>> that.
>>>>>>
>>>>>> Here are the two patches against latest 5.7-stable (the rc
>>>>>> branch, as
>>>>>> we had quite a few queued up after 5.9-rc1). Totally untested,
>>>>>> just
>>>>>> wanted to see if it was doable.
>>>>>>
>>>>>> First patch is mostly just applied, with various bits removed
>>>>>> that we
>>>>>> don't have in 5.7. The second patch just does -EAGAIN punt for
>>>>>> the
>>>>>> short read case, which will queue the remainder with io-wq for
>>>>>> async execution.
>>>>>>
>>>>>> Obviously needs quite a bit of testing before it can go
>>>>>> anywhere else,
>>>>>> but wanted to throw this out there in case you were interested
>>>>>> in
>>>>>> giving it a go...
>>>>>
>>>>> Actually passes basic testing, and doesn't return short reads. So
>>>>> at
>>>>> least it's not half bad, and it should be safe for you to test.
>>>>>
>>>>> I quickly looked at 5.8 as well, and the good news is that the
>>>>> same
>>>>> patches will apply there without changes.
>>>>
>>>> Thanks, but I was just curios and I currently don't have the
>>>> environment to test, sorry.
>>>>
>>>> Anoop: you helped a lot reproducing the problem with 5.6, would you
>>>> be able to
>>>> test the kernel patches against 5.7 or 5.8, while reverting the
>>>> samba patches?
>>>> See 
>>>> https://lore.kernel.org/io-uring/e22220a8-669a-d302-f454-03a35c9582b4@kernel.dk/T/#t
>>>> for the
>>>> whole discussion?
>>>
>>> I'm actually not too worried about the short reads not working, it'll
>>> naturally fall out correctly if the rest of the path is sane. The
>>> latter
>>> is what I'd be worried about! I ran some synthetic testing and
>>> haven't
>>> seen any issues so far, so maybe (just maybe) it's actually good.
>>>
>>> I can setup two branches with the 5.7-stable + patches and 5.8-stable 
>>> +
>>> patches if that helps facilitate testing?
>>
>> That would be great.
>>
>> I took those two patches and tried to apply on top of 5.7.y. I had to
>> manually resolve very few conflicts. I am not sure whether it is OK or
>> not to test such a patched version(because of conflicts).
> 
> I pushed out two branches:
> 
> 5.8-stable: current 5.8-stable rc queue + the three patches for this
> 5.7-stable: 5.7 ditto
> 
> So pick which one you want to use, and then pull it.
> 
> git://git.kernel.dk/linux-block 5.8-stable
> 
> git://git.kernel.dk/linux-block 5.7-stable
> 
> Hope that helps!

Ran these through the liburing regression testing as well, and found a
case where 'ret2' isn't initialized. So pushed out new branches. The
correct sha for testing should be:

5.7-stable: a451911d530075352fbc7ef9bb2df68145a747ad
5.8-stable: b101e651782a60eb1e96b64e523e51358b77f94f

-- 
Jens Axboe

