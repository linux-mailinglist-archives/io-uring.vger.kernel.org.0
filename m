Return-Path: <io-uring+bounces-1545-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D60C8A4E86
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 14:09:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 086EF283269
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 12:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756B76AF88;
	Mon, 15 Apr 2024 12:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G7z51ui+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7F16E613
	for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 12:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713182909; cv=none; b=swgzzuR/OML8Pz68sg89MFCZ/+CzEMKwx7HasT5k3HvUAXulOcCoBguLM3ZMeYv9t8pYWbuACI26n71S6eMOiWAfRmwviKaQO6BY4Xa2WohrkUU5AC93gD6OON0Lkq9wjskQdIm4X03GPv1ONnGvAkLQ4DeM6JslagKlrprxEe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713182909; c=relaxed/simple;
	bh=HO/zKnVNmSKy3pDtY5iJOgsiPkAvPnYQv8BixOOPL7Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=X8Si4BnIoUe0KQStuyQXOOSr/3VtrLLybn2j7y1nu9JEaI1uUarLZzFF42FhVEKnSHF2+YhTFV7+69OB6BWAhUEFMVBMswP4ze6DyRiD2s1xd5owKqA2Kci39d1yadqJhyeu0OpQUUjvrBOa/zgfiAG4naCB93QVwG+vcKXYd4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G7z51ui+; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a52582ecde4so161179566b.0
        for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 05:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713182902; x=1713787702; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UwahmYzc1gAw/Vz+z21rzHxWkJtchemADHCDBxsq9ew=;
        b=G7z51ui+n8y/bSqpMcGDgkftWnymdv8q20bhunQG/guQNX0ZJsuu0rXjnfyLrEDXrs
         1zDFWJw1q33rScl4DeZGrGm/ltagoft6CkWQj4flGC1hDT9RB3mfO0xUGcBbKdyvSdy3
         bzohQ0niBLsty5LLPohLsjm3fOewCkhPfBbLNn2yhUgpv7hldvod4YsOeJe2RUNLI1y8
         YaBTo0QNgPDgHTnXBsChU8hHnTzGcd9yrnTjMYT2QfbWCT7ixtYBmaP741O6IZvDW/mK
         0L6oGEnixR1XL/Pa12hdkTrIqjl/r4JU2X1lBzmKVZSHLC97BKBdzVMElk05ENSr5P9N
         9ANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713182902; x=1713787702;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UwahmYzc1gAw/Vz+z21rzHxWkJtchemADHCDBxsq9ew=;
        b=nEWu5Azea8McMeZVdCZIuwPtrqgk2BwLwy17dY61hWoT2ENZ8GJ2V0KfeHhXZNCH6D
         g+0Bjc6FSrPJmCK6Nl0nw3flKOeTMQqDYwpE7qiPDtktW21j8aZJx4VYos2kXOWhVB9C
         xwX+s9yB4WA6630xi3/tHfVNooQbhTJAsUpqMjlSSuuWtEDBvtHq62vvvta/eFxz0L7q
         dGZjjMF1X8/+cA/9b6e4YVZA0yYQGtlrkO1LJEJrmkyQS1T3aCbeq4ddZ/Ixsd5S8P6D
         /5n6i1Pd4Ch1cmyQvKFsDSbhz06upVGcdk8ASwtIc9OFuzTiuRkVDTnp7z5Q6m0/rjAX
         50UA==
X-Forwarded-Encrypted: i=1; AJvYcCWoybr7kJV7nl45DWNoY503oTN08PP1nszeCU46upsfssoyYXZN6TNmypOQF1YlY8pSOwoUVZ6OdRf+UOZHEAs1ywwEahpN96M=
X-Gm-Message-State: AOJu0Yyb3+KWFjdqeZf+rC/DjX6yE83hE6Etvh/1aX7HXf4EINTE+YuC
	p1sQTgg2fnIdgoROZ/d7kl3QqOZuBs2Vspfv+mwCvC7+F0m/URn9Vq2MQQ==
X-Google-Smtp-Source: AGHT+IHgbvXxJmmsdR5bBCDoIkgTUtO52N8H7Q1fFA6luLGHESIdo9CQwd7EXVWCod3obGfDc79s9Q==
X-Received: by 2002:a17:906:134a:b0:a52:195:7090 with SMTP id x10-20020a170906134a00b00a5201957090mr5540994ejb.41.1713182902291;
        Mon, 15 Apr 2024 05:08:22 -0700 (PDT)
Received: from [192.168.42.108] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id l17-20020a170906079100b00a51b3c951b6sm5384141ejc.191.2024.04.15.05.08.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 05:08:22 -0700 (PDT)
Message-ID: <1ddaa0bd-e72f-4eef-882c-7b8b0fb57593@gmail.com>
Date: Mon, 15 Apr 2024 13:08:28 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] io_uring: ensure overflow entries are dropped
 when ring is exiting
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <025b6c13-98fd-4b35-be83-257fd34291bc@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <025b6c13-98fd-4b35-be83-257fd34291bc@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/24 20:18, Jens Axboe wrote:
> A previous consolidation cleanup missed handling the case where the ring
> is dying, and __io_cqring_overflow_flush() doesn't flush entries if the
> CQ ring is already full. This is fine for the normal CQE overflow
> flushing, but if the ring is going away, we need to flush everything,
> even if it means simply freeing the overflown entries.

Indeed, sounds like a good idea to enable leak detection
for my testing.


> Fixes: 6c948ec44b29 ("io_uring: consolidate overflow flushing")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index c4419eef7e63..3c9087f37c43 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -674,7 +674,8 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
>   
>   	lockdep_assert_held(&ctx->uring_lock);
>   
> -	if (__io_cqring_events(ctx) == ctx->cq_entries)
> +	/* don't abort if we're dying, entries must get freed */
> +	if (!dying && __io_cqring_events(ctx) == ctx->cq_entries)
>   		return;
>   
>   	if (ctx->flags & IORING_SETUP_CQE32)
> 

-- 
Pavel Begunkov

