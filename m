Return-Path: <io-uring+bounces-3302-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B62985C14
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 14:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E8C01C24789
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 12:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99DE1865E2;
	Wed, 25 Sep 2024 11:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i5cGB+My"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E9121A1C;
	Wed, 25 Sep 2024 11:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727265461; cv=none; b=VnFosV+UlGpRHl33r7dGLnf2kBf7yh5pGRkLT18xe4mNGwlAIcT9FAtEw67bxSdYZ2fxy1DEDs+Tnv0xNm8i4syNsHmJX1XVYa8k6qOsoncPk35zSP+fj1Vjo74tTB0zfXAPnY4/8hMDx2s+4hLRxYpylNilBJdPQ9t/+OfovLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727265461; c=relaxed/simple;
	bh=G5Td+WWrfizeS2lkkwKWDxaZwUm6k8aZ3N0P9CYmwEo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tzz1cUnYSaYnT2QpB+iWLKS/97wiTmYFatUmItGOuANsa3evpXF8F5mu+I3egVOnNefyA/wdVjSJO0kWL9hb9TzVE8xnFwyMxLjb/oEnWj85auacO7sB1842eFkFCMrOPdGqfFsQcWfxcXQPgd7VH9lT+FUJ2gKESjnqC/fB8R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i5cGB+My; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2f75c6ed397so70415641fa.2;
        Wed, 25 Sep 2024 04:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727265458; x=1727870258; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BmlT8mVz0poKewfRg9p15ADjJkRKRpso2Nj7MuaKVq8=;
        b=i5cGB+MyRPlIUzn8dz+YM/SEkxGS00NkMWqnpP501gke30Ts68AoAwFqigbubKKFjz
         UQyomgHN/C/uQX7+sGInRlP7F9Qo5LtZrYB88Wx0LBvw8R+KDy37eLvG+wWSpcehy+ek
         Czm/MsN4s6Od9Zb93tNJOJmEJtFfX6l+E6D1bv+HeGdXs1LROBc5dvipBTYd0281RsXT
         t6vQpDriPMp3PmBoA31Uxu5r20K2CqRTbOg5E6APE7iGYjf3zV4sMseNZ3nEhAVIf6ve
         p2eBqKZMWWvdCSiSWB4sD+WxgUqXhBxSYboOFy1lzPY6xLbFZ+asxDdyJIZP6ykar24G
         Ldkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727265458; x=1727870258;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BmlT8mVz0poKewfRg9p15ADjJkRKRpso2Nj7MuaKVq8=;
        b=uxt5AYbkHETXOyJGxkfjwehhVqQfOW4g0HpUHVSjBuebDch7Msm7Eib5W77qaigYQt
         qEIAAXvXPyYgvmllsEf+3h3GvTglglfVl21fBF7IJSNxc138VmrZVEbpfqlKCzPr4808
         OZNfv79iPBBXzxsDfrYf1JsGvgb9Swrq6+OEW7zGmqYrhA6nCLm7MIdmgFEGqNievgnf
         M7P30mpDSk9cJzG7s8Cm7KFixeMs7wSjcI/l9cw2wewz+xCKAQlrVBVqk0iNa5425E6z
         QMwMlmBGWOBj4yQbhS8Smc3iA6xEXd3DGp6Tru6AqeNjyobzZsan+vXwtY2efMj0/XIN
         I8ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyIGmQIebpsuBm1Rgj+mUbzha9JvcqTKCvI9lTegCCnChi9jmGGa6HQsJq+rOKwpQyO5YqxBmCbyWK37Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7V+ZQ18xWiZQnik001GDsRsKY9BWfDIQBf4/FMDUk+bQY2Q1L
	xoaNc+SBNG/IeyktrLcim0fiQGWRJdpUnIzmGnYHOqsqCW+Wkev9+hBrYAlM
X-Google-Smtp-Source: AGHT+IFIcuDJ/MTLw4ON+iRrc7fEGM33mnlKzDZ0rV+YJcV1corgdL97dhlVovAOoRBPdCHASA0bZw==
X-Received: by 2002:a05:6512:224b:b0:533:7ce:20e0 with SMTP id 2adb3069b0e04-5387048b8demr1585664e87.8.1727265457610;
        Wed, 25 Sep 2024 04:57:37 -0700 (PDT)
Received: from [192.168.92.221] ([85.255.235.163])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9392f347fdsm203991466b.16.2024.09.25.04.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2024 04:57:37 -0700 (PDT)
Message-ID: <1f21a22b-e5a7-48bd-a1c8-b9d817b2291a@gmail.com>
Date: Wed, 25 Sep 2024 12:58:17 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 RESEND] io_uring/fdinfo: add timeout_list to fdinfo
To: Ruyi Zhang <ruyi.zhang@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 peiwei.li@samsung.com
References: <CGME20240925085815epcas5p16fa977581284a81dae7b67da8bc96a85@epcas5p1.samsung.com>
 <20240925085800.1729-1-ruyi.zhang@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240925085800.1729-1-ruyi.zhang@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/24 09:58, Ruyi Zhang wrote:
> io_uring fdinfo contains most of the runtime information,which is
> helpful for debugging io_uring applications; However, there is
> currently a lack of timeout-related information, and this patch adds
> timeout_list information.

Please refer to unaddressed comments from v1. We can't have irqs
disabled for that long. And it's too verbose (i.e. depends on
the number of timeouts).


> --
> changes since v1:
> - use _irq version spin_lock.
> - Fixed formatting issues and delete redundant code.
> - v1 :https://lore.kernel.org/io-uring/20240812020052.8763-1-ruyi.zhang@samsung.com/
> --
> 
> Signed-off-by: Ruyi Zhang <ruyi.zhang@samsung.com>

-- 
Pavel Begunkov

