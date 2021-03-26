Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0903634B240
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 23:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhCZWiX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 18:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhCZWiS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 18:38:18 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AAAC0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 15:38:18 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id d12so7168809oiw.12
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 15:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oWhGMhbhfaExshGxGcZbmcEJMK/dZUuQgIL4+55tUvE=;
        b=VxMB7skuZtkbamoSztTVJkDhpc0enYD2DT9h1F3I0Tky4rMifLy1zHotffpbthRZQc
         4ar/mBpaMJLBoxHKd7/nnAF/RvnvQWGr3bSg4PA9QcMkGneu1qOOVVWsqBmhYQvfkEyU
         OGqTF3NuR/yulYjXxYjlOZyToBFSyj1w8Ef0b5nM3rUDHO0u5dsWc9sLWZocA5zucDYq
         yzNWvJ0eqE2x5W9h3Xoink719Ee7ot4Kmvn8g7KXKA3NnxRv19DlXxrrl+j7vCqIAxUq
         Tr3PNT5Upk/fiOqy29BfaQZbb1vGwfPgFAIAwAZtiZL0J1XNl4xjL2pArSOt8G9Ecp5e
         zCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oWhGMhbhfaExshGxGcZbmcEJMK/dZUuQgIL4+55tUvE=;
        b=C571wUwxFEB3TLc3GQCDLKZcCqQtrVdo2C5u9v8uhJDhGJi3loDcMCVgNN1f0+zbQ5
         itsC/wTymozG73iXxz+hcrbYBWx0p5YA7qpWsd2IdEVrYFl3i2hc/34aY3A8FXYE/5MV
         BH9l9PM5fqwOtbI2IlqvBJSKeoKhb/aC3cylk1/jwONn4jPoONLvj+bMGIsmjHN0LwZf
         SFIjr/7p7pn9PU6mnO/i/KeLy4FivZQpKGVLVnQGy5xbUoqGaCkowK9YQ2TChnQT71Eu
         zsPHMavb/aRcQQXO+itfIfefj4izq77/c8Brq2WKUEdlVRH6AwIaaWEiIDSZ83psG0zU
         dH9A==
X-Gm-Message-State: AOAM5302Q1wmGT1I2E0Y9S7e4BDHuui8Prhx619sexBRg5N6I1KjmU6L
        VkX52X/pZeoZEh+aNlKAi+Mzkw==
X-Google-Smtp-Source: ABdhPJwBadLoXC7c0M6lSpBpqMiKAq8cK8Xi7TvgTVaisBNtUWFziHKfttYZ1Nv5lpJY+ScHYk2DIQ==
X-Received: by 2002:a05:6808:14cc:: with SMTP id f12mr11010998oiw.166.1616798297627;
        Fri, 26 Mar 2021 15:38:17 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id k24sm2051602oic.51.2021.03.26.15.38.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 15:38:17 -0700 (PDT)
Subject: Re: [PATCH 2/7] io_uring: handle signals for IO threads like a normal
 thread
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326155128.1057078-1-axboe@kernel.dk>
 <20210326155128.1057078-3-axboe@kernel.dk> <m1wntty7yn.fsf@fess.ebiederm.org>
 <106a38d3-5a5f-17fd-41f7-890f5e9a3602@kernel.dk>
 <m1k0ptv9kj.fsf@fess.ebiederm.org>
 <01058178-dd66-1bff-4d74-5ff610817ed6@kernel.dk>
 <m18s69v8zb.fsf@fess.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7a71da2f-ca39-6bbf-28c1-bcc2eec43943@kernel.dk>
Date:   Fri, 26 Mar 2021 16:38:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <m18s69v8zb.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 4:35 PM, Eric W. Biederman wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 3/26/21 4:23 PM, Eric W. Biederman wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>
>>>> On 3/26/21 2:29 PM, Eric W. Biederman wrote:
>>>>> Jens Axboe <axboe@kernel.dk> writes:
>>>>>
>>>>>> We go through various hoops to disallow signals for the IO threads, but
>>>>>> there's really no reason why we cannot just allow them. The IO threads
>>>>>> never return to userspace like a normal thread, and hence don't go through
>>>>>> normal signal processing. Instead, just check for a pending signal as part
>>>>>> of the work loop, and call get_signal() to handle it for us if anything
>>>>>> is pending.
>>>>>>
>>>>>> With that, we can support receiving signals, including special ones like
>>>>>> SIGSTOP.
>>>>>>
>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>> ---
>>>>>>  fs/io-wq.c    | 24 +++++++++++++++++-------
>>>>>>  fs/io_uring.c | 12 ++++++++----
>>>>>>  2 files changed, 25 insertions(+), 11 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>>>>> index b7c1fa932cb3..3e2f059a1737 100644
>>>>>> --- a/fs/io-wq.c
>>>>>> +++ b/fs/io-wq.c
>>>>>> @@ -16,7 +16,6 @@
>>>>>>  #include <linux/rculist_nulls.h>
>>>>>>  #include <linux/cpu.h>
>>>>>>  #include <linux/tracehook.h>
>>>>>> -#include <linux/freezer.h>
>>>>>>  
>>>>>>  #include "../kernel/sched/sched.h"
>>>>>>  #include "io-wq.h"
>>>>>> @@ -503,10 +502,16 @@ static int io_wqe_worker(void *data)
>>>>>>  		if (io_flush_signals())
>>>>>>  			continue;
>>>>>>  		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
>>>>>> -		if (try_to_freeze() || ret)
>>>>>> +		if (signal_pending(current)) {
>>>>>> +			struct ksignal ksig;
>>>>>> +
>>>>>> +			if (fatal_signal_pending(current))
>>>>>> +				break;
>>>>>> +			if (get_signal(&ksig))
>>>>>> +				continue;
>>>>>                         ^^^^^^^^^^^^^^^^^^^^^^
>>>>>
>>>>> That is wrong.  You are promising to deliver a signal to signal
>>>>> handler and them simply discarding it.  Perhaps:
>>>>>
>>>>> 			if (!get_signal(&ksig))
>>>>>                         	continue;
>>>>> 			WARN_ON(!sig_kernel_stop(ksig->sig));
>>>>>                         break;
>>>>
>>>> Thanks, updated.
>>>
>>> Gah.  Kill the WARN_ON.
>>>
>>> I was thinking "WARN_ON(!sig_kernel_fatal(ksig->sig));"
>>> The function sig_kernel_fatal does not exist.
>>>
>>> Fatal is the state that is left when a signal is neither
>>> ignored nor a stop signal, and does not have a handler.
>>>
>>> The rest of the logic still works.
>>
>> I've just come to the same conclusion myself after testing it.
>> Of the 3 cases, most of them can do the continue, but doesn't
>> really matter with the way the loop is structured. Anyway, looks
>> like this now:
> 
> This idiom in the code:
>> +		if (signal_pending(current)) {
>> +			struct ksignal ksig;
>> +
>> +			if (fatal_signal_pending(current))
>> +				break;
>> +			if (!get_signal(&ksig))
>> +				continue;
>>  }
> 
> Needs to be:
>> +		if (signal_pending(current)) {
>> +			struct ksignal ksig;
>> +
>> +			if (!get_signal(&ksig))
>> +				continue;
>> +			break;
>>  }
> 
> Because any signal returned from get_signal is fatal in this case.
> It might make sense to "WARN_ON(ksig->ka.sa.sa_handler != SIG_DFL)".
> As the io workers don't handle that case.
> 
> It won't happen because you have everything blocked.
>
> The extra fatal_signal_pending(current) logic is just confusing in this
> case.

OK good point, and follows the same logic even if it won't make a
difference in my case. I'll make the change.

-- 
Jens Axboe

