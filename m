Return-Path: <io-uring+bounces-10733-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A652AC7C2A1
	for <lists+io-uring@lfdr.de>; Sat, 22 Nov 2025 03:16:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A6E314E2EE3
	for <lists+io-uring@lfdr.de>; Sat, 22 Nov 2025 02:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DEF3285045;
	Sat, 22 Nov 2025 02:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="agDzsLuy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8149913959D
	for <io-uring@vger.kernel.org>; Sat, 22 Nov 2025 02:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763777675; cv=none; b=AihN0wCDrEo2k+ym/tR5VYyx4PjMCIklpvGeJ8AnnZmmDuECov2OkICC3Jib+drinrdqecihh5gMD43s8FxuKA0J1vJAvUIhW3U3BflJH1eozBZfTjeBBHFqkeIIRXnFgvGUHTHlznqWZ4TvuFS8uqQUgnn6g7kjLdTRCe5MRyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763777675; c=relaxed/simple;
	bh=ixATDmWAQHR7JLkejaYEJz4OoiolULOVrQzGKRnEf1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TNRzAzlX+u6FC5SbsYVi4zxjqFGC1qUMJR+OTsbYQlANkDzCxgGXx/TB/IzfY825xKo7ho1YGabvKdMz42kkZsUo9DOJcVd/NwOxPUEOfg9mJR/SrKIPvPJIwg2y58562VmrDebMctS9zT65PfF5TCeu6F5O6KFH0XcsmdLfbqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=agDzsLuy; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-11b6bc976d6so3658319c88.0
        for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 18:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763777672; x=1764382472; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fXD8xGLkJpEXCjyfR6EzT6paW99a1b2ciKP2iHRz520=;
        b=agDzsLuy0Y0vpnKUpG4Ch95afHRWjDMxVjxfBrAnQ7wLAMsjYRiA4Q8w89IxzV5Q51
         RuWDalf+52Ekf4mGPwzOy0bVAg1YH3td0GdbJVicQzfPNGVcMMmnLGzns4d+cNztnWyA
         PusrrN97PmTCjbQMa0ezhSwRv/vfRO9gc/8u9R5RgeVEhpISmSi3ivxfVcy86DvJo3UP
         QRDlDQZYxGPkZg1NUBzF1xYixNpnwTIfV10+FqqV3cHTRCqIBRmCUstTh1ovebuWqNb/
         kaYnoC9Q5UXEXw7DlU+nwLrNxZehXhpWO3F7r6sW5jQ2GXFgVED+gNhdzrAXZ9Lo3Yl5
         0sug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763777672; x=1764382472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fXD8xGLkJpEXCjyfR6EzT6paW99a1b2ciKP2iHRz520=;
        b=L6M6TesVXF04qhM/XzBMab7h+Sqn4nhizZlnzzfKv1EzDCHWr4nxA1e/rsQ6YkRJo5
         MI/PrRPD4igqbilEb73ANmQY/uwk0DzPLyPCqrWfL81YWgBt2+b/9sEnfWvPBc0OGSGt
         A5LpquGOIX9opux0VXkVCkVe0ItFK10DcY1efffMM/EbzJo1de8o0uFarygzVzj55DUS
         c3AGsFOE/ZH9jLFsGb43QFxbl8s9FM95/IgO+UohRAak+jdUs2Ai3n+zvOfvUpcvJwEo
         m1AJNtnTAAWMufowORRfZV9XNSXMM4wfggIQgkiDSN62VOgfPmUSrEVZq2zn7RkOgfK4
         5+NQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL2ayAJzXUxyF/0Lge5P25SbLoTXYU49eqOJuTbBR1Mjbf0DOv9nuGZNjAgKHhTa4gYssXNCxpHg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyShMclZyu4Q0T2ac0nlIrsYyFkd83H6BNEyfQW8f6HmvIVs3tL
	29H6Qeum8AoyqGqEVF+gE5zHBR7e6yDVCJJqOuDpV/txoR87z+oGhKjq2YpOFBkx9UKC9eubukE
	7HiRq59Uw5Y4VXqOhgUBucNaIJtFgZgfa+pElv83Z
X-Gm-Gg: ASbGncsnYf+ce7Th/AXW7pUonvv9t0yIKofJXH3mzMJcys2vGemOeXFL4Don7zgutDV
	fH/sqSuk7Qb1iieM7U2UckXpq+iKLjAA0itCbFUSrAkD0rXbMaTDx0Zrdf8hlLl1c5Ug1jXt0Oi
	X+bwv3JrfgVv89Q/CNwVJFOUWkauM3MPs/pZDiOhBviMDvGjPWSyL8twuJlVkKvDl3H7rEot7aq
	H9hwuf1/VszfBwwi932W+3hWsvqn5j0jUmDlSTFKD8lDbhETAhk2xAqHmu+Uu+jmuZ6hTA946QE
	5UcWxE/5TaGEEAHHYRs7TomzEApU
X-Google-Smtp-Source: AGHT+IEQd+Ucgwx1uwTerm8eYBf6Pw3gfuRxhCtxz1f3eUV5q504LT6oNRGWtpJFdyYlKNN0OCTvLlibWfcia6CJb+U=
X-Received: by 2002:a05:7022:1e14:b0:119:e569:f86d with SMTP id
 a92af1059eb24-11c9ca96a9cmr1214969c88.10.1763777672167; Fri, 21 Nov 2025
 18:14:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121160954.88038-1-krisman@suse.de> <20251121160954.88038-2-krisman@suse.de>
In-Reply-To: <20251121160954.88038-2-krisman@suse.de>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Fri, 21 Nov 2025 18:14:21 -0800
X-Gm-Features: AWmQ_bldxb5SIHv_YOpZvE401zjUsj8FuLj8HQweQYc9mQQFBc9DBQXfMLtf7as
Message-ID: <CAAVpQUAvDMCLySn_gW+abifVpt_=tH771ZzOxVM8mYsO6mgaMQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] socket: Unify getsockname and getpeername implementation
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, netdev@vger.kernel.org, io-uring@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 8:10=E2=80=AFAM Gabriel Krisman Bertazi <krisman@su=
se.de> wrote:
>
> They are already implemented by the same get_name hook in the protocol
> level.  Bring the unification one level up to reduce code duplication
> in preparation to supporting these as io_uring operations.
>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
> ---
>  include/linux/socket.h |  4 +--
>  net/compat.c           |  4 +--
>  net/socket.c           | 55 ++++++++++--------------------------------
>  3 files changed, 16 insertions(+), 47 deletions(-)
>
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 3b262487ec06..937fe331ff1e 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -454,9 +454,7 @@ extern int __sys_connect(int fd, struct sockaddr __us=
er *uservaddr,
>  extern int __sys_listen(int fd, int backlog);
>  extern int __sys_listen_socket(struct socket *sock, int backlog);
>  extern int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
> -                            int __user *usockaddr_len);
> -extern int __sys_getpeername(int fd, struct sockaddr __user *usockaddr,
> -                            int __user *usockaddr_len);
> +                            int __user *usockaddr_len, int peer);
>  extern int __sys_socketpair(int family, int type, int protocol,
>                             int __user *usockvec);
>  extern int __sys_shutdown_sock(struct socket *sock, int how);
> diff --git a/net/compat.c b/net/compat.c
> index 485db8ee9b28..2c9bd0edac99 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -460,10 +460,10 @@ COMPAT_SYSCALL_DEFINE2(socketcall, int, call, u32 _=
_user *, args)
>                 ret =3D __sys_accept4(a0, compat_ptr(a1), compat_ptr(a[2]=
), 0);
>                 break;
>         case SYS_GETSOCKNAME:
> -               ret =3D __sys_getsockname(a0, compat_ptr(a1), compat_ptr(=
a[2]));
> +               ret =3D __sys_getsockname(a0, compat_ptr(a1), compat_ptr(=
a[2]), 0);
>                 break;
>         case SYS_GETPEERNAME:
> -               ret =3D __sys_getpeername(a0, compat_ptr(a1), compat_ptr(=
a[2]));
> +               ret =3D __sys_getsockname(a0, compat_ptr(a1), compat_ptr(=
a[2]), 1);
>                 break;
>         case SYS_SOCKETPAIR:
>                 ret =3D __sys_socketpair(a0, a1, a[2], compat_ptr(a[3]));
> diff --git a/net/socket.c b/net/socket.c
> index e8892b218708..ee438b9425da 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2128,12 +2128,11 @@ SYSCALL_DEFINE3(connect, int, fd, struct sockaddr=
 __user *, uservaddr,
>  }
>
>  /*
> - *     Get the local address ('name') of a socket object. Move the obtai=
ned
> - *     name to user space.
> + *     Get the address (remote or local ('name')) of a socket object. Mo=
ve the

nit: Get the remote or local address ('name')

Otherwise, looks good.

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>


> + *     obtained name to user space.
>   */
> -
>  int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
> -                     int __user *usockaddr_len)
> +                     int __user *usockaddr_len, int peer)
>  {
>         struct socket *sock;
>         struct sockaddr_storage address;
> @@ -2146,11 +2145,14 @@ int __sys_getsockname(int fd, struct sockaddr __u=
ser *usockaddr,
>         if (unlikely(!sock))
>                 return -ENOTSOCK;
>
> -       err =3D security_socket_getsockname(sock);
> +       if (peer)
> +               err =3D security_socket_getpeername(sock);
> +       else
> +               err =3D security_socket_getsockname(sock);
>         if (err)
>                 return err;
>
> -       err =3D READ_ONCE(sock->ops)->getname(sock, (struct sockaddr *)&a=
ddress, 0);
> +       err =3D READ_ONCE(sock->ops)->getname(sock, (struct sockaddr *)&a=
ddress, peer);
>         if (err < 0)
>                 return err;
>
> @@ -2161,44 +2163,13 @@ int __sys_getsockname(int fd, struct sockaddr __u=
ser *usockaddr,
>  SYSCALL_DEFINE3(getsockname, int, fd, struct sockaddr __user *, usockadd=
r,
>                 int __user *, usockaddr_len)
>  {
> -       return __sys_getsockname(fd, usockaddr, usockaddr_len);
> -}
> -
> -/*
> - *     Get the remote address ('name') of a socket object. Move the obta=
ined
> - *     name to user space.
> - */
> -
> -int __sys_getpeername(int fd, struct sockaddr __user *usockaddr,
> -                     int __user *usockaddr_len)
> -{
> -       struct socket *sock;
> -       struct sockaddr_storage address;
> -       CLASS(fd, f)(fd);
> -       int err;
> -
> -       if (fd_empty(f))
> -               return -EBADF;
> -       sock =3D sock_from_file(fd_file(f));
> -       if (unlikely(!sock))
> -               return -ENOTSOCK;
> -
> -       err =3D security_socket_getpeername(sock);
> -       if (err)
> -               return err;
> -
> -       err =3D READ_ONCE(sock->ops)->getname(sock, (struct sockaddr *)&a=
ddress, 1);
> -       if (err < 0)
> -               return err;
> -
> -       /* "err" is actually length in this case */
> -       return move_addr_to_user(&address, err, usockaddr, usockaddr_len)=
;
> +       return __sys_getsockname(fd, usockaddr, usockaddr_len, 0);
>  }
>
>  SYSCALL_DEFINE3(getpeername, int, fd, struct sockaddr __user *, usockadd=
r,
>                 int __user *, usockaddr_len)
>  {
> -       return __sys_getpeername(fd, usockaddr, usockaddr_len);
> +       return __sys_getsockname(fd, usockaddr, usockaddr_len, 1);
>  }
>
>  /*
> @@ -3162,12 +3133,12 @@ SYSCALL_DEFINE2(socketcall, int, call, unsigned l=
ong __user *, args)
>         case SYS_GETSOCKNAME:
>                 err =3D
>                     __sys_getsockname(a0, (struct sockaddr __user *)a1,
> -                                     (int __user *)a[2]);
> +                                     (int __user *)a[2], 0);
>                 break;
>         case SYS_GETPEERNAME:
>                 err =3D
> -                   __sys_getpeername(a0, (struct sockaddr __user *)a1,
> -                                     (int __user *)a[2]);
> +                   __sys_getsockname(a0, (struct sockaddr __user *)a1,
> +                                     (int __user *)a[2], 1);
>                 break;
>         case SYS_SOCKETPAIR:
>                 err =3D __sys_socketpair(a0, a1, a[2], (int __user *)a[3]=
);
> --
> 2.51.0
>

