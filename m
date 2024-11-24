Return-Path: <io-uring+bounces-5006-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B36A79D776F
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 19:41:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7944B22B51
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 16:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E822500CE;
	Sun, 24 Nov 2024 16:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Vex9+FYW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4292500C5
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 16:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732465116; cv=none; b=cAMcJbYXv38yykhp/zobWt8R6jKzaeiRsw5mVOTOZf1v0gRJPcRC9qkLfX/if8+1QLn8e+2/D+Va+CMDANaab1rlAxU4W826jHgN+1LkICvzyAn1e+pMB7HZya+nyo8bUcgICzXrkJnYiNPf9dUgsy4SX+7FBD73grAxgEYBqyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732465116; c=relaxed/simple;
	bh=v7B8jvREupHhXCAucjY97mGQ1b+GGE5IZJWjtqJmBkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QGryH4PMEmHC29d0ReJ4m4k9w+dGCtGBjhzxqGpzWtTPvyqPLnsAMOv6ejmO3jDLCaUgKtxsosVKgteTCyTpfHVDO1V1bTgy221UrhofeI7spGOIAEMvkiNZ5avFvPv3hh5O19oxf+H6bhiqYGrDA0KlGZIXNzfKYSCRVgbsx2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Vex9+FYW; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2ea45dac86eso3121350a91.3
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 08:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732465109; x=1733069909; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aU07GmllCJGIBB5FxGtft1ot5jX/ZcuqzWe6pHs9PTk=;
        b=Vex9+FYWkD7N65PWZjBy8yNCIG2hXyaAyN92kukDaNppaG+uUXm2lNcElqsNEgrMTg
         S3D2nSYaEq2FmOaAxlWk5BjqAuD/4B/dds1Y8z4oZgy4iKR+PztDZJAkr6oRzp72OQLD
         KGGPdF6Aq09+XmOHqWRfrHkyA8cMzEsUs9f8c1Wy+MvT7kgTdg8hknY9JMEO9fT1a+vr
         FqcpQBw073HCiXbcgQgCTzeVDyY2kX3eGCKylTbswiujWAYcP3SbkJwRTX/Ohk6x4A7R
         1iHOEn6xUeXKDI6eTBNZCriS3On6M+Qinu2s+t7AAUyeEMRG018nK0MJlLttO+Hvhs2I
         egfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732465109; x=1733069909;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aU07GmllCJGIBB5FxGtft1ot5jX/ZcuqzWe6pHs9PTk=;
        b=HXGSqId8rbKYwOTwkkuAz+O5M4TJE5f79NY2ZhRMGoarGHY/05fQmm7hyyZhvOm7gm
         ycbNNuu1JuwPNnfakjex8MfsEAxqjmsTQaxyi9jFfJkDGWn9bzJT07YQMm+oToAKVc40
         +p1/uFOtuaTrY0oZZvGL0QgGsXPae8dTiHg8dNa8OTYRSYjXay8Lf17d4TA8yn+zAaeH
         htJT6Suwlv1/E9IMYRtOTeat/PZH+DGD45NKI+nM9cxyvwGnkWuwDjqPG4J/0WgPZaU0
         wtdvwZiLPxurW2aS3MbI6lngAAAw5mZZtAn+yBpIZ7x6AMlZhMAM3gtsqpj2LZL5JPnq
         L+tQ==
X-Gm-Message-State: AOJu0Yxpt/8i1SGXZ+5z3dQhe66NDqYSrtGnRIgJzWJPW1GOADGXWQtb
	a28TaoDH853Rr6+Mqm5sCGD9IP34rAgWxTwS6kOiIIWT/sZ1BcCyHfAUBHVpcGUIhujj85V8Pfk
	Gffo=
X-Gm-Gg: ASbGncvivY2/YQV8q+UaSCXh3ybUetjHS0VLFmE50L0iAHpSa5XYbNwsQBemTrmdWn5
	6pkwraLCJa7yCtGGW5w0qimWPP3VKpfsqmHT/vB8LMlAM5nnqmiFIWMaIks0cQ8GvZnGFUpKRmV
	QI7El1imT3i+oUHBre7gIsMZfn6ZLK1L87pLiYL0kbGtBuNhIB6JMhyYjZVWBJR1WxGBWOp4HP2
	DkY8ifjz0aByF0KFfWYsysmAsHMFfswHbhvrjnYcbTcQHc=
X-Google-Smtp-Source: AGHT+IHjRpfdV+eZ6NcCIwuFif5JycXG0gtXJwiCYf7S5T6hDJ2aDcmlNicZFfgtuPV5XuIk+V7b+A==
X-Received: by 2002:a17:90a:c2c6:b0:2ea:d5a8:67a7 with SMTP id 98e67ed59e1d1-2eb0e02b678mr11748069a91.1.1732465109647;
        Sun, 24 Nov 2024 08:18:29 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ead0311a21sm8585820a91.14.2024.11.24.08.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Nov 2024 08:18:28 -0800 (PST)
Message-ID: <53622595-5349-414f-a4c5-785eb14a1361@kernel.dk>
Date: Sun, 24 Nov 2024 09:18:28 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIIC1uZXh0XSBpb191cmluZzogYWRkIHN1?=
 =?UTF-8?Q?pport_for_fchmod?=
To: lizetao <lizetao1@huawei.com>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "asml.silence@gmail.com" <asml.silence@gmail.com>
References: <e291085644e14b3eb4d1c3995098bf4e@huawei.com>
 <2fe3005b-279d-489d-823f-731c6a52e5b1@kernel.dk>
 <8609cb5ca3bf4d2c8018ec2339f36430@huawei.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8609cb5ca3bf4d2c8018ec2339f36430@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/23/24 5:23 AM, lizetao wrote:
> Hi
> 
>>> On 11/19/24 1:12 AM, lizetao wrote:
>>> Adds support for doing chmod through io_uring. IORING_OP_FCHMOD 
>>> behaves like fchmod(2) and takes the same arguments.
> 
>> Looks pretty straight forward. The only downside is the forced use of REQ_F_FORCE_ASYNC - did you look into how feasible it would be to allow non-blocking issue of this? Would imagine the majority of fchmod calls end up not blocking in the first place.
> 
> Yes, I considered fchmod to allow asynchronous execution and wrote a test case to test it, the results are as follows:
> 
> fchmod:
> real	0m1.413s
> user	0m0.253s
> sys	0m1.079s
> 
> io_uring + fchmod:
> real	0m1.268s
> user	0m0.015s
> sys	0m5.739s
> 
> There is about a 10% improvement.

And that makes sense if you're keeping some fchmod inflight, as you'd
generally just have one io-wq processing them and running things in
parallel with submission. But what you you keep an indepth count of 1,
eg do sync fchmod? Then it'd be considerably slower than the syscall.

This isn't necessarily something to worry about, but fact is that if you
can do a nonblock issue and have it succeed most of the time, that'll be
more efficient (and faster for low/sync fchmod) than something that just
offloads to io-wq. You can see that from your results too, comparing the
sys number netween the two.

Hence why I'm asking if you looked into doing a nonblocking issue at
all. This won't necessarily gate the inclusion of the patch, and it is
something that can be changed down the line, I'm mostly just curious.

-- 
Jens Axboe

