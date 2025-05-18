Return-Path: <io-uring+bounces-8046-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 736B1ABACF1
	for <lists+io-uring@lfdr.de>; Sun, 18 May 2025 02:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85276189B819
	for <lists+io-uring@lfdr.de>; Sun, 18 May 2025 00:49:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35A311CBA;
	Sun, 18 May 2025 00:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Zx+3/8Lu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5C75C96
	for <io-uring@vger.kernel.org>; Sun, 18 May 2025 00:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747529331; cv=none; b=rSKgns6tr/zxn8QkTbGnIk+qTeu6ijquHOJYwBYSkGW4SKOYtibHXmsr27bj1twvfNJO2Unikl6eOHamnSOK68OMn3+vBbXQBXNNmyYaUEyxK7/NbDic4vQmtlNQQ+4Pzz0zpiOSN0uBTTLOcEvfb7dSujYNIIDBB1lSiIBsi94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747529331; c=relaxed/simple;
	bh=/U6EtA/7jDkpYQRe55mZ9bVWU1h+6VzzTl0MQs4os0c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oIq4wHGuaKlfR/La+Abgwe+wmNV2GrMv4BG1Zof+C9BU7Ky+twBaJ2UivfqgPFKlkq2jXS8jeiUhlOQUzq/sw9BfjbmH8VVfmOgcRfCecIvU8sGS7eNfKIwKNy4BaQs2c6ulTxbDMvZF5RuZ5xuliMFiU06UNWdeU9BwYsT7q+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Zx+3/8Lu; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d8020ba858so34237795ab.0
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 17:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747529326; x=1748134126; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CCooPz6+Um8FA5m4ui6m/gkR3sbwyvx6veN1ue5ns3A=;
        b=Zx+3/8LuoKTrebAdYgCsocFDFZVEYaqbZ7ujQ5LyKoVdu5NpM+odfGAUKBiltqjdTS
         6cmAXMURkgYqGIgwgZVhuE8bWCDJZrI1b0a0/EotUACRXMv2/ZEayYreWGrc0k6WRwS4
         fqKvY/YTw82NsW9OmInKJFXMixcgzgnOm8QI4OosdkscMgzdatHHMLJNffsjdxm19S2F
         MAEuYobsXf9N8bwe6KX3eklNpo3Cs/3yG86M73Knw6tOmghlnB5vIB/NocZqoLfE310L
         dppPVmn7CPIvrOY+QOlWnq9By5JvslvJI0+i9LfcP34OHwrMFBAMl8sidDSgw4uhhrWr
         KG/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747529326; x=1748134126;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CCooPz6+Um8FA5m4ui6m/gkR3sbwyvx6veN1ue5ns3A=;
        b=FPORk2DHI0Efcvnawl+oYqRkBpTdDV5qQSiorCRR4pTDXTh/q1+VXT+VBuhVVyNPS7
         UvT0J/3u4hg1fvaABSViEPyI3p6QBAAiVM4iWorbIr6HKWA1PbX8jf3BkgXDbQjWLg2+
         cf/M77//ad89g/ovGepRgKzOp+9RGlNdP44rnOGIE6GaNnR7wFutDJC0A46AFF/L7NYR
         ZXORJxsahzxVQBKLoyc3WEDOwpXGB4oKQv3eLPsjm0UpfdgQyaiwU+3eeexkr9UQKKh6
         28SJs0rkQ8dCjQstV+N78KJ6UdVogwUHAMuiWZiKKMF5P7IynlHphrvh5+WNM/B9g+q3
         +x5g==
X-Gm-Message-State: AOJu0YyNvh/ZFukk7LsnK5nb2fx+d4G4c7HzObNQegMHwFw8J1l6nmTU
	ven7GndafTRufAjBA/oWCrevZjuAbzZ4AzNkNV4+1bIEPxg31Yu03Tg9tcf6YAA3g2ZcL6SjWSy
	z+Uhh
X-Gm-Gg: ASbGncse+IqRFcn4hmhIqjg3qvygKxFg4Iu5wKzv3hpyq4LoIXkQKmWiNyOl49AYOJ2
	XCzSqqNJTXdVFtU0y/AkJyiF23cDP2mrwxtw57VpXTzjMcvBMdH7+NtgMQCvTYe1YpTYVEvw/4L
	jFNZspvhzaHMJ2YoA4mSnjmKMJI0B19kBi31HPF8WP8C/pRIq58p3RJYnw0mNvddQ5A+SHuTM64
	2+cdgDpGDiiB2hrr/roTbF3pHG9dhU37x8jFkTTjQVFGCZf4G8RAeXQRVi3njty5d9iJavOsk3c
	Mm250G+AHkmwofEpTMr3HknlCTxwsEwolUdXyA8GaVK8thL8e56DQmcYNrY=
X-Google-Smtp-Source: AGHT+IH6vt99AFwIuin8M9zdDtfY+HTc13xbwkUciVB1LZ3SfUz/31RV5FmRiUHWe60FqL7gpYeDDQ==
X-Received: by 2002:a05:6e02:351d:b0:3d9:6cb6:fa58 with SMTP id e9e14a558f8ab-3db84323912mr84252965ab.17.1747529326404;
        Sat, 17 May 2025 17:48:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3d6775sm1074521173.65.2025.05.17.17.48.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 May 2025 17:48:45 -0700 (PDT)
Message-ID: <94b773a8-6232-419c-821e-9fc18e545a60@kernel.dk>
Date: Sat, 17 May 2025 18:48:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] io_uring: split alloc and add of overflow
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
References: <20250517114938.533378-1-axboe@kernel.dk>
 <20250517114938.533378-3-axboe@kernel.dk>
 <CADUfDZqC5M8vH0PJ9Pqc-oesznP=OX0BN2sK9DdosHGhmV-VYg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZqC5M8vH0PJ9Pqc-oesznP=OX0BN2sK9DdosHGhmV-VYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/17/25 5:30 PM, Caleb Sander Mateos wrote:
>> @@ -1425,20 +1441,19 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>>                  */
>>                 if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
>>                     unlikely(!io_fill_cqe_req(ctx, req))) {
>> +                       gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;
>> +                       struct io_overflow_cqe *ocqe;
>> +
>> +                       ocqe = io_alloc_ocqe(ctx, req->cqe.user_data, req->cqe.res,
>> +                                            req->cqe.flags, req->big_cqe.extra1,
>> +                                            req->big_cqe.extra2, gfp);
>>                         if (ctx->lockless_cq) {
>>                                 spin_lock(&ctx->completion_lock);
>> -                               io_cqring_event_overflow(req->ctx, req->cqe.user_data,
>> -                                                       req->cqe.res, req->cqe.flags,
>> -                                                       req->big_cqe.extra1,
>> -                                                       req->big_cqe.extra2);
>> +                               io_cqring_add_overflow(ctx, ocqe);
>>                                 spin_unlock(&ctx->completion_lock);
>>                         } else {
>> -                               io_cqring_event_overflow(req->ctx, req->cqe.user_data,
>> -                                                       req->cqe.res, req->cqe.flags,
>> -                                                       req->big_cqe.extra1,
>> -                                                       req->big_cqe.extra2);
>> +                               io_cqring_add_overflow(ctx, ocqe);
>>                         }
>> -
>>                         memset(&req->big_cqe, 0, sizeof(req->big_cqe));
> 
> Stray whitespace change. Either drop it or move it to the previous
> patch which added the blank line?

Thanks, I'll drop it here, patch 4/5 kills it anyway with removing the
memset.

-- 
Jens Axboe

