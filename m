Return-Path: <io-uring+bounces-8329-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E582EAD7F9B
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 02:25:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBA0A18940DD
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 00:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A369A1B414A;
	Fri, 13 Jun 2025 00:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8J114Y3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2ED219E0;
	Fri, 13 Jun 2025 00:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749774322; cv=none; b=R5FNQj5748Ppvu6kbgFcUaukVfJ57OL8g1qmwHYoyCAFIUsKrOuIDg7kvRZF2uFnpg3t4MUZYd5e5sjCWS67x8EsAdysdHAFuaoO2KeYUTR7iLsjcuA5T2FoiMzz/UWI+GmWM8mVlUt9gewfVUJxBMvGKQkRp7gNP83UFmYtw8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749774322; c=relaxed/simple;
	bh=KOlum+J8kvBWXOiz2MOiHDhRZrX3PwYKoOaHJ27JLBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fD8TAm0doDarZYNjVi/nTc/LCeJvYYc3Y2sR1lGf/lmCl5mVxsfOUPEu3HCqeRmqg+S1A/+p/NeR/AEmh6EYMweVr3x5Ge0csplEX6I94W7DMha06gnFivxyhopT9t2rYUmXdUmV8gKWx06O/ozd23w0XjuDRqd/ABLOad9HYO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j8J114Y3; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-442fda876a6so13331615e9.0;
        Thu, 12 Jun 2025 17:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749774319; x=1750379119; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BtY2lCk3uzspSzuYUeIi/Qq4T39UA0U6nXtfkQzRaPA=;
        b=j8J114Y3pPpctKy0PSRMQbEUjcliXudtxBq7v/v6YvbDe10vDFkM0R2Kx/IMASoGUd
         3zHj9aNz2Qwvl7T3rxSZL7lCMTCPkwWRQmtH9tF9fwZycSHta0e9Ot2mtcPkTZoLxulS
         baibHrGrtY+8RTOU1ez3opfN98NdBzweLhreBArQGMJSHZbup2tiVpZOk1kTaNv2KnWJ
         4AQZAk9suMW1FcAc8pgn49ifexvkoj46X6TUENdgCC6pLkN98RDgE9LIlQV+vzylWdJO
         GUDrtwtR0XjO6UBVgcanjAFpKtUyjrd6haVmysJ3RxY4NVGA+a1ZymexW2KK1pBEApCH
         BSUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749774319; x=1750379119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BtY2lCk3uzspSzuYUeIi/Qq4T39UA0U6nXtfkQzRaPA=;
        b=njrwwbUHDX+ImClf95ubFSspgSJ/uxjPjFcBMRzWPhJqrnG47CeiZCZQvRBJVGtOPG
         /9/4exXY8RkzGoacq4WgBcm/tuIto7eP4zW0y/yjTd13GauHGjr5TwgKkHiIo+gf6v1q
         262LZO/CSCb5bCkL9Eov6QsjRSUeAygQA+iyYuJIx94PpYedvyfxAjTe2NQWoGr2aF9G
         +SMV1V00B48ty8NYTbl8hzCI4DQyTP6gF4CMm7MgrC8GC7k3Ysbjuj/T8tzuLB9F8rIx
         iCeaWWcC/L+HwMCelwzX7VUagF+m5t/bbkvnFVdhEWzuDD2HPnV+B6LRZnrKbOHV1Vo5
         +fHg==
X-Forwarded-Encrypted: i=1; AJvYcCV+BDUxJnU/xHjyXF+uZN0w+PBLCRy+gez7XoWeC2xHAOvkwIfRGHrnyBPFTE4Bi5G7pfs=@vger.kernel.org, AJvYcCWQ4KQGWFR9BwgUCDl7GMTSD8BdWaQxlTgGW9Gb0slEEV0Q9ilvIrTF+OsVCfDT7Zp8X6qXGc/tfqheWQyJ@vger.kernel.org
X-Gm-Message-State: AOJu0YzeYkQ9PG6zh+DiLw+DYIMf/Bl1ub+EDWaD3g8dhWrdnjfPpaYR
	vvpPET0F3FRM6/sZnVXw7R/B4jDo43Fj1OJy21eEpbkuKMeDoHrcD61bYvhBEw+FO6V4kvizxhy
	1QSU7B3FwWck3kXZXWJsefAhUD/L34n8417PO
X-Gm-Gg: ASbGncsS4nUNtSBcOJAQUfAGbxiZQgRt787Jb9sI/Hs7bTAhsYUxS5aL3XvwNyHfJq6
	+zRkohnDqq5xI9fJ0H4TLCHYKBN7vOPQ27CabRTjQ9MlnXsQtBwPQb8Gd91OCnrJDWSuSa9/O4H
	12tYbMkd+OaRfXxipIpP0cEvms2ei1xx5eMlC/qlehkU7pvWeOrvDKT1QEF30RjhwxBlAM7ehh
X-Google-Smtp-Source: AGHT+IF76pGBYxGZYWw+CJokdxXh6p6fIroXhuyYAPs9g7npmaYdejWwOR9kgrMPXPQHyCCG3MzqkJp4opYixEpEZ9E=
X-Received: by 2002:a5d:588a:0:b0:3a4:f52d:8b11 with SMTP id
 ffacd0b85a97d-3a5686f59e0mr1042820f8f.20.1749774318887; Thu, 12 Jun 2025
 17:25:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1749214572.git.asml.silence@gmail.com> <c4de7ed6e165f54e2166e84bc88632887d87cfdf.1749214572.git.asml.silence@gmail.com>
 <CAADnVQJgxnQEL+rtVkp7TB_qQ1JKHiXe=p48tB_-N6F+oaDLyQ@mail.gmail.com> <8aa7b962-40a6-4bbc-8646-86dd7ce3380e@gmail.com>
In-Reply-To: <8aa7b962-40a6-4bbc-8646-86dd7ce3380e@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 12 Jun 2025 17:25:07 -0700
X-Gm-Features: AX0GCFsinQTNjdnmxTBWf-QlYZGnOFA6IRDU-2AFsvp0E2RrYTzY6ZCebXQDLVg
Message-ID: <CAADnVQ+--s_zGdRg4VHv3H317dCrx_+nEGH7FNYzdywkdh3n-A@mail.gmail.com>
Subject: Re: [RFC v2 5/5] io_uring/bpf: add basic kfunc helpers
To: Pavel Begunkov <asml.silence@gmail.com>, Andrii Nakryiko <andrii@kernel.org>
Cc: io-uring@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>, 
	bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025 at 6:25=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 6/12/25 03:47, Alexei Starovoitov wrote:
> > On Fri, Jun 6, 2025 at 6:58=E2=80=AFAM Pavel Begunkov <asml.silence@gma=
il.com> wrote:
> ...>> +__bpf_kfunc
> >> +struct io_uring_cqe *bpf_io_uring_extract_next_cqe(struct io_ring_ctx=
 *ctx)
> >> +{
> >> +       struct io_rings *rings =3D ctx->rings;
> >> +       unsigned int mask =3D ctx->cq_entries - 1;
> >> +       unsigned head =3D rings->cq.head;
> >> +       struct io_uring_cqe *cqe;
> >> +
> >> +       /* TODO CQE32 */
> >> +       if (head =3D=3D rings->cq.tail)
> >> +               return NULL;
> >> +
> >> +       cqe =3D &rings->cqes[head & mask];
> >> +       rings->cq.head++;
> >> +       return cqe;
> >> +}
> >> +
> >> +__bpf_kfunc_end_defs();
> >> +
> >> +BTF_KFUNCS_START(io_uring_kfunc_set)
> >> +BTF_ID_FLAGS(func, bpf_io_uring_submit_sqes, KF_SLEEPABLE);
> >> +BTF_ID_FLAGS(func, bpf_io_uring_post_cqe, KF_SLEEPABLE);
> >> +BTF_ID_FLAGS(func, bpf_io_uring_queue_sqe, KF_SLEEPABLE);
> >> +BTF_ID_FLAGS(func, bpf_io_uring_get_cqe, 0);
> >> +BTF_ID_FLAGS(func, bpf_io_uring_extract_next_cqe, KF_RET_NULL);
> >> +BTF_KFUNCS_END(io_uring_kfunc_set)
> >
> > This is not safe in general.
> > The verifier doesn't enforce argument safety here.
> > As a minimum you need to add KF_TRUSTED_ARGS flag to all kfunc.
> > And once you do that you'll see that the verifier
> > doesn't recognize the cqe returned from bpf_io_uring_get_cqe*()
> > as trusted.
>
> Thanks, will add it. If I read it right, without the flag the
> program can, for example, create a struct io_ring_ctx on stack,
> fill it with nonsense and pass to kfuncs. Is that right?

No. The verifier will only allow a pointer to struct io_ring_ctx
to be passed, but it may not be fully trusted.

The verifier has 3 types of pointers to kernel structures:
1. ptr_to_btf_id
2. ptr_to_btf_id | trusted
3. ptr_to_btf_id | untrusted

1st was added long ago for tracing and gradually got adopted
for non-tracing needs, but it has a foot gun, since
all pointer walks keep ptr_to_btf_id type.
It's fine in some cases to follow pointers, but not in all.
Hence 2nd variant was added and there
foo->bar dereference needs to be explicitly allowed
instead of allowed by default like for 1st kind.

All loads through 1 and 3 are implemented as probe_read_kernel.
while loads from 2 are direct loads.

So kfuncs without KF_TRUSTED_ARGS with struct io_ring_ctx *ctx
argument are likely fine and safe, since it's impossible
to get this io_ring_ctx pointer by dereferencing some other pointer.
But better to tighten safety from the start.
We recommend KF_TRUSTED_ARGS for all kfuncs and
eventually it will be the default.

> > Looking at your example:
> > https://github.com/axboe/liburing/commit/706237127f03e15b4cc9c7c31c16d3=
4dbff37cdc
> > it doesn't care about contents of cqe and doesn't pass it further.
> > So sort-of ok-ish right now,
> > but if you need to pass cqe to another kfunc
> > you would need to add an open coded iterator for cqe-s
> > with appropriate KF_ITER* flags
> > or maybe add acquire/release semantics for cqe.
> > Like, get_cqe will be KF_ACQUIRE, and you'd need
> > matching KF_RELEASE kfunc,
> > so that 'cqe' is not lost.
> > Then 'cqe' will be trusted and you can pass it as actual 'cqe'
> > into another kfunc.
> > Without KF_ACQUIRE the verifier sees that get_cqe*() kfuncs
> > return 'struct io_uring_cqe *' and it's ok for tracing
> > or passing into kfuncs like bpf_io_uring_queue_sqe()
> > that don't care about a particular type,
> > but not ok for full tracking of objects.
>
> I don't need type safety for SQEs / CQEs, they're supposed to be simple
> memory blobs containing userspace data only. SQ / CQ are shared with
> userspace, and the kfuncs can leak the content of passed CQE / SQE to
> userspace. But I'd like to find a way to reject programs stashing
> kernel pointers / data into them.

That's impossible.
If you're worried about bpf prog exposing kernel addresses
to user space then abort the whole thing.
CAP_PERFMON is required for the majority of bpf progs.

>
> BPF_PROG(name, struct io_ring_ctx *io_ring)
> {
>      struct io_uring_sqe *cqe =3D ...;
>      cqe->user_data =3D io_ring;
>      cqe->res =3D io_ring->private_field;
> }
>
> And I mentioned in the message, I rather want to get rid of half of the
> kfuncs, and give BPF direct access to the SQ/CQ instead. Schematically
> it should look like this:
>
> BPF_PROG(name, struct io_ring_ctx *ring)
> {
>      struct io_uring_sqe *sqes =3D get_SQ(ring);
>
>      sqes[ring->sq_tail]->opcode =3D OP_NOP;
>      bpf_kfunc_submit_sqes(ring, 1);
>
>      struct io_uring_cqe *cqes =3D get_CQ(ring);
>      print_cqe(&cqes[ring->cq_head]);
> }
>
> I hacked up RET_PTR_TO_MEM for kfuncs, the diff is below, but it'd be
> great to get rid of the constness of the size argument. I need to
> digest arenas first as conceptually they look very close.

arena is a special memory region where every byte is writeable
by user space.

>
> > For next revision please post all selftest, examples,
> > and bpf progs on the list,
> > so people don't need to search github.
>
> Did the link in the cover letter not work for you? I'm confused
> since it's all in a branch in my tree, but you linked to the same
> patches but in Jens' tree, and I have zero clue what they're
> doing there or how you found them.

External links can disappear. It's not good for reviewers and
for keeping the history of conversation.

>
> diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> index 9494e4289605..400a06a74b5d 100644
> --- a/io_uring/bpf.c
> +++ b/io_uring/bpf.c
> @@ -2,6 +2,7 @@
>   #include <linux/bpf_verifier.h>
>
>   #include "io_uring.h"
> +#include "memmap.h"
>   #include "bpf.h"
>   #include "register.h"
>
> @@ -72,6 +73,14 @@ struct io_uring_cqe *bpf_io_uring_extract_next_cqe(str=
uct io_ring_ctx *ctx)
>         return cqe;
>   }
>
> +__bpf_kfunc
> +void *bpf_io_uring_get_region(struct io_ring_ctx *ctx, u64 size__retsz)
> +{
> +       if (size__retsz > ((u64)ctx->ring_region.nr_pages << PAGE_SHIFT))
> +               return NULL;
> +       return io_region_get_ptr(&ctx->ring_region);
> +}

and bpf prog should be able to read/write anything in
[ctx->ring_region->ptr, ..ptr + size] region ?

Populating (creating) dynptr is probably better.
See bpf_dynptr_from*()

but what is the lifetime of that memory ?

