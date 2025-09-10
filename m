Return-Path: <io-uring+bounces-9703-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A46B51633
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 13:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D837F7A704D
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 11:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8A425A355;
	Wed, 10 Sep 2025 11:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HqBlb69r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72E628641D;
	Wed, 10 Sep 2025 11:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757505402; cv=none; b=be8ElOO5Ok47YoGB67lO4BQkq2WS+N8XwUXKEKjF5jRM7o157MiNbB3eMyBne/cAU7cIaSCHBh8g0XByURa3+5VwYUafG7lWoV8hRXxLvHP1JbHK+U9EDMVwD0ys3r2Jdq+CQvRyamMobceoyHoiosjsRbtlLXKcaupWjeb1blk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757505402; c=relaxed/simple;
	bh=De2R9CBS606ovczcygR5nFL+7GgzXsLkukN/cVx7ye8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EBpc+f5/kSCQ4L/Tfq+25ZcVvdTjfQ3YPzHEW1UDfr2EgrOvNrs1CkcczeSJyJ5I4sJxPIxV0hJwiKF5DYmVIrgZ0CJXTS/qFCja4m5xt/oaUDUdDiiQPU5VSw4hfCy9AwUFoNM+FUD0NSdVzcU4Jwhd7QRl3R4PweHPuJb0iMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HqBlb69r; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-61d3d622a2bso933602a12.0;
        Wed, 10 Sep 2025 04:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757505399; x=1758110199; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=58PgKZ7crXEVN+doC/JvTxVFXEIdeFlRJ4nsNT4B/8U=;
        b=HqBlb69r1MRXRBsg4l0twKjzOWJMLVUoeG3kd4qrJGqq2fS64ZFOXxjNcAkSKluYgO
         6FHRvVUUxLkzQgnTVRYuJGyCa9wh80wt0b/D82eUTxCcwRVnejyO3CxeihTyuoBCKoW3
         XkUQ2Cd7k25xGpokWdy0lnC4ZwLfjnuq9mmnYeDo3Fms99F2yFbEP7pxkpJVbg0ss2TG
         w3KCD8sIA8zEoPsPS5IrPTVR/exQQgrgbm7rN6/7pX1z+HA+SV2bQmCFiG/LAJly5bBF
         kAh0qiTu3KdqnHxkBMTv0hmAQ+ty9r+Dl8JllHg9poSKykpLrDlNLurkTqHq949vqsRH
         YeOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757505399; x=1758110199;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=58PgKZ7crXEVN+doC/JvTxVFXEIdeFlRJ4nsNT4B/8U=;
        b=dXI+uK9qZSnAzYsww+zFr26UQDEN8lzvz/fzOWAQ67mt/aZXi8LPZVIeJyU3LKaa6e
         0R8UaglaH0wvIWqCB1fhTQsYWTF/VuaaLP6+8Q1Q37ag5ywyJycuVG1IM6JGLn9w6vyA
         q5bkGBeYs2xBuDHkjV5Fm2Ri8KsqJq+gpjRD65ZK9vqoYe0YfS0ID+G5v93cWZzYMqjv
         5Pf+m1mVmkR8aZZWFW5G7MMECkCimLUR0F5y8RULims0xsVnWKPXXi2/6xsXkJ9WlVhI
         4I3rjR6BKG8Mrng1t5Ize/G9z4+q6DjpNz5nqYpxJykkO+y1/vKiMkSkPUqfeDZ9i8+R
         1VOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhjceg6KVASbdWDFlRlpWN7Y5UlHAY4NVgp5YgSYhkfQp0Yv1HEQvkqriHJcJvDdT4TcjN1CHgk114sXY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdwdeqRArv1Y0FBdb0WyZK8g0850IZGLqySL9I63S5uy0mSLhQ
	gRcar46+XS0Xk15Ytqkq7crZdBC63vskZ5MWlSDw8PSXQJ/5ZhANcwLn
X-Gm-Gg: ASbGncvv9wJxY+6KalI3jfeHor9nRkaMQZcCuSj8p5V+vj2TH0wQq/6k3fWLziy31gR
	lFeEdSGZytR2wyAo4k564xtoqsL273EWyS+n8HNbtv25FdFsCP6NmgoPODKzzMiUFQVUAoOnDNp
	0nReOFZgDxw6UKZKLxoOmM7QxRvJmD3RHgVi0jtHVnjuHiEXy7uK6jphddQ74/h2NuQ1EXrHUn8
	LeK+B36IkqQD4XFfUzDq6XPIFx5ggXrT6ojqIgulk1KWaXOshudjBm3rlQrAjtsNmjTZ8xNDKBH
	4EuBXyr1TNEc9gp4LOJys+/TtG/qLlmRtD9fJwRwIQ9rq6v1J6IojfQtDWG2vpjtPZr9c/uQVI1
	KkxFkfaiAknkw6XvBsYXWezfqAPjJdKQ6
X-Google-Smtp-Source: AGHT+IFaCF3ulPJQNujmXvXkeP3bZfKPrcuvNuuV6c+u0Fa34L4TmNGVVHINFukz4dIvjqe4PcnIwg==
X-Received: by 2002:a17:907:1c15:b0:b04:2214:9499 with SMTP id a640c23a62f3a-b04b1dfa8fcmr1607594066b.8.1757505399085;
        Wed, 10 Sep 2025 04:56:39 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.147.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0783046d34sm159274866b.6.2025.09.10.04.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 04:56:38 -0700 (PDT)
Message-ID: <fe312d71-c546-4250-a730-79c23a92e028@gmail.com>
Date: Wed, 10 Sep 2025 12:57:42 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] io_uring: avoid uring_lock for
 IORING_SETUP_SINGLE_ISSUER
To: Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250904170902.2624135-1-csander@purestorage.com>
 <175742490970.76494.10067269818248850302.b4-ty@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <175742490970.76494.10067269818248850302.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/25 14:35, Jens Axboe wrote:
> 
> On Thu, 04 Sep 2025 11:08:57 -0600, Caleb Sander Mateos wrote:
>> As far as I can tell, setting IORING_SETUP_SINGLE_ISSUER when creating
>> an io_uring doesn't actually enable any additional optimizations (aside
>> from being a requirement for IORING_SETUP_DEFER_TASKRUN). This series
>> leverages IORING_SETUP_SINGLE_ISSUER's guarantee that only one task
>> submits SQEs to skip taking the uring_lock mutex in the submission and
>> task work paths.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/5] io_uring: don't include filetable.h in io_uring.h
>        commit: 5d4c52bfa8cdc1dc1ff701246e662be3f43a3fe1
> [2/5] io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
>        commit: 2f076a453f75de691a081c89bce31b530153d53b
> [3/5] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
>        commit: 6f5a203998fcf43df1d43f60657d264d1918cdcd
> [4/5] io_uring: factor out uring_lock helpers
>        commit: 7940a4f3394a6af801af3f2bcd1d491a71a7631d
> [5/5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
>        commit: 4cc292a0faf1f0755935aebc9b288ce578d0ced2

FWIW, from a glance that should be quite broken, there is a bunch of
bits protected from parallel use by the lock. I described this
optimisation few years back around when first introduced SINGLE_ISSUER
and the DEFER_TASKRUN locking model, but to this day think it's not
worth it as it'll be a major pain for any future changes. It would've
been more feasible if links wasn't a thing. Though, none of it is
my problem anymore, and I'm not insisting.

-- 
Pavel Begunkov


