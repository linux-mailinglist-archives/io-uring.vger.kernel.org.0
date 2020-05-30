Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D10E1E91BF
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2020 15:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgE3NgL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 May 2020 09:36:11 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:58927 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728941AbgE3NgL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 May 2020 09:36:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U-2WStx_1590845763;
Received: from 30.39.138.128(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U-2WStx_1590845763)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 30 May 2020 21:36:03 +0800
Subject: Re: [PATCH v3 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200528091550.3169-1-xiaoguang.wang@linux.alibaba.com>
 <fa5b8034-c911-3de1-cfec-0b3a82ae701a@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <b472d985-0e34-c53a-e976-3a174211d12b@linux.alibaba.com>
Date:   Sat, 30 May 2020 21:36:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <fa5b8034-c911-3de1-cfec-0b3a82ae701a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 28/05/2020 12:15, Xiaoguang Wang wrote:
>> If requests can be submitted and completed inline, we don't need to
>> initialize whole io_wq_work in io_init_req(), which is an expensive
>> operation, add a new 'REQ_F_WORK_INITIALIZED' to control whether
>> io_wq_work is initialized.
> 
> It looks nicer. Especially if you'd add a helper as Jens supposed.
Sure, I'll add a helper in V4, thanks.

> 
> The other thing, even though I hate treating a part of the fields differently
> from others, I don't like ->creds tossing either.
> 
> Did you consider trying using only ->work.creds without adding req->creds? like
> in the untested incremental below. init_io_work() there is misleading, should be
> somehow played around better.
But if not adding a new req->creds, I think there will be some potential risks.
In current io_uring mainline codes, look at io_kiocb's memory layout
crash> struct -o io_kiocb
struct io_kiocb {
         union {
     [0]     struct file *file;
     [0]     struct io_rw rw;
     [0]     struct io_poll_iocb poll;
     [0]     struct io_accept accept;
     [0]     struct io_sync sync;
     [0]     struct io_cancel cancel;
     [0]     struct io_timeout timeout;
     [0]     struct io_connect connect;
     [0]     struct io_sr_msg sr_msg;
     [0]     struct io_open open;
     [0]     struct io_close close;
     [0]     struct io_files_update files_update;
     [0]     struct io_fadvise fadvise;
     [0]     struct io_madvise madvise;
     [0]     struct io_epoll epoll;
     [0]     struct io_splice splice;
     [0]     struct io_provide_buf pbuf;
         };
    [64] struct io_async_ctx *io;
    [72] int cflags;
    [76] u8 opcode;
    [78] u16 buf_index;
    [80] struct io_ring_ctx *ctx;
    [88] struct list_head list;
   [104] unsigned int flags;
   [108] refcount_t refs;
   [112] struct task_struct *task;
   [120] unsigned long fsize;
   [128] u64 user_data;
   [136] u32 result;
   [140] u32 sequence;
   [144] struct list_head link_list;
   [160] struct list_head inflight_entry;
   [176] struct percpu_ref *fixed_file_refs;
         union {
             struct {
   [184]         struct callback_head task_work;
   [200]         struct hlist_node hash_node;
   [216]         struct async_poll *apoll;
             };
   [184]     struct io_wq_work work;
         };
}
SIZE: 240

struct io_wq_work {
    [0] struct io_wq_work_node list;
    [8] void (*func)(struct io_wq_work **);
   [16] struct files_struct *files;
   [24] struct mm_struct *mm;
   [32] const struct cred *creds;
   [40] struct fs_struct *fs;
   [48] unsigned int flags;
   [52] pid_t task_pid;
}
SIZE: 56

The risk mainly comes from the union:
union {
	/*
	 * Only commands that never go async can use the below fields,
	 * obviously. Right now only IORING_OP_POLL_ADD uses them, and
	 * async armed poll handlers for regular commands. The latter
	 * restore the work, if needed.
	 */
	struct {
		struct callback_head	task_work;
		struct hlist_node	hash_node;
		struct async_poll	*apoll;
	};
	struct io_wq_work	work;
};

1, apoll and creds are in same memory offset, for 'async armed poll handlers' case,
apoll will be used, that means creds will be overwrited. In patch "io_uring: avoid
unnecessary io_wq_work copy for fast poll feature", I use REQ_F_WORK_INITIALIZED
to control whether to do io_wq_work restore, then your below codes will break:

static inline void io_req_work_drop_env(struct io_kiocb *req)
{
	/* always init'ed, put before REQ_F_WORK_INITIALIZED check */
	if (req->work.creds) {
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Here req->work.creds will be invalid, or I still need to use some space
to record original req->work.creds, and do creds restore.

		put_cred(req->work.creds);
		req->work.creds = NULL;
	}
	if (!(req->flags & REQ_F_WORK_INITIALIZED))
  		return;

2, For IORING_OP_POLL_ADD case, current mainline codes will use task_work and hash_node,
32 bytes, that means io_wq_work's member list, func, files and mm would be overwrited,
but will not touch creds, it's safe now. But if we will add some new member to
struct {
	struct callback_head	task_work;
	struct hlist_node	hash_node;
	struct async_poll	*apoll;
};
say callback_head adds a new member, our check will still break.

3. IMO, io_wq_work is just to describe needed running environment for reqs that will be
punted to io-wq, for reqs submitted and completed inline should not touch this struct
from software design view, and current io_kiocb is 240 bytes, and a new pointer will be
248 bytes, still 4 cache lines for cache line 64 bytes.


Regards,
Xiaoguang Wang

> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 4dd3295d74f6..4086561ce444 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -643,7 +643,6 @@ struct io_kiocb {
>   	unsigned int		flags;
>   	refcount_t		refs;
>   	struct task_struct	*task;
> -	const struct cred	*creds;
>   	unsigned long		fsize;
>   	u64			user_data;
>   	u32			result;
> @@ -894,8 +893,16 @@ static const struct file_operations io_uring_fops;
>   static inline void init_io_work(struct io_kiocb *req,
>   			void (*func)(struct io_wq_work **))
>   {
> -	req->work = (struct io_wq_work){ .func = func };
> -	req->flags |= REQ_F_WORK_INITIALIZED;
> +	struct io_wq_work *work = &req->work;
> +
> +	/* work->creds are already initialised by a user */
> +	work->list.next = NULL;
> +	work->func = func;
> +	work->files = NULL;
> +	work->mm = NULL;
> +	work->fs = NULL;
> +	work->flags = REQ_F_WORK_INITIALIZED;
> +	work->task_pid = 0;
>   }
>   struct sock *io_uring_get_socket(struct file *file)
>   {
> @@ -1019,15 +1026,9 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
>   		mmgrab(current->mm);
>   		req->work.mm = current->mm;
>   	}
> +	if (!req->work.creds)
> +		req->work.creds = get_current_cred();
> 
> -	if (!req->work.creds) {
> -		if (!req->creds)
> -			req->work.creds = get_current_cred();
> -		else {
> -			req->work.creds = req->creds;
> -			req->creds = NULL;
> -		}
> -	}
>   	if (!req->work.fs && def->needs_fs) {
>   		spin_lock(&current->fs->lock);
>   		if (!current->fs->in_exec) {
> @@ -1044,6 +1045,12 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
> 
>   static inline void io_req_work_drop_env(struct io_kiocb *req)
>   {
> +	/* always init'ed, put before REQ_F_WORK_INITIALIZED check */
> +	if (req->work.creds) {
> +		put_cred(req->work.creds);
> +		req->work.creds = NULL;
> +	}
> +
>   	if (!(req->flags & REQ_F_WORK_INITIALIZED))
>   		return;
> 
> @@ -1051,10 +1058,6 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
>   		mmdrop(req->work.mm);
>   		req->work.mm = NULL;
>   	}
> -	if (req->work.creds) {
> -		put_cred(req->work.creds);
> -		req->work.creds = NULL;
> -	}
>   	if (req->work.fs) {
>   		struct fs_struct *fs = req->work.fs;
> 
> @@ -5901,12 +5904,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct
> io_kiocb *req,
> 
>   	id = READ_ONCE(sqe->personality);
>   	if (id) {
> -		req->creds = idr_find(&ctx->personality_idr, id);
> -		if (unlikely(!req->creds))
> +		req->work.creds = idr_find(&ctx->personality_idr, id);
> +		if (unlikely(!req->work.creds))
>   			return -EINVAL;
> -		get_cred(req->creds);
> +		get_cred(req->work.creds);
>   	} else
> -		req->creds = NULL;
> +		req->work.creds = NULL;
> 
>   	/* same numerical values with corresponding REQ_F_*, safe to copy */
>   	req->flags |= sqe_flags;
> 
