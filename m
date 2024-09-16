Return-Path: <io-uring+bounces-3201-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8C1979F32
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 12:23:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2122D282776
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 10:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4D81514CB;
	Mon, 16 Sep 2024 10:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QvYdQ+7G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C911F149C4F
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 10:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726482193; cv=none; b=EUKzd9lT9nQjVzePGEBffNcv0Gd9SYjdk8wzNuXBxe7YMSVCNvSNKK9KrJdQ0QFuQQjURHn0Uv53T/CIrqRCQXS2ZSZsBflVy74BsJlpYkiMv4oMGzrn0T5nPXOPwLX9Vpxm//4Qb+ouGYhZGEpZ5BelHVOeQXJ/w5dfE96/b+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726482193; c=relaxed/simple;
	bh=ZqnZpXtTmD3xKatofZAAQwvvqaq1jPma7L0SLkoI0/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FcOE6n2z4JngH5Q4O9NRb9sA3ATzRcVeGPp4igS9wp2IdsNqW5+/svBlvaBb1yMmAKSStf/WBXLlJwuakfW9Cct15ahNlyBrurCgc8UrHxj9XgHBoMk/9Hh903x57N9HHOVa0pvfAv8RMOll2ACFk9PgoRG6/dmY0na69t3O8NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QvYdQ+7G; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3e037b80140so1734001b6e.3
        for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 03:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726482190; x=1727086990; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gaX/Nl5/3cR/IWOOBCBwULhjgxhh2BtefvY1mo/HwHk=;
        b=QvYdQ+7GRVJtp2Bu2ZJUkiq3UrNl7NslpZ6MUsG4xlh5y+oVjnzlGpG3SZYEIhArWS
         ltDkd16nvAZotW5va2eOZvXTGa1/BseZVC54zFOKGwzkhrDAa9E3F7aiLkVXLkBToAA5
         hBpeQAOtCdYNo79JOuIAK4bQUXNfTukiTmu4yK77rDfiLPlzSD4IJJwQ88TLviIu22oU
         IwWp180sUUdcJ0Sz+r9ZysabB+B93Yjcp6ORw2VzSc6C2lu33XYI1tI7TBXvYjnZRDd2
         Q/BjIu1jnulF9uJdA2lfe94U2Se5VdE+cb1u9WT/pAg2JqrJAqJB0Z2+8tWCm9s5WQZZ
         IASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726482190; x=1727086990;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gaX/Nl5/3cR/IWOOBCBwULhjgxhh2BtefvY1mo/HwHk=;
        b=E0MXsV4OFumGUjDkuouTxYzHMVFJJ2EkzMi1nzbT5wTo1EYuXzbitcPVdeBcTjzj64
         idW8XOfAZinre4qwqu1gMmJUOkVl2XnDcoVnAegIAJhGySMaH6xfUo27vZGHUrHLNoBx
         TYtXOpYm3nLuTIcgKr77RpVJLI2rkEVQmJWXYi5QChDruhZ8wHeeGo/jNBTur/MHVv5G
         /JkQSEm5GkbzqLgZ0qscaxGugyQEZwAXABIV8GiOi4RPcMGgHUN8rw/cO+j3MzeMuH7g
         CAvVquZdXH3Ep7KqR/oDudFbGnoIbOnJmEssWZ6Qp0/EAdtgvSloRZSvwApOJoPQbVTl
         o81w==
X-Gm-Message-State: AOJu0YwnqP0eVtWcaVvfaamAHmmpZ3j9NDN4Hsi7qTU9dwUvxi94BPaC
	Q6LzzTY1QQB9MAn7S0ZoDZZ9ZpX2IyocPJgKtlwVxREZYu9cj60lXn/44qVps7o=
X-Google-Smtp-Source: AGHT+IFtOxpO84Kl57j41oMHZVIUwq1Gqwjy7ylxMw8W6XLORt9sp+fQTZCyuPQ87KKsr1rheIkZVw==
X-Received: by 2002:a05:6808:1411:b0:3e0:43ca:bfd4 with SMTP id 5614622812f47-3e071b15e1dmr7258794b6e.44.1726482189655;
        Mon, 16 Sep 2024 03:23:09 -0700 (PDT)
Received: from ?IPV6:2600:380:6345:6937:6815:e2a7:e82c:fd22? ([2600:380:6345:6937:6815:e2a7:e82c:fd22])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e166ce5024sm996647b6e.3.2024.09.16.03.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Sep 2024 03:23:09 -0700 (PDT)
Message-ID: <e3e6035d-078f-4803-850e-9308a75023a7@kernel.dk>
Date: Mon, 16 Sep 2024 04:23:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/sqpoll: do not put cpumask on stack
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: io-uring <io-uring@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <20240916102029.1252958-1-felix.moessbauer@siemens.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240916102029.1252958-1-felix.moessbauer@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/16/24 4:20 AM, Felix Moessbauer wrote:
> Putting the cpumask on the stack is deprecated for a long time (since
> 2d3854a37e8), as the masks can be big. Given that, we port-over the
> stack allocated mask to the cpumask allocation api.
> 
> Fixes: f011c9cf04c0 ("io_uring/sqpoll: do not allow pinning outside of cpuset")
> Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
> ---
>  io_uring/sqpoll.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 7adfcf6818ff..004740d6577e 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -461,15 +461,22 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
>  			return 0;
>  
>  		if (p->flags & IORING_SETUP_SQ_AFF) {
> -			struct cpumask allowed_mask;
> +			cpumask_var_t allowed_mask;
>  			int cpu = p->sq_thread_cpu;
>  
>  			ret = -EINVAL;
> +			if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL)) {
> +				ret = -ENOMEM;
> +				goto err_sqpoll;
> +			}
>  			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
>  				goto err_sqpoll;

This leaks allowed_mask... Probably allocate this _after_ we've already
sanity checked the 'cpu' value itself.

-- 
Jens Axboe

