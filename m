Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D74311708
	for <lists+io-uring@lfdr.de>; Sat,  6 Feb 2021 00:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhBEXW7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Feb 2021 18:22:59 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:42452 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230493AbhBEJ6O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Feb 2021 04:58:14 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UNxEx-m_1612519048;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UNxEx-m_1612519048)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Feb 2021 17:57:28 +0800
Subject: Re: [PATCH 2/2] io_uring: don't hold uring_lock when calling
 io_run_task_work*
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612364276-26847-1-git-send-email-haoxu@linux.alibaba.com>
 <1612364276-26847-3-git-send-email-haoxu@linux.alibaba.com>
 <c97beeca-f401-3a21-5d8d-aa53a4292c03@gmail.com>
 <9b1d9e51-1b92-a651-304d-919693f9fb6f@gmail.com>
 <3668106c-5e80-50c8-6221-bdfa246c98ae@linux.alibaba.com>
 <f1a0bb32-6357-45e7-d4e4-c65c134f2229@gmail.com>
 <343f70ec-4c41-ed73-564e-494fca895e90@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <150de65e-0f6a-315a-376e-8e3fcf07ce1a@linux.alibaba.com>
Date:   Fri, 5 Feb 2021 17:57:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <343f70ec-4c41-ed73-564e-494fca895e90@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/2/4 下午11:26, Pavel Begunkov 写道:
> 
> 
> On 04/02/2021 11:17, Pavel Begunkov wrote:
>> On 04/02/2021 03:25, Hao Xu wrote:
>>> 在 2021/2/4 上午12:45, Pavel Begunkov 写道:
>>>> On 03/02/2021 16:35, Pavel Begunkov wrote:
>>>>> On 03/02/2021 14:57, Hao Xu wrote:
>>>>>> This is caused by calling io_run_task_work_sig() to do work under
>>>>>> uring_lock while the caller io_sqe_files_unregister() already held
>>>>>> uring_lock.
>>>>>> we need to check if uring_lock is held by us when doing unlock around
>>>>>> io_run_task_work_sig() since there are code paths down to that place
>>>>>> without uring_lock held.
>>>>>
>>>>> 1. we don't want to allow parallel io_sqe_files_unregister()s
>>>>> happening, it's synchronised by uring_lock atm. Otherwise it's
>>>>> buggy.
>>> Here "since there are code paths down to that place without uring_lock held" I mean code path of io_ring_ctx_free().
>>
>> I guess it's to the 1/2, but let me outline the problem again:
>> if you have two tasks userspace threads sharing a ring, then they
>> can both and in parallel call syscall:files_unregeister. That's
>> a potential double percpu_ref_kill(&data->refs), or even worse.
>>
>> Same for 2, but racing for the table and refs.
> 
> There is a couple of thoughts for this:
> 
> 1. I don't like waiting without holding the lock in general, because
> someone can submit more reqs in-between and so indefinitely postponing
> the files_unregister.
Thanks, Pavel.
I thought this issue before, until I saw this in __io_uring_register:

   if (io_register_op_must_quiesce(opcode)) {
           percpu_ref_kill(&ctx->refs);

           /*
           ¦* Drop uring mutex before waiting for references to exit. If
           ¦* another thread is currently inside io_uring_enter() it might
           ¦* need to grab the uring_lock to make progress. If we hold it
           ¦* here across the drain wait, then we can deadlock. It's safe
           ¦* to drop the mutex here, since no new references will come in
           ¦* after we've killed the percpu ref.
           ¦*/
           mutex_unlock(&ctx->uring_lock);
           do {
                   ret = wait_for_completion_interruptible(&ctx->ref_comp);
                   if (!ret)
                           break;
                   ret = io_run_task_work_sig();
                   if (ret < 0)
                           break;
           } while (1);

           mutex_lock(&ctx->uring_lock);

           if (ret) {
                   percpu_ref_resurrect(&ctx->refs);
                   goto out_quiesce;
           }
   }

So now I guess the postponement issue also exits in the above code since
there could be another thread submiting reqs to the shared ctx(or we can 
say uring fd).

> 2. I wouldn't want to add checks for that in submission path.
> 
> So, a solution I think about is to wait under the lock, If we need to
> run task_works -- briefly drop the lock, run task_works and then do
> all unregister all over again. Keep an eye on refs, e.g. probably
> need to resurrect it.
> 
> Because we current task is busy nobody submits new requests on
> its behalf, and so there can't be infinite number of in-task_work
> reqs, and eventually it will just go wait/sleep forever (if not
> signalled) under the mutex, so we can a kind of upper bound on
> time.
> 
Do you mean sleeping with timeout rather than just sleeping? I think 
this works, I'll work on this and think about the detail.
But before addressing this issue, Should I first send a patch to just 
fix the deadlock issue?

Thanks,
Hao
>>
>>>>
>>>> This one should be simple, alike to
>>>>
>>>> if (percpu_refs_is_dying())
>>>>      return error; // fail *files_unregister();
>>>>
>>>>>
>>>>> 2. probably same with unregister and submit.
>>>>>
>>>>>>
>>>>>> Reported-by: Abaci <abaci@linux.alibaba.com>
>>>>>> Fixes: 1ffc54220c44 ("io_uring: fix io_sqe_files_unregister() hangs")
>>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>>>> ---
>>>>>>    fs/io_uring.c | 19 +++++++++++++------
>>>>>>    1 file changed, 13 insertions(+), 6 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>> index efb6d02fea6f..b093977713ee 100644
>>>>>> --- a/fs/io_uring.c
>>>>>> +++ b/fs/io_uring.c
>>>>>> @@ -7362,18 +7362,25 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx, bool locked)
>>>>>>          /* wait for all refs nodes to complete */
>>>>>>        flush_delayed_work(&ctx->file_put_work);
>>>>>> +    if (locked)
>>>>>> +        mutex_unlock(&ctx->uring_lock);
>>>>>>        do {
>>>>>>            ret = wait_for_completion_interruptible(&data->done);
>>>>>>            if (!ret)
>>>>>>                break;
>>>>>>            ret = io_run_task_work_sig();
>>>>>> -        if (ret < 0) {
>>>>>> -            percpu_ref_resurrect(&data->refs);
>>>>>> -            reinit_completion(&data->done);
>>>>>> -            io_sqe_files_set_node(data, backup_node);
>>>>>> -            return ret;
>>>>>> -        }
>>>>>> +        if (ret < 0)
>>>>>> +            break;
>>>>>>        } while (1);
>>>>>> +    if (locked)
>>>>>> +        mutex_lock(&ctx->uring_lock);
>>>>>> +
>>>>>> +    if (ret < 0) {
>>>>>> +        percpu_ref_resurrect(&data->refs);
>>>>>> +        reinit_completion(&data->done);
>>>>>> +        io_sqe_files_set_node(data, backup_node);
>>>>>> +        return ret;
>>>>>> +    }
>>>>>>          __io_sqe_files_unregister(ctx);
>>>>>>        nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
>>>>>>
>>>>>
>>>>
>>>
>>
> 

