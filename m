Return-Path: <io-uring+bounces-6918-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8EC0A4CF04
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 00:01:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02E681715C1
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 23:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F971E570E;
	Mon,  3 Mar 2025 23:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="NFpBBrU7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD301487F4
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 23:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741042886; cv=none; b=qjaNtqhi5YWZIA3hUXuE3076IGqr45jIl90NuNmDyiQ14iVXNIhyqfMf+1hLeF14qh1VGrBaJk6oc27tgLZ74uxTzTOB3CyIM1w+B1VA4RwZ/MDDPUMlgoK2eSUcxQmMAd4Qi93EyAc8hfUrrFTjTrgu8VFQkeVkY6NoSWRLLx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741042886; c=relaxed/simple;
	bh=oLoH167I5RvJBRzrvY1W5xIMFvqhPg5DJG3RQJ7a4hE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dXdjr2tuHTnSDbDO9V8+zpYX6TT4XP5g4vfkE4Un17vWbpkKy32yNFyG6a6is6BOeBG3a7sz14g1S6f90o0O1IPff6Xu3GX/ACQMrmz6E38t/EocuwAJO/5PZyBFz1xkJ9G7UKedscKBgKJ2cPgJSH9fU/THsodf5BgwGWBktWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=NFpBBrU7; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2feb700271aso916408a91.0
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 15:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1741042884; x=1741647684; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sS8WPJWjRy7NHvAaNgvoRhqwDt7xWD+javlfKptwEBc=;
        b=NFpBBrU7SUsVohdVs6BztPCAPEIYcQIoQjMBxJT1c+tgU9dnjEOes+aQuIiqHdTyjJ
         jv6U2JYqGdDS8g+Dlaqt+VmvZ4f2ZJyfcaIpdk4/l/kaO2w3ysaYaAVGWTiX3G6bg5bD
         k0nfY6Yl4Y3OaCuSWKMfoZfP7yGSpJfUK5fnllkyKh2BESNbxAfaz7P+sWuc2cb5oqTV
         SpXHrDV3apEuC0fWeCqa9z2EeI+FM3QSV+UGIgSBGe48C53lZtlkFiaZMxs5JXSC7XTI
         XTiO9VJb6D3jp4oBcAtihWNpZdsLNPi3hBJTgD0a0ogS1n7XMt3gvMnXadBEk6xfqle9
         L7aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741042884; x=1741647684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sS8WPJWjRy7NHvAaNgvoRhqwDt7xWD+javlfKptwEBc=;
        b=L7ujWtzMVJy3x6UOugvGgM2H376EgGXqkWaO/tAwuIGDWoCmuxQHr4jyC3HH7103Pu
         wDeoQdQmTxyg7gVdHWxQKlHtGEQQBJnX7yRo49d0RKEdHuHXAu7/s//yV3vgxciIqzk1
         GAkMPkdMllPJZPYwfzvYwA3iTo4GgeStqPijhatHfKohnU85eClQP7JuP79uCkaifDlN
         4INZjuhszrqmINzz21nrxRl1qQa0B4iThDAPHJdXwundNW2mknt7jihXLYfZfpqX06Gi
         r2RKaQ9JwdcV68CRbm6RFE7o4ULy0qcMeC5mM5807rb5az0JXINOf3tVAvB7BY9XzXPR
         DfnA==
X-Gm-Message-State: AOJu0YxJpp1RRqNO0A8XSmQAiQNvKbMZwRh3xXZErqk34G0sBbmvVkT6
	mSaS/zEQz+N2fdCqWnBLJ5b4Z3yKMuq3RV61OizMtQSxrOmACvqFgBajFEsl3tMNi7oF+n/vISN
	nn2J+bHe++27BzTiz3PezS79ml3zsV9WTo8S4l7rc289fDh7f
X-Gm-Gg: ASbGnctnOAAhHTl2O2g4qpe3J8FHTZHjjPK+9mFYkaeVosxtMlxrC7I9M4KF0wo6Sa4
	B30Z+idcr97+JNWXcFK7m5XtEit/Zbt32Wb/aTg+dRoQf2Pyi1t4LkoYJmbAl5itsXSOWoiPmwX
	YHAkLg+6yUOrob78MSFZOjzN++
X-Google-Smtp-Source: AGHT+IFV3FAn7WSgsgAfMXi/2N2almtqPP40x7RiQqS/eXZVm11QYp8Yfe/9LB+5FwR+IE0HVXXq7dvpSpq14LRUEEU=
X-Received: by 2002:a17:90b:1a88:b0:2fa:2011:c85d with SMTP id
 98e67ed59e1d1-2ff35362150mr287700a91.7.1741042883897; Mon, 03 Mar 2025
 15:01:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1741014186.git.asml.silence@gmail.com> <444a0ab0c3dc6320c5604a06284923a7abefa145.1741014186.git.asml.silence@gmail.com>
In-Reply-To: <444a0ab0c3dc6320c5604a06284923a7abefa145.1741014186.git.asml.silence@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 3 Mar 2025 15:01:12 -0800
X-Gm-Features: AQ5f1JpwSPTwX7zhWgR7XywchJ-X1FIwKUoWp7Pqvd4M0quN310he5iRoQXpVOE
Message-ID: <CADUfDZrNCzE=X5tSOsa9rBqop-TW3Kw9oHj8u+YDxYJXGyw5uA@mail.gmail.com>
Subject: Re: [PATCH 3/8] io_uring/rw: implement vectored registered rw
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Andres Freund <andres@anarazel.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 7:50=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> Implement registered buffer vectored reads with new opcodes
> IORING_OP_WRITEV_FIXED and IORING_OP_READV_FIXED.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/uapi/linux/io_uring.h |  2 ++
>  io_uring/opdef.c              | 39 +++++++++++++++++++++++++++
>  io_uring/rw.c                 | 51 +++++++++++++++++++++++++++++++++++
>  io_uring/rw.h                 |  2 ++
>  4 files changed, 94 insertions(+)
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
> index 1e02e94bc26d..9dd384b369ee 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -280,6 +280,8 @@ enum io_uring_op {
>         IORING_OP_BIND,
>         IORING_OP_LISTEN,
>         IORING_OP_RECV_ZC,
> +       IORING_OP_READV_FIXED,
> +       IORING_OP_WRITEV_FIXED,
>
>         /* this goes last, obviously */
>         IORING_OP_LAST,
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 9511262c513e..6655d2cbf74d 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -529,6 +529,35 @@ const struct io_issue_def io_issue_defs[] =3D {
>                 .prep                   =3D io_eopnotsupp_prep,
>  #endif
>         },
> +       [IORING_OP_READV_FIXED] =3D {
> +               .needs_file             =3D 1,
> +               .unbound_nonreg_file    =3D 1,
> +               .pollin                 =3D 1,
> +               .plug                   =3D 1,
> +               .audit_skip             =3D 1,
> +               .ioprio                 =3D 1,
> +               .iopoll                 =3D 1,
> +               .iopoll_queue           =3D 1,
> +               .vectored               =3D 1,
> +               .async_size             =3D sizeof(struct io_async_rw),
> +               .prep                   =3D io_prep_readv_fixed,
> +               .issue                  =3D io_read,
> +       },
> +       [IORING_OP_WRITEV_FIXED] =3D {
> +               .needs_file             =3D 1,
> +               .hash_reg_file          =3D 1,
> +               .unbound_nonreg_file    =3D 1,
> +               .pollout                =3D 1,
> +               .plug                   =3D 1,
> +               .audit_skip             =3D 1,
> +               .ioprio                 =3D 1,
> +               .iopoll                 =3D 1,
> +               .iopoll_queue           =3D 1,
> +               .vectored               =3D 1,
> +               .async_size             =3D sizeof(struct io_async_rw),
> +               .prep                   =3D io_prep_writev_fixed,
> +               .issue                  =3D io_write,
> +       },
>  };
>
>  const struct io_cold_def io_cold_defs[] =3D {
> @@ -761,6 +790,16 @@ const struct io_cold_def io_cold_defs[] =3D {
>         [IORING_OP_RECV_ZC] =3D {
>                 .name                   =3D "RECV_ZC",
>         },
> +       [IORING_OP_READV_FIXED] =3D {
> +               .name                   =3D "READV_FIXED",
> +               .cleanup                =3D io_readv_writev_cleanup,
> +               .fail                   =3D io_rw_fail,
> +       },
> +       [IORING_OP_WRITEV_FIXED] =3D {
> +               .name                   =3D "WRITEV_FIXED",
> +               .cleanup                =3D io_readv_writev_cleanup,
> +               .fail                   =3D io_rw_fail,
> +       },
>  };
>
>  const char *io_uring_get_opcode(u8 opcode)
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index ad7f647d48e9..4c4229f41aaa 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -381,6 +381,57 @@ int io_prep_write_fixed(struct io_kiocb *req, const =
struct io_uring_sqe *sqe)
>         return __io_prep_rw(req, sqe, ITER_SOURCE);
>  }
>
> +static int io_rw_prep_reg_vec(struct io_kiocb *req, int ddir)
> +{
> +       struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
> +       struct io_async_rw *io =3D req->async_data;
> +       const struct iovec __user *uvec;
> +       size_t uvec_segs =3D rw->len;
> +       struct iovec *iov;
> +       int iovec_off, ret;
> +       void *res;
> +
> +       if (uvec_segs > io->vec.nr) {
> +               ret =3D io_vec_realloc(&io->vec, uvec_segs);
> +               if (ret)
> +                       return ret;
> +               req->flags |=3D REQ_F_NEED_CLEANUP;
> +       }
> +       /* pad iovec to the right */
> +       iovec_off =3D io->vec.nr - uvec_segs;
> +       iov =3D io->vec.iovec + iovec_off;
> +       uvec =3D u64_to_user_ptr(rw->addr);
> +       res =3D iovec_from_user(uvec, uvec_segs, uvec_segs, iov,
> +                             io_is_compat(req->ctx));
> +       if (IS_ERR(res))
> +               return PTR_ERR(res);
> +
> +       ret =3D io_import_reg_vec(ddir, &io->iter, req, &io->vec,
> +                               uvec_segs, iovec_off, 0);

So the iovecs are being imported at prep time rather than issue time?
I suppose since only user registered buffers are allowed and not
kernel bvecs, you aren't concerned about interactions with the ublk
bvec register/unregister operations? I think in principle the
difference between prep and issue time is still observable if the same
registered buffer index is being used alternately for user and kernel
registered buffers.

Best,
Caleb

> +       iov_iter_save_state(&io->iter, &io->iter_state);
> +       return ret;
> +}
> +
> +int io_prep_readv_fixed(struct io_kiocb *req, const struct io_uring_sqe =
*sqe)
> +{
> +       int ret;
> +
> +       ret =3D __io_prep_rw(req, sqe, ITER_DEST);
> +       if (unlikely(ret))
> +               return ret;
> +       return io_rw_prep_reg_vec(req, ITER_DEST);
> +}
> +
> +int io_prep_writev_fixed(struct io_kiocb *req, const struct io_uring_sqe=
 *sqe)
> +{
> +       int ret;
> +
> +       ret =3D __io_prep_rw(req, sqe, ITER_SOURCE);
> +       if (unlikely(ret))
> +               return ret;
> +       return io_rw_prep_reg_vec(req, ITER_SOURCE);
> +}
> +
>  /*
>   * Multishot read is prepared just like a normal read/write request, onl=
y
>   * difference is that we set the MULTISHOT flag.
> diff --git a/io_uring/rw.h b/io_uring/rw.h
> index e86a3858f48b..475b6306a316 100644
> --- a/io_uring/rw.h
> +++ b/io_uring/rw.h
> @@ -34,6 +34,8 @@ struct io_async_rw {
>
>  int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *=
sqe);
>  int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe =
*sqe);
> +int io_prep_readv_fixed(struct io_kiocb *req, const struct io_uring_sqe =
*sqe);
> +int io_prep_writev_fixed(struct io_kiocb *req, const struct io_uring_sqe=
 *sqe);
>  int io_prep_readv(struct io_kiocb *req, const struct io_uring_sqe *sqe);
>  int io_prep_writev(struct io_kiocb *req, const struct io_uring_sqe *sqe)=
;
>  int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe);
> --
> 2.48.1
>
>

