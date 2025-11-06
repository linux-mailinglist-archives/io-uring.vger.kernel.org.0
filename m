Return-Path: <io-uring+bounces-10396-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 84B61C3A8C2
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 12:24:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9FBC74FA526
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 11:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B46E2E0413;
	Thu,  6 Nov 2025 11:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DroiepU2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A816A18C031
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 11:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762427966; cv=none; b=pxmhrzFgslZOu+yS5eGJ/YD/0SlxpUOTlp0xxTOOf4Lgb6k//qhuYCXFz3jqLq8KcpI5T6b518XbluSwqLtxGLQlTLgpEiiy+AN1QsLDD4vOp9tegl9u0GD2iNkwEWVprlvIEcTyPil8NycQtJvHFhpc1+GXC7xHZGI17032UZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762427966; c=relaxed/simple;
	bh=9gv2efB64R/hKg6M4ouFf/mpx43OnsogQ5ESP1uCG2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pXgUtQihlz/pVvRJglbzS81gRLkGxf91z/gm0v4msmAw0xsevQPmncefsuNZMgdKSHrWikn4u0awq+wL2/aoAIBjrI+6QikdT3CW3zhHWKPh3hnTKxCkb+PODjPA9k91VVhVvYHyo+4Fm2DN35ZnFSsqW4brtipahsazQfoIpuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DroiepU2; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47112a73785so5233975e9.3
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 03:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762427963; x=1763032763; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XkYdRZyE3uYViGFztfTL+nwDGiwwOYnS7mcrZoTTLns=;
        b=DroiepU2CRbB+AaXUrS+vc58IMYcG9z1aQUXBbEBksN6hzYjE80qb8v3k3JjW6anVN
         EedgvJq+WGjjXioYceupkWJK1WzFEgnuDNbfFiyomj1aDaJlmGwodpj4vinX1Vj81FqA
         OOvrfMU6kqgif2bNd9AFdCbJiv5Hp1GnPacmLiy1Qh/EYZ/r7vNkpn37b0zFYoDC/rg/
         7htctL7aRxACU65ZFYtmWArzjoeaY11u884a7Mtznnbf78z+auTAjvNmPjvtDmVqOAlR
         r2CkpE7jmfLFC9ve7EvvCG7IvFtzDM3ml7MDHTgFDtxsKqAyNm1OX2dPwvZrE0gn5/e+
         3e5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762427963; x=1763032763;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XkYdRZyE3uYViGFztfTL+nwDGiwwOYnS7mcrZoTTLns=;
        b=Y6s+yVnAnLTLmg4jMycuU8znPmRM26CQtrQ5bezFeVJdsuZcokpLw1RVL4HS5kGrKQ
         BtCCR2D7WMthRCVFF2h0DjLkcphyq0T80kgNSmSAM4tXOj7I+/GV4/axFyUqmczwpmZU
         J9H/aWOX8fEDNxFUt+o3Mm07LDv46imEagVNhQVqYy3ObkwPg/UjQLHKlGURiXeeK3Dt
         M/8P06+p0QMSKb1qWAkavrM/j3qq/qRGTSLF0yGtPREz5dqWJ5qqaW0uoRr9Be1aFeJe
         q7fC9E0AXT4aIenCJJKE4eWAU4jRgKRglI6fTZYUhc7zCZO+/tW5An9v/CEtGWRKjWgF
         4JQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJmEZvEHPwTsdDEo33Qzq0ziCgD3p1hMY97KHAI4MtolvK2Aqg1BSb35eO3eJBCo6HVH+aPlvXBw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3xlVNe2kQ5LrWArnRo39zLAbQT7msjEa2U6ldoFvGeGH7ptu5
	2J+11+CXZ8z53cRU310jIw0g/jeM/VlQftjfhM/Ca2tVilvJWZ1w/f5I
X-Gm-Gg: ASbGncscm4BIQ+gb2OwE0gLFoCfzQMQVkp3686r6FRQAL65qy0x6jfGLYcfY1dA38Ky
	8ik/YlYU9YyQBdaHL0NsXmI8XVAA0eJBQR+QPTg5oGMmTzy3QWuEjy0XUdcerWbcs3jo18q0vjZ
	/QuPWZQzZcw71uQmwx1Qmostan8+vx9eEv7XIhy2zLT0Kx4u2bpCpzgt+kIfcWR7wPMh3NCWOKT
	8CmamdcX3kjj43UgAgIN2ay063QY4X/TqzJenI85k3mdXsota7dmzqtjivMADMSoQ9R0iRSB9s+
	L1/fjEHoJ/mH5COgZWFtdeUhSjIyqReex3fxkR3tNGUsjvG58chAyB28VO6fCzWiTG4E1P9VSto
	odRgNY79ihT+UA981MrXFZ9OCQbcT4yM5+9vM/tbHpoMxsyyTIlVz1R5ZB+BR5IBuStI3iXb6M3
	onasKNj4D0svvYVsjFMzXssqaSqh/qnwdk74RvQn+pjKjHZzaBomI=
X-Google-Smtp-Source: AGHT+IEBjjHYEgqJ0x72G1+TXmkTAD+vfQLBoUcN3g17VbpVVOHP4P+CuAsM9y3g9IF7xSzsggdQBA==
X-Received: by 2002:a05:600c:a0d:b0:477:1622:7f78 with SMTP id 5b1f17b1804b1-4775ce24859mr62466505e9.40.1762427962931;
        Thu, 06 Nov 2025 03:19:22 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477625c2f4fsm43720565e9.11.2025.11.06.03.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 03:19:21 -0800 (PST)
Message-ID: <26635d1e-8c4f-4f79-927e-811a0105fe75@gmail.com>
Date: Thu, 6 Nov 2025 11:19:20 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 5/7] io_uring/zcrx: add user_struct and mm_struct to
 io_zcrx_ifq
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251104224458.1683606-1-dw@davidwei.uk>
 <20251104224458.1683606-6-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251104224458.1683606-6-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/25 22:44, David Wei wrote:
> In preparation for removing ifq->ctx and making ifq lifetime independent
> of ring ctx, add user_struct and mm_struct to io_zcrx_ifq.
> 
> In the ifq cleanup path, these are the only fields used from the main
> ring ctx to do accounting. Taking a copy in the ifq allows ifq->ctx to
> be removed later, including the ctx->refs held by the ifq.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


