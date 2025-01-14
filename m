Return-Path: <io-uring+bounces-5858-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 162A9A10EC4
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 19:01:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43D183ADC0A
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 18:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FA01FAC45;
	Tue, 14 Jan 2025 17:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="czibEJnn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D394F204F82
	for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 17:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736877476; cv=none; b=NmY4khoxQvy2leL8dXDuvBPjyXmN5mx9fEPzfMffKp+TgGbLe5TRIkHx7B7Ig2QCL+edgw8fBBdJgXrhBcjMlGv4+z2xalwS+pjZ0o6BHcVuekyJ8Q8+8rz4tYZYZI2015AmzRHrGaZWg9j6AW9ImubuGDFCShTnD26zk1BVTkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736877476; c=relaxed/simple;
	bh=TxMRwYzCnwl6uQRq6op+ElWOVvdYd8d7nOPZlZWcNiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U+TolpaofATxIB4pZq6GnA4CHxtqNnw+k+D5P+6tZTSpPbmkcfhX/2uPbeN+zLC4HzJUIxh/ZWoK+SaNZH/lH6YNXMFLh0/xWNppuX6qh1lHJLWDsOCYWMomWmgWjPkdRcWzMhRId3+JivD1hVYllCIICTzR6vPb9ZA10jIlovc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=czibEJnn; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-84ceaf2667aso318938539f.3
        for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 09:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736877472; x=1737482272; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y7YZstDiXjyB1zPsdbBPJIDIgikogr6PNjNg2k0F+Dc=;
        b=czibEJnnlPjSEmQf3W1mQ0be8cVy88K6ROUwxTx7LgIsvr58aSpOyQf+Hv3NZHbbjA
         YpsavFDpjDD229EFN6Er6t4vVAzWxhwgmZzYBBGkAXvBFSvxxEL5kqSp2PMHp5btgopn
         6ISBj5bHsfdwrYQTqE80N/WRIrwRHLN5LyEhyT7bfC7erHOMVy6IfJNkgiDivCbeBAd2
         /bYw9D9PTo3DuY+OtGiVsLcxMVN8OcHsSrB7zRQHhtZJ6vFOFRrwv5REiux7yV1foZ05
         ouObLz05BIqBzrSMWrJSpeUrkFLfzxypZqZQ2og9V16QObTrEdFElQ9Ovplm/ffOLYUw
         4Zmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736877472; x=1737482272;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y7YZstDiXjyB1zPsdbBPJIDIgikogr6PNjNg2k0F+Dc=;
        b=OtZsDcWSayxXma1mgkYHArxhekvooxi2S5N1aq6pX82fcTOzChNYBs8wBCqvTnslZT
         8A2bjivpyYVs9IGCmnrNB7cwmW/L1XS0YQ1X4O+ct36cHx+2SEB2ByZYtaCq2XdMd2H4
         Tki3qxCdCG4ijeKD7HkS7MTiONnCO6L3xZPdFDuxyhgusYnXwsrF1TO34UMe6cGqBHBN
         der/CzzzUzckJIShuXRt1YYWCIezsQ/G9MYRfLI4ucuQJAAIX+2gFEEHKd2U6w93GlQE
         dCkT7m+OQPuQZlpz9w40tyi/nV8UFaQwoIRTPRnxdDG9NmrNPnTI/Xfb+W8XG0Ezs4vu
         Cekw==
X-Forwarded-Encrypted: i=1; AJvYcCVx4cTOuEBSk4MS6t2mdMw9hKT5pFccQA2HXtNspm0ab++NJ8G4Ne8mldhfLcmFlXIh9JmEgimf7g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHpVdBJdJXEvP4UkfKGThYkccT1wzd5Cl8K0SIXTBenk3dF0nv
	xNrBHhX+BfILzXYb38U5qw5rAVUZW2KYEGpqeYphsl7g2iOcbUFFV2ALLcP4ay8=
X-Gm-Gg: ASbGncsAIOBzvyDexKk0OJ4gdfAxhCSwl0XwSEjaoO06C/4UKfWRyxOm6upCDJ1DArJ
	QVDGr3Oh7UHPPaAWxBnJBkdLMQ3bBr6t6HdUddkbrF1hlvOunyLIU+nyevRMIZOymz4/5XprzGP
	GwPxL44zf8ZRe6OQbxUezsFrNHid078O2dzB4w6q8n1r6Mhdyi3f5BQHZlvhKrjUSbek7qcwvsS
	F9Ph9AzfDkHP3AfqIsBrMiG14F1Gz8Rol2DOhhcG8xvsVmJFgph
X-Google-Smtp-Source: AGHT+IGM2drpw9X/rMTH6z+8c5xpupNIqajcv4pvVlwSoOOaEK5ifp+uXOoIV7PQX3wBEh9KYkSR2g==
X-Received: by 2002:a05:6e02:1d94:b0:3ce:7ab4:1afc with SMTP id e9e14a558f8ab-3ce7ab4225dmr38914715ab.7.1736877471927;
        Tue, 14 Jan 2025 09:57:51 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b7459desm3632119173.125.2025.01.14.09.57.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 09:57:51 -0800 (PST)
Message-ID: <d6208848-ecb5-44df-9d68-8845cd25d1b6@kernel.dk>
Date: Tue, 14 Jan 2025 10:57:50 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: require cloned buffers to share accounting
 contexts
To: Jann Horn <jannh@google.com>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20250114-uring-check-accounting-v1-1-42e4145aa743@google.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250114-uring-check-accounting-v1-1-42e4145aa743@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/25 10:49 AM, Jann Horn wrote:
> When IORING_REGISTER_CLONE_BUFFERS is used to clone buffers from uring
> instance A to uring instance B, where A and B use different MMs for
> accounting, the accounting can go wrong:
> If uring instance A is closed before uring instance B, the pinned memory
> counters for uring instance B will be decremented, even though the pinned
> memory was originally accounted through uring instance A; so the MM of
> uring instance B can end up with negative locked memory.
> 
> Cc: stable@vger.kernel.org
> Closes: https://lore.kernel.org/r/CAG48ez1zez4bdhmeGLEFxtbFADY4Czn3CV0u9d_TMcbvRA01bg@mail.gmail.com
> Fixes: 7cc2a6eadcd7 ("io_uring: add IORING_REGISTER_COPY_BUFFERS method")
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
> To be clear, I think this is a very minor issue, feel free to take your
> time landing it.
> 
> I put a stable marker on this, but I'm ambivalent about whether this
> issue even warrants landing a fix in stable - feel free to remove the
> Cc stable marker if you think it's unnecessary.

I'll just queue it up for 6.14. Let's just get it towards stable, if
nothing else it provides consistent behavior across kernels. IMHO that's
enough reason to move it to stable.

-- 
Jens Axboe

