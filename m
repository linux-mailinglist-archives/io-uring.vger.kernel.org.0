Return-Path: <io-uring+bounces-1328-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD88789210A
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 16:57:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0295D287A02
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 15:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD6DB1C0DDB;
	Fri, 29 Mar 2024 15:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cqEb1lGq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4EA3D55B
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 15:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711727865; cv=none; b=egqjSCK2SdVAIAHrIcs/DEcxZzQKneTZSjSJuCroHla/aKF7oKtzH5rW6Wxwpax3z9X5Y3mydeZ6vjvylcfsJyCjFtAooT/g0ezP7EZ6utL9JAgsUHcR1N27xhJ2auebvoFDjCWWxvuEvaxEIQEWA2BeFMiK71URpHMprRCYkeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711727865; c=relaxed/simple;
	bh=T8ccfKttB6XtBMHcFQzmatA82luBUwCX9u4eupIEOxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=p5OLEl/aj0fIWB+ZAoBE07tP46XFfGAuxfAs6hOEa9P4KhA09VagMP7wex0nIe9bhy6mmOQsxNCPv83TX6+E+SvULcyW5M5JL7VCCoxVQQcYY150Lofog/D3587l04FIsi0hzm+ocivm/RHjoqavEGXOFK4bKm/wdMTb/JCviUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cqEb1lGq; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a46ba938de0so289101566b.3
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 08:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711727862; x=1712332662; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FBxnjxAG7/LPxBOU39S3qnBa6CBa5jIopT7NUSBg5RE=;
        b=cqEb1lGqKKpqZ6CzfwUgle6x8fnUiK+++sig44hSfapM+5C9R56Szb31u0RjHRXXvk
         TUlPS1IszMa2pRIyn1zvmwiA1IYu7nlWxW1P789GJrNFsz4FhV5gmt5hI4nhMeqXEOdZ
         iR8xS9FaTqHA3irs2SleuwekqvbyN2uGRnKwhuOl3cl8BJUas5RJ5sKBnlX372NMe9IV
         jABextnGay1FkuHJM//GF0JOMkjmeTF66jwVDYqK7yFcOIYxU13lvh5YBlMhsWZ6emLt
         Xv7E9VZotyT27NYo4nw8eHMVqQdaZnCjhVOGkO9abSiRBiqaZeGataBQr5geoqJPhHf5
         ZsVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711727862; x=1712332662;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FBxnjxAG7/LPxBOU39S3qnBa6CBa5jIopT7NUSBg5RE=;
        b=hspjV4hAYDBERl8nwSi4vBp08WqVXe7eDVbcdqEcW3QcT0AMG7kWOegvh1KEYmg4fx
         iS/erkGUZptcbnsdCPz41XMVWk4ww23n/Q75Z9XwoyJxuZJzp8fn2M8UEvuRc9io0GMv
         ufEY9X1UFGsaKzPqFlU91ckrYx46xZ16LKOypxiuzEE7zuuKcDrGTRTHDY85tp1HkZjN
         t8yRyoaiohsZrOaHEahDQOTBdz5SPiBn2hSUz2Tj0e4Z8UigVlu7JPmbl4lpK/5HMjv+
         wBLMboOOR0zSFaCS+E4NYVvtVVh3lB/Zj57s46nAApFBItF90Ej00ezurbtze1/nV9cn
         wwxA==
X-Forwarded-Encrypted: i=1; AJvYcCWjDKi1KIXF5/I3BkXvCMJlDrEIMZWQcsBPFzkD4AAKJ4Sa5LIMV+OFMk612GcAD7IDJY1xeqPgpKzQ8XzjQEqb6igM9wPoBPs=
X-Gm-Message-State: AOJu0Yzlrw3XEQFkzdtumtGII78kvQZfFcCzXD92FOQYACoH9RWhzckr
	Zx5go5qGhjb75eaACTKCyuQ/DBn0UxCooSA8/dVwmNx+aRZ+hLf71z6OmJzT
X-Google-Smtp-Source: AGHT+IFaMbJvhtrUkGuSBuoeE5D4MAGEN4ZEKmpWhRg2wBOZ1l8xJ8nfiJ1sQHBD7G7zzveGtGuf5Q==
X-Received: by 2002:a17:906:5052:b0:a4a:3403:343c with SMTP id e18-20020a170906505200b00a4a3403343cmr1748281ejk.31.1711727862286;
        Fri, 29 Mar 2024 08:57:42 -0700 (PDT)
Received: from [192.168.8.112] ([148.252.140.106])
        by smtp.gmail.com with ESMTPSA id ho19-20020a1709070e9300b00a473631e261sm2062062ejc.28.2024.03.29.08.57.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 08:57:42 -0700 (PDT)
Message-ID: <25f1145c-9d13-42ed-8824-5b1364551627@gmail.com>
Date: Fri, 29 Mar 2024 15:57:38 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/msg_ring: cleanup posting to IOPOLL vs
 !IOPOLL ring
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240328185413.759531-1-axboe@kernel.dk>
 <20240328185413.759531-3-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240328185413.759531-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/24 18:52, Jens Axboe wrote:
> Move the posting outside the checking and locking, it's cleaner that
> way.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/msg_ring.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> index cd6dcf634ba3..d1f66a40b4b4 100644
> --- a/io_uring/msg_ring.c
> +++ b/io_uring/msg_ring.c
> @@ -147,13 +147,11 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
>   	if (target_ctx->flags & IORING_SETUP_IOPOLL) {
>   		if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
>   			return -EAGAIN;
> -		if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
> -			ret = 0;
> -		io_double_unlock_ctx(target_ctx);
> -	} else {
> -		if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
> -			ret = 0;
>   	}

A side note, maybe we should just get rid of double locking, it's always
horrible, and always do the job via tw. With DEFER_TASKRUN it only benefits
when rings and bound to the same task => never for any sane use case, so it's
only about !DEFER_TASKRUN. Simpler but also more predictable for general
latency and so on since you need to wait/grab two locks.


> +	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
> +		ret = 0;
> +	if (target_ctx->flags & IORING_SETUP_IOPOLL)
> +		io_double_unlock_ctx(target_ctx);
>   	return ret;
>   }
>   

-- 
Pavel Begunkov

