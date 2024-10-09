Return-Path: <io-uring+bounces-3513-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 213D199751A
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 20:50:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D4BFB22E93
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E1C95684;
	Wed,  9 Oct 2024 18:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A84h3SZE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD307EDE;
	Wed,  9 Oct 2024 18:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728499832; cv=none; b=h5MUdxIZpLH9I7Vv3OHiZ0is8oGVPEWjfwNjGz5b+E4GeQLFgQV+HMQ83k4bXy9VIivDNumTtB4LpAx3v3okR4ibI6WAvu+fYENmNgT+sc6/c+ZDOIFZTbv7QPKwVpyjVu7FsXcU3cxOqsyoj2KaPgYdqjKuwaKLkfChgbX7Ouw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728499832; c=relaxed/simple;
	bh=Fv8D1RIDpudXb1fJcaG3kX158HctkF1KAUsM62jfQmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SL6FHP7plg7iaBKW35nOAkAHVAVwDxh5nDOFySgMWG3KOnub/3sY6c7c879WsDX3Z0PyZSITh1WS7b3tF5jwU9l33kEiazyXzHRuuV/C9o9jh8DfDVmseL5a+wKArfw1mloeqsi83gYlQisfKkSPai2uY2DgGD5G9vGfJKqY4PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A84h3SZE; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9951fba3b4so21211266b.1;
        Wed, 09 Oct 2024 11:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728499829; x=1729104629; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=80twF2LO5hczYznwoL2osuEFf2d8bIx1CYdqruI2Mx0=;
        b=A84h3SZEA5r+5MHCS9V8xW+BrCSfapAL3+QBFcDLkP1Tkd9VPOWxnn/4ya5SG3i+li
         DMhNm+kN+uri3Ltc59XN7cIrr+KhRIvYQ8b4PLsYctIVKzSm+5r3u5pO6n83dwwO1tCQ
         H2NczIv4+wHevj8Wmh/aN45ILC7e8AKgahVIlWuZqqU7CK4M8yOWobbdcS9BIJcC+bOI
         yNG0Nw92W6g3ueCFcN3JW14dDyfsEAdSeuPri4ZyRHHcp+iE61hWVWo+veslpv50nNzV
         47DN3oRxSskGlh2m6XRMuU9jRtRl2m84TKFfO/amRGPc0gYhzS4ktRT/DLR6SVmcYiNX
         6GAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728499829; x=1729104629;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=80twF2LO5hczYznwoL2osuEFf2d8bIx1CYdqruI2Mx0=;
        b=LC5x8UnuMmfvI4By+Cha8d/49BjUg2Ha9f5rEKdU+BaGS/yFfZtvzIVlKbS+mcTT/C
         sJond/R2MIVTWW4ruIal4eieBKimi9whKPtYg7d1tdPNMkG8LlH/ZIKwNeHqO9AbDord
         H0x8AbBcocLeVodG+TjeCbc3lBgqujJcGZwQMtjwM4Zs4i5LqIFBsKSX5h4ylpfnBI0Y
         r3mP8lCGV4R+xiNBDkVZR26fa6cY9jQfBtPFuZ06rHjCbyvbBuurYSCFioMsu0a4rYxz
         pKS+TNpHmre06x0zEqM1NpwIJNtZ3lu2sXaXjX9NBYVvGmGepXqu+m5t/y2vzb4/+NYY
         3bOg==
X-Forwarded-Encrypted: i=1; AJvYcCWVbU9RyQz2+Uq+YNNjzuExqeMdMS4v8HVbRJEtzKSoXQhq2DQPYkYFnUiWCVfrF1Yzxk2XwIg1@vger.kernel.org, AJvYcCXrAaxeYH+suvB9PV3nbvMLoO+dKs7Yvb4WMyaBtGZWkslbkQNT2gbWPT+OJumOrjCNM8D9Co5S9Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzcg9IyGgwLfhTD231hz7cdGGIvVaex/rApvD9lDCDBFCMv2Ii2
	NCLPDqXf5kam2qTdPXk+eOksz+Keagg/G/PVBaa2JG/wFIAah9MV
X-Google-Smtp-Source: AGHT+IGpWySytZnXxzMz1WlP5REdCDvDldXRlvcbvW0MISCPMV+ADzQdFTXUika4jmTnb3q3Z88U8Q==
X-Received: by 2002:a17:907:e88:b0:a99:7177:3f6a with SMTP id a640c23a62f3a-a998d34dd19mr288519066b.63.1728499828636;
        Wed, 09 Oct 2024 11:50:28 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.145.180])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9952ac6d82sm463174366b.65.2024.10.09.11.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 11:50:28 -0700 (PDT)
Message-ID: <f2ab35ef-ef19-4280-bc39-daf9165c3a51@gmail.com>
Date: Wed, 9 Oct 2024 19:51:04 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 12/15] io_uring/zcrx: add io_recvzc request
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-13-dw@davidwei.uk>
 <703c9d90-bca1-4ee7-b1f3-0cfeaf38ef8f@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <703c9d90-bca1-4ee7-b1f3-0cfeaf38ef8f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 19:28, Jens Axboe wrote:
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index d08abcca89cc..482e138d2994 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -1193,6 +1201,76 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>   	return ret;
>>   }
>>   
>> +int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>> +	unsigned ifq_idx;
>> +
>> +	if (unlikely(sqe->file_index || sqe->addr2 || sqe->addr ||
>> +		     sqe->len || sqe->addr3))
>> +		return -EINVAL;
>> +
>> +	ifq_idx = READ_ONCE(sqe->zcrx_ifq_idx);
>> +	if (ifq_idx != 0)
>> +		return -EINVAL;
>> +	zc->ifq = req->ctx->ifq;
>> +	if (!zc->ifq)
>> +		return -EINVAL;
> 
> This is read and assigned to 'zc' here, but then the issue handler does
> it again? I'm assuming that at some point we'll have ifq selection here,
> and then the issue handler will just use zc->ifq. So this part should
> probably remain, and the issue side just use zc->ifq?

Yep, fairly overlooked. It's not a real problem, but should
only be fetched and checked here.

>> +	/* All data completions are posted as aux CQEs. */
>> +	req->flags |= REQ_F_APOLL_MULTISHOT;
> 
> This puzzles me a bit...

Well, it's a multishot request. And that flag protects from cq
locking rules violations, i.e. avoiding multishot reqs from
posting from io-wq.

>> +	zc->flags = READ_ONCE(sqe->ioprio);
>> +	zc->msg_flags = READ_ONCE(sqe->msg_flags);
>> +	if (zc->msg_flags)
>> +		return -EINVAL;
> 
> Maybe allow MSG_DONTWAIT at least? You already pass that in anyway.

What would the semantics be? The io_uring nowait has always
been a pure mess because it's not even clear what it supposed
to mean for async requests.


>> +	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT))
>> +		return -EINVAL;
>> +
>> +
>> +#ifdef CONFIG_COMPAT
>> +	if (req->ctx->compat)
>> +		zc->msg_flags |= MSG_CMSG_COMPAT;
>> +#endif
>> +	return 0;
>> +}
> 
> Heh, we could probably just return -EINVAL for that case, but since this
> is all we need, fine.

Well, there is no msghdr, cmsg nor iovec there, so doesn't even
make sense to set it. Can fail as well, I don't anyone would care.

-- 
Pavel Begunkov

