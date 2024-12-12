Return-Path: <io-uring+bounces-5466-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B7449EEB17
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 16:21:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C95FF188E6C3
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 15:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8DA6215776;
	Thu, 12 Dec 2024 15:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TY18sCg5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B6C2210DD
	for <io-uring@vger.kernel.org>; Thu, 12 Dec 2024 15:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016568; cv=none; b=AtGbMqmTugLKdxtFNWYQ98s/RG8DvoamJwfOWPqno5Qp8E7G9iil7h+P9MjynarELcVBHYdUWcHXshpChxIpXIHvtcovL8xzzyhWhF9QNoDvaH7Vdk7Ji4fHAFCyJUqV7DTZ/9zSgoXDB0npCgZLKmj1eoIxhh7qPzjOmOpisZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016568; c=relaxed/simple;
	bh=3SSjvybpl5rXfxOCPSTDFXi+iCXVPfOvQm7DvwDpSaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=myuZaoxu75pZ7zaHpNpVeqbV1UEt+yLqLcmgow42R7kp6RtyRKGl5rREwNbQPOFOXn9vOQM/dgqiw2VchT7vGGW2lQKxvm/iyCEcqRLzd9c+e8+PRBAhjZVQhOc7XxbepGWEgoyyV1X1XCcDgDBaOOe3f8OI/Fk+nJOg6UjrFt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TY18sCg5; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-844ba46e0d7so21592739f.0
        for <io-uring@vger.kernel.org>; Thu, 12 Dec 2024 07:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734016565; x=1734621365; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z0OZ8O6Ca4r+P7Py7Stsig8qKTNV0WtAJSlUeJrA8/c=;
        b=TY18sCg54u6e+78pFkAnhW8O83T2cwdmbf/Sh2U/Kn88bf+IkKbdJSDiiq6l2qlpc2
         5CVtxz/VW3Qxv3ifAxQ4LlHvGteSpQDyH7bN/aAbfrx/SpZsDrYTK8O5mddNwaD/8wWb
         PVThGyz4OzquOFMI2BYXFw6UtvbXY666mdQl9u+zQMVtoYETHB9szNi9AIr6KnGfQSAx
         4WxakxcqZPfpuIlERDceNcgYulsTeu++FWkXka9GFZa+bhYzp/LgbSS29QFZ3cy1syFp
         oBaSgjiOjEASbWBwZXuig+hzIwuNJgRTIzO2nq9XThlDO27BBh9+AoERs1dcKoW4hYRN
         x8Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734016565; x=1734621365;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z0OZ8O6Ca4r+P7Py7Stsig8qKTNV0WtAJSlUeJrA8/c=;
        b=PwydnbjW2PrC0gkFZ89uGGLCp/I/NquafkE/DiyOkbK1zCORUpisSuK3EbtVG3Gc12
         NfncNuPr/Y4k8QbQ5Q3g3mXKagHnb4304Jm56CC3ZU5NPNc33nXlLYBaxkY+ATmFalUQ
         35Epz+sfiLov2s0gcWsdty+zV0OD/xOLQEixFqPgskeWtwfSVsFZwygZ12k/PCrJXycm
         CMw/B96a42dGwlRV6egBBvbgTU9eUuOmLm8k52tv7qaUSaCGr2X4WPAhN+tcuwvSbC18
         yFSr3YJQlNksyvFcItftM9+7FhuZAqUJzkEslc1USPuTZPWjyllkqZmor1nXEstLRjM5
         MINQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBM8whq8XxUY4vA0Ga4g+5+f+s8vYI35YzHGZvH6ONcXXzQPthJ70N7nxrchDPgOn5rHobhV7X9g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGhvDPPpWqKSvSqtHWtjyCf1Md6TIjF+kGNeB9jcMICqerZkhy
	Pktht0XbAEct6rezRwb+1KCvfNWT2zwYPk8uZz5yxq381IhsMtGuX7pfPLz/O5s=
X-Gm-Gg: ASbGncvjoAOFsTo7ELmCsgGY0bxOIXJYMloGywEW7WuzgrMDoK7DlZ+WI89/f41nkvy
	z2ENWPj4Be5eEoY8dcgGAtQwSS8vWBLjnidxkeQSoajolPXNFv1COsG7I/mAot/EeG1TLBhk6WU
	UpJb5uVNF8Vbar9p0OS7EN+VI9NBGla953c78WB3VP+qDYp7gfruEaZeQTkdf/v/JXLsbX/Ofpl
	jgoZwyUnaMc5HzOCYOSNUdnNAC4Gq+YAnzYFz3BMLuBHLuRn/Sl
X-Google-Smtp-Source: AGHT+IH6ENBokNRefW67PEWn2Ayn4uC+Tx99zWyruB6kU13IoCqTYr/RWiG2rLlrSIA+Pd1bn/rmkg==
X-Received: by 2002:a5e:cb41:0:b0:844:2ef3:a95a with SMTP id ca18e2360f4ac-844e5b6e500mr51080439f.7.1734016565359;
        Thu, 12 Dec 2024 07:16:05 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e2c56975c0sm1940230173.20.2024.12.12.07.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 07:16:04 -0800 (PST)
Message-ID: <9176cbee-17d9-4811-a90c-d001ba9a6fea@kernel.dk>
Date: Thu, 12 Dec 2024 08:16:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [io-uring] use-after-free in io_cqring_wait
To: Pavel Begunkov <asml.silence@gmail.com>, chase xd
 <sl1589472800@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CADZouDQ7TcKn8gz8_efnyAEp1JvU1ktRk8PWz-tO0FXUoh8VGQ@mail.gmail.com>
 <54192dd9-d4e6-49ba-82b4-01710d9f7925@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <54192dd9-d4e6-49ba-82b4-01710d9f7925@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/12/24 4:21 AM, Pavel Begunkov wrote:
> On 12/12/24 10:08, chase xd wrote:
>> Syzkaller hit 'KASAN: use-after-free Read in io_cqring_wait' bug.
>>
>> ==================================================================
>> BUG: KASAN: use-after-free in io_cqring_wait+0x16bc/0x1780
>> io_uring/io_uring.c:2630
>> Read of size 4 at addr ffff88807d128008 by task syz-executor994/8389
> 
> So kernel reads CQ head/tail and get a UAF. The ring was allocated
> while resizing rings and was also deleted while resizing rings, but
> those could be different resize attempts.

I suspect this report would be fixed by just doing:

return READ_ONCE(ctx->rings->cq.head) == READ_ONCE(ctx->rings->cq.tail) ? ret   : 0;

as ->rings can have changed since we entered the function. But that obviously
won't fully sort this out, let me ponder it for a bit...

> Jens, considering the lack of locking on the normal waiting path,
> while swapping rings what prevents waiters from seeing an old ring?
> I'd assume that's the problem at hand.

Yep exactly.

-- 
Jens Axboe


