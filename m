Return-Path: <io-uring+bounces-8971-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 819DEB27E4C
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 12:33:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6933D6077F5
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 10:33:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E52F727FB09;
	Fri, 15 Aug 2025 10:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jogIB8yM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C80821FF5D;
	Fri, 15 Aug 2025 10:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755254005; cv=none; b=sgBlJ47FJxEQxdpX4J6hD1ud11G6qXp+k3M/rQuv/gQLdfadTbj2B/AlpKAs48BCRc4pRjj0fciyYyA7ziGSFZptyfn8uPYbKAtVcru8cA+J3qQO7KsT5xC5EnkJ+fUUG+dGwzmkgOj659efSymrbU+p2nBQlxlGfH1sFtyA1k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755254005; c=relaxed/simple;
	bh=9bcnwgAnmGFTWDWhEzKoI1vQeaxlQQb4buermh9kfRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uHgQMn+E0sIoUY1s5El7RRmCO+tTzJlkPPgnbqI8ly8kiZi1SPqba5Z2iKHB7lDFUYgUiHofN2VQv4Ca9Y3hFd9zVRjkr1VnrMalat0mCY8QjWlFgBWsJVmahluKn/EmNbsvlnwN3pBo1SgKccD8zs7eemu/IrWDWK14HPyazjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jogIB8yM; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-618b62dba1aso292820a12.2;
        Fri, 15 Aug 2025 03:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755254002; x=1755858802; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zt7y6ZS2ZP2HqUFeuI5mDzuKESPlChIA79k43BIReEw=;
        b=jogIB8yMvtiZIEoh3Gm0XWAhgHmRIIsdnvFEOFTQcUOL9K+G2+Ek7na5iYMmbZzcP2
         dDyaQOfA56DLCDM3u0eKE76amxT1ZUcivrOxmTJYHKo7aL3fGvimQhwU+iKAKqw8c1Uv
         73d7N24BiHRa9QWinq8xUuTY0KcKUZtEdPOTTcXvtheqWVFOMXkgeNkub84xklMbQLX0
         KzquRGalkWr2OSxQWfO/CfFjrF7VlFTv8/938lITc3foXCi+aW57BEvjPFyDWIm/T2yf
         jBhvE4pr9kBH0G6p1kpbwdM92rpCPdyvt/JUZQ20i/7a5/kLZlUFmM8xh2RzscXfpFOY
         JOzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755254002; x=1755858802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zt7y6ZS2ZP2HqUFeuI5mDzuKESPlChIA79k43BIReEw=;
        b=ZJt8RJsmx88m2xqKpsJnjqOnTHXZYNdFJGtKREkpEdRpSq+pMEXWZzB/aLY5HT1gXs
         J4kyJ1E0HMXtLK0XxuzZJHK5FLlpG7Uww5BE/7YHGZLnVEBT7PifDtEB77c39W1pnzjF
         qVszb3MaOur+kNybXjnCnUdM9gfKY6M3ySZuk125zNFEgTpG0nLk/29rS006O/cRBXb4
         KywRXgdn2HgtbniuTTDIjcDU/4VoRTahVfIEO2Kdf7pc658OnhkhTxf+lml4R3yVKbQy
         Ivm7gaoChlda3GWaLtfGy5sPjwmDqBGgchfT4PDt2lXi2sIbgr+FCrP981Wf5jJD/n33
         NdKg==
X-Forwarded-Encrypted: i=1; AJvYcCW5GDAHWHZ2AHpFC/XrFo+jGOiPCw7i8D9xTmoNylqrz/Usc0fFbT04v5xSvgOBHzdB94f1X9cewFUJTGle@vger.kernel.org, AJvYcCXvEvCS0hQVSy1SJ4cU0VBlDXr7kU49Cre5KT83is80pc6hHkRyp6f0EzZ0nR1bxXC4tasMHUiQef2G@vger.kernel.org
X-Gm-Message-State: AOJu0YypKR9ARJt9NJZRuZDCaFirt7/IbyUSHVQiDgSZk3blAyY7c+PK
	Wr4UZpOIpnqYZO9F3UpLNbsehMJHn/PHfY2D56E2gpQidEW8jW1FCBnpWCmwB/IbH8I/zJtLX1C
	ppEQvflz/f/9w8CNrPfqb1JJOcjlnZUlEI1qyy00=
X-Gm-Gg: ASbGncv8vtdcWPFNZaaWunyS3+9euxpC35Pu0wYQ2V9IZm/tVCZAWJqoRWYSxMzeUwZ
	a3q3WYuL7r6AI9WyPfRHQjNtDsOazxQELMPtKFxmdtS+PROmWJX0hevqSNS2VL0wBhwmM1N+GGd
	qyOIc/7GKnp7/gg39SLgAYnz9EeH3zO8VHvce1QCAiA6grV80y9nHhUbXlR20pw+JBWKcQxmvAH
	I8QDP0=
X-Google-Smtp-Source: AGHT+IE+46iRM2kr/8tCgOW5Wxr17Dm0wiOGZ/CAzwl2IJf7hWmqBgxNTz64/eQFuG1xCdbxnxtUW6jNV6iWntc/r/M=
X-Received: by 2002:a05:6402:5107:b0:618:1705:83e3 with SMTP id
 4fb4d7f45d1cf-618b0560889mr1144861a12.19.1755254002343; Fri, 15 Aug 2025
 03:33:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814235431.995876-1-tahbertschinger@gmail.com> <20250814235431.995876-5-tahbertschinger@gmail.com>
In-Reply-To: <20250814235431.995876-5-tahbertschinger@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 Aug 2025 12:33:11 +0200
X-Gm-Features: Ac12FXw0leNbfNne6TtQqtmUAacpK5BCYOvX6SVwbW9Vge9H_tJtnAkhB0Bhl6g
Message-ID: <CAOQ4uxhg6N1vwkE8PnxEnrLEhGq5SPGB1wg3RPymRx2yn+e6PQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] fhandle: create __do_handle_open() helper
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 1:52=E2=80=AFAM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> do_handle_open() takes care of both opening a file via its file handle,
> and associating it with a file descriptor.
>
> For io_uring, it is useful to do just the opening part separately,
> because io_uring might not want to install it into the main open files
> table when using fixed descriptors.
>
> This creates a helper which will enable io_uring to do that.
>
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> ---
>  fs/fhandle.c  | 24 +++++++++++++++++-------
>  fs/internal.h |  2 ++
>  2 files changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/fs/fhandle.c b/fs/fhandle.c
> index dbb273a26214..b14884a93867 100644
> --- a/fs/fhandle.c
> +++ b/fs/fhandle.c
> @@ -397,8 +397,8 @@ static int handle_to_path(int mountdirfd, struct file=
_handle __user *ufh,
>         return retval;
>  }
>
> -static long do_handle_open(int mountdirfd, struct file_handle __user *uf=
h,
> -                          int open_flag)
> +struct file *__do_handle_open(int mountdirfd, struct file_handle __user =
*ufh,
> +                             int open_flag)
>  {
>         long retval =3D 0;
>         struct path path __free(path_put) =3D {};
> @@ -407,17 +407,27 @@ static long do_handle_open(int mountdirfd, struct f=
ile_handle __user *ufh,
>
>         retval =3D handle_to_path(mountdirfd, ufh, &path, open_flag);
>         if (retval)
> -               return retval;
> -
> -       CLASS(get_unused_fd, fd)(open_flag);
> -       if (fd < 0)
> -               return fd;
> +               return ERR_PTR(retval);
>
>         eops =3D path.mnt->mnt_sb->s_export_op;
>         if (eops->open)
>                 file =3D eops->open(&path, open_flag);
>         else
>                 file =3D file_open_root(&path, "", open_flag, 0);
> +
> +       return file;
> +}
> +
> +static long do_handle_open(int mountdirfd, struct file_handle __user *uf=
h,
> +                          int open_flag)
> +{
> +       struct file *file;
> +
> +       CLASS(get_unused_fd, fd)(open_flag);
> +       if (fd < 0)
> +               return fd;
> +
> +       file =3D __do_handle_open(mountdirfd, ufh, open_flag);
>         if (IS_ERR(file))
>                 return PTR_ERR(file);
>
> diff --git a/fs/internal.h b/fs/internal.h
> index af7e0810a90d..26ac6f356313 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -362,3 +362,5 @@ void pidfs_get_root(struct path *path);
>  long do_name_to_handle_at(int dfd, const char __user *name,
>                           struct file_handle __user *handle,
>                           void __user *mnt_id, int flag, int lookup_flags=
);
> +struct file *__do_handle_open(int mountdirfd, struct file_handle __user =
*ufh,
> +                             int open_flag);

As I said I displike exported do_XXX() helpers, but I __do_XXX() exported
helpers are much worse.

How about do_filp_handle_open()?

Thanks,
Amir.

