Return-Path: <io-uring+bounces-6634-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7305BA40490
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 02:09:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03BD33B4DA9
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 01:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2162D15853B;
	Sat, 22 Feb 2025 01:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jHyPxiG1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9411515689A
	for <io-uring@vger.kernel.org>; Sat, 22 Feb 2025 01:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740186566; cv=none; b=eBAZZPgX4Tvx9kMkXf6K43Jn431XZG+InmnbpG+z0eoNF7PWgrcWUDzxwAyrQPmQk/+R/ye2TGkIAnt4woakYMGHShfKOEaujIPx2xakkJq7+GfT6XmQU7yd2OYEMRRdFynQon4iQLFicNt3A/hhGQ++iNkhHU1dYQpLBlQcc/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740186566; c=relaxed/simple;
	bh=xstfEMsaUbQA2x7yJ/pwkupxbok3XEiLgeRSndaCrTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nHICw98Au9Oieu+1JS3aNKH4OMZxd9qr9sFMvtzXxgPqNrKQ51lTIZtXvNU7b5LKNtN8/qT2Y6S38/6zgInTlfQlH9CcMrHMk6asDN2KwQpHrIekl59iPovoPXmUisQFOqq5yY7T7cplGDSVZfJFwIXOJfKE4kXLyVJgkE3qsF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jHyPxiG1; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-855b77783e9so77910139f.3
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 17:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740186561; x=1740791361; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=USE7kv8L8/NOJCfbYEu6vNt5icJ5IXo1mAp2NUPbMMQ=;
        b=jHyPxiG1T/Wre/lpH/1XvIblUROr7tGmAM9ZcQsDhqKHrjcofCHwUlDF+ZNHrkWuJc
         JTHAQg/iW1fhROhVzfqjrask83U2/NkR2BC944nufXMansbafxrvLnV6NR7/loYutOwS
         s5yV/JWrRJ9Kl16LvjmNdp+UidLt3LB26CtHs8weC/KF4Qb+jYZmYceNZb5IyQCiETax
         vBqgLtBT4fiLN5gF16ySYTJKPTyapSLLmEiuJ8aG3fVw4faeeW6J6rEbuDXm2Cpnmz44
         JUoWYLhJ1pKuNJ0080xgD0JWGpoZRyKUYgxv3c3q1xR6mQr5y42BlLXRc6SI6U/bCAnJ
         UhhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740186561; x=1740791361;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=USE7kv8L8/NOJCfbYEu6vNt5icJ5IXo1mAp2NUPbMMQ=;
        b=cY8TW67g14PdmCyJF1yj9lUz9o5u0i6wqHiYC8rmSBJ33ni7CqkjkEjUVD5YdBH48c
         0KosvUL4mBwveGICIbtP4qvAJhCUzy6oyHDc6C7bpI4PBIpA4SLFTm/s7HofWPvJxS5B
         ZCYbmmIgYqSVVGx9rQBc861t2bmDk8IUzvinnm6RgFAseDPkh+RcPp85LHAb+K7E81+Q
         Nsw3UxX7LVG6VoNmYMQONs1mdzhXH22Iuyzg3wra831kjYlmnYD8WaDaXhynxjdC3VSh
         R8xuai1wKtPtQvEr87422FLqQZjrini3UIQkXbDJCMb9qhA1ytoZdpuVFvqM0wQ2g4Nr
         YYcA==
X-Forwarded-Encrypted: i=1; AJvYcCX/k2lUWeGECyvZWn0th9ep8nCBcpTg3Ib3f1csAmcE7EDdXWBcdbuRry+jcMPoT9SzVWaIQ8Ee9A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKc04ueAhsTLAPjRNp2QUeL1KYJ/5w6w5iHA/p1WA1w/fzPzoy
	6xNEdBYrl7AL95LnLKOBkGgcGZNFNN5pOIbfcFU/pJKvaeQN5WkXr1yIAmhcmz8=
X-Gm-Gg: ASbGncuFwCldbDP8EnmM+cxdDRnQAP+Ma4Sn4LWvKfZ24Hi75yBeAT+gLxvF5R9h1Eu
	TrXtNuvO4gup7iWcovLdn3I37HRTSQ3zi8Bc/tF2h0SbxduHGGsxqHaAcuT3YXUwGssxi3OPBll
	wjFD929EVV7JEKFXoAR1aXPqN6ehFaGaOv6AqSAUKezEe4Xog4zEnGwlFP4nKpUleZAhHjoxgPF
	5wL0fU5xpeuZTPowDvpFIXOHspk3WUuehil7jj47vK1PbQbpMpMPCLCIBCDmQm9C/3HwdlPNwvR
	kIngLahwxBPdjvxpGRJ0Sjs=
X-Google-Smtp-Source: AGHT+IF4cKd4p9iV3zgLfOtRYj6ntGkWYfiYg9lioaHZ2+DSYhr/gOPvtQt31Rv9yLVb8CAZTJi2Hw==
X-Received: by 2002:a05:6602:6426:b0:855:c476:8b8a with SMTP id ca18e2360f4ac-855daac1293mr629440839f.0.1740186561517;
        Fri, 21 Feb 2025 17:09:21 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ee9c1a303bsm2622247173.26.2025.02.21.17.09.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 17:09:20 -0800 (PST)
Message-ID: <13ebc224-a280-4d60-89ca-d777dc7553b2@kernel.dk>
Date: Fri, 21 Feb 2025 18:09:20 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
 <6165d6a4-a8d3-4c2f-8550-e157a279c8f3@gmail.com>
 <a44a6ed1-8a4c-4334-9785-aee8b545c68d@kernel.dk>
 <516fdf90-1f0a-4c2e-b7ed-23a72b7a4342@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <516fdf90-1f0a-4c2e-b7ed-23a72b7a4342@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/21/25 6:06 PM, Pavel Begunkov wrote:
> On 2/22/25 00:52, Jens Axboe wrote:
>>>> @@ -1250,6 +1251,12 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>        zc->ifq = req->ctx->ifq;
>>>>        if (!zc->ifq)
>>>>            return -EINVAL;
>>>> +    zc->len = READ_ONCE(sqe->len);
>>>> +    if (zc->len == UINT_MAX)
>>>> +        return -EINVAL;
>>>
>>> The uapi gives u32, if we're using a special value it should
>>> match the type. ~(u32)0
>>
>> Any syscall in Linux is capped at 2G anyway, so I think all of this
> 
> I don't see how it related, you don't have to have a weird
> 00111111b as a special value.
> 
>> special meaning of ->len just needs to go away. Just ask for whatever
>> bytes you want, but yes more than 2G will not be supported anyway.
> 
> That's not the case here, the request does support more than 2G,
> it's just spread across multiple CQEs, and the limit accounts
> for multiple CQEs.

All pretty moot if we just go with 0 as the "transfer whatever length
you want", as obviously each individual transfer will be limited anyway.
Which is the better choice than having some odd 4G value.

-- 
Jens Axboe

