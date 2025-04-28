Return-Path: <io-uring+bounces-7750-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 773BBA9EDEE
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 12:28:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 013E517C154
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 10:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238FC25F974;
	Mon, 28 Apr 2025 10:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHDpePZl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBA525F971;
	Mon, 28 Apr 2025 10:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745836045; cv=none; b=c+gXnzRYrMbbr16/J+mf4cMH/+F47fAb8fGeMbXd96/hTWvXlqfjPpfgQiBkQyPwn3ShLdwTbzf5vDDDYFXeiKBCTVw14zpwICNysf3R7FADOOeOvr/h+ahfFCPGRrfxmwfstbdsanH+oDphVAUIRHcrsb/hJVFlcyWHpYF6TIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745836045; c=relaxed/simple;
	bh=JNL6y9IXcmBsNb0v8dMl/IC10CQI1i9T4eNVWErpDQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UEazxQMkWjlzfp7snSyVcS46bfJHd70D9HonYPyauK5sDyJdgcP2Ds6OrevtX+DLAmHX8JuAbWGb//LXuyAB++axXVsf0+nWMeflVVl+rgaDLydnCLSj4Sm3YIXUKgIUJy1hgon2p4qhFpEauA8dCIMntmEOPhYzBI7Hblu1E5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HHDpePZl; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e5deb6482cso9872165a12.1;
        Mon, 28 Apr 2025 03:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745836041; x=1746440841; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3xhKhC1fmtkSaLoJg++/Mm4NV4YPWK0HcslIuijT2U4=;
        b=HHDpePZlrBjGPcHp4yGVDm4RoREd38TpLm815rfJebWjpKKax0WIAK81+iRpr5eJ0L
         miZG14oxnmdxEjEYQ6n2rmjsTbZ/HU2TuL0Iz1isxkX9s02clOUnaewIWTTLo9KjggjS
         J16qvhSxqa9BIbnXJs1lfj8FXzqDQ1vE0sl922F6Sfg1u0WaMZcp3KTaX6ooIzxCdtM4
         EXZo2i+CZVKmo43QRd0LIT0vCT8sGNv3Pd7O3yeku4V+mhQPYQFz4j2nXSA7FEb7d6C4
         1N6QRWdRO48OrQKKj+7HQAb1M5tR5Db4Zy1nZ529DI07vX1p0WiAWdzrYGVKprKx0uWg
         r+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745836041; x=1746440841;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3xhKhC1fmtkSaLoJg++/Mm4NV4YPWK0HcslIuijT2U4=;
        b=WcNxGsaZYk/20XUZFGYtS9IMOLhma/Gajvp7334yTf0U5ZAFxNrhni+Ym6oPPMUrFz
         baUFezfTMSqnIxCdtdNPKYJVScEj58EDBccvWZQDcg0aEmamvvV912ij9QN/d557Gkfo
         c2N2vnfehMBt4Odr0FYGrJjKk2bSI4tFOhOXyb93ux7vl+ZIPo0t5a8W1UNLThkcPOlL
         URkplk75owCQdGaAxw8IOYJWAeWU+VKbUJruDkSKvm/N4CMaO/J4ABJr6s2Tj46JRRyA
         B8sHeyvTmLILE1V5PkN9pIYr783H3kasqZueQQAVb+qU7RtXtfng6YS2afRDQYXfGD6D
         HC8w==
X-Forwarded-Encrypted: i=1; AJvYcCVcg86MULW50IBKRhpUxftbHx21F3VVJoVXomeLbWFQ/AC35INE/mQZQbTiX3jXPL/yy8/pRkGYXVzLKs8=@vger.kernel.org, AJvYcCW4BhV4JxNHK4cwIpNspzO5i1FWng4VdOIIs2B26G2CaEsNOgcwfkgRa4D9TwL90bG9ygBHguYTPw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1EGEg0wOR/PhKofkcqtXbdo8acwOBcGTIwtt7aLRWH2SKVYYD
	v1lIwy1jCVn2IQqpl+lqZqogdcMrerFKICMnBq62+skCOYEZlddKUrbkXg==
X-Gm-Gg: ASbGncsnPzj1aastcxsBHV4Fk0CYH/n/g3SPX/RV8ddsndTZofCIUhpJW86OzlT8GyA
	r5rQ8RX8QetP58++BqOxH9qnjQcG0MSNPtRkgftnTzgmmVvdClPIHcXFdHDK8tfizABXGpMiV49
	Bh6d4gQKi6ymNhodp56T2AAcgbojW/tOfMJvOoxLCF0bxh1kSceryShiZZ24QSHzvk2NFKgeUBR
	A1k8JYCo2Emg1UZ/q+oM9vLXi+Lrqvn3dkoJkDASsOorUUsCdc2iBYPSgJDEMeQHbpz7CJXkDtR
	iQL324Y71Q682bmWT1YteGKL8ZSWmujPw/WTsATEt2woVTB5LrJPRA==
X-Google-Smtp-Source: AGHT+IGqINVV60lcXVB/C1MxU7TxOwTp2tG8SoP7zS+mRWR8a5O+KYv7EMTywDndv8a9zx/So9N7oA==
X-Received: by 2002:a17:907:7208:b0:ac7:3929:25f9 with SMTP id a640c23a62f3a-ace5a4854bbmr1317561566b.29.1745836041299;
        Mon, 28 Apr 2025 03:27:21 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::3ef? ([2620:10d:c092:600::1:8360])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6ed6aed0sm601229866b.135.2025.04.28.03.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Apr 2025 03:27:20 -0700 (PDT)
Message-ID: <0c542e65-d203-4a3e-b9fd-aa090c144afd@gmail.com>
Date: Mon, 28 Apr 2025 11:28:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/7] io_uring: support to register bvec buffer to
 specified io_uring
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
 Caleb Sander Mateos <csander@purestorage.com>,
 Keith Busch <kbusch@kernel.org>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
 <20250428094420.1584420-4-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250428094420.1584420-4-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/28/25 10:44, Ming Lei wrote:
> Extend io_buffer_register_bvec() and io_buffer_unregister_bvec() for
> supporting to register/unregister bvec buffer to specified io_uring,
> which FD is usually passed from userspace.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   include/linux/io_uring/cmd.h |  4 ++
>   io_uring/rsrc.c              | 83 +++++++++++++++++++++++++++---------
>   2 files changed, 67 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 78fa336a284b..7516fe5cd606 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -25,6 +25,10 @@ struct io_uring_cmd_data {
...
>   	io_ring_submit_lock(ctx, issue_flags);
> -	ret = __io_buffer_unregister_bvec(ctx, buf);
> +	if (reg)
> +		ret = __io_buffer_register_bvec(ctx, buf);
> +	else
> +		ret = __io_buffer_unregister_bvec(ctx, buf);
>   	io_ring_submit_unlock(ctx, issue_flags);
>   
>   	return ret;
>   }
> +
> +static int io_buffer_reg_unreg_bvec(struct io_ring_ctx *ctx,
> +				    struct io_buf_data *buf,
> +				    unsigned int issue_flags,
> +				    bool reg)
> +{
> +	struct io_ring_ctx *remote_ctx = ctx;
> +	struct file *file = NULL;
> +	int ret;
> +
> +	if (buf->has_fd) {
> +		file = io_uring_register_get_file(buf->ring_fd, buf->registered_fd);

io_uring_register_get_file() accesses task private data and the request
doesn't control from which task it's executed. IOW, you can't use the
helper here. It can be iowq or sqpoll, but either way nothing is
promised.

> +		if (IS_ERR(file))
> +			return PTR_ERR(file);
> +		remote_ctx = file->private_data;
> +		if (!remote_ctx)
> +			return -EINVAL;

nit: this check is not needed.

> +	}
> +
> +	if (remote_ctx == ctx) {
> +		do_reg_unreg_bvec(ctx, buf, issue_flags, reg);
> +	} else {
> +		if (!(issue_flags & IO_URING_F_UNLOCKED))
> +			mutex_unlock(&ctx->uring_lock);

We shouldn't be dropping the lock in random helpers, for example
it'd be pretty nasty suspending a submission loop with a submission
from another task.

You can try lock first, if fails it'll need a fresh context via
iowq to be task-work'ed into the ring. see msg_ring.c for how
it's done for files.

> +
> +		do_reg_unreg_bvec(remote_ctx, buf, IO_URING_F_UNLOCKED, reg);
> +
> +		if (!(issue_flags & IO_URING_F_UNLOCKED))
> +			mutex_lock(&ctx->uring_lock);
> +	}
> +
> +	if (file)
> +		fput(file);
> +
> +	return ret;
> +}
-- 
Pavel Begunkov


