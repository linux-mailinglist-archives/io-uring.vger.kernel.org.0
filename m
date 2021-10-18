Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B11431A49
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 15:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhJRNDI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 09:03:08 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:43407 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231548AbhJRNDI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 09:03:08 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UsfL1ZJ_1634562054;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UsfL1ZJ_1634562054)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 18 Oct 2021 21:00:55 +0800
Subject: Re: [PATCH 1/2] io_uring: split logic of force_nonblock
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211018112923.16874-1-haoxu@linux.alibaba.com>
 <20211018112923.16874-2-haoxu@linux.alibaba.com>
 <eadf11e3-18d1-0cfa-cf03-9a540da3693c@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <230fed47-9552-36d7-447f-a1ac5a0a0481@linux.alibaba.com>
Date:   Mon, 18 Oct 2021 21:00:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <eadf11e3-18d1-0cfa-cf03-9a540da3693c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/18 下午8:27, Pavel Begunkov 写道:
> On 10/18/21 11:29, Hao Xu wrote:
>> Currently force_nonblock stands for three meanings:
>>   - nowait or not
>>   - in an io-worker or not(hold uring_lock or not)
>>
>> Let's split the logic to two flags, IO_URING_F_NONBLOCK and
>> IO_URING_F_UNLOCKED for convenience of the next patch.
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 50 ++++++++++++++++++++++++++++----------------------
>>   1 file changed, 28 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index b6da03c26122..727cad6c36fc 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -199,6 +199,7 @@ struct io_rings {
>>   enum io_uring_cmd_flags {
>>       IO_URING_F_COMPLETE_DEFER    = 1,
>> +    IO_URING_F_UNLOCKED        = 2,
>>       /* int's last bit, sign checks are usually faster than a bit 
>> test */
>>       IO_URING_F_NONBLOCK        = INT_MIN,
>>   };
>> @@ -2926,7 +2927,7 @@ static void kiocb_done(struct kiocb *kiocb, 
>> ssize_t ret,
>>               struct io_ring_ctx *ctx = req->ctx;
>>               req_set_fail(req);
>> -            if (!(issue_flags & IO_URING_F_NONBLOCK)) {
>> +            if (issue_flags & IO_URING_F_UNLOCKED) {
>>                   mutex_lock(&ctx->uring_lock);
>>                   __io_req_complete(req, issue_flags, ret, cflags);
>>                   mutex_unlock(&ctx->uring_lock);
>> @@ -3036,7 +3037,7 @@ static struct io_buffer *io_buffer_select(struct 
>> io_kiocb *req, size_t *len,
>>   {
>>       struct io_buffer *kbuf = req->kbuf;
>>       struct io_buffer *head;
>> -    bool needs_lock = !(issue_flags & IO_URING_F_NONBLOCK);
>> +    bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
>>       if (req->flags & REQ_F_BUFFER_SELECTED)
>>           return kbuf;
>> @@ -3341,7 +3342,7 @@ static inline int io_rw_prep_async(struct 
>> io_kiocb *req, int rw)
>>       int ret;
>>       /* submission path, ->uring_lock should already be taken */
>> -    ret = io_import_iovec(rw, req, &iov, &iorw->s, IO_URING_F_NONBLOCK);
>> +    ret = io_import_iovec(rw, req, &iov, &iorw->s, 0);
>>       if (unlikely(ret < 0))
>>           return ret;
>> @@ -3452,6 +3453,7 @@ static int io_read(struct io_kiocb *req, 
>> unsigned int issue_flags)
>>       struct iovec *iovec;
>>       struct kiocb *kiocb = &req->rw.kiocb;
>>       bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>> +    bool in_worker = issue_flags & IO_URING_F_UNLOCKED;
> 
> io_read shouldn't have notion of worker or whatever. I'd say let's
> leave only force_nonblock here.
> 
> I assume 2/2 relies ot it, but if so you can make sure it ends up
> in sync (!force_nonblock) at some point if all other ways fail.
I re-read the code, found you're right, will send v3.
