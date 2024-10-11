Return-Path: <io-uring+bounces-3607-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 436FC99AC95
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 21:24:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 735381C23143
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 19:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A63981C2444;
	Fri, 11 Oct 2024 19:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZlhHZr7+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F55F1C2327
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 19:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728674651; cv=none; b=ld/hOkvJzF2qrEvj8TT34qpBbitkj4tzX/OLIup7ewqaQ6TB4fR7Sj/IngeRT2J0nszGC2uz+yZqQmWiXFywGsyL7okMTSfMQPVmaxxJq65FN2mc4IiyGk1lBOKPSaeuDMMAv4MeuP6wDnucvhBoy9SQEKkBEceEKcIJqSlkYRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728674651; c=relaxed/simple;
	bh=13CF7ab4ATRDB/MbW4oIzVkkmerDNb13nVQpRjnGKZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CRWB067bw4A1vcOxLLnAMUMuoU5gmdJw+SqEvxCJJ5YFKv1PH92exA8fWXApDG3fmLFEhvXsrYo12361YL/w5tsQKn+6fXhKHnkbwp2WAm2jPP06YNZGoTH1WpvznX7cvpzE8jnr0AJEqKh1jKqu0/En3wFfpo0HRaVEmWguB+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZlhHZr7+; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-8353fd2cb2dso103573039f.2
        for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 12:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728674649; x=1729279449; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4mA4Vy4NccZU27p7YJW472aP6iwOgDdVtps9WY16rg4=;
        b=ZlhHZr7+GjOkgJ3YmVpzLG5aJVHMXsY2YFWQcmKe2AnxQBIJyOnDbhPGpSp0wA4oSe
         9WuOOImWL4Pk1oQhcD2s1PiECV98pnR8O9pObVBntvGE0X0JGpnxU3RV7nWG+LjR3waW
         uShAj6FHakK1Bz6yUFzF35IE7EcACk6waU6ZS2nAWhtgf9fztP6AQEpHuUvdIXbzy0Mp
         StQuGnXXpXFGf6u3D2+Xhvk25f+HWJLFGNEQlMLcWn45kzbI+iFhzuTRz12oM2YDXyN+
         blmtSbvTrGSeDLgu4krkWHgNkIl7ijpckvMdEiHjdxOkLvSs9Ua6ZzeHW/x2YaNqTcCZ
         uKjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728674649; x=1729279449;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4mA4Vy4NccZU27p7YJW472aP6iwOgDdVtps9WY16rg4=;
        b=iXj6lS4J7kcWtkUC8c64VhtoOLnj57KMmsUDoiGL8RyernCCS5/WRNewBNctb0O3aT
         5kVOGh/aMRN/hWr4dzg8/FYFkLonZBFpooVhkDRI9wCqNfZYDeHJLAiGA+PbTAYeOAV7
         TmigST6MlegmVeJr+IC+vhvdWOt85UQSmFwc/1HbsTXOGtWs6EWV8ReplixlQdt8A1Eo
         M4krlCLiiDtfcSDNMx7AhU9RV6jvbRZCML3WWmZQx1uTAdW5Lf5WUZxhYt9lHV2hkiCv
         srfVggXj68LLGOADo1DOQlAuj34nAFdYErAhPzcsvqac5zuZr19UvMAWQEaxBy8/GSih
         OQKw==
X-Forwarded-Encrypted: i=1; AJvYcCXmVt2RxuYTJbo4qpIK97gjyxxYa65isdM6EHeFQQLjdUoXWG4JjxRJEd3NtAm2jwsFdltDqe5ISw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc4Zf5rA3kx1oAs1Ctf1cmk7stxOkl4D7TcQPB9NB8Mhag7x/q
	QWYtd9AAPBjL1ySu3T/pCZSI8CpIJRNVWcS1mgSYWdiNFANFih8Lvk7ybdGRADA=
X-Google-Smtp-Source: AGHT+IHI68qwfop2zP4xdM6GsV8SSKrgdMOtSCikYXrUjAuE99iLa1lgvv8X4GICj2hCz05TXh8RNg==
X-Received: by 2002:a05:6602:6403:b0:837:7f69:eac2 with SMTP id ca18e2360f4ac-8379241ac0emr394699739f.1.1728674649075;
        Fri, 11 Oct 2024 12:24:09 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8354b9130d0sm81240739f.17.2024.10.11.12.24.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 12:24:08 -0700 (PDT)
Message-ID: <136d1b08-81fc-4446-b5ed-7db6f8b5dc5b@kernel.dk>
Date: Fri, 11 Oct 2024 13:24:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Large CQE for fuse headers
To: Bernd Schubert <bernd.schubert@fastmail.fm>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
 <f83d5370-f026-4654-810a-199fb3e01038@kernel.dk>
 <aa99c09f-fa6f-4662-9da4-62a7d848d8b9@fastmail.fm>
 <3766a6e2-c9da-4643-8333-4f152d955609@kernel.dk>
 <69b6d3e2-28a1-4055-9b4f-b34d11f77dfc@fastmail.fm>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <69b6d3e2-28a1-4055-9b4f-b34d11f77dfc@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/11/24 1:03 PM, Bernd Schubert wrote:
>>
>> Curious, what's all the space needed for?
> 
> The basic fuse header: struct fuse_in_header -> current 40B
> and per request header headers, I think current max is 64.
> 
> And then some extra compat space for both, so that they can be safely
> extended in the future (which is currently an issue).

So that's 104b, and regular CQE stuff too I presume, so that's 104+16 ==
120 bytes. That'd fit in a 128b CQE, and 256b would be pleeeeenty? Just
squeeze a version field or something in there so you know what the
version is for future proofing? I would strongly recommend making it as
large as you need it for those things, but no longer just for
compat/future reasons. Eg 128b over 256b is a win for sure, and 256b
over 512b is a REALLY nice win.

>>>> Since this obviously means larger CQ rings, one nice side effect is that
>>>> since 6.10 we don't need contig pages to map any of the rings. So should
>>>> work just fine regardless of memory fragmentation, where previously that
>>>> would've been a concern.
>>>>
>>>
>>> Out of interest, what is the change? Up to fuse-io-uring rfc2 I was
>>> vmalloced buffers for fuse that got mmaped - was working fine. Miklos just
>>> wants to avoid that kernel allocates large chunks of memory on behalf of
>>> users.
>>
>> It was the change that got rid of remap_pfn_range() for mapping, and
>> switched to vm_insert_page(s) instead. Memory overhead should generally
>> not be too bad, it's all about sizing the rings appropriately. The much
>> bigger concern is needing contig memory, as that can become scarce after
>> longer uptimes, even with plenty of memory free. This is particularly
>> important if you need 512b CQEs, obviously.
>>
> 
> For sure, I was just curious what you had changed. I think I had looked into
> that io-uring code around 2 years ago.  Going to look into the update
> io-uring code, thanks for the hint.
> For fuse I was just using remap_vmalloc_range().
> 
> https://lore.kernel.org/all/20240529-fuse-uring-for-6-9-rfc2-out-v1-7-d149476b1d65@ddn.com/

That's the one to use, io_uring was just stuck with using the wrong API
for quite a while, but that got sorted.

-- 
Jens Axboe

