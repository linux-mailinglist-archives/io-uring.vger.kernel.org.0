Return-Path: <io-uring+bounces-8340-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FBA7AD95CD
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 21:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 804BE189E932
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 19:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A1623A990;
	Fri, 13 Jun 2025 19:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XOwKxyrl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC0B1993B9;
	Fri, 13 Jun 2025 19:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749844305; cv=none; b=L0XVfsjMi2Mo/BctX1AU+munYhMUKriTDG20WtTAqb1mTuqm+nFcXc0v16PtuB4DGla/komM5PxJI3eiho6jLJ7b4kI10osPW9UsW+BapO6nkFpfJRex2RG1hhxriG6ALchzjZ3idta6N7Pw4+kDI7fwAg74pHYmsGSPSzVyfzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749844305; c=relaxed/simple;
	bh=hkjH3jGhp6c6JuTPd/+HwtyvCL+Paord2dnC/mZAr0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JoCrEuEotnfMN1rgjKcd/8DMIB33m9ZYlddHhLMWIt2HMtdSgBetIIdQpyMY2jDMEyXkC4nw4LWf42nvsFCuT2Kx6Jq4C9oZSFAUKbl+dI2Hau06hh9OD3wQwp+qLLR7vdjfcWNCKUX2+K3EArPecd+9XmLdQ6CViDhu4VvQH3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XOwKxyrl; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a528243636so1557163f8f.3;
        Fri, 13 Jun 2025 12:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749844302; x=1750449102; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8RMTqA9/AALqHtkW2ZYDpZeXqFJrkLAJ7HRjWRQZhog=;
        b=XOwKxyrl3zNGOzLcnd/iMSNlZ4qlPgIcR+U9elSiR78ol2Iw2OlKEt2A9OJ5B759mz
         moNMNhc9/XK4mfJ5eW2TB7r67tGNIB2TKXXrHorZvr+UeMrT0dJoWPLLEJ0/qPYftCmW
         jnJ7i5LuHGaG8booJQxwi7LorulWDwEy7b22CK5FI/uwerLHhnv/B00X8nmyhVNl8GTa
         JFnaiIwjj/hdeadVvyn4efSqIcguSIFV/ThMPhOoU4IP5NhXeGk0Pz9JBDKe2u43FNRR
         P3I3UhypSVk3Hv4Ove1sdd3ad7xhDufhNca2EGXVERJTcMI0tN+U1fnzsovtCcuwsqiY
         NWIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749844302; x=1750449102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8RMTqA9/AALqHtkW2ZYDpZeXqFJrkLAJ7HRjWRQZhog=;
        b=XtSDEjFMfERSC5qUO9OgNXfZuLeoomeOKraLOPr6U4Ps/BEjdZ8B+ze4mqxUOl6j6S
         XfsL5HUsuasLhpGV14wKFilJ0AJMN5SfDyGzQX2dlmvVAFHFIXaH/i/rRDUaAslvUpBC
         JvbFbdqQ0mI7iIKnf6/B0KmFdEOUtqpIXdEN3Q3GjrpnBnbVNCIh5+ifIYXyzGvx0QIu
         K53Auk+75eWaQZefNGvb7xnZk7D/E2/LNg3IxQ7bTDPrAm7xs2QZkPmDVAyY5Hb2fK5c
         AHwibWVylSvBPUyrpfXIpYBLacTtHRFaVPNq5CaBg/PZV9VLt2f19lToOsdG7P1jiHB/
         PPOA==
X-Forwarded-Encrypted: i=1; AJvYcCWZrcwpGu6U3kcK65p2C0hktio9N3KrvngE8Oif1Bl2NP+77vfYengw2FUh7IXUjB9LWWuKKlwpM+0=@vger.kernel.org, AJvYcCXncfvJ7NhhGuabrHDbVL2dzotq1RJvAAe6vMezZBbABNOGqKRpoU1+wgX2S3exv+6FCaWon8VyutUg10fz@vger.kernel.org, AJvYcCXvitwY0h+tOS00jNFmFuJZDQc4A562NVcnPWZ/rcibYFjzNTbVxuGO/dIDM1VC9OKms38=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdW+qKCF0QmU9cLRILOjqGGcIcuxmK2Nye0b4FHgbTYwuuorB/
	cgbpDmViYqLBGqXyPg5BXNqwLSCGM64bemqzo/Y/Cpx5iM0Hp8XyYFAn4OZ+KIvJvnEnWPLLi8j
	0cPIMrevKM/WaNYsK6iS2rYu48WLFpVQ=
X-Gm-Gg: ASbGncvlwxviXx/yLUlwblJetCN2wmABoV5BpKwLM382/NdXEJjQEBHpvcPEQUfSXYg
	+ZjYc7ALSA7/m3KxdlacsIoH/1tVjrMLWlPjog1JRbRf3HfjFRoGd9wFOXA5jn+WmBzHX5dBiuu
	PBC0j9GfVjItcPbBI0lslOmGAyclt6QtKVT/srsE/15F5MTyz4ukloNevuvhjBChZW/252RRLF
X-Google-Smtp-Source: AGHT+IEH6N/JU6XFU/9UHBpiejq+rpKEhEZl1TIDOk5TrZShSP3LJDXDw/ehw7Blrm6KrGOz1tOOQjcothNo/ahnBfQ=
X-Received: by 2002:a05:6000:2003:b0:3a4:dd02:f565 with SMTP id
 ffacd0b85a97d-3a572397756mr1002900f8f.3.1749844301956; Fri, 13 Jun 2025
 12:51:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1749214572.git.asml.silence@gmail.com> <c4de7ed6e165f54e2166e84bc88632887d87cfdf.1749214572.git.asml.silence@gmail.com>
 <CAADnVQJgxnQEL+rtVkp7TB_qQ1JKHiXe=p48tB_-N6F+oaDLyQ@mail.gmail.com>
 <8aa7b962-40a6-4bbc-8646-86dd7ce3380e@gmail.com> <CAADnVQ+--s_zGdRg4VHv3H317dCrx_+nEGH7FNYzdywkdh3n-A@mail.gmail.com>
 <415993ef-0238-4fc0-a2e5-acb938ec2b10@gmail.com>
In-Reply-To: <415993ef-0238-4fc0-a2e5-acb938ec2b10@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 13 Jun 2025 12:51:30 -0700
X-Gm-Features: AX0GCFuhJ8xUcwBe-bKhFldxUiIl1DHxYWxxcoKc081DDOnh-5dfvgQjYLVQl9g
Message-ID: <CAADnVQKu6Q1ePFuxxSLNsm-xggZbUEmWb_Y=4zeU54aAt5o6HA@mail.gmail.com>
Subject: Re: [RFC v2 5/5] io_uring/bpf: add basic kfunc helpers
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>, io-uring@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@linux.dev>, bpf <bpf@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2025 at 9:11=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 6/13/25 01:25, Alexei Starovoitov wrote:
> > On Thu, Jun 12, 2025 at 6:25=E2=80=AFAM Pavel Begunkov <asml.silence@gm=
ail.com> wrote:
> ...>>>> +BTF_ID_FLAGS(func, bpf_io_uring_extract_next_cqe, KF_RET_NULL);
> >>>> +BTF_KFUNCS_END(io_uring_kfunc_set)
> >>>
> >>> This is not safe in general.
> >>> The verifier doesn't enforce argument safety here.
> >>> As a minimum you need to add KF_TRUSTED_ARGS flag to all kfunc.
> >>> And once you do that you'll see that the verifier
> >>> doesn't recognize the cqe returned from bpf_io_uring_get_cqe*()
> >>> as trusted.
> >>
> >> Thanks, will add it. If I read it right, without the flag the
> >> program can, for example, create a struct io_ring_ctx on stack,
> >> fill it with nonsense and pass to kfuncs. Is that right?
> >
> > No. The verifier will only allow a pointer to struct io_ring_ctx
> > to be passed, but it may not be fully trusted.
> >
> > The verifier has 3 types of pointers to kernel structures:
> > 1. ptr_to_btf_id
> > 2. ptr_to_btf_id | trusted
> > 3. ptr_to_btf_id | untrusted
> >
> > 1st was added long ago for tracing and gradually got adopted
> > for non-tracing needs, but it has a foot gun, since
> > all pointer walks keep ptr_to_btf_id type.
> > It's fine in some cases to follow pointers, but not in all.
> > Hence 2nd variant was added and there
> > foo->bar dereference needs to be explicitly allowed
> > instead of allowed by default like for 1st kind.
> >
> > All loads through 1 and 3 are implemented as probe_read_kernel.
> > while loads from 2 are direct loads.
> >
> > So kfuncs without KF_TRUSTED_ARGS with struct io_ring_ctx *ctx
> > argument are likely fine and safe, since it's impossible
> > to get this io_ring_ctx pointer by dereferencing some other pointer.
> > But better to tighten safety from the start.
> > We recommend KF_TRUSTED_ARGS for all kfuncs and
> > eventually it will be the default.
>
> Sure, I'll add it, thanks for the explanation
>
> ...>> diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> >> index 9494e4289605..400a06a74b5d 100644
> >> --- a/io_uring/bpf.c
> >> +++ b/io_uring/bpf.c
> >> @@ -2,6 +2,7 @@
> >>    #include <linux/bpf_verifier.h>
> >>
> >>    #include "io_uring.h"
> >> +#include "memmap.h"
> >>    #include "bpf.h"
> >>    #include "register.h"
> >>
> >> @@ -72,6 +73,14 @@ struct io_uring_cqe *bpf_io_uring_extract_next_cqe(=
struct io_ring_ctx *ctx)
> >>          return cqe;
> >>    }
> >>
> >> +__bpf_kfunc
> >> +void *bpf_io_uring_get_region(struct io_ring_ctx *ctx, u64 size__rets=
z)
> >> +{
> >> +       if (size__retsz > ((u64)ctx->ring_region.nr_pages << PAGE_SHIF=
T))
> >> +               return NULL;
> >> +       return io_region_get_ptr(&ctx->ring_region);
> >> +}
> >
> > and bpf prog should be able to read/write anything in
> > [ctx->ring_region->ptr, ..ptr + size] region ?
>
> Right, and it's already rw mmap'ed into the user space.
>
> > Populating (creating) dynptr is probably better.
> > See bpf_dynptr_from*()
> >
> > but what is the lifetime of that memory ?
>
> It's valid within a single run of the callback but shouldn't cross
> into another invocation. Specifically, it's protected by the lock,
> but that can be tuned. Does that match with what PTR_TO_MEM expects?

yes. PTR_TO_MEM lasts for duration of the prog.

> I can add refcounting for longer term pinning, maybe to store it
> as a bpf map or whatever is the right way, but I'd rather avoid
> anything expensive in the kfunc as that'll likely be called on
> every program run.

yeah. let's not add any refcounting.

It sounds like you want something similar to
__bpf_kfunc __u8 *
hid_bpf_get_data(struct hid_bpf_ctx *ctx, unsigned int offset, const
size_t rdwr_buf_size)

we have a special hack for it already in the verifier.
The argument need to be called rdwr_buf_size,
then it will be used to establish the range of PTR_TO_MEM.
It has to be run-time constant.

What you're proposing with "__retsz" is a cleaner version of the same.
But consider bpf_dynptr_from_io_uring(struct io_ring_ctx *ctx)
it can create a dynamically sized region,
and later use bpf_dynptr_slice_rdwr() to get writeable chunk of it.

I feel that __retsz approach may actually be a better fit at the end,
if you're ok with constant arg.

