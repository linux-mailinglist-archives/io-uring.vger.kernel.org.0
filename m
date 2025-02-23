Return-Path: <io-uring+bounces-6645-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9887A4120E
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 23:35:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C134172FCB
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 22:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 855451624CC;
	Sun, 23 Feb 2025 22:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ds9udbtV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13DC1DDE9
	for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 22:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740350146; cv=none; b=CL2t1Lyx7l5y8+9N9qFlrcCLrAaeegsW0GZoiRJEfgl6bDxpRDppzoM7GU4P+VlDnZuUdW1BugzIi3uYn7Cgi1TM7pjOUtNYiqHmhAtTjDC9PbY8bk+WdhZ/GaY5eYl2xTMZlsSEEdgB6O4x3gN/8/2aMgw1MrgCn8dlA9ND/cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740350146; c=relaxed/simple;
	bh=VqP9EcUdSbs4sLzPe3bpBtTGWeAesXMh1064J7F6YVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mM9qS7TPNQPx6kQUHD8ZE0fX1Ud8+BylUNGRGw/ZMYqrAGLte50csLRgLZ0YozAHvh2nbJmy38GBsskzjy2jA+5djWSLttvqizbpxD5OLcOMYYu/N/o3Kwpyq7HuhLQKYa3CdmyKXyvM4r7uZ3dQNnZyY/4mPF28rHrA6afAHNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ds9udbtV; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-220f048c038so70838525ad.2
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 14:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1740350143; x=1740954943; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hpj8Ef4KFM4t38BXliHrkDLy1brOEFRjxIKqekRsoQI=;
        b=ds9udbtVNTpbZBsUsOvuRwNNSaB4PrKylkbjzRhApMOkG14R2juLuOGG0lwNvclZWx
         Y3Q7Us9+eO8cPZuJfXjBxw/zxh9hgLAajU9Zdgf+ReFARTi4LixWkH3MvVlbAu9k6itd
         IVdR9pC3SIH3Zv07u4PAEbE5SGNIZhgQjPscmBmBdGP3+qId2hm5fFMi3YIcuFL0tmi7
         l/0id8LMYUARqbRAGEUIc9f+FOvUv/B1kTpxJyRfgdhRE+NdIv6aF1BiqgvPjCccCr/P
         v4K1Oq8AomsOFafGWici3mYZnSmJsCigGmvbR45oZaN+U0C6u4fABqH+TNd3lnijcg69
         QM+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740350143; x=1740954943;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hpj8Ef4KFM4t38BXliHrkDLy1brOEFRjxIKqekRsoQI=;
        b=dq0h9bQjHAYkYthpTEfMt4ikoYBLVR8s5SWC+Fx0mrTOk15DUeuqgjScjVkX9pqGwB
         Tj0Y6dgiQY+vZ7O+H5HHWgStjz99D+U/gP7qCghMaiIsdxTP+EvAcUJjdAa0PYLVOHEv
         bgYny81/6DTCFPZpAUm4vniW9yOTVWzcsdvQs8woXE1ugWFZaoeZEpsRv1GMFeROEc96
         lC0dRMWUBB7uxa0NBLWw0RSbLFXtcOsquneIWrVv4OgOgVZbzr6WH88RRdwWU+jndkHA
         hp/1l+xJC3GvfMHuIa1YLUiIDhdg2YEkAlj+pmKY8nv0Gt2b32k8A9QTt92TR+75xRhY
         CBHg==
X-Forwarded-Encrypted: i=1; AJvYcCW9i75/xhcW8V2BSL7CYr1kZiyiQcFk/KoPE+0klgqrfBr3GvDteLLNcGkX0rAiNOqBGKsUihSIiw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4lGiNNwpk+bUTHG6FHs8+jFlTw9HrZg4dMfD4qEe88cZZ+07E
	RinkmV5VorZ1eYR9D0vEVLvqpHM+AVMM4bnRlMi2GgNP200t9ukdLB6xP0Zv/fI=
X-Gm-Gg: ASbGncsv6K7JTpcwyN90pyFiNcPFXL2vymBv/1jhN/7M0GF3ZiDOhcpouhHacNAsQVr
	DUU2ul7t4au4lXvzXr44NNoleuSm68bs4bDWi4wCCV4QMizLrXC2eEocEvF1GIzyGemRS5/AAM9
	3bfLE4Jp2/mxl5UrtvzW83+2/vews05mXZXSlPirAt9SZxzGQzvHr0xdI9olmg5vOL84oCo4ZAE
	oiOQRaeb+dOx2c2JK6T9dLbMktI2RLZFcXCgPpT47I2pfBTqg6u8+zs91ehaCFEuJUzasodC80D
	6xxU1C/WuqPJCecNPZ054hwLOuiO1CIc
X-Google-Smtp-Source: AGHT+IFvGF7YLzsSjdcedxB4Q9G+8uk8mmfcUtRCoinHnMdVeFdhNIVywFjMjZqgkypLXWqkxSDFWg==
X-Received: by 2002:a05:6a21:9988:b0:1ee:bd99:9c71 with SMTP id adf61e73a8af0-1eef3cdcb2fmr21733827637.24.1740350143080;
        Sun, 23 Feb 2025 14:35:43 -0800 (PST)
Received: from [192.168.1.12] ([97.126.136.10])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ae0c6c25cdcsm9612962a12.23.2025.02.23.14.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2025 14:35:42 -0800 (PST)
Message-ID: <a9b1f507-91d6-4e9e-baee-f8dcb4e1a48c@davidwei.uk>
Date: Sun, 23 Feb 2025 14:35:42 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
 <9d081ae3-6f9d-48d2-a14c-f53430a523d0@kernel.dk>
 <f8409430-a83d-4bda-a654-3f9bedb36bbc@gmail.com>
 <16aef2a7-d20e-48a1-aa5d-747619c8a2c9@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <16aef2a7-d20e-48a1-aa5d-747619c8a2c9@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-02-21 17:07, Jens Axboe wrote:
> On 2/21/25 6:01 PM, Pavel Begunkov wrote:
>> On 2/22/25 00:08, Jens Axboe wrote:
>>> Just a few minor drive-by nits.
>>>
>>>> @@ -1250,6 +1251,12 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>       zc->ifq = req->ctx->ifq;
>>>>       if (!zc->ifq)
>>>>           return -EINVAL;
>>>> +    zc->len = READ_ONCE(sqe->len);
>>>> +    if (zc->len == UINT_MAX)
>>>> +        return -EINVAL;
>>>> +    /* UINT_MAX means no limit on readlen */
>>>> +    if (!zc->len)
>>>> +        zc->len = UINT_MAX;
>>>
>>> Why not just make UINT_MAX allowed, meaning no limit? Would avoid two
>>> branches here, and as far as I can tell not really change anything in
>>> terms of API niceness.
>>
>> I think 0 goes better as a special uapi value. It doesn't alter the
>> uapi, and commonly understood as "no limits", which is the opposite
>> to the other option, especially since UINT_MAX is not a max value for
>> an unlimited request, I'd easily expect it to drive more than 4GB.
> 
> Yeah that's certainly better, and as you say also has the same (forced)
> semantics for multishot.
> 

I thought about using 0 originally, but needed a way to distinguish 0
meaning no limit vs a limited read hitting 0 and completing. I could
store a flag in the request at recvzc_prep() time as an alternative.

