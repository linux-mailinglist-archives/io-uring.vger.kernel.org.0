Return-Path: <io-uring+bounces-7512-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A5F40A917F8
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 11:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 633F97A1EC8
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 09:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 659F2225A38;
	Thu, 17 Apr 2025 09:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hENmNsn2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3FD225417
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 09:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744882392; cv=none; b=Pve7LQkwB4Dgr7PAPPnYJS3sw9F4vb1BIwfharCcVQr2ezxZAC1EgyUCEcei6GkJIwOgKL9i2gRJFwEdPpisEk+lJDIS7UKtB+iBxRv9GQB0M7KJJeB2VTTkziZaLB6Ria2r2jfdXpxUeyC9deELhK1uX2XnIAcxbWW+JEN8OHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744882392; c=relaxed/simple;
	bh=kjQVdImFcUci9ZL95FJNNpmWUO0QBnEtERfeoNwktjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eB4xpwcYbUiirDsYKZJYpve5Ks/BhBefyi5R1R+kM0z8ww6Z0Y2yybxfd6VPZXbMcV8nhNNI7SN4gfY/FU+cHLgz9ELgt2MKrdoRgJM8cTsW+2iPqQGNk+cv6EYmdEeYh5x1gOylPJh2L1BUuR1pegOhEuNTqiq2uE14vvm15Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hENmNsn2; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5e61d91a087so876879a12.0
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 02:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744882387; x=1745487187; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AhMLUMoUvV1STyO8JrbLoJJ0nPcuTa/km36xzYiBxmA=;
        b=hENmNsn2o4n562HdXAajQ096hJYGHlFZal+MaEiuDq7bDY+f+OPf56H1EZvIYM3XZD
         chTtWnWvtkUoXb33gPXajUfrMbekqyUAhwJf9jPyz/+cP18Fqr2H7yr7TJbIvyY++5jB
         FezaqURnKSxmXpTu44GLWSXhTww8bEkaXAUBf68cExwPt6AKYcmBd8PFWUruw+i4xc+1
         2CXRjEHmUOCiqMoOx2g+0iWpP9V5e7irQyuinTMaeGQK0eaRIzVw2FM0+t8j5scXNhoG
         CMocQxvRBgAB8KNB59G3ZOwUSrJ9W/2PARgABsdxc7xFnnbcTSuAHluffVNWh/lr9oep
         fpKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744882387; x=1745487187;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AhMLUMoUvV1STyO8JrbLoJJ0nPcuTa/km36xzYiBxmA=;
        b=H+kF9Vl6dz7mNdgrp3sa+EhU/BjLotYRSnOUeH+cr7cuCDyqjqP7SG/3Aq5CLfx0lR
         XC5eLVHGyUwpLBagVO7PR38rr0OoleaVMnAcFyLSDYdjjCO9A4aV5Js6keyFnX8Ujo8F
         TxvIYLs5YB0pLo0e1WnOjpqTb05HbXqMNNQxqvVGSzY3gSPG+FVwPc/ed534Bst2LjCc
         bDtudTx+swbjkNxgw6AwMgf2+HTsMTMwbKqPuH5BejWmRAPPGpdxFOwPig0zO8IWfgDE
         l942f4WZFsnsbUkYNSdg+PBIZ8CsWjZpAEwSEFZ1pSF5t4JrhTdILp6dlL4ryM/D0SjU
         XKOg==
X-Gm-Message-State: AOJu0Yz8SUa0hWN0Zlp1ip02D5CQayKL4z3cLMqVH3LI1ap0cjQuKTE2
	GREslXZ+J4j12ZQQKhIwSzp5NMwXhGEwYICvYSieLz2Kw9TcHEWa+c9N0Rl0
X-Gm-Gg: ASbGncsIhuHr3hfDp5nRtD8+ZlgdLaTv8IiFXpBhdS7Tv7ZKm83MlOMAsrFGXx7wXRB
	lRZdaC2f82aXsWLXWNnBy0p5z/JlbZF1ndNQLRnZgMKAmxy82EZGqOWDnwCVeznY4wny6JhGngy
	mtEuLUHLBEd4r3ZjhAoKJ1CbktvpTAgxh1AWO/ZT8b5bRYHNUUPf2hYoooFBbWY+uzTUIofoVzU
	C6aY8XNbzlnCRT3MYLSD3EH44NnnvQFO1Apk4NkP0ysKv83iVEvn6TU2vF17b+lySVHdRCubybr
	qdWkhTk7bmmaeb7dnnQ3Rn4E2PKHK3nQE/ZIKHFzqIR6lfY9CAr/hz5zqXXaGoi8
X-Google-Smtp-Source: AGHT+IH8E7ocnLIcDmSbF3LviuQ55Xg7T6WiZ8zHvLI+3lOKMmegWLv4kgL5BrfTrQHT4nMEqEZg8A==
X-Received: by 2002:a05:6402:51c7:b0:5e5:b53:fd49 with SMTP id 4fb4d7f45d1cf-5f4b71deee7mr4915992a12.3.1744882387245;
        Thu, 17 Apr 2025 02:33:07 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1e4? ([2620:10d:c092:600::1:c8e6])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f36f5054cfsm9706295a12.55.2025.04.17.02.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 02:33:06 -0700 (PDT)
Message-ID: <d699cc5b-acc9-4e47-90a4-2a36dc047dc5@gmail.com>
Date: Thu, 17 Apr 2025 10:34:23 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/rsrc: send exact nr_segs for fixed buffer
To: io-uring@vger.kernel.org, Nitesh Shetty <nj.shetty@samsung.com>
References: <cover.1744882081.git.asml.silence@gmail.com>
 <7a1a49a8d053bd617c244291d63dbfbc07afde36.1744882081.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7a1a49a8d053bd617c244291d63dbfbc07afde36.1744882081.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/17/25 10:32, Pavel Begunkov wrote:
> From: Nitesh Shetty <nj.shetty@samsung.com>
...
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 5cf854318b1d..4099b8225670 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1037,6 +1037,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>   			   u64 buf_addr, size_t len)
>   {
>   	const struct bio_vec *bvec;
> +	size_t folio_mask;
>   	unsigned nr_segs;
>   	size_t offset;
>   	int ret;
> @@ -1067,6 +1068,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>   	 * 2) all bvecs are the same in size, except potentially the
>   	 *    first and last bvec
>   	 */
> +	folio_mask = (1UL << imu->folio_shift) - 1;
>   	bvec = imu->bvec;
>   	if (offset >= bvec->bv_len) {
>   		unsigned long seg_skip;
> @@ -1075,10 +1077,10 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>   		offset -= bvec->bv_len;
>   		seg_skip = 1 + (offset >> imu->folio_shift);
>   		bvec += seg_skip;
> -		offset &= (1UL << imu->folio_shift) - 1;
> +		offset &= folio_mask;
>   	}
>   
> -	nr_segs = imu->nr_bvecs - (bvec - imu->bvec);
> +	nr_segs = (offset + len + folio_mask) >> imu->folio_shift;

Nitesh, let me know if you're happy with this version.

>   	iov_iter_bvec(iter, ddir, bvec, nr_segs, len);
>   	iter->iov_offset = offset;
>   	return 0;

-- 
Pavel Begunkov


