Return-Path: <io-uring+bounces-3062-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C248196F5BE
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 15:47:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48495B2186A
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 13:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B601CF290;
	Fri,  6 Sep 2024 13:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aZdMBloW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6100C1CEAD3
	for <io-uring@vger.kernel.org>; Fri,  6 Sep 2024 13:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725630448; cv=none; b=n+rP/dyQQx2CQP5DxytZPiKlNMOjacI6bc5Qxxv9JLYgM9HHkhhRttmfmSQjDUik5f3gB1MG7GoGtWV9Gm//RyBO6BdsJqG3mYGg//7+nxtkOgSfFTp4mussyUiV7mqnO/s751mKVbgUj8qbFrQwJsJfsNOTtGZCq1t/Tt6+VKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725630448; c=relaxed/simple;
	bh=pIgf+7SsOpHo9YgmHRtwComDBR+t56JNvOlWZHxXxrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kc34oHFoK/eAnyg6juzsggnzhGClqZkhwJW1rl3N0bFj19ohebw+yG66+mTHb7sb53qPT158X9/YiSlsuxOQi6/YJdMJrY3XhG06CLJePzQt6OfOViZz7oONlSFELdf3AN/pJHCW8wu9gRlAMrkOXZItPVQGCsgLBPAbkyUPnAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aZdMBloW; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-718d962ad64so492569b3a.0
        for <io-uring@vger.kernel.org>; Fri, 06 Sep 2024 06:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725630447; x=1726235247; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MAKWGI3sm1Oxm3Ppx/VjAwW9wnluKyU080i1F7eUq9Q=;
        b=aZdMBloWeznHIM0HdBMmmf4UEX9ohprYJhTnM38zYldGeJJiumR85Sz0Bzk2mO+QMl
         UydGJssjPgir/FdI8rMcCDrslMjlgxtEuZpm8ZbcsH4N7/3yn60zxDRMJl4LTnKh1PT/
         jojncpTmxcXvK/wFgJMoxf6J6rCIrdfSdGG9EyMZOjyOZ05XP8U1UqWGEB/p0DQlUOSQ
         3pA0HnVVVn9pOXKK1LDQd95Tn7omz3ZjoNqcU4kwvy3le3hy9FHr4WTXrGiN54KneTyz
         EO1IgKn0kyf2DmH2FGF20WMglcLMFp0cGKjKJqCc+gLDcHnzsd+papsrIFj48lEzqJaP
         f2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725630447; x=1726235247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MAKWGI3sm1Oxm3Ppx/VjAwW9wnluKyU080i1F7eUq9Q=;
        b=cz7iLm31W6yk95kxxeu3gGDorfC6nM6Dq4dk1ktRmpODAKqsOF6n9/wh4Xa+3tDqqh
         9oMpgNw/VrRO62dT72dsuM77mcgSLjoui/91mAqIjDeUIrqt2qyensqEsqOfJOm9+vk/
         ChgFLaS0CMDys2u11qLT1UV9ogs1xcIcb159GIIC4RRRM69LwOXZZRTumA2qBBYzSlAF
         Fr/COd3nvORIdOXIs3vFathlz9QjvyIvDED3IXvmaEUsQ+Wwixw3MDeZMU9kRZC1ZZkH
         F8mT0YSmZ1KUa1LAWjs8s/KLoo5q5wi0ic9Jt18IJ1BkMVYmhUAa1sg+LKNZYEOnOHV1
         juGg==
X-Forwarded-Encrypted: i=1; AJvYcCWtLEIJG5fmCcozw9VKOd6xNAjup7ms25CfhkC5mqhYVl8Gpbv/AhWEZRoeswkV1ItLzXDNqNlzxw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOcnR1ueCkvIUv1mpTVWy78Sk5+i87ghLmsnUxa0RUPGFcqm2C
	MdWJVK63U7IxFYm+1AvGqkNFuZUMemZSk28dvODXtQajJJtpqemz8H8tGZp8SLw=
X-Google-Smtp-Source: AGHT+IFD4gaiCGNzSKi4CCQRh2XEyeaqBw4cxt3VsxUJUalI/hpnCOD/4KuNqnTydRpX3hVW6teqzQ==
X-Received: by 2002:a05:6a21:3994:b0:1cf:126c:3f6a with SMTP id adf61e73a8af0-1cf1d1c0a4fmr3303021637.27.1725630446742;
        Fri, 06 Sep 2024 06:47:26 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dadbfe829asm1572850a91.3.2024.09.06.06.47.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 06:47:26 -0700 (PDT)
Message-ID: <8633f306-f5e0-42f8-a4c6-f6f34b85844d@kernel.dk>
Date: Fri, 6 Sep 2024 07:47:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/sqpoll: inherit cpumask of creating process
To: Felix Moessbauer <felix.moessbauer@siemens.com>, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 cgroups@vger.kernel.org, dqminh@cloudflare.com, longman@redhat.com,
 adriaan.schmidt@siemens.com, florian.bezdeka@siemens.com,
 stable@vger.kernel.org
References: <20240906134433.433083-1-felix.moessbauer@siemens.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240906134433.433083-1-felix.moessbauer@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/6/24 7:44 AM, Felix Moessbauer wrote:
> The submit queue polling threads are "kernel" threads that are started

It's not a kernel thread, it's a normal userland thread that just never
exits to userspace.

> from the userland. In case the userland task is part of a cgroup with
> the cpuset controller enabled, the poller should also stay within that
> cpuset. This also holds, as the poller belongs to the same cgroup as
> the task that started it.
> 
> With the current implementation, a process can "break out" of the
> defined cpuset by creating sq pollers consuming CPU time on other CPUs,
> which is especially problematic for realtime applications.
> 
> Part of this problem was fixed in a5fc1441 by dropping the
> PF_NO_SETAFFINITY flag, but this only becomes effective after the first
> modification of the cpuset (i.e. the pollers cpuset is correct after the
> first update of the enclosing cgroups cpuset).
> 
> By inheriting the cpuset of the creating tasks, we ensure that the
> poller is created with a cpumask that is a subset of the cgroups mask.
> Inheriting the creators cpumask is reasonable, as other userland tasks
> also inherit the mask.

Looks fine to me.

-- 
Jens Axboe



