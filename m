Return-Path: <io-uring+bounces-8970-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA02CB27E1F
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 12:22:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4D9658623F
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 10:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8791B2FB981;
	Fri, 15 Aug 2025 10:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LgGUGj2Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DED92E266D;
	Fri, 15 Aug 2025 10:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755253324; cv=none; b=mSD/mDm9QZEpzO2YIUlL8h3mo4CO3ojXhaj0zSC8L7xSkG3EbmR58Y2OO8nHwXMk2zZSbIAC6Sv/OYW2TPRl1S3oiMbKyevDUyQBrLFzNtjHxn12cXis8CcJ3EzV/XaebPtM+lDtj/PHYQ53ZoFI3juSVxIrLZcjcjfHFXDk6fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755253324; c=relaxed/simple;
	bh=w4aEl0lApqJYQI9NlKPFKNjOLq13vE6LRgzQNymqmMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CRFa/m5AHarwpR3t0ISz3HHPe3GmASzJLRi7DnTFRoKwUPi1KB45cFotJC0WJHjppbcA76zF7wg2qju+Y1CT6o6/9zmft70z0I16FOc4Z8PZmVLceKnL2c+/WPwY2EH3jF4LE9z7XlXYFWS4hneKPpv7a2bBIIPT6D3SKcvlKZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LgGUGj2Q; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6188b5ad4f0so2485881a12.0;
        Fri, 15 Aug 2025 03:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755253321; x=1755858121; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1YIaHosLVSZwNA729fs3/zikOyAwrs7RZ03+ETubjXs=;
        b=LgGUGj2QvUydQxFyX/sdDssSiySwQucA7frz6NSQ7RkJ+YtfXcI9fd5VuU1ez+1T5b
         k5+mbUddqKytXWsljiMdyYkWD6nBt7XO3Qxa3C1uYcfnCG529O/1C9tQKW8SJiEdpDGX
         MoJMs6aMbCg1l19c5deLzuf8KhxxPVyRhbMCE5ZflB8Yu2s7SF+M34mb7U5hfnd6OBz1
         EiRT38F4UWD9JKUU3B/7bg91VV6H/6r+J5zYd0oqJRj1NkgrWI3YkSFS2tUgygPMXsg/
         fzfoxEyb8RfwY4BWZQMFVAespQ7uwEsViqu38Ql2thjPYONnulY4BBSZlXFC0iFq5b3/
         mIYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755253321; x=1755858121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1YIaHosLVSZwNA729fs3/zikOyAwrs7RZ03+ETubjXs=;
        b=D2LQ1qo/jBM1LZ3oUX481lNfRv4Dz+jZ2TfCBsG2DZ2+FcaNO0qYLNkdNZ23ad0yz9
         f5SU8o0lFPyKUydu+cC7LLwSuii2daEAq1eYIrq+MfysFIejUIbl+3vH3l3ToXu/Qoov
         Wi2r+TEo7/nUBFsgSDRyb3yJqX0iLqXpR5YwMtxr1VSeyAKim5eGF/ng9+9Zxot9jug1
         bBmXPNpXJL4yRixq4jdGUnYjUiCegIy/ZCLqGEItu1UqNTfxHFkfmS0+7tjZplRWWNDR
         RY3YElzBVobrAKv01qPtuFHnFy5tks4fEHSFCdGr3d4W4N9jBLA60w7KsmOPLCJOiVQD
         VmvA==
X-Forwarded-Encrypted: i=1; AJvYcCWC/qScCa/Q2TbVrnD2iPVVOQxr9K9cYGdYFHqhR174OmijAhqHY6FhGmn4xwHOIcBtJdkBejy4XyfR@vger.kernel.org, AJvYcCXlMpW30pCRSpDtj6V92nPwv8YSsyliIx7DhL2HPurv7lJpV1KfrtBO8JiHANZeDpAen6eKHxCHjZR8U8kM@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/95mVjEZqjRwjIITzUZag4xrgECJ1QFpCjLMqQrK18NtClq7Y
	bjMxocwYX6Xn55V2ULhgR5nb3O6uS0j2jiMzWXDUHlt00ZU0Tg8oTuvGVsu7yTKYqwXoiIoNQFW
	Q7Qo0+ajrpwaltq/roEBV1NpOE8CqI08=
X-Gm-Gg: ASbGncu8rGVh3qwvMLvdqAUqmF51I3KAHBESN3u7W6zj+v4Nk0ShENLyysFcB7ek0yC
	DC3LDLI+2a/av+H84kEfu3mT7ks1lyCQW+pMwgiU3DSAIOXo2C3KLCHd9/abAgIuQhCV9MNDsOu
	s3tZa9poxRHia3Lj8HFfyqVHhptzoc6Icw25Gh3ZfzyOScteN3czfspzrcSRgc21W8a36nbCXmy
	P+KF7I=
X-Google-Smtp-Source: AGHT+IGscOv5sQgzgyYDsGNTWkOBbRIPLNfyQPtvtUsJytBjnXvgWh8SR3/OEKkxjyhtcvHE1TKDfU0MdfrPJBM5kqo=
X-Received: by 2002:a05:6402:3482:b0:615:a3c2:2e5d with SMTP id
 4fb4d7f45d1cf-618b055041cmr1180244a12.19.1755253320568; Fri, 15 Aug 2025
 03:22:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814235431.995876-1-tahbertschinger@gmail.com> <20250814235431.995876-2-tahbertschinger@gmail.com>
In-Reply-To: <20250814235431.995876-2-tahbertschinger@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 Aug 2025 12:21:49 +0200
X-Gm-Features: Ac12FXzjRZLT_kVCvvhHv19BzsOjHIxX7-ETgbnsJ2xsqrKbqFuRH4Nte-RMLNc
Message-ID: <CAOQ4uxhPMOoJEK_nVn-fyBX+TzE_EJBb8wmXPg2ZCWfyEA+utQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] fhandle: create helper for name_to_handle_at(2)
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 1:51=E2=80=AFAM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> Create a helper do_name_to_handle_at() that takes an additional argument,
> lookup_flags, beyond the syscall arguments.
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
> ---
>  fs/fhandle.c  | 61 ++++++++++++++++++++++++++++-----------------------
>  fs/internal.h |  7 ++++++
>  2 files changed, 41 insertions(+), 27 deletions(-)
>
> diff --git a/fs/fhandle.c b/fs/fhandle.c
> index 7c236f64cdea..57da648ca866 100644
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
> +long do_name_to_handle_at(int dfd, const char __user *name,
> +                         struct file_handle __user *handle, void __user =
*mnt_id,
> +                         int flag, int lookup_flags)
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
> +       return do_name_to_handle_at(dfd, name, handle, mnt_id, flag, 0);
> +}
> +
>  static int get_path_anchor(int fd, struct path *root)
>  {
>         if (fd >=3D 0) {
> diff --git a/fs/internal.h b/fs/internal.h
> index 38e8aab27bbd..af7e0810a90d 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -355,3 +355,10 @@ int anon_inode_getattr(struct mnt_idmap *idmap, cons=
t struct path *path,
>  int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>                        struct iattr *attr);
>  void pidfs_get_root(struct path *path);
> +
> +/*
> + * fs/fhandle.c
> + */
> +long do_name_to_handle_at(int dfd, const char __user *name,
> +                         struct file_handle __user *handle,
> +                         void __user *mnt_id, int flag, int lookup_flags=
);

I really dislike do_XXX() helpers because we use them interchangeably
sometimes to wrap vfs_XXX() helpers and sometimes the other way around,
so exporting them in the vfs internal interface is a very bad pattern IMO.

io_uring has a common pattern that requires a helper with all the syscall
args and for that purpose, it uses do_renameat2(), do_unlinkat(), ...

I would much rather that we stop this pattern and start with following
the do_sys_XXX() pattern as in the do_sys_ftruncate() helper.

Lucky for us, you just renamed the confusing helper named
do_sys_name_to_handle(), so you are free to reuse this name
(+ _at) in a non confusing placement.

Thanks,
Amir.

