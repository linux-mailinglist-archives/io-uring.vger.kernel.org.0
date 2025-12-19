Return-Path: <io-uring+bounces-11226-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C38ECCE5DE
	for <lists+io-uring@lfdr.de>; Fri, 19 Dec 2025 04:28:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8BD213028186
	for <lists+io-uring@lfdr.de>; Fri, 19 Dec 2025 03:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA7B2877EA;
	Fri, 19 Dec 2025 03:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="twE8Q6wa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A901F30A9
	for <io-uring@vger.kernel.org>; Fri, 19 Dec 2025 03:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766114915; cv=none; b=Ge/qCuTsu5Of1zh53+EehNPqAlzT3BjzLM9/0/jMUqNsojcTG5F3hpF3IwUdWvx+eH6d/PU+XmwfhalTi4WXKt3aAoz2PWPUo0QT5tlbO24vi9GP+fGsEMsENdExJcdoWuKw3ZpDCUv+kho65aDS6g2CllDfHrgs+x0CFGwhb2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766114915; c=relaxed/simple;
	bh=MGw+Fcp3V5ofr0lrVYs9ECOucGUmiMDhXAOjLKJiuY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hO4SRzWeVSAiIco2UlGLJECJEYaAz0flM0+63lFSG0/fbCbqL1Yf3xUYbKINy4/TiPua6XtN7GReSPA72SvwPL/nPIxbzRXOUBWQmhFv/wIQAY5iaeKT9SyIblJylcBzifp0LHdrkbzikfuE7R+BiGlj5Zh76o4kj1vSRDPiUQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=twE8Q6wa; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-455dc1cf59aso840743b6e.0
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 19:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1766114912; x=1766719712; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DuEgUbURtVEABwJN+Di1NCf7fpdPuASWA2UG0m5bbnc=;
        b=twE8Q6wazPJ7j1PhfZShzIOHDW7ex39Rd9n4lWTnV8dZPvTFqQxvMCTV+zgxcDOtSA
         wjTwOUlovvLA1Y5eJDFtOyOCPCkWeZW7AuBBbbU5urx9uzaQUhsbZn6+KZxzv6P3gFr6
         w9CcMO2+L8s19A8x9Np9xmNYNeUFzXBZLM4VARzNVEnk3t0qjSFW7avRLEv3xUkDs4E2
         1yrKBfbxR6KZUeYIN0iMKior21OgtEbjqlCAC+iHjYm1Y0bsDBHcsvMKkQ7LGZLfLzoq
         HcmPuICxL21rt9we+/or1/YHjmTkbjW4mSBrmVIC1IM2gAYoAwF99WTyLd+UF+wvT+9w
         +T/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766114912; x=1766719712;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DuEgUbURtVEABwJN+Di1NCf7fpdPuASWA2UG0m5bbnc=;
        b=w1Th2EXk3M9neoz9K7Yn9Q0x74zlSF97SFWDd2JYERAQ1jNvYNq7aH4JM8ggVDvoOA
         UrHWbaa8lpqx4IqOgBJyDPchlx2kN+0OvxWU2SFQmGERJ2ja0C430Yr/SGG91IRn57mF
         RpYHHoWiZ31oKWQe8vMRneERWgRG+scFzKq0GmrUzAEhEwqOIwusK5YmmFPOaVhuMMXl
         h7ZcBuCai00fQIjYLQdbEKXwPc7pLfzRwHGcbcObahuIveZ7gI0JSQzZYb+N2sX/d0W/
         cxIfMUgGTNES0XIR/SBRnEGqtd177wKpxhem824a4xCGM+IuA/GMHcMq8KhZb1v4dTHY
         STFg==
X-Forwarded-Encrypted: i=1; AJvYcCVtQdNT75ehs/zM/n4Q9s3GHW+ll/DkzAlXrD5bv/KqaK379BMW1WxhSOdjbrZSfHUGBRH0FecAAA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFQGx/n4iejNprN4HPorKApruWasm0zTdtY66MH6rJb21bWCdG
	u3pdZqbk3agwLonUgTjzyWy7FzuFj0t+NfceT5JW7TYkuslhiMn0vorij9sA2f+9WXaqjT8I9o/
	TDJN2Mxo=
X-Gm-Gg: AY/fxX7n/g1L1HZAvovQGD/rDEYUD9k99XsnrflFZzKzY3B7x8pUIbiQllrW5o3+QV9
	zXNTQTYcmLPvMnsVpiwXcUtuLHbXM3gX4jUjb3ExCvJE4cUYxZQJwVVxcVqKm32b51/qlH3Hxoc
	cvC6MZyEdg7hppC9J/rhySn3WcKx6mej/q8wVxZsxtYstwFOWuKVt1Cjg39adasOMZ2h9Ks2N8A
	jScIR6zaVz9+qQtOdxHJHi6UB4KZNa5WEoO5G/dwj29vsMdPAJlu0GcE/IkBBAOgcg8i/YOhH4F
	a85z1Fc9rcHVHBd/An8EJOxu01qVF93iHHCqmYRHGAVRITHyxeNuW5hldaRGX3wsNEtHTyF9pOC
	fxLC9OnSDbgm3verqm4jcOg5emg+8pWtLeovpx6EmE5oX0naJ6sS7AaQJEGWVOeKv/mDBICOJFn
	9gTdiKBLw=
X-Google-Smtp-Source: AGHT+IHbIasLvbTop2riLdnzEUuy8PQEauwy8HWBLwz+cwrSp47O7Ha6xe5ytfp+xjbVNXSqRNXktg==
X-Received: by 2002:a05:6808:2384:b0:450:b64e:9c14 with SMTP id 5614622812f47-457b1fc2a1amr935332b6e.5.1766114911800;
        Thu, 18 Dec 2025 19:28:31 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3fdaac129c7sm683302fac.21.2025.12.18.19.28.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Dec 2025 19:28:31 -0800 (PST)
Message-ID: <2805e3cf-becb-4bcf-bf5e-96d3820f437b@kernel.dk>
Date: Thu, 18 Dec 2025 20:28:30 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: fix slab-out-of-bounds in
 io_buffer_register_bvec
To: Keith Busch <kbusch@kernel.org>, veygax <veyga@veygax.dev>
Cc: Ming Lei <ming.lei@redhat.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 Caleb Sander Mateos <csander@purestorage.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20251217210316.188157-3-veyga@veygax.dev>
 <aUNLs5g3Qed4tuYs@fedora> <f1522c5d-febf-4e51-b534-c0ffa719d555@veygax.dev>
 <aUNRS1Qiaiqo1scX@kbusch-mbp>
 <80a3a680-e42c-4d4e-b613-72385d3f46d5@veygax.dev>
 <aUSHcH9TccvzgQkG@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aUSHcH9TccvzgQkG@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/18/25 4:00 PM, Keith Busch wrote:
> On Thu, Dec 18, 2025 at 01:13:11AM +0000, veygax wrote:
>> On 18/12/2025 00:56, Keith Busch wrote:
>>> I believe you're supposed to use the bio_add_page() API rather than open
>>> code the bvec setup.
>>
>> True, but I wanted fine control to prove my theory
> 
> But doesn't that just prove misusing the interface breaks things? Is
> there currently a legit way to get this error without the misuse? Or is
> there existing mis-use in the kernel that should be fixed instead?

This is the big question, and also why I originally rejected the posted
poc as it's not a valid use case.

veygax, please make a real reproducer or detail how this can actually
happen with the exposed APIs.

-- 
Jens Axboe


