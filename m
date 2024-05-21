Return-Path: <io-uring+bounces-1941-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98AF08CB378
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 20:25:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F1B6281768
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 18:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B1B26CDD8;
	Tue, 21 May 2024 18:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="k3C/UcKd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9E421105
	for <io-uring@vger.kernel.org>; Tue, 21 May 2024 18:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716315940; cv=none; b=trCCVP0FS0+H7LCgzSeiPCxJvoT031wFXrOkVReB/MutElClLnUmJ59n448iPbiUFnYXfCR0SvCS3v4B2xZ69sEhXVpvgR/BQ2uoT1KxbGj8ngQ5LT3FCw3EIsEUQS0XFGY+TmyqUv+GdNVhdGxhp8Rz20DIsIc6JrPf9iSkB9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716315940; c=relaxed/simple;
	bh=NhaWXpSBe1wT/Z/z09f/JJVwqA8kjtVKPOHatr3cs1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EzgQM9ygzWsbBC258bZACqXuK1YqFczBct+c6XmP1OEJiHDdeJH0vgcQisx8PsAohHVIL07/g3H5JbPemZm2XVB4GrdNE3mGDMpwteFAdINkXSurRIv1ZxNq7FsIVXH00XK7jCIPW4QLPYjjrIvWqu0fstEsSOCEp+UXLbLoxbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=k3C/UcKd; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7e22af6fed5so20025039f.2
        for <io-uring@vger.kernel.org>; Tue, 21 May 2024 11:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716315935; x=1716920735; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S2wBSrU4Av1sT0fUiHB+Pz7Z7sfe/pMBb5+lPgVV2vI=;
        b=k3C/UcKdCUbBsJFNp/68Z43+xMPjgl1amzBLafDGFqUQcttzqG1qslBqAErxxPQUuK
         wlMe7aSZZ4pOf73MkMy+4golSsWgdhKY4OoHOJDEwrgzfmeswtiHs+jP9Rm0F0eoaodk
         KJbnd0zCkWypCu6h2C29H1Vp7L44ekvbf0zE+9sg1r0QvYi2F+X2uxL+U8iKRuAyLejP
         2ctSKns64rUlH0M9FbBsQ1jNAQLTkGhIt62mdIc4FpiEucj83glur94LsUtkfNFMqwlR
         U8Y9CwM2NDPt96qnKBGN0F7wAybjtIhhtpUqS1rlw+MlCEVI4UwDhTsd3NQPoIYdgc5t
         kl/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716315935; x=1716920735;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S2wBSrU4Av1sT0fUiHB+Pz7Z7sfe/pMBb5+lPgVV2vI=;
        b=uUszOpF2D+HH8BYJk/AlyYWi58m/P+DJPz5uS71GU6t30gmC9TqssD+GvdYf3Pn0eI
         07oUNpD4YhCYBGxTXPUW1KWQqVQuqlaCY9bFjMRcmY1nGPnhy9AOyXWgx57lMURA1VGc
         2bgDh6ovmROpj1y7lYMtjbE7czfKwB5vbL3cieJiltaUsXA+nXnT7DyLCXwIXIv//WSz
         ebT/sM0eO9Lhewnv+9uNOTlnytSHhgcP6UsQBOlR7lEgUOYbpXg2COHh/fjB+R5PgJrs
         ccqlFtq9zAFU0QalUceiFBwSlK34HsbhguFqd7S7bFkJ8q+QJSjvuWh++EUtSPxj4VM0
         NzTg==
X-Forwarded-Encrypted: i=1; AJvYcCVSjGs9UbuIpryYZQLKe9gyPRJ0wr9vXoS4ksvXtHMXhp7G72IAJipnAgyfvJJvJs85b1FTRDfvHerOAudXcbzfZueP8B86riI=
X-Gm-Message-State: AOJu0YydDndO2cSVfiAg6xBOi//Nb/NteLWZQBJzkOZkAqT8mQ6iNjzE
	DnvX348cvZksO4Ny7r7+uE/An8dk1Gohgj6pAxnaLUdSoGLEBtFDg+fWl3Id/5iq1h/5zAF8Pxw
	9
X-Google-Smtp-Source: AGHT+IFu19Ey9ORpInGJl6USoH3L909JnIOR/a6yUx0irocjkzqcTQjjhcMD41e/+JjVV36oQK/Ttg==
X-Received: by 2002:a05:6602:256e:b0:7e1:8829:51f6 with SMTP id ca18e2360f4ac-7e1b51fc52fmr3129914139f.1.1716315935183;
        Tue, 21 May 2024 11:25:35 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e1f42c22eesm444720339f.0.2024.05.21.11.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 11:25:33 -0700 (PDT)
Message-ID: <b8018270-6e9a-4888-87fd-69620d62c4e5@kernel.dk>
Date: Tue, 21 May 2024 12:25:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ETXTBSY when running Yarn (Node) since af5d68f
To: Christian Heusel <christian@heusel.eu>
Cc: Andrew Udvare <audvare@gmail.com>, regressions@lists.linux.dev,
 io-uring <io-uring@vger.kernel.org>
References: <313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com>
 <8979ae0b-c443-4b45-8210-6394471dddd1@kernel.dk>
 <8de221f7-fe5a-4da9-899e-de2a856a4ddc@kernel.dk>
 <yywbp7fjnwgqxvc66zimea4hgdc2eysjx5nezky3vndr7xw25l@jv76rdseqm3e>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <yywbp7fjnwgqxvc66zimea4hgdc2eysjx5nezky3vndr7xw25l@jv76rdseqm3e>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/24 12:17 PM, Christian Heusel wrote:
> On 24/05/21 10:22AM, Jens Axboe wrote:
>>> On 5/21/24 10:02 AM, Andrew Udvare wrote:
>>>> #regzbot introduced: v6.8..v6.9-rc1
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=af5d68f8892f8ee8f137648b79ceb2abc153a19b
>>>>
>>>> Since the above commit present in 6.9+, Node running a Yarn installation that executes a subprocess always shows the following:
>>>>
>>>> This also appears to affect node-gyp: https://github.com/nodejs/node/issues/53051
>>>>
>>>> See also: https://bugs.gentoo.org/931942
>>>
>>> This looks like a timing alteration due to task_work being done
>>> differently, from a quick look and guess. For some reason SQPOLL is
>>> being used. I tried running it here, but it doesn't reproduce for me.
>>> Tried both current -git and 6.9 as released. I'll try on x86 as well to
>>> see if I can hit it.
>>
> 
> It seems like this also was a problem for libuv previously as somone
> noted in a comment on the Arch Linux Bugtracker[0]:
> 
> - https://github.com/libuv/libuv/commit/1752791c9ea89dbf54e2a20a9d9f899119a2d179
> - https://github.com/libuv/libuv/blob/v1.48.0/src/unix/linux.c#L834

Just got that far in my local poking, it is indeed execve() getting
ETXTBUSY. I'll see if I can make a test case for this. Presumably the
application side is fine, eg it waits on the close completion before
doing the execve, not just having it be issued. Outside of that, only
other thing I can think of is that the final close would be punted to
task_work by fput(), which means there's also a dependency on the task
having run its kernel task_work before it's fully closed.

I'll be back with more info...

-- 
Jens Axboe


