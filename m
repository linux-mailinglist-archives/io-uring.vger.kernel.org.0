Return-Path: <io-uring+bounces-10785-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D019BC84FAA
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 13:35:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 74F3534F176
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 12:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C512301493;
	Tue, 25 Nov 2025 12:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P9x+YP9E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D5518DB1E
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 12:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764074112; cv=none; b=jFgTvDt/SQPvabIJJP9nOQfayFYfKi2LBPjWmsztJUMAF3AV1QR7cnVMB+gLR3E1BL0wtNudBOc26Y2MjkashjmPUldLb2MSQ9JVRaRWQauA4FGzSvyQvLa15W/85I/oT+K1c23x6zOgOiQGlGdYWkINn4plYiU9uPSG7n228UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764074112; c=relaxed/simple;
	bh=9KhMQtglvgwFLq0EERoB1DGsMk7bVLgsTiRTkQIulec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MrmkjB4/yaR37trl74eBjzp8YSA44bcMnCQNUOdFnZaTnVFbJSJGiDxQib76T1fFuTX9OF3cnUF/dh/tgMWw/LtWQJlKqzkI9j/6IO+r2q9pl7Pcm/6CUbJPmA3J4Cx0gsxluuIIy22JuxJHp/FpdSipIIZKixpjWqTm6i9Ffx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P9x+YP9E; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47798ded6fcso33082475e9.1
        for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 04:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764074109; x=1764678909; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=siB9qFjab8fX+nGosH2txh4HIYoNVo3aqhU42WS03o0=;
        b=P9x+YP9EXEnC7MMe0F5kk8o8F2AB7xaZa3E5RBDar3rlAchOZ1QM38zsIjtdEMifEG
         +3hXpND37T/LymWCB8VBxtGVRlPmm1kjRs4JlZm7WwVdlyfNz34bjzaDAwU2hbzWk2r4
         +FC5ikpPr/GNlJ2R/6WgiDYkS28IpAopY4azIg/V1BXMSzBFaDQ2gJ0YRLLUbTaOUiuy
         8ulPp6kL5/nmLgahc60VtlvC/WdwEuyYxJwlYlvCnwAdC00hO6zjNlDm7HmKnnfRxJvA
         WJIhjwxihIeragaJP9AetoGmnIjR7ceg95L66JS6cZzekSQdp680VNlYWm1JHvdwoWIq
         1bDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764074109; x=1764678909;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=siB9qFjab8fX+nGosH2txh4HIYoNVo3aqhU42WS03o0=;
        b=mFzstSgoCAHtM7+K9v04bWUEd1pi3FHqrDim8CWQfpf8buE7zcNmxUg1MxMSA/O57u
         3aSRHLicknH1cX7d5DnVSb/BUJzPdtqAHgJwyStZPhudRbU6GAyrYWuE+5F8TFZVi9R3
         mK9btgXpwmm7FSP9Qd/VUEvpgAFR7Gu9ZSv/e0fI41Gtt009o2L0xQM/rPNSVb+3o1cY
         UfHirCRhRoQGaFwZY2LcrMtHWeoRIb5tNrNU8buWJKBc42Mn8E/yvvpDOoCmjIelcTM6
         IlE5v/IAoH6ya1nXhAaSgA1HTA20F2FK5tVbfsciLxL8W+kuwDwSp1mnD0EbYeimjOK3
         p9dw==
X-Forwarded-Encrypted: i=1; AJvYcCU3qwQ5PGUYg2dQ82iFIO56/X4277tdo8+qjuzNzeAfyYlOvlvaJ5GXtNpD9ra8E0UVBS2cuZVjIw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSy760OjP5qZWmrA5ubRl3WJNCUnQJEwUK3EUd/KVZn5gso76x
	ulJ6lVAI4BOuS0okHNjWeD4YU8qBj0NhHQPHJFnZKUNwIeKpPagvLIa/
X-Gm-Gg: ASbGnct+owyr5ltqZUhnamILEhybWSY6IEPVOpbs7wdqGFhdwewvQYOxGAA8CbxzNTK
	HysPMAiZyGPQhv28tos3ywHrH7hwTGY0jAlnnkGRL/5JZchfTLNj/cD/0pKhH1QhsvIH4tsAJL6
	+YMHwO7Cn+gIkOwLHgJUCv6H6iRNHUJFQUPuABGV37oRJ/LFe6yAxVWIdmhrjhj91LtQ7ML+DYJ
	HH5RzZSbPi2BOXk9cci/uJVYPPjMxWD7rovZJ2rtJ9zgdQ6Xdl9NdISAvTx9CvuoCLuBmf8BLsI
	R4qjZz1K9sK/CNdofmyIEMH3b1zbTWpAKMH6bIsxsdk4EJ1Ja4SEYSK+8rzn1Wx1ywsPnUh161/
	nIsGTsUt04QbeKx8T5HgowRJWMWcHZGVNplXAXMHrLZAHHZgzMdHVGM14BoQy1ciqlAzpxnd72r
	t6UDYhl85vQRYvWjwp/YIM13J3wvxVqGfuBrUPdnW7p0ccsiN6teVR0gm4DR6jcQ==
X-Google-Smtp-Source: AGHT+IGiAByXWX/VuXJ575rRIj6bTeEbAlnebab6FY0vB4jAmRqS6rohlKvvoUgeChvVCplBX1c2lg==
X-Received: by 2002:a05:600c:1d1b:b0:477:9671:3a42 with SMTP id 5b1f17b1804b1-477c1133e4bmr159739175e9.35.1764074109236;
        Tue, 25 Nov 2025 04:35:09 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fb919bsm33941871f8f.34.2025.11.25.04.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 04:35:08 -0800 (PST)
Message-ID: <1f8b5e97-1f3c-46f8-8328-449c159b7d66@gmail.com>
Date: Tue, 25 Nov 2025 12:35:06 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 00/11] Add dmabuf read/write via io_uring
To: Anuj gupta <anuj1072538@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org,
 Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
References: <cover.1763725387.git.asml.silence@gmail.com>
 <CACzX3Au7PW2zFFLmtNgW10wq+Kp-bp66GXUVCUCfS4VvK3tDYw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CACzX3Au7PW2zFFLmtNgW10wq+Kp-bp66GXUVCUCfS4VvK3tDYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/24/25 13:35, Anuj gupta wrote:
> This series significantly reduces the IOMMU/DMA overhead for I/O,
> particularly when the IOMMU is configured in STRICT or LAZY mode. I
> modified t/io_uring in fio to exercise this path and tested with an
> Intel Optane device. On my setup, I see the following improvement:
> 
> - STRICT: before = 570 KIOPS, after = 5.01 MIOPS
> - LAZY: before = 1.93 MIOPS, after = 5.01 MIOPS
> - PASSTHROUGH: before = 5.01 MIOPS, after = 5.01 MIOPS
> 
> The STRICT/LAZY numbers clearly show the benefit of avoiding per-I/O
> dma_map/dma_unmap and reusing the pre-mapped DMA addresses.

Thanks for giving it a run. Looks indeed promising, and I believe
that was the main use case Keith was pursuing. I'll fix up the
build problems for v3

-- 
Pavel Begunkov


