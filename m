Return-Path: <io-uring+bounces-998-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE2D87D743
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 00:14:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C6AF1F22B3B
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 23:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D59E5A0F2;
	Fri, 15 Mar 2024 23:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bQsfCa5V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B5C59B6C
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 23:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710544456; cv=none; b=ktEKeW3Ayp0SoPj5CL7zK3gE0VhezP/T+2//ylJxyH1w+8HFrkmZ6OEn9ER10PfCppJnM56uRyE2e2uV5D7FCL2rGMZCtXetVFHKC/OxP36nOp6gCp3rrQQn/CwvDuFcMo0SEPXp+vcScu2PEm8NcYLFKAZdfrjbHoK4XSA1ziU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710544456; c=relaxed/simple;
	bh=rKWB3W667nrfVyIAsPejvSbjFoQw4ecdThvbSJlCvhc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=UhjhHIzvHEBEfMQI8LgRX6MMHN6U2U7dsY9282LiedPot5OP4yyRvnv59f+KAzrTDPWXkHBQ5MbR5gHUPKKNQKcxN35Ccho/d7VGXgPhpxWLzp0kGGpCoGLTfRuoWKNhrj5W9uePktDwP6fo3T2boXCdnLHUJdDKSpaeGdVbTPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bQsfCa5V; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-33e899ce9e3so2024394f8f.1
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 16:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710544453; x=1711149253; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bWj3YVJz+JrnqznQgcHNkVm2yWxLncJRRbmvIqZrEPs=;
        b=bQsfCa5VpYz5C+QV7d6McrqsQGXC+55tLY/4wo4smVdeuVaqtTpNBBvZ2iynwOMaW8
         HyQqaNQ9LEbtaYAVPCs63qadedDv39KSahmiS2+8WglAGsOaePndd3jRsZMi8bV1AN6+
         rHoBfUTVVGxi8dGjx1DkN6XRh2vLJ6IDjzyS8fR8sYZSd8c6ApQIZ/BFViXgkTUAk8SE
         qRRerMQ1DTNMB8nCrEk9AA+yeG9x4vEW5SxJ/GWQa9R/uhydeA91kshTsqfh2nHoe13g
         1sG++FlqJH6+U5RPdzx26O/nQUeDqXg6j/pcDxWXNjiCeK/A93dnaSnDa9npr9JRL963
         b6mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710544453; x=1711149253;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bWj3YVJz+JrnqznQgcHNkVm2yWxLncJRRbmvIqZrEPs=;
        b=YfuMXB55rZ45mE+RzR7erDtpq2ZkNB+Q7Dtu0kXvq4WZXVlkpDStsgGTngVVemBwK1
         BRACCd458jC9JL2R1AqLWosSbyf6jwndlsFKStYiyk2pUBRSMEgReVwsVqLnxz1UJUl9
         fGWi3ppFX80JISzRxI6bTJUGfSX0hfRXSZ8x8Vr4GbEv9tJMQVUu33lT/FNSSgAbITG9
         gJpXi4Ll31Ua2EkGlggvsyD2kq9hor1lnKQ5Japi4U9x6B5ySS9+bLlK8yVTxDGWhqEe
         Z3/D8LXVNmeswB4e6rT/DwRa9AfsB8HjbjZgEIR/r/66kEX2cNdW1tAGSOuZp5RBintf
         qvFw==
X-Forwarded-Encrypted: i=1; AJvYcCWBxsLp87kWP4+OZ09jBFxe6rCeDJp/5c2gWnsmBMtSffZjzeSCx4NzVOI67z0CLfNBhoq9GvARQCxjNp6PNC0a5DiKDltBj40=
X-Gm-Message-State: AOJu0YwT9ZcpdKzzDuA3Rn/Kf0cRFnv3ryViUcnQhFRbU/7KBwaGyeac
	DiEyC98/zdRckPEkuqSnk47F6OyNHixHa/q5bju+m2duqUyeF4U1vaofOKiX
X-Google-Smtp-Source: AGHT+IFf0ihPsmntOKskrnzlmmRTwlsi74v3birfsFlF2Kmxi+0N+O1l3VUl1HkJvzbAVh0mTObOlA==
X-Received: by 2002:adf:ab19:0:b0:33e:c410:a1cd with SMTP id q25-20020adfab19000000b0033ec410a1cdmr4398669wrc.69.1710544452563;
        Fri, 15 Mar 2024 16:14:12 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id t17-20020a5d49d1000000b0033ec91c9eadsm4176986wrs.53.2024.03.15.16.14.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 16:14:12 -0700 (PDT)
Message-ID: <cef96955-f7bc-4a0f-b3aa-befb338ca84d@gmail.com>
Date: Fri, 15 Mar 2024 23:13:04 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: ensure async prep handlers always
 initialize ->done_io
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <472ec1d4-f928-4a52-8a93-7ccc1af4f362@kernel.dk>
 <0ec91000-43f8-477e-9b61-f0a2f531e7d5@gmail.com>
In-Reply-To: <0ec91000-43f8-477e-9b61-f0a2f531e7d5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/15/24 23:09, Pavel Begunkov wrote:
> On 3/15/24 22:48, Jens Axboe wrote:
>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>> async handlers. But if we then fail setting it up and want to post
>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>> potential errors, but we need to cover the async setup too.
> 
> You can hit io_req_defer_failed() { opdef->fail(); }
> off of an early submission failure path where def->prep has
> not yet been called, I don't think the patch will fix the
> problem.
> 
> ->fail() handlers are fragile, maybe we should skip them
> if def->prep() wasn't called. Not even compile tested:
> 
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 846d67a9c72e..56eed1490571 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -993,7 +993,7 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
> 
>       req_set_fail(req);
>       io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
> -    if (def->fail)
> +    if ((req->flags & REQ_F_EARLY_FAIL) && def->fail)

it rather should've been

!(req->flags & REQ_F_EARLY_FAIL)


>           def->fail(req);
>       io_req_complete_defer(req);
>   }
> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>           }
>           req->flags |= REQ_F_CREDS;
>       }
> -
> -    return def->prep(req, sqe);
> +    return 0;
>   }
> 
>   static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>       int ret;
> 
>       ret = io_init_req(ctx, req, sqe);
> -    if (unlikely(ret))
> +    if (unlikely(ret)) {
> +fail:
> +        req->flags |= REQ_F_EARLY_FAIL;
>           return io_submit_fail_init(sqe, req, ret);
> +    }
> +
> +    ret = def->prep(req, sqe);
> +    if (unlikely(ret))
> +        goto fail;
> 
>       trace_io_uring_submit_req(req);
> 

-- 
Pavel Begunkov

