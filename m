Return-Path: <io-uring+bounces-528-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C962847E6A
	for <lists+io-uring@lfdr.de>; Sat,  3 Feb 2024 03:30:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 518131F25D84
	for <lists+io-uring@lfdr.de>; Sat,  3 Feb 2024 02:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ED0763CB;
	Sat,  3 Feb 2024 02:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OSdZ2Aj5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503FA63AE
	for <io-uring@vger.kernel.org>; Sat,  3 Feb 2024 02:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706927454; cv=none; b=fQXuDKGUGcava46qlLZf1ySRs05QllNSYumEB8v2tA41Im3llTHifBo4i4D3OpCJcoMcQFingDsw4b4zVcVJb20neujNzw5BSXxNGby7VorZAHvCCFckDr0Oi78mwoXWdlW//4uqzKV6TZD5KAY1vPNI+I34fetG3oKHpktx4oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706927454; c=relaxed/simple;
	bh=yHwyq/3E81Ve41GEprNfFAFtygOZouTN2zQAl9gBdjY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ZQ7jrDbkfSnYYpl74qx6pWXRnHpetToZttYTVRDkKxGTfano4v6fRgn1fZfKaIZ5KNmCEFGRe+MkXgNOvE0yuzbKUANnF5+J2Yg6/cGXj+ZUXfyUK8gf+FVa4TfcV/dHKrIqHPauWUcTRxnV0p3Q9KHIYxQL1sN1d6HanvLYK5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OSdZ2Aj5; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3bc21303a35so806131b6e.0
        for <io-uring@vger.kernel.org>; Fri, 02 Feb 2024 18:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706927450; x=1707532250; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KFF+85ytQlaTB8puxunrznupEogwDxP7b5PNMAatoIY=;
        b=OSdZ2Aj5v8Dkkqvo5qSQ0Q+/ycDPTspPLTqSV41MebHYm0ZHTqF3sEdxOOxWDANaES
         4IwERzReG6rN2SBoRlgn5p6C67hdaTbVF6+kFbH8rhP0iAgrLNX8Mw3f05pKLSzu40DS
         LIQgLflEK1nJKnEYAGQDnzEdA3f4c6/I2M+C7v55X90r1yVmYcxy4qxTlpeem/JOKVQh
         3VgPBPkDGXQSHgtBrxA+FLY5p5BA8bntB4o27j/JXFcJ8IoTdq8lZwk3COE58gNMbP26
         L9hXrW4dQf1oBrXoZFq8xzohf8FXKDc74KpJ5Q7trHDNnubJ3r95CqR85RBjLrhs5teg
         kr/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706927450; x=1707532250;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KFF+85ytQlaTB8puxunrznupEogwDxP7b5PNMAatoIY=;
        b=lG/s+7Hs2+G/20dYW2k3pqfcEcaw61qJm/slcC+GnpypIiaNQr9H9rTaByYlbv47oB
         tFILIgAmtdO7FrPQP+J3YWCO1NCZSIgCTpfb7wawy0aivGbrcAgT6e4kSXpu1cPXi7FE
         4tEVt2pFhfhG+3eH3ivtusXish0bsELngpwfuiqJi1KIAJOqG5TuB9roNxndwKyd2m6S
         hjgnhj/bebNaOg3jY5w9BncxWJIRhfSXMN/AscoXcDQVlsIdsULHUz52tuFuk95intHv
         EaN224l49ZgwJb+al7eSWgULYVdaGUrggBQQU8oy7DASzdm2iyeGlJakuwlf36Fwg6Lm
         +onQ==
X-Forwarded-Encrypted: i=0; AJvYcCUcSjpK21FfSOl2E2wHKO8plXPDkjzBvrCcMS97xuSvh3mECAVDiZCi1fz0QTch+O4/lX00JaPZ6ukfusc1WQP5tlhYG2XUt7A=
X-Gm-Message-State: AOJu0YydXBpi0Ug+zUrBa7UrpvCtHuaHO7kPdfb7fjquC9ZyTiM9TCxT
	q3YDj0LlTA83Jen7SV94a6nwt4PK6Awz5bYH4K3i62QLFqz8NCDW+kRPojlOScs=
X-Google-Smtp-Source: AGHT+IGnqw/dwG6wxIw/rFCzuGsnP3S98QSapaHcl6iZYz2MQmtkSK4oqCXfXhcy7qfRe5j7Ed8Vxg==
X-Received: by 2002:aca:1214:0:b0:3bd:f952:5b66 with SMTP id 20-20020aca1214000000b003bdf9525b66mr9434633ois.1.1706927450168;
        Fri, 02 Feb 2024 18:30:50 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVIYDXh+ZtIdacDiT/AvVwjjZ15/sDKKlhFEQrGH8/5H8fRxBYlF5Och2UoV+Lcn0Ottgr9pvxER1rLH1fFagdnH6r/YlCgC/agc2j4TnSFcmcj8p+IjW5zX6UrhuFRdtEwvOEI3HOLx2weKgVgsZ/6v3+uhHo=
Received: from ?IPV6:2600:380:9b49:f89d:4b02:3da0:4a46:b5bd? ([2600:380:9b49:f89d:4b02:3da0:4a46:b5bd])
        by smtp.gmail.com with ESMTPSA id s17-20020a056808009100b003becfdbaa95sm578093oic.16.2024.02.02.18.30.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Feb 2024 18:30:49 -0800 (PST)
Message-ID: <66a01dd5-2153-4c07-80c1-4d539c296dec@kernel.dk>
Date: Fri, 2 Feb 2024 19:30:48 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/4] liburing: add api to set napi busy poll settings
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Olivier Langlois <olivier@trillion01.com>
Cc: Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
 kernel-team@fb.com, ammarfaizi2@gnuweeb.org
References: <3b32446d8b259219d69bff81a6ef51c1ad0b64e3.camel@trillion01.com>
 <07EEF558-8000-436B-B9BD-0E0BAC40C2C3@kernel.dk>
 <a6bd8fc18d15bf1be4ccf0a8cd4f5445cd849fa2.camel@trillion01.com>
 <948ec12c-9601-4e96-b9b6-d97a6cebbde6@kernel.dk>
 <4d7b32a2-20e5-4408-a30b-cddb942ade25@kernel.dk>
In-Reply-To: <4d7b32a2-20e5-4408-a30b-cddb942ade25@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/2/24 3:46 PM, Jens Axboe wrote:
> On 2/2/24 3:20 PM, Jens Axboe wrote:
>> On 2/2/24 1:23 PM, Olivier Langlois wrote:
>>> On Fri, 2024-02-02 at 13:14 -0700, Jens Axboe wrote:
>>>>
>>>> Ah gotcha, yeah that?s odd and could not ever have worked. I wonder
>>>> how that was tested?
>>>>
>>>> I?ll setup a liburing branch as well.
>>>>
>>> It is easy. You omit to check the function return value by telling to
>>> yourself that it cannot fail...
>>>
>>> I caught my mistake on a second pass code review...
>>
>> Oh I can see how that can happen, but then there should be no functional
>> changes in terms of latency... Which means that it was never tested. The
>> test results were from the original postings, so probably just fine.
>> It's just that later versions would've failed. Looking at the example
>> test case, it doesn't check the return value.
> 
> Setup a 'napi' branch with the patches, and some fixes on top. It's a
> start... I'll try the example ping test here, just need to get off a
> plane and be able to access test boxes.

Added ipv4 support to the napi example code, and here's what I get.
Stock settings, no NAPI, 100k packets:

 rtt(us) min/avg/max/mdev = 31.730/37.006/87.960/0.497

and with -t10 -b enabled:

 rtt(us) min/avg/max/mdev = 23.250/29.795/63.511/1.203

So it seems to work fine as-is, with the current branch. I've added some
tweaks on the liburing napi branch, but mostly just little fixes.

-- 
Jens Axboe


