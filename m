Return-Path: <io-uring+bounces-5909-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55A37A13124
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 03:12:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86FE83A5FCD
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 02:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C1AC8633A;
	Thu, 16 Jan 2025 02:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dO91kPqa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C937C78F59;
	Thu, 16 Jan 2025 02:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736993511; cv=none; b=dx8YucN6lac5CtrFBkrsb+OIHT0cR18Pxge/zCNCBaI59uO4IIalbaykGP75MuMJJnA2iFwcNr0Dgx4t/8baynfkL3gNGvANAu16q2xKtRyLX4+knduMm29axvMg7/vThNcWNl3CoegvK4v3Gx0psPdhCVHE2cv7y6dx37S8/kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736993511; c=relaxed/simple;
	bh=XtOTkQCLqhjVEqgQGgKJ2Mm3uG5b3RLNVEsIjX+s9e8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ozyhv9/bTtPNtGsxG/3jTli7E6VtPCuNtxR+puDo09psafLF+k1FuXW4s7nOnA2Axa5iSXu3VkNVh8v7PVE9/v4HdC1wwPRasxVZJt9qjvAIBnpBoY0NeIZ6NwQJqYN4xfmZxi3ayCXr/zDsbl3i5y/eFjaNvRjAX8IgLYr87/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dO91kPqa; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aa689a37dd4so91228466b.3;
        Wed, 15 Jan 2025 18:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736993508; x=1737598308; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jkvH7katoYmcfleir9sIwJAOgTTKjP2vAioHzo+e8NU=;
        b=dO91kPqaqW4jhRQo/F6NYZg0JLcFaFmSE5gfwVblfBKixSLoaDnZoZ69qCTITlnEf4
         Ke2qdMuRteBQDIVIa9Zv/ct7OKhHIsBJiWAs1QWsB2cH7t+lFZCYqoj9uNKqnFu6m3Eb
         e7dc4k0l8RidvyHhhxdp3eoeRCmNtqJfiAWt7pjBF2CcSXkHczOMstev3y2OrA83IyVl
         yvm2sXkni7CEHWHDBhtxZ/Q8tbaDj5tzdAZmI6mtR2u4CEp3xrRupUVpi9M991KWXtwp
         5UfFQNYiV4U15K3j1EeTClLlwTqAH1rveaImr+xEQJ47NFQ4tBdn5AC5DIdaX4kT0n76
         ZEZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736993508; x=1737598308;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jkvH7katoYmcfleir9sIwJAOgTTKjP2vAioHzo+e8NU=;
        b=YC0+XIyIqg9P4K/eUSWE2li1N3Kdy1kAVfSmuIqMGP1W9ZeCkbJfqmkI5OGemIn99c
         LYruu0Pc+M+mWYwV1HQyivezo55h9dEQsAcH+wmj/BP1rH222qynq5xYstJGogLRXi3A
         c7pJi4b0FokXez3jAkWTvBo6iN2G2D4b6BwlMt6pAh4lgaIWMi0tVFSZy9gA/FJgwX1M
         +co7TB2iFY8ZlM9BYxM4fIXgvF5jFsGUlXkXTGcvjtMiG6TSHsvYyezGdLlNRO9RG9X0
         tH2s8TcbLF4BFpqm6UMmZjOIO5wJgcPtu8vKT+bUXfrgiPFy0etTL/kr5IM7xtGS6Dbe
         UU4w==
X-Forwarded-Encrypted: i=1; AJvYcCVcu5L+CybO6UfP+D1DOG332aHpzFMCrbMcPg4ayjTgivD2aOQ2RS/EdzU2dGhgRSyHzKbl/FI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz00xUsmOTEUjTpRiXW8lSwJUXfkudvf6wQqS0KJl4Bfj3nSRAQ
	Ad3ko50scVuDX5NEGrbFbLX4Hkm3pTt+t0Ymhj9oo7Mn0TmZUtCYx07uNZK3
X-Gm-Gg: ASbGncsuegSUh679ZG7fR6XdQrtNsueAAz5ElBfkoRXrDohpEDD5x1VT2JSh0ZMre1f
	dSsUVb3+VrLNc1j2t5LJ6KkFIpDymyB/tH+zu3gchx5YclcJbs7XRj3OmzS0qSkfPwlzmY2taR8
	OR98RDp9YTpCcEaMOckCtBiQMkfMBU1SYBZWlnyB+XFoaB2IJ5NgPnKLaVsb5KOyXJilJTnowNp
	ofmxu1pDDl/xFWMUVWB0cw+2J+8X3RTXGCmbp4eEnZQsMS56MPxvae2ufEZqTlzpDA=
X-Google-Smtp-Source: AGHT+IEzwNmCww3lVM87eP0tWsBqC6Wa0neiTY2wdfv/wMmBbgkXwVI10qP6eE0Q1bS0pVQouUHLeA==
X-Received: by 2002:a17:907:a0cf:b0:ab2:b77e:f421 with SMTP id a640c23a62f3a-ab2b77ef683mr2751252866b.23.1736993507979;
        Wed, 15 Jan 2025 18:11:47 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c905ed3esm832976066b.33.2025.01.15.18.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 18:11:47 -0800 (PST)
Message-ID: <f65232e3-9bef-444c-8e17-2e31b2dcfe05@gmail.com>
Date: Thu, 16 Jan 2025 02:12:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v10 05/22] net: page pool: export
 page_pool_set_dma_addr_netmem()
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250108220644.3528845-1-dw@davidwei.uk>
 <20250108220644.3528845-6-dw@davidwei.uk>
 <20250115163521.273482c5@kernel.org> <20250115163927.07713dca@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250115163927.07713dca@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/25 00:39, Jakub Kicinski wrote:
> On Wed, 15 Jan 2025 16:35:21 -0800 Jakub Kicinski wrote:
>> On Wed,  8 Jan 2025 14:06:26 -0800 David Wei wrote:
>>> Export page_pool_set_dma_addr_netmem() in page_pool/helpers.h. This is
>>> needed by memory provider implementations that are outside of net/ to be
>>> able to set the dma addrs on net_iovs during alloc/free.
>>
>> Please keep helpers.h focused on the driver-facing API.
>> Maybe create a new header page_pool/private.h would be
>> sufficiently suggestive.
> 
> Or you can put it in the memory_provider one from the next patch.

ok

-- 
Pavel Begunkov


