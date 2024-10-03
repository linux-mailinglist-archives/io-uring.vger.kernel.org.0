Return-Path: <io-uring+bounces-3391-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B5BB98E7E6
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 02:45:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0EA6B23D57
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 00:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAE9823DE;
	Thu,  3 Oct 2024 00:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ILAsrj3r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73861BA49
	for <io-uring@vger.kernel.org>; Thu,  3 Oct 2024 00:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727916345; cv=none; b=pdYtiwle1IwIMMeCyEeQ5V9l/AZ9RA218e0yeeoATUgmWedPk1FMaDd6P4fkIiajO6f0H5hZD9jteBjDhXIWdRP1jMZHEO1fbeiL1z0rx9aYqIKmGdXuJPQwb+xc7JQSV30lEOXKuXxBsfxdv9+BkXA07xYLMA5+KWNv8Cs/7qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727916345; c=relaxed/simple;
	bh=TF8dppnwBrZ09TviWya2d+PGaBpZogq1+seL+V8bScI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rdMwyTA+9lu1+CwvVF6o0AQE8YAt6+ohByv3NIgJiC5l90LHoQhj3P6hc++67jB/5m4XLs37wFtpzCBBhDcxbHNNHeyYZe4g5/AKinYWulGnc3j6cVx9kns1DM/H+zFzO55SMrmOU2DDEvuk5kEaSt43qhetwUPjZ7z6HvRsm0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ILAsrj3r; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2e1bfa9ddb3so79587a91.0
        for <io-uring@vger.kernel.org>; Wed, 02 Oct 2024 17:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727916341; x=1728521141; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QaCf93WpxraxzDO4sFjK8i7IYgil7NcpsU0p4DFW1Xs=;
        b=ILAsrj3r3zFpOBOZAKBzetraJo0NSQ/4K9CjpKqzOKXgXrSQmzFi37dSzlQgj4MnhX
         +T55RGpHR/PMqvX66XD2rk6htDnJjQGf3HKBc6cxBUSv5E2S7Ehx3gj9/4um9HljfFL4
         7ESBYXT4kEdUADVNsX4yZDSncj8rz1FOHkX1gCw4pj7KsbbWKcButUTePzWF51Gyni8F
         2UpR5zTsuM0uLoSneG7qdM7u9S1UFRmvD+StsmoTL+lZHzZF3IxFQ8C/uxAaXqMjGaZa
         N30pQ3bEnZjXHEXrHnOZ2RKbCGUZFNmTAh1JJqSjgrfBH/yWlCTsgOyN2CPO5IMPz77C
         X5yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727916341; x=1728521141;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QaCf93WpxraxzDO4sFjK8i7IYgil7NcpsU0p4DFW1Xs=;
        b=AhSUwSGyLUC7Z1axCCqXqcTXKuk+LYhNNWED29l+2JbvfPGWqOMJHLKSrA4Ps23aBb
         JVMsM42/YBJ+kNPp9S9P6So05lZymek5L6Mx2sZRehlp3tGN+eWWsYyH35kspRRDYMwC
         puGQJOg9nOSz2qlZEhPPNhVqjeslYFuMMnAcUVAfXqwZrqQU1YUALrLapSI+FQ/K86nm
         hwiqLsdFNiIb/fKn9rjmVxltDt+z19h2r3TqIkYAwwq9G4elUjIdM84NJNjXqnvCA4ZW
         D2A6XA7MJX4FdQPNC3b3BLR5Yubc2XW1DKz9prqWCkttlbkLDtp2xOlETRr9hj+rwyxU
         jLNA==
X-Forwarded-Encrypted: i=1; AJvYcCXhZgWAsSrFBAQZQlzluZKr2VnpWtFKCa8e15Yi61CVmSy2TjHtfxWSkSqPn1VWxeZPUFa4lHiHfw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbT4IEsj+vc/4t/olxH7oA7kJK+Mjqzad4lI7CJ4JPCsp7Bdsn
	IHFQxlulg8aWAcWhgWZ4yapZO5FfHhb4D3vSqoLM4psCIMLbUJE3mVMWeWZPk9OJiojtFZjfDFg
	8S+rKLg==
X-Google-Smtp-Source: AGHT+IFuzZJF+OHj42IL/50NBcHjqtyqViNOniMc5hcNsi8KFJkbz47mzgql8yHjENnnY4pTguK42g==
X-Received: by 2002:a17:90b:4c88:b0:2e0:9d79:4a02 with SMTP id 98e67ed59e1d1-2e1846bc3f6mr6284898a91.20.1727916340674;
        Wed, 02 Oct 2024 17:45:40 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e1bfb16f72sm165214a91.15.2024.10.02.17.45.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2024 17:45:40 -0700 (PDT)
Message-ID: <55026b93-bcbd-422d-8ff4-1542247e375a@kernel.dk>
Date: Wed, 2 Oct 2024 18:45:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] sanitize: add ifdef guard around sanitizer
 functions
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20241003000209.1159551-1-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241003000209.1159551-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/2/24 6:02 PM, David Wei wrote:
> Otherwise there are redefinition errors during compilation if
> CONFIG_USE_SANITIZER isn't set.
> 
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  src/sanitize.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/src/sanitize.c b/src/sanitize.c
> index 46391a6..db5930d 100644
> --- a/src/sanitize.c
> +++ b/src/sanitize.c
> @@ -118,6 +118,7 @@ static inline void initialize_sanitize_handlers()
>  	sanitize_handlers_initialized = true;
>  }
>  
> +#if defined(CONFIG_USE_SANITIZER)
>  void liburing_sanitize_ring(struct io_uring *ring)
>  {
>  	struct io_uring_sq *sq = &ring->sq;
> @@ -174,3 +175,4 @@ void liburing_sanitize_iovecs(const struct iovec *iovecs, unsigned nr)
>  		}
>  	}
>  }
> +#endif

Hmm, but src/sanitize.o should not be built unless that is set. How is
this happening?

-- 
Jens Axboe

