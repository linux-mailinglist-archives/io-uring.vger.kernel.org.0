Return-Path: <io-uring+bounces-3320-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05667989714
	for <lists+io-uring@lfdr.de>; Sun, 29 Sep 2024 21:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 343C61C209A5
	for <lists+io-uring@lfdr.de>; Sun, 29 Sep 2024 19:25:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F6E44C97;
	Sun, 29 Sep 2024 19:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJiEZEQZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E102F2B9BC
	for <io-uring@vger.kernel.org>; Sun, 29 Sep 2024 19:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727637910; cv=none; b=jfMr4C0VrA2evR6GH/jIvUezBXBleqKeutZ41A1nDsvvR4nsjqslDWKuisEDVcuQ7JoF9BiMBOEhOAUGiRaj0OxPW6Ta98jlg4iMTuToMZQKyg51lGN0mOZOlGqKaliokDY/MgmKkgWH3htkb5fTQi8eHUDporpDGCQNrZUHsAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727637910; c=relaxed/simple;
	bh=ctK+ajeJKAHnij5lJ3MkNsALtx1fDY2KbcVIOatYuqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iCHuHuCmYs00Cq5yDfSn+SdPLcNh+YlZ87jUqHP7iGJafm6lc0IcmrS99K2dgjGq3DVbOvUZjOY87rZrWSAUTnO5fuPJHUatr3+jx9g1qHOh9XgZmTUlQrC1L3za6GOxAGGkbvX0YnqXeQDzfFu42+O5seQcUUKzDiBmEB3cs0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RJiEZEQZ; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c8784e3bc8so4436959a12.1
        for <io-uring@vger.kernel.org>; Sun, 29 Sep 2024 12:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727637906; x=1728242706; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9lE1d6zjgQv145IYf5K6n0CgAksuovpxYUCQkL8Y0Eg=;
        b=RJiEZEQZTHY0+maSoJCxlNbjSgOeNCnYzBHJ583K1I6i5QaHaSEh884zOiUAGrXEfy
         Z++SerH92Rr9OD31TedM7M+oJrh6XGk9JwPcnJsPLGP8FSYRu51qC9fCm2VBOgcVrBBH
         SOskzPo1JHUppoUPpt0DdAfE+FzongYsP5bM8MAYaAu0aFplj1zhS+0HEYrRzvcFhEO3
         KaLvzWGO2K3q7uCl0OoE1mUAK08VJREAt1s3vHlqfs1N+CW88xnfb3ej98IQ0p9pRop3
         /ZIK/ervBLoLEtV+U/FSPdFXEUISx9jTcHmRm4nSqH6HK/GiDnKe3AOMCVvI+BRhkDXQ
         Xjzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727637906; x=1728242706;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9lE1d6zjgQv145IYf5K6n0CgAksuovpxYUCQkL8Y0Eg=;
        b=GQx5kyHONxcmmbS2U2xORBftyfRf3/agitjs+cps2pWt9hGl9tINPoyNmQo2earjlt
         wgizCGjApWnApKATOq2ppIIjicaPDPwc27TKfvF2WJAS4vlvnx2yol/rVPUKQ0gLg4eT
         L2MnslpZHi9cpv6NIxqt5g93sL8gjxT37Spd4LUliCviKKSuksUz6tMfOj1xbguUGVy7
         Nvbv/JZPUQWab8x/1rnhUbwyuEYlgj5SbTH0bEP0VHOJ9S82TqYc/6RoacyFH1HiQwJJ
         VuD1QfYfed4oujRIotoObrrXMwd2vDUhPvyh8f5ZYL4bL0KvqAUSJ07d+y4OpLJU8pT1
         k1KQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4KmewpRfqkpLe32aAhJATFgxO8ZXgYnhtO2PMjeFYAm3yrtiO+PuY2QqMnRV19M5daKi1YzjtKA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyL9jfOGzT1olpZw2m3Mv9wHp1XfNMD/QJA9ff6043jU0z7YG5R
	S8fqcCR5TNIeCeSHHNuyCg6Tpj5+JccVpvNybm9yVoSGRRsmTgszpAnRFw==
X-Google-Smtp-Source: AGHT+IEqkOvWLf73c6iTqQU9nc4EnaRCXOCO/W427qdAq7aOJrmwuqvW+pajFV35rzsbwFi/062szQ==
X-Received: by 2002:a17:906:730d:b0:a86:96d1:d1f with SMTP id a640c23a62f3a-a93c491d2e9mr1235090566b.26.1727637905956;
        Sun, 29 Sep 2024 12:25:05 -0700 (PDT)
Received: from [192.168.42.130] ([85.255.236.33])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c885f5336csm2543540a12.97.2024.09.29.12.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Sep 2024 12:25:05 -0700 (PDT)
Message-ID: <0542e045-e5ee-41d3-b44f-5b6f9657f90a@gmail.com>
Date: Sun, 29 Sep 2024 20:25:40 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: fix a multishot termination case for recv
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <fc717e5e-7801-4718-941a-77a44513f47f@kernel.dk>
 <2ddaef0b-0def-4886-ade6-8fedd7a0965f@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2ddaef0b-0def-4886-ade6-8fedd7a0965f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/28/24 13:40, Jens Axboe wrote:
> On 9/28/24 6:18 AM, Jens Axboe wrote:
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index f10f5a22d66a..18507658a921 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -1133,6 +1133,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>   	int ret, min_ret = 0;
>>   	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>   	size_t len = sr->len;
>> +	bool mshot_finished;
>>   
>>   	if (!(req->flags & REQ_F_POLLED) &&
>>   	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
>> @@ -1187,6 +1188,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>   		req_set_fail(req);
>>   	}
>>   
>> +	mshot_finished = ret <= 0;
>>   	if (ret > 0)
>>   		ret += sr->done_io;
>>   	else if (sr->done_io)
>> @@ -1194,7 +1196,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>   	else
>>   		io_kbuf_recycle(req, issue_flags);
>>   
>> -	if (!io_recv_finish(req, &ret, kmsg, ret <= 0, issue_flags))
>> +	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
>>   		goto retry_multishot;
>>   
>>   	return ret;
> 
> On second thought, I don't think we can get into this situation -
> sr->done_io is only ever used for recv if we had to retry after getting
> some data. And that only happens if MSG_WAITALL is set, which is not
> legal for multishot and will result in -EINVAL. So don't quite see how
> we can run into this issue. But I could be missing something...
> 
> Comments?

I noticed the chunk months ago, it's definitely a sloppy one, but I
deemed it not to be an actual problem after trying to exploit it at
the moment.

-- 
Pavel Begunkov

