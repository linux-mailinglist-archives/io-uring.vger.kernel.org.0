Return-Path: <io-uring+bounces-4357-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D75199BA0D6
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 15:43:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62899B21669
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 14:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB831189BB4;
	Sat,  2 Nov 2024 14:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tMWZBPDP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B58B19CC27
	for <io-uring@vger.kernel.org>; Sat,  2 Nov 2024 14:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730558617; cv=none; b=hTHqGjmSz7C9BOahg+p11VV3psg+Tlb9A77+XBjFsZHYnEIreez9Ul8umgEEniYw2AQ6loWZZRQM7bKmgQw4u9Kvb6AZpsSgge+CU1Srfh7ahOAZOseV+b4xdd0t9o5Pt6Vd5gAsEphDZpjnoI96ySSkNmnBukzliN6XoK+Qq7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730558617; c=relaxed/simple;
	bh=/Eed5JrklKb9Hqmz+439W4RlQxlng/Ae5yh2GWJCd+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iCvHFnFzq6OAdtzTqXljVhKj1rEwLmYq244ogr/upfzV5UhF8vttl9Nh+8Ly9tVHtpepVdt423bIiD8MdArCgQb9iMrZoQjdsV8z3GZnFsgifZ9Y/uVmQc9B4HqjZjaOXh2llBu0sWM6R7y6Cy+jAdcYeSoWxW/Hcx7Q94UFkfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tMWZBPDP; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-720b2d8bcd3so2256600b3a.2
        for <io-uring@vger.kernel.org>; Sat, 02 Nov 2024 07:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730558613; x=1731163413; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UgTI6j4twtQTKANKlcOCCvSgZw/9iWAQTs8FIHtDrmE=;
        b=tMWZBPDPt4+uQZwE5BRWCk7OOrwoTmEtxkD8HmXipJmcU5nM8cObtyzZqMnP/utrHk
         xG93+uo/cmAiL0kR9tRSOZZDTuKDYzgrHFZSSYR3qs9RI8P+zEy8gk5ZxnZhH5YK70F6
         eMLDBbHgHuj/5Ehbf1koYIt0UKe4V8BSB+F2GxQK6h2KVtQwM9GadA2DrOJ2KnYTekOb
         21dXoGK5EkLtECDdNZ0Ye8LO07r9rxFEfaGodfuuIWzg3v7RZMVWQLKG/4u7UpDT1QRD
         f9biE5a6iMd/YOwoUnN8vD9vx3d99yE8TiN5IxBpkXnvRS+vgNoyC1ekQlIXufu1iPxZ
         rJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730558613; x=1731163413;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UgTI6j4twtQTKANKlcOCCvSgZw/9iWAQTs8FIHtDrmE=;
        b=ka7Ys/X5fYfKJHZLbF1iIMHnCvoWfBSKS5JiyfZ+U9N8VaG70sApn6S76cdZcUCWD6
         LX2iVrMVICGHfYX9jzRv90Ayq+/XPeHK+kjq4SR4CUMy5jlcOLGWt+SXg3UPYj3DYYI2
         WlpOQJmW1Jlm3vDeV6bg03Vz9jk3E7AaMUUz84XrrRPrHwEBkO9AhU/khHVa5gggaYLQ
         s6N8Glvpjs7/YdZjYZVCd1h7w9onhbr7NYHCfWlI90KxBWRPGknwAbtOfk2JULDhjHVA
         q7V2CbfQI7e7gwpS86Qf+g0D5vjAxgnIa6Czj4aXhjmtzB2o+z0Un50/vtr6FFwY8QDO
         vkYw==
X-Forwarded-Encrypted: i=1; AJvYcCVFUNeGhg9c92ZgT4PvwzyE4jbrg2rPlcouFbKvWDCmv2dZ98Tf8ub0qI1z4UVYJdb81Ffy1mFWGA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4Er5ZI/1GcAS02EAD4rTg1AuHvQJxp7CW92E4UD7vxXmqqu4h
	7gNToj2BJo90xS+aGDwZJICNFNI6trvZAa3dTRihmZFjKGsK1q2zgJmyl/9rv6EeL5aaVyNuId1
	QY7k=
X-Google-Smtp-Source: AGHT+IHFqW55RL0gjJ7/sY7mwP2Be/4+ofTctoSEIyhIJPp+m5Ug31+P3tNcJQcj6+6S08raJLCxEg==
X-Received: by 2002:a05:6a21:2d05:b0:1d5:10d6:92b9 with SMTP id adf61e73a8af0-1d9a840b059mr32814164637.30.1730558613080;
        Sat, 02 Nov 2024 07:43:33 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc2eb554sm4193191b3a.161.2024.11.02.07.43.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Nov 2024 07:43:32 -0700 (PDT)
Message-ID: <2a01f70e-111c-4981-9165-5f5170242a8c@kernel.dk>
Date: Sat, 2 Nov 2024 08:43:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCHES v2] xattr stuff and interactions with io_uring
To: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>, io-uring@vger.kernel.org,
 =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
References: <20241002011011.GB4017910@ZenIV> <20241102072834.GQ1350452@ZenIV>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241102072834.GQ1350452@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/24 1:28 AM, Al Viro wrote:
> 	Changes since v1:
> * moved on top of (and makes use of) getname_maybe_null() stuff
> (first two commits here, form #base.getname-fixed)
> * fixed a leak on io_uring side spotted by Jens
> * putname(ERR_PTR(-E...)) is a no-op; allows to simplify things on
> io_uring side.
> * applied reviewed-by
> * picked a generic_listxattr() cleanup from Colin Ian King
> 
> 	Help with review and testing would be welcome; if nobody objects,
> to #for-next it goes...

Tested on arm64, fwiw I get these:

<stdin>:1603:2: warning: #warning syscall setxattrat not implemented [-Wcpp]
<stdin>:1606:2: warning: #warning syscall getxattrat not implemented [-Wcpp]
<stdin>:1609:2: warning: #warning syscall listxattrat not implemented [-Wcpp]
<stdin>:1612:2: warning: #warning syscall removexattrat not implemented [-Wcpp]

when compiling. But ran it through the usual testing on the io_uring side,
and it looks fine to me. Didn't test the xattr* stuff separately, assuming
I'd just be re-running what you already did on that side.

-- 
Jens Axboe


