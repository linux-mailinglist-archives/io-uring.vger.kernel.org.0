Return-Path: <io-uring+bounces-2337-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ACF99169E0
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 16:09:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E17B1C21A1E
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 14:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C421B7F7;
	Tue, 25 Jun 2024 14:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h+eb/ipd"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6635161936;
	Tue, 25 Jun 2024 14:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719324557; cv=none; b=iLmyIh1Qg7vjvYUa/qkLCRYGeqQJxHgPZvDn+HUJ21isWf12d6YGPg7nB7Xp61mnp3AFo8yJEOkrPIcTVNFkYTUCTg7Buiya4dhDiN/q/AOQjUnALoQ7di8tIj1JtKVJrSHfnxzNGkxnxDS64CtN0kpGptc+YK2cv/nrCRr6E7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719324557; c=relaxed/simple;
	bh=hlLqkbvsl8FfkgUGGlRARxPGbfNFx55w1hPBJfOAgHA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZRusZwLVBsbkRUn+2vTpw5Xx1VikYxUcrTzbEb1QkIEJNyvr8wl1y8WweepNnRgHldEuuT32iKyJZjNbEHzG+LDesIogCVGqfGiHvXHOi1omRrPLegQiPIC1qgq9IixfOrKHymYwQ9Q3w56FgL1sEPdfUspz1SaWA6LWjEHzgUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h+eb/ipd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509B3C4AF0D;
	Tue, 25 Jun 2024 14:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719324557;
	bh=hlLqkbvsl8FfkgUGGlRARxPGbfNFx55w1hPBJfOAgHA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=h+eb/ipdqcIcRdvSbvGtXe4k7qKlrw4eg1+t2K9U6LQ5UX8fdR9zwGuBKtngfshIl
	 kFtqRsh3xy9fzUodplSyP342b0vnDAWrTHl3yfbHNJ+IlxXMwNE4y5mSaJhJx3oWRC
	 wZ/tqG3EEuVRdxgAnmKL4JuTRpaNBL05YI8R34GNBWVDmCDBkHZlHzcSTRmU8jfNWt
	 miRQQRawvrtnRFpXvqu80jk7MgPdIyKGINjgUO/AGfL1R2R6+WCv6eUcagh8B//G8T
	 DT/XuRFBDOH0EziQSmnoBxvLORphfDR1YeQZmyHhSh95IEt8WSsW7Ni3Bg3SSRhoAF
	 ko1XCwZPRxu3A==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a724598cfe3so376524566b.1;
        Tue, 25 Jun 2024 07:09:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX0uH/He3/jrXJPTHqtT1A5Tl3IXpOsqQ48+F4mrvF/DLSy4JlNg+O5xR6jLUO7HT0U3zmAuH9+WxqE9iiIsQ97WzNbByzuzMKHYGDLSvDxO7NPylO7/1er3ASLC0JhQ0UPF4F4gNAzFI2CVr3zaL6VhPQzYwVnauk/BrSnhQrykK3QCm0E
X-Gm-Message-State: AOJu0Yx31cGx+LsjimTvUFq/depJFtsa9dxAikKBUmpW7IG9GDBvqL12
	EKroHq7qT9CPPM1YDnzJQ5/ZjIGfRDLqMwJWU+GiKepCdCAePHyY7bXpmivCgwgtHbIkZkRn5HA
	xAyOvr08+IuBb/YsmDffgkERgKbo=
X-Google-Smtp-Source: AGHT+IEv9khsq2McMAXCvCjQIz/xAD9ySx6njXlkyLTzNeiNd5EGy8BvIQl/0d6ORcdPqvhugAT19KVNDnaYOwS7k8s=
X-Received: by 2002:a17:907:160e:b0:a72:5e6f:b28d with SMTP id
 a640c23a62f3a-a725e6fb35dmr440530566b.73.1719324555779; Tue, 25 Jun 2024
 07:09:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625110029.606032-1-mjguzik@gmail.com> <20240625110029.606032-3-mjguzik@gmail.com>
In-Reply-To: <20240625110029.606032-3-mjguzik@gmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 25 Jun 2024 22:09:10 +0800
X-Gmail-Original-Message-ID: <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
Message-ID: <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, axboe@kernel.dk, torvalds@linux-foundation.org, 
	xry111@xry111.site, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2024 at 7:01=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> w=
rote:
>
> The newly used helper also checks for 0-sized buffers.
>
> This avoids path lookup code, lockref management, memory allocation and
> in case of NULL path userspace memory access (which can be quite
> expensive with SMAP on x86_64).
>
> statx with AT_EMPTY_PATH paired with "" or NULL argument as appropriate
> issued on Sapphire Rapids (ops/s):
> stock:     4231237
> 0-check:   5944063 (+40%)
> NULL path: 6601619 (+11%/+56%)
>
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Hi, Ruoyao,

I'm a bit confused. Ii this patch a replacement of your recent patch?

Huacai
> ---
>  fs/internal.h    |  2 ++
>  fs/stat.c        | 90 ++++++++++++++++++++++++++++++++++--------------
>  io_uring/statx.c | 23 +++++++------
>  3 files changed, 80 insertions(+), 35 deletions(-)
>
> diff --git a/fs/internal.h b/fs/internal.h
> index 1caa6a8f666f..0a018ebcaf49 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -244,6 +244,8 @@ extern const struct dentry_operations ns_dentry_opera=
tions;
>  int getname_statx_lookup_flags(int flags);
>  int do_statx(int dfd, struct filename *filename, unsigned int flags,
>              unsigned int mask, struct statx __user *buffer);
> +int do_statx_fd(int fd, unsigned int flags, unsigned int mask,
> +               struct statx __user *buffer);
>
>  /*
>   * fs/splice.c:
> diff --git a/fs/stat.c b/fs/stat.c
> index 106684034fdb..1214826f3a36 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -214,6 +214,43 @@ int getname_statx_lookup_flags(int flags)
>         return lookup_flags;
>  }
>
> +static int vfs_statx_path(struct path *path, int flags, struct kstat *st=
at,
> +                         u32 request_mask)
> +{
> +       int error =3D vfs_getattr(path, stat, request_mask, flags);
> +
> +       if (request_mask & STATX_MNT_ID_UNIQUE) {
> +               stat->mnt_id =3D real_mount(path->mnt)->mnt_id_unique;
> +               stat->result_mask |=3D STATX_MNT_ID_UNIQUE;
> +       } else {
> +               stat->mnt_id =3D real_mount(path->mnt)->mnt_id;
> +               stat->result_mask |=3D STATX_MNT_ID;
> +       }
> +
> +       if (path->mnt->mnt_root =3D=3D path->dentry)
> +               stat->attributes |=3D STATX_ATTR_MOUNT_ROOT;
> +       stat->attributes_mask |=3D STATX_ATTR_MOUNT_ROOT;
> +
> +       /* Handle STATX_DIOALIGN for block devices. */
> +       if (request_mask & STATX_DIOALIGN) {
> +               struct inode *inode =3D d_backing_inode(path->dentry);
> +
> +               if (S_ISBLK(inode->i_mode))
> +                       bdev_statx_dioalign(inode, stat);
> +       }
> +
> +       return error;
> +}
> +
> +static int vfs_statx_fd(int fd, int flags, struct kstat *stat,
> +                         u32 request_mask)
> +{
> +       CLASS(fd_raw, f)(fd);
> +       if (!f.file)
> +               return -EBADF;
> +       return vfs_statx_path(&f.file->f_path, flags, stat, request_mask)=
;
> +}
> +
>  /**
>   * vfs_statx - Get basic and extra attributes by filename
>   * @dfd: A file descriptor representing the base dir for a relative file=
name
> @@ -243,36 +280,13 @@ static int vfs_statx(int dfd, struct filename *file=
name, int flags,
>  retry:
>         error =3D filename_lookup(dfd, filename, lookup_flags, &path, NUL=
L);
>         if (error)
> -               goto out;
> -
> -       error =3D vfs_getattr(&path, stat, request_mask, flags);
> -
> -       if (request_mask & STATX_MNT_ID_UNIQUE) {
> -               stat->mnt_id =3D real_mount(path.mnt)->mnt_id_unique;
> -               stat->result_mask |=3D STATX_MNT_ID_UNIQUE;
> -       } else {
> -               stat->mnt_id =3D real_mount(path.mnt)->mnt_id;
> -               stat->result_mask |=3D STATX_MNT_ID;
> -       }
> -
> -       if (path.mnt->mnt_root =3D=3D path.dentry)
> -               stat->attributes |=3D STATX_ATTR_MOUNT_ROOT;
> -       stat->attributes_mask |=3D STATX_ATTR_MOUNT_ROOT;
> -
> -       /* Handle STATX_DIOALIGN for block devices. */
> -       if (request_mask & STATX_DIOALIGN) {
> -               struct inode *inode =3D d_backing_inode(path.dentry);
> -
> -               if (S_ISBLK(inode->i_mode))
> -                       bdev_statx_dioalign(inode, stat);
> -       }
> -
> +               return error;
> +       error =3D vfs_statx_path(&path, flags, stat, request_mask);
>         path_put(&path);
>         if (retry_estale(error, lookup_flags)) {
>                 lookup_flags |=3D LOOKUP_REVAL;
>                 goto retry;
>         }
> -out:
>         return error;
>  }
>
> @@ -677,6 +691,29 @@ int do_statx(int dfd, struct filename *filename, uns=
igned int flags,
>         return cp_statx(&stat, buffer);
>  }
>
> +int do_statx_fd(int fd, unsigned int flags, unsigned int mask,
> +            struct statx __user *buffer)
> +{
> +       struct kstat stat;
> +       int error;
> +
> +       if (mask & STATX__RESERVED)
> +               return -EINVAL;
> +       if ((flags & AT_STATX_SYNC_TYPE) =3D=3D AT_STATX_SYNC_TYPE)
> +               return -EINVAL;
> +
> +       /* STATX_CHANGE_COOKIE is kernel-only for now. Ignore requests
> +        * from userland.
> +        */
> +       mask &=3D ~STATX_CHANGE_COOKIE;
> +
> +       error =3D vfs_statx_fd(fd, flags, &stat, mask);
> +       if (error)
> +               return error;
> +
> +       return cp_statx(&stat, buffer);
> +}
> +
>  /**
>   * sys_statx - System call to get enhanced stats
>   * @dfd: Base directory to pathwalk from *or* fd to stat.
> @@ -696,6 +733,9 @@ SYSCALL_DEFINE5(statx,
>         int ret;
>         struct filename *name;
>
> +       if (flags =3D=3D AT_EMPTY_PATH && vfs_empty_path(dfd, filename))
> +               return do_statx_fd(dfd, flags, mask, buffer);
> +
>         name =3D getname_flags(filename, getname_statx_lookup_flags(flags=
), NULL);
>         ret =3D do_statx(dfd, name, flags, mask, buffer);
>         putname(name);
> diff --git a/io_uring/statx.c b/io_uring/statx.c
> index abb874209caa..fe967ecb1762 100644
> --- a/io_uring/statx.c
> +++ b/io_uring/statx.c
> @@ -23,6 +23,7 @@ struct io_statx {
>  int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>         struct io_statx *sx =3D io_kiocb_to_cmd(req, struct io_statx);
> +       struct filename *filename;
>         const char __user *path;
>
>         if (sqe->buf_index || sqe->splice_fd_in)
> @@ -36,15 +37,14 @@ int io_statx_prep(struct io_kiocb *req, const struct =
io_uring_sqe *sqe)
>         sx->buffer =3D u64_to_user_ptr(READ_ONCE(sqe->addr2));
>         sx->flags =3D READ_ONCE(sqe->statx_flags);
>
> -       sx->filename =3D getname_flags(path,
> -                                    getname_statx_lookup_flags(sx->flags=
),
> -                                    NULL);
> -
> -       if (IS_ERR(sx->filename)) {
> -               int ret =3D PTR_ERR(sx->filename);
> -
> -               sx->filename =3D NULL;
> -               return ret;
> +       sx->filename =3D NULL;
> +       if (!(sx->flags =3D=3D AT_EMPTY_PATH && vfs_empty_path(sx->dfd, p=
ath))) {
> +               filename =3D getname_flags(path,
> +                                        getname_statx_lookup_flags(sx->f=
lags),
> +                                        NULL);
> +               if (IS_ERR(filename))
> +                       return PTR_ERR(filename);
> +               sx->filename =3D filename;
>         }
>
>         req->flags |=3D REQ_F_NEED_CLEANUP;
> @@ -59,7 +59,10 @@ int io_statx(struct io_kiocb *req, unsigned int issue_=
flags)
>
>         WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
>
> -       ret =3D do_statx(sx->dfd, sx->filename, sx->flags, sx->mask, sx->=
buffer);
> +       if (sx->filename =3D=3D NULL)
> +               ret =3D do_statx_fd(sx->dfd, sx->flags, sx->mask, sx->buf=
fer);
> +       else
> +               ret =3D do_statx(sx->dfd, sx->filename, sx->flags, sx->ma=
sk, sx->buffer);
>         io_req_set_res(req, ret, 0);
>         return IOU_OK;
>  }
> --
> 2.43.0
>
>

