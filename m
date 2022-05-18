Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C5452BCEC
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 16:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbiERMwl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 08:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236984AbiERMwk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 08:52:40 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28E92983D
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 05:52:38 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id s14so1662858plk.8
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 05:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Paq8+juUmf29mMyi5gCCd5Y45Od4vCB9lL+wMXjxOSk=;
        b=DgEoxygYWB0mUsY9mFozlZTqMN1tuXA5NiYKwrlhiQuoZji9hJBt409DoKhAF3kDZJ
         XhK87gzl7cRiC/OKg3bnjS3P9aXGhniV4dfTuO8p1hgxlaPYU/an6v1MwybqodxZ1TB+
         VfIEsurmvcbIzOHFkvmqtTWFZlcNLBWtgpXV/6JUx4Mt+SALlHXjIcrbmuquugOibRSG
         99mHOHZwSf5UwXSJgJK86YpditQ4MsAR/ZoGPAx5J9g5fu8kyHvhkO7K2LQB6GHJc6dC
         t8/kDDs1rcUtX3N6zw7VVbQxBG8IkIXt5UIzHw0ASt3JdALRRQv9xUBCQLvmnvpqU1Gf
         bCdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Paq8+juUmf29mMyi5gCCd5Y45Od4vCB9lL+wMXjxOSk=;
        b=IVRX3t0Zj3/D4mVo75nhiZZEtFqiZgGUpcDMHQwK8h32BIau/xDKwrDL5f/GN1r3f1
         jXqjNOUZnBz/7DZhKEy9wnnTitOM7GSzo7uRo7+n0797xykfTygcH7DgTh41w+bduO0D
         DwhnQUarcjzCN7JcKeEBtF+9PEFnzfZl67j/hsMoTgCBscCsunaJo30a6j6cZ4PZgqU7
         1MgqmimeVketNIB1WZyaqkLkvsu/jjhLD/llVDTSAAILUs1gFOSTRNvU/MxBvAe0yY9h
         kmiasNUkapOCQAE3eDXg2N/6wYnCBvGnhqIrtAe5sPqT+m96hWk2BGiG1xhBW1iL+XOZ
         v/9g==
X-Gm-Message-State: AOAM532uo/PBVx+hABgbOAcgZZXGa2uCjepsC0j+4WD52DhRS17IYHpf
        EOE4vdUpNj6pUROrjNY5R8V+FSC/4zV/9w==
X-Google-Smtp-Source: ABdhPJwGEMa8l0i8Pa/bGNiulCfnfPbTevW/vQoJFvr5yVOo1zzO3LnauW/S0C+XIFnKZl6wvmBM4g==
X-Received: by 2002:a17:903:22cd:b0:161:be20:577 with SMTP id y13-20020a17090322cd00b00161be200577mr4312482plg.54.1652878358347;
        Wed, 18 May 2022 05:52:38 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d13-20020a65620d000000b003f61c311e79sm447063pgv.56.2022.05.18.05.52.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 05:52:37 -0700 (PDT)
Message-ID: <b7dc2992-e2d6-8e76-f089-b33561f8471f@kernel.dk>
Date:   Wed, 18 May 2022 06:52:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Content-Language: en-US
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <YoOJ/T4QRKC+fAZE@google.com>
 <97cba3e1-4ef7-0a17-8456-e0787d6702c6@kernel.dk>
 <YoOT7Cyobsed5IE3@google.com>
 <d503d5ff-4bc5-2bd0-00d3-cd7b0a0724cb@kernel.dk>
 <YoOW2+ov8KF1YcYF@google.com>
 <3d271554-9ddc-07ad-3ff8-30aba31f8bf2@kernel.dk>
 <YoOcYR15Jhkw2XwL@google.com>
 <f34c85cc-71a5-59d4-dd7a-cc07e2af536c@kernel.dk>
 <YoTrmjuct3ctvFim@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YoTrmjuct3ctvFim@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/18/22 6:50 AM, Lee Jones wrote:
> On Tue, 17 May 2022, Jens Axboe wrote:
> 
>> On 5/17/22 7:00 AM, Lee Jones wrote:
>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>
>>>> On 5/17/22 6:36 AM, Lee Jones wrote:
>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>
>>>>>> On 5/17/22 6:24 AM, Lee Jones wrote:
>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>>>
>>>>>>>> On 5/17/22 5:41 AM, Lee Jones wrote:
>>>>>>>>> Good afternoon Jens, Pavel, et al.,
>>>>>>>>>
>>>>>>>>> Not sure if you are presently aware, but there appears to be a
>>>>>>>>> use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
>>>>>>>>> in Stable v5.10.y.
>>>>>>>>>
>>>>>>>>> The full sysbot report can be seen below [0].
>>>>>>>>>
>>>>>>>>> The C-reproducer has been placed below that [1].
>>>>>>>>>
>>>>>>>>> I had great success running this reproducer in an infinite loop.
>>>>>>>>>
>>>>>>>>> My colleague reverse-bisected the fixing commit to:
>>>>>>>>>
>>>>>>>>>   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
>>>>>>>>>   Author: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>   Date:   Fri Feb 26 09:47:20 2021 -0700
>>>>>>>>>
>>>>>>>>>        io-wq: have manager wait for all workers to exit
>>>>>>>>>
>>>>>>>>>        Instead of having to wait separately on workers and manager, just have
>>>>>>>>>        the manager wait on the workers. We use an atomic_t for the reference
>>>>>>>>>        here, as we need to start at 0 and allow increment from that. Since the
>>>>>>>>>        number of workers is naturally capped by the allowed nr of processes,
>>>>>>>>>        and that uses an int, there is no risk of overflow.
>>>>>>>>>
>>>>>>>>>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>
>>>>>>>>>     fs/io-wq.c | 30 ++++++++++++++++++++++--------
>>>>>>>>>     1 file changed, 22 insertions(+), 8 deletions(-)
>>>>>>>>
>>>>>>>> Does this fix it:
>>>>>>>>
>>>>>>>> commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
>>>>>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>>>>>> Date:   Fri Mar 5 12:59:30 2021 -0700
>>>>>>>>
>>>>>>>>     io-wq: fix race in freeing 'wq' and worker access
>>>>>>>>
>>>>>>>> Looks like it didn't make it into 5.10-stable, but we can certainly
>>>>>>>> rectify that.
>>>>>>>
>>>>>>> Thanks for your quick response Jens.
>>>>>>>
>>>>>>> This patch doesn't apply cleanly to v5.10.y.
>>>>>>
>>>>>> This is probably why it never made it into 5.10-stable :-/
>>>>>
>>>>> Right.  It doesn't apply at all unfortunately.
>>>>>
>>>>>>> I'll have a go at back-porting it.  Please bear with me.
>>>>>>
>>>>>> Let me know if you into issues with that and I can help out.
>>>>>
>>>>> I think the dependency list is too big.
>>>>>
>>>>> Too much has changed that was never back-ported.
>>>>>
>>>>> Actually the list of patches pertaining to fs/io-wq.c alone isn't so
>>>>> bad, I did start to back-port them all but some of the big ones have
>>>>> fs/io_uring.c changes incorporated and that list is huge (256 patches
>>>>> from v5.10 to the fixing patch mentioned above).
>>>>
>>>> The problem is that 5.12 went to the new worker setup, and this patch
>>>> landed after that even though it also applies to the pre-native workers.
>>>> Hence the dependency chain isn't really as long as it seems, probably
>>>> just a few patches backporting the change references and completions.
>>>>
>>>> I'll take a look this afternoon.
>>>
>>> Thanks Jens.  I really appreciate it.
>>
>> Can you see if this helps? Untested...
> 
> What base does this apply against please?
> 
> I tried Mainline and v5.10.116 and both failed.

It's against 5.10.116, so that's puzzling. Let me double check I sent
the right one...

-- 
Jens Axboe

