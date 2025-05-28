Return-Path: <io-uring+bounces-8121-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DB64AC6AC4
	for <lists+io-uring@lfdr.de>; Wed, 28 May 2025 15:39:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D9D03A5939
	for <lists+io-uring@lfdr.de>; Wed, 28 May 2025 13:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DEEF7FBA2;
	Wed, 28 May 2025 13:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lVffQwXU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774D426A0E0
	for <io-uring@vger.kernel.org>; Wed, 28 May 2025 13:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748439584; cv=none; b=hBf42C9+BQMxBYFK8xvpCGup460KQ+QzoeJbNHiQ0MOs3+lD8Z7SG+zOLWEDtxY030h14IGhtqZSh5ubY7JojKD9EQumraizSmMUsBspVM2v3wI0eUMG0m9E1XNQoElC1oeLoyMjEsgzMShXphkNwhC+bLOCpDvdobC5dKRvAcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748439584; c=relaxed/simple;
	bh=bS4vfC2BCtzHx9/d/2yY6/BuFqbJAi4+ixauy/FhO9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WuGPjZkybJAGQ+menGpL0q1c0sr17rhj3beEKa8ehndngru6CqAmGPvtqLnVyqj7AacTr90UgF9hpd0RjrJVPV9jd0uOfOuYcCw+6DFBXRVGKIzxuju+/znywrS3APpIWvqDlCXSwUlhwT+uqtwUcbxwvhwcUJN8o4KSBfc4J5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lVffQwXU; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3dd81f9ce2eso3003635ab.1
        for <io-uring@vger.kernel.org>; Wed, 28 May 2025 06:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748439578; x=1749044378; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LRR55wqJfin7ZKU2ksx7+RmI/AW6cVgT72mUwaGpOqU=;
        b=lVffQwXU0cPHp9Uqp6ZC8o5uri4NrlzI1ch5q6gwF1a5PiSNOPGmXZ+bI9YygrFmlN
         QWJhOePMcewch7mqKJw4xPBdF4e9h1+CVh2lFAlmjKmwf6Wdg1pea3oqgbXjYefJYK/0
         Msfkdub3oXFET/7C5L/IS5lR6g2nPJEQiHsV07sJC8vLVgzcUkoa+gTddQIFYkUVAIx5
         3t/0Q1dxvh8JQvKuR3irk9tt6z309wokuCxv+LqSw7y3zsEhLE3AvQTlesV1uCPcp4eT
         25C3D9GFdEQtsOCn78F/tA3z2wxXGnaTbS14thUvYcde6Jsgt3i/r7CmXZTBS2YC369W
         yIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748439578; x=1749044378;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LRR55wqJfin7ZKU2ksx7+RmI/AW6cVgT72mUwaGpOqU=;
        b=EW5f+Jx3WDVTO6uaVLxvnNpuQtouSqrVKMXyiFI+mdi6+AchzXM5pmi40GJz6PnfIG
         oTTw4kjoiziEkMKBjQUPW6D0/dhs8vHpLrp4P/ZIYns2crQZGoRPfmfgLxZY+tRKEYjn
         PSKsBKi2g8b/Cpldw7HkB76qr6kMEiDns9lgirZUaZwqVGefFFkMQQDv8n8BUwYorCgK
         0KyzKU+Gn+Xx9x3q8qSVWaSN2HbIx9yvIWo1Vj7Av/6lpoXbDZc1jS6x6oAzKfVVyFPO
         LctKw6LXrzSDCnT4IYPv0840EBXPCnho6nf9vfaGrOx3/n4LAmLLlTySIe5+KT8m0DjF
         Oovg==
X-Forwarded-Encrypted: i=1; AJvYcCVRIItcGISdYYhj1v88ePrYzi03NXYOXbjDhIIaAv7CcBEgm92Q0r/dioUr+uNYqP2kjrswaW3akg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUZLMhCHKA/Y6j0N/fP35ygKNhY/6rSeiRwHDhPqvUXDpBi+v5
	4gm+x59CeWhlje/blqhU7GwsLj/9DIl6wMhp83WlOChuDDzVgT/yu1jFciC1zOO9OmE=
X-Gm-Gg: ASbGncuoUQXHSikFmE6dJciZKocXJIbt4zkWXQq9XeyQjkv4e+yUlSDJYTZKbDU2X8e
	t99W9ksLIw9H3arY2FlnzqkbFlypQ73QH2uMdB/mLZuXb779JBz7ghmbGjjlOQxPcjBlh3jb0Ru
	VF63xcxMDAIVZn/YXAVJhe119cAhDxboBUCefNVEBNYswLbfNkURgV7tnoPcEO2qSMM532dkExt
	mTsCY3oHFW80AiVguEKSzcrG7xoSAy1ZGjDzv1bXFX1/jQlEzQAtK6INIHeiWA8bZYj6lLpx1Yw
	pTO0Wa/HKiR8Hq0PMCgV2xZPLwTkZgLMUxsG/23R9k8oKQY=
X-Google-Smtp-Source: AGHT+IHELfMzHyghQ9N6sf9EDwZJx437nnUuTLrwvg+UdTvYW7FXrnZupf3u53+vI9l5sFybfd5JPw==
X-Received: by 2002:a05:6e02:1a2f:b0:3dc:8a59:9d91 with SMTP id e9e14a558f8ab-3dd8762aeefmr46421695ab.5.1748439577844;
        Wed, 28 May 2025 06:39:37 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd8bfb2ef2sm2917545ab.10.2025.05.28.06.39.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 May 2025 06:39:36 -0700 (PDT)
Message-ID: <84ac5b93-7f1c-4092-80a8-9f9813cdbc1b@kernel.dk>
Date: Wed, 28 May 2025 07:39:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [RFC PATCH] io_uring: fix io worker thread that
 keeps creating and destroying
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
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CAPFOzZvajLPeCk7OOWoww8XdtA3mSkT+hkuMomBt=5pqMZ29SQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/26/25 5:14 AM, Fengnan Chang wrote:
> Jens Axboe <axboe@kernel.dk> ?2025?5?23??? 23:20???
>>
>> On 5/23/25 1:57 AM, Fengnan Chang wrote:
>>> Jens Axboe <axboe@kernel.dk> ?2025?5?22??? 22:29???
>>>>
>>>> On 5/22/25 6:01 AM, Fengnan Chang wrote:
>>>>> Jens Axboe <axboe@kernel.dk> ?2025?5?22??? 19:35???
>>>>>>
>>>>>> On 5/22/25 3:09 AM, Fengnan Chang wrote:
>>>>>>> When running fio with buffer io and stable iops, I observed that
>>>>>>> part of io_worker threads keeps creating and destroying.
>>>>>>> Using this command can reproduce:
>>>>>>> fio --ioengine=io_uring --rw=randrw --bs=4k --direct=0 --size=100G
>>>>>>> --iodepth=256 --filename=/data03/fio-rand-read --name=test
>>>>>>> ps -L -p pid, you can see about 256 io_worker threads, and thread
>>>>>>> id keeps changing.
>>>>>>> And I do some debugging, most workers create happen in
>>>>>>> create_worker_cb. In create_worker_cb, if all workers have gone to
>>>>>>> sleep, and we have more work, we try to create new worker (let's
>>>>>>> call it worker B) to handle it.  And when new work comes,
>>>>>>> io_wq_enqueue will activate free worker (let's call it worker A) or
>>>>>>> create new one. It may cause worker A and B compete for one work.
>>>>>>> Since buffered write is hashed work, buffered write to a given file
>>>>>>> is serialized, only one worker gets the work in the end, the other
>>>>>>> worker goes to sleep. After repeating it many times, a lot of
>>>>>>> io_worker threads created, handles a few works or even no work to
>>>>>>> handle,and exit.
>>>>>>> There are several solutions:
>>>>>>> 1. Since all work is insert in io_wq_enqueue, io_wq_enqueue will
>>>>>>> create worker too, remove create worker action in create_worker_cb
>>>>>>> is fine, maybe affect performance?
>>>>>>> 2. When wq->hash->map bit is set, insert hashed work item, new work
>>>>>>> only put in wq->hash_tail, not link to work_list,
>>>>>>> io_worker_handle_work need to check hash_tail after a whole dependent
>>>>>>> link, io_acct_run_queue will return false when new work insert, no
>>>>>>> new thread will be created either in io_wqe_dec_running.
>>>>>>> 3. Check is there only one hash bucket in io_wqe_dec_running. If only
>>>>>>> one hash bucket, don't create worker, io_wq_enqueue will handle it.
>>>>>>
>>>>>> Nice catch on this! Does indeed look like a problem. Not a huge fan of
>>>>>> approach 3. Without having really looked into this yet, my initial idea
>>>>>> would've been to do some variant of solution 1 above. io_wq_enqueue()
>>>>>> checks if we need to create a worker, which basically boils down to "do
>>>>>> we have a free worker right now". If we do not, we create one. But the
>>>>>> question is really "do we need a new worker for this?", and if we're
>>>>>> inserting hashed worked and we have existing hashed work for the SAME
>>>>>> hash and it's busy, then the answer should be "no" as it'd be pointless
>>>>>> to create that worker.
>>>>>
>>>>> Agree
>>>>>
>>>>>>
>>>>>> Would it be feasible to augment the check in there such that
>>>>>> io_wq_enqueue() doesn't create a new worker for that case? And I guess a
>>>>>> followup question is, would that even be enough, do we always need to
>>>>>> cover the io_wq_dec_running() running case as well as
>>>>>> io_acct_run_queue() will return true as well since it doesn't know about
>>>>>> this either?
>>>>> Yes?It is feasible to avoid creating a worker by adding some checks in
>>>>> io_wq_enqueue. But what I have observed so far is most workers are
>>>>> created in io_wq_dec_running (why no worker create in io_wq_enqueue?
>>>>> I didn't figure it out now), it seems no need to check this
>>>>> in io_wq_enqueue.  And cover io_wq_dec_running is necessary.
>>>>
>>>> The general concept for io-wq is that it's always assumed that a worker
>>>> won't block, and if it does AND more work is available, at that point a
>>>> new worker is created. io_wq_dec_running() is called by the scheduler
>>>> when a worker is scheduled out, eg blocking, and then an extra worker is
>>>> created at that point, if necessary.
>>>>
>>>> I wonder if we can get away with something like the below? Basically two
>>>> things in there:
>>>>
>>>> 1) If a worker goes to sleep AND it doesn't have a current work
>>>>    assigned, just ignore it. Really a separate change, but seems to
>>>>    conceptually make sense - a new worker should only be created off
>>>>    that path, if it's currenly handling a work item and goes to sleep.
>>>>
>>>> 2) If there is current work, defer if it's hashed and the next work item
>>>>    in that list is also hashed and of the same value.
>>> I like this change, this makes the logic clearer. This patch looks good,
>>> I'll do more tests next week.
>>
>> Thanks for taking a look - I've posted it as a 3 patch series, as 1+2
>> above are really two separate things that need sorting imho. I've queued
>> it up for the next kernel release, so please do test next week when you
>> have time.
> 
> I have completed the test and the results are good.

Thanks for re-testing!

> But I still have a concern. When using one uring queue to buffer write
> multiple files, previously there were multiple workers working, this
> change will make only one worker working, which will reduce some
> concurrency and may cause performance degradation. But I didn't find
> it in the actual test, so my worry may be unnecessary.

Could be one of two things:

1) None of the workers _actually_ end up blocking, in which case it's
   working as-designed.

2) We're now missing cases where we should indeed create a worker. This
   is a bug.

I'll run some specific testing for io-wq here to see if it's 1 or 2.

-- 
Jens Axboe

