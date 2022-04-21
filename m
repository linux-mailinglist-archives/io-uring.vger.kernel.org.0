Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05A0509FD6
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 14:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385031AbiDUMoZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 08:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385105AbiDUMoY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 08:44:24 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DE73135E
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 05:41:34 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t12so4727425pll.7
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 05:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=r1O7HGsVrqHUsrB5J5Chaf8l2NjT3h8vQ1hwKzjc/Co=;
        b=y69Ds7umelnd0bcxPQhjvsKf7UKlN5ZoRL9Ff3DWUqi9nbpiW26BUqwksjCST/0dhj
         gI5Z0h2Hg3Zu2ShzyMJA9mGZIt+fFLFw8Cl9N0InHN16DfbcSjoURSle6BPOnFV9Tjtg
         bsulrFN2mJWBwpaaLjRTQJ49d76Lm3cq3m17B/uHfvVOutee60dkkgnGm/2ymlowbELq
         LSFoSiBhkZx41iixqmXetTu2uGKdG7jnQ9uODkFKkf+6WJr8nQH2YI1e6gqZI4nqjmKc
         m7zSuztx4q5cWl32yXaW0ExmvC4qy5QtP+0U123Cj8uSciNBhhDvtZ0f6705xL6Rih+/
         Bw2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r1O7HGsVrqHUsrB5J5Chaf8l2NjT3h8vQ1hwKzjc/Co=;
        b=bsZqzSjDw6e0r4sm4NxwV+53XLKZ2Y55v3WW6lkENoREaPLdEz5P0PuG/Q8oKO7CIa
         m0umusreeUwByBTLnxhCAIV7FS8lhOt9IIQxVHWqHF8waIQV98R0SbvXesUQUjGp3iNA
         GIFDlHBlUvSiDA+SJUihId41kscQP0Ds+5HvYwanDB1wVIs7ufFlbn7+3Uxkav6TBmvP
         lAHA09f6suzOx//t3/OhbCJCUP85nGfQDLrH54dnawTow2pxiqDF6TzfiKGB1+fRiojq
         RlN52FP4SADgI6S138H8y6eLns7iX2DSUpUEw61rCJ5/JzTAk3PeUgxizQqf5wwp+wpH
         M4xA==
X-Gm-Message-State: AOAM533v5IJPI7Vapt502R98wf93RK0xknECerrDZp63mxrvoeHZK2ei
        nFbqTGIzub2Q+KfOvSm5E7o8+w==
X-Google-Smtp-Source: ABdhPJzBV9UAnjRhDRdMKxhpxDz68gOD1Wolpa740qf2c4Sw9mq1uQWmBPEKhyQflCFOKsjtjBRv7Q==
X-Received: by 2002:a17:902:d344:b0:158:408c:4d5f with SMTP id l4-20020a170902d34400b00158408c4d5fmr25724224plk.122.1650544894192;
        Thu, 21 Apr 2022 05:41:34 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x23-20020a17090a0bd700b001cd498dc152sm3027992pjd.2.2022.04.21.05.41.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 05:41:33 -0700 (PDT)
Message-ID: <cc642b7f-5845-41a6-a8c7-a2f3a07e0ea0@kernel.dk>
Date:   Thu, 21 Apr 2022 06:41:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
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
 <05c068ed-4af1-f12e-623f-6a9dde73d1c0@kernel.dk>
 <CAJfpegvTPc0DR5z80kB6uq=-nMa=+4uxGUqbxiGcOTUiVrR+wg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJfpegvTPc0DR5z80kB6uq=-nMa=+4uxGUqbxiGcOTUiVrR+wg@mail.gmail.com>
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

On 4/21/22 6:39 AM, Miklos Szeredi wrote:
> On Thu, 21 Apr 2022 at 14:34, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/21/22 6:31 AM, Miklos Szeredi wrote:
>>> On Tue, 5 Apr 2022 at 16:44, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 4/5/22 1:45 AM, Miklos Szeredi wrote:
>>>>> On Sat, 2 Apr 2022 at 03:17, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> On 4/1/22 10:21 AM, Jens Axboe wrote:
>>>>>>> On 4/1/22 10:02 AM, Miklos Szeredi wrote:
>>>>>>>> On Fri, 1 Apr 2022 at 17:36, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>
>>>>>>>>> I take it you're continually reusing those slots?
>>>>>>>>
>>>>>>>> Yes.
>>>>>>>>
>>>>>>>>>  If you have a test
>>>>>>>>> case that'd be ideal. Agree that it sounds like we just need an
>>>>>>>>> appropriate breather to allow fput/task_work to run. Or it could be the
>>>>>>>>> deferral free of the fixed slot.
>>>>>>>>
>>>>>>>> Adding a breather could make the worst case latency be large.  I think
>>>>>>>> doing the fput synchronously would be better in general.
>>>>>>>
>>>>>>> fput() isn't sync, it'll just offload to task_work. There are some
>>>>>>> dependencies there that would need to be checked. But we'll find a way
>>>>>>> to deal with it.
>>>>>>>
>>>>>>>> I test this on an VM with 8G of memory and run the following:
>>>>>>>>
>>>>>>>> ./forkbomb 14 &
>>>>>>>> # wait till 16k processes are forked
>>>>>>>> for i in `seq 1 100`; do ./procreads u; done
>>>>>>>>
>>>>>>>> You can compare performance with plain reads (./procreads p), the
>>>>>>>> other tests don't work on public kernels.
>>>>>>>
>>>>>>> OK, I'll check up on this, but probably won't have time to do so before
>>>>>>> early next week.
>>>>>>
>>>>>> Can you try with this patch? It's not complete yet, there's actually a
>>>>>> bunch of things we can do to improve the direct descriptor case. But
>>>>>> this one is easy enough to pull off, and I think it'll fix your OOM
>>>>>> case. Not a proposed patch, but it'll prove the theory.
>>>>>
>>>>> Sorry for the delay..
>>>>>
>>>>> Patch works like charm.
>>>>
>>>> OK good, then it is the issue I suspected. Thanks for testing!
>>>
>>> Tested with v5.18-rc3 and performance seems significantly worse than
>>> with the test patch:
>>>
>>> test patch:
>>>         avg     min     max     stdev
>>> real    0.205   0.190   0.266   0.011
>>> user    0.017   0.007   0.029   0.004
>>> sys     0.374   0.336   0.503   0.022
>>>
>>> 5.18.0-rc3-00016-gb253435746d9:
>>>         avg     min     max     stdev
>>> real    0.725   0.200   18.090  2.279
>>> user    0.019   0.005   0.046   0.006
>>> sys     0.454   0.241   1.022   0.199
>>
>> It's been a month and I don't remember details of which patches were
>> tested, when you say "test patch", which one exactly are you referring
>> to and what base was it applied on?
> 
> https://lore.kernel.org/all/47912c4c-ccc2-0678-6c2f-3e3c0dd1f04b@kernel.dk/
> 
> The base is a good question, it was after the basic fixed slot
> assignment issues were fixed.

Gotcha, ok then this makes sense. The ordering issues were sorted out
for 5.18-rc3, but the direct descriptor optimization is only in the 5.19
branch.

-- 
Jens Axboe

