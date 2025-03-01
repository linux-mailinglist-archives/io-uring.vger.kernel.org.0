Return-Path: <io-uring+bounces-6875-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 845CEA4A758
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:23:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55A631881327
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 01:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE6563A9;
	Sat,  1 Mar 2025 01:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OiCNdXTh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E2CBE6C;
	Sat,  1 Mar 2025 01:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740792215; cv=none; b=frHixKTRORyrXclMDR2/EE6x/rcL98/DfHlH4fTTij+B9J9WIE/0/EdBbGHBD1qYkdEevFSQVIe+FN0yS/UsOj9K762NJcBjuC97HHURzduzqtbzUuu/y/EAu4MyNkri391dgy9k+MqnyEYrhFIg2cgDCcdytS9foMUBuwo1Ckw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740792215; c=relaxed/simple;
	bh=PTNepDljdJmBLPx1Vt119k3gOjDnw3szWpNNxq3pGPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f4xCkZEkHAMOQ5Q0YdCgK29Isw2p12s3awZyDiSIzWbxxx2Xn3ZDURZbsGdIwy5LGB/CJ3fNS+CDvExPUE6yhtI3gGp25I9GF58TZu159zNEklQL4miqysg+3CzHCYEBp78hhxXzlogXZPMVQxxYFypeDUqDYMlhcFcSWy+5De4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OiCNdXTh; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e4dc3d22b8so2555189a12.0;
        Fri, 28 Feb 2025 17:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740792212; x=1741397012; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uMeHz62fDGvf8tHSG9UR0lUzfNjHQKzyZfW4Wd98gl8=;
        b=OiCNdXThHWlUlA0Vvm9JMiPWqo6rskc1v74Ww9Xa/wl2GErIRjAvqIFuZ02eZlXP6e
         A20B3vHwSZrTzNM9g9Iu3T1XewQfl5c5aLAxTtlhJYkLV7GGWcWtI7mqWphvsyyhf3PW
         M27y3zwBnzu3LPvZKGmxhE1bXbxjrUPRRUzW5Ph731q5NtQrE6tFS6dDe6VgamiYj7vH
         prSFXypPs64GtBOjdfb+77muFdQstg2rv03UVzTU0YSB2vobTi3tvYlaJC1uR+N2lTJu
         Sxk2+BKW7J1WKppWCtXvEzNI9QnDIjVHO9lX2CNLb0UAK3lt0ARY2bIvmMtcqfyULUeN
         EnEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740792212; x=1741397012;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uMeHz62fDGvf8tHSG9UR0lUzfNjHQKzyZfW4Wd98gl8=;
        b=pIpdtNjf2cnrGzud7Lt1tHqz3EqTHrtgZyJPN/YwTJpS4VQtKgwOSB+u2q6ozu/ZR2
         HaVtD6538vZx1NJp59uTX3OvjjRf0srvsIMzzC5hT/tcw0fmWQwE2+PF6z5gjRyxxGi/
         0fe33cqyZR3LQUDnoTLVmSeWlIA/IHfyeWP4XZ7Vw+sSSbdwFh1SfwwO3bU6g8/Ur+Xm
         buFAyOVCGlLkWYt+PiEwKuK1XGwwJ1s/QgdxHZ7Q8+/wlEJxifpx0LTSZlVWnEj+ufhA
         J5LQD+NGJvFDxAQynF6UqIwjHXLZWtRWHTiHJ9hbb25GkXKDxUlo1ADeYxrJYQGV3aG3
         aMBw==
X-Forwarded-Encrypted: i=1; AJvYcCWvd7mvBNKxPBZqInINHU6tgANWO11sI4xNemcP1z9A4owDqouYwU885wrDVADY7oNb38l0l0dRSe0PRJE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz+cziR97XOGhsmiVFeIRLWqZ648YmTZMkFPWIWeSNAdMKgepK
	W8fjmK9RGZOPV7FfXuhS08hpTvrZyn/CJdcymu/EJbTFdGfuKg6jcU+6wA==
X-Gm-Gg: ASbGncsVhxb3K7lD+CkGR39fTg2S4zV1Y2P50CO0S47jI8ueMPY18bpAwa4c7qFA2ES
	kiVNVZeTkNP1bmX3grz6mLwivth42kh9vl73U0r3rgn6PwWckk2XVmkNKc3qP6y1BjBuGwqE6bO
	Y6Jt6EDdv2A7Rhqgd6ym2NgzxP2smUB+nqdwzOVcPKGQW50+99MqJiS6qZD637DTs+syWQHSGcJ
	9vAH6viThfGiasKPhR8pVUd3TMUc57ZGkCgQ+tV8fCZYaI+1Fl7SYQt+ARHDmgwYev0DnJ4yx18
	KWYhq3n+KAL3VS6Wxj2soX6/JdhCxeG6dmyIBxz00fsaWkjDxxq9U/w=
X-Google-Smtp-Source: AGHT+IHtFXWej0XzCMOuuyU0kbm3HzU+Nw3gsnAMeOWJO4CqvFP+K5eNx+djd4/aojUFBbQanSEADA==
X-Received: by 2002:a17:907:1c8d:b0:abf:23a7:fc6 with SMTP id a640c23a62f3a-abf2656e759mr608356066b.16.1740792211898;
        Fri, 28 Feb 2025 17:23:31 -0800 (PST)
Received: from [192.168.8.100] ([148.252.144.117])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf20eebff7sm274705266b.60.2025.02.28.17.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 17:23:30 -0800 (PST)
Message-ID: <6272ce74-cd1e-4386-ac84-2ca7df5dab33@gmail.com>
Date: Sat, 1 Mar 2025 01:24:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: use rq_data_dir() to compute bvec dir
To: Caleb Sander Mateos <csander@purestorage.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250228223057.615284-1-csander@purestorage.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250228223057.615284-1-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/25 22:30, Caleb Sander Mateos wrote:
> The macro rq_data_dir() already computes a request's data direction.
> Use it in place of the if-else to set imu->dir.
> 
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>   io_uring/rsrc.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 45bfb37bca1e..3107a03d56b8 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -957,15 +957,11 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
>   	imu->nr_bvecs = nr_bvecs;
>   	refcount_set(&imu->refs, 1);
>   	imu->release = release;
>   	imu->priv = rq;
>   	imu->is_kbuf = true;
> -
> -	if (op_is_write(req_op(rq)))
> -		imu->dir = IO_IMU_SOURCE;
> -	else
> -		imu->dir = IO_IMU_DEST;
> +	imu->dir = 1 << rq_data_dir(rq);

rq_data_dir returns READ/WRITE, which should be fine, but it'd
be nicer to be more explicit unless it's already enforced
somewhere else

BUILD_BUG_ON(WRITE ==  ITER_SOURCE);
ditto for READ


>   
>   	bvec = imu->bvec;
>   	rq_for_each_bvec(bv, rq, rq_iter)
>   		*bvec++ = bv;
>   

-- 
Pavel Begunkov


