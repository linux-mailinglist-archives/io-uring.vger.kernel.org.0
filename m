Return-Path: <io-uring+bounces-7978-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D76BAB7291
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 19:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D691166EAB
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 17:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C76A2750E3;
	Wed, 14 May 2025 17:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XYi6JBoK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C01479DA
	for <io-uring@vger.kernel.org>; Wed, 14 May 2025 17:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747243042; cv=none; b=QkUw6xq8vEVgLuy7bEL4ZQrtKxXb8EvlR6QAcjClsSOKBkYpmIwLyf6JfqA/UjRQ5BMIiYsT1EL9KtEu8Bkw1vFFwkSM8LfsYPESDdVKiqs2JUQGTkt3GWoZM1Ojr97rilKT4NwXxbS/mAuaaFYKdXzWab7hLE0Z5Oh8ENVELQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747243042; c=relaxed/simple;
	bh=A7E2xEgiztO2wb+wzFst9ubm74oLvzEFm0c4KUWFwH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nt+1FDqFGzwDDMVuKsRQMGIqjE3Y4BbqJ2qdAiAqDPZrJ6AreB9Qyu30XWkXkOWsLavBHmMJe6WewYI6qBAD5kqsnf2GTtvl9ZxV/TlFb8zqsqSJ55gj7PZ7TxaCewSt8UnukvUmaqB7dfRulszJQjqfdwZrSFPbvS3Y1dWlQGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XYi6JBoK; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a0b7fbdde7so13289f8f.2
        for <io-uring@vger.kernel.org>; Wed, 14 May 2025 10:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747243037; x=1747847837; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h2IxYZAfXZt7haFxTNW1giLRNV3x7TIRa8PHcjU0P4Q=;
        b=XYi6JBoKKU9lQpdTBRXzVqh0wa2+yvi50Au6gzW1wweub2nCJHg9VH9HHPiwRhXhwy
         s3Bk60pqM5FDZUEI8sKo7m65tKr2iRsmSuWCmot5voHX9RqwAHkoAsP6jVyv3uZTxoUW
         OY+Xz2gB6bq5pndJ9viufhE1iI0Sbxpsharta3ydTdecMUd2RndoHm4kab9IJg3yKP3k
         lemvo3X9cJmQ6zq+D1/1gbiVp/qrhN88dkr0EIISQK89pqyYi0kjraDTgXrM6pGzPNHE
         tzjUrQjeOa1SsMp3l77336oA+3a2pJa4inpSaBDtsLPzjmCrdEx8iqVXXBjSQgmNRmfo
         Ah1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747243037; x=1747847837;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h2IxYZAfXZt7haFxTNW1giLRNV3x7TIRa8PHcjU0P4Q=;
        b=aDdnZCDdt12mjgr0n4vj5YQUgJVFU/SSnhqZARTICscgngEj019BeZQY4h0oAR46+I
         nL0lfzuXC236Pg3+UENulfJTnUgOk+i7bA/pRXdaWxyiaVmMEXoeoUWVNeHXihn3/kq1
         sKb7ZZgF5KU2hxEvtq/GwfZMUmH3C4vAsBuW0syfIGT1/BXS0eTavuYicXyLzHhM8NUo
         78J/AUWqcl32Mj+I5fjgyYXzUct4xqNEVAKKqOAE5zqG7kl2zBHZMLm4X+9i3N2j69nj
         rHZKIlTycFidWhuGr/Y8BAgW4Yk3RuobiM921+ahNe9hioOiRXX6SH9793xt+I29qbTc
         DtXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVb876Es9DphG3wbOZgdK87jwY/HvDhDDCrpNGVxYQqIPtHlX2ajYQQsWSztMN93tNznL/vIvBPQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxyMxYClxkgIgFagiIOZwS0571np4+Stuzp+q3IpvJQQcKNdlLK
	iYHo7KvNagE38rKIHfPJ89GL16+/7BzaABo1pSLSASV5+nt1J87i6t1dnQ==
X-Gm-Gg: ASbGncshx/DWIrYJ8fZ4nfmkDmYN/XUMj0eQa9L9j/Wn7Evvrj9nvhQ8XeGHWUFXBCh
	f92snyfGhZ/mnm0sstISZGRO8bFVC+54BBJv33Ro2MWA77L/H3UWd0IYiDSMbADcWuHnuRFVIbO
	X5qdwmFwyr1Ni4Q8ezmHnWggO3VOQDh3eeNjG+vGIxozUd8qCYhLC2LKFvRpTaUXs0/cWRSuItZ
	V1KGSQsBm29tDLZd8SsHlEHXioZ+TbcXvK1ThteSjm19mFQo6NN06FM6XYcvSMBUKe9NW7JM2sM
	ZLKY6nzSW1Yt4Q6AJYjfdOgMgmimtNE46PAzZMj17kAmkEs4yfxbWBHW+gY=
X-Google-Smtp-Source: AGHT+IF8UZEV7OJWq9ZdRKAJ10RIkNrAfnWEXvNfmTy2SbsuIU4P2g6yI1gEYpIs1eS2Hy/OY4INDw==
X-Received: by 2002:adf:e5cb:0:b0:3a1:1c38:b588 with SMTP id ffacd0b85a97d-3a34991f0f0mr2853555f8f.41.1747243037219;
        Wed, 14 May 2025 10:17:17 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58eb9dfsm20578851f8f.31.2025.05.14.10.17.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 10:17:16 -0700 (PDT)
Message-ID: <d63f55e8-7453-46fb-a85a-03e6de14402f@gmail.com>
Date: Wed, 14 May 2025 18:18:36 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: move locking inside overflow posting
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1747209332.git.asml.silence@gmail.com>
 <56fb1f1b3977ae5eec732bd5d39635b69a056b3e.1747209332.git.asml.silence@gmail.com>
 <d6634082-86c0-4393-b270-ede60397695e@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d6634082-86c0-4393-b270-ede60397695e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/25 17:42, Jens Axboe wrote:
> On 5/14/25 2:07 AM, Pavel Begunkov wrote:
...>> +static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, bool locked,
>> +				     u64 user_data, s32 res, u32 cflags,
>> +				     u64 extra1, u64 extra2)
>> +{
>> +	bool queued;
>> +
>> +	if (locked) {
>> +		queued = __io_cqring_event_overflow(ctx, user_data, res, cflags,
>> +						    extra1, extra2);
>> +	} else {
>> +		spin_lock(&ctx->completion_lock);
>> +		queued = __io_cqring_event_overflow(ctx, user_data, res, cflags,
>> +						    extra1, extra2);
>> +		spin_unlock(&ctx->completion_lock);
>> +	}
>> +	return queued;
>> +}
> 
> Really not a fan of passing in locking state and having a split helper
> like that.

I'd agree in general, but it's the same thing that's already in
__io_submit_flush_completions(), just with a named argument
instead of backflipping on ctx->lockless_cq.

> It's also pretty unwieldy with 7 arguments.

It's 6 vs 7, not much difference, and the real problem here is
passing all cqe parts as separate arguments, which this series
doesn't touch.

> Overall, why do we care about atomic vs non-atomic allocations for
> overflows? If you're hitting overflow, you've messed up... And if it's

Not really, it's not far fetched to overflow with multishots unless
you're overallocating CQ quite a bit, especially if traffic is not so
homogeneous and has spikes. Expensive and should be minimised b/c of
that, but it's still reasonably possible in a well structured app.

> about cost, gfp atomic alloc will be predictable, vs GFP_KERNEL which
> can be a lot more involved.

Not the cost but reliability. If overflowing fails, the userspace can't
reasonably do anything to recover, so either terminate or leak. And
it's taking the atomic reserves from those who actually need it
like irq.

-- 
Pavel Begunkov


