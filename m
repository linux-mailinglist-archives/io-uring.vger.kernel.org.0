Return-Path: <io-uring+bounces-7344-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 920D1A77D71
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 16:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C63223A1277
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 14:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560B3FC08;
	Tue,  1 Apr 2025 14:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="R62X9tDm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A15D1ACED1
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 14:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743516933; cv=none; b=h8N31edskvVhuhaIEZCvCYTo8XbT4i+dffl9B01nW8f362hfKNgMe0ECkMOzoADgJKclM9/PvMxGHJ4VcxIQ+LM71LsozloWIpiy/ZMoml8jRIkPx7KwLm69M14NeG7f9mM07g9l7V0zNhBKBudGWmZ/z6bdbWdnKrz/l3jRbn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743516933; c=relaxed/simple;
	bh=uMeoGZcBgXyjE9WomOTBr4m+2h8KynUOwRi9L+VdmYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VqMD8MYWS1stT/9W0mAKVMNvXLPUqrCapdBYYY4gtR5VayQFizXxpKwglY0xzcyik4774zzYpA5R94iuuG4HNrHO0TLh2xJ533JDkb20jxKcfEkQNgminfYoAVcRwzcO8pXV4azoSh3wlcgzgN8mJa1VwNtYMxACW2UUtzu64as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=R62X9tDm; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-85db7a3da71so535332639f.1
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 07:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743516929; x=1744121729; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zeRYu+drKPArzPzmxG8i1KjNcBJ1Z9urg8LWfgex2A4=;
        b=R62X9tDmo3BZaF1mH99s6FGuFTs2CRk4o3TBgm8jp5bz664ra0Fv3S2qJhMeycrj1b
         EfQp/mXCXp3rluBLN+AhZ89ZnxE1qHPHmUJsdF+4FToIlFNVI5MWnRrPHnF9bQJ/JtF3
         Tbu0gaa533nSl31K3IfQwuqIf5t16WabIgpyfYOl9FYS8MGU4YEJaFv+5ow0a5+zi9k2
         toEq98QGTnmvxbYDww0mUihdm24J4rLrIKx4+Mzs9Wb23HrPCXD0iH1UYKDP+H50GFCo
         cuFBg9sGqDC7zNTwChKBNlfdk6LLW8YOWzLM7JtSBxdn8vn63QvJeVEh7N+KuRH4o7Ng
         N08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743516929; x=1744121729;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zeRYu+drKPArzPzmxG8i1KjNcBJ1Z9urg8LWfgex2A4=;
        b=lIUGca1bLjeUg8D54PKJ8ICPB+n5SSsIyrcD6j5TzMWSM5A8zNmKJ6e3OaS12jDYu1
         2NcPltXZ0asVSf40WS2iZ2j9O3Lin4EmGUNbHmq/trtTIXnPPo4NUvccPH/raWIUB3DE
         giS5ZW7sOiVwGAIu+sSiWmukpExLwjsHzQaqVsTYjAqZ8REFOGbc2qRWI6MVIq3ruZEb
         mZomeU1zJNsq7AxwHYpIFOZT1dslRYs6RefQwEIbpi0MmWVC0BBuAtNElr1U8kaUcSZr
         bJSNiaFuI/T0YaXMWhnFJCpP+UXecAyJaYWSJFx1jeLdR0I6s9XQW5InfKe6x8pTn6K/
         4Xaw==
X-Forwarded-Encrypted: i=1; AJvYcCVR9Q/Ea8GlmKL2QiJMR4cE/Xt7TX5/uz/LQeimE0dWVmmRETHUPRicDLdmDC3wDn0jzpCZzFuumw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMxCMUED6PM8wmG6heuhAi6f79FndYn3IJD4RGBtac21pw1Soh
	9IYFYF2S/50p5TQlhgRP0FduKFUbNHp7d+tH1g+DqwekribosumYZobgKDYFVwFAeSxwtF2sQZE
	z
X-Gm-Gg: ASbGncske0itzVBThYt8rzcTau0PDEnYv/ntKkWdVfOqeG9kp9Cng10kzVfDh7TQRXz
	w1cKXQZVFq2rvKUtazgclCzBLzYw5h8nQXx74u+ukMb9LVOANXmqNd8wyulRpf9AYdkON3oV51B
	meTcKZqyJ9h0BpcOwZOKCDOl8YJRtz/38QFZxtyJCBstZcWkb64ipO4pcLKYvvEuk1pnB1RM4fr
	sjqXX6T/V8PYphe/dhv7FLzbtJI4E5Kq7nC3ZOvQkfmmQgsEoyYhtxvcFEuwTs6Q4aIPRGMES9Y
	rG8FpkfWPvz8b6zwtVm8LJS/rhh2HCDGbfp6Shzmx9GJ0o3oW79R
X-Google-Smtp-Source: AGHT+IHblQOIh9BumPEqDqwSXmRWWt/ezFpcZlJS/APZnvzTksazow+L3bXFtyr+ZcPhilSkmyBJgw==
X-Received: by 2002:a05:6602:480f:b0:85b:3a51:2923 with SMTP id ca18e2360f4ac-85e9e9303abmr1379264139f.14.1743516929115;
        Tue, 01 Apr 2025 07:15:29 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f46473f5d5sm2387507173.53.2025.04.01.07.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 07:15:28 -0700 (PDT)
Message-ID: <79388830-edf6-460f-bb85-00c33afcedd9@kernel.dk>
Date: Tue, 1 Apr 2025 08:15:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/kbuf: remove last buf_index manipulation
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <0c01d76ff12986c2f48614db8610caff8f78c869.1743500909.git.asml.silence@gmail.com>
 <968861d1-23c0-40e6-9f7e-c306db54bb8d@kernel.dk>
 <59a05fb0-fe33-4e28-b3b3-48bfbd5486a4@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <59a05fb0-fe33-4e28-b3b3-48bfbd5486a4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/25 8:15 AM, Pavel Begunkov wrote:
> On 4/1/25 14:13, Jens Axboe wrote:
>> On 4/1/25 5:15 AM, Pavel Begunkov wrote:
>>> It doesn't cause any problem, but there is one more place missed where
>>> we set req->buf_index back to bgid. Remove it.
>>
>> Want me to just fold that in with the previous one, it's top of
>> tree anyway and part of the 6.16 series that I haven't even
>> pushed out yet?
> 
> Would be great!

Done!

-- 
Jens Axboe


