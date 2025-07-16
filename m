Return-Path: <io-uring+bounces-8698-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96AE4B0781E
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 16:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D70643A7948
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 14:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1188126B76D;
	Wed, 16 Jul 2025 14:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Yxd1+z9F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076B126981E
	for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 14:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752676209; cv=none; b=kFfpUtFGHwlR5V/tzNKpypP/XnDW4XW6GTaduM3SBoM0ag8+sEbbdDQERa3ARYUTTerRdQAkJvvDE7DEZDgscy1ggTs4S07EF2bML5bNnVazcql3dHbhLNI5gVMPDL7p+WJinaLH815LNx/7jXr4dexWBVl8YhPMCt8xkwJASEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752676209; c=relaxed/simple;
	bh=/fySb6zX4m+9WPPxh2LDL48r4LjPg+Qsne8ngkjNZMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C9SPMG9tCnPrcJVE3eD4dSdFQcwWSAuU4fHF6jtvWsyP5pLoeLZbkqMmZDbIHFpAma8ADsSyM4FgTPxny/+09P4qii0uFhmoxbrj+QbZvr63/0wIZ7UfLQ+ifAr/hCS131G7cVTdZ9XVAIW0aEOO0pozKTG7NdszgK2LXyd3olE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Yxd1+z9F; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3df2d8cb8d2so24056365ab.2
        for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 07:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752676206; x=1753281006; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Uojjm6fcLZ+mUddp83QrZxw9M8qmMMJaZaJ4O0EjFU=;
        b=Yxd1+z9Fr2E2ck7ymxSz5K8tZjj5M/ei9VR94p6SkHhUKNVWZNMqJuPs+vI2B40VGJ
         l6PqybHStKmJtJT+oEJbI5bXjH+kNCAg7/JdZeE8cqQfBUMSm5xgNA3fPF6EDxjHUHA0
         OvMW+b4bLHwSxz99aKwLzqr3T6226TUk1qYBC7WA4eR4+xs/nyaqRRiyOxIqIsxHge9e
         tu+27qTxx79YYvXabBPGyHoJiEdNAkySiV4dihaPykMYcqRd9Kf3hwVYm8xf31wovPK9
         abDmU9Ep9jeIMj88/Mq6Xx5sA0isZJVdseiG8miX4aHdRWZIibzdzG6Us+zcZqjInkYt
         nRxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752676206; x=1753281006;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Uojjm6fcLZ+mUddp83QrZxw9M8qmMMJaZaJ4O0EjFU=;
        b=B0XX9euFFaKd4r6o0dSOlR6V0C7cvNEBxFx8pTyb1Zi+C+fUfS3kBFTg2dnBTjVlAP
         NdgHawEFGLzbVj4jrMhSHv3YM28jcb0HOhvGnihxwM7e8Vi4cE8hF+GxjlPrI9X702SX
         YBpCaPc6PIA/9Swm1APzpUzYxq4iouDK/CkJwdC9+5nJMAEo4Eg4dOF+lnilg+2ReyFq
         0gd6uMr2WBKuwVDptmP+vE7BGD0/d1dPHMDfuekcHrI5Ald8RCOHQjJDqGmXC3LABh1o
         Jgk3E+5s60U8eO9fjHGS73Or9Gn1nnWVg5PPSt1UUKaPw//kprgVrBH+oeUFTbw7lqAp
         nHiw==
X-Forwarded-Encrypted: i=1; AJvYcCVGq5xUxyn7ptbX82DCLtWKBKAnO9g9fgs/t3EDxu2HgkxN0TXKAyOn1McI6INAz0n9M/6RA2Pouw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwnEHGI9ReRr3tnPPnxo1qgvV/RNaGUihbaMwx3AXe0/faSeKQe
	zdWmxzcxcJnjqex5oI7ojjm7PKNNn8LzkNm6FpaGwJWHS1TUoYMvDV7icrKuV+oIaVA=
X-Gm-Gg: ASbGncukkRoXuFnnVmZyoQYkMsMuloejEDHTcSp1VxDYWnxW8MIZKmtHFdb/O4MPKM6
	BVqbKHY1IqTMSQYlLdxrqJ77v3JihQcUC2w2VC5CS1PMnps4BbDPYAWUr1DP9+6zCxp0+suF+CA
	knFUgsFsW9PiF5hs5aaGgTQeh/tKo9YJTx1Wt+VEM2sKHVA9SAowiSSIEcgR8LmqwLGmrXqIxq3
	EwwtRWQtMQjhtF8Q5lO/pxKwB48Sb96Ff39WGAItiOqf0R8pieBFtEU9FgG+Gy9RuVaHZQcXg4y
	y8+xBU5GTDQoxXbv7PZOLg9TzLM4Uu/uCDh0a27dgCXRK+cLod0OHZTZqRnOl/qemeoIlpyGRkS
	rQnTont2bOxRjhjhFwkU=
X-Google-Smtp-Source: AGHT+IH+jLRGEsW4dtjrdZr5d6r5MlS0/wxSW+OlnfF/Bx4B5TKy4HEdvsg+u/BOVaab0R+9o6M71g==
X-Received: by 2002:a05:6e02:4508:20b0:3df:4046:93a9 with SMTP id e9e14a558f8ab-3e282300e22mr24807975ab.5.1752676205462;
        Wed, 16 Jul 2025 07:30:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556973079sm3091349173.63.2025.07.16.07.30.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 07:30:04 -0700 (PDT)
Message-ID: <9df85c99-4f2d-4d12-875f-ce68e781c107@kernel.dk>
Date: Wed, 16 Jul 2025 08:30:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2 0/3] Bring back `CONFIG_HAVE_MEMFD_CREATE` to
 fix Android build error
To: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 io-uring Mailing List <io-uring@vger.kernel.org>
References: <20250716004402.3902648-1-alviro.iskandar@gnuweeb.org>
 <3b28fddb-2171-4f2f-9729-0c0ed14d20cc@kernel.dk>
 <CAOG64qO1S+hd+cgabQn6uYMPGAMm7V-FRmm6btytZE270bEebA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAOG64qO1S+hd+cgabQn6uYMPGAMm7V-FRmm6btytZE270bEebA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/16/25 8:28 AM, Alviro Iskandar Setiawan wrote:
> On Wed, Jul 16, 2025 at 7:41?PM Jens Axboe wrote:
>> For patch 1, maybe just bring back the configure test and not bother
>> with a revert style commit? There is nothing in test/ that uses
>> memfd_create, so there's no point bringing it back in there.
> 
> Ah yea. That'd be easier. I'll copy the configure part instead of
> modifying the git revert result ?

Exactly, just make it that single patch.

>> IOW, patch 2 can be dropped, as it's really just dropping bits
>> that patch 1 re-added for some reason.
>>
>> All that's needed is to add it to the examples/ helpers. If it's
>> needed for test/ later, then it can get added at that time.
>>
>> All of that to say, I'd just add the configure bit and the examples/
>> helper in a single patch and not worry about test/ at all.
> 
> Understandable. I'll send a v3 revision shortly.

Thanks!

-- 
Jens Axboe

