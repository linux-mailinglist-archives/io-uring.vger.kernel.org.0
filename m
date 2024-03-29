Return-Path: <io-uring+bounces-1330-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F12D89214A
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 17:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E517E1F22313
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 16:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2837750A72;
	Fri, 29 Mar 2024 16:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cQ6fMw44"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEBE1C0DE3
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 16:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711728574; cv=none; b=Nj2ioGNIo0/D1JjmpeJARqfwp+8zs26kUFEoPLYChsafFNaHtITadlw6uCPp/XXE+ZGpRJMHHYuX0LjybPcOUecpFThL8YDiNeKcZhV++7ewI4HKBJyK/qJLEHquJgvrQchgQX5O9aAlj4seDC4eN20z/xkvxFA3s7aZUShw1wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711728574; c=relaxed/simple;
	bh=+cOW0UKMOcevPOK1qZO0kW95LZU3bGLdO30rn15OOUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IQpP+iLT3nkxVmD2eOckmsOY+RVAF9E4Zlcl6LipTySYZVow5l5t+NaIn727dTPizYMvh16GS6lWSwvfHR7+omnNr12uihoN14eOeia5SOQ1sCjUukHAi89bPLBxlKKIFizGmov6hdxf5gx10H7YsTmHJgwiG5a1PwanHIyYvaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cQ6fMw44; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e6c38be762so220357b3a.1
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 09:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711728570; x=1712333370; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gjscHG/5S+L8WJOUAMMwlEW/NvPcV4LXsCXmFhSKmAs=;
        b=cQ6fMw44Eq1VqbneuXFujLsIZj8QxjsJYTV0Dwvw3J8223oMHupp3ANljn/6mGuxMc
         rUs4W/CLVJ9na/MkBraLiHcTgbvY1GkA7S2Z4Zi1j4iQ0T9SqRM0YCyxVQMMO0A8rvbv
         HuLqefBD5Umw24ObzvALC5HmA7m2N+c8zHZRBsXKr6D9XBpmyn91LKXlaVXL+OsI3sn1
         3Gl8QQlVjrtEQajp+UOBZJdWBrgpOBGtlnH9jBiBxOAA4tk9Lx8kUprO/Wb3yeF3463v
         rVwF/QkEHL+fhGjHV2Jzp7zba/fyP1uepXMGxHmXAQjU8aVP41KNOH3BSTzcCJTrwRwc
         b5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711728571; x=1712333371;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gjscHG/5S+L8WJOUAMMwlEW/NvPcV4LXsCXmFhSKmAs=;
        b=vSq3PK2UDY3KGEltcfFZ8gQMnfV6wGyiN/WHizn00YijBajs8AadDPtEiieEJ6rwzL
         afeETCEzigtTrzlfTe7FovZF9HSJ1O545/rMFwD/MPxqVtP2pN/saFXkfN+/IH8pOZHk
         9uT32GANaa6oZNLuw+3K7I3yTXyuluiQMry6ln34FMiT1gckBJFFnP0q0SYBYdGOk27y
         B2DD6XSnDVEBsU1cqE9HqauvwUNYDsHy38JCX6iWPKbv/JakRHSx34bAI1nRypdaFCNm
         3Zgrq1VSefUhiM40qf6GBZwNwKAjnMI0BSQ9AiKyiTk0mjky2OD+LAOOgSleXdAvGEFB
         gs6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXmaNz5kUBoV62oCUjrbYGkJZ7qCUIHgq3s46jysILhMqy/iUHa5UZoS3pChRC9F2AA1P0oL2LVtxwLHcAA3M6dfMjBZufhAJY=
X-Gm-Message-State: AOJu0YzG7B+2OFFQjHthpWJDwKjyN6udXzgtKejWOjfFcNXjxir0Ng9e
	tCxvPUwU/8t1zYeoY7xnTR39nu/mbap68JrYlfPqbr9CqLKIBeoCx7Pv8JDuF0q83z2rp6eEarS
	9
X-Google-Smtp-Source: AGHT+IEPkfLOz+KO68dXZD141d47ZFufUYbLwX6q8MTRznnr8OHnMYLOWqHN8BnA9vSGN3gm6sCBRw==
X-Received: by 2002:a05:6a00:13a8:b0:6ea:88a2:af80 with SMTP id t40-20020a056a0013a800b006ea88a2af80mr2825073pfg.1.1711728570637;
        Fri, 29 Mar 2024 09:09:30 -0700 (PDT)
Received: from [192.168.201.244] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id ls29-20020a056a00741d00b006ead792b6a0sm3286568pfb.93.2024.03.29.09.09.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 09:09:30 -0700 (PDT)
Message-ID: <c28141b1-ac68-491d-83be-7fb5ab43baff@kernel.dk>
Date: Fri, 29 Mar 2024 10:09:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/msg_ring: cleanup posting to IOPOLL vs
 !IOPOLL ring
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240328185413.759531-1-axboe@kernel.dk>
 <20240328185413.759531-3-axboe@kernel.dk>
 <25f1145c-9d13-42ed-8824-5b1364551627@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <25f1145c-9d13-42ed-8824-5b1364551627@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 9:57 AM, Pavel Begunkov wrote:
> On 3/28/24 18:52, Jens Axboe wrote:
>> Move the posting outside the checking and locking, it's cleaner that
>> way.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   io_uring/msg_ring.c | 10 ++++------
>>   1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
>> index cd6dcf634ba3..d1f66a40b4b4 100644
>> --- a/io_uring/msg_ring.c
>> +++ b/io_uring/msg_ring.c
>> @@ -147,13 +147,11 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
>>       if (target_ctx->flags & IORING_SETUP_IOPOLL) {
>>           if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
>>               return -EAGAIN;
>> -        if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
>> -            ret = 0;
>> -        io_double_unlock_ctx(target_ctx);
>> -    } else {
>> -        if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
>> -            ret = 0;
>>       }
> 
> A side note, maybe we should just get rid of double locking, it's always
> horrible, and always do the job via tw. With DEFER_TASKRUN it only benefits
> when rings and bound to the same task => never for any sane use case, so it's
> only about !DEFER_TASKRUN. Simpler but also more predictable for general
> latency and so on since you need to wait/grab two locks.

It's not the prettiest, but at least for !DEFER_TASKRUN it's a LOT more
efficient than punting through task_work... This is more of a case of
DEFER_TASKRUN not being able to do this well, as we have strict
requirements on CQE posting.

The function is a bit misnamed imho, as it's not double locking, it's
just grabbing the target ctx lock. Should be io_lock_target_ctx() or
something like that.

-- 
Jens Axboe


