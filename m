Return-Path: <io-uring+bounces-10734-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 92007C7C2A7
	for <lists+io-uring@lfdr.de>; Sat, 22 Nov 2025 03:16:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4252134B997
	for <lists+io-uring@lfdr.de>; Sat, 22 Nov 2025 02:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65D02C21ED;
	Sat, 22 Nov 2025 02:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qJEh+XZw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA1B212F98
	for <io-uring@vger.kernel.org>; Sat, 22 Nov 2025 02:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763777764; cv=none; b=frWnJPszDVE6qw8jBqvC5tGgqhM2xdsmhRiK/cWrdaRvwX8j8dBivkfUuCdHPg9rGxEeLfAMNosrNI8KQfrkSBt6pGHNjZ4X5I6B82pG8G6hAtcLMPcDaoA2u30LtBbQuSJQXfNKhn6SR2+tgE7llWXqi7VGdISxTevAk0+uIWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763777764; c=relaxed/simple;
	bh=BHFJkb65NF6jyvP92hQZHaZ7yu+Ipv4m4/djl5gPcR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SvpXvM8syuZ4GeEMiC+pMk7jOqaKODfhlkALXgeVuVzzii6umPDcLrJXwBo5HotpQmjbE0vMNNFzCJwwrfe3BdjZcvW8I83wkTPDbfHgI5FS0UrJXWrNDF7VUYsdAWCbJgkttN8/tZFb14qwEi48cXpw8KB7p1NmQIP47mOAKI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qJEh+XZw; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso3168576b3a.2
        for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 18:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763777761; x=1764382561; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MwZHqk6D7/ztotFEOHDmupQkGYG2hAiZI4I+YGJ0Cng=;
        b=qJEh+XZwr2LDy3eFEKJtiZ8jGVMHXLfLVrkQMBDfZ8oX7HnrBHSwQGJOw+SjPgXplv
         3N++gIwLRnR3rIzlTaeKvjT0yr2sbsigq2pueJSYyTQvxiEpfrcDWkn8jLlpQBwO+eDm
         mVe4k65Cea4iOUJjT4wvun43hejgdCUUTtotvFTLwBLYSi9ukPkXjSOBVCbbKlDwXF+g
         +6erRFK0LDLthlNcBGUuabOIxIQ2Fv6hF7TW7NMPCj7JEDT9zrufTbN6ln5rTraCdOts
         YRg5jO2hD+pcF3sJqhTnY0IXchpkslGSaexT9o+fhsyP+lLOWrGI2mBBvBFqeKUFGbsn
         Mrrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763777761; x=1764382561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MwZHqk6D7/ztotFEOHDmupQkGYG2hAiZI4I+YGJ0Cng=;
        b=XA627nrpXUINFqHAleul1OItMv3XLyg2hRR65IpP2Fm7hN7bJYuPvBDYlgl7AAyIWK
         Xv5ssUixWZmHC8qkpTwQXSG2HZk8uPdqzKEZo1gUUj+mU1s+BYqYRDDpJARC+Qon77lV
         l2rsIGsrSpLkkNXsXQUP3Jixmu3hEY9DT0iF9QOHfGu71sfwTP3l8B+b1dgBWREHmErE
         FUSbOB2RWqxL27PaH57ZopEbrXxab6K50uuNg4P/3GWd/pKyLIdhc50Mmw9Em2drN9QI
         JC1dcfCW2W6yrbrFWQ9tiIeCsd7jKXw+ABfDXjr8Uid3kkAnkzjDNujw/P1IDtIQjjwf
         9o+A==
X-Forwarded-Encrypted: i=1; AJvYcCW/eafu+vEIRcszI+ZeZLxHYqs/ZOIdqy34gTn3PDMCuGyPr6e3x4pz0JDEoxx2wPM+vX+rxCgrLA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKjkLDBdTiQNuv/YsuyUpcsgIFKNMigZk3BFpsIXC8sbKDgzlU
	kKuAZMDuvUvC5n0BWu1UKn4If0h3mzXlysCZ98KwKEhZ3+gVoMuc+VFb5aBsDurGD5CJmeDeSlO
	Txqf3TW6HtmBxQUhoH7euIz8OCfZPeVftDqHm4rqR
X-Gm-Gg: ASbGncv45IohFtKoGTOGSNV2REJetRvKlxyEybhhSrwCqbmLp8MwR+FR2Us3bRTB5Qs
	IQ+FNl4mGURzt5jSF3xxk3ZHjs835Vif5ZBLdky8iJc78wENESy3BShnWoxE8CNhvWSNnZvTsy9
	eRTGixxFxYPrby1u0QD3wspIIQmuGFNvS81KBg351CUjb0hHlZpWXa4Y/LpG969vOBSC2VrD4lH
	Pmo2DIsyJgnS+uLLLak2eSNZ0jQMe3eo4iwI44ASK7pbMBbJQ5oUTLIEJdYLHF36IL8N9tYheba
	dAu3BhX+hOU0BTjN9bvVNL0Zr+Iv
X-Google-Smtp-Source: AGHT+IFUCKrwrkIcJ5jIciiCusYue03VCH60BWqW2feFIKgRses9GzdMsYNos9kodqTwN4Qd4PyVYtvrtAC+VnfymC4=
X-Received: by 2002:a05:7022:6610:b0:11b:9386:825e with SMTP id
 a92af1059eb24-11c9d8720a1mr1680122c88.43.1763777761039; Fri, 21 Nov 2025
 18:16:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121160954.88038-1-krisman@suse.de> <20251121160954.88038-3-krisman@suse.de>
In-Reply-To: <20251121160954.88038-3-krisman@suse.de>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Fri, 21 Nov 2025 18:15:50 -0800
X-Gm-Features: AWmQ_bkwrD2nvWkLk9hhcPJr_JfmdYMmx4MR6B5cjS0XjdSIov_5qt_nublNG5s
Message-ID: <CAAVpQUAPrmDH6-ZiEioJ_sohbQ-kBu1MFBssPVzY34FRnsnz0w@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] socket: Split out a getsockname helper for io_uring
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
> Similar to getsockopt, split out a helper to check security and issue
> the operation from the main handler that can be used by io_uring.
>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
> ---
>  include/linux/socket.h |  2 ++
>  net/socket.c           | 34 +++++++++++++++++++---------------
>  2 files changed, 21 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 937fe331ff1e..5afb5ef2990c 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -453,6 +453,8 @@ extern int __sys_connect(int fd, struct sockaddr __us=
er *uservaddr,
>                          int addrlen);
>  extern int __sys_listen(int fd, int backlog);
>  extern int __sys_listen_socket(struct socket *sock, int backlog);
> +extern int do_getsockname(struct socket *sock, struct sockaddr_storage *=
address,
> +                         int peer, struct sockaddr __user *usockaddr, in=
t __user *usockaddr_len);
>  extern int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
>                              int __user *usockaddr_len, int peer);
>  extern int __sys_socketpair(int family, int type, int protocol,
> diff --git a/net/socket.c b/net/socket.c
> index ee438b9425da..9c110b529cdd 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2127,6 +2127,24 @@ SYSCALL_DEFINE3(connect, int, fd, struct sockaddr =
__user *, uservaddr,
>         return __sys_connect(fd, uservaddr, addrlen);
>  }
>
> +int do_getsockname(struct socket *sock, struct sockaddr_storage *address=
, int peer,
> +                  struct sockaddr __user *usockaddr, int __user *usockad=
dr_len)
> +{
> +       int err;
> +
> +       if (peer)
> +               err =3D security_socket_getpeername(sock);
> +       else
> +               err =3D security_socket_getsockname(sock);
> +       if (err)
> +               return err;
> +       err =3D READ_ONCE(sock->ops)->getname(sock, (struct sockaddr *)ad=
dress, peer);
> +       if (err < 0)
> +               return err;
> +       /* "err" is actually length in this case */
> +       return move_addr_to_user(address, err, usockaddr, usockaddr_len);
> +}
> +
>  /*
>   *     Get the address (remote or local ('name')) of a socket object. Mo=
ve the
>   *     obtained name to user space.
> @@ -2137,27 +2155,13 @@ int __sys_getsockname(int fd, struct sockaddr __u=
ser *usockaddr,
>         struct socket *sock;
>         struct sockaddr_storage address;

Could you move this to do_getsockname() ?

The patch 3 also does not need to define it.


>         CLASS(fd, f)(fd);
> -       int err;
>
>         if (fd_empty(f))
>                 return -EBADF;
>         sock =3D sock_from_file(fd_file(f));
>         if (unlikely(!sock))
>                 return -ENOTSOCK;
> -
> -       if (peer)
> -               err =3D security_socket_getpeername(sock);
> -       else
> -               err =3D security_socket_getsockname(sock);
> -       if (err)
> -               return err;
> -
> -       err =3D READ_ONCE(sock->ops)->getname(sock, (struct sockaddr *)&a=
ddress, peer);
> -       if (err < 0)
> -               return err;
> -
> -       /* "err" is actually length in this case */
> -       return move_addr_to_user(&address, err, usockaddr, usockaddr_len)=
;
> +       return do_getsockname(sock, &address, peer, usockaddr, usockaddr_=
len);
>  }
>
>  SYSCALL_DEFINE3(getsockname, int, fd, struct sockaddr __user *, usockadd=
r,
> --
> 2.51.0
>

