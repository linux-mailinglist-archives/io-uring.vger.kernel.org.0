Return-Path: <io-uring+bounces-7887-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79AE7AAE536
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 17:45:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9FAF50054A
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 15:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A0F28B404;
	Wed,  7 May 2025 15:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UMVKMsGE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED7E21504D
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 15:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746632699; cv=none; b=fn7fmouAYO7sxeBqVr0OOqcSi3dnYZbysTx9QsVfx7fYQEdcG0WIlmHDK6dDNKrH80OBoSTBv97Vx6DJzIwr7xxIgUI8DMtjbTHZm6v37loahL4V8+UF8OciG6uwxmjdbR/kN19kv7+2o7wohdbAz2RG+BREexW20Y0UWjdkhqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746632699; c=relaxed/simple;
	bh=BJlb8lDOCjxpU2ObrCfjpWGEeFPte5WidHWmMRlHjJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gYHsHjnH6E6CTbkJVDjS+W0M1tq1gl06EPUeFKSjuZLH5cnXlGkQXYw3x2UKy9ZCl459MnB64NTvUxqJrrQtbF8CR9Am7bVBTvGHseMBOUYGQYCy100y+obej3NIUe8l9ma56wGibaY6aZhQH6LHxCQILcnQRvU/5UmaHvU6LY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UMVKMsGE; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-39c31e4c3e5so28761f8f.0
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 08:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746632696; x=1747237496; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YCcvcbjVvso/TK0koyTqEujmv5Y5JpVYbOigShpgFSQ=;
        b=UMVKMsGEhrK4/WyxddnYYrwhKT4iR8BUlqG3GfdDjX2d8oRn3OO7OR435d/4rYKYIc
         sVmXpiG4u8BYe4/w4JdxGeqCNUdw/thFYUlXvxz35ex/8dz8IRPNJmokjiSzdtBl4GT9
         dbWeoAmbu3Lxj4mHpx1NZAw1dFq7YjuOdebqRbmoBe2NA/ozxXUn6Lsmuz7vEWMPq2RF
         h6cvVdUHGb/LbQyZXqq1Bx1HdIyqPEIPCK5TrEzQ03lcX4LlmAx4h8Ul7JrI9vWaVKNg
         MwWzJ+yCr1ujx1t2Uo66zjmnuzrwTw8t+y3S4Z8rBX7OBkDSpwgBBm3VMoG7WLbgm0S2
         OpVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746632696; x=1747237496;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YCcvcbjVvso/TK0koyTqEujmv5Y5JpVYbOigShpgFSQ=;
        b=qKy6jKDd3537siJsKpYFy8n44K7ciQqjrmBVqgEarIIPs5n2HBiEmiCg7iQ3W4IIPF
         uqW80wF6PKEGbPbUepDPXBeFf0GBY26uYkMCR6cj5+NPazEBo7XDIdr11TZAKMman8Fy
         J6qGmn6f6Z4FcntbNOQdpPXEtuPLIUVQOGVuaG68RoARkbDVQiYI1i7BeIsjGuoKcr11
         XQ9q2ta6KX0XLYnbKscWkQPM1TAsPbPAdVbPeEc7AGedK7ORyGWC9onUJBMItq+tM0pw
         FPFR6yCLc9jaZgII7fJ7+UACk48lcGQfeqfnQ3oxXfcmuVvkpajwSyhARtH2HzAjE1/u
         RJIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCVFEM8C8iNurWo6T+cYh/70lvGAVlH8ueVYVLXuf73vq6Yt8dBjCCuZfObkWHZj/kf+5fL14sSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/QIYMOKAYeXazgq8MZphWOLHtmohGpVb/PNd1bsBTR7IWzYIp
	uTPDP64VO3kW0m90jQp9Hlzv9hy9r+sdnL6cGmx96OgYn71mV6RH07iHaQ==
X-Gm-Gg: ASbGncsrUbt4JGlOkLCZfwXQfFnq1VyB8tVdfI3d7lDMC0fVsfo71h4Lcz84nSyc7/K
	Te/t3tfnXGFp0iXPzHLkVvbYhpGLqVv3ECe0cf9z71cZuwKevVhYQpW48Dz3cFV9t3E7WenwdKP
	ZQ9GfnqIcj+BRNxBa/6I4UsAe/XKxP+nxN8DkH7R5tOH9nZQaUAwlUeLVqOhqhTZzgyBdI0q9os
	wcumtUnCf8Rc6+updOkbkMAU7QLtdW8br5zUWTlxJ4czNFc1yPRYJD41WMjwz6HLa+nKUfiGgBq
	bfSCaTnWYV1JdCfqlJkMG/kKijdSRkHvk6EwnnW3M0ty5pSaDA==
X-Google-Smtp-Source: AGHT+IEr3blIyhSEu60cqvN6dq9ofgFXkd8jpWrnNaXGDYjDO2Fi4A2a7yIeAzxrRXYNp5Q9eMkHxA==
X-Received: by 2002:a5d:5f49:0:b0:3a0:b930:b371 with SMTP id ffacd0b85a97d-3a0b930b4eemr479253f8f.16.1746632695580;
        Wed, 07 May 2025 08:44:55 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.145.185])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd2b3be5sm5486735e9.0.2025.05.07.08.44.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 08:44:55 -0700 (PDT)
Message-ID: <f62f094c-346c-49d0-a80e-bc5fc0dcdc34@gmail.com>
Date: Wed, 7 May 2025 16:46:09 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: ensure deferred completions are flushed for
 multishot
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <a1dffa40-0c30-40d0-87b4-0a03698fd85f@kernel.dk>
 <c6260e33-ad29-4cd1-85c1-d0658c347a31@gmail.com>
 <a4ef2e70-e858-4a3a-9f7a-22bd3af2fefe@kernel.dk>
 <f6ac1b25-3185-4d3a-8e8e-d6d2771f2b3c@gmail.com>
 <611393de-4c50-4597-9290-82059e412a4b@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <611393de-4c50-4597-9290-82059e412a4b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/25 16:26, Jens Axboe wrote:
> On 5/7/25 9:11 AM, Pavel Begunkov wrote:
>> On 5/7/25 15:58, Jens Axboe wrote:
>>> On 5/7/25 8:36 AM, Pavel Begunkov wrote:
>>>> On 5/7/25 14:56, Jens Axboe wrote:
>>>>> Multishot normally uses io_req_post_cqe() to post completions, but when
>>>>> stopping it, it may finish up with a deferred completion. This is fine,
>>>>> except if another multishot event triggers before the deferred completions
>>>>> get flushed. If this occurs, then CQEs may get reordered in the CQ ring,
>>>>> as new multishot completions get posted before the deferred ones are
>>>>> flushed. This can cause confusion on the application side, if strict
>>>>> ordering is required for the use case.
>>>>>
>>>>> When multishot posting via io_req_post_cqe(), flush any pending deferred
>>>>> completions first, if any.
>>>>>
>>>>> Cc: stable@vger.kernel.org # 6.1+
>>>>> Reported-by: Norman Maurer <norman_maurer@apple.com>
>>>>> Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>
>>>>> ---
>>>>>
>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>> index 769814d71153..541e65a1eebf 100644
>>>>> --- a/io_uring/io_uring.c
>>>>> +++ b/io_uring/io_uring.c
>>>>> @@ -848,6 +848,14 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
>>>>>         struct io_ring_ctx *ctx = req->ctx;
>>>>>         bool posted;
>>>>>     +    /*
>>>>> +     * If multishot has already posted deferred completions, ensure that
>>>>> +     * those are flushed first before posting this one. If not, CQEs
>>>>> +     * could get reordered.
>>>>> +     */
>>>>> +    if (!wq_list_empty(&ctx->submit_state.compl_reqs))
>>>>> +        __io_submit_flush_completions(ctx);
>>>>
>>>> A request is already dead if it's in compl_reqs, there should be no
>>>> way io_req_post_cqe() is called with it. Is it reordering of CQEs
>>>> belonging to the same request? And what do you mean by "deferred"
>>>> completions?
>>>
>>> It's not the same req, it's different requests using the same
>>> provided buffer ring where it can be problematic.
>>
>> Ok, and there has never been any ordering guarantees between them.
>> Is there any report describing the problem? Why it's ok if
>> io_req_post_cqe() produced CQEs of two multishot requests get
>> reordered, but it's not when one of them is finishing a request?
>> What's the problem with provided buffers?
> 
> There better be ordering between posting of the CQEs - I'm not talking
> about issue ordering in general, but if you have R1 (request 1) and R2
> each consuming from the same buffer ring, then completion posting of
> those absolutely need to be ordered. If not, you can have:
> 
> R1 peek X buffers, BID Y, BGID Z. Doesn't use io_req_post_cqe() because
> it's stopping, end up posting via io_req_task_complete ->
> io_req_complete_defer -> add to deferred list.
> 
> Other task_work in that run has R2, grabbing buffers from BGID Z,
> doesn't terminate, posts CQE2 via io_req_post_cqe().
> 
> tw run done, deferred completions flushed, R1 posts CQE1.
> 
> Then we have CQE2 ahead of CQE1 in the CQ ring.

Which is why provided buffers from the beginning were returning
buffer ids (i.e. bid, id within the group). Is it incremental
consumption or some newer feature not being able to differentiate
buffer chunks apart from ordering?

>> It's a pretty bad spot to do such kinds of things, it disables any
>> mixed mshot with non-mshot batching, and nesting flushing under
>> an opcode handler is pretty nasty, it should rather stay top
>> level as it is. From what I hear it's a provided buffer specific
>> problem and should be fixed there.
> 
> I agree it's not the prettiest, but I would prefer if we do it this way
> just in terms of stable backporting. This should be a relatively rare

Sure. Are you looking into fixing it in a different way for
upstream? Because it's not the right level of abstraction.

> occurence, so I'm not too concerned about missed batching here.

Any mixed recv / send app, especially with some send zc, if the
amount of traffic is large enough it'll definitely be hitting
it.

-- 
Pavel Begunkov


