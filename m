Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087AB30EB00
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 04:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhBDDfG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Feb 2021 22:35:06 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:33203 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231177AbhBDDfD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Feb 2021 22:35:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UNoeK4-_1612409657;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UNoeK4-_1612409657)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 04 Feb 2021 11:34:17 +0800
Subject: Re: [PATCH 1/2] io_uring: add uring_lock as an argument to
 io_sqe_files_unregister()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612364276-26847-1-git-send-email-haoxu@linux.alibaba.com>
 <1612364276-26847-2-git-send-email-haoxu@linux.alibaba.com>
 <976179ed-6013-3cd7-46a0-aa3201444ac4@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <a6827c98-c4f6-a0fd-6453-1351c654c3a5@linux.alibaba.com>
Date:   Thu, 4 Feb 2021 11:34:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <976179ed-6013-3cd7-46a0-aa3201444ac4@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/2/4 上午12:33, Pavel Begunkov 写道:
> On 03/02/2021 14:57, Hao Xu wrote:
>> io_sqe_files_unregister is currently called from several places:
>>      - syscall io_uring_register (with uring_lock)
>>      - io_ring_ctx_wait_and_kill() (without uring_lock)
>>
>> There is a AA type deadlock in io_sqe_files_unregister(), thus we need
>> to know if we hold uring_lock in io_sqe_files_unregister() to fix the
>> issue.
> 
> It's ugly, just take the lock and kill the patch. There can't be any
> contention during io_ring_ctx_free anyway.
Hi Pavel, I don't get it, do you mean this patch isn't needed, and we 
can just unlock(&uring_lock) before io_run_task_work_sig() and 
lock(&uring_lock) after it? I knew there won't be contention during 
io_ring_ctx_free that's why there is no uring_lock in it.
I tried to just do unlock(&uring_lock) before io_run_task_sig() without 
if(locked) check, it reports something like "there are unpaired mutex 
lock/unlock" since we cannot just unlock if it's from io_ring_ctx_free.
> 
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 38c6cbe1ab38..efb6d02fea6f 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -7339,7 +7339,7 @@ static void io_sqe_files_set_node(struct fixed_file_data *file_data,
>>   	percpu_ref_get(&file_data->refs);
>>   }
>>   
>> -static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>> +static int io_sqe_files_unregister(struct io_ring_ctx *ctx, bool locked)
>>   {
>>   	struct fixed_file_data *data = ctx->file_data;
>>   	struct fixed_file_ref_node *backup_node, *ref_node = NULL;
>> @@ -7872,13 +7872,13 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>>   
>>   	ret = io_sqe_files_scm(ctx);
>>   	if (ret) {
>> -		io_sqe_files_unregister(ctx);
>> +		io_sqe_files_unregister(ctx, true);
>>   		return ret;
>>   	}
>>   
>>   	ref_node = alloc_fixed_file_ref_node(ctx);
>>   	if (!ref_node) {
>> -		io_sqe_files_unregister(ctx);
>> +		io_sqe_files_unregister(ctx, true);
>>   		return -ENOMEM;
>>   	}
>>   
>> @@ -8682,7 +8682,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
>>   		css_put(ctx->sqo_blkcg_css);
>>   #endif
>>   
>> -	io_sqe_files_unregister(ctx);
>> +	io_sqe_files_unregister(ctx, false);
>>   	io_eventfd_unregister(ctx);
>>   	io_destroy_buffers(ctx);
>>   	idr_destroy(&ctx->personality_idr);
>> @@ -10065,7 +10065,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>>   		ret = -EINVAL;
>>   		if (arg || nr_args)
>>   			break;
>> -		ret = io_sqe_files_unregister(ctx);
>> +		ret = io_sqe_files_unregister(ctx, true);
>>   		break;
>>   	case IORING_REGISTER_FILES_UPDATE:
>>   		ret = io_sqe_files_update(ctx, arg, nr_args);
>>
> 

