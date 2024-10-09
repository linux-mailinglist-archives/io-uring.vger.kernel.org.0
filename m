Return-Path: <io-uring+bounces-3510-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F6489974FC
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 20:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 164AA1F2411F
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE6261E0E08;
	Wed,  9 Oct 2024 18:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IbgCjMsk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDA91DEFE8
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 18:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728499132; cv=none; b=V95MzSCAzQSBkFsCmA/zQDrAqzcCGkhEFF5KtgiMnODD3urskVj1bleD4qGaaLsS60fHumrGmTfE+MkL99Ejh2cWhKFyvVLeJvzeYgpYYiMLuu6GnWO/6ei9motalXiDjo4OScGN53BAwpscHY0GotQUw6lym3edcDeuBqAGQm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728499132; c=relaxed/simple;
	bh=N/2ieugxa0SXTK5YTA1GB8qMbCHc5wMUhIJtP8felgs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y/B4qPNzCIFkYSpPjZ7mSDwuXRSqkQK87wFM7ZxHxy4ZYJbT9ser2it/TvtGwX806WdcQabxxd3Oh3YfIta6bhdY2+g8cQt6GX1VjvZOapWTu3RN6SLjcMO1OM5aL/Ysj9XfsSdm8aBM7k0j2qWRD4iDFuFIkfSCkovCoty3KeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IbgCjMsk; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-835453714e5so4742339f.0
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 11:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728499130; x=1729103930; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tmoxcvQ/T+I30xbHIqf4OzwNmcqow7Bse9IuI/jOY00=;
        b=IbgCjMsk7OW6kjWGW/tqIFaoA5kFvO01jBU64xYF+LVRSV6kD562LCcH27y/4SdvTy
         BeQfO9pK+DcFnOxoK5cjjqdhrB3VXGnvco2e+c6d3vJfRXmf8LG4jJbz6hFZTnkdjX+s
         XYrhKsdN4OTmsLnj24OuzssKZSSkY2D2KIbghDlULoCGk3gffqIovXjHR3AGKtbeuWjy
         75TM0ZDuq2CMjmMYuBGNRPT/CXTbC0dVlqxfniwlEhHEAEsGATX1j420zmgpo8qwFvoY
         p7FqjID6UhVK3KoYlRnaWSdL4eLvsxjYxzQA/eGo/0h2IFOPYTmGjRFatNH1mXc2XCI8
         m1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728499130; x=1729103930;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tmoxcvQ/T+I30xbHIqf4OzwNmcqow7Bse9IuI/jOY00=;
        b=qpTUEJ02tr11ZmIPHh7/LKIRE9Aq2vrjN4AsY8dfUflvWHQHhehwI/ncvI+/TJzUhJ
         VjyLq+KyAhzOZmenk/S/CAA1bLNO9xrNrujEZ9rbLRofOReXH3XRp7ZZny2K5aUIN4c5
         cqcX09cVafxM73PL0C77iX3tV0Ym0nw1egb7wzpL4Ijca9YkukpR+/Ft+xYNJYN53JaY
         McU21QVHNWEi2gPb6SrwRK/IyylzSkvBE3qNMCu4aSAsu6EwjH3SUE//A5Fc3mYihsmD
         Ln9Unm8uCQozzWnWqqzuGg8mPU/dwcygViuxj5NlTJQt3pTP239uLVPOATJkqiJDbkju
         b7fw==
X-Forwarded-Encrypted: i=1; AJvYcCVi0ZSLGoS4gvNLRzhLItBmKxPF1iplatCsGtpKfviX8BCSlgGWNbL1oAls4RbAWFoEKw8zX7k9tA==@vger.kernel.org
X-Gm-Message-State: AOJu0YykUULJwYsqRcb7oUgz9aXUf6lHrgRUyKzpdf7B5d6QVV0q7T5+
	o6Sy2jjCV86ddUD/GNfxeXvxrpHRwn38Ze6H+ZOnUbER1yTOK0WjzaATV0A8MJ0=
X-Google-Smtp-Source: AGHT+IHYoiJRNosfauu4PXlD12A/o6W60sJKDdpAh0GeXVWT4aZ2It2RCoQbyvpnAoubP8oPt893ZA==
X-Received: by 2002:a05:6602:48e:b0:82c:ed57:ebea with SMTP id ca18e2360f4ac-83547bf5f56mr116601539f.13.1728499129739;
        Wed, 09 Oct 2024 11:38:49 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-835429b3442sm31796339f.40.2024.10.09.11.38.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 11:38:49 -0700 (PDT)
Message-ID: <e7388f1a-82c9-48f9-8490-393b665d6913@kernel.dk>
Date: Wed, 9 Oct 2024 12:38:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 13/15] io_uring/zcrx: add copy fallback
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-14-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241007221603.1703699-14-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/7/24 4:16 PM, David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> There are scenarios in which the zerocopy path might get a normal
> in-kernel buffer, it could be a mis-steered packet or simply the linear
> part of an skb. Another use case is to allow the driver to allocate
> kernel pages when it's out of zc buffers, which makes it more resilient
> to spikes in load and allow the user to choose the balance between the
> amount of memory provided and performance.
> 
> At the moment we fail such requests. Instead, grab a buffer from the
> page pool, copy data there, and return back to user in the usual way.
> Because the refill ring is private to the napi our page pool is running
> from, it's done by stopping the napi via napi_execute() helper. It grabs
> only one buffer, which is inefficient, and improving it is left for
> follow up patches.

This also looks fine to me. Agree with the sentiment that it'd be nice
to propagate back if copies are happening, and to what extent. But also
agree that this can wait.

-- 
Jens Axboe

