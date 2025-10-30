Return-Path: <io-uring+bounces-10292-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28D25C1DFE9
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 02:10:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B34CA3AE6DE
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 01:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB6023F439;
	Thu, 30 Oct 2025 01:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="UKWl2KFs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027BA1EDA0B
	for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 01:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761786599; cv=none; b=QxsuMEwjp3cyVt+qcPBcNv+StDDsWKaZEQKmr+vsUM9QiPKMwAburc4FXZlkp+KosX+h9IKWEkBIBJ50XU5pS3TIlhMyAaNqaUt/URJ+PjzgIUB09955LU3JZtnmiwX9IxOJjnX9RtFITrozZbB2c6RJ5oC1/pHooH6lvuUYH/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761786599; c=relaxed/simple;
	bh=D9Tme8q5q4e3sQxmpprJdpD+KQi5drqo8UZE60PpdhA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CFX6r2oiegHoSV1mKfvK9v5HMrHNnsS/uRuVwcYJFjnLYBJ2Un1dvsXJK3hqkEde5K/agzoCXG0LJJwdzLqtlUeEqEl5AAKm6mDYrszOkm0gGnm8OBwNxdB99nPabh27tT4vCVhJLe+qQFJGtwf3LfYiFRYtRYBl+Gdb/AyXi3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=UKWl2KFs; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-34029a194bcso608367a91.0
        for <io-uring@vger.kernel.org>; Wed, 29 Oct 2025 18:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761786597; x=1762391397; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9ZXkePErff/X7w1mCruG+ZVnzr8ox/6PFM/DVB8//m0=;
        b=UKWl2KFsFYd+n80UyCQm6BipqIQ99WCk8ba7UzQNbDQGPTOense90GaLj0Xy+/hJQc
         pA6aaLJ46NBkJW6M1bP7/XLsv++t86O4C1FofLFt76m8VDLI273CTwYXnBQi4RFM0dav
         rF9e5x0FcOO3RP3yArbOCsqWmxSBB49D82n1iLCREPTcGTWX64qaO2FWCt3e8syA6hmm
         NWmB79tE1xcVLhIb2teZcE7QD/4cFAq7+HBbKHK/KuEC3ydyzLtvccCVFOyC/Pta54OB
         fcPY84Y0QFMRhU5CblwGJq55sm3WHAUPb6sO7rxfiOFDn58+yMz388e4UwN57E520cqd
         QV/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761786597; x=1762391397;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ZXkePErff/X7w1mCruG+ZVnzr8ox/6PFM/DVB8//m0=;
        b=nTSwjyAGuy08GGUsrBvGK1ka8usaWIu6mj40pLkK56LpOWtsfj7rRZ4laYPW6rJrXU
         6LQCuo/KyHSU1h5vk8vEvNxVfFGv5ojLGIhYvgxPmYC1v2rqGo37r3Us+Nv+ueBnCUT+
         3A6zUf9BHQARAbNrz216rl3+lr1g4rhZBH15B60+gV4fJWW5dFUCQtoBagmkWIjgoZAr
         lRAovsEAZzPUzdxt+JCCrLqz7ZEa9ZM/PGRqgDSodtIUX0Z1OZ0hv18EGBiehgjMraSR
         QLBN8BVVvxlCNbCVYnj0E9vAqIP28F9PUTuWXzkQfedlTBL8hX05EIQfAUdmTARwVeQ+
         wZuw==
X-Gm-Message-State: AOJu0YyJIg5zF9hsWG4RtamOKHLMWWFf+QgOqz4q4vv37zvJqwh1oOXW
	Q38QKcxB9YbMP8LyUSU7lHr2DX1ufAs+Yivi87g0I56cwBu/pV/6gytAVEZ7ZSDt6Wc=
X-Gm-Gg: ASbGncs/3zbqaMXKdmcuLIeQ77kjXEIYTzBt+VFxGmW98YcKLumhBazGUyDezggR1hW
	zJgt6BJa6Qdp8Wnpa/IimPZ8PKjLFgx/VXVieChUfhRbjoMKmMvVrC8NQ4jT0P2Lp8Yr5p61duO
	EM91kdukTMMzyGTAJ0NkrpvpJ9I91ivK8HpfdD4/hMDUyLzheimrkJ+0q92OIeAtXhLez6WtXQq
	/itojzlZ2c9MSzI/CPbupfGSxQ2nXykWKIBbR1SypdWYwTYw/ItWOloDb7lG2Ozon1t87C5yrqf
	vkCUYlEPrbUweinHvOdu5eWVEYzLRwUp3uBthKTHraD09YtY8921W6c55qeHfNRFd83RHbYj4in
	zEGz5uD7fpnZlBm4Fvwxi5T6Cp1Atu/L+ll/GLciOmd1+SaDwffB7a0NMlvTnKMlgpy+VGpX54e
	1GVQRvL32zSj+yROv4NoXEgTHq329RHAIcfoB8HTE=
X-Google-Smtp-Source: AGHT+IFnlVfY8DVFhe9uMkmdmncjLOn8LIsq1MiGRK386r+K+cPBJjGdv1pTqeoka32t8RKLLu9aQQ==
X-Received: by 2002:a17:90b:4e8e:b0:330:6d5e:f17e with SMTP id 98e67ed59e1d1-3403a299f98mr5702054a91.24.1761786597207;
        Wed, 29 Oct 2025 18:09:57 -0700 (PDT)
Received: from [192.168.86.109] ([136.27.45.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3402942f298sm3370583a91.5.2025.10.29.18.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 18:09:56 -0700 (PDT)
Message-ID: <3801c040-e6b4-4c09-b711-b94f3bdc8250@davidwei.uk>
Date: Wed, 29 Oct 2025 18:09:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] net: export netdev_get_by_index_lock()
To: Jakub Kicinski <kuba@kernel.org>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
References: <20251029231654.1156874-1-dw@davidwei.uk>
 <20251029231654.1156874-2-dw@davidwei.uk>
 <20251029165143.30704d62@kernel.org>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20251029165143.30704d62@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-10-29 16:51, Jakub Kicinski wrote:
> On Wed, 29 Oct 2025 16:16:53 -0700 David Wei wrote:
>> +EXPORT_SYMBOL(netdev_get_by_index_lock);
> 
> I don't think io_uring can be a module? No need to export

Got it, will remove.

