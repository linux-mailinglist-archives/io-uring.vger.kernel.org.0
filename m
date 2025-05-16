Return-Path: <io-uring+bounces-8001-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AFB2ABA169
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 19:00:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C60771C03CD6
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 16:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D247243954;
	Fri, 16 May 2025 16:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jc3Gznlg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807C3214A60
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747414688; cv=none; b=CI4FjOY4fp0b6Tj7jC3LL4jie+MVXLn38rRYMXlYxVIodjx4tQowQJEwuElyDejneLfUAhM9tf2X008CSwvWWf5Ao07XyblHcCdi6Vde7Xbtu8Q/dzbvyBMiVNYViAVCJL4cLYtm5BN33Ct9ZFsHekrXm4Qjo487fqzsSLrynxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747414688; c=relaxed/simple;
	bh=GY637Y0wyQGGOgBBGthaVo1TavoK7NCVVw9PIDFhrog=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jAMqL9jR/fM5fyIW5bN5cr4lLW7kUj1lQZmA4BtTHpJ8A8LRWufAyAVokdXoktFUWDqI08Mfj7gjhLX90/HF8LFvWgGKe/8X1WTimYh11Op6r983bLk4uD5/AFXL/+e5Ujjn5awRw01p5Qv7Sea7HXH+20gE8dzuvgwM8bR5w78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jc3Gznlg; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3db87f6f106so5136775ab.1
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 09:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747414684; x=1748019484; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XLSrQL7B8XhL2qeojHn7fq9jVUFWsPm3E3IE51zn3Jw=;
        b=jc3Gznlgy0hdsXGKs9afV/OQEKg1lrx7TuB9DPycHx/wDq04wkBcor8s7+kkPTcgpw
         b0TymZPOWg/aFWFWX0Cw1Oeq+4w+SCGnvT5p8IV8aEDidzaK99lskTQeW4BlYd1HQvsJ
         kiCMofdREWMScWfJIQ3MMr7aNXhdFnYf68Y0+NsW92efOlOllnfJrc2nHgGorILNpnNY
         ilgpwm2RZbM324sE9fSt/wuxtU30Qb0N2Cjwztg28nvN4cDVMh15D3oTRNJ7NK92cSXk
         Lg7bxhEHD0ewg98PoZN/phtnjoNk4lPpXLUKeYhLPXbQ/2Pjac4+RLJVHVXcAwpdWi4A
         /G2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747414684; x=1748019484;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XLSrQL7B8XhL2qeojHn7fq9jVUFWsPm3E3IE51zn3Jw=;
        b=cA/gAPblROG7FKpL3cRr1J3fBkp1jw+1X7Rv5iTH1t3aWCD7GWgvz+Ihsz113ZqGaC
         Z3Gvn4a2+1q4Cscz+fswTxusSEQC21EWM7M6uGnE7hPJamQUD/Hs7p21iRzLhgMQj681
         LZSXmL/g9B7RT0TrNfi/17myfNxaMeIFP8czm8FI42C4f2It7E2tOYly7T32maIQLp3O
         iWx19XdKQ/Ho38eGfzrLg+mvW3DJbKQ5cyHfqdR+YDahWFyJuPa76aupo4ozzPYOC1Uh
         Dq69aVy1z3F0B1lko1ZWZ7ygFQ0e49SnPZ8UfKO/tw3rVb0p2ywGo47qtF7BQUn4ATep
         eSeQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1unn1pK/AKR5TxwfibABfugMsuEjOGK5bMyGIkMUGTOm42+K1m8TO5RZEi2mwcMls7BkFioT1tw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyqQqWwr759dsBXDk8PHN6WkChTioEtHPvK5Wxd4FqmOesXtML1
	jHvZoVJoO7xsIp0PMBfbXO6k9MzkWNiMJBuKvSA1/MQoXNowDRiYkQLhR4LJG589kHoCWfkPuPg
	WL6z9
X-Gm-Gg: ASbGncsvTNVOSYOPOfaxZKFX0SQJtKB83B6CLjwIR6hoQrQEYTYrrTmupNd/hFNgYax
	CQQByM/yDrt2hOUq5A9pS8IjeY1Jnwo/7L2NcK+qMVCjigosKpEWEUCKMEG9lSn3p7NWS7SC/rP
	4t8ThfUm0Zx+Robwfr/qdtI4UzOj7vapIFVUcnfKKr0Nk5pEGtDs+Yj2Ay4UDDubVOcIwXrzPjN
	9kstizNyzGgy9BMBfCLAUcc+jiafvm7GrOiK683EX1NQr/ZWB0RwG1hH2nqlUmjrgEKtWBuMQJh
	WXDX0dYbE1pw2pC/Xl5RuJtvWpguGIeFgx31PhssMfzHSbk=
X-Google-Smtp-Source: AGHT+IGEvBICeyQsU/ED6NvtCwG3sDIM4VdvubyXEQM5jwQuKaX95dvEqKLDQbOG17sO+Okci1UrsQ==
X-Received: by 2002:a05:6e02:164b:b0:3d9:659d:86de with SMTP id e9e14a558f8ab-3db84332185mr46527705ab.20.1747414673138;
        Fri, 16 May 2025 09:57:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1ad9sm486417173.53.2025.05.16.09.57.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 09:57:52 -0700 (PDT)
Message-ID: <f0d9fb95-5539-4a5d-972f-6904c1b9c2db@kernel.dk>
Date: Fri, 16 May 2025 10:57:51 -0600
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
 <036598fc-cc22-4e37-a83c-8378ef630f55@kernel.dk>
 <f8f99262-2e11-4204-ad18-fabe836881b6@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f8f99262-2e11-4204-ad18-fabe836881b6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/16/25 10:58 AM, Pavel Begunkov wrote:
> On 5/16/25 17:44, Jens Axboe wrote:
>> On 5/16/25 10:43 AM, Pavel Begunkov wrote:
>>> On 5/16/25 17:08, Jens Axboe wrote:
>>>> Add a new helper, io_alloc_ocqe(), that simply allocates and fills an
>>>> overflow entry. Then it can get done outside of the locking section,
>>>> and hence use more appropriate gfp_t allocation flags rather than always
>>>> default to GFP_ATOMIC.
>>>>
>>>> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
>>>
>>> I didn't suggest that. If anything, it complicates CQE posting
>>> helpers when we should be moving in the opposite direction.
>>
>> I'll kill the attribution then - it's not meant to mean the
>> approach, but the concept of being able to use GFP_KERNEL
>> when we can.
> 
> Sure, but that will be blurred by time, while the patch IMHO is
> making it worse and should never see the light.

Well, you're certainly cheerful today.

-- 
Jens Axboe


