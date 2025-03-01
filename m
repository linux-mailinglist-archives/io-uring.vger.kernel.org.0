Return-Path: <io-uring+bounces-6881-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4488A4A7C6
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 439C37A7DBE
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 01:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4B3F22066;
	Sat,  1 Mar 2025 02:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="btmg0Ens"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DDDB664;
	Sat,  1 Mar 2025 02:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740794443; cv=none; b=og7DaE5QGdh8g000Y1BRN6F/7nKhFwFPkEg1aV3//98ncOstgisYfyZS6B/WEYCsn++YiY2kdn+0zwM0CZn9RzVWRhi8uVykhokyvqHhMn3tME9TyOlodOVm4tMdajc5iAKfvoPV5PI4fsEJmtE/gDGot7f8ekj8Cg+/9NLj7zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740794443; c=relaxed/simple;
	bh=7XT2kpBSM1ulNCVtzP7T0Dp+V+WQA4MQReMQJLFg0UU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dCBxM0ziemSPsqRK5B/lpXFDrToPLs5zaTNYX6JphBXZdBhl5wHdl9n9vsArokc73qnhmmcZ1ey4rLlBHdkqhjArIXWeuTedJVtA87mQARy1j8GX5XiA9xmlUD8qRGrmb6b1KXuSWLXDtDAywACzbMLwruhtyOQkhr9DTYooBew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=btmg0Ens; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5e50d491f69so522501a12.1;
        Fri, 28 Feb 2025 18:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740794440; x=1741399240; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+6rF6vIpS7eRXkXRsCvMwkXu/dcCBj5tKuGyPWCNSG0=;
        b=btmg0Ens/pKHEnNFJq5xA5IkESK/+ZsHgS6zReuF/U5a4d/q2qTu4GRsNQ8AulTxOW
         rdNIiiUlos628qBfnM64Mih/EtwiYcK0a5MfdVqxg55j5/gK0C1/EXYQeJy83PhQc+8d
         8UGmnf4BIQnX3l8Eig99ttqOSMQ7MB5cPQ9R1MJR0kmvHORDCfhwZ70Dw3P1iPYGwIn0
         /MNHfu6KUNjkf/SsPTdHemXE0ot1A1Olf/F5PHPY9MHfF1Wtxb8CJBHlIbf9sAvJgUCP
         RMXL55i86cHHFrubiciEbwqAI2npHUITvv/tdM2Li7eaixXWHeD7CmeoUIhABrL/Fb1J
         O1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740794440; x=1741399240;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+6rF6vIpS7eRXkXRsCvMwkXu/dcCBj5tKuGyPWCNSG0=;
        b=ohgsArLdsT6mF/NKUVnesS9+hrFv9DRWHPFOCkWTKP3/ZBL0xhndSPcZiDo0BpsQq/
         UIKYl6rASv60lx+zUG2pMj0bTpDT5HJOOdw1bT4/OhfrIuN4DH62kYLEyA3qWXZD6Wsg
         Z82iQs0LKWldGm3ZJAfuCfAYfNmn99qOTQuEed862WV0wFRimEkqQiFNtclzsVqfuhWq
         dwzKmIh7KnF7x+NGnQoRT3IHzp2kowJNsv1xY3o2ba/5pgnvCULybhc+L+reEnsPg1Vw
         0O5vJ5++gftjIPS0LroHrxLX4iLzjIt8DysuMT0uh9zYQ16Hf+NOYQlhXoTXq+TAIPYw
         VTTw==
X-Forwarded-Encrypted: i=1; AJvYcCUfJ1tPMdPxbwsC3o5es8+YNuWrUZLgpUahcOQvoOlFGVNwO6idSfCT6YaH0/XHes35dAr/+vmXIo2+P3zN@vger.kernel.org, AJvYcCVvPvFPGMF7g/xv84J/WDr4u6zyKzs1CCPTBS0lal/RzuhOW3o75MA/+BtKdP3O/4GIWyeoS3UpHQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzC75e7732bIATFz39bUC5ra0INdJ55z8y783vgziBQzCatuZiZ
	MjNayvs6ONqg3LQMHy6Kln0y8u5kEGns8RDSkd9xfSAjzWawanli
X-Gm-Gg: ASbGncuM9qRfMFU4coQV7EXlQBfjFz/xjwliANVcwYC0TkqAQZE3Bf+Qa4ZbAGzHIxf
	HA/k8EojC0TivXv6rA8Br6UPHrYlkz+eUU5a9uKw1bPDq0zYoe0ppvVavcHCsyfZRjmj35WmzLr
	PW5cUNI8e5CCvoIkfz0TbwXYZF/9NTBsl3WGJYATuNB4l0uSVcDCkJqns4ZSE1RWCx31pvEQP2B
	APPMWHs3/Yr6KA7QX9BUt7FIaV4ozmDZm6RjUk5Y6VoFQ81JyU7YK1DYA7EG9Ottslp5Y+2qDwF
	R7cpsziLgU605OeBVfnUCdlHHSiYXWaQ8zbuw1CeUrsv+GHHYtQeuiY=
X-Google-Smtp-Source: AGHT+IFd5YtG5p2HCM7HIwfkyTisO9HLq3AfaFCBzVxWPZMdestBvH9uIVO2b+eWNBhTnAp+BxAZOA==
X-Received: by 2002:a05:6402:51c9:b0:5e4:c14e:fb51 with SMTP id 4fb4d7f45d1cf-5e4d6ae3a65mr4828688a12.12.1740794440010;
        Fri, 28 Feb 2025 18:00:40 -0800 (PST)
Received: from [192.168.8.100] ([148.252.144.117])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e4c3bc8800sm3432085a12.48.2025.02.28.18.00.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 18:00:38 -0800 (PST)
Message-ID: <a4001bbf-5782-47ee-9ea1-ea2020ed121d@gmail.com>
Date: Sat, 1 Mar 2025 02:01:45 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: use rq_data_dir() to compute bvec dir
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250228223057.615284-1-csander@purestorage.com>
 <6272ce74-cd1e-4386-ac84-2ca7df5dab33@gmail.com>
 <CADUfDZpmnj8wCjaQcDTTT_rNhsegs0NFk6w393e+JsTg4MN+bQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZpmnj8wCjaQcDTTT_rNhsegs0NFk6w393e+JsTg4MN+bQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/1/25 01:42, Caleb Sander Mateos wrote:
> On Fri, Feb 28, 2025 at 5:23 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 2/28/25 22:30, Caleb Sander Mateos wrote:
>>> The macro rq_data_dir() already computes a request's data direction.
>>> Use it in place of the if-else to set imu->dir.
>>>
>>> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
>>> ---
>>>    io_uring/rsrc.c | 6 +-----
>>>    1 file changed, 1 insertion(+), 5 deletions(-)
>>>
>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>> index 45bfb37bca1e..3107a03d56b8 100644
>>> --- a/io_uring/rsrc.c
>>> +++ b/io_uring/rsrc.c
>>> @@ -957,15 +957,11 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
>>>        imu->nr_bvecs = nr_bvecs;
>>>        refcount_set(&imu->refs, 1);
>>>        imu->release = release;
>>>        imu->priv = rq;
>>>        imu->is_kbuf = true;
>>> -
>>> -     if (op_is_write(req_op(rq)))
>>> -             imu->dir = IO_IMU_SOURCE;
>>> -     else
>>> -             imu->dir = IO_IMU_DEST;
>>> +     imu->dir = 1 << rq_data_dir(rq);
>>
>> rq_data_dir returns READ/WRITE, which should be fine, but it'd
>> be nicer to be more explicit unless it's already enforced
>> somewhere else
>>
>> BUILD_BUG_ON(WRITE ==  ITER_SOURCE);
>> ditto for READ
> 
> The definitions of ITER_SOURCE and ITER_DEST seem pretty clear that
> they are aliases for WRITE/READ:
> #define ITER_SOURCE 1 // == WRITE
> #define ITER_DEST 0 // == READ
> 
> So I assume other code is already relying on this equivalence.

And it'll be left a mystery they weren't defined through
WRITE/READ in the first place. but the patch should be fine
then.

-- 
Pavel Begunkov


