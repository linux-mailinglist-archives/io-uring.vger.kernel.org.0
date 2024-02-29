Return-Path: <io-uring+bounces-800-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D9CD86BE72
	for <lists+io-uring@lfdr.de>; Thu, 29 Feb 2024 02:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1461A284645
	for <lists+io-uring@lfdr.de>; Thu, 29 Feb 2024 01:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DE66364A0;
	Thu, 29 Feb 2024 01:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rLJTKoBC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD836364A4
	for <io-uring@vger.kernel.org>; Thu, 29 Feb 2024 01:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709171210; cv=none; b=AWymgMuujNVh7oXGUjvlBJUyhjNnfzlUt947fb1KZ0HbyJdpsrr1W/GHMh8pSaQ870PbUNEADPjhUbaGaz7Qqu8lCPkpg7uVqFZ0j8N1391H2Hd2rwfYCpwYNAiWvxvrUHL8rr2JrZ6Xrsh0trS+RS90fL1lgiuiVRXYJ+ly/dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709171210; c=relaxed/simple;
	bh=1HuC1bq9jCQNi1bD+MZtAESZew8TfpECJEOy7ALFXfE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ivfr9SCcxyf5KGds+9cfFlOnwwwjqnyn9alNdO7flu4v6vudPQ56U97bYAOKWHrVOZCDqw+HwcWj+S53DDsGfSj4B/qDFXKCTg6tsswYhCZrX7/Oa5Q4JUSgxpEib4Fv7+7575dP63LQP0Cb58xfHGxt42WA/3GikZUaurwRSd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rLJTKoBC; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6e4857d93ebso55462a34.0
        for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 17:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709171207; x=1709776007; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0PgZL/V9I4NJgOx/Ix5tYhCPZC5Zt3HIgEJTSd9ZOg0=;
        b=rLJTKoBCPVryYv0UluDwuBT+44L+xNBLbys6s1Dfzrmbs09FmL8vjQbFnTn0nNw2v6
         NO0Am5DsFy4XnU0WvOgDQkwJ1z2hI7gsJ7lF0eIxnrxkBgT3rDTWRuwr2t/iGJiAxBFi
         pCJ/osVYV93aeI0DzsrFQppJOjKOljMfcMWscV4K8T+i7PYMNnX7gdYgs9x12jY+rKgW
         ksZHkwHU8qXYM8K1JbBhN2RIsRlzNALTFVmoFK6NgQKqFqufS3v1bJOYSfn6EENhCKTQ
         nbi1bDMxe18BNEnl+hThU97hSeW/CM3hC9HenQe/2lZ0IE5AsxQcMjDZR6OwOTWjcTtC
         45xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709171207; x=1709776007;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0PgZL/V9I4NJgOx/Ix5tYhCPZC5Zt3HIgEJTSd9ZOg0=;
        b=DbH7L5s1xGzkgSDKtUKNFWTisnic8Oxgh+9zVX7ssx7q2DhngCdVepSC5K1JtyPfvF
         v3peVZaUSyp5F0/4Sp6k0xPswWqDg3io4zLtI+p5ZG94sjjsz+hADyzVoP1rImwdlVHf
         A6SJ60wjDWyjNyX4T9nT+qlhxX6Nr7c+O1EYIE66atgiWb13nXFm1PKIX1NzWiqoCm0S
         BAMS1r4dEV3xF+yoSu65srYaGuTAdDX4wWPzD+iB+P3mjTt3UNkFQcecUf64YQO8zc3A
         L4Yr6TJ8vr/aZMve4WNIsv0J6JwEAW5M2crwZt9hfgm1rmQoeuI7KMvf1hZjig2cDLhs
         qT7g==
X-Gm-Message-State: AOJu0Yx24NHdNsf0QAW7y07sVMz1A1z+16DsPqkJrJIRoxGEdZLRaMWp
	KqPAU5RzgxKmDpaGPakxUoEcB/YPYDH5VBJ19FnbGXi2eU5hjoikw872VOcO3RM=
X-Google-Smtp-Source: AGHT+IF5o99zk2Pemx6QIDiZURHlzfPI/9U97DncFf/K6VpcyDkrie0ZhhqbfBK/qCyCnQHLayKS8Q==
X-Received: by 2002:a05:6808:2386:b0:3c1:9b7b:5830 with SMTP id bp6-20020a056808238600b003c19b7b5830mr876665oib.5.1709171206814;
        Wed, 28 Feb 2024 17:46:46 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id t34-20020a056a0013a200b006e554f91e66sm104391pfg.49.2024.02.28.17.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 17:46:46 -0800 (PST)
Message-ID: <a61390aa-01a4-4511-a24a-c3373110a28a@kernel.dk>
Date: Wed, 28 Feb 2024 18:46:44 -0700
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
In-Reply-To: <3a0fdcbd-abd2-46e0-a097-9f0553954ad2@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/28/24 4:49 PM, Jens Axboe wrote:
> On 2/28/24 10:28 AM, Jens Axboe wrote:
>> When I have some time I can do add the append case, or feel free to do
>> that yourself, and I can run some testing with that too.
> 
> I did a quick hack to add the append mode, and by default we get roughly
> ring_size / 2 number of appended vecs, which I guess is expected.
> There's a few complications there:
> 
> 1) We basically need a per-send data structure at this point. While
>    that's not hard to do, at least for my case I'd need to add that just
>    for this case and everything would now need to do it. Perhaps. You
>    can perhaps steal a few low bits and only do it for sendmsg. But why?
>    Because now you have multiple buffer IDs in a send completion, and
>    you need to be able to unravel it. If we always receive and send in
>    order, then it'd always been contiguous, which I took advantage of.
>    Not a huge deal, just mentioning some of the steps I had to go
>    through.
> 
> 2) The iovec. Fine if you have the above data structure, as you can just
>    alloc/realloc -> free when done. I just took the easy path and made
>    the iovec big enough (eg ring size).
> 
> Outside of that, didn't need to make a lot of changes:
> 
>  1 file changed, 39 insertions(+), 17 deletions(-)
> 
> Performance is great, because we get to pass in N (in my case ~65)
> packets per send. No more per packet locking. Which I do think
> highlights that we can do better on the multishot send/sendmsg by
> grabbing buffers upfront and passing them in in one go rather than
> simply loop around calling tcp_sendmsg_locked() for each one.

In terms of absolute numbers, previous best times were multishot send,
with ran in 3125 usec. Using either the above approach, or a hacked up
version of multishot send that uses provided buffers and bundles them
into one send (ala sendmsg), the runtimes are within 1% of each other
and too close to call. But the runtime is around 2320, or aroudn 25%
faster than doing one issue at the time.

This is using the same small packet size of 32 bytes. Just did the
bundled send multishot thing to test, haven't tested more than that so
far.

-- 
Jens Axboe


