Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EAA3B8A57
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 00:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhF3WNI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 18:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbhF3WNH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 18:13:07 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D509EC061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 15:10:36 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id a5-20020a7bc1c50000b02901e3bbe0939bso2705966wmj.0
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 15:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zD2IGUHYtBe4hIYMZij30vVwJWchrWWuYMxaHm311E4=;
        b=rXIRp84Fr6yDmB2FNQe8VfC2JaApxzH3wIrWhuC+6LuebtsgDfOYWkCd66teG3tV3v
         XCJUOMmUCgTlfOJfJoU1QW8uYCVvdfEThj55E2ncFLdxJp7PzZDSMgv4mMA3i9M2APPo
         48yNUjb3XlsZDSGLCvKugsPkdMuJByWOB9/Yc+VCgl2P4bYw5IG4hAp6eWU/GerMxSVY
         xq3FZgFzZ76kXW1rpm5jWR8FyKm7r25EpqLz9TLWU0u/46kAYWAaQwUFAmFRkUCXK2Zt
         aBBEgXjDVsCnfF4ENj0iKNnWa7/GRevKUt6tA0W/BwQsTXfblIgoziFUZYK4ffNYYqbl
         V3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zD2IGUHYtBe4hIYMZij30vVwJWchrWWuYMxaHm311E4=;
        b=JZmXTK8S80N5MHYbl3bE/YRRZuXpxSKbuYAgqkX48EtE+oNfLRz4uyaaoyRMH1nH0z
         O7PlX/1y02udG3NpZt/WiEh1A8Pe5pTXtsrEXe7LKpvXodJ/MoQjA7Kfqwum3/TNKvVJ
         Nwgze7iH2bmrx3lPVhrPOHcfZJpfK7cRMCvdFwxZRmjl9YV7/JenVKAr/H5rpl9JOJN2
         pVLUdLDEDWA6i5njLoBr5SYptYYB5DzC9Q9L0Qf/jvXEn2BQfoEK0YamImB9gKW4Lk1R
         AEvtbwB9/T0+sOjiybA9+rUFBV0MOIEIzMulgfIRxupPQhcR0Orj7ze0z75ej9AyLFlV
         5UhA==
X-Gm-Message-State: AOAM533NZyxh/xuo3aalV/sQ/zQ57gsOl9lniPR7BqxWRX5Ns0IHCUt0
        YIQrjvAMnFgnibIgPg53tXNygjcLphImKSy5
X-Google-Smtp-Source: ABdhPJwbxOl3rpCdDUA4YzRytnh/fz64xb5wm94klbLBU1+Z1JJB8cf6tmnV+G3OobB3RYHek6vIXw==
X-Received: by 2002:a7b:c0c5:: with SMTP id s5mr15313460wmh.173.1625091035358;
        Wed, 30 Jun 2021 15:10:35 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.185])
        by smtp.gmail.com with ESMTPSA id w9sm4404048wmc.19.2021.06.30.15.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 15:10:35 -0700 (PDT)
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
Message-ID: <d94f850f-3394-9a16-dd9a-614575f87c01@gmail.com>
Date:   Wed, 30 Jun 2021 23:10:18 +0100
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

I guess you're positive that patches 1-2 have nothing to do
with that. Right?

-- 
Pavel Begunkov
