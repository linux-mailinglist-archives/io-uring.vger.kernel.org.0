Return-Path: <io-uring+bounces-5615-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C5EEB9FDA63
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 13:12:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91D5C7A03FA
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 12:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C733C47B;
	Sat, 28 Dec 2024 12:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TVrdHsc5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DD14D8C8;
	Sat, 28 Dec 2024 12:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735387955; cv=none; b=ukoIlfnqm492ZOkiPg/aiwgIUpTeJ7HvIh/3CsLPQ/NA+Mm31J0T2jc914SCmjlpOxpJJfs8md7UriKfEVMygdNcfgEgelDgUQir+76Dimhl+Xo5md47y1A+HG413ctznmEu/Do0jZbEzWUDcC1FHO+Dq1WIQzx/yY6dezEuz/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735387955; c=relaxed/simple;
	bh=uMnnJKTyCt4KRKE3CDma6/jpFIZdfrJFzqYll1jcUvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ku3HJu7GxVud+UROufElkXdaycIfk9VK6iFhXZBmFEdJAM9wNEIob67H/PVy8iNQrOwz1x+mgXY/HrVIrlTCcYw8dn4xvYalA7isoaOkB/SKO3YA9Isr9Rw/81v1o8HFadl+Rwc0KlgnYTYTlP21ckGimj4+VgzwQdSE+cvmBe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TVrdHsc5; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-435f8f29f8aso57189915e9.2;
        Sat, 28 Dec 2024 04:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735387952; x=1735992752; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LWQhzO14XX1XPUOTl5WXsyFZvESbG6TtqK6sLeXBeVg=;
        b=TVrdHsc54iGOArkpHHn5qrQyK48qDqay3LwpwTldMj6zhCnZi0l3Lu8Pu0puyAX2Y7
         JYfXQxxzM6GwvBXF34GZ7HGoEl7xUC3E+hrjtDgOfGOmAfmjGUMw5Er8T1g7GnBVrgam
         cgi1e0rPqitbaj5dRteKQs7Im8Z7UzAKeqg5h2l1za+gkjYlT/c9fUQOxnJELNDU77Ei
         CfWSrTFWJfGjSZcI9uHS9FNzEx2G9WDWb6MjmjJBJ4rEtWAZygYOmI1yZRmzNMQrK6OB
         hihpFwiAEMkvIVHNgg3Z3don+RgNSiEx5ckuq2BVq//+I5Hz56YzlAsIR6gi+F8WoqV4
         MuTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735387952; x=1735992752;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LWQhzO14XX1XPUOTl5WXsyFZvESbG6TtqK6sLeXBeVg=;
        b=MXoX4wwlNcfMqUf1zcE9NQQzC3Xey+zynu+J314Oo98nJ2CZJOd+aO/4Ecej5nBdgh
         iJ2fAF7a6HQhIQJUheSrfgqratqCTpG0xYz8QHMeJy/k5gUL26+nBWKcZY7sm7Lvj1rj
         OX1HAEn1D0DZDVwP5IXF6dfOOQTn4PdS3O4yUQhISkyL4Ki64RSDzG4g2aOpCy4khfDr
         QqhtjItSIicr2hTz2m4Nr8pO0DTJnEXpmGk3QDJGEBE128AckJjGRcose+Nj+tcmFdF/
         +D0Gx37yiWORqoU+Db6SSLLp7wTS2ygfmM9wzLriAWmGGtZIGA61WC/HZp0Hc7LBaqaT
         a9nA==
X-Forwarded-Encrypted: i=1; AJvYcCUuVw8Y64xDD9JJctUpe0PqW9NLHQFctoP7MuA1x4AKzU6C5NQssC9RmIHNhLrmk2Q4uJ5SN69Gyw==@vger.kernel.org, AJvYcCXqfUKa/UNuIAdpUhg5bRalMnkdjKt+2uD5t6gm9Rurdb/l4KBiXmgpoSkVXdKESFgdl4EffunEOBetsOhf@vger.kernel.org
X-Gm-Message-State: AOJu0YwBxEqOxwfVx5fIZt58uOjldLY6QJMZUeJXvxkn5bbLPwQLTgnM
	H8FZidEp7HmoaD24J2/4oQpbTfZjSadslkoKQ86OltxR7+iX1m5I
X-Gm-Gg: ASbGncu906gMzbG6//whVRdgEuYYzGme7HGelRV7jX7HCUB3xdvkR1XzdaFUWv/aquV
	ZSToR1AeDP0V2ezTKvLpNZzGRj3lD0uQcWcNk/QNzJOmND2LeInIZIotTd88tq5TsncctWZI2LH
	Jv6LqOlNzfgpkJYmkOHI9h4xoirlQJdEgZ1xnOkBHwBRvUdOZKDKZmh3/sYgppCeWRTEwCgMgzQ
	KyoCBbiHGj9jfeJrHFDCtYgbXukdNKdRXjbtM+2l3pJIQiw9bCeGcmmA0bPCQm+034=
X-Google-Smtp-Source: AGHT+IFHFkSEzMvyT5apcQ5J1hzuNETQ1fxi/IVJlhuyD/BwOZilGy1BmuA3+BEVNdXAz6KlAAGXPA==
X-Received: by 2002:a05:600c:1986:b0:434:fdbc:5cf7 with SMTP id 5b1f17b1804b1-43668b7a0a8mr239883145e9.27.1735387952182;
        Sat, 28 Dec 2024 04:12:32 -0800 (PST)
Received: from [192.168.42.69] ([148.252.146.249])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43661200ae5sm294042075e9.17.2024.12.28.04.12.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Dec 2024 04:12:31 -0800 (PST)
Message-ID: <2b186ee9-89cb-46f6-b1b2-3da51c82a5d1@gmail.com>
Date: Sat, 28 Dec 2024 12:13:19 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: slab-use-after-free Read in try_to_wake_up
To: Fudam <huk23@m.fudan.edu.cn>
Cc: Waiman Long <llong@redhat.com>, axboe@kernel.dk, peterz@infradead.org,
 mingo@redhat.com, will@kernel.org, boqun.feng@gmail.com,
 linux-kernel@vger.kernel.org, jjtan24@m.fudan.edu.cn,
 io-uring@vger.kernel.org
References: <d4d4da73-5d00-4476-9fd2-bee4e64b1304@gmail.com>
 <DA2747F7-5D2A-4515-9764-B214AAD1DB37@m.fudan.edu.cn>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <DA2747F7-5D2A-4515-9764-B214AAD1DB37@m.fudan.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/26/24 20:45, Fudam wrote:
>> Kun Hu, can you try out the patch I sent? It should likely be
>> it, but I couldn't reproduce without hand tailoring the kernel
>> code with sleeping and such.
> 
> 
> Okay, I’ll try again. Please wait for me for a moment. But you mean you couldn’t reproduce using the c program I provided unless you tailor the kernel code?

Right, it depends on timings / racy, so no wonder I wasn't able
to trigger it.

-- 
Pavel Begunkov


