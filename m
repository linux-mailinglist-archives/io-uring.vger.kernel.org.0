Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F972AA85B
	for <lists+io-uring@lfdr.de>; Sun,  8 Nov 2020 00:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgKGXR1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 18:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKGXR1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 18:17:27 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7082FC0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 15:17:25 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id p4so2708912plr.1
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 15:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QgMLbm+EPF/ESAX5Mn9aELzMj8fgv6PuxMn1yp1eh6o=;
        b=Cjn2XvNJpN4HMdtpBEMbc+Qu0AQtjDeSQw1H6IwA7EpHwK9aNrYN/X5haupf9oz+GC
         81yKpwusEEgaQ2pzaPq8xzxNE3Ou4ozythJGeHcu+7PrUj7N8VnyzLgju4Xy0fP9Y/wu
         xYG6WWkRl0rL5fUsWnrkzvR06liUm7Et4OOLImCY2kJy9P7QZMFzLDyKZjMSJaTlQEDs
         vLGKaf7WmQbUlG+kmUKXf6tCGaa00YPq6Y3bwC75DZA63sYz7WGsTnpF8DutHBpT9+2O
         DN5pRf7qsN53js8znQQ1veLKYVX4oaQ2TpLhoV9DrBymetRbdTXZQa6WxuyWSw1Xm9AX
         59cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QgMLbm+EPF/ESAX5Mn9aELzMj8fgv6PuxMn1yp1eh6o=;
        b=gSVF6BR0qrd4UkWUrn+o64PLXdH+jdQ/DTgspvLkDf3jZPagKli6OW+Bu8viY5Bgvs
         Tt/mChhVPf5qDl9wT1V7K8QSbkb2AAdUAaynJj5PiAItQmcGC2s3IB6gvNPUenz73KWo
         a+tpT1XzbJ5mxVR6kw5QK3zLETWpMNb+KHMP/CpFSUSqVvnNkIJ5qYp9XpPVHwaCpbyg
         NiLHPpRJjomECrEKHfFLGGxeV8si6tLj7ft+5eRKiBFns7K70JUGqM2IGQ2ix0ZegQKx
         moG45cNeJ+PXewkyaY+i2RBCK+geI/kA/WUl+Sk5ZHYG7SqfcZlpJSQc8kWVu8OEe7eP
         hcQw==
X-Gm-Message-State: AOAM532Z414fuPo7kN30txCWYR/PWzx6XITSh1WEEzmVxC/PbVMJQi+m
        Nk5eAQ+2IhdS8zJQ/DqPBac41A==
X-Google-Smtp-Source: ABdhPJyO3Zq3kfbcN3B4yzYN1Uxj6rVx+rMnzeL4cHsqAY94R21sOxPadQK/1iHT31cv4HoXK3Nvjw==
X-Received: by 2002:a17:90a:fd08:: with SMTP id cv8mr5689360pjb.203.1604791044795;
        Sat, 07 Nov 2020 15:17:24 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z22sm6661048pje.16.2020.11.07.15.17.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 15:17:24 -0800 (PST)
Subject: Re: [PATCH 5.11] io_uring: NULL files dereference by SQPOLL
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Josef Grieb <josef.grieb@gmail.com>
References: <24446f4e23e80803d3ab1a4d27a6d1a605e37b32.1604783766.git.asml.silence@gmail.com>
 <dd1253a1-e7aa-57a6-9851-7f7d4dfd9a92@kernel.dk>
 <2b72aee7-afc5-0458-c189-df873b0914ed@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3e8c0988-b92c-30ab-fd83-62261b93b98f@kernel.dk>
Date:   Sat, 7 Nov 2020 16:17:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2b72aee7-afc5-0458-c189-df873b0914ed@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/7/20 3:49 PM, Pavel Begunkov wrote:
> On 07/11/2020 22:30, Jens Axboe wrote:
>> On 11/7/20 2:16 PM, Pavel Begunkov wrote:
>>> SQPOLL task may find sqo_task->files == NULL, so
>>> __io_sq_thread_acquire_files() would left it unset and so all the
>>> following fails, e.g. attempts to submit. Fail if sqo_task doesn't have
>>> files.
>>>
>>> [  118.962785] BUG: kernel NULL pointer dereference, address:
>>> 	0000000000000020
>>> [  118.963812] #PF: supervisor read access in kernel mode
>>> [  118.964534] #PF: error_code(0x0000) - not-present page
>>> [  118.969029] RIP: 0010:__fget_files+0xb/0x80
>>> [  119.005409] Call Trace:
>>> [  119.005651]  fget_many+0x2b/0x30
>>> [  119.005964]  io_file_get+0xcf/0x180
>>> [  119.006315]  io_submit_sqes+0x3a4/0x950
>>> [  119.006678]  ? io_double_put_req+0x43/0x70
>>> [  119.007054]  ? io_async_task_func+0xc2/0x180
>>> [  119.007481]  io_sq_thread+0x1de/0x6a0
>>> [  119.007828]  kthread+0x114/0x150
>>> [  119.008135]  ? __ia32_sys_io_uring_enter+0x3c0/0x3c0
>>> [  119.008623]  ? kthread_park+0x90/0x90
>>> [  119.008963]  ret_from_fork+0x22/0x30
>>>
>>> Reported-by: Josef Grieb <josef.grieb@gmail.com>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>  fs/io_uring.c | 19 ++++++++++++-------
>>>  1 file changed, 12 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 8d721a652d61..9c035c5c4080 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -1080,7 +1080,7 @@ static void io_sq_thread_drop_mm_files(void)
>>>  	}
>>>  }
>>>  
>>> -static void __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
>>> +static int __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
>>>  {
>>>  	if (!current->files) {
>>>  		struct files_struct *files;
>>> @@ -1091,7 +1091,7 @@ static void __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
>>>  		files = ctx->sqo_task->files;
>>>  		if (!files) {
>>>  			task_unlock(ctx->sqo_task);
>>> -			return;
>>> +			return -EFAULT;
>>
>> I don't think we should use -EFAULT here, it's generally used for trying
>> to copy in/out of invalid regions. Probably -ECANCELED is better here,
> 
> Noted, I'll resend after Josef tests this.
> 
>> in lieu of something super appropriate. Maybe -EBADF would be fine too.
> 
> Yeah, something along OWNER_TASK_DEAD would make more sense.

You could try and commandeer -EOWNERDEAD for this use case, it does
make sense.

-- 
Jens Axboe

