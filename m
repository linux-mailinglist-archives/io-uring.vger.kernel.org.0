Return-Path: <io-uring+bounces-10011-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A829BDAF5D
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 20:37:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E2D83AF468
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 18:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 960D92951B3;
	Tue, 14 Oct 2025 18:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JZgk1mdf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D7B284880
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 18:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760467042; cv=none; b=TDwcL4vNXtNapHC9Vp3yijA5wZ9gNlQ9282opQBiYRfLuI2lY778g/U9vdpPudM6aQyy7IOb6v/Gkbw7KE+SUyW+M640PtHASCXSNZFssVkhwyOu+9Srf0ncd5wWQiUOt9M27w2YYlHudoAM3s+uwiWyK8+Gz59Tdknr0Tt8P4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760467042; c=relaxed/simple;
	bh=jzA2P4YGe6LKT8FiaAV3UakGGvttgadmNZeySgGJMUA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jiAx00CYlbSQ/AtxNeamSeYo3B0+5+BhuuQbDAqEU/i86C7DXw+HcD0s2UCCd8EA2Yd3y8CRFc8hWupwlIRA3JLHReKovlDgVQ/Rt+F9u1syKtSIMYx7k69vJ7JTMzdgtesaCTbL70AVyRwZhOz/KrD2W6Jp2qrDAEifPr2pKmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JZgk1mdf; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b63117fb83dso228589a12.3
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 11:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1760467040; x=1761071840; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xubvs84JPRKvMuOeA/SvKGU1MoFvS0nOfzc3i0FwOAI=;
        b=JZgk1mdfPi7u4Vqe7eR3gEkZPP4ssFb8Gylnnd22gRrfOcKTxVPXr0rRkhOK0JGV+T
         ZUJGk1jkHrJPA/dkoZR0lF2KRpZOMGt+t/Sfl7XdrxDdtHqQxpJwjwsIaBSD0GUW50hy
         iuR1gp/B27Yhx+3yLGPIuFp45KO9qLEr+CtSf/+OgFIsQKV1uxihyOFuNPyXUGS8Fu2R
         +4zbHRzaNYg2AhKuKOnoG0hcRKiP/MHp8K5TSskR/33TRnUplhf8pBnFhRu8NGbvDjPp
         XD6IxbCbhU5j7ZrBQgGGPK2OX86feMecXtU7770+A5DxDGQKLJhNgxCjUr2abHg5QyRL
         BQIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760467040; x=1761071840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xubvs84JPRKvMuOeA/SvKGU1MoFvS0nOfzc3i0FwOAI=;
        b=aaP6YYrZ18S/LLFUPd7I+z9hnFmYLYN+PxDenLTII1K9uUCH54p6YVpxEPK4r8c2zR
         7XUpSoZTHRqcuwFnJZ1brVQaEgc8LYWp0Zg0B8dR/aLiF03SfRwjcFFjsR88qbo7dZ9Y
         cqp9gdEjRW/qUpeKMsgp3/sL0iVfynsd3gLedmJLn2h6GPQC3fYM1ndz2UtWNQyGk7jr
         F0kSkxaQFSwavOSVNFMvnQTFfSdteyJiaeBw9XFs26EOZMgm5SdzTNSGm6wDk3+bbRpw
         ySipcMqlEed8BdSRNm1+6vIh+lUQo5+rmpP+P2FxFR8i/DuPJenlHbnr79/WGXnd0EU4
         lBKA==
X-Gm-Message-State: AOJu0YyVG4SxO+2Sa+UC9Sp5Oo8UN9WLS84F0h0wr+IE8+v5BbgHd6/6
	vFXwv7D5A+HQ+n/TfgLAJvFc/81ZHxcNe15z678aDTiEySTCibvOTl6egyl1xoPRn0F0qD9wBfH
	002SmaBkOgJL0VfirSoKgo7yuHAGjS3PRTe2MxZuTtCqkflU6l4h5o1khNA==
X-Gm-Gg: ASbGnctHenP8pSwe4OQr++vvBWq7h8uYHj7/QtHo3GG2S8857yCk8PWzkQFtUvN0K9a
	1VqymC9zW3xW8WFUqR0DuiKR3i6iEJ7B71Pv3G5BgbBnTCvRVCmD5a6V2yY8ds6HNjo3soYWe4e
	YXSDvCZFYPgcUvktCJogBYROl8PuBLiDJzXDAIr20DJIU+Q8kFE3virM8T2mkxkFZrWTz6zKBt3
	EeFagPwefDRqlh0leqE4FZJr7ZNXjUQQ1kFs8yRhGo92BptUk18cICqgvGIHlId/4xuJA==
X-Google-Smtp-Source: AGHT+IEiFV9FYAjSS9sc50zrr5yG7W20mz5S287vyAoIvxhXQ8EQ+vetD+3pWCxQpSYX+blw5L9Tm9TY5dEYJoBBuHE=
X-Received: by 2002:a17:903:1a6f:b0:257:3283:b859 with SMTP id
 d9443c01a7336-29027321d06mr204982025ad.9.1760467039562; Tue, 14 Oct 2025
 11:37:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1760438982.git.asml.silence@gmail.com> <d2cb4a123518196c2f33b9adfad8a8828969808c.1760438982.git.asml.silence@gmail.com>
In-Reply-To: <d2cb4a123518196c2f33b9adfad8a8828969808c.1760438982.git.asml.silence@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 14 Oct 2025 11:37:08 -0700
X-Gm-Features: AS18NWBZSh5OJ_xPLznPsrIandUXvHBwAEyFYXRqBqfjf6tq4VNWr0IVmrYc11o
Message-ID: <CADUfDZqXmmG+_9ENc6tJ4RRQ5L4_UKhWxZd3O5YGQP7tNo2iHg@mail.gmail.com>
Subject: Re: [PATCH 2/2] io_uring: introduce non-circular SQ
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025 at 3:57=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> Outside of SQPOLL, normally SQ entries are consumed by the time the
> submission syscall returns. For those cases we don't need a circular
> buffer and the head/tail tracking, instead the kernel can assume that
> entries always start from the beginning of the SQ at index 0. This patch
> introduces a setup flag doing exactly that.
>
> This method is simpler in general, needs fewer operations, doesn't
> require looking up heads and tails, however, the main goal here is to
> keep caches hot. The userspace might overprovision SQ, and in the normal
> way we'd be touching all the cache lines, but with this feature it
> reuses first entries and keeps them hot. This simplicity will also be
> quite handy for bpf-io_uring.
>
> To use the feature the user should set the IORING_SETUP_SQ_REWIND flag,
> and have a compatible liburing/userspace. The flag is restricted to
> IORING_SETUP_NO_SQARRAY rings and is not compatible with
> IORING_SETUP_SQPOLL.
>
> Note, it uses relaxed ring synchronisation as the userspace doing the
> syscall is naturally in sync, and setups that share a SQ should be
> rolling their own intra process/thread synchronisation.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/uapi/linux/io_uring.h |  6 ++++++
>  io_uring/io_uring.c           | 29 ++++++++++++++++++++++-------
>  io_uring/io_uring.h           |  3 ++-
>  3 files changed, 30 insertions(+), 8 deletions(-)
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
> index a0cc1cc0dd01..d1c654a7fa9a 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -231,6 +231,12 @@ enum io_uring_sqe_flags_bit {
>   */
>  #define IORING_SETUP_CQE_MIXED         (1U << 18)
>
> +/*
> + * SQEs always start at index 0 in the submission ring instead of using =
a
> + * wrap around indexing.
> + */
> +#define IORING_SETUP_SQ_REWIND         (1U << 19)

Keith's mixed-SQE-size patch series is already planning to use this
flag: https://lore.kernel.org/io-uring/20251013180011.134131-3-kbusch@meta.=
com/

> +
>  enum io_uring_op {
>         IORING_OP_NOP,
>         IORING_OP_READV,
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index ee04ab9bf968..e8af963d3233 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2367,12 +2367,16 @@ static void io_commit_sqring(struct io_ring_ctx *=
ctx)
>  {
>         struct io_rings *rings =3D ctx->rings;
>
> -       /*
> -        * Ensure any loads from the SQEs are done at this point,
> -        * since once we write the new head, the application could
> -        * write new data to them.
> -        */
> -       smp_store_release(&rings->sq.head, ctx->cached_sq_head);
> +       if (ctx->flags & IORING_SETUP_SQ_REWIND) {
> +               ctx->cached_sq_head =3D 0;

The only awkward thing about this interface seems to be if
io_submit_sqes() aborts early without submitting all the requested
SQEs. Does userspace then need to memmove() the remaining SQEs to the
start of the ring? It's certainly an unlikely case but something
userspace has to handle because io_alloc_req() can fail for reasons
outside its control. Seems like it might simplify the userspace side
if cached_sq_head wasn't rewound if not all SQEs were consumed.

> +       } else {
> +               /*
> +                * Ensure any loads from the SQEs are done at this point,
> +                * since once we write the new head, the application coul=
d
> +                * write new data to them.
> +                */
> +               smp_store_release(&rings->sq.head, ctx->cached_sq_head);
> +       }
>  }
>
>  /*
> @@ -2418,10 +2422,15 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, c=
onst struct io_uring_sqe **sqe)
>  int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>         __must_hold(&ctx->uring_lock)
>  {
> -       unsigned int entries =3D io_sqring_entries(ctx);
> +       unsigned int entries;
>         unsigned int left;
>         int ret;
>
> +       if (ctx->flags & IORING_SETUP_SQ_REWIND)
> +               entries =3D ctx->sq_entries;
> +       else
> +               entries =3D io_sqring_entries(ctx);
> +
>         entries =3D min(nr, entries);
>         if (unlikely(!entries))
>                 return 0;
> @@ -3678,6 +3687,12 @@ static int io_uring_sanitise_params(struct io_urin=
g_params *p)
>  {
>         unsigned flags =3D p->flags;
>
> +       if (flags & IORING_SETUP_SQ_REWIND) {
> +               if ((flags & IORING_SETUP_SQPOLL) ||
> +                   !(flags & IORING_SETUP_NO_SQARRAY))

Is there a reason IORING_SETUP_NO_SQARRAY is required? It seems like
the implementation would work just fine with the SQ indirection ring;
the rewind would just apply to the indirection ring instead of the SQE
array. The cache hit rate benefit would probably be smaller since many
more SQ indirection entries fit in a single cache line, but I don't
see a reason to explicitly forbid it.

Best,
Caleb

> +               return -EINVAL;
> +       }
> +
>         /* There is no way to mmap rings without a real fd */
>         if ((flags & IORING_SETUP_REGISTERED_FD_ONLY) &&
>             !(flags & IORING_SETUP_NO_MMAP))
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 46d9141d772a..b998ed57dd93 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -54,7 +54,8 @@
>                         IORING_SETUP_REGISTERED_FD_ONLY |\
>                         IORING_SETUP_NO_SQARRAY |\
>                         IORING_SETUP_HYBRID_IOPOLL |\
> -                       IORING_SETUP_CQE_MIXED)
> +                       IORING_SETUP_CQE_MIXED |\
> +                       IORING_SETUP_SQ_REWIND)
>
>  #define IORING_ENTER_FLAGS (IORING_ENTER_GETEVENTS |\
>                         IORING_ENTER_SQ_WAKEUP |\
> --
> 2.49.0
>
>

