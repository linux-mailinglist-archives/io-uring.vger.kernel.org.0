Return-Path: <io-uring+bounces-11335-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A00CEB01D
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 02:42:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AC1F6301B827
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 01:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050872D781F;
	Wed, 31 Dec 2025 01:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="FQ6vQ8t6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230B42D77FF
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 01:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767145345; cv=none; b=mcCHZLsGRwwhJQs9WuNJnmAodbqDqrzTAD+S0B62/vaoG8T/rhJdcSGlz44s1Hf7GGCmJqWr+co3c6yADh7BTlcZrvGK/ifX51qd1IKblhcGkeQwJJIuGbZI53WlrVZUOP/2l5Zpu41CHUwGoWFceKK4NvakZKMVJo8X+GA8krY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767145345; c=relaxed/simple;
	bh=wGPT7zxLfblE3AJxUL7ZxX8aIkF0EFPu5FrCAP/34VA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y+f9sbrAEkFm6ALAEOPFKRsFLbP007e6sUyteOM6fi5j7KAnXVMJ9VsCGd+kUBevWX3LjGWkGhFajw4GQfG9xhM4h/10s8sHZd5iZZvWJN6Xn+3KoJTu2OJMwImYB9HTsMus9BMQ2CV7gEU1bLyIHwC2s6YKdtrrEg0wxZYDjI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=FQ6vQ8t6; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-34ab4879aa5so884571a91.0
        for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 17:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767145343; x=1767750143; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SgNRN/JhIAyuU8OvwZCOqywgEaE99I1DcEWEsgMNE8I=;
        b=FQ6vQ8t69rYAho0LUtTvy65hBa3hwCsaGYekwSkUxOCFB+2b5LqMY5P1CLvHXMjfWP
         yoLIcErZN8F587B7GOSSz3A9JHXCuYw5/2Boo8L3I/PTWNmIDPQZIFk3tAdKuCQaC85H
         877wZEmellIx/b/naBHJvqxac/zp20TD2t4GEUO9uNAvndXZMNG7vjfP/KClE1lNsAfy
         toOM/nsSuahEoYAYVNOoCtDpbtXdv38CKaP9bpmPpYjq5Q6fZZ8IAQn3ZFVVxKxcBRKE
         D11hoV3x8C2TveI+4HnAUJqZpq7I53nXNL0DFYSsoqsZmrtMdL2NaDw41yt4QZusoBAo
         2BGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767145343; x=1767750143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SgNRN/JhIAyuU8OvwZCOqywgEaE99I1DcEWEsgMNE8I=;
        b=hhB/lRmYRmcON8LGLhSXbqcPADs9QeB/VNOhrOChr/5eHKyWfnLMA6B1Z/KQkOFc58
         zIh9QD9BrXr9e9LG0ZOa3oRC7iI2ApQCquTDC7piB+GAgLwWZBXHYSsQHfv2C3uRzTCY
         5qGl8XJ09T3xJVtOLXvmgVFUfxYzXCVHk6GwVg9XWmPL0vaEBfAycq6EaA7WwBxqOp9g
         xVBQfeaDtChIBhk1Kiixw34Fwd3zHnUb7YDxvbU9NgS6ELrNxakxvKC1FOAMmcN5BDhs
         DmGlYiN9vXjCilJmW08zKMIBKpsw8NCAHO2XdnVdCG0TG5p9UKWcRRoJrfvDJBB/D+My
         wsng==
X-Forwarded-Encrypted: i=1; AJvYcCXJnbxvNVl0cNGYwkwBt6AtGyckTfkIEgEGZ2Dzg5c4dCGOB0f+I103kXy5ye7rSwFV0wDxGcsNIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZoa74gY0LyW8hbSMm9o41i/z8TTrqk+7jzGgxlBrPhNav4h1P
	1HGhL0ga7ZX7ca0XNYtgUTUr5LebeHN6Ns/UzeYaretqyGec8wtnogBilXYcE7nfJ9K3oPd6f64
	Py+Cb1LL2e59CE8nSFvE0rXpR9jmbFuFFvMzP87h3uw==
X-Gm-Gg: AY/fxX4rnis7ox930z7GO+YSNbjCX5zXeH8gEWkqUBTNuUDOIYTwiCi4Mk+Dc4tSyd2
	9Bd8yQwRNhb7Awv8+V92qugxyHoxIUvXI9n50JqoCLyJwzMrM0FaiZsu4Ua/vmk5Sh543ZZq8/5
	KGwCbS3xT5kRQe0ZiKolFZZfbiHv5ZGTHbZCNUvI+hFgc95c0QAUSqmx7knXL3OLOZe+EDomxLR
	oiF+5BzwpznaXYoXbdRqqtImO1HszvczeQ46wVQZa7QKVs0NhqF63pJ55dqAPmWVSqkey90
X-Google-Smtp-Source: AGHT+IEOg+G9ZpQvsNAYCRZzEN5wlO8R5e6WiMUqaPTSdZe2B8emO9varWCJ+AJgpF5/JJQe81k9vdSSDkdMY8pa4+E=
X-Received: by 2002:a05:7022:688c:b0:11b:1c6d:98ed with SMTP id
 a92af1059eb24-121722b0402mr20386921c88.2.1767145343049; Tue, 30 Dec 2025
 17:42:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104162123.1086035-1-ming.lei@redhat.com> <20251104162123.1086035-5-ming.lei@redhat.com>
In-Reply-To: <20251104162123.1086035-5-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 30 Dec 2025 20:42:11 -0500
X-Gm-Features: AQt7F2qBgOUYhPj-007kgy8otUN56ENXxT1WwHOyQWk9PlIvbp-yiW7GvmEwA1s
Message-ID: <CADUfDZqUbJz_05m63-p4Q7XpsM1V6f4oGMCaKmPcE_wzNJvNqA@mail.gmail.com>
Subject: Re: [PATCH 4/5] io_uring: bpf: add buffer support for IORING_OP_BPF
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 8:22=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrote=
:
>
> Add support for passing 0-2 buffers to BPF operations through
> IORING_OP_BPF. Buffer types are encoded in sqe->bpf_op_flags
> using dedicated 3-bit fields for each buffer.

I agree the 2 buffer limit seems a bit restrictive, and it would make
more sense to expose kfuncs to import plain and fixed buffers. Then
the BPF program could decide what buffers to import based on the SQE,
BPF maps, etc. This would be analogous to how uring_cmd
implementations import buffers.

>
> Buffer 1 can be:
> - None (no buffer)
> - Plain user buffer (addr=3Dsqe->addr, len=3Dsqe->len)
> - Fixed/registered buffer (index=3Dsqe->buf_index, offset=3Dsqe->addr,

Should this say "addr=3D" instead of "offset=3D"? It's passed as buf_addr
to io_bpf_import_buffer(), so it's an absolute userspace address. The
offset into the fixed buffer depends on the starting address of the
fixed buffer.

>   len=3Dsqe->len)
>
> Buffer 2 can be:
> - None (no buffer)
> - Plain user buffer (addr=3Dsqe->addr3, len=3Dsqe->optlen)
>
> The sqe->bpf_op_flags layout (32 bits):
>   Bits 31-24: BPF operation ID (8 bits)
>   Bits 23-21: Buffer 1 type (3 bits)
>   Bits 20-18: Buffer 2 type (3 bits)
>   Bits 17-0:  Custom BPF flags (18 bits)
>
> Using 3-bit encoding for each buffer type allows for future
> expansion to 8 types (0-7). Currently types 0-2 are defined
> (none/plain/fixed) and 3-7 are reserved for future use.
>
> Buffer 2 currently only supports none/plain types because the
> io_uring framework can only handle one fixed buffer per request
> (via req->buf_index). The 3-bit encoding provides room for
> future enhancements.
>
> Buffer metadata (addresses, lengths) is stored in the extended
> uring_bpf_data structure and is accessible to BPF programs with
> readonly permissions. Buffer types can be extracted from the opf
> field using IORING_BPF_BUF1_TYPE() and IORING_BPF_BUF2_TYPE()
> macros.
>
> Valid buffer combinations:
> - 0 buffers
> - 1 plain buffer
> - 1 fixed buffer
> - 2 plain buffers
> - 1 fixed buffer + 1 plain buffer
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/uapi/linux/io_uring.h | 45 +++++++++++++++++++++++--
>  io_uring/bpf.c                | 63 ++++++++++++++++++++++++++++++++++-
>  io_uring/uring_bpf.h          | 12 ++++++-
>  3 files changed, 116 insertions(+), 4 deletions(-)
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
> index 94d2050131ac..950f4cfbbf86 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -429,12 +429,53 @@ enum io_uring_op {
>  #define IORING_SEND_VECTORIZED         (1U << 5)
>
>  /*
> - * sqe->bpf_op_flags           top 8bits is for storing bpf op
> - *                             The other 24bits are used for bpf prog
> + * sqe->bpf_op_flags layout (32 bits total):
> + *   Bits 31-24: BPF operation ID (8 bits, 256 possible operations)
> + *   Bits 23-21: Buffer 1 type (3 bits: none/plain/fixed/reserved)
> + *   Bits 20-18: Buffer 2 type (3 bits: none/plain/reserved)
> + *   Bits 17-0:  Custom BPF flags (18 bits, available for BPF programs)

This doesn't seem accurate, as io_uring_bpf_prep() rejects any
requests with these bits set?

> + *
> + * For IORING_OP_BPF, buffers are specified as follows:
> + *   Buffer 1 (plain):  addr=3Dsqe->addr, len=3Dsqe->len
> + *   Buffer 1 (fixed):  index=3Dsqe->buf_index, offset=3Dsqe->addr, len=
=3Dsqe->len
> + *   Buffer 2 (plain):  addr=3Dsqe->addr3, len=3Dsqe->optlen
> + *
> + * Note: Buffer 1 can be none/plain/fixed. Buffer 2 can only be none/pla=
in.
> + *       3-bit encoding for each buffer allows for future expansion to 8=
 types (0-7).
> + *       Currently only one fixed buffer per request is supported (buffe=
r 1).
> + *       Valid combinations: 0 buffers, 1 plain, 1 fixed, 2 plain, 1 fix=
ed + 1 plain.
>   */
>  #define IORING_BPF_OP_BITS     (8)
>  #define IORING_BPF_OP_SHIFT    (24)
>
> +/* Buffer type encoding in sqe->bpf_op_flags */
> +#define IORING_BPF_BUF1_TYPE_SHIFT     (21)
> +#define IORING_BPF_BUF2_TYPE_SHIFT     (18)
> +#define IORING_BPF_BUF_TYPE_NONE       (0)     /* No buffer */
> +#define IORING_BPF_BUF_TYPE_PLAIN      (1)     /* Plain user buffer */
> +#define IORING_BPF_BUF_TYPE_FIXED      (2)     /* Fixed/registered buffe=
r */
> +#define IORING_BPF_BUF_TYPE_MASK       (7)     /* 3-bit mask */

What do you think about replacing the bpf_op_flags field with a struct
containing op, buffer_flags, custom_flags fields to reduce the number
of bitwise operations needed to read and write these values?

> +
> +/* Helper macros to encode/decode buffer types */
> +#define IORING_BPF_BUF1_TYPE(flags) \
> +       (((flags) >> IORING_BPF_BUF1_TYPE_SHIFT) & IORING_BPF_BUF_TYPE_MA=
SK)
> +#define IORING_BPF_BUF2_TYPE(flags) \
> +       (((flags) >> IORING_BPF_BUF2_TYPE_SHIFT) & IORING_BPF_BUF_TYPE_MA=
SK)

I'm not sure how userspace would use these helpers. Would it make
sense to move them from the UAPI header to the kernel-internal code?

> +#define IORING_BPF_SET_BUF1_TYPE(type) \
> +       (((type) & IORING_BPF_BUF_TYPE_MASK) << IORING_BPF_BUF1_TYPE_SHIF=
T)
> +#define IORING_BPF_SET_BUF2_TYPE(type) \
> +       (((type) & IORING_BPF_BUF_TYPE_MASK) << IORING_BPF_BUF2_TYPE_SHIF=
T)
> +
> +/* Custom BPF flags mask (18 bits available, bits 17-0) */
> +#define IORING_BPF_CUSTOM_FLAGS_MASK   ((1U << 18) - 1)

Use IORING_BPF_BUF2_TYPE_SHIFT instead of 18?

> +
> +/* Encode all components into sqe->bpf_op_flags */
> +#define IORING_BPF_OP_FLAGS(op, buf1_type, buf2_type, flags) \
> +       (((op) << IORING_BPF_OP_SHIFT) | \
> +        IORING_BPF_SET_BUF1_TYPE(buf1_type) | \
> +        IORING_BPF_SET_BUF2_TYPE(buf2_type) | \
> +        ((flags) & IORING_BPF_CUSTOM_FLAGS_MASK))
> +
>  /*
>   * cqe.res for IORING_CQE_F_NOTIF if
>   * IORING_SEND_ZC_REPORT_USAGE was requested
> diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> index 8227be6d5a10..e837c3d57b96 100644
> --- a/io_uring/bpf.c
> +++ b/io_uring/bpf.c
> @@ -11,8 +11,10 @@
>  #include <linux/btf.h>
>  #include <linux/btf_ids.h>
>  #include <linux/filter.h>
> +#include <linux/uio.h>
>  #include "io_uring.h"
>  #include "uring_bpf.h"
> +#include "rsrc.h"
>
>  #define MAX_BPF_OPS_COUNT      (1 << IORING_BPF_OP_BITS)
>
> @@ -28,7 +30,7 @@ static inline unsigned char uring_bpf_get_op(unsigned i=
nt op_flags)
>
>  static inline unsigned int uring_bpf_get_flags(unsigned int op_flags)
>  {
> -       return op_flags & ((1U << IORING_BPF_OP_SHIFT) - 1);
> +       return op_flags & IORING_BPF_CUSTOM_FLAGS_MASK;
>  }
>
>  static inline struct uring_bpf_ops *uring_bpf_get_ops(struct uring_bpf_d=
ata *data)
> @@ -36,18 +38,77 @@ static inline struct uring_bpf_ops *uring_bpf_get_ops=
(struct uring_bpf_data *dat
>         return &bpf_ops[uring_bpf_get_op(data->opf)];
>  }
>
> +static int io_bpf_prep_buffers(struct io_kiocb *req,
> +                              const struct io_uring_sqe *sqe,
> +                              struct uring_bpf_data *data,
> +                              unsigned int op_flags)
> +{
> +       u8 buf1_type, buf2_type;
> +
> +       /* Extract buffer configuration from bpf_op_flags */
> +       buf1_type =3D IORING_BPF_BUF1_TYPE(op_flags);
> +       buf2_type =3D IORING_BPF_BUF2_TYPE(op_flags);
> +
> +       /* Prepare buffer 1 */
> +       if (buf1_type =3D=3D IORING_BPF_BUF_TYPE_PLAIN) {
> +               /* Plain user buffer: addr=3Dsqe->addr, len=3Dsqe->len */
> +               data->buf1_addr =3D READ_ONCE(sqe->addr);
> +               data->buf1_len =3D READ_ONCE(sqe->len);
> +       } else if (buf1_type =3D=3D IORING_BPF_BUF_TYPE_FIXED) {
> +               /* Fixed buffer: index=3Dsqe->buf_index, offset=3Dsqe->ad=
dr, len=3Dsqe->len */
> +               req->buf_index =3D READ_ONCE(sqe->buf_index);
> +               data->buf1_addr =3D READ_ONCE(sqe->addr);  /* offset with=
in fixed buffer */
> +               data->buf1_len =3D READ_ONCE(sqe->len);

Deduplicate these assignments with the ones in the
IORING_BPF_BUF_TYPE_PLAIN case?

> +
> +               /* Validate buffer index */
> +               if (unlikely(!req->ctx->buf_table.nr))
> +                       return -EFAULT;
> +               if (unlikely(req->buf_index >=3D req->ctx->buf_table.nr))
> +                       return -EINVAL;

Why validate these here? Won't io_import_reg_buf() check these anyways?

Best,
Caleb


> +       } else if (buf1_type =3D=3D IORING_BPF_BUF_TYPE_NONE) {
> +               data->buf1_addr =3D 0;
> +               data->buf1_len =3D 0;
> +       } else {
> +               return -EINVAL;
> +       }
> +
> +       /* Prepare buffer 2 (plain only - io_uring only supports one fixe=
d buffer) */
> +       if (buf2_type =3D=3D IORING_BPF_BUF_TYPE_PLAIN) {
> +               /* Plain user buffer: addr=3Dsqe->addr3, len=3Dsqe->optle=
n */
> +               data->buf2_addr =3D READ_ONCE(sqe->addr3);
> +               data->buf2_len =3D READ_ONCE(sqe->optlen);
> +       } else if (buf2_type =3D=3D IORING_BPF_BUF_TYPE_NONE) {
> +               data->buf2_addr =3D 0;
> +               data->buf2_len =3D 0;
> +       } else {
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
> +
>  int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *s=
qe)
>  {
>         struct uring_bpf_data *data =3D io_kiocb_to_cmd(req, struct uring=
_bpf_data);
>         unsigned int op_flags =3D READ_ONCE(sqe->bpf_op_flags);
>         struct uring_bpf_ops *ops;
> +       int ret;
>
>         if (!(req->ctx->flags & IORING_SETUP_BPF))
>                 return -EACCES;
>
> +       if (uring_bpf_get_flags(op_flags))
> +               return -EINVAL;
> +
>         data->opf =3D op_flags;
>         ops =3D &bpf_ops[uring_bpf_get_op(data->opf)];
>
> +       /* Prepare buffers based on buffer type flags */
> +       ret =3D io_bpf_prep_buffers(req, sqe, data, op_flags);
> +       if (ret)
> +               return ret;
> +
>         if (ops->prep_fn)
>                 return ops->prep_fn(data, sqe);
>         return -EOPNOTSUPP;
> diff --git a/io_uring/uring_bpf.h b/io_uring/uring_bpf.h
> index c76eba887d22..c919931cb4b0 100644
> --- a/io_uring/uring_bpf.h
> +++ b/io_uring/uring_bpf.h
> @@ -7,8 +7,18 @@ struct uring_bpf_data {
>         struct file     *file;
>         u32             opf;
>
> +       /* Buffer 1 metadata - readable for bpf prog */
> +       u32             buf1_len;               /* buffer 1 length, bytes=
 12-15 */
> +       u64             buf1_addr;              /* buffer 1 address or of=
fset, bytes 16-23 */
> +
> +       /* Buffer 2 metadata - readable for bpf prog (plain only) */
> +       u64             buf2_addr;              /* buffer 2 address, byte=
s 24-31 */
> +       u32             buf2_len;               /* buffer 2 length, bytes=
 32-35 */
> +       u32             __pad;                  /* padding, bytes 36-39 *=
/
> +
>         /* writeable for bpf prog */
> -       u8              pdu[64 - sizeof(struct file *) - sizeof(u32)];
> +       u8              pdu[64 - sizeof(struct file *) - 4 * sizeof(u32) =
-
> +               2 * sizeof(u64)];
>  };
>
>  typedef int (*uring_io_prep_t)(struct uring_bpf_data *data,
> --
> 2.47.0
>

