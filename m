Return-Path: <io-uring+bounces-3090-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23997970A75
	for <lists+io-uring@lfdr.de>; Mon,  9 Sep 2024 00:26:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5FAF2819A1
	for <lists+io-uring@lfdr.de>; Sun,  8 Sep 2024 22:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307BF14B96D;
	Sun,  8 Sep 2024 22:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ys9BY4lB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A3D14AD0E
	for <io-uring@vger.kernel.org>; Sun,  8 Sep 2024 22:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725834363; cv=none; b=DJuRP7G93CX0yOtAm0DDO0Uiung8BmPBbs8U2KWP7Hjw1tfEK03hTm+kxlL0w83F6nZqXzTpeUmxqrnHMhIPPkaaXMgQirdalFBrwJqnZ3YHCh4J8s4kjtk93BI4it8EklcCDmTvcccLxixKds8oHjDqTtqoSMKtNmnOdWOWbGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725834363; c=relaxed/simple;
	bh=WmpeAAzT0TjzN64zX3hckcbNTMWj+Us84tfUUkHbKn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hHHTzDTtfHyGujNVnwGBNMtfLOo8Mgef96bjdWeC/ZadQ1mT9EwS/vKWpnGpGLW96p3YD4n8vNNSx/KJL069qUlzJ5863xdksvNpYW/58r0Lod9bAeQ/9uuLmDZLFkju3mBfAegqCHHKlVIEBZtR0hBvbZTnLF08sZxYbM/GZ48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ys9BY4lB; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2daaa9706a9so2872425a91.1
        for <io-uring@vger.kernel.org>; Sun, 08 Sep 2024 15:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725834358; x=1726439158; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nhheKD2MaWmX7ObGYzIUVDmcL/vXif7CCP5OFRo31ag=;
        b=Ys9BY4lB5zHXyCVGjrUix4hM76iemo7BaEtFkHC2c+CPURV6hplNoqBvpBGRGlaFHn
         mDFooUus31D/tMGTTijCIU2k9eB577UqW3y8pK40vCerC2PlrtA+iQV0oUmnBJlVLlRq
         ABL7LsJe9jqvPfeT83xK+BDQs8Sjz4rtGsCijB0wn0TfrfD+We6qmgEY9uIwWcghjTzU
         MgTCWL/ixgM7H1v7AXGLru3dI9iRTnOZS6vXYHXTA/i0FEJrkcCBDsmgwkbMtCjJ4SbR
         +I4SQ7CEBYbrb9kB4hesiV9CgPq+/4+6bv+4fQU8dCn66MmTJQaAHMk01b+kYUwTJoht
         IIgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725834358; x=1726439158;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nhheKD2MaWmX7ObGYzIUVDmcL/vXif7CCP5OFRo31ag=;
        b=pwVYc4crF6Pz2FpEgeVuZFi6sysfYmBFs+eDXBBXjeygAb1EKU1DJhIOGM/Ntuxnje
         qBFTaZKsBGxT9eJd1In1rNUeemNoeG61TnOCTcXwA/4Hz1ZK3kIi2+3oqpXqpJW/IXxO
         wKab/HmUtj9AoqEWQV14ylTEncw5XaKxu1ecXHUcchBVnS/iLmlAhY7RfnbfG8+o3UG4
         Gw9tsE1GZJOJBq9K4dYhsR7Gqg6S5BZosZHxHyXiaslu6xszF8PJsf5SmT13smgnh0Eg
         Iz7X32Wrh/DWIDh+O87zYWAs/UTBkZZHpVc6I1JDPbLd+vMnyfzAXT/mT0nae6Y+3c3y
         7Xdw==
X-Forwarded-Encrypted: i=1; AJvYcCX+o2Yfop3Xxz5rW6iVrQ0wHemS+nE55Ez6PhnAKW0WZ9VcVgJB2jW8UwIm8bPOp7zUWd7Jh4cK+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxJRA7xeYVl8PjWmKUpLn05VKDdqL7UiwYXRRNPrMbwdubzgg8i
	AuX9j03TmN7mOmwistvwmgOK0kz+fFPolUDMN4MNafTMrUl0bD3GAYC83qBOiYk=
X-Google-Smtp-Source: AGHT+IGovwS3k3odF8N7sOl23DHwA+IOE/iVu4aQQ89/6DHIT/GBnaepkRD3z4HHegIOEg53WSFELA==
X-Received: by 2002:a17:90a:ea05:b0:2d3:ca3f:7f2a with SMTP id 98e67ed59e1d1-2dad5023345mr8442074a91.22.1725834358439;
        Sun, 08 Sep 2024 15:25:58 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db033fea14sm3156249a91.0.2024.09.08.15.25.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Sep 2024 15:25:57 -0700 (PDT)
Message-ID: <3edd6a16-3e95-4cae-ae16-e1702eafe724@kernel.dk>
Date: Sun, 8 Sep 2024 16:25:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/8] implement async block discards and other ops via
 io_uring
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>
References: <cover.1725621577.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1725621577.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/6/24 4:57 PM, Pavel Begunkov wrote:
> There is an interest in having asynchronous block operations like
> discard and write zeroes. The series implements that as io_uring commands,
> which is an io_uring request type allowing to implement custom file
> specific operations.
> 
> First 4 are preparation patches. Patch 5 introduces the main chunk of
> cmd infrastructure and discard commands. Patches 6-8 implement
> write zeroes variants.
> 
> Branch with tests and docs:
> https://github.com/isilence/liburing.git discard-cmd
> 
> The man page specifically (need to shuffle it to some cmd section):
> https://github.com/isilence/liburing/commit/a6fa2bc2400bf7fcb80496e322b5db4c8b3191f0

This looks good to me now. Only minor nit is that I generally don't
like:

while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects, gfp))) {

where assignment and test are in one line as they are harder do read,
prefer doing:

do {
	bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects, gfp);
	if (!bio)
		break;
	[...]
} while (1);

instead. But nothing that should need a respin or anything.

I'll run some testing on this tomorrow!

Thanks,
-- 
Jens Axboe


