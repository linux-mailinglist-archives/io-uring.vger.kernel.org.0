Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DA047C3A2
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 17:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239678AbhLUQTl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 11:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239668AbhLUQTl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 11:19:41 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DAAC061574
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 08:19:40 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id r17so27651417wrc.3
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 08:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XrqwFvFsgKkW3Aup6GDNi/4SGBDHr9KExBJOXrsEtQQ=;
        b=D4HR9N3d2UaBvjol8sUd4FV+MobBXOF0tpL6n1SCid0B4Vr9cKEke2Q4IGScTtmp4L
         MwehIMdA1w4KfCf6cytu3ucWB3N+PYICWwC3101EtXBWI8Lw10F7XLtjI5E6horfdiHl
         HfWumkHF68ZofUn4ITLXRlwPefZcFL0TWFNAX2R61R2Z/pHnrkMG1wv6M0cKoBj1X+/5
         541erABMzPYUpF4b6AHXPRtiA0uMcQpiSTiDpsYOgRYd5aSeIZ7BAUcLStq95adrHEF+
         zwXrSjT0KZaPFpY4yy/Sa5L38cZ4voleWV0px5i18t1JM2mG5N9Ux5c+h811GGoAZBjb
         o5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XrqwFvFsgKkW3Aup6GDNi/4SGBDHr9KExBJOXrsEtQQ=;
        b=D/eFmpm+w5FvCSIU07NECQiJMHtjcsK/s1LRp1cyMtEPZoIs3EKY+FezpnODoEf6/2
         u7250MZvYio/9eA02IEIW0BC/GqvJpOS4cAFgUMbKETXdaPhW+Eq/CTFc/q5xvNCzVTZ
         RL5lsLc6B31mCvl4envTq+2yFiv4rp7Uufx9oSfnptaE9InBUmvQntY+etGXQf0iY6//
         LqjbK5f8Jrcqbpo7tFaHe5YSZ7gpkyN7WHq1pV/Z37Mcs6dky316LeAXY1k2pvTr3dvS
         j4QvrA3zGZamLGIkATuQQ5mHuUUorMmOQiwNX+J24l3PCFomN04ayx85tZjccpxYiX5k
         rjvg==
X-Gm-Message-State: AOAM530t9yGc7rm1uJjMxFPeC3/pJ7GzKYXNfEkT9jGpjRSzavPzWs3g
        epJWs3/HCgfCQte8c5Y2KXM=
X-Google-Smtp-Source: ABdhPJzbqwlSPkfnFVMGg1s9QvIDOjw5kWfJHF3mj5NHDjPNlfKz1jzVsB/7C0Yd/OvfbW6YRWXolQ==
X-Received: by 2002:a05:6000:1b03:: with SMTP id f3mr3379669wrz.58.1640103579089;
        Tue, 21 Dec 2021 08:19:39 -0800 (PST)
Received: from [192.168.8.198] ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id f16sm3125560wmg.27.2021.12.21.08.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 08:19:37 -0800 (PST)
Message-ID: <84ed785a-b0b0-6d05-2c13-7c3efe9fd60b@gmail.com>
Date:   Tue, 21 Dec 2021 16:19:30 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [POC RFC 0/3] support graph like dependent sqes
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211214055734.61702-1-haoxu@linux.alibaba.com>
 <4ef630f4-54d8-e8c6-8622-dccef5323864@gmail.com>
 <7607c0f9-cad3-cfc5-687e-07dc82684b4e@linux.alibaba.com>
 <06e21b01-a168-e25f-1b42-97789392bd89@gmail.com>
 <c6e18c00-7c1b-d1e9-a152-91b86f426289@linux.alibaba.com>
 <aebc5433-258d-2d36-9e38-36860b99a669@gmail.com>
 <96155b9c-9f35-53b8-456a-8623fc850b03@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <96155b9c-9f35-53b8-456a-8623fc850b03@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/21 06:57, Hao Xu wrote:
> 在 2021/12/18 上午3:33, Pavel Begunkov 写道:
>> On 12/16/21 16:55, Hao Xu wrote:
>>> 在 2021/12/15 上午2:16, Pavel Begunkov 写道:
>>>> On 12/14/21 16:53, Hao Xu wrote:
>>>>> 在 2021/12/14 下午11:21, Pavel Begunkov 写道:
>>>>>> On 12/14/21 05:57, Hao Xu wrote:
>>>>>>> This is just a proof of concept which is incompleted, send it early for
>>>>>>> thoughts and suggestions.
>>>>>>>
>>>>>>> We already have IOSQE_IO_LINK to describe linear dependency
>>>>>>> relationship sqes. While this patchset provides a new feature to
>>>>>>> support DAG dependency. For instance, 4 sqes have a relationship
>>>>>>> as below:
>>>>>>>        --> 2 --
>>>>>>>       /        \
>>>>>>> 1 ---          ---> 4
>>>>>>>       \        /
>>>>>>>        --> 3 --
>>>>>>> IOSQE_IO_LINK serializes them to 1-->2-->3-->4, which unneccessarily
>>>>>>> serializes 2 and 3. But a DAG can fully describe it.
>>>>>>>
>>>>>>> For the detail usage, see the following patches' messages.
>>>>>>>
>>>>>>> Tested it with 100 direct read sqes, each one reads a BS=4k block data
>>>>>>> in a same file, blocks are not overlapped. These sqes form a graph:
>>>>>>>        2
>>>>>>>        3
>>>>>>> 1 --> 4 --> 100
>>>>>>>       ...
>>>>>>>        99
>>>>>>>
>>>>>>> This is an extreme case, just to show the idea.
>>>>>>>
>>>>>>> results below:
>>>>>>> io_link:
>>>>>>> IOPS: 15898251
>>>>>>> graph_link:
>>>>>>> IOPS: 29325513
>>>>>>> io_link:
>>>>>>> IOPS: 16420361
>>>>>>> graph_link:
>>>>>>> IOPS: 29585798
>>>>>>> io_link:
>>>>>>> IOPS: 18148820
>>>>>>> graph_link:
>>>>>>> IOPS: 27932960
>>>>>>
>>>>>> Hmm, what do we compare here? IIUC,
>>>>>> "io_link" is a huge link of 100 requests. Around 15898251 IOPS
>>>>>> "graph_link" is a graph of diameter 3. Around 29585798 IOPS
>>>>
>>>> Diam 2 graph, my bad
>>>>
>>>>
>>>>>> Is that right? If so it'd more more fair to compare with a
>>>>>> similar graph-like scheduling on the userspace side.
>>>>>
>>>>> The above test is more like to show the disadvantage of LINK
>>>>
>>>> Oh yeah, links can be slow, especially when it kills potential
>>>> parallelism or need extra allocations for keeping state, like
>>>> READV and WRITEV.
>>>>
>>>>
>>>>> But yes, it's better to test the similar userspace  scheduling since
>>>>>
>>>>> LINK is definitely not a good choice so have to prove the graph stuff
>>>>>
>>>>> beat the userspace scheduling. Will test that soon. Thanks.
>>>>
>>>> Would be also great if you can also post the benchmark once
>>>> it's done
>>>
>>> Wrote a new test to test nop sqes forming a full binary tree with (2^10)-1 nodes,
>>> which I think it a more general case.  Turns out the result is still not stable and
>>> the kernel side graph link is much slow. I'll try to optimize it.
>>
>> That's expected unfortunately. And without reacting on results
>> of previous requests, it's hard to imagine to be useful. BPF may
>> have helped, e.g. not keeping an explicit graph but just generating
>> new requests from the kernel... But apparently even with this it's
>> hard to compete with just leaving it in userspace.
>>
> Tried to exclude the memory allocation stuff, seems it's a bit better than the user graph.
> 
> For the result delivery, I was thinking of attaching BPF program within a sqe, not creating
> a single BPF type sqe. Then we can have data flow in the graph or linkchain. But I haven't
> had a clear draft for it

Oh, I dismissed this idea before. Even if it can be done in-place without any
additional tw (consider recursion and submit_state not prepared for that), it'll
be a horror to maintain. And I also don't see it being flexible enough.

There is one idea from guys that I have to implement, i.e. having a per-CQ
callback. Might interesting to experiment, but I don't see it being viable
in the long run.


>>> Btw, is there any comparison data between the current io link feature and the
>>> userspace scheduling.
>>
>> Don't remember. I'd try to look up the cover-letter for the patches
>> implementing it, I believe there should've been some numbers and
>> hopefully test description.
>>
>> fwiw, before io_uring mailing list got established patches/etc.
>> were mostly going through linux-block mailing list. Links are old, so
>> patches might be there.
>>

-- 
Pavel Begunkov
