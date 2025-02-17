Return-Path: <io-uring+bounces-6484-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D37A38519
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 14:49:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6372F16CF5C
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 13:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FB13748F;
	Mon, 17 Feb 2025 13:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B1gFNiKz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63A2125D6
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 13:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739800102; cv=none; b=lSvG3H52+uDlDHst3CAjw+STVYEga2eU48z6TaSktTICmfUgm7qa2G/UFv4qaHvAIlhiWRJMwSmHY6Yc1ez89TUVxVLMF9qSfjUKK3KFiNKg53AAy5eCcCSJs3oKHfczwNpEdPw7KVvvJReIAsP1VcPuqLHAMcRmoG008hmI+sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739800102; c=relaxed/simple;
	bh=e64M6OiLRmAD22NrKTjF6urguRAub+PHbd5pOQtfVpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=NinX+tmq7N2BLMI30zqhLxX16xVvrpKMP3sa0poCAU1f/mmyavxKglaFpma07whmz9Aszmsocg/r9slHhIZ/cZZ14xRCgdrv8+gEb6ejvZkvhdf+UzcxRfR4kPv4AT/sW5UHbN7o7Jnn/cfPR8cSFiAc5/eYUKG01xLsjdNCdsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B1gFNiKz; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-38f31f7732dso1511013f8f.1
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 05:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739800099; x=1740404899; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EkqN0aawT0JTXtyzjzgfuDqGpLtSIaeqTIrbz7D5kiE=;
        b=B1gFNiKzki488BLpL4PATkZw2iNaE4fW99qqvIrHlt1fzSQciLli36vydPSWs+xCsk
         jmn71TrOtG7syuvjPkwRLyXNdyFZG4zwa4TjDy6XkwkRwiJ0ifc1h6BthH/+3ulEZDTH
         hGU/iP8wijblfBDHYMUbCq14myvp2OEvA1iUWnkUXITdLc0CQSOTeMItky6C+sYTUI8a
         yWtA5cLaI9hSKBIKsF5w8pvuRs7qpJd9eZU531gyynQ8aWHZiU7XfrSnkwyvi+Lala/M
         9TZ8ZmjE/nAn73mz8ivfu0Vxtdlr/DaqPXBQQ/34w4bMJ3HNtbdtr/UDKLJlSzrMKtGL
         T9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739800099; x=1740404899;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EkqN0aawT0JTXtyzjzgfuDqGpLtSIaeqTIrbz7D5kiE=;
        b=a7yr9hBfc78SN9Su0lQFzH/2khHNbiCrt4eyjEob1pJA89S5VoObpdGb+SgBIpru3p
         slPSyPySdFhnjMboSUw/BgRS6e5qjzRK9Kpnnfrj81Ru2rgVWY47I+VgMrn+7KdPrWrD
         gYuRsbbtV5TcipTsG0KfgMLv+vkcmFlbFmGoow7+wuqT31fML+1NAzGG45fkMwXzlMnj
         qoHf8iIxwAThzjpamFi9R2k9hxShlIQ96F4fr84EneWULH3macLWNN7ShiEuvLNRGi9f
         tO/KnmgYQUlwxEWGKJi0VP+FvdfASG2aV4suGF7FVY6PZybwxqN0nRPYurypBmJOP7PB
         K56A==
X-Gm-Message-State: AOJu0YyRlbigb0DooL2IL0yQSyX2yFa2lwxJRWUDjdijWhvHr9jIcx7P
	LjYo4126wGLf3cGHr/PUQnAq/G26dj/hfNS5+fPoCQp1Ny2Z/vU6/iSBHg==
X-Gm-Gg: ASbGncsPW/HGDXtOxXsc4b160wG/88wplgncA6f0z8SJcOzWaL0OsBWoZWG1ktcjKd8
	VWQTikblgbKUlF8HVwxwWMlsK8kyJ/X9hMIfdCq5Q2eMfcnDB+MSr5ZED/1BWXVL8iO+oj9IhTo
	y4pr5sFdpnshqDSOdLjvuNzNYp80E5e7NyF7ZkmYWKahb3XHkKJn1YdqVl2+vqgUJqla+olVqVq
	B/QlSlan8l2D2AgLFZAIh8I5ojOFhjpk+RgddggGBZL8ESQ+EhWTsDilYnEmIBlBFnYDcWh532g
	HSpfgZyCVgeaIwp9eQgYnXCT
X-Google-Smtp-Source: AGHT+IGVWdYiEAWKtqFuW3bqcEYuK/e62T8jgkf16SZtw/DKRE4lJigbHTPa1cZKJ5VphdrF42cmzg==
X-Received: by 2002:a05:6000:18a9:b0:38c:5da8:5f88 with SMTP id ffacd0b85a97d-38f33c30f32mr8234386f8f.28.1739800098693;
        Mon, 17 Feb 2025 05:48:18 -0800 (PST)
Received: from [192.168.8.100] ([185.69.145.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d8dd6sm12453600f8f.62.2025.02.17.05.48.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 05:48:18 -0800 (PST)
Message-ID: <1004a92d-bf55-4313-9ec9-c55f8a1dc29f@gmail.com>
Date: Mon, 17 Feb 2025 13:49:13 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: forbid multishot async reads
To: io-uring <io-uring@vger.kernel.org>
References: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
Content-Language: en-US
Cc: chase xd <sl1589472800@gmail.com>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/17/25 13:37, Pavel Begunkov wrote:
> At the moment we can't sanely handle queuing an async request from a
> multishot context, so disable them. It shouldn't matter as pollable
> files / socekts don't normally do async.

I forgot:

Reported-by: chase xd <sl1589472800@gmail.com>

> 
> Cc: stable@vger.kernel.org
> Fixes: fc68fcda04910 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/rw.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 96b42c331267..4bda46c5eb20 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -878,7 +878,15 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>   	if (unlikely(ret))
>   		return ret;
>   
> -	ret = io_iter_do_read(rw, &io->iter);
> +	if (unlikely(req->opcode == IORING_OP_READ_MULTISHOT)) {
> +		void *cb_copy = rw->kiocb.ki_complete;
> +
> +		rw->kiocb.ki_complete = NULL;
> +		ret = io_iter_do_read(rw, &io->iter);
> +		rw->kiocb.ki_complete = cb_copy;
> +	} else {
> +		ret = io_iter_do_read(rw, &io->iter);
> +	}
>   
>   	/*
>   	 * Some file systems like to return -EOPNOTSUPP for an IOCB_NOWAIT
> @@ -902,7 +910,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>   	} else if (ret == -EIOCBQUEUED) {
>   		return IOU_ISSUE_SKIP_COMPLETE;
>   	} else if (ret == req->cqe.res || ret <= 0 || !force_nonblock ||
> -		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req)) {
> +		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req) ||
> +		   (issue_flags & IO_URING_F_MULTISHOT)) {
>   		/* read all, failed, already did sync or don't want to retry */
>   		goto done;
>   	}

-- 
Pavel Begunkov


