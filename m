Return-Path: <io-uring+bounces-1575-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 644CB8A6BD6
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 15:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8748C1C216C2
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 13:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E85FF12AAE7;
	Tue, 16 Apr 2024 13:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LhlaUEA1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB1D12882C;
	Tue, 16 Apr 2024 13:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713272891; cv=none; b=k26iThHT2mnyovRRNOvrUOeZJ4OR+J287Pkk2Wmd1yuh3vjBby+DVQ6na/AaJRd4rJeltglXLoYA6KWkM5z5EyuAbGC1g/jQphT3njh0Nudfil9+XeMTt844GeFasFDwvYaDHcwe8ShRGSxOSTCuTRw+ojzJTR5eVIj7oK8+t6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713272891; c=relaxed/simple;
	bh=dAj+WGxg4WBvJnXa2HzV62sBiEsyaVZZFtfu+3W2DGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HQfafj/cIHCXcYFUxRlf5d9yVwV8PFFJMDlDQUuA4PjnPLqkX/Yi9zFuzct8RBfzcBKd248bIcEMbU8TLVoTBFjJYUlrL/qWjpE6oLacUOnP43GA7FRoKLGTpRIbRM0bmu4xPjuh825BEn6cuqWKxo6mG8+JWbqVeEdEqWiU8ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LhlaUEA1; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-57009454c83so3736512a12.2;
        Tue, 16 Apr 2024 06:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713272888; x=1713877688; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WVjGqOpJq8m97dpitFrYVDyjjiMTVQ9pnya32L/MyQA=;
        b=LhlaUEA1N+ImrN5lb8Qe8p8ufHMjDk3U2I8x/A0qBUnd3BRFJJIEl4Xhi+4W67WUAm
         EcSQGnjfHEFaRMqMwo12+szzKwhs6sSs7xMBhtvq3ffV7CvPhS33ywtcfA4KK0nUIKjN
         4RGv9C/ALfg/hVDkYjL0dT5dLGSLJ8n0WxvqJTpoODssCJiWt85VFR07xHq4K5uPrwvD
         vyxKydiM39WZofAFcIrdaVrM1/U+SAnwo/Kk8qyZTXPbYq4oqogRycZHxe1nGzm0XGSs
         bS/9UZ3gxlSGAk/4rjvY/GPAiU5sf0PEEbecsJH5g+9+PGQNvfuAAoyyJZUKc30uNQKX
         n9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713272888; x=1713877688;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WVjGqOpJq8m97dpitFrYVDyjjiMTVQ9pnya32L/MyQA=;
        b=pRjwwdr5Nkuzf5gFFEO9I6CirfeRFnslP0Zy8bLi+ZgxwB6BJGA1VNOYDhqjtIyVrK
         YjzhLvHZdTMIpdk/QX0jm2ipdDmhbW2ag7jlfeKdWHIG52TZc0pBiv2Ycfw90otZXKTC
         vdS66uIYJLusW55rSLklFL6bCP470eNBd/+qJSOYVtxhwWd8O/f5UNClkciyXL6d+I9W
         Hx2ffx1LLZrR/u382NMan6QKeddjDABOn6qYcTVegO/hLMwDeR1QFkYc2LFXCcLr+5IK
         hniD8I91Pg3ATrlI3HgvFurzx7VTBGG0EfWgWN7ytgZH5BRNbASt7+9h7fWU0uqUcQAF
         mdoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJS4lbXmLJ4OT6LE7lL1f4FGoiwvjKvExd6hnPjbxgpmjwcvkGC6kEJlvoAxe6DDAMyKKxV4RdHDl0IFRZTUp4ikQ8Tdnse1g=
X-Gm-Message-State: AOJu0Yzs+Z8E/UljpwiN8zYzq7TcMEa7QT3wBvE7KuH+fZORAw+2YhEo
	ohe0rUWpMGxBereZ+pV7KmSHdzn0bOuMfl1hWxGDaJEw2mraMkdu
X-Google-Smtp-Source: AGHT+IGDIvvCNKSunhmGg61vdqBI9LV6QgomxHAGu9bxYEA2tF1KHhyxEvyTYbh+WHtnBaYyfxYEJA==
X-Received: by 2002:a50:955d:0:b0:570:8f8:bc3a with SMTP id v29-20020a50955d000000b0057008f8bc3amr6743054eda.4.1713272888274;
        Tue, 16 Apr 2024 06:08:08 -0700 (PDT)
Received: from [192.168.42.125] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id n13-20020a05640206cd00b005704ae9272dsm196787edy.93.2024.04.16.06.08.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 06:08:07 -0700 (PDT)
Message-ID: <cf7d7976-4285-4d6f-85c6-d8e83051cf35@gmail.com>
Date: Tue, 16 Apr 2024 14:08:15 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] WARNING: CPU: 5 PID: 679 at io_uring/io_uring.c:2835
 io_ring_exit_work+0x2b6/0x2e0
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
 Changhui Zhong <czhong@redhat.com>
Cc: Linux Block Devices <linux-block@vger.kernel.org>,
 io-uring <io-uring@vger.kernel.org>
References: <CAGVVp+WzC1yKiLHf8z0PnNWutse7BgY9HuwgQwwsvT4UYbUZXQ@mail.gmail.com>
 <06b1c052-cbd4-4b8c-bc58-175fe6d41d72@kernel.dk> <Zh3TjqD1763LzXUj@fedora>
 <CAGVVp+X81FhOHH0E3BwcsVBYsAAOoAPXpTX5D_BbRH4jqjeTJg@mail.gmail.com>
 <Zh5MSQVk54tN7Xx4@fedora> <28cc0bbb-fa85-48f1-9c8a-38d7ecf6c67e@kernel.dk>
 <d56d21d5-f8c2-435e-84ca-946927a32197@gmail.com>
 <34d7e331-e258-4dda-a21b-5327664d0d04@kernel.dk>
 <2836d7dc-4afd-49d8-8405-d888f2b3fc95@gmail.com>
 <9218e15d-d30f-470f-a09d-b88237bb02c3@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9218e15d-d30f-470f-a09d-b88237bb02c3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/24 13:51, Jens Axboe wrote:
> On 4/16/24 6:40 AM, Pavel Begunkov wrote:
>> On 4/16/24 13:24, Jens Axboe wrote:
>>> On 4/16/24 6:14 AM, Pavel Begunkov wrote:
>>>> On 4/16/24 12:38, Jens Axboe wrote:
>>>>> On 4/16/24 4:00 AM, Ming Lei wrote:
>>>>>> On Tue, Apr 16, 2024 at 10:26:16AM +0800, Changhui Zhong wrote:
>>>>>>>>>
>>>>>>>>> I can't reproduce this here, fwiw. Ming, something you've seen?
>>>>>>>>
>>>>>>>> I just test against the latest for-next/block(-rc4 based), and still can't
>>>>>>>> reproduce it. There was such RH internal report before, and maybe not
>>>>>>>> ublk related.
>>>>>>>>
>>>>>>>> Changhui, if the issue can be reproduced in your machine, care to share
>>>>>>>> your machine for me to investigate a bit?
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Ming
>>>>>>>>
>>>>>>>
>>>>>>> I still can reproduce this issue on my machine?
>>>>>>> and I shared machine to Ming?he can do more investigation for this issue?
>>>>>>>
>>>>>>> [ 1244.207092] running generic/006
>>>>>>> [ 1246.456896] blk_print_req_error: 77 callbacks suppressed
>>>>>>> [ 1246.456907] I/O error, dev ublkb1, sector 2395864 op 0x1:(WRITE)
>>>>>>> flags 0x8800 phys_seg 1 prio class 0
>>>>>>
>>>>>> The failure is actually triggered in recovering qcow2 target in generic/005,
>>>>>> since ublkb0 isn't removed successfully in generic/005.
>>>>>>
>>>>>> git-bisect shows that the 1st bad commit is cca6571381a0 ("io_uring/rw:
>>>>>> cleanup retry path").
>>>>>>
>>>>>> And not see any issue in uring command side, so the trouble seems
>>>>>> in normal io_uring rw side over XFS file, and not related with block
>>>>>> device.
>>>>>
>>>>> Indeed, I can reproduce it on XFS as well. I'll take a look.
>>>>
>>>> Looking at this patch, that io_rw_should_reissue() path is for when
>>>> we failed via the kiocb callback but came there off of the submission
>>>> path, so when we unwind back it finds the flag, preps and resubmits
>>>> the req. If it's not the case but we still return "true", it'd leaks
>>>> the request, which would explains why exit_work gets stuck.
>>>
>>> Yep, this is what happens. I have a test patch that just punts any
>>> reissue to task_work, it'll insert to iowq from there. Before we would
>>> fail it, even though we didn't have to, but that check was killed and
>>> then it just lingers for this case and it's lost.
>>
>> Sounds good, but let me note that while unwinding, block/fs/etc
>> could try to revert the iter, so it might not be safe to initiate
>> async IO from the callback as is
> 
> Good point, we may just want to do the iov iter revert before sending it
> to io-wq for retry. Seems prudent, and can't hurt.

To be more precise, the case I worry about is like this:

{fs,block}_read_iter()          |
-> iter_truncate();             |
-> kiocb->callback();           |
--> restore iter                |
--> queue async IO              |
                                 | start IO async()
                                 | -> or restore iter here
                                 | -> iter_truncate() / etc.
-> iter_reexpand() // unwind    |

At the iter_reexpand(), it's already re-initialised, and
re-expanding it would likely corrupt it.

-- 
Pavel Begunkov

