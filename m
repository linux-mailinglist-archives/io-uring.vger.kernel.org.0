Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFE83323DE
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 12:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhCILYh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 06:24:37 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13586 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhCILYF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 06:24:05 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dvt8m0WCHz16G9C;
        Tue,  9 Mar 2021 19:22:16 +0800 (CST)
Received: from [10.174.177.143] (10.174.177.143) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Mar 2021 19:23:53 +0800
Subject: Re: [PATCH 5.12] io_uring: Convert personality_idr to XArray
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, <io-uring@vger.kernel.org>
CC:     Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>, <yi.zhang@huawei.com>
References: <7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com>
 <803bad80-093a-5fbf-7677-754c9afad530@gmail.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <8b553635-b3d9-cb36-34f0-83777bec94ab@huawei.com>
Date:   Tue, 9 Mar 2021 19:23:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <803bad80-093a-5fbf-7677-754c9afad530@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.143]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



在 2021/3/8 22:22, Pavel Begunkov 写道:
> On 08/03/2021 14:16, Pavel Begunkov wrote:
>> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>>
>> You can't call idr_remove() from within a idr_for_each() callback,
>> but you can call xa_erase() from an xa_for_each() loop, so switch the
>> entire personality_idr from the IDR to the XArray.  This manifests as a
>> use-after-free as idr_for_each() attempts to walk the rest of the node
>> after removing the last entry from it.
> 
> yangerkun, can you test it and similarly take care of buffer idr?

Will try it latter :)

> 
> 
>>
>> Fixes: 071698e13ac6 ("io_uring: allow registering credentials")
>> Cc: stable@vger.kernel.org # 5.6+
>> Reported-by: yangerkun <yangerkun@huawei.com>
>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> [Pavel: rebased (creds load was moved into io_init_req())]
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   fs/io_uring.c | 47 ++++++++++++++++++++++++-----------------------
>>   1 file changed, 24 insertions(+), 23 deletions(-)
>>
>> p.s. passes liburing tests well
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 5ef9f836cccc..5505e19f1391 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -407,7 +407,8 @@ struct io_ring_ctx {
>>   
>>   	struct idr		io_buffer_idr;
>>   
>> -	struct idr		personality_idr;
>> +	struct xarray		personalities;
>> +	u32			pers_next;
>>   
>>   	struct {
>>   		unsigned		cached_cq_tail;
>> @@ -1138,7 +1139,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>>   	init_completion(&ctx->ref_comp);
>>   	init_completion(&ctx->sq_thread_comp);
>>   	idr_init(&ctx->io_buffer_idr);
>> -	idr_init(&ctx->personality_idr);
>> +	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
>>   	mutex_init(&ctx->uring_lock);
>>   	init_waitqueue_head(&ctx->wait);
>>   	spin_lock_init(&ctx->completion_lock);
>> @@ -6338,7 +6339,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>   	req->work.list.next = NULL;
>>   	personality = READ_ONCE(sqe->personality);
>>   	if (personality) {
>> -		req->work.creds = idr_find(&ctx->personality_idr, personality);
>> +		req->work.creds = xa_load(&ctx->personalities, personality);
>>   		if (!req->work.creds)
>>   			return -EINVAL;
>>   		get_cred(req->work.creds);
>> @@ -8359,7 +8360,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
>>   	mutex_unlock(&ctx->uring_lock);
>>   	io_eventfd_unregister(ctx);
>>   	io_destroy_buffers(ctx);
>> -	idr_destroy(&ctx->personality_idr);
>>   
>>   #if defined(CONFIG_UNIX)
>>   	if (ctx->ring_sock) {
>> @@ -8424,7 +8424,7 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
>>   {
>>   	const struct cred *creds;
>>   
>> -	creds = idr_remove(&ctx->personality_idr, id);
>> +	creds = xa_erase(&ctx->personalities, id);
>>   	if (creds) {
>>   		put_cred(creds);
>>   		return 0;
>> @@ -8433,14 +8433,6 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
>>   	return -EINVAL;
>>   }
>>   
>> -static int io_remove_personalities(int id, void *p, void *data)
>> -{
>> -	struct io_ring_ctx *ctx = data;
>> -
>> -	io_unregister_personality(ctx, id);
>> -	return 0;
>> -}
>> -
>>   static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
>>   {
>>   	struct callback_head *work, *next;
>> @@ -8530,13 +8522,17 @@ static void io_ring_exit_work(struct work_struct *work)
>>   
>>   static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
>>   {
>> +	unsigned long index;
>> +	struct creds *creds;
>> +
>>   	mutex_lock(&ctx->uring_lock);
>>   	percpu_ref_kill(&ctx->refs);
>>   	/* if force is set, the ring is going away. always drop after that */
>>   	ctx->cq_overflow_flushed = 1;
>>   	if (ctx->rings)
>>   		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
>> -	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
>> +	xa_for_each(&ctx->personalities, index, creds)
>> +		io_unregister_personality(ctx, index);
>>   	mutex_unlock(&ctx->uring_lock);
>>   
>>   	io_kill_timeouts(ctx, NULL, NULL);
>> @@ -9166,10 +9162,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>   }
>>   
>>   #ifdef CONFIG_PROC_FS
>> -static int io_uring_show_cred(int id, void *p, void *data)
>> +static int io_uring_show_cred(struct seq_file *m, unsigned int id,
>> +		const struct cred *cred)
>>   {
>> -	const struct cred *cred = p;
>> -	struct seq_file *m = data;
>>   	struct user_namespace *uns = seq_user_ns(m);
>>   	struct group_info *gi;
>>   	kernel_cap_t cap;
>> @@ -9237,9 +9232,13 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>>   		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf,
>>   						(unsigned int) buf->len);
>>   	}
>> -	if (has_lock && !idr_is_empty(&ctx->personality_idr)) {
>> +	if (has_lock && !xa_empty(&ctx->personalities)) {
>> +		unsigned long index;
>> +		const struct cred *cred;
>> +
>>   		seq_printf(m, "Personalities:\n");
>> -		idr_for_each(&ctx->personality_idr, io_uring_show_cred, m);
>> +		xa_for_each(&ctx->personalities, index, cred)
>> +			io_uring_show_cred(m, index, cred);
>>   	}
>>   	seq_printf(m, "PollList:\n");
>>   	spin_lock_irq(&ctx->completion_lock);
>> @@ -9568,14 +9567,16 @@ static int io_probe(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
>>   static int io_register_personality(struct io_ring_ctx *ctx)
>>   {
>>   	const struct cred *creds;
>> +	u32 id;
>>   	int ret;
>>   
>>   	creds = get_current_cred();
>>   
>> -	ret = idr_alloc_cyclic(&ctx->personality_idr, (void *) creds, 1,
>> -				USHRT_MAX, GFP_KERNEL);
>> -	if (ret < 0)
>> -		put_cred(creds);
>> +	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
>> +			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
>> +	if (!ret)
>> +		return id;
>> +	put_cred(creds);
>>   	return ret;
>>   }
>>   
>>
> 
