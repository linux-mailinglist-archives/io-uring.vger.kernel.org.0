Return-Path: <io-uring+bounces-2715-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 79EBE94F652
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 20:10:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1AD6AB21B27
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 18:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2081188CC0;
	Mon, 12 Aug 2024 18:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ysQynSmY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A915D18732B
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 18:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723486253; cv=none; b=Y2NugL7c83oqdGPux1754pMn2i6aET9bYmHVbjD7RfYmU6PnVHVEZZZK+hH/ijknDVpCnvzHk7ml8mj9uvRwhaCt1kSty4KE107FufwtCfOx9gGLTxp//HHMNaotA7we/fTTbW9dxh2Ko6w5qjYyMeratpZjx12I2f2XWRHU0kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723486253; c=relaxed/simple;
	bh=wZUziFloZMNO5UbhdLgCFC/TdinrqeAoxlEOhjuJc+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GjMLSbTTlAb5bo5Dt6GrCOMyuSix1tp2gsN3VRyMqQxUA34yCS4BYbD1uujUrootoDDGLlMeSgyBUk3LHAF3KnEmFGNR0rPUT0ZcouDQvrhmPAj0i9qy0k2Bl1GQz+fzm8uCRHKYPf8gbHVAv0wuUjWaCtzo5ke4zSSdQuOlhL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ysQynSmY; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-6e316754f65so112467a12.3
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 11:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723486250; x=1724091050; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dBgQIPgG/meUK6vb6jl28hzmHFqD36Khmo1hTJYdNvU=;
        b=ysQynSmYqwh9WFEgQtDqtnf1x3E4RiyKT2vkz3vDWvFQf4AJQ+oAaz+NtXNGPAL2fh
         Cu++0sSdFS9RHnzeghknqmGPdsaqM6rBFn3MrsKtxatwBFFniVsxeA25dFhfknKV6PoE
         QRqZFcdVksqIP9ZQug1UskPMqs1n0KB6wmxVjl/3x3im4fybjwQKed4Kek4v3SQ7/h3o
         iAAxns257SzBEP6VzPwHS1ffEFj7QLdX7auehvlod238s2qFj4vJoYXpwgUhEDICiXnU
         f2dlylgAoBM/GeQyAbCPVnGpRHAFQQW46t1/exzFGPFTdVcuVnBC5sIhBD61k1xfsbnJ
         gCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723486250; x=1724091050;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dBgQIPgG/meUK6vb6jl28hzmHFqD36Khmo1hTJYdNvU=;
        b=dTlChhecGJpGJzunP/9yS5SzH+LwkZKUQ3Rqn8GtTrVUfX19+qG/tU404qH5PTn3zj
         xtoTa/81ZuXf63KIyZTTi25/WzZFhbG7f/+muZsgU27SLUzeUSAvrUMbZQmKOYLvdr/6
         xk3irZv1MK189h+6opRB36sirkyL6fCqXUn9MSi49y1FY9QEFC+jygsWtX/xKbCAJEVZ
         cQ+RMmrRMrJ6fAps8bUKbIMcUOpOjpWxCi25HbnP9LgL6IXsZqjOrFRfiKRfDehbsHPP
         Bu1yoMvxG9dVhXcKDbiUsYZcUaczsZ5v96jjSfngzjUqcDSXbai0uA8Zv5Ala8Rl1aXo
         zeRg==
X-Forwarded-Encrypted: i=1; AJvYcCUN7m9frNYBLaRQKEk5N/rO5Z7LVms2v5Z23U2HLgvBNJh/OUkyOwRavkNJNhSupDEuUWP4xRA9Ag==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOzlJEeUK49fIlppKl3AGF4HUKa7pV6bOnf7ChemxV4VWY0EvW
	3gDLcJ9OfIcJPlxu0pZyc3Owo3VVKXh5eObXwoWm2/di51nkqrM5871WyJ/LhWk=
X-Google-Smtp-Source: AGHT+IGD/drmH538LyVemiVTYTUKs7vfKDQHygW1+4WOl5UZ/VPdxY4CWv+8KFhCklCZx9XDV4zuww==
X-Received: by 2002:a05:6a00:2d08:b0:70b:705f:8c5d with SMTP id d2e1a72fcca58-7125525d46bmr684572b3a.4.1723486249802;
        Mon, 12 Aug 2024 11:10:49 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c3dbe8cae3sm4451630a12.62.2024.08.12.11.10.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 11:10:49 -0700 (PDT)
Message-ID: <8c1ee6ab-8425-4d13-80f5-ff085d12dc91@kernel.dk>
Date: Mon, 12 Aug 2024 12:10:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/napi: remove duplicate io_napi_entry timeout
 assignation
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
 <05255cc5136254574b884b5e10aae7cf8301662a.camel@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <05255cc5136254574b884b5e10aae7cf8301662a.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/11/24 7:00 PM, Olivier Langlois wrote:
> On Sun, 2024-08-11 at 20:34 -0400, Olivier Langlois wrote:
>> io_napi_entry() has 2 calling sites. One of them is unlikely to find
>> an
>> entry and if it does, the timeout should arguable not be updated.
>>
>> The other io_napi_entry() calling site is overwriting the update made
>> by io_napi_entry() so the io_napi_entry() timeout value update has no
>> or
>> little value and therefore is removed.
>>
>> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
>> ---
>>  io_uring/napi.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/io_uring/napi.c b/io_uring/napi.c
>> index 73c4159e8405..1de1d4d62925 100644
>> --- a/io_uring/napi.c
>> +++ b/io_uring/napi.c
>> @@ -26,7 +26,6 @@ static struct io_napi_entry
>> *io_napi_hash_find(struct hlist_head *hash_list,
>>  	hlist_for_each_entry_rcu(e, hash_list, node) {
>>  		if (e->napi_id != napi_id)
>>  			continue;
>> -		e->timeout = jiffies + NAPI_TIMEOUT;
>>  		return e;
>>  	}
>>  
> I am commenting my own patch because I found something curious that I
> was not sure about when I was reviewing the code.
> 
> Should the remaining e->timeout assignation be wrapped with a
> WRITE_ONCE() macro to ensure an atomic store?

I think that makes sense to do as lookup can be within rcu, and
hence we have nothing serializing it. Not for torn writes, but to
ensure that the memory sanitizer doesn't complain. I can just make
this change while applying, or send a v2.

-- 
Jens Axboe



