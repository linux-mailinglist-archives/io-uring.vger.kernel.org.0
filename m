Return-Path: <io-uring+bounces-8620-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 760FEAFD5CA
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 19:55:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88AE2540E57
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 17:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662852E5B30;
	Tue,  8 Jul 2025 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ydTgpOI9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD1522FDE8
	for <io-uring@vger.kernel.org>; Tue,  8 Jul 2025 17:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751997306; cv=none; b=BJ+kRJQFOfB9mxojuCBhoZLcuRZX5Q4qCRliVniuO2XIeNWzdQbbpbsnrjcJtrayI59c5Ec67eBtDA2MSsOpjJOLPMSmhN0a4h7oN32SwSue54mDGuKlqwVr2pgQDzzv9rvkfRhZdlX3lEwRsXh2ExO/Ai4J1UnMaui9R5zSF1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751997306; c=relaxed/simple;
	bh=cLFQjQ+2QzSGtPJ2zGg8n2fYbRYVv29PKyHsR/hEAcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hsTTDvaeWJ0W2+d6C5ZKR60mxfoHCm7AaTmcNv+7v+4M3+StzSbYVssVEhA7ucn8bq+U1mc2P8YshMyIsKeuLS60Mdq6mELoSczZ2WQ3txHngQN0OiJD94cvtIfLYM5yVydwtUHKeeYzBTBAScnQGcjsYS7uApHRh+fyDg98sYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ydTgpOI9; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3e058c64a76so27879655ab.0
        for <io-uring@vger.kernel.org>; Tue, 08 Jul 2025 10:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751997303; x=1752602103; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bwxMlL4dHHFJuRC39FVTEsPVCjpDZYOEVrLBDVPIfE4=;
        b=ydTgpOI9NbvBcsNLxZnWszROA3TfS2qgwjScf98vANI151BzaVCpzN6gOb0rtYeu/T
         36rN8M6MP3cFBUU7bqquiFVWxc1Hh5S0qCw6FE/dVgxmuAPe9FmOKyn5VIyXe1JZzzUT
         vCHX9qxHh1z4TV29bnb8uNbpwHpHIbzw+7HRXz5eLLnJmSrwvKhOaUuZ45W9enEYe54c
         ocegYA8TSq2GHZ9RMaCOKciLeSCOBQEqBRdM3jlN8+hE+2/KbMq4zvp5fuK97XH+ieTq
         W04QH9bQBbb4dRQ5itpmXhs0WjdssUgHYSUX+7k7yWWQi7FrBPaC1beWDe80PV/2YtE3
         SFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751997303; x=1752602103;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bwxMlL4dHHFJuRC39FVTEsPVCjpDZYOEVrLBDVPIfE4=;
        b=OzJMz99pUyt0igoYIRKUaOCRyYJSsc9lwsRBMbr9UHSUBKYaqd0uh35LYVFQWMBuUS
         vg5JMfm6evkEpI3H3v/9fvmPWUVokmKXvxKRZZ6urT9hfJ8oZmgpLbeyhh+CmTv/Zw2u
         eVaMkkXwahoTuZe8/rbk9gZ+ocVC1xfn3kKfkqncUwk7ftUJbPrD/mIQbLKQ5jBs3dVJ
         Lqw6zTNJnlcDJNu07/iwiyri2lNEnxbHHl502X7WVlnu/f4AvWYhNGM1WxaE1AnFxZAv
         uYJZU5bTw047HLjc1CDaXhTzoIFtL+T6lwaivjjy/R87kLlNily55Z2FuvLZCPGZDiuO
         X0XA==
X-Forwarded-Encrypted: i=1; AJvYcCWArayxXaljDSrzRJYilyOzBADI7mMvCecGxOa4KtGfEuGDlmQiRuCmrltZFREROzcII5YTdoZJIg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzaySwde9bg7ruxQCiBG19POJzOT1EwbsSJz0cVw0rybIu3c+Gz
	B/JqOYvARCId3p9xbMTK4rwciHAEi3d8IQtv4YMn5Dv9wJsEAb/SlBIxkGWWHoeEXm8=
X-Gm-Gg: ASbGncuZKelYsosof2kiWTr1a1dLhuu8845LC2pvl23a/WydXcBimqRk9WDf4VaUePI
	WoITEcih38GtEcBhkr9bs4qz/BsJN8yG7t4DbMZ/72gB60yjeTIQ6hdcvrY9p78LqDeBAnpMa5F
	bNF9i+stIUb1wCpyWOIS9rdJZ3i5TiJnooMO9naf9pdJo/NDd2pQAT3pVJO3HeexZLs4TjZn3OX
	+uPuwLOVB5cVVwf0f3QbJiAFsjW56ywmKmNJWarmJ/21ryFIB5ah0HDPypb4ZdWoW5FBKdAgV5F
	FFc1s9TSUTM0zqEDzKHHF16RKSA/kmWlBhUi3MBlSkwYi+L1XyWDd2FbvA==
X-Google-Smtp-Source: AGHT+IEVX5R/Jkjvrqnwst9T+hPdAyhKlT1UFTOIZap7WHIKyOILujwesnTTfOqDjvcV0lz7WC8rRQ==
X-Received: by 2002:a05:6e02:2303:b0:3de:25cb:42c2 with SMTP id e9e14a558f8ab-3e137205693mr169397805ab.18.1751997302992;
        Tue, 08 Jul 2025 10:55:02 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-503b5c0fc49sm2242752173.104.2025.07.08.10.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 10:55:02 -0700 (PDT)
Message-ID: <caba8144-4e27-4eaa-9819-8601d66988a5@kernel.dk>
Date: Tue, 8 Jul 2025 11:55:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH v5 0/5] io_uring cmd for tx timestamps
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing
 <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <175069088204.49729.7974627770604664371.b4-ty@kernel.dk>
 <a3e2d283-37cd-4c96-ab0b-dfd1c50aae61@kernel.dk>
 <cf277ccc-5228-41dc-abd5-d486244682dd@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cf277ccc-5228-41dc-abd5-d486244682dd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/28/25 12:10 AM, Pavel Begunkov wrote:
> On 6/27/25 18:07, Jens Axboe wrote:
>> On 6/23/25 9:01 AM, Jens Axboe wrote:
>>>
>>> On Mon, 16 Jun 2025 10:46:24 +0100, Pavel Begunkov wrote:
>>>> Vadim Fedorenko suggested to add an alternative API for receiving
>>>> tx timestamps through io_uring. The series introduces io_uring socket
>>>> cmd for fetching tx timestamps, which is a polled multishot request,
>>>> i.e. internally polling the socket for POLLERR and posts timestamps
>>>> when they're arrives. For the API description see Patch 5.
>>>>
>>>> It reuses existing timestamp infra and takes them from the socket's
>>>> error queue. For networking people the important parts are Patch 1,
>>>> and io_uring_cmd_timestamp() from Patch 5 walking the error queue.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>>
>>> [2/5] io_uring/poll: introduce io_arm_apoll()
>>>        commit: 162151889267089bb920609830c35f9272087c3f
>>> [3/5] io_uring/cmd: allow multishot polled commands
>>>        commit: b95575495948a81ac9b0110aa721ea061dd850d9
>>> [4/5] io_uring: add mshot helper for posting CQE32
>>>        commit: ac479eac22e81c0ff56c6bdb93fad787015149cc
>>> [5/5] io_uring/netcmd: add tx timestamping cmd support
>>>        commit: 9e4ed359b8efad0e8ad4510d8ad22bf0b060526a
>>
>> Pavel, can you send in the liburing PR for these, please?
> 
> It needs a minor clean up, I'll send it by Monday

Gentle reminder on this. No rush, just want to make sure it isn't
forgotten.

-- 
Jens Axboe


