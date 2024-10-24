Return-Path: <io-uring+bounces-3988-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB1549AEC60
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 18:39:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89DE42835D3
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 388711F8182;
	Thu, 24 Oct 2024 16:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cqb2EFEG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA30C15A87C;
	Thu, 24 Oct 2024 16:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729787973; cv=none; b=Ev92wJV3edpNDry8PviHM+muqfojmG7O+znkASGXLbKRPmMRcnRPSMmNDnsexkvAW7lw2mMwGNVA8xZq5ki8DvN66YGvl2KiFSDUBf+phxD5zk40rsfsg2ck+Wyux4bjoYC+Fy5boPBCCtOwHeWXxiQi4NrJSxJ8qb3dbbry9aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729787973; c=relaxed/simple;
	bh=6ry637uavt5WOAjtjyuH5D5Vgw17qL4+QLHAwx2063g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r6scwuV17lkeZxpvBA/tOFylAKo2B/AYLNN7QTuZ67/EmgZhQzUyaTjFZL3jY19eoN82AFZjCXfcDHn/dwULtSf50psmoC1z1AHSvngOMpkcMlNjSHet13UGHh788lvD0j9CcGchLD92N2RQEqN0eQFB3R8iY7b7gBYQv85b0SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cqb2EFEG; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539f1292a9bso1474969e87.2;
        Thu, 24 Oct 2024 09:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729787969; x=1730392769; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BZaWT76KQAhb/SdvegV291/fD/GVxdusDKkbeX6aAyw=;
        b=cqb2EFEG8AeUPc3LxFMYXT4XpM2DnxLDQzT6PwcDxBrRwJdFltHmSXL5g8rvbuhndS
         xzHFlVnxfpk2ALREHeFnfMAB94Iuer0PHN9+BxnjEllAh/gRxsoij0gH5EuPA5QoMIM0
         6jh1j47oLgpveJFh3zgrLpV2H3RrCPQcQCYGaQwke8ciuWPhJzdetOtWXIQKppyXOxpg
         kUCD1z8Ais48Fkz+I87Sn/Xp2XFfqQwDL3eOGe6FFcmsZsLIC/Pn8NH6Sp7AXtawy2r8
         2nLOP5yOY9C+lUOz7zz/4oJqJ9xgXG4sZ02uGJYfikJ2r8t1EQi9+/iCC+g2w3SoGZ2h
         yI0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729787969; x=1730392769;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZaWT76KQAhb/SdvegV291/fD/GVxdusDKkbeX6aAyw=;
        b=KuVZGevo1RMLiW6Reg+/0dgfhptx1VC+ODQISJpJXFW6Sci22Y7v3Onarx6R/XFv5H
         4zDCdoD//T7tBhALEpZMq6wvPxXFWrsuCf1E2df2Uoz8ogluG771K4WkXhQTfHQdMfku
         HR0HT5VlMMPs2MsUenpqtQwN6E68b/L5bcbh3NoRAmu5Qm/25yaUAqHWXnrLXJLIc7kM
         p0AxIxsyFhnjfgaJqGavTiw+KyOJ+slJVWYhuJJuvPCJJwIFRZuER50FKctI9YNHuoFk
         RJ+9wZ4YR962G/6stEgWg48gx5yQmg4PiCSwe9JZAq26dXb5eLEXDhRtMR3w7w7C8wWJ
         f5cw==
X-Forwarded-Encrypted: i=1; AJvYcCWwKvG67lWj6s2CEdAsLCSg9FYD7NUrg1hTJovCI/FZE5qTN4UinWHjrzKAh+oU1NhgwaBE8F8DlFArFcs=@vger.kernel.org, AJvYcCXbjZ5symdonmTrWeIL/0NwEhVqIIRLC0kFi32zgkxJ//AVCGSsGMJPakM+elVLMWVEJoGENKzcvw==@vger.kernel.org, AJvYcCXpp1reyxNPsU1JWMAeEAL+TJhbLuqwuCHCi/Tq+hHO7VWAiLNjqXu1QCmglNybdnQn+HarRTDA@vger.kernel.org
X-Gm-Message-State: AOJu0YzfpcozhqTO2ifEPM/4BjyjrIcPLvlswcZByH05R7N+TYrezjLP
	XDWmJdQtFICkofCOzj90mxwFj3lyBvb//+mzEDJYKhAGPTZXC6ym
X-Google-Smtp-Source: AGHT+IGM2QIH1fkpvyL5zXwnzN1P9Fzl21jQNKRhYToOjYGnjYn96eDsd7Ox+gI2AzCZSLVIBZlJbw==
X-Received: by 2002:a05:6512:281b:b0:539:dca9:19a2 with SMTP id 2adb3069b0e04-53b23e69518mr1724653e87.39.1729787968611;
        Thu, 24 Oct 2024 09:39:28 -0700 (PDT)
Received: from [192.168.42.27] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912d638fsm645929366b.18.2024.10.24.09.39.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 09:39:28 -0700 (PDT)
Message-ID: <de9ae678-258d-4f68-86e1-59d5eb4b70a4@gmail.com>
Date: Thu, 24 Oct 2024 17:40:02 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/15] net: generalise net_iov chunk owners
To: Christoph Hellwig <hch@infradead.org>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-3-dw@davidwei.uk> <ZxijxiqNGONin3IY@infradead.org>
 <264c8f95-2a69-4d49-8af6-d035fa890ef1@gmail.com>
 <ZxoSBhC6sMEbXQi8@infradead.org>
 <a6864bf1-dd88-4ae0-bc67-b88bb4c17b44@gmail.com>
 <ZxpwgLRNsrTBmJEr@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZxpwgLRNsrTBmJEr@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 17:06, Christoph Hellwig wrote:
> On Thu, Oct 24, 2024 at 03:23:06PM +0100, Pavel Begunkov wrote:
>>> That's not what this series does.  It adds the new memory_provider_ops
>>> set of hooks, with once implementation for dmabufs, and one for
>>> io_uring zero copy.
>>
>> First, it's not a _new_ abstraction over a buffer as you called it
>> before, the abstraction (net_iov) is already merged.
> 
> Umm, it is a new ops vector.

I don't understand what you mean. Callback?

>> Second, you mention devmem TCP, and it's not just a page pool with
>> "dmabufs", it's a user API to use it and other memory agnostic
>> allocation logic. And yes, dmabufs there is the least technically
>> important part. Just having a dmabuf handle solves absolutely nothing.
> 
> It solves a lot, becaue it provides a proper abstraction.

Then please go ahead and take a look at the patchset in question
and see how much of dmabuf handling is there comparing to pure
networking changes. The point that it's a new set of API and lots
of changes not related directly to dmabufs stand. dmabufs is useful
there as an abstraction there, but it's a very long stretch saying
that the series is all about it.

> 
>>> So you are precluding zero copy RX into anything but your magic
>>> io_uring buffers, and using an odd abstraction for that.
>>
>> Right io_uring zero copy RX API expects transfer to happen into io_uring
>> controlled buffers, and that's the entire idea. Buffers that are based
>> on an existing network specific abstraction, which are not restricted to
>> pages or anything specific in the long run, but the flow of which from
>> net stack to user and back is controlled by io_uring. If you worry about
>> abuse, io_uring can't even sanely initialise those buffers itself and
>> therefore asking the page pool code to do that.
> 
> No, I worry about trying to io_uring for not good reason. This

It sounds that the argument is that you just don't want any
io_uring APIs, I don't think you'd be able to help you with
that.

> pre-cludes in-kernel uses which would be extremly useful for

Uses of what? devmem TCP is merged, I'm not removing it,
and the net_iov abstraction is in there, which can be potentially
be reused by other in-kernel users if that'd even make sense.

> network storage drivers, and it precludes device memory of all
> kinds.

You can't use page pools to allocate for a storage device, it's
a network specific allocator. You can get a dmabuf around that
device's memory and zero copy into it, but there is no problem
with that. Either use devmem TCP or wait until io_uring adds
support for dmabufs, which is, again, trivial.

>> I'm even more confused how that would help. The user API has to
>> be implemented and adding a new dmabuf gives nothing, not even
>> mentioning it's not clear what semantics of that beast is
>> supposed to be.
>>
> 
> The dma-buf maintainers already explained to you last time
> that there is absolutely no need to use the dmabuf UAPI, you
> can use dma-bufs through in-kernel interfaces just fine.

You can, even though it's not needed and I don't see how
it'd be useful, but you're missing the point. A new dmabuf
implementation doesn't implement the uapi we need nor it
helps to talk to the net layer.

-- 
Pavel Begunkov

