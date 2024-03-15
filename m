Return-Path: <io-uring+bounces-977-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C77E87D260
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 18:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDC3C280E6B
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 17:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64E7D4D133;
	Fri, 15 Mar 2024 17:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NFfJiFsL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979174CB28;
	Fri, 15 Mar 2024 17:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710522195; cv=none; b=VIQsA7nwGEuLc/r9JffSUGIpN57wq835fuUo2R2iZBLgFNfjJH8J+cvjpUukIT/xOskqTxgx7C8/rfZN9/T+XfHwplapCsgvAMCTybw11E/2GZtL/RgJWgf4v19jCT0W3P/7FtTd3Kh8IbAwn/oBDxi9dFiTqqokFH12pxi4BL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710522195; c=relaxed/simple;
	bh=VuiJ6Yk+4rO2dkDpvPyGuOChWDOminf+zuxzplbDYt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n+1wSblftkHdpKlu7YNCWi9PQzWMU4hAHBzSWSWWonT65lm2n4ErUUv/LCvCW/Lp+AxYEze1xkqWAjV6uxLpAumwHtvum61bv9TbUaZDZK4PdJZY1tpBVtDIOvz0/WhjayB/dFca2aGRZExEpxVgMCeDU5S473cZJujUu3x+1Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NFfJiFsL; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a46805cd977so165672966b.0;
        Fri, 15 Mar 2024 10:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710522192; x=1711126992; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JZ1sNJm+yT9gSzolt7Elm/obovWaZLhTaW0EpgnXEQs=;
        b=NFfJiFsLvf49XlMBvvVwwv2Y+YjwoH5qyn5W3t34DyWtcUZSjCLqlbf+0Hae8+VbJu
         sJgOBjlkE82SLHSoNmOUzbIS+xbxJ4Fzfvh6qmcqN8FNG8cXU/KzoEG83M7cNVyAGETE
         PrJi5lOUyLL2kWPGdGPj9sdHWsiPS5oi/Uce4UEwTOqavsGjjBRChDEFIPLY4n3xw3+A
         +Hu5lwlbAARlyyg25r+NpAao+hLSONZz07HyABCjHv/jMJnCpeUQN0VZRQoYMKaCEaJl
         6RudIetddkfXvXbg3+vkubEZOWzVRDmN757bjaIzwpGWUJsmaA9InPQQXm4j59FTumIO
         VsVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710522192; x=1711126992;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JZ1sNJm+yT9gSzolt7Elm/obovWaZLhTaW0EpgnXEQs=;
        b=MFsr2QD7KbJs0z1c2uJgWarYYW0abbbw4jcUDRwGUrqca0t95kRPp0RszclYfIBTIl
         P1nooI/XJla+7X0as5jMZOAjwILzVfJxwQn6/MPaETJZxr0slXoLNHXl+07r4N+eQ8h5
         50oCG/SeuSGyatK7FjYb9zuyNpZ3qDYe3yCOHIckeoiw99X5RWJZdbUVwOeADoWvXT5z
         +5euG/7rZDx1k4QRlTcWsFtDMcAtgb7I+FJsP9i6jYzUb6s4RjbjcJRcZq3+1FmHGvgq
         ++AzTAPlDvLir0GPzqx51zcsNAwis71uOMiycNZ63uH+9xBq5NbOEVBUa/mGHscBYcxY
         z/1A==
X-Forwarded-Encrypted: i=1; AJvYcCWe4BpHNMwVwiaa5nX9qtgjJgVd+eHFmu7EU64FEpb+Hkh5PNtC5EtZW2djnWVyERrMwPLmfN/RHpc6D3avZsJvFDhYjrKfFypCYF83lgpIkZqaAd3G4xFmxBcRK8PrTVnpgTZXBeI4xpPXRUM7n/Pkx7F3ZFTYxtSATtvf/Ws=
X-Gm-Message-State: AOJu0YwSu0v8eWQtT/Jy0QhvyH8KoDZNQ/xoJblZmCbBVA5gT3Z6hCh7
	1tYkdmmJbGKrdMQ/SwtuG6ns53GT34vrkxIFn0ukFPMEi4fzTx8Z
X-Google-Smtp-Source: AGHT+IHmXXk6e/3tQw4Vi40FAeG9esFTmR4mmLFDgLolU22mS0fcuSO+nCMA5o7zuNvSNbXzpebRwQ==
X-Received: by 2002:a17:906:3bd1:b0:a45:fb0f:d210 with SMTP id v17-20020a1709063bd100b00a45fb0fd210mr2348722ejf.25.1710522191729;
        Fri, 15 Mar 2024 10:03:11 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id e27-20020a170906375b00b00a4354b9893csm1857566ejc.74.2024.03.15.10.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 10:03:11 -0700 (PDT)
Message-ID: <7b82679f-9b69-4568-a61d-03eb1e4afc18@gmail.com>
Date: Fri, 15 Mar 2024 17:02:05 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net: Do not break out of sk_stream_wait_memory() with
 TIF_NOTIFY_SIGNAL
Content-Language: en-US
To: Sascha Hauer <s.hauer@pengutronix.de>, netdev@vger.kernel.org
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <20240315100159.3898944-1-s.hauer@pengutronix.de>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240315100159.3898944-1-s.hauer@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/24 10:01, Sascha Hauer wrote:
> It can happen that a socket sends the remaining data at close() time.
> With io_uring and KTLS it can happen that sk_stream_wait_memory() bails
> out with -512 (-ERESTARTSYS) because TIF_NOTIFY_SIGNAL is set for the
> current task. This flag has been set in io_req_normal_work_add() by
> calling task_work_add().

The entire idea of task_work is to interrupt syscalls and let io_uring
do its job, otherwise it wouldn't free resources it might be holding,
and even potentially forever block the syscall.

I'm not that sure about connect / close (are they not restartable?),
but it doesn't seem to be a good idea for sk_stream_wait_memory(),
which is the normal TCP blocking send path. I'm thinking of some kinds
of cases with a local TCP socket pair, the tx queue is full as well
and the rx queue of the other end, and io_uring has to run to receive
the data.

If interruptions are not welcome you can use different io_uring flags,
see IORING_SETUP_COOP_TASKRUN and/or IORING_SETUP_DEFER_TASKRUN.

Maybe I'm missing something, why not restart your syscall?


> This patch replaces signal_pending() with task_sigpending(), thus ignoring
> the TIF_NOTIFY_SIGNAL flag.
> 
> A discussion of this issue can be found at
> https://lore.kernel.org/20231010141932.GD3114228@pengutronix.de
> 
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>   net/core/stream.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/stream.c b/net/core/stream.c
> index 96fbcb9bbb30a..e9e17b48e0122 100644
> --- a/net/core/stream.c
> +++ b/net/core/stream.c
> @@ -67,7 +67,7 @@ int sk_stream_wait_connect(struct sock *sk, long *timeo_p)
>   			return -EPIPE;
>   		if (!*timeo_p)
>   			return -EAGAIN;
> -		if (signal_pending(tsk))
> +		if (task_sigpending(tsk))
>   			return sock_intr_errno(*timeo_p);
>   
>   		add_wait_queue(sk_sleep(sk), &wait);
> @@ -103,7 +103,7 @@ void sk_stream_wait_close(struct sock *sk, long timeout)
>   		do {
>   			if (sk_wait_event(sk, &timeout, !sk_stream_closing(sk), &wait))
>   				break;
> -		} while (!signal_pending(current) && timeout);
> +		} while (!task_sigpending(current) && timeout);
>   
>   		remove_wait_queue(sk_sleep(sk), &wait);
>   	}
> @@ -134,7 +134,7 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
>   			goto do_error;
>   		if (!*timeo_p)
>   			goto do_eagain;
> -		if (signal_pending(current))
> +		if (task_sigpending(current))
>   			goto do_interrupted;
>   		sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
>   		if (sk_stream_memory_free(sk) && !vm_wait)

-- 
Pavel Begunkov

