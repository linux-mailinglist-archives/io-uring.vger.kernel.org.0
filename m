Return-Path: <io-uring+bounces-2752-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80667950C61
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 20:35:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B28CD1C21D5E
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 18:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D821A38D7;
	Tue, 13 Aug 2024 18:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="T6yXjJgd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B524A3D
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 18:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723574142; cv=none; b=WPy943NnB1iG0ToZD5kPFWGq66WbLv1LIdemqmLT99MYk1fNC/BpcT5qIf8pHF4dn9OdZQYfVfgneyKD3nEytbgb2ggqUoVtwBDev1Ydn+xY7dTKDIw6/ZJEt4PNzE1EB2evb1htRjo5JXRPKZV0/TMYyTXsPyZ1rNiqNbGrFyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723574142; c=relaxed/simple;
	bh=YFElY7LqtPUHokqF+q/+Ny0QNk+b3F7PCQchtn022ec=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LN6/F7QKk0eaN+IImtQd3oEu09B1GZf+TcmmdIcFb0eWlXoZky/avII8XlAS3/VyFwWvSlC2O3ILxVjcrJKSRhLNEsjC1Hg2oxQJractCUUMcrDTQufpR0MsWHZQGQUhlq/80bzlD1PFDybyES3oepjYrNoZkx8QwWviP7wTwY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=T6yXjJgd; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1ff499841f4so2403845ad.1
        for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 11:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723574139; x=1724178939; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YpxV1hvHKtLLh1UUCEag9r0bBWiXPUGgwFb0YH4js5E=;
        b=T6yXjJgd3MQeGSQ0FvgMd5QBTKAIaj9jgAPtqDTIwXjrLLpwAx2oBIz/8NsIPiWmLm
         6TzmI53z0FmMijUA+w+n7c2+xAmQRzzkuukjexte+nRDLQV1HzZPnwRGtKC+4PMXgAmD
         wvJXoL54b1alDeBT3a2SIa2yTY30a52+ZDYQzWmzc3VDsAxLsMTmxlNfcpYwDHYfjL78
         LM3rERAhiapzIXKHVchZSrcjVfOQCS/kJMOsDbOTcwaiFTo9/BrGD6wTAMHHdEISeH+c
         H/TUIdFqf9jzhIkfGscbpROwarKD3rHzHa6fQZx+skmies6ky2iajy0DX+S+jGaHQjrC
         mB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723574139; x=1724178939;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YpxV1hvHKtLLh1UUCEag9r0bBWiXPUGgwFb0YH4js5E=;
        b=mRdC2cQMBUcJO8Q/aYfYnbrGjAjFlgPHmc5eX7UftLf+BWFsa8UtBRWzNzsSI7MrOx
         k8zPd6kGqwq94tbm3ckbw3Tw57FoYc5PmJNbhBKTVTDSbR96Y/N4bXIpzwsXGxveeW1Z
         7N4SkytTba8m9gLHdDfamsCONzuhKGf2SCRuzBW4ZdRsy5hjRjLavjuZNiMQZWrs5d82
         rTigm1bPtt9ywR2pCSd3JqPx9dHOXFUYmfjw2WuZpMvkTndFyzhoGCSeyvgM9KEzxn2T
         lPAwPukRBukma3ah50OwAn+qAC41cAC0hPGaM/9p9gdA88pWwbtwagjKNKlBh7JaqNik
         SCCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpLFB1JXGKnaCXKPaboqoK9bir2qKnCMcemX7N5+0mswvix/ECCRA8C7F14T/AX2hF1Ve/2kqvVw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt/y0j/GIPYHDzgMfxyH10t/8nHensxlnCqpEE3MI4wY+2ROmb
	d2jbyOqMzMbHfdF/sUAv8W/iJK42QWmP9R9piT6NEvLkSAMjeRlbONlIFefIvPh99BK78viYpB/
	J
X-Google-Smtp-Source: AGHT+IF25YliQkofNQqqBGgny9snCtewxStOn4B/8wT3jJBX+xnBawRrivv3KxcUVUFDmW4Fvx3bPA==
X-Received: by 2002:a17:902:f2d1:b0:1f3:10e8:1e0 with SMTP id d9443c01a7336-201d639e531mr2980815ad.2.1723574139364;
        Tue, 13 Aug 2024 11:35:39 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1b8ecesm16704735ad.218.2024.08.13.11.35.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 11:35:38 -0700 (PDT)
Message-ID: <bea51c28-17e0-4693-96bf-502ffa75f01a@kernel.dk>
Date: Tue, 13 Aug 2024 12:35:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/napi: remove duplicate io_napi_entry timeout
 assignation
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
 <05255cc5136254574b884b5e10aae7cf8301662a.camel@trillion01.com>
 <8c1ee6ab-8425-4d13-80f5-ff085d12dc91@kernel.dk>
 <f1397b51-8d41-4f91-aa25-37f771fe4e13@kernel.dk>
 <8887f2d97c1dafb6ceaf9f5c492457f642f532dd.camel@trillion01.com>
 <5730c0c1-73cb-42b5-8af3-afe60529f57d@kernel.dk>
 <e7e8a80ffcca7b3527b74be5741c927937517291.camel@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e7e8a80ffcca7b3527b74be5741c927937517291.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/13/24 11:22 AM, Olivier Langlois wrote:
> On Mon, 2024-08-12 at 14:40 -0600, Jens Axboe wrote:
>>
>>
>>> 3. I am surprised to notice that in __io_napi_do_busy_loop(),
>>> list_for_each_entry_rcu() is called to traverse the list but the
>>> regular methods list_del() and list_add_tail() are called to update
>>> the
>>> list instead of their RCU variant.
>>
>> Should all just use rcu variants.
>>
>> Here's a mashup of the changes. Would be great if you can test - I'll
>> do
>> some too, but always good with more than one person testing as it
>> tends
>> to hit more cases.
>>
> Jens,
> 
> I have integrated our RCU corrections into
> https://lore.kernel.org/io-uring/5fc9dd07e48a7178f547ed1b2aaa0814607fa246.1723567469.git.olivier@trillion01.com/T/#u
> 
> and my testing so far is not showing any problems...
> but I have a very static setup...
> I had no issues too without the corrections...

Thanks for testing, but regardless of whether that series would go in or
not, I think those rcu changes should be done separately and upfront
rather than be integrated with other changes.

-- 
Jens Axboe


