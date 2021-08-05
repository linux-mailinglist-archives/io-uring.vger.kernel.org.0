Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A73A3E1A8A
	for <lists+io-uring@lfdr.de>; Thu,  5 Aug 2021 19:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239635AbhHERhT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Aug 2021 13:37:19 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:55670 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239498AbhHERhT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Aug 2021 13:37:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Ui3wcfC_1628185022;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Ui3wcfC_1628185022)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Aug 2021 01:37:03 +0800
Subject: Re: [PATCH 1/3] io-wq: clean code of task state setting
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210805100538.127891-1-haoxu@linux.alibaba.com>
 <20210805100538.127891-2-haoxu@linux.alibaba.com>
 <cb24ad6d-cbab-a424-db7a-6a5e1f2feb74@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <36502b3d-bc15-53ea-6dda-789d92891873@linux.alibaba.com>
Date:   Fri, 6 Aug 2021 01:37:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <cb24ad6d-cbab-a424-db7a-6a5e1f2feb74@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/5 下午10:23, Jens Axboe 写道:
> On 8/5/21 4:05 AM, Hao Xu wrote:
>> We don't need to set task state to TASK_INTERRUPTIBLE at the beginning
>> of while() in io_wqe_worker(), which causes state resetting to
>> TASK_RUNNING in other place. Move it to above schedule_timeout() and
>> remove redundant task state settings.
> 
> Not sure that is safe - the reason why the state is manipulated is to
> guard from races where we do:
> 
> A				B
> if (!work_available)
> 				Work inserted
> schedule();
> 
You are right, the patch does bring in races. Though B will then create 
an io-worker in that race condition, but that causes delay. Thanks Jens!
> As long as setting the task runnable is part of the work being inserted,
> then the above race is fine, as the schedule() turns into a no-op.
> 

