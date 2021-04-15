Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0FD361147
	for <lists+io-uring@lfdr.de>; Thu, 15 Apr 2021 19:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhDORoC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 13:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbhDORoC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 13:44:02 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA829C061574;
        Thu, 15 Apr 2021 10:43:38 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j5so23170180wrn.4;
        Thu, 15 Apr 2021 10:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=glqV8G4m2t3RXY1t9mEDvQG/54QxYFUk50FCtMFS2ls=;
        b=cNEpAKQqW4MSV0nssyqfwCF7DrEKeafDE2FgXHb4b9zBIf+mEFIW1snCWNzgJ+I37J
         umUaLxvNKAACxQcNhK0ZADSzJxinP4OH2f3aZ3t72qoZ8Bgxvyx65+NWj1kU842m1eJ8
         woyDF1oCEgoJ580BGUh+TyKNyVeDGoWSw3d8wlV2dcnfgQy6YGFOJFo0Ld18Q//gsz5R
         GJFShCLcnxuTQEv3nC/x1IrUTG8TePLYpDSe5QcJ7BJ3CRJKyy1eAPYEuf2bIQYxrtnr
         s5+7lm1LNnpm4JS2JZoyBEhuQLuiExZG085Db7JD7VcKtiWnxsrjs+SKA4CoEdbzHZKu
         jDag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=glqV8G4m2t3RXY1t9mEDvQG/54QxYFUk50FCtMFS2ls=;
        b=YPGz3/rzKhgatWmuDM+0yZHjGwOmLEQYiDAsFadxxGAqdbc7VH+N+7TDDQYN7xVDdF
         ItcHsfSZhLAE8+Q8spHnRRPvii24eK8d01cbt3U1/AXoM7Zp0ryaiVG847p6UJYIReP6
         g5Xg2gDvfexHtXotqVgzAyTMqTo4UA6qMTc+5wRW9bwSHmOnvZhYQTWIf05sFZR/WGUM
         vEK4DC1i+neq8ygm/5T5kF7Brk+fBvftwXZG1UsI/yT8ZHeb9j/uNbNH2c/RxUP9BBYl
         WiOl0KA5oUC/gkLI/bWLGWE3FjB+Zsowkfz/j1sd1eZMh9+OjbPPAX25PNHD8NJkU2vZ
         lt6w==
X-Gm-Message-State: AOAM532lfwDAf+AKi4+otYFkPWsTCyAr57S2bWbEo8WikiSsNFdKP6Qr
        Y8DT12Rr0rI8pxl0lOJVvj0SMUuOeqrsrw==
X-Google-Smtp-Source: ABdhPJzxEiG8boH/apJggGvbonN24EV2GC50+Yy3C8+/Wpjj8jl9pA5lcULpAHJSTKvh5xTgZdr4wA==
X-Received: by 2002:a5d:4bce:: with SMTP id l14mr4750994wrt.359.1618508617405;
        Thu, 15 Apr 2021 10:43:37 -0700 (PDT)
Received: from [192.168.8.188] ([185.69.144.21])
        by smtp.gmail.com with ESMTPSA id a72sm3899058wme.29.2021.04.15.10.43.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 10:43:37 -0700 (PDT)
Subject: Re: [PATCH] block: reexpand iov_iter after read/write
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     yangerkun <yangerkun@huawei.com>, axboe@kernel.dk
Cc:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20210401071807.3328235-1-yangerkun@huawei.com>
 <a2e97190-936d-ebe0-2adc-748328076f31@gmail.com>
 <7ff7d1b7-8b6d-a684-1740-6a62565f77b6@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <3368729f-e61d-d4b6-f2ae-e17ebe59280e@gmail.com>
Date:   Thu, 15 Apr 2021 18:39:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <7ff7d1b7-8b6d-a684-1740-6a62565f77b6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/04/2021 18:37, Pavel Begunkov wrote:
> On 09/04/2021 15:49, Pavel Begunkov wrote:
>> On 01/04/2021 08:18, yangerkun wrote:
>>> We get a bug:
>>>
>>> BUG: KASAN: slab-out-of-bounds in iov_iter_revert+0x11c/0x404
>>> lib/iov_iter.c:1139
>>> Read of size 8 at addr ffff0000d3fb11f8 by task
>>>
>>> CPU: 0 PID: 12582 Comm: syz-executor.2 Not tainted
>>> 5.10.0-00843-g352c8610ccd2 #2
>>> Hardware name: linux,dummy-virt (DT)
>>> Call trace:
> ...
>>>  __asan_load8+0xb4/0xbc mm/kasan/generic.c:252
>>>  iov_iter_revert+0x11c/0x404 lib/iov_iter.c:1139
>>>  io_read fs/io_uring.c:3421 [inline]
>>>  io_issue_sqe+0x2344/0x2d64 fs/io_uring.c:5943
>>>  __io_queue_sqe+0x19c/0x520 fs/io_uring.c:6260
>>>  io_queue_sqe+0x2a4/0x590 fs/io_uring.c:6326
>>>  io_submit_sqe fs/io_uring.c:6395 [inline]
>>>  io_submit_sqes+0x4c0/0xa04 fs/io_uring.c:6624
> ...
>>>
>>> blkdev_read_iter can truncate iov_iter's count since the count + pos may
>>> exceed the size of the blkdev. This will confuse io_read that we have
>>> consume the iovec. And once we do the iov_iter_revert in io_read, we
>>> will trigger the slab-out-of-bounds. Fix it by reexpand the count with
>>> size has been truncated.
>>
>> Looks right,
>>
>> Acked-by: Pavel Begunkov <asml.silencec@gmail.com>
> 
> Fwiw, we need to forget to drag it through 5.13 + stable

Err, yypo, to _not_ forget to 5.13 + stable...

> 
> 
>>>
>>> blkdev_write_iter can trigger the problem too.
>>>
>>> Signed-off-by: yangerkun <yangerkun@huawei.com>
>>> ---
>>>  fs/block_dev.c | 20 +++++++++++++++++---
>>>  1 file changed, 17 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>>> index 92ed7d5df677..788e1014576f 100644
>>> --- a/fs/block_dev.c
>>> +++ b/fs/block_dev.c
>>> @@ -1680,6 +1680,7 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>>  	struct inode *bd_inode = bdev_file_inode(file);
>>>  	loff_t size = i_size_read(bd_inode);
>>>  	struct blk_plug plug;
>>> +	size_t shorted = 0;
>>>  	ssize_t ret;
>>>  
>>>  	if (bdev_read_only(I_BDEV(bd_inode)))
>>> @@ -1697,12 +1698,17 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>>  	if ((iocb->ki_flags & (IOCB_NOWAIT | IOCB_DIRECT)) == IOCB_NOWAIT)
>>>  		return -EOPNOTSUPP;
>>>  
>>> -	iov_iter_truncate(from, size - iocb->ki_pos);
>>> +	size -= iocb->ki_pos;
>>> +	if (iov_iter_count(from) > size) {
>>> +		shorted = iov_iter_count(from) - size;
>>> +		iov_iter_truncate(from, size);
>>> +	}
>>>  
>>>  	blk_start_plug(&plug);
>>>  	ret = __generic_file_write_iter(iocb, from);
>>>  	if (ret > 0)
>>>  		ret = generic_write_sync(iocb, ret);
>>> +	iov_iter_reexpand(from, iov_iter_count(from) + shorted);
>>>  	blk_finish_plug(&plug);
>>>  	return ret;
>>>  }
>>> @@ -1714,13 +1720,21 @@ ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>>  	struct inode *bd_inode = bdev_file_inode(file);
>>>  	loff_t size = i_size_read(bd_inode);
>>>  	loff_t pos = iocb->ki_pos;
>>> +	size_t shorted = 0;
>>> +	ssize_t ret;
>>>  
>>>  	if (pos >= size)
>>>  		return 0;
>>>  
>>>  	size -= pos;
>>> -	iov_iter_truncate(to, size);
>>> -	return generic_file_read_iter(iocb, to);
>>> +	if (iov_iter_count(to) > size) {
>>> +		shorted = iov_iter_count(to) - size;
>>> +		iov_iter_truncate(to, size);
>>> +	}
>>> +
>>> +	ret = generic_file_read_iter(iocb, to);
>>> +	iov_iter_reexpand(to, iov_iter_count(to) + shorted);
>>> +	return ret;
>>>  }
>>>  EXPORT_SYMBOL_GPL(blkdev_read_iter);
>>>  
>>>
>>
> 

-- 
Pavel Begunkov
