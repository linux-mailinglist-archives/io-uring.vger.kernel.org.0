Return-Path: <io-uring+bounces-10393-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F0E7C3A829
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 12:19:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 768C34FCEDF
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 11:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E40D30C363;
	Thu,  6 Nov 2025 11:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NR1RSx/E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F3D2F0C6D
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 11:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762427786; cv=none; b=iPVoNRJtdMwVCwCsxVix0o5em24LUOHWgnBkTO2nzT5qLfzMGTz1N/QdaqOSzkzrzQ79MM1nSJDrHKzhElSKI6vsI7NhXykfK0M7tgwXMmjkS7RVo7fHA09c08O3M8kvBh4wjeEVmiIKiPGcu5Ljx59KfjXF7bs65JoGq4CYpH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762427786; c=relaxed/simple;
	bh=7Y6mjwgDwYWYIudo7Oke6+8/zuz7V82C1eF8ZHCBf7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RaADNUevCg4Jh/fm5mGDFDuOzaIoVom92kba/K7HbBWGsi9CrFMO2aNrANgSyVPoJh/fm0yUPH3isLq1DqUYObctS/vmB4XGzPYRLTLuX9oelfJVs+TCLAxLI2SUi52Fux9SC8Yw6wO6Xq3hGNlGM8Aciwl/Ts5tK66+Q+bWoMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NR1RSx/E; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-477619f8ae5so7172445e9.3
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 03:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762427784; x=1763032584; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wZPs2xyBJxwp32jA5Pjexh3hPunWL3Vc+aqMJ7ALlyc=;
        b=NR1RSx/EzigZYHkO3eoe/1oFxB6capCI/NdN3+tQl7tqtQTxXiO8XAgFOtbm/kLq9x
         iAo/8R6czY/E8+VwysENazG3Kzb5CyDrDbAE+8W+a2BI/hHOyvvBrdRrqfsmDtDNbR5z
         nhbMxtzjEchE8mDCXKbYBJ9EAqfou8Eoe0jeZpZakbLO0+pvGD6fV6ZFBxuppzSq89hM
         YTdX7vxJIAd0SrRYYrdTjh+xGK0PBIyZWqToeed9EWjE2AOWNJ8XAfmlPAXwGR8fqaPG
         MbiDBhWMuo8E2aVbet0Y0ejjUP8L5hHWjnu5tdfqeAzhiOHuON30GUbCABcUqVKTFgH8
         3HRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762427784; x=1763032584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wZPs2xyBJxwp32jA5Pjexh3hPunWL3Vc+aqMJ7ALlyc=;
        b=ToGDMDMHoO5BDafHqCSzjSQBhBZs9oRHSPZ/AeZXiIcY6OV/vGz1Z/pPeJcvqbMG3J
         rNXI0qtmK2ZPkdG5fbz2WjUAZxLJk01WqNqz/EMRWurUwY+rGOsZa/ixtNCU95RQGu1N
         fHB423ilRTTRrT3fOA4K2MWSw735QSf0vsC3lcBPsn7WhCX8FlxXNeP8grOn3UyVIncr
         +a950+TuQ5P6CZJE2bUQLDugGenI8sxa0oLjNuUlqzChQQ8kPKAddktJOp/Mm/U7uD2d
         64jlDatmImSbbGWUeVCyJJBNkomtR9MdPD/zNSmDpZXepNJKzDcHtbVtJVxnJoJjdFZ0
         AE1A==
X-Forwarded-Encrypted: i=1; AJvYcCXNXMnXfEBLw2dCZAoAer7z5iT1FMCNz8jfzQgdRUWyeRTpXJOSjKowwmdDs2lBw5OAyEVtbPndlg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ3ScSvrXMicpHUeVhAjFQajs0e2PvC6GzjgDHiG++e12GGOZk
	1dC4xkxNIfoJX1B81nJJJgJqsohvtvotQHpvKco40I407fG1mD+Wltak
X-Gm-Gg: ASbGnctlMOd+QgA7whQaBDoOrLQKrtBseDUiuG0oyTMNOCuiKaOimASfuc2F8mrCjwN
	ayJYfgwdJcOEa/4S/zeyjqBKjiT2QP4nJCWa5zdslh+NWT8w72x5s6Z549ENzXQjLdslDITOKAy
	PPsgc01jHyG2efO0DM12k+cEsoKiLqHRyMbiiS8+Nk51wlggs3RTdp1Gpvd31JB0cvBOEYTuXXC
	T+lyNBsUT62kuda/C80wWmnTEqPcPjSoWC5kvb+hRxgAyxyWLzUuO59zksm6JDxImkLAYKOkgmz
	KTYGAQoWeM3ZRiBSoC26vlwybWbSNg8wbubjfbEo6U0Pe1/i2LKtAQ3vpzs2rtxSh5a6CQmyYo+
	p2/ZEpVjZLodQKGIApiNFWQ7ViBwc7YiWZzQpywZZF47p9nfMALUMrl7SjLS2cUYJUYQQfqnpgu
	nL94dCVgUmjc3X3qtFjs8P4SGrpnAp6tpu66hVzCTA0NLmQ3p/so8=
X-Google-Smtp-Source: AGHT+IEkWmARqtO7B1TtCYr48JE/pXPxmwu44dsbPF7TajlOF47f8GwH+/YHT3ggQMIjKGLEkTgj6w==
X-Received: by 2002:a05:600c:1e1e:b0:477:f1f:5c65 with SMTP id 5b1f17b1804b1-4775cdf2719mr42995665e9.23.1762427783555;
        Thu, 06 Nov 2025 03:16:23 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47763e15481sm13500995e9.3.2025.11.06.03.16.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 03:16:23 -0800 (PST)
Message-ID: <e30fc02e-7fe3-4ba7-a964-91a0b082813e@gmail.com>
Date: Thu, 6 Nov 2025 11:16:21 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/7] io_uring/memmap: refactor io_free_region() to take
 user_struct param
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251104224458.1683606-1-dw@davidwei.uk>
 <20251104224458.1683606-3-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251104224458.1683606-3-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/25 22:44, David Wei wrote:
> Refactor io_free_region() to take user_struct directly, instead of
> accessing it from the ring ctx.

Fwiw, it might be nicer to wrap accounting into a structure in the future.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


