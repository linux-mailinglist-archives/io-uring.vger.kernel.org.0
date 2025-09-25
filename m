Return-Path: <io-uring+bounces-9878-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC445BA0220
	for <lists+io-uring@lfdr.de>; Thu, 25 Sep 2025 17:09:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D124C1C21D45
	for <lists+io-uring@lfdr.de>; Thu, 25 Sep 2025 15:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0FA830BF4F;
	Thu, 25 Sep 2025 15:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bu/uciLX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E4330AD14
	for <io-uring@vger.kernel.org>; Thu, 25 Sep 2025 15:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758812617; cv=none; b=nvxaH0IRBAIXuTzwJTkKBiPjvB8m/WS5q9pkUnAsiuuSW7pmXfV1jqLUPD6hrzJyqxv7dotv3vXTXEeIGGazpFTmfBOYqN7j857lFBFXadOjkF5/kzR6RX39QRGfcWsmflyCdANa1/k4s40LUxQ4sXFiUhMO4gOBXIBJMmDlNOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758812617; c=relaxed/simple;
	bh=suuvAV8HM/PZaRGYUxUEQW0COpcJhYzd97Ndyn3Peoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f06gsBMrcGoSGUcJPHcgsYF3zxQHmQINVREuwVVQ/gJmNpW6f3TAbw3OGeeQmSsNyUhY+bDLS49o7eLeSd0lAZMRRyv6JQ5ofgGVfeH3hicEO9jFacjQddgQYg1FyD5RbHfteu0+PN+NMKrXzaHErXg7nCU2HaGRraQnz68rAcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Bu/uciLX; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e2562e8cbso9487005e9.1
        for <io-uring@vger.kernel.org>; Thu, 25 Sep 2025 08:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758812613; x=1759417413; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Iw35yhAn7j0CUlRxDSFxH02vLFDVDDxxrruaowsaVnk=;
        b=Bu/uciLXRzcLdaVI2t9/s5NPd/kw+PrMK498NstUl5JLWy/BHDcCiFW46ulo6XM9b+
         y9YJprjHjfOIM2sng+BZgEtOkQhM6J9vKiWkoaBFr4HT1DCm1DWDJy067Ciubhnmdscg
         8V0Y6eyd6VbwJlKK87wYxqNOcILtvmL2ARMsoWUTVkZjfmuANI6n66yxAagTZfQPlBI0
         Oa8tka4XozXvx/TmJMfiNFrkNOHHF1gSuH5kBRdFzs0yf/eUzSwFo4VWkkZ9YZLsdHLt
         kzNJY+LNxXTWJoXuNSPs5EOFLEDcPJrqUzXXkK6eqKftkTe7YYSUlgwoBN3CG7bmPJcB
         KhCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758812613; x=1759417413;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iw35yhAn7j0CUlRxDSFxH02vLFDVDDxxrruaowsaVnk=;
        b=pEMt4RxRqec7QN5VMsF436guvN/kX+E+QivBx7x81wHNQNpxN78ynXneo5+olnKb0N
         FjPWBEhGz7NxkGW3mfMcHQcXbY4MOn+P8Yyj9fWF1lucxQbzF4BkFqQYJjBokue4VT5Y
         VBlemyBpbgv+eER32M3vpH5+TbT2/+iuXzJ7tShHBbARWFrjHKJP4bnd4o/Rkh+hfGkG
         CSyZrEPMjAOc6Yvh50lNhiBjKpw4wq6elFxZxSRR4TqMMYUoGDUbE4FrwSvNcbkSA7zp
         lpuQTj3KVxlmK7JqiqeC7cxnOw9aNErYlCVkWpqmtQ+iyxWl2a54WaOVUaZ4FErakbVL
         jpag==
X-Forwarded-Encrypted: i=1; AJvYcCWmrwb5SCFYmeMgSXQBJaHQO8E1x4D/UAIASTq2VV6SojWjCFG8dtFMRBdBCs89a1rRlSiyTiJC+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoGCdj/HgYgumB7eIVHJ+IiAvkKVSC9Kg9tedCHXFpOfeqkJnE
	zC2kiZdRE8P9uQ6D1vGvlSzs/oWXj9S/7rdnyiBLwBFaTV9jRZFJD3O2mNeVYhoCrG8=
X-Gm-Gg: ASbGncsCDErUBZei74HQ3HN5ByhdohnLkcZyGuEHulAtJilAZ5/ArNskMoK0HjfOgS+
	3+PNrcFzPAWsHhU8ZGMSauhpLxEw5Ah8qScB1p2Iv+oLW6BacAObZh2PlCALS6Ya5SrXCA6NlDR
	yJ6ORkf/SOmjNuwAHrqKRwm1IzyLxTERf0+BMeGp6T+m5dxjMc/lU2FxWJRaqyaK9MXt9yRsI9a
	DDPR/AOyqmkzBn2LA/R38lOW9ydEVJOKSC8cvzN/n1HqaLORGSMtuhuOlH/4pPI7xrdr5CJ4Kxo
	wz976Xw6b4CDOwjdAXcL2lblWgoRsUaF3koNIZ1bA2GO+PCJuKnfxI6RvjM7e3QxWylJGyxy94G
	q5vd8t/RrGLBf2bVk7WPOtPU=
X-Google-Smtp-Source: AGHT+IGEtt9qokrYIwCBkc+z2ENEsej/ZkWbJWzYxY+oGKR8HNKxZPQ9IVWBqa931bZJIEP0R2uplA==
X-Received: by 2002:a05:600c:3145:b0:46c:d6ed:2311 with SMTP id 5b1f17b1804b1-46e329f9d06mr35802915e9.19.1758812612669;
        Thu, 25 Sep 2025 08:03:32 -0700 (PDT)
Received: from [10.10.156.189] ([213.174.118.18])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fac4a5e41sm3708299f8f.0.2025.09.25.08.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 08:03:31 -0700 (PDT)
Message-ID: <f5493b8a-634c-4fba-8fa4-a83c98f501d3@kernel.dk>
Date: Thu, 25 Sep 2025 09:03:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv3 1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
To: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org
Cc: csander@purestorage.com, ming.lei@redhat.com,
 Keith Busch <kbusch@kernel.org>
References: <20250924151210.619099-1-kbusch@meta.com>
 <20250924151210.619099-3-kbusch@meta.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250924151210.619099-3-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/24/25 9:12 AM, Keith Busch wrote:
> contiguous in the SQ ring, a 128b SQE cannot wrap the ring. For this
> case, a single NOP SQE should be posted with the SKIP_SUCCESS flag set.
> The kernel should simply ignore those.

I think this mirrors the CQE side too much - the kernel doesn't ignore
then, they get processed just like any other NOP that has SKIP_SUCCESS
set. They don't post a CQE, but that's not because they are ignored,
that's just the nature of a successful NOP w/SKIP_SUCCESS set.

> @@ -2179,6 +2179,14 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  	opcode = array_index_nospec(opcode, IORING_OP_LAST);
>  
>  	def = &io_issue_defs[opcode];
> +	if (def->is_128) {
> +		if (!(ctx->flags & IORING_SETUP_SQE_MIXED) || *left < 2 ||
> +		    (ctx->cached_sq_head & (ctx->sq_entries - 1)) == 0)
> +			return io_init_fail_req(req, -EINVAL);
> +		ctx->cached_sq_head++;
> +		(*left)--;
> +	}

This could do with a comment!

> @@ -582,9 +583,10 @@ static inline void io_req_queue_tw_complete(struct io_kiocb *req, s32 res)
>   * IORING_SETUP_SQE128 contexts allocate twice the normal SQE size for each
>   * slot.
>   */
> -static inline size_t uring_sqe_size(struct io_ring_ctx *ctx)
> +static inline size_t uring_sqe_size(struct io_kiocb *req)
>  {
> -	if (ctx->flags & IORING_SETUP_SQE128)
> +	if (req->ctx->flags & IORING_SETUP_SQE128 ||
> +	    req->opcode == IORING_OP_URING_CMD128)
>  		return 2 * sizeof(struct io_uring_sqe);
>  	return sizeof(struct io_uring_sqe);

This one really confused me, but then I grep'ed, and it's uring_cmd
specific. Should probably move this one to uring_cmd.c rather than have
it elsewhere.

> +int io_uring_cmd128_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	if (!(req->ctx->flags & IORING_SETUP_SQE_MIXED))
> +		return -EINVAL;
> +	return io_uring_cmd_prep(req, sqe);
> +}

Why isn't this just allowed for SQE128 as well? There should be no
reason to disallow explicitly 128b sqe commands in SQE128 mode, they
should work for any mode that supports 128b SQEs which is either
SQE_MIXED or SQE128?

-- 
Jens Axboe

