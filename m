Return-Path: <io-uring+bounces-3319-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C485988F39
	for <lists+io-uring@lfdr.de>; Sat, 28 Sep 2024 14:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AF331C208CC
	for <lists+io-uring@lfdr.de>; Sat, 28 Sep 2024 12:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B67E81862BD;
	Sat, 28 Sep 2024 12:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="m3UU0MJf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854AA17C9FA
	for <io-uring@vger.kernel.org>; Sat, 28 Sep 2024 12:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727527257; cv=none; b=Hd+dMsYf26Wx2alPPo8LjcMmBlILJU0yzqOtsCtMh6OjlKgul7Ba7HK7caxHqyBgQgnTzJHiO6783+ZszqZWl2s00/gjdzYwU7ANu2k6pEkK7/MENNflndkCLczc7zVF8Mes7CBXcWqCTZFnsPy/Gup14ef+628aC+MBHFxZmQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727527257; c=relaxed/simple;
	bh=yS4jH8DCYpPyJ9dswxSqAG4XUlB3pjPsAosBJm4kd7U=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=XssjQGxuIGttjTT7v1+ayH7oCl1dA2lSlsfJyhedgMSf/3ot7YxfQGkNxzHOtOtHIXPiZs8yiSMzVUaQnSEmjA8w+m7XlwXbxzQVkURtlTQPvCi3FR4lNscOVrofn5upZ7sJX6OQgshqWABYrpVw66LMQhrpDx4/sJYCFYmu+S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=m3UU0MJf; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7d7a9200947so2052322a12.3
        for <io-uring@vger.kernel.org>; Sat, 28 Sep 2024 05:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727527253; x=1728132053; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gmxZU9likHIZSTT8ZoDeLYR7nGGnPAouUkXM6H8Ww4k=;
        b=m3UU0MJfnLnPODEPy4UpC3MrRLF7fmMlo3RNKonYiE/hoDJzrvkbhB9hY8U24AhDKZ
         watWx+sAQEd5NdTkmaI7zMjecA8+T5ylguBnpc0U7q+gy50Z6Wrr1jAZCl4TJ3oohlWa
         AZ8+7bUBOnkl2+g27ERaWDc1SdcLpvEd5exUsZ8sHVotYqNDwZ206k30cyE7FuFCWJhw
         jqhqe0Afjsdf8u5l2Q9+iqEugj76yW3V7Dh5gmRoyjweWfR8/cBBaBkqXsCao7y7miD4
         Zf173JDlwL0PvZ24YXStMc2gGjizeUoJo9KDpwPv9ILJ6RJlzUhrSCOBGAgcXWCer60H
         9IMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727527253; x=1728132053;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gmxZU9likHIZSTT8ZoDeLYR7nGGnPAouUkXM6H8Ww4k=;
        b=torTBBdHUH9lDw/WpnHrTgUGrp+FEtSCJfkXtL0iMH0RAPSidQIb9Z9PQNE6sx5JmU
         aRlSwjXxwux64uOMxI8gokhcrwVpbQdMyai4V66620OjYCwr3ii2xZGZQ+EhiLgOphUR
         GpHdd04S07CypQppPMiRkvqzSXyaqmI39ESWYH5ZpussVmGD42Fp64pn0zbSie1NSNBX
         z5jGhCyHLxAWKOe/7Xna+ufI52I0Riw2/9gsyZqjKFmm2vA/lxbhNFnZEVDygY/4/47D
         FqabP6uOzoiPTRwCSev1W7QUXDCmYkQjSNX11znEcJKJR76hSljCwswE5agM0GaC8Yfn
         jNMg==
X-Gm-Message-State: AOJu0YxWMzZrTJ1Js8f4T8RLy9jnPgTvhmjW9B3pKIs0JyFpzbAWVJZA
	Y16pGFCeletmX2e0dMMKFXtKw7T+QIplxRV8bpI929u+eFE/pcfAe26RtQdB6Ilkgr1zhEnHXX+
	Ar00=
X-Google-Smtp-Source: AGHT+IHOYCAHUdxHFUYLQ8uOwer/7fCGyzIt5ziUnGg8/sj3eAIvoba2Y5EgTgesUAH+HIFBWRNXUg==
X-Received: by 2002:a17:90a:f002:b0:2e0:89d5:9855 with SMTP id 98e67ed59e1d1-2e0b8b2256dmr7543866a91.20.1727527252953;
        Sat, 28 Sep 2024 05:40:52 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e0b6e0fbf6sm3909281a91.40.2024.09.28.05.40.51
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Sep 2024 05:40:51 -0700 (PDT)
Message-ID: <2ddaef0b-0def-4886-ade6-8fedd7a0965f@kernel.dk>
Date: Sat, 28 Sep 2024 06:40:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: fix a multishot termination case for recv
From: Jens Axboe <axboe@kernel.dk>
To: io-uring <io-uring@vger.kernel.org>
References: <fc717e5e-7801-4718-941a-77a44513f47f@kernel.dk>
Content-Language: en-US
In-Reply-To: <fc717e5e-7801-4718-941a-77a44513f47f@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/28/24 6:18 AM, Jens Axboe wrote:
> diff --git a/io_uring/net.c b/io_uring/net.c
> index f10f5a22d66a..18507658a921 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -1133,6 +1133,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>  	int ret, min_ret = 0;
>  	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>  	size_t len = sr->len;
> +	bool mshot_finished;
>  
>  	if (!(req->flags & REQ_F_POLLED) &&
>  	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
> @@ -1187,6 +1188,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>  		req_set_fail(req);
>  	}
>  
> +	mshot_finished = ret <= 0;
>  	if (ret > 0)
>  		ret += sr->done_io;
>  	else if (sr->done_io)
> @@ -1194,7 +1196,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>  	else
>  		io_kbuf_recycle(req, issue_flags);
>  
> -	if (!io_recv_finish(req, &ret, kmsg, ret <= 0, issue_flags))
> +	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
>  		goto retry_multishot;
>  
>  	return ret;

On second thought, I don't think we can get into this situation -
sr->done_io is only ever used for recv if we had to retry after getting
some data. And that only happens if MSG_WAITALL is set, which is not
legal for multishot and will result in -EINVAL. So don't quite see how
we can run into this issue. But I could be missing something...

Comments?

-- 
Jens Axboe

