Return-Path: <io-uring+bounces-2636-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31600945C45
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 12:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6389E1C21470
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 10:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC001DB423;
	Fri,  2 Aug 2024 10:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O1SSQ2yr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E341DAC5B
	for <io-uring@vger.kernel.org>; Fri,  2 Aug 2024 10:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722595621; cv=none; b=fvfakv8vPOyB50mQmY6Ty7+a3eauqE/zL8FndyHz9EmbosF3M/HFYiKcdKZ22a05dh6hfokrfFkr+qa1ZNV5su9YO0MZTR6VoHnh9lk0Bjw4Zev2kSyIZMKTmszas4NZPMdv3B7IkUi381utS1jKw4XOpGftYQTstz2qZsC/M2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722595621; c=relaxed/simple;
	bh=KxLtJAlxun6u7nhOS3yvrma7o9mAWEt7f6htuy+dIvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K60jtyOn7KLsdsa80of2i9VyslpGYX2R81TOWQHWmca+vpBBY8l3Ifa4DQyTYk6ZH5Va/4mWum7DnElD3uFMALpFH6+t2J3lqUCcK4DguD3ORwkOLNl/9x7P45Uf1JgWv7s6uQXgdrVZ9JtO4O/sdwiBWEE7uHoOwL3KnpkVAlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O1SSQ2yr; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-368440b073bso1963986f8f.0
        for <io-uring@vger.kernel.org>; Fri, 02 Aug 2024 03:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722595618; x=1723200418; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gwg7Zacw2i9PlgStAgK9kLzT+wXsuQ3Zt0esWZmWAVI=;
        b=O1SSQ2yrzsu/n/Id4IHm4dZ0LqZ+LMrD947UJouTW7s+zb940AVa00gPdTXkZHi80F
         cHNvF2ylNHkeXcumVBUZrwKPiq8l6dcRLpucTk7gp8amZraU9/QtRb1CJWGtozgsm50u
         xJd1cyhk+YtEUdYcK7HKdXO7H2bi27vfvxez5Tuo2sIiRnTM5oXjxPnPNMotJ7NyHueJ
         m72KhDWvInyUR+GDzimBB+AvioXPKIgLZqh04w2iMPfp3LpQMzCrKhV7u93q3dwRs/Ca
         8acBNJJ/3w8j9x4GVeqCWJiBLEeZ5sj4NO5D5Ea0/FE5rkxoo5EMZ4g4hObYNzJl5mQJ
         FOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722595618; x=1723200418;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gwg7Zacw2i9PlgStAgK9kLzT+wXsuQ3Zt0esWZmWAVI=;
        b=JpWCfM0zNSN9MRPZH8UXNdLDD6DPQrHdRwSTL6Indb+jAZxst6fKN9eM4xi8vg2z2P
         /QNfjt5ttbmleJz7IWrXfqTomiaysEXdMIl7iyvYa04C5N/U20A/B4eTXgDEgGFA2TCR
         UZ8+5dIh2VzI4QPQCgYYfT/WoCXL3D5A4oxqH7BmTgVX5js/xb+vmHPS8tBTh4M73fcR
         Lv5YXVnyWVfKL3OIUZ3/saWNOCsIayRvwA/ZmO99LOkFj9W3Fomw4KY1UFXbNyD9vKdl
         SRdTzFie1bC2coFJWg17OU+ZoqPWzdUShracSbnzIZSJ5FjsgnyOt4sIHqYLeg1kM4Hh
         Mxzw==
X-Forwarded-Encrypted: i=1; AJvYcCUZOW0WSA35f5ZuPOWm4x26maoScxdSX6DowKp0334kfzRrltmEqRlB1VAmaqdVRPWvg7R1OHxEjjndiEHGOVlPV9XbvkIWooo=
X-Gm-Message-State: AOJu0Yz5XcgXW36dAjV9vM68mId5oDCVydib43ieO+ORtcIvB5JqoHpk
	hHOsWj1/T0kD9B8V70BIsIixNpjMZv4WKT5q8gWFH8GtQFAngYga
X-Google-Smtp-Source: AGHT+IEOPc0ki9JCzrvq0cH9yeGsj55xDkHD5kh4RPiVrUJViEkunNxX9bN2zveFPuN4o4803VBswQ==
X-Received: by 2002:adf:eec9:0:b0:368:3ee9:e119 with SMTP id ffacd0b85a97d-36bb35e5701mr3806618f8f.29.1722595618037;
        Fri, 02 Aug 2024 03:46:58 -0700 (PDT)
Received: from [192.168.42.220] (82-132-220-64.dab.02.net. [82.132.220.64])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4282b8ad475sm89818675e9.13.2024.08.02.03.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Aug 2024 03:46:57 -0700 (PDT)
Message-ID: <b5feb584-0d7d-45d3-af06-4771d5d4b899@gmail.com>
Date: Fri, 2 Aug 2024 11:47:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v3] test: add test cases for hugepage registered
 buffers
To: Jens Axboe <axboe@kernel.dk>, Chenliang Li <cliang01.li@samsung.com>
Cc: anuj20.g@samsung.com, gost.dev@samsung.com, io-uring@vger.kernel.org,
 joshi.k@samsung.com, kundan.kumar@samsung.com, peiwei.li@samsung.com
References: <2b0e7ae1-ac02-4661-b362-8229cc68abb8@gmail.com>
 <CGME20240801010122epcas5p3ea76168da6d5dd9ba6d8fe54537591d8@epcas5p3.samsung.com>
 <20240801010115.4936-1-cliang01.li@samsung.com>
 <c92fcb87-b8ef-4f86-b7bc-b09188e33ac3@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c92fcb87-b8ef-4f86-b7bc-b09188e33ac3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/1/24 21:51, Jens Axboe wrote:
> On 7/31/24 7:01 PM, Chenliang Li wrote:
>> On Thu, 1 Aug 2024 00:13:10 +0100, Pavel Begunkov wrote:
>>> On 5/31/24 06:20, Chenliang Li wrote:
>>>> Add a test file for hugepage registered buffers, to make sure the
>>>> fixed buffer coalescing feature works safe and soundly.
>>>>
>>>> Testcases include read/write with single/multiple/unaligned/non-2MB
>>>> hugepage fixed buffers, and also a should-not coalesce case where
>>>> buffer is a mixture of different size'd pages.
>>>
>>> lgtm, would be even better if you can add another patch
>>> testing adding a small buffer on the left size of a hugepage,
>>> i.e. like mmap_mixutre() but the small buffer is on the other
>>> side.
>>
>> Sure, will add that.
> 
> I'll queue up this v3, but please do send that as an incremental
> patch as I agree it's a good addition

I have to add that tests are already well made, the kernel code
is not symmetric however, so it'd give us more confidence and
help to not regress in the future.

-- 
Pavel Begunkov

