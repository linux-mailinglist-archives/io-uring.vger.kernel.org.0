Return-Path: <io-uring+bounces-198-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 983B080132C
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 19:54:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7CD51C20A26
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 18:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B7A62D639;
	Fri,  1 Dec 2023 18:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KtV0henW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2549410DA;
	Fri,  1 Dec 2023 10:54:06 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-54ba86ae133so2830485a12.2;
        Fri, 01 Dec 2023 10:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701456844; x=1702061644; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pxC6FvaCwqbKWFKkmrGd/+ggGHthPXEgXLr+pvJmw3g=;
        b=KtV0henWgarPXsqR7K5sjYvGsx57KfHBi8itTYCkGNHSp4471VY46vQcR/YdVRRyJe
         JJy7jksLG0mhZgZLGP35b/WKD2cbOsveRBwPH/6TlZ1g6sXdBBIh1jrl+WCyPlKDfIz5
         fXkb27bicU1rg/+SIg5FtZ6tf6IHpSKM1iuSSbLvM5EhkF8I7OVVoYoYNgVS6mVtdjBk
         ZBIa6w9Mke4vq8G5GzDiuXorqCwBmrMk/rnpGrzC7HztmSxvfHnvmDDZjES0dAfG/74c
         mvjT5dDkJxH5XesJOMdaAtnX54cr5pObumL49Z68QnMFbeWlzqPDlWues80FaAH86s3H
         Mg8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701456844; x=1702061644;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pxC6FvaCwqbKWFKkmrGd/+ggGHthPXEgXLr+pvJmw3g=;
        b=mFo+49JFWBJz8nQKiuu/9VpAKE34CjggjPEHdywDD761mSGyUPfk+8N6+exVEsUJBs
         NEOFku62j0OBPMowOOSXvaSY5u+9xwHIjmINmslSpZL3Zl1vIXsyWK8hi0LcE0f/rstV
         wJ0/vDxHAsLHr4+Q019HDIR0ufVTvQw0QY/0TC+A1lJIwVHaBogSXGx6Pz2jQTf5dYCT
         8gR81UorIUECd/LumfDcsyHScszIZidUscLk3M0yJ13+p+ouHAvz4Zjq0yS454UDxiK0
         Lws/x9gYA1rkeiZwBbLkBTuQTMm2J0SJYx9m3uC8qWttWSiHxiX317AE0YJzGBjTxBZl
         2cpg==
X-Gm-Message-State: AOJu0Yz/+zJwKfZJxUmwWTDL7AAg5o5HjVjTU4uuyo4J+pc1uHVez5ia
	fLn+xAUZtt110HZMxXM/K0KzBzO75ew=
X-Google-Smtp-Source: AGHT+IEbxsBUhuXYvFLq4S++XHBSv/HO34+0JLe6U83mvNd5vKQgX1AbPy8aPiWMpgPtnD3nq3g5eA==
X-Received: by 2002:a17:907:9047:b0:a10:f9a8:bfe1 with SMTP id az7-20020a170907904700b00a10f9a8bfe1mr1797143ejc.16.1701456844374;
        Fri, 01 Dec 2023 10:54:04 -0800 (PST)
Received: from [192.168.8.100] ([148.252.140.112])
        by smtp.gmail.com with ESMTPSA id q19-20020a1709060e5300b009a19701e7b5sm2185813eji.96.2023.12.01.10.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Dec 2023 10:54:04 -0800 (PST)
Message-ID: <42ef8260-7f92-4312-9291-19301aea3c30@gmail.com>
Date: Fri, 1 Dec 2023 18:52:43 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring: incorrect assumption about mutex behavior on unlock?
To: Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring <io-uring@vger.kernel.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>
References: <CAG48ez3xSoYb+45f1RLtktROJrpiDQ1otNvdR+YLQf7m+Krj5Q@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAG48ez3xSoYb+45f1RLtktROJrpiDQ1otNvdR+YLQf7m+Krj5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/23 16:41, Jann Horn wrote:
> mutex_unlock() has a different API contract compared to spin_unlock().
> spin_unlock() can be used to release ownership of an object, so that
> as soon as the spinlock is unlocked, another task is allowed to free
> the object containing the spinlock.
> mutex_unlock() does not support this kind of usage: The caller of
> mutex_unlock() must ensure that the mutex stays alive until
> mutex_unlock() has returned.
> (See the thread
> <https://lore.kernel.org/all/20231130204817.2031407-1-jannh@google.com/>
> which discusses adding documentation about this.)
> (POSIX userspace mutexes are different from kernel mutexes, in
> userspace this pattern is allowed.)
> 
> io_ring_exit_work() has a comment that seems to assume that the
> uring_lock (which is a mutex) can be used as if the spinlock-style API
> contract applied:
> 
>      /*
>      * Some may use context even when all refs and requests have been put,
>      * and they are free to do so while still holding uring_lock or
>      * completion_lock, see io_req_task_submit(). Apart from other work,
>      * this lock/unlock section also waits them to finish.
>      */
>      mutex_lock(&ctx->uring_lock);
> 

Oh crap. I'll check if there more suspects and patch it up, thanks

> I couldn't find any way in which io_req_task_submit() actually still
> relies on this. I think io_fallback_req_func() now relies on it,
> though I'm not sure whether that's intentional. ctx->fallback_work is
> flushed in io_ring_ctx_wait_and_kill(), but I think it can probably be
> restarted later on via:

Yes, io_fallback_req_func() relies on it, and it can be spinned up
asynchronously from different places, e.g. in-IRQ block request
completion.

> io_ring_exit_work -> io_move_task_work_from_local ->
> io_req_normal_work_add -> io_fallback_tw(sync=false) ->
> schedule_delayed_work
> 
> I think it is probably guaranteed that ctx->refs is non-zero when we
> enter io_fallback_req_func, since I think we can't enter
> io_fallback_req_func with an empty ctx->fallback_llist, and the
> requests queued up on ctx->fallback_llist have to hold refcounted
> references to the ctx. But by the time we reach the mutex_unlock(), I
> think we're not guaranteed to hold any references on the ctx anymore,
> and so the ctx could theoretically be freed in the middle of the
> mutex_unlock() call?

Right, it comes with refs but loses them in between lock()/unlock().

> I think that to make this code properly correct, it might be necessary
> to either add another flush_delayed_work() call after ctx->refs has
> dropped to zero and we know that the fallback work can't be restarted
> anymore, or create an extra ctx->refs reference that is dropped in
> io_fallback_req_func() after the mutex_unlock(). (Though I guess it's
> probably unlikely that this goes wrong in practice.)

-- 
Pavel Begunkov

