Return-Path: <io-uring+bounces-9742-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 02189B53208
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 14:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1651B1C8703E
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 12:25:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C940320A2E;
	Thu, 11 Sep 2025 12:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g80IJVwg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B94D1B87E8;
	Thu, 11 Sep 2025 12:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757593486; cv=none; b=Z0t2RTA0crV3MGKog30MJbupo7zmx+4yINLQmkwSg8nA3fYsDO8XW9bGM80BW+QLCJFKmW8qusJ6iXLn5loQCbE2c5C2mrCoMBuvvOklS6jVFyyuuklRny+tOcVDyUfEYPSGcWC7JdO+nEDS+f4dH5EXlmc0W7aRJUTqOx5wpIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757593486; c=relaxed/simple;
	bh=JWt0Bhs8uUMnK1PhWYzFFCMMjH7iql/RLgt7aJDcvoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tAAy4oWPU6HKVPF82Z3+CWpgkBVWjbh+7eYutETUjQZWS8wJnTXU6LjqWS+HXXmV6MQVdmOD35nvVxoWofKPQi7yF5KJeLHADlmfYQVf3EkwhfFfNGJitl76E0kNBuTIQyXuEB1M6NVOi8L4tJ4lSLmr6+MhkuWLZ07SaAQE/lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g80IJVwg; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-623720201fdso1341788a12.1;
        Thu, 11 Sep 2025 05:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757593483; x=1758198283; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UMC5bwFzJvK/zMVuCm6c7/Edja8w9ACCTthG4IkGFxg=;
        b=g80IJVwgTdL4IQ3BwD6wviO7mlq9TRPuAV9WKskBKmsgHvu2m4OOilXWZXrtigM0KN
         MftJzfbkUthAdqRZatB3maOHS43GJMFKH9xt+he3HW1tGgO0jlKC3bWmDlG7fKR4xsTp
         Oyn7C5ODhaCmoWgat4kPGKd9oeQyJaLYM+QH65f6RbIvrG/iLp9X50c5R5pIcokPcG9E
         kyYgCj6ThZU3KzFl49Q4T4BWgyclhmLnXkdQmyiaIpZ4ENehR976cpC8q0H2fXyVXXU4
         QC0ahij29l7+/tMpl/ZgxJfH7/5naAlrVZBNWt8VCaWS/Mhfr5BctKpBrOa5NeLnGvrh
         81KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757593483; x=1758198283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UMC5bwFzJvK/zMVuCm6c7/Edja8w9ACCTthG4IkGFxg=;
        b=NYdBX3KrKDgQUs8g6B4ZmE4/cnoEX0FLfT1g9Sgqzuf7qXxoDJudarjVR3FshSjUrs
         YYPMqkUQm3JGlDFfqq2uakBv3ZStsQH0R8MUo2dHOviNVAfqVikwcS6HWXO8MUIkX853
         fiEtxguABta4MLsz0v8Gf8GZQrtKZqqBQZbh/UMDnW7SwE9vIJaTf4GmnD8wmNUUKrnr
         ByxdKi5yk8juK5p9vzkfV3EYrD3TJygnpi/IkZ+E6pLO8jGmhhcS9s5X0tQj3EMSKIPb
         DWkqCAzet+dyIlOqiYeB1IgwIpJ1uuUEZfd0npgn0QgubSFRrkVaHAF/h7tvBeSToi82
         Hreg==
X-Forwarded-Encrypted: i=1; AJvYcCVL+uu9JHdIt3zV26LDmX5imWaU99YqnvMtuWIcbIHITMzCKtVaZxmqUjc3OyTMSP1TEN4aOa1faNZ7@vger.kernel.org, AJvYcCVlq56OMLT04fvyriuu7zKhI8wabT02NggxfnCdBlcsGmat9zxl323icaf/Iu0+0/DRLDcdCTmgngFM7YkL@vger.kernel.org
X-Gm-Message-State: AOJu0YwwIb84B+Fn6dCk0o7tqBbCcmGsPhEg0aSSeJ7hM5OtdjcAFFOf
	ycSHMjnTdj07h2KhrJvNLt70IwDb56mug+0ic1YOOzmzW6Y8191C1TSayLmovteNyIx+wPjtPDJ
	DGKs0Ul3fJgsK8xqcowqu5gmBEK8IPeA=
X-Gm-Gg: ASbGnctcoS7DvxLOTuI5gTBQdv2oMgtzFz99EsI8y1K8SVhNXX0JkWa9grKq8v2ZYAD
	VFkZ0Y4530XdgENi6or3yf11Ofp6+E588gUCU9kqf9OSR4Rmo2tbItg8bOKZKkxav1vd7xRF/p5
	CFA6aUFTzh0+jqejIjbwroZFce6UxXxeKjxhbZvquf4xkDbhML3sM9UbwJTtkrlxYNRiPMIsXV9
	Um+5dg=
X-Google-Smtp-Source: AGHT+IHG7BuesvyuY4ECkulw+lTRlD8PcLFbA+5qkuLGUbkEKdkHNg/FkvlzoQ08sFiBZtvlNk1ZiafeU3Bjv7GEBuc=
X-Received: by 2002:a05:6402:2708:b0:628:410f:4978 with SMTP id
 4fb4d7f45d1cf-628f21a973amr12191342a12.31.1757593482425; Thu, 11 Sep 2025
 05:24:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910214927.480316-1-tahbertschinger@gmail.com> <20250910214927.480316-7-tahbertschinger@gmail.com>
In-Reply-To: <20250910214927.480316-7-tahbertschinger@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 Sep 2025 14:24:31 +0200
X-Gm-Features: AS18NWA9Tn2OWx34tQiiZh5R8o-gM7tJq3zVQuTO1uPrp_I7Rfd7my35NfEMwco
Message-ID: <CAOQ4uxj1F82biw+AYCDr2cuzyxEPtTythLvSVCCd3WB0tFM=MQ@mail.gmail.com>
Subject: Re: [PATCH 06/10] exportfs: allow VFS flags in struct file_handle
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org, 
	chuck.lever@oracle.com, jlayton@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025 at 11:47=E2=80=AFPM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> The handle_type field of struct file_handle is already being used to
> pass "user" flags to open_by_handle_at() in the upper 16 bits.
>
> Bits 8..15 are still unused, as FS implementations are expected to only
> set the lower 8 bits.
>
> This change prepares the VFS to pass flags to FS implementations of
> fh_to_{dentry,parent}() using the previously unused bits 8..15 of
> handle_type.
>
> The user is prevented from setting VFS flags in a file handle--such a
> handle will be rejected by open_by_handle_at(2). Only the VFS can set
> those flags before passing the handle to the FS.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/exportfs/expfs.c      |  2 +-
>  fs/fhandle.c             |  2 +-
>  include/linux/exportfs.h | 29 ++++++++++++++++++++++++++---
>  3 files changed, 28 insertions(+), 5 deletions(-)
>
> diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
> index d3e55de4a2a2..949ce6ef6c4e 100644
> --- a/fs/exportfs/expfs.c
> +++ b/fs/exportfs/expfs.c
> @@ -391,7 +391,7 @@ int exportfs_encode_inode_fh(struct inode *inode, str=
uct fid *fid,
>         else
>                 type =3D nop->encode_fh(inode, fid->raw, max_len, parent)=
;
>
> -       if (type > 0 && FILEID_USER_FLAGS(type)) {
> +       if (type > 0 && (type & ~FILEID_HANDLE_TYPE_MASK)) {
>                 pr_warn_once("%s: unexpected fh type value 0x%x from fsty=
pe %s.\n",
>                              __func__, type, inode->i_sb->s_type->name);
>                 return -EINVAL;
> diff --git a/fs/fhandle.c b/fs/fhandle.c
> index 01fc209853d8..276c16454eb7 100644
> --- a/fs/fhandle.c
> +++ b/fs/fhandle.c
> @@ -342,7 +342,7 @@ struct file_handle *get_user_handle(struct file_handl=
e __user *ufh)
>             (f_handle.handle_bytes =3D=3D 0))
>                 return ERR_PTR(-EINVAL);
>
> -       if (f_handle.handle_type < 0 ||
> +       if (f_handle.handle_type < 0 || FILEID_FS_FLAGS(f_handle.handle_t=
ype) ||
>             FILEID_USER_FLAGS(f_handle.handle_type) & ~FILEID_VALID_USER_=
FLAGS)
>                 return ERR_PTR(-EINVAL);
>
> diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
> index cfb0dd1ea49c..30a9791d88e0 100644
> --- a/include/linux/exportfs.h
> +++ b/include/linux/exportfs.h
> @@ -173,10 +173,33 @@ struct handle_to_path_ctx {
>  #define EXPORT_FH_DIR_ONLY     0x4 /* Only decode file handle for a dire=
ctory */
>
>  /*
> - * Filesystems use only lower 8 bits of file_handle type for fid_type.
> - * name_to_handle_at() uses upper 16 bits of type as user flags to be
> - * interpreted by open_by_handle_at().
> + * The 32 bits of the handle_type field of struct file_handle are used f=
or a few
> + * different purposes:
> + *
> + *   Filesystems use only lower 8 bits of file_handle type for fid_type.
> + *
> + *   VFS uses bits 8..15 of the handle_type to pass flags to the FS
> + *   implementation of fh_to_{dentry,parent}().
> + *
> + *   name_to_handle_at() uses upper 16 bits of type as user flags to be
> + *   interpreted by open_by_handle_at().
> + *
> + *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> + *  |           user flags          |   VFS flags   |   fid_type    |
> + *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> + *  (MSB)                                                       (LSB)
> + *
> + * Filesystems are expected not to fill in any bits outside of fid_type =
in
> + * their encode_fh() implementation.
>   */
> +#define FILEID_HANDLE_TYPE_MASK        0xff
> +#define FILEID_TYPE(type)      ((type) & FILEID_HANDLE_TYPE_MASK)
> +
> +/* VFS flags: */
> +#define FILEID_FS_FLAGS_MASK   0xff00
> +#define FILEID_FS_FLAGS(flags) ((flags) & FILEID_FS_FLAGS_MASK)
> +
> +/* User flags: */
>  #define FILEID_USER_FLAGS_MASK 0xffff0000
>  #define FILEID_USER_FLAGS(type) ((type) & FILEID_USER_FLAGS_MASK)
>
> --
> 2.51.0
>

