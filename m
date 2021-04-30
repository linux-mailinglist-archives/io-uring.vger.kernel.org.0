Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F74236FB08
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 14:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhD3M6T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 08:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbhD3M6S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Apr 2021 08:58:18 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8833BC06174A;
        Fri, 30 Apr 2021 05:57:30 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id k4-20020a7bc4040000b02901331d89fb83so1628187wmi.5;
        Fri, 30 Apr 2021 05:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3dd/mitGLvz4qdKa/WihTM7PnH9tWmo6B8m+8qf/uBw=;
        b=Hs4c8felHsqfnOGWkeup9bMl8zgLiUWVux+CeamahDWOUZaLUl/yhqPFs7QD+kbm6S
         SCXTcwhD8eiQvxWhx7DC8ZudYwlreddQZaW8F892ydUGfES3cRihDnsZPanXoAhCgvhA
         yLqagHBtyuPYIvJRMbypORBkW3VTBR2kjjlVbXuIknIHb2PfdcG80sPZ+I1lnALf/2xS
         cZktQnANbeBPP6SsxJ+PML4a9sJ/Pft7SqeJmklsZLRHYgPYut/y4QAouXwiaolab4Op
         8tWgVHlYzE/5yCttSLJwE38noXvXHDXsZAdw12/i26FUgCGx61YGhqswbCtovMs5ACmO
         LX7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3dd/mitGLvz4qdKa/WihTM7PnH9tWmo6B8m+8qf/uBw=;
        b=T9vShWqH/D3aD3XE+/k04FvEeusCo2fIICcqgLRXun6YMfxTY425P969BLT4PgaKVo
         DRzMB37q3JFd6Qn9R3PUAIXu/ToR+Tvu5U2yMb2wWAQ+a0iw6Tm0Z4DNwFrB1jsCf4FY
         ArTrfh+6daIR0m2z72+f01X2xP7amcA7IALj+91k7n/5+aDeaJuaIC1Kt38EWgg9gXfs
         9DO7FgM+iN0h/NtPzEF8mjQkZ/4lOihXQcc42TtbJIbseYc3UVU8dz1Czh3hzLbFHHQe
         +JQTJpL0SE6oLfQhvvN8B3792nBAL5JdhbuGgbpzxaCiRRpQesS0GlRI+deDtQYSoZjO
         PWjA==
X-Gm-Message-State: AOAM531FEJdKkM953wdB0aQzcEBWzy8xOS15jMwMbafygXrk+GtcrkwR
        nKEmF9zqT4+RM83E9Lu5GBy2e9w8hBo=
X-Google-Smtp-Source: ABdhPJz5jBHWFPRjnmvYTbTi4aRQz0WtjynvyfyphDvCZMsXNIhS1ayQziRkt3MDq/0+FNqetA0MHg==
X-Received: by 2002:a05:600c:48a8:: with SMTP id j40mr6116830wmp.114.1619787448949;
        Fri, 30 Apr 2021 05:57:28 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id r11sm2189132wrx.22.2021.04.30.05.57.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 05:57:28 -0700 (PDT)
Subject: Re: [PATCH] block: reexpand iov_iter after read/write
To:     yangerkun <yangerkun@huawei.com>, axboe@kernel.dk
Cc:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20210401071807.3328235-1-yangerkun@huawei.com>
 <a2e97190-936d-ebe0-2adc-748328076f31@gmail.com>
 <7ff7d1b7-8b6d-a684-1740-6a62565f77b6@gmail.com>
 <3368729f-e61d-d4b6-f2ae-e17ebe59280e@gmail.com>
 <3d6904c0-9719-8569-2ae8-dd9694da046b@huawei.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <05803db5-c6de-e115-3db2-476454b20668@gmail.com>
Date:   Fri, 30 Apr 2021 13:57:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <3d6904c0-9719-8569-2ae8-dd9694da046b@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 7:16 AM, yangerkun wrote:
> Hi,
> 
> Should we pick this patch for 5.13?

Looks ok to me

> 
> 在 2021/4/16 1:39, Pavel Begunkov 写道:
>> On 15/04/2021 18:37, Pavel Begunkov wrote:
>>> On 09/04/2021 15:49, Pavel Begunkov wrote:
>>>> On 01/04/2021 08:18, yangerkun wrote:
>>>>> We get a bug:
>>>>>
>>>>> BUG: KASAN: slab-out-of-bounds in iov_iter_revert+0x11c/0x404
>>>>> lib/iov_iter.c:1139
>>>>> Read of size 8 at addr ffff0000d3fb11f8 by task
>>>>>
>>>>> CPU: 0 PID: 12582 Comm: syz-executor.2 Not tainted
>>>>> 5.10.0-00843-g352c8610ccd2 #2
>>>>> Hardware name: linux,dummy-virt (DT)
>>>>> Call trace:
>>> ...
>>>>>   __asan_load8+0xb4/0xbc mm/kasan/generic.c:252
>>>>>   iov_iter_revert+0x11c/0x404 lib/iov_iter.c:1139
>>>>>   io_read fs/io_uring.c:3421 [inline]
>>>>>   io_issue_sqe+0x2344/0x2d64 fs/io_uring.c:5943
>>>>>   __io_queue_sqe+0x19c/0x520 fs/io_uring.c:6260
>>>>>   io_queue_sqe+0x2a4/0x590 fs/io_uring.c:6326
>>>>>   io_submit_sqe fs/io_uring.c:6395 [inline]
>>>>>   io_submit_sqes+0x4c0/0xa04 fs/io_uring.c:6624
>>> ...
>>>>>
>>>>> blkdev_read_iter can truncate iov_iter's count since the count + pos may
>>>>> exceed the size of the blkdev. This will confuse io_read that we have
>>>>> consume the iovec. And once we do the iov_iter_revert in io_read, we
>>>>> will trigger the slab-out-of-bounds. Fix it by reexpand the count with
>>>>> size has been truncated.
>>>>
>>>> Looks right,
>>>>
>>>> Acked-by: Pavel Begunkov <asml.silencec@gmail.com>
>>>
>>> Fwiw, we need to forget to drag it through 5.13 + stable
>>
>> Err, yypo, to _not_ forget to 5.13 + stable...
>>
>>>
>>>
>>>>>
>>>>> blkdev_write_iter can trigger the problem too.
>>>>>
>>>>> Signed-off-by: yangerkun <yangerkun@huawei.com>
>>>>> ---
>>>>>   fs/block_dev.c | 20 +++++++++++++++++---
>>>>>   1 file changed, 17 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>>>>> index 92ed7d5df677..788e1014576f 100644
>>>>> --- a/fs/block_dev.c
>>>>> +++ b/fs/block_dev.c
>>>>> @@ -1680,6 +1680,7 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>>>>       struct inode *bd_inode = bdev_file_inode(file);
>>>>>       loff_t size = i_size_read(bd_inode);
>>>>>       struct blk_plug plug;
>>>>> +    size_t shorted = 0;
>>>>>       ssize_t ret;
>>>>>         if (bdev_read_only(I_BDEV(bd_inode)))
>>>>> @@ -1697,12 +1698,17 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>>>>       if ((iocb->ki_flags & (IOCB_NOWAIT | IOCB_DIRECT)) == IOCB_NOWAIT)
>>>>>           return -EOPNOTSUPP;
>>>>>   -    iov_iter_truncate(from, size - iocb->ki_pos);
>>>>> +    size -= iocb->ki_pos;
>>>>> +    if (iov_iter_count(from) > size) {
>>>>> +        shorted = iov_iter_count(from) - size;
>>>>> +        iov_iter_truncate(from, size);
>>>>> +    }
>>>>>         blk_start_plug(&plug);
>>>>>       ret = __generic_file_write_iter(iocb, from);
>>>>>       if (ret > 0)
>>>>>           ret = generic_write_sync(iocb, ret);
>>>>> +    iov_iter_reexpand(from, iov_iter_count(from) + shorted);
>>>>>       blk_finish_plug(&plug);
>>>>>       return ret;
>>>>>   }
>>>>> @@ -1714,13 +1720,21 @@ ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>>>>       struct inode *bd_inode = bdev_file_inode(file);
>>>>>       loff_t size = i_size_read(bd_inode);
>>>>>       loff_t pos = iocb->ki_pos;
>>>>> +    size_t shorted = 0;
>>>>> +    ssize_t ret;
>>>>>         if (pos >= size)
>>>>>           return 0;
>>>>>         size -= pos;
>>>>> -    iov_iter_truncate(to, size);
>>>>> -    return generic_file_read_iter(iocb, to);
>>>>> +    if (iov_iter_count(to) > size) {
>>>>> +        shorted = iov_iter_count(to) - size;
>>>>> +        iov_iter_truncate(to, size);
>>>>> +    }
>>>>> +
>>>>> +    ret = generic_file_read_iter(iocb, to);
>>>>> +    iov_iter_reexpand(to, iov_iter_count(to) + shorted);
>>>>> +    return ret;
>>>>>   }
>>>>>   EXPORT_SYMBOL_GPL(blkdev_read_iter);
>>>>>  
>>>>
>>>
>>

-- 
Pavel Begunkov
