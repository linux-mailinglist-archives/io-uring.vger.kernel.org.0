Return-Path: <io-uring+bounces-9729-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4A65B52C78
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 11:01:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC90F3BA53A
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 09:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2410B1D8DFB;
	Thu, 11 Sep 2025 09:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="exHMaFOA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E662C11C4
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 09:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757581262; cv=none; b=uS40yPwjBEFFpTwkUAvp1oOHHTnFFbOEzcnPiN8coQNv/8VED+zmSEFgVrm54D5ZmpViYWYRjVyRckToxkNO4v6sXawjLCF3SMyUJ17KZR/pni0krvgPebNc0VMpANZwqmxuvovcHYZetTnvSmrrI+VLvReMUq4GTQ3ZCJrUzdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757581262; c=relaxed/simple;
	bh=rdjsYcKkP4baopKCm/ifiiwiGjW8NcxAhe7g5Go/RVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lty+IzS1uDVV+kVpfx1fdwUWmFDWZA3WYwCnsqK6T96CW5vdibG9TqpNvIh9ZPZ3yumQxKF4PsIM6Pb30mdErNXylFN3r9RA/Q/FwlodFFkkufn0Uh7iJnRYw7XJmRlv8no9EGoztrNlth4z8iq/RzcjaBqbp1MsO3hEApZscOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=exHMaFOA; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45b4d89217aso3271945e9.2
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 02:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757581259; x=1758186059; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zhM7ZmLxn+eicBvx3dPx56UpzmtuJH2koGti2p1nI54=;
        b=exHMaFOA7jObb/CSPo1pt22LKxZQ8sWrGDlaOTEU34A1yzMVxtKlzFvZ1y8eLSxRNB
         8UqEhvn4gnOdlzBXMY7P4pOBQMkz4gbdCLZIMHxb7myc4VFQMhXZ2N7zPXIfAoNINzmC
         M2cP769YuqYBQjax0aarqKK6qm3C5KBP6I6NmT1WCsbZro2bnhKod+GPIBJFEg1e5ble
         yx3dZxPPtfFTtg9q1g5lCtbXtMwpoUNN6GSpsvW/gKa3LPQhUgl/A1ZwH6kZsZ+I3Sif
         T0K1YCT+A79bGy781bCPMaywa8m0fx2qyldH9groApicY5vShOe2nIZPg75YJX640s6+
         V9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757581259; x=1758186059;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zhM7ZmLxn+eicBvx3dPx56UpzmtuJH2koGti2p1nI54=;
        b=hCXA9JOTg6qnzCCGvtYArnnB9UJDets0JxRBeQ9ekirT7k+zq63BaDbzeJ3c24KSQi
         vG6Mwxxan/asycEHjICZYm/pH9+lsDpknT2JJ1d6mvVKBsf+2frn3rkuhEABEdoVn4lx
         ffMdrYp1cPnYqPNN8rDLlx+M/ozOACcv9rot9R/qsVndY+vr2CtmlT+z0cmCUh+FP+Jh
         XNzpKk6oSOIbsxc1evCIEAyl0hp5xgcH1OuZ5en5jzbM5csDz/5tZt6sSjlvydoWvyGX
         vYL0onqm8iCb2MwJJH9QXVQWmOVvTZJsWzi/Gec4oW3pRSNQ8uB2XsmvSuUoBq5k8Yvf
         OCRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXE+KF32gOK8GFtTHoZEnmEUNLHsN6F82sXCPlx8MhY2eAcXc1D4+NHpuD2ZYZ4oJ3u0dTmqglww==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6zJ1AXgkkxnGWZ3n/1SKVzHFSvuYBMijjcWztAL12WhVj07nk
	FHQpuVIa4IS3Ym2TARYz1TnK82wz5ZmAjuonjtXi9vmazmMIZ8KlWCcsDrk9Tw==
X-Gm-Gg: ASbGnctRhmn5XFUxNy8Up6REbIOIqFOQwtbcfWipctVtwtssGe5pkp830e+2xKpVvdJ
	YVDVB++vWWJnbRoC0dSLTuFZx40nCPLGjeKciLAzg0n9vn1EVZzrI3JJRgW6UQKxIX6okCGOoc/
	zpjnteNwkWwLhARVdXPAEFtWXjw9ko4V7DNDq9F0l5dGtr9OYeNDUKxZ0ZPKjELuBoh9GNCDkjS
	NWzfY2IuS9kWgi1lvA5P+pfzHXzbJikWlL/+Q1nN+4hjSSUu/YOGop0jsfFIhMfyTDoanm7GZIJ
	8LiWqlQimS5FA+AVyQNQkHr+liCf8txdz7B2Bzv+3B9S5J+MuJI5NQkR8DYafCsLUVy0hwQBPYE
	Zx0ZCc5vIRF2cUmEaf1NZIE3eqqmYl9mkvl7wVTzLhRYF/9s3KYuDYALp+2tsCTSM/g==
X-Google-Smtp-Source: AGHT+IGH+Vd77T4UMxa7FFPJgkQ7kcC//GQ8zmS9dy7xUQIElDR8SdP8PC4Vqa1YYVTmEV4VsuJTZw==
X-Received: by 2002:a05:600c:1f14:b0:45b:97e0:22a8 with SMTP id 5b1f17b1804b1-45dddecda9bmr158706665e9.22.1757581258317;
        Thu, 11 Sep 2025 02:00:58 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:a309])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607d822fsm1620059f8f.53.2025.09.11.02.00.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 02:00:57 -0700 (PDT)
Message-ID: <a686490e-03f0-4f21-a8d6-47451562682a@gmail.com>
Date: Thu, 11 Sep 2025 10:02:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] io_uring/query: check for loops in in_query()
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <2a4811de-1e35-428d-8784-a162c0e4ea8f@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2a4811de-1e35-428d-8784-a162c0e4ea8f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/25 01:13, Jens Axboe wrote:
> io_query() loops over query items that the application or liburing
> passes in. But it has no checking for a max number of items, or if a
> loop could be present. If someone were to do:
> 
>          struct io_uring_query_hdr hdr1, hdr2, hdr3;
> 
>          hdr3.next_entry = &hdr1;
>          hdr2.next_entry = &hdr3;
>          hdr1.next_entry = &hdr2;
> 
>          io_uring_register(fd, IORING_REGISTER_QUERY, &hdr1, 0);
> 
> then it'll happily loop forever and process hdr1 -> hdr2 -> hdr3 and
> then loop back to hdr1.
> 
> Add a max cap for these kinds of cases, which is arbitrarily set to
> 1024 as well. Since there's now a cap, it seems that it would be saner
> to have this interface return the number of items processed. Eg 0..N
> for success, and < 0 for an error. Then if someone does need to query
> more than the supported number of items, they can do so iteratively.

That worsens usability. The user would have to know / count how
many entries there was in the first place, retry, and do all
handling. It'll be better to:

if (nr > (1U << 20))
	return -ERANGE;
if (fatal_signal_pending())
	return -EINTR;
...
return 0;


1M should be high enough for future proofing and to protect from
mildly insane users (and would still be fast enough). I also had
cond_resched() in some version, but apparently it got lost as
well.

-- 
Pavel Begunkov


