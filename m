Return-Path: <io-uring+bounces-7550-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D304A93B90
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 19:01:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 825743AA129
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 17:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68D2C214216;
	Fri, 18 Apr 2025 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="D69zhl0H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205D1208A7
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 17:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744995667; cv=none; b=tuD3IqoovzNkNkvMLzvcNC6BxBMAY84sLkNbgLIlVc+VaTrCcdgMDXDhn7Qj871noFMbOhdyKnS5FGhaZKdV67GeahuqL0SPN7Vu/IKCOt4tH5LOFCovb6fsHyUo8IrTylfoyFhJeaOkSKAY94SWvGJgtPJXfvqijc3WWQlBIwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744995667; c=relaxed/simple;
	bh=SYR2GDPqSYTkgub64AdZPx9o1QKFrMRLij6ajOCnS1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SL7frEqrKruA/+svXYitebhkbnFFpaL+mjnKbd8ccv7ceEMcCUzIHtmXfQl1XBtvMfve7/HtpYx5YFA4AzrP7hGSO5BDa46qVsDW9zLAyOFUE8CQbo8ZSumPCtxMreHdxv+kvBlgvid4oO4r7PhXHg6eWWCk+x/P6NOKb+V63sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=D69zhl0H; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-739525d4e12so1861990b3a.3
        for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 10:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1744995664; x=1745600464; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GZfaUE4B+HlWFvzb8xiiemecJSruxnGTK+UHPIQb5K4=;
        b=D69zhl0HTLznIyhFlnjBuhj3gP+uKzH15/NTly5A2WngSwIablk4mPrj03LaxKltJZ
         +M5e/rK19EkCzC83D4ZNmJEiCAPXOhUUwluWVMfHPq2RRD2GssXCM51bC5k61uikaTTQ
         KFfKwsRG9yb6Rjk6U3KTbTT5RwV47CdUt1VtFwS+9brHghal8G8B/+/BUD2wZh3d6Akh
         k3QY4pJZ4/+1hyAlMy/2vvRqXbmPSaUtoHV39Xwkk3rK1bnUEFFEoQv7tnKUMvzsgk60
         hBxgeYDFh7E2uAWZbciol3xmOie9oUlaVaEsR6f7nz9/+EP9zA8Y9bPPQ0WCkKWBcrK9
         rleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744995664; x=1745600464;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GZfaUE4B+HlWFvzb8xiiemecJSruxnGTK+UHPIQb5K4=;
        b=RlicQlBFmZF5VgFUanaYbu3M1AKl4hRLY/X61xA1cNHQisc4JDbv1MtT6BX7VfpF8S
         4cq++CKx+RCwYzgB0kGsP/SoM9cWG2Fu2/VGNv9GNPkyGfJfz+Ynuhgk+vt7Z+gEVqkG
         ucqmfiRUgj3g3BScljt1ib/QHFYbac7VW7pCKHDUZbWDOxaME3TK/SYxilzUTrjxxlaS
         w35Sn37UhLVv3MXR/J9UUeeedSYjhnX8MViUV7gYun9nUc1IhrjIexc9XnSSr3WSn+kq
         5UCIYOS7UzV/bghxugttEYILgfd5sdzu3dyCubt7qbWffr6pMKfBRgJJUodcRj7Swm3T
         XxxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfMnt4XA+ciRbLsVldn0ztUVlWZ11n2aHVmdJ3CnEwbpe0g/CK5AL5ni73zLP97z1rcB2fs+5/oQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1hwsMfP7AghOX3oZZdCPyYKSLc1k8z2pWvqem08Rs+I0kK6Uh
	gqpZc2wr4T6HYN/nKPGGg/OQBu33BkZ0zv4hHN7MKkkH8CQ0utTt6awyAQvJxHENqvjZ4n8fZ3b
	e
X-Gm-Gg: ASbGncuLwbBr15EYircuVhK4Njhkw83beSzRx0HXxwzBkcHe0KYWjSWXPiGqFOdSMm8
	JSI2hKBDDKGkMn1QtJt43ZVIKNVdHWHcdesv0mhWXhRYaPrhaYgxNoANCSsp0qfJEEqigbK7T4h
	jVI3507XB+BaswyEhobhz2iKggaz8IkGCTWkPq9UJRhQNKesiwnlRQCgu18bJZMBFo2HJhSXYge
	7hmo+i3QwBEa3qkiajiDh8qAmXqmjnNXdckCl/MtLEBCEuQUemSa661IL4LPW8yQxByRQm0UF/m
	JOaLKc/Cu0IhHo2nixv/C1VD0eugq/3027bsWqxGZcx5HtlfI/9kQ3LFCyD/P83RTKyNk/PRGC3
	IJ2xEAUiM
X-Google-Smtp-Source: AGHT+IHZfVj2Iqn8UpaOBkWMwaagcZjQSX4tx50l1b8mAIsr0rOKEIzOeQ93e1wyMNy7LzaVCmOHXg==
X-Received: by 2002:a05:6a00:1886:b0:736:51ab:7ae1 with SMTP id d2e1a72fcca58-73dc156b0ecmr4300901b3a.16.1744995664220;
        Fri, 18 Apr 2025 10:01:04 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:1cf1:8569:9916:d71f? ([2620:10d:c090:500::6:5122])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbfaaf099sm1882674b3a.136.2025.04.18.10.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 10:01:03 -0700 (PDT)
Message-ID: <1b14f24b-f84a-4863-a0cb-33d0ebcd9171@davidwei.uk>
Date: Fri, 18 Apr 2025 10:01:01 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] io_uring/zcrx: add support for multiple ifqs
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1744815316.git.asml.silence@gmail.com>
 <8d8ddd5862a4793cdb1b4486601e285d427df22e.1744815316.git.asml.silence@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <8d8ddd5862a4793cdb1b4486601e285d427df22e.1744815316.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-04-16 08:21, Pavel Begunkov wrote:
> Allow the user to register multiple ifqs / zcrx contexts. With that we
> can use multiple interfaces / interface queues in a single io_uring
> instance.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/io_uring_types.h |  5 ++--
>  io_uring/io_uring.c            |  3 +-
>  io_uring/net.c                 |  8 ++---
>  io_uring/zcrx.c                | 53 +++++++++++++++++++++-------------
>  4 files changed, 40 insertions(+), 29 deletions(-)
> 
[...]
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 5f1a519d1fc6..b3a643675ce8 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -1185,16 +1185,14 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>  	unsigned ifq_idx;
>  
> -	if (unlikely(sqe->file_index || sqe->addr2 || sqe->addr ||
> -		     sqe->addr3))
> +	if (unlikely(sqe->addr2 || sqe->addr || sqe->addr3))
>  		return -EINVAL;

Why remove sqe->file_index?

>  
>  	ifq_idx = READ_ONCE(sqe->zcrx_ifq_idx);
> -	if (ifq_idx != 0)
> -		return -EINVAL;
> -	zc->ifq = req->ctx->ifq;
> +	zc->ifq = xa_load(&req->ctx->zcrx_ctxs, ifq_idx);
>  	if (!zc->ifq)
>  		return -EINVAL;
> +
>  	zc->len = READ_ONCE(sqe->len);
>  	zc->flags = READ_ONCE(sqe->ioprio);
>  	zc->msg_flags = READ_ONCE(sqe->msg_flags);
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index d56665fd103d..e4ce971b1257 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -172,9 +172,6 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
>  
>  static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
>  {
> -	if (WARN_ON_ONCE(ifq->ctx->ifq))
> -		return;
> -

I think this should stay.

>  	io_free_region(ifq->ctx, &ifq->region);
>  	ifq->rq_ring = NULL;
>  	ifq->rqes = NULL;
[...]
> @@ -440,16 +443,23 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>  
>  void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
>  {
> -	struct io_zcrx_ifq *ifq = ctx->ifq;
> +	struct io_zcrx_ifq *ifq;
> +	unsigned long id;
>  
>  	lockdep_assert_held(&ctx->uring_lock);
>  
> -	if (!ifq)
> -		return;
> +	while (1) {
> +		scoped_guard(mutex, &ctx->mmap_lock) {
> +			ifq = xa_find(&ctx->zcrx_ctxs, &id, ULONG_MAX, XA_PRESENT);
> +			if (ifq)
> +				xa_erase(&ctx->zcrx_ctxs, id);
> +		}
> +		if (!ifq)
> +			break;
> +		io_zcrx_ifq_free(ifq);
> +	}

Why not xa_for_each()? Is it weirdness with scoped_guard macro?


