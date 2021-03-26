Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6539034AB01
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhCZPKX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbhCZPKG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:10:06 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718B9C0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:10:06 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id n21so5716622ioa.7
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=utfxfNwabcfbVuwRPgcfwhwS17kOd25iCl9MxY83iVE=;
        b=dMq5Lpev1I4olY/DhGk/CchPEmq+vul7WGppqcV63oKm07OlwWX/iltIar3WXuem8D
         b5d3lH5OB3kl3r6+3QjE5rLkThFpdis9+16KUhZJZtKNxiPV0SpIWCCgbtBoPiFWyUnk
         ekZWioz+48lrFIArkFd9I7R5ICbZQ9l6691Q0WIp2A5c227EdzW7pbbXnSZHlFdDROqG
         ZaOKN3QbT05Q1gtlRnDFit/hVUXoWRvy1SMe/1SJNBq4++NiQXeFA3XXhXbBUTuqdolo
         7nMZ3ytzrG3xr4wjhTZq4pOzbXBDvZSHamJ0+rFnWc+R/s25tzGsE97fPEx/9Rr6GWQr
         cG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=utfxfNwabcfbVuwRPgcfwhwS17kOd25iCl9MxY83iVE=;
        b=aD7c2V1uSdM0c3uidKabASAp+ANLpC0nSsHfSExJhBzcxZkndconB3GT3pOmDI7AFk
         GqjmpcLQGakDi5HvS8rmczGV9ddqyaHJmFivxGb7CfWtqyh6Ym16fazMkbftD0V5lXRc
         tNjBXT5Vr9LMzoJmR9kgTHKK6vDTZ840BZVLd+kfQ9e58r5/sQR3YfdfJn25gDoKwpE7
         R9Kn2v0pWGBIDz5+Va+2NRhEqbBkT8D/lpsG9o3ZAKqotGGjB7GRz7fbGPJoGW0dwwoC
         k4H/kQHyPNSm5VWR/cda1WbJ2o9Sv4ygVsFwGZJaMEm3tv4R7qWi2ZqdfIKVBEj9pDYE
         uHQA==
X-Gm-Message-State: AOAM533u2NgQFdLAcw0T6knLPF3hAu91oxtkPLvD54oekAKQ+/iiSUpG
        dR9qoAzPUu14op47Nl0XBV8D9w==
X-Google-Smtp-Source: ABdhPJxKNEhuBgzkLLp9/Bj9ZO9o7cOlxWsoSKMrhuTImZ7Tcdk4OGSZBz2EIlfybr6jDxJmSImp6A==
X-Received: by 2002:a02:cb4b:: with SMTP id k11mr12410255jap.144.1616771405872;
        Fri, 26 Mar 2021 08:10:05 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 14sm4623798ilt.54.2021.03.26.08.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 08:10:05 -0700 (PDT)
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e30c5922-b775-d664-c22a-554fe2774a78@kernel.dk>
Date:   Fri, 26 Mar 2021 09:10:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6a171373-e901-ae97-41fd-29445c3fe89e@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 9:08 AM, Stefan Metzmacher wrote:
> Am 26.03.21 um 15:55 schrieb Jens Axboe:
>> On 3/26/21 8:53 AM, Jens Axboe wrote:
>>> On 3/26/21 8:45 AM, Stefan Metzmacher wrote:
>>>> Am 26.03.21 um 15:43 schrieb Stefan Metzmacher:
>>>>> Am 26.03.21 um 15:38 schrieb Jens Axboe:
>>>>>> On 3/26/21 7:59 AM, Jens Axboe wrote:
>>>>>>> On 3/26/21 7:54 AM, Jens Axboe wrote:
>>>>>>>>> The KILL after STOP deadlock still exists.
>>>>>>>>
>>>>>>>> In which tree? Sounds like you're still on the old one with that
>>>>>>>> incremental you sent, which wasn't complete.
>>>>>>>>
>>>>>>>>> Does io_wq_manager() exits without cleaning up on SIGKILL?
>>>>>>>>
>>>>>>>> No, it should kill up in all cases. I'll try your stop + kill, I just
>>>>>>>> tested both of them separately and didn't observe anything. I also ran
>>>>>>>> your io_uring-cp example (and found a bug in the example, fixed and
>>>>>>>> pushed), fwiw.
>>>>>>>
>>>>>>> I can reproduce this one! I'll take a closer look.
>>>>>>
>>>>>> OK, that one is actually pretty straight forward - we rely on cleaning
>>>>>> up on exit, but for fatal cases, get_signal() will call do_exit() for us
>>>>>> and never return. So we might need a special case in there to deal with
>>>>>> that, or some other way of ensuring that fatal signal gets processed
>>>>>> correctly for IO threads.
>>>>>
>>>>> And if (fatal_signal_pending(current)) doesn't prevent get_signal() from being called?
>>>>
>>>> Ah, we're still in the first get_signal() from SIGSTOP, correct?
>>>
>>> Yes exactly, we're waiting in there being stopped. So we either need to
>>> check to something ala:
>>>
>>> relock:
>>> +	if (current->flags & PF_IO_WORKER && fatal_signal_pending(current))
>>> +		return false;
>>>
>>> to catch it upfront and from the relock case, or add:
>>>
>>> 	fatal:
>>> +		if (current->flags & PF_IO_WORKER)
>>> +			return false;
>>>
>>> to catch it in the fatal section.
>>
>> Can you try this? Not crazy about adding a special case, but I don't
>> think there's any way around this one. And should be pretty cheap, as
>> we're already pulling in ->flags right above anyway.
>>
>> diff --git a/kernel/signal.c b/kernel/signal.c
>> index 5ad8566534e7..5b75fbe3d2d6 100644
>> --- a/kernel/signal.c
>> +++ b/kernel/signal.c
>> @@ -2752,6 +2752,15 @@ bool get_signal(struct ksignal *ksig)
>>  		 */
>>  		current->flags |= PF_SIGNALED;
>>  
>> +		/*
>> +		 * PF_IO_WORKER threads will catch and exit on fatal signals
>> +		 * themselves. They have cleanup that must be performed, so
>> +		 * we cannot call do_exit() on their behalf. coredumps also
>> +		 * do not apply to them.
>> +		 */
>> +		if (current->flags & PF_IO_WORKER)
>> +			return false;
>> +
>>  		if (sig_kernel_coredump(signr)) {
>>  			if (print_fatal_signals)
>>  				print_fatal_signal(ksig->info.si_signo);
>>
> 
> I guess not before next week, but if it resolves the problem for you,
> I guess it would be good to get this into rc5.

It does, I pushed out a new branch. I'll send out a v2 series in a bit.

-- 
Jens Axboe

