Return-Path: <io-uring+bounces-6970-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F6ACA505E9
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 18:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A307E188A803
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 17:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F359A151992;
	Wed,  5 Mar 2025 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K5IaHcgO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0222419C542
	for <io-uring@vger.kernel.org>; Wed,  5 Mar 2025 17:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741194223; cv=none; b=i7pIu7wUtlAXyq64wlu3YX9yrczRXQqSRmNR86pMTLZlAYfnwX8GlOyIDZVv2E49qktJ24agVn6FqOYFOohicLYFSL09CuIHimXW8P0ZU9bIuznfFt15fVoijKsV7nPDj/BnBLYgWjTkjXXUYf9+C0yQ6cKjBteqVU+6r0+BrAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741194223; c=relaxed/simple;
	bh=JNa80S5ubLg4TDjQSpy0UyE71ytxV5jGCgzwAqIqK+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cj4ehuVvHgoPXz55gfjJAwTgRFC1ryCRwCNvkaAVS0KenO9in4yUBcWSTEuBwFrZ7eTdXIyTyzAcXm3QYJoKU3X2KLdZVHdJp/hFPSC6XZV0wAoxj6RxI41XYtkIHAL8UOmU6qxI1knYDUUXs4Hy3RMOeiKySyhuB0TnpHIplnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=K5IaHcgO; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-85ad9bf7b03so276654039f.3
        for <io-uring@vger.kernel.org>; Wed, 05 Mar 2025 09:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741194220; x=1741799020; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ye8jYdlNGDHRbJBuQVYikUVt9cJikB2/kGvMNNsxwb0=;
        b=K5IaHcgOHc8On8kfp6yjGrZA9svYKaun8JwL9mMrK8BDjFcQU1uktcnnCRlc9NQMv+
         Qilk86CX/toNRa1qPFUZrP/j+8BzgFxOH/owMJKIICpER2QXZt8NlE8e5SCn42me+2GE
         UC9kFDVFn/TUnRelwNdDXmntMZjFkslHkNkLnqmkjTxc4Y6BhOzybAMJDQkYoybLIKbn
         7ebaCTGmKbeL/ccmsl4O5cfjwBJfKmhsNyao3hRlRX7XSw7SuVRLcv/kmti0xxcgyWL5
         dIdvmhe/Eb8d5rP1vTVoBUEQx+TreOFMddnnezDtQkRabreIeyiWflxNzpAbuBBwPSJ8
         H0sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741194220; x=1741799020;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ye8jYdlNGDHRbJBuQVYikUVt9cJikB2/kGvMNNsxwb0=;
        b=h/oys2aspWNudH703D962DOZVLIU853uVqAGmST0qXY6JeEVpPWlTQAv3rmn0xDtjZ
         Y8Z0Ius44cKHzdy+XaBQTA/M2DgtvthH0LvSWK00lzQAxgRnq8y7eVEtb0hZGVMoPv0C
         UYOWmXRknY+gCaas7zezaa2F8VEz2rbDr14PVVVofxcl6GR7W4tw+NLnyT8UQaA1jDW4
         zUVXAYTMdjeqkhRMu49s14lkeMJnRevd7vT9eX8HuWOrSRkPQ3YSo7CotCI44Sp8RJWp
         w6fmxW0iEIQ0oJCy13VJAjF6Bb262DYzhhkH0YT4ojHTq8xawB/p/2cauoPk8r/VCuHE
         LixA==
X-Forwarded-Encrypted: i=1; AJvYcCXI8HKFtueEeDKO6dBAKiyo/6M2xcESnMQOBHXA5mFH0jEZqFZ5nwnI81eJZtwtl8i0LF3DvbzLOg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzH4xm4DDUgENraIlAIJRRbaGuzFiWBJRe59SmjVYN4CfbmdvMs
	eo1Vn7u6cJvYrZ26bqw8haDPMlGjNMzBqRCHnjfPokkT6RW9MFGbYMaD6h2OMVw=
X-Gm-Gg: ASbGncv+pINKT42CZYosR7KgWLCnyM0ZozgdQoM2+j0EmZo3ddC3PNQdWthzryIwikW
	uJf6jr4IRb+QQIMhXdk7Gh0rVrYQl0JNzcGzmXaJ2wGptIyk7nnqyDnrZJFhFqxXDKH6+Zme1pH
	GwAW2bE51Y1b0DMn8PfpgA1LvSNneHrgggflhDOWPxvvITvABk8g7yGos2uaYNa/H4Ch3wRPtP7
	Gf9Lujp7ONgeI+zhfzZs0wkFc5Ka0Tnh/Ys0jNcyx6Fb1i+I+bBvW/iL4ooIy+7twY2Z2yBuuRL
	En3UL/6CKVaIydpWuo5cIHtv/HTBG2RMuQq9fsfm
X-Google-Smtp-Source: AGHT+IE0j+KmAvI0GONGGBRb0yBcq84nelhQkWdG5WvM7FpdyUDmfmueemR8L5YM73nIkMZVBa983w==
X-Received: by 2002:a05:6602:368c:b0:855:c259:70e8 with SMTP id ca18e2360f4ac-85aff729c93mr545166439f.0.1741194219973;
        Wed, 05 Mar 2025 09:03:39 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85aed8bc2e3sm115220339f.10.2025.03.05.09.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Mar 2025 09:03:39 -0800 (PST)
Message-ID: <c5e6b923-69b1-47d8-b313-ba339eac9501@kernel.dk>
Date: Wed, 5 Mar 2025 10:03:38 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/rw: handle -EAGAIN retry at IO completion
 time
To: John Garry <john.g.garry@oracle.com>, io-uring@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20250109181940.552635-1-axboe@kernel.dk>
 <20250109181940.552635-3-axboe@kernel.dk>
 <2b43ccfa-644d-4a09-8f8f-39ad71810f41@oracle.com>
 <c64a86d1-36cd-46b1-82fa-4ac4a4cf9cd2@oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c64a86d1-36cd-46b1-82fa-4ac4a4cf9cd2@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/5/25 9:57 AM, John Garry wrote:
> On 04/03/2025 18:10, John Garry wrote:
> 
> +
> 
>> On 09/01/2025 18:15, Jens Axboe wrote:
>>> Rather than try and have io_read/io_write turn REQ_F_REISSUE into
>>> -EAGAIN, catch the REQ_F_REISSUE when the request is otherwise
>>> considered as done. This is saner as we know this isn't happening
>>> during an actual submission, and it removes the need to randomly
>>> check REQ_F_REISSUE after read/write submission.
>>>
>>> If REQ_F_REISSUE is set, __io_submit_flush_completions() will skip over
>>> this request in terms of posting a CQE, and the regular request
>>> cleaning will ensure that it gets reissued via io-wq.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
> 
> Further info, I can easily recreate this on latest block/io_uring-6.14 on real NVMe HW:

Thanks, I'll take a look!

-- 
Jens Axboe


