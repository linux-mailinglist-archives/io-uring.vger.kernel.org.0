Return-Path: <io-uring+bounces-1990-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BB2A8D2B2A
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 04:44:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7571287241
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 02:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 972C915B0E6;
	Wed, 29 May 2024 02:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="n0soGpyY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422F415B0E0
	for <io-uring@vger.kernel.org>; Wed, 29 May 2024 02:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716950629; cv=none; b=G1eoOsI2rYbjbg3HES9FvuPC+9gMJQmgre37iZ3xe299xQgH5ObWlJkLDP305R4jExZLhSQxC8zuiq8/9rAeOV4lhJ2ppSDpZil21jm1fSlaIvY2/jIWXa3XKc/1Ssj+5BrLODIJxbnubBstvkwSZHfp2aetROPEetJ5pjg+bXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716950629; c=relaxed/simple;
	bh=6sZtUsiAK0VGjQUlad6/ZNUY4FnfklPrStcJRiqduXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CEWnrCATAwhkc5dlr5liRIzvQKNOvjC63M09h0gAPciYPrBLsbKauD2tABL2w9Sls9P8W8MTl+RLb2TxnX+fFqhNRP0MhICICsAAOeGKd0AP2dbI7bYscaAb4y/Zt9nb2kyAWi34uyCzlGaNwuxL5v7YRVg7XdLkLkk0/MSPpHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=n0soGpyY; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-68053bd4533so157886a12.0
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 19:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716950626; x=1717555426; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P4K1eeYfCTVM6iTJVMxuI7x5IkmLLkjAniNrT5Y4kw8=;
        b=n0soGpyYIy2JDlJu03VrKYxFd1UV4FtWB3A9fqs2qg8HOD/fXMXKn2zUajyRRrY8L+
         CRUMpDmM09inhfo57FvdLtrY/sm43ATimE7e02aNk0YYwyhGuPlml/xViXi16aWASqTS
         ePaIPuwg1nIuO2TP6zbHoZRIveqZtcaqpjnCYi6kH+svLxlcJWc6r7eKNUaaAEUX2bxB
         MuO2RzVlhGB9uXmZ9TfbUqjstnAnVC28XxPGv71sPs0PvgXBuiNGap0ABp0P1j+qNMqF
         NoUDG/qOVgVmYshViaL0Ab2c2h1Aa/LLCl/oCnnQidMAtvIn5nYr3X3HIYc24FY4JYyc
         t1Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716950626; x=1717555426;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P4K1eeYfCTVM6iTJVMxuI7x5IkmLLkjAniNrT5Y4kw8=;
        b=G0FBep+ypcjC0eu5uNbouSVLvYP2KsRq9zsTVuCyrjfB5Is41yl/iEGB4njxEpQ+Mt
         5TRq+v3/3QRcqxZL2hoVptH/pCI/jl0LxEEkjTfQn46IbEo3//teAUZIt0wga8Pu8Zjm
         Y8creUCyJMAomapJVkrV6+sTo4sy/eSbv5O1zgG0DdK3aMLqH0dqIBhVYAqTehvJclBB
         /IF5+iNqLw7bTwCFwCsrimMxCBrpp2A48iM985qYlWWL9vagFPYptLOO+IPt55nxNxbp
         VH9ijy7AuUGtbGV5Aot4w4zb4TARMGXLFk8Pu/aa1SlJ1rxFsG+gmh6Jhru7wza/jwmN
         CEvw==
X-Forwarded-Encrypted: i=1; AJvYcCV7XfH/5PQ6zjixBZBqE2t4z/MLoC0eNCShKrKqFHy1GQx1UqbKOD6cipDVJPgbfstPZvZ4BaUCHtCyRworB8lvPigzIEFqo1U=
X-Gm-Message-State: AOJu0YyXQFuF+YjJPBWZ4dUEK80f9FN1T1Wuzcy9h8UDl4QBinepFfsg
	in46VxRPqFjFXwbRNrJL/co6tf7pYE+xqEmEj1hrfgyhhh6t7gzpcMyKwwEQcYtSAbtfOkmbcBe
	e
X-Google-Smtp-Source: AGHT+IHZnAwPrCxsx1CsLxBy+P01Ev0sZjq7AjRaJxbxitq8PL9rwwnSTyHUs8qhmuHBEl+9qjTLfw==
X-Received: by 2002:a17:90b:a58:b0:2bd:e950:dfa5 with SMTP id 98e67ed59e1d1-2bf5ee1f6c6mr12962697a91.2.1716950626363;
        Tue, 28 May 2024 19:43:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c034e197bcsm35389a91.50.2024.05.28.19.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 19:43:45 -0700 (PDT)
Message-ID: <7c791cfe-20c9-4e1d-a45c-4b663722fbce@kernel.dk>
Date: Tue, 28 May 2024 20:43:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/msg_ring: avoid double indirection task_work
 for data messages
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <20240524230501.20178-3-axboe@kernel.dk>
 <d0ea0826-2929-4a52-86b1-788a521a6356@gmail.com>
 <c0dedf57-26b4-4b29-acbf-6624d89bd0ac@kernel.dk>
 <8566094d-0bcb-4280-b179-a5c273e8e182@gmail.com>
 <1fde3564-eb2e-4c7e-8d7d-4cd4f0a8533d@kernel.dk>
 <e8bcaf46-3324-46d3-87f9-e756d1576834@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e8bcaf46-3324-46d3-87f9-e756d1576834@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/24 8:04 PM, Pavel Begunkov wrote:
> On 5/28/24 18:59, Jens Axboe wrote:
>> On 5/28/24 10:23 AM, Pavel Begunkov wrote:
>>> On 5/28/24 15:23, Jens Axboe wrote:
>>>> On 5/28/24 7:32 AM, Pavel Begunkov wrote:
>>>>> On 5/24/24 23:58, Jens Axboe wrote:
>>>>>> If IORING_SETUP_SINGLE_ISSUER is set, then we can't post CQEs remotely
>>>>>> to the target ring. Instead, task_work is queued for the target ring,
>>>>>> which is used to post the CQE. To make matters worse, once the target
>>>>>> CQE has been posted, task_work is then queued with the originator to
>>>>>> fill the completion.
>>>>>>
>>>>>> This obviously adds a bunch of overhead and latency. Instead of relying
>>>>>> on generic kernel task_work for this, fill an overflow entry on the
>>>>>> target ring and flag it as such that the target ring will flush it. This
>>>>>> avoids both the task_work for posting the CQE, and it means that the
>>>>>> originator CQE can be filled inline as well.
>>>>>>
>>>>>> In local testing, this reduces the latency on the sender side by 5-6x.
>>>>>>
>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>> ---
>>>>>>     io_uring/msg_ring.c | 77 +++++++++++++++++++++++++++++++++++++++++++--
>>>>>>     1 file changed, 74 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
>>>>>> index feff2b0822cf..3f89ff3a40ad 100644
>>>>>> --- a/io_uring/msg_ring.c
>>>>>> +++ b/io_uring/msg_ring.c
>>>>>> @@ -123,6 +123,69 @@ static void io_msg_tw_complete(struct callback_head *head)
>>>>>>         io_req_queue_tw_complete(req, ret);
>>>>>>     }
>>>>>>     +static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
>>>>>> +{
>>>>>> +    bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
>>>>>> +    size_t cqe_size = sizeof(struct io_overflow_cqe);
>>>>>> +    struct io_overflow_cqe *ocqe;
>>>>>> +
>>>>>> +    if (is_cqe32)
>>>>>> +        cqe_size += sizeof(struct io_uring_cqe);
>>>>>> +
>>>>>> +    ocqe = kmalloc(cqe_size, GFP_ATOMIC | __GFP_ACCOUNT);
>>>>>
>>>>> __GFP_ACCOUNT looks painful
>>>>
>>>> It always is - I did add the usual alloc cache for this after posting
>>>> this series, which makes it a no-op basically:
>>>
>>> Simple ring private cache wouldn't work so well with non
>>> uniform transfer distributions. One way messaging, userspace
>>> level batching, etc., but the main question is in the other
>>> email, i.e. maybe it's better to go with the 2 tw hop model,
>>> which returns memory back where it came from.
>>
>> The cache is local to the ring, so anyone that sends messages to that
>> ring gets to use it. So I believe it should in fact work really well. If
>> messaging is bidirectional, then caching on the target will apply in
>> both directions.
> 
> *taking a look at the patch* it gets the entry from the target's
> ring, so indeed not a problem. Taking the target lock for that,
> however, is not the best, I ranted before about inter dependencies
> b/w rings. E.g. requests messaging a ring run by a task CPU bound
> in submission / tw execution would be directed to iowq and occupy
> a worker thread for the time being.

I can try and do some stats on io-wq bouncing, it can indeed be a risk.
Might even be possible to only retain the ring lock for flushing, which
is less of an issue as it happens locally, and have the overflow entries
locked separately. For now I just kept the overflow backend that we
already have, and the locking that MSG_RING already does.

-- 
Jens Axboe


