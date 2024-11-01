Return-Path: <io-uring+bounces-4325-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F0379B97A1
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 19:35:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B22841F21BEB
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 18:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A321149E17;
	Fri,  1 Nov 2024 18:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OKKuk5q0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72884146592;
	Fri,  1 Nov 2024 18:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730486095; cv=none; b=GHLprIvxwmCGuqwLXnF4+lhQUQSFnRiOoI+33CNncM/h/ovE7tuyHtYjMLtdxuCCVJwSBzq+E96ckk/kdkCUiAVqrSvmy8g1ajtoTXZeMd50XM1N+ENwkCmu2MFV0cDI81Qa5NP2+16K/6Vs09dwsO1FwaU9V9wSAwB8F92JuDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730486095; c=relaxed/simple;
	bh=pvZNLwJanWTI0a7jl9Z+5tB8L7uxCtvjaPGJLpse8C8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ab0zHyffuvUXgg2mjPdlK4qehf0W3Cx21adNAlQ48F69AU5kyVM6fLKBXKkoRAvpjVc+rYAR7vVGmbaU/dhBZAq2GR7g3kBWpJGnEvaYA8S+KEkPiF/kPCbaI56nFRbHIRC4f269CbwCU2WjJJG4eE33IcoaYd6CGvT7ZQASKU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OKKuk5q0; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-431ac30d379so18068495e9.1;
        Fri, 01 Nov 2024 11:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730486092; x=1731090892; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d9cLb+8Zm1EPG1j/QzKgAtizsAeVkXYPF6j5dQdjilE=;
        b=OKKuk5q0MqM9ZaFUuTXysNcStthJtqgFM2zwA+dOpsMxpRIWChfNheeu3FcY19wDYH
         J+71MJhFQbRcJM7ncOujf+fTs/ljq3+YpfCIY++twfd9ax23KtaicMOnn9nfNsQrHcNH
         W6x2E0UVoh74NBm1nWCYAnAj2swFRU7mev9vyTlZCh7xwKunG+32qn+KJEE8ecaeSWB6
         0t7T3EPhUJJTHjtOqYr1RJR6jwXk7w/vlsD1fK6Fj/vism4TVGQqfTm165GYXVUCPVSv
         JKMXmWT3/uSd6veyO17JXLOtcrbluBONNr9WS5J84G7fJuCUekWLfPZpL7o9LG1NEDkj
         T/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730486092; x=1731090892;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d9cLb+8Zm1EPG1j/QzKgAtizsAeVkXYPF6j5dQdjilE=;
        b=ZbjlyMDK0ulvvbo/fm7kjJtZYPP3/HOkmY3Mndi4kSe2+nrMYD65JlOeQesdZQtLNe
         lmo6XCuq7pxT8pb09lSHhacB6/1MvY3H5firzEfKwBoQ9gvox8mRMxe5glAcVuSPlZLJ
         cl6sbCV0qiuQktvSBwNiPtbJCOMDTNSZZWH6byKPHCj0JgjTu9ol8xEzeGY6tiY/AHyK
         TWF1s02wGbQWjKzTSsm1FWkQHwZwrRcJBvDFBRKe18q+CC3UBV4FBLXnGxfqsNTdia4J
         gTVYXOcuqQ2TJxSXq5/qtjBJ4BPDZmgL6cbVsLGWgZHEpJ4k9mDVDT4XltfHsC9EXPg6
         JJSA==
X-Forwarded-Encrypted: i=1; AJvYcCVGATGy7n20kR41x+wXfd+CnfPW6M7yWgKUJKITMmIJinlI6UgsQhA1rveVNSm/34QaFV4TJa16@vger.kernel.org, AJvYcCVWvYhUlzlSLU66GNyf70EyxJl3AXTrDZ2B4cVgMoi9LYlJlRkl0HQ34t+FvN6mduOWKZWXMt1Sjw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk4cri9V/QYBE6Sf3u3kDrcFQVsXfTnU89EP70ABe9BNJJCNa+
	XCq1wXEVr6WT9f3s97AmOxQDcLKnQlC3qdKOerLoMDCDHSYyZECw
X-Google-Smtp-Source: AGHT+IGC+FvAuRg8+cYw8X0e4pOWmDIWdE/keKH+JUsyXR+jxupy6lLECmY7WXTzDyd+XrfzCZWq/w==
X-Received: by 2002:a05:600c:1d84:b0:42c:ba1f:5482 with SMTP id 5b1f17b1804b1-4319ad36a7amr182918275e9.35.1730486091446;
        Fri, 01 Nov 2024 11:34:51 -0700 (PDT)
Received: from [192.168.42.19] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4327d5e8562sm70553705e9.23.2024.11.01.11.34.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 11:34:51 -0700 (PDT)
Message-ID: <58046d4d-4dff-42c2-ae89-a69c2b43e295@gmail.com>
Date: Fri, 1 Nov 2024 18:35:02 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/15] net: page_pool: add ->scrub mem provider
 callback
To: Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-7-dw@davidwei.uk>
 <CAHS8izPFp_Q1OngcwZDQeo=YD+nnA9vyVqhuaT--+uREEkfujQ@mail.gmail.com>
 <9f1897b3-0cea-4822-8e33-a4cab278b2ac@gmail.com>
 <CAHS8izOxsLc82jX=b3cwEctASerQabKR=Kqqio2Rs7hVkDHL4A@mail.gmail.com>
 <5d7925ed-91bf-4c78-8b70-598ae9ab3885@davidwei.uk>
 <CAHS8izNt8pfBwGnRNWphN4vJJ=1yJX=++-RmGVHrVOvy59=13Q@mail.gmail.com>
 <6acf95a6-2ddc-4eee-a6e1-257ac8d41285@gmail.com>
 <CAHS8izNXOSGCAT6zvwTOpW7uomuA5L7EwuVD75gyeh2pmqyE2w@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izNXOSGCAT6zvwTOpW7uomuA5L7EwuVD75gyeh2pmqyE2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/1/24 17:18, Mina Almasry wrote:
> On Wed, Oct 16, 2024 at 10:42 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>>> The critical point is as I said above, if you free the memory only
>>> when the pp is destroyed, then the memory lives from 1 io_uring ZC
>>> instance to the next. The next instance will see a reduced address
>>> space because the previously destroyed io_uring ZC connection did not
>>> free the memory. You could have users in production opening thousands
>>> of io_uring ZC connections between rxq resets, and not cleaning up
>>> those connections. In that case I think eventually they'll run out of
>>> memory as the memory leaks until it's cleaned up with a pp destroy
>>> (driver reset?).
>>
>> Not sure what giving memory from one io_uring zc instance to
>> another means. And it's perfectly valid to receive a buffer, close
>> the socket and only after use the data, it logically belongs to
>> the user, not the socket. It's only bound to io_uring zcrx/queue
>> object for clean up purposes if io_uring goes down, it's different
>> from devmem TCP.
>>
> 
> (responding here because I'm looking at the latest iteration after
> vacation, but the discussion is here)
> 
> Huh, interesting. For devmem TCP we bind a region of memory to the
> queue once, and after that we can create N connections all reusing the
> same memory region. Is that not the case for io_uring? There are no

Hmm, I think we already discussed the same question before. Yes, it
does indeed support arbitrary number of connections. For what I was
saying above, the devmem TCP analogy would be attaching buffers to the
netlink socket instead of a tcp socket (that new xarray you added) when
you give it to user space. Then, you can close the connection after a
receive and the buffer you've got would still be alive.

That's pretty intuitive as well, with normal receives the kernel
doesn't nuke the buffer you got data into from a normal recv(2) just
because the connection got closed.

> docs or selftest with the series to show sample code using this, but

There should be a good bunch of tests in liburing if you follow
links in the cover letter, as well as added support to some
benchmark tools, kperf and netbench. Also, as mentioned, need to
add a simpler example to liburing, not sure why it was removed.
There will also be man pages, that's better to be done after
merging it since things could change.


> the cover letter mentions that RSS + flow steering needs to be
> configured for io ZC to work. The configuration of flow steering
> implies that the user is responsible for initiating the connection. If
> the user is initiating 1 connection then they can initiate many
> without reconfiguring the memory binding, right?

Right

> When the user initiates the second connection, any pages not cleaned
> up from the previous connection (because we're waiting for the scrub
> callback to be hit), will be occupied when they should not be, right?

I'm not sure what you mean, but seems like the question comes from
the assumptions that it supports only one connection at a time,
which is not the case.

-- 
Pavel Begunkov

