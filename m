Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94AB4F51D6
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 04:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451804AbiDFCV3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Apr 2022 22:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450853AbiDEPwR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Apr 2022 11:52:17 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ABD95A1E
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 07:44:04 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id p21so15424827ioj.4
        for <io-uring@vger.kernel.org>; Tue, 05 Apr 2022 07:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8IwZBpX9/Q8Ita3IKJH3bJhysQKbY5oH39e3eSAZP08=;
        b=yISJnjWMC2oyPaQ/fKdWp8p8SOwxgH2IuHcH2nYcO9uKoWgB/RuPvusHGFAT2nB8If
         MpN5ns66esn2YDCf3gGmmN4frceUlXKVNUsduxOjeF86giwSinh7mJ03pobYVyk5hus7
         h/4phixEO7nCwlWVf9UDbF3SzLtqeWd41APkhQQ0IwmizXLjcc0RLrwRNJpkHzkvDdXX
         PauuUl6kWkQWQZsEIzuTqPajQDX/8wqswuA6Ro35I6BEQF6hGdAUKo2zQViKAM/KoRgg
         C1WjpKZ9TsFNerFF85UuDGu79qqxx4TPgGy9YHFJmxODPFfNhWOd8oS0sf2TXwkdC/jU
         prQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8IwZBpX9/Q8Ita3IKJH3bJhysQKbY5oH39e3eSAZP08=;
        b=F04jGxKgDYuVR+E4YUpGgZHpXeBZMKYBh49OZu06wN5RlhPlQ5y7BA19CVimkjruG/
         /avG3f+Ri4kOaqHs68tQHuKOtmY4KXlFbZ1B1yY7afd85btt1PsJQS4dOkjeai8jJ81S
         aK6DPrypo7imJUTUs481UC9ECz6fpcDa0rbm4AWtE3bsjcYU9hur4m36MObrYLDFfsrI
         uejminkNWXy0/+qNP1qJzD0t8uHpPi1eytsxWyAXyOmTZYnEUqJHRzYNga8UtxdgzrW1
         U3C203YFYGmcac+MaHxL1Stzv6Oxsygg+ujBHTuAy2ujaiAOtbtHdi5L9MvQwy5CRdvI
         Dcag==
X-Gm-Message-State: AOAM533Sxw0W7xfxEcS+IhXmawflyP3yvcSJ+fiTXp/HxUewB8p++xX3
        naT8obVqbBl/3GtH4MWMkBc9mLFi+/bTZQ==
X-Google-Smtp-Source: ABdhPJxmGRHgkwANf/Gdqk26/GVckeCQWbpBLRkb/5rezZ6iSDg/9rscj8I75ETCoSeLzqzf5r8Wwg==
X-Received: by 2002:a05:6638:d01:b0:323:cefe:f1b8 with SMTP id q1-20020a0566380d0100b00323cefef1b8mr2224649jaj.292.1649169843878;
        Tue, 05 Apr 2022 07:44:03 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c2-20020a92dc82000000b002c9b0f25e62sm7499170iln.60.2022.04.05.07.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:44:03 -0700 (PDT)
Message-ID: <ca3e4b7e-e9df-5988-5dc1-6d20ce27bdbf@kernel.dk>
Date:   Tue, 5 Apr 2022 08:44:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
 <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk>
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJfpeguWv7kJn2RReTp0Hfv8hCoAbGSjGmRyNGQnPcU2exrewQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/5/22 1:45 AM, Miklos Szeredi wrote:
> On Sat, 2 Apr 2022 at 03:17, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/1/22 10:21 AM, Jens Axboe wrote:
>>> On 4/1/22 10:02 AM, Miklos Szeredi wrote:
>>>> On Fri, 1 Apr 2022 at 17:36, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>>> I take it you're continually reusing those slots?
>>>>
>>>> Yes.
>>>>
>>>>>  If you have a test
>>>>> case that'd be ideal. Agree that it sounds like we just need an
>>>>> appropriate breather to allow fput/task_work to run. Or it could be the
>>>>> deferral free of the fixed slot.
>>>>
>>>> Adding a breather could make the worst case latency be large.  I think
>>>> doing the fput synchronously would be better in general.
>>>
>>> fput() isn't sync, it'll just offload to task_work. There are some
>>> dependencies there that would need to be checked. But we'll find a way
>>> to deal with it.
>>>
>>>> I test this on an VM with 8G of memory and run the following:
>>>>
>>>> ./forkbomb 14 &
>>>> # wait till 16k processes are forked
>>>> for i in `seq 1 100`; do ./procreads u; done
>>>>
>>>> You can compare performance with plain reads (./procreads p), the
>>>> other tests don't work on public kernels.
>>>
>>> OK, I'll check up on this, but probably won't have time to do so before
>>> early next week.
>>
>> Can you try with this patch? It's not complete yet, there's actually a
>> bunch of things we can do to improve the direct descriptor case. But
>> this one is easy enough to pull off, and I think it'll fix your OOM
>> case. Not a proposed patch, but it'll prove the theory.
> 
> Sorry for the delay..
> 
> Patch works like charm.

OK good, then it is the issue I suspected. Thanks for testing!

-- 
Jens Axboe

