Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D458634AB08
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCZPL7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhCZPL3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:11:29 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB40BC0613B2;
        Fri, 26 Mar 2021 08:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=X6+Ia+AcMqWgp5WM6pGVUxgYvK/J+DRXTGwO3A7jLr4=; b=vVdTk3Jp09NhTqG45pZr2o9fuw
        YdqG1WuyZ8By4vBvqh8n7AwuCVHTx0sGhmdQ+fabsZ1nR03YxXvRHnXpHcpycJ+z87UbnjYbLs0dh
        jFFpSvkZEgZket0uHlDc7C+1fHzQ17q0tGV5BvwcSGIwxKDe9Iuni97Ak7QnCrCdTWSjhHG7ciyKn
        DAeA7QQQjSeZ0Flqp1XwOPVe/T/OmYOZD4I6MUXGHIFaRb39ElSQaGKnh3Zq2p8MmM9kjh9hH07M3
        7/UAkgIaD1Bd1hrcr14SVpAruE972kwnGyPF8+fn8O+Q3aU/AGHiP37f9m9eZADKfQ1A4z3ywk34N
        Ip6JYh9fdmkUKH21t/OaFtixDzMNYVMSxsrQ8KMtGnTNej011hUIxTlGS607qw4Xa6XuACWpQvx7p
        wx/std7cVg0MBS/y62RLVs7KBcve0Bwkrb51wm3uw+tFgjusT320G4BaWxtddw4xfKzwzgDvWtjXp
        zv6xQoPg7QtL3V1OWYg7yjna;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPo7S-0003Le-Gb; Fri, 26 Mar 2021 15:11:27 +0000
Subject: Re: [PATCH 0/6] Allow signals for IO threads
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
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
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <018c3185-bd13-1085-e738-9b5010252215@samba.org>
Date:   Fri, 26 Mar 2021 16:11:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <e30c5922-b775-d664-c22a-554fe2774a78@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 26.03.21 um 16:10 schrieb Jens Axboe:
> On 3/26/21 9:08 AM, Stefan Metzmacher wrote:
>> Am 26.03.21 um 15:55 schrieb Jens Axboe:
>>> On 3/26/21 8:53 AM, Jens Axboe wrote:
>>>> On 3/26/21 8:45 AM, Stefan Metzmacher wrote:
>>>>> Am 26.03.21 um 15:43 schrieb Stefan Metzmacher:
>>>>>> Am 26.03.21 um 15:38 schrieb Jens Axboe:
>>>>>>> On 3/26/21 7:59 AM, Jens Axboe wrote:
>>>>>>>> On 3/26/21 7:54 AM, Jens Axboe wrote:
>>>>>>>>>> The KILL after STOP deadlock still exists.
>>>>>>>>>
>>>>>>>>> In which tree? Sounds like you're still on the old one with that
>>>>>>>>> incremental you sent, which wasn't complete.
>>>>>>>>>
>>>>>>>>>> Does io_wq_manager() exits without cleaning up on SIGKILL?
>>>>>>>>>
>>>>>>>>> No, it should kill up in all cases. I'll try your stop + kill, I just
>>>>>>>>> tested both of them separately and didn't observe anything. I also ran
>>>>>>>>> your io_uring-cp example (and found a bug in the example, fixed and
>>>>>>>>> pushed), fwiw.
>>>>>>>>
>>>>>>>> I can reproduce this one! I'll take a closer look.
>>>>>>>
>>>>>>> OK, that one is actually pretty straight forward - we rely on cleaning
>>>>>>> up on exit, but for fatal cases, get_signal() will call do_exit() for us
>>>>>>> and never return. So we might need a special case in there to deal with
>>>>>>> that, or some other way of ensuring that fatal signal gets processed
>>>>>>> correctly for IO threads.
>>>>>>
>>>>>> And if (fatal_signal_pending(current)) doesn't prevent get_signal() from being called?
>>>>>
>>>>> Ah, we're still in the first get_signal() from SIGSTOP, correct?
>>>>
>>>> Yes exactly, we're waiting in there being stopped. So we either need to
>>>> check to something ala:
>>>>
>>>> relock:
>>>> +	if (current->flags & PF_IO_WORKER && fatal_signal_pending(current))
>>>> +		return false;
>>>>
>>>> to catch it upfront and from the relock case, or add:
>>>>
>>>> 	fatal:
>>>> +		if (current->flags & PF_IO_WORKER)
>>>> +			return false;
>>>>
>>>> to catch it in the fatal section.
>>>
>>> Can you try this? Not crazy about adding a special case, but I don't
>>> think there's any way around this one. And should be pretty cheap, as
>>> we're already pulling in ->flags right above anyway.
>>>
>>> diff --git a/kernel/signal.c b/kernel/signal.c
>>> index 5ad8566534e7..5b75fbe3d2d6 100644
>>> --- a/kernel/signal.c
>>> +++ b/kernel/signal.c
>>> @@ -2752,6 +2752,15 @@ bool get_signal(struct ksignal *ksig)
>>>  		 */
>>>  		current->flags |= PF_SIGNALED;
>>>  
>>> +		/*
>>> +		 * PF_IO_WORKER threads will catch and exit on fatal signals
>>> +		 * themselves. They have cleanup that must be performed, so
>>> +		 * we cannot call do_exit() on their behalf. coredumps also
>>> +		 * do not apply to them.
>>> +		 */
>>> +		if (current->flags & PF_IO_WORKER)
>>> +			return false;
>>> +
>>>  		if (sig_kernel_coredump(signr)) {
>>>  			if (print_fatal_signals)
>>>  				print_fatal_signal(ksig->info.si_signo);
>>>
>>
>> I guess not before next week, but if it resolves the problem for you,
>> I guess it would be good to get this into rc5.
> 
> It does, I pushed out a new branch. I'll send out a v2 series in a bit.

Great, thanks!

Any chance to get the "cmdline" hiding included?

metze

