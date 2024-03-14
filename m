Return-Path: <io-uring+bounces-944-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B23A87C10D
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 17:14:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 404A31F220A2
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 16:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C07171721;
	Thu, 14 Mar 2024 16:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fhdmDq+l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B5073500
	for <io-uring@vger.kernel.org>; Thu, 14 Mar 2024 16:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710432868; cv=none; b=C4VlwauHae0k+QsqSMqmL+Uzwgg7iK9Cgpj2Q0mWPytb9ARWhEjOyiChNB/1xtI35dgo2DFB+GNuddVZjpJ5bmJuGQApheNYQk5MWX54WKOPM8YoJB9/bN/AG5bVU/G2NeekuhKG5LPV7X4d6CU+IgJhxHXwIJLsZRbz69Mrgrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710432868; c=relaxed/simple;
	bh=n9MLked4f6grPnR/JRH/R11dVICB5lb0E8UInKJ53Dg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ltc9Zv/GJprdEScV526AIagVgwpAu/tXdUBmbxc2gaWxW6sgN+8ixeVBLOP9GqCsqsBTbtHEppgNmTqmFrytXpF99EfE5KaiOjQVaWdIaRGp4UpaH3a8yPXI9w4CeWt3rjeTmaq2EFfQfzR8bn9Q3DUacICPxKdY5wyjyi/rw68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fhdmDq+l; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-36649b5bee6so1699595ab.1
        for <io-uring@vger.kernel.org>; Thu, 14 Mar 2024 09:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710432865; x=1711037665; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WhtBzfswvcmq6Svhz+lt0FVW2iab9sdhn0vJXLVmKrI=;
        b=fhdmDq+la9z1oMW1eeYD7QpkIsPsC99KY2vuhqJjts2QTgP33YQ1jeAUlSxrmYfxVb
         N/7l5eDtCU8vgxM6cHOXWNrj1Hy0yxtfUoenJyrkPDahQkZVttITf3iF/NOEx+TSok0u
         rQOpjRx1B2eM8EfoMLzTBW4HjE55CzcTtHy9X8V57nuV2FZUr/a7tMI8lgSPW0gNEvk7
         Qpu1AZR1vuZGZCcEo9qOOCxYIxKlhvK6bGS6EhzuZdOQa23kdccZ7yqQbZm62R/cF66+
         IJ1CtGTFTyUXiP0jy6vmfvytalXFOM8XVOc7c5+k1JJ93gyXpDdXNQA9nvrMXroOCHB3
         vcpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710432865; x=1711037665;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WhtBzfswvcmq6Svhz+lt0FVW2iab9sdhn0vJXLVmKrI=;
        b=b/WTlmLLC9K2SnoFR+U7u0V/WTd1vjQDTy8ROu89Pzy4e6Hyn0IZKrNjKWfSzG/GnA
         eo+pmkyZBvS6N0m/r2r2dDzmqQfrXZWK4SNzdzQe/960MVf7rJBh7daWqclv+GfR2eyN
         i282y/o+W5W8+Wxf7uBiH2WY7IPrH63ZMGMgMoB6areVb2c3rRU4g6Il4DJM356tGG33
         Afr7in4PQVVus12lR7GBoY29lxTEAA7QNcjMaWsjVmCf6WPBT7K2Zpobi7whUwOx9Kr4
         7uzwM1Cds8PJhAGyCLbze8Qqb5OJMLQZ1kcgSBMt+vgudaMuEITyxYmqyJ/K0YRTjrwU
         FESg==
X-Forwarded-Encrypted: i=1; AJvYcCX5SYNzM/iq9dnDoko5oLARKakvuuwfyIyBUiBmtjTDIKL4gdR5nt0Ga7lRCCmIw3+F18CgwDWHMCPLuZpXQiVvBgPzFnn1g/8=
X-Gm-Message-State: AOJu0YzzuWUsUrFJfHms6Y7LzLxxiAPPznCWMm4Y1vcn0n9pjh3FxEFt
	MzzVoyONZe/uJFFGFWebjX5m+KCay4PC6wyv363umMn/IcgRzPfiZDE3MvkA9IY=
X-Google-Smtp-Source: AGHT+IHaacrEds1wSxG89xmPXmuznnuZcUaNUesYBR55Uc8riQ8tCPiLzCrui2nXJtkkGIdemUYXEw==
X-Received: by 2002:a92:c80b:0:b0:365:2bd4:2f74 with SMTP id v11-20020a92c80b000000b003652bd42f74mr1868713iln.0.1710432865656;
        Thu, 14 Mar 2024 09:14:25 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t17-20020a92b111000000b00362b4d251a5sm221820ilh.25.2024.03.14.09.14.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Mar 2024 09:14:25 -0700 (PDT)
Message-ID: <c4871911-5cb6-4237-a0a3-001ecb8bd7e5@kernel.dk>
Date: Thu, 14 Mar 2024 10:14:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC PATCH v4 13/16] io_uring: add io_recvzc request
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20240312214430.2923019-1-dw@davidwei.uk>
 <20240312214430.2923019-14-dw@davidwei.uk>
 <7752a08c-f55c-48d5-87f2-70f248381e48@kernel.dk>
 <4343cff7-37d9-4b78-af70-a0d7771b04bc@gmail.com>
Content-Language: en-US
In-Reply-To: <4343cff7-37d9-4b78-af70-a0d7771b04bc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

(Apparently this went out without my comments attached, only one thing
worth noting so repeating that)

>>> @@ -695,7 +701,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>>       unsigned int cflags;
>>>         cflags = io_put_kbuf(req, issue_flags);
>>> -    if (msg->msg_inq && msg->msg_inq != -1)
>>> +    if (msg && msg->msg_inq && msg->msg_inq != -1)
>>>           cflags |= IORING_CQE_F_SOCK_NONEMPTY;
>>>         if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
>>> @@ -723,7 +729,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>>               goto enobufs;
>>>             /* Known not-empty or unknown state, retry */
>>> -        if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq == -1) {
>>> +        if (cflags & IORING_CQE_F_SOCK_NONEMPTY || (msg && msg->msg_inq == -1)) {
>>>               if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
>>>                   return false;
>>>               /* mshot retries exceeded, force a requeue */
>>
>> Maybe refactor this a bit so that you don't need to add these NULL
>> checks? That seems pretty fragile, hard to read, and should be doable
>> without extra checks.
> 
> That chunk can be completely thrown away, we're not using
> io_recv_finish() here anymore

OK good!

>>> @@ -1053,6 +1058,85 @@ struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
>>>       return ifq;
>>>   }
>>>   +int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>> +{
>>> +    struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>> +
>>> +    /* non-iopoll defer_taskrun only */
>>> +    if (!req->ctx->task_complete)
>>> +        return -EINVAL;
>>
>> What's the reasoning behind this?
> 
> CQ locking, see the comment a couple lines below

My question here was more towards "is this something we want to do".
Maybe this is just a temporary work-around and it's nothing to discuss,
but I'm not sure we want to have opcodes only work on certain ring
setups.


-- 
Jens Axboe



