Return-Path: <io-uring+bounces-1246-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB00E88EB6B
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 17:37:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 062E01C2B614
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 16:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9424F13AD3A;
	Wed, 27 Mar 2024 16:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="W53JqU+C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B71514C5A5
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 16:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711557421; cv=none; b=K7D3QeHgBQmqUlje46ccot523SdqIhPufTtZ4VAtBNuf3gyh9G868Xy7Wy0rwOQIvoVSTigQozIUQ8IlaO3dx9HtfSR3sUzJPXgzjHM1cblP6MQ3gxR6i+mcvzIlAR1TwS0+qsQFACDGsfCp1J8X1phsI5cMPxGELL3ZwqAzzrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711557421; c=relaxed/simple;
	bh=BkTFYq9fDoJ4mfNTrNDjoHVl3q+omrSKSoOjd42y+FI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kHyAjzI2sIc102VgaBjyXtEzNSnVR9srIQsNCsEsfuStiEDxWnr/H703FCDzn1hdMDGAO6QReITfi2tUxU8mIvVQXgljGT7BTMqm9XaH5dHIzTG6ehnI1E3tjZbCTCspNOZO0J3VI/IYWutGX6FKVm4ZNXKLyeYEBa+hUh3DDR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=W53JqU+C; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5cdbc42f5efso220252a12.0
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 09:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711557419; x=1712162219; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LjoiTYxbGJgeyeTThsHrqe6z4x8H3z2tYccBr7W5xBQ=;
        b=W53JqU+CIWtV3+NrxnbWVT8NbVdV2yb456vJYc0xT1LHo+IEHovTESt5PRgKa6nyr9
         uKzwoV4LhNmXVQAwNkkFugAktlJ3aCM09lPP5EmJ3CkaVrnl6qo/kZlGCGMbVONlOjMT
         XHscx2i9SWNNLRLaivgJ/d02/ycpZmviOU+CxeEIiNvF5TN30SylGpaWZQ7LpYurWCeW
         bbISOVfAybymm1ief61kdhhc3pX3F95v8IQ9zX8dH2ew2tfCd2njNnhoHI5sX1InTA3K
         SfyR4rpmkP21v9e6FkteCC1Oj1UYz5DpZpjlVrsgupyOxbYa9K4JkfHf18ED5SROHN2b
         ptPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711557419; x=1712162219;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LjoiTYxbGJgeyeTThsHrqe6z4x8H3z2tYccBr7W5xBQ=;
        b=WZK+Vm9dUjJS7MlbEYL8+qbBGeswqPg2jgxwgYw2F56Uyzksd3HrgtD28WIgBAsImZ
         UuCxv71hWnW07w48qYNKIbNi/e+UKm/UVyP0XaBbOZLlD55uMB1Nx3Ue4s40CUhrqFnf
         lKUqK5Jjo/4KHBdNHswhL8b4pePgbOl22U9nDRpWQDmKyje2pNyNNDL/1KzpswfohwVn
         uzYmApDRGlR8QxNJnZFrhR0GYyHJU9k8LTZjSwFykYKJnpapC5cUUotvzyi6Fyed87kU
         4WUYUvtvpVXPNa1GDVZneXqZNT7GvNiPnvpbPF2yhf5LxxPjdA65mqnS3qLfrOfa3jdU
         w9tA==
X-Forwarded-Encrypted: i=1; AJvYcCW9Dtzy4I0haZSM3cL8ALTG0vmW+pTiM8ynDzMgvHwQBTl+bvWMk3sTyB4MVwtVfHf9IjJ4g0ZwxUQfGjCQPda5bopQ7QoDgEg=
X-Gm-Message-State: AOJu0YyPYFoepeBTxhGFI2hSFRDmPhoYjHJgUiwEL5nvTv5V6hIbTpHV
	CqQ10+YJQn+3MI6gQ85xUOO4ZM9G3VgqO+wy+0I+YzrMoxUIWhFG0Nd5CTa7+QgxHuwddFsAdMX
	2
X-Google-Smtp-Source: AGHT+IF9oKQZBzKksRWiUlwE4dunx/pGOMSVjh20pFyFWaiy8+pw8ro2LeC707Ua0jVqggHbvQk+5Q==
X-Received: by 2002:a17:90b:4a43:b0:2a0:350a:a7a8 with SMTP id lb3-20020a17090b4a4300b002a0350aa7a8mr133486pjb.2.1711557419315;
        Wed, 27 Mar 2024 09:36:59 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:5ff4])
        by smtp.gmail.com with ESMTPSA id k6-20020a17090a658600b0029bc1c931d9sm1905155pjj.51.2024.03.27.09.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 09:36:58 -0700 (PDT)
Message-ID: <88493204-8801-4bbc-b8dc-c483e59e999e@kernel.dk>
Date: Wed, 27 Mar 2024 10:36:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/4] Use io_wq_work_list for task_work
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240326184615.458820-1-axboe@kernel.dk>
 <03e57f18-1565-46a4-a6b1-d95be713bfb2@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <03e57f18-1565-46a4-a6b1-d95be713bfb2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/27/24 7:33 AM, Pavel Begunkov wrote:
> On 3/26/24 18:42, Jens Axboe wrote:
>> Hi,
>>
>> This converts the deferred, normal, and fallback task_work to use a
>> normal io_wq_work_list, rather than an llist.
>>
>> The main motivation behind this is to get rid of the need to reverse
>> the list once it's deleted and run. I tested this basic conversion of
>> just switching it from an llist to an io_wq_work_list with a spinlock,
>> and I don't see any benefits from the lockless list. And for cases where
>> we get a bursty addition of task_work, this approach is faster as it
>> avoids the need to iterate the list upfront while reversing it.
> 
> I'm curious how you benchmarked it including accounting of irq/softirq
> where tw add usually happens?

Performance based and profiles. I tested send zc with small packets, as
that is task_work intensive and exhibits the bursty behavior I mentioned
in the patch / cover letter. And normal storage IO, IRQ driven.

For send zc, we're spending about 2% of the time doing list reversal,
and I've seen as high as 5 in other testing. And as that test is CPU
bound, performance is up about 2% as well.

With the patches, task work adding accounts for about 0.25% of the
cycles, before it's about 0.66%.

We're spending a bit more time in __io_run_local_work(), but I think
that's deceptive as we have to disable/enable interrupts now. If an
interrupt triggers on the unlock, that time tends to be attributed there
in terms of cycles.

> One known problem with the current list approach I mentioned several
> times before is that it peeks at the previous queued tw to count them.
> It's not nice, but that can be easily done with cmpxchg double. I
> wonder how much of an issue is that.

That's more of a wart than a real issue though, but we this approach
obviously doesn't do that. And then we can drop the rcu section around
adding local task_work. Not a huge deal, but still nice.

>> And this is less code and simpler, so I'd prefer to go that route.
> 
> I'm not sure it's less code, if you return optimisations that I
> believe were killed, see comments to patch 2, it might turn out to
> be even bulkier and not that simpler.

It's still considerably less:

 3 files changed, 59 insertions(+), 84 deletions(-)

thought that isn't conclusive by itself, as eg io_llist_xchg() goes away
which has some comments. But I do think the resulting code is simpler
and more straight forward.

-- 
Jens Axboe


