Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C6B3B8A58
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 00:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhF3WOc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 18:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbhF3WOb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 18:14:31 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B80C061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 15:12:01 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id g3so3097497iok.12
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 15:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Qal87Cg8pvN1kQ5XP7KO3E5fUAKMe3YnnReZ9jd+qTY=;
        b=lEFHeCEKVDMc3umyGyo6MN2x0Rj6Rx7Ndvj6v/tjcgUF0DmhOdUM2MtT5esJwNqB8J
         7tRXQ3euDhCS8jZrZq5Fgb/MnM5ZjfHOeKNB3Qsa1HmtGWFWouDZg+AWLGO/79xaPRy+
         Snms7PRF0EWvhFHSy+mwqVrvDcKRl50PIqc2CDc7xdAThePgiO3ojePZbzu0KTq32M5v
         6g03wk+MjlRTkl+yCadHY9fjJ0Gg5G8EHCUYUEPKNcLzBP6uSAQC1SYGUzaq3RpI4spn
         6siAoo12vNCVWjT76q3aBq1tOvygj6Fu/bGjJSZnjfNc4E4+7a2G4VVBmzQFrzZp1tdl
         eg6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qal87Cg8pvN1kQ5XP7KO3E5fUAKMe3YnnReZ9jd+qTY=;
        b=sq5RdYewaKuS5aoK384Q3GD8XLKaQubPBNTbd0oZjP2lK53BzDHYbjq0mcg+Cf32CZ
         hBsMCj6pWXxYmHfRmFdaRG0r6I/nAi2z6kvgQAP7mB9NVyLSHL2EEe3+reJMW7a/4Muw
         sRwNOmLFWPepj35GZgP2ek8fBw787cRaSNAftzqp7waQkPqM2nn/A/eaMJGWEuNpX+eN
         HhCs/LqZBNTjzpIHiPltExdv07gWN4kpZeweMfkKHcOs1YIEyOY3+QqNLFEBCTD5/MY5
         Q82CybvhEWTj1XiAO9aapCtP/xfiYpJfp2+X1R6T9PcCDF08BQfZufekQhjMRt9/XMSH
         wJIA==
X-Gm-Message-State: AOAM530aI6eUKJRHPq97FfRBg5BMCKYZo/TCoq6Njy+ujCa5nc9JvKzK
        yo1DN+V+omjjrUAJKkNQxxWWKXoiXok0IQ==
X-Google-Smtp-Source: ABdhPJwsrDnXEAUYpfL2a68EBg7HU9aMkbsl3qvFgbrappXDvV1ZnoWJrWvizNcSFfIhm9XQFMUg/w==
X-Received: by 2002:a05:6602:2bcf:: with SMTP id s15mr9324754iov.205.1625091120433;
        Wed, 30 Jun 2021 15:12:00 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id d13sm2113519ilv.34.2021.06.30.15.11.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 15:11:59 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: tweak io_req_task_work_add
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1625086418.git.asml.silence@gmail.com>
 <24b575ea075ae923992e9ce86b61e8b51629fd29.1625086418.git.asml.silence@gmail.com>
 <70c425a8-73dd-e15a-5a10-8ea640cdc7cd@kernel.dk>
 <d7f587b1-67bb-fc67-1174-91d2c8706b42@gmail.com>
 <e1b32d88-5801-b280-25ed-9902cfaa5092@kernel.dk>
 <dc8576f5-9187-c897-d2d5-04f61d54408d@gmail.com>
 <cf74754e-b120-fb71-098b-13d1eeb9428f@kernel.dk>
 <d4adfec3-8e08-3445-ce63-5ed71ae967c3@kernel.dk>
 <d94f850f-3394-9a16-dd9a-614575f87c01@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <81f57250-d41d-423c-1c1c-ef275ddb5da4@kernel.dk>
Date:   Wed, 30 Jun 2021 16:11:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d94f850f-3394-9a16-dd9a-614575f87c01@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 4:10 PM, Pavel Begunkov wrote:
> On 6/30/21 10:56 PM, Jens Axboe wrote:
>> On 6/30/21 3:45 PM, Jens Axboe wrote:
>>> On 6/30/21 3:38 PM, Pavel Begunkov wrote:
>>>> On 6/30/21 10:22 PM, Jens Axboe wrote:
>>>>> On 6/30/21 3:19 PM, Pavel Begunkov wrote:
>>>>>> On 6/30/21 10:17 PM, Jens Axboe wrote:
>>>>>>> On 6/30/21 2:54 PM, Pavel Begunkov wrote:
>>>>>>>> Whenever possible we don't want to fallback a request. task_work_add()
>>>>>>>> will be fine if the task is exiting, so don't check for PF_EXITING,
>>>>>>>> there is anyway only a relatively small gap between setting the flag
>>>>>>>> and doing the final task_work_run().
>>>>>>>>
>>>>>>>> Also add likely for the hot path.
>>>>>>>
>>>>>>> I'm not a huge fan of likely/unlikely, and in particular constructs like:
>>>>>>>
>>>>>>>> -	if (test_bit(0, &tctx->task_state) ||
>>>>>>>> +	if (likely(test_bit(0, &tctx->task_state)) ||
>>>>>>>>  	    test_and_set_bit(0, &tctx->task_state))
>>>>>>>>  		return 0;
>>>>>>>
>>>>>>> where the state is combined. In any case, it should be a separate
>>>>>>> change. If there's an "Also" paragraph in a patch, then that's also
>>>>>>> usually a good clue that that particular change should've been
>>>>>>> separate :-)
>>>>>>
>>>>>> Not sure what's wrong with likely above, but how about drop
>>>>>> this one then?
>>>>>
>>>>> Yep I did - we can do the exiting change separately, the commit message
>>>>
>>>> I think 1-2 is good enough for 5.14, I'll just send it for-next
>>>>
>>>>> just needs to be clarified a bit on why it's ok to do now. And that
>>>>
>>>> It should have been ok to do before those 2 patches, but
>>>> haven't tracked where it lost actuality.
>>>
>>> Right, I was thinking it was related to the swapping of the signal
>>> exit and task work run ordering. But didn't look that far yet...
>>
>> BTW, in usual testing, even just the one hunk removing the exit check
>> seems to result in quite a lot of memory leaks running
>> test/poll-mshot-update. So something is funky with the patch.
> 
> I guess you're positive that patches 1-2 have nothing to do
> with that. Right?

I double checked, and seems fine with those two alone. Ran the test
twice, saw massive amounts of leaks with patches 1-3, and none with
patches 1-2 only.

-- 
Jens Axboe

