Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79531509FBA
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 14:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382268AbiDUMg6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 08:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377192AbiDUMg4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 08:36:56 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4A520BE3
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 05:34:06 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id k14so4569773pga.0
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 05:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nq91BNyZp1XIprDKEGxcW+lLng2cM9BD77qb5uQR8j0=;
        b=g3mjVtScLnEKzmgZWHlLNvSBJtQla85ScprZ/NyEXYypgBEzudW1xHeJ2lvQVjovhS
         t58E8rlUVQatiyIPgoZ9YSMG/VruKAgOAa6e5fDkm1BkVkGYn20+m1iXHxsKt92/7K4+
         RvgGxjc0uFVd3u7YWZQp6EWASOu0RUT3/mwSchoyGOkPgx7H9haWwgeyrVYQl/IffuRJ
         U6VuK6serKi5oeGrlYxciosQoPRDHIClylsX3CFOSrvEy1QLOnYjIqSOpryHPvKzgbgC
         gmwXxnqMMPN+Aw+pKWd74w3MceblheEanmMMeKAdEZAyODTdkKm4ds7VirXJB9Z2wDgR
         5JaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nq91BNyZp1XIprDKEGxcW+lLng2cM9BD77qb5uQR8j0=;
        b=Aj8HFIhfHRKskT0DZyiP4B4s2K7iBjxhZ6h9jmbR22WLO2JPVsLtujdRtk7uE/5wnj
         qCIWKbZJYks3wncy9HJihfxbWoszg51Ro6sCL0dlNZEQaNUYOt/Ko79RBrtDx5uIVlYk
         5ofwsZ6Gtot56KvfKszvzykg1oI4oKXs4lwD+B4ITmjGTZEo13Nh8MgfJzHoZYgOEtqZ
         VtVlZ+mVXFGUbpfiR628MLMQ8/CGfKrOUwFOBNTzHmmolaC+Us0aCeCYK88Zc6LUHPx+
         NqdT64OiDC2A3z6xMOpBXGLK8KTvOpmzEzeBh5Ys/25Y+r8c2dcD4mCD0yWgXLZNjCkz
         KN2Q==
X-Gm-Message-State: AOAM533j/l5+RgnPg7S5L/UynIxfVOlqCwGahtpeJTLRM3X9mrK1fcI1
        IuKHdeJvjhk6cAksqMyobSt3GbGSSzDCZF8o
X-Google-Smtp-Source: ABdhPJy5dB8dr7uT/wR0codm8XEnemUUcUM8e+jDWXtiI///z7hZ4b56uM5GLDC4hw0sTSFdhDpS0g==
X-Received: by 2002:a63:cf4d:0:b0:399:40fc:addf with SMTP id b13-20020a63cf4d000000b0039940fcaddfmr23611399pgj.416.1650544445477;
        Thu, 21 Apr 2022 05:34:05 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y21-20020a631815000000b0039fcedd7bedsm24060377pgl.41.2022.04.21.05.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 05:34:04 -0700 (PDT)
Message-ID: <05c068ed-4af1-f12e-623f-6a9dde73d1c0@kernel.dk>
Date:   Thu, 21 Apr 2022 06:34:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
 <CAJfpegsADrdURSUOrGTjbu1DoRr7-8itGx23Tn0wf6gNdO5dWA@mail.gmail.com>
 <77229971-72cd-7d78-d790-3ef4789acc9e@kernel.dk>
 <CAJfpeguiZ7U=YQhgGa-oPWO07tpBL6sf3zM=xtAk66njb1p2cw@mail.gmail.com>
 <c5f27130-b4ad-3f4c-ce98-4414227db4fd@kernel.dk>
 <61c2336f-0315-5f76-3022-18c80f79e0b5@kernel.dk>
 <38436a44-5048-2062-c339-66679ae1e282@kernel.dk>
 <CAJfpegvM3LQ8nsJf=LsWjQznpOzC+mZFXB5xkZgZHR2tXXjxLQ@mail.gmail.com>
 <fbf3b195-7415-7f84-c0e6-bdfebf9692f2@kernel.dk>
 <CAJfpeguq1bBDa9-gbk6tutME1kH4SdHvkUdLGKzfdmhpCtCt6g@mail.gmail.com>
 <b9964d20-1c87-502b-a1b6-1deb538b7842@kernel.dk>
 <47912c4c-ccc2-0678-6c2f-3e3c0dd1f04b@kernel.dk>
 <CAJfpeguWv7kJn2RReTp0Hfv8hCoAbGSjGmRyNGQnPcU2exrewQ@mail.gmail.com>
 <ca3e4b7e-e9df-5988-5dc1-6d20ce27bdbf@kernel.dk>
 <CAJfpegsa8uza8bc1aMD7hLzrD6n1=wbxAmQH2KEOnrw7Rxkz2A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJfpegsa8uza8bc1aMD7hLzrD6n1=wbxAmQH2KEOnrw7Rxkz2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/21/22 6:31 AM, Miklos Szeredi wrote:
> On Tue, 5 Apr 2022 at 16:44, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/5/22 1:45 AM, Miklos Szeredi wrote:
>>> On Sat, 2 Apr 2022 at 03:17, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 4/1/22 10:21 AM, Jens Axboe wrote:
>>>>> On 4/1/22 10:02 AM, Miklos Szeredi wrote:
>>>>>> On Fri, 1 Apr 2022 at 17:36, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>>> I take it you're continually reusing those slots?
>>>>>>
>>>>>> Yes.
>>>>>>
>>>>>>>  If you have a test
>>>>>>> case that'd be ideal. Agree that it sounds like we just need an
>>>>>>> appropriate breather to allow fput/task_work to run. Or it could be the
>>>>>>> deferral free of the fixed slot.
>>>>>>
>>>>>> Adding a breather could make the worst case latency be large.  I think
>>>>>> doing the fput synchronously would be better in general.
>>>>>
>>>>> fput() isn't sync, it'll just offload to task_work. There are some
>>>>> dependencies there that would need to be checked. But we'll find a way
>>>>> to deal with it.
>>>>>
>>>>>> I test this on an VM with 8G of memory and run the following:
>>>>>>
>>>>>> ./forkbomb 14 &
>>>>>> # wait till 16k processes are forked
>>>>>> for i in `seq 1 100`; do ./procreads u; done
>>>>>>
>>>>>> You can compare performance with plain reads (./procreads p), the
>>>>>> other tests don't work on public kernels.
>>>>>
>>>>> OK, I'll check up on this, but probably won't have time to do so before
>>>>> early next week.
>>>>
>>>> Can you try with this patch? It's not complete yet, there's actually a
>>>> bunch of things we can do to improve the direct descriptor case. But
>>>> this one is easy enough to pull off, and I think it'll fix your OOM
>>>> case. Not a proposed patch, but it'll prove the theory.
>>>
>>> Sorry for the delay..
>>>
>>> Patch works like charm.
>>
>> OK good, then it is the issue I suspected. Thanks for testing!
> 
> Tested with v5.18-rc3 and performance seems significantly worse than
> with the test patch:
> 
> test patch:
>         avg     min     max     stdev
> real    0.205   0.190   0.266   0.011
> user    0.017   0.007   0.029   0.004
> sys     0.374   0.336   0.503   0.022
> 
> 5.18.0-rc3-00016-gb253435746d9:
>         avg     min     max     stdev
> real    0.725   0.200   18.090  2.279
> user    0.019   0.005   0.046   0.006
> sys     0.454   0.241   1.022   0.199

It's been a month and I don't remember details of which patches were
tested, when you say "test patch", which one exactly are you referring
to and what base was it applied on?

-- 
Jens Axboe

