Return-Path: <io-uring+bounces-8255-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E755CAD0426
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 16:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F12A3A929D
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 14:38:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FFD1494CC;
	Fri,  6 Jun 2025 14:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mKTa0PeW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0DE12C544
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 14:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749220747; cv=none; b=j0GzJiUjrBT1pwJu238MaqtWaryC8MABzHCvBKWqWRz9HBA93kmYHi8Fu2AyRVD5BmiHtMcpAxxsSq+V8EnGIa0zFManCM/Ki2QYmRq9LsgZXdf8FvbL4qWSWf6Oaz21s3GGGoBNLeXWR17x7qnVNrBewSlE+yyxjb0yFQHAgvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749220747; c=relaxed/simple;
	bh=3RlpGtfRa9bewFOs6MV3+PiSEYjbIEuBcgpZrywD4S4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aArurpCC/fJKQvH5LhhNAfLRz8k++OzaFDVKjzooBUk3YYj8v39qRLGvNDL8gwiVRodbTq+zQwRM3bUQNV9ceWHwMVI1YUYVM2b0xepOvj5HiDup3cmMyZcdGMrpaw2GEew7Fw0OyaMXnTZiLUvcl4xsPl4tpH/GD8cvFnJwXkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mKTa0PeW; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-86cdb330b48so182850339f.0
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 07:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749220744; x=1749825544; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ePD8mbSyxWI7tOm3mJrlzLEJipoLjaxPhCQo9r49Cf8=;
        b=mKTa0PeWjWcSVDM40+YtAJTOsOyqfMH3pmtRTzzSXlYGNVzR5A+RRsh/5jHgdp1GyD
         BK8zRWQdR40sbK/CLNWaZJaPf6X8yaGIlPHcZ5pOtiap1nCJFaEwmAksugXxqoiXIMu9
         Q/4W8fAXCwfYifhochJ97Z6to/ZVSJ3fuPezfwI+KTh8aZIvKEJyTFeDQL+Heycmtug/
         loT9Elme0eFcTstWi/gDI7BqIXlgQkp7d4esNhpd6JYUKYMhPd9LniOJD99kri7OgMxo
         WLUG2Hw+wyHLI77rNiPQmYpufxdQGEHDAjWEFhjFUbd/lEQ8OdlEe7W1WD+vh+qIw6Tu
         8gVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749220744; x=1749825544;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ePD8mbSyxWI7tOm3mJrlzLEJipoLjaxPhCQo9r49Cf8=;
        b=MeDYPDq09eVRW9+BFhVUHvVmovGqDTSAJ1OLJKHpeFjiJZ69pFmNfOsujbfSnd8jlK
         iF4pBa7X6zDJpoNrW/bXz5MQ8a9UUXUWkT0Fi9MGRPfD/XW5nmTZRTjjul3ZaKRv0ecA
         Tjb+GIkNHo44e2wCm169r8dpc8JIsy1rLr8Be9HyFx/tdg6904BaS+lrpi1v3KwMde22
         lx/3JbAfkldzmvklbDeKcgPqtbjXFjG9IDL6Eu5eMp4i06f7ZfPnZlTRgBaEZdnHcvld
         i/zIJ/XWonWWZBVQYV1TCvgkGmPjn7Wjm/1BGJn/xx7qsT0CVr2mfCKi4tGzhGfdnE+2
         Hi6w==
X-Forwarded-Encrypted: i=1; AJvYcCVnTAFCcleMaJW4tOkuiMPvQTu8Ex20HTGDaWqaMEAzMXVyCW9GkNQMzCTucKERHBMBysbErdxPNw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh8kX5Jlbj0FWRKLHEfvEmLafDlh8O87MODlEIvPRKhltJdu5Q
	/v+QGaM+gt0M/I3T5hoXQlLMw5Me/kVoTosVcj3O3+ue1y61nDTfI+w9pTKfI8j31zcnSs/Ogfh
	bADUU
X-Gm-Gg: ASbGncsZgl7K9A/AYqIp5z84IcPvFdkb3HM6MzK3d0dV9gavl/e7bLiP+rZ7pwGg1Ts
	WK34AV+JRqLExmEBgnIiYp0CsroYGTXIDePC5eNh2QoHbxUH+R0C2gflh/phg7JfcW2oen29uZZ
	mYNJwB4gWFU/3xggwQJGYrgVvJlkMNKtBW+/Zu548axrv+s3sfYvVTgY+dQdQHsbo9EYW4vXkzQ
	kdRlArQYr99QJiroEHA1kyehJwuE7yep1Ae8ht3BhegINKKLvbyEv6SF7uYpX8uN+uwX8l2xJOH
	qWF/1G5fNRvp7lhUGTKxj0013u8EdlUBORtCNyj0to+dCQk=
X-Google-Smtp-Source: AGHT+IEYIIwpMH1limnRPkyPHzVPpLRFlfL43w/MdnkURpLFcO0uzBblUbS83KbIhEnSklhOW03Jog==
X-Received: by 2002:a05:6602:4807:b0:86c:fea7:6b83 with SMTP id ca18e2360f4ac-8733665b1d9mr492040539f.6.1749220732743;
        Fri, 06 Jun 2025 07:38:52 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-873387843b3sm34217239f.8.2025.06.06.07.38.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 07:38:52 -0700 (PDT)
Message-ID: <36c0c06e-26fa-4395-a4cf-2a7520520187@kernel.dk>
Date: Fri, 6 Jun 2025 08:38:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 0/5] BPF controlled io_uring
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1749214572.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1749214572.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/25 7:57 AM, Pavel Begunkov wrote:
> This series adds io_uring BPF struct_ops, which allows processing
> events and submitting requests from BPF without returning to user.
> There is only one callback for now, it's called from the io_uring
> CQ waiting loop when there is an event to be processed. It also
> has access to waiting parameters like batching and timeouts.
> 
> It's tested with a program that queues a nop request, waits for
> its completion and then queues another request, repeating it N
> times. The baseline to compare with is traditional io_uring
> application doing same without BPF and using 2 requests links,
> with the same total number of requests.
> 
> # ./link 0 100000000
> type 2-LINK, requests to run 100000000
> sec 20, total (ms) 20374
> # ./link 1 100000000
> type BPF, requests to run 100000000
> sec 13, total (ms) 13700
> 
> The BPF version works ~50% faster on a mitigated kernel, while it's
> not even a completely fair comparison as links are restrictive and
> can't always be used. Without links the speedup reaches ~80%.

Nifty! Great to see the BPF side taking shape, I can think of many cool
things we could do with that. Out of curiosity, tested this on my usual
arm64 vm on the laptop:

axboe@m2max-kvm ~/g/l/examples-bpf (bpf) [1]> ./link 0 100000000
type 2-LINK, requests to run 100000000
sec 13, total (ms) 13868

axboe@m2max-kvm ~/g/l/examples-bpf (bpf)> sudo ./link 1 100000000
type BPF, requests to run 100000000
sec 4, total (ms) 4929

No mitigations or anything configured in this kernel.

I'll take a closer look at the patches.

-- 
Jens Axboe

