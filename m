Return-Path: <io-uring+bounces-6065-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D63A1A5D7
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:37:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1E481697A7
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5713C211A1E;
	Thu, 23 Jan 2025 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z6YFNDug"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9510321171F
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 14:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643054; cv=none; b=QJ+IabXWWO2t1Pf4hymIXAd1I/YO6DkPnUteT4F2rHIhw1Bp1FctzsZKve70TCWs/ZzbcQeWnlepm40Qs2dvHfrkoFFk+OABaGw/4CWnzuqRZ5qs5NXgbV1gzvdQha249Vfv2iuWndGdJEBmM32KBNhMK0GG1vUkPQZERqI2m2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643054; c=relaxed/simple;
	bh=Oh8Uh+WN3WAjPGXA0iZdr6LRP1dTgMhZcmUsZ2O2uXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fUn3NMwOnKcy9Q5zFfPAS8Nl7JL1BWEZcidP8pEG3HWlBTu9y3B3A7qjdohwfVgp45wsYttYwSGbceZj5kposnkavaAFBcfDCEmiLSEpO0Tg7YYrD4aH9aQ0MPQBVOYN3Tg4AI5k4KEG1YFhVmZAjRGw2bfjSU0CrHNZy5IlaKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z6YFNDug; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d90a5581fcso1832654a12.1
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 06:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737643051; x=1738247851; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xDKS300ZVxUd0WL2unTBrPXK6V31LYbpkau3QKnuRMI=;
        b=Z6YFNDugW5/fNFwGvVCYeAClPKTdv3xWEMkLeeGa1RcKSrbciPTyXi73kUdhzFITrH
         3nCQqH2e8soZA6rVlka8x4hWrqSavL8WRSCzce6IQOxFDEo7ZYCSAkZf5vRJSlZ1Z1Si
         L89Wc3fh6kU84kabiStYQsY3iykXYzQJyfjSWUFndeBqWnds3QJDb0xeo7RRaazTgLbW
         n90WcL8XvUmR04dw+eWyRBGYqf39C2Q7nX4NN/TjIhzEuj2IOvdsOvNmghnsqprspW29
         5yIuMX145RQJPKGW+mIfQZgGyLQ8STFo14NHAkAuzm9ByvCy8jJseqC8j4pPe/v/fuvo
         EOAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737643051; x=1738247851;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xDKS300ZVxUd0WL2unTBrPXK6V31LYbpkau3QKnuRMI=;
        b=XV/6Q7dFUG+yjYRIm5iB1hSXQHkgCCtBN5NS9Uc2GSi/lO9c4OxEQCuiXXmEL1Jh6H
         AejQr4DUSv2S003Won3iRaY5XpYB/HeqdLVyv80ZgrBx8pTd9GJuS13vVJamWUlsTIji
         wgW/pPt3K8w8gqwaOoXo1Urc7KSUuCuu4Evyin3/rV5BN9+NDcBbil3c94G0yXG1Uxvh
         CM0aCAWEFgkgd7LU42TjrkdwfyXOq/kVL8iwDf2ExH0SA7H0AwV4qIk1TOXxzEz8x96+
         j9UaD7kxLhulZQuPgmBhoXSvzK7A66Df8eWM1HdRD1XfqxWBx3xOBDDAUAjL2rbSiEcb
         Pibg==
X-Forwarded-Encrypted: i=1; AJvYcCXsgxXdp5FiBfXcM4Clt0eiK6qGnztNm7ToqzjVq55+JZqMGWI7P2E1NfKLEs5qDkQkdBrEz9fmsQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyrPIhPOYAf0HjnMBbCIgEHmyqrbjko0z/K5DtkFeN3C1R/Cgb1
	sti6rn06qCBkQebRB4PHH77ZVabA9fVuB67aZ5fp3nsKlC2h/ghh
X-Gm-Gg: ASbGncuHs21jNEz5r9h6ENaIbvbwFAQLmkmCiS4B07ukOTBrlT8KpwSFuYVQq3n9/yt
	K+EcW6TOs9JlT8glkSE6eTIboH+BFs4XM26CpXjeZ2vCR1cSpvcs6Qw5V3cszaEeYgHZ8C1w9bt
	k8c0QMXsHFyMgxDSXFjGNiqXIzY12gcFBo5XksJPp56jUHcEPv+Gu3lpM6+FxrJVd4g7ywfQUFj
	I7fq+rFXMbrIBusWxz1fEPUHz8RiY6BVrxydxMm5hnrHDyZvtFxuuvx11VPeS97Zwqb/hZ+O6Ln
	iecGpBHv9onBYUAYV2zMz797dMSUJQV/1fF+0Q==
X-Google-Smtp-Source: AGHT+IE30ygiNn15XyZ/PeU2Yg1fVxOCicM535Ojm1WD+LTyopkRq90oZQlluqDvMDaafLJo0kXXTg==
X-Received: by 2002:a17:907:7fa8:b0:aa6:af66:7c89 with SMTP id a640c23a62f3a-ab38b0b68b1mr2719258566b.5.1737643050588;
        Thu, 23 Jan 2025 06:37:30 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:7d36])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f87d70sm1097812866b.142.2025.01.23.06.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 06:37:30 -0800 (PST)
Message-ID: <914661c1-4718-4637-ab2b-6aa5af675d23@gmail.com>
Date: Thu, 23 Jan 2025 14:38:03 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/uring_cmd: cleanup struct io_uring_cmd_data
 layout
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: krisman@suse.de
References: <20250123142301.409846-1-axboe@kernel.dk>
 <20250123142301.409846-2-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250123142301.409846-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/25 14:21, Jens Axboe wrote:
> A few spots in uring_cmd assume that the SQEs copied are always at the
> start of the structure, and hence mix req->async_data and the struct
> itself.
> 
> Clean that up and use the proper indices.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/uring_cmd.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 3993c9339ac7..6a63ec4b5445 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -192,8 +192,8 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
>   		return 0;
>   	}
>   
> -	memcpy(req->async_data, sqe, uring_sqe_size(req->ctx));
> -	ioucmd->sqe = req->async_data;
> +	memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
> +	ioucmd->sqe = cache->sqes;
>   	return 0;
>   }
>   
> @@ -260,7 +260,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>   		struct io_uring_cmd_data *cache = req->async_data;
>   
>   		if (ioucmd->sqe != (void *) cache)
> -			memcpy(cache, ioucmd->sqe, uring_sqe_size(req->ctx));
> +			memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));

3347fa658a1b ("io_uring/cmd: add per-op data to struct io_uring_cmd_data")

IIUC the patch above is queued for 6.14, and with that this patch
looks like a fix? At least it feels pretty dangerous without.

-- 
Pavel Begunkov


