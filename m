Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6385934AADF
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhCZPEZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhCZPEM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:04:12 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB1DC0613AA;
        Fri, 26 Mar 2021 08:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=2IzumaravlGk+BRunv2UMivpeelF4L7NzuI2R8lgTAM=; b=CPiXftQsPvgFLchBjgrkJDvUPO
        RN94TVfwAhSD5bPUcG0y1Zea3epbwHadc/HW9y/Mtrm8kEMLCAkyWKja01gImewN0VOiGtJNXmxvS
        1f9aB6tZBKVeRW26jAVSOzHYLtbKz2zlrr7wSf/UNScTousKouvi0dciY+MTyfvLS0OJF2DOoIb82
        ymcrBE8sAT0CDi21qF1Qa252/pClEb2jku3TafwFqhMQrh8QSbKLpCLKnfsllLS50HoxG1Z84AqzN
        UgqcV9kJQMMddh+vg02rTPRCcYyBOkmaFkXudnuQy/vWc7rGdZhwF18+3G0P0gnLGD+8kLg/kvynM
        9KvaMey9HuArf+ls7R07NIMC0XHnPDkZABqQc9bUCaqevLmFO8enaCRWWFDbEY+FqgOLnEO5EfKeW
        R49vArwybC6slpq/rjJZg9jghHrSbcr0jirXK9kyfo+dCnuf92969fxolSnlr+SKwP2W+swispWR5
        OQM2dGtdvEMIsIP0IxaKmpBs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPo0P-0003IQ-Ub; Fri, 26 Mar 2021 15:04:09 +0000
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
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 0/6] Allow signals for IO threads
Message-ID: <98c22337-b85e-0316-b446-d4422af45d56@samba.org>
Date:   Fri, 26 Mar 2021 16:04:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <0396df33-7f91-90c8-6c0d-8a3afd3fff3c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 26.03.21 um 15:53 schrieb Jens Axboe:
> On 3/26/21 8:45 AM, Stefan Metzmacher wrote:
>> Am 26.03.21 um 15:43 schrieb Stefan Metzmacher:
>>> Am 26.03.21 um 15:38 schrieb Jens Axboe:
>>>> On 3/26/21 7:59 AM, Jens Axboe wrote:
>>>>> On 3/26/21 7:54 AM, Jens Axboe wrote:
>>>>>>> The KILL after STOP deadlock still exists.
>>>>>>
>>>>>> In which tree? Sounds like you're still on the old one with that
>>>>>> incremental you sent, which wasn't complete.
>>>>>>
>>>>>>> Does io_wq_manager() exits without cleaning up on SIGKILL?
>>>>>>
>>>>>> No, it should kill up in all cases. I'll try your stop + kill, I just
>>>>>> tested both of them separately and didn't observe anything. I also ran
>>>>>> your io_uring-cp example (and found a bug in the example, fixed and
>>>>>> pushed), fwiw.
>>>>>
>>>>> I can reproduce this one! I'll take a closer look.
>>>>
>>>> OK, that one is actually pretty straight forward - we rely on cleaning
>>>> up on exit, but for fatal cases, get_signal() will call do_exit() for us
>>>> and never return. So we might need a special case in there to deal with
>>>> that, or some other way of ensuring that fatal signal gets processed
>>>> correctly for IO threads.
>>>
>>> And if (fatal_signal_pending(current)) doesn't prevent get_signal() from being called?
>>
>> Ah, we're still in the first get_signal() from SIGSTOP, correct?
> 
> Yes exactly, we're waiting in there being stopped. So we either need to
> check to something ala:
> 
> relock:
> +	if (current->flags & PF_IO_WORKER && fatal_signal_pending(current))
> +		return false;
> 
> to catch it upfront and from the relock case, or add:
> 
> 	fatal:
> +		if (current->flags & PF_IO_WORKER)
> +			return false;
> 
> to catch it in the fatal section.
> 

Or something like io_uring_files_cancel()

Maybe change current->pf_io_worker with a generic current->io_thread
structure which, has exit hooks, as well as
io_wq_worker_sleeping() and io_wq_worker_running().

Maybe create_io_thread would take such an structure
as argument instead of a single function pointer.

struct io_thread_description {
	const char *name;
	int (*thread_fn)(struct io_thread_description *);
	void (*sleeping_fn)((struct io_thread_description *);
	void (*running_fn)((struct io_thread_description *);
	void (*exit_fn)((struct io_thread_description *);
};

And then
struct io_wq_manager {
	struct io_thread_description description;
	... manager specific stuff...
};

metze
