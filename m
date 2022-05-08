Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB9351ED3D
	for <lists+io-uring@lfdr.de>; Sun,  8 May 2022 13:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiEHLsF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 07:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiEHLsE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 07:48:04 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DFADFBD;
        Sun,  8 May 2022 04:44:14 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id r1-20020a1c2b01000000b00394398c5d51so6840724wmr.2;
        Sun, 08 May 2022 04:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uGom9LadN9y/dKy9cZp6nw8Lj9Rh3bqkuTAr2QAZygs=;
        b=A6cPx5B9Jzsiv5KRDwkhvAUNfqsoWWq7FNQH2Kd+c1HECo1EB+5MmGAGBAdqLim7Lb
         Nktgt+EST7zZeh1XJFjxPmBkhgrUMPxUGaBnoJLfJWIJ9S6OnFqt6fzzMH/4gq6IJeyt
         wm+Gr534Rcbpc5oDFsOVVyr7awT0pJ7HRJSXocW6B6OKw0RD2JPCHAXP57G/3Xr3FfJB
         6RV9dpwU0/ynu40FL+gHQgr6pIJnbX17m9cqU5OkFmL3agzLkwoHrtiTg17j6EQxnhiY
         yF+ObsQwVT8r1bJj44v5fhHBz9EOMhlg7xaIzcMkyqCpk03mC1DCXfNmEk/SuyyWNEUU
         KxWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uGom9LadN9y/dKy9cZp6nw8Lj9Rh3bqkuTAr2QAZygs=;
        b=AWHpFWHVPQMw/4d5zBNmcklX6pwH3lHZCOjNzox65Qeg2Gw85akyrEIodU4sTvp1oo
         AhhBn5pDoOteCpRVEurWVt2mCfsx9waA9zy+33/3uajZlafPcNQqSz6RuGw4b4XYsVu/
         PNs0LgR/PiqTHALaRHxb2jsOFd5Hn3Co2IhmWLrEVbE0ScwOHFgeXXRHQWSKiRMDoD/F
         njuC814gWkB4oqYuGJ6+3MlswyL2AD0s5iN+jdR8NspkidJWv3+mYZr/AsRBpckM7l+m
         hW+3zfhgV9LTcEk1YnflAJgFQ1+fryxl+lCbr1ZHW0USXqH8s78ciUmoezAS2+vyUsmI
         8Z5w==
X-Gm-Message-State: AOAM532jgbzeUTmTvwON2BZdUWxGzE8P6oiE4taQQgr8/19fpaZpBDF8
        yu3k/JDdgb5iftD4LzZaf6kQcjvAgY4=
X-Google-Smtp-Source: ABdhPJxk0zhR6KYK07Bn0EHj0OplxyM4f1/qqPYhsXAkCACxAA8HwtcJX5wePe1GVdTSZhGWkkLYVQ==
X-Received: by 2002:a05:600c:288:b0:394:31f9:68f with SMTP id 8-20020a05600c028800b0039431f9068fmr17937593wmk.57.1652010252850;
        Sun, 08 May 2022 04:44:12 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.103])
        by smtp.gmail.com with ESMTPSA id ay13-20020a5d6f0d000000b0020c5253d8e3sm8698640wrb.47.2022.05.08.04.44.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 May 2022 04:44:12 -0700 (PDT)
Message-ID: <73fc6ba6-a63e-d674-a3bb-05a3f914a714@gmail.com>
Date:   Sun, 8 May 2022 12:43:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: linux-stable-5.10-y CVE-2022-1508 of io_uring module
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Guo Xuenan <guoxuenan@huawei.com>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com
References: <dd122760-5f87-10b1-e50d-388c2631c01a@kernel.dk>
 <20220505141159.3182874-1-guoxuenan@huawei.com>
 <7d54523e-372b-759b-1ebb-e0dbc181f18d@kernel.dk>
 <31ae3426-b835-3a3f-f6d1-aecad24066e8@gmail.com>
 <6c417ba7-d677-5076-5ce3-d3e174eb8899@kernel.dk>
 <4fc454ca-8b3a-28f6-2246-3ffb998f9f11@kernel.dk>
 <9c4cff81-ff0f-4819-c41d-54f28dba2929@gmail.com>
 <fd9b34f1-5289-587a-2ba3-88f924af474c@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fd9b34f1-5289-587a-2ba3-88f924af474c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/22 15:18, Jens Axboe wrote:
> On 5/7/22 3:16 AM, Pavel Begunkov wrote:
>> On 5/6/22 19:22, Jens Axboe wrote:
>>> On 5/6/22 10:15 AM, Jens Axboe wrote:
>>>> On 5/6/22 9:57 AM, Pavel Begunkov wrote:
>>>>> On 5/6/22 03:16, Jens Axboe wrote:
>>>>>> On 5/5/22 8:11 AM, Guo Xuenan wrote:
>>>>>>> Hi, Pavel & Jens
>>>>>>>
>>>>>>> CVE-2022-1508[1] contains an patch[2] of io_uring. As Jones reported,
>>>>>>> it is not enough only apply [2] to stable-5.10.
>>>>>>> Io_uring is very valuable and active module of linux kernel.
>>>>>>> I've tried to apply these two patches[3] [4] to my local 5.10 code, I
>>>>>>> found my understanding of io_uring is not enough to resolve all conflicts.
>>>>>>>
>>>>>>> Since 5.10 is an important stable branch of linux, we would appreciate
>>>>>>> your help in solving this problem.
>>>>>>
>>>>>> Yes, this really needs to get buttoned up for 5.10. I seem to recall
>>>>>> there was a reproducer for this that was somewhat saner than the
>>>>>> syzbot one (which doesn't do anything for me). Pavel, do you have one?
>>>>>
>>>>> No, it was the only repro and was triggering the problem
>>>>> just fine back then
>>>>
>>>> I modified it a bit and I can now trigger it.
>>>
>>> Pavel, why don't we just keep it really simple and just always save the
>>> iter state in read/write, and use the restore instead of the revert?
>>
>> The problem here is where we're doing revert. If it's done deep in
>> the stack and then while unwinding someone decides to revert it again,
>> e.g. blkdev_read_iter(), we're screwed.
>>
>> The last attempt was backporting 20+ patches that would move revert
>> into io_read/io_write, i.e. REQ_F_REISSUE, back that failed some of
>> your tests back then. (was it read retry tests iirc?)
> 
> Do you still have that series? Yes, if I recall correctly, the series

Yep, still in the repo:

https://github.com/isilence/linux/tree/5.10_revert

> had an issue with the resubmit. Which might just be minor, I don't
> believe we really took a closer look at that.
> 
> Let's resurrect that series and see if we can pull it to completion,
> would be nice to finally close the chapter on this issue for 5.10...

We can try, but I'm not too comfortable with those backports, I had
to considerably rewrite last three patches or so. Another option
is to disable retries from the rw callback if the iter has been
truncated.

-- 
Pavel Begunkov
