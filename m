Return-Path: <io-uring+bounces-3128-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA7969743E6
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 22:10:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34F301F26CF1
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 20:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E98F18C930;
	Tue, 10 Sep 2024 20:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nA1pcZSU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDC1176252;
	Tue, 10 Sep 2024 20:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725999013; cv=none; b=GLufigef2RoxsUIP/armnk52EjSsjV4rN6bIgZPEmUyrvMc1hjBGN99h5fZDjo7aJxboJk66CtnJY3J8OII5dSxpWUsBERwmWvO1yU+C/FaP9XHUNKvGibPrNnH0TRKgeXPOJPvXUfR64h6ThGJLHjnbGdzzWIJYBHXNIFQVuaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725999013; c=relaxed/simple;
	bh=lb2HrdtFUXtuZIFefr+NvrlNc3pcdiXB5EQnXVqikrs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nfe6XtJ9TCMUEjm5wqxLaokAzc2oeGHvA+hOaq+nUPVqk6Rp63ITCSTMgVsBhGCqyWyf+NmV3EMF/78Q78tSjZEM2RHcuu1zncoICwFyej8Av/1/i8aQCoa6Ng03FKKZRgrv1OppRVm3YM+dn0fRGw62U46m8YVYtCimlcDyad4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nA1pcZSU; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-374ca65cafdso3765685f8f.2;
        Tue, 10 Sep 2024 13:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725999008; x=1726603808; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1V8I0bda6wgDAwGKScnVsLlsELDqLNjD+DNqt7q61gM=;
        b=nA1pcZSUKkVrs/Zh+hAEo8rzfA2pa/hsJlSe4RfGHuyRuRBq7slXNi+khxcCE7fstP
         CHKjGMbgEBTM3U18GmZ0dehwQzgkPSaPttRLaO9JzWk40ZwZfbOFtwRGHKQ0cmRCAIK6
         7Ufh3dQZhHstavQ5XNS6khH9q0X+U5ivsaVdtD/98gaOJ8oja/kaBAuU2XE0lZR10+XS
         aVPQMxv0p+B+2Mt4tyfpIEPJjURiXQLzxwFxDdpKs+TnOxvFD8THVFUJM7FpBTFwOtIj
         qHea+xgfk2nqL+3BHvVRhNqeLEyZX0aCCEZQfoJmNacO2EnWkvtEXUTAd8m1bC7SpgNp
         ypNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725999008; x=1726603808;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1V8I0bda6wgDAwGKScnVsLlsELDqLNjD+DNqt7q61gM=;
        b=J4aUQvYiUG5bpzDyJ0CRZ/YK2C7HaP2SX8bd196NyXm2VSoi6iaoZekUkTSf7aHBje
         tdm05cSn9Vg4gWETp/EILwTUf74PegtvFqakCHH6ePuIV4UlrVWdSVEzVL18MtyVM6Gz
         P0C4Xqr5UFr3+L4eu9q3k5t8lypJgX6JV5ytbLxGi6Px9ejnTm58x/sZWZhZ0LtffBjN
         2y1e6HkpvLNFGV1BxX3R5H5fDsGQVX9relSXXnuNpsDm8OPAxftCPKaHPQ/Ks4COpYPG
         TpeLnA6dy46AzTiVkSlMsa+/BSlU8zHBmzAg7vlZqBM0pOXo53DqcCWN9yTo4mRWh5+Q
         NGpg==
X-Forwarded-Encrypted: i=1; AJvYcCVlXeatx8oR7GLN7Qq1oIhExclMKfkf9/C1itGpeZbk9uoExIygR/z4UdKPWtJ3XQ4Hp6DdhHRSqKwngA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4mrEmjp0Z7bRv0HlkaIq0ZAFz9oqQ1buCb+r0Wpk1cgNC9Oca
	1WdKDX6J8XwCCTq/dQB7ezW7dMmWy5ienJaABWLbvUpwi3WynrP8
X-Google-Smtp-Source: AGHT+IGPhCsr2Cg6XFvgIErACrpEzyACnrLWkIv8TFs1iJmpEPQsddD03gvCRqm/Dm+ZabnJuSjhSQ==
X-Received: by 2002:a5d:47ab:0:b0:374:c122:e8b8 with SMTP id ffacd0b85a97d-378949ef675mr8780895f8f.11.1725999007887;
        Tue, 10 Sep 2024 13:10:07 -0700 (PDT)
Received: from [192.168.42.24] ([185.69.144.178])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeb33489sm120509425e9.19.2024.09.10.13.10.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 13:10:07 -0700 (PDT)
Message-ID: <bea206da-d634-4e34-8d69-94a024721f21@gmail.com>
Date: Tue, 10 Sep 2024 21:10:34 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/8] block: implement async write zero pages command
To: Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org
References: <cover.1725621577.git.asml.silence@gmail.com>
 <c465430b0802ced71d22f548587f2e06951b3cd5.1725621577.git.asml.silence@gmail.com>
 <Zt_9DEzoX6uxC9Q7@infradead.org>
 <d205d118-8907-4da1-8dd8-2c7c103d2754@gmail.com>
 <ZuBVy2U7Whre7EnU@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZuBVy2U7Whre7EnU@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 15:20, Christoph Hellwig wrote:
> On Tue, Sep 10, 2024 at 01:17:48PM +0100, Pavel Begunkov wrote:
>>>> Add a command that writes the zero page to the drive. Apart from passing
>>>> the zero page instead of actual data it uses the normal write path and
>>>> doesn't do any further acceleration, nor it requires any special
>>>> hardware support. The indended use is to have a fallback when
>>>> BLOCK_URING_CMD_WRITE_ZEROES is not supported.
>>>
>>> That's just a horrible API.  The user should not have to care if the
>>> kernel is using different kinds of implementations.
>>
>> It's rather not a good api when instead of issuing a presumably low
>> overhead fast command the user expects sending a good bunch of actual
>> writes with different performance characteristics.
> 
> The normal use case (at least the ones I've been involved with) are
> simply zero these blocks or the entire device, and please do it as
> good as you can.  Needing asynchronous error handling in userspace
> for that is extremely counter productive.

If we expect any error handling from the user space at all (we do),
it'll and have to be asynchronous, it's async commands and io_uring.
Asking the user to reissue a command in some form is normal.

>> In my experience,
>> such fallbacks cause more pain when a more explicit approach is
>> possible. And let me note that it's already exposed via fallocate, even
>> though in a bit different way.
> 
> Do you mean the FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE case in
> blkdev_fallocate?  As far as I can tell this is actually a really bad
> example, as even a hardware offloaded write zeroes can and often does
> write physical zeroes to the media, and does so from a firmware path
> that is often slower than the kernel loop.

That's a shame, I agree, which is why I call it "presumably" faster,
but that actually gives more reasons why you might want this cmd
separately from write zeroes, considering the user might know
its hardware and the kernel doesn't try to choose which approach
faster.

> But you have an actual use case where you want to send a write zeroes
> command but never a loop of writes, it would be good to document that
> and add a flag for it.  And if we don't have that case it would still

Users who know more about hw and e.g. prefer writes with 0 page as
per above. Users with lots of devices who care about pcie / memory
bandwidth, there is enough of those, they might want to do
something different like adjusting algorithms and throttling.
Better/easier testing, though of lesser importance.

Those I made up just now on the spot, but the reporter did
specifically ask about some way to differentiate fallbacks.

> be good to have a reserved flags field to add it later if needed.

if (unlikely(sqe->ioprio || sqe->__pad1 || sqe->len ||
	     sqe->rw_flags || sqe->file_index))
	return -EINVAL;

There is a good bunch of sqe fields that can used for that later.

> Btw, do you have API documentation (e.g. in the form of a man page)
> for these new calls somewhere?

Mentioned in the cover:

tests and docs:
https://github.com/isilence/liburing.git discard-cmd
man page specifically:
https://github.com/isilence/liburing/commit/a6fa2bc2400bf7fcb80496e322b5db4c8b3191f0

I'll send them once the kernel is set in place.

-- 
Pavel Begunkov

