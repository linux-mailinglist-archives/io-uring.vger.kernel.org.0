Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DCA3537D2
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 12:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhDDK5H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 06:57:07 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:60635 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229678AbhDDK5H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Apr 2021 06:57:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UUPFB.M_1617533821;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUPFB.M_1617533821)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 04 Apr 2021 18:57:01 +0800
Subject: Re: [PATCH] io_uring: don't mark S_ISBLK async work as unbounded
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>
References: <a96971ea-2787-149a-a4bd-422fa696a586@kernel.dk>
 <48023516-ac7d-8393-f603-f9bf4faa722f@linux.alibaba.com>
 <a4661870-a839-f949-e5cf-18022d070384@gmail.com>
 <2c0ce39f-3ccb-3e25-9dcf-d9876c30efb1@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <5264e0da-42f2-0629-f0a7-7c78eeee6deb@linux.alibaba.com>
Date:   Sun, 4 Apr 2021 18:57:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <2c0ce39f-3ccb-3e25-9dcf-d9876c30efb1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/2 下午6:48, Pavel Begunkov 写道:
> On 02/04/2021 11:32, Pavel Begunkov wrote:
>> On 02/04/2021 09:52, Hao Xu wrote:
>>> 在 2021/4/1 下午10:57, Jens Axboe 写道:
>>>> S_ISBLK is marked as unbounded work for async preparation, because it
>>>> doesn't match S_ISREG. That is incorrect, as any read/write to a block
>>>> device is also a bounded operation. Fix it up and ensure that S_ISBLK
>>>> isn't marked unbounded.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>
>>> Hi Jens, I saw a (un)bounded work is for a (un)bounded worker to
>>> execute. What is the difference between bounded and unbounded?
>>
>> Unbounded works are not bounded in execution time, i.e. they may take
>> forever to complete. E.g. recv depends on the other end to send something,
>> that not necessarily will ever happen.
> 
> To elaborate a bit, one example of how it's used: because unbounded may
> stay for long, it always spawns a new worker thread for each of them.
> 
> If app submits SQEs as below, and send's are not actually sent for execution
> but stashed somewhere internally in a list, e.g. waiting for a worker thread
> to get free, it would just hang from the userspace perspective.
> 
> recv(fd1), recv(fd1), send(fd1), send(fd1)
> 
Hi Pavel, thank you for the patient explanation, I got the meaning of
  bound/unbond now, but it seems there is no difference handling bounded 
and unbounded work in the current code?
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 6d7a1b69712b..a16b7df934d1 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -1213,7 +1213,7 @@ static void io_prep_async_work(struct io_kiocb *req)
>>>>        if (req->flags & REQ_F_ISREG) {
>>>>            if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
>>>>                io_wq_hash_work(&req->work, file_inode(req->file));
>>>> -    } else {
>>>> +    } else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {
>>>>            if (def->unbound_nonreg_file)
>>>>                req->work.flags |= IO_WQ_WORK_UNBOUND;
>>>>        }
> 

