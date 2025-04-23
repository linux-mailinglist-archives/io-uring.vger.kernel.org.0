Return-Path: <io-uring+bounces-7658-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E5D5A986AB
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 12:03:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 898EE1B624D4
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 10:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4ECC2566DA;
	Wed, 23 Apr 2025 10:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bWt18urx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E811BEF77
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 10:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745402582; cv=none; b=ceDXSaNFAGd1++MSOoPHEHTE3iSr42e590NFEC5IBZ33KDoDrTRu/gl+rAmFMdc12w6GvHInOBxsdKbxGsnYPno/aUi6HTRbQIF+2AAFSXf5wEhV2sT4dYFlGvdwKI5SPaBt5pepjUg8tZ4y8Il35qO8iQQXCaDv/VqfepBDPt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745402582; c=relaxed/simple;
	bh=SW7OHNxsUfZgZQBlnuueNgbEV8JC36lDmn/yVNAAB7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UoiKqHIbEO9MC40Ij+D2bSEhSnqAHnQY8TI63qzMBQn7pSX8MyudMdwZq0bwC2zqwuavwIwvdPTAEAciySq/Y496gsL3LmfaAUA+ojsMuoUQToMoCRkPCm+4wM0BFpV2RkGDbx3vI/oJDFZFb2J7pAJeJDbw9yBZ4/MZ2o6mlIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bWt18urx; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5ed43460d6bso9358746a12.0
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 03:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745402579; x=1746007379; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d0qTubwqbpyXi7kz9EsQW3ZLfvBTuWc0PuDl6sNpZ/k=;
        b=bWt18urxkBZ08gOAyDhzgnachUX0VHG2a52X4Yl6w/YN9JoFEARgMSZQHtZTBHd/ph
         muJ/gjX9n8oXhDA2k80xJ0JY3MnYw3BW/kx/TYyiBmbwTS0ZVId1mTnnu6CLAEzNy5Bt
         20OF97baMJmzjvPOlwP+VRsqBMsnsdh5Zx1Uy6BZcYPQr+ZhFV8C7K47bPP2/tpgVdzN
         KTQjGP7rclw6HRmdmut4YJ5+Kn1yP/hTb7tGQWKKK2ykGPLhjWAULxEZ3/B2vJk4v0HV
         vsPC/d/8xLOVGdaoK6C47Ar+J7yjqEDPl0MV4f5qFfzU5KLlPB4UNbnLaxucqQKN4aUI
         wTiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745402579; x=1746007379;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d0qTubwqbpyXi7kz9EsQW3ZLfvBTuWc0PuDl6sNpZ/k=;
        b=RQToE44M+MSt5FmVinDMYZ24JqbES6neCUKFpO5Kz9LoC0gyhZs5g0D0Zqs9UtbKZq
         NtC1kQ9f5kYto3vxC6xnJ843wRq/vN0TaPBM2XiDVXgvhGweBJ9Bh82BZSVsMByK6qF9
         +0KVxcNPT4Uln5nnuKyc/ytRKABieY62ffBLB1alLaYosIoLWaReC+aW2iavAAmNVSJ5
         XlfsmkgmiH++drS/qGRTcrL/ulfvHofXvY3UxIs3UO69Soq+VR/UeeHmS5uw20q+tvVD
         r2hPiD0CmfPNBL8Bxjhu2jBUcxAKiYMUBwYRI4DZYs9mW23SCFTJzyjGgOAiKQDCbR81
         2FJQ==
X-Gm-Message-State: AOJu0YwIDI4eIZ+iBz6xyxfrnJX0eMq4+jslp7VQEFBFfah1skVRslrk
	PIp+G+JCGGflGBFyFBgfyLQKqnQkFm81ImWjlUyAdQCbdQWThG8C
X-Gm-Gg: ASbGnctjc1ev45gOyTJZS/XouXxBA3snoIesAZHV/FyRop97MYHNApKtFLRHdrxLXZU
	mD3zlgeB5HWfLUkR6CwE6gpSY4xYRSl7BHjHPX0gaXWYCtvXV8tCIt4vs5ClcY+2CAKiZz5SrFu
	YDLQ0ey2UKbnCWaaAlsJwGrml/K+7nMgri9LKLaWUqEX/2sXDF3XvF0nCSFiFhfBcOiugsEBOTL
	ykNGYUHoASVlPt1kzMY7W/X2m7krcmIY5l6ud34JJlpFnL0SfpD2V5HpDxDXZ/YII2sW3LaVwxB
	ZF6EIpsjqkwW5o1t7WuDjRyLmcqJzvkR+Er9LqadZjJHimtWdQM=
X-Google-Smtp-Source: AGHT+IFeIRJuyBuEnVdTQTr/GtcVMXgJHbnLmQfTG5cuJNZ4eiYA5Wgrc1BLSDqjzBbsGCYMx/GZfw==
X-Received: by 2002:a05:6402:2812:b0:5e6:17fb:d3c6 with SMTP id 4fb4d7f45d1cf-5f6285dce3bmr15780093a12.25.1745402578922;
        Wed, 23 Apr 2025 03:02:58 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.144.224])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f62554990asm7182844a12.15.2025.04.23.03.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 03:02:58 -0700 (PDT)
Message-ID: <6047214a-794f-400b-993c-5b5ef9e6daf6@gmail.com>
Date: Wed, 23 Apr 2025 11:04:12 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring/zcrx: add support for multiple ifqs
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: io-uring@vger.kernel.org
References: <aAiTlrx6uXuyoCkf@stanley.mountain>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aAiTlrx6uXuyoCkf@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/25 08:15, Dan Carpenter wrote:
> Hello Pavel Begunkov,
> 
> Commit 9c2a1c508442 ("io_uring/zcrx: add support for multiple ifqs")
> from Apr 20, 2025 (linux-next), leads to the following Smatch static
> checker warning:
> 
> 	io_uring/zcrx.c:457 io_register_zcrx_ifq()
> 	error: uninitialized symbol 'id'.
> 
> io_uring/zcrx.c
...
>      396         ifq = io_zcrx_ifq_alloc(ctx);
>      397         if (!ifq)
>      398                 return -ENOMEM;
>      399
>      400         scoped_guard(mutex, &ctx->mmap_lock) {
>      401                 /* preallocate id */
>      402                 ret = xa_alloc(&ctx->zcrx_ctxs, &id, NULL, xa_limit_31b, GFP_KERNEL);
>      403                 if (ret)
>      404                         goto err;
> 
> Potentially uninitialized on this path.  Presumably we don't need to
> erase id if alloc fails.

Thanks for letting know



-- 
Pavel Begunkov


