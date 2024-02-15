Return-Path: <io-uring+bounces-613-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91B5C85709D
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 23:37:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3805B281885
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 22:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F4141A87;
	Thu, 15 Feb 2024 22:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="pp5VPD0w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3391E4AE
	for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 22:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708036639; cv=none; b=Khc6S0V98W53dS7SZxg39k55i87R3W1kEoqOH1ifJjMI2NBlIIRbGSlNAy6Vrd1l2+kZanYYAKLMrv3kAaELLrDT3aZa8cTz7d0M/+W3Nu+oPFOsXtAtZ8+Mes42VejuPokTCxuR7x1Ch7ZfY15b+C/KzkXRJBxsYqAKaZTrXsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708036639; c=relaxed/simple;
	bh=Hz+i1ZZk7yk2pjU3+BKigOMV3EZOgOHmjKJc54rGFZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eP2SUJ6nmSsiO08c3tiC5PH7PkAeq3o8bxH/dD/Xlmv0soB/IJtAudkhH+fDDsmFc7aVvxjttE+rZOqt1M48jFXR92Ot0MWHCPcLDpbBRDDjKjfdg4cihJVWApLx9+xTOZxvY5MkJVMAIVpeaC1lHNRPeXtTiHA/om8n3aIOsVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=pp5VPD0w; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7bc332d3a8cso74950939f.2
        for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 14:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1708036636; x=1708641436; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sJk1Tn6kl4UfeyZPnoWse3D2fgWjDRAvm7rF0FPEhwE=;
        b=pp5VPD0w5obLqH4n+bk93m+/QjcZ8PuF/WGyOUJejhpyTiEa0N20xpJ80NgBAYaV1A
         VvPzjZJ2101wWrfYqxCE8DtI+drj1owrte/gEa7IQxD63WgbjlHacrRusdCdu+pVXqll
         FH47VdYYiSYwrGN7bjUSBr+EEcZ/kRxxvZvBGxjPvM9BSrTs/ZwFljLqkZL5ttYNiChM
         zPYtxV4+Et45Rqtj2Z3cqut8Wlj1PG+reefOY9+px5qVwwQzIx+j/cuvvlZO+F7OgKN7
         9Mw66TTdlxvevuPoHgNb8wf11H8qAft1IQ5EWb6p9gH0//kTP2G+RxUOWtTHstO3GK6Q
         39TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708036636; x=1708641436;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sJk1Tn6kl4UfeyZPnoWse3D2fgWjDRAvm7rF0FPEhwE=;
        b=YjRukWj7gvwR+eM3CMqZ/axfuDz99Mnunkf5mzkqFN3ROTs2bUCd5GA3Q09XhP7P5D
         TwFVB2Vsx5zyJt7kTaF5I+eOLbciGiY+jI549KZ479PS2OwqS3ZZTinhnNO3CRG7Fc8+
         ahkBxkiL/wrMVe34SiaF5mkCoNaAg5IqG6JTX7XkFJCDb6ZYx5cOFBRkHe8ROu02IcxH
         1QieLOISUtD+zQBYa+kelT9w4MH8lOxdpJYORtoQtGMB2gRW3S1GPzHydfxLCqVdBsSQ
         XaKpyaQL0ayZhe07XkLN0hxc0erngI5jr0T1BpgnMVlq1mFsi+eOvkVAEsE3hBvceE0e
         Z+GA==
X-Forwarded-Encrypted: i=1; AJvYcCXYlr5zH7V0+5WubaImbYN3xVvrsZ5Q1TM0mnFavU7+tMUKyOMJfyV1uPQIrA6ft9ZCawE9Mi+POHbTckpR3IXLB65knB6eqAY=
X-Gm-Message-State: AOJu0YyWU5OgvjPFBXXl+yAmSH4De256B8evzDjROQG6Q8vbrpXq5Y2p
	MjAqUOGFfd+1N+VaJH8OFkl5MStPRl3Rld09o4F8AmcOrHFxmBoedkPS/WoJBiouiWDaOdqy0ov
	q
X-Google-Smtp-Source: AGHT+IFWGNE3SXQ8bZmsiLKz0nQ3y7TTlmVPXqhgtx4y1CGpc8To5XL25mWErNlVChE0KgShJslrQQ==
X-Received: by 2002:a5e:cb0a:0:b0:7c4:9a42:2cc3 with SMTP id p10-20020a5ecb0a000000b007c49a422cc3mr2797047iom.11.1708036635934;
        Thu, 15 Feb 2024 14:37:15 -0800 (PST)
Received: from [192.168.1.132] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f8-20020a02cac8000000b00473b5f7b25dsm567724jap.29.2024.02.15.14.37.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Feb 2024 14:37:15 -0800 (PST)
Message-ID: <a16586d2-a488-4c5f-95a3-14256c84693c@davidwei.uk>
Date: Thu, 15 Feb 2024 15:37:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/napi: enable even with a timeout of 0
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <c7210193-a850-465c-bee2-ade5b36b4e2d@kernel.dk>
Content-Language: en-GB
From: David Wei <dw@davidwei.uk>
In-Reply-To: <c7210193-a850-465c-bee2-ade5b36b4e2d@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-02-15 15:32, Jens Axboe wrote:
> 1 usec is not as short as it used to be, and it makes sense to allow 0
> for a busy poll timeout - this means just do one loop to check if we
> have anything available. Add a separate ->napi_enabled to check if napi
> has been enabled or not.
> 
> While at it, move the writing of the ctx napi values after we've copied
> the old values back to userspace. This ensures that if the call fails,
> we'll be in the same state as we were before, rather than some
> indeterminate state.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 4fe7af8a4907..bd7071aeec5d 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -420,6 +420,7 @@ struct io_ring_ctx {
>  	/* napi busy poll default timeout */
>  	unsigned int		napi_busy_poll_to;
>  	bool			napi_prefer_busy_poll;
> +	bool			napi_enabled;
>  
>  	DECLARE_HASHTABLE(napi_ht, 4);
>  #endif
> diff --git a/io_uring/napi.c b/io_uring/napi.c
> index b234adda7dfd..e653927a376e 100644
> --- a/io_uring/napi.c
> +++ b/io_uring/napi.c
> @@ -227,12 +227,12 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
>  	if (napi.pad[0] || napi.pad[1] || napi.pad[2] || napi.resv)
>  		return -EINVAL;
>  
> -	WRITE_ONCE(ctx->napi_busy_poll_to, napi.busy_poll_to);
> -	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi.prefer_busy_poll);
> -
>  	if (copy_to_user(arg, &curr, sizeof(curr)))
>  		return -EFAULT;
>  
> +	WRITE_ONCE(ctx->napi_busy_poll_to, napi.busy_poll_to);
> +	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi.prefer_busy_poll);
> +	WRITE_ONCE(ctx->napi_enabled, true);
>  	return 0;
>  }
>  
> @@ -256,6 +256,7 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
>  
>  	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
>  	WRITE_ONCE(ctx->napi_prefer_busy_poll, false);
> +	WRITE_ONCE(ctx->napi_enabled, true);

Should this be false?

>  	return 0;
>  }
>  
> @@ -300,7 +301,7 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
>  {
>  	iowq->napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
>  
> -	if (!(ctx->flags & IORING_SETUP_SQPOLL) && iowq->napi_busy_poll_to)
> +	if (!(ctx->flags & IORING_SETUP_SQPOLL) && ctx->napi_enabled)
>  		io_napi_blocking_busy_loop(ctx, iowq);
>  }
>  

