Return-Path: <io-uring+bounces-9739-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3128AB531BB
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 14:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C4297A4A6C
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 12:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B092031B833;
	Thu, 11 Sep 2025 12:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z9G6EcfC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21B61A2387;
	Thu, 11 Sep 2025 12:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757592431; cv=none; b=pPDo+nq01KaFCaQU7CAzugrilJpfalb7dJHqMCQb2+mtOKhB1bGxwMQfn+De/Vzf5qFSNiqhRIf2N+0NmIagYkHn+pODugU1qTvzuNY3PiivNkkO1tnFO7L0IRA8/kUdk69FgpsbVj8VkvagkNjxW64u+x6QoxysikVhBh5shho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757592431; c=relaxed/simple;
	bh=CWtgdGZKGiV6C2LAqDBOWl4B+CogxkQkccfpg7R1L7I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KdPvN0RHRjj2Y1f1HYznu47vxHZkjAKl+wcpc5LRtoZzr3DYvYEIMSYFsX/NWnr6PxnXUfurb6YwTN1K52TjGTtgLUQcbDuMehDND8xFzedrwmWtDtHd4Of1IVo0NMTQnVKWeM4FB2dSxZCz4YdTYkvkJEbX7E0t8CKxivw7Fes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z9G6EcfC; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b0473327e70so102318066b.3;
        Thu, 11 Sep 2025 05:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757592428; x=1758197228; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MlXq62wKeHqg0gd09zghwHhFaAtZDnEewIqOdMn/A2I=;
        b=Z9G6EcfCqUI4Yn+03tzsObmBUSmPVQHMQfDCpu3cs0nGAwp5if+NO1EePp7G8vxJsI
         lfsbMGMD7CLj309oU9Y2kqEc/bxN8+x/wN8Hi8h2W3auSOahC1xhY/Ih2M9nA1gvZ5J6
         haCNViHzZrqde7pGvkuM1Bkq1dObL9aAl7EJM1kOajpgMZdHzyGM1gIO8ueiS7fvcFBU
         e6S5slrN9YPGMYKQ/WB3hwvmVcrNqbG1JM9A/paHz+06SvUkqSsSpL7rHdRKkS8ClfOM
         bHY0n3yneYH9/UchX1hYhGZOuNMcLbkcmcTnK656mZ40YtiEI6I7rCmhCsGrUtKpbiTW
         cEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757592428; x=1758197228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MlXq62wKeHqg0gd09zghwHhFaAtZDnEewIqOdMn/A2I=;
        b=rSIpOo3HxvAlceqqhDeQceMs9yNb0EwwO7TiJ1EcBFsYq4wYP8ODoXZeUe4cY1wlnx
         Bz+wwmHjRdhoq6YZoiSH14wyjeieErMNHwatNeKrSpacYU09iYCDLCpR53TZ4SOCDVFm
         /TgFQ29tSAr2VTim2/U6JnXTQinKfnMscFKYRVuwErocjPF2FL9z7IiTvkzk6WTTbUau
         YbMQUs5ZyBvlTq9Axu7wDkhsR65TDAlibVqLQ3/gxega2tPj5Tbm7tCeQDNF1vYZzxKq
         Ac+REQ2JAMkk6N3qLjZ1l6xEsJ1qGCbFCguCGNykzBzs38syvUyLFn0Q3HdvXWZyikeF
         hicw==
X-Forwarded-Encrypted: i=1; AJvYcCUdwN9yNX8iLXvcdqNW0OabX2u8NFEPBI6qtb7tKvvgpYRfRKCVBZuDD2iS3u0EYWDcYmS6oBWtfJ034+Bv@vger.kernel.org, AJvYcCVlLYgCfwNyIny5sp43riaM5o2FyzHwgjYP15LL7u+HiQUA6AYaF06eMNJBwc1x4HtiwXnb2IQrja3Q@vger.kernel.org
X-Gm-Message-State: AOJu0YxY+OB29i8pRLwKhdVX81tWvaISwBZzTD3wbIxA48ubrMDrK2ay
	XYEnvAf3aoDseQ9OFlJUep8K7yoNCr8GygWBEF7WPozCyFIM+6epLOKvVXE3ZBHmj+NOGQN7/4R
	JLhItjhMSNqGkuoFXfZtuvOr5GaitEyI=
X-Gm-Gg: ASbGncuCOqPrZGt2PJ8a1jSMoi/EltC5SBS5L5JmqIMviZSkQmER5hKXY3VK9M9cU6s
	NqGkarYgkqttw4abwyYTrtHIwQFi9hLpkVyPJyiyl5IdSq9cJRHCVGWR8Qi9JoCFYEXtkhqwBm8
	k/FXiRtnFylLYMv6/zbDlvATg0hUO9Z8+rNL9Sj6KL2mmlVpH4ZKfLQZf/hU4Xq4VbBl+ocFPSu
	u66bkA=
X-Google-Smtp-Source: AGHT+IHuO4Y18/ms8HXtfsVzkykLOgDmAzsniOj5IhMIMaxBgw7OSG4cIU3ZypSMTOIG9T8PMAClxQPupp2Q4vvNwf4=
X-Received: by 2002:a17:907:1c93:b0:b04:58f8:16e3 with SMTP id
 a640c23a62f3a-b04b1458ca9mr1835311266b.24.1757592427535; Thu, 11 Sep 2025
 05:07:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910214927.480316-1-tahbertschinger@gmail.com> <20250910214927.480316-2-tahbertschinger@gmail.com>
In-Reply-To: <20250910214927.480316-2-tahbertschinger@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 Sep 2025 14:06:56 +0200
X-Gm-Features: Ac12FXwE8Bj9dGWGo-5zJ_H-d4HpOgV3sKUQE4ulZ5dVMB7X5gawDwPRuEUsYDQ
Message-ID: <CAOQ4uxhFXaqxy2tDvFpw1MpX8ierbiXL4kXq0rLL22X3h=_UXA@mail.gmail.com>
Subject: Re: [PATCH 01/10] fhandle: create helper for name_to_handle_at(2)
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025 at 11:47=E2=80=AFPM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> Create a helper do_sys_name_to_handle_at() that takes an additional
> argument, lookup_flags, beyond the syscall arguments.
>
> Because name_to_handle_at(2) doesn't take any lookup flags, it always
> passes 0 for this argument.
>
> Future callers like io_uring may pass LOOKUP_CACHED in order to request
> a non-blocking lookup.
>
> This helper's name is confusingly similar to do_sys_name_to_handle()
> which takes care of returning the file handle, once the filename has
> been turned into a struct path. To distinguish the names more clearly,
> rename the latter to do_path_to_handle().
>
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>

Thomas,

If you post another patch set please use git-format -v3 to add v3
to all patch subjects (not only to cover letter subject).

Feel free to add:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.

> ---
>  fs/fhandle.c  | 61 ++++++++++++++++++++++++++++-----------------------
>  fs/internal.h |  9 ++++++++
>  2 files changed, 43 insertions(+), 27 deletions(-)
>
> diff --git a/fs/fhandle.c b/fs/fhandle.c
> index 68a7d2861c58..605ad8e7d93d 100644
> --- a/fs/fhandle.c
> +++ b/fs/fhandle.c
> @@ -14,10 +14,10 @@
>  #include "internal.h"
>  #include "mount.h"
>
> -static long do_sys_name_to_handle(const struct path *path,
> -                                 struct file_handle __user *ufh,
> -                                 void __user *mnt_id, bool unique_mntid,
> -                                 int fh_flags)
> +static long do_path_to_handle(const struct path *path,
> +                             struct file_handle __user *ufh,
> +                             void __user *mnt_id, bool unique_mntid,
> +                             int fh_flags)
>  {
>         long retval;
>         struct file_handle f_handle;
> @@ -111,27 +111,11 @@ static long do_sys_name_to_handle(const struct path=
 *path,
>         return retval;
>  }
>
> -/**
> - * sys_name_to_handle_at: convert name to handle
> - * @dfd: directory relative to which name is interpreted if not absolute
> - * @name: name that should be converted to handle.
> - * @handle: resulting file handle
> - * @mnt_id: mount id of the file system containing the file
> - *          (u64 if AT_HANDLE_MNT_ID_UNIQUE, otherwise int)
> - * @flag: flag value to indicate whether to follow symlink or not
> - *        and whether a decodable file handle is required.
> - *
> - * @handle->handle_size indicate the space available to store the
> - * variable part of the file handle in bytes. If there is not
> - * enough space, the field is updated to return the minimum
> - * value required.
> - */
> -SYSCALL_DEFINE5(name_to_handle_at, int, dfd, const char __user *, name,
> -               struct file_handle __user *, handle, void __user *, mnt_i=
d,
> -               int, flag)
> +long do_sys_name_to_handle_at(int dfd, const char __user *name,
> +                             struct file_handle __user *handle,
> +                             void __user *mnt_id, int flag, int lookup_f=
lags)
>  {
>         struct path path;
> -       int lookup_flags;
>         int fh_flags =3D 0;
>         int err;
>
> @@ -155,19 +139,42 @@ SYSCALL_DEFINE5(name_to_handle_at, int, dfd, const =
char __user *, name,
>         else if (flag & AT_HANDLE_CONNECTABLE)
>                 fh_flags |=3D EXPORT_FH_CONNECTABLE;
>
> -       lookup_flags =3D (flag & AT_SYMLINK_FOLLOW) ? LOOKUP_FOLLOW : 0;
> +       if (flag & AT_SYMLINK_FOLLOW)
> +               lookup_flags |=3D LOOKUP_FOLLOW;
>         if (flag & AT_EMPTY_PATH)
>                 lookup_flags |=3D LOOKUP_EMPTY;
>         err =3D user_path_at(dfd, name, lookup_flags, &path);
>         if (!err) {
> -               err =3D do_sys_name_to_handle(&path, handle, mnt_id,
> -                                           flag & AT_HANDLE_MNT_ID_UNIQU=
E,
> -                                           fh_flags);
> +               err =3D do_path_to_handle(&path, handle, mnt_id,
> +                                       flag & AT_HANDLE_MNT_ID_UNIQUE,
> +                                       fh_flags);
>                 path_put(&path);
>         }
>         return err;
>  }
>
> +/**
> + * sys_name_to_handle_at: convert name to handle
> + * @dfd: directory relative to which name is interpreted if not absolute
> + * @name: name that should be converted to handle.
> + * @handle: resulting file handle
> + * @mnt_id: mount id of the file system containing the file
> + *          (u64 if AT_HANDLE_MNT_ID_UNIQUE, otherwise int)
> + * @flag: flag value to indicate whether to follow symlink or not
> + *        and whether a decodable file handle is required.
> + *
> + * @handle->handle_size indicate the space available to store the
> + * variable part of the file handle in bytes. If there is not
> + * enough space, the field is updated to return the minimum
> + * value required.
> + */
> +SYSCALL_DEFINE5(name_to_handle_at, int, dfd, const char __user *, name,
> +               struct file_handle __user *, handle, void __user *, mnt_i=
d,
> +               int, flag)
> +{
> +       return do_sys_name_to_handle_at(dfd, name, handle, mnt_id, flag, =
0);
> +}
> +
>  static int get_path_anchor(int fd, struct path *root)
>  {
>         if (fd >=3D 0) {
> diff --git a/fs/internal.h b/fs/internal.h
> index 38e8aab27bbd..c972f8ade52d 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -355,3 +355,12 @@ int anon_inode_getattr(struct mnt_idmap *idmap, cons=
t struct path *path,
>  int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>                        struct iattr *attr);
>  void pidfs_get_root(struct path *path);
> +
> +/*
> + * fs/fhandle.c
> + */
> +#ifdef CONFIG_FHANDLE
> +long do_sys_name_to_handle_at(int dfd, const char __user *name,
> +                             struct file_handle __user *handle,
> +                             void __user *mnt_id, int flag, int lookup_f=
lags);
> +#endif /* CONFIG_FHANDLE */
> --
> 2.51.0
>
>

