Return-Path: <io-uring+bounces-11334-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D37DCEAFCF
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 02:20:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CAD33301A70A
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 01:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AD6C74C14;
	Wed, 31 Dec 2025 01:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="AHwq6s72"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7880742AA6
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 01:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767144005; cv=none; b=b5jCOph6zd67x8CTNlZ74hMSdDt/uHVWOBvjI7BOaeFwexVd+ecP5D9D/gkqn/ZRvFGVXnSoclmIzbA4CGvluk3fx07zx79h2czCb7LC2TjmS7u2WV6pfxby0AhfA0p06DUwmBgpAqf8fMNqNLVB6gcAl5k3JuuV9AZqeSjdh+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767144005; c=relaxed/simple;
	bh=vU7xnWnvCE2qYi6bL/Rb2yG8ROA+2GmirbwdsgsUtHg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B2lYtWT5lVQXFdwyxglLfr4tEK+2+nAtpH7ouKtj8vrheRabBpQPBLwnSU6hOu2nP3BN6cPGnqyI4qTXptRQY0YbRyqq1HnCeeVMPLNeJiaLWBz1GmmHFLkoTLggkfXHcYcWRg/6KkolDKp9V6tGQ9eclugCRFhq6pC3Z2Dkt78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=AHwq6s72; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a097cc08d5so25973085ad.0
        for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 17:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767144002; x=1767748802; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SuVQus7dJBv6krdvPZqyyxezkDZr9ZguFO+hQr/gfGU=;
        b=AHwq6s72dTjxFDosKru3F6MFRJbvdhjgOjCrFUC71f/9+VOms+zZzOIf03CDk1oYZ2
         lBKo0Qzpw6C95CCwbwQMMB/BX/5KRrPadqMGS1cwcSrVAM35z7vOldS6filSWwXMvlfv
         CKR+3s7tj3RNcr3w09CMM9EqYgpDMU/jC3nQEkWXcnwjOetgw4pa5vpJ8ZwUu7wC9pVa
         dkXJ1vCVMjRq54cg5Dbu8r7xM4Xa/DalqmC58cXSLdfYm6RR35vZsRDJvpOWMrRtS076
         ckT0E9DKd/1D1ZTERvANCojVeMdR1b5mXd9zi9iJTmjsJzpntozql14kMJfF9kPfWE3X
         8CLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767144002; x=1767748802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SuVQus7dJBv6krdvPZqyyxezkDZr9ZguFO+hQr/gfGU=;
        b=l6F/etLVL7KGgtAApA9WBHCbFBBnu1k02YvhhaKf1vZ4MLcz6qk4/f/B9TsfUsvrO/
         sHwg6aXaLhrfXCPPvznzqrw/aBeo05hb+OlGLTS0ae049jTqfQXq9Pz1aJmhmu9RaEsw
         JK/UiMXITwLkgsvn+DQQahPU4KCz+onp3dJvsqqiX9BA6awssoxggMonLPJJVEjwmFV2
         P0RXEghFdqwJHylYMmaRCthsBx1p+sjMgO9wZgtlvQK/fmVITttQEBuNe2oEC74pFGbt
         YAcZ4nwNyNne1MKXBLzLTF63lXYxlVnrOOhN3eaGeO+mYmAhER3jjaVgLq7crfT8fone
         /bRg==
X-Forwarded-Encrypted: i=1; AJvYcCV+utt4rMznaYZeMXfcKbWB0YL3HTo6aZYVi3/J+vN6XxVnTvMQMF/j9ZKKQTGTBghFCmX+zoydGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLpewpTy+Xu3hI2EdfaqMI56wP97AHGZ08PpykdOE8NlqFHy8b
	LMxBdZVC8SQvIwF6Y74xmZHbn/zWFdyvfwWaqDKqaEzc5SMMFHXJCbzjueqoGlo/edW4KxmUN39
	h+fiSqluEv0LJgLUsOjwn49wesas/iZ8WpJNWwxGRsg==
X-Gm-Gg: AY/fxX7JOvvn5p6jpHlYOALhF7bJ6lrsvFObq1CtKtyt6RycvvkjwQV/E7x+h/MH16D
	hjlwZC4VXNgeaJxwqYvqfhDiuhCPBRyRol6Pq3ZLn7gYTxJf3sqhhiToMV0a9qoqzqxp2lllW9Y
	MBH8x6wiIH4rt4B0WBxgddjJHX1G1jBboUb7Udj/kbE+z0c6iheehsqr/2FxTI7tmJjvxEoseuR
	a11UPWFiZZ/ENJr5sgDg95Fvz/LjYOucdunvRM0V3S62gKWFcckCmnkcevQaOrjENg2k/A9lRt3
	28C4jhM=
X-Google-Smtp-Source: AGHT+IEGkJVaML/hW31fapLm6yhdhm5YCD6UUqMR1USDt93s/byhrDrcN0XBlYQC+ZSo32+vWsGcCQUvhIbkDNK7YBk=
X-Received: by 2002:a05:7022:f698:b0:119:e56b:c3f5 with SMTP id
 a92af1059eb24-121722eb266mr18109690c88.5.1767144001334; Tue, 30 Dec 2025
 17:20:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104162123.1086035-1-ming.lei@redhat.com> <20251104162123.1086035-4-ming.lei@redhat.com>
In-Reply-To: <20251104162123.1086035-4-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 30 Dec 2025 20:19:49 -0500
X-Gm-Features: AQt7F2rg-KxYmGkk92pFKs65iEF0OkkzBXnuZT8CvEJUzBaTsHov_tyKjVQCiR4
Message-ID: <CADUfDZrCvqR-1HConMx_xPQMgNPwn=jCDpbNBfqWrPucU3krzg@mail.gmail.com>
Subject: Re: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 8:22=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrote=
:
>
> io_uring can be extended with bpf struct_ops in the following ways:
>
> 1) add new io_uring operation from application
> - one typical use case is for operating device zero-copy buffer, which
> belongs to kernel, and not visible or too expensive to export to
> userspace, such as supporting copy data from this buffer to userspace,
> decompressing data to zero-copy buffer in Android case[1][2], or
> checksum/decrypting.
>
> [1] https://lpc.events/event/18/contributions/1710/attachments/1440/3070/=
LPC2024_ublk_zero_copy.pdf
>
> 2) extend 64 byte SQE, since bpf map can be used to store IO data
>    conveniently
>
> 3) communicate in IO chain, since bpf map can be shared among IOs,
> when one bpf IO is completed, data can be written to IO chain wide
> bpf map, then the following bpf IO can retrieve the data from this bpf
> map, this way is more flexible than io_uring built-in buffer
>
> 4) pretty handy to inject error for test purpose
>
> bpf struct_ops is one very handy way to attach bpf prog with kernel, and
> this patch simply wires existed io_uring operation callbacks with added
> uring bpf struct_ops, so application can define its own uring bpf
> operations.
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/uapi/linux/io_uring.h |   9 ++
>  io_uring/bpf.c                | 271 +++++++++++++++++++++++++++++++++-
>  io_uring/io_uring.c           |   1 +
>  io_uring/io_uring.h           |   3 +-
>  io_uring/uring_bpf.h          |  30 ++++
>  5 files changed, 311 insertions(+), 3 deletions(-)
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
> index b8c49813b4e5..94d2050131ac 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -74,6 +74,7 @@ struct io_uring_sqe {
>                 __u32           install_fd_flags;
>                 __u32           nop_flags;
>                 __u32           pipe_flags;
> +               __u32           bpf_op_flags;
>         };
>         __u64   user_data;      /* data to be passed back at completion t=
ime */
>         /* pack this to avoid bogus arm OABI complaints */
> @@ -427,6 +428,13 @@ enum io_uring_op {
>  #define IORING_RECVSEND_BUNDLE         (1U << 4)
>  #define IORING_SEND_VECTORIZED         (1U << 5)
>
> +/*
> + * sqe->bpf_op_flags           top 8bits is for storing bpf op
> + *                             The other 24bits are used for bpf prog
> + */
> +#define IORING_BPF_OP_BITS     (8)
> +#define IORING_BPF_OP_SHIFT    (24)

Could omit the parentheses here

> +
>  /*
>   * cqe.res for IORING_CQE_F_NOTIF if
>   * IORING_SEND_ZC_REPORT_USAGE was requested
> @@ -631,6 +639,7 @@ struct io_uring_params {
>  #define IORING_FEAT_MIN_TIMEOUT                (1U << 15)
>  #define IORING_FEAT_RW_ATTR            (1U << 16)
>  #define IORING_FEAT_NO_IOWAIT          (1U << 17)
> +#define IORING_FEAT_BPF                        (1U << 18)
>
>  /*
>   * io_uring_register(2) opcodes and arguments
> diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> index bb1e37d1e804..8227be6d5a10 100644
> --- a/io_uring/bpf.c
> +++ b/io_uring/bpf.c
> @@ -4,28 +4,95 @@
>  #include <linux/kernel.h>
>  #include <linux/errno.h>
>  #include <uapi/linux/io_uring.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <linux/bpf_verifier.h>
> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +#include <linux/btf_ids.h>
> +#include <linux/filter.h>
>  #include "io_uring.h"
>  #include "uring_bpf.h"
>
> +#define MAX_BPF_OPS_COUNT      (1 << IORING_BPF_OP_BITS)
> +
>  static DEFINE_MUTEX(uring_bpf_ctx_lock);
>  static LIST_HEAD(uring_bpf_ctx_list);
> +DEFINE_STATIC_SRCU(uring_bpf_srcu);
> +static struct uring_bpf_ops bpf_ops[MAX_BPF_OPS_COUNT];
>
> -int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
> +static inline unsigned char uring_bpf_get_op(unsigned int op_flags)
>  {
> -       return -ECANCELED;
> +       return (unsigned char)(op_flags >> IORING_BPF_OP_SHIFT);
> +}
> +
> +static inline unsigned int uring_bpf_get_flags(unsigned int op_flags)

u32?

> +{
> +       return op_flags & ((1U << IORING_BPF_OP_SHIFT) - 1);
> +}
> +
> +static inline struct uring_bpf_ops *uring_bpf_get_ops(struct uring_bpf_d=
ata *data)
> +{
> +       return &bpf_ops[uring_bpf_get_op(data->opf)];
>  }
>
>  int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *s=
qe)
>  {
> +       struct uring_bpf_data *data =3D io_kiocb_to_cmd(req, struct uring=
_bpf_data);
> +       unsigned int op_flags =3D READ_ONCE(sqe->bpf_op_flags);

u32?

> +       struct uring_bpf_ops *ops;
> +
> +       if (!(req->ctx->flags & IORING_SETUP_BPF))
> +               return -EACCES;
> +
> +       data->opf =3D op_flags;
> +       ops =3D &bpf_ops[uring_bpf_get_op(data->opf)];
> +
> +       if (ops->prep_fn)
> +               return ops->prep_fn(data, sqe);
>         return -EOPNOTSUPP;
>  }
>
> +static int __io_uring_bpf_issue(struct io_kiocb *req)
> +{
> +       struct uring_bpf_data *data =3D io_kiocb_to_cmd(req, struct uring=
_bpf_data);
> +       struct uring_bpf_ops *ops =3D uring_bpf_get_ops(data);
> +
> +       if (ops->issue_fn)
> +               return ops->issue_fn(data);

Doesn't this need to use rcu_dereference() to access ops->issue_fn
since io_bpf_reg_unreg() may concurrently modify it?

Also, it doesn't look safe to propagate the BPF ->issue_fn() return
value to the ->issue() return value. If the BPF program returns
IOU_ISSUE_SKIP_COMPLETE =3D -EIOCBQUEUED, the io_uring request will
never be completed. And it looks like ->issue() implementations are
meant to return either IOU_COMPLETE, IOU_RETRY, or
IOU_ISSUE_SKIP_COMPLETE. If the BPF program returns some other value,
it would be nice to propagate it to the io_uring CQE result and return
IOU_COMPLETE, similar to io_uring_cmd().

> +       return -ECANCELED;
> +}
> +
> +int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +       if (issue_flags & IO_URING_F_UNLOCKED) {
> +               int idx, ret;
> +
> +               idx =3D srcu_read_lock(&uring_bpf_srcu);
> +               ret =3D __io_uring_bpf_issue(req);
> +               srcu_read_unlock(&uring_bpf_srcu, idx);
> +
> +               return ret;
> +       }
> +       return __io_uring_bpf_issue(req);
> +}
> +
>  void io_uring_bpf_fail(struct io_kiocb *req)
>  {
> +       struct uring_bpf_data *data =3D io_kiocb_to_cmd(req, struct uring=
_bpf_data);
> +       struct uring_bpf_ops *ops =3D uring_bpf_get_ops(data);
> +
> +       if (ops->fail_fn)
> +               ops->fail_fn(data);
>  }
>
>  void io_uring_bpf_cleanup(struct io_kiocb *req)
>  {
> +       struct uring_bpf_data *data =3D io_kiocb_to_cmd(req, struct uring=
_bpf_data);
> +       struct uring_bpf_ops *ops =3D uring_bpf_get_ops(data);
> +
> +       if (ops->cleanup_fn)
> +               ops->cleanup_fn(data);
>  }
>
>  void uring_bpf_add_ctx(struct io_ring_ctx *ctx)
> @@ -39,3 +106,203 @@ void uring_bpf_del_ctx(struct io_ring_ctx *ctx)
>         guard(mutex)(&uring_bpf_ctx_lock);
>         list_del(&ctx->bpf_node);
>  }
> +
> +static const struct btf_type *uring_bpf_data_type;
> +
> +static bool uring_bpf_ops_is_valid_access(int off, int size,
> +                                      enum bpf_access_type type,
> +                                      const struct bpf_prog *prog,
> +                                      struct bpf_insn_access_aux *info)
> +{
> +       return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
> +}

Just use bpf_tracing_btf_ctx_access instead of defining another
equivalent function?

> +
> +static int uring_bpf_ops_btf_struct_access(struct bpf_verifier_log *log,
> +                                       const struct bpf_reg_state *reg,
> +                                       int off, int size)
> +{
> +       const struct btf_type *t;
> +
> +       t =3D btf_type_by_id(reg->btf, reg->btf_id);
> +       if (t !=3D uring_bpf_data_type) {
> +               bpf_log(log, "only read is supported\n");

What does this log line mean?

> +               return -EACCES;
> +       }
> +
> +       if (off < offsetof(struct uring_bpf_data, pdu) ||
> +                       off + size >=3D sizeof(struct uring_bpf_data))

Should be > instead of >=3D? Otherwise the last byte of pdu isn't usable.

> +               return -EACCES;
> +
> +       return NOT_INIT;
> +}
> +
> +static const struct bpf_verifier_ops io_bpf_verifier_ops =3D {
> +       .get_func_proto =3D bpf_base_func_proto,
> +       .is_valid_access =3D uring_bpf_ops_is_valid_access,
> +       .btf_struct_access =3D uring_bpf_ops_btf_struct_access,
> +};
> +
> +static int uring_bpf_ops_init(struct btf *btf)
> +{
> +       s32 type_id;
> +
> +       type_id =3D btf_find_by_name_kind(btf, "uring_bpf_data", BTF_KIND=
_STRUCT);
> +       if (type_id < 0)
> +               return -EINVAL;
> +       uring_bpf_data_type =3D btf_type_by_id(btf, type_id);
> +       return 0;
> +}
> +
> +static int uring_bpf_ops_check_member(const struct btf_type *t,
> +                                  const struct btf_member *member,
> +                                  const struct bpf_prog *prog)
> +{
> +       return 0;
> +}

It looks like struct bpf_struct_ops's .check_member can be omitted if
it always succeeds

> +
> +static int uring_bpf_ops_init_member(const struct btf_type *t,
> +                                const struct btf_member *member,
> +                                void *kdata, const void *udata)
> +{
> +       const struct uring_bpf_ops *uuring_bpf_ops;
> +       struct uring_bpf_ops *kuring_bpf_ops;
> +       u32 moff;
> +
> +       uuring_bpf_ops =3D (const struct uring_bpf_ops *)udata;
> +       kuring_bpf_ops =3D (struct uring_bpf_ops *)kdata;

Don't need to explicitly cast from (const) void *. That could allow
these initializers to be combined with the variable declarations.

> +
> +       moff =3D __btf_member_bit_offset(t, member) / 8;
> +
> +       switch (moff) {
> +       case offsetof(struct uring_bpf_ops, id):
> +               /* For dev_id, this function has to copy it and return 1 =
to

What does "dev_id" refer to?

> +                * indicate that the data has been handled by the struct_=
ops
> +                * type, or the verifier will reject the map if the value=
 of
> +                * those fields is not zero.
> +                */
> +               kuring_bpf_ops->id =3D uuring_bpf_ops->id;
> +               return 1;
> +       }
> +       return 0;
> +}
> +
> +static int io_bpf_reg_unreg(struct uring_bpf_ops *ops, bool reg)
> +{
> +       struct io_ring_ctx *ctx;
> +       int ret =3D 0;
> +
> +       guard(mutex)(&uring_bpf_ctx_lock);
> +       list_for_each_entry(ctx, &uring_bpf_ctx_list, bpf_node)
> +               mutex_lock(&ctx->uring_lock);

Locking multiple io_ring_ctx's uring_locks is deadlock prone. See
lock_two_rings() for example, which takes care to acquire multiple
uring_locks in a consistent order. Would it be possible to lock one
io_ring_ctx at a time and set some flag to indicate that
srcu_read_lock() needs to be used?

> +
> +       if (reg) {
> +               if (bpf_ops[ops->id].issue_fn)
> +                       ret =3D -EBUSY;
> +               else
> +                       bpf_ops[ops->id] =3D *ops;
> +       } else {
> +               bpf_ops[ops->id] =3D (struct uring_bpf_ops) {0};

Don't these need to use rcu_assign_pointer() to assign
bpf_ops[ops->id].issue_fn since __io_uring_bpf_issue() may read it
concurrently?

> +       }
> +
> +       synchronize_srcu(&uring_bpf_srcu);
> +
> +       list_for_each_entry(ctx, &uring_bpf_ctx_list, bpf_node)
> +               mutex_unlock(&ctx->uring_lock);

It might be preferable to call synchronize_srcu() after releasing the
uring_locks (and maybe uring_bpf_ctx_lock). That would minimize the
latency injected into io_uring requests in case synchronize_srcu()
blocks for a long time.

> +
> +       return ret;
> +}
> +
> +static int io_bpf_reg(void *kdata, struct bpf_link *link)
> +{
> +       struct uring_bpf_ops *ops =3D kdata;
> +
> +       return io_bpf_reg_unreg(ops, true);
> +}
> +
> +static void io_bpf_unreg(void *kdata, struct bpf_link *link)
> +{
> +       struct uring_bpf_ops *ops =3D kdata;
> +
> +       io_bpf_reg_unreg(ops, false);
> +}
> +
> +static int io_bpf_prep_io(struct uring_bpf_data *data, const struct io_u=
ring_sqe *sqe)
> +{
> +       return -EOPNOTSUPP;

The return value for the stub functions doesn't matter, return 0 for simpli=
city?

Also, could the stub functions be renamed to more clearly indicate
that they are only used for their signature and shouldn't be called
directly?

> +}
> +
> +static int io_bpf_issue_io(struct uring_bpf_data *data)
> +{
> +       return -ECANCELED;
> +}
> +
> +static void io_bpf_fail_io(struct uring_bpf_data *data)
> +{
> +}
> +
> +static void io_bpf_cleanup_io(struct uring_bpf_data *data)
> +{
> +}
> +
> +static struct uring_bpf_ops __bpf_uring_bpf_ops =3D {
> +       .prep_fn        =3D io_bpf_prep_io,
> +       .issue_fn       =3D io_bpf_issue_io,
> +       .fail_fn        =3D io_bpf_fail_io,
> +       .cleanup_fn     =3D io_bpf_cleanup_io,
> +};
> +
> +static struct bpf_struct_ops bpf_uring_bpf_ops =3D {

const?

> +       .verifier_ops =3D &io_bpf_verifier_ops,
> +       .init =3D uring_bpf_ops_init,
> +       .check_member =3D uring_bpf_ops_check_member,
> +       .init_member =3D uring_bpf_ops_init_member,
> +       .reg =3D io_bpf_reg,
> +       .unreg =3D io_bpf_unreg,
> +       .name =3D "uring_bpf_ops",
> +       . =3D &__bpf_uring_bpf_ops,
> +       .owner =3D THIS_MODULE,
> +};
> +
> +__bpf_kfunc_start_defs();
> +__bpf_kfunc void uring_bpf_set_result(struct uring_bpf_data *data, int r=
es)
> +{
> +       struct io_kiocb *req =3D cmd_to_io_kiocb(data);
> +
> +       if (res < 0)
> +               req_set_fail(req);
> +       io_req_set_res(req, res, 0);
> +}
> +
> +/* io_kiocb layout might be changed */
> +__bpf_kfunc struct io_kiocb *uring_bpf_data_to_req(struct uring_bpf_data=
 *data)

How would the returned struct io_kiocb * be used in an io_uring BPF program=
?

> +{
> +       return cmd_to_io_kiocb(data);
> +}
> +__bpf_kfunc_end_defs();
> +
> +BTF_KFUNCS_START(uring_bpf_kfuncs)
> +BTF_ID_FLAGS(func, uring_bpf_set_result)
> +BTF_ID_FLAGS(func, uring_bpf_data_to_req)
> +BTF_KFUNCS_END(uring_bpf_kfuncs)
> +
> +static const struct btf_kfunc_id_set uring_kfunc_set =3D {
> +       .owner =3D THIS_MODULE,
> +       .set   =3D &uring_bpf_kfuncs,
> +};
> +
> +int __init io_bpf_init(void)
> +{
> +       int err;
> +
> +       err =3D register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &urin=
g_kfunc_set);
> +       if (err) {
> +               pr_warn("error while setting UBLK BPF tracing kfuncs: %d"=
, err);
> +               return err;
> +       }
> +
> +       err =3D register_bpf_struct_ops(&bpf_uring_bpf_ops, uring_bpf_ops=
);
> +       if (err)
> +               pr_warn("error while registering io_uring bpf struct ops:=
 %d", err);

Is there a reason this error isn't fatal?

> +
> +       return 0;
> +}
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 38f03f6c28cb..d2517e09407a 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3851,6 +3851,7 @@ static int __init io_uring_init(void)
>         register_sysctl_init("kernel", kernel_io_uring_disabled_table);
>  #endif
>
> +       io_bpf_init();

It doesn't look like there are any particular initialization ordering
requirements with the rest of io_uring_init(). How about making a
separate __initcall() in bpf.c so io_bpf_init() doesn't need to be
visible outside that file?

>         return 0;
>  };
>  __initcall(io_uring_init);
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 4baf21a9e1ee..3f19bb079bcc 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -34,7 +34,8 @@
>                         IORING_FEAT_RECVSEND_BUNDLE |\
>                         IORING_FEAT_MIN_TIMEOUT |\
>                         IORING_FEAT_RW_ATTR |\
> -                       IORING_FEAT_NO_IOWAIT)
> +                       IORING_FEAT_NO_IOWAIT |\
> +                       IORING_FEAT_BPF);

Unintentional semicolon?

>
>  #define IORING_SETUP_FLAGS (IORING_SETUP_IOPOLL |\
>                         IORING_SETUP_SQPOLL |\
> diff --git a/io_uring/uring_bpf.h b/io_uring/uring_bpf.h
> index b6cda6df99b1..c76eba887d22 100644
> --- a/io_uring/uring_bpf.h
> +++ b/io_uring/uring_bpf.h
> @@ -2,6 +2,29 @@
>  #ifndef IOU_BPF_H
>  #define IOU_BPF_H
>
> +struct uring_bpf_data {
> +       /* readonly for bpf prog */

It doesn't look like uring_bpf_ops_btf_struct_access() actually allows
these fields to be accessed?

> +       struct file     *file;
> +       u32             opf;
> +
> +       /* writeable for bpf prog */
> +       u8              pdu[64 - sizeof(struct file *) - sizeof(u32)];
> +};
> +
> +typedef int (*uring_io_prep_t)(struct uring_bpf_data *data,
> +                              const struct io_uring_sqe *sqe);
> +typedef int (*uring_io_issue_t)(struct uring_bpf_data *data);
> +typedef void (*uring_io_fail_t)(struct uring_bpf_data *data);
> +typedef void (*uring_io_cleanup_t)(struct uring_bpf_data *data);

"uring_io" seems like a strange name for function typedefs specific to
io_uring BPF. How about renaming these to "uring_bpf_..." instead?

Best,
Caleb


> +
> +struct uring_bpf_ops {
> +       unsigned short          id;
> +       uring_io_prep_t         prep_fn;
> +       uring_io_issue_t        issue_fn;
> +       uring_io_fail_t         fail_fn;
> +       uring_io_cleanup_t      cleanup_fn;
> +};
> +
>  #ifdef CONFIG_IO_URING_BPF
>  int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags);
>  int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *s=
qe);
> @@ -11,6 +34,8 @@ void io_uring_bpf_cleanup(struct io_kiocb *req);
>  void uring_bpf_add_ctx(struct io_ring_ctx *ctx);
>  void uring_bpf_del_ctx(struct io_ring_ctx *ctx);
>
> +int __init io_bpf_init(void);
> +
>  #else
>  static inline int io_uring_bpf_issue(struct io_kiocb *req, unsigned int =
issue_flags)
>  {
> @@ -33,5 +58,10 @@ static inline void uring_bpf_add_ctx(struct io_ring_ct=
x *ctx)
>  static inline void uring_bpf_del_ctx(struct io_ring_ctx *ctx)
>  {
>  }
> +
> +static inline int __init io_bpf_init(void)
> +{
> +       return 0;
> +}
>  #endif
>  #endif
> --
> 2.47.0
>

