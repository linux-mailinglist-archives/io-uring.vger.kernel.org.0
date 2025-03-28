Return-Path: <io-uring+bounces-7280-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED169A74F2B
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 18:21:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E48923A4A5E
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 17:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7FFE1B5EA4;
	Fri, 28 Mar 2025 17:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="REuSyWp5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C0D23CB
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 17:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743182425; cv=none; b=ZdtORqPIDJn1p55Zrv6MM1lhdpD8iq8Y7oEsysN0ac2ulrNQwcBrrUX2KmXN7b2O8vW4lPfVIpKnR+OVCv5LRFC/Xmme8lBZU/eu483RbfeTG++dKilWnMN6ZGe+kBvV883h0Iv3hrupsOs9KaqUPzfCTjdwhohmT9WzVFdFATo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743182425; c=relaxed/simple;
	bh=ertufSeix6OBwMwo2sAZj35yCvtTgBFqB2KLwJXefv0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=PC4DKflTzSwDkXdt5e4tCkPfMiHOO/TvvEDJjcvfFEO0VQcsVtasYmsI2YNeMNKIJn4BVjc7Sea0XUGnNde7NDeHNgbr4wZiYW6S/C3qNw38nJHHE1DbZ5xt9jXeX0MfhI/FygnpFsiJfs6BAryGAAJgqjwAdhKYSY3U1+m6ChM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=REuSyWp5; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ac41514a734so396774866b.2
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 10:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743182421; x=1743787221; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MCyf98BfZWDmImYjm0eOMyT9cDL31SNbsQ9t2XSZdck=;
        b=REuSyWp500KEc3XnUib2IKBPV9l7fckCkQ1aVtzU/PqwbclY3enUFxNXLtgA9k2zvL
         BC7Yh/KCKKY6vmbuYPV1BDOxfEua9kVwRUpuSEQPvsNhzbaReuc9tKch2onbjv98d5OO
         Cpke8bvuEG+zbwTpsn8dVvnV/ZWaJT0Ju1Gl/+y8FIUJh+EbRZK0/9MinmdZ4kQ8V603
         pr3bT2JWjY2FOd6j/zleEZ3/0aYa/64rmt91xv2WKRItH5RnjIys0SojW1yi4gx1UQWi
         ULzMQmakP12uiWIxxKlDhtts0bpivuBSd2Ee8SNXyQEtR3PNLzZmoKD1UZIucmqPSb5H
         5s+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743182421; x=1743787221;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MCyf98BfZWDmImYjm0eOMyT9cDL31SNbsQ9t2XSZdck=;
        b=q71/cQWMx/CzQrVrjCfnhLv9lI9E+lnfOkELrBdkyVmINJtBRZpjkRoLHYB+DYI4NQ
         K9/ODnYAsV6+jqPMY734/xBayr7taZu86heh6MTJcVQeh2sXLB5ZLAV10CUR/iVfvIye
         kGgMndT3vEELWsIaDqrCuiFNT4GWRK1Yf+D0Iym0XL14I36CQPuVQu6WVK7IBdBbJ5mo
         xr+eS/lhtJOpoeYMv8y2UcWUpDqoZiSF+fYFTgDBm0wV55mGHikVDKJEJLmEONPQVbM/
         voVIOh3Fkftrv+j14m9XVkxpqk7qyHBFgNwdekcpR2r9COWkL92d/a4kr1G6noXdpEKb
         bn9A==
X-Gm-Message-State: AOJu0Yz/Qw2jlnsavQhRMf6dyniUNfzCcUH81R5bDWRNQEAJp+NNGZ3s
	QinNqHijt06a00BjLazMbnn6Pi85RV8a+mcf9dyHzXKAubbWhN2W
X-Gm-Gg: ASbGnct8HC4XsdubBoHhwyu0oWV4neehbdcUe1MndZaODnRSSkXjto8JhY9Feaub3tc
	lUyvGuks3Gi3MmMm4gF9L2MN45jXRYc3MJFtR0X0g7cbIFa6+jtDA0iW5MOpVYB0tDvnkRCBdb4
	UBbkP3egxd7u5eoUY0MEwUB/S/F050Sxl2xzFVEprlN5FepLcZ1Rf7Cx1NPyJ5fslMexdFZacnN
	uD7RgOCOSbgZTxI4D3wtJMDlSvyjMAX3eCP7X1XiHrMhahUjhk7AC9KtUz24/2rKqXFS/ZAC6EP
	jDlCTmxeH9Z3S1bA0o4AAWwjGs0cq/0lbuC50xEjPYipULKsMFNv3fg=
X-Google-Smtp-Source: AGHT+IHMVrVd3+DsZOleHWPePCROGPYJF3FvcGPW4dpOAsDDNRDGZBWnBoUrmia4U6ULpIjatszOnQ==
X-Received: by 2002:a17:906:f587:b0:ac4:5f1:a129 with SMTP id a640c23a62f3a-ac6faed1862mr929072966b.15.1743182420789;
        Fri, 28 Mar 2025 10:20:20 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71927afcesm193536566b.55.2025.03.28.10.20.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Mar 2025 10:20:20 -0700 (PDT)
Message-ID: <876b1590-0576-40f8-af9a-bcd135374320@gmail.com>
Date: Fri, 28 Mar 2025 17:21:06 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SOCKET_URING_OP_GETSOCKOPT SOL_SOCKET restriction
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>
Cc: io-uring <io-uring@vger.kernel.org>, Breno Leitao <leitao@debian.org>
References: <a41d8ee5-e859-4ec6-b01f-c0ea3d753704@samba.org>
 <272ceaca-3e53-45ae-bbd4-2590f36c7ef8@kernel.dk>
 <8ba612c4-c3ed-4b65-9060-d24226f53779@gmail.com>
 <3b59c209-374c-4d04-ad5d-7ad8aa312c0b@kernel.dk>
 <e5cac037-f729-4d3a-9fe6-2c9ba9d55894@gmail.com>
Content-Language: en-US
In-Reply-To: <e5cac037-f729-4d3a-9fe6-2c9ba9d55894@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/25 17:18, Pavel Begunkov wrote:
> On 3/28/25 16:34, Jens Axboe wrote:
>> On 3/28/25 9:02 AM, Pavel Begunkov wrote:
>>> On 3/28/25 14:30, Jens Axboe wrote:
>>>> On 3/28/25 8:27 AM, Stefan Metzmacher wrote:
>>>>> Hi Jens,
>>>>>
>>>>> while playing with the kernel QUIC driver [1],
>>>>> I noticed it does a lot of getsockopt() and setsockopt()
>>>>> calls to sync the required state into and out of the kernel.
>>>>>
>>>>> My long term plan is to let the userspace quic handshake logic
>>>>> work with SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT.
>>>>>
>>>>> The used level is SOL_QUIC and that won't work
>>>>> as io_uring_cmd_getsockopt() has a restriction to
>>>>> SOL_SOCKET, while there's no restriction in
>>>>> io_uring_cmd_setsockopt().
>>>>>
>>>>> What's the reason to have that restriction?
>>>>> And why is it only for the get path and not
>>>>> the set path?
>>>>
>>>> There's absolutely no reason for that, looks like a pure oversight?!
>>>
>>> Cc Breno, he can explain better, but IIRC that's because most
>>> of set/get sockopt options expect user pointers to be passed in,
>>> and io_uring wants to use kernel memory. It's plumbed for
>>> SOL_SOCKET with sockptr_t, but there was a push back against
>>> converting the rest.
>>
>> Gah yes, now I remember. What's pretty annoying though, as it leaves the
>> get/setsockopt parts less useful than they should be, compared to the
>> regular syscalls.
>>
>> Did we ever ponder ways of getting this sorted out on the net side?
> 
> I remember Breno looking at several different options.
> 
> Breno, can you remind me, why can't we convert ->getsockopt to
> take a normal kernel ptr for length while passing a user ptr
> for value as before?

Similar to this:

getsockopt_syscall(void __user *len_uptr) {
	int klen;

	copy_from_user(&klen, len_uptr);
	->getsockopt(&klen);
	copy_to_user(len_uptr, &klen);
}

-- 
Pavel Begunkov


