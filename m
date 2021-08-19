Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AAF3F1F46
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 19:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhHSRkb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 13:40:31 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:37320 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229520AbhHSRka (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 13:40:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0Uk6goQf_1629394792;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uk6goQf_1629394792)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 20 Aug 2021 01:39:53 +0800
Subject: Re: [PATCH] io_uring: remove PF_EXITING checking in io_poll_rewait()
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <0d53b4d3-b388-bd82-05a6-d4815aafff49@kernel.dk>
 <71755898-060a-6975-88b8-164fc3fff366@linux.alibaba.com>
 <f2c01919-d8c8-3750-c926-13fbee14eed7@kernel.dk>
 <5df6fdf4-dc27-7ee5-d4d5-b48ab30c809c@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <29134d4d-99a6-949d-0df7-7e8ddfef9a27@linux.alibaba.com>
Date:   Fri, 20 Aug 2021 01:39:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <5df6fdf4-dc27-7ee5-d4d5-b48ab30c809c@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/20 上午1:36, Jens Axboe 写道:
> On 8/19/21 11:29 AM, Jens Axboe wrote:
>> On 8/19/21 11:26 AM, Hao Xu wrote:
>>> 在 2021/8/19 下午11:48, Jens Axboe 写道:
>>>> We have two checks of task->flags & PF_EXITING left:
>>>>
>>>> 1) In io_req_task_submit(), which is called in task_work and hence always
>>>>      in the context of the original task. That means that
>>>>      req->task == current, and hence checking ->flags is totally fine.
>>>>
>>>> 2) In io_poll_rewait(), where we need to stop re-arming poll to prevent
>>>>      it interfering with cancelation. Here, req->task is not necessarily
>>>>      current, and hence the check is racy. Use the ctx refs state instead
>>>>      to check if we need to cancel this request or not.
>>> Hi Jens,
>>> I saw cases that io_req_task_submit() and io_poll_rewait() in one
>>> function, why one is safe and the other one not? btw, it seems both two
>>> executes in task_work context..and task_work_add() may fail and then
>>> work goes to system_wq, is that case safe?
>>
>> io_req_task_submit() is guaranteed to be run in the task that is req->task,
>> io_poll_rewait() is not. The latter can get called from eg the poll
>> waitqueue handling, which is not run from the task in question.
> 
> Pavel nudged me, and in the 5.15 branch we actually only do run rewait
> from the task itself. So this patch isn't needed, we can ignore it!
> Might just augment it with a comment, like it was done for submit.
saw this after my second email. cool!
> 

