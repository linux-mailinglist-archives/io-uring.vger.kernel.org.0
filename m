Return-Path: <io-uring+bounces-5975-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1B54A15203
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 15:41:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D22201693D8
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 14:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3D315B54A;
	Fri, 17 Jan 2025 14:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GhPUp+1i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CEB158870;
	Fri, 17 Jan 2025 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737124910; cv=none; b=plWZBaPN7iKQ6oVFb6Kqy5MnK/oyQHZ6Qefdd5z/bg381784wRFRbSnonQ0ofJ0V7xLqhp28HYnRDrO41xcxWdLpCk+5mHEweE/PP+vXE4iuqIu9KGfLUyyjSdDto9smnplet6SCRowcaZ/ZCcguGXp4QaoEltuIm/RxI9hoVT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737124910; c=relaxed/simple;
	bh=KulbyKepCLarT86VF0p05Hz+9Ji42FDc8DmOReszu0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rG72nHwa63IVpCnKs9rAe0jr02CV2XneChH4SeaU++cFVWTm+y4O97NDYuVSIvfktDdmewZ+o/5Kn23W48qWsBnwrIfh19TDCjoK1Sb2e+ILKsN014OYkM8EvTuNSYwX4HQ2ELKYxAzYg7pa0lys25VCvri8Rzfbospo0bMn2oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GhPUp+1i; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d3f57582a2so6709479a12.1;
        Fri, 17 Jan 2025 06:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737124907; x=1737729707; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SlIrXoiTLkvo9Nus/MqEtLJXMV6m2Qw67+BcTKYb0SM=;
        b=GhPUp+1imTc8sh79g5Rausaa5TJwUqARejOBJbO66qlSKUd1CzlEBVAwiPY80wg8oW
         ru9ShhmnstRD4Q9vrXYkpnvmFGbRu1eF4ECdIQwM36Zcgqi3gB6VNhWqs9/ll1IU/UyX
         R+kOistLZDRh38tM6Kt9AFAkvj/VwIdkxbEAGLQd6rM7oIQT94m9S7yOUJ+WD1nSHdcm
         FZfFTeGr0DRV8G3M2z3dwR+ZL/ARL74db70TfuWQCBm+U6K4PGL9rkbIINQvPNkQh7bu
         e/3AINOzCq4Y1Y1hHh83fJKjBSQtZKbp9/NhnI9X7PQP3xchwr/bhujbi4aabpKjTQC6
         UEHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737124907; x=1737729707;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SlIrXoiTLkvo9Nus/MqEtLJXMV6m2Qw67+BcTKYb0SM=;
        b=eltPa/6+RNjTqlZQfM2b3Ctw7zifFGITvrmtaNWBdUyC0UGparFrvC9ZBPJz9kaIJR
         kZeEPAzU3ab2TgPfp+8y4NX7EPxs5Lms4ne0xWPEXizalpxZmpPJfv7HQxPF9zfwvAiF
         nrvdqHxJ6tEXP6Dxt1JNEHPH50RizAZSSDlfIyo61d8ir83T9rYXTS5jgle9uj4NakZN
         l9NAZn4xP/42Sv9XOBZg+CGYCWQIRepBGzCExgOcs2t7H5UYnU/2wmUldG3IAsUybKIS
         NBfI97iZWLZUW10jFGqyFqBPQ29D9qvV6pknHKb2/Aq3bzzCD+HYTpW4CvhYOprExx9J
         +EWA==
X-Forwarded-Encrypted: i=1; AJvYcCUd2xH1XZTJkmqNDmJRpOSGRmpoEzPq9E647aEhL4uGtWBo2K3VrsBHCRdak1CaAwaMRbtFlHBC0Q==@vger.kernel.org, AJvYcCWERBWDhDArT6YnXCkYvvfcGStWUecAkcV7SEAuk8zxUiYxBm1T7DuYJX616v6nUXvkIFGCIJ9M@vger.kernel.org
X-Gm-Message-State: AOJu0YwLkPcV+b8Yfg38it8dGRh5FmHVzTAVU9uHQ6ge5WyuxYxvCXEu
	gkNjPqV7SM8lSTqRRdGKLtQotX6Us/QrFAGgKeMl6hRvfxrIW0LS
X-Gm-Gg: ASbGnctTh/ge8FsimFvibicGM/VpJMcpuo3ftLdLNAYMAw/+9TRCg/JV4JfG3S0M4cb
	pLLkL23+ktC5RFM41YShnXzIyF1o9f1yBPTCit+YepZziJsEzm6AnhTTqzfSO4/nzrl8TWkLj38
	olepLlmRldvG02Dzt4fWoLJrzd0ylJ4M1VmghNcVMSKaLaBgYJwrvjNHuUz91Rdk/0tyfQ/bJfo
	nfnzHRm0Ycreuxkt2safShuhBOJRMTv7YCozz1GX5wiSWDLXSC/BIZ3nK3y3ihfR4zpS9oPn97F
	UNcc8kXKqbis9w==
X-Google-Smtp-Source: AGHT+IGU7cGVURZupnicsSIbvcjzO+/TIyUDWVQxCWRsL6hpsQdaOOKWB2PBo6tet8TufvFjdRsbgA==
X-Received: by 2002:a17:907:1c96:b0:aa6:88a2:cfbd with SMTP id a640c23a62f3a-ab38cd63a57mr269238266b.22.1737124906745;
        Fri, 17 Jan 2025 06:41:46 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f8d86esm181107366b.154.2025.01.17.06.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 06:41:46 -0800 (PST)
Message-ID: <ce9caef4-0d95-4e81-bdb8-536236377f81@gmail.com>
Date: Fri, 17 Jan 2025 14:42:30 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v11 00/21] io_uring zero copy rx
To: Paolo Abeni <pabeni@redhat.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250116231704.2402455-1-dw@davidwei.uk>
 <406fcbd2-55af-4919-abee-7cd80fb449d3@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <406fcbd2-55af-4919-abee-7cd80fb449d3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/25 14:28, Paolo Abeni wrote:
> On 1/17/25 12:16 AM, David Wei wrote:
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
>> to an io_uring instance. Data is 'read' using a new io_uring request
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
>> and Mellanox mlx5 support is WIP pending driver changes.
>>
>> ===========
>> Performance
>> ===========
>>
>> Note: Comparison with epoll + TCP_ZEROCOPY_RECEIVE isn't done yet.
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
>> +-------------------------------+
>> | epoll     | io_uring          |
>> |-----------|-------------------|
>> | 82.2 Gbps | 116.2 Gbps (+41%) |
>> +-------------------------------+
>>
>> Pinned to _same_ core:
>>
>> +-------------------------------+
>> | epoll     | io_uring          |
>> |-----------|-------------------|
>> | 62.6 Gbps | 80.9 Gbps (+29%)  |
>> +-------------------------------+
>>
>> =====
>> Links
>> =====
>>
>> Broadcom bnxt support:
>> [1]: https://lore.kernel.org/netdev/20241003160620.1521626-8-ap420073@gmail.com/
>>
>> Linux kernel branch:
>> [2]: https://github.com/spikeh/linux.git zcrx/v9
>>
>> liburing for testing:
>> [3]: https://github.com/isilence/liburing.git zcrx/next
>>
>> kperf for testing:
>> [4]: https://git.kernel.dk/kperf.git
> 
> We are getting very close to the merge window. In order to get this
> series merged before such deadline the point raised by Jakub on this
> version must me resolved, the next iteration should land to the ML
> before the end of the current working day and the series must apply
> cleanly to net-next, so that it can be processed by our CI.

Sounds good, thanks Paolo.

Since the merging is not trivial, I'll send a PR for the net/
patches instead of reposting the entire thing, if that sounds right
to you. The rest will be handled on the io_uring side.

-- 
Pavel Begunkov


