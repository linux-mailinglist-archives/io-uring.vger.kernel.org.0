Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8479B3B8A45
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 23:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhF3V7v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 17:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhF3V7v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 17:59:51 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73885C061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:57:21 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id p8so5484899wrr.1
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=okYOa/dW2DJzTVvK4p/pKIx9siwfIvnR8HvBsGYPuKg=;
        b=JyuPm9b8bJVr/jt7AAAV8tMMYa5owDbe/TmzWIEAkMzz86J8QunU/eHc+ZfP1yKt3b
         b+yGr3f09kjeuiNiOXw+may5UGngsA+JGdXTA49mUcjnkUunbvpAJrx1CJYkwAKIHMFz
         prjPT4iHc1t78ff1rQNKSdynyqBpswQksHlUepquAJ4swHktT2KvnunSY3uhv7jvjoZL
         o17X7Vq/NnC91cV6po8Be6DqRdK2TXyJVy7R3nuBvqqe7wxTlNGsN62AAH02fnkrxfmh
         Sr2tsm5/ROhfuA1RasoHgMyBylGaMxvh+veXFMkEbV/urkf10S5Cv/rea1a6qhtxZBIV
         joQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=okYOa/dW2DJzTVvK4p/pKIx9siwfIvnR8HvBsGYPuKg=;
        b=PQMordoQCUMZs4iGlBDB5i0uv7ukpT3B5zr6ZmF7SSU+eALas/Fstg9ftdr400BPN2
         pKvIVkWtA6cHOM4GqJTGV2kR4zOIOCZlmtvcdIv+zKz9xKhoP/BETNrRrLCB6qlBdjbS
         dPKae7vVrBOcN+HYgp0QupfP6eKCZ4cgkpT0woQ4lsOtusSlrG8u3n6WlcedXNIlHZU7
         m83/cVKT5CuBSzriSyIoH3pKCkXYqA2QP4OFNF7AhJd6vxl7cybEINfozrSn27j4ODLZ
         Rbxlmza4+R7n2YEXCLFKhWRYgAfhdQOvNhtJju7/jglZp2rhzOGb7Ai0kQjnZaSxYZmH
         qiiw==
X-Gm-Message-State: AOAM5338ppQpGsRbeFIATKse2hFid6MeR5HPC31G4FkLqdmO+SP5/t9e
        t8pilE/yWEA9rBanUiPfurhOoc+zwc359Hrt
X-Google-Smtp-Source: ABdhPJw5AzVtD1Ib7HDTIAxWcwcrZZLXBRsDXbfMLOqQV+sxMtgM0etqicda1e06Bn1m6tAPSC+4Tw==
X-Received: by 2002:a05:6000:551:: with SMTP id b17mr41454214wrf.32.1625090239877;
        Wed, 30 Jun 2021 14:57:19 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.185])
        by smtp.gmail.com with ESMTPSA id a9sm22597966wrv.37.2021.06.30.14.57.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 14:57:19 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: tweak io_req_task_work_add
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1625086418.git.asml.silence@gmail.com>
 <24b575ea075ae923992e9ce86b61e8b51629fd29.1625086418.git.asml.silence@gmail.com>
 <70c425a8-73dd-e15a-5a10-8ea640cdc7cd@kernel.dk>
 <d7f587b1-67bb-fc67-1174-91d2c8706b42@gmail.com>
 <e1b32d88-5801-b280-25ed-9902cfaa5092@kernel.dk>
 <dc8576f5-9187-c897-d2d5-04f61d54408d@gmail.com>
 <cf74754e-b120-fb71-098b-13d1eeb9428f@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <7197a75d-566b-b182-4f46-98617c00c480@gmail.com>
Date:   Wed, 30 Jun 2021 22:57:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cf74754e-b120-fb71-098b-13d1eeb9428f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 10:45 PM, Jens Axboe wrote:
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

commit 6200b0ae4ea28a4bfd8eb434e33e6201b7a6a282
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sun Sep 13 14:38:30 2020 -0600

    io_uring: don't run task work on an exiting task

Came from there, times where there still was io_uring_flush()
and no from do_exit() cancellations

-- 
Pavel Begunkov
