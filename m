Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C55B468B9A
	for <lists+io-uring@lfdr.de>; Sun,  5 Dec 2021 16:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235221AbhLEPOl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Dec 2021 10:14:41 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:12331 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235126AbhLEPOl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Dec 2021 10:14:41 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UzSGBDd_1638717071;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UzSGBDd_1638717071)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 05 Dec 2021 23:11:12 +0800
Subject: Re: [PATCH v6 0/6] task work optimization
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211126100740.196550-1-haoxu@linux.alibaba.com>
 <7184b704-5996-e3b5-a277-7a4f446b2f82@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <e6c2a875-d853-c1f8-8e1e-96b4c7cd2e88@linux.alibaba.com>
Date:   Sun, 5 Dec 2021 23:11:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <7184b704-5996-e3b5-a277-7a4f446b2f82@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/12/5 上午4:58, Pavel Begunkov 写道:
> On 11/26/21 10:07, Hao Xu wrote:
>> v4->v5
>> - change the implementation of merge_wq_list
>>
>> v5->v6
>> - change the logic of handling prior task list to:
>>    1) grabbed uring_lock: leverage the inline completion infra
>>    2) otherwise: batch __req_complete_post() calls to save
>>       completion_lock operations.
> 
> FYI, took 5/6 into another patchset to avoid conflicts.
> 
> also, you can remove "[pavel: ...]" from patches, I was just
> leaving them as a hint that the patches were very slightly
> modified. I'll retest/etc. once you fix 6/6. Hopefully, will
> be merged soon, the patches already had been bouncing around
> for too long.
Gotcha.
> 
> 
>> Hao Xu (6):
>>    io-wq: add helper to merge two wq_lists
>>    io_uring: add a priority tw list for irq completion work
>>    io_uring: add helper for task work execution code
>>    io_uring: split io_req_complete_post() and add a helper
>>    io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
>>    io_uring: batch completion in prior_task_list
>>
>>   fs/io-wq.h    |  22 +++++++
>>   fs/io_uring.c | 168 ++++++++++++++++++++++++++++++++++----------------
>>   2 files changed, 136 insertions(+), 54 deletions(-)
>>
> 

