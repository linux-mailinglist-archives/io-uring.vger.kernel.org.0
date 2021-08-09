Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF013E3EA5
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 06:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhHIEIH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 00:08:07 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:55907 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230365AbhHIEIG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 00:08:06 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UiM6Ee7_1628482064;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UiM6Ee7_1628482064)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 09 Aug 2021 12:07:45 +0800
Subject: Re: [PATCH 1/2] io_uring: clear TIF_NOTIFY_SIGNAL when running task
 work
To:     Nadav Amit <namit@vmware.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210808001342.964634-1-namit@vmware.com>
 <20210808001342.964634-2-namit@vmware.com>
 <488f005c-fd92-9881-2700-b2eb1adbb78e@gmail.com>
 <40885F33-F35D-49E9-A79F-DB3C35278F73@vmware.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <8825c48c-3574-c76f-4ff2-e68aaf657cda@linux.alibaba.com>
Date:   Mon, 9 Aug 2021 12:07:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <40885F33-F35D-49E9-A79F-DB3C35278F73@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/9 上午1:31, Nadav Amit 写道:
> 
> 
>> On Aug 8, 2021, at 5:55 AM, Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 8/8/21 1:13 AM, Nadav Amit wrote:
>>> From: Nadav Amit <namit@vmware.com>
>>>
>>> When using SQPOLL, the submission queue polling thread calls
>>> task_work_run() to run queued work. However, when work is added with
>>> TWA_SIGNAL - as done by io_uring itself - the TIF_NOTIFY_SIGNAL remains
>>
>> static int io_req_task_work_add(struct io_kiocb *req)
>> {
>> 	...
>> 	notify = (req->ctx->flags & IORING_SETUP_SQPOLL) ? TWA_NONE : TWA_SIGNAL;
>> 	if (!task_work_add(tsk, &tctx->task_work, notify))
>> 	...
>> }
>>
>> io_uring doesn't set TIF_NOTIFY_SIGNAL for SQPOLL. But if you see it, I'm
>> rather curious who does.
> 
> I was saying io-uring, but I meant io-uring in the wider sense:
> io_queue_worker_create().
> 
> Here is a call trace for when TWA_SIGNAL is used. io_queue_worker_create()
> uses TWA_SIGNAL. It is called by io_wqe_dec_running(), and not shown due
> to inlining:
Hi Nadav, Pavel,
How about trying to make this kind of call to use TWA_NONE for sqthread,
though I know for this case currently there is no info to get to know if
task is sqthread. I think we shouldn't kick sqthread.

regards,
Hao
> 
> [   70.540761] Call Trace:
> [   70.541352]  dump_stack+0x7d/0x9c
> [   70.541930]  task_work_add.cold+0x9/0x12
> [   70.542591]  io_wqe_dec_running+0xd6/0xf0
> [   70.543259]  io_wq_worker_sleeping+0x3d/0x60
> [   70.544106]  schedule+0xa0/0xc0
> [   70.544673]  userfaultfd_read_iter+0x2c3/0x790
> [   70.545374]  ? wake_up_q+0xa0/0xa0
> [   70.545887]  io_iter_do_read+0x1e/0x40
> [   70.546531]  io_read+0xdc/0x340
> [   70.547148]  ? update_curr+0x72/0x1c0
> [   70.547887]  ? update_load_avg+0x7c/0x600
> [   70.548538]  ? __switch_to_xtra+0x10a/0x500
> [   70.549264]  io_issue_sqe+0xd99/0x1840
> [   70.549887]  ? lock_timer_base+0x72/0xa0
> [   70.550516]  ? try_to_del_timer_sync+0x54/0x80
> [   70.551224]  io_wq_submit_work+0x87/0xb0
> [   70.552001]  io_worker_handle_work+0x2b5/0x4b0
> [   70.552705]  io_wqe_worker+0xd6/0x2f0
> [   70.553364]  ? recalc_sigpending+0x1c/0x50
> [   70.554074]  ? io_worker_handle_work+0x4b0/0x4b0
> [   70.554813]  ret_from_fork+0x22/0x30
> 
> Does it answer your question?
> 

