Return-Path: <io-uring+bounces-11030-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A651DCB9BAB
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 21:10:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2BF5230249D8
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 20:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A39F7245019;
	Fri, 12 Dec 2025 20:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kMcM4LWP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D082D238D
	for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 20:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765570257; cv=none; b=Jle/OjoKVgZMlqAGGAEIdhhnA5U0cMf33Q5v8NdArraEhBPKU13hxI51nUiK94vuFNS55fFjDA8Y5Z9/yMCKBGQsHKVlnZXndw2+CPs1g7moGzCjSWEAtB9fPO4jOKRCSIqQFkPCqSfuMA+U4p7Jq63m8x9hMeaj64XtCfC+oSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765570257; c=relaxed/simple;
	bh=4gfCtO9+aoCvqYEay1XZJUUI1s50LzgL381O6T7z7FE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a6iiI0E4PyRy8Iry3CGujrbWEEjs1dAMr+orQc3hAMmS2sbGsGqgQT0t0enWUQQBUqIAmM0KdRqK4m7dogdu9FRb/cRBWMq6CP79xrQo9oi4eCLeHbJuEZ/BxvP0I5Qo33cqIMlLEHGI71aVNCKfj/O+eY52TAAnFwXpBBb5Qt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kMcM4LWP; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29ba9249e9dso21977695ad.3
        for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 12:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765570255; x=1766175055; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gsVed5WgXtZPXSfJ2PXjLRbNCmFwRAyF31OH8siBSJw=;
        b=kMcM4LWPOOW5aofuFjI2DOpQEcNRY9pNxIjsXTaODIbDPKMC5FNcR7RvUO9eXo7mUq
         6BsGnJ80Xlb32jsfGAp+kCt1gImNMKb/QKdXHMJzk3bvdv8jJhbJphheaDpf4gyuL5OG
         HydGJQiIETyM9h3gNatOuE/XUa43fmZn6KP8wz9r5te3Ta0LYeDWaXyvX2hZGRTaXuXg
         /iNRw/JmobBVs/4eJJRU3EsIFK6gjThqYZOWcBvyjw/thYYPRJAIm93s1R1dBxjNosQg
         yLY2UQskQxlKMiLFwHf+C19An1ecALJSPCTKVzeWTZrQ5wRsmfgnj+Hjun9X4HRLWPjc
         cWWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765570255; x=1766175055;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gsVed5WgXtZPXSfJ2PXjLRbNCmFwRAyF31OH8siBSJw=;
        b=HhHaKAHTgGaO0OIKC8ZD/Y0Cf2Sk65hOquCZjdnvTXKfoxCF1gTeho7+3yXFLncAtv
         vH0NkqRgbECveH1+Yw9VfcyI1NJ2Gu8hsvKigUH+lZScaKib2TdOhaj0WV+kLRRcu+cl
         lKMVj/2q/p2+c5gRT084IyF3VMP8XP1pXmhnE33EWduT/rfQiaWQdJxsvbB1ftBTsjXc
         z+kF1sJmQ/+Pe7OsHxx9STRKTPf4jHWDSk8cyFFoSZAOMWZSj8/3GZkA/8TCTgz4dnOs
         jpj0x8wTaRjjWEcu7UWqugfZL7eLpS/bkJUrF5Gtapn+bvTf3auKOvQw8kySH4eZSDoj
         173A==
X-Forwarded-Encrypted: i=1; AJvYcCXIrNchJxhKQNHcZvjpnNrDfg4PQ0x3mrpkIBaUbUwUNiw+DOfOWKEvQe1cURRz6Q/Vj0+RAO0GPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwTfW8/22ts8EstBPuSOxjPeLos+iyADc5s0pc0JtFo/XO35Grw
	l4qGoX4AN11vUf2beqJVHI8oFJQM0BqzvnwCSj8rEnnpmXjiOe7leYaYOM6TOkaMOyE=
X-Gm-Gg: AY/fxX7Tt4Kb9ae/DiRHS6PrF60ZG4WmqpUw5ZDWJlm4cPGP53EtBQQ4tougEWg6GWt
	g2bjrskqN8UUzKXvgNrFlFTmub0PmQm6Kv0FZr8jGv3VH0LIl0b+itJ5+XjGi9EOe1jUIIc+JAu
	NOwUurtNoHqCGYLI65UwBpqjturuSjkAxizpVl0u7Yow90D7jCvRR7sq1BNSn0dsnn16FADrkny
	nEy0lFN5bZnoLPVjT2623Sys7yDFEOSDdMfjL3Q7YViFZeimKl6+AHM2ReRx44cH3zw9CiGN1GT
	XPNzbaz+mgeUs0d+vJ+zlKxx7gQjli6738bNeTxB2R9ry3kys4cgyjpCXBZmXWKn9Ry/DnozIoH
	mzPZXTrx7E9MwKjwzIFghBQ4DtEbhdZsoC/fC2wvXb15it1H2slzOCyIgk16rEixnbSFSdVyYV+
	07dBfKJoXkOKj82LJ72kik6DdGRQsGTOmWqQurUsovBROyGKl52A==
X-Google-Smtp-Source: AGHT+IH4YKlBbDeLqTy95z05gm75S6dqOblA2F2FrB859WtV1ZEekn7/gpBPyoL8TMFo+3JpfAzaQQ==
X-Received: by 2002:a17:902:f688:b0:29f:29a8:608b with SMTP id d9443c01a7336-29f29a861cemr19807075ad.13.1765570255065;
        Fri, 12 Dec 2025 12:10:55 -0800 (PST)
Received: from [172.20.4.188] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9d38c7fsm62825655ad.39.2025.12.12.12.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Dec 2025 12:10:54 -0800 (PST)
Message-ID: <2729b31b-ba58-4f32-b71a-75bd07524ac8@kernel.dk>
Date: Fri, 12 Dec 2025 13:10:50 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 03/11] block: move around bio flagging helpers
To: Pavel Begunkov <asml.silence@gmail.com>,
 Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org,
 tushar.gohad@intel.com, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
References: <cover.1763725387.git.asml.silence@gmail.com>
 <6cb3193d3249ab5ca54e8aecbfc24086db09b753.1763725387.git.asml.silence@gmail.com>
 <aTFl290ou0_RIT6-@infradead.org>
 <4ed581b6-af0f-49e6-8782-63f85e02503c@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <4ed581b6-af0f-49e6-8782-63f85e02503c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/11/25 6:08 PM, Pavel Begunkov wrote:
> On 12/4/25 10:43, Christoph Hellwig wrote:
>> On Sun, Nov 23, 2025 at 10:51:23PM +0000, Pavel Begunkov wrote:
>>> We'll need bio_flagged() earlier in bio.h in the next patch, move it
>>> together with all related helpers, and mark the bio_flagged()'s bio
>>> argument as const.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Looks good:
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>
>> Maybe ask Jens to queue it up ASAP to get it out of the way?
> 
> I was away, so a bit late for that. I definitely wouldn't
> mind if Jens pulls it in, but for a separate patch I'd need
> to justify it, and I don't think it brings anything
> meaningful in itself.

I like getting prep stuff like that out of the way, and honestly the
patch makes sense on its own anyway as it's always nicer to have related
code closer together.

-- 
Jens Axboe

