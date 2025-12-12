Return-Path: <io-uring+bounces-11026-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1ACCB8E6C
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 14:33:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 11EB8300AFE5
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 13:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 727268460;
	Fri, 12 Dec 2025 13:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="TTaqkpPT"
X-Original-To: io-uring@vger.kernel.org
Received: from sg-1-101.ptr.blmpb.com (sg-1-101.ptr.blmpb.com [118.26.132.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41760208994
	for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 13:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765546390; cv=none; b=rtyn0E55Bz+nnLBNsfb954MAJ6IBGFPJOxKIbZTODrM2BxnqZaxtD5Pl6WKmOnMevn60Ttt3jpLYWgwoRkrFjeb8jnQa7Umwa4tKET3k6F2yOgmaWpTBVj9USGESEdb0NTIL08tzueA/uyHQyBo8Co1DnEWx/5YwqjPQqOtujEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765546390; c=relaxed/simple;
	bh=A51vVt2tWZzNBdpSGdXU/9TtHl/aPjWMjs33wbKQr+k=;
	h=Subject:In-Reply-To:From:Mime-Version:References:To:Cc:Message-Id:
	 Date:Content-Type; b=lF8L0ng75Xn/sUYrv8Gmmb0Zv104a3ZPgWyZgIwo5yc5HKIDaDG2VoX7Y+nkZL2demOjOvL3BY6/BocMoCR/mGS2PFXSbGamCbirelmuWokZopCaYq6DAOhabchQTxqc2ywAVWu+0FvWB0IHhfyldGPbFWW0E6KvLgWYxRHc3ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=TTaqkpPT; arc=none smtp.client-ip=118.26.132.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1765546374; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=t2cGIAc4aUNWe56E7nEalKgTd+opQuy7M7lT12bitP8=;
 b=TTaqkpPTM0agJY3w7/sV0IGjKnG5X3Qg89Sdn72U6NkrtRvpHLpqeL+Y25L2TUXLnmoIhf
 WArqeNiW0z2yCPcyIJrylRkL7RZBvPvTER1rM1BgLobI7k+mwtEePrYkTvH7Xoo+fk5GP4
 mpekcsLRhK+g2s8/qY0l39toN4+d5qdhDXQNEYThF0/30R6wWgpRB6CKvqS/xgjsrAk/Eb
 IaAnbGofrpOVd7hnTiAEMgSfh5yVixnu9aQ0YfzVu7evHh4Velyc4r4MJMPlL+Y/fDhGHz
 RZpmwsA9labvEEOkDP28yEORLLDpMZ6JPsLjxzsXAF9QvqWePAgWXeXoQtAvDw==
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
In-Reply-To: <f763dcd7-dcb3-4cc5-a567-f922cda91ca2@kernel.dk>
From: "Diangang Li" <lidiangang@bytedance.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
References: <20251210085501.84261-1-changfengnan@bytedance.com> <20251210085501.84261-3-changfengnan@bytedance.com> <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk> <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk> <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com> <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk> <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk> <5ce7c227-3a03-4586-baa8-5bd6579500c7@gmail.com> <1d8a4c67-0c30-449e-a4e3-24363de0fcfa@kernel.dk> <f987df2c-f9a7-4656-b725-7a30651b4d86@gmail.com> <f763dcd7-dcb3-4cc5-a567-f922cda91ca2@kernel.dk>
Content-Language: en-US
To: "Jens Axboe" <axboe@kernel.dk>, "Fengnan Chang" <fengnanchang@gmail.com>, 
	<asml.silence@gmail.com>, <io-uring@vger.kernel.org>
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
Message-Id: <b640d708-6270-4946-916d-350d323f1678@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Original-From: Diangang Li <lidiangang@bytedance.com>
Date: Fri, 12 Dec 2025 21:32:37 +0800
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+2693c1984+a1c648+vger.kernel.org+lidiangang@bytedance.com>

On 2025/12/12 13:11, Jens Axboe wrote:
> On 12/11/25 7:12 PM, Fengnan Chang wrote:
>>
>>
>> ? 2025/12/12 09:53, Jens Axboe ??:
>>> On 12/11/25 6:41 PM, Fengnan Chang wrote:
>>>> Oh, we can't add nr_events == iob.nr_reqs check, if
>>>> blk_mq_add_to_batch add failed, completed IO will not add into iob,
>>>> iob.nr_reqs will be 0, this may cause io hang.
>>> Indeed, won't work as-is.
>>>
>>> I do think we're probably making a bigger deal out of the full loop than
>>> necessary. At least I'd be perfectly happy with just the current patch,
>>> performance should be better there than we currently have it. Ideally
>>> we'd have just one loop for polling and catching the completed items,
>>> but that's a bit tricky with the batch completions.
>>
>> Yes, ideally one loop would be enough, but given that there are also
>> multi_queue ctx, that doesn't seem to be possible.
> 
> It's not removing the double loop, but the below could help _only_
> iterate completed requests at the end. Rather than move items between
> the current list at the completion callback, have a separate list just
> for completed requests. Then we can simply iterate that, knowing all of
> them have completed. Gets rid of the ->iopoll_completed as well, and
> then we can move the poll_refs. Not really related at all, obviously
> this patch should be split into multiple pieces.
> 
> This uses a lockless list. But since the producer and consumer are
> generally the same task, that should not add any real overhead. On top
> of the previous one I sent. What do you think?
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 54fd30abf2b8..2d67d95a64ee 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -317,6 +317,7 @@ struct io_ring_ctx {
>   		 */
>   		bool			poll_multi_queue;
>   		struct list_head	iopoll_list;
> +		struct llist_head	iopoll_complete;
>   
>   		struct io_file_table	file_table;
>   		struct io_rsrc_data	buf_table;
> @@ -672,8 +673,9 @@ struct io_kiocb {
>   	};
>   
>   	u8				opcode;
> -	/* polled IO has completed */
> -	u8				iopoll_completed;
> +
> +	bool				cancel_seq_set;
> +
>   	/*
>   	 * Can be either a fixed buffer index, or used with provided buffers.
>   	 * For the latter, it points to the selected buffer ID.
> @@ -700,6 +702,7 @@ struct io_kiocb {
>   	union {
>   		/* used by request caches, completion batching and iopoll */
>   		struct io_wq_work_node	comp_list;
> +		struct llist_node	iopoll_done_list;
>   		/* cache ->apoll->events */
>   		__poll_t apoll_events;
>   	};
> @@ -707,7 +710,7 @@ struct io_kiocb {
>   	struct io_rsrc_node		*file_node;
>   
>   	atomic_t			refs;
> -	bool				cancel_seq_set;
> +	atomic_t			poll_refs;
>   
>   	/*
>   	 * IOPOLL doesn't use task_work, so use the ->iopoll_node list
> @@ -734,7 +737,6 @@ struct io_kiocb {
>   	/* opcode allocated if it needs to store data for async defer */
>   	void				*async_data;
>   	/* linked requests, IFF REQ_F_HARDLINK or REQ_F_LINK are set */
> -	atomic_t			poll_refs;
>   	struct io_kiocb			*link;
>   	/* custom credentials, valid IFF REQ_F_CREDS is set */
>   	const struct cred		*creds;
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 05a660c97316..5e503a0bfcfc 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -335,6 +335,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   	spin_lock_init(&ctx->completion_lock);
>   	raw_spin_lock_init(&ctx->timeout_lock);
>   	INIT_LIST_HEAD(&ctx->iopoll_list);
> +	init_llist_head(&ctx->iopoll_complete);
>   	INIT_LIST_HEAD(&ctx->defer_list);
>   	INIT_LIST_HEAD(&ctx->timeout_list);
>   	INIT_LIST_HEAD(&ctx->ltimeout_list);
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 307f1f39d9f3..ad481ca74a46 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -604,8 +604,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
>   			req->cqe.res = res;
>   	}
>   
> -	/* order with io_iopoll_complete() checking ->iopoll_completed */
> -	smp_store_release(&req->iopoll_completed, 1);
> +	llist_add(&req->iopoll_done_list, &req->ctx->iopoll_complete);
>   }
>   
>   static inline void io_rw_done(struct io_kiocb *req, ssize_t ret)
> @@ -870,7 +869,6 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
>   			return -EOPNOTSUPP;
>   		kiocb->private = NULL;
>   		kiocb->ki_flags |= IOCB_HIPRI;
> -		req->iopoll_completed = 0;
>   		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
>   			/* make sure every req only blocks once*/
>   			req->flags &= ~REQ_F_IOPOLL_STATE;
> @@ -1317,7 +1315,8 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>   {
>   	unsigned int poll_flags = 0;
>   	DEFINE_IO_COMP_BATCH(iob);
> -	struct io_kiocb *req, *tmp;
> +	struct llist_node *node;
> +	struct io_kiocb *req;
>   	int nr_events = 0;
>   
>   	/*
> @@ -1327,17 +1326,12 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>   	if (ctx->poll_multi_queue || force_nonspin)
>   		poll_flags |= BLK_POLL_ONESHOT;
>   
> +	/*
> +	 * Loop over uncompleted polled IO requests, and poll for them.
> +	 */
>   	list_for_each_entry(req, &ctx->iopoll_list, iopoll_node) {
>   		int ret;
>   
> -		/*
> -		 * Move completed and retryable entries to our local lists.
> -		 * If we find a request that requires polling, break out
> -		 * and complete those lists first, if we have entries there.
> -		 */
> -		if (READ_ONCE(req->iopoll_completed))
> -			break;

Suggest keeping iopoll_completed here to avoid unnecessary subsequent 
polling and to process IRQ-completed requests promptly.

> -
>   		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL)
>   			ret = io_uring_hybrid_poll(req, &iob, poll_flags);
>   		else
> @@ -1349,24 +1343,25 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>   			poll_flags |= BLK_POLL_ONESHOT;
>   
>   		/* iopoll may have completed current req */
> -		if (!rq_list_empty(&iob.req_list) ||
> -		    READ_ONCE(req->iopoll_completed))
> +		if (!rq_list_empty(&iob.req_list))
>   			break;
>   	}
>   
>   	if (!rq_list_empty(&iob.req_list))
>   		iob.complete(&iob);
>   
> -	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, iopoll_node) {
> -		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
> -		if (!smp_load_acquire(&req->iopoll_completed))
> -			continue;
> +	node = llist_del_all(&ctx->iopoll_complete);
> +	while (node) {
> +		struct llist_node *next = node->next;
> +
> +		req = container_of(node, struct io_kiocb, iopoll_done_list);
>   		list_del(&req->iopoll_node);
>   		wq_list_add_tail(&req->comp_list, &ctx->submit_state.compl_reqs);
>   		nr_events++;
>   		req->cqe.flags = io_put_kbuf(req, req->cqe.res, NULL);
>   		if (req->opcode != IORING_OP_URING_CMD)
>   			io_req_rw_cleanup(req, 0);
> +		node = next;
>   	}
>   	if (nr_events)
>   		__io_submit_flush_completions(ctx);
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 197474911f04..0841fa541f5d 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -159,8 +159,7 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
>   	}
>   	io_req_uring_cleanup(req, issue_flags);
>   	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
> -		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
> -		smp_store_release(&req->iopoll_completed, 1);
> +		llist_add(&req->iopoll_done_list, &req->ctx->iopoll_complete);
>   	} else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
>   		if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
>   			return;
> @@ -252,7 +251,6 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>   		if (!file->f_op->uring_cmd_iopoll)
>   			return -EOPNOTSUPP;
>   		issue_flags |= IO_URING_F_IOPOLL;
> -		req->iopoll_completed = 0;
>   		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
>   			/* make sure every req only blocks once */
>   			req->flags &= ~REQ_F_IOPOLL_STATE;

