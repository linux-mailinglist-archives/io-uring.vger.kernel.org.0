Return-Path: <io-uring+bounces-675-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 719B68613F9
	for <lists+io-uring@lfdr.de>; Fri, 23 Feb 2024 15:32:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 123451F22B5E
	for <lists+io-uring@lfdr.de>; Fri, 23 Feb 2024 14:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFB27443D;
	Fri, 23 Feb 2024 14:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3avPHSHt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72235387
	for <io-uring@vger.kernel.org>; Fri, 23 Feb 2024 14:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708698711; cv=none; b=YvCzc5dmSFLrVFd4ndjvhRMjxU94jCu1avlXciYZWTePHwU0yZLaP8yfatbL2hm6+OG/9twoXPXnFfJ5Syq5N1XC7egX85+I6D6rtOUtJU/XAnZt08XgtKWvPIIQyNgUjQgB3/z9eDNjJ6DERVJrsM7/J9n9k0mSdRXlXi5fJkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708698711; c=relaxed/simple;
	bh=mQ7n5DbfgzNDlenz4pOvucV+mrPC5iX3GTxKMuisasc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JOoOMy4OANCpEcFEgMC3kmhuV+xW91g5MP7zhM2Bf27F0SyoBVcpnT4W0WATa32m2r26uKlmflGStT0J6qUw68Z7yk9uTIqpeS7CE70Exni+VoYCL4bU/hhs56jKYwO4mm7lNGuRDCteOJbZeFcjl/RxppwW+z6u9Jdw9Apxykg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3avPHSHt; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e28029f2b4so43845b3a.1
        for <io-uring@vger.kernel.org>; Fri, 23 Feb 2024 06:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708698707; x=1709303507; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F+zIwcm92R+5UE0ZKoQrjhfT95FCPbxCnXqLiTrlmEs=;
        b=3avPHSHtRvHFe0bFCj/eX+d1J1I1NJ3fqag/IQxxlGZ+UHULzCVZ7DL33/PezDDBpy
         7e1+olhZ0rFhlqG11G71cdtIUsnBfwntraFQLvEGq+au9I+p4xvTnTN+fh/pT28ZGSlM
         RVHEfgYGKnuAoSr9J3PmyLyfLTPB4qgJMtI2PmD492d/74stn3CkpsoU5mWwHFogiSAM
         lbUdDOYT4r8WXz1J0b5Y3XwXNGEMxKL04cff9QLGpCb4A6DfpOWTl/7nVFoMFUh4q6Cd
         BIZ0AWEU6TFyxeHlTOcuIJN7aPpbLCSeq8PDeS6zQCFjbywNdwsoDbDXZLOA9BjEB6hA
         uKZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708698707; x=1709303507;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F+zIwcm92R+5UE0ZKoQrjhfT95FCPbxCnXqLiTrlmEs=;
        b=p1xr6w8sw2dsEoCvO9NuWXnbDOHZtMmPoGfQ/jLRkFOzaK+oG88qZh0nMD6eek9yEC
         dxw9pe7P5iuuS7EtsvuZeq06fFaYiZMmK/zemYgcetDckNKgBL6vJCsoB0F7bJoeI7H/
         HhKBPOm47JO8C9qcp9XkloP3rC0T5HBpxT+U/JIU/8oIzQaEc33AqNBILa5EbHwxLS6E
         Sp3C8CiIzEawd0XLgtdgrIBURtzKLFCKi6/xvrses2rz8YOw4EoMNtzkeUU+USFDSzuF
         hILWhVxpygPimcpXAzI9WL56zTZI7z/dy+dVvtCJQDZeTSvpmpAcA40CiVn18YcJ2M7c
         LmRw==
X-Forwarded-Encrypted: i=1; AJvYcCVthdDigDOZ9UgvH4YiZdAkJgZsv+wLIMGYL8CDwsBOPImyagxwxwuG3APXoD1gm7jU63+/9rYrZHETanG8UiTSqfOVa/fmBfA=
X-Gm-Message-State: AOJu0Yyv5XidTytCITv25tQKBrGNjkxb6ZPyklV0OsclbYFXbzWprt8I
	SUOSxn1TaUDYGlkMRg9y13L57kn4OiP8fkiFj29HwzJYsxphjmZlmJGGUeOnReC7m9WCjVsjTT9
	J
X-Google-Smtp-Source: AGHT+IFmDLGa0duKCXEWjmEc8ntybdg0IyQH0HPBLF7OJSmFdhFboWzVU5K0+7Y/IC+/lHZnFT8bzg==
X-Received: by 2002:a05:6a00:92aa:b0:6e4:c69e:11d7 with SMTP id jw42-20020a056a0092aa00b006e4c69e11d7mr2217880pfb.1.1708698707558;
        Fri, 23 Feb 2024 06:31:47 -0800 (PST)
Received: from [172.20.8.9] (071-095-160-189.biz.spectrum.com. [71.95.160.189])
        by smtp.gmail.com with ESMTPSA id k7-20020aa79d07000000b006e04c3b3b5asm13328500pfp.175.2024.02.23.06.31.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Feb 2024 06:31:47 -0800 (PST)
Message-ID: <71ce7853-a1b9-4475-ab2a-0d751d156e1b@kernel.dk>
Date: Fri, 23 Feb 2024 07:31:40 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1] io_uring: only account cqring wait time as iowait
 if enabled for a ring
Content-Language: en-US
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20240223054012.3386196-1-dw@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240223054012.3386196-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/22/24 10:40 PM, David Wei wrote:
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index bd7071aeec5d..57318fc01379 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -425,6 +425,9 @@ struct io_ring_ctx {
>  	DECLARE_HASHTABLE(napi_ht, 4);
>  #endif
>  
> +	/* iowait accounting */
> +	bool				iowait_enabled;
> +

Since this is just a single bit, you should put it in the top section
where we have other single bits for hot / read-mostly data. This avoids
needing something many cache lines away for the hotter wait path, and it
avoids growing the struct as there's still plenty of space there for
this.

> diff --git a/io_uring/register.c b/io_uring/register.c
> index 99c37775f974..7cbc08544c4c 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -387,6 +387,12 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
>  	return ret;
>  }
>  
> +static int io_register_iowait(struct io_ring_ctx *ctx)
> +{
> +	ctx->iowait_enabled = true;
> +	return 0;
> +}
> +
>  static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>  			       void __user *arg, unsigned nr_args)
>  	__releases(ctx->uring_lock)
> @@ -563,6 +569,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>  			break;
>  		ret = io_unregister_napi(ctx, arg);
>  		break;
> +	case IORING_REGISTER_IOWAIT:
> +		ret = -EINVAL;
> +		if (arg || nr_args)
> +			break;
> +		ret = io_register_iowait(ctx);
> +		break;


This only allows you to set it, not clear it. I think we want to make it
pass in the value, and pass back the previous. Something ala:

static int io_register_iowait(struct io_ring_ctx *ctx, int val)
{
	int was_enabled = ctx->iowait_enabled;

	if (val)
		ctx->iowait_enabled = 1;
	else
		ctx->iowait_enabled = 0;
	return was_enabled;
}

and then:

	case IORING_REGISTER_IOWAIT:
		ret = -EINVAL;
		if (arg)
			break;
		ret = io_register_iowait(ctx, nr_args);
		break;

I'd also add a:

Fixes: 8a796565cec3 ("io_uring: Use io_schedule* in cqring wait")

and mark it for stable, so we at least attempt to make it something that
can be depended on.

-- 
Jens Axboe


