Return-Path: <io-uring+bounces-3111-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D269973A9D
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 16:53:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7FC1DB25404
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 14:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D645195FEC;
	Tue, 10 Sep 2024 14:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pfHKzftx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2CE194C79
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 14:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725979986; cv=none; b=JCAazmotUl6cIdWkA6urM34tRPVSXjrJnIFAMb4m8pd07Njg+0FDXSv5gBqO3DpoUdC93mk+kNlm3NTCUXbWgJOfrY7qBGGdL4BKQMpqGRdeBpFVRcZe4+CEpGTyLPjrZmngNL1NmkmjEqKdqNoHn7ntFgRwFQxS3A56i5KqP9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725979986; c=relaxed/simple;
	bh=3OPROinPYG66BAUMLz0K2W90EqZSjrxBstxfOOMxzAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yo4KS+pRG6sp54yVrTo1IEdLbnqKezFiD9HeCj8nUasi1nK6a8sEHzaUtt3ePC1x+tRZMgAoMo7ow1kLYh6P+o570kle7C748MvbclOKVA4rSKhNPiTAUmjFW9z5NEPRYM31ln1KWYyLB8eRhXuaVKme2dniFeXfocj8+t6/lLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pfHKzftx; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3a0220c2c6bso26070095ab.0
        for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 07:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725979984; x=1726584784; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E5Fc70nClVNFClBK/d7N6FBEhsUoSgP+e799qj2/mYg=;
        b=pfHKzftxq5+KkWdeMti08Ynm9mD9AnulORPkphYudQZmHp12KHYdoENMmOmBKKgC7F
         dG4gQVskAG8VIbgovpWx/qOTT2BwzBrU0R3Y6FmgDy+FDp+zx2Xn+vt8iRpT4h2MMSA7
         eGkZ7eSSIgLMQi/+vPp23hblkZ59UcDPxpbP8KmyyloRtwOEfO4Iia2ovrvCoA1Tehpz
         ycPiEjCV36CypGlNpRjmrm/Ew/A/6I3hGZN2aIoiDYXtyw44SBZxUZWbGunapDzSe6AM
         IQ696Jh8kB4g6MuN0p2CmGJCVMKtgBMyJy22uUHDG5Un6EpTGmkJMfzYTwOuZoYMtNHB
         HuuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725979984; x=1726584784;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E5Fc70nClVNFClBK/d7N6FBEhsUoSgP+e799qj2/mYg=;
        b=lW4ZnANWJ9pqocutNTguILOoLZc89sqfLEEVPyrGpG1W+u8owCz2w6YZkMyPE67fhh
         JkHbWgph1wA5h3RZuLZk7OZJ53vwELPNdPu+EAeBawu0DUvQhSTGXOaqFWpxHpNOjSu0
         BEF3Gy/pA3N75PCOjVAiee9ZhAouAjeR0aUF8tcLLScrGCFxIdewwRyP9ulqAC3GFlqE
         ECrM3XtZ83HOxQowKDCaOCA60cD2XLponjyFMB11koJ3WHQPTp58Qx3Ic31xwtT/eNAn
         tD0BENeXcQaXN3w3GqhZjRKSlNxvOZH5IaBGLJ0i1+D4VAV32M13Wyenmo7gsk9MzOGv
         D9qQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPyXOjM31oAnED4IVaus6lwsfeR+W6Y9NXz5QmZ6oYyOkWKXIBxrnAA+VFsJTngQyq+6ujABH45w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6aY4W6Obe5GrK110rG6Nlocz2QW3Cr/0HlFS3y4DVoZHRzbYs
	qtZ8Ewh/uf0wllLAOnf0aS4k8JF6uFd1pQwfGnSYeM4/RYsFMZuFJ8IP3TSfXCM=
X-Google-Smtp-Source: AGHT+IHaKWfN4cqnAqZaqt8tfammQulEh3IZTlHKZSFgjb5rfigxJT43Fj1kclLEAXBReBPQ+dXhqg==
X-Received: by 2002:a05:6e02:160c:b0:39b:3894:9298 with SMTP id e9e14a558f8ab-3a0521a7f5cmr146307485ab.0.1725979983722;
        Tue, 10 Sep 2024 07:53:03 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a058fe556fsm20400425ab.36.2024.09.10.07.53.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 07:53:03 -0700 (PDT)
Message-ID: <ec01745a-b102-4f6e-abc9-abd636d36319@kernel.dk>
Date: Tue, 10 Sep 2024 08:53:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] io_uring/io-wq: respect cgroup cpusets
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, cgroups@vger.kernel.org, dqminh@cloudflare.com,
 longman@redhat.com, adriaan.schmidt@siemens.com, florian.bezdeka@siemens.com
References: <20240910143320.123234-1-felix.moessbauer@siemens.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240910143320.123234-1-felix.moessbauer@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/24 8:33 AM, Felix Moessbauer wrote:
> Hi,
> 
> this series continues the affinity cleanup work started in
> io_uring/sqpoll. It has been tested against the liburing testsuite
> (make runtests), whereby the read-mshot test always fails:
> 
>   Running test read-mshot.t
>   Buffer ring register failed -22
>   test_inc 0 0 failed                                                                                                                          
>   Test read-mshot.t failed with ret 1     
> 
> However, this test also fails on a non-patched linux-next @ 
> bc83b4d1f086.

That sounds very odd... What liburing are you using? On old kernels
where provided buffer rings aren't available the test should just skip,
new ones it should pass. Only thing I can think of is that your liburing
repo isn't current?

> The test wq-aff.t succeeds if at least cpu 0,1 are in the set and
> fails otherwise. This is expected, as the test wants to pin on these
> cpus. I'll send a patch for liburing to skip that test in case this
> pre-condition is not met.
> 
> Regarding backporting: I would like to backport these patches to 6.1 as
> well, as they affect our realtime applications. However, in-between 6.1
> and next there is a major change da64d6db3bd3 ("io_uring: One wqe per
> wq"), which makes the backport tricky. While I don't think we want to
> backport this change, would a dedicated backport of the two pinning
> patches for the old multi-queue implementation have a chance to be accepted?

Let's not backport that patch, just because it's pretty invasive. It's
fine to have a separate backport patch of them for -stable, in this case
we'll have one version for stable kernels new enough to have that
change, and one for older versions. Thankfully not that many to care
about.

-- 
Jens Axboe

