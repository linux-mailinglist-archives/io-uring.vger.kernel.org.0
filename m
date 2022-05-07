Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8440D51E7BD
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 16:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446528AbiEGOWg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 10:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236242AbiEGOWf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 10:22:35 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC14120AC
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 07:18:49 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k14so8401522pga.0
        for <io-uring@vger.kernel.org>; Sat, 07 May 2022 07:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ho9WJbdLiWPZ/4qNJpTqUhf2IK1l980DdbUsNdLi8wc=;
        b=aRlj0uGhsQMp6PIBfqPPu4jOHi7KUQcgEBKPY4RufohgVfcOdlNKpirqcKbPwvEXEY
         NtrC6Uizaj6D7+6UyaKT3sOwQkxAb6w2VPSdnUdD7ZaOlyzpDDpUTAPT/ftIut8OE9E5
         7BlUyJW7N710PyksnJvRuEe9lizWS7PZIMa5kA6KOOkdoFwyF5fbS7nIOarzcM5ec+GI
         lo5hvTnqqGrUOr6n5wNNWTSx1GItm8k52M6Qvwu3FklSXCTSwOZVqb6pgUy4y2lEuonL
         MoVdq+109G4olyRO7b1ayZ7peWxXCcJ2ol+y2BZbi59bHrOwzRHmtdRB4D/Sm2Xl64Lo
         yn6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ho9WJbdLiWPZ/4qNJpTqUhf2IK1l980DdbUsNdLi8wc=;
        b=hN2NDFvSek5MfXx2s3DDGXDX3ZgNwEy3jvIpylx2ISeo1YI4qeGMCSlbD+fmgrFHs2
         zdeFmYyU7ahw0dbBU15UIUwly5lngRDxz9km2gtAEh9yvdGDBdq8WdR03VqI/Ppm5J1S
         gZ/2dNIqINGQJMT9nWKZVeH3hOAX5f/dwmOtIHnF0euRBPBRi/resCXOYNQtEmTjDhrM
         50McmK9cfrBPffiTQfah3LGx94MJVbIhs/pzyvz1fwCFqYKFMG6YcUPpXwlM4/WPgJEP
         CMPeBUeI3bEwZf0whU8tnf9178rWlSVdRw8IfwX2YKaCLVsu480c2zhKv+U0NuLAlgCX
         mP8A==
X-Gm-Message-State: AOAM533sa16NsY51XtC1UyMIMM+WX0/ZTFmggjCz2yNPOa8KbESGrf+Q
        e56EJdovQZVvefKVbq1W6QSVQg==
X-Google-Smtp-Source: ABdhPJwsBzvBBOWA7uE3ZDSxbPrTafA6LOEbau5fhdxJgcx/lWuBTqg/01Qu5aNrK5CEic6gqvglQg==
X-Received: by 2002:a63:1b5e:0:b0:3aa:593c:9392 with SMTP id b30-20020a631b5e000000b003aa593c9392mr6606656pgm.470.1651933128528;
        Sat, 07 May 2022 07:18:48 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id w25-20020aa79559000000b0050dc7628199sm5334168pfq.115.2022.05.07.07.18.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 07:18:48 -0700 (PDT)
Message-ID: <fd9b34f1-5289-587a-2ba3-88f924af474c@kernel.dk>
Date:   Sat, 7 May 2022 08:18:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: linux-stable-5.10-y CVE-2022-1508 of io_uring module
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Guo Xuenan <guoxuenan@huawei.com>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com
References: <dd122760-5f87-10b1-e50d-388c2631c01a@kernel.dk>
 <20220505141159.3182874-1-guoxuenan@huawei.com>
 <7d54523e-372b-759b-1ebb-e0dbc181f18d@kernel.dk>
 <31ae3426-b835-3a3f-f6d1-aecad24066e8@gmail.com>
 <6c417ba7-d677-5076-5ce3-d3e174eb8899@kernel.dk>
 <4fc454ca-8b3a-28f6-2246-3ffb998f9f11@kernel.dk>
 <9c4cff81-ff0f-4819-c41d-54f28dba2929@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9c4cff81-ff0f-4819-c41d-54f28dba2929@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/22 3:16 AM, Pavel Begunkov wrote:
> On 5/6/22 19:22, Jens Axboe wrote:
>> On 5/6/22 10:15 AM, Jens Axboe wrote:
>>> On 5/6/22 9:57 AM, Pavel Begunkov wrote:
>>>> On 5/6/22 03:16, Jens Axboe wrote:
>>>>> On 5/5/22 8:11 AM, Guo Xuenan wrote:
>>>>>> Hi, Pavel & Jens
>>>>>>
>>>>>> CVE-2022-1508[1] contains an patch[2] of io_uring. As Jones reported,
>>>>>> it is not enough only apply [2] to stable-5.10.
>>>>>> Io_uring is very valuable and active module of linux kernel.
>>>>>> I've tried to apply these two patches[3] [4] to my local 5.10 code, I
>>>>>> found my understanding of io_uring is not enough to resolve all conflicts.
>>>>>>
>>>>>> Since 5.10 is an important stable branch of linux, we would appreciate
>>>>>> your help in solving this problem.
>>>>>
>>>>> Yes, this really needs to get buttoned up for 5.10. I seem to recall
>>>>> there was a reproducer for this that was somewhat saner than the
>>>>> syzbot one (which doesn't do anything for me). Pavel, do you have one?
>>>>
>>>> No, it was the only repro and was triggering the problem
>>>> just fine back then
>>>
>>> I modified it a bit and I can now trigger it.
>>
>> Pavel, why don't we just keep it really simple and just always save the
>> iter state in read/write, and use the restore instead of the revert?
> 
> The problem here is where we're doing revert. If it's done deep in
> the stack and then while unwinding someone decides to revert it again,
> e.g. blkdev_read_iter(), we're screwed.
> 
> The last attempt was backporting 20+ patches that would move revert
> into io_read/io_write, i.e. REQ_F_REISSUE, back that failed some of
> your tests back then. (was it read retry tests iirc?)

Do you still have that series? Yes, if I recall correctly, the series
had an issue with the resubmit. Which might just be minor, I don't
believe we really took a closer look at that.

Let's resurrect that series and see if we can pull it to completion,
would be nice to finally close the chapter on this issue for 5.10...

-- 
Jens Axboe

