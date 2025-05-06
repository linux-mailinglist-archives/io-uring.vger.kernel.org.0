Return-Path: <io-uring+bounces-7869-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 105F0AACA94
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 18:11:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8F487AF09F
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 16:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA511280A29;
	Tue,  6 May 2025 16:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0NNMNqpC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC034281523
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 16:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746547912; cv=none; b=cy4OKBirvM8maJodVr+jQOa7bLShRvnuiwOt4P7dcYpZGdRV6sI9DFa//ccU3tmED/cf68vbX60cdtVxiRzCe0h9aT4thU1CV3mTpkyJFsDFG2bUu3QStu1RmrEyN46c7F8sPKDEoE/SQL2q40vsgzY5qgkBInAmUrLnjTCGlEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746547912; c=relaxed/simple;
	bh=XghGIwQxHjfX5/QQuDhZxcpHaMTrJHRHr5S8BBfxQKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AX46qMhxVHWHESC1mtX33PjfI23Mzg/KuEEusDOOpda6WDQhr2i6Ay+H9dqvvNjyEgAe6ZZy/T2YoWnXlo1equtCb04eGarN6StLGdI47SRtuXg/7iY7fv0HjP+tKWsoNkKb2E4A0oKLIh+5xIufDQPXn9vHMrOAsLxfHfSDhSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0NNMNqpC; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-85df99da233so594798939f.3
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 09:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746547909; x=1747152709; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1XykedOmLHk5dNi01+Df1ehAhdSm17Q5ExZzLiNl+zA=;
        b=0NNMNqpCH3YqN9stdYbUIHjfjLdvOsCGiBldBpAZuek+NT4i1fSkiIYfKiXhBDPiWK
         r3zqsoltx3vyDOLHlwnuWBMoHAJREpW5EyJ0NMItp8ITTJdga304KtJYcYoawDVorxpF
         blFny26vfzYMhQOoeLFTRyOsZ7q3LPOFE8OqsRV/+ddPfB4gqojTJBCMKsl5GVC1pZae
         S5YGor1k+3JMYRuPI+yS34JkQJnYxoI1kfOL0VyXxN+gRhfQ8F8ug9r35WX3CXyrgaRn
         pDoSO02YxRIaeftvGBbej/IS2RsNX7GBf3aoSoZ3G06O60pafmmc7S284GiCSxONZJXI
         GJNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746547909; x=1747152709;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1XykedOmLHk5dNi01+Df1ehAhdSm17Q5ExZzLiNl+zA=;
        b=Ca3YtNV/OLBmx7pJV9btUkK/QaJ7Dp3eiQ67QgPfHBMCwP2L88Sesix9Keu1V3oUwE
         vLGxDPqqD5h/FENvEfW9d/SulcQKaoIcUhRfSOc1oWuMC1oaVNwOMCqduc6XIp+REcaj
         2/CnVMsFZOfWOjujfffDj6dPK3/CLfBMw3NTtVKEWJ8yFx8fah8XBnG8iBZH0tBPhwQP
         YndbjRShWFNQIFXgO61QyhWRu5cdtnCqbBHp0zBb/1DVrJwDhhx5HdCwJqp0CGFdzYgB
         yRx2ycIWabcH45dj1ij3Lvc3HLEy4Kdl/u+ScA8kTxj6LoPPG9sXHfrgKh3c+iNeTv4+
         UEqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWn4gMTrRcDk+dOFzUv+g90BIAtWufbbccJ4qJ7tFg0RAB2MHzK17THFVUVts8wjujL1OZzPAkvDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHxk5K5SxTcLI5kUQlNCkXCH3P8y9p0lqEDq48kPumdAuPAYY3
	3ofXltiEPiA+ksqIb069MGFXG5cVF3PLnQGYpGCIeaWtsAglgJ7P/ibqQ1LNdu4=
X-Gm-Gg: ASbGncvczBhoOWiIX90q65jxKQzDVKgum9ZiCEzaELIDmmoNn+DqWDQtpC/kfXPYvvJ
	uinS59UbfyXwuGrwvGPoVEzqNHRMl5sQlLDguz7Sh9gmxHo5v4HIMPWzxCZpsT6u3Pve4WXMLSm
	RX+gFwg6CQiTqOairEwsuHlKtXgv+yLxT240H3rW86SFqtN99n45jK/4mlFKvIZEnBLYX95K1zo
	fGCAZgk8wUHPJ+b0cncJCJw3dD5Jm/lCgcHkjVzEIrlhPELxJfFojhTVOHgAXQVM5jXHsj9x15Q
	XF7WE6yNnL3Vr6sPY9KPO6Dk1wNIksQaPHrbAWXxlNuCaow=
X-Google-Smtp-Source: AGHT+IHPoF9R83dmId/71qjWn1XFsicQ+izJJOJXD4Tp0/Yidr9CnlXmpxTn1ujekG0V67Krl5eVbA==
X-Received: by 2002:a05:6e02:1f13:b0:3d8:20f0:4006 with SMTP id e9e14a558f8ab-3da6cdc9e77mr48251275ab.4.1746547908780;
        Tue, 06 May 2025 09:11:48 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88aa8e1f7sm2295862173.121.2025.05.06.09.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 May 2025 09:11:48 -0700 (PDT)
Message-ID: <08c18157-c180-4034-bf21-61f0b11af95d@kernel.dk>
Date: Tue, 6 May 2025 10:11:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix builds without dmabuf
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Alexey Charkov <alchark@gmail.com>
References: <6e37db97303212bbd8955f9501cf99b579f8aece.1746547722.git.asml.silence@gmail.com>
 <e6e7f396-9eb2-4990-927b-d4256494e669@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e6e7f396-9eb2-4990-927b-d4256494e669@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/6/25 10:10 AM, Pavel Begunkov wrote:
> On 5/6/25 17:08, Pavel Begunkov wrote:
>> armv7a-unknown-linux-gnueabihf-ld: io_uring/zcrx.o: in function
>> `io_release_dmabuf':
>> zcrx.c:(.text+0x1c): undefined reference to `dma_buf_unmap_attachment_unlocked'
>> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x30): undefined
>> reference to `dma_buf_detach'
>> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x40): undefined
>> reference to `dma_buf_put'
>> armv7a-unknown-linux-gnueabihf-ld: io_uring/zcrx.o: in function
>> `io_register_zcrx_ifq':
>> zcrx.c:(.text+0x15cc): undefined reference to `dma_buf_get'
>> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x15e8): undefined
>> reference to `dma_buf_attach'
>> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x1604): undefined
>> reference to `dma_buf_map_attachment_unlocked'
>> make[2]: *** [scripts/Makefile.vmlinux:91: vmlinux] Error 1
>> make[1]: *** [/home/alchark/linux/Makefile:1242: vmlinux] Error 2
>> make: *** [Makefile:248: __sub-make] Error 2
>>
>> There are no definitions for dma-buf functions without
>> CONFIG_DMA_SHARED_BUFFER, make sure we don't try to link to them
>> if dma-bufs are not enabled.
> 
> Jens, you'd probably want to squash it into a42c735833315bbe7a54
> ("io_uring/zcrx: dmabuf backed zerocopy receive")

Done, added the new link too.

-- 
Jens Axboe


