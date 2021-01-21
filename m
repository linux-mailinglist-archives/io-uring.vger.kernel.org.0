Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CC52FE018
	for <lists+io-uring@lfdr.de>; Thu, 21 Jan 2021 04:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbhAUDke (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jan 2021 22:40:34 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:35081 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727650AbhAUB5l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jan 2021 20:57:41 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UMNH62b_1611194209;
Received: from 30.225.32.87(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UMNH62b_1611194209)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 21 Jan 2021 09:56:49 +0800
Subject: Re: [PATCH] io_uring: leave clean req to be done in flush overflow
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <1611130310-108105-1-git-send-email-joseph.qi@linux.alibaba.com>
 <62fdcc48-ccb2-2a51-a69f-9ead1ff1ea59@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <0e640650-4288-2dc4-b761-f48423131462@linux.alibaba.com>
Date:   Thu, 21 Jan 2021 09:54:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <62fdcc48-ccb2-2a51-a69f-9ead1ff1ea59@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi Pavel,

> On 20/01/2021 08:11, Joseph Qi wrote:
>> Abaci reported the following BUG:
>>
>> [   27.629441] BUG: sleeping function called from invalid context at fs/file.c:402
>> [   27.631317] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 1012, name: io_wqe_worker-0
>> [   27.633220] 1 lock held by io_wqe_worker-0/1012:
>> [   27.634286]  #0: ffff888105e26c98 (&ctx->completion_lock){....}-{2:2}, at: __io_req_complete.part.102+0x30/0x70
>> [   27.636487] irq event stamp: 66658
>> [   27.637302] hardirqs last  enabled at (66657): [<ffffffff8144ba02>] kmem_cache_free+0x1f2/0x3b0
>> [   27.639211] hardirqs last disabled at (66658): [<ffffffff82003a77>] _raw_spin_lock_irqsave+0x17/0x50
>> [   27.641196] softirqs last  enabled at (64686): [<ffffffff824003c5>] __do_softirq+0x3c5/0x5aa
>> [   27.643062] softirqs last disabled at (64681): [<ffffffff8220108f>] asm_call_irq_on_stack+0xf/0x20
>> [   27.645029] CPU: 1 PID: 1012 Comm: io_wqe_worker-0 Not tainted 5.11.0-rc4+ #68
>> [   27.646651] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
>> [   27.649249] Call Trace:
>> [   27.649874]  dump_stack+0xac/0xe3
>> [   27.650666]  ___might_sleep+0x284/0x2c0
>> [   27.651566]  put_files_struct+0xb8/0x120
>> [   27.652481]  __io_clean_op+0x10c/0x2a0
>> [   27.653362]  __io_cqring_fill_event+0x2c1/0x350
>> [   27.654399]  __io_req_complete.part.102+0x41/0x70
>> [   27.655464]  io_openat2+0x151/0x300
>> [   27.656297]  io_issue_sqe+0x6c/0x14e0
>> [   27.657170]  ? lock_acquire+0x31a/0x440
>> [   27.658068]  ? io_worker_handle_work+0x24e/0x8a0
>> [   27.659119]  ? find_held_lock+0x28/0xb0
>> [   27.660026]  ? io_wq_submit_work+0x7f/0x240
>> [   27.660991]  io_wq_submit_work+0x7f/0x240
>> [   27.661915]  ? trace_hardirqs_on+0x46/0x110
>> [   27.662890]  io_worker_handle_work+0x501/0x8a0
>> [   27.663917]  ? io_wqe_worker+0x135/0x520
>> [   27.664836]  io_wqe_worker+0x158/0x520
>> [   27.665719]  ? __kthread_parkme+0x96/0xc0
>> [   27.666663]  ? io_worker_handle_work+0x8a0/0x8a0
>> [   27.667726]  kthread+0x134/0x180
>> [   27.668506]  ? kthread_create_worker_on_cpu+0x90/0x90
>> [   27.669641]  ret_from_fork+0x1f/0x30
>>
>> It blames we call cond_resched() with completion_lock when clean
>> request. In fact we will do it during flush overflow and it seems we
>> have no reason to do it before. So just remove io_clean_op() in
>> __io_cqring_fill_event() to fix this BUG.
> 
> Nope, it would be broken. You may override, e.g. iov pointer
> that is dynamically allocated, and the function makes sure all
> those are deleted and freed. Most probably there will be problems
> on flush side as well.
Could you please explain more why this is a problem?
io_clean_op justs does some clean work, free allocated memory, put file, etc,
and these jobs should can be done in __io_cqring_overflow_flush():
	while (!list_empty(&list)) {
		req = list_first_entry(&list, struct io_kiocb, compl.list);
		list_del(&req->compl.list);
		io_put_req(req); // will call io_clean_op
	}

And calling a single io_clean_op in __io_cqring_fill_event() looks weird.

Regards,
Xiaoguang Wang

> 
> Looks like the problem is that we do spin_lock_irqsave() in
> __io_req_complete() and then just spin_lock() for put_files_struct().
> Jens, is it a real problem?
> 
> At least for 5.12 there is a cleanup as below, moving drop_files()
> into io_req_clean_work/io_free_req(), which is out of locks. Depends
> on that don't-cancel-by-files patch, but I guess can be for 5.11
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 4f702d03d375..3d3087851fed 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -614,7 +614,6 @@ enum {
>   	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
>   
>   	REQ_F_FAIL_LINK_BIT,
> -	REQ_F_INFLIGHT_BIT,
>   	REQ_F_CUR_POS_BIT,
>   	REQ_F_NOWAIT_BIT,
>   	REQ_F_LINK_TIMEOUT_BIT,
> @@ -647,8 +646,6 @@ enum {
>   
>   	/* fail rest of links */
>   	REQ_F_FAIL_LINK		= BIT(REQ_F_FAIL_LINK_BIT),
> -	/* on inflight list */
> -	REQ_F_INFLIGHT		= BIT(REQ_F_INFLIGHT_BIT),
>   	/* read/write uses file position */
>   	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
>   	/* must not punt to workers */
> @@ -1057,8 +1054,7 @@ EXPORT_SYMBOL(io_uring_get_socket);
>   
>   static inline void io_clean_op(struct io_kiocb *req)
>   {
> -	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
> -			  REQ_F_INFLIGHT))
> +	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
>   		__io_clean_op(req);
>   }
>   
> @@ -1375,6 +1371,11 @@ static void io_req_clean_work(struct io_kiocb *req)
>   			free_fs_struct(fs);
>   		req->work.flags &= ~IO_WQ_WORK_FS;
>   	}
> +	if (req->work.flags & IO_WQ_WORK_FILES) {
> +		put_files_struct(req->work.identity->files);
> +		put_nsproxy(req->work.identity->nsproxy);
> +		req->work.flags &= ~IO_WQ_WORK_FILES;
> +	}
>   
>   	io_put_identity(req->task->io_uring, req);
>   }
> @@ -1483,7 +1484,6 @@ static bool io_grab_identity(struct io_kiocb *req)
>   			return false;
>   		atomic_inc(&id->files->count);
>   		get_nsproxy(id->nsproxy);
> -		req->flags |= REQ_F_INFLIGHT;
>   		req->work.flags |= IO_WQ_WORK_FILES;
>   	}
>   	if (!(req->work.flags & IO_WQ_WORK_MM) &&
> @@ -6128,18 +6128,6 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   	return -EIOCBQUEUED;
>   }
>   
> -static void io_req_drop_files(struct io_kiocb *req)
> -{
> -	struct io_uring_task *tctx = req->task->io_uring;
> -
> -	put_files_struct(req->work.identity->files);
> -	put_nsproxy(req->work.identity->nsproxy);
> -	req->flags &= ~REQ_F_INFLIGHT;
> -	req->work.flags &= ~IO_WQ_WORK_FILES;
> -	if (atomic_read(&tctx->in_idle))
> -		wake_up(&tctx->wait);
> -}
> -
>   static void __io_clean_op(struct io_kiocb *req)
>   {
>   	if (req->flags & REQ_F_BUFFER_SELECTED) {
> @@ -6197,9 +6185,6 @@ static void __io_clean_op(struct io_kiocb *req)
>   		}
>   		req->flags &= ~REQ_F_NEED_CLEANUP;
>   	}
> -
> -	if (req->flags & REQ_F_INFLIGHT)
> -		io_req_drop_files(req);
>   }
>   
>   static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
> 
> 
