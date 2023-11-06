Return-Path: <io-uring+bounces-34-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 806777E27AA
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 15:51:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1136CB20B16
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 14:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93CD628DB0;
	Mon,  6 Nov 2023 14:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GTExF/pR"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F70028DAD
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 14:51:17 +0000 (UTC)
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D958B6
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 06:51:16 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-3593f3ef420so3776165ab.1
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 06:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699282276; x=1699887076; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z4LFEC8zxGouliqv1ewI+zE3Fj0IJxXLFveghYySH60=;
        b=GTExF/pRLKZBClmsDkiqv3058GaC6ZTJCKttIOkoj1ziH6KwhKTjM0qP8mpmf4DDff
         k0n0rYV7naN9kpq5CEKywylXooIOo/jiXZF9Qn2DQsoSABB0RVcDnXBuHdbB5WrFElSd
         /H8xZJM/D22q/I0LKNiGVeLnWCeCaESqUUrS/GVBsuinGnygHCxC4NePV8F8Ip0lUXHx
         fjQ3czHh/bLZdoaRP6AWND0BFfWqeSD6T/pEEDYERehn1h3FslgS54TXkzUdI4uzY2D2
         kqESU7vANhnrPlaxoJxtlpqr6IJ/nfmSklDaSncR4rQsQeKmbm8DnYN0A63WYBATI7Nu
         lU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699282276; x=1699887076;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4LFEC8zxGouliqv1ewI+zE3Fj0IJxXLFveghYySH60=;
        b=D4tLuTCzON+k6ea14o84udtgHBcnFup4s3H1OqV8RVA1a+/KyAwsF3S6zoEV6dLblb
         eF5h5wF2lG3bhHhx7VCGv5efOsTgwN/nXl8Adxtg3pa9ZsVfNBD2x9SBJKsoX7MHDsDf
         IYW6M8DeRSGYkd6Y+sKiY/GNNZ9s+kyzXaKNCoN4SS3lW5gaTYzvSvICkQKUZoLHJ3eA
         qQ21e21cNKSeSIZUuYCQtcdfxZoPxkjVreabex1aH/DWQM4fyuO2S+9xpJZVKOSH3jjx
         VfgGaP94iOd6Nd75h5zXCa8doToZIMWelx2J7RGSJhtWsdy4yU3nmQwO8QmQX5y9YNHk
         MD8w==
X-Gm-Message-State: AOJu0YxnnN8LRmjjEZXQEipTKGhlLa2jPVUzu0wab4NJPPW3w9AmuUyq
	66vkOnsRxPaEeRcdon+1koXhyQ==
X-Google-Smtp-Source: AGHT+IHMuRIH7+wiwg4NpZuxmai8CDlWG8J5QZDmA4pcM9urgKerPzXG9xJxfAy6uOsGAi58tEq8Bw==
X-Received: by 2002:a05:6e02:260a:b0:359:3f91:1814 with SMTP id by10-20020a056e02260a00b003593f911814mr22498232ilb.1.1699282275747;
        Mon, 06 Nov 2023 06:51:15 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g8-20020a0566380bc800b0045b8d5a9262sm2165753jad.11.2023.11.06.06.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 06:51:15 -0800 (PST)
Message-ID: <2699f7c9-3d56-4ce4-be49-be8b2903ac11@kernel.dk>
Date: Mon, 6 Nov 2023 07:51:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring: do not allow multishot read to set addr or
 len
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Dylan Yudaken <dyudaken@gmail.com>, io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
References: <20231105223008.125563-1-dyudaken@gmail.com>
 <20231105223008.125563-2-dyudaken@gmail.com>
 <d6cbb872-b1fc-4e91-96f9-46d814a94974@kernel.dk>
In-Reply-To: <d6cbb872-b1fc-4e91-96f9-46d814a94974@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/23 7:32 AM, Jens Axboe wrote:
> On 11/5/23 3:30 PM, Dylan Yudaken wrote:
>> For addr: this field is not used, since buffer select is forced. But by forcing
>> it to be zero it leaves open future uses of the field.
>>
>> len is actually usable, you could imagine that you want to receive
>> multishot up to a certain length.
>> However right now this is not how it is implemented, and it seems
>> safer to force this to be zero.
>>
>> Fixes: fc68fcda0491 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
>> Signed-off-by: Dylan Yudaken <dyudaken@gmail.com>
>> ---
>>  io_uring/rw.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>> index 1c76de483ef6..ea86498d8769 100644
>> --- a/io_uring/rw.c
>> +++ b/io_uring/rw.c
>> @@ -111,6 +111,13 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  	rw->len = READ_ONCE(sqe->len);
>>  	rw->flags = READ_ONCE(sqe->rw_flags);
>>  
>> +	if (req->opcode == IORING_OP_READ_MULTISHOT) {
>> +		if (rw->addr)
>> +			return -EINVAL;
>> +		if (rw->len)
>> +			return -EINVAL;
>> +	}
> 
> Should we just put these in io_read_mshot_prep() instead? Ala the below.
> In general I think it'd be nice to have a core prep_rw, and then each
> variant will have its own prep. Then we can get away from random opcode
> checking in there.
> 
> I do agree with the change in general, just think we can tweak it a bit
> to make it a bit cleaner.

Sent out two cleanups that take it in this direction in general, fwiw.

-- 
Jens Axboe


