Return-Path: <io-uring+bounces-10218-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB6AEC0A87B
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 14:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 216143AEDB2
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 13:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C00FC1C1AAA;
	Sun, 26 Oct 2025 13:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K4DCAOJX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7C31527B4
	for <io-uring@vger.kernel.org>; Sun, 26 Oct 2025 13:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761484595; cv=none; b=r46EABHRaqvNaji6+Udek+XoPWg7ZUX9Jya6pUAGTkjLAIuQxADtvfaijtvFMS4Sy+1d3IvepGCFTskGBpcpud1Hf8ItQ53Q0GddocnfhgsU7ALGZGB9vz9JBBIJvpl6q9PHr8VasW4uE2sIbSkF63QSL16QWx/HONCb+BW82cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761484595; c=relaxed/simple;
	bh=SERo0fpHLJ6iN9CZvXvaItAVNwQzTh5UAwKP7FYDghI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KqFNxL7agt+BZCeAKOziqUwK6BmiSZF+sHKskmcdsZQ0ZmYiOxVoNRoJugpmlud4DPE0KYD+cL6eVzem3Hqap1Yqk1l7zTkpMNawXj92P5d8e4nd5Dyr8mxPV2CpPvnhZFpVKwt0B5Gr8X5004iBqUmhR4IxHbIDHDGiQN0fvBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=K4DCAOJX; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-92c781fd73aso382994239f.1
        for <io-uring@vger.kernel.org>; Sun, 26 Oct 2025 06:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761484592; x=1762089392; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Je2G6oS0diRsBc1xkoypa2q+3cXAdySawINjZn0hOes=;
        b=K4DCAOJXcOR87xnT3rI6SUlnE9nU96qH6cRHiy+Z/OKc44i8ILL3cnLDwae9w/pBbj
         kK+GkhqekXPse3FgDWmBJQZ424o1AQr3omUwKwURKz8fYbAhd0zzQ8liKXmFTgLglVGN
         wpo9fYOLer9O2OW6Ts++N3ESmriYW7d8k2pcaKdiRBk4tNpmXulNwOV5W8oRQX859UIp
         /kEoAPYvpPXHV0RDumnNQQHk3iLFdjFMCdcuNR8foaC+mwc+NVLAqZ2l05dDBe4E5J9g
         wg7iPPGtR1lYoUzCA7+JbZ1XY23zSS9EXQegdYAukMAmnB8ZK1e7b4KnUI5o249aQ+Kt
         5FnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761484592; x=1762089392;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Je2G6oS0diRsBc1xkoypa2q+3cXAdySawINjZn0hOes=;
        b=GbJ/O9Yy7OuVXV4uvjdcHtSiZLPEWpFnXOmxWAxS1kChMjWHaUVR/b9+Ije1VgGX7y
         JxCFhEXKoP805fjWo9cXwTkfpbZ3QcZiEezjZma0xE2yVi5D9Fua3mrt6bswu8S11y1j
         Yqa24lnPJB7dlgDVlriGuycrRW1GQKyUx4g2XZdrgHDImttCANTly8NjHN4d/nuIi/ek
         /XY3uinKzXkX6IB00qdCqbiCIjc8gCqpu3rWlSGwxkJO+Z8cQ0LQ1o9fPk7zO2fyxWc7
         aBRexeG2kMH2hw0k9f0Qp6hvJ6YNW0KH5l7eef/LcyiyfdOK/aish5Y4J8FjhZc9kixG
         KnyA==
X-Forwarded-Encrypted: i=1; AJvYcCWu6fW3fGDuj4kAWWzK3K3UsA+OSpFLBSCPK94MEUgdCpmaUEzjH58mc9leX/BLiaJxEvO7gBVZEg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyqs8HPGnOvuXLbTLD6zEoDbvraf9ex2DSYL4Yi/AaVaIIoI7/8
	Et/dyg4pX7KFynxAOyrNen+LDIioi6L5lFT9UBcIIA8/WWHJWFy1/j69o0ky3E9tsoI=
X-Gm-Gg: ASbGncsib8HAF8TLHoyKwntLbrrSJdWa2duLozx2bjwemwaESpSw3YvQ2SB1ssx35Vj
	FrS+idMKoBIDclHiPKCtlGcgDY+dpbiMfyUSkMoRIA5YhZb9zNBjhspAD5qLjuqpUtTIg4sXKaR
	jg9QLSiLsrxmmUfPaBr5GCYg1t8DO2Ua/VlJPe6kLE8MWhQpvpVKfetW7wPuAIcWknpN1NzYOyA
	oijE9Wzna7+9DRoYi03zwYu9qVnwkIrH3EreB6wkP2sNrQLIJxoeFIVLJniXd0Vstg5prb0borq
	pD9fK0uduZ/XEb5zLc6/rvneOm+96DL+rIZQ0t7y9FRKzN5q1iCKD/WIGciRwgFUAbMRdimpWqx
	srE6BvSlhuIGqAlR0ZJf7hSDkutybuQTDWNC8pQvjgoy6LztpilXsLGTqLO8acB4pLDX7x5jSgu
	CBq2gZ7Toy
X-Google-Smtp-Source: AGHT+IFYc55UFA7cxHsnoKidSYgwjCNGGkmSuK1XFsIhHJj5qglvRcSPZriyxg1o6xWyafqqzNnJ+g==
X-Received: by 2002:a92:cda3:0:b0:430:c1ba:3558 with SMTP id e9e14a558f8ab-430c5268daamr314115775ab.18.1761484591776;
        Sun, 26 Oct 2025 06:16:31 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-431f6899e76sm18805135ab.34.2025.10.26.06.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Oct 2025 06:16:30 -0700 (PDT)
Message-ID: <3a7a2318-09fb-41d2-9ba1-9d60c7e417a6@kernel.dk>
Date: Sun, 26 Oct 2025 07:16:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] io_uring/zcrx: share an ifq between rings
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20251025191504.3024224-1-dw@davidwei.uk>
 <20251025191504.3024224-4-dw@davidwei.uk>
 <f1fa5543-c637-435d-a189-5d942b1c7ebc@kernel.dk>
 <ffdd2619-15d5-4393-87db-7a893f6d1fbf@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <ffdd2619-15d5-4393-87db-7a893f6d1fbf@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/25/25 10:12 PM, David Wei wrote:
> Sorry I missed this during the splitting. Will include in v3.
> 
>>
>>> +    ifq->proxy = src_ifq;
>>
>> For this, since the ifq is shared and reference counted, why don't they
>> just point at the same memory here? Would avoid having this ->proxy
>> thing and just skipping to that in other spots where the actual
>> io_zcrx_ifq is required?
>>
> 
> I wanted a way to separate src and dst rings, while also decrementing
> refcounts once and only once. I used separate ifq objects to do this,
> but having learnt about xarray marks, I think I can use that instead.

I'm confused, why do you even need that? You already have
ifq->proxy which is just a "link" to the shared queue, why aren't both
rings just using the same ifq structure? You already increment the
refcount when you add proxy, why can't the new ring just store the same
ifq?

-- 
Jens Axboe

