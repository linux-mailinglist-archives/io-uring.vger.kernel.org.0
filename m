Return-Path: <io-uring+bounces-11559-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 314B7D07E2C
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 09:41:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2B110300092B
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 08:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3120D33769F;
	Fri,  9 Jan 2026 08:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Gm5+hv2f"
X-Original-To: io-uring@vger.kernel.org
Received: from sg-1-100.ptr.blmpb.com (sg-1-100.ptr.blmpb.com [118.26.132.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD94B23C4F3
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 08:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767948062; cv=none; b=gVAAj2Fv3m8Tqmp9hNIeXblG685FkeNWe+JSlT2rXpRfSKOylwgkHTKfExznHEl0wT10W7dRoazVfM5xeP/T2N1rQz3nahc7q31BD2Aw696YPqTBwdb5EQSN4weoMnG9/ej5s76b5CQvfFyep9SmoDOs6xMMozE5oVbhC+tt0as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767948062; c=relaxed/simple;
	bh=cifsJHj/rjmmIWQcRmEGKMM0bGQWHN+dIX6IjfKZVoY=;
	h=Content-Type:Message-Id:In-Reply-To:To:Date:From:Mime-Version:
	 References:Cc:Subject; b=axBj8LOCJwDLZ1pXonsYCcOzzILZ5rsWJ1tu1WTqJq7hQL722i4WT+h/BnwTmjYFOuoBlv9bxctCiMvBCY65jOAkelHuIUZsktDNEazYwlNom+ibV8F8lMTV7luWdkZdvqSjV9I2l5Zm0MJ4xB4ZIDbtWuB5xUK0xnHZdRzcyeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Gm5+hv2f; arc=none smtp.client-ip=118.26.132.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767948052; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=9Xj78Gyipd/VvH+bxg51uwZJ9CfiRb1eF3XE2SCIotI=;
 b=Gm5+hv2fm30xQ7Eb/KV2dQEfNpDpCw+23jWmsXIchlemAwcYyyPj88JT9Fz1tyvoPc4vn0
 3vUpFfEajHgG2F9SHKt8Y4SzeucKkE+3kSq5kDrumwmFDmafYtmIodzluEIk9fQjt+TVn/
 Rj6IIVGdKq+BwZsZj8J4q8MQ1uhkKJ8cY6NROuQ1qewkyICiFVv6Uxl6i4eEHFQB6Yh9Ki
 YzfiNidD3zfVtxUvCe9kJSX/RkClPWjTmYveMWC74UW7+mJwugB1e+nEyxOfk4eksDPHVp
 /SOcpENeVbKcs7hgsIpWHa+1b0tFAVbdPEABVZPXsXNVx0B29s3RiLZqPTYZRQ==
Content-Type: text/plain; charset=UTF-8
Message-Id: <c360b8bc-fcf9-4a36-8208-9451aaeb9f41@bytedance.com>
In-Reply-To: <e0dfa76c-c28a-4684-81b4-6ce784ee9a3c@bytedance.com>
X-Original-From: Diangang Li <lidiangang@bytedance.com>
X-Lms-Return-Path: <lba+26960bf13+13819b+vger.kernel.org+lidiangang@bytedance.com>
To: "Jens Axboe" <axboe@kernel.dk>, "Fengnan Chang" <fengnanchang@gmail.com>, 
	<asml.silence@gmail.com>, <io-uring@vger.kernel.org>
Date: Fri, 9 Jan 2026 16:35:18 +0800
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
From: "Diangang Li" <lidiangang@bytedance.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251210085501.84261-1-changfengnan@bytedance.com> <20251210085501.84261-3-changfengnan@bytedance.com> <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk> <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk> <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com> <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk> <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk> <5ce7c227-3a03-4586-baa8-5bd6579500c7@gmail.com> <1d8a4c67-0c30-449e-a4e3-24363de0fcfa@kernel.dk> <f987df2c-f9a7-4656-b725-7a30651b4d86@gmail.com> <f763dcd7-dcb3-4cc5-a567-f922cda91ca2@kernel.dk> <f2836fb8-9ad7-4277-948b-430dcd24d1b6@bytedance.com> <9a8418d8-439f-4dd2-b3fe-33567129861e@kernel.dk> <e0dfa76c-c28a-4684-81b4-6ce784ee9a3c@bytedance.com>
Content-Language: en-US
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode

On 2025/12/19 13:43, Diangang Li wrote:
>=20
>=20
> On 2025/12/18 00:25, Jens Axboe wrote:
>> On 12/17/25 5:34 AM, Diangang Li wrote:
>>> Hi Jens,
>>>
>>> We?ve identified one critical panic issue here.
>>>
>>> [ 4504.422964] [=C2=A0 T63683] list_del corruption, ff2adc9b51d19a90->n=
ext is
>>> LIST_POISON1 (dead000000000100)
>>> [ 4504.422994] [=C2=A0 T63683] ------------[ cut here ]------------
>>> [ 4504.422995] [=C2=A0 T63683] kernel BUG at lib/list_debug.c:56!
>>> [ 4504.423006] [=C2=A0 T63683] Oops: invalid opcode: 0000 [#1] SMP NOPT=
I
>>> [ 4504.423017] [=C2=A0 T63683] CPU: 38 UID: 0 PID: 63683 Comm: io_uring
>>> Kdump: loaded Tainted: G S=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 E=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.19.0-rc1+ #1
>>> PREEMPT(voluntary)
>>> [ 4504.423032] [=C2=A0 T63683] Tainted: [S]=3DCPU_OUT_OF_SPEC,=20
>>> [E]=3DUNSIGNED_MODULE
>>> [ 4504.423040] [=C2=A0 T63683] Hardware name: Inventec S520-A6/Nanping =
MLB,
>>> BIOS 01.01.01.06.03 03/03/2023
>>> [ 4504.423050] [=C2=A0 T63683] RIP:
>>> 0010:__list_del_entry_valid_or_report+0x94/0x100
>>> [ 4504.423064] [=C2=A0 T63683] Code: 89 fe 48 c7 c7 f0 78 87 b5 e8 38 0=
7 ae
>>> ff 0f 0b 48 89 ef e8 6e 40 cd ff 48 89 ea 48 89 de 48 c7 c7 20 79 87 b5
>>> e8 1c 07 ae ff <0f> 0b 4c 89 e7 e8 52 40 cd ff 4c 89 e2 48 89 de 48 c7
>>> c7 58 79 87
>>> [ 4504.423085] [=C2=A0 T63683] RSP: 0018:ff4efd9f3838fdb0 EFLAGS: 00010=
246
>>> [ 4504.423093] [=C2=A0 T63683] RAX: 000000000000004e RBX: ff2adc9b51d19=
a90
>>> RCX: 0000000000000027
>>> [ 4504.423103] [=C2=A0 T63683] RDX: 0000000000000000 RSI: 0000000000000=
001
>>> RDI: ff2add151cf99580
>>> [ 4504.423112] [=C2=A0 T63683] RBP: dead000000000100 R08: 0000000000000=
000
>>> R09: 0000000000000003
>>> [ 4504.423120] [=C2=A0 T63683] R10: ff4efd9f3838fc60 R11: ff2add151cdff=
fe8
>>> R12: dead000000000122
>>> [ 4504.423130] [=C2=A0 T63683] R13: ff2adc9b51d19a00 R14: 0000000000000=
000
>>> R15: 0000000000000000
>>> [ 4504.423139] [=C2=A0 T63683] FS:=C2=A0 00007fae4f7ff6c0(0000)
>>> GS:ff2add15665f5000(0000) knlGS:0000000000000000
>>> [ 4504.423148] [=C2=A0 T63683] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0:=20
>>> 0000000080050033
>>> [ 4504.423157] [=C2=A0 T63683] CR2: 000055aa8afe5000 CR3: 00000083037ee=
006
>>> CR4: 0000000000773ef0
>>> [ 4504.423166] [=C2=A0 T63683] PKRU: 55555554
>>> [ 4504.423171] [=C2=A0 T63683] Call Trace:
>>> [ 4504.423178] [=C2=A0 T63683]=C2=A0 <TASK>
>>> [ 4504.423184] [=C2=A0 T63683]=C2=A0 io_do_iopoll+0x298/0x330
>>> [ 4504.423193] [=C2=A0 T63683]=C2=A0 ? asm_sysvec_apic_timer_interrupt+=
0x1a/0x20
>>> [ 4504.423204] [=C2=A0 T63683]=C2=A0 __do_sys_io_uring_enter+0x421/0x77=
0
>>> [ 4504.423214] [=C2=A0 T63683]=C2=A0 do_syscall_64+0x67/0xf00
>>> [ 4504.423223] [=C2=A0 T63683]=C2=A0 entry_SYSCALL_64_after_hwframe+0x7=
6/0x7e
>>> [ 4504.423232] [=C2=A0 T63683] RIP: 0033:0x55aa707e99c3
>>>
>>> It can be reproduced in three ways:
>>> - Running iopoll tests while switching the block scheduler
>>> - A split IO scenario in iopoll (e.g., bs=3D512k with max_sectors_kb=3D=
256k)
>>> - Multi poll queues with multi threads
>>>
>>> All cases appear related to IO completions occurring outside the
>>> io_do_iopoll() loop. The root cause remains unclear.
>>
>> Ah I see what it is - we can get multiple completions on the iopoll
>> side, if you have multiple bio's per request. This didn't matter before
>> the patch that uses a lockless list to collect them, as it just marked
>> the request completed by writing to ->iopoll_complete and letting the
>> reaper find them. But it matters with the llist change, as then we're
>> adding the request to the llist more than once.
>>
>>
>=20
>  From e2f749299e3c76ef92d3edfd9f8f7fc9a029129a Mon Sep 17 00:00:00 2001
> From: Diangang Li <lidiangang@bytedance.com>
> Date: Fri, 19 Dec 2025 10:14:33 +0800
> Subject: [PATCH] io_uring: fix race between adding to ctx->iopoll_list=20
> and ctx->iopoll_complete
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>=20
> Since commit 316693eb8aed ("io_uring: be smarter about handling IOPOLL
> completions") introduced ctx->iopoll_complete to cache polled=20
> completions, a request can be enqueued to ctx->iopoll_complete as part=20
> of a batched poll while it is still in the issuing path.
>=20
> If the IO was submitted via io_wq_submit_work(), it may still be stuck=20
> in io_iopoll_req_issued() waiting for ctx->uring_lock, which is held by
> io_do_iopoll(). In this state, io_do_iopoll() may attempt to delete the
> request from ctx->iopoll_list before it has ever been linked, leading to=
=20
> a list_del() corruption.
>=20
> Fix this by introducing an iopoll_state flag to mark whether the request
> has been inserted into ctx->iopoll_list. When io_do_iopoll() tries to
> unlink a request and the flag indicates it hasn=E2=80=99t been linked yet=
, skip
> the list_del() and just requeue the completion to ctx->iopoll_complete=20
> for later reap.
>=20
> Signed-off-by: Diangang Li <lidiangang@bytedance.com>
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> ---
>  =C2=A0include/linux/io_uring_types.h | 1 +
>  =C2=A0io_uring/io_uring.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 1 +
>  =C2=A0io_uring/rw.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 7 +++++++
>  =C2=A0io_uring/uring_cmd.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 1 +
>  =C2=A04 files changed, 10 insertions(+)
>=20
> diff --git a/include/linux/io_uring_types.h b/include/linux/=20
> io_uring_types.h
> index 0f619c37dce4..aaf26911badb 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -677,6 +677,7 @@ struct io_kiocb {
>  =C2=A0=C2=A0=C2=A0=C2=A0 };
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0 u8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 opcode;
> +=C2=A0=C2=A0=C2=A0 u8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iopoll_state;
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0 bool=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cancel_seq_set;
>=20
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 5e503a0bfcfc..4eb206359d05 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1692,6 +1692,7 @@ static void io_iopoll_req_issued(struct io_kiocb=20
> *req, unsigned int issue_flags)
>  =C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0 list_add_tail(&req->iopoll_node, &ctx->iopoll_l=
ist);
> +=C2=A0=C2=A0=C2=A0 smp_store_release(&req->iopoll_state, 1);
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(needs_lock)) {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index ad481ca74a46..d1397739c58b 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -869,6 +869,7 @@ static int io_rw_init_file(struct io_kiocb *req,=20
> fmode_t mode, int rw_type)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 return -EOPNOTSUPP;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kiocb->private =3D NULL=
;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kiocb->ki_flags |=3D IO=
CB_HIPRI;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->iopoll_state =3D 0;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ctx->flags & IORING=
_SETUP_HYBRID_IOPOLL) {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 /* make sure every req only blocks once*/
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 req->flags &=3D ~REQ_F_IOPOLL_STATE;
> @@ -1355,6 +1356,12 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool=20
> force_nonspin)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct llist_node *next=
 =3D node->next;
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req =3D container_of(no=
de, struct io_kiocb, iopoll_done_list);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!READ_ONCE(req->iopoll_st=
ate)) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 node-=
>next =3D NULL;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 llist=
_add(&req->iopoll_done_list, &ctx->iopoll_complete);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 node =
=3D next;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 conti=
nue;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_del(&req->iopoll_n=
ode);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wq_list_add_tail(&req->=
comp_list, &ctx->submit_state.compl_reqs);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nr_events++;
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 0841fa541f5d..cf2eacea5be8 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -251,6 +251,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int=
=20
> issue_flags)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!file->f_op->uring_=
cmd_iopoll)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 return -EOPNOTSUPP;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 issue_flags |=3D IO_URI=
NG_F_IOPOLL;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->iopoll_state =3D 0;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ctx->flags & IORING=
_SETUP_HYBRID_IOPOLL) {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 /* make sure every req only blocks once */
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 req->flags &=3D ~REQ_F_IOPOLL_STATE;

Hi Jens,

Regarding the analysis of this list_del corruption issue and the fix=20
patch, do you have any other comments?

Best regards,
Diangang Li

