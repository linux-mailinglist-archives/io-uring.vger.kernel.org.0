Return-Path: <io-uring+bounces-6192-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED9F4A23EB9
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 14:54:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 541DA168CC1
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 13:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E0B1C5D76;
	Fri, 31 Jan 2025 13:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UzzXJE5v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325051C3BF9;
	Fri, 31 Jan 2025 13:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738331654; cv=none; b=NSlqtmPASPBCn+6oGVtaz5CKDIN1VLF4DThYKgSnJ4+egO7EeP8seFaTAxgkZvpHsHL8aebac9IgV6TrLK8MoCBCNzgpsaKUpDQKKB6XD7T4VBo+atkeuWTNAKvSanTj3yawLO3k1Ss8yMGny/pAuvcXiZaPPe0/PZDI6NZYcjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738331654; c=relaxed/simple;
	bh=8VDfY1PNJJZyJET9X+YARvJ5wJd8LjSlDYhTrPkk9UM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tZ4rOg5aIGejP83+R+pQU958PbH2zBLb82eM5o7KfEkNG4LyOz8f0KUIqRReJmfcHSgFUiPu9MmkSty9+TwaJc25nyIsDTRPK/5rzLdz/I5PyljAF2sNIRHIMDWOPPOxsQZsRFEvecCotjS77Dsbw7pc6r4K0uEnz9nV0Efb6rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UzzXJE5v; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aa679ad4265so555483466b.0;
        Fri, 31 Jan 2025 05:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738331651; x=1738936451; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U+oPKEKL04/BZOUCCzYCZRl3onDQOPUzPlPjewuz4tE=;
        b=UzzXJE5vuxZ9doB9Skgmn433+80ffiUYmCbuMSf9bgyDZT699NepgcCROLxokpqoWl
         pqPnB9QwmWtzjyOFa9ImHOZzMVlGPYzxrFAN8gj8CbN3ysxwTUShIdRE5AtHYSrO1gOz
         y0GYPLbAaCILUZRiAomF6n/al6Zc1aQEdtRIdDChFGUF124vSIt9h40lldi3qQrJmiya
         MDaAZnM51w+dL1s25XJLVZ/drT9BYmPiO9tmPdtxDq1AXCbcJsPd7YCfVagnFrXzXQGd
         2f+27nWDHRjjichp8cL/VJdH9YVhM4AbYBU98dRYew561C5CwbwmRtF1XPrlR3yHndXP
         bZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738331651; x=1738936451;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U+oPKEKL04/BZOUCCzYCZRl3onDQOPUzPlPjewuz4tE=;
        b=i2FxSQET97BiFR3d0OMPRS7xB1S5MZIzrMXDAL3Fqy06e2I/5JRS1zPj66xkwPc6iW
         +nXpWc42l5uiB9meS4pIfapnZ1VxC2VrjL0LoztoEgQvtnUt3oCmcbRpeiqPkHzGUoB5
         VrDWjsnz3rUe3okOuUiUKZqQZzQhdil9Hc0hNYoFvt2dwPupMpvH5dWqjO82DLCeQNT7
         dRdKe9pr9GG36YIUPBo7Wja/1RLfSzTeljiDPfU6uCe2oqRlgzs2specnL4dB70dfGRa
         n2S/jyD0snCLWHM/HbMDhv522bQe3k8u0kMjZIraaGijSDTJ/Eh/Q3mU5eLG+cvH3RDr
         0JwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsLVbyiLb0gw5U9ZCaneS8LWe1GhBl2k2YJIDyUs56mW1LQVtHNClmJXN4Lug9quqQsXZcU3CyKw==@vger.kernel.org, AJvYcCXJ22EzewWfj8zVMCS40CWBW3jO2x7H2jBJBNlvYjYD8TpmrgPzZnTQZ8mGWSeZZWIvPw5UU5c/n8beXhtL@vger.kernel.org
X-Gm-Message-State: AOJu0Yx936tLkXdAzgDP0XZuByOvptS8E+JYYYCKXC3fb8v95WB1hLjI
	KUzoqunG7VMOwomnJDDUOc8RSHQJLbvVozFZyON2+9+mrwJweefu
X-Gm-Gg: ASbGncs5Ui6NkFUz3xEp8wg9XoYBBX6vfMlwEyUqQLtjaHJ1Ry5RKfZNdbxMP/mU8Kw
	FIwaiinAZe9RVwX7fT2TtEWL7VABEd3ngI6+7iJvbEKzZtb+Dv/176pmIsHcqSLCicUNR7ArbQe
	NYxuvnO90PNUjF/d+LW0YtLUTD6hmdWWCC2xWc/eGr1WUfR7/lqUc8L9/x/ohHlOQ6f1B+qjZ9J
	pdAVO5hSXVHff67SNYayaw77gciMuOW84fE9TspVuaPNfyxl5LKp5PJd/bV1jHhiNmOUksC6sp+
	evv83BkmuPjc33EsIuo8Rafa7e/WzV8kv7gcutMGJ/9Q9pgv
X-Google-Smtp-Source: AGHT+IEWkjqOrQNZslu8I3WFXwYqunGsMP6w00g33o5wgq+OeuZN/kMLuXVxDIeIEmQ6Wx6l8MvdCw==
X-Received: by 2002:a17:906:7951:b0:ab6:f0d3:9687 with SMTP id a640c23a62f3a-ab6f0d3e9cdmr531751166b.21.1738331651199;
        Fri, 31 Jan 2025 05:54:11 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:7071])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e47a7b1asm300355066b.31.2025.01.31.05.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2025 05:54:10 -0800 (PST)
Message-ID: <794043b6-4008-448e-b241-1390aa91d2ab@gmail.com>
Date: Fri, 31 Jan 2025 13:54:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] io_uring: skip redundant poll wakeups
To: Max Kellermann <max.kellermann@ionos.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <20250128133927.3989681-9-max.kellermann@ionos.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250128133927.3989681-9-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/28/25 13:39, Max Kellermann wrote:
> Using io_uring with epoll is very expensive because every completion
> leads to a __wake_up() call, most of which are unnecessary because the
> polling process has already been woken up but has not had a chance to
> process the completions.  During this time, wq_has_sleeper() still
> returns true, therefore this check is not enough.

The poller is not required to call vfs_poll / io_uring_poll()
multiple times, in which case all subsequent events will be dropped
on the floor. E.g. the poller queues a poll entry in the first
io_uring_poll(), and then every time there is an event it'd do
vfs_read() or whatever without removing the entry.

I don't think we can make such assumptions about the poller, at
least without some help from it / special casing particular
callbacks.

...
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 137c2066c5a3..b65efd07e9f0 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
...
> @@ -2793,6 +2794,9 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
>   
>   	if (unlikely(!ctx->poll_activated))
>   		io_activate_pollwq(ctx);
> +
> +	atomic_set(&ctx->poll_wq_waiting, 1);

io_uring_poll()                 |
     poll_wq_waiting = 1         |
                                 | io_poll_wq_wake()
                                 |     poll_wq_waiting = 0
                                 |     // no waiters yet => no wake ups
                                 | <return to user space>
                                 |    <consume all cqes>
     poll_wait()                 |
     return; // no events        |
                                 | produce_cqes()
                                 | io_poll_wq_wake()
                                 |     if (poll_wq_waiting) wake();
                                 |     // it's still 0, wake up is lost


>   	/*
>   	 * provides mb() which pairs with barrier from wq_has_sleeper
>   	 * call in io_commit_cqring
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index f65e3f3ede51..186cee066f9f 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -287,7 +287,7 @@ static inline void io_commit_cqring(struct io_ring_ctx *ctx)
>   
>   static inline void io_poll_wq_wake(struct io_ring_ctx *ctx)
>   {
> -	if (wq_has_sleeper(&ctx->poll_wq))
> +	if (wq_has_sleeper(&ctx->poll_wq) && atomic_xchg_release(&ctx->poll_wq_waiting, 0) > 0)
>   		__wake_up(&ctx->poll_wq, TASK_NORMAL, 0,
>   				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
>   }

-- 
Pavel Begunkov


