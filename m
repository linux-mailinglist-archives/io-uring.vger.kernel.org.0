Return-Path: <io-uring+bounces-1849-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 774E18C1C5C
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 04:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C3D6282C52
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 02:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E057533EE;
	Fri, 10 May 2024 02:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1IKzepMs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBFF13A889
	for <io-uring@vger.kernel.org>; Fri, 10 May 2024 02:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715307586; cv=none; b=Av3w/CvArPPQOPbFU0N93kLP8RJS49xIrZkBHt437dsAiD1eaU+m1WhQlla4OumQZxX+ZmFs+akehvf2rFvIMuRDaAtCGgNloJd2StEBq5g8q4wyph9JmRQFurhZduCbNhcT5S6OUyvmh5eXDj2d9zlGyzadOCZmhRJ85POxkqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715307586; c=relaxed/simple;
	bh=7LYOHvm0Gf5FJ0a2N+1kx9Ib4c8xFCff/taGudUVkrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FeHpOpgBchWipAwQWHwt8Wf/S3FHbPI6o56BNbo2G5RSB4KY7ML4lWyhVJ2WFmsz9DHFgsask4Any3VmqswHQ2z6cxz5UQaKwqcUr1hOvUUFRiYeo+dHFtsif1KV1GQdhlO8xEaIMO0JRTaqFllOiJ7q6u4hz1G/XpqbYwSS0P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1IKzepMs; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2b6215bcd03so410481a91.1
        for <io-uring@vger.kernel.org>; Thu, 09 May 2024 19:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715307582; x=1715912382; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qb/9SIfq7posCzftop6IuZbCHyqWEssdXC1J8FM0R50=;
        b=1IKzepMsOipy9OdOZMNaRO4uljedvIKtCPeoQH9U9oj9nGIEU6SvyOfKgQN4yiCeEC
         wlHh3sADIUZ8PjgS3zZVg8N/F7spaOVhzfnsuA10nY9ppz5UlcnqbdBQuROw0Qp9dwU+
         xw9AeHoWn/VIbsgwZvxMEPkRrRQ5zPu5iQic53UO7yxgfgd+a3tglR2CDw0ADKJHVaq/
         xPCfCyDX1ZSUnIe5C6L17mClO0gvHYb8R/fqyY3B58G2STOyd38gAxBFMo0f6nGMZbHG
         FPeFVouH7C2HDyk5EJsQty5J2ES4iE8RuOfLbRHksSK4Pose3uK+Ozdht1pAb8ZuIf3S
         w7/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715307582; x=1715912382;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qb/9SIfq7posCzftop6IuZbCHyqWEssdXC1J8FM0R50=;
        b=muCDpq43FHRc3THbC+uIoVxynoWgfZVIZOhQ3xW7d0B8TCDiCn6FMsMfeOiEl09Q+y
         OY0y4afT/nLjAHf9PEPnR6gjFV77KzqaLqeLUfVGs9RJJO6mLwF9YoNINVbo9Z6nmJDL
         zjM0kB9Aws1VzD0CJrzd/OqTgV6Xbm2jKv2RcKDJoAwDwoxe07wlS6PqwjFRafHjAgeP
         gInz2YCAETpMiM3vvw/7SebXRL/+yBt8QvncmPN7SXHyJwM8ZdmvK4Stp2VdXUKwinpc
         hrT4bF3vNk0G98pBgXA14BBGHM9HthhxAqg25ooTW6+5Y+vJyNxzuOmr97giJZvh056I
         X9yg==
X-Forwarded-Encrypted: i=1; AJvYcCWLdOMmNL85G2DWK2US+xb2TDWr4AlTJlSUOMMWe7w+6F/09qrOpu+CVtG8zoROlc+a1Tj0taTRjPIt/Nk0ugEVg+MFGcvPSo4=
X-Gm-Message-State: AOJu0YzoFCFAzmt/seyzC8ZM+VAaoopWw2Ht0fBtxk6xCZBWyrJELXHY
	5y2BVlmoPRgiJw7rgZKJsrVHQ76Ovmn7bm07aT6lfWR2n82HFKXoa/bXgMFvQci4HaAO3uXPiYG
	N
X-Google-Smtp-Source: AGHT+IGM5L8XLJ8ms+8uF0I6HhH4Uo5fOXWi9kTowzUaiHKOnMs1R9THJxDbXmlLax5ikbrpaZFzhw==
X-Received: by 2002:a17:902:d2cd:b0:1e8:4063:6ded with SMTP id d9443c01a7336-1ef43c0c80cmr16348095ad.1.1715307582241;
        Thu, 09 May 2024 19:19:42 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0b9d1642sm21186465ad.31.2024.05.09.19.19.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 May 2024 19:19:41 -0700 (PDT)
Message-ID: <a9cdda78-99f5-4546-863f-8f17f278610f@kernel.dk>
Date: Thu, 9 May 2024 20:19:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: support to inject result for NOP
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
References: <20240510011421.55139-1-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240510011421.55139-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/9/24 7:14 PM, Ming Lei wrote:
> Support to inject result for NOP so that we can inject failure from
> userspace. It is very helpful for covering failure handling code in
> io_uring core change.
> 
> With nop flags, it could be possible to add more test feature for NOP in
> future, but the NOP behavior of direct completion has to be kept.
> 
> Cleared NOP SQE is required, look both liburing and Rust io-uring crate
> clears SQE, and it shouldn't be one big deal for raw, especially it is
> just NOP.

I think this implementation looks fine, but probably would be best if
you first had a prep patch that adds nop_flags to io_uring_sqe, and
checks it in io_nop_prep() and fails if it's non-zero. Then we can mark
that for stable, rather than need to do the whole thing.

Then patch 2 adds the actual meat of this patch, and now adds the proper
check in io_nop_prep() for whether any unknown flags are set.

> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 922f29b07ccc..5db3a209b302 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -48,7 +48,10 @@ struct io_uring_sqe {
>  			__u32	optname;
>  		};
>  	};
> -	__u32	len;		/* buffer size or number of iovecs */
> +	union {
> +		__u32	len;		/* buffer size or number of iovecs */
> +		__s32	result;		/* for NOP to inject result only */
> +	};
>  	union {

And I'd drop that, just use 'len' throughout.

Rest of the patch looks fine as-is.

-- 
Jens Axboe


