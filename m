Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC0730EAE3
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 04:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhBDD0J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Feb 2021 22:26:09 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:48732 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231553AbhBDD0I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Feb 2021 22:26:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UNoR0kx_1612409124;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UNoR0kx_1612409124)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 04 Feb 2021 11:25:24 +0800
Subject: Re: [PATCH 2/2] io_uring: don't hold uring_lock when calling
 io_run_task_work*
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612364276-26847-1-git-send-email-haoxu@linux.alibaba.com>
 <1612364276-26847-3-git-send-email-haoxu@linux.alibaba.com>
 <c97beeca-f401-3a21-5d8d-aa53a4292c03@gmail.com>
 <9b1d9e51-1b92-a651-304d-919693f9fb6f@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <3668106c-5e80-50c8-6221-bdfa246c98ae@linux.alibaba.com>
Date:   Thu, 4 Feb 2021 11:25:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <9b1d9e51-1b92-a651-304d-919693f9fb6f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/2/4 上午12:45, Pavel Begunkov 写道:
> On 03/02/2021 16:35, Pavel Begunkov wrote:
>> On 03/02/2021 14:57, Hao Xu wrote:
>>> This is caused by calling io_run_task_work_sig() to do work under
>>> uring_lock while the caller io_sqe_files_unregister() already held
>>> uring_lock.
>>> we need to check if uring_lock is held by us when doing unlock around
>>> io_run_task_work_sig() since there are code paths down to that place
>>> without uring_lock held.
>>
>> 1. we don't want to allow parallel io_sqe_files_unregister()s
>> happening, it's synchronised by uring_lock atm. Otherwise it's
>> buggy.
Here "since there are code paths down to that place without uring_lock 
held" I mean code path of io_ring_ctx_free().
> 
> This one should be simple, alike to
> 
> if (percpu_refs_is_dying())
> 	return error; // fail *files_unregister();
> 
>>
>> 2. probably same with unregister and submit.
>>
>>>
>>> Reported-by: Abaci <abaci@linux.alibaba.com>
>>> Fixes: 1ffc54220c44 ("io_uring: fix io_sqe_files_unregister() hangs")
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io_uring.c | 19 +++++++++++++------
>>>   1 file changed, 13 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index efb6d02fea6f..b093977713ee 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -7362,18 +7362,25 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx, bool locked)
>>>   
>>>   	/* wait for all refs nodes to complete */
>>>   	flush_delayed_work(&ctx->file_put_work);
>>> +	if (locked)
>>> +		mutex_unlock(&ctx->uring_lock);
>>>   	do {
>>>   		ret = wait_for_completion_interruptible(&data->done);
>>>   		if (!ret)
>>>   			break;
>>>   		ret = io_run_task_work_sig();
>>> -		if (ret < 0) {
>>> -			percpu_ref_resurrect(&data->refs);
>>> -			reinit_completion(&data->done);
>>> -			io_sqe_files_set_node(data, backup_node);
>>> -			return ret;
>>> -		}
>>> +		if (ret < 0)
>>> +			break;
>>>   	} while (1);
>>> +	if (locked)
>>> +		mutex_lock(&ctx->uring_lock);
>>> +
>>> +	if (ret < 0) {
>>> +		percpu_ref_resurrect(&data->refs);
>>> +		reinit_completion(&data->done);
>>> +		io_sqe_files_set_node(data, backup_node);
>>> +		return ret;
>>> +	}
>>>   
>>>   	__io_sqe_files_unregister(ctx);
>>>   	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
>>>
>>
> 

