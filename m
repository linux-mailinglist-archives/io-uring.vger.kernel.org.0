Return-Path: <io-uring+bounces-5876-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BB37A12748
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 16:23:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E61727A12A8
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 15:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE3D1482F2;
	Wed, 15 Jan 2025 15:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DZFib0oX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408EB14A605
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 15:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736954625; cv=none; b=qaErkUq75vb+//Q1ikc7jupuX5okpl94bWOb+7KdyUNkMMJ/CUWanP/82vK6g8ftF6/LaBZpW/sQ9bLZJVcphG96uBxTGEJKLfaKf9ZKPVFQdbskYW5sfQ0hLQxPIFawq7f85oh0kOGbcuMyJLAceTASlS96bNeYDzCqYHlKj7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736954625; c=relaxed/simple;
	bh=FpbWNghr4I3oH1ZpXlgglf4cIPZC7j3EO3dFtNeqQ3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NKJBweIAGtAXjASZHZ0FLGUEk1cWb/q/uXiovotmubwC0npgHVfenevQzZMKwVeDdP60avg/6x1r5DTe44OSLyUAHUvycK+XXrgW/fEvjw70sS7adqJsm1OEcy3XnZQpUbMxOL7bH6rmPM+i5Q8BfYio7QIcnPjPgvw+G+/EMR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DZFib0oX; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-844df397754so221114739f.2
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 07:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736954621; x=1737559421; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SQITDuwTLGqqA/jrunc3wxHx18rrm4NsNZTAokS06qs=;
        b=DZFib0oXM+aoqHOlScMFg27pgZW93ZCtSMCs44AFxdiAIDtAWp+cIiNzAX9WNWy18i
         wo3Jc2Uti81xo9hHHiwPBrNDNVI1y1VBe33XTE953/MRT3f1tEnpMHQU38Du8BBsZylm
         AVytpX0jUW5VwdR4tMK1sL4KltCn5OguDgifJkz7Lr+o5aTHTvRBX2ddljdgxL/RnN0W
         +Il08kxwEtcMi7cQbmIFAxJnhknSO8zNCl66FbySLkLZwOR/k/2OsWBaDiWRqFMRJV4j
         jCVjh+zQYP7e9PVPFLVonQrEFxaAI++VeK6bC7kc7+GC1qEJDJWGV9rP3UBit+w1GKvc
         yVlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736954621; x=1737559421;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SQITDuwTLGqqA/jrunc3wxHx18rrm4NsNZTAokS06qs=;
        b=b5pmsRCdwzCXMINGDh140agVq8jNlYbma/ccMMEVjEi7BCCugmEpsMBvPF+m1+iZGj
         H0y9P11e3GsYFS4fo17/KWZD5890JynYqkvAxMsUnPnTigiIGyQXlPhDuyk60EC2Wwt0
         x6VUe+IPuTJrhL5C2Be61h6UvBTCxrCgxn73eZ+Zgdi+R3s0OU9VcaTsp55xmhTXhHcP
         DCJReF+L7MiCw36mDmOFqdGIu2yagO4KE6CaE13xUbMGV3UOiptVCRPvaLIscgChNo2Y
         sjJxXMoGNDaTfKgn8rlDbW3dIpzKRxZcLXnyJjIISSg3lfuVpXT0TzNh4Vgs6gojQG2L
         vugg==
X-Forwarded-Encrypted: i=1; AJvYcCUclZiHACC1VcrR55YyxPgh2ghJJRKQd05Kzvo/81YkrvUec8p0/dXKCNxn88qS8z+RnNkl9Zp+6w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1SOoV3mmeBY55D/LtmEyaHL6Rhg+x1CEyZTsOkXvX2Mr7XRGV
	H9WkY9EXMMjnx9bSaHFqxZOy/HsD23c4GUcuJ1OYRL2HVTccvYvS11EdRBcy+28aJFuqt9pp/0q
	/
X-Gm-Gg: ASbGnctuBRjDZo4G1fuR/jHYJ8tJDguxRqVIwNIHpleNCg/UKmD7nVuAIFAypZqYAVf
	gAF/3VojUPCmM7IBBTEqSQW+Vzq/DnoRZXh8sGcETMS/LBhEO+82K7Lht/euW3cWQZECynxpbsQ
	GsMrxdBFSyHby9fy3SgJBrRfNCHKG0uvNfKb/GOA6iEHm8Wv5lN1oBre8kavW4THoptFJWrsdlY
	+VBA3mpZDwXcuGPaVFGMiJ4IOlBcCqVXyngvg8G34JZf9ZwLCIO
X-Google-Smtp-Source: AGHT+IEwpf/Y1pi5fFJxzWkZxnCJSCrhdfX2xFxZLqXFx82QSyDTzJQYxD36oOloRcH8GeHEpriO8w==
X-Received: by 2002:a05:6e02:13ad:b0:3ce:8ed9:ca81 with SMTP id e9e14a558f8ab-3ce8ed9ce12mr8462085ab.5.1736954621276;
        Wed, 15 Jan 2025 07:23:41 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce8b096ecbsm2512055ab.36.2025.01.15.07.23.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 07:23:40 -0800 (PST)
Message-ID: <30a6d768-b1b8-4adf-8ff0-9f54edde9605@kernel.dk>
Date: Wed, 15 Jan 2025 08:23:39 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: futex+io_uring: futex_q::task can maybe be dangling (but is not
 actually accessed, so it's fine)
To: Thomas Gleixner <tglx@linutronix.de>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>,
 Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
 =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>,
 kernel list <linux-kernel@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
References: <CAG48ez2HHU+vSCcurs5TsFXiEfUhLSXbEzcugBSTBZgBWkzpuA@mail.gmail.com>
 <3b78348b-a804-4072-b088-9519353edb10@kernel.dk>
 <20250113143832.GH5388@noisy.programming.kicks-ass.net> <877c6wcra6.ffs@tglx>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <877c6wcra6.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/25 3:20 AM, Thomas Gleixner wrote:
> On Mon, Jan 13 2025 at 15:38, Peter Zijlstra wrote:
>> On Fri, Jan 10, 2025 at 08:33:34PM -0700, Jens Axboe wrote:
>>
>>> @@ -548,7 +549,7 @@ void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
>>>  
>>>  	plist_node_init(&q->list, prio);
>>>  	plist_add(&q->list, &hb->chain);
>>> -	q->task = current;
>>> +	q->task = task;
>>>  }
>>>  
>>>  /**
>>
>> The alternative is, I suppose, to move the q->task assignment out to
>> these two callsites instead. Thomas, any opinions?
> 
> That's fine as long as hb->lock is held, but the explicit argument makes
> all of this simpler to understand.
> 
> Though I'm not really a fan of this part:
> 
>> +		__futex_queue(&ifd->q, hb, NULL);
>> +		spin_unlock(&hb->lock);
> 
> Can we please add that @task argument to futex_queue() and keep the
> internals in the futex code instead of pulling more stuff into io_uring?

Sure, was trying to keep the change more minimal, but we can certainly
add it to futex_queue() instead rather than needing to work around it on
the io_uring side.

I'll be happy to send out a patch for that.

-- 
Jens Axboe

