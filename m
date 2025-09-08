Return-Path: <io-uring+bounces-9644-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1F07B490F0
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 16:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D45916D7A2
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 14:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 788E82FDC53;
	Mon,  8 Sep 2025 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="irSR+pZr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA793081AC
	for <io-uring@vger.kernel.org>; Mon,  8 Sep 2025 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757340799; cv=none; b=u5btkwuSawA5jJubTCejZWLRjjne19lqAygoPsoWuf1SZzBxCb4g/ZHNCte9l8QsVWOmEwWJyohIZTWc1yUvF4tBizNnxTk+GF/fUNcFsSYDLW2/Cw3cTueZk+++ufyjDwsotP8kfYSBXnQAYeibZff3MjNhtMs1zoCvZjpnVls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757340799; c=relaxed/simple;
	bh=h0D0SEqPji3fHwIoVrp0jHPUatei55dk0QRkQqv/duw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YKbxRz2/ZMM/pNEZnKWY8kQYmxm9JZLC5rCX3JqWiPo1XyQUiatRejqDxHaIrjQ143Qlg+Ty2xybIX5MHM26xVbBzxB+iujsJynD2+8142jbaPGDZ3VrcjpRPs2ntMp6QBHzowssjivc3RH+brCD3HTtnhWextp7guNjsBytY2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=irSR+pZr; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7725147ec88so1798364b3a.0
        for <io-uring@vger.kernel.org>; Mon, 08 Sep 2025 07:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757340796; x=1757945596; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UZF66cJNg0DGdhDsxeGBFMCJxYCrZerYg7Gnl/nvd78=;
        b=irSR+pZrOh6cTWRO+LIl2EooH4nGGi0dQwOOZha+0ZoTMFwTfA2G3ocqrH4P3+j5Mg
         rtp86fWI9r0pZj8j1ODng7l76NkaK9Pi9mTZibj+qZWa3WrMXF6Rq9Slz9p/E2VtzBcl
         OSFxKNNKoA4klxs2PLfWn9sQXcCzpHQQ/DjqI4LBKYZJHu/ktqazNRUEnQ123+i1NQMA
         hjMko+p+YJd9XYhRnwAFF/TJCb2wVuFAzKkYLQ/BQdtwpPYUn5mBK+0J+nRnLMDqCjMx
         GEQ1vBSZqbSj9J8Jqx3+y5hZD2DKKOMiEcwTASUoeVxPOY+PRH2K8wFj3Rsu3TkYJghk
         p7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757340796; x=1757945596;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UZF66cJNg0DGdhDsxeGBFMCJxYCrZerYg7Gnl/nvd78=;
        b=YYvcqGj36PleI43I13SqUORw5DTeokvGHnQ8taqugItSRKqGbvznCsZjrUJ8NsTodb
         /FsYvgOdiUWL8Xymg+2fkwfNcf7I3O+rEBpu9WLZkuO0d9uKZc58uidhd5/R7FXv87ls
         J3lMbkigJ4sElrNBYR+Dxv+qS3mP/UgXGbsRgswjPLjYsl0/DGqHKYfSRFAnZjd6wfBh
         VrMR5rB0Sq0X8UR4oajRVo+hinNyZX9zYvzlmxEmXyeawHaHA+vcEDx7WpPmlYCrShB3
         my4maAm+pVm53YukQFw5EkjNAv9Lhvm73HFCbXptfYah73MonUn08XgdMZKu2JVdqHIz
         dGzg==
X-Gm-Message-State: AOJu0YyzomyIKBs6/RajHp/U+1H6wtxtOanLskNeEl55KZoQSS6+5BC/
	TSoByRn0WKbL1YhWnk9pgnS9dg+eLMMUYR3LnR8hMSiwqpx0mekBhHEjfh8w5XtD0K4=
X-Gm-Gg: ASbGnctSHIyc5DhnJPq3jVe5ZnApXIFkuDCaLTwTjP9WxDwBITi2BNPIl5O5y/fFJQq
	O44CE7yE7Zx6iFE8bmAY7nud07rwcqobYI4S760xK1PGccD/+g+hGLc4wRIdvxMqzWCHIAp2qqZ
	w7pgiY3k8hTyQ3fLqPq70zXleAxSavVvbyzS4RpwTUHDcnMhKBK3WiUftMrLaP+IK6NjADucYqW
	M2ZQ+ZoI8RUVgQEx28hDUEb1shIstP0vTt6SnLtPrUE8hg+3pWDJBclmTrNqhNq8r2E33kNnd43
	JQEZF15gD9KhoXlFSM7w6arKfd8nAwa8sEJZiQ4FGGrrhYfdJNJrk2a0Lo5DAQrylaYyMP21TDe
	RUGjdYNC8x46lYpC1hUOBddNCShA2f2U=
X-Google-Smtp-Source: AGHT+IEsiSNhHutwk0RCJsT9JHAXZkKZX+8NOR4PeGFuw6oURb33W4QXf2+JENghOU4mdcLKN0AzOQ==
X-Received: by 2002:a05:6a21:6d99:b0:246:5be:ca90 with SMTP id adf61e73a8af0-253777539b7mr10169857637.10.1757340796130;
        Mon, 08 Sep 2025 07:13:16 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7724b62922dsm23941487b3a.27.2025.09.08.07.13.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 07:13:15 -0700 (PDT)
Message-ID: <07806298-f9d3-4ca6-8ce5-4088c9f0ea2c@kernel.dk>
Date: Mon, 8 Sep 2025 08:13:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] io_uring: clear IORING_SETUP_SINGLE_ISSUER for
 IORING_SETUP_SQPOLL
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250904170902.2624135-1-csander@purestorage.com>
 <20250904170902.2624135-4-csander@purestorage.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250904170902.2624135-4-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/25 11:09 AM, Caleb Sander Mateos wrote:
> IORING_SETUP_SINGLE_ISSUER doesn't currently enable any optimizations,
> but it will soon be used to avoid taking io_ring_ctx's uring_lock when
> submitting from the single issuer task. If the IORING_SETUP_SQPOLL flag
> is set, the SQ thread is the sole task issuing SQEs. However, other
> tasks may make io_uring_register() syscalls, which must be synchronized
> with SQE submission. So it wouldn't be safe to skip the uring_lock
> around the SQ thread's submission even if IORING_SETUP_SINGLE_ISSUER is
> set. Therefore, clear IORING_SETUP_SINGLE_ISSUER from the io_ring_ctx
> flags if IORING_SETUP_SQPOLL is set.
> 
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  io_uring/io_uring.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 42f6bfbb99d3..c7af9dc3d95a 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3724,10 +3724,19 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
>  	 */
>  	if ((flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED)) ==
>  	    (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED))
>  		return -EINVAL;
>  
> +	/*
> +	 * If IORING_SETUP_SQPOLL is set, only the SQ thread issues SQEs,
> +	 * but other threads may call io_uring_register() concurrently.
> +	 * We still need uring_lock to synchronize these io_ring_ctx accesses,
> +	 * so disable the single issuer optimizations.
> +	 */
> +	if (flags & IORING_SETUP_SQPOLL)
> +		p->flags &= ~IORING_SETUP_SINGLE_ISSUER;
> +

As mentioned I think this is fine. Just for posterity, one solution
here would be to require that the task doing eg io_uring_register() on a
setup with SINGLE_ISSUER|SQPOLL would be required to park and unpark the
SQ thread before doing what it needs to do. That should get us most/all
of the way there to enabling it with SQPOLL as well.

-- 
Jens Axboe

