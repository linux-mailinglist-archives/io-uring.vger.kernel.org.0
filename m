Return-Path: <io-uring+bounces-10663-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2068FC70741
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 18:27:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 717284F841B
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 17:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A202C3559C9;
	Wed, 19 Nov 2025 17:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMQN8bM7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E264833A6E7
	for <io-uring@vger.kernel.org>; Wed, 19 Nov 2025 17:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763572702; cv=none; b=nP6DNL8EDL+fjQZ8w7JdbhW5kd0L9I571yvPYdmvWAC/n67rudfgSYhtzJjfX4rbCVKEBXOadtaFGWhHT/1BRkQDqfMhn1fy4y50ZNhpJF8VBo2Kg/fwREIlOpp9KgvKAXLE1HngmtWgt5k92PSAqV6kj1GcEXThsb5zMwq2GuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763572702; c=relaxed/simple;
	bh=8VK1efu0NogyyXns0xhQCCtSiYZghjt7ikrYpLl+1MM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=j2YnSakSh5bvaJY/pc5D5lhcXdyLqaul4KFjYZULCgwJu9mIpJljF0mQ25mK7xlsxm1WINq0s1OTiGMYfcbBlH7ezQUxLCMPdjM646z7DjepynXEmY2JOgEYYUo4nF8SceWvYimx7zpJYFbwPSAoXqe+uWoUCzMhou8AFDIY/w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kMQN8bM7; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42b2a0c18caso3777091f8f.1
        for <io-uring@vger.kernel.org>; Wed, 19 Nov 2025 09:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763572699; x=1764177499; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gT0/K8Sqn0pCE+ouzSq8qBiV/AFXAMUSPgFCq6AcsOQ=;
        b=kMQN8bM7d50k36u6a0XN4t0HWcnpt6LlFQWY5wH7nUzNX5iG0g/TB3WTR60dOe1Xqu
         5SMDayGmfx/iHBP3hcRQs1xxlJhxo3QX4ajGlmhTBDGXcIxVyqTZR15xzrGCdZiQhPg6
         D2pazsdv2kNK7banv5Hne5NvRnc8OU9/3nG6nsZvfPrlREV8ggdsHaipGUEMsUhaREpr
         2cFr0tzLOh3BZJhNM12icBT/QZaemSDP/1D1IKrQfn0NPIpIbK3C+LhSqwtKaTMAU2Wn
         7ylzQKpll85JQrKzF5jv21q03XWzTCOtf40et8mj9bkN7XJ8AYtJQV0rCLuWb0W25umP
         qriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763572699; x=1764177499;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gT0/K8Sqn0pCE+ouzSq8qBiV/AFXAMUSPgFCq6AcsOQ=;
        b=gnDXoZiH5YYKUeJoWFbHJeH42GpvnyHqOS2CPzS76GGWDPLhhUKC3HG2L4Lzsc/Rj8
         NCiKyA5TNgJptLb7oVx6Bo5W6P9ByptvpbE790KuUs9WxPqjcu7e/z4lNYCqKqQ8MIwf
         ClKzeovou24CxhNgFG/YOxalwO0NZtkb+3y8u9XbtWbYpfihSh6oIMp8klI7kpuG/758
         xckgRJl9MG5YI0rY5JgzamFuD+K8PsUlFmyw/Ay0i1ys3aZCefoRDztP3dqkXtWFcTlS
         A8KgUqNdzpYnRDQ7ZoaXdGQfbf3WufAPKLun+9pzOb29HO8qDirrNtbznri5V6oZcxXc
         XhvA==
X-Forwarded-Encrypted: i=1; AJvYcCV72zhIFKHpz8/Qb3sVRnhmqwRdWUZfzv7+2DXMXrNZOuh/FGVtQBkryV83pL3M0a9ZkaNLd4MZ9Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHrq+YNp78M7F456ujpXE3Y6NNa//OBsJQrsECOQ/NGvmWehs9
	GMLSukrFiQ2M2kh3LoqEnooP9p69vwRVtBgvSbg8M8jKNYGISBqAOkf5
X-Gm-Gg: ASbGncvCHFGKBgcpuglD/lvSXyUS4/E6Oz+4pzk3veGwWajAWDg0MI7n6eXROTRQUJa
	7/YkqpeM28ApHFh+ICFpOUPXsBpEQ3tH5XMvLA2f1kXG7nsRA6KGJJyBJHTYB9HtCbitVW6HNm6
	pNTj7sVApA6MZlZrrZqDsCXB6zrPotyj33mWIym7QEFVpYVhDC42gYXR1ctZoYFE4Ikvb3+b58b
	xJn6a+XI0BB9b19p4g/aEvk0zovDOj1lPdhZDAsvluqRB5y5dPZZgdphTPH43U7RcJSTB+w3XGn
	wYD3XGpFeuiMSysTFUAnXqvxuIynsUY1TCFz17wSgLkh+izWcUEgst/iP9Z8n2gft5Ety/nA260
	VhOPPk4BlXJlewBISej4P/y9HPt+HvHeztFuBow2CPZ28puQHFXIj/EmVzTdNw+28CwRgDGWOgN
	w3pTm1/2jwviE3eZyYHw+EJkrTN7q6fmwrQGvtEBCILt0XIBmrkaxsbf+ijHHJSw==
X-Google-Smtp-Source: AGHT+IENn5tjM38acY8HmPhw9w47QLQtYK7jhZkOv7CcYmm31TNTX9GWV6UEXMpBufMS0/5F17rqmw==
X-Received: by 2002:a05:6000:1884:b0:42b:2c53:3aa8 with SMTP id ffacd0b85a97d-42b595a4d3fmr20294380f8f.37.1763572698892;
        Wed, 19 Nov 2025 09:18:18 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fa3a81sm239429f8f.26.2025.11.19.09.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 09:18:18 -0800 (PST)
Message-ID: <7febd726-8744-4d3a-a282-86215d34892f@gmail.com>
Date: Wed, 19 Nov 2025 17:18:16 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/register: use correct location for
 io_rings_layout
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <64459921-de76-4e5c-8f2b-52e63461d3d4@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <64459921-de76-4e5c-8f2b-52e63461d3d4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/25 02:36, Jens Axboe wrote:
> A previous consolidated the ring size etc calculations into
> io_prepare_config(), but missed updating io_register_resize_rings()
> correctly to use the calculated values. As a result, it ended up using
> on-stack uninitialized values, and hence either failed validating the
> size correctly, or just failed resizing because the sizes were random.
> 
> This caused failures in the liburing regression tests:

That made me wonder how it could possibly pass tests for me. I even
made sure it was reaching the final return. Turns out the layout was
0 initialised, region creation fails with -EINVAL, and then the
resizing test just silently skips sub-cases. It'd be great to have
a "not supported, skip" message.

-- 
Pavel Begunkov


