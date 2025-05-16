Return-Path: <io-uring+bounces-7995-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21F69ABA0F6
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:44:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F0581C01496
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 16:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF6931D63F8;
	Fri, 16 May 2025 16:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cjf98WZc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4AA1632DF
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747413876; cv=none; b=rlWIKwXYEStJm+iAKc57VY8Kwanf9CHDoJzxEt7/Nxf/4uTgaNybgtvp0c/2wEUazV1TD4WglxWqD1QHF4tt+Fvzf2HZorI8HqhT84M4xrLEelXOMYg9OHWBgEV3ylfsgnlHukt+RH1ee/y7YMnZvhpNNMBIZnL0QbGKDWl38SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747413876; c=relaxed/simple;
	bh=SNsL+ybWVVpK7GDM6Nv56PugqoeZk5LpiWG+GY1l/B0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GBcr8kCjyhb8ygGgI2opYhK4mZv8mZFHR/95GP/fNBNFGIuhGq9rOjUzscDwSsknNidVWJ1qlyJlhKZFPRJSY9CfPSfTzUm33qXAHwTnlRS+pHn36qslWDFf69XYu476R+oFyC3gGJkIDYg6q2TSHtj9gcMrEWYMu9qBtTZKoIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cjf98WZc; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3d80bbf3aefso5849835ab.1
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 09:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747413873; x=1748018673; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lutEzDUM0/jdOlzToGPfMp1DayKbezNHaYscqO5IN+Q=;
        b=cjf98WZcFaUZI0nj9N4pJkeCUJ1ZnX8Uo2S3NDR7MrsQfCxm6Sy5+URlNFxTlqSjcd
         8iGJg2lUiIccWh92KZceltrflRl15C7gmAcqlPanJLRa3a3DpC7H91/7kWNy77xneUq/
         r17Da8tWqVnb1EAQFIQy7f/GayixF3BXZVRsydKpG+1IQKfuezd0HbqzyEZ09f3IjiV1
         wm+CTowizdRUVWKs8nHaVgVcpSm5a9d6qomdLYa6/KycWPwLWzj5Ae230idzU5FQhthV
         wG7OKgxkK1XmOB5/k4BdO15uXNttA8V1eae2cpPYxgfWuaBqKRtuCCDqQMcAxjMjNL+i
         f2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747413873; x=1748018673;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lutEzDUM0/jdOlzToGPfMp1DayKbezNHaYscqO5IN+Q=;
        b=RJMPzpbecol/CSPLuRaA3t2RYj0G+W9+WyPjm0cO5TrITlGpDhh2xQ9QFQ2IsHIFTb
         7BwhKmzNlSEx655ZKwvQVMKt0s3n4Z5yFuhqk++qxQ18mPSm/Wu9Gg0ZT+48EFxuOvDT
         lByMRQQg93b751Vz3mERsLJW47zXpl3RhlwLRAJe47f3bNlFO1L4Ja6TBxxoZ34dDm9f
         jN8pVYJpcguWTHuI22lhymTb/KHH58VUodLSFKSpNsPjjeYXvkFCVPnoGaMLRhFGnY5A
         Jt9ZB7joAqtdu79Wkd6cbUvmw/2oPb6ZkdRpxdfhxef+TePuCdSGM7NaH3AwmozBvpJ7
         op4w==
X-Forwarded-Encrypted: i=1; AJvYcCVtuX2VEdj3Iybd0yZOnvBz1zOEjlRoSLjaHVUbKCAtc89aOVnVwsjo4YNICOBst7Q2vf1XUplsDg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+IOlQ/1cJ4s4RQ7n5YVacjk+ig96frPK4XIb9q1QlBVa/NeTf
	ChZB4Nw+D7XCnXWz3prGrou+o/AnsjsWGUN7GotZwZ604nsWDdYvObbkgeI5HVeC+N8=
X-Gm-Gg: ASbGncuajP9iBzkibDWrUZoUCEjmHLWkCnBa/JFGm0VMuFa0prL6tnEEM6j0msEcUPx
	7TaxcCn4/vb2V5s8OmUykx0cZ4AqSp5zkpi5MMYcF4XM9hptN6K8+qAygbU06Wo3H0FoDB72Gwk
	ERPWOAveIy5nM0nI+3m2EsH7iQRnMLfnnufXYXLnQPH/84nFL0ejr+DOPUrigNnCxVtyv1LN1X1
	W0BiAss0BjjdMBOHIN8jHnRN9BS/0oSZoug/+mIt3e0ObkgLrfq7v1BDDgSic32pKmrKpcd48Bj
	uTbmm/qnGg7hfof0RGBwsMleZJJJGUYgXrbhap1+YIA/DGXH2IItXwJDKQ==
X-Google-Smtp-Source: AGHT+IHAF2Jp/Xv+W2JzrPC1OoKChpB70VCWJDbQOMIVunaPgxrv37Ny36yv0c9tvNh1HyIzzdqemg==
X-Received: by 2002:a92:cda6:0:b0:3d8:1d2d:60b0 with SMTP id e9e14a558f8ab-3db842aae78mr52344865ab.5.1747413872737;
        Fri, 16 May 2025 09:44:32 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3d67a9sm464463173.64.2025.05.16.09.44.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 09:44:32 -0700 (PDT)
Message-ID: <036598fc-cc22-4e37-a83c-8378ef630f55@kernel.dk>
Date: Fri, 16 May 2025 10:44:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring: split alloc and add of overflow
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20250516161452.395927-1-axboe@kernel.dk>
 <20250516161452.395927-2-axboe@kernel.dk>
 <01275ac2-8d33-4f33-b216-f9d37e7c83af@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <01275ac2-8d33-4f33-b216-f9d37e7c83af@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/16/25 10:43 AM, Pavel Begunkov wrote:
> On 5/16/25 17:08, Jens Axboe wrote:
>> Add a new helper, io_alloc_ocqe(), that simply allocates and fills an
>> overflow entry. Then it can get done outside of the locking section,
>> and hence use more appropriate gfp_t allocation flags rather than always
>> default to GFP_ATOMIC.
>>
>> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> I didn't suggest that. If anything, it complicates CQE posting
> helpers when we should be moving in the opposite direction.

I'll kill the attribution then - it's not meant to mean the
approach, but the concept of being able to use GFP_KERNEL
when we can.

>> @@ -1442,10 +1462,11 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>>               unlikely(!io_fill_cqe_req(ctx, req))) {
>>               if (ctx->lockless_cq) {
>>                   spin_lock(&ctx->completion_lock);
>> -                io_req_cqe_overflow(req);
>> +                io_req_cqe_overflow(req, GFP_ATOMIC);
>>                   spin_unlock(&ctx->completion_lock);
>>               } else {
>> -                io_req_cqe_overflow(req);
>> +                gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;
> 
> if (!ctx->lockless_cq)
>     gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;
> 

Yeah see other reply to Caleb. I'll just slurp in your patch 1/4 as this
makes it simpler.

-- 
Jens Axboe

