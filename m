Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78FC24884B
	for <lists+io-uring@lfdr.de>; Tue, 18 Aug 2020 16:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgHROyF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Aug 2020 10:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgHROyA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Aug 2020 10:54:00 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E5BC061389
        for <io-uring@vger.kernel.org>; Tue, 18 Aug 2020 07:54:00 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id h12so9858702pgm.7
        for <io-uring@vger.kernel.org>; Tue, 18 Aug 2020 07:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fyr/L1FPOjPc3IZ3QQCweukOZHKqTskdFrBUUSFg+qY=;
        b=KdpsfaCB0iTT2iscqeJllpxoc/Kt21K1BLM/VvYMem8wd858JV31WkNlSGrzEK1Uv/
         Cwo3Xkb4PK+5NbJTA9NZGo0AwbdG+HXJBTA+DI25JN3fEnikOKSYEU1S2VXC1A3uvmbn
         tZyXVrh92zXM/SlPSVAYnfILpdxwJWlXXkXA9iRRJ2cHEF82SdWap9EuWJejYAsYfi3r
         d3w3Rt74FlSCySvjT+/RVQYBkmNK8sf7u/I4gIZvhvsMk6AMKZOMXwVLtz63ToBiE2IA
         I/iU3foSRhRnXwfVkmkizOO33jMaXDETLonbn0DcB8iEQqk3pXmTMZQAFr6hb4aB81NN
         snbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fyr/L1FPOjPc3IZ3QQCweukOZHKqTskdFrBUUSFg+qY=;
        b=oUiA+6XO8x/tHjdPx0iCQz/SggGmD2qv3PDGjNiqM0nyqbtCUzPlj+5lmIsCTVbrsS
         qdd3XqaGF8SUbUcFUAqZ/637Zqz4Pd2bNj3zpsz3oNnmeHELnf9SEhpnRJ+G2ZZ4rP6Z
         Ngr4PyBOhezrbxF9+0ipyfpQKSxebcK1y/+s9jU/ItsSD+JrOwWT+GTisqOj1fGb3+Pe
         EkqRYri/NRSETKCyvNfXuJmR6bmNAf+kldnMpNLKEMUMYF4F+OfxewwPIvCEBWU4jewj
         hlVtF7qCsJaHmC0xBGMA6SCKqn68+yqOFFHKmccQOTMdXgo/j27SuPz3w6erO9LY0Luc
         NnWw==
X-Gm-Message-State: AOAM5323K0BUXDCUT2/mTtGIcJeLREFhG/RzQ5RvjEWDLRwo2Kdwbbol
        RoGq/tGsjflvhyrpfkXkqzXXiA==
X-Google-Smtp-Source: ABdhPJxdYJxENWSLgNh+zXG+CEMaLNspdPJtWn/SwgWaWKxTkiUimDIayP0Z2ynzO2kCSJXP5dDz+g==
X-Received: by 2002:a63:304:: with SMTP id 4mr12756191pgd.296.1597762439474;
        Tue, 18 Aug 2020 07:53:59 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:9214:36a5:5cec:a06d? ([2605:e000:100e:8c61:9214:36a5:5cec:a06d])
        by smtp.gmail.com with ESMTPSA id y9sm16139951pgp.77.2020.08.18.07.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 07:53:59 -0700 (PDT)
Subject: Re: [PATCHSET v2 0/2] io_uring: handle short reads internally
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4ffd97f6-848d-69ff-f76c-2197abbd5e6d@kernel.dk>
Date:   Tue, 18 Aug 2020 07:53:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <631dbeff8926dbef4fec5a12281843c8a66565e5.camel@cryptolab.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/18/20 7:49 AM, Anoop C S wrote:
> On Tue, 2020-08-18 at 07:44 -0700, Jens Axboe wrote:
>> On 8/18/20 12:40 AM, Stefan Metzmacher wrote:
>>> Hi Jens,
>>>
>>>>>>> Will this be backported?
>>>>>>
>>>>>> I can, but not really in an efficient manner. It depends on
>>>>>> the async
>>>>>> buffered work to make progress, and the task_work handling
>>>>>> retry. The
>>>>>> latter means it's 5.7+, while the former is only in 5.9+...
>>>>>>
>>>>>> We can make it work for earlier kernels by just using the
>>>>>> thread offload
>>>>>> for that, and that may be worth doing. That would enable it
>>>>>> in
>>>>>> 5.7-stable and 5.8-stable. For that, you just need these two
>>>>>> patches.
>>>>>> Patch 1 would work as-is, while patch 2 would need a small
>>>>>> bit of
>>>>>> massaging since io_read() doesn't have the retry parts.
>>>>>>
>>>>>> I'll give it a whirl just out of curiosity, then we can
>>>>>> debate it after
>>>>>> that.
>>>>>
>>>>> Here are the two patches against latest 5.7-stable (the rc
>>>>> branch, as
>>>>> we had quite a few queued up after 5.9-rc1). Totally untested,
>>>>> just
>>>>> wanted to see if it was doable.
>>>>>
>>>>> First patch is mostly just applied, with various bits removed
>>>>> that we
>>>>> don't have in 5.7. The second patch just does -EAGAIN punt for
>>>>> the
>>>>> short read case, which will queue the remainder with io-wq for
>>>>> async execution.
>>>>>
>>>>> Obviously needs quite a bit of testing before it can go
>>>>> anywhere else,
>>>>> but wanted to throw this out there in case you were interested
>>>>> in
>>>>> giving it a go...
>>>>
>>>> Actually passes basic testing, and doesn't return short reads. So
>>>> at
>>>> least it's not half bad, and it should be safe for you to test.
>>>>
>>>> I quickly looked at 5.8 as well, and the good news is that the
>>>> same
>>>> patches will apply there without changes.
>>>
>>> Thanks, but I was just curios and I currently don't have the
>>> environment to test, sorry.
>>>
>>> Anoop: you helped a lot reproducing the problem with 5.6, would you
>>> be able to
>>> test the kernel patches against 5.7 or 5.8, while reverting the
>>> samba patches?
>>> See 
>>> https://lore.kernel.org/io-uring/e22220a8-669a-d302-f454-03a35c9582b4@kernel.dk/T/#t
>>> for the
>>> whole discussion?
>>
>> I'm actually not too worried about the short reads not working, it'll
>> naturally fall out correctly if the rest of the path is sane. The
>> latter
>> is what I'd be worried about! I ran some synthetic testing and
>> haven't
>> seen any issues so far, so maybe (just maybe) it's actually good.
>>
>> I can setup two branches with the 5.7-stable + patches and 5.8-stable 
>> +
>> patches if that helps facilitate testing?
> 
> That would be great.
> 
> I took those two patches and tried to apply on top of 5.7.y. I had to
> manually resolve very few conflicts. I am not sure whether it is OK or
> not to test such a patched version(because of conflicts).

I pushed out two branches:

5.8-stable: current 5.8-stable rc queue + the three patches for this
5.7-stable: 5.7 ditto

So pick which one you want to use, and then pull it.

git://git.kernel.dk/linux-block 5.8-stable

git://git.kernel.dk/linux-block 5.7-stable

Hope that helps!

-- 
Jens Axboe

