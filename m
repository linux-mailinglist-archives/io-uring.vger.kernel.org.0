Return-Path: <io-uring+bounces-10015-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD29BDBA78
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 00:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 550D5351EBA
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 22:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADDE207DE2;
	Tue, 14 Oct 2025 22:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="WiCjvjAe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05C21FB1
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 22:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760481213; cv=none; b=KG3UZ/m6GcrZo1hLR97CPoTn+XLaNjpCIMQW4DtUEXpwddOyUfmbZzbrj3e0wQgsQUS/4UVi3NeEl/pEI6my+tXEcy2BwybfyDbS0wcAyJNglUFBKm6lG0jeuqvBi1n0PiT+GEe7wV9JWsovYUsHLUD8/0LbigUMcLrrgm4Z5xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760481213; c=relaxed/simple;
	bh=AeJqO7ICnk/6Z6szU0DdnBbLd8qrO8y2O8HsJL6RVJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KEPCx4a7FEfpWb3KaAPEO1srdRKyOF4VYaQbtqQgzkLX3fPix0pw23INAvEVkq6UlsQ3z0hYL3Pbt+9+Ink7ai5C8eooG9p/SIWmbnRxc4WT5XGw6yiBkSVW8QLocYpOY3n2vzVmzTRIvEgwiFsXS2EhEi0If/N60HpuEcPewn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=WiCjvjAe; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-269ba651d06so9101105ad.0
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 15:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1760481211; x=1761086011; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0SAHkElgeN+uImh1U8LDz2YCCf+9EoIroz5BynZCq1Q=;
        b=WiCjvjAeO1JjCtFbqsd1TBACXdBm3XQVEj08A1i69dQpoeGSAUBEgpcwRlMYvQqqCc
         sd/DxEE5GwbAhPF+CQgLdbt9VOAgnAv1lefIdroIct2MRdtz7m8BS9T5+Zdu8VfV0ZfI
         TsZlp5NerVKbM5VChCjSofUMLg3mxtsucYhXUElolvDy3qFVZsLauHi5FKFXZUcN5U7u
         ag/jn1agnf8XtgylgSjgHuf4YUJUZppYb1+ptjyoBV2vT/saKqsYBcUbwVE9d9D7kByl
         7HjFiR+qJwWBCp8TGxZdWe7TztKrsVFeCahTAO/CyBblwnrITG2zlmjm5/EW+QJkIrfS
         STaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760481211; x=1761086011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0SAHkElgeN+uImh1U8LDz2YCCf+9EoIroz5BynZCq1Q=;
        b=qNkMdptczu8Lf5nTMgO23VhhwQbj6mWQdJUV1SN0nxUKm81JfCvKHs9vJ+NtHFueiQ
         apgFyHiGCa0ebnHdgKB61xF/UgJetP4kUCzhv7l0QyAihRer/nov0QncoxvMtNNbmeAx
         D2pq8mtaILNMUCf312IcgYZMIv1lt6jAkUsTDT+2F8zreOhpkeueXQD/OKKy2WwYM3j7
         AcNleQSuSzXW9mkRmjrHdfSkEKCGi4gZ7R6/BXBCM0Ucr4Cw4txHqir9H4P5PCGUciHN
         GODtqSSrLnkMSkckzLdAocPJjxuIHKGF/gR4Yn7JRjgPXZ1fJ+MzOx1GUqE6AWsd7n+n
         IFdA==
X-Gm-Message-State: AOJu0YxoZ/60mtCogcI3ElERLAVI0VyjvRMANt2vvrpQW0SLWVWwuAsk
	zPPTHWYYcHU9ZZfz36PsPMssneUw2KqlTNzcBRLD1errbJJfzou0wddBY77tZr5DfLTfPhd702Q
	smQzI6thtpJnnRbeyAweR63EyjlofiZBVkBE1ppmIBA==
X-Gm-Gg: ASbGncsoU7UiMiMtsjgt5pT2xpgSQyHrngZ8ZWoO2QTwNBB0XjwSPYSFYvjYkDC7K8l
	4rZRh72QYNbdg2bLMyyzsau3zzuP+LRyeWY76rfhJCrq1TcqSprD0m2SizAQS1OF23dqgCFVHTU
	rks2hA4sv20dr7xArYEUmDIrv7Fo4AEVi5vR8Yh4+hbb1ovQ8YDQMksM9aCizReE5f/Uhvzhu9p
	0IYcr5Sr0t4z1ClLAmZ1bVkTuyQ9YlAhcp4UGwIwkMIhdaK/iYq/9KrlsPwb64tBugMWb1E7G/P
	9POz
X-Google-Smtp-Source: AGHT+IHHefz0S65H9WgENy934DsEb7AYK6Tm1raI2/Ty+iJMidRxzksUfKCu1732hGKemv+5IRcHb1BqqD/7VAKPVG4=
X-Received: by 2002:a17:903:2302:b0:27e:d4fa:cd23 with SMTP id
 d9443c01a7336-290273f347cmr175917075ad.5.1760481210800; Tue, 14 Oct 2025
 15:33:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251013180011.134131-1-kbusch@meta.com> <20251013180011.134131-3-kbusch@meta.com>
In-Reply-To: <20251013180011.134131-3-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 14 Oct 2025 15:33:19 -0700
X-Gm-Features: AS18NWBbyk4et3eu0tGgeNZoHbEdbTK_jx9XvcEXgxAm1wMabUBcKjU17wxts2Y
Message-ID: <CADUfDZqe7+M9dqxVxUmMo31S1EGVmOhwqfKGLJfR45Yb_BT+Fg@mail.gmail.com>
Subject: Re: [PATCHv5 1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
To: Keith Busch <kbusch@meta.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 11:00=E2=80=AFAM Keith Busch <kbusch@meta.com> wrot=
e:
>
> From: Keith Busch <kbusch@kernel.org>
>
> Normal rings support 64b SQEs for posting submissions, while certain
> features require the ring to be configured with IORING_SETUP_SQE128, as
> they need to convey more information per submission. This, in turn,
> makes ALL the SQEs be 128b in size. This is somewhat wasteful and
> inefficient, particularly when only certain SQEs need to be of the
> bigger variant.
>
> This adds support for setting up a ring with mixed SQE sizes, using
> IORING_SETUP_SQE_MIXED. When setup in this mode, SQEs posted to the ring
> may be either 64b or 128b in size. If a SQE is 128b in size, then opcode
> will be set to a variante to indicate that this is the case. Any other
> non-128b opcode will assume the SQ's default size.
>
> SQEs on these types of mixed rings may also utilize NOP with skip
> success set.  This can happen if the ring is one (small) SQE entry away
> from wrapping, and an attempt is made to get a 128b SQE. As SQEs must be
> contiguous in the SQ ring, a 128b SQE cannot wrap the ring. For this
> case, a single NOP SQE should be inserted with the SKIP_SUCCESS flag
> set. The kernel will process this as a normal NOP and without posting a
> CQE.
>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  include/uapi/linux/io_uring.h |  8 ++++++++
>  io_uring/fdinfo.c             | 34 +++++++++++++++++++++++++++-------
>  io_uring/io_uring.c           | 35 +++++++++++++++++++++++++++++++----
>  io_uring/io_uring.h           | 14 ++------------
>  io_uring/opdef.c              | 26 ++++++++++++++++++++++++++
>  io_uring/opdef.h              |  2 ++
>  io_uring/register.c           |  2 +-
>  io_uring/uring_cmd.c          | 17 +++++++++++++++--
>  8 files changed, 112 insertions(+), 26 deletions(-)
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
> index 263bed13473ef..04797a9b76bc2 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -231,6 +231,12 @@ enum io_uring_sqe_flags_bit {
>   */
>  #define IORING_SETUP_CQE_MIXED         (1U << 18)
>
> +/*
> + * Allow both 64b and 128b SQEs. If a 128b SQE is posted, it will have
> + * a 128b opcode.
> + */
> +#define IORING_SETUP_SQE_MIXED         (1U << 19)
> +
>  enum io_uring_op {
>         IORING_OP_NOP,
>         IORING_OP_READV,
> @@ -295,6 +301,8 @@ enum io_uring_op {
>         IORING_OP_READV_FIXED,
>         IORING_OP_WRITEV_FIXED,
>         IORING_OP_PIPE,
> +       IORING_OP_NOP128,
> +       IORING_OP_URING_CMD128,
>
>         /* this goes last, obviously */
>         IORING_OP_LAST,
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index ff3364531c77b..d14d2e983b623 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -14,6 +14,7 @@
>  #include "fdinfo.h"
>  #include "cancel.h"
>  #include "rsrc.h"
> +#include "opdef.h"
>
>  #ifdef CONFIG_NET_RX_BUSY_POLL
>  static __cold void common_tracking_show_fdinfo(struct io_ring_ctx *ctx,
> @@ -66,7 +67,6 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *=
ctx, struct seq_file *m)
>         unsigned int cq_head =3D READ_ONCE(r->cq.head);
>         unsigned int cq_tail =3D READ_ONCE(r->cq.tail);
>         unsigned int sq_shift =3D 0;
> -       unsigned int sq_entries;
>         int sq_pid =3D -1, sq_cpu =3D -1;
>         u64 sq_total_time =3D 0, sq_work_time =3D 0;
>         unsigned int i;
> @@ -89,26 +89,45 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
 *ctx, struct seq_file *m)
>         seq_printf(m, "CqTail:\t%u\n", cq_tail);
>         seq_printf(m, "CachedCqTail:\t%u\n", data_race(ctx->cached_cq_tai=
l));
>         seq_printf(m, "SQEs:\t%u\n", sq_tail - sq_head);
> -       sq_entries =3D min(sq_tail - sq_head, ctx->sq_entries);
> -       for (i =3D 0; i < sq_entries; i++) {
> -               unsigned int entry =3D i + sq_head;
> +       while (sq_head < sq_tail) {
>                 struct io_uring_sqe *sqe;
>                 unsigned int sq_idx;
> +               bool sqe128 =3D false;
> +               u8 opcode;
>
>                 if (ctx->flags & IORING_SETUP_NO_SQARRAY)
>                         break;
> -               sq_idx =3D READ_ONCE(ctx->sq_array[entry & sq_mask]);
> +               sq_idx =3D READ_ONCE(ctx->sq_array[sq_head & sq_mask]);
>                 if (sq_idx > sq_mask)
>                         continue;
> +
> +               opcode =3D READ_ONCE(sqe->opcode);
>                 sqe =3D &ctx->sq_sqes[sq_idx << sq_shift];
> +               if (sq_shift)
> +                       sqe128 =3D true;
> +               else if (io_issue_defs[opcode].is_128) {
> +                       if (!(ctx->flags & IORING_SETUP_SQE_MIXED)) {
> +                               seq_printf(m,
> +                                       "%5u: invalid sqe, 128B entry on =
non-mixed sq\n",
> +                                       sq_idx);
> +                               break;
> +                       }
> +                       if ((++sq_head & sq_mask) =3D=3D 0) {
> +                               seq_printf(m,
> +                                       "%5u: corrupted sqe, wrapping 128=
B entry\n",
> +                                       sq_idx);
> +                               break;
> +                       }
> +                       sqe128 =3D true;
> +               }
>                 seq_printf(m, "%5u: opcode:%s, fd:%d, flags:%x, off:%llu,=
 "
>                               "addr:0x%llx, rw_flags:0x%x, buf_index:%d "
>                               "user_data:%llu",
> -                          sq_idx, io_uring_get_opcode(sqe->opcode), sqe-=
>fd,
> +                          sq_idx, io_uring_get_opcode(opcode), sqe->fd,
>                            sqe->flags, (unsigned long long) sqe->off,
>                            (unsigned long long) sqe->addr, sqe->rw_flags,
>                            sqe->buf_index, sqe->user_data);
> -               if (sq_shift) {
> +               if (sqe128) {
>                         u64 *sqeb =3D (void *) (sqe + 1);
>                         int size =3D sizeof(struct io_uring_sqe) / sizeof=
(u64);
>                         int j;
> @@ -120,6 +139,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
 *ctx, struct seq_file *m)
>                         }
>                 }
>                 seq_printf(m, "\n");
> +               sq_head++;
>         }
>         seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
>         while (cq_head < cq_tail) {
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 820ef05276667..cd84eb4f2d4ca 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2151,7 +2151,7 @@ static __cold int io_init_fail_req(struct io_kiocb =
*req, int err)
>  }
>
>  static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
> -                      const struct io_uring_sqe *sqe)
> +                      const struct io_uring_sqe *sqe, unsigned int *left=
)
>         __must_hold(&ctx->uring_lock)
>  {
>         const struct io_issue_def *def;
> @@ -2177,6 +2177,22 @@ static int io_init_req(struct io_ring_ctx *ctx, st=
ruct io_kiocb *req,
>         opcode =3D array_index_nospec(opcode, IORING_OP_LAST);
>
>         def =3D &io_issue_defs[opcode];
> +       if (def->is_128 && !(ctx->flags & IORING_SETUP_SQE128)) {
> +               /*
> +                * A 128b op on a non-128b SQ requires mixed SQE support =
as
> +                * well as 2 contiguous entries.
> +                */
> +               if (!(ctx->flags & IORING_SETUP_SQE_MIXED) || *left < 2 |=
|
> +                   !(ctx->cached_sq_head & (ctx->sq_entries - 1)))
> +                       return io_init_fail_req(req, -EINVAL);
> +               /*
> +                * A 128b operation on a mixed SQ uses two entries, so we=
 have
> +                * to increment the head and decrement what's left.
> +                */
> +               ctx->cached_sq_head++;
> +               (*left)--;

Hmm, io_submit_sqes() calls io_get_task_refs() at the start to
decrement cached_refs by the number of SQEs (counting 128-byte SQEs
twice) but io_put_task() only increments it once for each completed
request (counting 128-byte SQEs once). Does that mean there's a
refcount leak? Perhaps io_submit_sqes() or this block needs to
increment cached_refs to account for each 128-byte SQE?

Otherwise, this looks good to me.

Best,
Caleb


> +       }
> +
>         if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
>                 /* enforce forwards compatibility on users */
>                 if (sqe_flags & ~SQE_VALID_FLAGS)
> @@ -2286,13 +2302,13 @@ static __cold int io_submit_fail_init(const struc=
t io_uring_sqe *sqe,
>  }
>
>  static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb=
 *req,
> -                        const struct io_uring_sqe *sqe)
> +                        const struct io_uring_sqe *sqe, unsigned int *le=
ft)
>         __must_hold(&ctx->uring_lock)
>  {
>         struct io_submit_link *link =3D &ctx->submit_state.link;
>         int ret;
>
> -       ret =3D io_init_req(ctx, req, sqe);
> +       ret =3D io_init_req(ctx, req, sqe, left);
>         if (unlikely(ret))
>                 return io_submit_fail_init(sqe, req, ret);
>
> @@ -2444,7 +2460,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigne=
d int nr)
>                  * Continue submitting even for sqe failure if the
>                  * ring was setup with IORING_SETUP_SUBMIT_ALL
>                  */
> -               if (unlikely(io_submit_sqe(ctx, req, sqe)) &&
> +               if (unlikely(io_submit_sqe(ctx, req, sqe, &left)) &&
>                     !(ctx->flags & IORING_SETUP_SUBMIT_ALL)) {
>                         left--;
>                         break;
> @@ -2789,6 +2805,10 @@ unsigned long rings_size(unsigned int flags, unsig=
ned int sq_entries,
>                 if (cq_entries < 2)
>                         return SIZE_MAX;
>         }
> +       if (flags & IORING_SETUP_SQE_MIXED) {
> +               if (sq_entries < 2)
> +                       return SIZE_MAX;
> +       }
>
>  #ifdef CONFIG_SMP
>         off =3D ALIGN(off, SMP_CACHE_BYTES);
> @@ -3715,6 +3735,13 @@ static int io_uring_sanitise_params(struct io_urin=
g_params *p)
>         if ((flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED)) =3D=3D
>             (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED))
>                 return -EINVAL;
> +       /*
> +        * Nonsensical to ask for SQE128 and mixed SQE support, it's not
> +        * supported to post 64b SQEs on a ring setup with SQE128.
> +        */
> +       if ((flags & (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED)) =3D=3D
> +           (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED))
> +               return -EINVAL;
>
>         return 0;
>  }
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 46d9141d772a7..85ed8eb7df80c 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -54,7 +54,8 @@
>                         IORING_SETUP_REGISTERED_FD_ONLY |\
>                         IORING_SETUP_NO_SQARRAY |\
>                         IORING_SETUP_HYBRID_IOPOLL |\
> -                       IORING_SETUP_CQE_MIXED)
> +                       IORING_SETUP_CQE_MIXED |\
> +                       IORING_SETUP_SQE_MIXED)
>
>  #define IORING_ENTER_FLAGS (IORING_ENTER_GETEVENTS |\
>                         IORING_ENTER_SQ_WAKEUP |\
> @@ -578,17 +579,6 @@ static inline void io_req_queue_tw_complete(struct i=
o_kiocb *req, s32 res)
>         io_req_task_work_add(req);
>  }
>
> -/*
> - * IORING_SETUP_SQE128 contexts allocate twice the normal SQE size for e=
ach
> - * slot.
> - */
> -static inline size_t uring_sqe_size(struct io_ring_ctx *ctx)
> -{
> -       if (ctx->flags & IORING_SETUP_SQE128)
> -               return 2 * sizeof(struct io_uring_sqe);
> -       return sizeof(struct io_uring_sqe);
> -}
> -
>  static inline bool io_file_can_poll(struct io_kiocb *req)
>  {
>         if (req->flags & REQ_F_CAN_POLL)
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 932319633eac2..df52d760240e4 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -575,6 +575,24 @@ const struct io_issue_def io_issue_defs[] =3D {
>                 .prep                   =3D io_pipe_prep,
>                 .issue                  =3D io_pipe,
>         },
> +       [IORING_OP_NOP128] =3D {
> +               .audit_skip             =3D 1,
> +               .iopoll                 =3D 1,
> +               .is_128                 =3D 1,
> +               .prep                   =3D io_nop_prep,
> +               .issue                  =3D io_nop,
> +       },
> +       [IORING_OP_URING_CMD128] =3D {
> +               .buffer_select          =3D 1,
> +               .needs_file             =3D 1,
> +               .plug                   =3D 1,
> +               .iopoll                 =3D 1,
> +               .iopoll_queue           =3D 1,
> +               .is_128                 =3D 1,
> +               .async_size             =3D sizeof(struct io_async_cmd),
> +               .prep                   =3D io_uring_cmd_prep,
> +               .issue                  =3D io_uring_cmd,
> +       },
>  };
>
>  const struct io_cold_def io_cold_defs[] =3D {
> @@ -825,6 +843,14 @@ const struct io_cold_def io_cold_defs[] =3D {
>         [IORING_OP_PIPE] =3D {
>                 .name                   =3D "PIPE",
>         },
> +       [IORING_OP_NOP128] =3D {
> +               .name                   =3D "NOP128",
> +       },
> +       [IORING_OP_URING_CMD128] =3D {
> +               .name                   =3D "URING_CMD128",
> +               .sqe_copy               =3D io_uring_cmd_sqe_copy,
> +               .cleanup                =3D io_uring_cmd_cleanup,
> +       },
>  };
>
>  const char *io_uring_get_opcode(u8 opcode)
> diff --git a/io_uring/opdef.h b/io_uring/opdef.h
> index c2f0907ed78cc..aa37846880ffd 100644
> --- a/io_uring/opdef.h
> +++ b/io_uring/opdef.h
> @@ -27,6 +27,8 @@ struct io_issue_def {
>         unsigned                iopoll_queue : 1;
>         /* vectored opcode, set if 1) vectored, and 2) handler needs to k=
now */
>         unsigned                vectored : 1;
> +       /* set to 1 if this opcode uses 128b sqes in a mixed sq */
> +       unsigned                is_128 : 1;
>
>         /* size of async data needed, if any */
>         unsigned short          async_size;
> diff --git a/io_uring/register.c b/io_uring/register.c
> index 43f04c47522c0..e97d9cbba7111 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -395,7 +395,7 @@ static void io_register_free_rings(struct io_ring_ctx=
 *ctx,
>  #define RESIZE_FLAGS   (IORING_SETUP_CQSIZE | IORING_SETUP_CLAMP)
>  #define COPY_FLAGS     (IORING_SETUP_NO_SQARRAY | IORING_SETUP_SQE128 | =
\
>                          IORING_SETUP_CQE32 | IORING_SETUP_NO_MMAP | \
> -                        IORING_SETUP_CQE_MIXED)
> +                        IORING_SETUP_CQE_MIXED | IORING_SETUP_SQE_MIXED)
>
>  static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user=
 *arg)
>  {
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index d1e3ba62ee8e8..a89b29cc5d199 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -216,6 +216,18 @@ int io_uring_cmd_prep(struct io_kiocb *req, const st=
ruct io_uring_sqe *sqe)
>         return 0;
>  }
>
> +/*
> + * IORING_SETUP_SQE128 contexts allocate twice the normal SQE size for e=
ach
> + * slot.
> + */
> +static inline size_t uring_sqe_size(struct io_kiocb *req)
> +{
> +       if (req->ctx->flags & IORING_SETUP_SQE128 ||
> +           req->opcode =3D=3D IORING_OP_URING_CMD128)
> +               return 2 * sizeof(struct io_uring_sqe);
> +       return sizeof(struct io_uring_sqe);
> +}
> +
>  void io_uring_cmd_sqe_copy(struct io_kiocb *req)
>  {
>         struct io_uring_cmd *ioucmd =3D io_kiocb_to_cmd(req, struct io_ur=
ing_cmd);
> @@ -224,7 +236,7 @@ void io_uring_cmd_sqe_copy(struct io_kiocb *req)
>         /* Should not happen, as REQ_F_SQE_COPIED covers this */
>         if (WARN_ON_ONCE(ioucmd->sqe =3D=3D ac->sqes))
>                 return;
> -       memcpy(ac->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
> +       memcpy(ac->sqes, ioucmd->sqe, uring_sqe_size(req));
>         ioucmd->sqe =3D ac->sqes;
>  }
>
> @@ -242,7 +254,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int i=
ssue_flags)
>         if (ret)
>                 return ret;
>
> -       if (ctx->flags & IORING_SETUP_SQE128)
> +       if (ctx->flags & IORING_SETUP_SQE128 ||
> +           req->opcode =3D=3D IORING_OP_URING_CMD128)
>                 issue_flags |=3D IO_URING_F_SQE128;
>         if (ctx->flags & (IORING_SETUP_CQE32 | IORING_SETUP_CQE_MIXED))
>                 issue_flags |=3D IO_URING_F_CQE32;
> --
> 2.47.3
>

