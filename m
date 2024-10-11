Return-Path: <io-uring+bounces-3577-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B9C9997E7
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 02:33:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D54BF1C25163
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 00:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0519440C;
	Fri, 11 Oct 2024 00:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="IR4EdD05"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228F217D2
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 00:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606590; cv=none; b=N0HxlKIKLIMRJjsHq4VhJqWFOlTRbWmR56faWJA51JiQZu9zIjWYJtOVDavma/f2sY1+sX6VXpiHugii0lijweCSuk5tHpljW4OhM2qNF2PQe4gLB1534pIaJ9JxzaxMwVhzoye0shJg3lId/YnAZVP1lkgGkXRdCXKMmgqGfdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606590; c=relaxed/simple;
	bh=uCJsc3x1Wo5SSDBIG8SrjiMOurlGTbSziYI3YSHxhXc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CdU6FNXO2snzEdsNnba8NYLSI9mpdWC/GaizSg5HXcDoyWr7D9ZfVu5BK2hFCsRvB44xmxvwRutsNmK9fytkN7lZjBaOOAx2sdK20rx6orP2OsxXZydDVLzskqmgyIyDAZ4kRDQoHYjc6fD472vRZbSQL8ateoAF6bYeSWR6+00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=IR4EdD05; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20b86298710so12435835ad.1
        for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 17:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728606588; x=1729211388; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/jxj63N/X15j2xK944cy0ex/izWYNWSpB1BC7CvFvKo=;
        b=IR4EdD05tfFmkIqI0VooNFJkkUVI9wCKDXBoWJH8pz9Uuf5/mKlI1QvF6T8shNxnKo
         uG8RNAh0SHIDv3V9RwUnCgBlGAx9aLzLSAndjn+guIqSqr4R+cYej7PjDaCmDzCVhbr1
         LtwjESWzlwz5JBJmorKRzq5jsMUnzH/0/egjd44lesqlVw4EOjGcDkvMUpFxjREbA4NW
         uhqWYIPEbxRDQp5slHrnKsZfWRvwGAOB4sGRd3YGDDpBkfPl7AERGmdaIp7IcvnKXX3+
         S0HCeeNpzNIDh3HyL//k+Dk5d7lOByQJToo36BQAm26ofsq9ORitxQDUUnN0Evu5ykeq
         k4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728606588; x=1729211388;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/jxj63N/X15j2xK944cy0ex/izWYNWSpB1BC7CvFvKo=;
        b=hcHCTqCdzmA0h41mL0leyZ3lmSY+efyIA7DAG2THzhFDc5RihLuRO8fr4YwngEq7e4
         oDLDziNEq2VKKQNhjIJ6O1iL/H9I0Zl6R4fGBi/aKjvw2Q+80q0zpieM7bhI51f4s46f
         F3xdpj7nt1XdbQYdeyMYxT/xsJySq9+xWXe+VIsCWF8o8xLoe2yVvmo5c7N8ygSADQZF
         t3hmJ1Yt3nhzja49RxkHc92z1kEW9zBvazbZyYJN4FMn8Ogr5BWdtPD9HL2T4+L9I7dd
         Coc6s+r3ecjSqcDyIxgBSI0OqZwqzeJc8J5xs9AMNTgmNkE9xnpj9uUWlrsRwF2Ybar/
         OuMA==
X-Gm-Message-State: AOJu0Yz6ckkBfv+tIcfkaDKxjR52eY1ci+wI0i4mfebm+YrTLGefGmyf
	O4L/6p2dp4SSLQ/WTrOW32bXXRo1gT965QPioFum2cydW3ddmKoD+Uhsq+AL2jM=
X-Google-Smtp-Source: AGHT+IFdiWEWLlfV9mvX75Z/WC8ndRHPoEtQDKmWk0Dyr/KGR5U3zOFqCsHFmcgUAGSRP28xjaO5tA==
X-Received: by 2002:a17:903:2b07:b0:207:13a3:a896 with SMTP id d9443c01a7336-20ca1466468mr10234125ad.23.1728606588386;
        Thu, 10 Oct 2024 17:29:48 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::6:f60d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c0e7744sm14725845ad.135.2024.10.10.17.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 17:29:47 -0700 (PDT)
Message-ID: <73637a66-e7f7-4ba6-a16e-c2ccb43735d6@davidwei.uk>
Date: Thu, 10 Oct 2024 17:29:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: Mina Almasry <almasrymina@google.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 David Wei <dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
Content-Language: en-GB
From: David Wei <dw@davidwei.uk>
In-Reply-To: <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024-10-09 09:55, Mina Almasry wrote:
> On Mon, Oct 7, 2024 at 3:16 PM David Wei <dw@davidwei.uk> wrote:
>>
>> This patchset adds support for zero copy rx into userspace pages using
>> io_uring, eliminating a kernel to user copy.
>>
>> We configure a page pool that a driver uses to fill a hw rx queue to
>> hand out user pages instead of kernel pages. Any data that ends up
>> hitting this hw rx queue will thus be dma'd into userspace memory
>> directly, without needing to be bounced through kernel memory. 'Reading'
>> data out of a socket instead becomes a _notification_ mechanism, where
>> the kernel tells userspace where the data is. The overall approach is
>> similar to the devmem TCP proposal.
>>
>> This relies on hw header/data split, flow steering and RSS to ensure
>> packet headers remain in kernel memory and only desired flows hit a hw
>> rx queue configured for zero copy. Configuring this is outside of the
>> scope of this patchset.
>>
>> We share netdev core infra with devmem TCP. The main difference is that
>> io_uring is used for the uAPI and the lifetime of all objects are bound
>> to an io_uring instance.
> 
> I've been thinking about this a bit, and I hope this feedback isn't
> too late, but I think your work may be useful for users not using
> io_uring. I.e. zero copy to host memory that is not dependent on page
> aligned MSS sizing. I.e. AF_XDP zerocopy but using the TCP stack.
> 
> If we refactor things around a bit we should be able to have the
> memory tied to the RX queue similar to what AF_XDP does, and then we
> should be able to zero copy to the memory via regular sockets and via
> io_uring. This will be useful for us and other applications that would
> like to ZC similar to what you're doing here but not necessarily
> through io_uring.

Using io_uring and trying to move away from a socket based interface is
an explicit longer term goal. I see your proposal of adding a
traditional socket based API as orthogonal to what we're trying to do.
If someone is motivated enough to see this exist then they can build it
themselves.

> 
>> Data is 'read' using a new io_uring request
>> type. When done, data is returned via a new shared refill queue. A zero
>> copy page pool refills a hw rx queue from this refill queue directly. Of
>> course, the lifetime of these data buffers are managed by io_uring
>> rather than the networking stack, with different refcounting rules.
>>
>> This patchset is the first step adding basic zero copy support. We will
>> extend this iteratively with new features e.g. dynamically allocated
>> zero copy areas, THP support, dmabuf support, improved copy fallback,
>> general optimisations and more.
>>
>> In terms of netdev support, we're first targeting Broadcom bnxt. Patches
>> aren't included since Taehee Yoo has already sent a more comprehensive
>> patchset adding support in [1]. Google gve should already support this,
> 
> This is an aside, but GVE supports this via the out-of-tree patches
> I've been carrying on github. Uptsream we're working on adding the
> prerequisite page_pool support.
> 
>> and Mellanox mlx5 support is WIP pending driver changes.
>>
>> ===========
>> Performance
>> ===========
>>
>> Test setup:
>> * AMD EPYC 9454
>> * Broadcom BCM957508 200G
>> * Kernel v6.11 base [2]
>> * liburing fork [3]
>> * kperf fork [4]
>> * 4K MTU
>> * Single TCP flow
>>
>> With application thread + net rx softirq pinned to _different_ cores:
>>
>> epoll
>> 82.2 Gbps
>>
>> io_uring
>> 116.2 Gbps (+41%)
>>
>> Pinned to _same_ core:
>>
>> epoll
>> 62.6 Gbps
>>
>> io_uring
>> 80.9 Gbps (+29%)
>>
> 
> Is the 'epoll' results here and the 'io_uring' using TCP RX zerocopy
> [1]  and io_uring zerocopy respectively?
> 
> If not, I would like to see a comparison between TCP RX zerocopy and
> this new io-uring zerocopy. For Google for example we use the TCP RX
> zerocopy, I would like to see perf numbers possibly motivating us to
> move to this new thing.

No, it is comparing epoll without zero copy vs io_uring zero copy. Yes,
that's a fair request. I will add epoll with TCP_ZEROCOPY_RECEIVE to
kperf and compare.

> 
> [1] https://lwn.net/Articles/752046/
> 
> 

