Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD003235E0
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 03:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhBXCsg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 21:48:36 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:34727 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230371AbhBXCsU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 21:48:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UPPdGcT_1614134857;
Received: from 30.225.32.114(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UPPdGcT_1614134857)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Feb 2021 10:47:38 +0800
Subject: Re: [PATCH] io_uring: don't issue reqs in iopoll mode when ctx is
 dying
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20210206150006.1945-1-xiaoguang.wang@linux.alibaba.com>
 <e4220bf0-2d60-cdd8-c738-cf48236073fa@gmail.com>
 <3e3cb8da-d925-7ebd-11a0-f9e145861962@linux.alibaba.com>
 <f3081423-bdee-e7e4-e292-aa001f0937d1@gmail.com>
 <e185a388-9b7c-b01f-bcf9-2440d9024fd2@gmail.com>
 <754563ed-5b2b-075d-16f8-d980e51102e6@linux.alibaba.com>
 <215e12a6-1aa7-c56f-1349-bd3828b225f6@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <7f52ca3a-b456-582e-c3db-99d2d028042f@linux.alibaba.com>
Date:   Wed, 24 Feb 2021 10:45:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <215e12a6-1aa7-c56f-1349-bd3828b225f6@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 2/23/21 7:30 PM, Xiaoguang Wang wrote:
>> hi Pavel,
>>
>>> On 08/02/2021 13:35, Pavel Begunkov wrote:
>>>> On 08/02/2021 02:50, Xiaoguang Wang wrote:
>>>>>>> The io_identity's count is underflowed. It's because in io_put_identity,
>>>>>>> first argument tctx comes from req->task->io_uring, the second argument
>>>>>>> comes from the task context that calls io_req_init_async, so the compare
>>>>>>> in io_put_identity maybe meaningless. See below case:
>>>>>>>        task context A issue one polled req, then req->task = A.
>>>>>>>        task context B do iopoll, above req returns with EAGAIN error.
>>>>>>>        task context B re-issue req, call io_queue_async_work for req.
>>>>>>>        req->task->io_uring will set to task context B's identity, or cow new one.
>>>>>>> then for above case, in io_put_identity(), the compare is meaningless.
>>>>>>>
>>>>>>> IIUC, req->task should indicates the initial task context that issues req,
>>>>>>> then if it gets EAGAIN error, we'll call io_prep_async_work() in req->task
>>>>>>> context, but iopoll reqs seems special, they maybe issued successfully and
>>>>>>> got re-issued in other task context because of EAGAIN error.
>>>>>>
>>>>>> Looks as you say, but the patch doesn't solve the issue completely.
>>>>>> 1. We must not do io_queue_async_work() under a different task context,
>>>>>> because of it potentially uses a different set of resources. So, I just
>>>>>> thought that it would be better to punt it to the right task context
>>>>>> via task_work. But...
>>>>>>
>>>>>> 2. ...iovec import from io_resubmit_prep() might happen after submit ends,
>>>>>> i.e. when iovec was freed in userspace. And that's not great at all.
>>>>> Yes, agree, that's why I say we neeed to re-consider the io identity codes
>>>>> more in commit message :) I'll have a try to prepare a better one.
>>>>
>>>> I'd vote for dragging -AGAIN'ed reqs that don't need io_import_iovec()
>>>> through task_work for resubmission, and fail everything else. Not great,
>>>> but imho better than always setting async_data.
>>>
>>> Hey Xiaoguang, are you working on this? I would like to leave it to you,
>>> If you do.
>> Sorry, currently I'm busy with other project and don't have much time to work on
>> it yet. Hao Xu will help to continue work on the new version patch.
> 
> Is it issue or reissue? I found this one today:
> 
> https://lore.kernel.org/io-uring/c9f6e1f6-ff82-0e58-ab66-956d0cde30ff@kernel.dk/
Yeah, my initial patch is similar to yours, but it only solves the bug described
in my commit message partially(ctx is dying), you can have a look at my commit message
for the bug bug scene, thanks.

Regards,
Xiaoguang Wang


> 
