Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD863B8A43
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 23:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhF3V6q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 17:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbhF3V6o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 17:58:44 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46F3C0617AD
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:56:14 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id g3so3151748ilq.10
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=uWRhnDRy2P1UpkcbzNFQtzHj2nfVQW59tN1eJZdbVN0=;
        b=O5O49H7y1VrTPRVK8VJiI4CyVtvLfuMFhAh0PKFAxpmIuSfjABrNVTIeKjYa13TRtL
         b8TQ/z8JN8xUEsK1wh33Fc821DGkjxlLebWVX4tXXxp7QpuUKikpGx05tojmTTOMzYRF
         kP8CkYB1p5qLBtMog4c0M0Usc6kwTkcY5ZXZVJ1D8VDhzyJWpTCgFNn1pgKo3Jdxpzqp
         ftPwd9GW6tml5+VTuu3FeOmRicC1xLqGjahAVBHIvVvjVehbE3RzdFB4bvFXxccYgf/I
         BcRa1o4Bbnuu23yKS/9sDd4dza29PX1ESgmh+TkTBLBvmTNSPRlZIxB1ok47iGcvIdrv
         tqiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uWRhnDRy2P1UpkcbzNFQtzHj2nfVQW59tN1eJZdbVN0=;
        b=SkJgOG+L/X2mqtqv5O6mB/Y7MdR7HZOS1X3BrBsaBgN0V7a2PRRkAA4P35jt9KZZbQ
         cKOob4DqwiLaZ/LLHC5ZNuMKC/2Fhgqr3vus0ZqQiEwO7AW85/aQHmYRdEoaTMQya/nW
         i+hC/N/qs7/M7846EJfxjnSlW/nUy7RXciALj8x6qejS4oYhUyPBgyaC5bkp1PjdRbWz
         AKawJJ0fZ+vOiU4+inPKjZPMEro+jf69ye3tCpSl/hxO0W1CyvACHBCQDYuBHzMiI50I
         mnVBUvvjdFLGj9s2u50/bhpBm9GWPkxeqHxAYrPK3GAmgnd4luqFzi8XepNBOTdqxgNc
         mAMQ==
X-Gm-Message-State: AOAM531+9+DOUmnf3mcJ+o9Le8vFzRtEBYppd0rB/J6Fqth9YW77nlTS
        Wx54Oam4aBzjfj7hlhXZFrllaB/y2SskwA==
X-Google-Smtp-Source: ABdhPJzww420q4J9lC5U9euLp2LtbqttiVwaC7WBDCtH+ap0zViJL+Zpedbe3zqWuePYCjqDHb/VPg==
X-Received: by 2002:a92:bd03:: with SMTP id c3mr26398476ile.83.1625090173857;
        Wed, 30 Jun 2021 14:56:13 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id m184sm12927801ioa.17.2021.06.30.14.56.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 14:56:13 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: tweak io_req_task_work_add
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1625086418.git.asml.silence@gmail.com>
 <24b575ea075ae923992e9ce86b61e8b51629fd29.1625086418.git.asml.silence@gmail.com>
 <70c425a8-73dd-e15a-5a10-8ea640cdc7cd@kernel.dk>
 <d7f587b1-67bb-fc67-1174-91d2c8706b42@gmail.com>
 <e1b32d88-5801-b280-25ed-9902cfaa5092@kernel.dk>
 <dc8576f5-9187-c897-d2d5-04f61d54408d@gmail.com>
 <cf74754e-b120-fb71-098b-13d1eeb9428f@kernel.dk>
Message-ID: <d4adfec3-8e08-3445-ce63-5ed71ae967c3@kernel.dk>
Date:   Wed, 30 Jun 2021 15:56:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cf74754e-b120-fb71-098b-13d1eeb9428f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 3:45 PM, Jens Axboe wrote:
> On 6/30/21 3:38 PM, Pavel Begunkov wrote:
>> On 6/30/21 10:22 PM, Jens Axboe wrote:
>>> On 6/30/21 3:19 PM, Pavel Begunkov wrote:
>>>> On 6/30/21 10:17 PM, Jens Axboe wrote:
>>>>> On 6/30/21 2:54 PM, Pavel Begunkov wrote:
>>>>>> Whenever possible we don't want to fallback a request. task_work_add()
>>>>>> will be fine if the task is exiting, so don't check for PF_EXITING,
>>>>>> there is anyway only a relatively small gap between setting the flag
>>>>>> and doing the final task_work_run().
>>>>>>
>>>>>> Also add likely for the hot path.
>>>>>
>>>>> I'm not a huge fan of likely/unlikely, and in particular constructs like:
>>>>>
>>>>>> -	if (test_bit(0, &tctx->task_state) ||
>>>>>> +	if (likely(test_bit(0, &tctx->task_state)) ||
>>>>>>  	    test_and_set_bit(0, &tctx->task_state))
>>>>>>  		return 0;
>>>>>
>>>>> where the state is combined. In any case, it should be a separate
>>>>> change. If there's an "Also" paragraph in a patch, then that's also
>>>>> usually a good clue that that particular change should've been
>>>>> separate :-)
>>>>
>>>> Not sure what's wrong with likely above, but how about drop
>>>> this one then?
>>>
>>> Yep I did - we can do the exiting change separately, the commit message
>>
>> I think 1-2 is good enough for 5.14, I'll just send it for-next
>>
>>> just needs to be clarified a bit on why it's ok to do now. And that
>>
>> It should have been ok to do before those 2 patches, but
>> haven't tracked where it lost actuality.
> 
> Right, I was thinking it was related to the swapping of the signal
> exit and task work run ordering. But didn't look that far yet...

BTW, in usual testing, even just the one hunk removing the exit check
seems to result in quite a lot of memory leaks running
test/poll-mshot-update. So something is funky with the patch.

-- 
Jens Axboe

