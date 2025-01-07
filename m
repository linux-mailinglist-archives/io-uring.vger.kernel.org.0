Return-Path: <io-uring+bounces-5743-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B47CA04904
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 19:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3574B165DD4
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 18:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F1118CBE8;
	Tue,  7 Jan 2025 18:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1I/NoNL1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0244018C900
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 18:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736273577; cv=none; b=oKskxfHyb+Z/AFQqvbTr1zt77LL0ZJgr00lxnliZnBUxxdumuPpTdwxPU0SCAtebIcWXO6r1ccVcstaGLiFLaWfobwEh371dPSLT7qNIY7C7m7bJ7ozNzNYtrZ4Xa2IZmU/0+7eXqN9ZMU8zUcYfPFf6yzoNo/3kjgtUDSq3aHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736273577; c=relaxed/simple;
	bh=Y5NpFZWvLq8MqtbHDLWfB2TfxMY2GCkdJP0LHgdJ4Ew=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=igg+S9LL15nEOrsiGu//mp4lk8cyhxAykDYKStLH7Acx4CQ5UiMl8CHpEWB58MlEY2vWlfQ+LeP/IUmVOGrCl/NOVKqfIBr8jCt4IRkZtYyi2tUaDTt8jGRVZebxmwOVITooWE7dWsg5oqr0Y0njB4ZVtbZN+6eB1ybykMHhyDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1I/NoNL1; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-844bff5ba1dso1249189539f.1
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2025 10:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736273572; x=1736878372; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dhHjl8LY1wV38OqaGnhfFBmxqodWke7YmZ47bd1kV6E=;
        b=1I/NoNL1LQ+byFmH/z45nw+9G+yIV2UZ4+tfDwxfKSQ8n5YNhbst8eLYdwJhEFtLpu
         0h3ibGsvltmrzwXAavI0OYmr7qYehnjurJ2QiqEhTJV2D8bSKBdEysKtPLif2Am8cuDm
         d9M7voQc5AWT8U6pIcWeiLvNH7FMIdOm/gONEC0axMjWoNKPlaVjbB5fIP9SLpeStwSh
         cuMs1okqDIC8v2XQF6HDprc1gUpJg3fmnhnmnGCfSfdTc17dG28TInkrXWlSSv+5fm2j
         CK6sgwvsDw4oe0lfmIdneluQthUC9gZynkOmXCEo/WEfKrhPpIrn3AjFTKDPP1vdUxK5
         rClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736273572; x=1736878372;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dhHjl8LY1wV38OqaGnhfFBmxqodWke7YmZ47bd1kV6E=;
        b=kgVoaPc02ibCmid1v44XkptRPcF43OdjQDwlQnxxPRH25Hu4L1OAhSGC7dOV6brqwI
         2iOPfejYw+lCJ+POXTRq7nTIrx9qTz3OsvUlP5hQSH32xn1aaq5Ag3iL5alF/BhhoDNE
         zkMkwP4xznl2EptWnHA3nm3PK4CziZcwROjRETwohnE/MIxZVGoR4RoTxEO1Lky+kx1b
         QXjRIsCF15kyUdzCz+8A6VEPYzmKYHgdnJHstymS0nPRGosLM+VJaFeiyXdusOotOReP
         5Q34Aq8ATptyMgrMaoXuxW0pctkUSaGhTt37xT7CJ2SH/49qozr+DW0EJUfjB/fTHH7r
         UHBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTbtsZVvEvA0FHjoYyV0/xPYloqT8K7CaTbWdQz/GsWoAbiVe8dup4u8NU/TX0YjcaEeAnv05JmA==@vger.kernel.org
X-Gm-Message-State: AOJu0YylmIRsHPK5jImi9w4hpyphw0vLBCRFM6UPnRjcnDAFHpnsrdME
	flgO9U+osu109WR9tfzsI6jacd0cFYp7vcg2GcoWn3PvHdrFEVf6vDxlWXKVz+qFCzhQ0eA32no
	C
X-Gm-Gg: ASbGncsUU1Nl71HRE16eNGVqXyJXIXR52iRb3Poz34kNlWYU05OzbnAWUpcjnfj1Idw
	Kr5D4DHi0FOWti5f++9kheDa31/gNNkMB23xCq021Meh79T3BLgRYp+7nAjAAAv+TkM9BN5h+/w
	fj4igmkiH/he/9stFBNRHRe18iZuvaE246tdIM7QCks7twBxShWqApgrlTKI5h6bLgOBVsIlMbC
	5lov+KxDgXnb506EgnZGvvUXHN8f+SDZn+Yx9uD/Zrx25NbsI+I
X-Google-Smtp-Source: AGHT+IGHIMY3AEn2qc4TTY2ckO2cDEDHWAx/zKm1wf1aTaIoVZUVebI9wN6ii7922Xb1FAV58cAXJw==
X-Received: by 2002:a05:6602:4742:b0:84c:da71:b127 with SMTP id ca18e2360f4ac-84ce0080f59mr3607639f.5.1736273572036;
        Tue, 07 Jan 2025 10:12:52 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8498d8279afsm937771539f.30.2025.01.07.10.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 10:12:51 -0800 (PST)
Message-ID: <df4c7e5a-8395-4af9-ad87-2625b2e48e9a@kernel.dk>
Date: Tue, 7 Jan 2025 11:12:50 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug? CQE.res = -EAGAIN with nvme multipath driver
From: Jens Axboe <axboe@kernel.dk>
To: "Haeuptle, Michael" <michael.haeuptle@hpe.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <DS7PR84MB31105C2C63CFA47BE8CBD6EE95102@DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM>
 <fe2c7e3c-9cec-4f30-8b9b-4b377c567411@kernel.dk>
 <da6375f5-602f-4edd-8d27-1c70cc28b30e@kernel.dk>
 <8330be7f-bb41-4201-822b-93c31dd649fe@kernel.dk>
Content-Language: en-US
In-Reply-To: <8330be7f-bb41-4201-822b-93c31dd649fe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/25 7:39 PM, Jens Axboe wrote:
> On 1/6/25 7:33 PM, Jens Axboe wrote:
>> On 1/6/25 4:53 PM, Jens Axboe wrote:
>>> On 1/6/25 1:03 PM, Haeuptle, Michael wrote:
>>>> Hello,
>>>>
>>>> I?m using the nvme multipath driver (NVMF/RDMA) and io-uring. When a
>>>> path goes away, I sometimes get a CQE.res = -EAGAIN in user space.
>>>> This is unexpected since the nvme multipath driver should handle this
>>>> transparently. It?s somewhat workload related but easy to reproduce
>>>> with fio.
>>>>
>>>> The multipath driver uses kblockd worker to re-queue the failed NVME
>>>> bios
>>>> (https://github.com/torvalds/linux/blob/13563da6ffcf49b8b45772e40b35f96926a7ee1e/drivers/nvme/host/multipath.c#L126).
>>>> The original request is ended. 
>>>>
>>>> When the nvme_requeue_work callback is executed, the blk layer tries
>>>> to allocate a new request for the bios but that fails and the bio
>>>> status is set to BLK_STS_AGAIN
>>>> (https://elixir.bootlin.com/linux/v6.12.6/source/block/blk-mq.c#L2987).
>>>> The failure to allocate a new req seems to be due to all tags for the
>>>> queue being used up.
>>>>
>>>> Eventually, this makes it into io_uring?s io_rw_should_reissue and
>>>> hits same_thread_group(req->tctx->task, current) = false (in
>>>> https://github.com/torvalds/linux/blob/13563da6ffcf49b8b45772e40b35f96926a7ee1e/io_uring/rw.c#L437).
>>>> As a result, CQE.res = -EAGAIN and thrown back to the user space
>>>> program.
>>>>
>>>> Here?s a stack dump when we hit same_thread_group(req->tctx->task,
>>>> current) = false 
>>>>
>>>> kernel: [237700.098733]  dump_stack_lvl+0x44/0x5c
>>>> kernel: [237700.098737]  io_rw_should_reissue.cold+0x5d/0x64
>>>> kernel: [237700.098742]  io_complete_rw+0x9a/0xc0
>>>> kernel: [237700.098745]  blkdev_bio_end_io_async+0x33/0x80
>>>> kernel: [237700.098749]  blk_mq_submit_bio+0x5b5/0x620
>>>> kernel: [237700.098756]  submit_bio_noacct_nocheck+0x163/0x370
>>>> kernel: [237700.098760]  ? submit_bio_noacct+0x79/0x4b0
>>>> kernel: [237700.098764]  nvme_requeue_work+0x4b/0x60 [nvme_core]
>>>> kernel: [237700.098776]  process_one_work+0x1c7/0x380
>>>> kernel: [237700.098782]  worker_thread+0x4d/0x380
>>>> kernel: [237700.098786]  ? _raw_spin_lock_irqsave+0x23/0x50
>>>> kernel: [237700.098791]  ? rescuer_thread+0x3a0/0x3a0
>>>> kernel: [237700.098794]  kthread+0xe9/0x110
>>>> kernel: [237700.098798]  ? kthread_complete_and_exit+0x20/0x20
>>>> kernel: [237700.098802]  ret_from_fork+0x22/0x30
>>>> kernel: [237700.098811]  </TASK>
>>>>
>>>> Is the same_thread_group() check really needed in this case? The
>>>> thread groups are certainly different? Any side effects if this check
>>>> is being removed?
>>>
>>> It's their for safety reasons - across all request types, it's not
>>> always safe. For this case, absolutely the check does not need to be
>>> there. So probably best to ponder ways to bypass it selectively.
>>>
>>> Let me ponder a bit what the best approach would be here...
>>
>> Actually I think we can just remove it. The actual retry will happen out
>> of context anyway, and the comment about the import is no longer valid
>> as the import will have been done upfront since 6.10.
>>
>> Do you want to send a patch for that, or do you want me to send one out
>> referencing this report?
> 
> Also see:
> 
> commit 039a2e800bcd5beb89909d1a488abf3d647642cf
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Thu Apr 25 09:04:32 2024 -0600
> 
>     io_uring/rw: reinstate thread check for retries
> 
> let me take a closer look tomorrow...

If you can test a custom kernel, can you give this branch a try?

git://git.kernel.dk/linux.git io_uring-rw-retry

-- 
Jens Axboe


