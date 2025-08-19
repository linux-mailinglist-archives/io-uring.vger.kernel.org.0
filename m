Return-Path: <io-uring+bounces-9074-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BC50EB2C900
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 18:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D45971C27149
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 16:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AFDD284690;
	Tue, 19 Aug 2025 16:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AyQV00Yz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52755264FB5;
	Tue, 19 Aug 2025 16:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755619416; cv=none; b=ulvseGusjPLGmDQO69inKQRBo4wLQIOyjZR6mbm1VWZtaxgOW3srPyoTyJ9we85QyrlN0vdIaaRTVa61/yQ1Az3QAkwkYYD3LZ6ds2MyxL3g5shAE+V+fP2YGhcc0s7/BKxj3jHPs/dMfMhruE7IzqL24rXIn6sr/N33iri0SlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755619416; c=relaxed/simple;
	bh=jTCYQ5+CaWRzLQmhmfNfYKl3VFqqLFfXMtg+Z7mq3Qc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tMBDfNO23ga7ui2AIjFjHlVOf2Si75cshFxt1XAJOakMJLF6LwTV04/R5FPOnujzEen4WjjEIBTxv3LsJrgljq1RpLC/LNLep1ZMsC9u6JLeST/lec4ZD0N1Xn7dy6dB3EzDa52JTreOKDP1QedJaPTTHy2GRGvQgDUd9EzduTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AyQV00Yz; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45a1b05a49cso40473975e9.1;
        Tue, 19 Aug 2025 09:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755619413; x=1756224213; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nuD2xahK5JiJkloZOjqnEDldK6EL9Pc0//cVu0fR2Ys=;
        b=AyQV00YzkCvpVLIFvd1hH1zJl82mm/7BYNVtmxGo20/f6WsrMOX7s09cqDzM+HcBMZ
         0JQoNMGyPYnrd7ZRQ6m8OnbitYg6ze4zTg1B4cILyMvaIYLrN41BEpUOjntWHZ7pIE2V
         MbsSUkMsNO+JoUAwXyPPxFf4CdKJNI2tnDpsmTVVWwZHhHNPfAd+cnHx4XIP+vVvpI2B
         0iaHcF30NKRA3G5+Ea9GYQIp2XTWUcWEB7IR7T6Lz53KHQgxD2jbMo3dFvlnhpEqBv+u
         pEStqpEx5LZhvhYSQ8pIel5D2Oj6QZslyqToCxPiYoqONooXG3GAynFiGhyrPHgmal29
         Q+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755619413; x=1756224213;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nuD2xahK5JiJkloZOjqnEDldK6EL9Pc0//cVu0fR2Ys=;
        b=qgpDqe0huhtcUmDxDdl18EMylZn+M0whw+P9UaCziFW9SJ55KtSK3Q5jEALjXi2bD6
         e7xDWYrm3u4zkfLQobe1lRJ9RPq8lhzS8jTjbETCsyOujbRURTWluGPYFAc2MMXHLuDS
         c3vp0VcZKbpXL6YVOs3+9e5MTTlp29G+hsKAghLwJYVmpi+e5gjiwXq23UvXFhWnU5mS
         MPQeBPAShwiZlq4V/bH5lOqe6EyIHd4QugLJizamBUjzQM5nwDb9xsfmTkTArMcs96QU
         CXFWVlZNfqb7UQHh3pYsFgUWSAvpRQvKwU6srUy9KcaUZmDvWOiBQ66p5k8mBbYSwUmZ
         Egew==
X-Forwarded-Encrypted: i=1; AJvYcCWZGGOtCl1r8Bhkr1jICyIkhdGEgwJGQzkgMXd6R2DT3beqZH9HSLu0+NkTq8V9dy9/vRn0wMuJfw==@vger.kernel.org, AJvYcCWx2ubMdk0kamZfbvA2e6sUu2STHhWMx1VPV/POIvSC06XLjXMqyDAOxQRFhOrd5QPwtgfZj+jS4JhoRc/s@vger.kernel.org
X-Gm-Message-State: AOJu0YxdPDtx14j81WB25OzyPBDTzlQBvwWV6uMuHiK6lkqv3nOF5aDZ
	CbEaREKC6C6fEfFd0TrmKdHe7X7Em2Ga5+CslCSke9L1qSVMYyfn2JlA
X-Gm-Gg: ASbGncutwe1pzO+xuS+STvYbvu2HATo7loSRSW7U9Lc0KK6ZdpIx0Gz4b0BE9xZ7qKY
	aACu30QKivHBaPCMx3MDJFMnrseEEopEXifgSzGZcRgLc8K61t6Db5rtXi7uovYK5Hjn0gqhD3s
	MiPIafzVX9CL9m7ZqPJG5LvZcejKTBrZZHAA3fZOuJGeHHJXA7Mw7kKi1qNUwb67QSmYGpBD79J
	KhA0PHmmzpu2pTLDpA0JECVB+iZfA5/z+d5EoA9Z18p9OSilH2OWN7cSEkSAbgyaQBVpTZmUKTw
	hb56sAJXPYDdjL+5YtPC9AF/wgWT9GpxSZ/UKwXdzx/yc8VjKvqiwlbqLALDyyc4vdG4BtaGLxP
	jdBsMbfrSPfqYNiWZ4QoUHpyZ/ahMqQ==
X-Google-Smtp-Source: AGHT+IHf0XhcfUQatI12wyrKYxTNGVre5Fz2SfAAWbS2f5Q3W9ktlOhsyri7tFyUvpYT2w2i9NDcJQ==
X-Received: by 2002:a05:600c:3ba9:b0:459:4441:1c07 with SMTP id 5b1f17b1804b1-45b470e635dmr1385165e9.20.1755619413173;
        Tue, 19 Aug 2025 09:03:33 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c074d43947sm4457324f8f.18.2025.08.19.09.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 09:03:32 -0700 (PDT)
Message-ID: <7dd538ed-d767-4c9d-906f-93b9e5341ea6@gmail.com>
Date: Tue, 19 Aug 2025 17:04:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC net-next v3 2/7] io_uring/zcrx: add support for custom DMA
 devices
To: Dragos Tatulea <dtatulea@nvidia.com>, almasrymina@google.com,
 Jens Axboe <axboe@kernel.dk>
Cc: cratiu@nvidia.com, tariqt@nvidia.com, parav@nvidia.com,
 Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250815110401.2254214-2-dtatulea@nvidia.com>
 <20250815110401.2254214-4-dtatulea@nvidia.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250815110401.2254214-4-dtatulea@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/25 12:03, Dragos Tatulea wrote:
> Use the new API for getting a DMA device for a specific netdev queue.
> 
> This patch will allow io_uring zero-copy rx to work with devices
> where the DMA device is not stored in the parent device. mlx5 SFs
> are an example of such a device.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

It'll likely be fine for it to go to the net tree.

-- 
Pavel Begunkov


