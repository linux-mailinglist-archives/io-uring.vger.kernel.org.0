Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B1E3B8AA3
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 00:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhF3Wzu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 18:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhF3Wzt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 18:55:49 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DEEC061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 15:53:19 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id f14so5225370wrs.6
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 15:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CVFUJSP5IlqHLYlewLwPbePYY8TCZgmuDrZ1ewUfaLs=;
        b=vQCQZMdhvP3beQJz73aTysTMHaxQ3aU/HIXQwe2H+x246V3UXHyCq9halxNDwlAdzT
         FUJ3S6f6hTNsA9RJPEskwhlZRCm774GjYX1IdMdfIqIiANxqhsUbQ4ycuymWoTVL0jhy
         qfkw+MYo+SQ9guCX2x5foUhUdnhLRNC+XZt+DZAValE+1CiLVySWlrYIEsCddKuMRzFO
         9q2C1q8mqH20AlRF0wwxBLjtDs1B7GPVhxMm1xwL1xxyUywIblRYsjcBlEY5hvx+RiYT
         hkaKELrVvRp99mJOk1GVa/15v7uOPOQLnKp3+xou45DFoRlOTUEpv1NpMWRPs4uCbn/A
         xisw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CVFUJSP5IlqHLYlewLwPbePYY8TCZgmuDrZ1ewUfaLs=;
        b=BBYwSbC+9345ioFeJ9/32mw9OMIq+aF8SIho4sT9YWajK8+XvxXp+aOS43QuUAc+k5
         LhNY2pl4NcrmeD6YJs5ArnFRFXhl4Z8RKtFpMt696dKiP5Dm/dKY+np8SfS4SwrljonB
         1qzCHqKCV7av2S+VHScpsXW83fwmRn4lTtUWNVczNmIe1Tl/oQ+8HkrKRiRTvXJuoFaA
         I/hFVZZLdtlU/B2SvRKOOjTPud7SRbsNgfXnh8y28Zyw8GKX9pjRX/eRaTTjnyApgZ68
         4eAB+nmQ8J1qaq2Kdf7ZaPb6LM/+YYkP9XYcimaAjZ7f4FZoQZ/Fyf9qhCvn0pZDoA4J
         Ck0g==
X-Gm-Message-State: AOAM533tgLqN/4N40u7YXR3vwppDf6t8kfDQlyKKtOSkMsbAsFz4KyBL
        oj0Tp/kh+a6QActZu5FZuBDpQPXXIsxbHq9Y
X-Google-Smtp-Source: ABdhPJx1TSat+im10pvIF/X8ixYdWNmDqR0xzvZa79l62peCq+zC5TdUzzVB/eHcmyrFWKCQQlLxNg==
X-Received: by 2002:a05:6000:1b0e:: with SMTP id f14mr20739850wrz.335.1625093598075;
        Wed, 30 Jun 2021 15:53:18 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.185])
        by smtp.gmail.com with ESMTPSA id t17sm21306345wmi.47.2021.06.30.15.53.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 15:53:17 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: tweak io_req_task_work_add
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1625086418.git.asml.silence@gmail.com>
 <24b575ea075ae923992e9ce86b61e8b51629fd29.1625086418.git.asml.silence@gmail.com>
 <70c425a8-73dd-e15a-5a10-8ea640cdc7cd@kernel.dk>
 <d7f587b1-67bb-fc67-1174-91d2c8706b42@gmail.com>
 <e1b32d88-5801-b280-25ed-9902cfaa5092@kernel.dk>
 <dc8576f5-9187-c897-d2d5-04f61d54408d@gmail.com>
 <cf74754e-b120-fb71-098b-13d1eeb9428f@kernel.dk>
 <d4adfec3-8e08-3445-ce63-5ed71ae967c3@kernel.dk>
 <d94f850f-3394-9a16-dd9a-614575f87c01@gmail.com>
 <81f57250-d41d-423c-1c1c-ef275ddb5da4@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <1927a5f6-d467-2b50-ef4f-ad1542c83fdb@gmail.com>
Date:   Wed, 30 Jun 2021 23:53:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <81f57250-d41d-423c-1c1c-ef275ddb5da4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 11:11 PM, Jens Axboe wrote:
> On 6/30/21 4:10 PM, Pavel Begunkov wrote:
>> On 6/30/21 10:56 PM, Jens Axboe wrote:
>>> On 6/30/21 3:45 PM, Jens Axboe wrote:
>>>> On 6/30/21 3:38 PM, Pavel Begunkov wrote:
>>>>> On 6/30/21 10:22 PM, Jens Axboe wrote:
>>>>>> On 6/30/21 3:19 PM, Pavel Begunkov wrote:
>>>>>>> On 6/30/21 10:17 PM, Jens Axboe wrote:
>>>>>>>> On 6/30/21 2:54 PM, Pavel Begunkov wrote:
>>>>>>>>> Whenever possible we don't want to fallback a request. task_work_add()
>>>>>>>>> will be fine if the task is exiting, so don't check for PF_EXITING,
>>>>>>>>> there is anyway only a relatively small gap between setting the flag
>>>>>>>>> and doing the final task_work_run().
>>>>>>>>>
>>>>>>>>> Also add likely for the hot path.
>>>>>>>>
>>>>>>>> I'm not a huge fan of likely/unlikely, and in particular constructs like:
>>>>>>>>
>>>>>>>>> -	if (test_bit(0, &tctx->task_state) ||
>>>>>>>>> +	if (likely(test_bit(0, &tctx->task_state)) ||
>>>>>>>>>  	    test_and_set_bit(0, &tctx->task_state))
>>>>>>>>>  		return 0;
>>>>>>>>
>>>>>>>> where the state is combined. In any case, it should be a separate
>>>>>>>> change. If there's an "Also" paragraph in a patch, then that's also
>>>>>>>> usually a good clue that that particular change should've been
>>>>>>>> separate :-)
>>>>>>>
>>>>>>> Not sure what's wrong with likely above, but how about drop
>>>>>>> this one then?
>>>>>>
>>>>>> Yep I did - we can do the exiting change separately, the commit message
>>>>>
>>>>> I think 1-2 is good enough for 5.14, I'll just send it for-next
>>>>>
>>>>>> just needs to be clarified a bit on why it's ok to do now. And that
>>>>>
>>>>> It should have been ok to do before those 2 patches, but
>>>>> haven't tracked where it lost actuality.
>>>>
>>>> Right, I was thinking it was related to the swapping of the signal
>>>> exit and task work run ordering. But didn't look that far yet...
>>>
>>> BTW, in usual testing, even just the one hunk removing the exit check
>>> seems to result in quite a lot of memory leaks running
>>> test/poll-mshot-update. So something is funky with the patch.
>>
>> I guess you're positive that patches 1-2 have nothing to do
>> with that. Right?
> 
> I double checked, and seems fine with those two alone. Ran the test
> twice, saw massive amounts of leaks with patches 1-3, and none with
> patches 1-2 only.

I think there is a problem with the failing path of
io_req_task_work_add(), the removing back part. Will send a patch
tomorrow, but not able to test.

-- 
Pavel Begunkov
