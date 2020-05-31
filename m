Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB9F1E98C8
	for <lists+io-uring@lfdr.de>; Sun, 31 May 2020 18:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgEaQQg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 May 2020 12:16:36 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:46723 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726193AbgEaQQg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 May 2020 12:16:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04397;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U-7d0Y2_1590941710;
Received: from 30.15.192.46(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U-7d0Y2_1590941710)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Jun 2020 00:15:11 +0800
Subject: Re: [PATCH v4 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200530143947.21224-1-xiaoguang.wang@linux.alibaba.com>
 <8c361177-c0b0-b08c-e0a5-141f7fd948f0@kernel.dk>
 <e2040210-ab73-e82b-50ea-cdeb88c69157@kernel.dk>
 <27e264ec-2707-495f-3d24-4e9e20b86032@kernel.dk>
 <32d0768e-f7d7-1281-e9ff-e95329db9dc5@linux.alibaba.com>
 <94ed2ba3-0209-d3a1-c5f0-dc45493f4505@linux.alibaba.com>
 <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <4de0ccd2-249f-26af-d815-6dba1b86b25a@linux.alibaba.com>
Date:   Mon, 1 Jun 2020 00:15:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 12296ce3e8b9..2a3a02838f7b 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -907,9 +907,10 @@ static void io_file_put_work(struct work_struct *work);
>>>    static inline void io_req_init_async(struct io_kiocb *req,
>>>                           void (*func)(struct io_wq_work **))
>>>    {
>>> -       if (req->flags & REQ_F_WORK_INITIALIZED)
>>> -               req->work.func = func;
>>> -       else {
>>> +       if (req->flags & REQ_F_WORK_INITIALIZED) {
>>> +               if (!req->work.func)
>>> +                       req->work.func = func;
>>> +       } else {
>>>                   req->work = (struct io_wq_work){ .func = func };
>>>                   req->flags |= REQ_F_WORK_INITIALIZED;
>>>           }
>>> @@ -2920,6 +2921,8 @@ static int __io_splice_prep(struct io_kiocb *req,
>>>                   return ret;
>>>           req->flags |= REQ_F_NEED_CLEANUP;
>>>
>>> +       /* Splice will be punted aync, so initialize io_wq_work firstly_*/
>>> +       io_req_init_async(req, io_wq_submit_work);
>>>           if (!S_ISREG(file_inode(sp->file_in)->i_mode))
>>>                   req->work.flags |= IO_WQ_WORK_UNBOUND;
>>>
>>> @@ -3592,6 +3595,9 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
>>>
>>>    static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>    {
>>> +        /* Close may be punted aync, so initialize io_wq_work firstly */
>>> +       io_req_init_async(req, io_wq_submit_work);
>>> +
>> For splice and close requests, these two about io_req_init_async() calls should be
>> io_req_init_async(req, NULL), because they change req->work.flags firstly.
> 
> Please no. Such assumptions/dependencies are prone to break.
> It'll get us subtle bugs in no time.
> 
> BTW, why not io_wq_submit_work in place of NULL?
In the begin of __io_splice_prep or io_close_prep, current io_uring mainline codes will
modify req->work.flags firstly, so we need to call io_req_init_async to initialize
io_wq_work before the work.flags modification.
For below codes:
static inline void io_req_init_async(struct io_kiocb *req,
                         void (*func)(struct io_wq_work **))
{
         if (req->flags & REQ_F_WORK_INITIALIZED) {
                 if (!req->work.func)
                         req->work.func = func;
         } else {
                 req->work = (struct io_wq_work){ .func = func };
                 req->flags |= REQ_F_WORK_INITIALIZED;
         }
}

if we not pass NULL to parameter 'func', e.g. pass io_wq_submit_work, then
we can not use io_req_init_async() to pass io_close_finish again.

Now I'm confused how to write better codes based on current io_uring mainline codes :)
If you have some free time, please have a deeper look, thanks.

Regards,
Xiaoguang Wang


> 
