Return-Path: <io-uring+bounces-5844-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17106A0BC1A
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 16:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F84C1884598
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 15:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D5CC29D19;
	Mon, 13 Jan 2025 15:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QIZvP06Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29C8240245;
	Mon, 13 Jan 2025 15:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736782405; cv=none; b=mCZJFvyoAFpuRRErecatW/mMca6IgztK3ndq/GMZdRnAYSNUF0F3WmI4Z3y+hR6B2Vgolx7jPeCuxV366uUmhgPHAAOyTAHtHqt7LntcXl3C0inAT/3yyCIlBPkKZBRvF0Gj4lQ38UJcIsc14lzQqzO74EeWEVLLogWIuU74uOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736782405; c=relaxed/simple;
	bh=yTH2Oggo0lcoM47iqJCtspvY0MbBlCLSOu4Xey5Ndf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sQnZPm8C/gLhVct6PFcRmlbGJpcrVRrhw9x0Xva9x2t+zT1GErkUeZMjkKc7YD06RYzpBLjB76TF1R2RQVpmooanISWg7OvbbDyCEVO7mkojuaIMV1TjT9WyDkMizP1blCNqhBdXZMT3YkJ8XmvBXHQ/5g7t49h1LOX7onjjtuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QIZvP06Y; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21654fdd5daso75096085ad.1;
        Mon, 13 Jan 2025 07:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736782403; x=1737387203; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CDDA2rXyQq16FfCh1gqaGctIL4mxg3rKVYqPYLPEUaY=;
        b=QIZvP06Y4EhkOpIOIOtsCiO5t9W/JvQLxNSe/hv8NYLurS9n9XZKryc2X+JsetVH3X
         ldxebm/ex1pSP/7AQU6mDSSG/4mzJL+O5LVNS+L3foBLKTn0Dn+/rxiLcOKMWEe4AyCh
         znsaXmMUsZPOKPnbYyNgZp49OLtZ2FCI+fj+LGHi2f22QzT0weXwzdNdZqe6pJ1x5dO5
         an6FQaQce6PUklrNFBK4aUwwjKgIbX5nbMy6ztu+QfAPxwOU+TKc5SJn5yvy1+Qdn9gC
         yATXCYO3b0rE0KOD3EZ+6DmCZEhwWBwOT6O+FiONK90qar6nCC8GodiQSvS95c4odQxG
         0EfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736782403; x=1737387203;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CDDA2rXyQq16FfCh1gqaGctIL4mxg3rKVYqPYLPEUaY=;
        b=oYsrYkUVT7paLURf7XGhjrfYfLcauFCAFKU4fPXAVMWjJFYX5eTxgrNwfhx9Fa0H5h
         eQJ6XDQ38LYbt7VA3qL7+c95DHHLqutvX0V2O6yHyCRWT8mHphN3cnyPKvYGECFEKRyx
         P+zUL8NCN76dJ3SV7MwYwp37l42dyFO3I2kbXO89z0k7nvfXWXOeHQOQemfhEUBdlohX
         etpMJBIdRwEabPNfrmyP3LyNKA7MLGtne2SoXCuUOJgd4cZiG2NujLHZMYUjuWg2yfSr
         df8z2G9VbXi5gskux8l/zgEi4WJIRwQZbUwSjwtL2r3xg260MQzEbc0xydZLUWSqBntA
         4ZOw==
X-Forwarded-Encrypted: i=1; AJvYcCUE2gE3m992OUHXe0Qgc34Vv3qbesRDc8Buu4xzsuKqWoS2HppgOESvwJe7LEKu7MRI5AHtmbmkRKXQ10cn@vger.kernel.org, AJvYcCWPsjdNX63qT/OwhTRt9yoYa68XeI3QTqsVJV7ulTKBV5TYSnIyTpxt9+03n3n2a0cr4nepFzIXjQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5Sw+gUllOdepbf3TmcbrQxFiujyyKTNjSD7ytcAdXkh428F2C
	T9forPIbo15ToLODg5pUMm7CaGQSHir5ARJg72Pzv6/4hRqPW9sX
X-Gm-Gg: ASbGncvzsShC/4+hNEbWiiQVLmg+iTgERqqFWJfLIc6Q00L6ORMfdB67hCAa/sL9CCd
	YX/PJpaJCUqH7o3SpzDptjYyR1ZNvrb0T0Gp0VWe/5Nk2EH4nlxYtVj5Kr+I2owGQZvgf5i3clm
	K88DdQ3rdH4rBN0Gel3ln3gLhW4Sppd0229FHfoolrOkhtVsKf/bg921vZ5mxkQAb0YDACY50X5
	nMBrA2khXZCL2GfKRjH0Oy2i5OmBkXwf94WMM5UZt2WIptdSGNDR/Lr9vksCZOzDd0FLExJPgk/
	M0uvpsErNOQYX67Tb0eSGtL35Nzujef2jQA=
X-Google-Smtp-Source: AGHT+IEUIKbzcU5VEKNhmTWHRErSrM+VGBrEEj6WxhG5F3wd29lziIZXlZkikyHJwI4OlakTVUpB7g==
X-Received: by 2002:a05:6a20:8423:b0:1e6:8f39:d635 with SMTP id adf61e73a8af0-1e88cf7f7a1mr32122730637.9.1736782401043;
        Mon, 13 Jan 2025 07:33:21 -0800 (PST)
Received: from ?IPV6:2001:ee0:4f4c:d5a0:7984:f0b3:c5d7:378f? ([2001:ee0:4f4c:d5a0:7984:f0b3:c5d7:378f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a318e055fccsm7057562a12.34.2025.01.13.07.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 07:33:20 -0800 (PST)
Message-ID: <fe804e02-f791-4885-94b7-ffdf2476573b@gmail.com>
Date: Mon, 13 Jan 2025 22:33:15 +0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: simplify the SQPOLL thread check when
 cancelling requests
To: Pavel Begunkov <asml.silence@gmail.com>, lizetao <lizetao1@huawei.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com"
 <syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com>
References: <20250112143358.49671-1-minhquangbui99@gmail.com>
 <aff011219272498a900f052d0142978c@huawei.com>
 <3cab5ad8-3089-46c7-868e-38bd3c250b26@gmail.com>
 <75e12d85-9c2e-4b06-99d1-bc29c5422b69@gmail.com>
Content-Language: en-US
From: Bui Quang Minh <minhquangbui99@gmail.com>
In-Reply-To: <75e12d85-9c2e-4b06-99d1-bc29c5422b69@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/13/25 04:15, Pavel Begunkov wrote:
> On 1/12/25 16:14, Bui Quang Minh wrote:
> ...
>>>> @@ -2898,7 +2899,12 @@ static __cold void io_ring_exit_work(struct
>>>> work_struct *work)
>>>>           if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>>>               io_move_task_work_from_local(ctx);
>>>>
>>>> -        while (io_uring_try_cancel_requests(ctx, NULL, true))
>>>> +        /*
>>>> +         * Even if SQPOLL thread reaches this path, don't force
>>>> +         * iopoll here, let the io_uring_cancel_generic handle
>>>> +         * it.
>>>
>>> Just curious, will sq_thread enter this io_ring_exit_work path?
>>
>> AFAIK, yes. The SQPOLL thread is created with create_io_thread, this 
>> function creates a new task with CLONE_FILES. So all the open files is 
>> shared. There will be case that the parent closes its io_uring file 
>> and SQPOLL thread become the only owner of that file. So it can reach 
>> this path when terminating.
> 
> The function is run by a separate kthread, the sqpoll task doesn't
> call it directly.

Yeah, the io_uring_release can be called in sqpoll thread but the 
io_ring_exit_work is queued in the io_uring workqueue so that function 
is executed in a kthread worker.

I will update the comment and commit message.

Thanks,
Quang Minh.

