Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF60F52BE7B
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 17:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239242AbiERPUV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 11:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239256AbiERPUU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 11:20:20 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FDA1A384
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 08:20:18 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id s23so2575470iog.13
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 08:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ybDEtV3nXAdy0xbiVIgxxDeVerG9En9+3bXJwrFbqrw=;
        b=YVrFL08D2lPVhB/5yy8xa63dBxa+8NiqBxbReoA0xj4oWZyKh9ZaGIcZAQFs7kFY8m
         UEVoDuzdonNRQeM05dDIZHkmL5sLa48A0f9lvbxu+aiSUxvs+2Mhb2S6ejMxmzyqKw78
         92WqbCA/Srp+T+M7gQqfbc6U98KPjnJ/qtC40KLNRMf297i36QYA7uXxJMJoYoWdd4qi
         pwQzLU/AjpJBr7C7kU3/cK7+HGNAUqOoCGdy+OyKBoPghK4Y06jzAclmU/R+wwb267Ay
         JopayF5RlvM9hDpZrLjCrcXzg+w+v3O4Inyti3u0xgM6mOe+WKiZtmYsID6ELxROhzKg
         NYXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ybDEtV3nXAdy0xbiVIgxxDeVerG9En9+3bXJwrFbqrw=;
        b=zKhjssmzErtdRsJhXIXfyWrlAyPAlTJxfgnt0UC+8fewXnH6MfwRBpGrKjbwhRRTOJ
         S0aICVPo6KUgyGBvKDwwyarQ4C/C0k3rP70we0caCgGLp2OdhIQ6tgzeIFqF8iV59+xF
         rzWwJFouAROc3tM8EUXsRxCGhfJTk12T0J7DW6mzqob4IDKD85wR+JueuLfVbhmfjnpi
         qfV0z/Wf1/qA7uhLBpm5ols9PEPm+E7SDwQq3yflmP2/DLh9KrrewKM5ZyOCRyQFbGcn
         hqU5U9XusVkSXCYeAqLpIDnMOz4JAbkUeZVDV0j8rBBIr9Jty8PTfS6eTD035RPjqNx+
         huRw==
X-Gm-Message-State: AOAM531ARJRRw1+0OBkW5RbZZ5zjOZ9yNTPAXISWgVucStSIzgkU1OtU
        GXCnuYoWFKtxzHn12cY99mMwkA==
X-Google-Smtp-Source: ABdhPJxHuzvINXblCDKRPB94RIuHqGlAcKaKQlMspzJXlx07bcy3C8plJlCZvx58qme+L7Xd92Lpnw==
X-Received: by 2002:a05:6638:1649:b0:32b:e328:c95d with SMTP id a9-20020a056638164900b0032be328c95dmr1121jat.143.1652887217456;
        Wed, 18 May 2022 08:20:17 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j13-20020a02cb0d000000b0032e262428d1sm584797jap.143.2022.05.18.08.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 08:20:16 -0700 (PDT)
Message-ID: <49609b89-f2f0-44b3-d732-dfcb4f73cee1@kernel.dk>
Date:   Wed, 18 May 2022 09:20:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Content-Language: en-US
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <YoOT7Cyobsed5IE3@google.com>
 <d503d5ff-4bc5-2bd0-00d3-cd7b0a0724cb@kernel.dk>
 <YoOW2+ov8KF1YcYF@google.com>
 <3d271554-9ddc-07ad-3ff8-30aba31f8bf2@kernel.dk>
 <YoOcYR15Jhkw2XwL@google.com>
 <f34c85cc-71a5-59d4-dd7a-cc07e2af536c@kernel.dk>
 <YoTrmjuct3ctvFim@google.com>
 <b7dc2992-e2d6-8e76-f089-b33561f8471f@kernel.dk>
 <f821d544-78d5-a227-1370-b5f0895fb184@kernel.dk>
 <06710b30-fec8-b593-3af4-1318515b41d8@kernel.dk>
 <YoUNQlzU0W4ShA85@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YoUNQlzU0W4ShA85@google.com>
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

On 5/18/22 9:14 AM, Lee Jones wrote:
> On Wed, 18 May 2022, Jens Axboe wrote:
> 
>> On 5/18/22 6:54 AM, Jens Axboe wrote:
>>> On 5/18/22 6:52 AM, Jens Axboe wrote:
>>>> On 5/18/22 6:50 AM, Lee Jones wrote:
>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>
>>>>>> On 5/17/22 7:00 AM, Lee Jones wrote:
>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>>>
>>>>>>>> On 5/17/22 6:36 AM, Lee Jones wrote:
>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>>>>>
>>>>>>>>>> On 5/17/22 6:24 AM, Lee Jones wrote:
>>>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>>>>>>>
>>>>>>>>>>>> On 5/17/22 5:41 AM, Lee Jones wrote:
>>>>>>>>>>>>> Good afternoon Jens, Pavel, et al.,
>>>>>>>>>>>>>
>>>>>>>>>>>>> Not sure if you are presently aware, but there appears to be a
>>>>>>>>>>>>> use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
>>>>>>>>>>>>> in Stable v5.10.y.
>>>>>>>>>>>>>
>>>>>>>>>>>>> The full sysbot report can be seen below [0].
>>>>>>>>>>>>>
>>>>>>>>>>>>> The C-reproducer has been placed below that [1].
>>>>>>>>>>>>>
>>>>>>>>>>>>> I had great success running this reproducer in an infinite loop.
>>>>>>>>>>>>>
>>>>>>>>>>>>> My colleague reverse-bisected the fixing commit to:
>>>>>>>>>>>>>
>>>>>>>>>>>>>   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
>>>>>>>>>>>>>   Author: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>>>   Date:   Fri Feb 26 09:47:20 2021 -0700
>>>>>>>>>>>>>
>>>>>>>>>>>>>        io-wq: have manager wait for all workers to exit
>>>>>>>>>>>>>
>>>>>>>>>>>>>        Instead of having to wait separately on workers and manager, just have
>>>>>>>>>>>>>        the manager wait on the workers. We use an atomic_t for the reference
>>>>>>>>>>>>>        here, as we need to start at 0 and allow increment from that. Since the
>>>>>>>>>>>>>        number of workers is naturally capped by the allowed nr of processes,
>>>>>>>>>>>>>        and that uses an int, there is no risk of overflow.
>>>>>>>>>>>>>
>>>>>>>>>>>>>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>>>
>>>>>>>>>>>>>     fs/io-wq.c | 30 ++++++++++++++++++++++--------
>>>>>>>>>>>>>     1 file changed, 22 insertions(+), 8 deletions(-)
>>>>>>>>>>>>
>>>>>>>>>>>> Does this fix it:
>>>>>>>>>>>>
>>>>>>>>>>>> commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
>>>>>>>>>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>> Date:   Fri Mar 5 12:59:30 2021 -0700
>>>>>>>>>>>>
>>>>>>>>>>>>     io-wq: fix race in freeing 'wq' and worker access
>>>>>>>>>>>>
>>>>>>>>>>>> Looks like it didn't make it into 5.10-stable, but we can certainly
>>>>>>>>>>>> rectify that.
>>>>>>>>>>>
>>>>>>>>>>> Thanks for your quick response Jens.
>>>>>>>>>>>
>>>>>>>>>>> This patch doesn't apply cleanly to v5.10.y.
>>>>>>>>>>
>>>>>>>>>> This is probably why it never made it into 5.10-stable :-/
>>>>>>>>>
>>>>>>>>> Right.  It doesn't apply at all unfortunately.
>>>>>>>>>
>>>>>>>>>>> I'll have a go at back-porting it.  Please bear with me.
>>>>>>>>>>
>>>>>>>>>> Let me know if you into issues with that and I can help out.
>>>>>>>>>
>>>>>>>>> I think the dependency list is too big.
>>>>>>>>>
>>>>>>>>> Too much has changed that was never back-ported.
>>>>>>>>>
>>>>>>>>> Actually the list of patches pertaining to fs/io-wq.c alone isn't so
>>>>>>>>> bad, I did start to back-port them all but some of the big ones have
>>>>>>>>> fs/io_uring.c changes incorporated and that list is huge (256 patches
>>>>>>>>> from v5.10 to the fixing patch mentioned above).
>>>>>>>>
>>>>>>>> The problem is that 5.12 went to the new worker setup, and this patch
>>>>>>>> landed after that even though it also applies to the pre-native workers.
>>>>>>>> Hence the dependency chain isn't really as long as it seems, probably
>>>>>>>> just a few patches backporting the change references and completions.
>>>>>>>>
>>>>>>>> I'll take a look this afternoon.
>>>>>>>
>>>>>>> Thanks Jens.  I really appreciate it.
>>>>>>
>>>>>> Can you see if this helps? Untested...
>>>>>
>>>>> What base does this apply against please?
>>>>>
>>>>> I tried Mainline and v5.10.116 and both failed.
>>>>
>>>> It's against 5.10.116, so that's puzzling. Let me double check I sent
>>>> the right one...
>>>
>>> Looks like I sent the one from the wrong directory, sorry about that.
>>> This one should be better:
>>
>> Nope, both are the right one. Maybe your mailer is mangling the patch?
>> I'll attach it gzip'ed here in case that helps.
> 
> Okay, that applied, thanks.
> 
> Unfortunately, I am still able to crash the kernel in the same way.

Alright, maybe it's not enough. I can't get your reproducer to crash,
unfortunately. I'll try on a different box.

-- 
Jens Axboe

