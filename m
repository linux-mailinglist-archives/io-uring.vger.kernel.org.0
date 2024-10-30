Return-Path: <io-uring+bounces-4207-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 051A39B6578
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 15:17:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D1871F23AA4
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 14:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B87B1E1312;
	Wed, 30 Oct 2024 14:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mGwn4Uzz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B193D1E47DE
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730297841; cv=none; b=kdanl28s0fKmOXFgBoT45paTeDpHgEHLleHK/0sXV/cBiNZrjI5W4wxYkYoEYGgOdj1w4OgrNfWKR5lFEvEJscMiGFtnw5cCnyz6b5H/T9GgRKy0pa5FExL8iAHOicirDwXPtAgZ7k+lHl4s4V9mTaEIBHIhltlb+Ltsqouur0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730297841; c=relaxed/simple;
	bh=8yVKDNFqDlEE8qhlQKIqw2kasIYFgFQiNkJc/0jvi+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZP1yyrNul6djWgNnD4Qc69AQkcI2LTdx43MfmU8oviA+yAMArPRJgH02n1D0mlzREQed9nxW1xWU7ua3vwY9BjebWLAzhcwDNzEodoQzsFL5mgTejvoVzK1xDqqOYhVAIWbyrF5BE6uZrVEUt7Bx39Zc3yGhsVO+0c6HUqvGxnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mGwn4Uzz; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-83ac4dacaf9so244823039f.2
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 07:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730297837; x=1730902637; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ukybthk+BP4Nd5glGQC4ifNZ3Q/hqizXfIAZXvjBbhE=;
        b=mGwn4UzzQi3tciUXXmIMBM275PssON0lvCLKgdwnmpCm6rHuzCFzs4egVHqGrN+Owh
         fiMH6htxATqe2aAKidmOCgOPhmAmjv5UdI4EVdrR9VtH0vLnooSh/3rKvMHzpKNnbnmM
         lxas9OwMsfQ7ZfwAHWlje1dEAABoRvawzP4jJPB4kzKsooXAGuv/uNbxguWNYnk9HuWw
         5cgaGr0N0XRvZnOtyUXL5nBQuQUYK8v7Mmz1SSnknrB3TB3oRnvyiZS82M8Qj1JM2Qwj
         5mwKaC5Hd+hv1zTgrC8FNx0dO1qMdmocfxy0Ql3bNjFRtl5KzqkIHwuadSbaU4bNLjD1
         4kOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730297837; x=1730902637;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ukybthk+BP4Nd5glGQC4ifNZ3Q/hqizXfIAZXvjBbhE=;
        b=Al+V575tzV1kO0/FAUhZeMhZpW68YYNpzPklAOIeD/1+Bnw+kzgvM4gu6dntJ0pKTp
         RU2kCGwLVoWT7cGs5T9pf4+eDI0qxT0PjQ8jqwjM9j+schOc0tP1tDrahSE5QZyKKbWb
         x+mMBJJhiN6JVkdO8FTeCGmevku6lcPvys8vnuaNE/okW01e598KSZ2xRhfN5kZ9XgyN
         L2b1VbuydIn4aSP88CNP7UVYq6n2xl0b2nf7gVIaknRLZamGpwpXv0rUHnmzEAAMGdmU
         9uz1nBQz9i4zmFHfnYxt59FpCFV0o+u7Bxjly0KAWYK5JqB/f3gmk0pF7j0gx/rk6YBp
         x3ug==
X-Gm-Message-State: AOJu0YwfHWDbceALF6mXzrsSjgzt5guHbVm+UUnUzGkutf+0LrnKi0Lw
	X/plCgJKxHzYR6agQadjg5VwIyqVntqELQPhkJgX80UZPDj7SGM9w1Dqd/RyD6Bp8pG7Omstl09
	HvU4=
X-Google-Smtp-Source: AGHT+IFmcJ5W1Pi0NmXdOXzStdSbWXjNuTZKH8nK5iD+QYVexyPl5y98QW1rjnwyyMwImPkhfAozmw==
X-Received: by 2002:a05:6602:2d95:b0:83a:b52b:5cb5 with SMTP id ca18e2360f4ac-83b1c3efbf8mr1763165039f.5.1730297836748;
        Wed, 30 Oct 2024 07:17:16 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc72784e3csm2926243173.147.2024.10.30.07.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 07:17:16 -0700 (PDT)
Message-ID: <c3b398b3-4912-45d5-a6a1-d3fee42ce162@kernel.dk>
Date: Wed, 30 Oct 2024 08:17:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring: add support for fixed wait regions
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: io-uring@vger.kernel.org
References: <3191af58-8707-4916-a657-ee376b36810a@stanley.mountain>
 <eebde978-cf9b-4586-9dcf-0ff62e535a2d@kernel.dk>
 <53d780a8-1761-408f-b334-bd7fa82aa71d@stanley.mountain>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <53d780a8-1761-408f-b334-bd7fa82aa71d@stanley.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/30/24 7:58 AM, Dan Carpenter wrote:
> On Wed, Oct 30, 2024 at 07:22:49AM -0600, Jens Axboe wrote:
>> On 10/30/24 5:40 AM, Dan Carpenter wrote:
>>> Hello Jens Axboe,
>>>
>>> Commit 4b926ab18279 ("io_uring: add support for fixed wait regions")
>>> from Oct 22, 2024 (linux-next), leads to the following Smatch static
>>> checker warning:
>>>
>>> 	io_uring/register.c:616 io_register_cqwait_reg()
>>> 	warn: was expecting a 64 bit value instead of '~(~(((1) << 12) - 1))'
>>>
>>> io_uring/register.c
>>>     594 static int io_register_cqwait_reg(struct io_ring_ctx *ctx, void __user *uarg)
>>>     595 {
>>>     596         struct io_uring_cqwait_reg_arg arg;
>>>     597         struct io_uring_reg_wait *reg;
>>>     598         struct page **pages;
>>>     599         unsigned long len;
>>>     600         int nr_pages, poff;
>>>     601         int ret;
>>>     602 
>>>     603         if (ctx->cq_wait_page || ctx->cq_wait_arg)
>>>     604                 return -EBUSY;
>>>     605         if (copy_from_user(&arg, uarg, sizeof(arg)))
>>>     606                 return -EFAULT;
>>>     607         if (!arg.nr_entries || arg.flags)
>>>     608                 return -EINVAL;
>>>     609         if (arg.struct_size != sizeof(*reg))
>>>     610                 return -EINVAL;
>>>     611         if (check_mul_overflow(arg.struct_size, arg.nr_entries, &len))
>>>     612                 return -EOVERFLOW;
>>>     613         if (len > PAGE_SIZE)
>>>     614                 return -EINVAL;
>>>     615         /* offset + len must fit within a page, and must be reg_wait aligned */
>>> --> 616         poff = arg.user_addr & ~PAGE_MASK;
>>>
>>> This is a harmless thing, but on 32 bit systems you can put whatever you want in
>>> the high 32 bits of arg.user_addr and it won't affect anything.
>>
>> That is certainly true, it'll get masked away. I suspect this kind of
>> thing is everywhere, though? What do you suggest?
> 
> The way that I normally see these warnings is with code like "if
> (u64flags & ~mask)" where only the first 3 bits of u64flags are used.
> It's not normally a real life bug.  Normally fix them the warning, but
> I have 174 old warnings from before I started complaining about them.
> 
> Maybe:
> 
>         if (U32_MAX >= SIZE_MAX && arg.user_addr > SIZE_MAX)
> 		return -EINVAL;
> 
> This code works fine as-is, but eventually I want this code to trigger
> a couple more static checker warnings.  It's so suspicious because
> we're truncating user data then re-using the same untruncated variable
> again.

Agree, that's the part I don't like. It's fine masking off for offset,
but the later passing in directly is wonky. It'll get truncated to
unsigned long at that point though, so won't _actually_ be passed in.
Hence I'm a bit dubious that this really needs fixing. Yeah the app can
put garbage in the upper 32-bits, but it's never going to be seen.
Should we catch and -EINVAL on that? Potentially, at least it can't hurt
to do so.

-- 
Jens Axboe

