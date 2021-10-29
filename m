Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4846043F712
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 08:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhJ2GVM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 02:21:12 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:38973 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231774AbhJ2GVL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 02:21:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uu5jT6u_1635488321;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uu5jT6u_1635488321)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Oct 2021 14:18:42 +0800
Subject: Re: [PATCH for-5.16 v3 0/8] task work optimization
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211027140216.20008-1-haoxu@linux.alibaba.com>
 <da85ab25-a6c6-f6a7-e2d5-d9a13c4dcf2f@gmail.com>
 <7a528ce1-a44e-3ee7-095c-1a92528ec441@linux.alibaba.com>
 <a1acf557-e2d6-8beb-0108-f38e824e16ba@linux.alibaba.com>
 <d7bbf237-9c91-c971-246d-46b91e4c89a3@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <4bc45226-8b27-500a-58e7-36da2eb5f92e@linux.alibaba.com>
Date:   Fri, 29 Oct 2021 14:18:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <d7bbf237-9c91-c971-246d-46b91e4c89a3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/29 上午3:08, Pavel Begunkov 写道:
> On 10/28/21 12:46, Hao Xu wrote:
>> 在 2021/10/28 下午2:07, Hao Xu 写道:
>>> 在 2021/10/28 上午2:15, Pavel Begunkov 写道:
>>>> On 10/27/21 15:02, Hao Xu wrote:
>>>>> Tested this patchset by manually replace __io_queue_sqe() in
>>>>> io_queue_sqe() by io_req_task_queue() to construct 'heavy' task works.
>>>>> Then test with fio:
>>>>
>>>> If submissions and completions are done by the same task it doesn't
>>>> really matter in which order they're executed because the task won't
>>>> get back to userspace execution to see CQEs until tw returns.
>>> It may matter, it depends on the time cost of submittion
>>> and the DMA IO time. Pick up sqpoll mode as example,
>>> we submit 10 reqs:
>>> t1          io_submit_sqes
>>>              -->io_req_task_queue
>>> t2          io_task_work_run
>>> we actually do the submittion in t2,  but if the workload
>>> is big engough, the 'irq completion TW' will be inserted
>>> to the TW list after t2 is fully done, then those
>>> 'irq completion TW' will be delayed to the next round.
>>> With this patchset, we can handle them first.
>>>> Furthermore, it even might be worse because the earlier you submit
>>>> the better with everything else equal.
>>>>
>>>> IIRC, that's how it's with fio, right? If so, you may get better
>>>> numbers with a test that does submissions and completions in
>>>> different threads.
>>> Because of the completion cache, I doubt if it works.
>>> For single ctx, it seems we always update the cqring
>>> pointer after all the TWs in the list are done.
>> I suddenly realized sqpoll mode does submissions and completions
>> in different threads, and in this situation this patchset always
>> first commit_cqring() after handling TWs in priority list.
>> So this is the right test, do I miss something?
> 
> Yep, should be it. So the scope of the feature is SQPOLL or
> completion/submission with different tasks.
 From the test results, it's a bit risk to apply this feature to
normal mode(no good, but have to ensure no bad), so I'd like to
apply it to sqpoll mode for now. For completion/submission
decoupled situation, maybe we can include it later.
> 
>>>>
>>>> Also interesting to find an explanation for you numbers assuming
>>> The reason may be what I said above, but I don't have a
>>> strict proof now.
>>>> they're stable. 7/8 batching? How often it does it go this path?
>>>> If only one task submits requests it should already be covered
>>>> with existing batching.
>>> the problem of the existing batch is(given there is only
>>> one ctx):
>>> 1. we flush it after all the TWs done
>>> 2. we batch them if we have uring lock.
>>> the new batch is:
>>> 1. don't care about uring lock
>>> 2. we can flush the completions in the priority list
>>>     in advance.(which means userland can see it earlier.)
>>>>
>>>>
>>>>> ioengine=io_uring
>>>>> sqpoll=1
>>>>> thread=1
>>>>> bs=4k
>>>>> direct=1
>>>>> rw=randread
>>>>> time_based=1
>>>>> runtime=600
>>>>> randrepeat=0
>>>>> group_reporting=1
>>>>> filename=/dev/nvme0n1
>>>>>
>>>>> 2/8 set unlimited priority_task_list, 8/8 set a limitation of
>>>>> 1/3 * (len_prority_list + len_normal_list), data below:
>>>>>     depth     no 8/8   include 8/8      before this patchset
>>>>>      1        7.05         7.82              7.10
>>>>>      2        8.47         8.48              8.60
>>>>>      4        10.42        9.99              10.42
>>>>>      8        13.78        13.13             13.22
>>>>>      16       27.41        27.92             24.33
>>>>>      32       49.40        46.16             53.08
>>>>>      64       102.53       105.68            103.36
>>>>>      128      196.98       202.76            205.61
>>>>>      256      372.99       375.61            414.88
>>>>>      512      747.23       763.95            791.30
>>>>>      1024     1472.59      1527.46           1538.72
>>>>>      2048     3153.49      3129.22           3329.01
>>>>>      4096     6387.86      5899.74           6682.54
>>>>>      8192     12150.25     12433.59          12774.14
>>>>>      16384    23085.58     24342.84          26044.71
>>>>>
>>>>> It seems 2/8 is better, haven't tried other choices other than 1/3,
>>>>> still put 8/8 here for people's further thoughts.
>>>>>
>>>>> Hao Xu (8):
>>>>>    io-wq: add helper to merge two wq_lists
>>>>>    io_uring: add a priority tw list for irq completion work
>>>>>    io_uring: add helper for task work execution code
>>>>>    io_uring: split io_req_complete_post() and add a helper
>>>>>    io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
>>>>>    io_uring: add nr_ctx to record the number of ctx in a task
>>>>>    io_uring: batch completion in prior_task_list
>>>>>    io_uring: add limited number of TWs to priority task list
>>>>>
>>>>>   fs/io-wq.h    |  21 +++++++
>>>>>   fs/io_uring.c | 168 
>>>>> +++++++++++++++++++++++++++++++++++---------------
>>>>>   2 files changed, 138 insertions(+), 51 deletions(-)
>>>>>
>>>>
>>
> 

