Return-Path: <io-uring+bounces-979-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A6C87D2E2
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 18:35:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38A90282C61
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 17:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D4A4AEC6;
	Fri, 15 Mar 2024 17:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mk9y5T8n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D11E4D599;
	Fri, 15 Mar 2024 17:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710524134; cv=none; b=WOjMgmKfpSqxwBL/4LLAx8lm7HHb2/sYq7G3ZWaOTz/gbvVOabBpouZG2Cjm3KVDj7RRHHaTWEuVruK46FzEMjcru8D6lYMLF7hnXmugd9aVe8MKkHbdoQe+nKJqKgs+4o1BgNSiOb6CMpoZC0+ZT3g5+OVrtJ9e3cNHOdM7bx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710524134; c=relaxed/simple;
	bh=Y1PEXpSEK0rsDS711/gG7hMZeM0np4zytvBVm/pTdUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IDmUxajP741vhZEZd83ZNo+KY2/Pchm/wD59+BMURgePxJznAVlDhPkaZccmGIgBK8y7uxg9aDAirvBDcfo1dX+9dTwZIz8j3lcRzVDrN0tPUY7djH5iIzUY/mgmimzxqw8+fPrPi2yQoyqMf23digVjmHJHy07CXIKgjJZbgfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mk9y5T8n; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-413fff2aa2aso8491945e9.2;
        Fri, 15 Mar 2024 10:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710524131; x=1711128931; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cfpfNcyeYYbLF1S7F08Dgtx2zhwW7B2Wxc9KNT7IMbo=;
        b=Mk9y5T8n1A6dx3RCTJ6waVVBUROdWpep3UgG0M/mIcG4wKIUNeMaIr282InAR5AxjL
         QaNJ1z9bsVSb7MF5/yBrXgZgSVXjCeYCgPHFwV8CxtgFE+yrUvGbGk95mjB2t8iO3Dzz
         zd2Y3UBIEleayNnOxhGu2rnukSeOUxKyLM384+Cn4USz0Z67bkPRB9cKl6YMq9CLgQYq
         15zOQfNSpSZhSUFJxpawFNOdjcPl3E7jbp5CwvO+6Czzr0PEsQNVGm1RJE5jLTnsCGd0
         nW8jN3FonBGaWlD055BxghRCxkbxtAAAJopkND/NmXLPPB77JJP1lXKjcbIsn3PAEYoL
         /gQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710524131; x=1711128931;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cfpfNcyeYYbLF1S7F08Dgtx2zhwW7B2Wxc9KNT7IMbo=;
        b=MFhdYOAgqDNm2AN9U47hAzenq137bqj/6c2KlEO9fwm81WHNonx+74jALpcGA5NenM
         MWz50WKkyScAT6NafTUOtBP6vPgL/9/23GNKe2F3Df6DE+VGUyDP7ViKD9juiD0/LhQP
         F5MiVL7sUURdwjkqnuEbETBRkG7qMp+e0AonjXR/8wDJBjv+iyC2fHdDoak9keDCjLEU
         zoaCX/Y9N71Vd9JxWgzpi7Ps5mnM+e2XUUL3LKHZhsDKIIVepzlNVoG3Mii2THl0kN2X
         y5bx/sA+qWHdm1KJWbW7RsjQttrWJAavIMKvQI7RSauelw02xxJvHA+JBisyxEzsskkj
         Hd3A==
X-Forwarded-Encrypted: i=1; AJvYcCVWmKdzH1EBsM+hg8dVwrzhPOqIP3hAR4dQ1LJDf9UXrkE5N9SdIZvzlIf91j3GSFp1O+fWsbqVc1A5KUAGviOuV/2J1PB0kHvL3cuqIatiNJeN+R03E1ZtX45K83xVkmc=
X-Gm-Message-State: AOJu0YyeGwN35bDvHBmGuuwsYQIqrJDCM8oWX9g9Wzpv2BbWhOyDPPUI
	7PknAwPrjAUbR7qp7waFksCB/y9mCITi0aViH21ywtZaBv7eTECI
X-Google-Smtp-Source: AGHT+IFKcYchHNiJVp2U2l5sbwFT4QFFnm1EDc9lywsF5tDhdHwYtFysvSsFYJLSb/susBVb24Lqwg==
X-Received: by 2002:a5d:5383:0:b0:33d:1f11:33c1 with SMTP id d3-20020a5d5383000000b0033d1f1133c1mr3097424wrv.55.1710524130435;
        Fri, 15 Mar 2024 10:35:30 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id bv17-20020a0560001f1100b0033dd9b050f9sm3639718wrb.14.2024.03.15.10.35.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 10:35:30 -0700 (PDT)
Message-ID: <e646d731-dec9-4d2e-9e05-dbb9b1183a0b@gmail.com>
Date: Fri, 15 Mar 2024 17:34:24 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 13/16] io_uring: add io_recvzc request
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20240312214430.2923019-1-dw@davidwei.uk>
 <20240312214430.2923019-14-dw@davidwei.uk>
 <7752a08c-f55c-48d5-87f2-70f248381e48@kernel.dk>
 <4343cff7-37d9-4b78-af70-a0d7771b04bc@gmail.com>
 <c4871911-5cb6-4237-a0a3-001ecb8bd7e5@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c4871911-5cb6-4237-a0a3-001ecb8bd7e5@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/24 16:14, Jens Axboe wrote:
[...]
>>>> @@ -1053,6 +1058,85 @@ struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
>>>>        return ifq;
>>>>    }
>>>>    +int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>> +{
>>>> +    struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>>> +
>>>> +    /* non-iopoll defer_taskrun only */
>>>> +    if (!req->ctx->task_complete)
>>>> +        return -EINVAL;
>>>
>>> What's the reasoning behind this?
>>
>> CQ locking, see the comment a couple lines below
> 
> My question here was more towards "is this something we want to do".
> Maybe this is just a temporary work-around and it's nothing to discuss,
> but I'm not sure we want to have opcodes only work on certain ring
> setups.

I don't think it's that unreasonable restricting it. It's hard to
care about !DEFER_TASKRUN for net workloads, it makes CQE posting a bit
cleaner, and who knows where the single task part would become handy.
Thinking about ifq termination, which should better cancel and wait
for all corresponding zc requests, it's should be easier without
parallel threads. E.g. what if another thread is in the enter syscall
using ifq, or running task_work and not cancellable. Then apart
from (non-atomic) refcounting, we'd need to somehow wait for it,
doing wake ups on the zc side, and so on.

The CQ side is easy to support though, put conditional locking
around the posting like fill/post_cqe does with the todays
patchset.

-- 
Pavel Begunkov

