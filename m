Return-Path: <io-uring+bounces-9128-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80A0FB2E5A6
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 21:32:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 397781C8719C
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 19:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C984D27D780;
	Wed, 20 Aug 2025 19:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j2XtCqSs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A1036CE0C
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755718370; cv=none; b=iDKitVqGxYUHo7Qw35/xbUaVDEha/jAbTd14sIFbb91fzIX40p1gwqa6px/Su6dt0wKOyXGqcCXeSXVRAgQvA+eEjOJpk/yffC8qfkRe8Lv0gsnns1JkbYgKzOwkpvIYLHOC2eyfIGxNwveTF6yRE5Fdp+TanyZRbQEjXIjR5H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755718370; c=relaxed/simple;
	bh=MU4nZLR8FirgiXSHHhQn9FYy56VuhaqzDWgPHwxHG6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=plaGcYBcsOzgPFksmK1cRNh5VHLbRVbgYxNi1mNu0yum5a7PdwritV/qEKcujKjgZ4FD96WFEWm1q/KoqUFkIuIzDyzcd04m/vl6ZD7LS0EgDah7NsEuTvZXAShMuhs8LEOjmnHcZGq7hLsA1/gN2Z1Np+Q0QExUXGfjgXUvuNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j2XtCqSs; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-afcb7af30a5so45334966b.3
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 12:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755718367; x=1756323167; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JX77pTfvc8qS33yxZqL8KXeihML51aKtvuuWLA0CJPI=;
        b=j2XtCqSsnIcgAUrUjpc2YFZH7lhdYVA/78uodVyVqgqJrGHjPFgTqBdCw/3IrwJJxi
         4CZmAXCjeOFwhX8BUgwtFe67ijjeFlbvq+WjCKvRClOp1T8R7GzkrVj5W2ooUtCLCbMM
         DtKqxwfChJHddCsDctghDJxjWMTg4THaJYWonPIfk969wQ/KixuswXawJgv3o2ERDB6f
         bK22OLG2vB9oSceEeljM6DeDvnMkHBMNomaKE6UDpVHwEy+/pShDgRh1nJDky8Uk2P3x
         CFmOx4IczhCYzdxg0j7y0JxcN7udTtl5tHwFx1C6B3qLaoKhzC7EEH4Lpjs1V2Mz7OQz
         YCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755718367; x=1756323167;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JX77pTfvc8qS33yxZqL8KXeihML51aKtvuuWLA0CJPI=;
        b=mLjnlc1gbQuJ7EmMyWYtgvQ8cnAHftw5lUCXoe+dwT7+EVw84dQgm0gpCyvGo9OPMV
         RAADyLTObhfBsCQlcZR8ja6MVzu2fXazbTOsRZFPvj2Un8SOlHyyyV8kY1gl7b8tbbhX
         kvizVdJ/ytnRSpaccXIFdRmpd4B+2sdHTvCihPHlgtk8HjYo54bbWRjO1x+fVhwesh36
         PLT/WXN0vudKCdWjRqZ6Bc6/LqMaJ0Aysth9cUQ1mAI0GTinnKsg54V9fWIpIyFEFwKc
         b94sCvy9mSFSfzqcziBrcMPf5XRdLC3CDxUeN5GgCKf0qbWMUvddJay1YbDfXBouAtCe
         +j1g==
X-Forwarded-Encrypted: i=1; AJvYcCXMGoPwOsQW9KmJJB66SsK6oVraZ3aO5ei79IKDsEATq+tJBmFlLLI5sbjQns19+5H5uin3j9GeGA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrjja6/rPC4qCUj5Ze4YB6BZnr8ejMD6PzyOxVaS72E+TJ7M26
	B5sSaxQX3EsT4gkmOfhZATd6QUzgybaqPauy795UywOe4PaO+P6M+IiZ
X-Gm-Gg: ASbGncv1sG5B3/W/RCGD7O6mlJEJQf+zIzn91YtZASX4UyCnbi2VPkJ6cOnBDI/rS2Y
	sqPNcr2V0uZBHxvPhyYUmPflRsWt0+Sg90wrt2QRYLrwp2f4aRQWMH/oKqpLfuG5BZNBVUAioTd
	nG46h23Qbd9BRLVLNpU0OLKlX1SMrN40wtC5EmA3eBMBIy278bjy9jw0ivsxDSNsfBTXUkKgyLQ
	efSzWM1B42pKwp6RIkNyNbx6rUz7yWN93qu8UBgCodXJwB+GwyMhL5oOGiiP6t72s8r1/UpLEev
	wdevUgltEbadQV/s+mWX9UbnPAdGbjftcoSBy4Vu6oA9RTzepq58Wq8CTLScTx55BVo6ozfqO7R
	Q801TaPKHA0CXT+jfqd/D/9EahwVIJOmy
X-Google-Smtp-Source: AGHT+IFKoVySIXv9+nWqnpsEAg/SouXYuKU4eqxAPbTelNckzh++L+VmPDZkeMPTCKU/gHE/yLcWeA==
X-Received: by 2002:a17:907:7b8e:b0:afc:aec3:7da4 with SMTP id a640c23a62f3a-afe07d45139mr1631766b.58.1755718367193;
        Wed, 20 Aug 2025 12:32:47 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.113])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afded4ca695sm232185666b.90.2025.08.20.12.32.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 12:32:46 -0700 (PDT)
Message-ID: <20422c51-1227-42a8-8506-8f499eb53e89@gmail.com>
Date: Wed, 20 Aug 2025 20:33:56 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [zcrx-next 0/2] add support for synchronous refill
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1755468077.git.asml.silence@gmail.com>
 <175571405086.442349.7150561067887044481.b4-ty@kernel.dk>
 <c6ea1a29-3a0a-4eee-b137-a0b2929f00df@gmail.com>
 <b811389e-2a4b-42b3-b9ed-3d31e5e30fd2@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b811389e-2a4b-42b3-b9ed-3d31e5e30fd2@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/25 20:02, Jens Axboe wrote:
> On 8/20/25 12:57 PM, Pavel Begunkov wrote:
>> On 8/20/25 19:20, Jens Axboe wrote:
>>>
>>> On Sun, 17 Aug 2025 23:44:56 +0100, Pavel Begunkov wrote:
>>>> Returning buffers via a ring is efficient but can cause problems
>>>> when the ring doesn't have space. Add a way to return buffers
>>>> synchronously via io_uring "register" syscall, which should serve
>>>> as a slow fallback path.
>>>>
>>>> For a full branch with all relevant dependencies see
>>>> https://github.com/isilence/linux.git zcrx/for-next
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>
>> Leave these and other series out please. I sent them for
>> review, but it'll be easier to keep in a branch and rebase
>> it if necessary. I hoped tagging with zcrx-next would be
>> good enough of a sign.
> 
> Alright, but then please make it clear when you are sending
> something out for merging.

That would be a pull request, should be obvious enough. Perhaps
it'd make sense to tag for review only patches. Any preference
what tag it should be or otherwise?

-- 
Pavel Begunkov


