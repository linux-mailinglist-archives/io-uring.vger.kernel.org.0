Return-Path: <io-uring+bounces-8122-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43398AC6B15
	for <lists+io-uring@lfdr.de>; Wed, 28 May 2025 15:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7A911883AD3
	for <lists+io-uring@lfdr.de>; Wed, 28 May 2025 13:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B58F247285;
	Wed, 28 May 2025 13:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WnSYBNIV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B00548EE
	for <io-uring@vger.kernel.org>; Wed, 28 May 2025 13:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748440605; cv=none; b=BJKxq9W9hrpOSs3FTun0vMkUpo7NnuRMJx2eJ2EugsqWDHfbnTt50AQyjvNJJmBHzaZD41JfJKxhidUDdC25dc94NlnhyBbUT7PHpOvo7P+TpEwcQnzMrxtj0Wzgh0DpYs6NcmeycK1VwLCg9YCZtHKEezyZvvrs6EwnNTw1NoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748440605; c=relaxed/simple;
	bh=or9Z9bLWWzApRxQJ6ClNsNqde5C8HsPzV27T4k8XRlo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=SK6C529oYamny0VI6DCuQaCk3qjYdqg4FO6LACbNtoQj3LxvczNKvaARb/e3bw7AZuePlh2I82DeJjYYx0H4OJlmEZz9YZUG3CHKluT8iZHFZEGzcJvw8idlPE7X8LUihlDAS/j1cCfQaDLPfmUnRgzg0YA9JRQ0UBp5F3M8SCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WnSYBNIV; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3dc9e3bd2e3so13804125ab.1
        for <io-uring@vger.kernel.org>; Wed, 28 May 2025 06:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748440600; x=1749045400; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BOjbDGDdoWvFBDTTPsg4yRZ2lGv7H/kyJzJu+043IWo=;
        b=WnSYBNIVwaDo6SMeSSUgN3MTdg/1BxbVCiolRwVS/nbQibODnmCHLegPIMFTEM3kWg
         Fuf+3g9APhqtTG8LqtiyY8QAq3OZC51b5I8GlE7KpJbZXlockUjJAkzs4s+aURt3FkC8
         8zR/zjMOzeGShevz2fYl+UUdg+fBQ7HocpLyc3z/584K5zvDwwvW/dM/XZF0i3v2NpKG
         mfM6nMAnCaPr5WYplnm3PrAknHrmGGSpNLgF9T9u08ehNn4AmgDEsc4dtKgqbMTUor8q
         u1FERkWHVoYV5PSqLofyIVhom6hAcU76M8kaK9LGAab6mluZ7qL4z1wc9Ewjo+psjw5p
         wsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748440600; x=1749045400;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BOjbDGDdoWvFBDTTPsg4yRZ2lGv7H/kyJzJu+043IWo=;
        b=ULGL0L1Gsdfo8VkRQgCIHEuuoajjUyGG+SAPzdOKhJ277yKgsY2x2JrbeDjaXELmsD
         ViMQWEDBruv0Tq/NEgvMOCP0+YMgbr0Pj9JHYTVIg47XTInBnXvLTzhTMXJicT4p6HL/
         rCV2J2n4J+MzIGZb+EzcCpabXwcCgimKlYqJU02RFPgug8+Km9FwXSlGt+lZHPkmLt8y
         VhV9D3NsnuHu2kwfIzTsww2bE91oePZ9c9L0MyejeljDO5gNv5A6uHWAvYrm30Awv5ax
         7I1Sk9a9QxQM/mK0jTa6O7qMqmtFivRm9arYTchJmtZLPpXz47SN3KCLDoBNKu1s0ZGX
         cnYA==
X-Forwarded-Encrypted: i=1; AJvYcCUpsKYl1zsC8sLH3nq0BhjSRnPlZ+yXCRY3hEXdiiTF3YwJ0/kGbUi+zsVwDJyJNKONkO186e0YEg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/m9BDcnZNxdWHOUq8umI0gvP4WBzLXfrhxnqxpSHFUetqqb5K
	mK7jVEWOOw2AKDqTozQ2XrIB7F8fQudDuL65WjEqLIAphEezFHfChe30eoHKJlkxYZA=
X-Gm-Gg: ASbGncsmzgXKUcHUDbrIt9hcf8TjwWxOkmaetNxrzo1M9CVMf1knlSolcepNzQ6eY/v
	qcKy5Dg9mi2DdaLyns5DxpkcOAPzWsPwcfvv2/aberHhBTQU9y7PcHlf3R6xW0wXFad91QQfXeM
	ecXFbENh79Vy2SKh4YYDbztzMOB9Td8xsrRsboTmfmCh81d4Qd96JNOr7HzyU0+CW9MhMXaEFtO
	8cf5aoOckZd3ew+01w0WR1SaS792v+hBY51ePkkIZ5A48K38KR3Yge7eP+GruyIRSrJkz2yspUl
	A/TRnWOA12PhJRJICFskpJgCueleLLTzKwz7fHwuth45NOQ=
X-Google-Smtp-Source: AGHT+IFZKUXuQDzgi2oQpv80hx75EWyrA+WPftvZiUUH0979+OceL1rh0NGGDSDpjESAAEPuhQk16g==
X-Received: by 2002:a05:6e02:1547:b0:3dc:6761:4494 with SMTP id e9e14a558f8ab-3dc9b6e7ba3mr182786635ab.18.1748440599652;
        Wed, 28 May 2025 06:56:39 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd8bfb2fc0sm3157395ab.3.2025.05.28.06.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 May 2025 06:56:39 -0700 (PDT)
Message-ID: <07297228-f913-4142-ad33-3ae87f4fc099@kernel.dk>
Date: Wed, 28 May 2025 07:56:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [RFC PATCH] io_uring: fix io worker thread that
 keeps creating and destroying
From: Jens Axboe <axboe@kernel.dk>
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 Diangang Li <lidiangang@bytedance.com>
References: <20250522090909.73212-1-changfengnan@bytedance.com>
 <b8cd8947-76fa-4863-a1f6-119c6d086196@kernel.dk>
 <CAPFOzZtxRYsCg1BVdpDUH=_bsLEQRvsp5+x-7Kpwow66poUVtA@mail.gmail.com>
 <356c5068-bd97-419a-884c-bcdb04ad6820@kernel.dk>
 <CAPFOzZtxXOQvC0wcNLaj-hZUOf2PWqon0uEvbQh7if7a7DdX=g@mail.gmail.com>
 <7bf620dc-1b5c-4401-a03c-16978de0598a@kernel.dk>
 <CAPFOzZvajLPeCk7OOWoww8XdtA3mSkT+hkuMomBt=5pqMZ29SQ@mail.gmail.com>
 <84ac5b93-7f1c-4092-80a8-9f9813cdbc1b@kernel.dk>
Content-Language: en-US
In-Reply-To: <84ac5b93-7f1c-4092-80a8-9f9813cdbc1b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/25 7:39 AM, Jens Axboe wrote:
> On 5/26/25 5:14 AM, Fengnan Chang wrote:
>> Jens Axboe <axboe@kernel.dk> ?2025?5?23??? 23:20???
>>>
>>> On 5/23/25 1:57 AM, Fengnan Chang wrote:
>>>> Jens Axboe <axboe@kernel.dk> ?2025?5?22??? 22:29???
>>>>>
>>>>> On 5/22/25 6:01 AM, Fengnan Chang wrote:
>>>>>> Jens Axboe <axboe@kernel.dk> ?2025?5?22??? 19:35???
>>>>>>>
>>>>>>> On 5/22/25 3:09 AM, Fengnan Chang wrote:
>>>>>>>> When running fio with buffer io and stable iops, I observed that
>>>>>>>> part of io_worker threads keeps creating and destroying.
>>>>>>>> Using this command can reproduce:
>>>>>>>> fio --ioengine=io_uring --rw=randrw --bs=4k --direct=0 --size=100G
>>>>>>>> --iodepth=256 --filename=/data03/fio-rand-read --name=test
>>>>>>>> ps -L -p pid, you can see about 256 io_worker threads, and thread
>>>>>>>> id keeps changing.
>>>>>>>> And I do some debugging, most workers create happen in
>>>>>>>> create_worker_cb. In create_worker_cb, if all workers have gone to
>>>>>>>> sleep, and we have more work, we try to create new worker (let's
>>>>>>>> call it worker B) to handle it.  And when new work comes,
>>>>>>>> io_wq_enqueue will activate free worker (let's call it worker A) or
>>>>>>>> create new one. It may cause worker A and B compete for one work.
>>>>>>>> Since buffered write is hashed work, buffered write to a given file
>>>>>>>> is serialized, only one worker gets the work in the end, the other
>>>>>>>> worker goes to sleep. After repeating it many times, a lot of
>>>>>>>> io_worker threads created, handles a few works or even no work to
>>>>>>>> handle,and exit.
>>>>>>>> There are several solutions:
>>>>>>>> 1. Since all work is insert in io_wq_enqueue, io_wq_enqueue will
>>>>>>>> create worker too, remove create worker action in create_worker_cb
>>>>>>>> is fine, maybe affect performance?
>>>>>>>> 2. When wq->hash->map bit is set, insert hashed work item, new work
>>>>>>>> only put in wq->hash_tail, not link to work_list,
>>>>>>>> io_worker_handle_work need to check hash_tail after a whole dependent
>>>>>>>> link, io_acct_run_queue will return false when new work insert, no
>>>>>>>> new thread will be created either in io_wqe_dec_running.
>>>>>>>> 3. Check is there only one hash bucket in io_wqe_dec_running. If only
>>>>>>>> one hash bucket, don't create worker, io_wq_enqueue will handle it.
>>>>>>>
>>>>>>> Nice catch on this! Does indeed look like a problem. Not a huge fan of
>>>>>>> approach 3. Without having really looked into this yet, my initial idea
>>>>>>> would've been to do some variant of solution 1 above. io_wq_enqueue()
>>>>>>> checks if we need to create a worker, which basically boils down to "do
>>>>>>> we have a free worker right now". If we do not, we create one. But the
>>>>>>> question is really "do we need a new worker for this?", and if we're
>>>>>>> inserting hashed worked and we have existing hashed work for the SAME
>>>>>>> hash and it's busy, then the answer should be "no" as it'd be pointless
>>>>>>> to create that worker.
>>>>>>
>>>>>> Agree
>>>>>>
>>>>>>>
>>>>>>> Would it be feasible to augment the check in there such that
>>>>>>> io_wq_enqueue() doesn't create a new worker for that case? And I guess a
>>>>>>> followup question is, would that even be enough, do we always need to
>>>>>>> cover the io_wq_dec_running() running case as well as
>>>>>>> io_acct_run_queue() will return true as well since it doesn't know about
>>>>>>> this either?
>>>>>> Yes?It is feasible to avoid creating a worker by adding some checks in
>>>>>> io_wq_enqueue. But what I have observed so far is most workers are
>>>>>> created in io_wq_dec_running (why no worker create in io_wq_enqueue?
>>>>>> I didn't figure it out now), it seems no need to check this
>>>>>> in io_wq_enqueue.  And cover io_wq_dec_running is necessary.
>>>>>
>>>>> The general concept for io-wq is that it's always assumed that a worker
>>>>> won't block, and if it does AND more work is available, at that point a
>>>>> new worker is created. io_wq_dec_running() is called by the scheduler
>>>>> when a worker is scheduled out, eg blocking, and then an extra worker is
>>>>> created at that point, if necessary.
>>>>>
>>>>> I wonder if we can get away with something like the below? Basically two
>>>>> things in there:
>>>>>
>>>>> 1) If a worker goes to sleep AND it doesn't have a current work
>>>>>    assigned, just ignore it. Really a separate change, but seems to
>>>>>    conceptually make sense - a new worker should only be created off
>>>>>    that path, if it's currenly handling a work item and goes to sleep.
>>>>>
>>>>> 2) If there is current work, defer if it's hashed and the next work item
>>>>>    in that list is also hashed and of the same value.
>>>> I like this change, this makes the logic clearer. This patch looks good,
>>>> I'll do more tests next week.
>>>
>>> Thanks for taking a look - I've posted it as a 3 patch series, as 1+2
>>> above are really two separate things that need sorting imho. I've queued
>>> it up for the next kernel release, so please do test next week when you
>>> have time.
>>
>> I have completed the test and the results are good.
> 
> Thanks for re-testing!
> 
>> But I still have a concern. When using one uring queue to buffer write
>> multiple files, previously there were multiple workers working, this
>> change will make only one worker working, which will reduce some
>> concurrency and may cause performance degradation. But I didn't find
>> it in the actual test, so my worry may be unnecessary.
> 
> Could be one of two things:
> 
> 1) None of the workers _actually_ end up blocking, in which case it's
>    working as-designed.
> 
> 2) We're now missing cases where we should indeed create a worker. This
>    is a bug.
> 
> I'll run some specific testing for io-wq here to see if it's 1 or 2.

Ran a very basic test case, which is using btrfs and O_DIRECT reads.
btrfs has this "bug" where anything dio bigger than 4k will always
return -EAGAIN if RWF_NOWAIT is set, which makes it a good use case to
test this as any directly issued IO will return -EAGAIN, and you know
that a dio read will always end up blocking if issued sync.> 

Doing:

fio --name=foo --filename=/data/foo --bs=8k --direct=1 \
--ioengine=io_uring --iodepth=8

should this yield 8 iou-wrk workers running, which it does seems to do.
If I bump that to iodepth=32, then I should see about 32 workers on
average, which also looks to be true.

Hence it doesn't immediately look like we're not creating workers when
we should, and we're not over-creating either.

This is not to say that the current code is perfect. If you have a case
you think is wrong, then please do send it along. But I suspect that
your writing case ends up largely not blocking, which is where io-wq
would otherwise create a new worker if one is needed. There's no
checking in io-wq for "this worker is not blocking but is running for a
long time" that will create a new worker. There probably could/should
be, but that's not how it's been done so far. New worker creation is
strictly driven by an existing worker going to sleep AND there being
other work items to start.

Note: this is _blocking_, not being scheduled out. If an io-wq worker is
being preempted right now, then that will not count as an event that
warrants creating a new worker. We could potentially have it called for
preemption too, and let that be the driver of "long running work". That
might be an improvement, at least for certain workloads.

-- 
Jens Axboe

