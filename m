Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F68361144
	for <lists+io-uring@lfdr.de>; Thu, 15 Apr 2021 19:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbhDORm2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 13:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbhDORm1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 13:42:27 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFDBC061574;
        Thu, 15 Apr 2021 10:42:02 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j5so23165711wrn.4;
        Thu, 15 Apr 2021 10:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uEjbmIlAYJr/chkPHgEovS37j8EeMpHOWLqyA5kaHHk=;
        b=rg81Y52c74FFPUJHGbFwesSapImx1QoWoJI3kId+pUt7+4xA0yZcd/XjpzyPdlepxE
         2yCeLR684plNnQxr0miHx8T+QLN63CPrKw+TOd6s2koNyJad+zQyvo3kPKIlmZuWolQS
         W3X3JeGLnDkG5hDfrsG27kw2p4jtuxuHIl1j0EQLARWcCwEaq2hZjPAw9zXjUp18p/MW
         aoVH2Ddxp9jh/NHe1zXCjeKpDxO+6+cd/wyEdiVy0e4042Emdl7naeP2CJpmFheJ+32G
         /nBj9vFH2SYYqlVUszpWTO5ErQuzCYyfh5dvcA2yN4Hsh0/idNv2L2cAZXlq0eVyrK0N
         dx0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uEjbmIlAYJr/chkPHgEovS37j8EeMpHOWLqyA5kaHHk=;
        b=FtfZVpIBn1c3Su0NK5sNkM07D9fMXODQ8WMGPZKSHhwbyVGKqFqCpMS/H/OH49heMs
         cNuBE5nJCRr/TX4foXCXHRIISrZ266LkGYbYgPZigyh4Ug4b2sPA1gPQ6UAyauITlvND
         1EZ2XCC9Fl3PVqFvARA+K8bC7a0wymfEZlwpFei0WKX0g3E28rW7Tts94nnWwVlSJwHt
         rB4H3uYJuuZBklEfnfkxZKoxJwM4cumM8ON1Y0jsHpgWt+tOykYMTHrif8Yz+Z105e2S
         TNYLKEtD41ngtF06zrZdw9rfOWWwjvdA44nGDPP34weOpfl6q86J3O+KAU1zJtvGk3pR
         hBlQ==
X-Gm-Message-State: AOAM532jG78qC7QEUxNgrpL0V45Mh8vDxgsQaeRXmZf870/EXURdtqD1
        qCKzeAWi9x465I/0qEoz6oc3c/9ZauJJSg==
X-Google-Smtp-Source: ABdhPJzg1wWuONXjWedvc2gZqj9aFK0JFCeYfMzaOK/8Vn58gK7kr8Di8DcbNgeaBFYkQU6DPnzHbA==
X-Received: by 2002:adf:f302:: with SMTP id i2mr4596297wro.423.1618508521460;
        Thu, 15 Apr 2021 10:42:01 -0700 (PDT)
Received: from [192.168.8.188] ([185.69.144.21])
        by smtp.gmail.com with ESMTPSA id 61sm5038669wrm.52.2021.04.15.10.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 10:42:00 -0700 (PDT)
Subject: Re: [PATCH] block: reexpand iov_iter after read/write
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     yangerkun <yangerkun@huawei.com>, axboe@kernel.dk
Cc:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20210401071807.3328235-1-yangerkun@huawei.com>
 <a2e97190-936d-ebe0-2adc-748328076f31@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <7ff7d1b7-8b6d-a684-1740-6a62565f77b6@gmail.com>
Date:   Thu, 15 Apr 2021 18:37:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a2e97190-936d-ebe0-2adc-748328076f31@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/04/2021 15:49, Pavel Begunkov wrote:
> On 01/04/2021 08:18, yangerkun wrote:
>> We get a bug:
>>
>> BUG: KASAN: slab-out-of-bounds in iov_iter_revert+0x11c/0x404
>> lib/iov_iter.c:1139
>> Read of size 8 at addr ffff0000d3fb11f8 by task
>>
>> CPU: 0 PID: 12582 Comm: syz-executor.2 Not tainted
>> 5.10.0-00843-g352c8610ccd2 #2
>> Hardware name: linux,dummy-virt (DT)
>> Call trace:
...
>>  __asan_load8+0xb4/0xbc mm/kasan/generic.c:252
>>  iov_iter_revert+0x11c/0x404 lib/iov_iter.c:1139
>>  io_read fs/io_uring.c:3421 [inline]
>>  io_issue_sqe+0x2344/0x2d64 fs/io_uring.c:5943
>>  __io_queue_sqe+0x19c/0x520 fs/io_uring.c:6260
>>  io_queue_sqe+0x2a4/0x590 fs/io_uring.c:6326
>>  io_submit_sqe fs/io_uring.c:6395 [inline]
>>  io_submit_sqes+0x4c0/0xa04 fs/io_uring.c:6624
...
>>
>> blkdev_read_iter can truncate iov_iter's count since the count + pos may
>> exceed the size of the blkdev. This will confuse io_read that we have
>> consume the iovec. And once we do the iov_iter_revert in io_read, we
>> will trigger the slab-out-of-bounds. Fix it by reexpand the count with
>> size has been truncated.
> 
> Looks right,
> 
> Acked-by: Pavel Begunkov <asml.silencec@gmail.com>

Fwiw, we need to forget to drag it through 5.13 + stable


>>
>> blkdev_write_iter can trigger the problem too.
>>
>> Signed-off-by: yangerkun <yangerkun@huawei.com>
>> ---
>>  fs/block_dev.c | 20 +++++++++++++++++---
>>  1 file changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>> index 92ed7d5df677..788e1014576f 100644
>> --- a/fs/block_dev.c
>> +++ b/fs/block_dev.c
>> @@ -1680,6 +1680,7 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>  	struct inode *bd_inode = bdev_file_inode(file);
>>  	loff_t size = i_size_read(bd_inode);
>>  	struct blk_plug plug;
>> +	size_t shorted = 0;
>>  	ssize_t ret;
>>  
>>  	if (bdev_read_only(I_BDEV(bd_inode)))
>> @@ -1697,12 +1698,17 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>  	if ((iocb->ki_flags & (IOCB_NOWAIT | IOCB_DIRECT)) == IOCB_NOWAIT)
>>  		return -EOPNOTSUPP;
>>  
>> -	iov_iter_truncate(from, size - iocb->ki_pos);
>> +	size -= iocb->ki_pos;
>> +	if (iov_iter_count(from) > size) {
>> +		shorted = iov_iter_count(from) - size;
>> +		iov_iter_truncate(from, size);
>> +	}
>>  
>>  	blk_start_plug(&plug);
>>  	ret = __generic_file_write_iter(iocb, from);
>>  	if (ret > 0)
>>  		ret = generic_write_sync(iocb, ret);
>> +	iov_iter_reexpand(from, iov_iter_count(from) + shorted);
>>  	blk_finish_plug(&plug);
>>  	return ret;
>>  }
>> @@ -1714,13 +1720,21 @@ ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>  	struct inode *bd_inode = bdev_file_inode(file);
>>  	loff_t size = i_size_read(bd_inode);
>>  	loff_t pos = iocb->ki_pos;
>> +	size_t shorted = 0;
>> +	ssize_t ret;
>>  
>>  	if (pos >= size)
>>  		return 0;
>>  
>>  	size -= pos;
>> -	iov_iter_truncate(to, size);
>> -	return generic_file_read_iter(iocb, to);
>> +	if (iov_iter_count(to) > size) {
>> +		shorted = iov_iter_count(to) - size;
>> +		iov_iter_truncate(to, size);
>> +	}
>> +
>> +	ret = generic_file_read_iter(iocb, to);
>> +	iov_iter_reexpand(to, iov_iter_count(to) + shorted);
>> +	return ret;
>>  }
>>  EXPORT_SYMBOL_GPL(blkdev_read_iter);
>>  
>>
> 

-- 
Pavel Begunkov
