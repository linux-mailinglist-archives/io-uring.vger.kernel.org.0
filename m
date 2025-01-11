Return-Path: <io-uring+bounces-5822-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65C29A0A375
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 13:01:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C9513AA572
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 12:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F00189BA2;
	Sat, 11 Jan 2025 12:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MPKgcFKj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0FC7E9;
	Sat, 11 Jan 2025 12:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736596896; cv=none; b=bn+iU8BijKR3hYpVAxMQUzj2v0cXZSTr0PQXEiGfaHZvHpBAaiecYXJAKf9cz2N1dT7H3ocmiexs0gPg+RSuZmxz/i0U7RYPawG3CMD+/7Z2DXth26OTVT8qhybe02iOCE4PtqhwBMbd+K51EPTeKpkKqGDpcMcGAUK46Zl79uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736596896; c=relaxed/simple;
	bh=b+ufm5eQLMdl5LpR0+wXz7DWHtGH86RBMGjLbM1gXVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ttZuEqxk3TqpK0q7sGhbdJ95cw49Lzsz1P7VyahAEeDuPMdlu1+dbrPsKb3kHTtOGiUfG4Naxr7U8qBBhfxg5WxqXK5F/zGx1dm6TpK3OgndivVA0dsTxGE86PW0W1UJmM51enEse8YI5yu/NFrjlurW/dNU4NqStXSHKqMkPfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MPKgcFKj; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d41848901bso5314254a12.0;
        Sat, 11 Jan 2025 04:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736596893; x=1737201693; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UzAVlF7/7n+KkcKqqjmhcnsJiQYYbkrUhhMZjo+3dD8=;
        b=MPKgcFKjx8+mCF/JylikulkUooQjxDrp8lUWMSeQyYVPYOwuY8Sq9vqSy3fMLdqVcQ
         JrxkS3JyYiNj4pMvQUtPKDE35TfOf7I9JnMekCNBXCA80pVYbV0MRMUvFeVlBbhm38zB
         k55YZ2N3IgKXiVL0TY5bywnjA0gyLvYyOjLxmwWmPvA8OLzwYEIPsb8EkNvTUlUK+S0/
         oHbn1TzBw3Qsa5P9cMPAW194T9g2M9mWsNZ/zrhqRJO31ZU0JXQwHJyuSW4IOG7dM3mY
         BkfWfBltyEm/P7C/ygxVSSWrvVH1Bxcwou6CXd9vpDv9pksS+FLA13slQ3Kobta3CsY2
         z/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736596893; x=1737201693;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UzAVlF7/7n+KkcKqqjmhcnsJiQYYbkrUhhMZjo+3dD8=;
        b=i9Q888UmbtX/TUqExHbCr2PUgtH2Uk+FKIzSLGaToGfm7awiCaFlxVsT9RaduyvIAg
         jZ00gI1IraQnfV7zGM2FuR4dc6PtlfNh833S1EzIfoWSaPWUDTxaZTZMtjS35rYJDdsJ
         7V0rcSyRwjxP6kCYllBQBfuMDi/Zkr8WyK0FGZn4XYhc8QtseM8T2dctD10J6aE7Wgub
         wAxtnq8K1KHBuULzgA8Nrmbve9TiUNvFUuNY0rEXcE9bOLfegSOzEqqfora7NftjjanR
         RBOglMtmGTPnkJn7VJ88J5nWOUIS71DnZjYL9LpS3itTFqOIBFRZmMnNUnX0Yd9TOPcW
         rBtw==
X-Forwarded-Encrypted: i=1; AJvYcCVUJZWkvn/WLBhNCxHLpH1pJahJhdgDvkbTY2o+h7BGogiRfC1fc2eBG8lBBaZ+kI03JoMROD4AnpbnzwbQ@vger.kernel.org, AJvYcCWMIqH/UGLffwKVQggElKr/VVxkmzzr4jZjouy3pjuvOztb1rnEvXpcDNNRb/LMKqqKhKOqj53LRw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ0Szss0CJm8v+AtVYnXKLDM92wfWby9Q4BtB1adVC4B+xQQQi
	kZj85ucE7MOHuMR6r2ND0PZCFTzdxjZhDzV81MxtPVjGg5wlf8pn
X-Gm-Gg: ASbGnctLLycnCdwHarp6ZmOPe/a1eSkqLU//nlrc87ISJx5575QEsqbzjERPavPPXnt
	0JDZPKkZcXMfsenOe/3lrecugvRRvE1+9slUbpHyxNXxRntDMxnlWdZbX36JsAqHbA+Lgp8LAY7
	b+lz3ooGCymSHIjbI7ERcoQyaicONiub4zM2XGpadJuVLDoCGQWX6MYPhHlBsGYo+yToP2MdZ8g
	iM3uUMDX0FaPSKiFSpIxekLyum4uTFFxLRtK+fe5vn4vK1y8QpFOE4wdmGTAKoxeQ==
X-Google-Smtp-Source: AGHT+IGF41NBnMzwcRWugyK4L2xhRKj6eFzR3VhdcF/LDL8FchjQJXmEmwg31/ZKqVIGKtJ8LojvLA==
X-Received: by 2002:a05:6402:5193:b0:5d4:c0c:70f9 with SMTP id 4fb4d7f45d1cf-5d9861d6795mr8171734a12.6.1736596892614;
        Sat, 11 Jan 2025 04:01:32 -0800 (PST)
Received: from [192.168.8.100] ([85.255.237.228])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d99046e048sm2520338a12.71.2025.01.11.04.01.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2025 04:01:32 -0800 (PST)
Message-ID: <02961c66-19b2-4f55-b785-3c4a132a5da3@gmail.com>
Date: Sat, 11 Jan 2025 12:02:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: annotate sqd->thread access with data race in
 cancel path
To: Bui Quang Minh <minhquangbui99@gmail.com>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com,
 Li Zetao <lizetao1@huawei.com>
References: <20250111105920.38083-1-minhquangbui99@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250111105920.38083-1-minhquangbui99@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/11/25 10:59, Bui Quang Minh wrote:
> The sqd->thread access in io_uring_cancel_generic is just for debug check
> so we can safely ignore the data race.
> 
> The sqd->thread access in io_uring_try_cancel_requests is to check if the
> caller is the sq threadi with the check ctx->sq_data->thread == current. In
> case this is called in a task other than the sq thread, we expect the
> expression to be false. And in that case, the sq_data->thread read can race
> with the NULL write in the sq thread termination. However, the race will
> still make ctx->sq_data->thread == current be false, so we can safely
> ignore the data race.
> 
> Reported-by: syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com
> Reported-by: Li Zetao <lizetao1@huawei.com>
> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
> ---
>   io_uring/io_uring.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index ff691f37462c..b1a116620ae1 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3094,9 +3094,18 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>   		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
>   	}
>   
> -	/* SQPOLL thread does its own polling */
> +	/*
> +	 * SQPOLL thread does its own polling
> +	 *
> +	 * We expect ctx->sq_data->thread == current to be false when
> +	 * this function is called on a task other than the sq thread.
> +	 * In that case, the sq_data->thread read can race with the
> +	 * NULL write in the sq thread termination. However, the race
> +	 * will still make ctx->sq_data->thread == current be false,
> +	 * so we can safely ignore the data race here.
> +	 */
>   	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
> -	    (ctx->sq_data && ctx->sq_data->thread == current)) {
> +	    (ctx->sq_data && data_race(ctx->sq_data->thread) == current)) {
>   		while (!wq_list_empty(&ctx->iopoll_list)) {
>   			io_iopoll_try_reap_events(ctx);
>   			ret = true;

data_race() is a hammer we don't want to use to just silence warnings,
it can hide real problems. The fact that it needs 6 lines of comments
to explain is also not a good sign.

Instead, you can pass a flag, i.e. io_uring_cancel_generic() will have
non zero sqd IFF it's the SQPOLL task.


> @@ -3142,7 +3151,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
>   	s64 inflight;
>   	DEFINE_WAIT(wait);
>   
> -	WARN_ON_ONCE(sqd && sqd->thread != current);

It's not racing if it's the same thread, if it's not it'll trigger
the warning anyway, I don't think we care about this one.

> +	WARN_ON_ONCE(sqd && data_race(sqd->thread) != current);
>   
>   	if (!current->io_uring)
>   		return;

-- 
Pavel Begunkov


