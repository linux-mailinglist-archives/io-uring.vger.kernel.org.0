Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D90375BA0
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 21:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhEFTVZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 15:21:25 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:43672 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230375AbhEFTVY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 15:21:24 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UY-T64p_1620328824;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UY-T64p_1620328824)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 07 May 2021 03:20:24 +0800
Subject: Re: [PATCH RFC 5.13] io_uring: add IORING_REGISTER_PRIORITY
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1620311593-46083-1-git-send-email-haoxu@linux.alibaba.com>
 <38e587bb-a484-24dc-1ea9-cc252b1639ba@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <92da0bd6-3de9-eedd-fca7-87d8ad99ba70@linux.alibaba.com>
Date:   Fri, 7 May 2021 03:20:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <38e587bb-a484-24dc-1ea9-cc252b1639ba@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/5/7 上午1:10, Jens Axboe 写道:
> On 5/6/21 8:33 AM, Hao Xu wrote:
>> Users may want a higher priority for sq_thread or io-worker. Provide a
>> way to change the nice value(for SCHED_NORMAL) or scheduling policy.
> 
> Silly question - why is this needed for sqpoll? With the threads now
> being essentially user threads, why can't we just modify nice and
> scheduler class from userspace instead? That should work now. I think
> this is especially true for sqpoll where it's persistent, and argument
> could be made for the io-wq worker threads that we'd need io_uring
> support for that, as they come and go and there's no reliable way to
> find and tweak the thread scheduler settings for that particular use
> case.
> 
> It may be more convenient to support this through io_uring, and that is
> a valid argument. I do think that the better way would then be to simply
> pass back the sqpoll pid after ring setup, because then it'd almost be
> as simple to do it from the app itself using the regular system call
> interfaces for that.
> 
Hi Jens,
It's my bad. I didn't realize this until I almost completed the patch,
then I looked into io_uring_param, found just __u32 resv[3] can be
leveraged. Not sure if it's neccessary to occupy one to do this, so I
still sent this patch for comments.
> In summary, I do think this _may_ make sense for the worker threads,
> being able to pass in this information and have io-wq worker thread
> setup perform the necessary tweaks when a thread is created, but it does
I'm working on this(for the io-wq worker), have done part of it.
> seem a bit silly to add this for sqpoll where it could just as easily be
> achieved from the application itself without needing to add this
It's beyond my knowledge, correct me if I'm wrong: if we do
it from application, we have to search the pid of sq_thread by it's name
which is iou-sqp-`sqd->task_pid`, and may be cut off because of
TASK_COMM_LEN(would this macro value be possibly changed in the
future?). And set_task_comm() is called when sq_thread runs, so there is
very small chance(but there is) that set_task_comm() hasn't been called
when application try to get the command name of sq_thread. Based on this
(if it is not wrong...) I think return pid of sq_thread in io_uring
level may be a better choice.

Regards,
Hao
> support.
> 
> What do you think?
> 

