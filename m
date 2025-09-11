Return-Path: <io-uring+bounces-9754-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 795F2B53859
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 17:55:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF4D0A017F8
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 15:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A0B93431F1;
	Thu, 11 Sep 2025 15:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ihkw953S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FF2352072
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757606075; cv=none; b=PbpLVstcrHYLm8Wh2Ottby9x+UA11ngEtUFft3PnlmjocZSmyfB1+6XtqfaAhk/W4lXM8IREeNn3ZiY9tHvg4bJgbmABmrCgPisQvv9cstKuiOzSeulaq1s/QOrRHVKA7Xa8+e0JEIB+0jfQpzp09oCXSVCFOZaXuirZYAJpGUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757606075; c=relaxed/simple;
	bh=N6KUVeAYlqCnQ6iBRMc8GsEzZCQ252qPvughTl4WJwc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iOmKaAfVTuj6VTBbBZBwUypHFjphxeVLZpEx3LuIvvABrtcR8X6s5bgnTqqkmNiJwNa0xdqPWXfcZMJBsdj9yx/fvEE8qnfZs2230n1DEtmQDZ9bR8ceF6LlSRbPyxruK3ubx3ov7LeE2p26dcUAnW4pD2mqITKW+XuTx9AHEdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ihkw953S; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b042eb09948so191760266b.3
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 08:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757606071; x=1758210871; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WkqFoXRVAdDE9iMlbog/yo4QKx4apSNAOb6E1ZAEaj0=;
        b=ihkw953Sy52WgLe7B7ReXLwuglgw7EBzY9dwEopvKGXJDCsdTseZRJiq9MAVbIHsm8
         +hgC+WbU877h8jkDZIpLBbsmORODQw+F2vRrpIr2Pjet5M0Fx1M4jvxt9J9OdMD3jQ/Y
         rjhjsfBM/nqFK6MiL7pNTXREVPyj4EK2SbbUlgB5+ftrf0Ht0X0374aXWZlVO79raic7
         c5wMJvmtMHC7ndz+QF+fFvFQI8UJxK7PYifMfHb2s7xpy0de3eYpdGyNecTlPbkprycq
         tFiBzDqrDduKu3c7KYj9JHDks2gkSOsX0PTNaZqojvay965uw/n3Vq9160iR8WV2gRcZ
         o7Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757606071; x=1758210871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WkqFoXRVAdDE9iMlbog/yo4QKx4apSNAOb6E1ZAEaj0=;
        b=fsMmtjzsiJUU6iSDdRk+q7LCci/jd/ev1tAigS2gdshcnNByMwDIlulozm24TagWjx
         JLrbyfSKYc1Sc6EGLrdn76xAPRdQn1345iGNHWUgmBadRp5obkp1hpPeXez1Jjs2Lfu1
         X+IZ2IaOgejRW7AHU4sg9N3qr5F20yUsF4lOwJ/i8defcaX314DzqOqg28wRyGfGTmKA
         LUyhb42vAa1a8C+eQ2TALNH2tvtzxXzITCO4mEGY8nZ0B1DLhu4/hLjRORw/y2bpKtdf
         x0IMPWbpDEq3KZBNBTLMrq0ntkGdRr94CUchgfczMvab+fX5ChKje65k9+duXhUHaoyb
         +KJg==
X-Gm-Message-State: AOJu0Yx8hSsCrdqRFy1gnHD1v9ESSJU/o+cJAnFFSpo7fu2+31+Wchqe
	+o5amVAdX+RK/gaMoZUgItaE4wLbnqTE2RZVbq+WO6yAaiOxfw5H/Xhlo5yzK7quvb03w75mLCJ
	qn3Qy1wTZg/3xGN2XEvUol5YknLwHoOQ=
X-Gm-Gg: ASbGncsgRbJ0WV0eaKWnAgIUA3zvzMI3IYg6kdcHztvYOGBFF0j72KmpG6GePWT6Q2V
	R99wRCQN7xpaEWsBwJsJClF2I0CxiKkQ6Cj61gMz8MWXOYg34fWJHZ6IyQyt9mG2eRyENyNmXvv
	H96wuuGwtaOKv8CI/DZ1zWN6XpCwtWPOi1hVrtPH08brqSPReckC8DgfRcirtBUicSuK51/edqQ
	0ucJuY=
X-Google-Smtp-Source: AGHT+IFeDzO/UlXZsLPQ3nN/k/PZZgm9LBpW7vo72PhZEuvoWBzlvdz37LXf7rjvckeodtKdJgyArTaBeqMTcNZOSgM=
X-Received: by 2002:a17:907:9483:b0:b04:4786:5dfc with SMTP id
 a640c23a62f3a-b04b14aec52mr2283271566b.27.1757606070566; Thu, 11 Sep 2025
 08:54:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910214927.480316-1-tahbertschinger@gmail.com>
 <20250910214927.480316-4-tahbertschinger@gmail.com> <CAOQ4uxhkU80A75PVB7bsXs2BGhGqKv0vr8RvLb5TnEiMO__pmw@mail.gmail.com>
 <DCQ2V7HPAAPL.1OIBUT89HV16S@gmail.com>
In-Reply-To: <DCQ2V7HPAAPL.1OIBUT89HV16S@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 Sep 2025 17:54:18 +0200
X-Gm-Features: Ac12FXzd-RY7w0Ujox948kT-K1TwvOHhxN_T-smjh3uSYBwO4MDC1q26EJTyW6M
Message-ID: <CAOQ4uxiCAbHGusCYdQ0iRvb35O4CLKJQsWp5C04+Hp0+Q8O2zw@mail.gmail.com>
Subject: Re: [PATCH 03/10] fhandle: helper for allocating, reading struct file_handle
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 5:26=E2=80=AFPM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> On Thu Sep 11, 2025 at 6:15 AM MDT, Amir Goldstein wrote:
> > On Wed, Sep 10, 2025 at 11:47=E2=80=AFPM Thomas Bertschinger
> > <tahbertschinger@gmail.com> wrote:
> >>
> >> Pull the code for allocating and copying a struct file_handle from
> >> userspace into a helper function get_user_handle() just for this.
> >>
> >> do_handle_open() is updated to call get_user_handle() prior to calling
> >> handle_to_path(), and the latter now takes a kernel pointer as a
> >> parameter instead of a __user pointer.
> >>
> >> This new helper, as well as handle_to_path(), are also exposed in
> >> fs/internal.h. In a subsequent commit, io_uring will use these helpers
> >> to support open_by_handle_at(2) in io_uring.
> >>
> >> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> >> ---
> >>  fs/fhandle.c  | 64 +++++++++++++++++++++++++++++---------------------=
-
> >>  fs/internal.h |  3 +++
> >>  2 files changed, 40 insertions(+), 27 deletions(-)
> >>
> >> diff --git a/fs/fhandle.c b/fs/fhandle.c
> >> index 605ad8e7d93d..36e194dd4cb6 100644
> >> --- a/fs/fhandle.c
> >> +++ b/fs/fhandle.c
> >> @@ -330,25 +330,45 @@ static inline int may_decode_fh(struct handle_to=
_path_ctx *ctx,
> >>         return 0;
> >>  }
> >>
> >> -static int handle_to_path(int mountdirfd, struct file_handle __user *=
ufh,
> >> -                  struct path *path, unsigned int o_flags)
> >> +struct file_handle *get_user_handle(struct file_handle __user *ufh)
> >>  {
> >> -       int retval =3D 0;
> >>         struct file_handle f_handle;
> >> -       struct file_handle *handle __free(kfree) =3D NULL;
> >> -       struct handle_to_path_ctx ctx =3D {};
> >> -       const struct export_operations *eops;
> >> +       struct file_handle *handle;
> >>
> >>         if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle))=
)
> >> -               return -EFAULT;
> >> +               return ERR_PTR(-EFAULT);
> >>
> >>         if ((f_handle.handle_bytes > MAX_HANDLE_SZ) ||
> >>             (f_handle.handle_bytes =3D=3D 0))
> >> -               return -EINVAL;
> >> +               return ERR_PTR(-EINVAL);
> >>
> >>         if (f_handle.handle_type < 0 ||
> >>             FILEID_USER_FLAGS(f_handle.handle_type) & ~FILEID_VALID_US=
ER_FLAGS)
> >> -               return -EINVAL;
> >> +               return ERR_PTR(-EINVAL);
> >> +
> >> +       handle =3D kmalloc(struct_size(handle, f_handle, f_handle.hand=
le_bytes),
> >> +                        GFP_KERNEL);
> >> +       if (!handle) {
> >> +               return ERR_PTR(-ENOMEM);
> >> +       }
> >> +
> >> +       /* copy the full handle */
> >> +       *handle =3D f_handle;
> >> +       if (copy_from_user(&handle->f_handle,
> >> +                          &ufh->f_handle,
> >> +                          f_handle.handle_bytes)) {
> >> +               return ERR_PTR(-EFAULT);
> >> +       }
> >> +
> >> +       return handle;
> >> +}
> >> +
> >> +int handle_to_path(int mountdirfd, struct file_handle *handle,
> >> +                  struct path *path, unsigned int o_flags)
> >> +{
> >> +       int retval =3D 0;
> >> +       struct handle_to_path_ctx ctx =3D {};
> >> +       const struct export_operations *eops;
> >>
> >>         retval =3D get_path_anchor(mountdirfd, &ctx.root);
> >>         if (retval)
> >> @@ -362,31 +382,16 @@ static int handle_to_path(int mountdirfd, struct=
 file_handle __user *ufh,
> >>         if (retval)
> >>                 goto out_path;
> >>
> >> -       handle =3D kmalloc(struct_size(handle, f_handle, f_handle.hand=
le_bytes),
> >> -                        GFP_KERNEL);
> >> -       if (!handle) {
> >> -               retval =3D -ENOMEM;
> >> -               goto out_path;
> >> -       }
> >> -       /* copy the full handle */
> >> -       *handle =3D f_handle;
> >> -       if (copy_from_user(&handle->f_handle,
> >> -                          &ufh->f_handle,
> >> -                          f_handle.handle_bytes)) {
> >> -               retval =3D -EFAULT;
> >> -               goto out_path;
> >> -       }
> >> -
> >>         /*
> >>          * If handle was encoded with AT_HANDLE_CONNECTABLE, verify th=
at we
> >>          * are decoding an fd with connected path, which is accessible=
 from
> >>          * the mount fd path.
> >>          */
> >> -       if (f_handle.handle_type & FILEID_IS_CONNECTABLE) {
> >> +       if (handle->handle_type & FILEID_IS_CONNECTABLE) {
> >>                 ctx.fh_flags |=3D EXPORT_FH_CONNECTABLE;
> >>                 ctx.flags |=3D HANDLE_CHECK_SUBTREE;
> >>         }
> >> -       if (f_handle.handle_type & FILEID_IS_DIR)
> >> +       if (handle->handle_type & FILEID_IS_DIR)
> >>                 ctx.fh_flags |=3D EXPORT_FH_DIR_ONLY;
> >>         /* Filesystem code should not be exposed to user flags */
> >>         handle->handle_type &=3D ~FILEID_USER_FLAGS_MASK;
> >> @@ -400,12 +405,17 @@ static int handle_to_path(int mountdirfd, struct=
 file_handle __user *ufh,
> >>  static long do_handle_open(int mountdirfd, struct file_handle __user =
*ufh,
> >>                            int open_flag)
> >>  {
> >> +       struct file_handle *handle __free(kfree) =3D NULL;
> >>         long retval =3D 0;
> >>         struct path path __free(path_put) =3D {};
> >>         struct file *file;
> >>         const struct export_operations *eops;
> >>
> >> -       retval =3D handle_to_path(mountdirfd, ufh, &path, open_flag);
> >> +       handle =3D get_user_handle(ufh);
> >> +       if (IS_ERR(handle))
> >> +               return PTR_ERR(handle);
> >
> > I don't think you can use __free(kfree) for something that can be an ER=
R_PTR.
> >
> > Thanks,
> > Amir.
>
> It looks like the error pointer is correctly handled?
>
> in include/linux/slab.h:
>
> DEFINE_FREE(kfree, void *, if (!IS_ERR_OR_NULL(_T)) kfree(_T))

Right! feel free to add for v3:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.

