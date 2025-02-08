Return-Path: <io-uring+bounces-6331-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B4FA2D8FA
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 22:40:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4423165651
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 21:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E036119993D;
	Sat,  8 Feb 2025 21:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cZ93xXhv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BB233DB;
	Sat,  8 Feb 2025 21:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739050825; cv=none; b=PrKvBcaVA9vhcBWaRNFv6AYjEJ/W7HBp8UcEBpkZ+AzyuHCOFA6U8atsDZYhirfuXZ3My10+3kKKEE7nDNEq9gyY2WSA9qb6mzwxjGbmxG2n6bv8ZLCVAOA5ZgakJ/G44hS2CCLkMrajYsDDlJiQo5vrXhqz1bq5e578M4lJSEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739050825; c=relaxed/simple;
	bh=NvFMcd30jMo2W3gTKgjEJzdytysiCYjpOZPfsaqfh7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EmmW+xAbprqEar+9YXBJOfH0x1CltmzBro/71nYNWEwx14ab97RxoQ9HxeFkQ1MPpxH430uai7Bo6iAMWa2JSMuDa/2cv5xoNkI+zBx+mQRgFegnYxNDmGsxuTbghkDznBLEYnV5mZEE5VCjvoQF9rQNAS4BEBpU/1lotGumFWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cZ93xXhv; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5dced61e5a3so5828593a12.0;
        Sat, 08 Feb 2025 13:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739050822; x=1739655622; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ggXxobOKOAWHPlVZQhCvjuMnfln2GaczcCxd/sZN16Q=;
        b=cZ93xXhvf7JqHvzpoKVovUIb5uw4xvfepsZCyjsIEUh81EAiOAoM+sQ7gHwlfmUAMz
         Pgo+oX9QpVKw+0TDoRFfGZdwmA0MprO4b9VzaKJpCrrYgq/nkqJHk/j6F3+mP5yRmJIZ
         KwoR7FayhhFA/Q2dYufkIajhZoWx+JNESvQx/6Y+RIBJnd6nwHBQBg34R4rCyE/i+/55
         kmwqBpHPbXr/KjG1VTxNuBj9CkHqaeP4BH/UGrX5U4q6lxDQQcnT/g9sfxC7rKnUH6xX
         PuMGN9dOuQHmqSSoowdqHs4zvHWsBXciRp46uRz2VCsJ98VMQSzzzf2kuFlE8MtqfVql
         uJCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739050822; x=1739655622;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ggXxobOKOAWHPlVZQhCvjuMnfln2GaczcCxd/sZN16Q=;
        b=gOeWmAYUsQ8sFLffuag6IDP017uZjd+lUnPgiOq66odctOuU0AdrzGNf+ZlLDSTix8
         uJE8tUDQ8K95xuGn5BGvabutd1NX2aIKjtX5GwAqOWXtT1lqTH4UvpdvXaEGgLXadjwm
         Bd1M4gAQ/P3Q7tfVpvCmFazUMqG2imE9AwxJ/98cPSh51aaH+wqs+hp8+VocvOgWR+jE
         HojhNsnmU0JBrtljitBOSuFdgsevHekSMvD0i/wXMOT+CdEIa3a4ajUp1m2KyyLD3k8S
         yLODnYV6Mt0o3AI2rHXY43mU6dXMquEMEu0kVU+RRxn9MLq3W9tqkVLOPGYqH/adAABM
         Jh8w==
X-Forwarded-Encrypted: i=1; AJvYcCUoWLS8FB6Fa3rLHw15bwshSmsb+EQyACEVwb9j1bliK8Q/JUlD7UNlCy90tnHkR6ysXj4xLOzdVg==@vger.kernel.org, AJvYcCV1Mf1/fkOM/KQFdWjLKKNAhd0ogLO2mwtjwHeU4XFJyxLMvNu+zObQyxX6/WjV5o8DQJFP5airl7QIePk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZavL5z0U2Ok9Cq0XOo9KewYwldxKLdnXFJyT8ZTkOekm2KHyt
	DJ9OKK1BqfqR3qyj53f2Q8O8dW8MYIlIj/unPNAPdmt9pcAprCduqjUpuA==
X-Gm-Gg: ASbGncsz6IAuCbyry9qqQbcWYHossyE0BPDAjUwqnXJIVPXD9rm5UnmDCFeArdzjOIH
	evE9tF/S4V50d2fZre5yk/5kMITOOXXHqaGzPQ5jEwQSdDL6XiegCLXa1hvc0Z6RaWEDroMfGJ3
	a9THXGlTddHiH05BTLft+i6xiVlu1bHGkT5wY5tt/GOtVXtFkBjne8RGGNvuWGVcZdpqgMtCvCM
	4kxa7ie782R9/XJZUmbZ8nOFUIPzeIYh3Y5fPssIJURneBIhV/+bc4TB3U90ZLCU4J69Mi7JSsr
	W2N50jT8WzRgVIHL3JTdDKdXdw==
X-Google-Smtp-Source: AGHT+IFOIgqK8rTNPt4qp59bkX4QOAIJPXx2bmTW2YFSdHlt69yR1zOZnCFFBV83RSLJWNpZwFYouQ==
X-Received: by 2002:a17:907:971e:b0:ab7:a1a4:8d9b with SMTP id a640c23a62f3a-ab7a1a48f7amr370716066b.1.1739050822180;
        Sat, 08 Feb 2025 13:40:22 -0800 (PST)
Received: from [192.168.8.100] ([148.252.133.220])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7a7829d4csm157521966b.9.2025.02.08.13.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2025 13:40:21 -0800 (PST)
Message-ID: <68256da6-bb13-4498-a0e0-dce88bb32242@gmail.com>
Date: Sat, 8 Feb 2025 21:40:22 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] ublk zero-copy support
To: Keith Busch <kbusch@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@meta.com>,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk,
 Bernd Schubert <bernd@bsbernd.com>
References: <20250203154517.937623-1-kbusch@meta.com>
 <Z6WDVdYxxQT4Trj8@fedora> <Z6YTfi29FcSQ1cSe@kbusch-mbp>
 <Z6bvSXKF9ESwJ61r@fedora> <b6211101-3f74-4dea-a880-81bb75575dbd@gmail.com>
 <Z6e6-w_L4GZwKuN8@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z6e6-w_L4GZwKuN8@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/8/25 20:13, Keith Busch wrote:
> On Sat, Feb 08, 2025 at 02:16:15PM +0000, Pavel Begunkov wrote:
>> On 2/8/25 05:44, Ming Lei wrote:
>>> On Fri, Feb 07, 2025 at 07:06:54AM -0700, Keith Busch wrote:
>>>> On Fri, Feb 07, 2025 at 11:51:49AM +0800, Ming Lei wrote:
>>>>> On Mon, Feb 03, 2025 at 07:45:11AM -0800, Keith Busch wrote:
>>>>>>
>>>>>> The previous version from Ming can be viewed here:
>>>>>>
>>>>>>     https://lore.kernel.org/linux-block/20241107110149.890530-1-ming.lei@redhat.com/
>>>>>>
>>>>>> Based on the feedback from that thread, the desired io_uring interfaces
>>>>>> needed to be simpler, and the kernel registered resources need to behave
>>>>>> more similiar to user registered buffers.
>>>>>>
>>>>>> This series introduces a new resource node type, KBUF, which, like the
>>>>>> BUFFER resource, needs to be installed into an io_uring buf_node table
>>>>>> in order for the user to access it in a fixed buffer command. The
>>>>>> new io_uring kernel API provides a way for a user to register a struct
>>>>>> request's bvec to a specific index, and a way to unregister it.
>>>>>>
>>>>>> When the ublk server receives notification of a new command, it must
>>>>>> first select an index and register the zero copy buffer. It may use that
>>>>>> index for any number of fixed buffer commands, then it must unregister
>>>>>> the index when it's done. This can all be done in a single io_uring_enter
>>>>>> if desired, or it can be split into multiple enters if needed.
>>>>>
>>>>> I suspect it may not be done in single io_uring_enter() because there
>>>>> is strict dependency among the three OPs(register buffer, read/write,
>>>>> unregister buffer).
>>>>
>>>> The registration is synchronous. io_uring completes the SQE entirely
>>>> before it even looks at the read command in the next SQE.
>>>
>>> Can you explain a bit "synchronous" here?
>>
>> I'd believe synchronous here means "executed during submission from
>> the submit syscall path". And I agree that we can't rely on that.
>> That's an implementation detail and io_uring doesn't promise that,
> 
> The commands are processed in order under the ctx's uring_lock. What are
> you thinking you might do to make this happen in any different order?

Bunch of stuff. IOSQE_ASYNC will reorder them. Drain can push it to
a different path with no guarantees what happens there, even when you
only used drain only for some past requests. Or it can get reordered
by racing with draining. Someone floated (not merged) idea before of
hybrid task / sqpoll execution, things like that might be needed at
some point, and that will reorder requests. Or you might want to
offload more aggressively, e.g. to already waiting tasks or the
thread pool.

-- 
Pavel Begunkov


