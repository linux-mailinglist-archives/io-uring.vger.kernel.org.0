Return-Path: <io-uring+bounces-805-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 00A1486D94B
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 02:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A92B01F225DD
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 01:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8FE2B9C1;
	Fri,  1 Mar 2024 01:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WM/UZYpU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F04639FC0
	for <io-uring@vger.kernel.org>; Fri,  1 Mar 2024 01:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709258364; cv=none; b=ZBncon/9y36w3en01Xxvb+U6awt9EssFQcNoSXKX/eKD0lkGUnH9AwoT+9YFdbPBIaGkxxF55+oKVWamdzuaGWs8WnsLuN2jc/aDpXdb9SpB8AUMmw5iLH9YMiXP98Br544MIu8W8HC8sdgbheqGawtzkFME39LU4GKI2Z3eRuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709258364; c=relaxed/simple;
	bh=Kprs1lGvGWqgikapfmP2IDY6HbuwA3HEH6azJRjXw8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c3CDyI8lcX5bqGI0k430I7yB5Ytu+9bbY76yeTS6MgOVUv4x0f7+S1SHeyTTforMaoQgNBmUgLPpob+bO6OIjtrqaKdmNpvZOGiIP94lQ+pbUHj2LXRMWw0zCylJHgJIntZanh+3jhrAkorLus0TAMZn1G/p5bUsMt1J/juhS5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WM/UZYpU; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-33d61e39912so754712f8f.3
        for <io-uring@vger.kernel.org>; Thu, 29 Feb 2024 17:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709258361; x=1709863161; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nnOhiO+GO0PJGhbie0QmK+8guXSKyET/fDFikHe9Gkw=;
        b=WM/UZYpUL+yHNZMHeFcgrDnPqZWsr7ybdHX3AHIvYwGTk8b5FABGfXSUxIQehEzNev
         Irijq5eM9RCMoMC7BC3BKyxkhkY0A20xpJ+9dg4XxVIMGVV/r0s4n01vYtJydFE13tKZ
         ELrOclC5/dP/xJJGWIJsuFEu+faLUCXYwf4+OxbwXHc28nHCkT5LKjROpuotdGLLsJ9r
         QtiYf3YaqsO8JX4sMio67CNkG49F8OVfriRX4DWt2CYFJjme5AnNvW/kfALrfamZNzi5
         egLhoBhEkbqCj1KQKKkxMBBmHsZ8oDTHCyN1Vo/ww7Bnjst/n5If2qDznjBR3wpbngPC
         pPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709258361; x=1709863161;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nnOhiO+GO0PJGhbie0QmK+8guXSKyET/fDFikHe9Gkw=;
        b=pIQVE0GRHuGWyCFMeSMYJWGT0XeWhBOYAyFbgEl8Pduv+XjFaqBnSxgHGzrIttOh6m
         HjYIFKJNoqdS3gRCN9qD424MBqZqeMD8x7O7s+fum2d1W6woKW3m/YnmgI9ecPZEhLCh
         2FzfOPh9/i8bSY+6yBmL22SBp5FY5wVcgGU5pY2gTso1O9kKxoIYoJAcBcK6ccZXm5LQ
         VSLiQZYZ4UdGRneizueby9ng/smEQwmdypt+622g4YbrtPblkMjgoXv8/KYlhuzG6UIy
         beKZ07Vph9kxy5pRupOUkUweWnNwr+A5iROP+Tja8Xnq6gDnP7aoNxMoid0/brr9/B9h
         l0PQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+9bGtmtTzNBrV27QtMNmt3xVQZDoCpJ2n53XZ5TTGzkVPALUZurOv8/6wDMKZwCYTPxgeBlL/7Z4Yzxjk2z+zBAfPjEeTwb4=
X-Gm-Message-State: AOJu0Yzfn9nm9ckSpKLq2VDzQFb/vM0IneessdjmrRJOrneYjx3RgP2F
	Cyqq7mGJyh9+TFC1m3R/lgfBbsKq9C+fm5ElvtYO7FefceFO9E5jrvu+TeAU
X-Google-Smtp-Source: AGHT+IFrTp/lcXI60xMFlPbZ90t1c30b9siFfkduYWO3Ov5CZTIGyXqd9R/Bq5NNeipqrd7r0lPzIA==
X-Received: by 2002:a5d:6e48:0:b0:33d:7e99:babc with SMTP id j8-20020a5d6e48000000b0033d7e99babcmr163407wrz.50.1709258361154;
        Thu, 29 Feb 2024 17:59:21 -0800 (PST)
Received: from [192.168.8.100] ([148.252.140.212])
        by smtp.gmail.com with ESMTPSA id q13-20020adfcb8d000000b0033ce06c303csm3150845wrh.40.2024.02.29.17.59.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 17:59:20 -0800 (PST)
Message-ID: <f5adf30e-e35c-4165-9266-bda42fb5d599@gmail.com>
Date: Fri, 1 Mar 2024 01:57:34 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: get rid of intermediate aux cqe caches
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <935d517f0e71218bfc1d40352a4754abb610176d.1709224453.git.asml.silence@gmail.com>
 <076c3569-1403-4ea2-b62a-cf7426c6d097@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <076c3569-1403-4ea2-b62a-cf7426c6d097@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/29/24 18:03, David Wei wrote:
> On 2024-02-29 16:36, Pavel Begunkov wrote:
>> With defer taskrun we store aux cqes into a cache array and then flush
>> into the CQ, and we also maintain the ordering so aux cqes are flushed
>> before request completions. Why do we need the cache instead of pushing
>> them directly? We acutally don't, so let's kill it.
>>
>> One nuance is synchronisation -- the path we touch here is only for
>> DEFER_TASKRUN and guaranteed to be executed in the task context, and
>> all cqe posting is serialised by that. We also don't need locks because
>> of that, see __io_cq_lock().
> 
> Overall the change looks good to me. Are there any tests that check
> corner cases for multishot recv() CQE ordering?

In short, recv-multishot.c:test_enobuf() should do

And it's pretty safe, we want aux cqes first -- we get them
first. They're posted immediately, and it's hard to imagine
it to be any earlier, i.e. posting before anyone even asked
to post them.

-- 
Pavel Begunkov

