Return-Path: <io-uring+bounces-8100-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC769AC2650
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 17:20:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7EE49E5242
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 15:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF951C861A;
	Fri, 23 May 2025 15:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yRuy3thP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168C7207DFD
	for <io-uring@vger.kernel.org>; Fri, 23 May 2025 15:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748013628; cv=none; b=ffkvmH55dw4xgZc20bWIY8THQqgHtMhxqBQFWvMJHFr0xf6v9v9zJnWS0A/+/Snt2eJyrDN8L6qqtDaueqPHw7aHJdSkif5GSAnjGHntiA3Q6xUkxq775CNAiA68cmy0ClUhSF49/DZJMNbdPiT31VWe7Qc48MJYniZCqf3AxFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748013628; c=relaxed/simple;
	bh=N2fQnVtiM1LPGY/BgxpNgU5JtkCT9zoy1sn8EfPk0C4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mRf3sZq8EFXy8RLBCyuMSKfzAZZ5vzngS3GCQndPQ4kUUEZ1hAPRust6CeoAsR1WEW7NzowOebvEXrkFPM/WFd8fw/rpCQwkyIxZkca/oXcsGiujjgclHPp3JZ4oHgRmF8ZBtaSwnyh9kMisEae+tpHQiGlVyv9dG+y51D8WOZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yRuy3thP; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3d8020ba858so40495ab.0
        for <io-uring@vger.kernel.org>; Fri, 23 May 2025 08:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748013626; x=1748618426; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6tIK28SwckRL9twqRdIeEiS4a3kgn/1/MK/6zCmJpSA=;
        b=yRuy3thPV3L6pInKN3WMGGJ2KR3ljyZseRTaQtUZez/4p7Lc/SRY4F/x2VelddLZpK
         OAlSk+DFE8qoeKZwaS4rT7DLMpvUddzFdmNhaLBVIbqllDnqLUoDY5dubDm/Vzw/+fTR
         jDTsdviNRr/cCg8thhRBbFhHvPVS7mvhVO+YKUz89SrJfrzSI5RTRH/HPBT5XQnGiWJi
         eiSXX/6+G5T03xADeRbM0Jw73zWejvFm1p/EFmEsqGiyaSqAC44W5HupRd5PKB208tI5
         za+6orHkhGv/TF39C8QHcJi3FhnFMD2KV0x6AmcFxug6p69SWm2z9fjyNlUnimwDKqdE
         9FnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748013626; x=1748618426;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6tIK28SwckRL9twqRdIeEiS4a3kgn/1/MK/6zCmJpSA=;
        b=GjIM4MhrGPuhoMEzl4q7ONsOar0jPuvEfeEqJXPs/0rRG0/0sYxf6rs6AEozXatU4T
         /7cfe+8c66tQIFtw1QwI2vYxqUXAbZ/3ZBepKRDPSSnAfbOodI2uF7wcj8o4iw7fEBu3
         SsmI+K4Uja92reW1dmd5FUf+Nmtt+e76ztQZwx8ZCd9BwZizrWZ28WKLiPWeLt6DCiXX
         YapX3YZ9FMtSRmzdoXVk2qeJTa/FeXPVNErBlOOU3FrCc+cSnHBDjHOKmkwpKgSybMza
         U9xPiFEiOkyEPL80zPBa40nCl6n3cKc5z8Aq+XJA7k+c/g5m2hgJLKmZ6H/NDinNZHeT
         8Srw==
X-Forwarded-Encrypted: i=1; AJvYcCVSJV5kVQV2t8v1SMddiIWVC6Xx6O958HR2bSKmUgGoD4OHb6tBBzBH/U+4nXEVw5zqXgFtIXp64w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyW2AA6LOFpdmWtYTl9mIS1qcZX7gGUM6RuNde65s+c1S4f0BhU
	70+rZ7rkJbufFyE2or0hj4/IgLDsEikAf9ryO0oGGWFhJvr7z1BncTmZo5zsp0DBd7gen5LU0g9
	m43HW
X-Gm-Gg: ASbGnctd2FDr2vC4zxFyDFrNIvDtZqMp5VIRxhjUbkWHq1g4uF1awvkzI67aChbB3ZG
	fNSg8gWLj0hq4dUmpMEi/50VgenATBKZ9iNvX96CO0bLuleQOKT7H3OBb7Lcsv6TI37BA4gFDVu
	QcG+zFG/ZvJEmswWLjhG20qwnWS6MUxTXyNevBO+8h2OUd6MTYpHKMLaTb7hsxid/JvhT0HenQZ
	7yzyXoikuIpgYAYmrbM2GozyOk9nljiCZR6GzaUZSosw87zQxYn/nkQCAXDBVd67RA01XIXztvh
	r5bn0bGkfuYfVlnuML7YeUjstlvj6cLNlulUCCFdMXklLlQ=
X-Google-Smtp-Source: AGHT+IEkBP7ibxM3selZY1Oa2jjX46/6SejGZhcFxk0eFjYCzfRMr03bOmeuR3eqjAikHvfcCvaq1w==
X-Received: by 2002:a05:6e02:2788:b0:3d8:1b25:cc2 with SMTP id e9e14a558f8ab-3dc9326cf12mr36070505ab.8.1748013614110;
        Fri, 23 May 2025 08:20:14 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dc84ceeccesm14519445ab.45.2025.05.23.08.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 May 2025 08:20:13 -0700 (PDT)
Message-ID: <7bf620dc-1b5c-4401-a03c-16978de0598a@kernel.dk>
Date: Fri, 23 May 2025 09:20:12 -0600
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
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CAPFOzZtxXOQvC0wcNLaj-hZUOf2PWqon0uEvbQh7if7a7DdX=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/23/25 1:57 AM, Fengnan Chang wrote:
> Jens Axboe <axboe@kernel.dk> ?2025?5?22??? 22:29???
>>
>> On 5/22/25 6:01 AM, Fengnan Chang wrote:
>>> Jens Axboe <axboe@kernel.dk> ?2025?5?22??? 19:35???
>>>>
>>>> On 5/22/25 3:09 AM, Fengnan Chang wrote:
>>>>> When running fio with buffer io and stable iops, I observed that
>>>>> part of io_worker threads keeps creating and destroying.
>>>>> Using this command can reproduce:
>>>>> fio --ioengine=io_uring --rw=randrw --bs=4k --direct=0 --size=100G
>>>>> --iodepth=256 --filename=/data03/fio-rand-read --name=test
>>>>> ps -L -p pid, you can see about 256 io_worker threads, and thread
>>>>> id keeps changing.
>>>>> And I do some debugging, most workers create happen in
>>>>> create_worker_cb. In create_worker_cb, if all workers have gone to
>>>>> sleep, and we have more work, we try to create new worker (let's
>>>>> call it worker B) to handle it.  And when new work comes,
>>>>> io_wq_enqueue will activate free worker (let's call it worker A) or
>>>>> create new one. It may cause worker A and B compete for one work.
>>>>> Since buffered write is hashed work, buffered write to a given file
>>>>> is serialized, only one worker gets the work in the end, the other
>>>>> worker goes to sleep. After repeating it many times, a lot of
>>>>> io_worker threads created, handles a few works or even no work to
>>>>> handle,and exit.
>>>>> There are several solutions:
>>>>> 1. Since all work is insert in io_wq_enqueue, io_wq_enqueue will
>>>>> create worker too, remove create worker action in create_worker_cb
>>>>> is fine, maybe affect performance?
>>>>> 2. When wq->hash->map bit is set, insert hashed work item, new work
>>>>> only put in wq->hash_tail, not link to work_list,
>>>>> io_worker_handle_work need to check hash_tail after a whole dependent
>>>>> link, io_acct_run_queue will return false when new work insert, no
>>>>> new thread will be created either in io_wqe_dec_running.
>>>>> 3. Check is there only one hash bucket in io_wqe_dec_running. If only
>>>>> one hash bucket, don't create worker, io_wq_enqueue will handle it.
>>>>
>>>> Nice catch on this! Does indeed look like a problem. Not a huge fan of
>>>> approach 3. Without having really looked into this yet, my initial idea
>>>> would've been to do some variant of solution 1 above. io_wq_enqueue()
>>>> checks if we need to create a worker, which basically boils down to "do
>>>> we have a free worker right now". If we do not, we create one. But the
>>>> question is really "do we need a new worker for this?", and if we're
>>>> inserting hashed worked and we have existing hashed work for the SAME
>>>> hash and it's busy, then the answer should be "no" as it'd be pointless
>>>> to create that worker.
>>>
>>> Agree
>>>
>>>>
>>>> Would it be feasible to augment the check in there such that
>>>> io_wq_enqueue() doesn't create a new worker for that case? And I guess a
>>>> followup question is, would that even be enough, do we always need to
>>>> cover the io_wq_dec_running() running case as well as
>>>> io_acct_run_queue() will return true as well since it doesn't know about
>>>> this either?
>>> Yes?It is feasible to avoid creating a worker by adding some checks in
>>> io_wq_enqueue. But what I have observed so far is most workers are
>>> created in io_wq_dec_running (why no worker create in io_wq_enqueue?
>>> I didn't figure it out now), it seems no need to check this
>>> in io_wq_enqueue.  And cover io_wq_dec_running is necessary.
>>
>> The general concept for io-wq is that it's always assumed that a worker
>> won't block, and if it does AND more work is available, at that point a
>> new worker is created. io_wq_dec_running() is called by the scheduler
>> when a worker is scheduled out, eg blocking, and then an extra worker is
>> created at that point, if necessary.
>>
>> I wonder if we can get away with something like the below? Basically two
>> things in there:
>>
>> 1) If a worker goes to sleep AND it doesn't have a current work
>>    assigned, just ignore it. Really a separate change, but seems to
>>    conceptually make sense - a new worker should only be created off
>>    that path, if it's currenly handling a work item and goes to sleep.
>>
>> 2) If there is current work, defer if it's hashed and the next work item
>>    in that list is also hashed and of the same value.
> I like this change, this makes the logic clearer. This patch looks good,
> I'll do more tests next week.

Thanks for taking a look - I've posted it as a 3 patch series, as 1+2
above are really two separate things that need sorting imho. I've queued
it up for the next kernel release, so please do test next week when you
have time.

-- 
Jens Axboe

