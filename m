Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1247F34AB23
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhCZPMd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhCZPMU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:12:20 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08565C0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:12:18 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id r8so5293881ilo.8
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/B+rkG+QASXJ+f3N/V701sPdc66lQcXE98p293DZ/Ro=;
        b=yGKGzQKQ3J4aDN0SiM1Cc94ZusrO3ZOe0UiL+VrtoUWKJ50JIaoAB2NKGPnZdyYNlI
         zXTTsKQq2m5K63jZTsyIgizRhkdfQqQ79zvRo+2JP7UtU40wvy/mE81lMlPUj4P6dVNP
         4lIf1p5//fuMAYIFIfo7dztwwMBhUoDryZPB7qIvTSr1kw0vRpx1y2klINt/aXkin7P5
         Z4xH0KXqgx68CIuGBGiUtS77Ey7FU/BEGEWDvASuivjKvTSLvjfYwvqEgdNsrFNY83r1
         vWLbbOto37SyiH7VIOpiymGTSrn178cLrPeq6YCqAuNBqKqU8UFyU5H5ANdZ5kNsDEV2
         INEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/B+rkG+QASXJ+f3N/V701sPdc66lQcXE98p293DZ/Ro=;
        b=YY6gyp2xKILxFLnJX2He4x2EZqgSHzqxh6nPLXzNV0jvTF/Gpwb0uHZ1dSlFpCJo3L
         2oziC/U3QcHxdqpKO3S1516WWCeTxC6ARyewAcPdiJzPgRcVxuqb9onzqM7goQahh7XB
         8nbzgXYu44LXQXkkplYDpFQcd6NDAa37sYY8ywYK/C+HeZomkiyu6oPUSAVj+r2jmiTx
         vxyDZ67MXRFCF3q3WBtgu/0tKUVhhXtFrYx5FBgYmnri9n/rSFOF/VvSpjNaXa3YNw9T
         zJ2twSOW0TR4M7Nwk8ggYeyVbYHKIfA0vUpPSyHQkOTndAVqOuxjsNSSQzpIfEJycS9J
         ge+w==
X-Gm-Message-State: AOAM530XnVVd9nDyI0SblaFLdYopTjt9cHdjoIWtd9wXPdEhnarC4s5x
        84joKe8tz0so5X3mrXPAvagi4Q==
X-Google-Smtp-Source: ABdhPJyN604lOiqV3+3XwW5ECVqjzT6kq4SSE/vnPAIv78cRziMv0b73uD1e2aVKi2nJj17lkqmnPg==
X-Received: by 2002:a05:6e02:f07:: with SMTP id x7mr5614797ilj.242.1616771537478;
        Fri, 26 Mar 2021 08:12:17 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q21sm4377742ioh.41.2021.03.26.08.12.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 08:12:17 -0700 (PDT)
Subject: Re: [PATCH 0/6] Allow signals for IO threads
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
 <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
 <0c91d9e7-82cd-bec2-19ae-cc592ec757c6@kernel.dk>
 <bfaae5fd-5de9-bae4-89b6-2d67bbfb86c6@kernel.dk>
 <66fa3cfc-4161-76fe-272e-160097f32a53@kernel.dk>
 <67a83ad5-1a94-39e5-34c7-6b2192eb7edb@samba.org>
 <ac807735-53d0-0c9e-e119-775e5e01d971@samba.org>
 <0396df33-7f91-90c8-6c0d-8a3afd3fff3c@kernel.dk>
 <1304f480-a8db-44cf-5d89-aa9b99efdcd7@kernel.dk>
 <6a171373-e901-ae97-41fd-29445c3fe89e@samba.org>
 <e30c5922-b775-d664-c22a-554fe2774a78@kernel.dk>
 <018c3185-bd13-1085-e738-9b5010252215@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <26b06a25-9be9-102e-09f5-b2cb7c0fbc5e@kernel.dk>
Date:   Fri, 26 Mar 2021 09:12:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <018c3185-bd13-1085-e738-9b5010252215@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 9:11 AM, Stefan Metzmacher wrote:
> Am 26.03.21 um 16:10 schrieb Jens Axboe:
>> On 3/26/21 9:08 AM, Stefan Metzmacher wrote:
>>> Am 26.03.21 um 15:55 schrieb Jens Axboe:
>>>> On 3/26/21 8:53 AM, Jens Axboe wrote:
>>>>> On 3/26/21 8:45 AM, Stefan Metzmacher wrote:
>>>>>> Am 26.03.21 um 15:43 schrieb Stefan Metzmacher:
>>>>>>> Am 26.03.21 um 15:38 schrieb Jens Axboe:
>>>>>>>> On 3/26/21 7:59 AM, Jens Axboe wrote:
>>>>>>>>> On 3/26/21 7:54 AM, Jens Axboe wrote:
>>>>>>>>>>> The KILL after STOP deadlock still exists.
>>>>>>>>>>
>>>>>>>>>> In which tree? Sounds like you're still on the old one with that
>>>>>>>>>> incremental you sent, which wasn't complete.
>>>>>>>>>>
>>>>>>>>>>> Does io_wq_manager() exits without cleaning up on SIGKILL?
>>>>>>>>>>
>>>>>>>>>> No, it should kill up in all cases. I'll try your stop + kill, I just
>>>>>>>>>> tested both of them separately and didn't observe anything. I also ran
>>>>>>>>>> your io_uring-cp example (and found a bug in the example, fixed and
>>>>>>>>>> pushed), fwiw.
>>>>>>>>>
>>>>>>>>> I can reproduce this one! I'll take a closer look.
>>>>>>>>
>>>>>>>> OK, that one is actually pretty straight forward - we rely on cleaning
>>>>>>>> up on exit, but for fatal cases, get_signal() will call do_exit() for us
>>>>>>>> and never return. So we might need a special case in there to deal with
>>>>>>>> that, or some other way of ensuring that fatal signal gets processed
>>>>>>>> correctly for IO threads.
>>>>>>>
>>>>>>> And if (fatal_signal_pending(current)) doesn't prevent get_signal() from being called?
>>>>>>
>>>>>> Ah, we're still in the first get_signal() from SIGSTOP, correct?
>>>>>
>>>>> Yes exactly, we're waiting in there being stopped. So we either need to
>>>>> check to something ala:
>>>>>
>>>>> relock:
>>>>> +	if (current->flags & PF_IO_WORKER && fatal_signal_pending(current))
>>>>> +		return false;
>>>>>
>>>>> to catch it upfront and from the relock case, or add:
>>>>>
>>>>> 	fatal:
>>>>> +		if (current->flags & PF_IO_WORKER)
>>>>> +			return false;
>>>>>
>>>>> to catch it in the fatal section.
>>>>
>>>> Can you try this? Not crazy about adding a special case, but I don't
>>>> think there's any way around this one. And should be pretty cheap, as
>>>> we're already pulling in ->flags right above anyway.
>>>>
>>>> diff --git a/kernel/signal.c b/kernel/signal.c
>>>> index 5ad8566534e7..5b75fbe3d2d6 100644
>>>> --- a/kernel/signal.c
>>>> +++ b/kernel/signal.c
>>>> @@ -2752,6 +2752,15 @@ bool get_signal(struct ksignal *ksig)
>>>>  		 */
>>>>  		current->flags |= PF_SIGNALED;
>>>>  
>>>> +		/*
>>>> +		 * PF_IO_WORKER threads will catch and exit on fatal signals
>>>> +		 * themselves. They have cleanup that must be performed, so
>>>> +		 * we cannot call do_exit() on their behalf. coredumps also
>>>> +		 * do not apply to them.
>>>> +		 */
>>>> +		if (current->flags & PF_IO_WORKER)
>>>> +			return false;
>>>> +
>>>>  		if (sig_kernel_coredump(signr)) {
>>>>  			if (print_fatal_signals)
>>>>  				print_fatal_signal(ksig->info.si_signo);
>>>>
>>>
>>> I guess not before next week, but if it resolves the problem for you,
>>> I guess it would be good to get this into rc5.
>>
>> It does, I pushed out a new branch. I'll send out a v2 series in a bit.
> 
> Great, thanks!
> 
> Any chance to get the "cmdline" hiding included?

I'll take a look at your response there, haven't yet. Wanted to get this
one sorted first.

-- 
Jens Axboe

