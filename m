Return-Path: <io-uring+bounces-6824-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF803A46C8B
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 21:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D508616ED52
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 20:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBA352185B8;
	Wed, 26 Feb 2025 20:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OGC0f7lO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0035427561C
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 20:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740602179; cv=none; b=fIyMf63FP14svXCSuXqW7xoNyEZN76abhirJXg7SY6GQgzZ1NkertPfjIpiJd7DfFaA8mVzUAWpqmrKODm8zHJKhiQePCB0srk76N9tQlmAYXB5WOi55ow6UF8o1Uop0352DOiJdTZDpXIETQM6N7QyVe4CVe48OM6LNb98RYFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740602179; c=relaxed/simple;
	bh=VC3SAPTEl0i49ihRbrDdJsQYLdTwF6Wi5VeIuAFox50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dRsskKxM8kupFokNA7zssn8D6XReLCg+AwWInrarvwx0AaIRsCmjhIu1hKhPNIMcHG/qXzkTxNg0NVULltzz+73iIhGLV5ai9Nu5SwAEkJRyaVHhVCCxAi2KVejgVZQeT5ZgrQ5A9ZzUvYfLTRWu+n/OBR/PuWB9pJjQ5OQ913g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OGC0f7lO; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3d1a428471fso1926755ab.2
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 12:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740602176; x=1741206976; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hmzqUtuLFgT2c7u/W65oS618sUsNHDHfq220kvzNU6c=;
        b=OGC0f7lOayOhgQ/acv2MgoIggYZT2/PmQAxeu71GXIKDaGy0ueYZKv91gACs0/x59u
         NCFiQDz4gTdHNOoTEeIl7acP0HguFFND/nSR7lvZ/YFpVAyb3rHfwrTcy5WJcD9Hj9Bu
         hmNFFo4TuFw5zWTTGiekt+5J4qTRh2bSKBeM4BXFOTzA4W5K8ydm1F4LRwyCJnNBUrXM
         CdW2j2szmGOpLZYmx6WhmQreYVJjjhK0iUs8d3Utzh7g8igzbDN2yn32vMlBZp343Iyi
         Rt6TxXyHelHgY0zSdvEgqCqoIDnylW8h/xrZEqgUr3b9U7cjzgYFm7nSDax1ie2e8gnj
         Yzrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740602176; x=1741206976;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hmzqUtuLFgT2c7u/W65oS618sUsNHDHfq220kvzNU6c=;
        b=IhQ2onvKN9E44PJ5sh+8g7FE+gJ+IzZMcVt8bDCNEvanoHk/Lp9sbdmlVJ9RpVG0Y0
         sFsn9qT2/3NoKFRWpfyYGpjhKnRn9lONm/QYLnhG3b1JkGdVv4eabkncM/f4EzUk8Snu
         jTOIPRiOSMEJdGqOsqvMVVeZJbsdATSMmI50062jraM+exdzy4qiUuN08bdLR/6IAlBw
         pKwy45nbnHBxDRCoeMW0s9OPM9l5DiCqtVEx1q+c+R1tCtLjguc6cwDl4SuVvTtt0qz8
         8KYYJm/UQiJd+qtXsbJEHMWQx4FmOjRAbb87kmrPxs0U8QzzwY7t/t6dyl5jICLUNHXO
         /5jw==
X-Forwarded-Encrypted: i=1; AJvYcCXHDAa1BPSW/gf31ltsAOnB8Bap5LseEyR8jlffrvLbGFVqiHnuZNl6XuKZ64lSJP8scIjp1HncwA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYLIOBKkKG0sfZC9/8CE5LH3fiqLmO31IEl1qE+0Lzu/J1C67K
	IUvkGdrmq9XUhe8tu+sRpwYOn0E65xKmjD7w2RUQZGSyGQ5VJPcSWEl65WN09gE=
X-Gm-Gg: ASbGncuH3goFnVU1ULm7eCPO4bdW9Fb5CZfHp2wyBTP+dMj8CA3jx0CxHe1QGGuEYIo
	sqlNb2/7z+hLkOXJsdjtvLH1UYna7WnfBDJJdT3U3eyCYBH84ShKFWVnyIO4H5byDhvjXZfEMyD
	axOg3eu77L8KO1gx3ALLQvpJ58IryUOK4qUa5rU/eOboxirJQObgUFIDlJN3XPZ5HivbKRKL8+c
	3QoLeRhkzDaR3WtqRa/RfCk4nH4i4nvRuCbJiWiavzC6M58Ys8d2N6eXV23TzuD+8XMHZ6cgbzO
	tDQy2lCF8wG0bd6IZRH2Mw==
X-Google-Smtp-Source: AGHT+IFZhUDa0aBEcOlvPZddOMoMuQxC93b3SQFzlP0FnLZWxjGnGimX11rNVAbPFw+yMxcl4BKkvQ==
X-Received: by 2002:a05:6e02:1906:b0:3d3:d4a2:94a0 with SMTP id e9e14a558f8ab-3d3d4a29640mr41989075ab.8.1740602175816;
        Wed, 26 Feb 2025 12:36:15 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f061fa8750sm12443173.136.2025.02.26.12.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 12:36:15 -0800 (PST)
Message-ID: <e7e3d82d-d983-4073-8cfa-91f2a3f2ea62@kernel.dk>
Date: Wed, 26 Feb 2025 13:36:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 2/6] io_uring: add support for kernel registered bvecs
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
 asml.silence@gmail.com, linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
References: <20250226182102.2631321-1-kbusch@meta.com>
 <20250226182102.2631321-3-kbusch@meta.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250226182102.2631321-3-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/25 11:20 AM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Provide an interface for the kernel to leverage the existing
> pre-registered buffers that io_uring provides. User space can reference
> these later to achieve zero-copy IO.
> 
> User space must register an empty fixed buffer table with io_uring in
> order for the kernel to make use of it.

Just a suggestion, but might make sense to not use ->release() as
a gating whether this is a kernel buffer or not, there's room in the
struct anyway with the 'u8 perm' having holes anyway. And if we did
that, then we could just have a default release that does the unpin
and put rather than needing to check and have branches for the two
types of release. Yes the indirect function call isn't free either,
like the branches aren't, but I don't think it matters on the release
side. At least not enough to care, and it'd help streamline the code
a bit and not overload ->release() with meaning "oh this is a kernel
buffer".

-- 
Jens Axboe


