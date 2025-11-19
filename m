Return-Path: <io-uring+bounces-10664-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 819C0C70B9E
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 20:02:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E7F484E1477
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 19:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA4FA1DDA24;
	Wed, 19 Nov 2025 19:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/efX9a8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB01B262FE4
	for <io-uring@vger.kernel.org>; Wed, 19 Nov 2025 19:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763578818; cv=none; b=vBhAZ93Wf8i+4VEANO2BBWrJPjpW6jFe5FauZ45XNebRSgdfnM9cMaG1+dw/67xYxDfnFfUdwU1euYKlzegwvQJ6d6bLMD/lVxQWRiuLBmRmN0CbDSoATKr/bC8oAZUtWAO7HiVJGhRjPQ8btdKwRplYr7FuqGJYCuIemkPSVlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763578818; c=relaxed/simple;
	bh=KnGFpoKuwtmqB/EnRVJ1HUFND/ZP4LQUX3c0HAyxmLo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=bi11O+rmJU93wODH+5tPzOpEYLZeNxFkKfPz287vVsichr8Nkd3iQR4EYzVogWZtbOfrGjSl0w6yeCXEDQpyhImJmmzNSKqM5JdoeArNISPhQQy+ojstnZ2voXN/f/Wgvwvle+flJ/rWjQjLY9iam4ZzRlxDArS6OZKqcIZ9RgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H/efX9a8; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477a1c28778so1092215e9.3
        for <io-uring@vger.kernel.org>; Wed, 19 Nov 2025 11:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763578811; x=1764183611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/2rTu1Zyb2OXccoo9CgESriF93aItZ+MOzoslT+MBNo=;
        b=H/efX9a8ZBdfXGtGI+S7w+VYSXlnygnUEY19RtoBvBfiJvYjmeHveGtBbWQaBNtVtJ
         8E+HdT/1ZV8SxwZiTdtaZFntv9EYW4o56JiSH0iT2IiX9SSL+WdC3M1kA16O76vj74ft
         fyIKVUHpGACyETd3/MM5NAbjHQUPQILllTuVDjHlklHtNKldrCc7jpxb2qt+xH8wCCKX
         obPM7ylOpFr9PJLb3QtGzqLUBRXmSGTD7IsCgBDClWyJqSfdpAf8WO+l0UCVf2DZcosu
         vIPMW1RHuWhRfhx9k/wdxkDM0se5gXirc6k3EO3jcqseQ/s1K7B0RhCwwDlSnuVNIJ4j
         dfSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763578811; x=1764183611;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/2rTu1Zyb2OXccoo9CgESriF93aItZ+MOzoslT+MBNo=;
        b=braWQ1EmSSQw70t4+5wZBhbPu1lTbZ/QRXUj8dRuSghER7EVXvX4cV/iUw0TSCrfkh
         E3ntsyVPcvSb9hCGX8P2rHt0sFaJfNCUnSrZGEhsdW1uI1FTsG4kyaI59PeUg6h+od1u
         SvGFJRfxeIB2hbYL2g9yCa8TtHbyKRryheotQjjKXtYnp77HFLcKPaANHXRC4CKdYUw8
         pw57bOuTJnhgJet7KJjb7BQASb+sUt7E5olKaa0WTQBmHRozdqNn2Ex14Z9WWEPYZaB8
         aPvqK6WsexRvYY/gZ4EhtwEX++C5PhbOkmXDnEagFK0fBeIykQloYl/qJwW3VJI+u0rO
         c49g==
X-Forwarded-Encrypted: i=1; AJvYcCUwZ4/yUVXtEPzALMxSmpi3UpVMk5YCmxDfG1H7qR7CikqMm80U2031w+Ku7tdo9Y9lkH9Y0BPhLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzB8urt56oJWNJBn8kB1O9W+CCHNO/tfg28V6yfXrY08mUnJJKO
	rONF2AoNrs346NsXL2RPPZJPukwqtul6DDuDuC/nKuwtulL2iOM2axhM
X-Gm-Gg: ASbGncte1bfjC0qRNFnXI0yf+dNU/9KACgJxIHW5V4+icsE1Pd7KDR9rOH44OHEdE5D
	FMohGUs6sfgDJDgJbrqLh3+D/mcImNNgv7IiQ5QxWniq7eZq4VihBAChfKnvYnC4EdOotHpRzO6
	tcRFmniyQEB45gOyxXGzuz9ZuCQkT2nLknxTmPZO+a/q9fnBnN/9SZ0ISNz4BaS+wSUq9Y1MC1z
	0CPsGHRqv5bJmGGKj2WiHT9XF5k8vLhbhIJN4oOZ4ASaoW2uiC9d8WSWjSzj0wGwXU5xOYtcMWV
	vLc7+pEwllJzdsU7+bQE/MOGWgd03vJBGjNK3PG+go49fulIoIMpf7U+9PhE9sjxRmQ5Bih3yMq
	CA6FOXKjgEhOk5N8OSmFIK7PZP28Eq/kd0GevDkUL0lTYWjgEzUEM8qQqBOYZmSm+UgYy/01WUx
	K2AG7VUVCH8lZnff6WRCChGD66sYtMZwGlWcJkhDoS26LZR2VVKhg6kp9neAABtw==
X-Google-Smtp-Source: AGHT+IHAX18VnUcaT0wAUrR+wCvUrOrmLXzcKjJrw0Gpf3ST+Lwi0+eH7wNPzaqt/428ybUkeBGd+A==
X-Received: by 2002:a05:600c:1c8d:b0:477:54cd:2029 with SMTP id 5b1f17b1804b1-477b857906emr3833125e9.4.1763578810230;
        Wed, 19 Nov 2025 11:00:10 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477a9dfd643sm45093245e9.14.2025.11.19.11.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 11:00:09 -0800 (PST)
Message-ID: <0527a07c-57ac-41f2-acfd-cfd057922e4a@gmail.com>
Date: Wed, 19 Nov 2025 19:00:08 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 0/5] io_uring: add IORING_OP_BPF for extending io_uring
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Caleb Sander Mateos <csander@purestorage.com>,
 Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
 Alexei Starovoitov <ast@kernel.org>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <891f4413-9556-4f0d-87e2-6b452b08a83f@gmail.com> <aQtz-dw7t7jtqALc@fedora>
 <58c0e697-2f6a-4b06-bf04-c011057cd6c7@gmail.com> <aQ4WTLX9ieL5J7ot@fedora>
 <9b59b165-1f57-4cb6-ae62-403d922ad4da@gmail.com> <aRVcAFOsb7X3kxB9@fedora>
Content-Language: en-US
In-Reply-To: <aRVcAFOsb7X3kxB9@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hey Ming,

Sorry for a late reply

On 11/13/25 04:18, Ming Lei wrote:
...
>> both cases you have bpf implementing some logic that was previously
>> done in userspace. To emphasize, you can do the desired parts of
>> handling in BPF, and I'm not suggesting moving the entirety of
>> request processing in there.
> 
> The problem with your patch is that SQE is built in bpf prog(kernel), then

It's an option, not a requirement. It should be perfectly fine,
for example, to only process CQEs and run some kfuncs, and return
back to userspace.

> inevitable application logic is moved to bpf prog, which isn't good at
> handling complicated logic.
> 
> Then people have to run kernel<->user communication for setting up the SQE.
> 
> And the SQE in bpf prog may need to be linked with previous and following SQEs in
> usersapce, which basically partitions application logic into two parts: one
> is in userspace, another is in bpf prog(kernel).

I'm not a huge fan of links. They add enough of complexity to the
kernel. I'd rather see them gone / sidelined out of the normal
execution paths if there is an alternative.

> The patch I am suggesting doesn't have this problem, all SQEs are built in
> userspace, and just the minimized part(standalone and well defined function) is
> done in bpf prog.
> 
>>
>>>>>> for short BPF programs is not great because of io_uring request handling
>>>>>> overhead. And flexibility was severely lacking, so even simple use cases
>>>>>
>>>>> What is the overhead? In this patch, OP's prep() and issue() are defined in
>>>>
>>>> The overhead of creating, freeing and executing a request. If you use
>>>> it with links, it's also overhead of that. That prototype could also
>>>> optionally wait for completions, and it wasn't free either.
>>>
>>> IORING_OP_BPF is same with existing normal io_uring request and link, wrt
>>> all above you mentioned.
>>
>> It is, but it's an extra request, and in previous testing overhead
>> for that extra request was affecting total performance, that's why
>> linking or not is also important.
> 
> Yes, but does the extra request matters for whole performance?

It did in previous tests with small pre-buffered IO, but that
depends on how well ammortised it is with other requests and
BPF execution.

> I did have such test:
> 
> 1) in tools/testing/selftests/ublk/null.c
> 
> - for zero copy test, one extra nop is submitted
> 
> 2) rublk test
> 
> - for zero copy test, it simply returns without submitting nop
> 
> The IOPS gap is pretty small.
> 
> Also in your approach, without allocating one new SQE in bpf, how to
> provide generic interface for bpf prog to work on different functions, such
> as, memory copy or raid5 parity or compression ..., all require flexible
> handling, such as, variable parameters, buffer could be plain user memory
> , fixed, vectored or fixed vectored,..., so one SQE or new operation is the
> easiest way for providing the abstraction and generic bpf prog interface.

Or it can be a kfunc

...
>>> It is easy to say, how can the BPF prog know the next completion is
>>> exactly waiting for? You have to rely on bpf map to communicate with userspace
>>
>> By taking a peek at and maybe dereferencing cqe->user_data.
> 
> Yes, but you have to pass the interested ->user_data to bpf prog first.

It can be looked it up from the CQ

> There could be many inflight interested IOs, how to query them efficiently?
> 
> Scan each one after every CQE is posted? But ebpf just support bound loops,
> the complexity may be run out of easily[1].
> 
> https://docs.ebpf.io/linux/concepts/loops/

Good point, I need to take a look at the looping.

>>> to understanding what completion is what you are interested in, also
>>> need all information from userpace for preparing the SQE for submission
>>> from bpf prog. Tons of userspace and kernel communication.
>>
>> You can setup a BPF arena, and all that comm will be working with
>> a block of shared memory. Or same but via io_uring parameter region.
>> That sounds pretty simple.
> 
> But application logic has to splitted into two parts, both two have to
> rely on the shared memory to communicate.
> 
> The exiting io_uring application has been complicated enough, adding one
> extra shared memory communication for holding application logic just makes
> things worse. Even in userspace programming, it is horrible to model logic
> into data, that is why state machine pattern is usually not readable.
> 
> Think about writing high performance raid5 application based on ublk zero
> copy & io_uring, for example, handling one simple write:
> 
> - one ublk write command comes for raid5
> 
> - suppose the command just writes data to one single stripe exactly
> 
> - submitting each write to N - 1 disks
> 
> - When all N writes are done, the new SQE needs to work:
> 
> 	- calculate parity by reading buffers from the N request kernel buffer
> 	  and writing resulted XOR parity to one user specified buffer
> 
> - then new FS IO need to be submitted to write the parity data to one calculated
> disk(N)
> 
> So the involved things for bpf prog SQE:
> 
> 	- monitoring N - 1 writes
> 	- do the parity calculation job, which has to define one kfunc
> 	- mark parity is ready & notify userspace for writing parity(how to
> 	  notify?)

And something still needs to do all that. The only silver lining
for userspace handling is that there is more language sugar helping
with it like coroutines.

> Now there can be variable(many) such WRITEs to handle concurrently, and the
> bpf prog has to cover them all.
> 
> The above just the simplest case, the write command may not align with
> stripe, so parity calculation may need to read data from other stripes.
> 
> If you think it is `pretty simple`, care to provide one example to show your
> approach is workable?
> 
>>
>>>> you introduced. After it can optionally queue up requests
>>>> writing it to the storage or anything else.
>>>
>>> Again, I do not want to move userspace logic into bpf prog(kernel), what
>>> IORING_BPF_OP provides is to define one operation, then userspace
>>> can use it just like in-kernel operations.
>>
>> Right, but that's rather limited. I want to cover all those
>> use cases with one implementation instead of fragmenting users,
>> if that can be achieved.
> 
> I don't know when your ambitious plan can land or be doable.
> 
> I am going to write V2 with the approach of IORING_BPF_OP which is at least
> workable for some cases, and much easier to take in userspace. Also it
> doesn't conflict with your approach.

-- 
Pavel Begunkov


