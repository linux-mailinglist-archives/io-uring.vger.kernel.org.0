Return-Path: <io-uring+bounces-7246-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80260A7141F
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 10:51:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76D3F3B2A41
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 09:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB4AE1A3BD8;
	Wed, 26 Mar 2025 09:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AQrn70Dw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AEE189919;
	Wed, 26 Mar 2025 09:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742982681; cv=none; b=COgACUx5qoGdgxPTH3ytuIvhupPFpIHSGONLxa65EbAkz//giazAuIWDxZzBR+XcJJFcQnKcrMiwvGgQSmnc6Jur5R9uJh1+Ot6520V/INK4hKNz4/+m2QCjLf91IJHaQ0omH/GeueLeclcn8YNdPV9Ky10+HIIBZE8jQ7u77nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742982681; c=relaxed/simple;
	bh=+SmKmRQ0ICul1wVXSljlX1mwFHE5l6f0djwNzQswS0Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rhs2vKeG7R5Y+0Wly4Aw7GQF+vpRFRqH95ZkVcxh3CmCLMl0wiE3sdZlhl3Q24gzZIMPHS/FAD96PQlKCGReZsHZPwbqEncntu6ZZ0q/Dj5jVrAJYTVT4AiQbNrCmpCCRM+T18rhHKqWD8O2B8ynfDTUGjAZq4UD4lW4c8Bu2MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AQrn70Dw; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e5cd420781so11910627a12.2;
        Wed, 26 Mar 2025 02:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742982678; x=1743587478; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j825DE4xV6eVw15kdI5rFC4NLUrYGUwUWUgRROPn0QQ=;
        b=AQrn70DwT27FuXJ9eiNhO6UVMES+PIC5TKzk9MQ78crKyDday4voyBZS7bXG1ZlaAE
         INyEWuqpE1o1OQ+pL+OnylNwFOsAI0fT+YAi3KSFf3WTWKENPXrcXXjmkKaaamDQfdBM
         5R+q8LVcvB9Nw/BHSWIo+ZkYWtrORGJtKL7HKky06R1qHeMin0RazqJ4KU3G8gm1X05K
         l7jnFGVnZzWJz9yyVGrglFoDe8/zzqEcmbAb5cuDyt/0rNtbiEK5tjLeVOzA0wFUTeVQ
         g2cH36UtJTZ/dIqrWNLKKhRgeB9Np9fxvwxTnc3d6zjyKi+mGJiQ2hFaB0M+r5KSYtKN
         BmGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742982678; x=1743587478;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j825DE4xV6eVw15kdI5rFC4NLUrYGUwUWUgRROPn0QQ=;
        b=D9yrSCl/Z6ot/i/Rp+IyikTYTQIVCyi5VIhDuiPh1vbwIWEZr4zsZt9neMphsgU322
         p3MjK5rwcMMaD57uwtLwhMF7fqEpJZSbhdSsN+jNfGMHqX9Y9cTUUSlmHRHZ4oG5Y4bN
         S96kDdQwWV5G2GFO/ur0Qpn4TFuJm0nsfqMiedoM5R+YBDW/ul2q0cHfdXTudgjdnWvV
         gqNIhOI4tQFtqBMDjtk53KcaUj9Ghxe3sne3MtNhOu5wXww6w9pYgarI5DLLKAQqGApF
         zXRhThgNgLX/HGM0K3kAl2oLAeImsnGPpa5vzxLeEXyE7gkuAAbJqD4YKaWBvN8C/RHL
         uuRw==
X-Forwarded-Encrypted: i=1; AJvYcCV1G4xVs96C/9XT0bOld5uw9hFpuSyXUhrYb/7i3ypACetexhG+DRk+VM9u6OHjCZCR6UdRqIrQUg==@vger.kernel.org, AJvYcCX0G0wbEm2vk9deLI569t+MyG/O8l3yr4w7BTHQmTndskHfhCJz2kXVC2Z47JKiG8Zr5PPngzc8Hosae4+5@vger.kernel.org
X-Gm-Message-State: AOJu0YzVz0BIPWAmBpYdjW96s58SUcifnlCI6jrrYUIQWNeVH9zl8sKm
	ZDfpSa/5DjVZwNfhnFD/YaxEMNjRjykYBGk+MVRqCFdiO4sPTQvytwPbhg==
X-Gm-Gg: ASbGnctgb8XXbkLWB9I/Z1EBnv7LNK2xwf8QHqj5hS7LRg4QaGjkEsTbLrR+UjCLtWz
	WiApg4P6A3/M5jom2Y/Nqo9yJIOPB6IGZ3AdQ0yXjmD2Fq2nq4z1RVSPVqvUWfIVRFch75+bykH
	hxr9uCrVVOYxQsBLw96NcrOhURpUCvJ9rh64ynqrFZqAPnrl/k3yX5+dfYpv0C4gSNrvpgWxKOC
	29LVw+8qX69nLRF4ycjEIXBwfn284xgu3yUZtHadFVwzNDZynSPHStOmWW7lgYo3tdEoIanPTXL
	KKcYOcWcuTlUV+kDASPRQR/8IZdYo5EJuD9dsXtXL3TA5WhKn4hfM7029G+JQHSV9xTXEveFdSl
	ZgNL1GIqL26W0
X-Google-Smtp-Source: AGHT+IHFziojx8RYE9zCQ1G101GqE6nrsumegcSPKSsnX+7DOxWlK5RpQwyLdDa16NDeRfewPfbh2g==
X-Received: by 2002:a05:6402:35c2:b0:5e4:c119:7ff8 with SMTP id 4fb4d7f45d1cf-5ebcd415b51mr17569587a12.4.1742982678163;
        Wed, 26 Mar 2025 02:51:18 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:cd60])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ebccf68f3fsm9074864a12.7.2025.03.26.02.51.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 02:51:17 -0700 (PDT)
Message-ID: <c3b36363-a0a8-44e0-9e0e-3c05c059190a@gmail.com>
Date: Wed, 26 Mar 2025 09:52:06 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: use REQ_F_IMPORT_BUFFER for send_zc
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250324151123.726124-1-csander@purestorage.com>
 <8b22d0df-f0ea-4667-b161-0ca42f03a232@gmail.com>
 <CADUfDZocNe0jm1n3WxO+hHqVcQcgj5PtA4h+S3EsiB0D=-m+dA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZocNe0jm1n3WxO+hHqVcQcgj5PtA4h+S3EsiB0D=-m+dA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/25/25 14:39, Caleb Sander Mateos wrote:
> On Tue, Mar 25, 2025 at 6:30 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 3/24/25 15:11, Caleb Sander Mateos wrote:
>>> Instead of a bool field in struct io_sr_msg, use REQ_F_IMPORT_BUFFER to
>>> track whether io_send_zc() has already imported the buffer. This flag
>>> already serves a similar purpose for sendmsg_zc and {read,write}v_fixed.
>>>
>>> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
>>> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>    include/linux/io_uring_types.h | 5 ++++-
>>>    io_uring/net.c                 | 8 +++-----
>>>    2 files changed, 7 insertions(+), 6 deletions(-)
...
>>> @@ -1305,12 +1304,11 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>        struct io_ring_ctx *ctx = req->ctx;
>>>        struct io_kiocb *notif;
>>>
>>>        zc->done_io = 0;
>>>        zc->retry = false;
>>> -     zc->imported = false;
>>> -     req->flags |= REQ_F_POLL_NO_LAZY;
>>> +     req->flags |= REQ_F_POLL_NO_LAZY | REQ_F_IMPORT_BUFFER;
>>
>> This function is shared with sendmsg_zc, so if we set it here,
>> it'll trigger io_import_reg_vec() in io_sendmsg_zc() even for
>> non register buffer request.
> 
> Good catch. I keep forgetting which prep and issue functions are
> shared between which opcodes.

No worries, can happen. I'd recommend to run liburing tests,
they're very useful for catching such things. I run it out
of curiosity, it crashes on send-zerocopy.c pretty fast.

-- 
Pavel Begunkov


