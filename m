Return-Path: <io-uring+bounces-11150-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D8023CC7A58
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 13:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2136730019DA
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 12:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC1F217B425;
	Wed, 17 Dec 2025 12:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Zgi+ddQu"
X-Original-To: io-uring@vger.kernel.org
Received: from lf-1-129.ptr.blmpb.com (lf-1-129.ptr.blmpb.com [103.149.242.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9393829993F
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 12:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.149.242.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765974990; cv=none; b=mM023AU3ivFV9qoZ+XYy4nev5oj625cbPuWsp+RpEBCZzZRA6qX5SeJMIRuYtmW/sTau7Vwf0J81gb1pBhMGIHeVJQenGi8UmGfG9L5jz1bg3vqFbMuWnjriJLzBs00hRHtF7g2hl4SQZxEyRMO5fzsYLLyp/LOsOlM5ONQTU6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765974990; c=relaxed/simple;
	bh=L7RG0TbnLv9ME9PtTkdobzZiSKdlmDxtVNI4DDAz+to=;
	h=Cc:Subject:Mime-Version:To:Date:From:In-Reply-To:Content-Type:
	 Message-Id:References; b=nYDjp/n8iDjDEk2tfD9eMuz0hI/yxKB5l93IjdBgIaeRZ/dazKL63PWnCCo1gBCSurBZDGJib/jVSFnSQCHygGSustlosW0bQy6i3oEv1WPlrS8Q+7souvi9ZrjXcNVO1T8wAwyyXhuVup2ug7vmi/1t72v2zBd+dB5upwNB3eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Zgi+ddQu; arc=none smtp.client-ip=103.149.242.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1765974899; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=oNAZ59GhDWQMMwGBkedqQ/PznGFn0x0FDYgFXv+BvVI=;
 b=Zgi+ddQueumtN7tRlEAD3ZGgBrOU3U2NGKejtXF43sq7lh3UBo+7pSpEgFyBDy2KAj91GC
 gUkX0u0byLY3eHWLj5+MM0HWBmM30wzWJeYIaKo8KOECHaIPOBy9vBinJTk8hYXGn7IyQ4
 P6Alebve3omnWYXBMho6j3BOwVZVaMPzB+6on9JuLpHlShAHXIG7yTjsRco4biKGS6CT+x
 vkqgnQ9PaukxB2WLmxRuFKiqaWcBRvfq01znxREVWmTzsXpkxFXodM7dkUowFXx9dlsa0X
 +Z0/zAjhtYS2ORloGiqXq/q8rkdh1dDmdvx5DRRdXyLfVZPIHA+Qb+33nkXE8w==
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: "Jens Axboe" <axboe@kernel.dk>, "Fengnan Chang" <fengnanchang@gmail.com>, 
	<asml.silence@gmail.com>, <io-uring@vger.kernel.org>
Date: Wed, 17 Dec 2025 20:34:47 +0800
X-Lms-Return-Path: <lba+26942a371+3d9a9b+vger.kernel.org+lidiangang@bytedance.com>
X-Original-From: Diangang Li <lidiangang@bytedance.com>
From: "Diangang Li" <lidiangang@bytedance.com>
User-Agent: Mozilla Thunderbird
In-Reply-To: <f763dcd7-dcb3-4cc5-a567-f922cda91ca2@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Message-Id: <f2836fb8-9ad7-4277-948b-430dcd24d1b6@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com> <20251210085501.84261-3-changfengnan@bytedance.com> <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk> <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk> <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com> <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk> <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk> <5ce7c227-3a03-4586-baa8-5bd6579500c7@gmail.com> <1d8a4c67-0c30-449e-a4e3-24363de0fcfa@kernel.dk> <f987df2c-f9a7-4656-b725-7a30651b4d86@gmail.com> <f763dcd7-dcb3-4cc5-a567-f922cda91ca2@kernel.dk>
Content-Language: en-US

On 2025/12/12 13:11, Jens Axboe wrote:
> On 12/11/25 7:12 PM, Fengnan Chang wrote:
>>
>>
>> ? 2025/12/12 09:53, Jens Axboe ??:
>>> On 12/11/25 6:41 PM, Fengnan Chang wrote:
>>>> Oh, we can't add nr_events =3D=3D iob.nr_reqs check, if
>>>> blk_mq_add_to_batch add failed, completed IO will not add into iob,
>>>> iob.nr_reqs will be 0, this may cause io hang.
>>> Indeed, won't work as-is.
>>>
>>> I do think we're probably making a bigger deal out of the full loop tha=
n
>>> necessary. At least I'd be perfectly happy with just the current patch,
>>> performance should be better there than we currently have it. Ideally
>>> we'd have just one loop for polling and catching the completed items,
>>> but that's a bit tricky with the batch completions.
>>
>> Yes, ideally one loop would be enough, but given that there are also
>> multi_queue ctx, that doesn't seem to be possible.
>=20
> It's not removing the double loop, but the below could help _only_
> iterate completed requests at the end. Rather than move items between
> the current list at the completion callback, have a separate list just
> for completed requests. Then we can simply iterate that, knowing all of
> them have completed. Gets rid of the ->iopoll_completed as well, and
> then we can move the poll_refs. Not really related at all, obviously
> this patch should be split into multiple pieces.
>=20
> This uses a lockless list. But since the producer and consumer are
> generally the same task, that should not add any real overhead. On top
> of the previous one I sent. What do you think?
>=20
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 54fd30abf2b8..2d67d95a64ee 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -317,6 +317,7 @@ struct io_ring_ctx {
>   		 */
>   		bool			poll_multi_queue;
>   		struct list_head	iopoll_list;
> +		struct llist_head	iopoll_complete;
>  =20
>   		struct io_file_table	file_table;
>   		struct io_rsrc_data	buf_table;
> @@ -672,8 +673,9 @@ struct io_kiocb {
>   	};
>  =20
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
>  =20
>   	atomic_t			refs;
> -	bool				cancel_seq_set;
> +	atomic_t			poll_refs;
>  =20
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
> @@ -335,6 +335,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
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
> @@ -604,8 +604,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb=
, long res)
>   			req->cqe.res =3D res;
>   	}
>  =20
> -	/* order with io_iopoll_complete() checking ->iopoll_completed */
> -	smp_store_release(&req->iopoll_completed, 1);
> +	llist_add(&req->iopoll_done_list, &req->ctx->iopoll_complete);
>   }
>  =20
>   static inline void io_rw_done(struct io_kiocb *req, ssize_t ret)
> @@ -870,7 +869,6 @@ static int io_rw_init_file(struct io_kiocb *req, fmod=
e_t mode, int rw_type)
>   			return -EOPNOTSUPP;
>   		kiocb->private =3D NULL;
>   		kiocb->ki_flags |=3D IOCB_HIPRI;
> -		req->iopoll_completed =3D 0;
>   		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
>   			/* make sure every req only blocks once*/
>   			req->flags &=3D ~REQ_F_IOPOLL_STATE;
> @@ -1317,7 +1315,8 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool forc=
e_nonspin)
>   {
>   	unsigned int poll_flags =3D 0;
>   	DEFINE_IO_COMP_BATCH(iob);
> -	struct io_kiocb *req, *tmp;
> +	struct llist_node *node;
> +	struct io_kiocb *req;
>   	int nr_events =3D 0;
>  =20
>   	/*
> @@ -1327,17 +1326,12 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool fo=
rce_nonspin)
>   	if (ctx->poll_multi_queue || force_nonspin)
>   		poll_flags |=3D BLK_POLL_ONESHOT;
>  =20
> +	/*
> +	 * Loop over uncompleted polled IO requests, and poll for them.
> +	 */
>   	list_for_each_entry(req, &ctx->iopoll_list, iopoll_node) {
>   		int ret;
>  =20
> -		/*
> -		 * Move completed and retryable entries to our local lists.
> -		 * If we find a request that requires polling, break out
> -		 * and complete those lists first, if we have entries there.
> -		 */
> -		if (READ_ONCE(req->iopoll_completed))
> -			break;
> -
>   		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL)
>   			ret =3D io_uring_hybrid_poll(req, &iob, poll_flags);
>   		else
> @@ -1349,24 +1343,25 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool fo=
rce_nonspin)
>   			poll_flags |=3D BLK_POLL_ONESHOT;
>  =20
>   		/* iopoll may have completed current req */
> -		if (!rq_list_empty(&iob.req_list) ||
> -		    READ_ONCE(req->iopoll_completed))
> +		if (!rq_list_empty(&iob.req_list))
>   			break;
>   	}
>  =20
>   	if (!rq_list_empty(&iob.req_list))
>   		iob.complete(&iob);
>  =20
> -	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, iopoll_node) {
> -		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
> -		if (!smp_load_acquire(&req->iopoll_completed))
> -			continue;
> +	node =3D llist_del_all(&ctx->iopoll_complete);
> +	while (node) {
> +		struct llist_node *next =3D node->next;
> +
> +		req =3D container_of(node, struct io_kiocb, iopoll_done_list);
>   		list_del(&req->iopoll_node);

Hi Jens,

We=E2=80=99ve identified one critical panic issue here.

[ 4504.422964] [  T63683] list_del corruption, ff2adc9b51d19a90->next is=20
LIST_POISON1 (dead000000000100)
[ 4504.422994] [  T63683] ------------[ cut here ]------------
[ 4504.422995] [  T63683] kernel BUG at lib/list_debug.c:56!
[ 4504.423006] [  T63683] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[ 4504.423017] [  T63683] CPU: 38 UID: 0 PID: 63683 Comm: io_uring=20
Kdump: loaded Tainted: G S          E       6.19.0-rc1+ #1=20
PREEMPT(voluntary)
[ 4504.423032] [  T63683] Tainted: [S]=3DCPU_OUT_OF_SPEC, [E]=3DUNSIGNED_MO=
DULE
[ 4504.423040] [  T63683] Hardware name: Inventec S520-A6/Nanping MLB,=20
BIOS 01.01.01.06.03 03/03/2023
[ 4504.423050] [  T63683] RIP:=20
0010:__list_del_entry_valid_or_report+0x94/0x100
[ 4504.423064] [  T63683] Code: 89 fe 48 c7 c7 f0 78 87 b5 e8 38 07 ae=20
ff 0f 0b 48 89 ef e8 6e 40 cd ff 48 89 ea 48 89 de 48 c7 c7 20 79 87 b5=20
e8 1c 07 ae ff <0f> 0b 4c 89 e7 e8 52 40 cd ff 4c 89 e2 48 89 de 48 c7=20
c7 58 79 87
[ 4504.423085] [  T63683] RSP: 0018:ff4efd9f3838fdb0 EFLAGS: 00010246
[ 4504.423093] [  T63683] RAX: 000000000000004e RBX: ff2adc9b51d19a90=20
RCX: 0000000000000027
[ 4504.423103] [  T63683] RDX: 0000000000000000 RSI: 0000000000000001=20
RDI: ff2add151cf99580
[ 4504.423112] [  T63683] RBP: dead000000000100 R08: 0000000000000000=20
R09: 0000000000000003
[ 4504.423120] [  T63683] R10: ff4efd9f3838fc60 R11: ff2add151cdfffe8=20
R12: dead000000000122
[ 4504.423130] [  T63683] R13: ff2adc9b51d19a00 R14: 0000000000000000=20
R15: 0000000000000000
[ 4504.423139] [  T63683] FS:  00007fae4f7ff6c0(0000)=20
GS:ff2add15665f5000(0000) knlGS:0000000000000000
[ 4504.423148] [  T63683] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4504.423157] [  T63683] CR2: 000055aa8afe5000 CR3: 00000083037ee006=20
CR4: 0000000000773ef0
[ 4504.423166] [  T63683] PKRU: 55555554
[ 4504.423171] [  T63683] Call Trace:
[ 4504.423178] [  T63683]  <TASK>
[ 4504.423184] [  T63683]  io_do_iopoll+0x298/0x330
[ 4504.423193] [  T63683]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
[ 4504.423204] [  T63683]  __do_sys_io_uring_enter+0x421/0x770
[ 4504.423214] [  T63683]  do_syscall_64+0x67/0xf00
[ 4504.423223] [  T63683]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 4504.423232] [  T63683] RIP: 0033:0x55aa707e99c3

It can be reproduced in three ways:
- Running iopoll tests while switching the block scheduler
- A split IO scenario in iopoll (e.g., bs=3D512k with max_sectors_kb=3D256k=
)
- Multi poll queues with multi threads

All cases appear related to IO completions occurring outside the=20
io_do_iopoll() loop. The root cause remains unclear.

Best,
Diangang

>   		wq_list_add_tail(&req->comp_list, &ctx->submit_state.compl_reqs);
>   		nr_events++;
>   		req->cqe.flags =3D io_put_kbuf(req, req->cqe.res, NULL);
>   		if (req->opcode !=3D IORING_OP_URING_CMD)
>   			io_req_rw_cleanup(req, 0);
> +		node =3D next;
>   	}
>   	if (nr_events)
>   		__io_submit_flush_completions(ctx);
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 197474911f04..0841fa541f5d 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -159,8 +159,7 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd,=
 s32 ret, u64 res2,
>   	}
>   	io_req_uring_cleanup(req, issue_flags);
>   	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
> -		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
> -		smp_store_release(&req->iopoll_completed, 1);
> +		llist_add(&req->iopoll_done_list, &req->ctx->iopoll_complete);
>   	} else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
>   		if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
>   			return;
> @@ -252,7 +251,6 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int i=
ssue_flags)
>   		if (!file->f_op->uring_cmd_iopoll)
>   			return -EOPNOTSUPP;
>   		issue_flags |=3D IO_URING_F_IOPOLL;
> -		req->iopoll_completed =3D 0;
>   		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
>   			/* make sure every req only blocks once */
>   			req->flags &=3D ~REQ_F_IOPOLL_STATE;
>

