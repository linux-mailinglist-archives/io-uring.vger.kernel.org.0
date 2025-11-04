Return-Path: <io-uring+bounces-10361-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57607C314FC
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 14:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 493C3188429C
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 13:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530221922FB;
	Tue,  4 Nov 2025 13:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IHrS+QMi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0022E9721
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 13:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762264405; cv=none; b=Rxj42tITCG4eXdg+X+msiSE2DAPMFMPkY84irGB/6GCirGEH1mq01Q57TNhPbatyDBynvnE15lVOaPZqKY8qElBfj2AUYjrsOcw8jQORBdZ8cyJ2GCGpdavvJBYu+EYV3My++26fLpoldvWmBByv4hyQhs2QCUC6mtkIuZPUxpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762264405; c=relaxed/simple;
	bh=UxAvDGAGCoIk5OLuG5PyrBfEi7TsHW4FLoS6QeQZQTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JRoIiYojxmq52/D7lTUaX7+l4C9XCI5H4DVVMzbDviSosU0AVXqUddnrtfdZKjAflovQ6FNDGasT3YXsegFq4w/9w6aMnhR0MD63TOpl47dl+6QVpJDvzn8rPHOSYPHLBioj3FMaUVihuY9pS1sXrkhMStnYSU+/nbqv80tDVmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IHrS+QMi; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-477563bcbbcso3560175e9.0
        for <io-uring@vger.kernel.org>; Tue, 04 Nov 2025 05:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762264402; x=1762869202; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UVswTIUqwaVcpvvOza2s2v5rkWcsQPLaGHXFWG1zOkI=;
        b=IHrS+QMiFhuOspluZvgaITgRp+P4cx+9WT6u77yaNXFKMZMy69eP68ccVNj6hAchUS
         UqqEIHK/o2ZK1VefG6mKBovYBsgj0GtgG1+LVwN8kT0qLgCtQBo5O2wu+zSGIXS5a9me
         iAO/ZjgyCJwz4atZRlKpGh1lsT1c9FuW2XpRib0OVEWAERwVLUpMdhBzYz4yHgm8c48A
         NxUQmHmlMAbd8nBwRoafa+zYRa5qjnoi1st4c2b15vH8ZTfumANmizA9XYV1j/SFaGlD
         Pc9MlW2G4J4YFTWe0KNSAb5YF3Ls+0T961VPixwKKnp1X3ObdRWDGZn9GnypVajMksWo
         g5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762264402; x=1762869202;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UVswTIUqwaVcpvvOza2s2v5rkWcsQPLaGHXFWG1zOkI=;
        b=tf5OEyxLV5mMFHoGnyBKHzWzXfqWmJyRHXmXd1LG7NRBiwNQcqOBp+HIIVbDxF8BAL
         1lW4SGW8TU77xm38fMY6GRtTo0P481MrKiSgiBTyX3hd9l/IuVL3X8SQDMEj/8lqwPX0
         dFlDoesH+3g0ZR31SuG37seWbUmQclKgZjWdhBpOpuRiLf/Rz2/7oGGDCfpR6PzdaVpU
         CTlQ63bw6n7XsM/hhrluzTFDxafmF+ehbFA1KrThki+tp1Gc5aMGr4DnmonDhli3PLKh
         kfrXqZKBC2JQmBbJCbxA0V2sqIJ5Zg+0AmgQAitV7FsaJnaJ5AjPvtIKGkjinKoaNyj2
         khdw==
X-Forwarded-Encrypted: i=1; AJvYcCVNCsaPzgIucTCcY/S3oQPUr6cH+ReFRNE9loCFqIfcCVV9IP156wKYhNxNwp0eIjaLJDIYaZMICg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwtJ7MLYgnlT7RGON+dxO3sizBH08eAY2JTYDXgtTxJwZXvtP7a
	f6AukrK2t+S4PHOqg8Wvz7bUZkuUTJVIZgo9WZ6cY3K1kKqtlP6meUaUk11jNA==
X-Gm-Gg: ASbGncsbKiVc702rPSfVUbkEx0CMEY+cGb5XgGB4b41jZAkzx0w4fTtrSyPZCJyuruR
	U8GQC/5pLYtIF2fqbbw5YlEeKIRVgIFeT3VdJw1lpDxsqhh4jefzun8cGpkcCjJ7ZCR0/y3Z9bA
	rue7Am2W7VYos8Xu9NtSL3HxVBS2ED3a/xFXwOpL8mE4HMoQCp2hWv2z64EP2enJdopEuobl5MP
	R2Xz9CZ7cLJGNFHHbmoVHWvifDrUHPgSNIKssJV2aTpZf3uyOYLj2qtDH07xZmA5uya81KaRZBr
	4jUIEOIAQttb4GtL+J++dbRPYkfCdVzRjX1xswVpQqmluxhTNWikwFWtVIAz0KQ1uJ9yw0149HR
	NY6uQbeOviKOZpeqntOK0jcEDZ5NVMfeW9eWieVmlCl7TkRdWg3sYV3KZ18xsCosKEWTyeSruy0
	zEVxyCmy1+lYyHKr0cPWwKd3xjTcIwrDzV+7rb+Zzs3nF+DoJMkPI=
X-Google-Smtp-Source: AGHT+IF76Obe5eAqidOCakeytBBcLeDYgGfe3MruoJ+zCd2LdUq8R6mjNcIjxJ4UVeBF9Cnh/854Fg==
X-Received: by 2002:a05:600c:3acd:b0:46e:32f7:98fc with SMTP id 5b1f17b1804b1-477498de36fmr76929235e9.21.1762264401533;
        Tue, 04 Nov 2025 05:53:21 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47755a550dfsm40206505e9.17.2025.11.04.05.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 05:53:20 -0800 (PST)
Message-ID: <98e5fe45-7d8a-4e40-884b-8f462b5f39a7@gmail.com>
Date: Tue, 4 Nov 2025 13:53:17 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/12] io_uring/zcrx: share an ifq between rings
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251103234110.127790-1-dw@davidwei.uk>
 <20251103234110.127790-13-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251103234110.127790-13-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/25 23:41, David Wei wrote:
> Add a way to share an ifq from a src ring that is real (i.e. bound to a
> HW RX queue) with other rings. This is done by passing a new flag
> IORING_ZCRX_IFQ_REG_IMPORT in the registration struct
> io_uring_zcrx_ifq_reg, alongside the fd of an exported zcrx ifq.
> 
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>   include/uapi/linux/io_uring.h |  4 +++
>   io_uring/zcrx.c               | 63 +++++++++++++++++++++++++++++++++--
>   2 files changed, 65 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 34bd32402902..0ead7f6b2094 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -1063,6 +1063,10 @@ struct io_uring_zcrx_area_reg {
>   	__u64	__resv2[2];
>   };
>   
> +enum io_uring_zcrx_ifq_reg_flags {

Maybe just zcrx_reg_flags? "io_uring" prefix we used before makes
things too long and quite unhandy. And "ifq" is dropped as it's
not great long term assuming one ifq backing it.

> +	IORING_ZCRX_IFQ_REG_IMPORT	= 1,

Same

> +};
> +
>   /*
>    * Argument for IORING_REGISTER_ZCRX_IFQ
>    */
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 17ce49536f41..5a0af9dd6a8e 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -625,6 +625,11 @@ static int export_zcrx(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
>   	struct file *file;
>   	int fd = -1;
>   
> +	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
> +		return -EINVAL;
> +	if (!(ctx->flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED)))
> +		return -EINVAL;

This chunk should be in the import path.

> +
>   	if (!mem_is_zero(&ctrl->resv, sizeof(ctrl->resv)))
>   		return -EINVAL;
>   	fd = get_unused_fd_flags(O_CLOEXEC);
> @@ -646,6 +651,58 @@ static int export_zcrx(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
>   	return fd;
>   }
>   
> +static int import_zcrx(struct io_ring_ctx *ctx,
> +		       struct io_uring_zcrx_ifq_reg __user *arg,
> +		       struct io_uring_zcrx_ifq_reg *reg)
> +{
> +	struct io_zcrx_ifq *ifq;
> +	struct file *file;
> +	int fd, ret;
> +	u32 id;
> +
> +	if (reg->if_rxq || reg->rq_entries || reg->area_ptr || reg->region_ptr)
> +		return -EINVAL;
> +
> +	fd = reg->if_idx;
> +	CLASS(fd, f)(fd);
> +	if (fd_empty(f))
> +		return -EBADF;
> +
> +	file = fd_file(f);
> +	if (file->f_op != &zcrx_box_fops || !file->private_data)
> +		return -EBADF;
> +
> +	ifq = file->private_data;
> +	refcount_inc(&ifq->refs);
> +	refcount_inc(&ifq->user_refs);

It'd be a good idea to fill in basic info about zcrx
it usually returns from registration. E.g. offsets.

> +	scoped_guard(mutex, &ctx->mmap_lock) {
> +		ret = xa_alloc(&ctx->zcrx_ctxs, &id, NULL, xa_limit_31b, GFP_KERNEL);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	reg->zcrx_id = id;
> +	if (copy_to_user(arg, reg, sizeof(*reg))) {
> +		ret = -EFAULT;
> +		goto err_xa_erase;
> +	}
> +
> +	scoped_guard(mutex, &ctx->mmap_lock) {
> +		ret = -ENOMEM;
> +		if (xa_store(&ctx->zcrx_ctxs, id, ifq, GFP_KERNEL))
> +			goto err_xa_erase;
> +	}
> +
> +	return 0;
> +err_xa_erase:
> +	scoped_guard(mutex, &ctx->mmap_lock)
> +		xa_erase(&ctx->zcrx_ctxs, id);
> +err:
> +	zcrx_unregister(ifq);
> +	return ret;
> +}
-- 
Pavel Begunkov


