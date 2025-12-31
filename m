Return-Path: <io-uring+bounces-11349-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B036CEC481
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 17:48:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7E4C63005A96
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 16:48:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB53283686;
	Wed, 31 Dec 2025 16:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="SRgIEhna"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D13A280A29
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767199715; cv=none; b=qdZrc1j3apv7TTQldGKMdPlPvSU7VMPKngHOZGRLU6X4ysj6zp90BgbPh3OX1f3gVH0j1EmC3eAjVoE05ujjc81097MXqn0Hp9gVtssT8JBBFXVhYnuY4dwTz/yPg+4dmHCuugzITTvh2Us+cpsoivRSR0uGBwiKbG8oVJ2qt6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767199715; c=relaxed/simple;
	bh=fmeOoLPWk88YfoonBSgKNzO5a8ekyIE2Di8snaBbDzA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sCdd12gd7O2DDkkHiHuPK4rCBhSOcv3dP5295euZPePNBkVxa/KwRU9pz4Qs03HrJ2avCmxVs1ryZIelPpC3IHH58K9RJsp98B7PV8riZ0YqyI7U1yJiKo5WO5JVZzcoilyancvXLTgoJbmC1gI49Op6hH4YZjezG4GEC7wT3I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=SRgIEhna; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a110548f10so38061465ad.1
        for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 08:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767199713; x=1767804513; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VGVs+AoQ4lqn3oXqqwSiy6NrqMJgLD8dUnLE013xyl8=;
        b=SRgIEhnagFhrIEbkdYBqE/WUgEJctSsikp48SsV/P3Pt57NH1odfHD+JMTjA/Ix7KZ
         BOQmpwBOk9XaqptgzGjLhKhNOYUZQOvqjlDM8udN6q0SF4GRDxKjYZwfn+Zm7JvWaFl2
         k5mKfgL+fLZC/7CGPXVSMfY6nqPGUKFdCT257kv9tT3mLPBgEYFIVFJs1NNqqbs3dpPf
         JGPKF51PvisUvWE+vBZWup7qLLyMdbbQQFXzJV5z6pr6gJ/UM6x9YO7FLM+apvuKvvPj
         wrRFteXPiapg9ECKf0fP3hqLX6e4LPBS470zYdtf/2f17fnSwyOTYj/XPJNIXRZVLeoG
         UuuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767199713; x=1767804513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VGVs+AoQ4lqn3oXqqwSiy6NrqMJgLD8dUnLE013xyl8=;
        b=UfsoN5vIjRjpelcUR/5y/tDh0pY4146S+VkcDpYRofHCvcybG2Spu4IYaA8TA7la86
         oC8EN4uy1SQwwAFp0o9KRG3z2rcseaMD1kE8y1rXC2uLBm5vp8eEJ34K4EbHGf6GrUXa
         LPIlL/KMnR4qNvrOkQVCqUhE6AnDmyDu5qy7BI7kHQwOU1faY4tg6pm9tmfpYfmlNI4F
         +OYC6N2bP2RSKazOOfDH+ggDEyLCNAEXQhvIkhhW0O/OawSlsSCkVH2bXV60NXdOfmDc
         uG/jfHfMCYSQ3QGwPc/v2co0KG5ELS0b1AsXJ2nJQqriR22x3b+DpTH7bHrBA8Rs7u4F
         sd1Q==
X-Forwarded-Encrypted: i=1; AJvYcCX5GGWP5P1wSHANJqI55AnJjwITmCycCeNIjGvPaSCR5mzuFHs5x6ao/E/ecu0juHyHa3sthH9q/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyIi+V+6mZ1roVvbUyE/iHibnm0qCfiEMSG6iqC3fKAY3IZHV6P
	Lkvxw7tYKN9Cr3wzWUTwD1Y2rtdCYpIocpWP+GrXuUNU/v1dLsXGSWID8550D/as8wJh3cKKzPY
	XdGYoYbR7iZzrMN3oSAhwoaF0z8plEyOiHReqqx4xCw==
X-Gm-Gg: AY/fxX4Ag3Hv5U+eAhz1khWkqyy9oZo/7MEcMeonfc/uhrGWSv+JkElAam7Fvt3zS+4
	yi83Fh4EChftKeHr7HgUrCWH70/blXEe8L3gmMx6xeY8QRQ4bmfnlWRfNQkV+c4S3IKYgfyQSFZ
	KGVN272OCqHVh3Ds/2Iwvb/jq3752EN4oZXqMsy6qcB8lKRDd+sG2P9vnowNz+ZLFwpVvvQHhKS
	8v3A5CvTmuisOTZBKXYCx60lZdVtevI88H2t5v8z+cZLKiBU+Q5cwqnWBxb3gMDciJMnCvp
X-Google-Smtp-Source: AGHT+IFSXOCxwqakeDF6WXlTTI4bBsTb9pWhT5utMlfMOBMhhdOnSWynW7evlp2mq4Q6YE2xP4QLwAbQlBw0SCics5o=
X-Received: by 2002:a05:7022:264a:b0:11b:862d:8031 with SMTP id
 a92af1059eb24-121721380fcmr14038376c88.0.1767199712274; Wed, 31 Dec 2025
 08:48:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104162123.1086035-1-ming.lei@redhat.com> <20251104162123.1086035-4-ming.lei@redhat.com>
 <CADUfDZrCvqR-1HConMx_xPQMgNPwn=jCDpbNBfqWrPucU3krzg@mail.gmail.com> <aVT7rJUBU_U_Tkmu@fedora>
In-Reply-To: <aVT7rJUBU_U_Tkmu@fedora>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 31 Dec 2025 11:48:20 -0500
X-Gm-Features: AQt7F2oHrUvbh2t6N_ZR2L9RoKdF3pHj9ZMgC5H79XUJdhUdz-DKsmG7XbgEMas
Message-ID: <CADUfDZrEohMQbbKAKC+jzTFGw+01aNUM4C8Z4i4+CRmTD0KiSg@mail.gmail.com>
Subject: Re: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 31, 2025 at 2:32=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Tue, Dec 30, 2025 at 08:19:49PM -0500, Caleb Sander Mateos wrote:
> > On Tue, Nov 4, 2025 at 8:22=E2=80=AFAM Ming Lei <ming.lei@redhat.com> w=
rote:
> > >
> > > io_uring can be extended with bpf struct_ops in the following ways:
> > >
> > > 1) add new io_uring operation from application
> > > - one typical use case is for operating device zero-copy buffer, whic=
h
> > > belongs to kernel, and not visible or too expensive to export to
> > > userspace, such as supporting copy data from this buffer to userspace=
,
> > > decompressing data to zero-copy buffer in Android case[1][2], or
> > > checksum/decrypting.
> > >
> > > [1] https://lpc.events/event/18/contributions/1710/attachments/1440/3=
070/LPC2024_ublk_zero_copy.pdf
> > >
> > > 2) extend 64 byte SQE, since bpf map can be used to store IO data
> > >    conveniently
> > >
> > > 3) communicate in IO chain, since bpf map can be shared among IOs,
> > > when one bpf IO is completed, data can be written to IO chain wide
> > > bpf map, then the following bpf IO can retrieve the data from this bp=
f
> > > map, this way is more flexible than io_uring built-in buffer
> > >
> > > 4) pretty handy to inject error for test purpose
> > >
> > > bpf struct_ops is one very handy way to attach bpf prog with kernel, =
and
> > > this patch simply wires existed io_uring operation callbacks with add=
ed
> > > uring bpf struct_ops, so application can define its own uring bpf
> > > operations.
> > >
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > ---
> > >  include/uapi/linux/io_uring.h |   9 ++
> > >  io_uring/bpf.c                | 271 ++++++++++++++++++++++++++++++++=
+-
> > >  io_uring/io_uring.c           |   1 +
> > >  io_uring/io_uring.h           |   3 +-
> > >  io_uring/uring_bpf.h          |  30 ++++
> > >  5 files changed, 311 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_ur=
ing.h
> > > index b8c49813b4e5..94d2050131ac 100644
> > > --- a/include/uapi/linux/io_uring.h
> > > +++ b/include/uapi/linux/io_uring.h
> > > @@ -74,6 +74,7 @@ struct io_uring_sqe {
> > >                 __u32           install_fd_flags;
> > >                 __u32           nop_flags;
> > >                 __u32           pipe_flags;
> > > +               __u32           bpf_op_flags;
> > >         };
> > >         __u64   user_data;      /* data to be passed back at completi=
on time */
> > >         /* pack this to avoid bogus arm OABI complaints */
> > > @@ -427,6 +428,13 @@ enum io_uring_op {
> > >  #define IORING_RECVSEND_BUNDLE         (1U << 4)
> > >  #define IORING_SEND_VECTORIZED         (1U << 5)
> > >
> > > +/*
> > > + * sqe->bpf_op_flags           top 8bits is for storing bpf op
> > > + *                             The other 24bits are used for bpf pro=
g
> > > + */
> > > +#define IORING_BPF_OP_BITS     (8)
> > > +#define IORING_BPF_OP_SHIFT    (24)
> >
> > Could omit the parentheses here
> >
> > > +
> > >  /*
> > >   * cqe.res for IORING_CQE_F_NOTIF if
> > >   * IORING_SEND_ZC_REPORT_USAGE was requested
> > > @@ -631,6 +639,7 @@ struct io_uring_params {
> > >  #define IORING_FEAT_MIN_TIMEOUT                (1U << 15)
> > >  #define IORING_FEAT_RW_ATTR            (1U << 16)
> > >  #define IORING_FEAT_NO_IOWAIT          (1U << 17)
> > > +#define IORING_FEAT_BPF                        (1U << 18)
> > >
> > >  /*
> > >   * io_uring_register(2) opcodes and arguments
> > > diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> > > index bb1e37d1e804..8227be6d5a10 100644
> > > --- a/io_uring/bpf.c
> > > +++ b/io_uring/bpf.c
> > > @@ -4,28 +4,95 @@
> > >  #include <linux/kernel.h>
> > >  #include <linux/errno.h>
> > >  #include <uapi/linux/io_uring.h>
> > > +#include <linux/init.h>
> > > +#include <linux/types.h>
> > > +#include <linux/bpf_verifier.h>
> > > +#include <linux/bpf.h>
> > > +#include <linux/btf.h>
> > > +#include <linux/btf_ids.h>
> > > +#include <linux/filter.h>
> > >  #include "io_uring.h"
> > >  #include "uring_bpf.h"
> > >
> > > +#define MAX_BPF_OPS_COUNT      (1 << IORING_BPF_OP_BITS)
> > > +
> > >  static DEFINE_MUTEX(uring_bpf_ctx_lock);
> > >  static LIST_HEAD(uring_bpf_ctx_list);
> > > +DEFINE_STATIC_SRCU(uring_bpf_srcu);
> > > +static struct uring_bpf_ops bpf_ops[MAX_BPF_OPS_COUNT];
> > >
> > > -int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flag=
s)
> > > +static inline unsigned char uring_bpf_get_op(unsigned int op_flags)
> > >  {
> > > -       return -ECANCELED;
> > > +       return (unsigned char)(op_flags >> IORING_BPF_OP_SHIFT);
> > > +}
> > > +
> > > +static inline unsigned int uring_bpf_get_flags(unsigned int op_flags=
)
> >
> > u32?
> >
> > > +{
> > > +       return op_flags & ((1U << IORING_BPF_OP_SHIFT) - 1);
> > > +}
> > > +
> > > +static inline struct uring_bpf_ops *uring_bpf_get_ops(struct uring_b=
pf_data *data)
> > > +{
> > > +       return &bpf_ops[uring_bpf_get_op(data->opf)];
> > >  }
> > >
> > >  int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sq=
e *sqe)
> > >  {
> > > +       struct uring_bpf_data *data =3D io_kiocb_to_cmd(req, struct u=
ring_bpf_data);
> > > +       unsigned int op_flags =3D READ_ONCE(sqe->bpf_op_flags);
> >
> > u32?
> >
> > > +       struct uring_bpf_ops *ops;
> > > +
> > > +       if (!(req->ctx->flags & IORING_SETUP_BPF))
> > > +               return -EACCES;
> > > +
> > > +       data->opf =3D op_flags;
> > > +       ops =3D &bpf_ops[uring_bpf_get_op(data->opf)];
> > > +
> > > +       if (ops->prep_fn)
> > > +               return ops->prep_fn(data, sqe);
> > >         return -EOPNOTSUPP;
> > >  }
> > >
> > > +static int __io_uring_bpf_issue(struct io_kiocb *req)
> > > +{
> > > +       struct uring_bpf_data *data =3D io_kiocb_to_cmd(req, struct u=
ring_bpf_data);
> > > +       struct uring_bpf_ops *ops =3D uring_bpf_get_ops(data);
> > > +
> > > +       if (ops->issue_fn)
> > > +               return ops->issue_fn(data);
> >
> > Doesn't this need to use rcu_dereference() to access ops->issue_fn
> > since io_bpf_reg_unreg() may concurrently modify it?
>
> rcu isn't enough, io_bpf_reg_unreg() shouldn't be started unless one bpf
> IO is completed. Probably percpu-refcount may have to be used.
>
> >
> > Also, it doesn't look safe to propagate the BPF ->issue_fn() return
> > value to the ->issue() return value. If the BPF program returns
> > IOU_ISSUE_SKIP_COMPLETE =3D -EIOCBQUEUED, the io_uring request will
> > never be completed. And it looks like ->issue() implementations are
>
> It depends on if bpf OP can support async IO, and it relies on bpf kfunc'=
s
> capability actually.
>
> But yes, it is better to start with sync bpf IO only.

Yeah, the existing kfunc interface doesn't provide any way to complete
the request asynchronously. I'm having a hard time imagining how the
asynchronous completion would even be triggered. I guess the struct
uring_bpf_data * would need to be stored somewhere and some other BPF
program that runs later would call the kfunc to complete it? Seems
like it would be difficult to prevent double completions. I agree
supporting only synchronous BPF programs for now makes sense.

>
> > meant to return either IOU_COMPLETE, IOU_RETRY, or
> > IOU_ISSUE_SKIP_COMPLETE. If the BPF program returns some other value,
> > it would be nice to propagate it to the io_uring CQE result and return
> > IOU_COMPLETE, similar to io_uring_cmd().
> >
> > > +       return -ECANCELED;
> > > +}
> > > +
> > > +int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flag=
s)
> > > +{
> > > +       if (issue_flags & IO_URING_F_UNLOCKED) {
> > > +               int idx, ret;
> > > +
> > > +               idx =3D srcu_read_lock(&uring_bpf_srcu);
> > > +               ret =3D __io_uring_bpf_issue(req);
> > > +               srcu_read_unlock(&uring_bpf_srcu, idx);
> > > +
> > > +               return ret;
> > > +       }
> > > +       return __io_uring_bpf_issue(req);
> > > +}
> > > +
> > >  void io_uring_bpf_fail(struct io_kiocb *req)
> > >  {
> > > +       struct uring_bpf_data *data =3D io_kiocb_to_cmd(req, struct u=
ring_bpf_data);
> > > +       struct uring_bpf_ops *ops =3D uring_bpf_get_ops(data);
> > > +
> > > +       if (ops->fail_fn)
> > > +               ops->fail_fn(data);
> > >  }
> > >
> > >  void io_uring_bpf_cleanup(struct io_kiocb *req)
> > >  {
> > > +       struct uring_bpf_data *data =3D io_kiocb_to_cmd(req, struct u=
ring_bpf_data);
> > > +       struct uring_bpf_ops *ops =3D uring_bpf_get_ops(data);
> > > +
> > > +       if (ops->cleanup_fn)
> > > +               ops->cleanup_fn(data);
> > >  }
> > >
> > >  void uring_bpf_add_ctx(struct io_ring_ctx *ctx)
> > > @@ -39,3 +106,203 @@ void uring_bpf_del_ctx(struct io_ring_ctx *ctx)
> > >         guard(mutex)(&uring_bpf_ctx_lock);
> > >         list_del(&ctx->bpf_node);
> > >  }
> > > +
> > > +static const struct btf_type *uring_bpf_data_type;
> > > +
> > > +static bool uring_bpf_ops_is_valid_access(int off, int size,
> > > +                                      enum bpf_access_type type,
> > > +                                      const struct bpf_prog *prog,
> > > +                                      struct bpf_insn_access_aux *in=
fo)
> > > +{
> > > +       return bpf_tracing_btf_ctx_access(off, size, type, prog, info=
);
> > > +}
> >
> > Just use bpf_tracing_btf_ctx_access instead of defining another
> > equivalent function?
> >
> > > +
> > > +static int uring_bpf_ops_btf_struct_access(struct bpf_verifier_log *=
log,
> > > +                                       const struct bpf_reg_state *r=
eg,
> > > +                                       int off, int size)
> > > +{
> > > +       const struct btf_type *t;
> > > +
> > > +       t =3D btf_type_by_id(reg->btf, reg->btf_id);
> > > +       if (t !=3D uring_bpf_data_type) {
> > > +               bpf_log(log, "only read is supported\n");
> >
> > What does this log line mean?
>
> We only support to write to uring_bpf_data.pdu, and readonly is for other=
 type.

I missed that ->btf_struct_access() is only called for write accesses.
Makes sense.

>
> >
> > > +               return -EACCES;
> > > +       }
> > > +
> > > +       if (off < offsetof(struct uring_bpf_data, pdu) ||
> > > +                       off + size >=3D sizeof(struct uring_bpf_data)=
)
> >
> > Should be > instead of >=3D? Otherwise the last byte of pdu isn't usabl=
e.
>
> Good catch!
>
> >
> > > +               return -EACCES;
> > > +
> > > +       return NOT_INIT;
> > > +}
> > > +
> > > +static const struct bpf_verifier_ops io_bpf_verifier_ops =3D {
> > > +       .get_func_proto =3D bpf_base_func_proto,
> > > +       .is_valid_access =3D uring_bpf_ops_is_valid_access,
> > > +       .btf_struct_access =3D uring_bpf_ops_btf_struct_access,
> > > +};
> > > +
> > > +static int uring_bpf_ops_init(struct btf *btf)
> > > +{
> > > +       s32 type_id;
> > > +
> > > +       type_id =3D btf_find_by_name_kind(btf, "uring_bpf_data", BTF_=
KIND_STRUCT);
> > > +       if (type_id < 0)
> > > +               return -EINVAL;
> > > +       uring_bpf_data_type =3D btf_type_by_id(btf, type_id);
> > > +       return 0;
> > > +}
> > > +
> > > +static int uring_bpf_ops_check_member(const struct btf_type *t,
> > > +                                  const struct btf_member *member,
> > > +                                  const struct bpf_prog *prog)
> > > +{
> > > +       return 0;
> > > +}
> >
> > It looks like struct bpf_struct_ops's .check_member can be omitted if
> > it always succeeds
>
> I think it is better to check each member of the struct_ops, also
> .sleepable need to be checked here.
>
> >
> > > +
> > > +static int uring_bpf_ops_init_member(const struct btf_type *t,
> > > +                                const struct btf_member *member,
> > > +                                void *kdata, const void *udata)
> > > +{
> > > +       const struct uring_bpf_ops *uuring_bpf_ops;
> > > +       struct uring_bpf_ops *kuring_bpf_ops;
> > > +       u32 moff;
> > > +
> > > +       uuring_bpf_ops =3D (const struct uring_bpf_ops *)udata;
> > > +       kuring_bpf_ops =3D (struct uring_bpf_ops *)kdata;
> >
> > Don't need to explicitly cast from (const) void *. That could allow
> > these initializers to be combined with the variable declarations.
>
> OK.
>
> >
> > > +
> > > +       moff =3D __btf_member_bit_offset(t, member) / 8;
> > > +
> > > +       switch (moff) {
> > > +       case offsetof(struct uring_bpf_ops, id):
> > > +               /* For dev_id, this function has to copy it and retur=
n 1 to
> >
> > What does "dev_id" refer to?
>
> Looks a typo.
>
> >
> > > +                * indicate that the data has been handled by the str=
uct_ops
> > > +                * type, or the verifier will reject the map if the v=
alue of
> > > +                * those fields is not zero.
> > > +                */
> > > +               kuring_bpf_ops->id =3D uuring_bpf_ops->id;
> > > +               return 1;
> > > +       }
> > > +       return 0;
> > > +}
> > > +
> > > +static int io_bpf_reg_unreg(struct uring_bpf_ops *ops, bool reg)
> > > +{
> > > +       struct io_ring_ctx *ctx;
> > > +       int ret =3D 0;
> > > +
> > > +       guard(mutex)(&uring_bpf_ctx_lock);
> > > +       list_for_each_entry(ctx, &uring_bpf_ctx_list, bpf_node)
> > > +               mutex_lock(&ctx->uring_lock);
> >
> > Locking multiple io_ring_ctx's uring_locks is deadlock prone. See
> > lock_two_rings() for example, which takes care to acquire multiple
> > uring_locks in a consistent order. Would it be possible to lock one
> > io_ring_ctx at a time and set some flag to indicate that
> > srcu_read_lock() needs to be used?
> >
> > > +
> > > +       if (reg) {
> > > +               if (bpf_ops[ops->id].issue_fn)
> > > +                       ret =3D -EBUSY;
> > > +               else
> > > +                       bpf_ops[ops->id] =3D *ops;
> > > +       } else {
> > > +               bpf_ops[ops->id] =3D (struct uring_bpf_ops) {0};
> >
> > Don't these need to use rcu_assign_pointer() to assign
> > bpf_ops[ops->id].issue_fn since __io_uring_bpf_issue() may read it
> > concurrently?
> >
> > > +       }
> > > +
> > > +       synchronize_srcu(&uring_bpf_srcu);
> > > +
> > > +       list_for_each_entry(ctx, &uring_bpf_ctx_list, bpf_node)
> > > +               mutex_unlock(&ctx->uring_lock);
> >
> > It might be preferable to call synchronize_srcu() after releasing the
> > uring_locks (and maybe uring_bpf_ctx_lock). That would minimize the
> > latency injected into io_uring requests in case synchronize_srcu()
> > blocks for a long time.
>
> I plan to switch to percpu-refcount, which is simple, and can avoid unreg
> when one such bpf io is inflight.

Okay, I still think it would be simpler to specify the io_uring BPF
program by bpf_fd. Then we could use the existing file
descriptor/io_uring registered file lookup mechanisms instead of
having to write a new one.

>
> >
> > > +
> > > +       return ret;
> > > +}
> > > +
> > > +static int io_bpf_reg(void *kdata, struct bpf_link *link)
> > > +{
> > > +       struct uring_bpf_ops *ops =3D kdata;
> > > +
> > > +       return io_bpf_reg_unreg(ops, true);
> > > +}
> > > +
> > > +static void io_bpf_unreg(void *kdata, struct bpf_link *link)
> > > +{
> > > +       struct uring_bpf_ops *ops =3D kdata;
> > > +
> > > +       io_bpf_reg_unreg(ops, false);
> > > +}
> > > +
> > > +static int io_bpf_prep_io(struct uring_bpf_data *data, const struct =
io_uring_sqe *sqe)
> > > +{
> > > +       return -EOPNOTSUPP;
> >
> > The return value for the stub functions doesn't matter, return 0 for si=
mplicity?
> >
> > Also, could the stub functions be renamed to more clearly indicate
> > that they are only used for their signature and shouldn't be called
> > directly?
>
> Looks fine.
>
> >
> > > +}
> > > +
> > > +static int io_bpf_issue_io(struct uring_bpf_data *data)
> > > +{
> > > +       return -ECANCELED;
> > > +}
> > > +
> > > +static void io_bpf_fail_io(struct uring_bpf_data *data)
> > > +{
> > > +}
> > > +
> > > +static void io_bpf_cleanup_io(struct uring_bpf_data *data)
> > > +{
> > > +}
> > > +
> > > +static struct uring_bpf_ops __bpf_uring_bpf_ops =3D {
> > > +       .prep_fn        =3D io_bpf_prep_io,
> > > +       .issue_fn       =3D io_bpf_issue_io,
> > > +       .fail_fn        =3D io_bpf_fail_io,
> > > +       .cleanup_fn     =3D io_bpf_cleanup_io,
> > > +};
> > > +
> > > +static struct bpf_struct_ops bpf_uring_bpf_ops =3D {
> >
> > const?
>
> int __register_bpf_struct_ops(struct bpf_struct_ops *st_ops)

Good point. I was confused why a mutable pointer is needed, but looks
like the BPF code internally assigns to the func_models field.

>
> >
> > > +       .verifier_ops =3D &io_bpf_verifier_ops,
> > > +       .init =3D uring_bpf_ops_init,
> > > +       .check_member =3D uring_bpf_ops_check_member,
> > > +       .init_member =3D uring_bpf_ops_init_member,
> > > +       .reg =3D io_bpf_reg,
> > > +       .unreg =3D io_bpf_unreg,
> > > +       .name =3D "uring_bpf_ops",
> > > +       . =3D &__bpf_uring_bpf_ops,
> > > +       .owner =3D THIS_MODULE,
> > > +};
> > > +
> > > +__bpf_kfunc_start_defs();
> > > +__bpf_kfunc void uring_bpf_set_result(struct uring_bpf_data *data, i=
nt res)
> > > +{
> > > +       struct io_kiocb *req =3D cmd_to_io_kiocb(data);
> > > +
> > > +       if (res < 0)
> > > +               req_set_fail(req);
> > > +       io_req_set_res(req, res, 0);
> > > +}
> > > +
> > > +/* io_kiocb layout might be changed */
> > > +__bpf_kfunc struct io_kiocb *uring_bpf_data_to_req(struct uring_bpf_=
data *data)
> >
> > How would the returned struct io_kiocb * be used in an io_uring BPF pro=
gram?
>
> I plan to not expose io_kiocb to bpf prog in next version.
>
> >
> > > +{
> > > +       return cmd_to_io_kiocb(data);
> > > +}
> > > +__bpf_kfunc_end_defs();
> > > +
> > > +BTF_KFUNCS_START(uring_bpf_kfuncs)
> > > +BTF_ID_FLAGS(func, uring_bpf_set_result)
> > > +BTF_ID_FLAGS(func, uring_bpf_data_to_req)
> > > +BTF_KFUNCS_END(uring_bpf_kfuncs)
> > > +
> > > +static const struct btf_kfunc_id_set uring_kfunc_set =3D {
> > > +       .owner =3D THIS_MODULE,
> > > +       .set   =3D &uring_bpf_kfuncs,
> > > +};
> > > +
> > > +int __init io_bpf_init(void)
> > > +{
> > > +       int err;
> > > +
> > > +       err =3D register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &=
uring_kfunc_set);
> > > +       if (err) {
> > > +               pr_warn("error while setting UBLK BPF tracing kfuncs:=
 %d", err);
> > > +               return err;
> > > +       }
> > > +
> > > +       err =3D register_bpf_struct_ops(&bpf_uring_bpf_ops, uring_bpf=
_ops);
> > > +       if (err)
> > > +               pr_warn("error while registering io_uring bpf struct =
ops: %d", err);
> >
> > Is there a reason this error isn't fatal?
>
> oops, the following line should be `return err`.
>
> >
> > > +
> > > +       return 0;
> > > +}
> > > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > > index 38f03f6c28cb..d2517e09407a 100644
> > > --- a/io_uring/io_uring.c
> > > +++ b/io_uring/io_uring.c
> > > @@ -3851,6 +3851,7 @@ static int __init io_uring_init(void)
> > >         register_sysctl_init("kernel", kernel_io_uring_disabled_table=
);
> > >  #endif
> > >
> > > +       io_bpf_init();
> >
> > It doesn't look like there are any particular initialization ordering
> > requirements with the rest of io_uring_init(). How about making a
> > separate __initcall() in bpf.c so io_bpf_init() doesn't need to be
> > visible outside that file?
>
> Looks fine.
>
> >
> > >         return 0;
> > >  };
> > >  __initcall(io_uring_init);
> > > diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> > > index 4baf21a9e1ee..3f19bb079bcc 100644
> > > --- a/io_uring/io_uring.h
> > > +++ b/io_uring/io_uring.h
> > > @@ -34,7 +34,8 @@
> > >                         IORING_FEAT_RECVSEND_BUNDLE |\
> > >                         IORING_FEAT_MIN_TIMEOUT |\
> > >                         IORING_FEAT_RW_ATTR |\
> > > -                       IORING_FEAT_NO_IOWAIT)
> > > +                       IORING_FEAT_NO_IOWAIT |\
> > > +                       IORING_FEAT_BPF);
> >
> > Unintentional semicolon?
>
> Good catch!
>
> >
> > >
> > >  #define IORING_SETUP_FLAGS (IORING_SETUP_IOPOLL |\
> > >                         IORING_SETUP_SQPOLL |\
> > > diff --git a/io_uring/uring_bpf.h b/io_uring/uring_bpf.h
> > > index b6cda6df99b1..c76eba887d22 100644
> > > --- a/io_uring/uring_bpf.h
> > > +++ b/io_uring/uring_bpf.h
> > > @@ -2,6 +2,29 @@
> > >  #ifndef IOU_BPF_H
> > >  #define IOU_BPF_H
> > >
> > > +struct uring_bpf_data {
> > > +       /* readonly for bpf prog */
> >
> > It doesn't look like uring_bpf_ops_btf_struct_access() actually allows
> > these fields to be accessed?
>
> `pdu` is writeable, the following two are readonly.

I'm new to BPF, what allows them to be read? Are BPF programs
implicitly allowed to read within the bounds of any struct?

Best,
Caleb

>
> >
> > > +       struct file     *file;
> > > +       u32             opf;
> > > +
> > > +       /* writeable for bpf prog */
> > > +       u8              pdu[64 - sizeof(struct file *) - sizeof(u32)]=
;
> > > +};
> > > +
> > > +typedef int (*uring_io_prep_t)(struct uring_bpf_data *data,
> > > +                              const struct io_uring_sqe *sqe);
> > > +typedef int (*uring_io_issue_t)(struct uring_bpf_data *data);
> > > +typedef void (*uring_io_fail_t)(struct uring_bpf_data *data);
> > > +typedef void (*uring_io_cleanup_t)(struct uring_bpf_data *data);
> >
> > "uring_io" seems like a strange name for function typedefs specific to
> > io_uring BPF. How about renaming these to "uring_bpf_..." instead?
>
> Looks fine.
>
>
> Thanks,
> Ming
>

