Return-Path: <io-uring+bounces-2806-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 926F7955345
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 00:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46A6C1F21FF8
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 22:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 334FE14533C;
	Fri, 16 Aug 2024 22:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="GVWquQlX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6F71448E0
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 22:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723846992; cv=none; b=V8bZZvmuHIF8RO3Fo+9i8vO1Jp/d7AYoeBFKF/gnzktppR+9S0Phe2Fy5flO5Zo3b1EDvyMfqwyllqHiNM0Vql2tYbPSaCVvyfKRdK486Ss0rwJh4B71eDz1KkW6bpNY0UZ5cfCW+uak8Lv7z3eF/72vVvlTj4uFTiLXbPuKg/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723846992; c=relaxed/simple;
	bh=bTysRd1bAhztbXXKBteDMqUVM4YWTu4U8qR5aQ1Wixw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=THApfx01LWB0/FUiM1BGxKB5ouHpW0VR5vjE2Ktgkzpcoz1mkOH7UKC7U6Dj1NI0u5CDiFt5FkqbOpqUtRX+3P2LKNMXhqNTl24oKlFFd9iNp9mYjzKhK+xj20Z2Q9KFZ57F31DHhUPngVMwyEFUF0lfjc6i8hOdUos0eGtnzSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=GVWquQlX; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3db23a60850so1594107b6e.0
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 15:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1723846989; x=1724451789; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nuVkvW4GNrLeoim63/iv6czDdRqnKmw2mpDeGoZCC0o=;
        b=GVWquQlXojyndIU6ogSSv+CfgAgC15mVCRQXAMVT8rQlJET7+IAs8pDLEgAoqRtE9j
         Ek1Jf7nXxWUbpCfjekXEX9ZVAuq5DPq8/j/IVWqTX7ev7UtvOtyJUBD7UaUdCTidOGYK
         09qqzaktdJoTpIOemSF0HTdetYXRZA8GmzOwkifSD+wbQDMdfqIHVs5/IZ7piJ4kPerj
         0akvCpnMRBBHjwqTJ6d+qHsg0IszzZ8VQYqil+EEfQ7ruzCm+/E5DXk4VdyQnflHZghQ
         GdarCcJYFWV9UAO3FPdDB6jBHvU9wI7QuIne+gqluqFIDMeYgmG6swOa0+tiDzCyZYqR
         z9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723846989; x=1724451789;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nuVkvW4GNrLeoim63/iv6czDdRqnKmw2mpDeGoZCC0o=;
        b=cKqBdFGhIqDrSziAOhwh+XAktcw0mPPubIK6qywpioudZokKc72Kpas5Cw1aZzL/sX
         4Ke8Jl93p5DgY+jd7DphZeaWLLi5qkCD/Np6e+x2OPU358LhGGf2hzi4VgCTi6nQKbFD
         Q9FkeHXeW/EQYPRYekP48Cl7oTh0ujbeCNbG1W4XXuAXUu4gNgbqeZle+L8/4b1IA7io
         DDDbnM5lbpokZVwWndKwLszRN3/nOlJqtvQQzJeKn7jsAslDUjfWHi/aTx+o/GQmIVaU
         D4DMNl9ezl/XuNn48bLrrXF3mSDuoMgzSGwRcGAxk79Toezxlv7WEyly1Ec3Ck9X9Ar4
         e5hg==
X-Forwarded-Encrypted: i=1; AJvYcCXiuuqdW6MxrPEBbkIa0dTX066IVClJ+vTMsNn8nNnDtG4P0rw/LalQ60Otu9IM0NJLlTD7VqUyZyEFCqIb+8TUNewdjBZ6Nkg=
X-Gm-Message-State: AOJu0Ywi8KlqNgC5Fv3ZMu2Ik5g5cjDCK3YQ4Z82n0blUhuZiDnZfwtZ
	kjKNa6mePc2XPlfmhgHW0RHZIPG3V7XQE8ob1VV+NeUdruUYK6lbPjnmiznHk0k=
X-Google-Smtp-Source: AGHT+IFMI1DSIBq1qNQ7RyCk3Pcepeh4W1X/aqGaFlKSrNSHjRdBRoUj2k5v60s8adiN/qr/s1wJSg==
X-Received: by 2002:a05:6808:1407:b0:3db:2025:122 with SMTP id 5614622812f47-3dd3ae07aafmr5303842b6e.36.1723846989657;
        Fri, 16 Aug 2024 15:23:09 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:1cbd:da2b:a9f2:881? ([2620:10d:c090:500::7:a8d6])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b6356929sm3502878a12.73.2024.08.16.15.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 15:23:09 -0700 (PDT)
Message-ID: <803eef8f-49ca-4cd2-843d-d9e5095269d8@davidwei.uk>
Date: Fri, 16 Aug 2024 15:23:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] io_uring: do not set no_iowait if
 IORING_ENTER_NO_WAIT
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20240816180145.14561-1-dw@davidwei.uk>
 <20240816180145.14561-3-dw@davidwei.uk>
 <5163db7a-c40a-4cd1-b809-e701bec6f98d@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <5163db7a-c40a-4cd1-b809-e701bec6f98d@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-08-16 11:38, Jens Axboe wrote:
> On 8/16/24 12:01 PM, David Wei wrote:
>> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
>> index 9935819f12b7..e35fecca4445 100644
>> --- a/io_uring/io_uring.h
>> +++ b/io_uring/io_uring.h
>> @@ -41,6 +41,7 @@ struct io_wait_queue {
>>  	unsigned cq_tail;
>>  	unsigned nr_timeouts;
>>  	ktime_t timeout;
>> +	bool no_iowait;
>>  
>>  #ifdef CONFIG_NET_RX_BUSY_POLL
>>  	ktime_t napi_busy_poll_dt;
> 
> I'd put that bool below the NAPI section, then it'll pack in with
> napi_prefer_busy_poll rather than waste 7 bytes as it does here.
> 

Thanks, I will remember to always check with pahole next time!

