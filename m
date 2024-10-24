Return-Path: <io-uring+bounces-4007-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A9FE9AF315
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 21:57:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BECA7B220A9
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EA7E17333D;
	Thu, 24 Oct 2024 19:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ETbCZj/V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F97619CC3A
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 19:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729799780; cv=none; b=V2m1/REA9nEGzTMN+V7+BBXrFn9cW5TR1Ndwnmmao43ciMiQ/lDi+hixm218b07oZkzSpJhqNW2VMcOWmvijE2qWT4axSnP2/CRFAXDv7ZkOhfjPaeEdYHYrh/z/y4HfvPZyM6ZQ8ELCyPanFR+T8hW5Pahai27KVHCq77uoRRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729799780; c=relaxed/simple;
	bh=VmIQlKmdRjCOjpV+zOFuLojiN1+WYuwoGQZCDFVZrxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=t9gW9Sb9JiRJeC7/ebMjow8av3B8rXvnD8UQ9aalnfEtP6w+kdhxqVbXqM57W5mJaawdXNFD6M3g12snChxY/qEvdtlNWRWHCV0sbq60UEnUWA+yZ89aNguzbiwjcCOyZ9NRBid8sw6xwQIqtMSpgNwH7U+gLb0x3HDW5uJB4i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ETbCZj/V; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-83ab94452a7so56871639f.3
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 12:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729799776; x=1730404576; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kMMaQla2XKMIkTHsq978UokkGPhyOoYjHH36iKWfbEk=;
        b=ETbCZj/VgCque8CIRD5vGWAFeHjMA/sRhPHjhV9D33bqL2UE8UyTWnUmfifk4ZMIl4
         fZ/t33j2g4mF7DEVxnXEJXAhwdBxJRw2yIiqqQ5OgTGOa9ETNPeXMzPBN71z9GhUp5Ol
         wPAa6+/lkSPyge/Tk2bwJxo315iwQrMPYM9i+Z2kVU2PAAKYpsD3kL/mb91QU5RbpNBt
         OhxbPdTQdgYk3hC5nqbQYen4Ccm4nVwIS4I/FsDaxeiD2ZqpPGpgiGqAot//9jFOKWLq
         27bUyRon01UXw/NLcINo+lfsQxyJJE70ePNJwFI5R0xLv0Tv0hl5P2rzl+cVzT0Ni1W/
         R0DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729799776; x=1730404576;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kMMaQla2XKMIkTHsq978UokkGPhyOoYjHH36iKWfbEk=;
        b=BR5TJOKm3wTzaMP07f+jnHIJqu6esdslz6bGOuDFu0YJEjhcl9InDKXrNpEcm5uz/U
         SFNe+5UN0hT/D8dpF1C9GT1QBJ+6TKSnKRrUL5kOYd4wjXxp+heXs0+7UrfaGwvcls4a
         zmgNOs9/FjQ2izVELB03b+TstjNmf8bqClElXvVjqZ93wnLTrhvQxdwEuAi4iTBWtIPk
         cM0Qstk8u3hEiJ4vK5CTbcb38aSqrwXYhvqE8AgxpDUBIPA4s0PyYH5lJjkvBw6piB6p
         tNvWGJdwlIUMKIFlOTShKjraTxkL8YdFsKBxNABPF6RObd6jZZKDRyMl+M9/AxvksE06
         xL6Q==
X-Forwarded-Encrypted: i=1; AJvYcCV7YnBDxVcRTVRUgWpOp6OKuKG/oBwGcpqVUU9mhNkDWvD5/MWuplpEidgIVVvrgCuM6C7sWMWfjw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyAdXSyjdaEWbxRHTIYxzFhPVWu4R93Jcq/Am5L8WDzOuG8NusA
	GoReVUMBK6izS2qqbgN2YRqlwuZcDMEq/zSzuDWnu5IoZ8PGl0KGFIDWrZVFo/1SZ3IGT3I8o8p
	6
X-Google-Smtp-Source: AGHT+IHYJhCgySxMBjkM5/UDl8g+BdWG4LUeXuVwUYHoaoo7DvRZdV9BHhvrMJXwIrHugQdNeFbVYg==
X-Received: by 2002:a05:6602:2c94:b0:82d:16fa:52dd with SMTP id ca18e2360f4ac-83af6192782mr618844739f.7.1729799775757;
        Thu, 24 Oct 2024 12:56:15 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a6301ecsm2788104173.135.2024.10.24.12.56.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 12:56:15 -0700 (PDT)
Message-ID: <daeacc90-e5b4-471d-a79e-74ae10eb4aba@kernel.dk>
Date: Thu, 24 Oct 2024 13:56:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] implement vectored registered buffers for sendzc
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1729650350.git.asml.silence@gmail.com>
 <b15e136f-3dbd-4d4e-92c5-103ecffe3965@kernel.dk>
 <bfbe577b-1092-47a2-ab6c-d358f55003dc@gmail.com>
 <28964ec6-34a7-49b8-88f5-7aaf0e1e4e3f@kernel.dk>
 <3e28f0bb-4739-40de-93c7-9b207d90d7c5@gmail.com>
 <3e6c3ff5-9116-4d50-9fa8-aae85ad24abc@kernel.dk>
 <3376be3e-e5c4-4fbb-95bb-b3bcd0e9bd8b@gmail.com>
 <67f9a2b9-f2bd-4abd-a4a5-c1c5e8beda61@kernel.dk>
 <d8da2a22-948b-4837-a69a-e9e91e37feec@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d8da2a22-948b-4837-a69a-e9e91e37feec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 12:13 PM, Pavel Begunkov wrote:
> On 10/24/24 19:00, Jens Axboe wrote:
>> On 10/24/24 11:56 AM, Pavel Begunkov wrote:
>>> On 10/24/24 18:19, Jens Axboe wrote:
>>>> On 10/24/24 10:06 AM, Pavel Begunkov wrote:
>>>>> On 10/24/24 16:45, Jens Axboe wrote:
> ...>>>> Seems like you're agreeing but then stating the opposite, there
>>>>> is some confusion. I'm saying that IMHO the right API wise way
>>>>> is resolving an imu at issue time, just like it's done for fixed
>>>>> files, and what your recent series did for send zc.
>>>>
>>>> Yeah early morning confusion I guess. And I do agree in principle,
>>>> though for registered buffers, those have to be registered upfront
>>>> anyway, so no confusion possible with prep vs issue there. For provided
>>>> buffers, it only matters for the legacy ones, which generally should not
>>>> be used. Doesn't change the fact that you're technically correct, the
>>>> right time to resolve them would be at issue time.
>>>
>>> I'm talking about sendmsg with iovec. Registered buffers should
>>> be registered upfront, that's right, but iovec should be copied
>>> at prep, and finally resolved into bvecs incl the imu/buffer lookup
>>> at the issue time. And those are two different points in time,
>>> maybe because of links, draining or anything else. And if they
>>> should be at different moments, there is no way to do it while
>>> copying iovec.
>>
>> Oh I totally follow, the incremental approach would only work if it can
>> be done at prep time. If at issue time, then it has to turn an existing
>> iovec array into the appropriate bvec array. And that's where you'd have
>> to do some clever bits to avoid holding both a full bvec and iovec array
>> in memory, which would be pretty wasteful/inefficient. If done at issue
> 
> Why would it be wasteful and inefficient? No more than jumping
> though that incremental infra for each chunk, doubling the size
> of the array / reallocating / memcpy'ing it, instead of a tight
> loop doing the entire conversion.

Because it would prevent doing an iovec at-the-time import, then turning
it into the desired bvec. That's one loop instead of two. You would have
the space upfront, there should be no need to realloc+memcpy. And then
there's the space concern, where the initial import is an iovec, and
then you need a bvec. For 64-bit that's fine as they take up the same
amount of space, but for 32-bit it'd make incremental importing from a
stable iovec to a bvec array a bit more tricky (and would need realloc,
unless you over-alloc'ed for the iovec array upfront).

-- 
Jens Axboe

