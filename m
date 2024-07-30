Return-Path: <io-uring+bounces-2597-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A4D694102D
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 13:04:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D060D284878
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 11:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F16AB194A63;
	Tue, 30 Jul 2024 11:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKx2F8Sd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1E540BF2
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 11:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722337486; cv=none; b=CmAstQ4z7GbKUXfcwyX8a5JguVY5EQfKJIlWMx0+J8nReLoj//krHFo434dko4VQstwd1/xdFlQTzJ7j4p9LoYydeTUFEyP7pX1lcC9JT/VTWp0v79QMKQkKLttVpnMrJxuY33unVvh7zdmuUvIJxdWc9c5uk5RphRINtaYeb/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722337486; c=relaxed/simple;
	bh=xBSzvctDSNPVhb2dfcsWe6THv0sSAkyXO13BXZNY2q4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BUbXfVictNJHQHFqWimropjx1cBoKwlBtzvL9kCBvY3X2tr6QHV9TJ2ijMIU3hbbPA/mH6f+VKE1hOSkqpE1pUg1wVX0pKIdb/vM6ckjOgsStusGpiQoltjPcSgB8qzFjLLzU2F5W8G0sYWJjrnVfg6cm61GDuYXE32rhgmNffs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EKx2F8Sd; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4280c55e488so16837505e9.0
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 04:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722337483; x=1722942283; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VwHTLSM2XviPwU+8/OjOC/zLDxRRFIw/64VnrQLzKxo=;
        b=EKx2F8Sdb1BWtHrKc3pMBOyPwwzdsB1dcip/XDxz7PXq4KqeTg1zhDqhg0qE6Xv9Fd
         3r2txT7y0d0LKYqzTeoKQwweE21O8nd31mwO9HOD8LxISPvBFHh0GiZgvfkIhiUwdget
         GrH2QRJarOYWyMvtHU1kRC140tenG5/0IkSc7Xl48jqH8kjYVlgFLzdPtcl8pYwhxfgs
         eRVyVVayyk1YjeZr90dG9obKueERpwJonvbdUeg54cLjOejLBk5uY+X5kKa32m4x+1Hs
         GgUUmePhjescOp8l3ExzkMBGV4q7sDspPdIc/ZLzUqCnXnXCGKGQjrvUojjH7BPE4RIi
         Awfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722337483; x=1722942283;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VwHTLSM2XviPwU+8/OjOC/zLDxRRFIw/64VnrQLzKxo=;
        b=Gp3v68Jdgln58rfziZvbRpdbCFMqmCxZybQqD3zGDFujt6rD1nEGDzhNxAf7nUSuyX
         2boeG7swTlD9kdOezpKRcefHmFEmRUdBbFHwFEONk62iHidH6+T+Ga1bSm4XeuH7mP/q
         uCK2qmQM0vCrmpKw4yxzyH4lniLXaTJ5UuYZ/0PXmzu9mlsPg20DIs+nZ799NFR8KwhF
         7kXRn8tiF9Bpnff/AUSuilbtkiU49+23TsKi+xT/O4QWG+ozwjwh+pCqV4Vll0B+a82b
         H0cPCGxM8eURnvYPqqbkqNT+6DzB7+I7CCH9qsWD/Re8RxkTydOIaTeOiPFDC9tvy7Wu
         gJ9w==
X-Forwarded-Encrypted: i=1; AJvYcCXdyJKYbMBkOh/SVx2EPPa76TkJHFT9Qng1toe6sZvWfTMpmzxfONaXJR9ORgi7Nh0gumG/CtZcfmWXS9d1erUKlEKoSOlw2Ws=
X-Gm-Message-State: AOJu0YxuRy0vxoP/7BsjY7vycpADUBupeN4z9l9d3ZGTvy4c1/+BVNA8
	PXZGqty1mMbDO8QkB7PLU28OK5LowQiaYFJNXxT6LE9Xxfc4z66+
X-Google-Smtp-Source: AGHT+IHlK4XfHJ0X3kgyRju/+fGAPecGGRFZ0IRyKyISrQ+oGx0Uz/S2USE/VGrQbEd47kHLUD5uiQ==
X-Received: by 2002:a05:600c:474b:b0:428:b4a:7001 with SMTP id 5b1f17b1804b1-4282445c599mr10304995e9.15.1722337483171;
        Tue, 30 Jul 2024 04:04:43 -0700 (PDT)
Received: from [192.168.42.104] (82-132-222-76.dab.02.net. [82.132.222.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-428175e60b7sm106070545e9.42.2024.07.30.04.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 04:04:42 -0700 (PDT)
Message-ID: <99aa340f-2379-4bdb-9a7d-941eee4bf3bf@gmail.com>
Date: Tue, 30 Jul 2024 12:05:13 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: add napi busy settings to the fdinfo output
To: Olivier Langlois <olivier@trillion01.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <bb184f8b62703ddd3e6e19eae7ab6c67b97e1e10.1722293317.git.olivier@trillion01.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bb184f8b62703ddd3e6e19eae7ab6c67b97e1e10.1722293317.git.olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/24 23:38, Olivier Langlois wrote:
> this info may be useful when attempting to debug a problem
> involving a ring using the feature.

Apart from a comment below,

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

Maybe, Jens would be willing to move the block after the spin_unlock
while applying.


> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>   io_uring/fdinfo.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index b1e0e0d85349..3ba42e136a40 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -221,7 +221,18 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
>   			   cqe->user_data, cqe->res, cqe->flags);
>   
>   	}
> -
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	if (ctx->napi_enabled) {
> +		seq_puts(m, "NAPI:\tenabled\n");
> +		seq_printf(m, "napi_busy_poll_dt:\t%llu\n", ctx->napi_busy_poll_dt);
> +		if (ctx->napi_prefer_busy_poll)
> +			seq_puts(m, "napi_prefer_busy_poll:\ttrue\n");
> +		else
> +			seq_puts(m, "napi_prefer_busy_poll:\tfalse\n");
> +	} else {
> +		seq_puts(m, "NAPI:\tdisabled\n");
> +	}
> +#endif
>   	spin_unlock(&ctx->completion_lock);

That doesn't need to be under completion_lock, it should move outside
of the spin section.


>   }
>   #endif

-- 
Pavel Begunkov

