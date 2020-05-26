Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4B11E24CD
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 16:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgEZO7V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 10:59:21 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:40610 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728110AbgEZO7V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 10:59:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TzjkD-m_1590505159;
Received: from 30.0.168.64(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TzjkD-m_1590505159)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 26 May 2020 22:59:19 +0800
Subject: Re: [PATCH 1/3] io_uring: don't use req->work.creds for inline
 requests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200526064330.9322-1-xiaoguang.wang@linux.alibaba.com>
 <fe4196c6-a069-a029-6a98-68801d088798@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <06081761-4aef-6423-ac70-97c62a7c0e5c@linux.alibaba.com>
Date:   Tue, 26 May 2020 22:59:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <fe4196c6-a069-a029-6a98-68801d088798@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 26/05/2020 09:43, Xiaoguang Wang wrote:
>> In io_init_req(), if uers requires a new credentials, currently we'll
>> save it in req->work.creds, but indeed io_wq_work is designed to describe
>> needed running environment for requests that will go to io-wq, if one
>> request is going to be submitted inline, we'd better not touch io_wq_work.
>> Here add a new 'const struct cred *creds' in io_kiocb, if uers requires a
>> new credentials, inline requests can use it.
>>
>> This patch is also a preparation for later patch.
> 
> What's the difference from keeping only one creds field in io_kiocb (i.e.
> req->work.creds), but handling it specially (i.e. always initialising)? It will
> be a lot easier than tossing it around.
> 
> Also, the patch doubles {get,put}_creds() for sqe->personality case, and that's
> extra atomics without a good reason.
You're right, thanks.
The original motivation for this patch is that it's just a preparation later patch
"io_uring: avoid whole io_wq_work copy for inline requests", I can use io_wq_work.func
to determine whether to drop io_wq_work in io_req_work_drop_env(), so if io_wq_work.func
is NULL, I don't want io_wq_work has a valid creds.
I'll look into whether we can just assign req->creds's pointer to io_wq_work.creds to
reduce the atomic operations.

Regards,
Xiaoguang Wang

> 
>>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 23 +++++++++++++++--------
>>   1 file changed, 15 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 2af87f73848e..788d960abc69 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -635,6 +635,7 @@ struct io_kiocb {
>>   	unsigned int		flags;
>>   	refcount_t		refs;
>>   	struct task_struct	*task;
>> +	const struct cred	*creds;
>>   	unsigned long		fsize;
>>   	u64			user_data;
>>   	u32			result;
>> @@ -1035,8 +1036,10 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
>>   		mmgrab(current->mm);
>>   		req->work.mm = current->mm;
>>   	}
>> -	if (!req->work.creds)
>> +	if (!req->creds)
>>   		req->work.creds = get_current_cred();
>> +	else
>> +		req->work.creds = get_cred(req->creds);
>>   	if (!req->work.fs && def->needs_fs) {
>>   		spin_lock(&current->fs->lock);
>>   		if (!current->fs->in_exec) {
>> @@ -1368,6 +1371,9 @@ static void __io_req_aux_free(struct io_kiocb *req)
>>   	if (req->flags & REQ_F_NEED_CLEANUP)
>>   		io_cleanup_req(req);
>>   
>> +	if (req->creds)
>> +		put_cred(req->creds);
>> +
>>   	kfree(req->io);
>>   	if (req->file)
>>   		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
>> @@ -5673,13 +5679,13 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   again:
>>   	linked_timeout = io_prep_linked_timeout(req);
>>   
>> -	if (req->work.creds && req->work.creds != current_cred()) {
>> +	if (req->creds && req->creds != current_cred()) {
>>   		if (old_creds)
>>   			revert_creds(old_creds);
>> -		if (old_creds == req->work.creds)
>> +		if (old_creds == req->creds)
>>   			old_creds = NULL; /* restored original creds */
>>   		else
>> -			old_creds = override_creds(req->work.creds);
>> +			old_creds = override_creds(req->creds);
>>   	}
>>   
>>   	ret = io_issue_sqe(req, sqe, true);
>> @@ -5970,11 +5976,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>   
>>   	id = READ_ONCE(sqe->personality);
>>   	if (id) {
>> -		req->work.creds = idr_find(&ctx->personality_idr, id);
>> -		if (unlikely(!req->work.creds))
>> +		req->creds = idr_find(&ctx->personality_idr, id);
>> +		if (unlikely(!req->creds))
>>   			return -EINVAL;
>> -		get_cred(req->work.creds);
>> -	}
>> +		get_cred(req->creds);
>> +	} else
>> +		req->creds = NULL;
>>   
>>   	/* same numerical values with corresponding REQ_F_*, safe to copy */
>>   	req->flags |= sqe_flags;
>>
> 
