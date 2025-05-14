Return-Path: <io-uring+bounces-7977-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4EEAB71D3
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 18:44:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97EE316AEBE
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 16:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4327C27A107;
	Wed, 14 May 2025 16:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HP3Z9uBB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763EB1C1F21
	for <io-uring@vger.kernel.org>; Wed, 14 May 2025 16:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747240991; cv=none; b=fgASKoHLHwpEfaTcjX+Lt5rkzc73EcycUfg3urKsVd9RQmKgRNsw2i8eVKHNCycJCIQ919vimXNwvIFlDbTaQLdBv4wSqkIvaT8L/z6sQy1SoOvmfQGHDTgTe0xlQ0u0wl+xuXBUeB5+jZNsaUNP7sD8ig/VxUIxq9llnXswuAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747240991; c=relaxed/simple;
	bh=pj4DmhUFLFvn4yzYxSO7+kvIN7/WdE5k9pBpEW+/8B8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nzN1rYf+CKoRnpwaWiiaKYelruOFWodnP0b+tNREeaec1az4k5IqJ3YcfbBH9rku7QvNp/LuFY5aQD0Tz2/BvQmQoG9OE8S32JRwXGLowk+qjtsUtQKmfPm5KOQ2+SZ1BAAU3TKT9cV/xdDqRSbv6jfNk9FZxUsQbbwNUpKirjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HP3Z9uBB; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7c7913bab2cso786482785a.0
        for <io-uring@vger.kernel.org>; Wed, 14 May 2025 09:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747240986; x=1747845786; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R9cr9xARecF/qmfEUPzPib2K6+zBjWn3RQfs2nZ+kVE=;
        b=HP3Z9uBBQ8ENCobitkmXbld21PHdL+V3bC1RO8cJmLrYkUg9hWvouEPWqlp/EBIc9o
         0ekWyjVmDxcZ0rO2fYjI0LxC3yM4Z9sLTN1/r7opcoITMpHTfBDATkr0jbUimiyngmfp
         Y+82vi1GcD+J4KrHl75Ozo2obMYlnYKpO7sEQWdWrLt1SJoX1KdcBg0QZwSm/ovuzj+Q
         XLZcTGiFe4L548wXJpp/RrPwQhAAXYZwwQZgLxvtCAH7OsT0I2LtpSzeXVqQVbbZaFF+
         zMGxzjEHla7TQpluHrLBaXU0TrVFnIzsCIjY7mMsqqRt0druiCf/VGPN8cNJy/Fg3q1G
         DI6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747240986; x=1747845786;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R9cr9xARecF/qmfEUPzPib2K6+zBjWn3RQfs2nZ+kVE=;
        b=QPwKwXn1Em2icboeah2ThvX3OoJyHRle6jo+mD85MUyGb4D6tS3gDsbUe/da3TRM5n
         sXUf6OFB5jmMshqKS3lL9VeApBeJxt0GvL7iRjj3qdn0YAG8qhRkeOq3V3iQ6dgh76wE
         io3gpuX/LPi6ubfRWF4To1RMMr5wO6TtsAcDyHCU9hkEDXPmKnDcNasZqZ4vdJxUnmK3
         xhXhigYY1uuh1lnMSkE+vx9GxVNlZX6NA22R9etbtSj+0t4uSkdoCxrPHnpdtpdnjL9M
         T/FAgKriN69ZQ0jZT7UqKd6riCXUU+M2hDFRbW/sCBPzOPGud5dLddDEhXJC6yGp4xsV
         YLpg==
X-Forwarded-Encrypted: i=1; AJvYcCV8v6hl9P581tbmHV0W5bBG5w+UbgXKNN3kg19oExuTqVlCRh9QCFcq/+odHBq78ZCbfnUMDd39tQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7nljE3QWTpcZIRgHKvCMALdzvIv5XuGRD16YCQogr5kDhTHV9
	P5pCARcxt/Yh0nXDjQBPNe3j4cvVAkMQScLCNVaIy9JDLOFUjIOoKlGKOviFbJVYZ2RTejgbmBg
	D
X-Gm-Gg: ASbGncvNr/ApfK4JAWVBoRpNLpjDOg/Ul3dYS7I9lfExH8NfXdMBonvs96RNilgsRX0
	twwb70/XwECx/+SxGVcQ7/zSA+06W/1WmoWJap3cCvVOOm8+wzuZFAk/cH7Qlv+Tx2G3IKoRHNX
	PJoPEhRfStVT4T9OnOxlcxtKky3355FSIJXdTHnH1qbDvm4sXxsa4xsSapwiHOX4wM9r9dFWZk9
	qprk0a/IF7ZPAvftNklFM+qYDZs8eoD64IgktIFa+sPeCiTOJGGPDlHHCwQgyI3oq0EfS5bi81j
	4MDgHsDFDwNGV5f4AhPUpIzLtni+pD+yGbSzmJVnCAbcX24=
X-Google-Smtp-Source: AGHT+IGfK+HSYnNUWP+SxM2uiQXwLhdEPzUyss944Wo46U+/sAZw5VYTbD8bkp6c9bXzeFnKd0/ioA==
X-Received: by 2002:a05:6e02:1707:b0:3db:72f7:d7b3 with SMTP id e9e14a558f8ab-3db72f7dc1dmr27928625ab.4.1747240975295;
        Wed, 14 May 2025 09:42:55 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa22659f9asm2627368173.128.2025.05.14.09.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 09:42:54 -0700 (PDT)
Message-ID: <d6634082-86c0-4393-b270-ede60397695e@kernel.dk>
Date: Wed, 14 May 2025 10:42:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: move locking inside overflow posting
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1747209332.git.asml.silence@gmail.com>
 <56fb1f1b3977ae5eec732bd5d39635b69a056b3e.1747209332.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <56fb1f1b3977ae5eec732bd5d39635b69a056b3e.1747209332.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/14/25 2:07 AM, Pavel Begunkov wrote:
> A preparation patch moving locking protecting the overflow list into
> io_cqring_event_overflow(). The locking needs to be conditional because
> callers might already hold the lock. It's not the prettiest option, but
> it's not much different from the current state. Hopefully, one day we'll
> get rid of this nasty locking pattern.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/io_uring.c | 53 +++++++++++++++++++++++++++------------------
>  1 file changed, 32 insertions(+), 21 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 068e140b6bd8..5b253e2b6c49 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -718,8 +718,9 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
>  	}
>  }
>  
> -static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
> -				     s32 res, u32 cflags, u64 extra1, u64 extra2)
> +static bool __io_cqring_event_overflow(struct io_ring_ctx *ctx,
> +				       u64 user_data, s32 res, u32 cflags,
> +				       u64 extra1, u64 extra2)
>  {
>  	struct io_overflow_cqe *ocqe;
>  	size_t ocq_size = sizeof(struct io_overflow_cqe);
> @@ -760,6 +761,24 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
>  	return true;
>  }
>  
> +static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, bool locked,
> +				     u64 user_data, s32 res, u32 cflags,
> +				     u64 extra1, u64 extra2)
> +{
> +	bool queued;
> +
> +	if (locked) {
> +		queued = __io_cqring_event_overflow(ctx, user_data, res, cflags,
> +						    extra1, extra2);
> +	} else {
> +		spin_lock(&ctx->completion_lock);
> +		queued = __io_cqring_event_overflow(ctx, user_data, res, cflags,
> +						    extra1, extra2);
> +		spin_unlock(&ctx->completion_lock);
> +	}
> +	return queued;
> +}

Really not a fan of passing in locking state and having a split helper
like that. It's also pretty unwieldy with 7 arguments.

Overall, why do we care about atomic vs non-atomic allocations for
overflows? If you're hitting overflow, you've messed up... And if it's
about cost, gfp atomic alloc will be predictable, vs GFP_KERNEL which
can be a lot more involved.

-- 
Jens Axboe

