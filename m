Return-Path: <io-uring+bounces-8179-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C912ACAC60
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 12:22:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5984A3A95A1
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 10:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB5E77E0FF;
	Mon,  2 Jun 2025 10:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JB9h8s11"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379AC1758B
	for <io-uring@vger.kernel.org>; Mon,  2 Jun 2025 10:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748859766; cv=none; b=RpHlEJ6T0s3vrQp+QRZVrz7CHOnxdi0cN6TvwJ0bbU4RLZP2Awe2l2SRbTXWDVuG6/BPFaX3R81Vn+JorhoSght9XZk0scni+5mtpFwXCYuk7rq2jRu57FZS561dc/sfDQEfT/1XRfyAHIpGx3XCkxHIGrDLcgPZaL7FfBCikR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748859766; c=relaxed/simple;
	bh=gDuZU6guqMfa5okenLseqEF/+vcJX2JUtSiN9o8hajQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bn5eAyJpgMqQ65sAWW5oivdRlZnTtpjTZGxUcbjXoBxDGEmY/GtYQTmcM3IPXPJz+yEmCG9/CZA9LcUF3rFIY3HLNz7cbOJljv68xFolB5M3e60o+eM7GfU23US+qRcGV1xRGSTzpTbjPlhdOauQ6cCDe2oO5vh8n6be36T65zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JB9h8s11; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ad55d6aeb07so643853966b.0
        for <io-uring@vger.kernel.org>; Mon, 02 Jun 2025 03:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748859763; x=1749464563; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cKNk7h+YxKGwDbsx3oLbUBOHVVnuX5T60HM12or7xxQ=;
        b=JB9h8s116MLvncBYOwk4YzlSyOMWRpH3H2OD9tlW8vgA2F0UnpCvMatPN2/ydNDur6
         JaXhlAP7An8rqB+ji/3+9qd0tvECIwq9WPODGo5bgUvVYHsJm4UMQPaKojnJ5dAcHs7d
         6WshvbRP+WANOsjDhz7MHUQylTD+YG1KmBYvfg46g4HkFmvVOR71S42LW69FUnhOBLCt
         NkjgFVB+etQW/IJue9ZvmfnmOCOlRsD8YPCqqQErAggtEIsKx/C1q/3lNQVhT2zBWDyq
         HNKDXMmiB3k0YFCr3P5hJuneTBD7pUrVie5UeZTf4Wl3L1Vn4HqgSs5h41gX3GKz9bF1
         TNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748859763; x=1749464563;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cKNk7h+YxKGwDbsx3oLbUBOHVVnuX5T60HM12or7xxQ=;
        b=NncfWaLbhZQVFh6l1eBVisnrR6j4wOyes0orbddai2szoG0VIgyNRNBMx0XkXzHUPJ
         8aCGduH6GSLnoUYM0tajfaYP4t24EUqy2DybyhlZsVD91G6laoUxSVhbaRTAcJ1gLyEZ
         ojj1jWKLtpxsZ7zLhVgL+NVupapkB1P4NsfLMtpwL5NEAG6zJgkiYD/+cvEbRcK7YA+r
         nzDYOYOxDk/+OsajtZO1URyfMa6Cx+ztRgzsnFjaT688UpmWmghcoJcP6998z/c2NXfj
         c5YFzbhLtvLsSd4+iTM0HaNUNJC+eY4RBiHH/B41UPqFI6naMZg6U4lW4KALfoeNFeK7
         KXWg==
X-Forwarded-Encrypted: i=1; AJvYcCXW4s1nP7w32xongJfobTPsP2SkhjUeJAjv/tTlfjLzXLyCLI2SIwV7AxARS1SttqzG4mE3s49eOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwNH/6vsRsZIEYLNZ7tuW+4BOBhjiNAZt4l0LtoizhpPqH3P31F
	FtwnxD+Vjv6rD1rxscFC7ZpWNb0jB/JI9ZDPEsHRAQynlcKBdMhc+n0V
X-Gm-Gg: ASbGncu2xkxdQ2IHwMT0FfHxHgRdCywU2Kx0svzWi8klGPP3fPizxOb5jB9ulVcDERJ
	mQvmpT+vujaDYCzvqejsMAybJ8xlW8qAWh2uYPykXzWJtX+/KpOIeb7szb12+Lmi8IG6//MIrJh
	j4Sntyc2xGpgrHyxXTmRokUkS9fHdFW00NLvhB6GGUSKh3mPq0CirI6Y2n85NyvG0DfgLhOKdEB
	pmqrp/hmNH7JDhJ1vcniIPyZWj8N/n6257uUxa5Wtw3BxKZl3+skoV/aPUhDurERYGVxikk04ab
	GVBnOFD1ciftJll6Uf3WjuYJq9DmRjWlX2z5IP14NvFmx3bwW0bAzbcpg82bgjWo
X-Google-Smtp-Source: AGHT+IEGBmtHfgbw0BRmSixzLN+6PIL7Sb47u71GNH/aMXH3dr80zVEy6Vx3+Ta9x/c8oFab0MFNmg==
X-Received: by 2002:a17:907:948a:b0:ad4:d9b2:6ee4 with SMTP id a640c23a62f3a-adb36bfc483mr1126143066b.49.1748859763261;
        Mon, 02 Jun 2025 03:22:43 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:8317])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adb2ead829csm644514766b.79.2025.06.02.03.22.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 03:22:42 -0700 (PDT)
Message-ID: <6659c8b0-dff2-4b5c-b4bd-00a8110e8358@gmail.com>
Date: Mon, 2 Jun 2025 11:24:08 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/uring_cmd: be smarter about SQE copying
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <5d03de61-1419-443f-b3a4-e1f2ac2fe137@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5d03de61-1419-443f-b3a4-e1f2ac2fe137@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/31/25 21:52, Jens Axboe wrote:
> uring_cmd currently copies the SQE unconditionally, which was introduced
...>   	/*
> -	 * Unconditionally cache the SQE for now - this is only needed for
> -	 * requests that go async, but prep handlers must ensure that any
> -	 * sqe data is stable beyond prep. Since uring_cmd is special in
> -	 * that it doesn't read in per-op data, play it safe and ensure that
> -	 * any SQE data is stable beyond prep. This can later get relaxed.
> +	 * Copy SQE now, if we know we're going async. Drain will set
> +	 * FORCE_ASYNC, and assume links may cause it to go async. If not,
> +	 * copy is deferred until issue time, if the request doesn't issue
> +	 * or queue inline.
>   	 */
> -	memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
> -	ioucmd->sqe = ac->sqes;
> +	ioucmd->sqe = sqe;
> +	if (req->flags & (REQ_F_FORCE_ASYNC| REQ_F_LINK | REQ_F_HARDLINK) ||
> +	    ctx->submit_state.link.head)
> +		io_uring_sqe_copy(req, ioucmd);
> +

It'd be great if we can't crash the kernel (or do sth more nefarious with
that), and I'm 95% sure it's possible. The culprit is violation of
layering by poking into io_uring core bits that opcodes should not know
about, the flimsiness of attempts to infer the core io_uring behaviour
from opcode handlers, and leaving a potentially stale ->sqe pointer.

-- 
Pavel Begunkov


