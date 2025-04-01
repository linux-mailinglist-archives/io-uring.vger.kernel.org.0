Return-Path: <io-uring+bounces-7353-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D43DA7829D
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 21:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 774D67A4E98
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 19:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4336721149F;
	Tue,  1 Apr 2025 19:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="aGfrd8jw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1421A7253
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 19:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743534661; cv=none; b=gGKMp0vCQA/DX5TVulVXgchdZVq/7Ka01WICeYvQ0DdAfAXIrKaDrL2L9+nGwEIWMoOsHScjTr/UU+RkMl6SWp0LhCfIHSjbNk5V78CfkMywhiWSaSG7ElCVjdsDNO0SLQir4PtODWfqc0c4u379HaLCrFVdAW9k6xXudRlTyJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743534661; c=relaxed/simple;
	bh=39wIHJouwCFU4itGDEddaRqOYuRAMjLFcaBIlbKYUHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dxxmTjGuyTVKdIhpiEVE+WRdD6IZJI3b49lm5adBp3F+XGbcF65Bkv6RgWwdNxnT09/bJI6Ce9d2/8sfWU+xbcopJGayxIk4hZV9eFe3OoK0d/M2eE2IZjVlL4q7rcw4+6+GbwG8lWXzBwejcIEVHKVCPQ5oP7kpDsK+WeYHdOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=aGfrd8jw; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2243803b776so46771105ad.0
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 12:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1743534659; x=1744139459; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YP+KGabLT56jAzy9JEhpvLE2TwMaIKxI5QpZ93GyGpQ=;
        b=aGfrd8jwAJApB+FIeDBTesLBRt1IkPWrWGaYrMJaUw6SsdzEOcX/V1z85vu5TlUFZH
         53aA+zyUGaHSxbTp9e5gFZEA+/BVAZnmOt+yGadrammiNFaI03pVLsUW6shDJ42q/rav
         P9ABKugedSu/g1NMnhRmq+TNhfOJyuI7pjdcTVSmWqxVvGrgOfmh1Fq90HGMannz8C7i
         XSZ3xHO3R6EMCJnEF06a6FvjaXHF7iE16v/4thOyPKht5lc49GwqpSjmZ9tGdYcfAKk+
         1BQeVLsg6y69H6nu+Wdz0FDnM5ltZ9QPaFX0ps/hPUh6KMZTfJiDuO8u11DsGuVKiPVB
         Ol0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743534659; x=1744139459;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YP+KGabLT56jAzy9JEhpvLE2TwMaIKxI5QpZ93GyGpQ=;
        b=K2GlyeiYis9rqBHVe7RYJjizpKVmKmtoJVOQMYGkT8Tu7pEO7d/xvf1wDNlKZKAPRk
         fNtY+TnLt2Qqo4jt3YNJkNbW69/fkFSdBpqS5WtnPnSoHfE8UxcaC9lvUDtUzrawnt7I
         IULDR/HpPDbs4XYMH6/YJHOLijkWRpYarvmjTojzeSYSGiF4Sxn7TRLTq9cyQXLpRfqp
         IEjJQzBP9X/k6PmdFR+hhhaburgmvST7kHF0Ggo6Bo9NyfF2+9NTrYUfe4fLOlUzsi20
         8QyA+IQ9p7LcEHTK4gWpF0F8biW8QDepjSKQoCKUgx5eq27QWythMtk0UX1E+X3IRXnd
         ITfg==
X-Forwarded-Encrypted: i=1; AJvYcCV2R4AsamaumZagcBNBVj9NjZf0JHM8DIhnpdhWckOnPt8m/iVSLKGfny2+8nTYnWtKBgfthy2M6A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzbwqnNE53NnyAM/jSZbyaB+LmVACmq4dib7K2VJs2bUtFwGx3R
	30Ag6W/PgXRHKZEE9/ydKAE2YkAfqDZfslEut/7S6KkVoxhRN7CYkQ/VjJR+CiRXOZQdkfZS3Bs
	E
X-Gm-Gg: ASbGnct9z942+rtydRPl4+9SWktU0EBUB3qf9NjLy8FhPo5BsgHulKY4yEtEQcfKGFA
	ObFhQGkuPBrFFJUpcHFAZvEk3tnvDQk890WiJ5yGQg7+9j896csg6RziAcoT2FuKYx3er3MyNlL
	qgtMVs+q6dgrJivpTG11aRmM5L8WVj1A/MbddCz7A5/gjyNO5F3MsuKMYWdDDmGIdlUk90ndYde
	bUonbZk8oHVtNc66q9dwWYRswV8ncQJyOW76iBLZ2cueZtdESC1PWnw2thylvtcaiwhECSFNNtQ
	lGKweiwRFtD8RBD22DYtErqHOArHwrgYyvT/ctXuuerYNRcIW5FUScSeqURcTGpu4bjK1EF4oGl
	Ypwip6hA=
X-Google-Smtp-Source: AGHT+IEqo9RyMK8teSDwhulXpeelwZ1nqYSe+C4mLTcUi4RcwTwUlaTFaQwobBdMnjbtyti1eeoxew==
X-Received: by 2002:a05:6a00:1909:b0:736:6268:9ec9 with SMTP id d2e1a72fcca58-73980424500mr20847109b3a.16.1743534658762;
        Tue, 01 Apr 2025 12:10:58 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:1cf1:8569:9916:d71f? ([2620:10d:c090:500::5:4565])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73971064088sm9587725b3a.93.2025.04.01.12.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 12:10:58 -0700 (PDT)
Message-ID: <20e4d11f-688f-46de-9094-765073f0dc41@davidwei.uk>
Date: Tue, 1 Apr 2025 12:10:57 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/zcrx: return early from io_zcrx_recv_skb if
 readlen is 0
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20250401182813.1115909-1-dw@davidwei.uk>
 <e89aef50-7364-4ab9-9582-aef6aec8cffb@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <e89aef50-7364-4ab9-9582-aef6aec8cffb@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-04-01 11:56, Jens Axboe wrote:
> On 4/1/25 12:28 PM, David Wei wrote:
>> When readlen is set for a recvzc request, tcp_read_sock() will call
>> io_zcrx_recv_skb() one final time with len == desc->count == 0. This is
>> caused by the !desc->count check happening too late. The offset + 1 !=
>> skb->len happens earlier and causes the while loop to continue.
>>
>> Fix this in io_zcrx_recv_skb() instead of tcp_read_sock(). Return early
>> if len is 0 i.e. the read is done.
> 
> Needs a Fixes tag, which looks like it should be:
> 
> Fixes: 6699ec9a23f8 ("io_uring/zcrx: add a read limit to recvzc requests")
> 
> ?

Sorry I missed that, will add the tag.

> 
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>  io_uring/zcrx.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index 9c95b5b6ec4e..d1dd25e7cf4a 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -818,6 +818,8 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
>>  	int ret = 0;
>>  
>>  	len = min_t(size_t, len, desc->count);
>> +	if (!len)
>> +		goto out;
> 
> just return 0 here? Jumping to out would make more sense if there
> are things to fixup/account at this point, but it's just going
> to find offset == start_off and return 'ret', which is 0 anyway.
> 

Makes sense, yeah. I'll return 0 here early.

