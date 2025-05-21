Return-Path: <io-uring+bounces-8060-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84B28ABF705
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 16:03:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DD994E5C6B
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 14:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A32D184540;
	Wed, 21 May 2025 14:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ePgK/aR2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28C72D613
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 14:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747836229; cv=none; b=CCyQVlBCUL06NMczuHa5kRugYWVTzqVTUcG+xF5lNMaV82x4s1qLP+fZO/r49BCcKRHfL3eWveBpm8Z2A6VC3g3VmbzR3W3OTfcVhDCxDba2OlmsSIk09CnV0YWZ/85+U53l7exzQIdauJ23lpfmMU/zUvQsNC4FjOVB2tw11eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747836229; c=relaxed/simple;
	bh=RUNGBfVaDZh75I0xohwM9Pr434Mddr8kIlHGZrJTHns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PKERU+D88kiUdByLoSQUdxukjmqKjakt7ir4yGVrLhBKafCoytJ2U5wW4idMhljhadrsEjY2KvKQjtscNorr9WBSgD2vc9HDC62Vbrjpuik4dLRCMjoQgNjrSx7Mf96l0/pyEecOp2hAekTIYQ3RQjraRCKu+g+yBBWW1iVyDMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ePgK/aR2; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-60179d8e65fso2762873a12.0
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 07:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747836226; x=1748441026; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L+8aePrlF+depIviEBqAivb6igK2YbH4eLBpEqdAfD4=;
        b=ePgK/aR2XpJv5DxDOQQrHkoG0s9/HG8D/aLMGCIh6soF7e7bCBCI2BBDpqbDJzQAq9
         vATrP53eRnPrXPIjnsgEOV4zlXROd6GS0cAuNjP7ybnU+kDedaMoWgjGo9lU1Ri/pJZ0
         LM2+9ugf4bj7q25Ef1pD4TQPisBFO+3hPK2FdcWRWa0fV175s6dPdBUtCIKEzetFJgzK
         UPu0dqMpKJlVno0Skz5jLTn9cTYyjUWx6X20sQKUJJdaDPUc1k54ydGs3WezpYxcweYN
         tDVn+O7FdnZIUUmRCeVjdJ/z68Nwuj1B4wbILoCIKERlYe8l3W3EJPuFRYNwZByYSmuC
         7ZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747836226; x=1748441026;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L+8aePrlF+depIviEBqAivb6igK2YbH4eLBpEqdAfD4=;
        b=oVyo+B7FKjZfcCYfyBwvgoFH9g+MWtE/FXSKb0M0ihmaUprwUmLBFBGyL2S8UIfblF
         ITwDa//Y0X+GGn41pOkI8FRDsYMYf6Ey1rK6mDDOxMFQh/EGOQciD1s5txaHhZP4Snv1
         CyjEuCP19XOmH0OvON5mraiGGgrK1BYXItvq0B4gPKgDqgsdVqP6ZfCD0+t/84S4gF1h
         iKplYkj1txDBLop0ejqDh7qWyBiAfB+x4Gwq4yL0Nqt96jQadoyyOU5ZuPo8V7OdqTNg
         j57+hpzc4hoeSVwCnlo26XjN6d7NBFYeQ8cQ6s1xXp+wIUQWZrCPq+xxdEwjDCIgS74p
         FkYg==
X-Forwarded-Encrypted: i=1; AJvYcCUDEavkQ5P7yJlIG1nzuqtpvt0Tisd1NBFdveF74Iprcusf+zJQKpDcVWn5hLbTwkBgQdJS9uHkqw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyH84okTijG0fRnJob8iu629c0abWN1YhDcn7QFqGhn8DYZMwnK
	x1286Zgu92XukrfS3ycMFc6Z4og7hKaCs5hKEUOEVxi+DiObM+9qenOe
X-Gm-Gg: ASbGnctDA+kNqC5STaz0pAKYS40s17uimHE9rBcvX6ikqEFUSXG/+PPXI9BI6cycwTu
	mJ6p8t7oHxYKAu4UW4zpB+W/wYpyH2rFuN1pzI+szLTICs63VVpKe5G/DBjQ+4cksKbYBG3b9zO
	yTbcyho023pBTIQ7fFeKMDdR63+QSPRs3TmNgb5lCpLAYoSYjUKzLjtFjR5oUlnHqNnOhLr3tNU
	b2GhmkfUzDDsXo3QWd/Vd7l6RDCs9GO+L76D2ITj60guq9FU0YlTigWiMdeLnTxKIPuy3GLPazG
	SGK04i6euizADTOGNOkAawgbBc6+vjtC0C/unPLqzE8W+NJ9DT6Za5zfE7bG
X-Google-Smtp-Source: AGHT+IHxyW+zatIVQ31txSKOh3/vFU2l46cs4MOirCpAX2fqioIcP/vLCv2VyqOPRL7SDkNiXvhYUg==
X-Received: by 2002:a05:6402:5248:b0:5fb:f4a5:7871 with SMTP id 4fb4d7f45d1cf-60090076e17mr19315110a12.16.1747836225742;
        Wed, 21 May 2025 07:03:45 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005ac32f5csm8870864a12.62.2025.05.21.07.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 07:03:45 -0700 (PDT)
Message-ID: <48319c53-9556-4a97-97b3-3530247b6046@gmail.com>
Date: Wed, 21 May 2025 15:05:05 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] test/io_uring_passthrough: add test for vectored
 fixed-buffers
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, io-uring@vger.kernel.org,
 axboe@kernel.dk, joshi.k@samsung.com
References: <CGME20250521083658epcas5p2c2d23dbcfac4242343365bb85301c5ea@epcas5p2.samsung.com>
 <20250521081949.10497-1-anuj20.g@samsung.com>
 <7e846c8a-3506-4581-bbc5-fdf9e084a5bf@gmail.com>
 <CACzX3Av3G1K0aoZXDOHjfT=Su6G9D-_RyKWjdMwsNpba8T7CFA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CACzX3Av3G1K0aoZXDOHjfT=Su6G9D-_RyKWjdMwsNpba8T7CFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/21/25 11:35, Anuj gupta wrote:
>> LGTM, it's great to have the test, thanks Anuj. FWIW, that's the
>> same way I tested the kernel patch.
>>
>> Somewhat unrelated questions, is there some particular reason why all
>> vectored versions are limited to 1 entry iovec? And why do we even care
>> calling io_uring_prep_read/write*() helpers when non of the rw related
>> fields set are used by passthrough? i.e. iovec passed in the second half
>> of the sqe.
> 
> Thanks, Pavel!
> 
> Regarding the vectored I/O being limited to 1 iovec — yeah, I kept it
> simple initially because the plumbing was easier that way. It’s the same
> in test/read-write.c, where vectored calls also use just one iovec. But
> I agree, for better coverage, it makes sense to test with multiple
> iovecs. I’ll prepare and post a follow-up patch that adds that.

Got it, it's overlooked that rw doesn't pass longer iovecs. It'd be
great to unify the main loops of read-write.c, iopoll.c and nvme
passthrough tests. All of them do the same thing just initialising
sqes in different ways.

> About the use of io_uring_prep_read/write*() helpers — you're right,
> they don’t really add much here since the passthrough command handles
> the fields directly. I’ll work on a cleanup patch to remove those and
> simplify the submission code.

I don't care about the test itself much, but it means there
are lots of unused fields for the nvme commands that are not
checked by the kernel and hence can't be reused in the future.
That's not great

-- 
Pavel Begunkov


