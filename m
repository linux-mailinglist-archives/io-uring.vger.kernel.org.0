Return-Path: <io-uring+bounces-7886-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E31A3AAE4C9
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 17:29:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D2695238EC
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 15:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C5E628A40A;
	Wed,  7 May 2025 15:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wWjl6/NA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D9A28A710
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746631623; cv=none; b=BTUv7fc23wRTQpHj/OYv8KjvIXoHbEesPqbsCoIJMCj4axBCdHRTgIrg1BPBEpPheLDoDUF6Kdv8599WEhUwnzUVV9HtTx/0q8ckUkl2aqFUqyLFzPaWOax3HvTsOLQoe/t34WAVbN8zb+a6/yCMzS+fRrhKr/PrKc/pAW59T8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746631623; c=relaxed/simple;
	bh=i0MYtKyos90BkK0bFeIgGi7LQbMKdDBP2hn09A+AoXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Lm/3xKAe6ugdYIL+KNwpxD3STwz1NDAJDyQ1WpBCU21PJLnBBidmJHmlJ5tMak3cmB4YQgT2ZLGsPPWMuqnXn+z99GTbNwULlZKnJKBui/dwpaqU4EVKIYlOodBYdekS5CHFEAawCgc4CvWyktWsSWXW6Wb2XkTxEnyCZk+VVpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wWjl6/NA; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-85b3f92c8f8so753705239f.1
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 08:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746631620; x=1747236420; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d4cRKQpuKcxswKFHo8hG6UvBIm2s6TKOV9QB4ug2IJw=;
        b=wWjl6/NApZmTLnwFAu8xw17Eyfgr/wWvwhLhFhJn9DPgpSxlWMF5RbPKrdOgpV7tnX
         PPkekp8wNmarcSEaoWOfUMEUUuTwS17OY24WpRTWLl8GSy8e0Wd3J9MRj51zJlVsx/Zb
         me8rEFBCckKHh3+OduEea82Y+4udPoeJBGhdKLm5Wg8V48CDpD82FrEs4IQpSXQgCvDA
         2qes3xYhWIjbd9Az/3ZPdOD5EcR9WwjSKGU0whPIiDxpCAPVx88KweL5LSI2XoCrxur/
         xCEV2ikJkjaJOaHpxR5GPW9JHnY27eLAQJAa3LxCZ3CaEbYBs2pmAvdbP1KjWIh0OZgt
         z+Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746631620; x=1747236420;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d4cRKQpuKcxswKFHo8hG6UvBIm2s6TKOV9QB4ug2IJw=;
        b=QN25BsxNPDfCLKGEv1yKraZyTPknEtFEt8WQToFfzP1N7LjJPeVsj1mVRgSKgbd/Mc
         jW5DNYKcke/h5wyLBUHTrxlo+D9WFBn/9fUfPx1ZCEw266pE3tYNeLrTG8IQy8BEjVk9
         Uo7skqzidSOgU1UfEp7QzH0onOVzmQPcoG5YznZ+3MqH3SqZjPGf3PiqX0yGaUPCYra7
         NWaOl6aNJ39MLjAqF5qro6kmFG4rd6oi6mP0HRhU5XWFVzQ67RQk+XEzaJBUs6eGlzx6
         qwf4R/foNc7RQ01DH9yt8BkEs785jylVW3LRLcX4pFtHbgQQAexFDv2GHNWqTbbRoMRs
         kxpg==
X-Forwarded-Encrypted: i=1; AJvYcCWHVJbsdq/zcTFdhwUUpNbXhZC5E/md0sy91/gKxWFts9Ij3rknYC0HiT5nYs8loFJnrXZOSVAtrw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzZzL+7aCAR++O9fCUAklcIn2btaLsruI1cW9NG+2hrJ+ZSAtM1
	Kc2kc3Li8lLhUvky6wbgGDmbUjljJa2B0Iss5oJ4pDQO10lSQF2LKT7zwNVR3+RSIPwgAgn8zOm
	+
X-Gm-Gg: ASbGncs56hibFfGCfOkOM2H9zfVxb5pSesgPQg9YWeBaRdp5v6T9bcKj6iMc09DZDV6
	N/P1H1qiTEAI8crexUlNxH13s0p7VX/QEq3IRzxlKrPMWx7rF1MfCUnFPCL3AZ6xBKDcvcgX2m/
	G/8w0jyA7TIh/6OuzgwyIdiqzb5c8u+uQ0EMxGDlqkNyF7zkI5105Q6iSnt3fxN2rRRwrVHP1HP
	sE9eNm5xBYFUhbcaEv2y9Qyxq6bRHM+1mDmyjpOJWWbNExbg36C4cmkB9Wdq6o0T77o6Cb4FWBK
	s8YRrL8k3wQfy+Cxz0fAGsSSXK3RoLkE5wus
X-Google-Smtp-Source: AGHT+IF84ljkX3I41Bmx/UJnJePPmRsyMhZkLujwFKKAdoeov0YVSCEzQsvj/oL8tl1d+g6IYEXyng==
X-Received: by 2002:a05:6602:3f85:b0:867:3e9e:89db with SMTP id ca18e2360f4ac-867473170e3mr493950339f.8.1746631619661;
        Wed, 07 May 2025 08:26:59 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-864aa2f45adsm269582039f.18.2025.05.07.08.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 08:26:59 -0700 (PDT)
Message-ID: <611393de-4c50-4597-9290-82059e412a4b@kernel.dk>
Date: Wed, 7 May 2025 09:26:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: ensure deferred completions are flushed for
 multishot
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <a1dffa40-0c30-40d0-87b4-0a03698fd85f@kernel.dk>
 <c6260e33-ad29-4cd1-85c1-d0658c347a31@gmail.com>
 <a4ef2e70-e858-4a3a-9f7a-22bd3af2fefe@kernel.dk>
 <f6ac1b25-3185-4d3a-8e8e-d6d2771f2b3c@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <f6ac1b25-3185-4d3a-8e8e-d6d2771f2b3c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/7/25 9:11 AM, Pavel Begunkov wrote:
> On 5/7/25 15:58, Jens Axboe wrote:
>> On 5/7/25 8:36 AM, Pavel Begunkov wrote:
>>> On 5/7/25 14:56, Jens Axboe wrote:
>>>> Multishot normally uses io_req_post_cqe() to post completions, but when
>>>> stopping it, it may finish up with a deferred completion. This is fine,
>>>> except if another multishot event triggers before the deferred completions
>>>> get flushed. If this occurs, then CQEs may get reordered in the CQ ring,
>>>> as new multishot completions get posted before the deferred ones are
>>>> flushed. This can cause confusion on the application side, if strict
>>>> ordering is required for the use case.
>>>>
>>>> When multishot posting via io_req_post_cqe(), flush any pending deferred
>>>> completions first, if any.
>>>>
>>>> Cc: stable@vger.kernel.org # 6.1+
>>>> Reported-by: Norman Maurer <norman_maurer@apple.com>
>>>> Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>
>>>> ---
>>>>
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index 769814d71153..541e65a1eebf 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>>>> @@ -848,6 +848,14 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
>>>>        struct io_ring_ctx *ctx = req->ctx;
>>>>        bool posted;
>>>>    +    /*
>>>> +     * If multishot has already posted deferred completions, ensure that
>>>> +     * those are flushed first before posting this one. If not, CQEs
>>>> +     * could get reordered.
>>>> +     */
>>>> +    if (!wq_list_empty(&ctx->submit_state.compl_reqs))
>>>> +        __io_submit_flush_completions(ctx);
>>>
>>> A request is already dead if it's in compl_reqs, there should be no
>>> way io_req_post_cqe() is called with it. Is it reordering of CQEs
>>> belonging to the same request? And what do you mean by "deferred"
>>> completions?
>>
>> It's not the same req, it's different requests using the same
>> provided buffer ring where it can be problematic.
> 
> Ok, and there has never been any ordering guarantees between them.
> Is there any report describing the problem? Why it's ok if
> io_req_post_cqe() produced CQEs of two multishot requests get
> reordered, but it's not when one of them is finishing a request?
> What's the problem with provided buffers?

There better be ordering between posting of the CQEs - I'm not talking
about issue ordering in general, but if you have R1 (request 1) and R2
each consuming from the same buffer ring, then completion posting of
those absolutely need to be ordered. If not, you can have:

R1 peek X buffers, BID Y, BGID Z. Doesn't use io_req_post_cqe() because
it's stopping, end up posting via io_req_task_complete ->
io_req_complete_defer -> add to deferred list.

Other task_work in that run has R2, grabbing buffers from BGID Z,
doesn't terminate, posts CQE2 via io_req_post_cqe().

tw run done, deferred completions flushed, R1 posts CQE1.

Then we have CQE2 ahead of CQE1 in the CQ ring.

> It's a pretty bad spot to do such kinds of things, it disables any
> mixed mshot with non-mshot batching, and nesting flushing under
> an opcode handler is pretty nasty, it should rather stay top
> level as it is. From what I hear it's a provided buffer specific
> problem and should be fixed there.

I agree it's not the prettiest, but I would prefer if we do it this way
just in terms of stable backporting. This should be a relatively rare
occurence, so I'm not too concerned about missed batching here.

-- 
Jens Axboe

