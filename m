Return-Path: <io-uring+bounces-10058-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E3E5ABEE9C1
	for <lists+io-uring@lfdr.de>; Sun, 19 Oct 2025 18:24:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 759D64E2045
	for <lists+io-uring@lfdr.de>; Sun, 19 Oct 2025 16:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928E6222584;
	Sun, 19 Oct 2025 16:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="So24cv2n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3E21A00F0
	for <io-uring@vger.kernel.org>; Sun, 19 Oct 2025 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760891065; cv=none; b=Vy3NHTJazyUY0jq4fbSBb3fbb371Bhq4LaZKQbUERDJY2a51GkGZkkEouKg6hDiYk7OQwLIQ0Qdd/FaFfDbl+9RyCRZN2jD3VNEv6FLjreuAYbFbyaqYifU9AbDQt+dKzvbzlKIEwHCcFVoOFftmXWbFEuDZPWb9+T9khFBhfdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760891065; c=relaxed/simple;
	bh=rXO36M0qeZauk9UEoMcY8qb3U7/KcH/hSDLETpgZmrk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qDoammPSiZk/ZMgQNIXsQjGm8IhWYTMOHDh83UmcsOLfTmz5BCTfFpU72nq9u/osRKdsxShXjt/u2ptDKmAKCJDrZ7QRUrL+YgGMK1P2QBrm/Cz2Xx/FUt1wx3h/m/jAF6dHgCLqzRaR8ZRA3pUEUj97fpfN2dPnDsDMHEf0RCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=So24cv2n; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-26987b80720so6869715ad.2
        for <io-uring@vger.kernel.org>; Sun, 19 Oct 2025 09:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1760891063; x=1761495863; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jbIkUR6b7otdsvfEI3XFvRh+GmzAMcCMklv7vLg7D8Y=;
        b=So24cv2nmb2c6OPRoh9DUB0W56q4/Z2WE/trx6JC3cxwaJnVBSKypVJVl+iriERJO8
         5buf25f6yCRPSS0rM0C+6cHOpeenweVXvR9wpa4HUBZO2rkJDjy9U48jLVtjXBrYRZsX
         jxSazteh5WL54LebRQV5DKivGeq13iyr/c7BXv+V4eLozkZu/dG8G7U7aCsPeplaBTdF
         RD3aJIABAIu/6SM2YnDZVKlhqEAnFbjybqOphMQpPuFFBjpjo6jLd94jOPixacT3jRhl
         OaMgrscVtbY1HD5e6fLTRCDpmKcYRsiq0BZuwz6C0hlChkVXO1mrE3oMdbyXGycxqWfC
         9tvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760891063; x=1761495863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jbIkUR6b7otdsvfEI3XFvRh+GmzAMcCMklv7vLg7D8Y=;
        b=C5pIJG9+CbQFcNVhu2m5WCpInaUnorAcct2kKiju/UY2H6iXC4KHBZ1W6oVNADKZ42
         LGbv0U5Si+LoQUhxRxNx229o7Dt344sF/bn1y7tuQbZadOXpm63p/B1mdK/zt+MplGi1
         88bu43IPJRRasa/to4bGrlMc9NE03/mDY0qqDzy0tQNvxE284lhy2eRSUQs5CJjWPOMl
         Uz7IbLD6nLXcrV4kMw6YboteoDOIViLZ/0XdrMGBwcjihQSVjM8C7aK7Wg4Rnn1JaxN3
         BgbvYfQfEwCfaU6oNUtlM47LVl8Nxun8XWWb3zDUS9l+oK7g72n37KSmhw4N2/i2i35Y
         P/qA==
X-Gm-Message-State: AOJu0Yzh3SudgEaRrXWbT3ocpjvnuGFVrlAUPndOZiElsUjRTqBZ5LzD
	mLsvwZ73Qr86QgsZ1BzL3FbRK7crCGCyGiT5TLvS36ildiDUgriZKMMqOgJu/xORY0ScaIi3foK
	5UhR8PUR1VkQ+Q0CZBqT+dBFFnTMS1ulzwh/Zq55oOA==
X-Gm-Gg: ASbGnctXakpxai03aLdy2Keq9iv/mq5AQKSTgHpEGydNXO1Neber1xrUYSllNeiFuqS
	uAIL/axNztfe08rAYSXihtOLPXI8jBrv1F1Fc1t0CNf+t66wgRKXEdfDHIqJgT2Z7EikA7WIRDc
	s09llGudwguKyO1JXVNo/ekrNsvucfz7rgyAYdWsjzRcQClesnbsj6MW6O0s7uBZ/YzkpRFkgNF
	u2VVoit1l1DGU3AthvuXMj6xa5DroC3IaQgkuaF6hk5x8QfzhJ0EQliY4ysIuW23Gi4uZd2YbTO
	ehHR8SvR8XuZmDAmWn4V8ns5w3sz
X-Google-Smtp-Source: AGHT+IGFJjEFRMdXWgi/cCQ5EMkxGpKEjzhogW710BHVgpcaQuFJ3b9ZMstQoUZ1e/Cy1eLxdcNqVe5E8e0ZrFFtyd4=
X-Received: by 2002:a17:902:ce0a:b0:27e:da7d:32d2 with SMTP id
 d9443c01a7336-290caf83194mr68525765ad.7.1760891062653; Sun, 19 Oct 2025
 09:24:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251013180011.134131-1-kbusch@meta.com> <20251013180011.134131-4-kbusch@meta.com>
In-Reply-To: <20251013180011.134131-4-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Sun, 19 Oct 2025 09:24:10 -0700
X-Gm-Features: AS18NWCLuHBVAyFiet1Ep20aWvSi4kiZj0vpGsFu83qfdu1oDTQRyaj9jSbFHjg
Message-ID: <CADUfDZp-6s8QYAoeikMG98MhvfsZ0V-Vu_EGVoHUhthM=xth6Q@mail.gmail.com>
Subject: Re: [PATCHv5 1/4] liburing: provide uring_cmd prep function
To: Keith Busch <kbusch@meta.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looks good to me, just a few minor comments.

On Mon, Oct 13, 2025 at 11:00=E2=80=AFAM Keith Busch <kbusch@meta.com> wrot=
e:
>
> From: Keith Busch <kbusch@kernel.org>
>
> The rw prep doesn't clear __pad1, which is a reserved field for

io_uring_prep_rw() does assign to sqe->off, which is unioned with
cmd_op and __pad1. Though obviously __pad1 being set to 0 is dependent
on a offset being passed as 0 to io_uring_prep_rw(). But I certainly
agree a dedicated helper for IORING_OP_URING_CMD is a great
improvement.

> uring_cmd. If a prior submission in that entry did use that field, the
> uring_cmd will fail the kernel's checks.
>
> Also, the nvme uring_cmd tests had a couple places setting the sqe addr
> and length, which are unused fields for the nvme uring_cmds, so they
> shouldn't have been doing that, though had been checking these, so it

"had" -> "hadn't"?

> didn't cause any errors.
>
> Provide a helper function specific to the uring_cmd preparation.
>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  src/include/liburing.h      | 19 +++++++++++++++----
>  test/io_uring_passthrough.c | 14 ++++----------
>  2 files changed, 19 insertions(+), 14 deletions(-)
>
> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index c80bffd3..f7af20aa 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -1517,6 +1517,19 @@ IOURINGINLINE void io_uring_prep_socket_direct_all=
oc(struct io_uring_sqe *sqe,
>         __io_uring_set_target_fixed_file(sqe, IORING_FILE_INDEX_ALLOC - 1=
);
>  }
>
> +IOURINGINLINE void io_uring_prep_uring_cmd(struct io_uring_sqe *sqe,
> +                                          int cmd_op,

I see this is copied from io_uring_prep_cmd_sock(), but u32 is
probably more accurate.


> +                                          int fd)
> +       LIBURING_NOEXCEPT
> +{
> +       sqe->opcode =3D (__u8) IORING_OP_URING_CMD;

Casting the constant seems unnecessary. Do compilers really warn about this=
?

> +       sqe->fd =3D fd;
> +       sqe->cmd_op =3D cmd_op;
> +       sqe->__pad1 =3D 0;
> +       sqe->addr =3D 0ul;
> +       sqe->len =3D 0;
> +}
> +
>  /*
>   * Prepare commands for sockets
>   */
> @@ -1529,11 +1542,10 @@ IOURINGINLINE void io_uring_prep_cmd_sock(struct =
io_uring_sqe *sqe,
>                                           int optlen)
>         LIBURING_NOEXCEPT
>  {
> -       io_uring_prep_rw(IORING_OP_URING_CMD, sqe, fd, NULL, 0, 0);
> +       io_uring_prep_uring_cmd(sqe, cmd_op, fd);
>         sqe->optval =3D (unsigned long) (uintptr_t) optval;
>         sqe->optname =3D optname;
>         sqe->optlen =3D optlen;
> -       sqe->cmd_op =3D cmd_op;
>         sqe->level =3D level;
>  }
>
> @@ -1607,8 +1619,7 @@ IOURINGINLINE void io_uring_prep_cmd_discard(struct=
 io_uring_sqe *sqe,
>                                              uint64_t offset, uint64_t nb=
ytes)
>         LIBURING_NOEXCEPT
>  {
> -       io_uring_prep_rw(IORING_OP_URING_CMD, sqe, fd, 0, 0, 0);
> -       sqe->cmd_op =3D BLOCK_URING_CMD_DISCARD;
> +       io_uring_prep_uring_cmd(sqe, BLOCK_URING_CMD_DISCARD, fd);
>         sqe->addr =3D offset;
>         sqe->addr3 =3D nbytes;
>  }
> diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
> index beaa81ad..26051710 100644
> --- a/test/io_uring_passthrough.c
> +++ b/test/io_uring_passthrough.c
> @@ -148,11 +148,9 @@ static int __test_io(const char *file, struct io_uri=
ng *ring, int tc, int read,
>                 if (async)
>                         sqe->flags |=3D IOSQE_ASYNC;
>                 if (nonvec)
> -                       sqe->cmd_op =3D NVME_URING_CMD_IO;
> +                       io_uring_prep_uring_cmd(sqe, NVME_URING_CMD_IO, u=
se_fd);

I guess this works because io_uring_prep_uring_cmd() doesn't touch
sqe->buf_index or sqe->flags, but it seems like it would be less
brittle to call io_uring_prep_uring_cmd() before setting any of the
other sqe fields.

>                 else
> -                       sqe->cmd_op =3D NVME_URING_CMD_IO_VEC;
> -               sqe->fd =3D use_fd;
> -               sqe->opcode =3D IORING_OP_URING_CMD;
> +                       io_uring_prep_uring_cmd(sqe, NVME_URING_CMD_IO_VE=
C, use_fd);
>                 if (do_fixed)
>                         sqe->uring_cmd_flags |=3D IORING_URING_CMD_FIXED;
>                 sqe->user_data =3D ((uint64_t)offset << 32) | i;
> @@ -328,9 +326,7 @@ static int test_invalid_passthru_submit(const char *f=
ile)
>         }
>
>         sqe =3D io_uring_get_sqe(&ring);
> -       io_uring_prep_read(sqe, fd, vecs[0].iov_base, vecs[0].iov_len, 0)=
;
> -       sqe->cmd_op =3D NVME_URING_CMD_IO;
> -       sqe->opcode =3D IORING_OP_URING_CMD;
> +       io_uring_prep_uring_cmd(sqe, NVME_URING_CMD_IO, fd);
>         sqe->user_data =3D 1;
>         cmd =3D (struct nvme_uring_cmd *)sqe->cmd;
>         memset(cmd, 0, sizeof(struct nvme_uring_cmd));
> @@ -401,10 +397,8 @@ static int test_io_uring_submit_enters(const char *f=
ile)
>                 __u32 nlb;
>
>                 sqe =3D io_uring_get_sqe(&ring);
> -               io_uring_prep_readv(sqe, fd, &vecs[i], 1, offset);
> +               io_uring_prep_uring_cmd(sqe, NVME_URING_CMD_IO, fd);
>                 sqe->user_data =3D i;
> -               sqe->opcode =3D IORING_OP_URING_CMD;
> -               sqe->cmd_op =3D NVME_URING_CMD_IO;
>                 cmd =3D (struct nvme_uring_cmd *)sqe->cmd;
>                 memset(cmd, 0, sizeof(struct nvme_uring_cmd));
>
> --
> 2.47.3
>

