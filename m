Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D363B8A47
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 23:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhF3WAV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 18:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhF3WAV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 18:00:21 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3693C061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:57:50 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id i189so4998562ioa.8
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wgAbRJN2aN89fO6A9blI78xO1ID5bHijlVohAhMW79E=;
        b=cofOYFpEJ5CAGXiPF3q7i8Tw6Wxs6JdOk5To+ER//FC5cO+X7wLIcD9nnGc5iZTnFe
         ZOhaikXVnjPTciotJCcMlZOlArcnZPtLVE1mynANH6jkKnre5wpxTaxuMiYlFMHINze9
         MLMAN/rj2O1BUYC5IpMyyLJKms7KUxvWU1BgxiT60X3PgpYklVKTLks9RY1d8xeFg2yQ
         8JDQH22v8+3RVvYKW1QyZWcnRvLzAIiTlV7xktjylEZsOyvqWoLWPqGHMZNu3OhF2s/X
         B8qU9rcdXPfjcpbG7DJ6ZsMzl8zFJ81WVBkn2whULhGijA4AE1Fvl7UuT6/RPqAxWKIg
         VHcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wgAbRJN2aN89fO6A9blI78xO1ID5bHijlVohAhMW79E=;
        b=C9Qkgwhq1+xYrIfOqqbvlOZmgl5RYz1Zj/SIz5e39PpuikCCLXE28gfzY6Z+/GWcfB
         W55XGhh+D3Vi5ippBtw+75bBNnVMmIuDYcVRnMV47zMehK8i0jIpVDohK+GKkyKbTFVf
         0Y60bWSxp/deVBpreZDwkYYK/0TFva/lmWvnTHO3C9O2Q+uL3V5gWs+J/NvF/jUeDI5Q
         9s2IPDeA5CPf+FUPbkyL/Nuh2LrynyAHtkPPkv8zvDFX5UKCcuVoQbyIDPwtO2jH8dGM
         1nC2aha7CAjjuUp4Xy6hSJxfaILPg5yBlAVSFT3GPuYNtFeS6Ce/FfiPHU5RzuYLUm+F
         xz0A==
X-Gm-Message-State: AOAM532fEYb/3uNsTdSAt3Qd5m8xteBUJhTA1Hiv1mI7rHKYulpZAVwG
        9EhxSbE7qdrjxJAjWuL1PBufK+MCzuHRHg==
X-Google-Smtp-Source: ABdhPJwAjw5b19MOK7ZlsPznfhOFRNWRcgOnJQC0BybmJTYSuIoCu69FC4+MrwcooP3hfyNsyyt7iQ==
X-Received: by 2002:a02:94af:: with SMTP id x44mr10620038jah.79.1625090269751;
        Wed, 30 Jun 2021 14:57:49 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id x8sm12761115ila.36.2021.06.30.14.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 14:57:49 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: tweak io_req_task_work_add
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1625086418.git.asml.silence@gmail.com>
 <24b575ea075ae923992e9ce86b61e8b51629fd29.1625086418.git.asml.silence@gmail.com>
 <70c425a8-73dd-e15a-5a10-8ea640cdc7cd@kernel.dk>
 <d7f587b1-67bb-fc67-1174-91d2c8706b42@gmail.com>
 <e1b32d88-5801-b280-25ed-9902cfaa5092@kernel.dk>
 <dc8576f5-9187-c897-d2d5-04f61d54408d@gmail.com>
 <cf74754e-b120-fb71-098b-13d1eeb9428f@kernel.dk>
 <7197a75d-566b-b182-4f46-98617c00c480@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8a4eabff-c279-0ae5-b316-454a16de6a04@kernel.dk>
Date:   Wed, 30 Jun 2021 15:57:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7197a75d-566b-b182-4f46-98617c00c480@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 3:57 PM, Pavel Begunkov wrote:
> On 6/30/21 10:45 PM, Jens Axboe wrote:
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
> commit 6200b0ae4ea28a4bfd8eb434e33e6201b7a6a282
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Sun Sep 13 14:38:30 2020 -0600
> 
>     io_uring: don't run task work on an exiting task
> 
> Came from there, times where there still was io_uring_flush()
> and no from do_exit() cancellations

Ah yes, that makes sense.

-- 
Jens Axboe

