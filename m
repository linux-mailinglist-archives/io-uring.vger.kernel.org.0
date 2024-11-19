Return-Path: <io-uring+bounces-4802-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BFDCD9D1D4C
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:30:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34BCEB21ED2
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 647202AD20;
	Tue, 19 Nov 2024 01:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uO9xr1vg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22790200CB
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731979799; cv=none; b=n/zqK+dGon6dpJGXHczjcE9GS/gHfvsSa9m7McE+xhSONoAC/F8Fy3EmYjvTVVTn+bLEu/9Gkozp9qiuw/mngfR2yiI6QMXlPXgYcEeC1ki5pcOF56KmjLm0m2a3c4ES6s0SW/h3IEo4BiNezQ3RLQm3FxyrEPUbIzoADGPjmpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731979799; c=relaxed/simple;
	bh=6H+dwGAtX/1/31LppTVZqdAq1L3YeqAtuyqTcdi3tLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dLYeZp28lbb0uhuFQGyfadPLH/YriTL7llcCTxt1+jpFhtNk3ARStHr/bSdp0+CzFCo5oidX5lh3IQA7I1y6fISKSBPvMBX1X5KGB9XRvpG86AIO4zJv5AZByTyVJyd0B8j5ZTICtnlJNvpTF0DuE08Kes1pR+mHLabIrlh9qTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uO9xr1vg; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-724455f40a0so312843b3a.0
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 17:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731979795; x=1732584595; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uTzfOwgM9WO8BfKXgeQz/v8OOQLJdR9rRLhLJnqXJHg=;
        b=uO9xr1vg0Jx5nOQUotJS/9M7mXQVUgYpK0/wofzDZl6oBfiL0iVOdiPdC4xuPo16m7
         vAcMhvd6AY2YzBReaXkCVMBXjaGEpCeHN46gcLZiFkM95fF/Ou8l2awBrfX9DMq31oNY
         0x9NH1aq5VAshJFiycEr2u+2O/B/3XdVItysK8j8ixn3bHRXsiHDsUUPIbP7xowpiNdF
         yW3UyRIY0xabd0fDx7YEd+O5lBcM0NtGmiQc5GHARSQ5UNY38Jfcc2BJ1aDU2VOw8ETp
         9/3N4PiJg/wKq22z34XuYVsB0QMR8wNBR5VXElzOZjP95tGKpuYV1dawxORasvY4Q+7N
         rIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731979795; x=1732584595;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uTzfOwgM9WO8BfKXgeQz/v8OOQLJdR9rRLhLJnqXJHg=;
        b=owdQr6s1nPne2BT5hVNDC55s+4EMyYA4YmW9uc86o9LLE/p5ptJiHaub8afz4bcGLg
         OdHagjg9OlODj/PsSc8jyxM7nVH8BnxcDhw4oFF3EakS1v9i458NOnsmLatGVsC862PJ
         vWhmLp/fUGxBZstAAmF12shQ2qCbqBic7A/QHXPtNmtD/nJkpcAkojYa8JiAtF+c8SJj
         UwcLX9kj0Cv+XWGDYwrzyNMZp4v9qUSo4DFr53BNB4yb8bN85CM0aHfDVEb3bsBlxED0
         TQ3TOBb/t6Jga7pDyDrhPyYl+kzAWW6w58GdhnpRSA+W/nEVaGL6npYY8ysOubi4pI19
         DS2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUw5+V+ZV+u5xDEec1/YJ+Am5YnuyngEVAi3QIJkLqfVNVl9IYgOYd02nl6lWMjSMm3C5YCGpjVYA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw10o8uFgdhI3dZBQ8SdzN38nPvPuoPvOWwMn6SDPV9RCVZaTbh
	qhnLt2SmgN4THQOb7ByLbaAOdyozPU4CvfoO2soZeB9HDajS7l98W5paGfPpCVA=
X-Google-Smtp-Source: AGHT+IF8xTuD4+qc3/nFGlgY6Owf/ur9ErAeVfG9oC0rQMdTW9Plua3FGPDCIjlzJw/8Zr9yX8BhbQ==
X-Received: by 2002:a05:6a00:1786:b0:71e:659:f2e7 with SMTP id d2e1a72fcca58-72476ba6accmr22476157b3a.8.1731979795305;
        Mon, 18 Nov 2024 17:29:55 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f8c1dd62dasm6569677a12.74.2024.11.18.17.29.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2024 17:29:54 -0800 (PST)
Message-ID: <0dfd1032-6ddd-49b3-a422-569af2307d3b@kernel.dk>
Date: Mon, 18 Nov 2024 18:29:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: prevent reg-wait speculations
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: jannh@google.com
References: <fd36cd900023955c763bd424c0895ae5828f68a0.1731979403.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <fd36cd900023955c763bd424c0895ae5828f68a0.1731979403.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/24 6:29 PM, Pavel Begunkov wrote:
> With *ENTER_EXT_ARG_REG instead of passing a user pointer with arguments
> for the waiting loop the user can specify an offset into a pre-mapped
> region of memory, in which case the
> [offset, offset + sizeof(io_uring_reg_wait)) will be intepreted as the
> argument.
> 
> As we address a kernel array using a user given index, it'd be a subject
> to speculation type of exploits.
> 
> Fixes: d617b3147d54c ("io_uring: restore back registered wait arguments")
> Fixes: aa00f67adc2c0 ("io_uring: add support for fixed wait regions")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/io_uring.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index da8fd460977b..3a3e4fca1545 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3207,6 +3207,7 @@ static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
>  		     end > ctx->cq_wait_size))
>  		return ERR_PTR(-EFAULT);
>  
> +	barrier_nospec();
>  	return ctx->cq_wait_arg + offset;

We need something better than that, barrier_nospec() is a big slow
hammer...

-- 
Jens Axboe


