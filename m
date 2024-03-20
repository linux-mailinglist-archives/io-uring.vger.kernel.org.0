Return-Path: <io-uring+bounces-1161-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8EA88137E
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 15:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF3971C217B8
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 14:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AC947A63;
	Wed, 20 Mar 2024 14:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HaGsRuTy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC2F40BEF
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 14:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710945672; cv=none; b=qfA4AV/XrhEYuQ63ZKw3hDKlZhsTnhPJ0a7KW/rVD4jJ6nW9XJa9isTuSH/+/EGf80Y2GTk1bQXqJujpm1IR0+Qd/DYwG+jyv5KU53tdKR+pHSCOXvmVvrAf8vJpyIAf8rk+QFq5iKpxhb786+SstlGZIlDCiJjuYUUYm6P0BaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710945672; c=relaxed/simple;
	bh=9/iT+Kh12tczix5MivN5zWvmdvs6z7jtGvkmRFeaKZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kAv+tWM+3cJZZdRq0qRj50fAMasn0uzn9OCzEt5jFDz5w3Oqr3iLas+tI+35gY+R71X8CKsr3924HeQyLOkACSUuKoar7ut3I8reBgO00yxKXhCFRWDTP9QryL2Zn3k3//c50zf5AhvPPg89QdbFgaqTVAZVjJ/OGdVbjmWnnCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HaGsRuTy; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7cc5e664d52so31525839f.0
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 07:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710945667; x=1711550467; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H/6rY/awT69nq274sdrgOZc9inrvQObVNrWmY/hxh04=;
        b=HaGsRuTyGcRHehnB6KfyQyVXdDcSC+Zn7ZZVwdtqu3ngSC3oZRCElc1c1kiVFBqfpU
         f6ZcCwPHdmaiw8j83hz4YoVPG1HTgMxhnASt4Pem4svP48Hy3dFLMyEnjB87Vu8QOv9g
         eBMP7XNKpxQvsL55vxi0rrsd0wYmofDWu+D0W4rAeZdXGtFyebqcDTjBe1j1+4onVVF2
         igedTmt11JXrlpNN4ILApr/PU+QJzZ5V8SRjHB7Ct1ksOcO65C9EjmIil/KinLgzDeR4
         oTVd0dFhbkHB2qEQnoKpHF4cO0TgXg9AygU5bWawRCGbbClieVgVI/aXiwF5IjlodAo1
         TJPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710945667; x=1711550467;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H/6rY/awT69nq274sdrgOZc9inrvQObVNrWmY/hxh04=;
        b=BRLJ6uW4bawWSJfpueDchQ84Xgh/2Qmfw/LeOQBVkeRhTbeWi9qiapM6rdbTAxNLW7
         lXn46BNKc3QJ9xeN3vHDc3F7GCxR0vj1YpjjVmXIQU5sKbOMD93OHeEjzbf4eX3tFN/x
         KxIvW3UP0Y5UgnZBx3t4ZF/meGUMbuJdWogDGNOhCGbFRpP7eHQRiTuqYbF4wY6eZAmy
         6H4O7gRrEfsjIe/SdflaYLu7f/xu+EVvXqZCvPuIh1DqSlc4+SWp3QuEb3IksdfgXSlP
         /lZsaFJKbZOtmDbgDo9/cdnHBzbSHr12iUwfUWHqPeZUhfTJbcdCwL9N/uuzaqRbBk8+
         8vSQ==
X-Gm-Message-State: AOJu0Yw4yrNhxRGP/NeZG58bMJ28GK54fvaBx+6p5ri2sIcWJ+B5H5y1
	+kKClaK3ek1FZ2g6YhvxCTLC4Cz77gDldAL7H1MQVBOe+pfRjkaUTIYfzgqAb5YuJVcH13+MBMf
	L
X-Google-Smtp-Source: AGHT+IFpgj77h4tUxRSuCa456lijZHEDFWAe9mNbfN2sebZtQLJ0YtuUrpOt0O3IycGG/ywriTiA+g==
X-Received: by 2002:a6b:5108:0:b0:7ce:f407:1edf with SMTP id f8-20020a6b5108000000b007cef4071edfmr5433659iob.0.1710945667259;
        Wed, 20 Mar 2024 07:41:07 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id fo3-20020a056638648300b004748175344bsm3526674jab.167.2024.03.20.07.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 07:41:05 -0700 (PDT)
Message-ID: <df071f2d-0dd1-4874-9ad7-d79389dd3084@kernel.dk>
Date: Wed, 20 Mar 2024 08:41:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: drop unused 'fast_iov_one' entry
Content-Language: en-US
To: Dylan Yudaken <dyudaken@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <7366e668-7083-4924-af43-5d5ba66fb76a@kernel.dk>
 <CAO_YeohJmpk=5463u3APYjqfoDB75m6rDZtQ10SPaL7TLG_D8Q@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAO_YeohJmpk=5463u3APYjqfoDB75m6rDZtQ10SPaL7TLG_D8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/20/24 7:59 AM, Dylan Yudaken wrote:
> On Tue, Mar 19, 2024 at 11:37?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Doesn't really matter at this point, as the fast_iov entries dominate
>> the size of io_async_msghdr. But that may not always be the case, so
>> drop this unused member. It turns out it got added in a previous commit,
>> but never actually used for anything.
>>
>> Fixes: 9bb66906f23e ("io_uring: support multishot in recvmsg")
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/io_uring/net.h b/io_uring/net.h
>> index 191009979bcb..9d7962f65f26 100644
>> --- a/io_uring/net.h
>> +++ b/io_uring/net.h
>> @@ -10,7 +10,6 @@ struct io_async_msghdr {
>>         union {
>>                 struct iovec            fast_iov[UIO_FASTIOV];
>>                 struct {
>> -                       struct iovec    fast_iov_one;
>>                         __kernel_size_t controllen;
>>                         int             namelen;
>>                         __kernel_size_t payloadlen;
>>
> 
> I "believe" this is used in the async paths, where fast_iov[0] gets
> used (since multishot always has exactly one iovec) and so
> fast_iov_one is just a placeholder.
> I think that means it's not safe to remove until after your async patches.

Oh that's nasty, no comment about that, nor any direct use of it. Poor
shame on whoever wrote that code :-)

I'll double check.

-- 
Jens Axboe


