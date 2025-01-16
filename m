Return-Path: <io-uring+bounces-5917-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59016A13BE0
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 15:13:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C67D53AA162
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 14:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E6122B8D2;
	Thu, 16 Jan 2025 14:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fxrQt2za"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EAB22ACCA
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 14:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737036619; cv=none; b=eM2RXrlpgeOfkq4r8AIOxydjWF4h2XWm21bn1SQfUQrW/3YaMgCmGUuiFTUqjLhl+sS4iw/MxNJ93DSOObGnadN+Vrxcak0duL6YtgxJ+AmuzNZMY7por1De0xL0Q/YhTtOfjEMOBNRU4ORyiHvrKdD4KhCowOgtCS10gUb1Axk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737036619; c=relaxed/simple;
	bh=syGnBX0RBGHdtNP3ojey18Ws/A7mzJsMDko9+9169M8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SC8HNnvui6cCHBR3lWKLMrv2JgNmlRC81hOSgToxWV9RyMgVQDXNQizLCk3nrHRSp+t155FtT1r4JGXCVS/LehMH0WQG3DzezjQlQ/RWJtIXiCT659b2FczeT+v0iT6AI+Hz9afLbpCTjKyJmY2c1rdcmRHIhW5pUzDRp6HKnQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fxrQt2za; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3ce915a8a25so3127875ab.1
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 06:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737036614; x=1737641414; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9ndLuW2fV04ESZeeP++y4naYWGWMtA/jjlcwVROPYdw=;
        b=fxrQt2zaVRaVfm4VMvbq/4fm81CY/kUbOnm837/UTYd28YNnPA3px8j+Zs5A1XPtzX
         wL1Q4Gce/AQjRzxHTA1bSo0oNZdNiqgOsa8sZpIvLsYmoSesKBCoBOQc5srthEhgEgMj
         +GLq21rXUorMajehbPXXWwVTc5Q0mDKSdeCi8k3Ij08vLRmcex52DT+aF8hJxhaJielz
         ocD5Uy2coXMUXCF+1QONxmxy/V5YHKSXN9Gm6eZJPGNl8Dh7WPNlPE+aRt8w3YWj4LC3
         D3rRpTkrqzQqXEU+SICQ+/Bs3rhs1Y1N+jJFdP2UbtyuuwFBHPlZVn+pyZJbISiITo1O
         3iiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737036614; x=1737641414;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ndLuW2fV04ESZeeP++y4naYWGWMtA/jjlcwVROPYdw=;
        b=S+9hwkieipUKH5okUUY+145MC1NorOQ+ujg0fCQA/+/HJW59M+1BbPtJ7YmH9u9kdZ
         J1L02bKNkugAZM6COy5/qlPdXHmcf/iFfFHoXn2tM17VABv8f5P+6dpLlrFaDKYExZvP
         yMHmPHxSor+hDI+OOZl2OTR+kr3+NlGI12vREYqiriAKPLacInwtSc4T5LTQdwvLWNSW
         QNZWhC1sY3GXgGOTyd4KHtPghW3JaS0rUnAP+Yd1fs95okRvaU4S/3LOlxXH49/7p/Om
         eqgNYE0NUzeYenUtOP+lp/+AUrsKhR+tKTblvAeBYGkzUTzXtTLpwacH6Kot9lahLsxR
         XckA==
X-Gm-Message-State: AOJu0Yz1VSXYPhPs8aiP7NP9Xftc+AEX7gBzwG20+RasVWm/TsPhbua/
	H6ioHoYnHeqgQPubO/7OlFj269H5zFfb1IBLR3KsImeYHwhGiZtxG95RNDTy6dtmhYdzk6RxfZm
	z
X-Gm-Gg: ASbGncue/HrdDwAPmc/EFfu/lBlUxdJYk3mH2i5qyoYH/EiwxIlnraFVRk2sC15Q218
	n+eDm+TlgqKHLD0PvRqi0scnIzG9/Pc1BdbehSfmZEF06hDBM5tRrZwB+gEGo9jd+3w5ro2f46f
	EFXWH8yKn2aOmxWbeWwUDPGd+tBH8oLl0pTh4zP0j5DL5FgzvW/CvwGmYXUM5gZ9MEldCsiANCc
	PG64Izl/l8AURxeOcuHGjmSUfqhMmmHAnxQXFAjjKaImXOkGqsn
X-Google-Smtp-Source: AGHT+IHgxrCPSh2R1e5jmGHCS2HQBv4XifTzn5o53qyyEQJ/lOq3h4jOiEvh58laHW9DLCy/qAVyvA==
X-Received: by 2002:a05:6e02:1:b0:3ce:7bbd:971c with SMTP id e9e14a558f8ab-3ce7bbd9852mr105065835ab.15.1737036614550;
        Thu, 16 Jan 2025 06:10:14 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cf71ab002fsm198815ab.37.2025.01.16.06.10.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 06:10:13 -0800 (PST)
Message-ID: <eb0fb2c4-bf88-4fa8-bbe3-4eca830606aa@kernel.dk>
Date: Thu, 16 Jan 2025 07:10:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: clean up io_uring_register_get_file()
To: lizetao <lizetao1@huawei.com>, Pavel Begunkov <asml.silence@gmail.com>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <0d0b13a63e8edd6b5d360fc821dcdb035cb6b7e0.1736995897.git.asml.silence@gmail.com>
 <5c2d3f69cb7c48d48b33c1a84dddaa8c@huawei.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5c2d3f69cb7c48d48b33c1a84dddaa8c@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/16/25 6:09 AM, lizetao wrote:
> Hi,
> 
>> -----Original Message-----
>> From: Pavel Begunkov <asml.silence@gmail.com>
>> Sent: Thursday, January 16, 2025 10:53 AM
>> To: io-uring@vger.kernel.org
>> Cc: asml.silence@gmail.com
>> Subject: [PATCH 1/1] io_uring: clean up io_uring_register_get_file()
>>
>> Make it always reference the returned file. It's safer, especially with
>> unregistrations happening under it. And it makes the api cleaner with no
>> conditional clean ups by the caller.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  io_uring/register.c | 6 ++++--
>>  io_uring/rsrc.c     | 4 ++--
>>  2 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/io_uring/register.c b/io_uring/register.c index
>> 5e48413706ac..a93c979c2f38 100644
>> --- a/io_uring/register.c
>> +++ b/io_uring/register.c
>> @@ -841,6 +841,8 @@ struct file *io_uring_register_get_file(unsigned int fd,
>> bool registered)
>>  			return ERR_PTR(-EINVAL);
>>  		fd = array_index_nospec(fd, IO_RINGFD_REG_MAX);
>>  		file = tctx->registered_rings[fd];
>> +		if (file)
>> +			get_file(file);
> 
> Should performance be a priority here?

Performance only really matters for high frequency invocations, of which
the register part is not. So no, should not matter at all.

-- 
Jens Axboe

