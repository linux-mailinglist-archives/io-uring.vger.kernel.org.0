Return-Path: <io-uring+bounces-4012-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A9979AF45C
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 23:09:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D005A28432D
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 21:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BCD521A6EA;
	Thu, 24 Oct 2024 21:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BAUYnSRh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD68218303
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 21:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729804092; cv=none; b=f4fJ3efEHf87mVLN1JxVbAOihe/ivyMw5c+Cvcg+GaHpufIamBMZwPjw5DtVgT/o32bTXYqQjE5b4EiPeyyqDrog50pKFSjDP2kGWyWRb3LSVFCqySfdJLny9ZYaGIRhNmDIjccuOq0p8KCsP42BrhKvAZa+rSzSgC5s7F3MgyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729804092; c=relaxed/simple;
	bh=ngIxGusIMitrDCXDm7dJRrkqO7n4Q2RugQjsu+jEiJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tqDTKM1Wbk3IaHz2Z60L9vens1kSFioXnLeIcky8zBqxmzR0qMTmg9tlb2rkpunQ5EpDt4bFnDaxyDK4FX+DvJJuJCrADqfoM5xUtIBXZUq/Yd5GGRjrm2wURDNDF2hxWmjhkSwYjmDFDeNIBjw+P1PZSOB1giADVGJekmPqJSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BAUYnSRh; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2e34a089cd3so1082532a91.3
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 14:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729804085; x=1730408885; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/LSHFrGPaqiYBaNTJtCN27Ah/ZZg5gnYQx/q+x5R0gc=;
        b=BAUYnSRhIz+2wmH1rGheq9qJrXAXfOXPzBq6VLos2nYW6zpjSCxAvgIb1L5azAf0w0
         agIEySTSraXSza6Uuz2d5sUmPnPEixxCMspMXAAuvKriIC99sQWIb3MmHwXXDyTh5DkE
         HhKlmCqUv0w595oFKjYXc8QoAoJEzx5ye1mS927+fuAwPbccNEufDGO6/MBli1yUCAl8
         PwdEp580hF6UiH0O6LTPD8iVuGfxdvu1Ip74WrOFrcnMP+OrTSedJ8TTFQCyffCOyMMY
         genMrsrOTfnjlHggi+qv/Zk9i8iAM/SFTP7pi76bfzRqfY9lL70l5trWF5+gYy1XtvxG
         Otgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729804085; x=1730408885;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/LSHFrGPaqiYBaNTJtCN27Ah/ZZg5gnYQx/q+x5R0gc=;
        b=i9FX3f9t1/o7JDDi+Dob0oerinRs/HAW/F5IlULIRC4bZL0aIoDHh1G3NPKyiE+Jhw
         +KbreJZFSQyqNgOmeCht2OP7mxMXqI9/EeSxvk1npfXKjEBrd7Tc1TSCMGvhsU/00Mb3
         XIPUMUHld008c3DVbEnb38HHF4c3Ef3EB3kunZOYM6hsSJS6nQmZLsn5NXfw2pDsBG7m
         D6h3DBxGkH1htTgbxEKsMeNy9yMZVF6+AuhSkMNtuB9LQPIZ2mqVf5KmXuwiQv+2dR8o
         V4cDrysNzVFJA8HA0A7TEBNC00fDxYbHZSKEITXF3XWc0J5wxQvinsxwyvZpvluSrFcR
         M6Sg==
X-Gm-Message-State: AOJu0YxlAK5bX47rq8Be6UQax2+EYNSiRGa6rYXQo7e8Kd3jFQ/4paIA
	9TwlzXqMMW/88apPfXWDd2q6IeuDfZ25sGy+irWcd++OM8gL0L/mUW7YwlQaGe5Tbc02QQN2JCc
	K
X-Google-Smtp-Source: AGHT+IEFA5aOCN7fSidQ6a9nZ4beGop6off+h/MM9Ko1vs4kIi5u2au2ObBureGahCP8zJG9FuJ2dg==
X-Received: by 2002:a17:90b:3c47:b0:2e2:bd68:b8d8 with SMTP id 98e67ed59e1d1-2e77f3226cemr3746879a91.8.1729804085108;
        Thu, 24 Oct 2024 14:08:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeab58aadsm9049885a12.53.2024.10.24.14.08.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 14:08:04 -0700 (PDT)
Message-ID: <d107ca88-3dc9-4fdd-8f19-235fdfaa6529@kernel.dk>
Date: Thu, 24 Oct 2024 15:08:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/register: add IORING_REGISTER_RESIZE_RINGS
To: Jann Horn <jannh@google.com>
Cc: io-uring@vger.kernel.org
References: <20241024170829.1266002-1-axboe@kernel.dk>
 <20241024170829.1266002-5-axboe@kernel.dk>
 <CAG48ez3kqabFd3F6r8H7eRnwKg7GZj_bRu5CoNAjKgWr9k=GZw@mail.gmail.com>
 <aaa3a0f3-a4f8-4e99-8143-1f81a5e39604@kernel.dk>
 <CAG48ez3KJwLr8REE8hPebWtkAF6ybEGQtRnEXYYKKJKbbDYbSg@mail.gmail.com>
 <1384e3fe-d6e9-4d43-b992-9c389422feaa@kernel.dk>
 <CAG48ez2iUrx7SauNXL3wAHHr7ceEv8zGNcaAiv+u2T8_cDO7HA@mail.gmail.com>
 <a55927a1-fa68-474c-a55b-9def6197fc93@kernel.dk>
 <CAG48ez2MJDzx4e8r6AQJMVr9C8BC+-k1OoK8as0S7RD3vh8f6A@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez2MJDzx4e8r6AQJMVr9C8BC+-k1OoK8as0S7RD3vh8f6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 2:32 PM, Jann Horn wrote:
> On Thu, Oct 24, 2024 at 10:25?PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/24/24 2:08 PM, Jann Horn wrote:
>>> On Thu, Oct 24, 2024 at 9:59?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 10/24/24 1:53 PM, Jann Horn wrote:
>>>>> On Thu, Oct 24, 2024 at 9:50?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> On 10/24/24 12:13 PM, Jann Horn wrote:
>>>>>>> On Thu, Oct 24, 2024 at 7:08?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>> Add IORING_REGISTER_RESIZE_RINGS, which allows an application to resize
>>>>>>>> the existing rings. It takes a struct io_uring_params argument, the same
>>>>>>>> one which is used to setup the ring initially, and resizes rings
>>>>>>>> according to the sizes given.
>>>>>>> [...]
>>>>>>>> +        * We'll do the swap. Clear out existing mappings to prevent mmap
>>>>>>>> +        * from seeing them, as we'll unmap them. Any attempt to mmap existing
>>>>>>>> +        * rings beyond this point will fail. Not that it could proceed at this
>>>>>>>> +        * point anyway, as we'll hold the mmap_sem until we've done the swap.
>>>>>>>> +        * Likewise, hold the completion * lock over the duration of the actual
>>>>>>>> +        * swap.
>>>>>>>> +        */
>>>>>>>> +       mmap_write_lock(current->mm);
>>>>>>>
>>>>>>> Why does the mmap lock for current->mm suffice here? I see nothing in
>>>>>>> io_uring_mmap() that limits mmap() to tasks with the same mm_struct.
>>>>>>
>>>>>> Ehm does ->mmap() not hold ->mmap_sem already? I was under that
>>>>>> understanding. Obviously if it doesn't, then yeah this won't be enough.
>>>>>> Checked, and it does.
>>>>>>
>>>>>> Ah I see what you mean now, task with different mm. But how would that
>>>>>> come about? The io_uring fd is CLOEXEC, and it can't get passed.
>>>>>
>>>>> Yeah, that's what I meant, tasks with different mm. I think there are
>>>>> a few ways to get the io_uring fd into a different task, the ones I
>>>>> can immediately think of:
>>>>>
>>>>>  - O_CLOEXEC only applies on execve(), fork() should still inherit the fd
>>>>>  - O_CLOEXEC can be cleared via fcntl()
>>>>>  - you can use clone() to create two tasks that share FD tables
>>>>> without sharing an mm
>>>>
>>>> OK good catch, yes then it won't be enough. Might just make sense to
>>>> exclude mmap separately, then. Thanks, I'll work on that for v4!
>>>
>>> Yeah, that sounds reasonable to me.
>>
>> Something like this should do it, it's really just replacing mmap_sem
>> with a ring private lock. And since the ordering already had to deal
>> with uring_lock vs mmap_sem ABBA issues, this should slot straight in as
>> well.
> 
> Looks good to me at a glance.

Great, thanks for checking Jann. In the first place as well, appreciate
it.

FWIW, compiled and ran through the testing, looks fine so far here.

-- 
Jens Axboe

