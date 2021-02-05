Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E76C3105C9
	for <lists+io-uring@lfdr.de>; Fri,  5 Feb 2021 08:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhBEHX5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Feb 2021 02:23:57 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:52951 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230486AbhBEHXz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Feb 2021 02:23:55 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UNwaEfj_1612509662;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UNwaEfj_1612509662)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Feb 2021 15:21:03 +0800
Subject: Re: Queston about io_uring_flush
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <63d16aae-1ca7-8939-1c8a-89c600be8462@linux.alibaba.com>
 <51499dcc-5991-e177-98c4-8cc8a909da70@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <21456ca2-f5e6-9c93-b42b-697aba82cce7@linux.alibaba.com>
Date:   Fri, 5 Feb 2021 15:21:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <51499dcc-5991-e177-98c4-8cc8a909da70@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/2/4 下午7:00, Pavel Begunkov 写道:
> On 04/02/2021 09:31, Hao Xu wrote:
>> Hi all,
>> Sorry for disturb all of you. Here comes my question.
>> When we close a uring file, we go into io_uring_flush(),
>> there is codes at the end:
>>
>> if (!(ctx->flags & IORING_SETUP_SQPOLL) || ctx->sqo_task == current)
>>     io_uring_del_task_file(file);
>>
>> My understanding, this is to delete the ctx(associated with the uring
>> file) from current->io_uring->xa.
>> I'm thinking of this scenario: the task to close uring file is not the
>> one which created the uring file.
>> Then it doesn't make sense to delete the uring file from current->io_uring->xa. It should be "delete uring file from
>> ctx->sqo_task->io_uring->xa" instead.
> 
> 1. It's not only about created or not, look for
> io_uring_add_task_file() call sites.
> 
> 2. io_uring->xa is basically a map from task to used by it urings.
> Every user task should clean only its own context (SQPOLL task is
> a bit different), it'll be hell bunch of races otherwise.
> 
> 3. If happens that it's closed by a task that has nothing to do
> with this ctx, then it won't find anything in its
> task->io_uring->xa, and so won't delete anything, and that's ok.
> io_uring->xa of sqo_task will be cleaned by sqo_task, either
> on another close() or on exit() (see io_uring_files_cancel).
> 
> 4. There is a bunch of cases where that scheme doesn't behave
> nice, but at least should not leak/fault when all related tasks
> are killed.
> 
Thank you Pavel for the detail explanation. I got it, basically
just delay the clean work to sqo_task.
I have this question since I'm looking into the tctx->inflight, it 
puzzles me a little bit. When a task exit(), it finally calls
  __io_uring_task_cancel(), where we wait until tctx->inflight is 0.
What does tctx->inflight actually mean? I thought it stands for all
the inflight reqs of ctxs of this task. But in tctx_inflight():

   /*
    * If we have SQPOLL rings, then we need to iterate and find them, and
    * add the pending count for those.
    */
   xa_for_each(&tctx->xa, index, file) {
           struct io_ring_ctx *ctx = file->private_data;

           if (ctx->flags & IORING_SETUP_SQPOLL) {
                   struct io_uring_task *__tctx = ctx->sqo_task->io_uring;

                   inflight += percpu_counter_sum(&__tctx->inflight);
           }
   }

Why it adds ctx->sqo_task->io_uring->inflight.
In a scenario like this:
	taskA->tctx:    ctx0    ctx1
		     sqpoll     normal

Since ctx0->sqo_task is taskA, so isn't taskA->io_uring->inflight 
calculated twice?
In another hand, count of requests submited by sqthread will be added to 
sqthread->io_uring, do we ommit this part？with that being said, should 
taskA wait for sqes/reqs created by taskA but handled by sqthread?
