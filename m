Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B2142893A
	for <lists+io-uring@lfdr.de>; Mon, 11 Oct 2021 10:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbhJKI5I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Oct 2021 04:57:08 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:50620 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235163AbhJKI5H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Oct 2021 04:57:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UrOCGrW_1633942505;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UrOCGrW_1633942505)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 11 Oct 2021 16:55:06 +0800
Subject: Re: [PATCH 2/2] io_uring: implementation of IOSQE_ASYNC_HYBRID logic
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211008123642.229338-1-haoxu@linux.alibaba.com>
 <20211008123642.229338-3-haoxu@linux.alibaba.com>
 <0c0f713e-f1ef-5798-f38f-18ef8358eb6b@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <e4a831b2-ca0a-5c8d-1ce2-c8b734ec0ed4@linux.alibaba.com>
Date:   Mon, 11 Oct 2021 16:55:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <0c0f713e-f1ef-5798-f38f-18ef8358eb6b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/9 下午8:46, Pavel Begunkov 写道:
> On 10/8/21 13:36, Hao Xu wrote:
>> The process of this kind of requests is:
>>
>> step1: original context:
>>             queue it to io-worker
>> step2: io-worker context:
>>             nonblock try(the old logic is a synchronous try here)
>>                 |
>>                 |--fail--> arm poll
>>                              |
>>                              |--(fail/ready)-->synchronous issue
>>                              |
>>                              |--(succeed)-->worker finish it's job, tw
>>                                             take over the req
>>
>> This works much better than IOSQE_ASYNC in cases where cpu resources
>> are scarce or unbound max_worker is small. In these cases, number of
>> io-worker eazily increments to max_worker, new worker cannot be created
>> and running workers stuck there handling old works in IOSQE_ASYNC mode.
>>
>> In my machine, set unbound max_worker to 20, run echo-server, turns out:
>> (arguments: register_file, connetion number is 1000, message size is 12
>> Byte)
>> IOSQE_ASYNC: 76664.151 tps
>> IOSQE_ASYNC_HYBRID: 166934.985 tps
>>
>> Suggested-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 42 ++++++++++++++++++++++++++++++++++++++----
>>   1 file changed, 38 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index a99f7f46e6d4..024cef09bc12 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1409,7 +1409,7 @@ static void io_prep_async_work(struct io_kiocb 
>> *req)
>>       req->work.list.next = NULL;
>>       req->work.flags = 0;
>> -    if (req->flags & REQ_F_FORCE_ASYNC)
>> +    if (req->flags & (REQ_F_FORCE_ASYNC | REQ_F_ASYNC_HYBRID))
>>           req->work.flags |= IO_WQ_WORK_CONCURRENT;
>>       if (req->flags & REQ_F_ISREG) {
>> @@ -5575,7 +5575,13 @@ static int io_arm_poll_handler(struct io_kiocb 
>> *req)
>>       req->apoll = apoll;
>>       req->flags |= REQ_F_POLLED;
>>       ipt.pt._qproc = io_async_queue_proc;
>> -    io_req_set_refcount(req);
>> +    /*
>> +     * REQ_F_REFCOUNT set indicate we are in io-worker context, where we
> 
> Nope, it indicates that needs more complex refcounting. It includes linked
> timeouts but also poll because of req_ref_get for double poll. fwiw, with
> some work it can be removed for polls, harder (and IMHO not necessary) 
> to do
> for timeouts.Agree, I now realize that the explanation I put here is not good at all,
I actually want to say that the io-worker already set refs = 2 (also
possible that prep_link_out set 1, and io-worker adds the other 1,
previously I miss this situation). One will be put at completion time,
the other one will be put in io_wq_free_work(). So no need to set the
refcount here again. I looked into io_req_set_refcount(), since it does
nothing if refcount is already not zero, I should be ok to keep this one
as it was.
> 
>> +     * already explicitly set the submittion and completion ref. So no
> 
> I'd say there is no notion of submission vs completion refs anymore.
> 
>> +     * need to set refcount here if that is the case.
>> +     */
>> +    if (!(req->flags & REQ_F_REFCOUNT))
> 
> Compare it with io_req_set_refcount(), that "if" is a a no-op
> 
>> +        io_req_set_refcount(req);
>>       ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
>>                       io_async_wake);
>> @@ -6704,8 +6710,11 @@ static void io_wq_submit_work(struct io_wq_work 
>> *work)
>>           ret = -ECANCELED;
>>       if (!ret) {
>> +        bool need_poll = req->flags & REQ_F_ASYNC_HYBRID;
>> +
>>           do {
>> -            ret = io_issue_sqe(req, 0);
>> +issue_sqe:
>> +            ret = io_issue_sqe(req, need_poll ? IO_URING_F_NONBLOCK : 
>> 0);
> 
> It's buggy, you will get all kinds of kernel crashes and leaks.
> Currently IO_URING_F_NONBLOCK has dual meaning: obvious nonblock but
> also whether we hold uring_lock or not. You'd need to split the flag
> into two, i.e. IO_URING_F_LOCKED
I'll look into it. I was thinking about to do the first nowait try in
the original context, but then I thought it doesn't make sense to bring
up a worker just for poll infra arming since thread creating and
scheduling has its overhead.
> 

