Return-Path: <io-uring+bounces-8669-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5AE5B046E3
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 19:51:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E74E717432D
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 17:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F9502F22;
	Mon, 14 Jul 2025 17:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="g2tczGZA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6CA246BBE
	for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 17:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752515467; cv=none; b=MvK1kkd5amDpMJPtekfIpwNWpqiLUyrCyo2D/UxunlXTUAv++yByEXxplvXGFLrKm44Xngz1MSMjeCgCjlE/9tteHH0y9R2hf9/IH9RvcImWkVQ9kkJZ+MfdbJP+k9Z6rqrFOdisA7bFuu5JZzvKxpIe4qJOpTQWL/3yWWxzTiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752515467; c=relaxed/simple;
	bh=rCuh0Z0i8K3XOCxEMz7l37NChCOJXBR1AMTGMg4i61w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LLbtliiV9QSDmeL0JuxWauZKZQQz2zftjQz62jNX5nvW4oQiSrbzwEhDcUCr75MeQ7js0av+Gv+V43IyYIcV8eDdFvfYAkGTQ3Lw807beCTnrUucwmpAQStKYk81Lhzxq9Pyyek0U8cIWQB9hME5HpoONs/EFOwdlL8xT8KNM3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=g2tczGZA; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3df2e7cdc69so12719255ab.2
        for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 10:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752515463; x=1753120263; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pZwz0QXBk0Ru3/YkjnOL0bTPkf6rMI8li/9gh/pn/MA=;
        b=g2tczGZAIFUPQEOjlkbyAV4iLubA8wvbhDNYJkX5g1a4R8Gd7t0NoDc4U15x/4rIQr
         oHgRaBjhPMlD6NwuG+FkYxhyAdxuddpSL+BmFx7JhSK3T7rp4vwrv6VZMGqzv0aSPxYZ
         PXbbd9awEPBtK6Ez7LvfajvmU3+mVH0vB1MzDpDRbRe98dO1Z3gIcVYbv+L271J2IIij
         m1UoORGNvFrXnEg1Lq/ppBSYfK4Vtxj3NutXnvFJdWPdR4WS7Wl6slYzS7ZvveoP93Tu
         t+qrfEfrtGSxtdlwEOXc0HK34oObgFg71t7xcnjKtgWhIqdYQFPbWPBpH402T7rvQ/WV
         +hFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752515463; x=1753120263;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pZwz0QXBk0Ru3/YkjnOL0bTPkf6rMI8li/9gh/pn/MA=;
        b=oV5nrt7bOQDUrVV0cHt13DVqyJCjqBO13qs/zcpwy1QlqnvgWyERIe/cm8om0EfLuG
         vaPJaN2v7mDSi16iBh59Q9iP513egXCu2EZbkNz2MWSI/b/V7NL3bg1chEOZIinshnFT
         tiDA9z4mAA1UTnyNGdo6/8Eb/N3K6J2lmnRnaqy1Y5OByGxREG+n1A8xBt9K2M9mZYaB
         kvXem0BkpHBq1iGoFgoaVGy+PnyYZwK/UKyA3xEKOO9z05PEFvgkAY8oT+cAENa9nga2
         ohctWlXDRz1wHZf2qeT5zkXZWwHsGYoANocoNZNhV5lxfmeHOacGi8TGZ2JwCLD//aj4
         Grhg==
X-Forwarded-Encrypted: i=1; AJvYcCV8qrD8BQvyv11iU2ZI8c1JTcSbIxp+QqK3lGOKcPvuTf9qI6xb8Mfu2wF7uTXbNSVK4WCEi+0Etg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0UEXLZU+yoSrwryhmKk3uXzo70I+dgJWy8LwzPRwOtRESt4Ix
	cfjiWpmUAKgM8uSigDZm/aovXMpTcv3mryJmZOgjDCwMiOJ8g64jvccqHZ74mxzeALAP5caGuqc
	0fZU9
X-Gm-Gg: ASbGncu78IsEAGT9HdDQYlNs0+3+S5f4OPVhGvSxuuU9L09jD0WBSpf2Ro2gyMEELlc
	f5fCoXw3iqA1KrABgkXggVgyyHbsXr/vj05W6PHOjjO4ncbqllUSVFmduBmN/LleXKNIPX1vx6E
	sS/N2RSDWrxu/OJfIwPehpVYa3aATD88k+hc6bz0vEnOxF5NFqu9TFxCAPNdDsba4poWlKZuJNm
	gKaaJIU/QBBQkYiKp0dbApCq2uRi5LeoRdeM9sCmrKv2sSW+nvYfh7AScHAPjYm0pkVFnVuhg0g
	GwaYwhzlQ6jH+fsOwuGgv/QZ7Ktzt5cRxdSmU9u5sEqA469QMuFIqhhgqvbO/IGV58ynweTUUss
	dqa3BMwVSQN0F7YZGkicbK5Vce3ffcw==
X-Google-Smtp-Source: AGHT+IEFxMM6auz0+aZ0e510/r4yDS+kLgV86CZ3gyHh4HwjTv0qwUN0E1o9rL/45qNz6DRkyKwLAA==
X-Received: by 2002:a05:6e02:378a:b0:3df:29a6:ffbc with SMTP id e9e14a558f8ab-3e2533140c2mr142142645ab.17.1752515462869;
        Mon, 14 Jul 2025 10:51:02 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-505565324efsm2097944173.24.2025.07.14.10.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 10:51:02 -0700 (PDT)
Message-ID: <9b874b96-f79e-4a1e-a971-9504f3f209ca@kernel.dk>
Date: Mon, 14 Jul 2025 11:51:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/poll: flag request as having gone through
 poll wake machinery
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
 <20250712000344.1579663-1-axboe@kernel.dk>
 <20250712000344.1579663-3-axboe@kernel.dk>
 <801afb46-4070-4df4-a3f6-cb55ceb22a00@gmail.com>
 <9d9b87d4-78df-4c31-8504-8dbc633ccb22@kernel.dk>
 <e89d9a26-0d54-4c22-85d2-6f6c7bad9a73@gmail.com>
 <e24aaa01-e703-4a6b-9d1c-bf5deacbda86@kernel.dk>
 <4abbf820-11c9-4e01-9f95-5ccc45f0f20c@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <4abbf820-11c9-4e01-9f95-5ccc45f0f20c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/14/25 9:45 AM, Pavel Begunkov wrote:
> On 7/14/25 15:54, Jens Axboe wrote:
>> On 7/14/25 3:26 AM, Pavel Begunkov wrote:
>>> On 7/12/25 21:59, Jens Axboe wrote:
>>>> On 7/12/25 5:39 AM, Pavel Begunkov wrote:
>>>>> On 7/12/25 00:59, Jens Axboe wrote:
>>>>>> No functional changes in this patch, just in preparation for being able
> ...>>>> Same, it's overhead for all polled requests for a not clear gain.
>>>>> Just move it to the arming function. It's also not correct to
>>>>> keep it here, if that's what you care about.
>>>>
>>>> Not too worried about overhead, for an unlocked or. The whole poll
>>>
>>> You know, I wrote this machinery and optimised it, I'm not saying it
>>> to just piss you off, I still need it to work well for zcrx :)
>>
>> This was not a critique of the code, it's just a generic statement on
>> the serialization around poll triggering is obviously a lot more
>> expensive than basic flag checking or setting. Every comment is not a
>> backhanded attack on someones code.
> 
> Not taken this way, it works well enough for such highly concurrent
> synchronisation.

Certainly, no complaints!

>>> Not going into details, but it's not such a simple unlocked or. And
>>> death by a thousand is never old either.
>>
>> That's obviously true, I was just trying to set expectations that a
>> single flag mask is not really a big deal. If the idea and feature was
>> fully solidified and useful, then arguing that adding a bit or is a
>> problem is nonsense.
> 
> Quite the opppsite, it should be argued about, and not because "or"
> is expensive, but because it's a write in a nuanced place.

I think that's orthogonal - should it be commented? Definitely yes. This
is sadly true for a lot of the code in there, but doesn't mean we should
add more.

But all moot so far, at least until it can move forward, if at all.

-- 
Jens Axboe

