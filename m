Return-Path: <io-uring+bounces-1987-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB2B8D2A93
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 04:07:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D402928B2B7
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 02:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D7822324;
	Wed, 29 May 2024 02:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RCztsV6E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD43915B0FF
	for <io-uring@vger.kernel.org>; Wed, 29 May 2024 02:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716948291; cv=none; b=i+tkKXRE00F9p5rVEWnh2oDZeQbyfXJbtCAYaBIBTEv5IlUTbJvIKkyR+R96tZD+nG93TFP8EbiebBy7sBxJj4N5kHANELOa1MtxQQyRRrm2RbHdBo81lkIPu/Ztl4toS7cHoyEgTeETYlIugmHAGDB23ZUPIsQBxWpZfqyI8Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716948291; c=relaxed/simple;
	bh=MrVOy5rkET+3i89nPh5enEPvjaYpFOwQbU1fe2Lz8I0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nyAaSgossE+jqW6nRpwzJwQz+2GwTpk0If5iyrtVEn+dTSf/k+QKtZoBoAXthOHl6ZjlQ1ejDRuohh48LSrKDGpwdZcXkCszHkIjk7LVX1DWHq5vOwDwCwL5Sbt/yBvh6e/1pKd3DwyNvMPCiEWRFj7AI3nbN0B992ilSkEn5Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RCztsV6E; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-421124a0b37so8055615e9.1
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 19:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716948288; x=1717553088; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XWafbXSV7kvOjg+O2KbBGlbla/BsATzJlrZA8EplZks=;
        b=RCztsV6EKZgSqyc49iDllYNgmgWU+SiZBVebOziHYCug0LDWfe9c/b1tOhYI8D56vG
         piBvRri1gzedO8/caIumfMy6JKNd8jw+L5aml7J//KD0Y5BVc5of4T6eL5TvEylqkzWF
         UKY6HCuv6dNCcqwM3hyZ8f/4oSUReH3hM9FNAnnfyWPTvNmoJRxjH/OKIVECUInkrt02
         OI3iQspMZefto8rw0KYQNTJJ2+YYdiaRiBpf2QF5pfAhyqvmA5vfiPouNijD+s4uHPuh
         GNfdwHTDLom4000jEnGc70oohwIQEqCRLQdaUKyFshylhmrC65WqVeQMfEm+Eg/YqiI+
         O2dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716948288; x=1717553088;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XWafbXSV7kvOjg+O2KbBGlbla/BsATzJlrZA8EplZks=;
        b=s26ibXMY6+BHlZU5d0jtwgcapWrXd2daVuH5+mc3OxgT1gRl2LY9BfNT/yYv351oxP
         DkyFeh2saw1/rS6BTpiMBFOsrb6rF6/dbwLMByREpmQlnAU0HW8OLuHfjZJnRtw4RH9F
         clj6ZqtOlYKmUMg5fFf8vqzM1zGb/4toDrMoaXtq+EJYEV7LPqjrG1jebLB2jY0bTyFU
         9IJbqIhV33VwJ3PnjkcUoNYs7BT7SvBXvMV5SuK24D+GF0g7H+Rv/RQFh7lWFszk2srE
         DqZK2ytJJKwvswj2xY43pNUty+EAZO13u93I7VV4qHRe2nyJ7G8Gs/uFkKKLWWU0Ij7p
         omBQ==
X-Forwarded-Encrypted: i=1; AJvYcCW60BkdMWqyr9+hxGL8FBCDkaTB8LLqVWv5vgP8RbI9VPpbd5b+Hhv/kCQ9GlgxMEEBz0MgRDqklXCu2hDqRkzrtX5Zex3N/+o=
X-Gm-Message-State: AOJu0YyrWGkGmKgZ4iceC8uIPzbctii24ctM+rm++c6py2Uo15vaD1a8
	cVUKKP1G706kPZh5BZLQsNIxbZ4IbqqDFeOWelFvxplMtxK++Ej0xoBPeQ==
X-Google-Smtp-Source: AGHT+IEHpz9oOfYhcXRiBkbymHhN9paZ0irA+jx7xV75A4l56QZVJ81Lqn7iqIJSO/DiokKIKgEBPA==
X-Received: by 2002:a05:600c:3c93:b0:421:794:9630 with SMTP id 5b1f17b1804b1-421089da76cmr123529235e9.9.1716948287902;
        Tue, 28 May 2024 19:04:47 -0700 (PDT)
Received: from [192.168.42.154] ([185.69.144.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42100eeca80sm195549145e9.2.2024.05.28.19.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 19:04:47 -0700 (PDT)
Message-ID: <e8bcaf46-3324-46d3-87f9-e756d1576834@gmail.com>
Date: Wed, 29 May 2024 03:04:49 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/msg_ring: avoid double indirection task_work
 for data messages
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <20240524230501.20178-3-axboe@kernel.dk>
 <d0ea0826-2929-4a52-86b1-788a521a6356@gmail.com>
 <c0dedf57-26b4-4b29-acbf-6624d89bd0ac@kernel.dk>
 <8566094d-0bcb-4280-b179-a5c273e8e182@gmail.com>
 <1fde3564-eb2e-4c7e-8d7d-4cd4f0a8533d@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1fde3564-eb2e-4c7e-8d7d-4cd4f0a8533d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/24 18:59, Jens Axboe wrote:
> On 5/28/24 10:23 AM, Pavel Begunkov wrote:
>> On 5/28/24 15:23, Jens Axboe wrote:
>>> On 5/28/24 7:32 AM, Pavel Begunkov wrote:
>>>> On 5/24/24 23:58, Jens Axboe wrote:
>>>>> If IORING_SETUP_SINGLE_ISSUER is set, then we can't post CQEs remotely
>>>>> to the target ring. Instead, task_work is queued for the target ring,
>>>>> which is used to post the CQE. To make matters worse, once the target
>>>>> CQE has been posted, task_work is then queued with the originator to
>>>>> fill the completion.
>>>>>
>>>>> This obviously adds a bunch of overhead and latency. Instead of relying
>>>>> on generic kernel task_work for this, fill an overflow entry on the
>>>>> target ring and flag it as such that the target ring will flush it. This
>>>>> avoids both the task_work for posting the CQE, and it means that the
>>>>> originator CQE can be filled inline as well.
>>>>>
>>>>> In local testing, this reduces the latency on the sender side by 5-6x.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>> ---
>>>>>     io_uring/msg_ring.c | 77 +++++++++++++++++++++++++++++++++++++++++++--
>>>>>     1 file changed, 74 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
>>>>> index feff2b0822cf..3f89ff3a40ad 100644
>>>>> --- a/io_uring/msg_ring.c
>>>>> +++ b/io_uring/msg_ring.c
>>>>> @@ -123,6 +123,69 @@ static void io_msg_tw_complete(struct callback_head *head)
>>>>>         io_req_queue_tw_complete(req, ret);
>>>>>     }
>>>>>     +static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
>>>>> +{
>>>>> +    bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
>>>>> +    size_t cqe_size = sizeof(struct io_overflow_cqe);
>>>>> +    struct io_overflow_cqe *ocqe;
>>>>> +
>>>>> +    if (is_cqe32)
>>>>> +        cqe_size += sizeof(struct io_uring_cqe);
>>>>> +
>>>>> +    ocqe = kmalloc(cqe_size, GFP_ATOMIC | __GFP_ACCOUNT);
>>>>
>>>> __GFP_ACCOUNT looks painful
>>>
>>> It always is - I did add the usual alloc cache for this after posting
>>> this series, which makes it a no-op basically:
>>
>> Simple ring private cache wouldn't work so well with non
>> uniform transfer distributions. One way messaging, userspace
>> level batching, etc., but the main question is in the other
>> email, i.e. maybe it's better to go with the 2 tw hop model,
>> which returns memory back where it came from.
> 
> The cache is local to the ring, so anyone that sends messages to that
> ring gets to use it. So I believe it should in fact work really well. If
> messaging is bidirectional, then caching on the target will apply in
> both directions.

*taking a look at the patch* it gets the entry from the target's
ring, so indeed not a problem. Taking the target lock for that,
however, is not the best, I ranted before about inter dependencies
b/w rings. E.g. requests messaging a ring run by a task CPU bound
in submission / tw execution would be directed to iowq and occupy
a worker thread for the time being.

-- 
Pavel Begunkov

