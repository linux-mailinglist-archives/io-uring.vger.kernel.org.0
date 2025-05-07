Return-Path: <io-uring+bounces-7889-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7C03AAE676
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 18:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D670E507B7E
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 16:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DCDF28C855;
	Wed,  7 May 2025 16:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bUiQ4ynd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5883B28C019
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746634619; cv=none; b=cC+oqkXM2oBKW+ZiA3n47JGiVtWjMqwY7uUIDCNNkdkCNMCHnl3TemWxEoRUiZWer/7iTVZ6N5HzhSMeSCWK+LibDegqM+d5xrioarOfPwbl+d89mbRYQk8P0Ki3Ubd+bWBarTiuq957K/V7+WKQYuKp8EUQzLFQgg46pwbC8k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746634619; c=relaxed/simple;
	bh=BaVi4CjEwuQsjcCp1eKriThFM3hym7+VXef0yRoKBKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NEP6oX/GyU55kRlwka5K+y5MoK4oxwp9DvUUfXOQOy7BRhdGp2Nai4cOTohmGlUlecSP92ezzF2hgQbhuye8TkI09J1y70R3ejwi+xGjOMJQ4nL4eFmzLFtAAroqlOafF2v1DmzDNwYD0UVKLoCjNcQYq5LFFuMTmQHS+GnSZ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bUiQ4ynd; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cf05f0c3eso602895e9.0
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 09:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746634615; x=1747239415; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fTw3PgOXIVZV3fYffBIR/F08vvrYOStZ9RdF/slAmaE=;
        b=bUiQ4yndYU0gngKclrv+Qkv9iWGZMGie1yS1o16LedPJibi709WcDTR25fuJr7MLi6
         kcYx711Atl96MTiTZguWWlJpKVTm8ReQLfOFOq3lawz1YQEzaIPD5ejFdmu4mDYLKKsl
         1nR9TIRP6b/IbGQR9w2BRh74GrKfQWY0xJtcZfFs6EskTQnvu1WD264SxdaUh1fKOE8J
         BJa8lh2qwDjXXAiZiJlWCPqfJS8tbDYU49LSW/ymWJuNej5Rh3a6F1KT7yDYrTQ6eSpV
         dCAOVe8XKbG44KNkuJYaWJ0R2pPZe3WpTv9pc1t7xY4Z/vDFh1vWhKFlSvf8gzZCfDpf
         aofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746634615; x=1747239415;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fTw3PgOXIVZV3fYffBIR/F08vvrYOStZ9RdF/slAmaE=;
        b=qc0nMnlg7LEeZlbMcIYxaL7vYiYj92cXkd1/7dqFiVmzAPaDFdHRUQWdkSckV375Jl
         mSc99ZT88ehGqxbJ3SnYRsDov4hzPTohJgAQ76E8NeFn2PAxroAL2JBRgmyGaNX6oUg/
         6KJsKsDu1nvqjhteK8ny7gz0iLcP/pf6QcrZ0lMUEF4eSQGSm+Iz5X7vCRy7p4mMRXO2
         pthEWFYLhYq8MKlVY5m9Iyskn7RN93cwAKIKa+uXPy67POYdguCPPOerYWPCMW9hKMlZ
         lB/6HToqNYLK4pVwfnrtYvuROi0mCwGhS14anz6EUdnsFwNWzbojBMOyWbPedT4MUkw3
         yySw==
X-Forwarded-Encrypted: i=1; AJvYcCXNhTIP0xaMIQmtwN3OfGb0p7Q8yi3CRIFyr+BTmnDNsxUYyiPoCDBup4v9ckQA7/WlWBW+JRPfQg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyoSfzNfXiImOkj+t+HYBlcNUpByoEzxE2gnDJVvCYysA90hfrb
	HEFmPQutL/mk6FIUWZpjd3XY+kHd32if+01CbESOTqB5BhGsFK+ZGNkBKQ==
X-Gm-Gg: ASbGncu6AkTPOPXXXhAZJoYp4GexwqclALLRFh400Fu6kXbtNlECK5F3EwbeqvE5J1z
	2OHiC7NEuuWXofPogTY0gbexEh2dP4vJfoDTwAZ36skJg8qBpA5ZxDCZnEhVJNIEq0xrMr5o6KL
	jqxut4r94Z0E/K+cGOlsF+MCxApUbrTBRP00mIV58eXScwzbzyVu9yhQ6BWnIzKVmOP223GnbX4
	hU3MauHqmuLf8Y1noExIvJhBQIu5cRZacwHJTn62TiNXMtKokeh30scFMFHyZ4tO7HHQpY+arMi
	K25+esusBbaTk0Zfw2ulpvLhC7xzV0Qb16dIEm2lFeMdjcgGkA==
X-Google-Smtp-Source: AGHT+IEdSezJatbA9J0mdupC1opU3wWOkjqTFpX5UWz32+YD2gGfYm3la9SMXQrvt/0ElhG7ltL5Mg==
X-Received: by 2002:a5d:588e:0:b0:3a0:8492:e493 with SMTP id ffacd0b85a97d-3a0b49ae782mr3116081f8f.6.1746634615481;
        Wed, 07 May 2025 09:16:55 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.145.185])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a0b1e8e8d8sm5129770f8f.33.2025.05.07.09.16.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 09:16:54 -0700 (PDT)
Message-ID: <364679fa-8fc3-4bcb-8296-0877f39d6f2c@gmail.com>
Date: Wed, 7 May 2025 17:18:10 +0100
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
 <f62f094c-346c-49d0-a80e-bc5fc0dcdc34@gmail.com>
 <654d7a07-5b5f-4f78-bef5-dda6a919c3e1@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <654d7a07-5b5f-4f78-bef5-dda6a919c3e1@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/25 16:49, Jens Axboe wrote:
> On 5/7/25 9:46 AM, Pavel Begunkov wrote:
>> On 5/7/25 16:26, Jens Axboe wrote:
>>> On 5/7/25 9:11 AM, Pavel Begunkov wrote:
>>>> On 5/7/25 15:58, Jens Axboe wrote:
>>>>> On 5/7/25 8:36 AM, Pavel Begunkov wrote:
>>>>>> On 5/7/25 14:56, Jens Axboe wrote:
>>>>>>> Multishot normally uses io_req_post_cqe() to post completions, but when
>>>>>>> stopping it, it may finish up with a deferred completion. This is fine,
>>>>>>> except if another multishot event triggers before the deferred completions
>>>>>>> get flushed. If this occurs, then CQEs may get reordered in the CQ ring,
>>>>>>> as new multishot completions get posted before the deferred ones are
>>>>>>> flushed. This can cause confusion on the application side, if strict
>>>>>>> ordering is required for the use case.
>>>>>>>
>>>>>>> When multishot posting via io_req_post_cqe(), flush any pending deferred
>>>>>>> completions first, if any.
>>>>>>>
>>>>>>> Cc: stable@vger.kernel.org # 6.1+
>>>>>>> Reported-by: Norman Maurer <norman_maurer@apple.com>
>>>>>>> Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>
>>>>>>> ---
>>>>>>>
>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>> index 769814d71153..541e65a1eebf 100644
>>>>>>> --- a/io_uring/io_uring.c
>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>> @@ -848,6 +848,14 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
>>>>>>>          struct io_ring_ctx *ctx = req->ctx;
>>>>>>>          bool posted;
>>>>>>>      +    /*
>>>>>>> +     * If multishot has already posted deferred completions, ensure that
>>>>>>> +     * those are flushed first before posting this one. If not, CQEs
>>>>>>> +     * could get reordered.
>>>>>>> +     */
>>>>>>> +    if (!wq_list_empty(&ctx->submit_state.compl_reqs))
>>>>>>> +        __io_submit_flush_completions(ctx);
>>>>>>
>>>>>> A request is already dead if it's in compl_reqs, there should be no
>>>>>> way io_req_post_cqe() is called with it. Is it reordering of CQEs
>>>>>> belonging to the same request? And what do you mean by "deferred"
>>>>>> completions?
>>>>>
>>>>> It's not the same req, it's different requests using the same
>>>>> provided buffer ring where it can be problematic.
>>>>
>>>> Ok, and there has never been any ordering guarantees between them.
>>>> Is there any report describing the problem? Why it's ok if
>>>> io_req_post_cqe() produced CQEs of two multishot requests get
>>>> reordered, but it's not when one of them is finishing a request?
>>>> What's the problem with provided buffers?
>>>
>>> There better be ordering between posting of the CQEs - I'm not talking
>>> about issue ordering in general, but if you have R1 (request 1) and R2
>>> each consuming from the same buffer ring, then completion posting of
>>> those absolutely need to be ordered. If not, you can have:
>>>
>>> R1 peek X buffers, BID Y, BGID Z. Doesn't use io_req_post_cqe() because
>>> it's stopping, end up posting via io_req_task_complete ->
>>> io_req_complete_defer -> add to deferred list.
>>>
>>> Other task_work in that run has R2, grabbing buffers from BGID Z,
>>> doesn't terminate, posts CQE2 via io_req_post_cqe().
>>>
>>> tw run done, deferred completions flushed, R1 posts CQE1.
>>>
>>> Then we have CQE2 ahead of CQE1 in the CQ ring.
>>
>> Which is why provided buffers from the beginning were returning
>> buffer ids (i.e. bid, id within the group). Is it incremental
>> consumption or some newer feature not being able to differentiate
>> buffer chunks apart from ordering?
> 
> Both incrementally consumed and bundles are susceptible to this
> reordering.
> 
>>>> It's a pretty bad spot to do such kinds of things, it disables any
>>>> mixed mshot with non-mshot batching, and nesting flushing under
>>>> an opcode handler is pretty nasty, it should rather stay top
>>>> level as it is. From what I hear it's a provided buffer specific
>>>> problem and should be fixed there.
>>>
>>> I agree it's not the prettiest, but I would prefer if we do it this way
>>> just in terms of stable backporting. This should be a relatively rare
>>
>> Sure. Are you looking into fixing it in a different way for
>> upstream? Because it's not the right level of abstraction.
> 
> Yeah I think so - basically the common use case for stopping multishot
> doesn't really work for this, as there are two methods of posting the
> CQE. One is using io_req_post_cqe(), the other is a final deferred
> completion. The mix and match of those two is what's causing this,
> obviously.

That's the reason why all mshot stuff I've been adding is solely
using io_req_post_cqe() for IO completions, and the final CQE only
carries error / 0. Maybe it's not too late to switch read/recv to
that model.

Or use io_req_post_cqe() for the final completion and silence
the CQE coming from flush_completions() with REQ_F_SKIP_CQE?

> I'd do this patch upstream, and then unify how the various users of
> io_req_post_cqe() terminate, and ensure that only one channel is used
> for posting CQEs for that case. When we're happy with that, we can
> always flag that for stable fixing this one too, at least for 6.x where
> x == newer.
> 
> Cooking that up right now on top...

-- 
Pavel Begunkov


