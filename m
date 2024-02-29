Return-Path: <io-uring+bounces-801-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3D7586CD49
	for <lists+io-uring@lfdr.de>; Thu, 29 Feb 2024 16:42:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56D53286A09
	for <lists+io-uring@lfdr.de>; Thu, 29 Feb 2024 15:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907FD1468F6;
	Thu, 29 Feb 2024 15:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nuxx6pWL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C3114601B
	for <io-uring@vger.kernel.org>; Thu, 29 Feb 2024 15:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709221365; cv=none; b=qhEOO/POrdtz/LE+NWjuaBhDClHgCUHslkTMt2mam/7K84a5uGxkWhhHomEiuqrcoR4VEM5wJzts4IqsSC57aXtk9qpOxizHfNKoUY8us9Uc0XWYhGJTR5cZstfIUoqrHT49ybyXvYHHa6iGcL2/s9QiwR8cA6hgpU4cWGZXGeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709221365; c=relaxed/simple;
	bh=8lx1Klt1VIp47UkBtTtEf+H8H6mxnq2Ak4gayJ9qicI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=UytlHxbsY81wD71NFCyRy/w1whMywbyAkLEm0nC/11S1K/qJncLYcjypjfB5e/F7vNf1K+zVQa//k3LpG5wZxs76SIuHYsgokO1Q+bpr6/sbWS4ax/beUYCIJQjzfUWN98mUK3HG4jdkxCejEKY6y+bu0DbEPzu3QgbC9VJ42l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nuxx6pWL; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e28029f2b4so62421b3a.1
        for <io-uring@vger.kernel.org>; Thu, 29 Feb 2024 07:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709221361; x=1709826161; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IYow9i9N+6WlEA42qzeRbHqOQDZ0hOkzXn+YfSfO01o=;
        b=nuxx6pWLJBYL/KsbLddaggiN3NIG6JE9bEkcvPP1wHjQ+eC2mPdiwlUT8HaY3TaJV1
         UZB6XDmC41h88BqcY2MQt+BcZ6KqWf/3Aatyf51IkfCvaoopqzqH3W4wo4nC+mjrxLVH
         bMttHOFyxFqWEuy1RcXE4xIoYADtSGc6I3XwnVJRQmz+RP0zmqf5Yj/6A/l3dAWjQ7LK
         AZtf/93ZRQr7iJBS4ADcGBQmjfGQj5dTl8OO4UYpedX8BsnnBn6Q1aVdHhtCJArGYyUc
         VYFuiJdP8NUpt5skBF6owXCqrvGDLmZxjim//40rLTVtlSyJIMvdSPTkzQK2crj6qtSw
         WhJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709221361; x=1709826161;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IYow9i9N+6WlEA42qzeRbHqOQDZ0hOkzXn+YfSfO01o=;
        b=n/NykXcXxyySotwexxoCKy0EYFrFK2pBqrn71vfX4neKE/yKvyoax8Jf4Bhms063aS
         Q+8eWLsz4H/WcYtaNrA7OOBFKTmsJFNsjzGNq/QonsDNIAJic3MG2IHMEM4nxghK5tOn
         a4g9kzqFZncagsN4DDxhKZ/2PIMtJuJglzVJfLbpWGcRpeRc7ANHSlLUfsXitKo0jOr5
         ykA41S0H1RRbSjG296UXoAZg7uE2iBpiXLiLhiOQPIWHZEGXHTrWAyF6/+HkOczSWg5A
         01menyer0NKSMPPM2JShxzv8urbS7x92eyN4Y67Pz+G8cE3jY5CQpRULfZ/l34jWrSi7
         wZFQ==
X-Gm-Message-State: AOJu0YykMy7H+4/05fZ7X19hQoJVeA9APgQb9oGJIeXzN76nD4z5kTpz
	QJHGvBFPPKvXtXFeTnXGypYV5lzyx0byJBkJ46hFLmRf8lth+kvMatfJbCkChkfeKwyHgeEl10V
	k
X-Google-Smtp-Source: AGHT+IFb2bx1rhtxieWLFuHu3cF07yijoITO3obfOGsi2ZWK/UivtpUOY3SnnbealvWyGKkFsxTrKA==
X-Received: by 2002:a6b:6e07:0:b0:7c7:7f73:d1a with SMTP id d7-20020a6b6e07000000b007c77f730d1amr2708695ioh.1.1709221339853;
        Thu, 29 Feb 2024 07:42:19 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d6-20020a056602280600b007c7a55ea0b6sm343824ioe.48.2024.02.29.07.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 07:42:19 -0800 (PST)
Message-ID: <d980459c-6070-4b9a-9808-a8497df44ef9@kernel.dk>
Date: Thu, 29 Feb 2024 08:42:18 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] io_uring/net: support multishot for send
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>,
 Dylan Yudaken <dyudaken@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20240225003941.129030-1-axboe@kernel.dk>
 <20240225003941.129030-7-axboe@kernel.dk>
 <CAO_YeojZHSnx471+HKKFgRo-yy5cv=OmEg_Ri48vMUOwegvOqg@mail.gmail.com>
 <63859888-5602-41fb-9a42-4edc6132766f@kernel.dk>
 <CAO_YeoiTpPALaeiQiCjoW1VSr6PMPDUrH5xT3dTD19=OK1ytPg@mail.gmail.com>
 <ecd796a4-e413-47d3-91c1-015b5c211ee2@kernel.dk>
 <f0046836-ef9d-4b58-bfae-f2bf087233e1@gmail.com>
 <454ef0d2-066f-4bdf-af42-52fd0c57bd56@kernel.dk>
 <a0f62e25-f19c-44b7-bf26-4460ae01de7f@gmail.com>
 <4823c201-8c5d-4a4f-a77e-bd3e6c239cbe@kernel.dk>
 <68adc174-802a-455d-b6ca-a6908e592689@gmail.com>
 <302bf59a-40e1-413a-862d-9b99c8793061@kernel.dk>
 <0d440ebb-206e-4315-a7c4-84edc73e8082@gmail.com>
 <53e69744-7165-4069-bada-8e60c2adc0c7@kernel.dk>
 <63da5078-96ea-4734-9b68-817b1be52ec6@gmail.com>
 <0e02646e-589d-41da-afcb-d885150800e6@kernel.dk>
 <3a0fdcbd-abd2-46e0-a097-9f0553954ad2@kernel.dk>
 <a61390aa-01a4-4511-a24a-c3373110a28a@kernel.dk>
In-Reply-To: <a61390aa-01a4-4511-a24a-c3373110a28a@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/28/24 6:46 PM, Jens Axboe wrote:
> On 2/28/24 4:49 PM, Jens Axboe wrote:
>> On 2/28/24 10:28 AM, Jens Axboe wrote:
>>> When I have some time I can do add the append case, or feel free to do
>>> that yourself, and I can run some testing with that too.
>>
>> I did a quick hack to add the append mode, and by default we get roughly
>> ring_size / 2 number of appended vecs, which I guess is expected.
>> There's a few complications there:
>>
>> 1) We basically need a per-send data structure at this point. While
>>    that's not hard to do, at least for my case I'd need to add that just
>>    for this case and everything would now need to do it. Perhaps. You
>>    can perhaps steal a few low bits and only do it for sendmsg. But why?
>>    Because now you have multiple buffer IDs in a send completion, and
>>    you need to be able to unravel it. If we always receive and send in
>>    order, then it'd always been contiguous, which I took advantage of.
>>    Not a huge deal, just mentioning some of the steps I had to go
>>    through.
>>
>> 2) The iovec. Fine if you have the above data structure, as you can just
>>    alloc/realloc -> free when done. I just took the easy path and made
>>    the iovec big enough (eg ring size).
>>
>> Outside of that, didn't need to make a lot of changes:
>>
>>  1 file changed, 39 insertions(+), 17 deletions(-)
>>
>> Performance is great, because we get to pass in N (in my case ~65)
>> packets per send. No more per packet locking. Which I do think
>> highlights that we can do better on the multishot send/sendmsg by
>> grabbing buffers upfront and passing them in in one go rather than
>> simply loop around calling tcp_sendmsg_locked() for each one.
> 
> In terms of absolute numbers, previous best times were multishot send,
> with ran in 3125 usec. Using either the above approach, or a hacked up
> version of multishot send that uses provided buffers and bundles them
> into one send (ala sendmsg), the runtimes are within 1% of each other
> and too close to call. But the runtime is around 2320, or aroudn 25%
> faster than doing one issue at the time.
> 
> This is using the same small packet size of 32 bytes. Just did the
> bundled send multishot thing to test, haven't tested more than that so
> far.

Update: I had a bug in the sendmsg with multiple vecs, it did not have a
single msg inflight at the same time, it could be multiple. Which
obviously can't work. That voids the sendmsg append results for now.
Will fiddle with it a bit and get it working, and post the full results
when I have them.

-- 
Jens Axboe


