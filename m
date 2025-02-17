Return-Path: <io-uring+bounces-6485-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81F67A38535
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 14:58:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55C5F16BB1C
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 13:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CEB921B18A;
	Mon, 17 Feb 2025 13:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="a6CYJ0zK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9864713AA5D
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 13:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739800689; cv=none; b=kkCKpd6hIn+YSL7+iEoqZNnuNxt7u15ch7mvdf64mWvjhLSfk4sxh9VpPNtA2II3zoMVMAzTNWk9WaZxxXRyUaYABzK8+d4ZEICxCE9xMS7rIgwGoie3oqNMTtAkX+E3MHZauTTShijBYQL4k4jFrv2c0roMNuXhtQA989scpHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739800689; c=relaxed/simple;
	bh=9fIXCx6lew54/AwqGtOZbAzxkNSWdyKtCHy8pIdzZCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JEeBqRTBkJ5Ks90Shee8a0lwQVqq26hQMuhyoS4kimPvDJ4qUnHTQzrLGntRYSmzwN+rcpul0t/0CYK9WlJhUSzoMRjTdcMvqRMB4cm3CkRWu7KiojKTOMndm2Py7cUlYHfnIv76RKsJoc/AC5aD+Kgfp0+KCUTkbhzqHPrEYds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=a6CYJ0zK; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-8558a6ce042so27010639f.2
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 05:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739800685; x=1740405485; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7RGUO8851SfC0Hpeg2MzrG+oPMBnisEuD/CfyWZjmmw=;
        b=a6CYJ0zKJ/OwjU2R0GDiIOX2zdfadCGORoyhCPYUqamSYyfiY4mfmRoV4wSpEUbJsv
         m4PIzCcwT9VLdrv7yrqW+YvoehwWp2ozI/D0LWbK8itvMpJdJ5Na8wUDTt9qmsg+b6dr
         QWJ33kx98Q3GTBmihlBjCPplewxNkOfqlgNrAnmCRIXm1BSMuODRPUWH5XqNvN6tMqPT
         zW3Fu8akQ+vN2pRSprF5zJ/4GjHkdfPHnFqmT549bSTIDvTwDShCGhLsQPBSD7TGaFMi
         tMVJKhwoMv6KLUAnCbN8yRwHkOQsmli2jwrZJ6no+8jlghYwGt6zqgtRPumjFhGF4HCg
         Tc9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739800685; x=1740405485;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7RGUO8851SfC0Hpeg2MzrG+oPMBnisEuD/CfyWZjmmw=;
        b=e1fcKl+7+wH+tCMp5iQS4KxCon/bIG1ClGX4VSjUwT24zjjSSJiVlYwDKFW+lKZIQk
         BqpBcMR9GVijIRSPTnPBfboIAf/ciSRT9/9tZr0LVAxDh7PUilwtPcg2zxOXx9u0giQr
         HtdYrBllFwkL0Jl1VM6YJ6rhmxXmBly+zkIkTdFYGFsl/yrOWbTT62VIUoeFDtDCrZgs
         ry7dlhquoAe+lBsresTSfOQMFZqq+xUkgx7RsIqAs/m+uU3/+robTIE37958ErnXbdNj
         SecKKL950VhpvcMGgNmZ8nBNWxevZVEO7qhm3dF4pVm5EvukfROAweeHFwHybJHnpRCj
         NiSg==
X-Forwarded-Encrypted: i=1; AJvYcCVGNTKgUTfEfi2FupgDoQM15sb7IsXwGrwhgUf2GoTyRmHbaYgEIajGCWIYWGmlL3Pf4Ik2k/cFTQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxuJtlM6WjV5QZG2RTvvrfI72rc8nfoWZ4fVcWZcUzle1VrN+Yh
	sPF1eQdkjvD3gSAnjUeif1PROpDz+3+PEQQLbG33UpkAZ4InWEdRgfOqA/7Oct4=
X-Gm-Gg: ASbGncs5I8olREN7SzMgvmbmIRAZZq+JFJBtQh4FbsqPO70i3EM6dlUb6BO43UEjCJz
	7sokBIlGKHU9j67bFugb9VNOQm4t0H1hRFqx1jbCq7OBoSuaGoX8d0P3fqJ30HLIyID2MjLqxS8
	pACPYnnu0V+YkYoHQa0usx4xOngnkReMDAcre8/6L/+75K3N9XuH6Nk9ZDKA/kostDSKM0/FSIM
	6mwGxyTlFxfp4Ak0I541SHjbVEDbiALxsPY/ZFqPuqWMQx0THaEDv04ZepyxRxE+AxxCZqVgh6w
	mfhNMBZTu3g2
X-Google-Smtp-Source: AGHT+IGQj4u7NgKz6iqf55U4605BGO8BmRa0oTix3Qe5mV1LLdk+FO+DKSlqiPTCe+0TfkKy9cxq+Q==
X-Received: by 2002:a05:6602:2dd4:b0:855:7285:8458 with SMTP id ca18e2360f4ac-8557a0d201amr927275939f.7.1739800685571;
        Mon, 17 Feb 2025 05:58:05 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85566e120cbsm189050239f.9.2025.02.17.05.58.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 05:58:04 -0800 (PST)
Message-ID: <cd42f912-df8a-4c9d-a891-1c127f6b6fa0@kernel.dk>
Date: Mon, 17 Feb 2025 06:58:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: forbid multishot async reads
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/17/25 6:37 AM, Pavel Begunkov wrote:
> At the moment we can't sanely handle queuing an async request from a
> multishot context, so disable them. It shouldn't matter as pollable
> files / socekts don't normally do async.

Having something pollable that can return -EIOCBQUEUED is odd, but
that's just a side comment.


> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 96b42c331267..4bda46c5eb20 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -878,7 +878,15 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>  	if (unlikely(ret))
>  		return ret;
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

This looks a bit odd. Why can't io_read_mshot() just clear
->ki_complete?

The kiocb semantics of ki_complete == NULL -> sync kiocb is also odd,
but probably fine for this case as read mshot strictly deals with
pollable files. Otherwise you'd just be blocking off this issue,
regardless of whether or not IOCB_NOWAIT is set.

In any case, it'd be much nicer to container this in io_read_mshot()
where it arguably belongs, rather than sprinkle it in __io_read().
Possible?

-- 
Jens Axboe

