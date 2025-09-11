Return-Path: <io-uring+bounces-9745-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EA55B53277
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 14:38:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A98A53A99BF
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 12:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90F2E322755;
	Thu, 11 Sep 2025 12:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TD+i0uO+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF9B32142E;
	Thu, 11 Sep 2025 12:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757594324; cv=none; b=ClXoITEzNs+2AhCnlgzdGOXVlXf8RSMTKnsKeVnft0roahRnbwoOjjRT+/2NCM4QY8KrhvgCThMbhc/4bK7RAHT6AfP5atZC8SpZiNI1gmK0U2AZQOkB9+alDb+4Nxoca6IJCQgrjJ/Miuun9CNUUA2X/BbQtZaZhGPgbA4e0YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757594324; c=relaxed/simple;
	bh=u/ALNIVqq+8nv8iC67ZnZsItx42v7r8Su8BGFXCArmA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tGV7zZ+WyVb4IBhu1y/7TXY55wMf7VGR7vub3DMC10qR8Q1AYbe0fsQzOUvGf96sc+M9Ti13NOiPsaLM65EfWmeLIVH1K5qYjW9IEvygPt8t87xGLiuWo6njYK0O4J7wPfRTAQDsQuqoRh+zlnoxknjmrYT19qQtOu/lGVfdrtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TD+i0uO+; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-621b8b0893bso899111a12.2;
        Thu, 11 Sep 2025 05:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757594321; x=1758199121; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/WxJ3KYFLNnBUJGjxQykXswRz9dVVWA7eyNONYHvss=;
        b=TD+i0uO+4eAWzVmw1oU2l1fli6Usv9Ed4jqs0LIBsakch4xlF3UimRAqrOvXkhXJBX
         k6ncF70LzHTVc+EWLwZ/0AKB+KnTPcUpSb9nu6kMrwjRyny/LL3vdp7ajEaATWcz2RJJ
         JXG1FhVQh6Lrs2LZ1X6uLIjhgEyRTlQuXMZ1MSfv95VHFvdoSDsehmPAbcwd1ESukgnT
         EbdXWKC2cE3Xj8RuO2YrxfV5VE4f0NFslr3w7vd0FiqJ7KW+/576/TTl/Oegvt+rTONa
         thLWLsloJGpjwsxBLlvIJy/7BzR0hp6xcldKHKY7oE/fO3wA8GWhjEj2kWC82jsubrAI
         VxJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757594321; x=1758199121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k/WxJ3KYFLNnBUJGjxQykXswRz9dVVWA7eyNONYHvss=;
        b=Ylb/vrpUpWxCMUdhGHlF5DaDrG5RCSkI0gqX2etzhWKmsavcMXIiTn/hqxipa2ejsk
         UQvBeajCU54U+e1cQPwuX4C5i8tPlNU45QUnWMxum8U+l9n2XAs/fo51TkvEtWqND1ns
         n48DL46PEpWlijbVLIwtaIN3X9o+Reb4GE5Qby+wy9S4KWg1a9I2I0OVnW4tRxIymU6+
         2Ioq0IEsanBgezgbjjK5fCN/fZvU5vigmOi/kfrKDqRCEEWZ3TUrtArejokqpBPX16BE
         FjvdF2RdmWSAU/n2UrULsd7LEfKsyNh1gjL9TRXTEOppyar1lThrGcfeifhHd47SQBEW
         R55A==
X-Forwarded-Encrypted: i=1; AJvYcCUXHX9F8k6nK1zjvTqvv3fP+uO1ARU64ot6FCcBVLsLsah68+IDt1oJ3u43dS2BNv91b2XyL9azjiAX8sz5@vger.kernel.org, AJvYcCV1JTK5ubZQjRsKscytN/eWvMO2tKOajbuV/MG+Wm5oLygxYYaBbuOkrMpZoZGgH2iQ5/Kzk16p8BG5@vger.kernel.org, AJvYcCVxnyTRCwPQ7zoz4YEOzDBdaMzEnugtsRUlTmV8vI5cz3LM1+5lqCZd0yPw2hwmoFu2hQlcGyOVrZj4@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6ygIVKHH9wYK7TJX0p/z7XprH6dfZJc8lKgXFsjP6bRqjvh38
	tNCccCdg3T1sEEYuSK5XwZmE7j/fLXJi4IsXpGX6Ft6jCWCmp6qCUlOlNwNgYT7weSERqMI58xb
	rKJH5bKQnbhupFfbtUHd52dL5+r23yJaV3JWJc9A=
X-Gm-Gg: ASbGncuaJCtSRKRoESeUsDOW/Gc3OVC/R+JF411ucdDVlH4VHTjSVWa/cpaPMF9wcRT
	BNQZSQXjWIy0pur6ItvqjqWA5TVtYNr/sxVRoPefN5P5rkI3uJDc0NosGrgoLHSdzAt++GMX6uT
	aCe42+D+v2Ud+hgZ0MPC9QKd2aVy2COBaLcS92/NSNWW4bq+68vPYLcCOQ06Normgso74bxmhhY
	QB3qeo=
X-Google-Smtp-Source: AGHT+IFdidMZit/bEURg14HC0z6kPcGCPVdnSHA5O9P2/DeWpOZYekKab9y+LBjgHEVJfrB9JryUs5G7r/lha8TCxbU=
X-Received: by 2002:a05:6402:505c:b0:621:ceb4:12fb with SMTP id
 4fb4d7f45d1cf-6237ebc6feemr17386325a12.20.1757594320887; Thu, 11 Sep 2025
 05:38:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910214927.480316-1-tahbertschinger@gmail.com> <20250910214927.480316-11-tahbertschinger@gmail.com>
In-Reply-To: <20250910214927.480316-11-tahbertschinger@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 Sep 2025 14:38:29 +0200
X-Gm-Features: AS18NWCB5RTm3FkLAR4TV3ln9yphUjWssjJ4P_71yJHyHQFn7R6Wgo1_xHgWAsU
Message-ID: <CAOQ4uxhwmPWFHn7aTbjdzk_4RP7Vy+rqYe5GGWxDzV5s1YJ0Rg@mail.gmail.com>
Subject: Re: [PATCH 10/10] xfs: add support for non-blocking fh_to_dentry()
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, cem@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025 at 11:48=E2=80=AFPM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> This is to support using open_by_handle_at(2) via io_uring. It is useful
> for io_uring to request that opening a file via handle be completed
> using only cached data, or fail with -EAGAIN if that is not possible.
>
> The signature of xfs_nfs_get_inode() is extended with a new flags
> argument that allows callers to specify XFS_IGET_INCORE.
>
> That flag is set when the VFS passes the FILEID_CACHED flag via the
> fileid_type argument.
>
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>

I'll let xfs developers review this, but its looks pretty straightforward,
so on my part you may add:

Acked-by: Amir Goldstein <amir73il@gmail.com>

One small nit below

> ---
>  fs/xfs/xfs_export.c | 32 ++++++++++++++++++++++++++------
>  fs/xfs/xfs_export.h |  3 ++-
>  fs/xfs/xfs_handle.c |  2 +-
>  3 files changed, 29 insertions(+), 8 deletions(-)
>
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index 201489d3de08..ca2a9ed0eb16 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -106,7 +106,8 @@ struct inode *
>  xfs_nfs_get_inode(
>         struct super_block      *sb,
>         u64                     ino,
> -       u32                     generation)
> +       u32                     generation,
> +       uint                    flags)
>  {
>         xfs_mount_t             *mp =3D XFS_M(sb);
>         xfs_inode_t             *ip;
> @@ -123,7 +124,9 @@ xfs_nfs_get_inode(
>          * fine and not an indication of a corrupted filesystem as client=
s can
>          * send invalid file handles and we have to handle it gracefully.=
.
>          */
> -       error =3D xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED, 0, &ip);
> +       flags |=3D XFS_IGET_UNTRUSTED;
> +
> +       error =3D xfs_iget(mp, NULL, ino, flags, 0, &ip);
>         if (error) {
>
>                 /*
> @@ -140,6 +143,10 @@ xfs_nfs_get_inode(
>                 case -EFSCORRUPTED:
>                         error =3D -ESTALE;
>                         break;
> +               case -ENODATA:
> +                       if (flags & XFS_IGET_INCORE)
> +                               error =3D -EAGAIN;
> +                       break;
>                 default:
>                         break;
>                 }
> @@ -174,6 +181,12 @@ xfs_fs_fh_to_dentry(struct super_block *sb, struct f=
id *fid,
>  {
>         struct xfs_fid64        *fid64 =3D (struct xfs_fid64 *)fid;
>         struct inode            *inode =3D NULL;
> +       uint                    flags =3D 0;
> +
> +       if (fileid_type & FILEID_CACHED)
> +               flags =3D XFS_IGET_INCORE;
> +
> +       fileid_type =3D FILEID_TYPE(fileid_type);

That is a smelly practice.
It's better to rename the function argument to fileid_flags or fileid_type_=
flags
and use a local fileid_type var for fileid_type =3D FILEID_TYPE(fileid_flag=
s)

Thanks,
Amir.

>
>         if (fh_len < xfs_fileid_length(fileid_type))
>                 return NULL;
> @@ -181,11 +194,11 @@ xfs_fs_fh_to_dentry(struct super_block *sb, struct =
fid *fid,
>         switch (fileid_type) {
>         case FILEID_INO32_GEN_PARENT:
>         case FILEID_INO32_GEN:
> -               inode =3D xfs_nfs_get_inode(sb, fid->i32.ino, fid->i32.ge=
n);
> +               inode =3D xfs_nfs_get_inode(sb, fid->i32.ino, fid->i32.ge=
n, flags);
>                 break;
>         case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
>         case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
> -               inode =3D xfs_nfs_get_inode(sb, fid64->ino, fid64->gen);
> +               inode =3D xfs_nfs_get_inode(sb, fid64->ino, fid64->gen, f=
lags);
>                 break;
>         }
>
> @@ -198,6 +211,12 @@ xfs_fs_fh_to_parent(struct super_block *sb, struct f=
id *fid,
>  {
>         struct xfs_fid64        *fid64 =3D (struct xfs_fid64 *)fid;
>         struct inode            *inode =3D NULL;
> +       uint                    flags =3D 0;
> +
> +       if (fileid_type & FILEID_CACHED)
> +               flags =3D XFS_IGET_INCORE;
> +
> +       fileid_type =3D FILEID_TYPE(fileid_type);
>
>         if (fh_len < xfs_fileid_length(fileid_type))
>                 return NULL;
> @@ -205,11 +224,11 @@ xfs_fs_fh_to_parent(struct super_block *sb, struct =
fid *fid,
>         switch (fileid_type) {
>         case FILEID_INO32_GEN_PARENT:
>                 inode =3D xfs_nfs_get_inode(sb, fid->i32.parent_ino,
> -                                             fid->i32.parent_gen);
> +                                             fid->i32.parent_gen, flags)=
;
>                 break;
>         case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
>                 inode =3D xfs_nfs_get_inode(sb, fid64->parent_ino,
> -                                             fid64->parent_gen);
> +                                             fid64->parent_gen, flags);
>                 break;
>         }
>
> @@ -248,4 +267,5 @@ const struct export_operations xfs_export_operations =
=3D {
>         .map_blocks             =3D xfs_fs_map_blocks,
>         .commit_blocks          =3D xfs_fs_commit_blocks,
>  #endif
> +       .flags                  =3D EXPORT_OP_NONBLOCK,
>  };
> diff --git a/fs/xfs/xfs_export.h b/fs/xfs/xfs_export.h
> index 3cd85e8901a5..9addfcd5b1e1 100644
> --- a/fs/xfs/xfs_export.h
> +++ b/fs/xfs/xfs_export.h
> @@ -57,6 +57,7 @@ struct xfs_fid64 {
>  /* This flag goes on the wire.  Don't play with it. */
>  #define XFS_FILEID_TYPE_64FLAG 0x80    /* NFS fileid has 64bit inodes */
>
> -struct inode *xfs_nfs_get_inode(struct super_block *sb, u64 ino, u32 gen=
);
> +struct inode *xfs_nfs_get_inode(struct super_block *sb, u64 ino, u32 gen=
,
> +                               uint flags);
>
>  #endif /* __XFS_EXPORT_H__ */
> diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
> index f19fce557354..7d877ff504d6 100644
> --- a/fs/xfs/xfs_handle.c
> +++ b/fs/xfs/xfs_handle.c
> @@ -193,7 +193,7 @@ xfs_khandle_to_inode(
>                 return ERR_PTR(-EINVAL);
>
>         inode =3D xfs_nfs_get_inode(mp->m_super, handle->ha_fid.fid_ino,
> -                       handle->ha_fid.fid_gen);
> +                       handle->ha_fid.fid_gen, 0);
>         if (IS_ERR(inode))
>                 return ERR_CAST(inode);
>
> --
> 2.51.0
>
>

