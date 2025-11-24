Return-Path: <io-uring+bounces-10754-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A5480C80355
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 12:30:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4DE893413BC
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 11:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A002FD7D6;
	Mon, 24 Nov 2025 11:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="il6R7Iw0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C892FC88B
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 11:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763983811; cv=none; b=oWnbmO0iawwKIjJkSqYMzTK2lxY0PApY4ho8VLPmPP+FqMT1sX0keohfaCO31nvNhTjW3Bi50WAuy/noqVly45GRkOE22LrpIGaY369L6jzA11YMHOa9NVHG3V0N6AvU/B2bZ7wUCCRHzc71pmwvUsj8zoVb46zi/G0xWX5T8TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763983811; c=relaxed/simple;
	bh=B6c4Rha0j7ElsnG2lldQikR/5+CIYYmoxpK8FQj5Yvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EmqGZKEghMw9i23WlOKBDL4WGojTRPqo5zePmKwSwev49sYPaS9t10LhgSRm/dfyueAOQqpX6oe45JZP3ocOjPZo/Yc97hdnmhl9Ya91CxvguBVEO/FAjNB45gJem7eQBkKLooX93mrmA/10Hd7ftAhaigEEkxVMDNQGbZWpuPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=il6R7Iw0; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477563e28a3so28322525e9.1
        for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 03:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763983807; x=1764588607; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FIrNcMo3OIORc59oYq11M7V6LWyQ4cuR88/fqcwGDYI=;
        b=il6R7Iw0Zo1ugXnoYsdVIa5PeY3EJutXCTy2qfnvp4Y7P2EQaxAPQNlUyCU0FyzPqe
         qm1ddhlRIFGey1mqV/PAIwD9VD/1g5IEJJ2OY1y5Ed0DK1pDpmExF3t8Vn9fCCBycxe9
         8ca3bOUEE6aoiCx9FqOnGExGunEML1XTgoh45CY63zrHfd5um4HOLxJOVeq18JLYPFoA
         53MmubmKqyTHbsD/C9g0a1H3ddxQPmgfAxvPwj3s3UFGSJf89teXvj7IcKzYm4wPC/1K
         DiT/AUWvhSB5yE0FY9Md+O2f0EUfipJgMj6Vp77foFQb9lizcNMx+S3hyanevFJg5kSb
         uIeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763983807; x=1764588607;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FIrNcMo3OIORc59oYq11M7V6LWyQ4cuR88/fqcwGDYI=;
        b=UbSdG5QraMIL9PyI3Hn0oui2Wj7+is/uHwU/hYpD7qUIONNxLe6oCBz/l7bN3mdkSZ
         RI0nVC0AVKdSbKNNvnnUVOCZs6188XwCe5puwgx3Mbl4rqtjXn1dSy2EqlPVPuXKgL6K
         0c8EQgkncozQW8d2NMkj+biaVd9pc6BM9nsMsjAdUodF4duxT4/MsEqdC2EwPTfFZ4x9
         vuOooyHCARo9B17vtny1XoEO1HDD30hhgOZO9TXT9KGdlLrVHsSOdNVCji5Ri0gjEeSJ
         MUirxRPDCtl5qosZmvQ97oLgt6vkCE6Mo0GFHfnzHPLJAY+7qO5Vp4JJSWseBdtqR/ES
         y4iQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmksi3i+FHur6MdfdJFdlHBact5lyDwCJknNpbZHzh65iaRf+DQwUQyMtHwOW2tuM0/10bSYBOVA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8jSuuCvmxGB8ya91rHm9vLhFAME8ncEcklFyCRhqHSKjaRAC6
	Zzl53tS9Kd5Z4OIisJHjbagxlxGeFMlJabiMxngBFhDyQZ+3Izvox3fl
X-Gm-Gg: ASbGncuEi3zK4l+FbZUM3G/OA1j3IymDMv2U7x10LacFMBBSih2dlFlPHekP2YE7LX2
	QIUFlKYJsk8OyO6SZBUN3G/bVJJjR19cKd2DddQBEQgB9ycn9aJq1OREocwsOONRbQJu7TaSQio
	5RYnhoyIma+vdyY+v0+D0mjo7WQzwrvd9WEdLZTUnd3rwft/JdETVoGU5zXM9ATzmTth5OENn7y
	I+vu1LR8i4Hj0q95izlLopfnZwV7BGDHlqUfTLUJAgE8vrQdJ+WDeQcgy4BkdqU7bJ/fpBIbzrD
	GDPEZ48AdoyuHR4c7aNt7N8CeF2GbZWCcKAGhOAeUpjrhNLGr1XVhOQeL4euTX9eGuPva43yfrq
	Wg1suAqMML0zcjMPM1DHSetxNVIcKWSliiXIzXfQRprAH8adb0r/NyPEHErS/yb1vnLNTeVakr/
	B90ISIIkZQ64hEDzx4GMdZ/Nw4DiPnUvB9dgEAcnL8DdqScECcWdPa+HWoDVSLlrU+rzothpPp
X-Google-Smtp-Source: AGHT+IH4rhfkRALzBtaC9gdxzf7gjncNKNUbJLJsQNk7iBQd1pjAZr0TQJP790c1nQt2gF0ktavqUA==
X-Received: by 2002:a05:600c:1d14:b0:477:9d88:2da6 with SMTP id 5b1f17b1804b1-477c026ed62mr113061345e9.0.1763983807185;
        Mon, 24 Nov 2025 03:30:07 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e432sm27351895f8f.9.2025.11.24.03.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 03:30:06 -0800 (PST)
Message-ID: <905ff009-0e02-4a5b-aa8d-236bfc1a404e@gmail.com>
Date: Mon, 24 Nov 2025 11:30:01 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 00/11] Add dmabuf read/write via io_uring
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
References: <cover.1763725387.git.asml.silence@gmail.com>
 <fd10fe48-f278-4ed0-b96b-c4f5a91b7f95@amd.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fd10fe48-f278-4ed0-b96b-c4f5a91b7f95@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/24/25 10:33, Christian König wrote:
> On 11/23/25 23:51, Pavel Begunkov wrote:
>> Picking up the work on supporting dmabuf in the read/write path.
> 
> IIRC that work was completely stopped because it violated core dma_fence and DMA-buf rules and after some private discussion was considered not doable in general.
> 
> Or am I mixing something up here?

The time gap is purely due to me being busy. I wasn't CC'ed to those private
discussions you mentioned, but the v1 feedback was to use dynamic attachments
and avoid passing dma address arrays directly.

https://lore.kernel.org/all/cover.1751035820.git.asml.silence@gmail.com/

I'm lost on what part is not doable. Can you elaborate on the core
dma-fence dma-buf rules?

> Since I don't see any dma_fence implementation at all that might actually be the case.

See Patch 5, struct blk_mq_dma_fence. It's used in the move_notify
callback and is signaled when all inflight IO using the current
mapping are complete. All new IO requests will try to recreate the
mapping, and hence potentially wait with dma_resv_wait_timeout().

> On the other hand we have direct I/O from DMA-buf working for quite a while, just not upstream and without io_uring support.

Have any reference?

-- 
Pavel Begunkov


