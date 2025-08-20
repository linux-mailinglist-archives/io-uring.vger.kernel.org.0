Return-Path: <io-uring+bounces-9093-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8538FB2D69C
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 10:35:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D06985A4C27
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 08:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1D9A231826;
	Wed, 20 Aug 2025 08:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D0BUyuAS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06C126E70B;
	Wed, 20 Aug 2025 08:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755678893; cv=none; b=jHN24aBRmfLd0LmzqRRn7U5/55+hwAjlEptfZon1P7HD3zlm+QCXEg1bC/RB7HoSOUMK05lyuac4f7BsTm08PZDObriEJ/1ZAarOh98emM+vdnkEuUrrxpOyEGKNIqQ0DpPnAQwaWWwJMuZ8Pf4K+iLrj3ZDzQTqFxmZ9FtNBi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755678893; c=relaxed/simple;
	bh=CJJv4rjIsH/rANKFddXWp2JgagQ9EV0G62jhTdBfNqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WEJUQFT0qPZoMdC1WWPRNRwTGeU7GcmjUMr2b1S0wZxZ+IJJrdnQxo/TzpVcS4n+XpMdLf/yZMCg54udc4vsTAQiAPBoE5jvt2J21B8U3hSFX0XOMUYVu7cylwcCvx/G5m1ZBHNz2vks2tZMPrqRky/jLpgym+v4GkLpS012lK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D0BUyuAS; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6188b5b11b2so7648592a12.0;
        Wed, 20 Aug 2025 01:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755678890; x=1756283690; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQGNfd7swWSngpFSEQ79BVLX8C34WWL1H/j3aeA6PsM=;
        b=D0BUyuASuX6THBGNsoHqJWDk3OGeT2/OZqSthdFRe9iOALp3gz5X81+lMTmCys5VpM
         j3wj4QcUW8DB9QdnmprvMYThhVL4BygVTrYU3VxvRNijfAiWF90JOYGpX05VMgBI2smb
         x95e6bDXfnZQiYH/4OzNQ68jjI+R3IWsSxcwhwaHCvPaopXdY3F7Kq2n1FqAinpGr02H
         lVIfgvdEMsjimbYt8nDNlGI8nAbCNQr8/LeSOTeyCzShbsz615zX9bcHiP3YA7dJHFkh
         fpnk1rdnKf7d61O/0pbAZzlJafGX4h9Bne7u1zvwA3Jwxn141VQgva65dZ3KseR+SGk5
         /EXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755678890; x=1756283690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KQGNfd7swWSngpFSEQ79BVLX8C34WWL1H/j3aeA6PsM=;
        b=WcwESilEhT58JKaFoN2qNLXRvxRz1+HNjdjCZIiG+yQ5zfh+FgffAoyZS89KyqD67+
         NfqeXFgslfH4+zDxLtfMxpKYtix05WhCopBEGvgnrBWQi4xv6RENS35/tNhGAC95etGK
         z9t17tvXEwSmmfST1eLODPbo7qqIP0wJqhy5gTVI9sGSaVNiBmezGUrIHx6OmjgeG8Yn
         uDJZYKBBj82JpIj7M4ScTkCf+5Du9U11jkw8KqpXIHrseFHO+I0zLM0BoCWX2kqcvzcv
         noD0yIjFvlrlAvQDtWVzW5ymXVD7Z/3VPmUf3+oYxXbmBmdCjSsQJesPvagwsPIain/a
         TeTg==
X-Forwarded-Encrypted: i=1; AJvYcCUJPMI/USX9Sn8LY9eeGDMKKGMemaXvT1h5VMEFDkdl0Ghe1rt1v8XLhNLXfzPkpKv38TARudtD71fm@vger.kernel.org, AJvYcCUYi/IWHo12g4mKasPfryH9CAsNrGN48gvshcvG11mVq8s3IN9HPBtld1h36MVFBcXXFMJ9+roK9Q==@vger.kernel.org, AJvYcCUyuzQYlcBVP4cibEBvoOF7l7y3AEN9jk0Bz6nTh15eJH3aZjzb6xgvvJJ1zFnDJVSufyStmhcHXa6TdOMMmQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwS35qVWLVNZnVB04lff8wMdNnNPxPNefMucg+SF8FGm84vJtU3
	orGiflpSDZpcIpq/CT+ZbKmU481rgIXeWt5oS213fOz+3v0efm2xTY/MG5XGPiqjCoFEBwsa6/k
	9gt00A5TEq/kKl13yHKPEXWR75rkjLk0=
X-Gm-Gg: ASbGncttySuh5+GvgCP/Bd77X7uHaZ3OijeySmm+3WFtnxQQWVcJAb0Gv02Ve1yx7aL
	e3Xo97LBZWxjvtWGdqtDwov3RrSB2xhaX9NRyDfXzN8tXrWT8Wgfsuoat73Z8jO+qsHTrM9ZuiP
	HzCP2f5yidhyJIK5ks+dY15dsQtZW10aMda/YHVnP3Pkax49zbI8qoo/oqTWbg6I8K3sqgnNB+K
	xV4VB8=
X-Google-Smtp-Source: AGHT+IHnf8Q6BCvIt2URpWEl6mG4Vjxz0cJBTiEGNqC2tvy97ktjMRqYfeDDF4q+M2pPHGoZQYadQ1MyuKCzMpJUyks=
X-Received: by 2002:a05:6402:5113:b0:617:b2ab:fba2 with SMTP id
 4fb4d7f45d1cf-61a97852204mr1874328a12.34.1755678889773; Wed, 20 Aug 2025
 01:34:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
 <e914d653-a1b6-477d-8afa-0680a703d68f@kernel.dk> <DC6X58YNOC3F.BPB6J0245QTL@gmail.com>
In-Reply-To: <DC6X58YNOC3F.BPB6J0245QTL@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 20 Aug 2025 10:34:38 +0200
X-Gm-Features: Ac12FXzyfXpVAf1OB76uvO0fIkwnVLWIoIsF_XcMgEN_2816qzzulWSYj8SX_kY
Message-ID: <CAOQ4uxj=XOFqHBmYY1aBFAnJtSkxzSyPu5G3xP1rx=ZfPfe-kg@mail.gmail.com>
Subject: Re: [PATCHSET RFC 0/6] add support for name_to, open_by_handle_at(2)
 to io_uring
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 4:57=E2=80=AFAM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> On Tue Aug 19, 2025 at 9:11 AM MDT, Jens Axboe wrote:
> > I'll take a look at this, but wanted to mention that I dabbled in this
> > too a while ago, here's what I had:
> >
> > https://git.kernel.dk/cgit/linux/log/?h=3Dio_uring-handle
>
> Thanks! That is helpful. Right away I see something you included that I
> missed: requiring CONFIG_FHANDLE. Missing that would explain the build
> failure emails I got on this series.
>
> I'll include that in v2, when I get around to that--hopefully soon.
>
> >
> > Probably pretty incomplete, but I did try and handle some of the
> > cases that won't block to avoid spurious -EAGAIN and io-wq usage.
>
> So for the non-blocking case, what I am concerned about is code paths
> like this:
>
> do_handle_to_path()
>   -> exportfs_decode_fh_raw()
>     -> fh_to_dentry()
>       -> xfs_fs_fh_to_dentry()
>         ... -> xfs_iget()
>       OR
>       -> ext4_fh_to_dentry()
>         ... -> ext4_iget()
>
> Where there doesn't seem to be any existing way to tell the FS
> implementation to give up and return -EAGAIN when appropriate. I wasn't
> sure how to do that without modifying the signature of fh_to_dentry()
> (and fh_to_parent()) which seems awfully invasive for this.
>
> (Using a flag in task_struct to signify "don't block" was previously
> discussed:
> https://lore.kernel.org/io-uring/22630618-40fc-5668-078d-6cefcb2e4962@ker=
nel.dk/
> and that could allow not needing to pass a flag via function argument,
> but I agree with the conclusion in that email chain that it's an ugly
> solution.)
>
> Any thoughts on that? This seemed to me like there wasn't an obvious
> easy solution, hence why I just didn't attempt it at all in v1.
> Maybe I'm missing something, though.
>

Since FILEID_IS_CONNECTABLE, we started using the high 16 bits of
fh_type for FILEID_USER_FLAGS, since fs is not likely expecting a fh_type
beyond 0xff (Documentation/filesystems/nfs/exporting.rst):
"A filehandle fragment consists of an array of 1 or more 4byte words,
together with a one byte "type"."

The name FILEID_USER_FLAGS may be a bit misleading - it was
never the intention for users to manipulate those flags, although they
certainly can and there is no real harm in that.

These flags are used in the syscall interface only, but
->fh_to_{dentry,parent}() function signature also take an int fh_flags
argument, so we can use that to express the non-blocking request.

Untested patch follows (easier than explaining):


diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index d3e55de4a2a2a..a46c97af4dfb1 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -391,7 +391,7 @@ int exportfs_encode_inode_fh(struct inode *inode,
struct fid *fid,
        else
                type =3D nop->encode_fh(inode, fid->raw, max_len, parent);

-       if (type > 0 && FILEID_USER_FLAGS(type)) {
+       if (type > 0 && type & ~FILEID_HANDLE_TYPE_MASK) {
                pr_warn_once("%s: unexpected fh type value 0x%x from
fstype %s.\n",
                             __func__, type, inode->i_sb->s_type->name);
                return -EINVAL;
@@ -443,9 +443,12 @@ exportfs_decode_fh_raw(struct vfsmount *mnt,
struct fid *fid, int fh_len,
        const struct export_operations *nop =3D mnt->mnt_sb->s_export_op;
        struct dentry *result, *alias;
        char nbuf[NAME_MAX+1];
+       int fh_type =3D fileid_type | FILEID_FS_FLAGS(flags);
        int err;

-       if (fileid_type < 0 || FILEID_USER_FLAGS(fileid_type))
+       BUILD_BUG_ON(FILEID_HANDLE_TYPE_MASK & FILEID_FS_FLAGS_MASK);
+       BUILD_BUG_ON(FILEID_USER_FLAGS_MASK & FILEID_FS_FLAGS_MASK);
+       if (fileid_type < 0 || fileid_type & ~FILEID_HANDLE_TYPE_MASK)
                return ERR_PTR(-EINVAL);

        /*
@@ -453,7 +456,7 @@ exportfs_decode_fh_raw(struct vfsmount *mnt,
struct fid *fid, int fh_len,
         */
        if (!exportfs_can_decode_fh(nop))
                return ERR_PTR(-ESTALE);
-       result =3D nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fileid_type)=
;
+       result =3D nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fh_type);
        if (IS_ERR_OR_NULL(result))
                return result;

@@ -481,6 +484,10 @@ exportfs_decode_fh_raw(struct vfsmount *mnt,
struct fid *fid, int fh_len,
                 * filesystem root.
                 */
                if (result->d_flags & DCACHE_DISCONNECTED) {
+                       err =3D -EAGAIN;
+                       if (flags & EXPORT_FH_CACHED)
+                               goto err_result;
+
                        err =3D reconnect_path(mnt, result, nbuf);
                        if (err)
                                goto err_result;
@@ -511,6 +518,10 @@ exportfs_decode_fh_raw(struct vfsmount *mnt,
struct fid *fid, int fh_len,
                if (alias)
                        return alias;

+               err =3D -EAGAIN;
+               if (flags & EXPORT_FH_CACHED)
+                       goto err_result;
+
                /*
                 * Try to extract a dentry for the parent directory from th=
e
                 * file handle.  If this fails we'll have to give up.
diff --git a/fs/fhandle.c b/fs/fhandle.c
index 7c236f64cdeac..228512424ad65 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -339,7 +339,7 @@ static int handle_to_path(int mountdirfd, struct
file_handle __user *ufh,
            (f_handle.handle_bytes =3D=3D 0))
                return -EINVAL;

-       if (f_handle.handle_type < 0 ||
+       if (f_handle.handle_type < 0 || FILEID_FS_FLAGS(f_handle.handle_typ=
e) ||
            FILEID_USER_FLAGS(f_handle.handle_type) & ~FILEID_VALID_USER_FL=
AGS)
                return -EINVAL;

@@ -382,7 +382,10 @@ static int handle_to_path(int mountdirfd, struct
file_handle __user *ufh,
        if (f_handle.handle_type & FILEID_IS_DIR)
                ctx.fh_flags |=3D EXPORT_FH_DIR_ONLY;
        /* Filesystem code should not be exposed to user flags */
-       handle->handle_type &=3D ~FILEID_USER_FLAGS_MASK;
+       BUILD_BUG_ON(FILEID_HANDLE_TYPE_MASK & FILEID_USER_FLAGS_MASK);
+       handle->handle_type &=3D ~FILEID_HANDLE_TYPE_MASK;
+       if (o_flags & O_NONBLOCK)
+               ctx.fh_flags |=3D EXPORT_FH_CACHED;
        retval =3D do_handle_to_path(handle, path, &ctx);

 out_path:
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index cfb0dd1ea49c7..331d28093b568 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -174,6 +174,18 @@ struct handle_to_path_ctx {

 /*
  * Filesystems use only lower 8 bits of file_handle type for fid_type.
+ */
+#define FILEID_HANDLE_TYPE_MASK        0xff
+
+/*
+ * vfs uses bits 8..15 of @fh_type arg of fh_to_dentry/fh_to_parent method=
s
+ * as misc. flags to pass to filesystems.
+ */
+#define EXPORT_FH_CACHED       0x100 /* Non-blocking encode/decode */
+#define FILEID_FS_FLAGS_MASK   0xff00
+#define FILEID_FS_FLAGS(flags) ((flags) & FILEID_FS_FLAGS_MASK)
+
+/*
  * name_to_handle_at() uses upper 16 bits of type as user flags to be
  * interpreted by open_by_handle_at().
  */

Thanks,
Amir.

