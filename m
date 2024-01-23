Return-Path: <io-uring+bounces-465-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20466839B94
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 22:57:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAC9E2899B4
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 21:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C94C34F201;
	Tue, 23 Jan 2024 21:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Fx6/qw+d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247504E1BC
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 21:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706047040; cv=none; b=NYCJ9yQuaB9zMkCLzrErL9qoIAceuwrJHY6vOfJSq1JLfe+E1EMVfF/qoea9tRexzEhsai1D+Mnlf5X7ZT/QXxOoVikB2Zr+fRJf/pkMVuhuyYDaG8wpcLGCpnqi3v8nlh5k6I9R6TL+yWLhDa7q+dtTFrrCqu8u3kJ240oAPmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706047040; c=relaxed/simple;
	bh=cszWx0o2HPusfqkpOfHXrdNctgQuMhLZAjzKhBheWSo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rrBS7vI6xFSRcYiMUZFILJTpqhImWkN/9KGF6T64ZBMPPdgdUF+1DPHTdZpwx2uInxAAxMdV3J7xt3E0n7eKGCv2tbehMxgURxlM/+gUWPqCyBUx2fpZldaPMFSK1N0q2lyftX+AAGA4xr402a7W5yoLoNPntoIWbC1cYou050k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Fx6/qw+d; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-dc21d7a7042so4122236276.2
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 13:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1706047038; x=1706651838; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TxtwJgE4RYnu6on0jd5HbEaZUzse4dI8DHc5hHUQCOU=;
        b=Fx6/qw+dQx4nPboaufNv8bXvEiz6Ms6TKgpOm2Iy/XB94eqAfPHoUVp6EaQ/B92X7p
         qnqoyhpvCH0zoogw8T1US3AWnw/ED0tRx48Cy4s6Zk9W/l+ay7BYDD16rCSSxYxxXG52
         zktIQTlZfP8aFWB01/4mEXpbv5rk2HeDdB/UINFpRkdtZMjQnmF2K4KQnBem+idyyCeo
         ktruxnsNj/56/kA1hVwJibqN6JfMUK66EksIo3gLt6vFtCvwAntoVUmeM9rdHd6roOsj
         YSgGL91suC46Pjs4QDCc2ZRs6lwtxnb5hvg5R13hcx/rCREY2kBfYNOi3Aq0RBgYJTwf
         Rrjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706047038; x=1706651838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TxtwJgE4RYnu6on0jd5HbEaZUzse4dI8DHc5hHUQCOU=;
        b=SloTA2N6ANwBatDe+c5/375fKBu+YSjq0ZO7bKI/Yafb/1qQcDj07R5xx/WyHl9D70
         urFHfHa1WD46Oq9smt84zAaR8F67n8SwEwPw/gzEDPa5gvkoceeaPmBe4F+Cc4Tb2JfI
         sa6zus8FqqX8KDDkaI/PI/J2yMWP1b58RsezO0dc0Wz2pxVTDccMqUAHj8oT26DiPV5k
         sZlS/f87sP7DdGRZh6Wlqzlmttfr3nVMZbdSsMmeQkBNFWWcU3Mhf3eA9w4ALnbYE+ia
         SvywWi5jlvoxZo0E8g5sC+zaYzeqCk6ZnevKM3q0c/g2TqvCsQpvagT79mgH4S+P/yrH
         bfow==
X-Gm-Message-State: AOJu0Yy0VPqJ7WlN+qT6EgKoMcBnGtaN+w9yqTjBSwUsMcwZMkgCK/Tw
	WcxReetpqzMf7xRoYgr+Jo+z/Jul1uutkKRiS1ulW5suKZJvKOedICOYW7p79ggsyAxT/7lrquP
	NG3AhAVqjv9CivDQP9DX1D4S8tJFMejc7nUeEEPevYLCABxXO5Q==
X-Google-Smtp-Source: AGHT+IFi5/1dep4Gc28z4r+BSC3PuU3HsK/J59bSjesypTnCZF5lXu98VGDHSmsvxVeW948WwwG5Y4WrdFcAJIF6Sj8=
X-Received: by 2002:a25:aa71:0:b0:dbd:4c39:30bf with SMTP id
 s104-20020a25aa71000000b00dbd4c3930bfmr4353836ybi.98.1706047037953; Tue, 23
 Jan 2024 13:57:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240123215501.289566-2-paul@paul-moore.com>
In-Reply-To: <20240123215501.289566-2-paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 23 Jan 2024 16:57:06 -0500
Message-ID: <CAHC9VhRMsUkNHpc45H4PVnrGj77RDR_BLR9nN89Nh725ke1ECg@mail.gmail.com>
Subject: Re: [PATCH] io_uring: enable audit and restrict cred override for IORING_OP_FIXED_FD_INSTALL
To: io-uring@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, audit@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 4:55=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> We need to correct some aspects of the IORING_OP_FIXED_FD_INSTALL
> command to take into account the security implications of making an
> io_uring-private file descriptor generally accessible to a userspace
> task.
>
> The first change in this patch is to enable auditing of the FD_INSTALL
> operation as installing a file descriptor into a task's file descriptor
> table is a security relevant operation and something that admins/users
> may want to audit.
>
> The second change is to disable the io_uring credential override
> functionality, also known as io_uring "personalities", in the
> FD_INSTALL command.  The credential override in FD_INSTALL is
> particularly problematic as it affects the credentials used in the
> security_file_receive() LSM hook.  If a task were to request a
> credential override via REQ_F_CREDS on a FD_INSTALL operation, the LSM
> would incorrectly check to see if the overridden credentials of the
> io_uring were able to "receive" the file as opposed to the task's
> credentials.  After discussions upstream, it's difficult to imagine a
> use case where we would want to allow a credential override on a
> FD_INSTALL operation so we are simply going to block REQ_F_CREDS on
> IORING_OP_FIXED_FD_INSTALL operations.
>
> Fixes: dc18b89ab113 ("io_uring/openclose: add support for IORING_OP_FIXED=
_FD_INSTALL")
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  io_uring/opdef.c     | 1 -
>  io_uring/openclose.c | 4 ++++
>  2 files changed, 4 insertions(+), 1 deletion(-)

Not having an IORING_OP_FIXED_FD_INSTALL test handy I only did some
basic sanity tests before posting, I would appreciate it if the
io_uring folks could run this through whatever FD_INSTALL tests you
have.

> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 6705634e5f52..b1ee3a9c3807 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -471,7 +471,6 @@ const struct io_issue_def io_issue_defs[] =3D {
>         },
>         [IORING_OP_FIXED_FD_INSTALL] =3D {
>                 .needs_file             =3D 1,
> -               .audit_skip             =3D 1,
>                 .prep                   =3D io_install_fixed_fd_prep,
>                 .issue                  =3D io_install_fixed_fd,
>         },
> diff --git a/io_uring/openclose.c b/io_uring/openclose.c
> index 0fe0dd305546..e3357dfa14ca 100644
> --- a/io_uring/openclose.c
> +++ b/io_uring/openclose.c
> @@ -277,6 +277,10 @@ int io_install_fixed_fd_prep(struct io_kiocb *req, c=
onst struct io_uring_sqe *sq
>         if (flags & ~IORING_FIXED_FD_NO_CLOEXEC)
>                 return -EINVAL;
>
> +       /* ensure the task's creds are used when installing/receiving fds=
 */
> +       if (req->flags & REQ_F_CREDS)
> +               return -EPERM;
> +
>         /* default to O_CLOEXEC, disable if IORING_FIXED_FD_NO_CLOEXEC is=
 set */
>         ifi =3D io_kiocb_to_cmd(req, struct io_fixed_install);
>         ifi->o_flags =3D O_CLOEXEC;
> --
> 2.43.0

--=20
paul-moore.com

