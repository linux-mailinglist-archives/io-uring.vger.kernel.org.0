Return-Path: <io-uring+bounces-8980-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05989B282F7
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 17:32:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D450F169237
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 15:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1819821C194;
	Fri, 15 Aug 2025 15:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1LTMd4A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932882AD13;
	Fri, 15 Aug 2025 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755271869; cv=none; b=Qtr9WU7wCGC9MZpqeY8UdSz2t93Tk0wCSDGzlQMvIKqjoY1OVoRdk1LLaIq6VGYT4Q2vjJ1I+2x7pokHUWsf45z/L/I2FeOvw+wQ2Q+x443f+P215OHaW9EG0Pl4V5r49Zn+CsjYvlaolUnmf1+EFZSCfpgs2UoFCjIqgfuCezQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755271869; c=relaxed/simple;
	bh=IRqI8fHDMdsh55e0Tx0NBB8lE6UkIbtfrdJC3dNGRJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TA3YwY87mkYxiLWmP01EAheJ+eQ+vIW2GlUvUHDES0IdPqrR3xB39Uya7Xcxsm1fUqafnO0xeT1ZSG9LYfDmJiXh6Nf19K+2DxPlTVkm1UizaJecqfCEAUKPuxbqIOBeH8Ye5QIxuC0/Fi4QnGZSE6uKiHxT6c3V/LJr/OKDLU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1LTMd4A; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-24458242b33so19880725ad.3;
        Fri, 15 Aug 2025 08:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755271867; x=1755876667; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NSt0o4DAYQoZCN08JDMbTQeP9CBWq8tSRkUO5qbJiM8=;
        b=V1LTMd4AUo/6uEDuSOR7DdqYPYBc46Dx5DRMaBCRBSrC/UxTvmzCa7C06wb0AspC5j
         8x57o2WIAhurSOvT32DKoLlDXwI2ThRku9THBpgj7lUtPQS/KiOFdPqx2P9z+cxrUK7I
         WT9UiUXoHp+cKtozCISb0aLj2ZtJ7md+dLmSzT1f2+VnbGiboh9/yWORX7/AaqbG2lIz
         huz5m5xeIae6/qNfgAvyhQ4k5PaWPhIDwT1Ml5Z4WG/Oo3+0s1Ze+dytpEKQbNohOWhe
         JsQoDaXUBjMeOzyFGJfNJqb/JfDiNei2pPaE9YxbueMt61/SdDA/ZcWM0TezRC9AHhXa
         eiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755271867; x=1755876667;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NSt0o4DAYQoZCN08JDMbTQeP9CBWq8tSRkUO5qbJiM8=;
        b=vLN3IJrDrke6OMKgFkkzIwmN/Ef7duN2H6i0FxvU2TxFJFSBt38MjwiRRMEsJd9Lol
         Ivvu/w6ZX3j3y9hyh8VJOVE9NvM7hi2MrK+8LNlD/2YSvtRS/fpcvY219PAMmTKIwAN9
         1L8MXP4iWoidOEv2nKrKW+/GsPwlAid7fTRWaXBxSqBRnUAtINWxJiPaB82M9cloNOw0
         7v47sXFwoCKShyQKyLcrYuK7xHodSeOPV3jcVuqkIPTpwqoIHIDif+1mXjGhmW35g/MK
         oOAeCAXJ9dhtgNROYWJxxjVLByUMMnRJikfdyX3holrLqg/pYk45gOBLrncUERn2aId1
         3euA==
X-Forwarded-Encrypted: i=1; AJvYcCUaqpw/YVPxGM4dXaH3KfnWsEMfDYsA3cHGIyosrdhoQPOlFieihgpV0o2fCUQVrxNzk8qwJ2h5WKKrrtPf@vger.kernel.org, AJvYcCV9b3KNOoXklQGYNns2B1pk+ufKpOutXDW3ZEuWYR6k5NNrz8ZeNiRASNSJRQxUEjo9BAb9ZcKtpg==@vger.kernel.org, AJvYcCXhacvJFWZsHm6vHG+pxhIe6xaACaWvk5TTE42nbG/gvuXrJhEp/VyXIKF3yPcDOGDC2hGhgN1i@vger.kernel.org, AJvYcCXj4YKCsSbW4QFxyE9js/3ibcnJu84iZArrAR4nDMZP8gWO4fseNl+7PGUA4nMswv6wwqHks3PKKuL+MQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyhMu5Nmwb1VW2/9o0rmV0H0q98XDP5t+ibeVF4iDoh0vivp6hy
	ysa9/6tcm1aEEOIELdSVAnbgllMC3yioFXd8eE4ie+9mIGPRTUpjt40=
X-Gm-Gg: ASbGncvIGugJLXt49RGp9O6MXaasZUAaab3anW87gHwwhJ5rMg33tlayKVWEq57AX9z
	CTafbEdEaDMrYOocif4dZ3oYt7CDwuBadD2RsOx0x3X6MNyz3ljORRlcTUK5TIxNEUr1mpFJbYh
	HS298u6T7b8sh8ZUhvjT9UwXrs9LTGh4QrywOSMRLqV1C428uuB3OAIpswHq7uDtsnL2ZWZEfYV
	CGb2idBPQkxhFSCnOBR24am1lQWidIDpBK1WLmMpTq4pRdDjtjd67hOjHww9vT7kOha+Mk7s1kJ
	uPp/ITFvyTqVGfZwvg9gtfe7mRFB8SHpQTCDFYj8Qaz2bB5jmTXKRk41SCwFu7ql9GA/tR29zKI
	BAt+hng00U9PT979/WwaCzQn5j7ICQMutwX9wUWBIKkJX3hthO4WwA0+1x2U=
X-Google-Smtp-Source: AGHT+IFuIiW/HvU2DvdjMihkEix7W9hPl4GUhJNG8esujMO8U+GyUJ45blWSl0KpxoQv2EfYq5Npmw==
X-Received: by 2002:a17:903:37c7:b0:23f:ed09:f7b with SMTP id d9443c01a7336-2446d95078amr40125455ad.48.1755271866678;
        Fri, 15 Aug 2025 08:31:06 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-2446cb0dd5bsm16573385ad.63.2025.08.15.08.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 08:31:06 -0700 (PDT)
Date: Fri, 15 Aug 2025 08:31:05 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: almasrymina@google.com, asml.silence@gmail.com,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>, cratiu@nvidia.com,
	parav@nvidia.com, Christoph Hellwig <hch@infradead.org>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [RFC net-next v3 0/7] devmem/io_uring: allow more flexibility
 for ZC DMA devices
Message-ID: <aJ9SuemoS6n0GIBs@mini-arch>
References: <20250815110401.2254214-2-dtatulea@nvidia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250815110401.2254214-2-dtatulea@nvidia.com>

On 08/15, Dragos Tatulea wrote:
> For TCP zerocopy rx (io_uring, devmem), there is an assumption that the
> parent device can do DMA. However that is not always the case:
> - Scalable Function netdevs [1] have the DMA device in the grandparent.
> - For Multi-PF netdevs [2] queues can be associated to different DMA
>   devices.
> 
> The series adds an API for getting the DMA device for a netdev queue.
> Drivers that have special requirements can implement the newly added
> queue management op. Otherwise the parent will still be used as before.
> 
> This series continues with switching to this API for io_uring zcrx and
> devmem and adds a ndo_queue_dma_dev op for mlx5.
> 
> The last part of the series changes devmem rx bind to get the DMA device
> per queue and blocks the case when multiple queues use different DMA
> devices. The tx bind is left as is.
> 
> [1] Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
> [2] Documentation/networking/multi-pf-netdev.rst
> 
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> 
> ----
> Changes sice v2 [3]:
> - Downgraded to RFC status until consensus is reached.
> - Implemented more generic approach as discussed during
>   v2 review.
> - Refactor devmem to get DMA device for multiple rx queues for
>   multi PF netdev support.
> - Renamed series with a more generic name.
> 
> Changes since v1 [2]:
> - Dropped the Fixes tag.
> - Added more documentation as requeseted.
> - Renamed the patch title to better reflect its purpose.
> 
> Changes since RFC [1]:
> - Upgraded from RFC status.
> - Dropped driver specific bits for generic solution.
> - Implemented single patch as a fix as requested in RFC.
> - Handling of multi-PF netdevs will be handled in a subsequent patch
>   series.
> 
> [1] RFC: https://lore.kernel.org/all/20250702172433.1738947-2-dtatulea@nvidia.com/
> [2]  v1: https://lore.kernel.org/all/20250709124059.516095-2-dtatulea@nvidia.com/
> [3]  v2: https://lore.kernel.org/all/20250711092634.2733340-2-dtatulea@nvidia.com/
> ---
> Dragos Tatulea (7):
>   queue_api: add support for fetching per queue DMA dev

[..]

>   io_uring/zcrx: add support for custom DMA devices

Did something happen to 2/7? I don't see it in my mailbox and in the
lore..

