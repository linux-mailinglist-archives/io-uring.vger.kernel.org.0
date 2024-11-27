Return-Path: <io-uring+bounces-5104-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C7DF9DAF5E
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 23:54:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 566AC166F03
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 22:54:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9840F13BC35;
	Wed, 27 Nov 2024 22:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZmhRU+el"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53AB204081
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 22:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748031; cv=none; b=WYm1IlT53oaJjtotvbjoZQBVKukjsHVKXFxzI/FHLCAPy2WPdWeQmZYIQzNLxPhZdqSLCr492j4V23wwM+1JB1AX80ZuDNmRWhg1mlHGa4O80d8GWYnue/aXaqZFax+osGQEGbHEFubaCdTJZJiA97s7cdYV3/k6/nCRpsIA69g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748031; c=relaxed/simple;
	bh=FTdkXYT3MbCr2UlyGLRQDYjmo7m1sFUqPEejSlQ9bJg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JmjMO4viqgD4efHqWwpMzuz29Py1QTbY2W1SO+ksbMoUCpzdVy9p7x0HWgi6BpXBT6/ZF7atL39a7dJRmpE3hi2XdIxLeRGr8gcMUxGW0z3TNclmWK4l3NpUpIVAyigVx21sAHUpRjm0dwBcUdkQUC9KKnYoTAfq8jiWYbzQchU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZmhRU+el; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5cfc18d5259so311a12.1
        for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 14:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732748028; x=1733352828; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Rcv11/t22rS5AI6Q5DxcJyoDs0LYfTQoHvoxeEY324=;
        b=ZmhRU+elRjGDDTyeS7DyBblmmwbCCY6FK7xXo/kg32cEt6/2xExL8CWme3F5HyN/CR
         lm1l+pJAMr7D/tfxr2bXYqnWAySXLjLkUgHeQvCyKo14QZMgfwQaKUuUjIsP9utENHe1
         SfkX8IOmSp338v4J5eNfRFGNdRA4yb5cjHqdw2qHXLpSymiPUG1zLP2kMZ9HtANPZjAS
         L03CAUU53aIUqB0PFQtcZFowVHJ1Fr6vhMOhkzFKwPavEtHmd05XHfVVpWeTrlTpW8wg
         6khkPZwqqJae3DWBuxMJLf7wkIseII1tqcbgsUuQow4fmQzYBj3Ms8mXQoaRbvFJVfNF
         SjTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732748028; x=1733352828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Rcv11/t22rS5AI6Q5DxcJyoDs0LYfTQoHvoxeEY324=;
        b=aA/9RDi49Q43JBkKWu8o1LcPxK1j7K3ZOQ7VklWYtTPafOnDNCThdD9PwhgNiqdB1y
         9qA6mD+6vHttCMCmdMmgx+zSayIan9sGgjGAOWdtVqV1KjEdiWvAvmD+7y/55Pu5RxSt
         D5Coi6auYhSO13UjReVt8KwzIaPw1bD+zJzc4x2P/Qf4pIwnx8TdjrnMubq8YxDZo4Xm
         YuLJOz+DFZ9cn4FAci+pTVZee/6sJfDCc8EKrPvK6OpikHkaoT7CB8t22WH+vitxSaXK
         Nhpzvuv3FdXg40KPRADX0NsuKquOTBkyS60YB4KhtE7iIrF9Em8HsueCf/AsvRRehqH1
         z+NQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOEe2loHzQ7xdj95W03uFY+DYjeo+jCB//XZ/AWZPJZ5YMQtTui7nF2197quKkA5lBGUfqrrf8GQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzPm+Cj+Py0YUZA+H3uokbxaK0FyXlcTvOLuaLtgNAJmU+HaQ2v
	AtDMqHfQNjQXb8eFy1gIe+6RZiB4AujlGO+LJYgTuHyuNQP/0JRPnaXiKiKN79+H+LUgipPIrm7
	15sBAQT+tHw5He7jVU4QGaxQWugksjwIFoKKVRGQBa9GilsMgDNoRl5Y=
X-Gm-Gg: ASbGncv2kCbzBDuzqnnelbHHPqWeaAM4utLI1ZFexwIhoCfkr4A0mwUcnCpdWAS1/qR
	1I+GvtahACIsE9iiGb/Jq+T19EchLF7VFGX6Fz+WROf8O4HkMPYUchI0B5EM=
X-Google-Smtp-Source: AGHT+IGQK2NIR/Mj25JZwAIsnaefw5zRd8osQmsPGjtPZihEj18wQ3Zld5gWQM5+JyIK2eyWtjTBVR/3UzBoC24V9Gc=
X-Received: by 2002:a50:ab50:0:b0:5d0:3bfb:c479 with SMTP id
 4fb4d7f45d1cf-5d098206dfamr5491a12.3.1732748027540; Wed, 27 Nov 2024 14:53:47
 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <fd36cd900023955c763bd424c0895ae5828f68a0.1731979403.git.asml.silence@gmail.com>
 <0dfd1032-6ddd-49b3-a422-569af2307d3b@kernel.dk> <d5e9c79f-d571-4f3a-9145-f7e349e532ae@gmail.com>
 <278a1964-b795-4146-8f24-19f112af75b0@kernel.dk> <8bc3b927-b7f0-425f-8874-a3905b30759d@gmail.com>
In-Reply-To: <8bc3b927-b7f0-425f-8874-a3905b30759d@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 27 Nov 2024 23:53:11 +0100
Message-ID: <CAG48ez3QNBvryTaf7s6G--Cgcuq2_vUmgJQOFxPLeySbsGj0Kg@mail.gmail.com>
Subject: Re: [PATCH 1/1] io_uring: prevent reg-wait speculations
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 21, 2024 at 1:12=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
> On 11/19/24 01:59, Jens Axboe wrote:
> > On 11/18/24 6:43 PM, Pavel Begunkov wrote:
> >> On 11/19/24 01:29, Jens Axboe wrote:
> >>> On 11/18/24 6:29 PM, Pavel Begunkov wrote:
> >>>> With *ENTER_EXT_ARG_REG instead of passing a user pointer with argum=
ents
> >>>> for the waiting loop the user can specify an offset into a pre-mappe=
d
> >>>> region of memory, in which case the
> >>>> [offset, offset + sizeof(io_uring_reg_wait)) will be intepreted as t=
he
> >>>> argument.
> >>>>
> >>>> As we address a kernel array using a user given index, it'd be a sub=
ject
> >>>> to speculation type of exploits.
> >>>>
> >>>> Fixes: d617b3147d54c ("io_uring: restore back registered wait argume=
nts")
> >>>> Fixes: aa00f67adc2c0 ("io_uring: add support for fixed wait regions"=
)
> >>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >>>> ---
> >>>>    io_uring/io_uring.c | 1 +
> >>>>    1 file changed, 1 insertion(+)
> >>>>
> >>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >>>> index da8fd460977b..3a3e4fca1545 100644
> >>>> --- a/io_uring/io_uring.c
> >>>> +++ b/io_uring/io_uring.c
> >>>> @@ -3207,6 +3207,7 @@ static struct io_uring_reg_wait *io_get_ext_ar=
g_reg(struct io_ring_ctx *ctx,
> >>>>                 end > ctx->cq_wait_size))
> >>>>            return ERR_PTR(-EFAULT);
> >>>>    +    barrier_nospec();
> >>>>        return ctx->cq_wait_arg + offset;
> >>>
> >>> We need something better than that, barrier_nospec() is a big slow
> >>> hammer...
> >>
> >> Right, more of a discussion opener. I wonder if Jann can help here
> >> (see the other reply). I don't like back and forth like that, but if
> >> nothing works there is an option of returning back to reg-wait array
> >> indexes. Trivial to change, but then we're committing to not expanding
> >> the structure or complicating things if we do.
> >
> > Then I think it should've been marked as a discussion point, because we
> > definitely can't do this. Soliciting input is perfectly fine. And yeah,
> > was thinking the same thing, if this is an issue then we just go back t=
o
> > indexing again. At least both the problem and solution is well known
> > there. The original aa00f67adc2c0 just needed an array_index_nospec()
> > and it would've been fine.
> >
> > Not a huge deal in terms of timing, either way.
> >
> > I suspect we can do something similar here, with just clamping the
> > indexing offset. But let's hear what Jann thinks.
>
> That what I hope for, but I can't say I entirely understand it. E.g.
> why can_do_masked_user_access() exists and guards mask_user_address().

FWIW, my understanding is that x86-64 can do this because there is a
really big hole in the virtual address space between userspace
addresses and kernel addresses (over 2^63 bytes big); so if you check
that the address at which you start accessing memory is in userspace,
and then you access memory more or less linearly forward from there,
you'll never reach kernelspace addresses.

> IIRC, with invalid argument the mask turns the index into 0. A complete
> speculation from my side of how it works is that you then able to
> "inspect" or what's the right word the value of array[0] but not a
> address of memory of choice.

Yeah, exactly, that's the idea of array_index_nospec(). As the comment
above the generic version of array_index_mask_nospec() describes, the
mask used for the bitwise AND in array_index_nospec() is generated as
follows:
"When @index is out of bounds (@index >=3D @size), the sign bit will be
set.  Extend the sign bit to all bits and invert, giving a result of
zero for an out of bounds index, or ~0 if within bounds [0, @size)."

The X86 version of array_index_mask_nospec() just does the same with
optimized assembly code. But there are architectures, like arm64, that
actually do more than just this - arm64's array_index_mask_nospec()
additionally includes a csdb(), which is some arm64 barrier for some
kinds of speculation. (So, for example, open-coding a bitwise AND may
not be enough on all architectures.)

> Then in our case, considering that
> mappings are page sized, array_index_nospec() would clamp it to either
> first 32 bytes of the first page or to absolute addresses [0, 32)
> in case size=3D=3D0 and the mapping is NULL. But that could be just my
> fantasy.

Without having looked at this uring code in detail: What you're saying
sounds reasonable to me. Though one thing to be careful with is that
if the value you're masking is a byte offset, you should ideally make
sure to give array_index_mask_nospec() a limit that is something like
the size of the region minus the size of an element - you should
probably assume that the preceding "if (unlikely(offset %
sizeof(long)))" could be bypassed in speculation, though in practice
that's probably unlikely since it'd compile into something
straightforward like a bitmask-and-test with immediate operands.

