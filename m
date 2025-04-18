Return-Path: <io-uring+bounces-7543-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBBE5A9391B
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 17:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BAB63A5BDE
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 15:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E077202C36;
	Fri, 18 Apr 2025 15:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ED631kkn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA52202984
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 15:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744988770; cv=none; b=eTfiF7IWLUM/HKzLNlUFtY6wn+MetwtI56pZsE96FCy4fmpc+SbU2Bn9ZoXs8+9MS5sG6L1VJqVyLNfSUI3oTZwmKEbPoXIKW4iOxyPb8RXstLDSguJ3PncBbgl1FZEK1JGLDUoFJ4lBmK2Q+i1EcmcCjkix6qXs9ytREDTw0oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744988770; c=relaxed/simple;
	bh=XOsGNriCMTroSXOWulEwW5h2icM+w07/M6IHtVwWQl8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rY0ZDGbznuztOrREMkmgaBF81S4WbutwFhTO4DrG8+QtPHoqosFbhjS13aglAoyJz+CbSmkghqFUBONMksUEgNENz303Db1O2IXC7PAVQb+DPxBpUJju8yVbYuCnSvsKWKv9gv+/OoE8q4o3+dckUFBEhJQoSJcByR8GostkPG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ED631kkn; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-736aaeed234so1713396b3a.0
        for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 08:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1744988768; x=1745593568; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1yUpiK4onVG0Br+9mMgEA/Nyxtde9VkpCezmT0yGbmI=;
        b=ED631kknJcxCFuJo8gKmtcakgNMPaq4LiNGxzKtn2/C+SHGdQnLIpzJ8Iwa1UdfAmD
         6U1GhOCriGVjJK2PjzT2vG1E9AdDGEmzWllvomsRhmkZGqyIgVJ9hKiXyx2NYBFxJa/c
         o8MXF5+LEtAAeZuz8iVE0lFppKyh1+9ahiO7A22SQEZFnsX1POBv0IEuxyRLiZehB+6o
         S2XRn+XuDLxXZ5UIVboQWiXlKH4f9NSsAceqVni0Nnu8dKoealVi5M/SVE9BYHhYpXV8
         AIl26dkjoMp7V5ZoT4r6vLubehMNwLi5j+vzDEN4oOj6f85ZuMKB+Ohk2Yy2DL0cl+6j
         Ezbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744988768; x=1745593568;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1yUpiK4onVG0Br+9mMgEA/Nyxtde9VkpCezmT0yGbmI=;
        b=hu6vJG0wIDJrQoWKN14fn4Zvfvk4SDwhf8L3HcsaT/SFcMiDgDITAeg+cjxbv9s6sA
         fRSIGTWJzlnkQ3cPFmNZOD2Bzm1JmrXtW+GDpK+mkWBLPHh6TR6b+pXQPOD4exAtmRI2
         bPcTQgj9QTiMlp9WIbuyPILS3pNlB2txZT7xLBqpf/sjXyAiEOYOQIRg2e6AmrgyAz/F
         eBD47n19iq8otX4jXtAT+9zDBlcJYttC4MgXWdxbpqo8VavTN3ztsbyF52QcbFEh2aEr
         nGWfhtlf9RCUmQxwADrL140X+zoxuVaZCWEXXgKSN84H/icS+lwjy96Sz+JGb6+WwdiO
         ZRvA==
X-Forwarded-Encrypted: i=1; AJvYcCWTuNbgdp6nBuwuL900haASsLxz4THNR8ed6KTovDwY/4f1W/f5IUe+svLSTl5wI7EbRYxBAo2XqA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLLhKIDoh1hyiH1Np6BkNAwN0RiPzIrZaHDiwLPMmCMh6cQ6UX
	KlYCqgfoOSwVbtdJHmiE0s/py1mn3/ciTo1XF9rChlm7cQj9qxM4sr43+nFGAQqcwJIQZAFAt4c
	f
X-Gm-Gg: ASbGncueGDsePo8S4Ad7e9k6Oai3DFnOCFiwfyHeGMm+AO/ocZOjp8Y90WabJBx2LD3
	jpsx8rv6EbLS/B4f0RIV4O0BObyHz+6mllgzq2QUeR2HjQZrLuXCLf2nZ8MJT/4PkTjZ+rhKO51
	8wvl2aheb0jExohQP/I1ldJd/l5081Lzj+AuVcWWQ08prJ+7PrPrjPUljwbDoaNLE9rwhTpGzU3
	xVK9g/XwCFCzcD9Fvuo5+jmFxREq/x8Q2d4rG+PHa7Cyhvn4qetzWLz1c5f3dva6CEHGt3co5D0
	axfoqPlTjigwhE8tyVhnIebO6/4CjrJrlFcHersLaExFP0MDZLcA9MZJa2eVUugVV4hvQxyXa8T
	mCuM=
X-Google-Smtp-Source: AGHT+IFUeHMxtUHXKfY22ocr+HVPL8OSU2JhIBpSyl/3MosuWA5aOsRwG65YFimzy4LReAZOryJOBQ==
X-Received: by 2002:a05:6a00:2e84:b0:736:32d2:aa93 with SMTP id d2e1a72fcca58-73dc15c5c5dmr3428317b3a.20.1744988768241;
        Fri, 18 Apr 2025 08:06:08 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:1cf1:8569:9916:d71f? ([2620:10d:c090:500::6:5122])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbfae97cfsm1687008b3a.163.2025.04.18.08.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 08:06:07 -0700 (PDT)
Message-ID: <0d7e62a4-faa2-49ce-92a5-a852cca72ddc@davidwei.uk>
Date: Fri, 18 Apr 2025 08:06:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] io_uring/zcrx: remove duplicated freelist init
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1744815316.git.asml.silence@gmail.com>
 <27d0a2165f1890c039e873563c19c7959c1982d9.1744815316.git.asml.silence@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <27d0a2165f1890c039e873563c19c7959c1982d9.1744815316.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-04-16 08:21, Pavel Begunkov wrote:
> Several lines below we already initialise the freelist, don't do it
> twice.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/zcrx.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 5defbe8f95f9..659438f4cfcf 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -238,9 +238,6 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
>  	if (!area->freelist)
>  		goto err;
>  
> -	for (i = 0; i < nr_iovs; i++)
> -		area->freelist[i] = i;
> -
>  	area->user_refs = kvmalloc_array(nr_iovs, sizeof(area->user_refs[0]),
>  					GFP_KERNEL | __GFP_ZERO);
>  	if (!area->user_refs)

Reviewed-by: David Wei <dw@davidwei.uk>

