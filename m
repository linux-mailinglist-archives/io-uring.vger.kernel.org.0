Return-Path: <io-uring+bounces-9744-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 485C1B53248
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 14:32:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F7AB1C87C48
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 12:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A021322C63;
	Thu, 11 Sep 2025 12:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FD/I6jVk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF4F2B9A4;
	Thu, 11 Sep 2025 12:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757593890; cv=none; b=iEq2iKeu8z3QJqJ2QgwZg3F8obSB/rFFOg3wIM/i0aJ3gShwJ9QWQg3s3zMMQKhZejsBx1ZbBR/lOsZRmYyELcYUu8ZmDWWmnwJlRVbROsAHmikvIUP3b9z9/zgguAiLo+IzVCZawrdV153/AH+a2kQ63ekByjnM1WdBmQt4zho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757593890; c=relaxed/simple;
	bh=hDtQkdh6WZWn0haheZLwVUGKnT10G9NPRD7mdTFVjHc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o1VtJElkTbhtg9q3mmkSGidBSsHNmc9PvvgdMHqX2fntUplvlZyAcJJ1oiWkSuCnr+OcRS4Ud7sAZQljA3ZDTy1TynvK5YRYoytHpFjyBPdkmEano0Nx8Gqq7aGD7fbZHOjQxjFeb/d0X3875pTUPQE2ffCsv08Vihr8+Adpmfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FD/I6jVk; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6228de281baso1106531a12.1;
        Thu, 11 Sep 2025 05:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757593887; x=1758198687; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Kins1VKefbulcK0+wbfTrzadCXq3OhWXuadJ2XRZFI=;
        b=FD/I6jVkhsbs+gb3PiRCLPPXVnhZja8Vxd71JCAzcrS99S7TEYBTqqosDYJaqk0aJE
         6sZ7N+zI1mkYKc9vLB1QQHek+zDPvjXuZkZ5NQDoII+R/pDMHM2xitePVJiMNW4pfwRZ
         nLvL8tfJ1KC11V3haunrmYdyU2tsgHXG5zCe/MIkr3GwxXkef2IWQw/oW6+TbYJzhzKB
         vc6ujsFBvFZSlUg7aqhSIx/EnwTq+Ld/a63oeM8QtKUyGgTEBe7ozkMCmuK6/pe+D3L9
         XpARUJvR4f9VPzllqCILPG4ryPhtn3Du2WY2eOqxrdZpAgTRmoGe4saOKDQPkFSObUnO
         lrVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757593887; x=1758198687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Kins1VKefbulcK0+wbfTrzadCXq3OhWXuadJ2XRZFI=;
        b=kOV6aAdhOpDyLKxSrB/0FKkIDKXTad5BcdFx2TIvo6GOA3jYbs/zcOrmY3wBXffOp9
         U5sDn8t3VjgGH+YoPoyZeKVE/HpyPny8kjOIo2zHSK38VIXY1aL2AHhe8evR36E79eoq
         aZ1mHR4mHYKNukyQge/7Vk6xQmkSLVnUHNGeaR0NuMDo4PrXCLyCQZ1uFqhv+4sbIlAv
         aRuka0sOD+on56dqJDZQzDIDzpzTeIAxb/dda+Orkqp2Oh8ThAIMXygEV39vGmwpQEuD
         MmdDeTK0O+8lulaSAKsGV7jrfoq/7N66GD0IjbvsNPZC8Ob81uOU85EIAqUkgmFKTWw6
         aJzg==
X-Forwarded-Encrypted: i=1; AJvYcCXWsSDL0p1chl2KU6qJSjyuUavVqHy76HJaM8tWDzI277sXK21IqkzvkpcdRXfaOdrN4tlLBaFlG6uc@vger.kernel.org, AJvYcCXs2XgzN3c2a5Q+fm4wbwKUOwAfbWpX+dvzfVabkvfyiaaDoWcW/HHB6DFvFa4b+7q6mKODlzdMBdYhD8HN@vger.kernel.org
X-Gm-Message-State: AOJu0YwR1s9w20X8rA63QinVP6oMcFNz7fYQ/TxlY4FC9wcDl1CAVmBM
	5GwEQ/eWvnzE+wVyr6V3LL3eRZOOfj25+PC/jAkmFk/1r3hWEBg4AW7sd64ykiY/IYGtXeEHmKM
	1Jid+GAxh8RxBwgWE7Fs2m1hTfLMMkOQ=
X-Gm-Gg: ASbGncvYI8VVOzCGZjLb89GKUR5+EUjVBr49RR8iJk08QDIA2UmjxAMsdFWooINPlCz
	V9Guf+To3bg9P9YEEO35s5m3ywqADZVoMe9gjgqmEJn93dD7OD1KlG/3AvY/Qd6KRlcEFO3vn1K
	biKDUOM6n3qT6LTx5VaaM1fORMYMVxeDJS/sBBf5IpwALLChb/dmd0lphHD3uqZHvKDrWcmWcIC
	EWmZKo=
X-Google-Smtp-Source: AGHT+IH3noTAubA5xmLSGRvfiZEBFi5M2dI1pL9G0yLTMhjR7ziZH+7RlBxlihSEl7EqS/oT41OvNI+Q6kAO31PbkAE=
X-Received: by 2002:a05:6402:2744:b0:628:f0df:2c7f with SMTP id
 4fb4d7f45d1cf-628f0df3006mr12655027a12.8.1757593886728; Thu, 11 Sep 2025
 05:31:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910214927.480316-1-tahbertschinger@gmail.com> <20250910214927.480316-8-tahbertschinger@gmail.com>
In-Reply-To: <20250910214927.480316-8-tahbertschinger@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 Sep 2025 14:31:14 +0200
X-Gm-Features: AS18NWCrKSfaZUUI0gGgwd_sAK79dWTfHTJXfqiLArxjanXepLHg3OOSgzOkdV4
Message-ID: <CAOQ4uxiS-U9cf63=RXyHEzFtp41n_Cg_2DnVYR_eNUx1Lb3ung@mail.gmail.com>
Subject: Re: [PATCH 07/10] exportfs: new FILEID_CACHED flag for non-blocking
 fh lookup
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org, 
	chuck.lever@oracle.com, jlayton@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025 at 11:47=E2=80=AFPM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> This defines a new flag FILEID_CACHED that the VFS can set in the
> handle_type field of struct file_handle to request that the FS
> implementations of fh_to_{dentry,parent}() only complete if they can
> satisfy the request with cached data.
>
> Because not every FS implementation will recognize this new flag, those
> that do recognize the flag can indicate their support using a new
> export flag, EXPORT_OP_NONBLOCK.
>
> If FILEID_CACHED is set in a file handle, but the filesystem does not
> set EXPORT_OP_NONBLOCK, then the VFS will return -EAGAIN without
> attempting to call into the filesystem code.
>
> exportfs_decode_fh_raw() is updated to respect the new flag by returning
> -EAGAIN when it would need to do an operation that may not be possible
> with only cached data.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Small comment below

> ---
>  fs/exportfs/expfs.c      | 13 +++++++++++++
>  fs/fhandle.c             |  2 ++
>  include/linux/exportfs.h |  5 +++++
>  3 files changed, 20 insertions(+)
>
> diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
> index 949ce6ef6c4e..88418b93abbf 100644
> --- a/fs/exportfs/expfs.c
> +++ b/fs/exportfs/expfs.c
> @@ -441,6 +441,7 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct f=
id *fid, int fh_len,
>                        void *context)
>  {
>         const struct export_operations *nop =3D mnt->mnt_sb->s_export_op;
> +       bool decode_cached =3D fileid_type & FILEID_CACHED;
>         struct dentry *result, *alias;
>         char nbuf[NAME_MAX+1];
>         int err;
> @@ -453,6 +454,10 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct =
fid *fid, int fh_len,
>          */
>         if (!exportfs_can_decode_fh(nop))
>                 return ERR_PTR(-ESTALE);
> +
> +       if (decode_cached && !(nop->flags & EXPORT_OP_NONBLOCK))
> +               return ERR_PTR(-EAGAIN);
> +
>         result =3D nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fileid_typ=
e);
>         if (IS_ERR_OR_NULL(result))
>                 return result;
> @@ -481,6 +486,10 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct =
fid *fid, int fh_len,
>                  * filesystem root.
>                  */
>                 if (result->d_flags & DCACHE_DISCONNECTED) {
> +                       err =3D -EAGAIN;
> +                       if (decode_cached)
> +                               goto err_result;
> +
>                         err =3D reconnect_path(mnt, result, nbuf);
>                         if (err)
>                                 goto err_result;
> @@ -526,6 +535,10 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct =
fid *fid, int fh_len,
>                 err =3D PTR_ERR(target_dir);
>                 if (IS_ERR(target_dir))
>                         goto err_result;
> +               err =3D -EAGAIN;
> +               if (decode_cached & (target_dir->d_flags & DCACHE_DISCONN=
ECTED)) {
> +                       goto err_result;
> +               }
>
>                 /*
>                  * And as usual we need to make sure the parent directory=
 is
> diff --git a/fs/fhandle.c b/fs/fhandle.c
> index 276c16454eb7..70e265f6a3ab 100644
> --- a/fs/fhandle.c
> +++ b/fs/fhandle.c
> @@ -273,6 +273,8 @@ static int do_handle_to_path(struct file_handle *hand=
le, struct path *path,
>         if (IS_ERR_OR_NULL(dentry)) {
>                 if (dentry =3D=3D ERR_PTR(-ENOMEM))
>                         return -ENOMEM;
> +               if (dentry =3D=3D ERR_PTR(-EAGAIN))
> +                       return -EAGAIN;
>                 return -ESTALE;
>         }
>         path->dentry =3D dentry;
> diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
> index 30a9791d88e0..8238b6f67956 100644
> --- a/include/linux/exportfs.h
> +++ b/include/linux/exportfs.h
> @@ -199,6 +199,8 @@ struct handle_to_path_ctx {
>  #define FILEID_FS_FLAGS_MASK   0xff00
>  #define FILEID_FS_FLAGS(flags) ((flags) & FILEID_FS_FLAGS_MASK)
>

/* vfs flags: */
> +#define FILEID_CACHED          0x100 /* Use only cached data when decodi=
ng handle */
> +
>  /* User flags: */
>  #define FILEID_USER_FLAGS_MASK 0xffff0000
>  #define FILEID_USER_FLAGS(type) ((type) & FILEID_USER_FLAGS_MASK)
> @@ -303,6 +305,9 @@ struct export_operations {
>                                                 */
>  #define EXPORT_OP_FLUSH_ON_CLOSE       (0x20) /* fs flushes file data on=
 close */
>  #define EXPORT_OP_NOLOCKS              (0x40) /* no file locking support=
 */
> +#define EXPORT_OP_NONBLOCK             (0x80) /* Filesystem supports non=
-
> +                                                 blocking fh_to_dentry()
> +                                               */
>         unsigned long   flags;
>  };
>
> --
> 2.51.0
>

