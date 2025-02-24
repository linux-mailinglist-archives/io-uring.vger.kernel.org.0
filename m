Return-Path: <io-uring+bounces-6693-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B127A42A67
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 18:55:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 054A27A5D36
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 17:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FC2C264F86;
	Mon, 24 Feb 2025 17:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NxTRE61I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681E72641C2
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740419727; cv=none; b=F0fK6oBoIddlHonyF74uDaLZVWS8XT2r/E+C1PfAsZ650A0/gb/y+pH+0GsKlUfNWuBcK0i/nDEWbe5Z4e4UFKWNSxtxLbcAX+sXgFcBsIY6tg/GwyPnUmgYqM2TN2Eq/XOjLlWELsc1P6XFer/koWOedAxuflsJ5iuBT9CmQwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740419727; c=relaxed/simple;
	bh=aHxQ3RpgVyxdHjQE/CzgpBbZ7e4Z7E1ZeJ/blA+sYqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BuuAKaI1DB+qPpCER0k7fOzwyjfeeYjomEJyd/qYvdfievwAITayQDYmIYbITv6ydqGg+LEwaMLIr9lIWIEFkwyYSq3kvx8ShSCEMqGrHo0yXNvF9vkBnO41/sD+0R/lPUTUScXi/tx6M6BO+213RsETfX+MRGaFyW+KipitjME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NxTRE61I; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-855a5aa9360so348146339f.0
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 09:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740419723; x=1741024523; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1uzyU82hmIsAi67Xq5Y6egExuZwd4OLfYvCWCU2BXJo=;
        b=NxTRE61IhUNX6gP1C1ngxoWh2wdxVxiFkXPK2o1WzukRLlKkFsfHtcIi/QrgIA3e6D
         Wmv+OeugepqtOKS3A0s3JPaaQqxPKhhQ+/LCa2uCVkKkbF9g9Xgajw93HmjHWDSWLwG5
         RAW3kJtRpihIY8M31KwQLAlu7NFyCxT2TYUhMB7CPIhaB7YBJZtJJpnsQIX1S0b5Q5Lk
         +qUdlTHq1o1pqJUeD9ebuNX7IGGXAnbu6Otn2/b6ZMuREUp57R6gBe+Se/uYQkCh0E96
         aVZ7UryJV95+tLvCIii9v667aEJDTKbHP8uucSK09Izs2mgtaPSKu3MfkMsOLVdhrSzb
         JpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740419723; x=1741024523;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1uzyU82hmIsAi67Xq5Y6egExuZwd4OLfYvCWCU2BXJo=;
        b=t5iCVHuQqhF9Vwl9nc5hdVkhU5aN++rxI8VavaHD2ZatBmpvoeDKBENbwQC63vZhR2
         ZDfPmVhhs3RHHlpGBefF06OXomn4BxWsCczcP5bfGrU4Fkg21x8Yg6QL1tLuGfW33m/U
         Zr3X2rT14oCmmw2oDYFoKk3Uc+TMtmYJ3YRzha3HuoPeQhpmegYmtfn3cE+5RxTPPjtC
         Ky7cNib4xPGnhQVH+1m39ooCZ8+OFWWidxcbwA1pOVXlPo3KGuoWJNVg0ohhVToP6p4Y
         foak4NB8vHHLT3j626QF9dU5FGctAHff1bhqIOM3zyzj/h9sSpT6PZgjiUjmBBWP0/0o
         yGzA==
X-Forwarded-Encrypted: i=1; AJvYcCUDli8vuVr7g89txHOGzs5TqT6dz1JnYJlgf0XmFfJQBuPj1L1/CeNEPp3LJbZR888f9wXfvLM29g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5cySkcV/oQOnHEJc3hsmwIewmeRJHsG9FEndjP65Mi3ZE9Ooi
	w7UcThIkoqcH4+0JEFcmECbpJglVzDHNcbOukyWN100GoyPBTbL14ZmIHMRjtQa2F/DevXAX2Jl
	g
X-Gm-Gg: ASbGncvfbHUN1WwRWxcoIacQkpk8hw6yChvuMENnBcIhLrz3RfWIlpfBHArOUmdOsUS
	uvKe0I4B8GiGVEfDP1ixwqIiiZmFm1qTuWgepMU8+qjdxujSF8Dvy0kEfq/UBJO6Uf2h7h/3U+u
	40h4MsubuEBfy9c36+QvCK4wTEaB6ndysA7M2McY3jbgoq+ZdnxGiAAWCwlxnnnPiQYjK/V5GG8
	Pona46qdL14qYhIdtL2csz32LtxMN/HiCQlmfTh/ODp3dzoUF2KAJfmm9ESoa9vYNw98XHTO4bA
	PGip4cY95chJ98RAelgSRsE=
X-Google-Smtp-Source: AGHT+IFMKNwb9DdbQv5NBCGYRpuI/1FV/FwOCa9S1u6cQx71eQK5s0ZB75Sc3VNIaRoNkDF5hdJkRw==
X-Received: by 2002:a05:6602:1485:b0:855:ac69:32bb with SMTP id ca18e2360f4ac-8562014a58emr31561739f.1.1740419723435;
        Mon, 24 Feb 2025 09:55:23 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-855a00df541sm327191239f.5.2025.02.24.09.55.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 09:55:22 -0800 (PST)
Message-ID: <fedd8628-327a-473b-9443-4504fab48c2c@kernel.dk>
Date: Mon, 24 Feb 2025 10:55:22 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/waitid: remove #ifdef CONFIG_COMPAT
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250224172337.2009871-1-csander@purestorage.com>
 <ebad3c9b-9305-4efd-97b7-bbdf07060fea@kernel.dk>
 <CADUfDZrXAn=+4B9boaKe3aMBq19TXn8JDQm4kL0ctOxwB6YF9g@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZrXAn=+4B9boaKe3aMBq19TXn8JDQm4kL0ctOxwB6YF9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/24/25 10:53 AM, Caleb Sander Mateos wrote:
> On Mon, Feb 24, 2025 at 9:44 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 2/24/25 10:23 AM, Caleb Sander Mateos wrote:
>>> io_is_compat() is already defined to return false if CONFIG_COMPAT is
>>> disabled. So remove the additional #ifdef CONFIG_COMPAT guards. Let the
>>> compiler optimize out the dead code when CONFIG_COMPAT is disabled.
>>
>> Would you mind if I fold this into Pavel's patch? I can keep it
>> standalone too, just let me know.
> 
> Fine by me, though I thought Pavel was suggesting keeping it separate:
> https://lore.kernel.org/io-uring/da109d01-7aab-4205-bbb1-f5f1387f1847@gmail.com/T/#u

I'm reading it as he has other stuff that will go on top. I don't see
any reason to double stage this part, might as well remove the
CONFIG dependency at the same time, if it's doable.

Pavel?

-- 
Jens Axboe


