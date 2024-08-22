Return-Path: <io-uring+bounces-2896-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFBF395B676
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 15:24:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62A83281D62
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 13:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C0C1C9453;
	Thu, 22 Aug 2024 13:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="je7G11ot"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F981CB321
	for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 13:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724332957; cv=none; b=n0hTOnBhZTTABJ0H+XNI/6r25iGMEr7XN/nFxie7YDq6r0OW4Pz4cQW2TyKCxVmhROlVFzfhVChmWmmB8RY7rM9Tpprita1BGEouBR9DD8u+ol9BEHhNm5liKeDpQce/p4jynr0IKsMrXpZIoB7cbqrzOmc3RurddyS1Ofyec3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724332957; c=relaxed/simple;
	bh=ciZkDi9rxG5M9+wGMfc2K8Oe3jYqKEj6eGHhqjHRUsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R21ek6/RNN+iDF5UMgL2IsjnNy1jOgOZzxqszvQJkgm5Q+LrsBXuEJessgvRl+k4p3Wi4QpGZwr+7u096PfvhU64RujvgIAXDV9pzU6kp7LRLLljUQ15Abm79JXq4xALbam4C8KAH7yxIXJ/1uo9ccZx9m9byg+9xZE+mEIt4yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=je7G11ot; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5bec87ececeso1098507a12.0
        for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 06:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724332954; x=1724937754; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z8eRY4nyLdUxopRMEeB7+S6FgkDi3i4JcOXHZLy8A/o=;
        b=je7G11otjLnd+pcwITFjx7Oa/21Cd5uoJaWeT5pUuCc2rerhj43y/9NFMMeOkhaxdu
         CCOZYNi0wT+CdTD3CAMMl8P7BQzrrAWZkXL2pYga0eHv0inFDdcbLhoKhSUmEnS9pT5/
         px8Mup46n0Xbes0zJfVOdkCXCxvDrPj3P7n5P0Ba3B1gc60Ku6ewofWxzf7kjPEsEx11
         UIz1GjQQg4PhjO5GLbGwAExFKwYEF//SiHbAGo6+eRPTgy4BY8qgTYB7vv9z1SwVe6F5
         Hv/h5zrZIhoK0dLqx0nFL47j0q18AnEBhXtiYGF4mlrNVvHyA83LCkrBpssow/Jo6DCO
         iLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724332954; x=1724937754;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z8eRY4nyLdUxopRMEeB7+S6FgkDi3i4JcOXHZLy8A/o=;
        b=ozOxqxtnJfKynM8eDGmxllgpBaSgQMLoYR8IOUqLMNHsI6qneSb81aPZ5I+qXt261V
         thMqcEHz8LAseBQicSAXyPU9YcAmZVK4WPsigpSdtLlzmNOEZqNti0UuBkG6efpZfuyI
         itBdw83f+5gnvrFzRrZDAGk/VPuxonSyejX8tvCts/yOJ2xmqtame4Z2DUxqDUfXjFSS
         X7mZrc44TwF+uIu2h7V8/avbxYTIR4lkY3CEagdnGzc1dYwj2S7QvOhNriYCX90bBZUD
         eFQsb6W5783Xh0kDmy2jU3ylaoEUuk03mIEtpGIw2ctpT0VjBDQWmOdgA0jXFoM6xsuV
         3oJg==
X-Forwarded-Encrypted: i=1; AJvYcCWHPYNtbZ01O1OgcMMCFY4LIFge0xryj4SSmxbxYWo8WuAFuqFuFZq22zleklVWEAsc3Up597ThCw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6MSEXU6YFHPKi/YkjBbj/gkqi1ea+D+hZiUvHhtVh4Rg0TnXK
	/RcFJdERgyxvxPr/kXmI49cMcvgZ9w2lHkh2+PjBmhvHJtvuCrDY
X-Google-Smtp-Source: AGHT+IH9DJrs9tA2LOS3PcJNaFKfHE3E9oOwSQFU8PoDqUaLBR5ucM5SY6k5fUEpOiiaKzVdPt/dYA==
X-Received: by 2002:a17:907:2d0a:b0:a86:7b71:7b74 with SMTP id a640c23a62f3a-a867b718734mr403104966b.55.1724332953249;
        Thu, 22 Aug 2024 06:22:33 -0700 (PDT)
Received: from [192.168.42.237] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a86942d5afesm84376566b.154.2024.08.22.06.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 06:22:32 -0700 (PDT)
Message-ID: <00ce2394-03e2-4769-bc55-8affdc578bd1@gmail.com>
Date: Thu, 22 Aug 2024 14:22:58 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: implement our own schedule timeout handling
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <20240821141910.204660-1-axboe@kernel.dk>
 <20240821141910.204660-4-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240821141910.204660-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/24 15:16, Jens Axboe wrote:
> In preparation for having two distinct timeouts and avoid waking the
> task if we don't need to.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/io_uring.c | 37 ++++++++++++++++++++++++++++++++-----
>   io_uring/io_uring.h |  2 ++
>   2 files changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 9e2b8d4c05db..4ba5292137c3 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2322,7 +2322,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>   	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
>   	 * the task, and the next invocation will do it.
>   	 */
> -	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
> +	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)

Shouldn't be needed. If the timer fires, it should wake the task,
and the task will check ->hit_timeout there and later remove the
itself from the waitqueue.

>   		return autoremove_wake_function(curr, mode, wake_flags, key);
>   	return -1;
>   }
> @@ -2350,6 +2350,34 @@ static bool current_pending_io(void)
>   	return percpu_counter_read_positive(&tctx->inflight);
>   }
...

-- 
Pavel Begunkov

