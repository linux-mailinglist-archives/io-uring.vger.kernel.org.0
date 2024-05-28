Return-Path: <io-uring+bounces-1974-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E4478D1E85
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 16:23:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A07F1C233D8
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 14:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B84A216E895;
	Tue, 28 May 2024 14:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qXKVMSFq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C590816F902
	for <io-uring@vger.kernel.org>; Tue, 28 May 2024 14:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716906200; cv=none; b=JAsbN+EZWn6eD7lPC8MVHGI3z4bMUDf5MRIVzb+CypIdFrC969GslIwAhk9M6R2RJYeA8+a8YJRPvqF5rLrzcZk5pT+vFEfFGcqYBHS+8nnzWXFDgeZbZyhmqFFHrEzY8ICCWigJe3p+MGsDPaXzWmlCSMnOCHUDnj9UJlxoBFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716906200; c=relaxed/simple;
	bh=fWwHnnRaRyyar1zATvn24FmK3bKDm9WnkaPdxfD6lv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gGcJRT9z7VIUWa5ZCfFFVO7J67W/8KiGtRPPGUgfPURTE9QJ4gvxOk7dKJrcn1ktZm/HE6LzbOjMtnyb+bAkx8VJZ/mB+m1uErp3xGXquySGzaX2pA3VVSwPF5R6HJGYYM/XIdxcWWZmIAAp6e46LljrMopjhJ7b4KgdlJy+mKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qXKVMSFq; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3c9b5776fbfso21999b6e.1
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 07:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716906197; x=1717510997; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/UjPVilYlVqu/YZSAFVLjapxDBvbdpQZbIOCmirq4pk=;
        b=qXKVMSFqK8ZXtIH4q05LzBjLfSx0hEE703xKC/PMUl0ox78Q85VrN7fXeimxSOJYii
         JUmPm28yWb/mBump+kimitsIGSHVO1Ni3/eLQ6adDBhQxknqnvFFrfBykFQH8gw1oRjh
         Iez7bJUD6ZMKPbVIbMvvYvMnXp2cC9U3AAkwwWYMS9pvHIVtupLBS1v2YLgdxxumjQyp
         nIRM3MX8b39EU1ub5xBZUPpl+/xSa7mmPTHw+eZMJv7iWKDEYlkvrzlSN6X6jUgOsSQA
         IPjytGqOBaHq/hK7XbYjM97WAi1jlbfBo8jMufzHYpiMvSwdJR6VaHGqDit6qMuYYWbr
         88lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716906197; x=1717510997;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/UjPVilYlVqu/YZSAFVLjapxDBvbdpQZbIOCmirq4pk=;
        b=nYAga4iDE0RIAAliQ5aYdcXgdQHm0KwYTVfz7ioe4KO/e7FXC2BZMtPNShkaXR9io/
         jNNanof+Rv/eb5MoN/ntlWwFcwcEhxsjz9fOSzWwMOP4uxxsDnj0wmCfYw9PFaTjhRCt
         1OxbXkCdO7e+ALKbWoI+HvRUunYCnib4A19J6LZEqqQ3FmQyhNMXbs8fiTtn5f0oeHll
         8kMm12//HrQBU74NYcHzSrRL1OYDwF7Dif/x7O+PWNcGJ5u4kZyR8LfzllYNOQbhz90/
         3DChF0ETTziqdaky7N436er591Zty7meZe2+k4+VdbPyN++1Kh9FYrz0jm1zS2YzE6T7
         pU4w==
X-Forwarded-Encrypted: i=1; AJvYcCVEfE9GxZnjek1A+BFTLQvDF7Ds59crqutcvewaCpjEBfG3+2YWS/tDgVXmlEIt1jMfaeCc1Yl4OmjprRKTKBIYEoX78OS8MKg=
X-Gm-Message-State: AOJu0YyAqYsid4X8fStWuchTLxSSfNsPQWqO+v2Xna3wPv6b2w9UYm6m
	NRCtgC8xPwARfgInAG+gI5N+98Tf5h1KdtrkPSeY0wkvbHnsKkNBI0ingR0W6dWV5Npvq5dQZKn
	F
X-Google-Smtp-Source: AGHT+IHcNAmsg+Yx8A5Mtpq/02vmFk+rscJtiMD1Qi494PvM8c4dNE3zkqVhaWFzZBmKkhwRT+k8TQ==
X-Received: by 2002:a05:6808:3087:b0:3c9:951d:a4a1 with SMTP id 5614622812f47-3d1a7d27b1bmr13804741b6e.3.1716906196905;
        Tue, 28 May 2024 07:23:16 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d1b36dc8ecsm1351721b6e.25.2024.05.28.07.23.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 07:23:16 -0700 (PDT)
Message-ID: <c0dedf57-26b4-4b29-acbf-6624d89bd0ac@kernel.dk>
Date: Tue, 28 May 2024 08:23:14 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d0ea0826-2929-4a52-86b1-788a521a6356@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/24 7:32 AM, Pavel Begunkov wrote:
> On 5/24/24 23:58, Jens Axboe wrote:
>> If IORING_SETUP_SINGLE_ISSUER is set, then we can't post CQEs remotely
>> to the target ring. Instead, task_work is queued for the target ring,
>> which is used to post the CQE. To make matters worse, once the target
>> CQE has been posted, task_work is then queued with the originator to
>> fill the completion.
>>
>> This obviously adds a bunch of overhead and latency. Instead of relying
>> on generic kernel task_work for this, fill an overflow entry on the
>> target ring and flag it as such that the target ring will flush it. This
>> avoids both the task_work for posting the CQE, and it means that the
>> originator CQE can be filled inline as well.
>>
>> In local testing, this reduces the latency on the sender side by 5-6x.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   io_uring/msg_ring.c | 77 +++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 74 insertions(+), 3 deletions(-)
>>
>> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
>> index feff2b0822cf..3f89ff3a40ad 100644
>> --- a/io_uring/msg_ring.c
>> +++ b/io_uring/msg_ring.c
>> @@ -123,6 +123,69 @@ static void io_msg_tw_complete(struct callback_head *head)
>>       io_req_queue_tw_complete(req, ret);
>>   }
>>   +static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
>> +{
>> +    bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
>> +    size_t cqe_size = sizeof(struct io_overflow_cqe);
>> +    struct io_overflow_cqe *ocqe;
>> +
>> +    if (is_cqe32)
>> +        cqe_size += sizeof(struct io_uring_cqe);
>> +
>> +    ocqe = kmalloc(cqe_size, GFP_ATOMIC | __GFP_ACCOUNT);
> 
> __GFP_ACCOUNT looks painful

It always is - I did add the usual alloc cache for this after posting
this series, which makes it a no-op basically:

https://git.kernel.dk/cgit/linux/commit/?h=io_uring-msg_ring&id=c39ead262b60872d6d7daf55e9fc7d76dc09b29d

Just haven't posted a v2 yet.

-- 
Jens Axboe


