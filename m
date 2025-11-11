Return-Path: <io-uring+bounces-10519-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3466EC4F416
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 18:35:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D97F34E6FD3
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 17:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A0C3AA1BB;
	Tue, 11 Nov 2025 17:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="iLsp+OB0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C31365A13
	for <io-uring@vger.kernel.org>; Tue, 11 Nov 2025 17:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762882511; cv=none; b=B1Rv2r0te8vtnSwrC4fdBF9Ol2q8U/w0/3bG7OUoqziE8q3IL7uWw+Wihadm+1lP2i7B15ZNQ0+7s2o4qbs6Gx9xTXeAEbPGNd1gCf1mc7oLfjMmN0qGy7OQC1IbwwXUADYkJi9GCuXeVSqxIVoObbjV9EYpH++0hsbgq9mzZXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762882511; c=relaxed/simple;
	bh=EE+WvBsWH1KNgw2W8XtWypIxgQcREqPyb1uWJ2mPK4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fd9VZFQaf4QSvBabUIaa9nsz/l7/t7/HQABRLbrPAeXDRKs9DdxIKVDUqzETvciI67tD48OeMK3UdMiPgvuJvAA124k+1lYL0dkeXBMwl9LKLos7vjadlfaUX20xeKvzvmMOXo5/eGSqqNXxPQyD9js9efpyV9LK81FUFiXvr5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=iLsp+OB0; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7b72bfcbb26so466627b3a.0
        for <io-uring@vger.kernel.org>; Tue, 11 Nov 2025 09:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762882509; x=1763487309; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fn7wodOlLmLsT5jl+y7mwvvOyNWafbKyZT24/lhSKsU=;
        b=iLsp+OB028yaFvcgC1JvtYs5K3+FA7KMpMnCPeqJ8I4B5f7HQeHllb/9dBCMMe7bpw
         GfhucaD6wvy851iS/b8d22UI+lm54YCIbLPvrw9DaKRuMa43l/IjojTZOXZnCpdlWiXc
         OajUZPoPmh0EmEIqexG7b2H4IUspfqpJsDpGKJAnq7AT6zp66gNtECU96TVjcE3oZYQv
         ceVyLXjWcKtJQjhc+HMrUsbVbt9RKP0rpIRLb1grK+Jn8IZ4abPNdaPcMoo/8yuwZHVd
         KKNQT+icGsXhOaAn7nIfD35L8ZUxlHTgx7hvxiRkyKX0itPOkPqCraaKbWdfqHCboMZv
         3zrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762882509; x=1763487309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fn7wodOlLmLsT5jl+y7mwvvOyNWafbKyZT24/lhSKsU=;
        b=LqUr1wdbbqVJZst5wli4Q87CTUeazOL3mnf+xXQXaq6D2H/WdyXHLgnza3xJhAMdOq
         HBlZsd0TtodPqfXZFsOwq7i1qxLI99mlx669tnyS4BcCaAhTWbR8dt+YIZBOyCAcrRFd
         z5ouBLI2ONJibuXdAuT+V1bMRcnVGUfdf8OB/Szimq1gUS6p4DEWU79Lf9SNi9G4Km29
         9m0qBM3FfNiIg4VNle7OTKUc7bxB85yIXmloK4wn6GE2mbW307COUOh0GUvXIAUyE25k
         S7t4SqA7QLNhXAmtc/9Pcu6ISobYao/7WT698EFNS77zEOxPHbAS6fie7MgG7nthk3mD
         FNkw==
X-Forwarded-Encrypted: i=1; AJvYcCXUYGOBENfAl28dTtqEZxMnsmeva/kOwRyyocrHD+ixecj7wZopRO8hIZYYgAGa+ndj0Zuzc/YqDw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq5jI+zd2ol7RpVCoRM58Aa/Mpt+YTu5c2a7P5Cqh/5F48qWns
	kziHJNTZqWW70IAtwuR8skZMExzaKDROcexLkMjzTwnClbQh6GGRKWvJbUTOySgl354=
X-Gm-Gg: ASbGncvQwYnHjPgLBVSuQu9xM/3L2gTEJiWKVa9Dw1jQcJXUW8wotL6IuJcgWzPVZmq
	n7og4T9GiD2T6KBN6++X2tlOWwiDRfqqZbCw+6wDLGL7zH/uQws4BWDyA6Ld/DU0pZnl/ojeWiC
	iGTU0asrR5ds21cSi1Ksr1+kwlbnt29nwmcxQEoLg+mxbqw6NFkSkXiu0uI62idWpVJ0OyTlBfU
	eH7ixc00VLyh7eXeM3LqLyle4rgtQtVlqizu44HuOEsc43kVWO4/OnanWS7Mn2pGvp7pzq+y0Zb
	Fn6Fos4Wjj0KGG0SoA+5bhylrvi5WPCd1aT7SjDPplWt0JbRd0MKgoOcn9nLE5y/iF3TygIac2+
	rSPijsqqZLIuakMEWtx7Mm9voiAgaLhYQTFhpLaZNVticp400VsF/KfA+XZBTHBlS6yufQPgPft
	0o+9dzuX3G1MMsI4gvJjzqI+GohPTLqKM3BNvvtidVPgAkfZ3CENiijNW09pl+Nxr/UyEs
X-Google-Smtp-Source: AGHT+IEz0LrvTesjoq9sqvJhE7WDXqU+vmtvWV1dJIaEtss7fo1N4X5gKRr8bhaxc3JVEmkbc6B2QQ==
X-Received: by 2002:a05:6a00:a0e:b0:7ab:995a:46af with SMTP id d2e1a72fcca58-7b225ac9db4mr16166106b3a.4.1762882509376;
        Tue, 11 Nov 2025 09:35:09 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:c8f:b917:4342:fa09? ([2620:10d:c090:500::7:7ef1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b783087c08sm131191b3a.3.2025.11.11.09.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 09:35:09 -0800 (PST)
Message-ID: <17aaebdb-aee4-4a00-926b-847943aea14c@davidwei.uk>
Date: Tue, 11 Nov 2025 09:35:07 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] io_uring zcrx ifq sharing
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251108181423.3518005-1-dw@davidwei.uk>
 <f933fe15-6bd5-4acc-94ce-d5ce498ecf79@gmail.com>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <f933fe15-6bd5-4acc-94ce-d5ce498ecf79@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-11-11 06:40, Pavel Begunkov wrote:
> On 11/8/25 18:14, David Wei wrote:
>> Each ifq is bound to a HW RX queue with no way to share this across
>> multiple rings. It is possible that one ring will not be able to fully
>> saturate an entire HW RX queue due to userspace work. There are two ways
>> to handle more work:
>>
>>    1. Move work to other threads, but have to pay context switch overhead
>>       and cold caches.
>>    2. Add more rings with ifqs, but HW RX queues are a limited resource.
>>
>> This patchset add a way for multiple rings to share the same underlying
>> src ifq that is bound to a HW RX queue. Rings with shared ifqs can issue
>> io_recvzc on zero copy sockets, just like the src ring.
>>
>> Userspace are expected to create rings in separate threads and not
>> processes, such that all rings share the same address space. This is
>> because the sharing and synchronisation of refill rings is purely done
>> in userspace with no kernel involvement e.g. dst rings do not mmap the
>> refill ring. Also, userspace must distribute zero copy sockets steered
>> into the same HW RX queue across rings sharing the ifq.
> 
> I agree it's the simplest way to use it, but cross process sharing
> is a valid use case. I'm sure you can mmap it by guessing offset
> and you can place it into some shared memory otherwise.
> 
> The implementation lgtm. I need to give it a run, but let me
> queue it up with other dependencies.
> 

Yeah there's no reason why shm + mmap wouldn't work cross process with
the right offsets, but I do suspect that it'll be niche with most users
running iou across threads in the same process.

We can add cross process support in the future.

