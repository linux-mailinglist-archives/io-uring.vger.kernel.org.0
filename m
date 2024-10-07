Return-Path: <io-uring+bounces-3459-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82CE9993A36
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E96F1F2477C
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 878E418D621;
	Mon,  7 Oct 2024 22:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fcf59brg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99D118B482
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728340175; cv=none; b=tyOOgTa8PigbocKyOsn0lUHdFfIF38bEmO3Dck0xknJqoczmis8SeUhXbp144n0VXH/7YwuYwL9Ra/rtY8+cSJ9r6t7IwyJd6uLa5AerxrFaLCPDlW2mtEhlXJU563l2m4CJtxWoL+NmOAzZ6gsytf8L60nG5nWHECbaFgWtBc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728340175; c=relaxed/simple;
	bh=dFBGJ7Fkq5TiDATvU9vo7164l+g2CBClix4Hq87gImE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B/jDh6u3/01e1E9N1S1JrNzl+UUH8cB1l7W/BqiCO2bFKl9Qj5TfdK6OwJW7Uh36+3j0LVEmdKmkpjPyuEy9dTlH3kysQqRdkaQjTsjqKLgHwC6l1u/T75NS6vrkKGLKFaVNrqeUizeUAgkifOBVrzf8FhkuZF7Ji0jimWmsbEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fcf59brg; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-20bcae5e482so43270125ad.0
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728340171; x=1728944971; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u7Yr4WO6vKFC515dnzWPLRRBdfJDGWgI8I6HVaT96bc=;
        b=fcf59brg4H5iQuVla2nfg/+lzvVh9+OkxVEBNmuaqRXaiOv7sIA4wMmOyx3qPJX8bR
         NPN/PV4jIgfSdAeIOcwig8OpQoFu0Iw8bLJignJMk6O2qBFFUYiJn8OC8AQ0AQDlT7/t
         ztJycwjlix6+o1X2BO/FtLjPAHqHAYC+SUwootFBmNDJ4qPrO1MJkz2HAzZ0DXDVvamk
         n29reW/0I2JDO1X5OluGtZ2a0cAdazcAYZZpvvuehE/a9X/42nrGa821/z5RKwR7uUcw
         Irdt+hMipYAIUXm1lJuSRXxjIUMgb2POaesEg19itoi0wNuAs77xiCAfWnJ6k2E5qxiD
         v+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728340171; x=1728944971;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u7Yr4WO6vKFC515dnzWPLRRBdfJDGWgI8I6HVaT96bc=;
        b=lxO/4TQ2xIrJCCGhwh8B0lG9BEPFEMGum73itID6A9R+PLQ/Z8G8US2Yze6vsaWAWN
         OQelPBU2pZjtT4x9DX9NQ7lmum+BXI323LIqofWI+Ae/yvfdl5wqeLG7p3DSiT7TzXm4
         Es4q+t6H6OjkghBxu2WkDbC8BzRTf6JqNHzIFSfAQ63mez+qDLtee7qPqIxMZr+fZlyw
         ZDq+tiKEr1UII5xQd58p5+gtCfaNm3CiDASkNPQXNlQMi/84M19mX9Ks1qbkCNGoz+0e
         00W4BUQPUBu3C1NfOKCMUPbSvHkr23qr9qZt9PzCuHDihNn/yOnJ7TX95IU5KYHhvPMm
         mHTw==
X-Forwarded-Encrypted: i=1; AJvYcCUtuI9wtgJ2ZtO9RiXTZaPYGv4bSqRcWv6vGEAViEEVPTUH7WQuia21WVODgg5FBLBvKSvgIp5xyg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2NM1qC5T+Euew7dQ8ptBUJdFrE6p97/+rYAjy2pmUFjAQs+dq
	yMmCxQifEtea2JkhYQzsjGA/CsSmsqrbkdp7xQT+8isg8rL1mKVEABlIROOwtnM=
X-Google-Smtp-Source: AGHT+IH5NEobdxwS04ehz34YXVr2JyGbv2t0wb0CI25E+GEqKPdOzfpWGeUld/PYfzZktVocnX+3fQ==
X-Received: by 2002:a17:902:f68a:b0:205:4721:19c with SMTP id d9443c01a7336-20bff1944a8mr137708025ad.37.1728340171233;
        Mon, 07 Oct 2024 15:29:31 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c13990b52sm44234165ad.281.2024.10.07.15.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 15:29:30 -0700 (PDT)
Message-ID: <2da6c045-3e55-4137-b646-f2da69032fff@kernel.dk>
Date: Mon, 7 Oct 2024 16:29:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] replace do_setxattr() with saner helpers.
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org,
 io-uring@vger.kernel.org, cgzones@googlemail.com
References: <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
 <20241002012230.4174585-5-viro@zeniv.linux.org.uk>
 <12334e67-80a6-4509-9826-90d16483835e@kernel.dk>
 <20241002020857.GC4017910@ZenIV>
 <a2730d25-3998-4d76-8c12-dde7ce1be719@kernel.dk>
 <20241002211939.GE4017910@ZenIV>
 <d69b33f9-31a0-4c70-baf2-a72dc28139e0@kernel.dk>
 <20241006052859.GD4017910@ZenIV>
 <69e696d7-637a-4cb2-912c-6066d23afd72@kernel.dk>
 <965e59b5-615a-4d20-bb04-a462c33ad84b@kernel.dk>
 <20241007212034.GS4017910@ZenIV>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241007212034.GS4017910@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/7/24 3:20 PM, Al Viro wrote:
> On Mon, Oct 07, 2024 at 12:20:20PM -0600, Jens Axboe wrote:
>> On 10/7/24 12:09 PM, Jens Axboe wrote:
>>>>>> Questions on the io_uring side:
>>>>>> 	* you usually reject REQ_F_FIXED_FILE for ...at() at ->prep() time.
>>>>>> Fine, but... what's the point of doing that in IORING_OP_FGETXATTR case?
>>>>>> Or IORING_OP_GETXATTR, for that matter, since you pass AT_FDCWD anyway...
>>>>>> Am I missing something subtle here?
>>>>>
>>>>> Right, it could be allowed for fgetxattr on the io_uring side. Anything
>>>>> that passes in a struct file would be fair game to enable it on.
>>>>> Anything that passes in a path (eg a non-fd value), it obviously
>>>>> wouldn't make sense anyway.
>>>>
>>>> OK, done and force-pushed into #work.xattr.
>>>
>>> I just checked, and while I think this is fine to do for the 'fd' taking
>>> {s,g}etxattr, I don't think the path taking ones should allow
>>> IOSQE_FIXED_FILE being set. It's nonsensical, as they don't take a file
>>> descriptor. So I'd prefer if we kept it to just the f* variants. I can
>>> just make this tweak in my io_uring 6.12 branch and get it upstream this
>>> week, that'll take it out of your hands.
>>>
>>> What do you think?
>>
>> Like the below. You can update yours if you want, or I can shove this
>> into 6.12, whatever is the easiest for you.
> 
> Can I put your s-o-b on that, with e.g.
> 
> io_uring: IORING_OP_F[GS]ETXATTR is fine with REQ_F_FIXED_FILE
> 
> Rejection of IOSQE_FIXED_FILE combined with IORING_OP_[GS]ETXATTR
> is fine - these do not take a file descriptor, so such combination
> makes no sense.  The checks are misplaced, though - as it is, they
> triggers on IORING_OP_F[GS]ETXATTR as well, and those do take 
> a file reference, no matter the origin. 

Yep that's perfect, officially:

Signed-off-by: Jens Axboe <axboe@kernel.dk>

Thanks Al!

-- 
Jens Axboe

