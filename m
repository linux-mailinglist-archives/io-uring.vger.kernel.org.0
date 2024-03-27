Return-Path: <io-uring+bounces-1247-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF3DF88EB6F
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 17:37:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 784761F250F3
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 16:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AD1714C5BE;
	Wed, 27 Mar 2024 16:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vejMc2OU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38FC12DDB3
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 16:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711557460; cv=none; b=McRtQuiiw73uiS3XmIXbg6WM7hqrS2vJEbm4im5GqbBG78pIcS6JMGzp8tmM/tkJ6zTAdwfTvb6ncNymsooHGwgyFhVMMv49UH7fZGppCbnYcvlBCOSffkhEj5zhKxeoqHwrnsKKIirO0Rfw+LSjY8iue0BDXTRRQnHwuRIswpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711557460; c=relaxed/simple;
	bh=TEG1e94m/bUNlZRjJ1sJ/gbG8aIPCEOwWg/YIdpUCTw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=FnWU1tqFPh3dDFq7UMz4PI+fbxrXv26mDKOr529CskolHX7Q63rm4a/JaH87MdWe4/9fD8bUSxMujz2uHkJK1/iAfkPFa/NANNmSCWcq7ODGhLIJPW3t1JLUEPbLAiAappMY1/ur3wXi88YxymNvhrYWiKv+SgPQK1s4VH4eyg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vejMc2OU; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-29f66c9ffa5so13402a91.0
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 09:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711557458; x=1712162258; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=atAzS9HVhZDmACSs1Df8kMl3QQHQ971RSbvTF8gyH+g=;
        b=vejMc2OUoDeXr4VAttnP8rUcPepCr8112n/1+SZI9Yc47HVMfskX1tOKCgdlRwMYWm
         pAxJO41Q+HR8lj2TKx6JbZ3isiCFHNiT8bJp3+Kly8dqUNAVWG2jvR5P8tTxyX/WyLRt
         6UwXUHmqy09SbBgL1HKYo+Pq1btZfjTG+UUcEzLMOv8yVkKmomp1NTH6SXo4CJgHy/gZ
         GTVExFfU5QNB1e/3FPAeQYgTrxh1tXHiEYpKiIxE6u1+ITy/sSDvpT4H3YNFSYDFn5uR
         G8c7P6OlBjipLzzBmEfZSun1X+N/zx1qUe4B2sJnRQw8h+T+JftB5bXaBVBKWr/eVqlb
         Lpmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711557458; x=1712162258;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=atAzS9HVhZDmACSs1Df8kMl3QQHQ971RSbvTF8gyH+g=;
        b=UNxzzAZ9RJAdLPikeJGXUFF/mAJ6fHWPlAfT1ka2v41yeh+4khanpc605qW9TiYb+E
         mNO/1Z8hUH6Vn6ulbWBcl89or1I8VhTpYIa7wPwjb4ni/uZ9Pf4Du4tYPQoo7d0jhegm
         m3Yhbqv61DF7ualcY23hQ2FYL0YX2xABv0JQMA9hhBa/bzLnZFN08qmjB/K346MqIsdk
         p4q1zSaLhnRCkLu7HxvXPKeNeIQZmLySEGzX7MMnPDINcrD0kSlHSsDPxdhQWqqTBmGT
         0utOquL6wwiDjnDuRWKPqvgUSfmXFqnRb48f9XhV+lj87wL1/D+rRhu8D5iERlrtrQDx
         N1kQ==
X-Forwarded-Encrypted: i=1; AJvYcCXb51RNy3d8giuXsSZ/jYao5+ajNXyydz4i7gfTqdrf6xIr6FRPL0lKaS6umRPb98NZZF4ZJJT0Ng1ipISkXNd4XHfnHG6+Bis=
X-Gm-Message-State: AOJu0YxXRei1pp0DOj0V/ayVNCAuxQolBT+G+6u7+A+/ePGHZ6UM/j6n
	oyHYd2qJ2ULfXUUPiEskU3b6R1WLxp6c6GgrSpCTgNrY4m+GuOWh9pttksW/eJU=
X-Google-Smtp-Source: AGHT+IH7G8G/uJfLPBXIfiomMCIq9YqYqDt1muJnlfFEHHXyukML8pwFWlkLfMT8l1sHB2kIeD+cCw==
X-Received: by 2002:a17:90b:2289:b0:29f:718b:16b2 with SMTP id kx9-20020a17090b228900b0029f718b16b2mr219439pjb.0.1711557458129;
        Wed, 27 Mar 2024 09:37:38 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:5ff4])
        by smtp.gmail.com with ESMTPSA id k6-20020a17090a658600b0029bc1c931d9sm1905155pjj.51.2024.03.27.09.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 09:37:37 -0700 (PDT)
Message-ID: <bb1b7259-5112-4c9b-a5f4-b5d9d95cfe68@kernel.dk>
Date: Wed, 27 Mar 2024 10:37:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: switch deferred task_work to an
 io_wq_work_list
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240326184615.458820-1-axboe@kernel.dk>
 <20240326184615.458820-3-axboe@kernel.dk>
 <22f87633-9efa-4cd2-ab5d-e6d225b28ad5@gmail.com>
 <7662a22e-caeb-4ffd-a4ee-482ff809e628@kernel.dk>
In-Reply-To: <7662a22e-caeb-4ffd-a4ee-482ff809e628@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/27/24 9:45 AM, Jens Axboe wrote:
>> smp_mb(), see the comment below, and fwiw "_after_atomic" would not
>> work.
> 
> For this one, I think all we need to do is have the wq_list_empty()
> check be fully stable. If we read:
> 
> nr_wait = atomic_read(&ctx->cq_wait_nr);
> 
> right before a waiter does:
> 
> atomic_set(&ctx->cq_wait_nr, foo);
> set_current_state(TASK_INTERRUPTIBLE);
> 
> then we need to ensure that the "I have work" check in
> io_cqring_wait_schedule() sees the work. The spin_unlock() has release
> semantics, and the current READ_ONCE() for work check sbould be enough,
> no?

To answer my own question - no, it's not enough. Let me think about this
a bit.

-- 
Jens Axboe


