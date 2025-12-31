Return-Path: <io-uring+bounces-11332-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D6A5CEAFB6
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 02:13:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE8463009401
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 01:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A87441C2324;
	Wed, 31 Dec 2025 01:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="FkUQIdZL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B4F7FBA2
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 01:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767143634; cv=none; b=gq5XDrmoZattnCA2rYf4ZZoKr6OqHzcn1OZoVfFz65wI+1uGd4MizbyGy15ArtOdgcwydrfz+yTu70AgGvV7XypjtNeMNhDstIHtL7cN15Kn8NwUWp1oCOnPs6XnmLfwEyqwpwqa9udIa+YW1LI06682OPJl3ZtJGrFphuVG1OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767143634; c=relaxed/simple;
	bh=BHc1lKJE0Lxu8JAlx2hMuiUWIwahFQkcP5p8tpc37Wo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MTPhf86u83lqCjWw4O+wHWU570r4By+Pwmh83ewBBRyFe6wOg7yU/+uVI9SqZFYqO/RUqpuH3zVrrKZ8E30LVQXnOB3hZXlNgCVwsH/ORWVlltL42WpZeOX77OSxRcuTZe9u3UJx1+5MVSZlMeZTY7+iDWn6F/8z3fpVuZ9UrmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=FkUQIdZL; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-34ab4879aa5so881632a91.0
        for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 17:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767143631; x=1767748431; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zq10vCygZW6CW+x1mvjXSGXGpQ8JcmNGWdgXeJyge+c=;
        b=FkUQIdZLN6MLUkjYeObh5dGVZlB7LDBNdHC7Ed2TVSapP9ayhg5tglH1wq99VE8pr4
         HdMv8gHdf3iyvtd/0IvGs4qve2DKJ8ZTCRfLRUwK7vlCAEcLvAheFSthpuKI6MvmgyLI
         5529D6cOIR+GiiI+ChCNRALzr1aCYINTrf5MskMteOYXmNuverXWGIsd0rf5tvD/ENJV
         3yU6I8NdpNBaMx9N4x/FeTLZl4G0ncMtwBoC7QdBzfi14KONyQiP8RUQdVubxCaF0d6J
         58xW5uT0ED1vnSvtbsr8CdyJ6lHMRE3IDoEpx5Jc3L+VzvuwRdghGjiGT+yJvEK09Wfx
         CeLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767143631; x=1767748431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zq10vCygZW6CW+x1mvjXSGXGpQ8JcmNGWdgXeJyge+c=;
        b=moQHyz7V5CG9lgQxtzy2SaCHhCeC2gMJ+6myWHeSl+sldqphLBLqUGvqxSWlzrEjCx
         CHnkzuWSRpPkllB1RdJSPPZwcD0GvBmO2/Y+Pbwyc9BS7GV6L7+07kzohO9MVkl/m5fe
         gfyWYH7zfGL6fjklOiDZAdAZhM9JtivF4t2QZwQBoJj6REcPny6MqXg989nOPspiINtj
         rjJK0xBbJ4PRU569akqbNrC7rSXEA8eCy+sYupNMgjpmdQBksI/G63J4spqWhM4hFhsp
         rsH1RwTcgic7S0qIogG0wkh8RJSqKvQcBfLiOxxICBaLmbUvvc0FTVsPkayxlzA0827B
         QlJg==
X-Forwarded-Encrypted: i=1; AJvYcCXZflvf83YWeft6tVLuLrCROyvqPgtU3B66jalls1G98mFbNaf6/caCrgwl6K9h90jipd7crtkOhA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsotBTbw2sJvEhyTIkurf3L0iE7YgWhIJjb2zDPajBwCEnPShZ
	0GaCBxyNY3UnuQZWofbMyaiuLNhaIYUo3uIqD7epBNpEisMTUZpe7UzNdk9R7etOPK0eu0PDg2t
	bwsvKlv5A7gITyfxDTGLOPF9SmauywWcYGWWA0T+xww==
X-Gm-Gg: AY/fxX7/LoD3VCKj0lrmgQGF3KCK4LfdGdlpJXdDeZrEANAT7iBjOUpi+VqxfXwpWym
	iezDuVDuzx6Rum+JR0/6NrBzDKh9HA+XFjHWsh+cRXQeP9Isl5TWtdrVLG5FuY/tSTTYnJcaRJG
	+U///2TCp9YofhU/JRrK1VMPvXuCMxvY+O4icmCvZgOtIFeXS8AzSf+wpAyKfPd4gd8A1EqRP+D
	CM9c6vW5mbkmlSvjNVF2ZEkM0OmAPwvxltBS7dcHX9aHKcjBQ2QlnQN2TjseBXPJeMf9yhTgbIG
	8gXE75E=
X-Google-Smtp-Source: AGHT+IGnvMYgLoUGqsdwvwcCTmeb80f7fpsbnkwKmZCezaIlRVuiT4QB92DpekjrbVoFg73H82rkpFpgzOai8JtsV7M=
X-Received: by 2002:a05:7022:3718:b0:119:e56b:46ba with SMTP id
 a92af1059eb24-121722efb56mr12235293c88.4.1767143631160; Tue, 30 Dec 2025
 17:13:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104162123.1086035-1-ming.lei@redhat.com> <20251104162123.1086035-2-ming.lei@redhat.com>
In-Reply-To: <20251104162123.1086035-2-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 30 Dec 2025 20:13:40 -0500
X-Gm-Features: AQt7F2o-Y_rqaK5zCZt0RytXUMHSDtgxGJhRCzo2ZGnMMj7QX-y9iFE46-9NNDY
Message-ID: <CADUfDZoTWvDspuyLRsHXZRa3D__dffyAptF=BpaF+h6pREbPug@mail.gmail.com>
Subject: Re: [PATCH 1/5] io_uring: prepare for extending io_uring with bpf
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 8:22=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrote=
:
>
> Add one bpf operation & related framework and prepare for extending io_ur=
ing
> with bpf.
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/uapi/linux/io_uring.h |  1 +
>  init/Kconfig                  |  7 +++++++
>  io_uring/Makefile             |  1 +
>  io_uring/bpf.c                | 26 ++++++++++++++++++++++++++
>  io_uring/opdef.c              | 10 ++++++++++
>  io_uring/uring_bpf.h          | 26 ++++++++++++++++++++++++++
>  6 files changed, 71 insertions(+)
>  create mode 100644 io_uring/bpf.c
>  create mode 100644 io_uring/uring_bpf.h
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
> index 04797a9b76bc..b167c1d4ce6e 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -303,6 +303,7 @@ enum io_uring_op {
>         IORING_OP_PIPE,
>         IORING_OP_NOP128,
>         IORING_OP_URING_CMD128,
> +       IORING_OP_BPF,
>
>         /* this goes last, obviously */
>         IORING_OP_LAST,
> diff --git a/init/Kconfig b/init/Kconfig
> index cab3ad28ca49..14d566516643 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1843,6 +1843,13 @@ config IO_URING
>           applications to submit and complete IO through submission and
>           completion rings that are shared between the kernel and applica=
tion.
>
> +config IO_URING_BPF
> +       bool "Enable IO uring bpf extension" if EXPERT
> +       depends on IO_URING && BPF
> +       help
> +         This option enables bpf extension for the io_uring interface, s=
o
> +         application can define its own io_uring operation by bpf progra=
m.
> +
>  config GCOV_PROFILE_URING
>         bool "Enable GCOV profiling on the io_uring subsystem"
>         depends on IO_URING && GCOV_KERNEL
> diff --git a/io_uring/Makefile b/io_uring/Makefile
> index bc4e4a3fa0a5..35eeeaf64489 100644
> --- a/io_uring/Makefile
> +++ b/io_uring/Makefile
> @@ -22,3 +22,4 @@ obj-$(CONFIG_NET_RX_BUSY_POLL)        +=3D napi.o
>  obj-$(CONFIG_NET) +=3D net.o cmd_net.o
>  obj-$(CONFIG_PROC_FS) +=3D fdinfo.o
>  obj-$(CONFIG_IO_URING_MOCK_FILE) +=3D mock_file.o
> +obj-$(CONFIG_IO_URING_BPF)     +=3D bpf.o
> diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> new file mode 100644
> index 000000000000..8c47df13c7b5
> --- /dev/null
> +++ b/io_uring/bpf.c
> @@ -0,0 +1,26 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2024 Red Hat */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <uapi/linux/io_uring.h>
> +#include "io_uring.h"
> +#include "uring_bpf.h"
> +
> +int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +       return -ECANCELED;
> +}
> +
> +int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *s=
qe)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +void io_uring_bpf_fail(struct io_kiocb *req)
> +{
> +}
> +
> +void io_uring_bpf_cleanup(struct io_kiocb *req)
> +{
> +}
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index df52d760240e..d93ee3d577d4 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -38,6 +38,7 @@
>  #include "futex.h"
>  #include "truncate.h"
>  #include "zcrx.h"
> +#include "uring_bpf.h"
>
>  static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
>  {
> @@ -593,6 +594,10 @@ const struct io_issue_def io_issue_defs[] =3D {
>                 .prep                   =3D io_uring_cmd_prep,
>                 .issue                  =3D io_uring_cmd,
>         },
> +       [IORING_OP_BPF] =3D {
> +               .prep                   =3D io_uring_bpf_prep,
> +               .issue                  =3D io_uring_bpf_issue,

Should this set .prep =3D io_eopnotsupp_prep for !CONFIG_IO_URING_BPF
and remove the stub implementations? That would be more consistent
with the other opcodes when they are configured out, and ensure
io_uring_op_supported(IORING_OP_BPF) returns false for
!CONFIG_IO_URING_BPF.

Best,
Caleb


> +       },
>  };
>
>  const struct io_cold_def io_cold_defs[] =3D {
> @@ -851,6 +856,11 @@ const struct io_cold_def io_cold_defs[] =3D {
>                 .sqe_copy               =3D io_uring_cmd_sqe_copy,
>                 .cleanup                =3D io_uring_cmd_cleanup,
>         },
> +       [IORING_OP_BPF] =3D {
> +               .name                   =3D "BPF",
> +               .cleanup                =3D io_uring_bpf_cleanup,
> +               .fail                   =3D io_uring_bpf_fail,
> +       },
>  };
>
>  const char *io_uring_get_opcode(u8 opcode)
> diff --git a/io_uring/uring_bpf.h b/io_uring/uring_bpf.h
> new file mode 100644
> index 000000000000..bde774ce6ac0
> --- /dev/null
> +++ b/io_uring/uring_bpf.h
> @@ -0,0 +1,26 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#ifndef IOU_BPF_H
> +#define IOU_BPF_H
> +
> +#ifdef CONFIG_IO_URING_BPF
> +int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags);
> +int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *s=
qe);
> +void io_uring_bpf_fail(struct io_kiocb *req);
> +void io_uring_bpf_cleanup(struct io_kiocb *req);
> +#else
> +static inline int io_uring_bpf_issue(struct io_kiocb *req, unsigned int =
issue_flags)
> +{
> +       return -ECANCELED;
> +}
> +static inline int io_uring_bpf_prep(struct io_kiocb *req, const struct i=
o_uring_sqe *sqe)
> +{
> +       return -EOPNOTSUPP;
> +}
> +static inline void io_uring_bpf_fail(struct io_kiocb *req)
> +{
> +}
> +static inline void io_uring_bpf_cleanup(struct io_kiocb *req)
> +{
> +}
> +#endif
> +#endif
> --
> 2.47.0
>

