Return-Path: <io-uring+bounces-7994-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A75ABA0E5
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F6EE17F573
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 16:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 103C61D5CFB;
	Fri, 16 May 2025 16:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xas52OTs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A557261B
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747413756; cv=none; b=g5un6aN6XMSTsdWZ3sinTW6jpd+IJ8IphkEHphn1PXcs7Fsu/HSCvzMBtMKjbJQHmuEFeB3aEV2MP4+Opqq3QEGsc7X53V3u3TWH0qmSxbGFG6sXmUIHDEKQyb6caMIMuU436FV5C+n/YoB05DC3aK12jT0uK0a2ZeKX2ypXHLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747413756; c=relaxed/simple;
	bh=CkOnvZintGeeTzcaNpAG1Zjd2HHHuk66BP2BDQaCEH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IY7aNKiJ+RS/t/mNze82oU51MZhz7ZsDwH29EmwInCmu7jCB4WxN0JOPs7iqKLG5MXJUomil8Kbhv8QfJoDOfnJ8GMsUo2ywkabtkQyVUuFZtHCm7dxpRkEMMsUc40z96NyjowXYz8XzTAzuSnH7pA8P+0M6qy3ZXvDn8al1eq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xas52OTs; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ad4ffb005d8so391181666b.1
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 09:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747413752; x=1748018552; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JDNNBBMZRk4a4QzFSMH+Tpvmr9PnPc/SX6NbNufkqhM=;
        b=Xas52OTsGUeorjkpF2SorsMI5IrVtEWhDdx94VAE4z+csdlWCRLwIbB7eAzD7GgHyj
         hJjJEboq4NFXrodcaQlCl0i0p9Qv2KuWps9NR1x3lML5RAEq5ND3i+k2p1O+ZO+pSjsN
         wr9DOI0k7uI0z/Bfo5GkR83VgjEhfX+2969rqr8jQRebJBFLPDcJ869khqEeDqQcgjZA
         kMMb6gsBqOihsqbBIo8DWkzyPBUKE4IcPxWH9cI3VVj5B29KGIPKE9Mtm9ZC4Z/0MSkN
         xVhIpcV8GSHiTaI0QT9ILfclh4t5FOC7ixn0PUh5vsK311fJugCcF4ZVrmRt8FJwsoT6
         R5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747413752; x=1748018552;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JDNNBBMZRk4a4QzFSMH+Tpvmr9PnPc/SX6NbNufkqhM=;
        b=Zco+uGWqmxoMgGk2R1MVRyf0MRM6fuDoQ802C8rIirggpJ9PbGWVIp4FVGwOnDcg7D
         TCniJxgDdW+C3yffUBKEH59ZN026LcQslls/oKQCl6cvZIaTNlmTljRKjO3ZmlNcuIIg
         4BSMn00Z41kSggzGE/gb6x8YvfEcRCvAr2sSAW4lDtCvnZy4SsJqcHlSZ+7OLUVshDq8
         tb4womJWWrwOYuUR4hduHKbdDvd8g1EeN3+wTJVDsl81p3NFuYbA5F3gx1PDkBVU8/ct
         LRz5YoKL2ZTj8ST8OhYksvxqBxT0bY8tG73e38j5cv1kD5N5Jw8QMgXpcqqatL9Ycn3v
         5y/g==
X-Forwarded-Encrypted: i=1; AJvYcCXe+VsZWCh3V7k1ufymmxP1GK0AE3yDGQEMWNvJDa1Cz3QsENvvkyI1yxGzfbBZLNNyh6QLbvf/Kw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2Fjr9aC1HFpL1BHPuVHLjTiqNjTFqiAoqpCet+3JMh2feVFNq
	AbpsI0oHx5LzZqZi1lfyQFGLDCNEjKB6k7if+JuLCQIzruAvkFj5SSNcPI7SzA==
X-Gm-Gg: ASbGncsq6VSk/6qXP3WOOlBpiY/AW6ZwYmKHXYqfhT+x3VTGrE/LYAXX7E25O7sURZo
	+y9759miAXfKKrfPV4gGIYuPLm+TFKn+x0YOy6dYQEji73ZyMRxtbROMN6CN8bPTg6RV82bjKDy
	WZrqtREDii+p3fD1lzMjNWJt/aiHzUI3XCLMEh2c+abkKLzgPO3gV50JrgNr9UtcBvPQhJMJiq5
	fKQs8guXV/68kTu0qUbcaSdL1odC7S31y46HovfLVo3SBJx6KUZ8wqTWm4b2dNcHghufWk6H2qx
	y655/2pJMc6BXHHliX2s5TWArLWyAkCaKXCk2ziWIoWDv/NPuScBF0BsQjA=
X-Google-Smtp-Source: AGHT+IESH1Dee3Nr0dgfw6omyyy3PweUUCS6iMGuLsbTV7t4dVwkmjX3QG8PK6hzIQMmUzjMzDX0JQ==
X-Received: by 2002:a17:907:7f13:b0:ace:8003:6a6 with SMTP id a640c23a62f3a-ad52d441ff2mr408630566b.6.1747413752211;
        Fri, 16 May 2025 09:42:32 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d04af2asm182933966b.4.2025.05.16.09.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 09:42:31 -0700 (PDT)
Message-ID: <01275ac2-8d33-4f33-b216-f9d37e7c83af@gmail.com>
Date: Fri, 16 May 2025 17:43:48 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring: split alloc and add of overflow
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20250516161452.395927-1-axboe@kernel.dk>
 <20250516161452.395927-2-axboe@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250516161452.395927-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/25 17:08, Jens Axboe wrote:
> Add a new helper, io_alloc_ocqe(), that simply allocates and fills an
> overflow entry. Then it can get done outside of the locking section,
> and hence use more appropriate gfp_t allocation flags rather than always
> default to GFP_ATOMIC.
> 
> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>

I didn't suggest that. If anything, it complicates CQE posting
helpers when we should be moving in the opposite direction.

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/io_uring.c | 75 +++++++++++++++++++++++++++++----------------
>   1 file changed, 48 insertions(+), 27 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 9a9b8d35349b..2519fab303c4 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -718,20 +718,11 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)

...
>   	ctx->submit_state.cq_flush = true;
> @@ -1442,10 +1462,11 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   		    unlikely(!io_fill_cqe_req(ctx, req))) {
>   			if (ctx->lockless_cq) {
>   				spin_lock(&ctx->completion_lock);
> -				io_req_cqe_overflow(req);
> +				io_req_cqe_overflow(req, GFP_ATOMIC);
>   				spin_unlock(&ctx->completion_lock);
>   			} else {
> -				io_req_cqe_overflow(req);
> +				gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;

if (!ctx->lockless_cq)
	gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;

-- 
Pavel Begunkov


