Return-Path: <io-uring+bounces-10219-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C2B27C0A89F
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 14:43:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9C5BF4E1BE3
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 13:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1108B215191;
	Sun, 26 Oct 2025 13:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zXQRJEy5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDCC1527B4
	for <io-uring@vger.kernel.org>; Sun, 26 Oct 2025 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761486230; cv=none; b=c9wSfo/Mkx33zIcWpxgt2DegkwrOAkO1jiXYW1nnU4reNqjnlmzbNUOo0b3kVQLZyPHQVdzkVLtHgEhmmO9QzpPS4VzHbZYmu8pvt3FCC7/T99jmwryDDpb/bnbGih6OXsLQ0aFPVWmmVcSLBMJ1a1xdaP+IiVW7eWc3S28rxnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761486230; c=relaxed/simple;
	bh=1n66Jhm9Uz/eV2eyf9nb/Pyi9bQJbc+BMJRG1KIYu2Q=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=dRXTUywY0hjPT9iMRv0PJGmRiDtoOdvrgTlvr3bby7RRgNb3GhNffBZXeXEztw/k4gKPbM1zDyKzawf/fpoM2etnLt59lNmOhaRfHNWDMXCZS1+IUvf91y1TFhj/VLQWaoEbKla+jpqiK9wRx2KBBNgjg1Zhtg9HnnQbE/R+hng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zXQRJEy5; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-430aeaffeaeso15629125ab.3
        for <io-uring@vger.kernel.org>; Sun, 26 Oct 2025 06:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761486227; x=1762091027; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Bt998LNx2nbYBgDO+TmmCdOEKtpEPTHI4UlxWFYhid8=;
        b=zXQRJEy5uva2fEkOYuS0uxk72pLqVo4ShSd24pbEvWpAGzWD+rLMcaR2Zq4KEy3EXQ
         sNf75LOVF74wjebuTnW29MF1yw8oE9HHCDhfdnaxIqql1Nok+hJYxaQnqmDnXPJ/OWaA
         KkORMQLlVgXwGWesJWztTtQ5z+D27ZBDbFadWJjjGiL59GGGRIurGnzAtHgQEsBAkUCY
         3UDXv5K55nPB1NeNZlv42i5LbrOcV+gMd0yI7ur/XA4Xf38wNzBgZauDfHDQMT80xEqK
         SvFJ7ahJ89jtizvf8yUtRQLMKczftsAKe0+viPNxh4Qf8vDrkAVx++mdsdrmCP8IO+So
         GIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761486227; x=1762091027;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bt998LNx2nbYBgDO+TmmCdOEKtpEPTHI4UlxWFYhid8=;
        b=S3j+3wZ38YXw7KkMoPo2T+37HUARirm580XpFgUfhOcWohyiu5cJEOOr96oPTw0m0Y
         jD7xgCbi2gtgohf+zhYZm6WIXYIy83pIFT0lpZn+m13PXc1co2wuS7bWXfcizNiTAIeA
         LDsky8/gaBoSGmW5Z9P61z4qxEZ3bNqkH/aPOovB9DUZruuG73BJ6bd1WQgBplYXRWRd
         g1DLdObMB0e4gL3ElcDJrMGQfvu1nr+odzqcjTIfLbv0GwXPVu44J3WfneolO2ltuNVe
         9Uwp/85H3K+YtRp+ie3dFVwGiROeKqgHKIpkbFj38hfT/qgy4gKEzYv7QQCLuVfF5On2
         0WlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBZ1EV872vPzqH1Vv+eLFx1In7U2TVZeu5d4HzD2oHp8HpuSQAS/GkccycokkXgxBLUK2dWzMWFg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxOoshU1Haibn9AkdR+N4d2BYY8ypSWZhkD46APMStN0UcMVYTf
	61Jf7dhl3wWZTcXlsGT6NvUd+PyKSu3GIrgWu0n2fqty0JUtN/wxoTGurQELBP4mTgs=
X-Gm-Gg: ASbGncsM7G/jwaOa9uu64xBAacPqdJSlhXPj6MH0aw0RtTq6Bb4ZEAGSUZsoL6owFag
	UorIxi4sBP2AYhcowASjmm5+B6r2TVeNrNTryBzlqOHI8f7Hahexcw5cUQklpu6xBC2keeANyMX
	M10B1OdMFA2lcXM9/lglxfvfhaF7fhP152S1S+jPKaCHEvKj2OtZAnxGHNvMddF6xRC4CrRWy1z
	Wk3Ye+BOy44W8VYHXxC4Jf7yX+IKGZ0QyYjo+ujWX5LJ8mqD6LiqLzatbcpVhEKX+/svM3mobEc
	Eifw0mRCzaqPfAB+FjOGrAGEvVvsFb8w1qs8a6hJhuTOZ9d7/w0oTtrCifBrf36OwvduPSWOeM4
	ud86S1qffapF/DESv5wsV3o5xmr8JLOGUgVfooih/ttCWkfs4EDOr5OWhWVqJHs6+r6FSZjQrPg
	==
X-Google-Smtp-Source: AGHT+IF8hs9TsnHgI9f2ak40uYOazM/lwTkKpgiZfPelR1zE5aQhSz5dw0og/f+/vRbeO1KYHmtHEg==
X-Received: by 2002:a05:6e02:1947:b0:42f:9ba7:e47e with SMTP id e9e14a558f8ab-430c522f01fmr497370815ab.14.1761486226953;
        Sun, 26 Oct 2025 06:43:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-431f6899ed6sm18753295ab.36.2025.10.26.06.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Oct 2025 06:43:46 -0700 (PDT)
Message-ID: <a8c453b4-acc8-4ec7-a064-3c3e470c5669@kernel.dk>
Date: Sun, 26 Oct 2025 07:43:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] io_uring/zcrx: share an ifq between rings
From: Jens Axboe <axboe@kernel.dk>
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20251025191504.3024224-1-dw@davidwei.uk>
 <20251025191504.3024224-4-dw@davidwei.uk>
 <f1fa5543-c637-435d-a189-5d942b1c7ebc@kernel.dk>
 <ffdd2619-15d5-4393-87db-7a893f6d1fbf@davidwei.uk>
 <3a7a2318-09fb-41d2-9ba1-9d60c7e417a6@kernel.dk>
Content-Language: en-US
In-Reply-To: <3a7a2318-09fb-41d2-9ba1-9d60c7e417a6@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/26/25 7:16 AM, Jens Axboe wrote:
> On 10/25/25 10:12 PM, David Wei wrote:
>> Sorry I missed this during the splitting. Will include in v3.
>>
>>>
>>>> +    ifq->proxy = src_ifq;
>>>
>>> For this, since the ifq is shared and reference counted, why don't they
>>> just point at the same memory here? Would avoid having this ->proxy
>>> thing and just skipping to that in other spots where the actual
>>> io_zcrx_ifq is required?
>>>
>>
>> I wanted a way to separate src and dst rings, while also decrementing
>> refcounts once and only once. I used separate ifq objects to do this,
>> but having learnt about xarray marks, I think I can use that instead.
> 
> I'm confused, why do you even need that? You already have
> ifq->proxy which is just a "link" to the shared queue, why aren't both
> rings just using the same ifq structure? You already increment the
> refcount when you add proxy, why can't the new ring just store the same
> ifq?

And just to follow up - if this isn't directly feasible, then I think
the ifq bits need to be refactored a bit first to facilitate having it
be shared. Having a dummy ifq that only uses ->proxy is not super clean
to look at. From a quick look, ->ctx is the odd one out there, that part
is obviously not shared between the two rings.

-- 
Jens Axboe

