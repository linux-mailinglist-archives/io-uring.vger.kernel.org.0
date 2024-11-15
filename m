Return-Path: <io-uring+bounces-4718-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E719CF16D
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 17:23:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E780B3EC3F
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 15:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06941D5148;
	Fri, 15 Nov 2024 15:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TC9LE44L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2FA1C07EE
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 15:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731685259; cv=none; b=X+6FvZnp8vJm+2U5Vm2dN/NRJwKk2rkKT9/jYW4PbMMatNDCD7IYBgHQw0guRykq9pEUKHbfL+pXKdKtInuz4lHyfXU94udrx+uhRMV9wBRkoZNPw4ebwKBs6aumHn4r1BQBeYDqquPgEXD759RascqTtVQV6S5nerpMdLGFRmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731685259; c=relaxed/simple;
	bh=jdr8qNxy+Jo1gsIHbtkxZqlHxWm+kUlA4DWc5Z9WKtw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CqJ8hXyqL5eXJr6pqFMcH37/N6OUyN93FNAe14fLqpEgY5/ywLUk/6sedhagT2Lulb2aJ6RHrso/T8mH/mF6TTopkCwmHH2m2PVTLROkWaLSUr19blutTC8TDMyhAgDoP3FNCoAvhwfKxCv9huk98W2/6zHTUOXgMc+pLDvks68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TC9LE44L; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3e602994635so536063b6e.0
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 07:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731685256; x=1732290056; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qoZnHCDbvEhSS1c5SRWBNLiOwRUEY61DZ2aXp4JDEYc=;
        b=TC9LE44LpmuaBUF2ni7msJ+oK51W1D83PnHgzYUlflAY+cERqgR0vE3LBLWk9TxC7a
         p1jISsurUq6S59DUx37zcfpMiJCv0awylLruPYU+YwApwtBUxVxZlHm1bI/POjy+BFtn
         lqh86KHsj+bVsS2fy/299PTkWQB9HX+9Ha/fgfEhvLbFblmNostVlEjJU99Lbx3adXJ/
         rznhtFl0LPcslGWEQYTRdzLVPEzO2z0r3kxqHWvZUO87CGUO8Jp5zg4tjqakkUGRNgu2
         avNFass9dSjg0z0AhbOJfrmY5zTcAI8aw8srkccowzVXjare5LgxZaCh3lNhUyep4inO
         JgFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731685256; x=1732290056;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qoZnHCDbvEhSS1c5SRWBNLiOwRUEY61DZ2aXp4JDEYc=;
        b=q3oNOyHbNNzs34MsaFZUoXUcMvVLX+NqezGmzzqYzYibbQ0emLVq2zXZpdC/pG9zZo
         LlVeI8crRlPXN7d4QAKMhl5UXbchCkv/aY6v25rvFPWuf3ejQR4DYfaH/e3zXMPvSS5F
         l1uA+d8H5tvyJ0pjNaBebXQGUdTAqrRDRNtmTEjBa4Q+svg20kdGLp5VHeB2BMpsBLei
         Vu0YSNHY766hOnMaWgmhnLn8MhwxA8PRIcIPOoneECeWpDKdRiGyxCtvtFjmuZaPCgX7
         OJPOMgwJlFaynIgE1gwLfzbm0u6ZS7bqP7oSMT0j+t/g8Ul0cxto07+BJTK2fq8fWxSq
         /m7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXNg91WxAhT1nHhvSbsi4lCzkcteDnpIlLfdOIBlCc2NHD1iJ1lUyLOoPihHmHSSWPrGW5YpWZoPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzpBaima9lwMghh00l8mrZUoKSHaJKQrHPX2dnBebtt2cEdjRr5
	HBMeLix0uEl2IIWBhpLCdogmeld96ANeB9c1Vchg9rg7NKJD1gROth/LBd7XGQE=
X-Google-Smtp-Source: AGHT+IFdUS8uN49tDNf746ur2SPDst9sm3KOAJaU1AK84+5cj7rnDzwIuOtF3souY+5wecSwvnATWA==
X-Received: by 2002:a05:6870:e38a:b0:288:a00e:92dc with SMTP id 586e51a60fabf-2962deeacdamr3161996fac.2.1731685256497;
        Fri, 15 Nov 2024 07:40:56 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29610949b12sm1516348fac.26.2024.11.15.07.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 07:40:55 -0800 (PST)
Message-ID: <7b1ed2bb-dc06-41ea-ba48-85c25d085dd8@kernel.dk>
Date: Fri, 15 Nov 2024 08:40:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] test: add test cases for hybrid iopoll
To: hexue <xue01.he@samsung.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <3aada5a2-074a-45e8-882c-0302cae4c41b@kernel.dk>
 <CGME20241115033450epcas5p10bdbbfa584b483d8822535d43da868d2@epcas5p1.samsung.com>
 <20241115033445.742464-1-xue01.he@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241115033445.742464-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/14/24 8:34 PM, hexue wrote:
>> The kernel should already do this, no point duplicating it in liburing.
>>
>> The test bits look much better now, way simpler. I'll just need to
>> double check that they handle EINVAL on setup properly, and EOPNOTSUPP
>> at completion time will turn off further testing of it. Did you run it
>> on configurations where hybrid io polling will both fail at setup time,
>> and at runtime (eg the latter where the kernel supports it, but the
>> device/fs does not)?
> 
> Yes, I have run both of these error configurations. The running cases are: 
> hybrid poll without IORING_SETUP_IOPOLL and device with incorrect queue
> configuration, EINVAL and EOPNOTSUPP are both identified.

I figured that was the case, as the existing test case should already
cover both of those cases. I'll get this applied once you send the
updated version.

-- 
Jens Axboe

