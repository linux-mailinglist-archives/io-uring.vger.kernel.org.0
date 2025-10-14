Return-Path: <io-uring+bounces-10006-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEDF2BDA432
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 17:14:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C42C5805F0
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 15:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B238303A3D;
	Tue, 14 Oct 2025 15:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NLXyQw/s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96476303A04
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 15:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760454330; cv=none; b=LUrGzeK0u/aLnS+a3a5ly8DHzVShZMPfmRJhKPcpX1EQ/qTgVIefDAEccsZfalPiFbqjhgMqFv9KYWupdB57z4Do20p9ykzWLcyXNPioZUTr7nrXensYBMWCJk8wGUNk39qOen/w4TYG7vKP+FJ9mqHPw+rca7WDMyWBdTmj9XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760454330; c=relaxed/simple;
	bh=Cpeh2PobhrlkWQq//Zg3oNUV4rDlQSMY0avy4PLRJP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=m7bdBnP/jMMLIcS5ToCHfouqwvjFOffVvvou8foFnxpcHYIZZvxNs6RLW0LIbk/ogvf7X08M/qXHsIuznNgLLK65s0xEINrpVJseuSj0Drxh18NvtJxV4jNwFoWTuXbHKxNl/47Z0RECWNuWCSE0jcsjqhndVoq6IwJFG4nvfHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NLXyQw/s; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-9335a918867so546963239f.2
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 08:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760454324; x=1761059124; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=20H9qrzulYi7f8Nw/bG6Cq9N9HWvck32DkHEVmHisB0=;
        b=NLXyQw/sRcBgDaR2n7w3WGCAf+eT/McBMOyXyWEmeO/paypIfJAZ9KtpMxGB9CPauE
         oqfKDmx2kTDWP/8OAy+/l3AVW62lWg17YqGQMXbTFbmEecFK8bIUwQmqro4jR8CIj3f2
         nN4Bp8nvu0kU29t9TuqiWb6A2LAXM7MRVptsSWCX+NMxnzb41HDMjA0Hl0Pe5bON5tRb
         V1i0B4Sv0UL1hkmUEE7S9LH7k5E48uJrm89yriL/q6+pQRR3pDmIpODhNtIkNLuZza0B
         S76Y17yJ3k5cCIROsYZsT7DdIn82AbStY6uIqYcDa/I3M3cNIhQOJGh1It/E5Fe+Jb16
         YeUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760454324; x=1761059124;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=20H9qrzulYi7f8Nw/bG6Cq9N9HWvck32DkHEVmHisB0=;
        b=rfLb3ch0YtGY75CJPfolszKXgul/qP5j+yeEeSDdk1MIVtnIcpSjRyOENzvll4z3si
         q04dSzQpAyzasz7YL/l0SEIoBKlgM9at42h1NuOlctyEDKhXMzZsCTmTaLKvzXZSuz/R
         MMZ+7wr4zktdj2li/J5hbkaZ+pZAi4RAwIHmdL93+NwRhxJDwXwxXQPNSxUhgd5LbXij
         XfhmOUcHP+2PEbw1Rqe0LHElNLwTqTLp4vCdikZHV0Fziji3uy8V2/isPvbuYn5pGMrK
         v9vBFC6vg7gpMgnIuixxRj/6fwd3YLYqlSe3awpBEBramwmzgOAP8TgpYdR4u2M9UOi9
         oTXg==
X-Forwarded-Encrypted: i=1; AJvYcCUq5pBunzKvTmi7fKvd5bz3osnCQJYu2euqp2PCNUwA0dbJHBTxYUUoSy6K3gOAMGnXKWSLdjXeKg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJt1FJ5UCbpE4MNd2sXvKBAPhjp9X7lIJ7wL/6vCGvd0zFjKxe
	QPSkBIpsHnreIgQG6nUKrOGt9B9eTFCJVg6yPAWHBq/QlYZSYTI/ZPzr/lYOF991hgrkul9Rx2u
	1MSVpLsw=
X-Gm-Gg: ASbGncsJGQGzGSqkVvFwiDioMWjsdJ0clhY2t16q8io8KE2/Fgl4lmAmYKvUXUPC7DI
	g2OpLnz6cxywqYiPOzAxVfcSRJXylntysNW4q4+lnf/0Y18Jyn3ADiRl5wbCHKCebjsq6pR2xVO
	WAj2iGLtXS1TfC4g+SE+hq5AfQ0FiD79iLh/ECyUrxLxUmkUnjchqRPkbk/S8RE9XcebpG+BXr4
	5KjivLNMcCn1QKxwvtW1kd7q6ABGdYxUb62MQU5Plo4F1pt7kIGTRU9T6vU3ATHIueqr4Uxm2eQ
	hooUjKpxQ1+iKsBnq3xY+yeQOzScCc+/9oBvqI/ODs2qS/b0vO55S1bvA24jcxptrZ05lGh+w3l
	cpeuvqr7xPxDovr3lTOHq0jcXwL39mvc1H7FgOA==
X-Google-Smtp-Source: AGHT+IEXZe7/ZtKjlG3ymnWPrRgo581ArGInbVmkv+iTSj5KsjTPv6YbeANLa6/uMtT7jTPiPynNQQ==
X-Received: by 2002:a05:6602:160f:b0:913:34eb:5562 with SMTP id ca18e2360f4ac-93bd16fdf50mr3190001739f.0.1760454324509;
        Tue, 14 Oct 2025 08:05:24 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93e25a3f004sm498134439f.16.2025.10.14.08.05.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 08:05:22 -0700 (PDT)
Message-ID: <845640f0-d8a7-4fc1-aaff-334491780063@kernel.dk>
Date: Tue, 14 Oct 2025 09:05:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Introduce non circular SQ
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1760438982.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1760438982.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/14/25 4:58 AM, Pavel Begunkov wrote:
> Add a feature that makes the kernel to ignore SQ head/tail and
> always start fetching SQ entries from index 0, which helps to
> keep caches hot. See Patch 2 for more details.
> 
> liburing support:
> https://github.com/isilence/liburing.git sq-rewind
> 
> Tested by forcing liburing to enable the flag for compatible setups.
> 
> Pavel Begunkov (2):
>   io_uring: check for user passing 0 nr_submit
>   io_uring: introduce non-circular SQ
> 
>  include/uapi/linux/io_uring.h |  6 ++++++
>  io_uring/io_uring.c           | 34 +++++++++++++++++++++++++---------
>  io_uring/io_uring.h           |  3 ++-
>  3 files changed, 33 insertions(+), 10 deletions(-)

I like the concept of this, makes a lot of sense. No need to keep
churning through the entire SQ ring, when apps mostly submit a few
requests at the time. Will help cut down on cacheline usage.

Curious, do you have any numbers on this for any kind of workload?

-- 
Jens Axboe


