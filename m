Return-Path: <io-uring+bounces-3203-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CB3A979FE4
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 13:03:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63C271C20891
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 11:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE0313C67C;
	Mon, 16 Sep 2024 11:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dC/G7gsV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6FC13A89B
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 11:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726484624; cv=none; b=j59NtcKW0T7jbPkO+OrpokUvD/enJp9aSGg+tQeo4KLrGWJeNMnUjDgxlPCCMEOXLdZyIDyLLHfY3fgTdTJGynQpdmsiNeoiAilAcl8As9NIhShkF2ENmoEhczfZofsozsLBgpYFmCJS797Ya0PuVFMzLGa4YCXiHLtm9OEqekg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726484624; c=relaxed/simple;
	bh=K4Gc/5fWWfAS5Y1h8RAMu6JxU15yK965qSP88TJWVis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vlf03g8H4bmRwdFLnZ76J+1NNvY8VrRMENiM2yY13r9Tk/jMoYeqAFi2XYD5kF7Q6kvItGdT+LxktCB3ESkiAyYi+XLW6iicQt9C8ZIB0l4hbZ9hObuL8lcAafgJaLOarHfliqLMkwfIgOWUBXvsxKawFSqoq6k21eUIgZOJMdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dC/G7gsV; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3de13d6bdcaso1086940b6e.2
        for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 04:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726484620; x=1727089420; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oZ241FAYjIdlTkt2yeF5hLBl0idLofaihq6pPixpEk4=;
        b=dC/G7gsVVIV507MDyGIuvFyT63xwH4D/pyp5MUb++HNkdhx2L7ZNHxf/vFGz+qtn31
         qHz5aeVXLa7Q3BINofEWwswAcH3cCcjytzciTzREIj4NMzbiqczvcqUbJnwaLM4Ypvye
         cpKvswUgPJX97dY/+RnWGsu6d+/WtY8nqPScCm7xMrxPSo58JNvwwHRGsPV7wUBch5jq
         t003K4o+jnKIa0+2mZyYrqVkXGGr0FqCZq3W91JScjYyby0npjLoEaEgm2YCeQyoKgPu
         9+5met+0P1J759Kv4WvZ7MphZ/rspPkr9GqpU6h7eN2kN9G5YKagZhXtC5KyI+ng7iYA
         mscA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726484620; x=1727089420;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oZ241FAYjIdlTkt2yeF5hLBl0idLofaihq6pPixpEk4=;
        b=lWjAOuhjbJ0o0xiByJVLT81nvcF6s1AZLlS6gyCFACwqKVom5HSlucHPNWwp7VNBRB
         1dK1+CYxwypswn6qzpotQWRBBIl2yGnte2fm8w5E0VrQgLmdXF5YE5Bj6lN8ad+cdqAI
         8ysswk6u8iXy52q0alfaPciBtU2MhqnkuyABxGnE0Z0MaeGXIoTn0p2XbNL8n4NQFQys
         QQ+/vML28MI3XaIqa769RUU4FeOMFMvPsuVua4Qnl58Gic/fzVB4XgN2EFHABc7OWC8e
         7FJcqwzdOzXcKejdzYEGLMSC1RTqLEw5EIh4OKBuu52mQgPRrO4f6YIQiunRZxyuFZyb
         DT/Q==
X-Gm-Message-State: AOJu0YyL94cSULjF4yscXABRipLWvVAyP90YD12tWlFg271102Ms+4Vi
	n8NwTVK1c3szW1tE36qgEhPyEMFpkOgt2WWgINae+nVkKjCC/JmAJ584tt+h3bU=
X-Google-Smtp-Source: AGHT+IEkvfijvx6b/cusc1elEJGtaif6+JrOLjCWA89H6In+VCevQ1A2wDpFVlwBaN2zvwrsOnG/Pw==
X-Received: by 2002:a05:6808:1454:b0:3e0:4eb4:6b57 with SMTP id 5614622812f47-3e071a90904mr8195494b6e.1.1726484620383;
        Mon, 16 Sep 2024 04:03:40 -0700 (PDT)
Received: from ?IPV6:2600:380:6345:6937:6815:e2a7:e82c:fd22? ([2600:380:6345:6937:6815:e2a7:e82c:fd22])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e166f89f50sm984746b6e.37.2024.09.16.04.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Sep 2024 04:03:39 -0700 (PDT)
Message-ID: <8bc08bc1-df91-45c5-829a-a0beb0f74652@kernel.dk>
Date: Mon, 16 Sep 2024 05:03:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] io_uring/sqpoll: do not put cpumasks on stack
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: io-uring <io-uring@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <20240916105514.1260506-1-felix.moessbauer@siemens.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240916105514.1260506-1-felix.moessbauer@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/16/24 4:55 AM, Felix Moessbauer wrote:
> Putting the cpumask on the stack is deprecated for a long time (since
> 2d3854a37e8), as these can be big. Given that, we port-over the stack
> allocated mask to the cpumask allocation api.

I'd change that last sentence to:

Given that, change the on-stack allocation of allowed_mask to be
dynamically allocated.

> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 7adfcf6818ff..44b9f58e11b6 100644
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
>  			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
>  				goto err_sqpoll;
> -			cpuset_cpus_allowed(current, &allowed_mask);
> -			if (!cpumask_test_cpu(cpu, &allowed_mask))
> +			if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL)) {
> +				ret = -ENOMEM;
>  				goto err_sqpoll;
> +			}
> +			cpuset_cpus_allowed(current, allowed_mask);
> +			if (!cpumask_test_cpu(cpu, allowed_mask)) {
> +				free_cpumask_var(allowed_mask);
> +				goto err_sqpoll;
> +			}
> +			free_cpumask_var(allowed_mask);
>  			sqd->sq_cpu = cpu;

The kernel generally does:

ret = -ESOMEERROR;
if (fails_check)
	goto err_label;

and you're now mixing the two here. To keep it consistent, it'd be
better to do :

ret = -ENOMEM before the alloc, and then re-set it to -EINVAL before the
cpumask check.

-- 
Jens Axboe

