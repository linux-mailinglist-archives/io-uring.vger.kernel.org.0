Return-Path: <io-uring+bounces-6509-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 712E1A3A45C
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 18:32:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 317F9167CBF
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 17:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DE2A26B97A;
	Tue, 18 Feb 2025 17:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uoQmn257"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9451F9F5C
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739899919; cv=none; b=VfgOjbHvrStGb8Fp43Vn4eHXC8fRU7PDhEKAenLyDDzvXFE9MHVvDMmuhaZT2SN7yQPEELSYhJ0p6GRUVuay0F6SHekTlW1cGjiKFTk86h594Nt+S1OphJ6PHgB6q8Rmkc1nMCizbpLTI9+hnjUcT6WgrDSXt9Mvc8lRwU1MB2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739899919; c=relaxed/simple;
	bh=1YAPWH83wSAcYyAWGFq/tuTWa7gALdzyKXsBcpaaGSQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LImo7hC5lM54Vps8/03uH5c5XbdbIDPmelrxUXyWDmF07srFG37lQrmpbcdqvnzfHkrtPBSM+TGa1nD6wz7JBpVRArw0A3M0AWqK50vw8vRBO2mmlM155DkSHm1G/1PlCitJCPC47V+9lCqRIdHjGrh9udD5yp0kXzw3ctLDOC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uoQmn257; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-855a5aa9360so68192639f.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 09:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739899915; x=1740504715; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TUlFyiqKfoEydb4AfzSnISLsv6JpK8hWkLCP44n3mgE=;
        b=uoQmn257BVjObjSYs+ISQZaNcaQe4TfEZG3Gs+ef3KOD3qHcV4nvoxCvBXR9BIF9mb
         57deG52+pONcEAgb46G2rMgWdWroVI/qqzqu58IU09izk0agRIjmC2x80iRspRSGkDA1
         zzGI1BRe4GyJgww/6bY8uWUiGntALXhfkcZAcHU9gR7j6kGj36wgKI3HNUusRn76Aco8
         61n1vIviA7ad1lxl0qKE1Lv93Jbcnoy34N+iC0A3ojw42J+Mq83L2ywWUeYu2ZfQC0eH
         2mz0SKe5y9X3x4Mqzwo+Jg3qB9v1/2EEQXSnXnwSK+GYQqgIpRkfAcLnmT9to8939/+3
         DD6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739899915; x=1740504715;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TUlFyiqKfoEydb4AfzSnISLsv6JpK8hWkLCP44n3mgE=;
        b=ETIkhci1L2l6cGrHliwvO1sr0QmetpgEb2ZwD6SK/9itGtaWnMIQKcPNH4kN3rUqyQ
         4TlDDR6aUP/3+JGPdJxmAwuwIIWWXaVHRpGFGaETHzobROh2R68HwicDZ8Ye2gD4OVw3
         F0eUQ6+iqh1hPX9COJ6Rwfw/J2BrvsRmIFlA+r7dRVqr6Q3DgZe/Ms/8DClxTFPi1KB8
         7LPQRTvaPEUUKkAjCp6JlkeSHTtkfDjQoqeEQeBRsrpHPTeoGUO4HiOZ/xFn4oopRMgg
         Aq1gXL9M2csMVm5gElR4qrHgIgcfm0lBDTsQcz+eRlElqqelbtM8iBN4/iPLjI353i2e
         A3/g==
X-Forwarded-Encrypted: i=1; AJvYcCW9Aw8moMgERoxfUqZBjwvc0Dj879cUfW64S70p5c1iE/IZKaQD7x7/YboAiMqHrl+dbZDkxCWi4w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwdwpFzkKmII3efC/6gfsxIDvU8HZI+uLh1jl26OKh6dMOu1idc
	Wx96ZvpIti1WE8Zz+Y6GFEkYDp+KZGPWaDlf22v8/Krbj5NYgStPJlWIWbG+fqmkpIL3DI7WpZE
	J
X-Gm-Gg: ASbGncuwuF362OA56+e1Q5w28CRkvDa4c7/A9E97F1ws8yWjLB0cGYtk7hCOVOi6Q24
	vndmhEpOSh76Xa4rYKHZb75Ymbs5VMTX8VuQDBrPNMEUlPocOjk60sI1DKY8P5md7HV42cOe84A
	WBhln5kFfHrEixJwI7Z2/OPKnEkPqIyTsd0HmhOtPAVLZ+d7ujNfi0bRtqy0OKTwmCFZX/KeJvV
	lN0cglcackA5lBXyeCZSC/A6Qo/uQ06Pwh2/VDBA1ZgBdpquoYfHVw0m/ZEPKcbef0YwgL+XJSD
	Ev654x/NZAhu
X-Google-Smtp-Source: AGHT+IG9UBtM80Gz60Wg9EzJCPAOnxXpXMPdCw2IZbILcJCxZxRdWOnHsqM6A1WCKC8/nw0eLlhUjQ==
X-Received: by 2002:a05:6602:6408:b0:855:5072:d940 with SMTP id ca18e2360f4ac-8557a156632mr1358292939f.13.1739899915207;
        Tue, 18 Feb 2025 09:31:55 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8559e0bececsm62201639f.33.2025.02.18.09.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 09:31:54 -0800 (PST)
Message-ID: <5bf694df-0f40-492b-954f-2bc543264c3b@kernel.dk>
Date: Tue, 18 Feb 2025 10:31:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1 0/3] add basic zero copy receive support
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20250215041857.2108684-1-dw@davidwei.uk>
 <98e2abcc-c5b4-40e9-942e-30b1a438e5ed@kernel.dk>
 <c1738f1a-3b43-43bd-8d21-e76c4db43c58@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c1738f1a-3b43-43bd-8d21-e76c4db43c58@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/18/25 10:30 AM, David Wei wrote:
> On 2025-02-18 09:01, Jens Axboe wrote:
>> On 2/14/25 9:18 PM, David Wei wrote:
>>> Add basic support for io_uring zero copy receive in liburing. Besides
>>> the mandatory syncing of necessary liburing.h headers, add a thin
>>> wrapper around the registration op and a unit test.
>>>
>>> Users still need to setup by hand e.g. mmap, setup the registration
>>> structs, do the registration and then setup the refill queue struct
>>> io_uring_zcrx_rq.
>>>
>>> In the future, I'll add code to hide the implementation details. But for
>>> now, this unblocks the kernel selftest.
>>
>> man pages coming for this too?
>>
> 
> I'm working on higher level abstractions so that users hopefully won't
> need to call it directly. Could I defer manpages until these take shape?

Yep that's fine, thanks!

-- 
Jens Axboe


