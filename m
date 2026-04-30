Return-Path: <io-uring+bounces-13186-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AGEUNcq48mnxtgEAu9opvQ
	(envelope-from <io-uring+bounces-13186-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 04:04:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CD4449C322
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 04:04:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6F3433018C36
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 02:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90ADF2765FF;
	Thu, 30 Apr 2026 02:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U1hhz6fP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC2D299A82
	for <io-uring@vger.kernel.org>; Thu, 30 Apr 2026 02:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777514680; cv=pass; b=uAXaYrhjvWjI0rtjUZN7LCnXqZIy6vdrUS604hbPXVqnM42ugnBrzA09QqH6djMBJxAAVBMZ5zEUqclU3cBqHqIBw/eJ5ynnDZj2bgmyXGSPMVy4q4XLtenrUMQB0E5twg849gX20nYusHzo/y6JkmWOxo8N8RWntmdv4xLA+Vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777514680; c=relaxed/simple;
	bh=JfRn7LeEM2Z4wOW+xEk0Arv/D81Qc9qMKhr4etxYk3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rBqYAmQ2SM0Ssl+zre2VwHRtz3gBoMizejLdF/1waK+IdoYNMr/oYHe6dWOeRuwHaHgyUOyf711yYmlX+mL+Gpf7aJ/SQ1MzI5O9eOwgfrpkm1UUAu36QSwV1peB+oz9C62wGI7Ha2oUi4JzV6iBuRiYgtuTDEQzMz7t4KCzRyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U1hhz6fP; arc=pass smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-12db7bf1541so622695c88.0
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 19:04:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777514678; cv=none;
        d=google.com; s=arc-20240605;
        b=BZ9ldHp478RvXQG+fLZTqBxfQD1cI6NyroSEw//Ryn+e0kMjjnTwPpiV7SKFEwR0R7
         /Eai8/Gd6TzpSFmthqinUEvJ/LaM2QRlieAbCO2EZSzZ5HjZ33fSkhjSsaEiwtk9Mc6e
         OdYDKaK3Cs4Wh9Xaz1tjGn8IX/Fm7+QjY6KN/tx8SpBC7UwqcwNt2xcFE/zFDTgB+xx9
         L5tfBvmAu8TPdb35xryxAB8XuBR4b3Ygrjq4kbhjbkBvTlHA/W3ir5m8zs7aSu6Hy29Z
         MFl1lTa/g7jPNfZppLazJOMZgzlvaTXTlQna50zA6Fz2BRxlMXBMdRKmFO3OP2d0pPpc
         Ca/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aDxeCxdQ9PGx9KNRHGpF+PZcTI/LTfYCvsCotQDae10=;
        fh=wq0AZngtqbWGQTR/8YjlV1ygGH3RdhwcT3Nrlp5p7X0=;
        b=HuyNIdpD2q8XWe6Kzl/o6r00AHEnIaqPZ6B2AXUVrLtFNJ/pIR5iid90vUAjPuOb0r
         Azf+S5UfWFgoZW/sYA0LKfS6ieeNnqz+pMknRZQp6bKjabP0gIQYNJFCRRUCcvarrZ5l
         BeAWE88u+MexWXbnkv67cJ8k+cB0D8tsmZf6OBiXRr2pARtz/h7YwGE772rbJM+j/y5k
         N9zW2xp4yYtZ2ViJ49Tf4vsDCyt7RnLf6xBYHNAaJPDfxvVeasM4C4EnYkkWHwPh2GjN
         2mvXjz4G56C/hpBajfO1eFvlEEwb9SfrBpiOOzCxkqq/nr2Z6b+HpGBFnkq58JNInEpQ
         /OBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777514678; x=1778119478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aDxeCxdQ9PGx9KNRHGpF+PZcTI/LTfYCvsCotQDae10=;
        b=U1hhz6fPkfkahO3PD7pkb22O9UuU4UHLtZX5buZCGkfK4Q1UAj2IOPDokuIfihtSfz
         OzPQCgegR+allVMs9nNqYuDBEO0+t0sqGKqOOmlbLhEmpV7heY2qslvMACMmIhc51dX6
         ExyofCwvHWwain6KqPv26Kb4QBDkJsv6YwHJ4Y5TuIDVqDONz7CSqn1AXIGzdD6ioGTR
         PN/uBTxI5xH13pUM1pYjOf1FHqSJS4obxe/50hqLJvyn8NRQfxOKNTNXtjRzFjVIv3ml
         zFUPZEtkHI+z4applbL9kZ8C+nIaXQxzfPzI9bniWG3LxaUR2dUmlgNTY51XVGz6lC4Y
         DBtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777514678; x=1778119478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aDxeCxdQ9PGx9KNRHGpF+PZcTI/LTfYCvsCotQDae10=;
        b=d08mxaFiuQxaK4t0FTI4GEzyEzXaDUVu8ih6UbD643+/G3MvX24EC43srZnp0Lushm
         BH0e7MCGygEbZS8JsxHgJezHbWEssec1gdOqKdRBB/11RN3SSnPLjFBIcIcUAAga87Ph
         0fmUWVKJnTFSFDNs1cIbjBi7RBkb3JyVQpLmqPL+Xi89GLPevWsSIFHB5DwRiRocwHT7
         EJyAUwVO5bZVn6ISBSYH++7kjH8lq26Qsx+eqCDqf1pMsL+7YGVvCRVLn5YQIvJ0xzjB
         35a3ZiSE6Teu5cg2NqQZzcsdIYQ46T5CCtcbzfREUgulf5FhQQXe9I8TauHIhzraDsFc
         AOGQ==
X-Forwarded-Encrypted: i=1; AFNElJ8kTpUBKQsIy8GdUpu97jnvy4SJ5YswzgPc7oy/niLBwfobaMBm+rclyEiri7u2kbMMPynb04qvzA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHa9q41dw6tCTKy4e3H02vdQEGl8AaBbqlLJBE/HGU9MDNwb+9
	hxFFk+0AXuD4YMrsDzzU7sKOTYXu+5M8nKnUmtqZAFMpEZMYjlD4UpMmLjNcts63RABkMiq0g6o
	WknFvzfHAaBpWPZ+08qnmw6eeCKzoGHqdCnEWJ6XS
X-Gm-Gg: AeBDiesAFxId6M6VMW1WxPY9hYhFiCdP+QRzi+UkCHN2U2d9/4VQNjI/cF2Xik64VI1
	L6ghW04mH3CyF0y4wHWDMjBYJ+9FizmdxiuFR0DPOl3fxRz9ZkQu9ci3M9LVi/NJq8qq9WRZ9j7
	fY07XjPTHCxmc1Hsyr4epnBSgq0+T/58DUPgVWbVXgTmg8qt3hXgL5tXnJ5bf/W0Ml2UxLS6gFc
	WVQDHN4xRaT+5jdxiSw1ogTSvErY5MJxpmIv8jMTSqZsK86014pgUsb6Y4LEX07q0FPKUqcWAUA
	mEV61yW7b3QGpUQFS/kn1iuT+pO2ogPX972ZFIgAACRXtpdwe+asrdDWwGJuoDq0QjXqt8f2k1x
	iwwiQFp0MwmFTvyfe07FUfm2ZiBn8kTEYdjpIxHh70YF5t7OKE3qS15uory6DpSF+l5GhNrRE8Q
	==
X-Received: by 2002:a05:7022:207:b0:12d:ceaf:ffcc with SMTP id
 a92af1059eb24-12deac3aa70mr554238c88.5.1777514677240; Wed, 29 Apr 2026
 19:04:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428175125.2705296-1-jkoolstra@xs4all.nl> <20260428175125.2705296-2-jkoolstra@xs4all.nl>
In-Reply-To: <20260428175125.2705296-2-jkoolstra@xs4all.nl>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 29 Apr 2026 19:04:25 -0700
X-Gm-Features: AVHnY4JYACaJ3lOY3vhTsY9K5_lOk4dNnlzp9D9zNaCs3b5RV1wtvUbOZutFyfk
Message-ID: <CAAVpQUBKeN2KtRkRAFr8sYJM1_-rbkdjsujau5fAyaiP_dO6FA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] net: af_unix: Useful handling of LSM denials on SCM_RIGHTS
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@kernel.dk>, Kees Cook <kees@kernel.org>, 
	Simon Horman <horms@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, 
	Jeff Layton <jlayton@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Andrei Vagin <avagin@gmail.com>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Mateusz Guzik <mjguzik@gmail.com>, 
	Joel Granados <joel.granados@kernel.org>, Charlie Mirabile <cmirabil@redhat.com>, 
	Aleksa Sarai <cyphar@cyphar.com>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5CD4449C322
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13186-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[xs4all.nl];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	FREEMAIL_CC(0.00)[zeniv.linux.org.uk,kernel.org,suse.cz,google.com,redhat.com,davemloft.net,kernel.dk,amacapital.net,chromium.org,gmail.com,virtuozzo.com,cyphar.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuniyu@google.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[xs4all.nl:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]

On Tue, Apr 28, 2026 at 10:51=E2=80=AFAM Jori Koolstra <jkoolstra@xs4all.nl=
> wrote:
>
> Right now if some LSM such as Smack denies an AF_UNIX socket peer to
> receive an SCM_RIGHTS fd the SCM_RIGHTS fd array will be cut short at
> that point, and MSG_CTRUNC is set on return of recvmsg(). This is
> highly problematic behaviour, because it leaves the receiver
> wondering what happened. As per man page MSG_CTRUNC is supposed to
> indicate that the control buffer was sized too short, but suddenly
> a permission error might result in the exact same flag being set.
> Moreover, the receiver has no chance to determine how many fds got
> originally sent and how many were suppressed.[1]
>
> Add two MSG_* flags:

Since we only have 5 bits remaining for future extension,
we need to consider the use case a bit more carefully.


>  - MSG_RIGHTS_DENIAL is set whenever any file is rejected by the LSM
>    during recvmsg() of SCM_RIGHTS fds.

Is this really needed ?

Even if the fd array is truncated, the application will traverse
the array anyway since it has some fds already installed (to
clean up in case of MSG_CTRUNC ?).

Then, it will find the -EPERM entry.

I assume no one uses MSG_RIGHTS_DENIAL without
MSG_RIGHTS_FILTER.


>  - If MSG_RIGHTS_FILTER is passed as a flag to recvmsg(), the SCM_RIGHTS

Does this flag need per-recvmsg() granularity ?

If the application does not welcome the truncated fd array,
it would have passed MSG_RIGHTS_FILTER to every
recvmsg(), no ?

( and I feel _FILTER sounds like "please do filtering (truncase)".
  Maybe _NOTRUNC ? )


>    fd array is always passed in its full original size. However, any
>    files rejected by the LSM are replaced in this array with -EPERM
>    instead of an assigned fd, while keeping the original order. If the
>    flag is not set, the original truncate behavior is used.
>
> [1]: https://github.com/uapi-group/kernel-features#useful-handling-of-lsm=
-denials-on-scm_rights
>
> Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
> ---
>  fs/file.c              | 21 ++++++++++++++++++---
>  include/linux/file.h   |  4 +++-
>  include/linux/socket.h |  3 +++
>  include/net/scm.h      |  8 ++++----
>  io_uring/openclose.c   |  2 +-
>  kernel/pid.c           |  2 +-
>  kernel/seccomp.c       |  2 +-
>  net/compat.c           |  7 ++++---
>  net/core/scm.c         | 11 ++++++-----
>  9 files changed, 41 insertions(+), 19 deletions(-)
>
> diff --git a/fs/file.c b/fs/file.c
> index 2c81c0b162d0..cc33a1e77049 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -1370,10 +1370,11 @@ int replace_fd(unsigned fd, struct file *file, un=
signed flags)
>  }
>
>  /**
> - * receive_fd() - Install received file into file descriptor table
> + * receive_fd_msg() - Install received file into file descriptor table
>   * @file: struct file that was received from another process
>   * @ufd: __user pointer to write new fd number to
>   * @o_flags: the O_* flags to apply to the new fd entry
> + * @msg_flags: the MSG_* flags to set for recvmsg(2)
>   *
>   * Installs a received file into the file descriptor table, with appropr=
iate
>   * checks and count updates. Optionally writes the fd number to userspac=
e, if
> @@ -1384,13 +1385,21 @@ int replace_fd(unsigned fd, struct file *file, un=
signed flags)
>   *
>   * Returns newly install fd or -ve on error.
>   */
> -int receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
> +int receive_fd_msg(struct file *file, int __user *ufd, unsigned int o_fl=
ags,
> +              unsigned int *msg_flags)
>  {
>         int error;
>
>         error =3D security_file_receive(file);
> -       if (error)
> +       if (error) {
> +               if (msg_flags)
> +                       *msg_flags |=3D MSG_RIGHTS_DENIAL;
> +
> +               if (ufd)
> +                       put_user(-EPERM, ufd);
> +
>                 return error;
> +       }
>
>         FD_PREPARE(fdf, o_flags, file);
>         if (fdf.err)
> @@ -1406,6 +1415,12 @@ int receive_fd(struct file *file, int __user *ufd,=
 unsigned int o_flags)
>         __receive_sock(fd_prepare_file(fdf));
>         return fd_publish(fdf);
>  }
> +EXPORT_SYMBOL_GPL(receive_fd_msg);
> +
> +int receive_fd(struct file *file, unsigned int o_flags)
> +{
> +       return receive_fd_msg(file, NULL, o_flags, NULL);
> +}
>  EXPORT_SYMBOL_GPL(receive_fd);
>
>  int receive_fd_replace(int new_fd, struct file *file, unsigned int o_fla=
gs)
> diff --git a/include/linux/file.h b/include/linux/file.h
> index 27484b444d31..38f022d997a6 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -118,7 +118,9 @@ DEFINE_FREE(fput, struct file *, if (!IS_ERR_OR_NULL(=
_T)) fput(_T))
>
>  extern void fd_install(unsigned int fd, struct file *file);
>
> -int receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)=
;
> +int receive_fd_msg(struct file *file, int __user *ufd, unsigned int o_fl=
ags,
> +                  unsigned int *msg_flags);
> +int receive_fd(struct file *file, unsigned int o_flags);
>
>  int receive_fd_replace(int new_fd, struct file *file, unsigned int o_fla=
gs);
>
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index ec4a0a025793..3809a8add2fc 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -342,6 +342,9 @@ struct ucred {
>                                           * plain text and require encryp=
tion
>                                           */
>
> +#define MSG_RIGHTS_DENIAL 0x200000
> +#define MSG_RIGHTS_FILTER 0x400000
> +
>  #define MSG_SOCK_DEVMEM 0x2000000      /* Receive devmem skbs as cmsg */
>  #define MSG_ZEROCOPY   0x4000000       /* Use user data in kernel path *=
/
>  #define MSG_SPLICE_PAGES 0x8000000     /* Splice the pages from the iter=
ator in sendmsg() */
> diff --git a/include/net/scm.h b/include/net/scm.h
> index c52519669349..983efa952c8e 100644
> --- a/include/net/scm.h
> +++ b/include/net/scm.h
> @@ -50,8 +50,8 @@ struct scm_cookie {
>  #endif
>  };
>
> -void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm);
> -void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm);
> +void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm, int recv=
_flags);
> +void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm, i=
nt recv_flags);
>  int __scm_send(struct socket *sock, struct msghdr *msg, struct scm_cooki=
e *scm);
>  void __scm_destroy(struct scm_cookie *scm);
>  struct scm_fp_list *scm_fp_dup(struct scm_fp_list *fpl);
> @@ -108,11 +108,11 @@ void scm_recv_unix(struct socket *sock, struct msgh=
dr *msg,
>                    struct scm_cookie *scm, int flags);
>
>  static inline int scm_recv_one_fd(struct file *f, int __user *ufd,
> -                                 unsigned int flags)
> +                                 unsigned int o_flags, unsigned int *msg=
_flags)
>  {
>         if (!ufd)
>                 return -EFAULT;
> -       return receive_fd(f, ufd, flags);
> +       return receive_fd_msg(f, ufd, o_flags, msg_flags);
>  }
>
>  #endif /* __LINUX_NET_SCM_H */
> diff --git a/io_uring/openclose.c b/io_uring/openclose.c
> index c71242915dad..1b6cb05b0e3d 100644
> --- a/io_uring/openclose.c
> +++ b/io_uring/openclose.c
> @@ -308,7 +308,7 @@ int io_install_fixed_fd(struct io_kiocb *req, unsigne=
d int issue_flags)
>         int ret;
>
>         ifi =3D io_kiocb_to_cmd(req, struct io_fixed_install);
> -       ret =3D receive_fd(req->file, NULL, ifi->o_flags);
> +       ret =3D receive_fd(req->file, ifi->o_flags);
>         if (ret < 0)
>                 req_set_fail(req);
>         io_req_set_res(req, ret, 0);
> diff --git a/kernel/pid.c b/kernel/pid.c
> index fd5c2d4aa349..62af6874192d 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -929,7 +929,7 @@ static int pidfd_getfd(struct pid *pid, int fd)
>         if (IS_ERR(file))
>                 return PTR_ERR(file);
>
> -       ret =3D receive_fd(file, NULL, O_CLOEXEC);
> +       ret =3D receive_fd(file, O_CLOEXEC);
>         fput(file);
>
>         return ret;
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 066909393c38..ad5ab16fe2b1 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -1130,7 +1130,7 @@ static void seccomp_handle_addfd(struct seccomp_kad=
dfd *addfd, struct seccomp_kn
>          */
>         list_del_init(&addfd->list);
>         if (!addfd->setfd)
> -               fd =3D receive_fd(addfd->file, NULL, addfd->flags);
> +               fd =3D receive_fd(addfd->file, addfd->flags);
>         else
>                 fd =3D receive_fd_replace(addfd->fd, addfd->file, addfd->=
flags);
>         addfd->ret =3D fd;
> diff --git a/net/compat.c b/net/compat.c
> index 2c9bd0edac99..056bce0927c4 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -287,18 +287,19 @@ static int scm_max_fds_compat(struct msghdr *msg)
>         return (msg->msg_controllen - sizeof(struct compat_cmsghdr)) / si=
zeof(int);
>  }
>
> -void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
> +void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm, i=
nt recv_flags)
>  {
>         struct compat_cmsghdr __user *cm =3D
>                 (struct compat_cmsghdr __user *)msg->msg_control_user;
>         unsigned int o_flags =3D (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_=
CLOEXEC : 0;
> +       bool filter_rights =3D recv_flags & MSG_RIGHTS_FILTER;
>         int fdmax =3D min_t(int, scm_max_fds_compat(msg), scm->fp->count)=
;
>         int __user *cmsg_data =3D CMSG_COMPAT_DATA(cm);
>         int err =3D 0, i;
>
>         for (i =3D 0; i < fdmax; i++) {
> -               err =3D scm_recv_one_fd(scm->fp->fp[i], cmsg_data + i, o_=
flags);
> -               if (err < 0)
> +               err =3D scm_recv_one_fd(scm->fp->fp[i], cmsg_data + i, o_=
flags, &msg->msg_flags);
> +               if (err < 0 && !filter_rights)
>                         break;
>         }
>
> diff --git a/net/core/scm.c b/net/core/scm.c
> index eec13f50ecaf..035329645d8f 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -351,10 +351,11 @@ static int scm_max_fds(struct msghdr *msg)
>         return (msg->msg_controllen - sizeof(struct cmsghdr)) / sizeof(in=
t);
>  }
>
> -void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
> +void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm, int recv=
_flags)
>  {
>         struct cmsghdr __user *cm =3D
>                 (__force struct cmsghdr __user *)msg->msg_control_user;
> +       bool filter_rights =3D recv_flags & MSG_RIGHTS_FILTER;
>         unsigned int o_flags =3D (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_=
CLOEXEC : 0;
>         int fdmax =3D min_t(int, scm_max_fds(msg), scm->fp->count);
>         int __user *cmsg_data =3D CMSG_USER_DATA(cm);
> @@ -365,13 +366,13 @@ void scm_detach_fds(struct msghdr *msg, struct scm_=
cookie *scm)
>                 return;
>
>         if (msg->msg_flags & MSG_CMSG_COMPAT) {
> -               scm_detach_fds_compat(msg, scm);
> +               scm_detach_fds_compat(msg, scm, recv_flags);
>                 return;
>         }
>
>         for (i =3D 0; i < fdmax; i++) {
> -               err =3D scm_recv_one_fd(scm->fp->fp[i], cmsg_data + i, o_=
flags);
> -               if (err < 0)
> +               err =3D scm_recv_one_fd(scm->fp->fp[i], cmsg_data + i, o_=
flags, &msg->msg_flags);
> +               if (err < 0 && !filter_rights)
>                         break;
>         }
>
> @@ -524,7 +525,7 @@ static bool __scm_recv_common(struct sock *sk, struct=
 msghdr *msg,
>         scm_passec(sk, msg, scm);
>
>         if (scm->fp)
> -               scm_detach_fds(msg, scm);
> +               scm_detach_fds(msg, scm, flags);
>
>         return true;
>  }
> --
> 2.54.0
>

