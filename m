Return-Path: <io-uring+bounces-1875-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 516978C328F
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 18:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 041431F2165C
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 16:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 524134431;
	Sat, 11 May 2024 16:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="a3qvAlh7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DE87F
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715445816; cv=none; b=QYIvI2W499hd9eRMMjmBtLqUk7SY4ztFrxiZPp7CcxitT3jwkTLl2Ai7JCTJyRSafuisP2mwTNFzThnEsgTJI2TJM2K2/scGTEq/UIxSeFUpXJElNga3fJ3L/WuUp1ubDmc9IJektfxJ1Jl4OSTI1/bsmNL81sbF52KXHOOouoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715445816; c=relaxed/simple;
	bh=uiNE4Pe6QDG0gDnmVjX2O7KS3JJWPx2mnl/v/URN2aM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o5rUjv94cPfeqf5vUZw1QfrXgTZaoGvrTAhIBbHJAjeHVtwJ/o9xJHkpyVB2UyHGd5YD/SbsvyIeXJsYQuXY+V2Hi6Kg1ZMvwQJRJkT6CS/jnqUhouNvWOyQ2nDWFgZOG8f2h5nEyKAqtYO3Y4lIegwbgXb66ueo3LPeVULg+BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=a3qvAlh7; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2b620b0662dso827609a91.0
        for <io-uring@vger.kernel.org>; Sat, 11 May 2024 09:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715445813; x=1716050613; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+i/fvj/eoaqxIwWufvw1hFxFjZrJgyoFymEpBQO82WM=;
        b=a3qvAlh7MlTmK/FaMCZvWZZ7BgH2HMT6bKOV9dz6+eaj5/e9XnDPgxddcHRQCXpsG7
         sP9OMIwRSlNNWW0s5oEfvWBYbVtHVLuiwCaWgOZhRcqyqyFduRiSa1wsOouUopRqdjqI
         AGodIp9pJYdS+kFw7EsGsRPwuXNHyMwLyVm3JbIdv3TNH/QFHNeIZ6hAeC3wHyfZ5o7a
         6QL0tGQtzXN3PHvzIsQLJGKBypEIehh0woTkTsgCM/Uo6PPdJ+Ez7ialNS3wsz92o9TA
         IOl7p+1wSV+FYNCAY6wRFZn0atXNNwmF/d8Gkyh0p+bfBlUO928Gss3IojHf3vW5WNUm
         OwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715445813; x=1716050613;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+i/fvj/eoaqxIwWufvw1hFxFjZrJgyoFymEpBQO82WM=;
        b=YpLgRhdhZqLpr4TNSqnwrB6D2qB5lyHXDQg4drxiNrGIqsFtXtiNn5HNRCfdm4T2X/
         uIsyJzmgtda+QQ3vBX0+BuNwkd3tZhgnmRwKoBpoo21d4FHM9r46LLOukSf3FWjZwH21
         D0/n/6rvLVIOLmO2xXl2GZpRIR30T4XblUUqeyoXpWyQs2SdIleLB6ynanxC4LNyK0/i
         Rus98Rtfkhb0vFHyRKmRqBb9UtYvMM0t48uXNL8PamoPtOtTSw41ar4M/RektIDW+lBo
         VcAoUkFqRApl4sBlVu/ZhvwgcKF62v00W5NQ4HtV7q/SMPvoThvsOFayJNo1HfBgaSfq
         oWjQ==
X-Gm-Message-State: AOJu0YwTF+cxTH4Whs6oaEbEBt0T55dJr8RJADWBdGdWYUvskIyBWNxj
	HMd3oznI72xlw1Dc3nlgkMDf1+zqTdH10i4wz87hLZj4vO2DMA5fhUwxetV4rIs=
X-Google-Smtp-Source: AGHT+IFA02HkiIwNIvc6Z5U4Wr3yk1pCL5NjcjXzerFHjEnublEe+ZN6Y99kSZPlLDy8t/8rRZyFjg==
X-Received: by 2002:a17:902:f68b:b0:1e7:b7da:842 with SMTP id d9443c01a7336-1ef43d2a424mr66691815ad.2.1715445813098;
        Sat, 11 May 2024 09:43:33 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c036952sm50596395ad.214.2024.05.11.09.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 May 2024 09:43:32 -0700 (PDT)
Message-ID: <7a8b2be9-626e-4f5d-a7ab-238637414bbe@kernel.dk>
Date: Sat, 11 May 2024 10:43:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] io_uring/rsrc: add hugepage buffer coalesce
 helpers
To: Chenliang Li <cliang01.li@samsung.com>, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, gost.dev@samsung.com
References: <20240511055229.352481-1-cliang01.li@samsung.com>
 <CGME20240511055243epcas5p291fc5f72baf211a79475ec36682e170d@epcas5p2.samsung.com>
 <20240511055229.352481-2-cliang01.li@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240511055229.352481-2-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/10/24 11:52 PM, Chenliang Li wrote:
> This patch introduces helper functions to check whether a buffer can
> be coalesced or not, and gather folio data for later use.

Introduce helper functions to check whether a buffer can
be coalesced or not, and gather folio data for later use.

-- 
Jens Axboe


