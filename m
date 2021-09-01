Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A743FD73A
	for <lists+io-uring@lfdr.de>; Wed,  1 Sep 2021 11:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243670AbhIAJxA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Sep 2021 05:53:00 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:59328 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243721AbhIAJxA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Sep 2021 05:53:00 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UmvSa8n_1630489922;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UmvSa8n_1630489922)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 01 Sep 2021 17:52:02 +0800
Subject: Re: [RFC PATCH] io_uring: stop issue failed request to fix panic
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <b04adedd-a78a-634f-f28b-5840d5ec01df@linux.alibaba.com>
 <b2bd9fd0-736d-668f-7c32-3dda6f862758@gmail.com>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <88c0b5ca-134f-85e5-4e25-b2ea558c4061@linux.alibaba.com>
Date:   Wed, 1 Sep 2021 17:52:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b2bd9fd0-736d-668f-7c32-3dda6f862758@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2021/9/1 下午5:47, Pavel Begunkov wrote:
> On 9/1/21 10:39 AM, 王贇 wrote:
>> We observed panic:
>>   BUG: kernel NULL pointer dereference, address:0000000000000028
>>   [skip]
>>   Oops: 0000 [#1] SMP PTI
>>   CPU: 1 PID: 737 Comm: a.out Not tainted 5.14.0+ #58
>>   Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>>   RIP: 0010:vfs_fadvise+0x1e/0x80
>>   [skip]
>>   Call Trace:
>>    ? tctx_task_work+0x111/0x2a0
>>    io_issue_sqe+0x524/0x1b90
> 
> Most likely it was fixed yesterday. Can you try?
> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.15/io_uring
> 
> Or these two patches in particular
> 
> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.15/io_uring&id=c6d3d9cbd659de8f2176b4e4721149c88ac096d4
> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.15/io_uring&id=b8ce1b9d25ccf81e1bbabd45b963ed98b2222df8

Yup, it no longer panic :-)

Regards,
Michael Wang

> 
>> This is caused by io_wq_submit_work() calling io_issue_sqe()
>> on a failed fadvise request, and the io_init_req() return error
>> before initialize the file for it, lead into the panic when
>> vfs_fadvise() try to access 'req->file'.
>>
>> This patch add the missing check & handle for failed request
>> before calling io_issue_sqe().
>>
>> Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
>> ---
>>  fs/io_uring.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 6f35b12..bfec7bf 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2214,7 +2214,8 @@ static void io_req_task_submit(struct io_kiocb *req, bool *locked)
>>
>>  	io_tw_lock(ctx, locked);
>>  	/* req->task == current here, checking PF_EXITING is safe */
>> -	if (likely(!(req->task->flags & PF_EXITING)))
>> +	if (likely(!(req->task->flags & PF_EXITING) &&
>> +		   !(req->flags & REQ_F_FAIL)))
>>  		__io_queue_sqe(req);
>>  	else
>>  		io_req_complete_failed(req, -EFAULT);
>> @@ -6704,7 +6705,10 @@ static void io_wq_submit_work(struct io_wq_work *work)
>>
>>  	if (!ret) {
>>  		do {
>> -			ret = io_issue_sqe(req, 0);
>> +			if (likely(!(req->flags & REQ_F_FAIL)))
>> +				ret = io_issue_sqe(req, 0);
>> +			else
>> +				io_req_complete_failed(req, -EFAULT);
>>  			/*
>>  			 * We can get EAGAIN for polled IO even though we're
>>  			 * forcing a sync submission from here, since we can't
>>
> 
