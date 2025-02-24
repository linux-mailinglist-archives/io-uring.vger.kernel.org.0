Return-Path: <io-uring+bounces-6674-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6390EA42300
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 15:28:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 227C33A3E0A
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 14:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88CC4152E12;
	Mon, 24 Feb 2025 14:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dQtfn7CA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D2E13A244;
	Mon, 24 Feb 2025 14:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740406602; cv=none; b=Zbw5USJELlIb+PsiWodBI+E9SUsi6u2Thb0GLhl82N9Fm6LYqP3RZD+rUxZx4NOb0xq6fcpf88QIoKWu9/y8tow5X9+DwAixkOvmm9fVvoSrpkKA3/Xplul2RAbxtVrIT3JFab2PnYP0QwBmXhfV4mJ5Z//K14Ah1ZGWLZNuqjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740406602; c=relaxed/simple;
	bh=Phh6pAdjL59IyOXhZlY/SAI7jKTCU2BQM4aOO9n6VRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IrVng71FQVHTzcyp7qUXYbRWNvrPLQ6DzT3yj6Oq9LPJMUg0ie/f+elqOMLXHWnhusKqzLIVXfpHw4JL6g7KpQVG4VySWibBFu98jp9DxKTKO4FLCtuzdU/U8H1gp97j3uffrq6pETLNFCpFxISzpd9QNtWHBwSi6tCcrAKpF6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dQtfn7CA; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5e0505275b7so7193744a12.3;
        Mon, 24 Feb 2025 06:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740406599; x=1741011399; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tw0qNv0ynUeW6Gr/ncBwy6EWJSTtEK5Or7iESAPDNAs=;
        b=dQtfn7CAaKd1ykzm8EwHw8Gjda0PKyY3xKz1KpVd0dZDHywMwqq3sKztvG0NCWPMmK
         d97/Frh4wA3KSdVwcbHHv9D2XrIl5AoS24b1P14FKc1g6QPBR5YmDDQH/elvNxMJNahi
         /LhC03Ga6/CEy0rZy3ECaqKMDA1v3tZktfTxT4fPt+q8P+dqYB0hWidMJYSMWIu/LSU6
         HjRIuF7a7ijCVMucTuATPVoJZe67G6n80zXj5OuzwLmo4YrlyznqUUEFKvlbU5f3dwdZ
         doaH7pcW6taLqdeYEn4LFZEpma48mXBVwtgOeMpTRHEsUJUpELhRITxqSuwGZykcUojp
         nXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740406599; x=1741011399;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tw0qNv0ynUeW6Gr/ncBwy6EWJSTtEK5Or7iESAPDNAs=;
        b=MlbCL0mV5eFUt/vUXGyoZkuyg/GCj9/zmPib2jxfnnGRIU6xDQicXyWInwHRMUs/OM
         Cp/CG18vGYBADGh1JGSDJBbjNbjXztMSnSXpZlOfcvAKegSdN4Bm+ojG5ooNlt8tlTq0
         Foo+ZuTeeyo+nkhlkvuw0UCKAW0f87u26zNOxmoJ4oLq725qkLqxYgYy0RJSLG3+lPvi
         1Wb13jxYLbi4W4u2kPfq9tRP59t6+LPDTFhljeU+F1c27M4dEQGlh0VzfyRDWbpEhFEz
         emvMeYhvH27yMfOestPJih8q0i1oljo+g4h1F3syj97FhDrGmLtZsMRyIh52D3M6Unq2
         RIZA==
X-Forwarded-Encrypted: i=1; AJvYcCXvKYpnK3XAnnjShKV7o+iI1y3FVbQfvUrHvGb6xX86SMpNP1fmHLJHZ9swu4BDiWo+ZLy52ZC29w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyD5nV3qMUsfNPV5WoOs+GA2SZFLq8sj1yMRSCjwc1MasN7+9FR
	jOh5sdCwSLxmZgRuRVT7ZVbJoJ+PRF6ZPKud8Mxf9OuyWSVUY5l6
X-Gm-Gg: ASbGncs1KWqGc4Y3nX2ETqjeEOFT4/qegMcvy7MVho0s5h76wElmqPtXrSlWfT9P37R
	0vwN1TM70x5SdaGKvwJwPLo07hLkbuyBTmen2Em5fazi+ROpU97/vhomAEu+zB3HuyZSI0nWUiA
	DG2tts9jLPThLG/jPkf7VJEcxvZHYHs6BjynfwNrVvKPMe+wB6aOhUZuPcJsbbzSJCLdM1ce8Ia
	jLp1FU07qg/r3khozqTHqBIUy6nZIeku6R6ikgURZ0cwFKbvqP+y3Bfp7wyFUswSt/cmXWxgFtq
	8xNYwq7p8qDTBWzeoU4Un6XjcWmOCVOCDQf2+OHsipl5mN2PsabRDVI4K1s=
X-Google-Smtp-Source: AGHT+IEHxDWR+hs50gaa/KPKJkYDs4U2vu7fqcRO3bkAq8+Q6GBpPa2WyS3e3G30+2WaCxtVNMcFgw==
X-Received: by 2002:a05:6402:2386:b0:5e2:1f4c:8a3 with SMTP id 4fb4d7f45d1cf-5e21f4c08f4mr369280a12.22.1740406598467;
        Mon, 24 Feb 2025 06:16:38 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e075f59e3csm11558666a12.43.2025.02.24.06.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 06:16:37 -0800 (PST)
Message-ID: <07b78572-7a50-49d4-8049-8756b3644a69@gmail.com>
Date: Mon, 24 Feb 2025 14:17:39 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] io_uring/epoll: add support for IORING_OP_EPOLL_WAIT
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org
References: <20250219172552.1565603-1-axboe@kernel.dk>
 <20250219172552.1565603-6-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250219172552.1565603-6-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/19/25 17:22, Jens Axboe wrote:
> For existing epoll event loops that can't fully convert to io_uring,
> the used approach is usually to add the io_uring fd to the epoll
> instance and use epoll_wait() to wait on both "legacy" and io_uring
> events. While this work, it isn't optimal as:
> 
> 1) epoll_wait() is pretty limited in what it can do. It does not support
>     partial reaping of events, or waiting on a batch of events.
> 
> 2) When an io_uring ring is added to an epoll instance, it activates the
>     io_uring "I'm being polled" logic which slows things down.
> 
> Rather than use this approach, with EPOLL_WAIT support added to io_uring,
> event loops can use the normal io_uring wait logic for everything, as
> long as an epoll wait request has been armed with io_uring.
> 
> Note that IORING_OP_EPOLL_WAIT does NOT take a timeout value, as this
> is an async request. Waiting on io_uring events in general has various
> timeout parameters, and those are the ones that should be used when
> waiting on any kind of request. If events are immediately available for
> reaping, then This opcode will return those immediately. If none are
> available, then it will post an async completion when they become
> available.
> 
> cqe->res will contain either an error code (< 0 value) for a malformed
> request, invalid epoll instance, etc. It will return a positive result
> indicating how many events were reaped.
> 
> IORING_OP_EPOLL_WAIT requests may be canceled using the normal io_uring
> cancelation infrastructure.

Looks quite trivial now! Should be pretty easy to add
multishot on top.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


