Return-Path: <io-uring+bounces-9740-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47854B531E2
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 14:16:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC53B3A94ED
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 12:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BC87320382;
	Thu, 11 Sep 2025 12:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i4ReBOQ0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18375320CA4
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 12:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757592967; cv=none; b=tCOQinSH+YANmSYlTcZQLGFr8Tg+gipkGhaZ+Dmq5cfCw31eLQDH/5T6hXfpf5q4vK9iPqTLDXGvRJtiVTJsdxm9PcAOGjMSOVjztRSXxqYL4nnAyx9hWjI7B+Pc0pjRnkvEFUQzjwZFVmBsW6plDa2CVOfw0rQDdmG28YxfySg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757592967; c=relaxed/simple;
	bh=JUpYwnClt38SjC34E6edjWshBcshGQPJ5TCZ0Eyt0I0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nVZnXcEhBxfQDhHr0rD18Ke7Qmzyh39uY056XWP/2h+xr3q9g+NGizKrBzDvufNaj/SjLr5qgLz+4pGSZqjlOUZ4kC33VNs6nt5q8dwJlMqbs/s36VI5gJs3wFiVDP9N77IVDBzd6RwQvj77wqIVREuyWyv8FeyTVpETF5WpeAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i4ReBOQ0; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6228de280ccso1385941a12.3
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 05:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757592963; x=1758197763; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hmPBcWTObj50LhXYM1I5KZNh6dnED3MFUByLrKPPsww=;
        b=i4ReBOQ08D7T772beYG9bsDvfxozmdGqIizYFywUNTibOJNMd4FBEbbC6W2Bqd9kt5
         ooKDxStyMY0PeyXd+XKLiTfTswCsz47Vw3HIISgU8Cg7hN0z3JoOnjE5kaNvkam64IWL
         GL7KyAaoB/sWGowMf7IB9ED3L5loVmIQs1ob5qZqzvgKLTs8v9i1S5N112+WEti60Ze5
         oQZlhN4BWKF53rx/YJqQAuc22V5m51b1aE2Qt8yXVgcuO458IIU6YY6tlH+BVlIp4evW
         i/CqU+xqSwpy9mgeuF3DIQf9ymC2GU06YQg0MwwBgklGDI3u3VV+ybwoK1lJKGDaytoO
         aapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757592963; x=1758197763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hmPBcWTObj50LhXYM1I5KZNh6dnED3MFUByLrKPPsww=;
        b=JkyaOF/qRLSWsTbTPI19HV/AtdBlXBBl/DpvqvUatwQfsoVddIedHCqdcdIrzie7Nj
         rkfvuEoS/r7SQF8vv04Km2QTBF9BEDx4XDFGiWBgvtZSet5ACZKF83+I49WeAFyNBU50
         KYhBIuNsBsgwYI+65iBa2UbuNkFUzUJGxjKVt7ts4P7y3hEn+DZH75wjHpRB/RNBJndS
         3drMh00QEGVbKNjztJpZarCn0cuPJy01sJy/6AxSjqdDRhaWLy+kidTu1ejgd+gBqWNe
         V6vAViB9SJqgFEaGrVk8xCeD3TIUfFRO/4G84eAAQOGGejB7gVVrmVHR4bjEZcilXlia
         wzsQ==
X-Gm-Message-State: AOJu0YwnDKvNZhzhroT7g9FdunuT+Zcp3awVVHLNN6NCRpZl6RUtxM03
	zu1ZEWU0YH7SnDIl8W9jxHB0Prj7ESvq7mTt9P1d/hugZdKfExQwvu6Aa/oalIFyR0jY5Cjpcuk
	2jfmqMKvy5W+vZ8p6orXTHXPLHX6K6+w=
X-Gm-Gg: ASbGncsLGu3hwpptfMnNAuSySygxTPPZe0v3HPRqt2VC6HZtN7kcMzpOcBDNFvORn+9
	KFigxbiLy6xSMecJNe6PfhqyiecD6vZwYNuubc4VEdvYGAfDFm8gqzr3BKHl/Gs8jegkb8u31hE
	UXVcAD7CYsMSf+AEr7K3XJOUnMhgvMPvlToY4QcvqlvQOKCHL1vcNEK0Mb3Zcb/n18lbtTfrS8B
	dD8/mymAWFjgbEWlA==
X-Google-Smtp-Source: AGHT+IH7awg+/3rQKI0A5I+og5+M+CvuxyPUITL9rerUxhq2gVDrUHNMQ5fr4up+/Au7lWL3bnr+hbuailmMlx+CkKE=
X-Received: by 2002:a05:6402:274d:b0:628:f0c1:d711 with SMTP id
 4fb4d7f45d1cf-628f0c1d78amr12276828a12.30.1757592963327; Thu, 11 Sep 2025
 05:16:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910214927.480316-1-tahbertschinger@gmail.com> <20250910214927.480316-4-tahbertschinger@gmail.com>
In-Reply-To: <20250910214927.480316-4-tahbertschinger@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 Sep 2025 14:15:52 +0200
X-Gm-Features: AS18NWD_kI_hQbdQVU0TIOUGXScDePOgT214upJqMBIKSZWcO-wvs36BjpfETcE
Message-ID: <CAOQ4uxhkU80A75PVB7bsXs2BGhGqKv0vr8RvLb5TnEiMO__pmw@mail.gmail.com>
Subject: Re: [PATCH 03/10] fhandle: helper for allocating, reading struct file_handle
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025 at 11:47=E2=80=AFPM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> Pull the code for allocating and copying a struct file_handle from
> userspace into a helper function get_user_handle() just for this.
>
> do_handle_open() is updated to call get_user_handle() prior to calling
> handle_to_path(), and the latter now takes a kernel pointer as a
> parameter instead of a __user pointer.
>
> This new helper, as well as handle_to_path(), are also exposed in
> fs/internal.h. In a subsequent commit, io_uring will use these helpers
> to support open_by_handle_at(2) in io_uring.
>
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> ---
>  fs/fhandle.c  | 64 +++++++++++++++++++++++++++++----------------------
>  fs/internal.h |  3 +++
>  2 files changed, 40 insertions(+), 27 deletions(-)
>
> diff --git a/fs/fhandle.c b/fs/fhandle.c
> index 605ad8e7d93d..36e194dd4cb6 100644
> --- a/fs/fhandle.c
> +++ b/fs/fhandle.c
> @@ -330,25 +330,45 @@ static inline int may_decode_fh(struct handle_to_pa=
th_ctx *ctx,
>         return 0;
>  }
>
> -static int handle_to_path(int mountdirfd, struct file_handle __user *ufh=
,
> -                  struct path *path, unsigned int o_flags)
> +struct file_handle *get_user_handle(struct file_handle __user *ufh)
>  {
> -       int retval =3D 0;
>         struct file_handle f_handle;
> -       struct file_handle *handle __free(kfree) =3D NULL;
> -       struct handle_to_path_ctx ctx =3D {};
> -       const struct export_operations *eops;
> +       struct file_handle *handle;
>
>         if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle)))
> -               return -EFAULT;
> +               return ERR_PTR(-EFAULT);
>
>         if ((f_handle.handle_bytes > MAX_HANDLE_SZ) ||
>             (f_handle.handle_bytes =3D=3D 0))
> -               return -EINVAL;
> +               return ERR_PTR(-EINVAL);
>
>         if (f_handle.handle_type < 0 ||
>             FILEID_USER_FLAGS(f_handle.handle_type) & ~FILEID_VALID_USER_=
FLAGS)
> -               return -EINVAL;
> +               return ERR_PTR(-EINVAL);
> +
> +       handle =3D kmalloc(struct_size(handle, f_handle, f_handle.handle_=
bytes),
> +                        GFP_KERNEL);
> +       if (!handle) {
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       /* copy the full handle */
> +       *handle =3D f_handle;
> +       if (copy_from_user(&handle->f_handle,
> +                          &ufh->f_handle,
> +                          f_handle.handle_bytes)) {
> +               return ERR_PTR(-EFAULT);
> +       }
> +
> +       return handle;
> +}
> +
> +int handle_to_path(int mountdirfd, struct file_handle *handle,
> +                  struct path *path, unsigned int o_flags)
> +{
> +       int retval =3D 0;
> +       struct handle_to_path_ctx ctx =3D {};
> +       const struct export_operations *eops;
>
>         retval =3D get_path_anchor(mountdirfd, &ctx.root);
>         if (retval)
> @@ -362,31 +382,16 @@ static int handle_to_path(int mountdirfd, struct fi=
le_handle __user *ufh,
>         if (retval)
>                 goto out_path;
>
> -       handle =3D kmalloc(struct_size(handle, f_handle, f_handle.handle_=
bytes),
> -                        GFP_KERNEL);
> -       if (!handle) {
> -               retval =3D -ENOMEM;
> -               goto out_path;
> -       }
> -       /* copy the full handle */
> -       *handle =3D f_handle;
> -       if (copy_from_user(&handle->f_handle,
> -                          &ufh->f_handle,
> -                          f_handle.handle_bytes)) {
> -               retval =3D -EFAULT;
> -               goto out_path;
> -       }
> -
>         /*
>          * If handle was encoded with AT_HANDLE_CONNECTABLE, verify that =
we
>          * are decoding an fd with connected path, which is accessible fr=
om
>          * the mount fd path.
>          */
> -       if (f_handle.handle_type & FILEID_IS_CONNECTABLE) {
> +       if (handle->handle_type & FILEID_IS_CONNECTABLE) {
>                 ctx.fh_flags |=3D EXPORT_FH_CONNECTABLE;
>                 ctx.flags |=3D HANDLE_CHECK_SUBTREE;
>         }
> -       if (f_handle.handle_type & FILEID_IS_DIR)
> +       if (handle->handle_type & FILEID_IS_DIR)
>                 ctx.fh_flags |=3D EXPORT_FH_DIR_ONLY;
>         /* Filesystem code should not be exposed to user flags */
>         handle->handle_type &=3D ~FILEID_USER_FLAGS_MASK;
> @@ -400,12 +405,17 @@ static int handle_to_path(int mountdirfd, struct fi=
le_handle __user *ufh,
>  static long do_handle_open(int mountdirfd, struct file_handle __user *uf=
h,
>                            int open_flag)
>  {
> +       struct file_handle *handle __free(kfree) =3D NULL;
>         long retval =3D 0;
>         struct path path __free(path_put) =3D {};
>         struct file *file;
>         const struct export_operations *eops;
>
> -       retval =3D handle_to_path(mountdirfd, ufh, &path, open_flag);
> +       handle =3D get_user_handle(ufh);
> +       if (IS_ERR(handle))
> +               return PTR_ERR(handle);

I don't think you can use __free(kfree) for something that can be an ERR_PT=
R.

Thanks,
Amir.

