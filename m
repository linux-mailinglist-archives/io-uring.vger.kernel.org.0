Return-Path: <io-uring+bounces-7098-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA39A655D7
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 16:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 852573AA6C5
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 15:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4669F245025;
	Mon, 17 Mar 2025 15:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="YQG0MXK9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B62EC8EB
	for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 15:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742225839; cv=none; b=JRG1KNvQDecKF2YQ6Pz0vmo4L16pR8u/olJpKlSYWsokF/FLGwunPW+HjoyFbNfOF3Mk49CrGCgUzyDMdHZ80KTJk0SMMYDGixJL5Xeh64cWto0oBZ1vl+Qr4bZnDud0I2EV6i7dABxjUlYEM2tS+YoQDjy21a5PWJT739Hq/Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742225839; c=relaxed/simple;
	bh=91EOAGT/LTBvqkDxJPvP1DdiTgpu0CdX8waGspRJd3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R4SyJiNn3V2nw+clcY6QmQfw0kUF7XNAyQb26VjtWo8B9l2iHyB/1wZb1gOat3JkjfMUZnxToQNKRckLgwNeOPelw1ir6RTbj0Vr8ohrxKMFrlJAZAX9GVieGX327ysGkdNcLEOvwtwZh3Gox4qnwo9OxDY0fPqY7FVZ5qxXh+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=YQG0MXK9; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-223fd44daf8so12224955ad.2
        for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 08:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742225837; x=1742830637; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SiuraD0scF98DIVnU8j0ichZUEJVFJ9SSQQ48OkmXJE=;
        b=YQG0MXK9/XmPj12Y2SpjDJLDxCCbZRn9d5hR3wxd+LyFEKabXc+JBD0kvgbTL1ASCT
         LbiTntYo3sDdy2OhFN8KSHx+ydrhr4dRYyMepN//mNUc73vTNKy4lYdoSHzfAyvibol1
         ilIoBv4LEaPloiIJe8221dum6Lo/UpLn94RwTT6gTsJQGbnBbgwbytqGTu5CRrcqFFoW
         b2JeyMe8V6ljj2h2CEDWqoerdgqB4aZ8TWotraMtfG1jdeD0NNCYdvZgIF0K04JUSPFH
         Ol69N70SjicxhazQIzWLO9mPlM8UyWco2iQbyEk6nVnLAdFPqNF/1uy0EBdO0tcQN/Jl
         Tpxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742225837; x=1742830637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SiuraD0scF98DIVnU8j0ichZUEJVFJ9SSQQ48OkmXJE=;
        b=kYsoxc9EwwYui+MMWd78gQJjQdnkqxMhnQavBNsmRl6PmLMoOyBzLHk2SFXH7oAGwV
         YRd+yp+BH1eo5kXq3wlCOAa/kAs29vL9aIIlKMIOoAnGecVi/gA2DK8m8t8jJqKuxl0Y
         DNOxn1KUG+5B2cV0WuZ0YmwnfoB0m/YqgEqLnte5PrgYr7f9QO6f+X0gj40Ce+B963WY
         MBFpflqi99FLETdxpJBivpYn00KBG38W0D45JdaNhkGtCOfMsuzotWmMmhl5vcc6syDW
         8vhTeipvpgipXS2FHPkFrWbA3JIlM9f2d9ayQWdRRo/HUmINwU+0Qi14+V8OdX2vfmFK
         iRzw==
X-Forwarded-Encrypted: i=1; AJvYcCXKH7PgQECBxenVS4wCK+8d4sWY+O4zjLqWiB9MWKwWqL+VPl40jsjMBdD4HpWfwyWsAD5NwaUDlA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXi5BYOKVK+Vn39auLGZd1b3pQNU7QAY3ScIMQGbIpb/6FY89P
	pihILZtUzd9zY6pOm37Vx2YikKMBtsnAgY1McfQ/R41lZGzjB+StxLx4+pnvIf5cwRiKTxwzUXw
	IjVbyJvw8XjJkBT9ArX52d1YTWRiZggHwkcKCRQ==
X-Gm-Gg: ASbGncso10CQ0fv3A+PIH7+CWjVIJnVRCul92dYiecIpQNcY6VEOD4IRMt2zOBzEDcs
	HwF9Y/LnOFU72vDeEug4DlW/Qlgvkv8iiZbH39QVv+rgBItrDXDSqIO8+yWUfPa86VPz6vFTG35
	TAqmQgO40DUBaPq8ohIS06/Di/
X-Google-Smtp-Source: AGHT+IE8Qbr3Z3+6SwhCTqHY9ADPhV2r/oQIGA5Q+N790zg0o4fuQxNlr+9lLIHk8Xp4CRzlkCuTq1UUuAzPw3fR6GI=
X-Received: by 2002:a17:902:e548:b0:223:5e86:efa9 with SMTP id
 d9443c01a7336-225e0a7e750mr60599445ad.8.1742225836723; Mon, 17 Mar 2025
 08:37:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317135742.4331-1-sidong.yang@furiosa.ai> <20250317135742.4331-5-sidong.yang@furiosa.ai>
In-Reply-To: <20250317135742.4331-5-sidong.yang@furiosa.ai>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 17 Mar 2025 08:37:04 -0700
X-Gm-Features: AQ5f1JotubFdO4WCR1ty3ess4dG_oJvLLuow5UKCYcAMST_9n9hwbV1GunT3J1E
Message-ID: <CADUfDZoR+L8za5h6-Q=EL-7bRekBt03CeARE48EjMr18S6gvww@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/5] btrfs: ioctl: introduce btrfs_uring_import_iovec()
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 17, 2025 at 7:00=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.ai=
> wrote:
>
> This patch introduces btrfs_uring_import_iovec(). In encoded read/write
> with uring cmd, it uses import_iovec without supporting fixed buffer.
> btrfs_using_import_iovec() could use fixed buffer if cmd flags has
> IORING_URING_CMD_FIXED.
>
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
>  fs/btrfs/ioctl.c | 32 ++++++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 6c18bad53cd3..a7b52fd99059 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4802,6 +4802,28 @@ struct btrfs_uring_encoded_data {
>         struct iov_iter iter;
>  };
>
> +static int btrfs_uring_import_iovec(struct io_uring_cmd *cmd,
> +                                   unsigned int issue_flags, int rw)
> +{
> +       struct btrfs_uring_encoded_data *data =3D
> +               io_uring_cmd_get_async_data(cmd)->op_data;
> +       int ret;
> +
> +       if (cmd && (cmd->flags & IORING_URING_CMD_FIXED)) {
> +               data->iov =3D NULL;
> +               ret =3D io_uring_cmd_import_fixed_vec(cmd, data->args.iov=
,
> +                                                   data->args.iovcnt,
> +                                                   ITER_DEST, issue_flag=
s,

Why ITER_DEST instead of rw?

Best,
Caleb

> +                                                   &data->iter);
> +       } else {
> +               data->iov =3D data->iovstack;
> +               ret =3D import_iovec(rw, data->args.iov, data->args.iovcn=
t,
> +                                  ARRAY_SIZE(data->iovstack), &data->iov=
,
> +                                  &data->iter);
> +       }
> +       return ret;
> +}
> +
>  static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned i=
nt issue_flags)
>  {
>         size_t copy_end_kernel =3D offsetofend(struct btrfs_ioctl_encoded=
_io_args, flags);
> @@ -4874,10 +4896,7 @@ static int btrfs_uring_encoded_read(struct io_urin=
g_cmd *cmd, unsigned int issue
>                         goto out_acct;
>                 }
>
> -               data->iov =3D data->iovstack;
> -               ret =3D import_iovec(ITER_DEST, data->args.iov, data->arg=
s.iovcnt,
> -                                  ARRAY_SIZE(data->iovstack), &data->iov=
,
> -                                  &data->iter);
> +               ret =3D btrfs_uring_import_iovec(cmd, issue_flags, ITER_D=
EST);
>                 if (ret < 0)
>                         goto out_acct;
>
> @@ -5022,10 +5041,7 @@ static int btrfs_uring_encoded_write(struct io_uri=
ng_cmd *cmd, unsigned int issu
>                 if (data->args.len > data->args.unencoded_len - data->arg=
s.unencoded_offset)
>                         goto out_acct;
>
> -               data->iov =3D data->iovstack;
> -               ret =3D import_iovec(ITER_SOURCE, data->args.iov, data->a=
rgs.iovcnt,
> -                                  ARRAY_SIZE(data->iovstack), &data->iov=
,
> -                                  &data->iter);
> +               ret =3D btrfs_uring_import_iovec(cmd, issue_flags, ITER_S=
OURCE);
>                 if (ret < 0)
>                         goto out_acct;
>
> --
> 2.43.0
>
>

