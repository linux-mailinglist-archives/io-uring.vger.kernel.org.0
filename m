Return-Path: <io-uring+bounces-10220-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E311AC0ABDC
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 16:07:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5A5F3A6FEF
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 15:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23BE713B280;
	Sun, 26 Oct 2025 15:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="rQevN++t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A782066F7
	for <io-uring@vger.kernel.org>; Sun, 26 Oct 2025 15:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761491219; cv=none; b=U2Df7cUAYVkytzXx/h8VThAP6seu+wQy9OYSjtGkVfAjNF+jOsAPLftOa6B0HFjLA7hBbKEzhhvUDx/pfT4odpxD2uLK8K48p78XlBNUM5tik1+rrnv7vo9C76ewnnGjNEQ8UrZZ5Ov6JunS8NlDfz+BYiOVQhgVxPicsrW8Byw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761491219; c=relaxed/simple;
	bh=5GGMRkSI4d8+tD4TA6r4LveMpYENo9Im+iO54sNr+iw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z7lcW6drzjrjx3EnxVd8o1J2dfzJP5FwaqepWoOEtX+taxppf9kbnxDTFw9nPZSil9hLhgQegJhFv8SiAG3Ul6vww4Q5DMgDBwb+a+3IiKNJ/hAz++ZSJyuEyZYP/Idvt5bhUDGelxN6FZv/8wA34KljNC2KsvDRcjDwSFUlJBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=rQevN++t; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-33bb1701ca5so3478711a91.3
        for <io-uring@vger.kernel.org>; Sun, 26 Oct 2025 08:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761491217; x=1762096017; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bejr6fb3023EKDlNvUJHi45ybr5AGE7VVK5YDyAbObE=;
        b=rQevN++twTVK1p4Y/L330Ovy8L1HuDVekPXADMruRyuplStEsl0lR2no555DdYorVY
         cP+a4UnAP6TBokx24yZ7mnn9v5EUFYO43Nh140ZUpUaVwQU+dciuWfX9L/7TI0W21Ue4
         7n2GlOLt/WIMre5ytZvLbgdIUN7kIPx8o5RUW0SVaLcbKyMvnVMsO2LpxKQzv41bGbwl
         dfF/tPfUkU5Mn3nEvKXqQWOCt5B9XLhESKLqKv7zDHM0stlg9SlCzDW3Y0eCj853ADH0
         7b8SUjs8nUFmSPaBA9SG35nUGHHXx2wI1VmVxfoWLHtR6G47yX1gIax/IIzNoQV9JV8A
         iZSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761491217; x=1762096017;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bejr6fb3023EKDlNvUJHi45ybr5AGE7VVK5YDyAbObE=;
        b=NDwGc0eGz8TXL/4APa+Qb/dtVTGWIbJeBSS3+TdElT9YWBjmLSHq8yvgYXuOryLbyk
         NKfCPpW9m44tTgd7aqjWxWf+fR4uNEUdCgzZHGloUqWLtUevtgX05zzG4e9dWihxur2P
         kOp6QKgUln20g8FR5JT8LJsHP7VKjAeWaqodWE6RxC8blXReFUmvpbNKRmlBfyUT+FP0
         vj855m1ejiVd8F6KVVxv6kcaMpYEwkzvjdNe5oD5IoI9R66iNkEafwV6oM+0mLe/M1R7
         B2V2vLErWcPzoK1Nh+pG47w3041RIOZMkxi2iDIIAhAJf49brof5Qdp2P04JZF6u/Kgh
         wnKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZssSYAPT/TDL60q8p5pVxJG2ByJLm+F0R06vluuAQ0TDKy8qnfx1pHqZHET1Rv2/sHd+0Y9A7mg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9pBDGD2HibAztDJL4LDRj6qpy5CjlM7tu+CCkM8LjbZlD8Jo1
	/4UwpnfJ6GXgGx6FOHqbOaWXTdQawGmQbHUnIXOLRVAqnl/A/ze+gy74uF2NQqKOjbY=
X-Gm-Gg: ASbGncsf6dDuqg7kA0K83PEQwh8eq/9v6iGCPZtV6oT/stbwLBkqY85h2Ek9ss+VrfH
	chTGLYnBS5Po1hhs/awkDRaC8MSwTm1X8pXiSzxpdAdmlg3l2mqMOGZ/4vhbYWi0sCX3lQcl4yg
	rWyCS1cNNtrtD5fhq51opPHs4mq9CArAsXgH3mQ7MvT07Hla7IP6DsfdahqakCJ97jHiGiMNFSl
	lPUonxRJb88dxHTy8PihdYIrzBaI5nGrM4uVqwYxnZ27fqaEgq/S9utEH1svupRv5h9028dSFjN
	p5bt2B6HrznK/L3dKBXjzITtyWFHkY3YysZRqfvl9TqYakZGGno8bfMWnVC+b05m1HeeEi8AOwF
	vjZySzBc1wkqkxmSzdkHxBHFeOWpdBLZlaIbbZYmhYiK/Xhx2gL0kBTd4EN9i8ODMrQwefLf5ZF
	xS0HwmwdSZwC1vfp+dkxnI6uid4b/M0obtAPhPtIs=
X-Google-Smtp-Source: AGHT+IGSuYMw+4qbYl+40pf0ckK/243HZTwuCGugNqPM4I8wLgPesKwVZp1Pad0qkipjtPwGM8UElg==
X-Received: by 2002:a17:90b:1d88:b0:32b:df0e:9283 with SMTP id 98e67ed59e1d1-33bcf90e86cmr44489521a91.34.1761491216967;
        Sun, 26 Oct 2025 08:06:56 -0700 (PDT)
Received: from [192.168.86.109] ([136.27.45.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed8178d5sm5502198a91.18.2025.10.26.08.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Oct 2025 08:06:56 -0700 (PDT)
Message-ID: <fdf328c5-c933-4b9c-a683-c910c6fc16a4@davidwei.uk>
Date: Sun, 26 Oct 2025 08:06:55 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] io_uring/zcrx: share an ifq between rings
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20251025191504.3024224-1-dw@davidwei.uk>
 <20251025191504.3024224-4-dw@davidwei.uk>
 <f1fa5543-c637-435d-a189-5d942b1c7ebc@kernel.dk>
 <ffdd2619-15d5-4393-87db-7a893f6d1fbf@davidwei.uk>
 <3a7a2318-09fb-41d2-9ba1-9d60c7e417a6@kernel.dk>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <3a7a2318-09fb-41d2-9ba1-9d60c7e417a6@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-10-26 06:16, Jens Axboe wrote:
> On 10/25/25 10:12 PM, David Wei wrote:
>> Sorry I missed this during the splitting. Will include in v3.
>>
>>>
>>>> +    ifq->proxy = src_ifq;
>>>
>>> For this, since the ifq is shared and reference counted, why don't they
>>> just point at the same memory here? Would avoid having this ->proxy
>>> thing and just skipping to that in other spots where the actual
>>> io_zcrx_ifq is required?
>>>
>>
>> I wanted a way to separate src and dst rings, while also decrementing
>> refcounts once and only once. I used separate ifq objects to do this,
>> but having learnt about xarray marks, I think I can use that instead.
> 
> I'm confused, why do you even need that? You already have
> ifq->proxy which is just a "link" to the shared queue, why aren't both
> rings just using the same ifq structure? You already increment the
> refcount when you add proxy, why can't the new ring just store the same
> ifq?
> 

The main reason is I want only-once semantics for decrementing the
refcounts. I used a separate ifq to do this, marking it with -1
afterwards, but I learnt about xarray marks which lets me do the same
thing.

Hopefully v3 will make it clearer what I mean. It's looking really
clean.

