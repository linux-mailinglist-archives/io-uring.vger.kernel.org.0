Return-Path: <io-uring+bounces-6837-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1EAA4824D
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 16:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FEBC1891C15
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 14:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B944325DB16;
	Thu, 27 Feb 2025 14:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B3hfEzj2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159FD25CC7B;
	Thu, 27 Feb 2025 14:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740668001; cv=none; b=XFq2774RxCPlYI/CtNRkb1coSnJI6RkJwcCzWibUUXHXcxpBxf96ntshVgNQRFu29RUiNOd8jrJgNPB0xLbKPZVQofK8XYsnlRHenbBKiwOS8btMjQmVVl/IJBDc3vbQ45a2h4Kwgtbaa3oeSooqC+pXyqmN0BHJU4RucCZAC8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740668001; c=relaxed/simple;
	bh=q2GwVWz1/9PKFbqsPfnaphn+KW1rK4B8wqH9lN+LYOg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=BsqfEljdgVfv6PmWLpUMV9NDAZjDZcKlRLS+sTyAiXN3fjsqjkXHKUXuLFJztg5bdZL3poob0e7X2vF3OtQfXGJzuY/f74S4YEZPUHQbUzw4ePRR2JBDhpNBcwBtMQlYq6RM/GoRkur+gGq7UCRH/3ZvSr20zute2SPYwUBLHxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B3hfEzj2; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ab7430e27b2so166531366b.3;
        Thu, 27 Feb 2025 06:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740667998; x=1741272798; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=btvFNagWkKH+cMrctRR0r6pBNr9QjhwzZ0RP7CAU4ao=;
        b=B3hfEzj2l6G3+7dgEspuM0Fz1Pc9R9NoXuFkSpgnUVBDjRI6hWrVqtzzAiW6dfXKWC
         Uz5c0TrTK7GqCzGM7RKUemhrGjaNqABjurWgD3vzitGzNZAOqpACQEFrRp7evpQU1FJu
         0F6VWhUZmBYv6zjhQs/QXKNR6sa+uZ8a1O9d8j0JzpWNulU8qYdZHKAoAY688Ac8g2h7
         qY/zI+UDIECSTMF3aDqXEyXlo2Nobr+/osPqbkQ49U4wLLcKzxlJLdsdFuS5Gn4TsCeb
         j/vPmZouwHpnrK+PUA2Mj3EZ9u8dO8BgCfq3RDmJ/lRgYtoAjiP0JkUr8ciRWkir+lVG
         MVEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740667998; x=1741272798;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=btvFNagWkKH+cMrctRR0r6pBNr9QjhwzZ0RP7CAU4ao=;
        b=Zvaj5j3vvpj1qhRAl9o2G9cXCEQADK6ETPWsm8X75TvEPWvjFM3AnTFSpvbkISDr4r
         Aq7QEqJk3fCgrfHHxAnzCw1XGMSkPyj27GS6KBCPLx9yHUHBe3CAi9cJCOF/9YaozhYN
         lCrMZmtMXFGS8VzcZ2/AzcSrX9bzm8+pMBmJzQTJyj+iffqkGveSpOOCs12/yg/tJZRj
         ewjgel+WfpzeGllLuNeAhy0g1yY2siL/TN6bSFPiPQ2TEpPbxjs2ARc9A5ctuoaOwgzX
         YRj/xpDgygjkdTOP9UujkyNaFE0ugmVe2leBaxrixb7zBlOsGeEFXUbnXLSWPLCb1Sp0
         J19g==
X-Forwarded-Encrypted: i=1; AJvYcCUwluOYb1IK//VA3Oeuja/WxIIKb3Wes6Sdy+zCMMXk0u5JYuFRLeHM1h3qxmUkO9jP81dC0w2ovA==@vger.kernel.org, AJvYcCXpCTshoMObynd9NCArYDpOWhh/4mpn2eR1aGmh+VVo0mqd3r/vauXDaz+KfwUYTgebOYVZO70Wy/8CViEA@vger.kernel.org
X-Gm-Message-State: AOJu0YzFIjwhcy77JaSefMz4Ka9aDQ0RQ9ZsxT9LHLXaueD4k+2MtqKy
	Fn2bv2xbmJ4tX9fH/Htv5SF2PJExRLBlDWj+yJWs4YT4qZNWY64/
X-Gm-Gg: ASbGncsvhdpT+T4qPBgtHW/LJus2QZXLPD3/TLHotgLEWZVxJN3Tzvl23Sq/pa/RjgA
	rIT/Vmoal8kjpL6Rni0potuc9qEI4z12+trPQe+fGU1MOwz+gC5zWaNd3b6AYu3ZdJlRWxZy+Fz
	R1WphZ+KEe8vcoIsXOqupkGk/HbOb8RXxoWurg2FY+lbYNpZwxeUFUfDjv1eXVZQyQeH4sLo8IL
	8zbEQon8N3DwSUvS01VNP/AgaqqvOGQGnDgyTFhwroyYjlo0vz9IZp9tgtBkUOiD/AjoM4cdOBk
	UG9BG4pLEgg59U7ues/pzL4EOvQY1yfwkfvhosaepoV5ZI+EHrN+e7upmsw=
X-Google-Smtp-Source: AGHT+IGn2fQD/9JMxb/2MtYLyJoSzNKDGBGxmXzWMWKWGR6SXcgpDtXhBLIo9EQkQaZSTh0DKetUoA==
X-Received: by 2002:a17:907:9619:b0:abe:ebe2:6747 with SMTP id a640c23a62f3a-abeebe26b4amr1107777966b.9.1740667998056;
        Thu, 27 Feb 2025 06:53:18 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:4215])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf1d1a84b7sm57963466b.19.2025.02.27.06.53.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2025 06:53:17 -0800 (PST)
Message-ID: <1e84c070-ab32-4617-bd6a-352f2a744004@gmail.com>
Date: Thu, 27 Feb 2025 14:54:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: fix build warning for !CONFIG_COMPAT
From: Pavel Begunkov <asml.silence@gmail.com>
To: Arnd Bergmann <arnd@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Arnd Bergmann <arnd@arndb.de>, Gabriel Krisman Bertazi <krisman@suse.de>,
 David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250227132018.1111094-1-arnd@kernel.org>
 <275033e5-d3fe-400a-9e53-de1286adb107@gmail.com>
Content-Language: en-US
In-Reply-To: <275033e5-d3fe-400a-9e53-de1286adb107@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/27/25 13:49, Pavel Begunkov wrote:
> On 2/27/25 13:20, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> A code rework resulted in an uninitialized return code when COMPAT
>> mode is disabled:
> 
> As mentioned in the lkp report, it should be a false positive.
> 
>>
>> io_uring/net.c:722:6: error: variable 'ret' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>>    722 |         if (io_is_compat(req->ctx)) {
>>        |             ^~~~~~~~~~~~~~~~~~~~~~
>> io_uring/net.c:736:15: note: uninitialized use occurs here
>>    736 |         if (unlikely(ret))
>>        |                      ^~~
>>
>> Since io_is_compat() turns into a compile-time 'false', the #ifdef
>> here is completely unnecessary, and removing it avoids the warning.
> 
> I don't think __get_compat_msghdr() and other helpers are
> compiled for !COMPAT. I'd just silence it like:

I guess we're relying on dead code elimination to prevent
linking against them, if that's a normal practise and we
do mandate compilers to do that, then it looks fine to me

> 
> if (io_is_compat(req->ctx)) {
>      ret = -EFAULT;
> #ifdef CONFIG_COMPAT
>      ...
> #endif CONFIG_COMPAT
> }
> 
> Let's see if Jens wants to fix it up in the tree.
> 

-- 
Pavel Begunkov


