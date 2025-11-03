Return-Path: <io-uring+bounces-10321-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A25C2C402
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 14:51:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A2F35349AC4
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 13:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E6C302770;
	Mon,  3 Nov 2025 13:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IXN85PgB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511CE2737E1
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 13:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762177886; cv=none; b=Er4BdzVs6M5R4KbfHqZXBUG65xVFVlO4z0IuhMKFvaszCmmYTWZVm3T9Ftifen25kFSsVOp1Zc7j0OqFK8osx0hfkOzYxWMejsgMhzsh0zyAhhF5FYdGFUt848GL+J6pY9sXlVx83+8BJSl5KA5yqJKvZncBOTAnO7X+jL2Oo0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762177886; c=relaxed/simple;
	bh=BQDuC6r6TWDQJpT9KkmN2q4sS8FD10IGStDubc3vX54=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WJIRWkFgmNWloFTiokadAGN8jBW8yWUFGt6bM/pqsUfel2pgsvzb1IYhxglUbTXtj4v+Vvjo+F1cq7r63BnaeAp3lLBxsmSW9ybs+zoj7ZBedS2ptMYtfL7/GBa2E9Kzg5BDXUQKRndFmHoaLLJlmnXv8iTF3necqNk4dj8+mV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IXN85PgB; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47117f92e32so36079255e9.1
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 05:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762177883; x=1762782683; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DkgKOXS8iR41FJ7eJBZfn0YxAKuFudOEEAKSm0IDw3Q=;
        b=IXN85PgB9Z7OUh8x8nBUXF+0SXEMrh51nu0sW2tkSgHcqgZi9r9Zr2GK1ySRo1HOeM
         ffxLYagmaz6r6QraZ63Q8HFmP5kdGoXMvW3hYOTpf6HRl7a+zWlRJ4whs2XQ7Fwaouqt
         UnzxMgDcbdVH3ri2Jda596VThu+o6YRhaRgRCy7mrDTr6kqD6OVoD+GjFt1jR3t/Fjqa
         BLnRWAOk4V/EgTIkH+MdDWKk7C4y9jfwKKunsHBc5ez2OLx76+vlNsCk55yovU0vyFkb
         CglmVCgyWMrw/bjdySpdxjWUxVrIlZNS+Ml/ERERTd0EIHtDdhmtBpQvuFIQyVr3fN5L
         S+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762177883; x=1762782683;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DkgKOXS8iR41FJ7eJBZfn0YxAKuFudOEEAKSm0IDw3Q=;
        b=F7tleiaIHMbVN5rNDzNEW+xd1JBa0Ux0vChIFUyFwo3/rZqmuHwndeeEml5c7/i2TF
         /6Ba6wG1UvPL2+dWOVJtBF+DQAzSwkUxL+tpGyLS3qPK3sSz20nhHQyG/3dtF0TcGupF
         a+z0zv/g0TAl5VuAttEPIOBfVBAXvOIc5dPiTRZMteYULvFnfiDOzAhynZlqIuYNIgfh
         flBo3pzgxRWmeUmLqjt0MkS7cTbTQ35zVpwiNNPwYhmKKpB6LharnrFN6MSOVoQbAWUD
         8R6cnF8DfwSRkBWS/NbgEPimpscpeWzxw+JrZYmYDjHpd0nW3pxcZVW4S5QED0xK2uqb
         /2iQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4uYfxHU7AFC+rrdIWfcTc48lkjkzg+/C7AiB6Sqv2m+ycSLdr2lstUopanFAtUaHKRV0XN49QwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDPmI17/zGSDGWVY5W+mz/Fh6aTf7WU1BpHmjA+RB1tY06ck79
	eAf45bl491eqT8A+p+O+qBSjpMpNoUj64ScZWStMmAu54NYoHHukPat8
X-Gm-Gg: ASbGnculLSlpe1vff223TYsMJZ5Tiwv2Z/SIsNEMCX5eFwLjxJDaHSEOrot/aqBVF2N
	lAK4poVNryH7Moxrq+HSRMT00FSWPDkmB70oWhY2WCdOK/eVBcWJgmh05UK6NF15+L153GSatub
	bYaI7QHZmFVcmshKWdtRartJddepS5sI9yI9CE/EBIuAaAxDWKi7Hkov3eXC/b9aCt/x1t7czoC
	nM8HLTzQ+ronzJWi/3i/sBywl03NoGV3dOAAtCjHmhrSZpmodMwBlX1oYcnXTqJt2ksh7GQdMw0
	9H8AuXh9G57q+wCLuVtAkcAvEKSdtcMmSm1lnPlqubV4tHpUIyaspoYmVt7NoXCK9zJx2HYjseS
	IUjuvShsZMIPROwsRB0tt/+l6MqMiZ8warB7+MERUN5S8owmFcU1gA54edwA6D4rpZIx+HhJ+E6
	sxsw+yP7B7i2BWCvoDBQZqk9WAXU8X5sx0
X-Google-Smtp-Source: AGHT+IGxjdLdbAjuRyDH6Sfd0+V0iMnyxe8nC+AdTMfwTxHuL6tvjznsPScW12HQ+xMzzx7c398mhg==
X-Received: by 2002:a05:600c:83ce:b0:471:989:9d85 with SMTP id 5b1f17b1804b1-47730871fa6mr137194365e9.19.1762177882479;
        Mon, 03 Nov 2025 05:51:22 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:21ea])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47751794620sm29118545e9.6.2025.11.03.05.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 05:51:21 -0800 (PST)
Message-ID: <c374df85-23ec-4324-b966-9f2b3a74489a@gmail.com>
Date: Mon, 3 Nov 2025 13:51:19 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] net: io_uring/zcrx: call
 netdev_queue_get_dma_dev() under instance lock
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
References: <20251101022449.1112313-1-dw@davidwei.uk>
 <20251101022449.1112313-3-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251101022449.1112313-3-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/25 02:24, David Wei wrote:
> netdev ops must be called under instance lock or rtnl_lock, but
> io_register_zcrx_ifq() isn't doing this for netdev_queue_get_dma_dev().
> Fix this by taking the instance lock using netdev_get_by_index_lock().
> 
> Extended the instance lock section to include attaching a memory
> provider. Could not move io_zcrx_create_area() outside, since the dmabuf
> codepath IORING_ZCRX_AREA_DMABUF requires ifq->dev.

It's probably fine for now, but this nested waiting feels
uncomfortable considering that it could be waiting for other
devices to finish IO via dmabuf fences.

-- 
Pavel Begunkov


