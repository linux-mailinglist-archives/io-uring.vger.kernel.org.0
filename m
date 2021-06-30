Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D233B8A4F
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 00:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhF3WHN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 18:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbhF3WHN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 18:07:13 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D34DC061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 15:04:43 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i94so5481733wri.4
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 15:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Rqkb4Fuzr8dhUua5iGAO4RLoWMVxLLOXSW00dvLA/tY=;
        b=Bi9gaijdQD8LqHIPEsy4UTThmr7/Byis9LB+I3mS9xIz/XvLn1AsItLYArKYSjQ1zf
         bfxufg3JdbFve6On89kejE3dN7tqsA4MyIzV+OU1OsE2iKn+bqa2ITeAlkIBe3Mz9DUQ
         7+qfJuj9g2U3RSgPUSYB8kCRIAJHbDoeVcDEoCBcJZ9MLFIoKpTUqXTDL9odcTQTv9JK
         n5pHXs3I1XljAUQ5udziob/OQ1fKAyk9H91QT73Xn0SJG7ed7A+/FUkHLIBSTAnLicnb
         3XO/e6iVH8qR+Am3SVWBAR1XVV2enSylrChYUtfLXY8KYZtgJUsuh8hqzNTQR8QPbHS1
         D9mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rqkb4Fuzr8dhUua5iGAO4RLoWMVxLLOXSW00dvLA/tY=;
        b=kOhvp0dbk0+EpwbsfBc10vazF/GoSQque9oBzVez7ZXjdDuPboN4fIWFGrge39ouNT
         YWChTJeMFHgCLJKnjHX5Tm9PgnJ1wYcq/2eaYkSTvkzfHaF+OveKj/Tu5kRhKcGeGYDM
         TJNR+/ZAU0WIiReLu1YwN5SFtQViL7sk5NgEelHczksuMZzyg3Z9S+ximeb18M+Jv5vN
         ypMqUmqsb/QSc/htfnTg48qqHsdRdvowORmC9Os06xGvO8ABjZsZ0KeER+pp+8zwDoT6
         m4Kh+RY1M323yFyGyfmPeGcNRkhPCZ2Fvmu9X6MZbMSTvOTyN032UUbbJ2WX3d8KtdbY
         puuQ==
X-Gm-Message-State: AOAM531wEOpvhf0nyAkb15ABCkem4x5E2UJiYZplI4VbkGIuHdd60fKn
        kZ6KMYxXqxaHTdPVzBChTGkTDSv9DDtOn9xV
X-Google-Smtp-Source: ABdhPJxBpXBw+9k+gUq96Zqt/giNmNGDRTs7hHab5TE4Rt1bDxxOET8Yk31RvPkFA2Z4y9gvHV75lA==
X-Received: by 2002:a5d:4492:: with SMTP id j18mr1269646wrq.151.1625090681713;
        Wed, 30 Jun 2021 15:04:41 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.185])
        by smtp.gmail.com with ESMTPSA id a4sm15363238wru.55.2021.06.30.15.04.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 15:04:41 -0700 (PDT)
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
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <72ae0561-fe00-3c26-ee5b-5410fec08b31@gmail.com>
Date:   Wed, 30 Jun 2021 23:04:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d4adfec3-8e08-3445-ce63-5ed71ae967c3@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 10:56 PM, Jens Axboe wrote:
> On 6/30/21 3:45 PM, Jens Axboe wrote:
>> On 6/30/21 3:38 PM, Pavel Begunkov wrote:
>>> On 6/30/21 10:22 PM, Jens Axboe wrote:
>>>> On 6/30/21 3:19 PM, Pavel Begunkov wrote:
>>>>> On 6/30/21 10:17 PM, Jens Axboe wrote:
>>>>>> On 6/30/21 2:54 PM, Pavel Begunkov wrote:
>>>>>>> Whenever possible we don't want to fallback a request. task_work_add()
>>>>>>> will be fine if the task is exiting, so don't check for PF_EXITING,
>>>>>>> there is anyway only a relatively small gap between setting the flag
>>>>>>> and doing the final task_work_run().
>>>>>>>
>>>>>>> Also add likely for the hot path.
>>>>>>
>>>>>> I'm not a huge fan of likely/unlikely, and in particular constructs like:
>>>>>>
>>>>>>> -	if (test_bit(0, &tctx->task_state) ||
>>>>>>> +	if (likely(test_bit(0, &tctx->task_state)) ||
>>>>>>>  	    test_and_set_bit(0, &tctx->task_state))
>>>>>>>  		return 0;
>>>>>>
>>>>>> where the state is combined. In any case, it should be a separate
>>>>>> change. If there's an "Also" paragraph in a patch, then that's also
>>>>>> usually a good clue that that particular change should've been
>>>>>> separate :-)
>>>>>
>>>>> Not sure what's wrong with likely above, but how about drop
>>>>> this one then?
>>>>
>>>> Yep I did - we can do the exiting change separately, the commit message
>>>
>>> I think 1-2 is good enough for 5.14, I'll just send it for-next
>>>
>>>> just needs to be clarified a bit on why it's ok to do now. And that
>>>
>>> It should have been ok to do before those 2 patches, but
>>> haven't tracked where it lost actuality.
>>
>> Right, I was thinking it was related to the swapping of the signal
>> exit and task work run ordering. But didn't look that far yet...
> 
> BTW, in usual testing, even just the one hunk removing the exit check
> seems to result in quite a lot of memory leaks running
> test/poll-mshot-update. So something is funky with the patch.

Oh, have no idea why yet. Apparently, I commented out
the test as it was always failing, and forgot to return
it back... Will take a note

-- 
Pavel Begunkov
