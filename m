Return-Path: <io-uring+bounces-8051-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC117ABF033
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 11:40:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E7653AB105
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 09:40:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95015253955;
	Wed, 21 May 2025 09:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fJGA0B8T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B681A3BD7
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 09:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747820448; cv=none; b=s888gXYXu1V+Aqw9zQnHKoIsAdPWDaGJLfOB1fDBg3F9yjTMgt5mytkcOxREJgXD29jDl55dIyUvhB6Sj2SS20OQBY38EmaCvbgIBqjUSsPntKO53t6rD0i2GbXMlTfzHRxOauszUkjJcfcfbmaObUZvSltZyRYtws0clpcmw1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747820448; c=relaxed/simple;
	bh=C8btEgnc79P+7ipJRYQpSVK8gt6liPrqYsUu9q3Q5d0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lQ6nAzDdfzraR4FjumFeHFXZjXpEcG32WpJRhdKRlAeuuGMOZsYTW0vZJXesHA5YDsvFR1H7L3E8SaXMDSi2Wp2bj5IBJjH5PoFrS7gUyKun0zb44Ljo5flP0IDvoO1g4YskkUw/bYEROrTV2Lj4GzARXUH9Ykg9BwHAU/4Bo1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fJGA0B8T; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ad51ba0af48so1038783266b.0
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 02:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747820445; x=1748425245; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j9RbPe4epQ04tseBIcUyuctMtOREfVg+nP89daxHlrE=;
        b=fJGA0B8TIA7VaNvNTQg9HuaWF0A7w0wVZZ0yf/jYuPjyUxA66fTdP6aFKYY1h/CAQ1
         b3FxlEuwqEnEjL5ojzB7vbOAZMEfysPaNLG/pagews8EiyAMi1idU0nbi6T6zsf8LnH+
         6ueGClpTbZ9CiGh7NM3IkSM6ioDQp9ClSGoY4bzwtWXyLdMZC/yIIil3J+vgNp5W+dav
         48lwHidjBFYZHmoB+rLuTiEnV8tnetazxyBma95fFqwWvUdDvqLXz6RsK5XyoFmSi/id
         7Pfkq4ss+oanvhbFxWzMGCWw2g4yuz8Twwx2v/xakgW/HGhl2cay+CmLsKM84qOJJ7xP
         0ILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747820445; x=1748425245;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j9RbPe4epQ04tseBIcUyuctMtOREfVg+nP89daxHlrE=;
        b=FW7wPqwhkjInR4K/5TGAnoHyh/pWvJDKErmwd6c06ZeOp29f2qEi5Y4ly9fgQeGoUC
         2ERa/V0zuefBDRapQjhIsmcibjtLNMpgPLxL50viTBpfYNHLYYuYg/wvre2vkS4drAC7
         wF30ObMWEZ81HhKXRFDxz8YkeqL7dBYUD4uBbIdSVktZuUq45XvqPWo7aU6c1GvdL+7g
         kXcfaf4IyzMi3THUIGSIQTlMgbih5vSW41GtoLStfKXxFa5U2eBX/HYEmRDscEz8KTLO
         E5107EJbAv+Eh2IxbrKJvtfCk/zJGNuUmBj8g96foYbJa3Ulj4wImnjHSDVzbkQVdbRY
         F8KQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTj/mDhZi2X66DZvkfPv2rQgUeSVCk+QZBSRhBWsuKF52iJ6tubC4LUmFV2mYkarsJoIEl00Feqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzabsjvX4NlyjoiDIR7G+UzhtdqzqGMcfbABMeu3eXLex3+Vvgy
	TRjja0RQoGsnwS4JwhVoxRDjW0l8FTOsdUht+l0cX3//dwU913q1qQK3lw4Yug==
X-Gm-Gg: ASbGncs3ut4O/rtdi7E5sxdmDwKDUFqkWHnaJl8zSTbhG9nNMIheVvxgTh8gTKI1pbl
	3L6255CHyqwhW0gix7x3u/s/xpcAnPk3l/2k/1H+5pp3Dl28/1spRd79r6zEm+H/H78k9GEL7Iu
	G2S+Y23ShK699HY1BfP65kRU3xekL2O7SgWbXepuMXmFHTo+Pu3SoY3NVHLrMeMXsI5eVDTNfS5
	MTcXPrKm0CoFNtzTPrhJSpOjzImShQE/hXptJsHmeT1vlRxLwbbzeSCSx6K5UNaKHXIwOHLGdys
	RamU5oRJrrBP7Pj+1r9XM2LTg2z7dzpJbVdzxpPsQ47i6s49IKp9CA7RpcxPfg==
X-Google-Smtp-Source: AGHT+IGkxROgY/AyweOuhHQ9YLNwbf4vgnuqJF+QISYK5IGlKg/j0DbmjWngVj5cp8gxcBz+qhxdxg==
X-Received: by 2002:a17:907:6d0a:b0:ad5:4cde:fb97 with SMTP id a640c23a62f3a-ad54cdf0454mr1477358966b.29.1747820444672;
        Wed, 21 May 2025 02:40:44 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::3de? ([2620:10d:c092:600::a96b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d4395c3sm869500266b.109.2025.05.21.02.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 02:40:43 -0700 (PDT)
Message-ID: <7e846c8a-3506-4581-bbc5-fdf9e084a5bf@gmail.com>
Date: Wed, 21 May 2025 10:42:03 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] test/io_uring_passthrough: add test for vectored
 fixed-buffers
To: Anuj Gupta <anuj20.g@samsung.com>, io-uring@vger.kernel.org,
 anuj1072538@gmail.com, axboe@kernel.dk
Cc: joshi.k@samsung.com
References: <CGME20250521083658epcas5p2c2d23dbcfac4242343365bb85301c5ea@epcas5p2.samsung.com>
 <20250521081949.10497-1-anuj20.g@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250521081949.10497-1-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/21/25 09:19, Anuj Gupta wrote:
> This patch adds support for vectored fixed buffer I/O using io_uring
> nvme passthrough, enabling broader testing of this path. Since older
> kernels may return -EINVAL for this combination (fixed + vectored), the
> test now detects this failure at runtime via a vec_fixed_supported flag.
> Subsequent iterations skip only the unsupported combinations while
> continuing to test all other valid variants.

LGTM, it's great to have the test, thanks Anuj. FWIW, that's the
same way I tested the kernel patch.

Somewhat unrelated questions, is there some particular reason why all
vectored versions are limited to 1 entry iovec? And why do we even care
calling io_uring_prep_read/write*() helpers when non of the rw related
fields set are used by passthrough? i.e. iovec passed in the second half
of the sqe.

-- 
Pavel Begunkov


