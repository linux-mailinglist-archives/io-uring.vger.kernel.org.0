Return-Path: <io-uring+bounces-3487-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C733399705C
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:03:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D88F1F23A51
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 16:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C61D1F8932;
	Wed,  9 Oct 2024 15:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="scrB/xaS"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FF61CDFDA;
	Wed,  9 Oct 2024 15:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728488308; cv=none; b=t41fVsWaUWZeUdps1ODbJP4qSA1hgvobIDNxxqrFdP8FZqxKXB8G6wY9zE4sSjg6Q8+oclxULg/e0xpcJzp/3MDElKltEobF3SLUxDL8OzHjSzvAnhsHM7+kYC8740+WbGAtLbxTozxakmoU94cDnDYROe0JmJ9N3LN1r2alDz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728488308; c=relaxed/simple;
	bh=pSIRYcOq7yuk3LxFM9v+gjRbmOVzzh+hWTfM13SBCvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WUoE9F/FbGi5l/J0gJw+TXvx3U5UuZjvIOdQkcUcPhA2K593X+A16YW2/HrXKaXV4NIoevuNyWKKud3t4BsEa1jSLpnt3iMYHZKoyXHP0KzPOn4Vw6+HFa9vNsONH18BrUo4FUzVzjRF3L8itbEvl0Ra8LG+TkJGGgFBXAGpu4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=scrB/xaS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D369C4CEC3;
	Wed,  9 Oct 2024 15:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728488305;
	bh=pSIRYcOq7yuk3LxFM9v+gjRbmOVzzh+hWTfM13SBCvg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=scrB/xaSqfCMnWUDx+l/7CcXx7ny4t+zJZiru+MJtQNagcmjhH/dRsUM996KRs0NE
	 O3y/keEKl1vwUJLD93ijV8SqrWv0Gi4M2BNh2xQpVI5fBr+DPhq4XuXU6hOBCRuF65
	 3wwb8gSoKpUzsqfhU9EfBUtVznZNDloJMrEJ7uvdnP3rkAnvUg7yW7Rmu8sGkU6J8d
	 0VDLj+poT+9PPOyOWKaMbacUloShUShPE115oEiU4glXngIftIU+xUbLq5SDE9IxC1
	 K515+W2ydPeEucy9xxMwpdXv+W2GR1ypEICHTfn2faCjDzENS+gC7CM/RJXTIQ88jm
	 97IoAfDRqXsiQ==
Message-ID: <93036b67-018a-44fb-8d12-7328c58be3c4@kernel.org>
Date: Wed, 9 Oct 2024 09:38:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <2e475d9f-8d39-43f4-adc5-501897c951a8@kernel.dk>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <2e475d9f-8d39-43f4-adc5-501897c951a8@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 9:27 AM, Jens Axboe wrote:
> On 10/7/24 4:15 PM, David Wei wrote:
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
> 
> I'll review the io_uring bits in detail, but I did take a quick look and
> overall it looks really nice.
> 
> I decided to give this a spin, as I noticed that Broadcom now has a
> 230.x firmware release out that supports this. Hence no dependencies on
> that anymore, outside of some pain getting the fw updated. Here are my
> test setup details:
> 
> Receiver:
> AMD EPYC 9754 (recei
> Broadcom P2100G
> -git + this series + the bnxt series referenced
> 
> Sender:
> Intel(R) Xeon(R) Platinum 8458P
> Broadcom P2100G
> -git
> 
> Test:
> kperf with David's patches to support io_uring zc. Eg single flow TCP,
> just testing bandwidth. A single cpu/thread being used on both the
> receiver and sender side.
> 
> non-zc
> 60.9 Gbps
> 
> io_uring + zc
> 97.1 Gbps

so line rate? Did you look at whether there is cpu to spare? meaning it
will report higher speeds with a 200G setup?


