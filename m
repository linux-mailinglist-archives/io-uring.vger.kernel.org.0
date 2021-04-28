Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B6236D219
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 08:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbhD1GRF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 02:17:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16162 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhD1GRF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 02:17:05 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FVSx304jwzpbqd;
        Wed, 28 Apr 2021 14:13:11 +0800 (CST)
Received: from [10.174.176.73] (10.174.176.73) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Wed, 28 Apr 2021 14:16:13 +0800
Subject: Re: [PATCH] block: reexpand iov_iter after read/write
To:     Pavel Begunkov <asml.silence@gmail.com>, <axboe@kernel.dk>
CC:     <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
References: <20210401071807.3328235-1-yangerkun@huawei.com>
 <a2e97190-936d-ebe0-2adc-748328076f31@gmail.com>
 <7ff7d1b7-8b6d-a684-1740-6a62565f77b6@gmail.com>
 <3368729f-e61d-d4b6-f2ae-e17ebe59280e@gmail.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <3d6904c0-9719-8569-2ae8-dd9694da046b@huawei.com>
Date:   Wed, 28 Apr 2021 14:16:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <3368729f-e61d-d4b6-f2ae-e17ebe59280e@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.73]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Should we pick this patch for 5.13?

在 2021/4/16 1:39, Pavel Begunkov 写道:
> On 15/04/2021 18:37, Pavel Begunkov wrote:
>> On 09/04/2021 15:49, Pavel Begunkov wrote:
>>> On 01/04/2021 08:18, yangerkun wrote:
>>>> We get a bug:
>>>>
>>>> BUG: KASAN: slab-out-of-bounds in iov_iter_revert+0x11c/0x404
>>>> lib/iov_iter.c:1139
>>>> Read of size 8 at addr ffff0000d3fb11f8 by task
>>>>
>>>> CPU: 0 PID: 12582 Comm: syz-executor.2 Not tainted
>>>> 5.10.0-00843-g352c8610ccd2 #2
>>>> Hardware name: linux,dummy-virt (DT)
>>>> Call trace:
>> ...
>>>>   __asan_load8+0xb4/0xbc mm/kasan/generic.c:252
>>>>   iov_iter_revert+0x11c/0x404 lib/iov_iter.c:1139
>>>>   io_read fs/io_uring.c:3421 [inline]
>>>>   io_issue_sqe+0x2344/0x2d64 fs/io_uring.c:5943
>>>>   __io_queue_sqe+0x19c/0x520 fs/io_uring.c:6260
>>>>   io_queue_sqe+0x2a4/0x590 fs/io_uring.c:6326
>>>>   io_submit_sqe fs/io_uring.c:6395 [inline]
>>>>   io_submit_sqes+0x4c0/0xa04 fs/io_uring.c:6624
>> ...
>>>>
>>>> blkdev_read_iter can truncate iov_iter's count since the count + pos may
>>>> exceed the size of the blkdev. This will confuse io_read that we have
>>>> consume the iovec. And once we do the iov_iter_revert in io_read, we
>>>> will trigger the slab-out-of-bounds. Fix it by reexpand the count with
>>>> size has been truncated.
>>>
>>> Looks right,
>>>
>>> Acked-by: Pavel Begunkov <asml.silencec@gmail.com>
>>
>> Fwiw, we need to forget to drag it through 5.13 + stable
> 
> Err, yypo, to _not_ forget to 5.13 + stable...
> 
>>
>>
>>>>
>>>> blkdev_write_iter can trigger the problem too.
>>>>
>>>> Signed-off-by: yangerkun <yangerkun@huawei.com>
>>>> ---
>>>>   fs/block_dev.c | 20 +++++++++++++++++---
>>>>   1 file changed, 17 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>>>> index 92ed7d5df677..788e1014576f 100644
>>>> --- a/fs/block_dev.c
>>>> +++ b/fs/block_dev.c
>>>> @@ -1680,6 +1680,7 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>>>   	struct inode *bd_inode = bdev_file_inode(file);
>>>>   	loff_t size = i_size_read(bd_inode);
>>>>   	struct blk_plug plug;
>>>> +	size_t shorted = 0;
>>>>   	ssize_t ret;
>>>>   
>>>>   	if (bdev_read_only(I_BDEV(bd_inode)))
>>>> @@ -1697,12 +1698,17 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>>>   	if ((iocb->ki_flags & (IOCB_NOWAIT | IOCB_DIRECT)) == IOCB_NOWAIT)
>>>>   		return -EOPNOTSUPP;
>>>>   
>>>> -	iov_iter_truncate(from, size - iocb->ki_pos);
>>>> +	size -= iocb->ki_pos;
>>>> +	if (iov_iter_count(from) > size) {
>>>> +		shorted = iov_iter_count(from) - size;
>>>> +		iov_iter_truncate(from, size);
>>>> +	}
>>>>   
>>>>   	blk_start_plug(&plug);
>>>>   	ret = __generic_file_write_iter(iocb, from);
>>>>   	if (ret > 0)
>>>>   		ret = generic_write_sync(iocb, ret);
>>>> +	iov_iter_reexpand(from, iov_iter_count(from) + shorted);
>>>>   	blk_finish_plug(&plug);
>>>>   	return ret;
>>>>   }
>>>> @@ -1714,13 +1720,21 @@ ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>>>   	struct inode *bd_inode = bdev_file_inode(file);
>>>>   	loff_t size = i_size_read(bd_inode);
>>>>   	loff_t pos = iocb->ki_pos;
>>>> +	size_t shorted = 0;
>>>> +	ssize_t ret;
>>>>   
>>>>   	if (pos >= size)
>>>>   		return 0;
>>>>   
>>>>   	size -= pos;
>>>> -	iov_iter_truncate(to, size);
>>>> -	return generic_file_read_iter(iocb, to);
>>>> +	if (iov_iter_count(to) > size) {
>>>> +		shorted = iov_iter_count(to) - size;
>>>> +		iov_iter_truncate(to, size);
>>>> +	}
>>>> +
>>>> +	ret = generic_file_read_iter(iocb, to);
>>>> +	iov_iter_reexpand(to, iov_iter_count(to) + shorted);
>>>> +	return ret;
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(blkdev_read_iter);
>>>>   
>>>>
>>>
>>
> 
