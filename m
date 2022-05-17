Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCD252A16B
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 14:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345986AbiEQMZc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 08:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345981AbiEQMZW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 08:25:22 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59F7483A1
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 05:25:19 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c9so17201904plh.2
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 05:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IrIkpbmuHKrrFsBUcjgqjjP93rmoX31NTGTCvMbPP4Y=;
        b=NBnYbNP+J+JpzURJ6Bf3exMaOrCVSX0qu7AbJU/g5utF6PrfU0h0Z3iopcGlBvlMaC
         GPNDDKiTgAOxADt5l7Ze5F7iIYg0EeQWUaoI2NkGxf4FSSIbbwRwWPxUNQHvoCM9b3Fd
         RbW2rvRzAo+Kf46ym8S/g4GDjZXkuFzjGEU4H3BLIEeBLDIPm0KvzYVaZDnPOKrlJalB
         LrmgUM3YBO579B1Rq/5vGNGBTpVc80eg0Z+iMNjWSBL4pDDBAUriFACI5YQWiy0QYXAt
         foThqezPvxPmiwv0HisQ9imencOBCyxh/lJ9aQxB2Y3NH3Iqr81CvzDrcRTWh0DqwQ6S
         gtwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IrIkpbmuHKrrFsBUcjgqjjP93rmoX31NTGTCvMbPP4Y=;
        b=PqhQ9OOcNgl2azjyAlxrSvXz952Gz2L2PIypG5Tv7zD1NmrwDqdqey9toE5F1GZkVB
         2ZXWpj03y/tx/j0tBFkt9mZRifbke9453ozU1BG9X7FVPgrfFEmZXtb4JLyCcGLiLA7K
         Tz0n9ZqZ29Ow7pCMdS5cg3+Uv54tgpbGGZTW2qH4e6P7rXRnuI7AbaRuMYXMn1lvKlL4
         cQCJdl5hXgMsnJyrm/3OlkBT4erh1XiEsqNcPkOnA6OPpCIx7bzKCp6/1WOioA47vwHc
         WusBbMSh/QelOytfKI2BjQKUBDL5hZ+zQkVZwkp9QHjOZZhqLS+Olx0fFkGCdNdG/zeJ
         TIIg==
X-Gm-Message-State: AOAM532KabS1RhoVE4frmcKRPD/s0QtpY4o0iBpg8fJZDr3R2ENfiocY
        2WD1sAyixvKdgpq60OWdqNhAbg==
X-Google-Smtp-Source: ABdhPJz+aD1l14DXBGFrAfTzh04KGDyvg7BAjkXVZnm/y60aPmtYxeB2+8D7hg4SfmHCGxIXoIkF7g==
X-Received: by 2002:a17:90b:4a51:b0:1df:7617:bcfb with SMTP id lb17-20020a17090b4a5100b001df7617bcfbmr6584943pjb.207.1652790319084;
        Tue, 17 May 2022 05:25:19 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b8-20020a17090a990800b001df6216e89dsm1542814pjp.28.2022.05.17.05.25.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 05:25:18 -0700 (PDT)
Message-ID: <d503d5ff-4bc5-2bd0-00d3-cd7b0a0724cb@kernel.dk>
Date:   Tue, 17 May 2022 06:25:17 -0600
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YoOT7Cyobsed5IE3@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/22 6:24 AM, Lee Jones wrote:
> On Tue, 17 May 2022, Jens Axboe wrote:
> 
>> On 5/17/22 5:41 AM, Lee Jones wrote:
>>> Good afternoon Jens, Pavel, et al.,
>>>
>>> Not sure if you are presently aware, but there appears to be a
>>> use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
>>> in Stable v5.10.y.
>>>
>>> The full sysbot report can be seen below [0].
>>>
>>> The C-reproducer has been placed below that [1].
>>>
>>> I had great success running this reproducer in an infinite loop.
>>>
>>> My colleague reverse-bisected the fixing commit to:
>>>
>>>   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
>>>   Author: Jens Axboe <axboe@kernel.dk>
>>>   Date:   Fri Feb 26 09:47:20 2021 -0700
>>>
>>>        io-wq: have manager wait for all workers to exit
>>>
>>>        Instead of having to wait separately on workers and manager, just have
>>>        the manager wait on the workers. We use an atomic_t for the reference
>>>        here, as we need to start at 0 and allow increment from that. Since the
>>>        number of workers is naturally capped by the allowed nr of processes,
>>>        and that uses an int, there is no risk of overflow.
>>>
>>>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>>     fs/io-wq.c | 30 ++++++++++++++++++++++--------
>>>     1 file changed, 22 insertions(+), 8 deletions(-)
>>
>> Does this fix it:
>>
>> commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Fri Mar 5 12:59:30 2021 -0700
>>
>>     io-wq: fix race in freeing 'wq' and worker access
>>
>> Looks like it didn't make it into 5.10-stable, but we can certainly
>> rectify that.
> 
> Thanks for your quick response Jens.
> 
> This patch doesn't apply cleanly to v5.10.y.

This is probably why it never made it into 5.10-stable :-/

> I'll have a go at back-porting it.  Please bear with me.

Let me know if you into issues with that and I can help out.

-- 
Jens Axboe

