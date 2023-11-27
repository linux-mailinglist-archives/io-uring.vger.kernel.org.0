Return-Path: <io-uring+bounces-154-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED72E7F9C60
	for <lists+io-uring@lfdr.de>; Mon, 27 Nov 2023 10:08:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 72213B20D83
	for <lists+io-uring@lfdr.de>; Mon, 27 Nov 2023 09:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D013B12E50;
	Mon, 27 Nov 2023 09:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LxGTuOln"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9F1111
	for <io-uring@vger.kernel.org>; Mon, 27 Nov 2023 01:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701076085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8UzLKe3MZHXpdSNSglco220DD3bo0944FEKr1A6zn/8=;
	b=LxGTuOln4vVQBSqpU2N0awh9MXWz4R/NxBQgA349dvvkFcYghrNNKoWWvfRu/UOCh1MoRU
	5ZY7kZiSog1M3NvVZTccvbflYoDSasBrFE2VeMjkkMfmSGvphCZKvQxhfXIuaNAPtJ4CWc
	g30PmBLH92cWeecbUhzVT0fALBAcItA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-uR2J_n0HNCOE9WjflMiLNQ-1; Mon, 27 Nov 2023 04:08:03 -0500
X-MC-Unique: uR2J_n0HNCOE9WjflMiLNQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a10bbc8f905so6945866b.1
        for <io-uring@vger.kernel.org>; Mon, 27 Nov 2023 01:08:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701076082; x=1701680882;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8UzLKe3MZHXpdSNSglco220DD3bo0944FEKr1A6zn/8=;
        b=UOTPGMncbQ8r4fQRRAzGpJu28ot9QMHIe6Ipg7XBN0tzQyiK4Tgs/vvejWtlyfLSE+
         jVYmgPln4lVFMH74P1LTLADGQHSHAQzDf/ELVk77K/hG1ONmkIcDwqhl9AKaIytvKaLW
         KAnAII1gzhqxZkNuoWOPoDMcPcUdEGxDPAtDffnN73L+q++nwuXvEAWa3HMTjtSRnYcA
         MBsLgR9OE+nhW0n5X21Cg/RuPwfJqzuiLvA5o9gFvxCvL5JrXRIuvrJKHTtpr9/kSmZ6
         ZX1Qr9DbIpGfErc8MjFs2i7FvWTIZWfTKMha7ZAsGra5bok2K24hhK94MwbhDuiHPMOB
         6bNw==
X-Gm-Message-State: AOJu0Yzx0R5IL79O3y7PWaDrfsKVpNUwrqOIQhIuD4gwsnkw3kS3/eTL
	cQ94+MerX0G0S8QlbJQ3cewK3HZ2HCpaVzgJM4OuffI312K24D/9m5rFXcck8I/HPp/HXSfhyI+
	pX9cn3NKfmwSOewhzr0g=
X-Received: by 2002:a17:906:f807:b0:9d0:51d4:4dc6 with SMTP id kh7-20020a170906f80700b009d051d44dc6mr6686833ejb.2.1701076082639;
        Mon, 27 Nov 2023 01:08:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGYqbx6PiDPnvS3tr7Qk3o+tZ1tS7gUn06WfMqd9DfKx40Agce7Xti/RXxgVPS5PgH9purh8w==
X-Received: by 2002:a17:906:f807:b0:9d0:51d4:4dc6 with SMTP id kh7-20020a170906f80700b009d051d44dc6mr6686809ejb.2.1701076082258;
        Mon, 27 Nov 2023 01:08:02 -0800 (PST)
Received: from gerbillo.redhat.com (host-87-11-7-253.retail.telecomitalia.it. [87.11.7.253])
        by smtp.gmail.com with ESMTPSA id p18-20020a1709061b5200b009b9a1714524sm5540847ejg.12.2023.11.27.01.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 01:08:01 -0800 (PST)
Message-ID: <df0620741383dd4506d478a5a7adcb8b8f63fd67.camel@redhat.com>
Subject: Re: [PATCH v2 net-next 2/4] af_unix: Return struct unix_sock from
 unix_get_socket().
From: Paolo Abeni <pabeni@redhat.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>, "David S. Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>
Cc: Ivan Babrou <ivan@cloudflare.com>, Kuniyuki Iwashima
 <kuni1840@gmail.com>,  netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org
Date: Mon, 27 Nov 2023 10:08:00 +0100
In-Reply-To: <20231123014747.66063-3-kuniyu@amazon.com>
References: <20231123014747.66063-1-kuniyu@amazon.com>
	 <20231123014747.66063-3-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2023-11-22 at 17:47 -0800, Kuniyuki Iwashima wrote:
> Currently, unix_get_socket() returns struct sock, but after calling
> it, we always cast it to unix_sk().
>=20
> Let's return struct unix_sock from unix_get_socket().
>=20
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/linux/io_uring.h |  4 ++--
>  include/net/af_unix.h    |  2 +-
>  io_uring/io_uring.c      |  5 +++--
>  net/unix/garbage.c       | 19 +++++++------------
>  net/unix/scm.c           | 26 +++++++++++---------------
>  5 files changed, 24 insertions(+), 32 deletions(-)
>=20
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index aefb73eeeebf..be16677f0e4c 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -54,7 +54,7 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long l=
en, int rw,
>  			      struct iov_iter *iter, void *ioucmd);
>  void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t re=
s2,
>  			unsigned issue_flags);
> -struct sock *io_uring_get_socket(struct file *file);
> +struct unix_sock *io_uring_get_socket(struct file *file);
>  void __io_uring_cancel(bool cancel_all);
>  void __io_uring_free(struct task_struct *tsk);
>  void io_uring_unreg_ringfd(void);
> @@ -111,7 +111,7 @@ static inline void io_uring_cmd_do_in_task_lazy(struc=
t io_uring_cmd *ioucmd,
>  			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>  {
>  }
> -static inline struct sock *io_uring_get_socket(struct file *file)
> +static inline struct unix_sock *io_uring_get_socket(struct file *file)
>  {
>  	return NULL;
>  }
> diff --git a/include/net/af_unix.h b/include/net/af_unix.h
> index 5a8a670b1920..c628d30ceb19 100644
> --- a/include/net/af_unix.h
> +++ b/include/net/af_unix.h
> @@ -14,7 +14,7 @@ void unix_destruct_scm(struct sk_buff *skb);
>  void io_uring_destruct_scm(struct sk_buff *skb);
>  void unix_gc(void);
>  void wait_for_unix_gc(void);
> -struct sock *unix_get_socket(struct file *filp);
> +struct unix_sock *unix_get_socket(struct file *filp);
>  struct sock *unix_peer_get(struct sock *sk);
> =20
>  #define UNIX_HASH_MOD	(256 - 1)
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index ed254076c723..daed897f5975 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -177,13 +177,14 @@ static struct ctl_table kernel_io_uring_disabled_ta=
ble[] =3D {
>  };
>  #endif
> =20
> -struct sock *io_uring_get_socket(struct file *file)
> +struct unix_sock *io_uring_get_socket(struct file *file)
>  {
>  #if defined(CONFIG_UNIX)
>  	if (io_is_uring_fops(file)) {
>  		struct io_ring_ctx *ctx =3D file->private_data;
> =20
> -		return ctx->ring_sock->sk;
> +		if (ctx->ring_sock->sk)
> +			return unix_sk(ctx->ring_sock->sk);
>  	}
>  #endif
>  	return NULL;
> diff --git a/net/unix/garbage.c b/net/unix/garbage.c
> index db1bb99bb793..4d634f5f6a55 100644
> --- a/net/unix/garbage.c
> +++ b/net/unix/garbage.c
> @@ -105,20 +105,15 @@ static void scan_inflight(struct sock *x, void (*fu=
nc)(struct unix_sock *),
> =20
>  			while (nfd--) {
>  				/* Get the socket the fd matches if it indeed does so */
> -				struct sock *sk =3D unix_get_socket(*fp++);
> +				struct unix_sock *u =3D unix_get_socket(*fp++);
> =20
> -				if (sk) {
> -					struct unix_sock *u =3D unix_sk(sk);
> +				/* Ignore non-candidates, they could have been added
> +				 * to the queues after starting the garbage collection
> +				 */
> +				if (u && test_bit(UNIX_GC_CANDIDATE, &u->gc_flags)) {
> +					hit =3D true;
> =20
> -					/* Ignore non-candidates, they could
> -					 * have been added to the queues after
> -					 * starting the garbage collection
> -					 */
> -					if (test_bit(UNIX_GC_CANDIDATE, &u->gc_flags)) {
> -						hit =3D true;
> -
> -						func(u);
> -					}
> +					func(u);
>  				}
>  			}
>  			if (hit && hitlist !=3D NULL) {
> diff --git a/net/unix/scm.c b/net/unix/scm.c
> index 4b3979272a81..36ce8fed9acc 100644
> --- a/net/unix/scm.c
> +++ b/net/unix/scm.c
> @@ -21,9 +21,8 @@ EXPORT_SYMBOL(gc_inflight_list);
>  DEFINE_SPINLOCK(unix_gc_lock);
>  EXPORT_SYMBOL(unix_gc_lock);
> =20
> -struct sock *unix_get_socket(struct file *filp)
> +struct unix_sock *unix_get_socket(struct file *filp)
>  {
> -	struct sock *u_sock =3D NULL;
>  	struct inode *inode =3D file_inode(filp);
> =20
>  	/* Socket ? */
> @@ -34,12 +33,13 @@ struct sock *unix_get_socket(struct file *filp)
> =20
>  		/* PF_UNIX ? */
>  		if (s && ops && ops->family =3D=3D PF_UNIX)
> -			u_sock =3D s;
> -	} else {
> -		/* Could be an io_uring instance */
> -		u_sock =3D io_uring_get_socket(filp);
> +			return unix_sk(s);
> +
> +		return NULL;
>  	}
> -	return u_sock;
> +
> +	/* Could be an io_uring instance */
> +	return io_uring_get_socket(filp);
>  }
>  EXPORT_SYMBOL(unix_get_socket);
> =20
> @@ -48,13 +48,11 @@ EXPORT_SYMBOL(unix_get_socket);
>   */
>  void unix_inflight(struct user_struct *user, struct file *fp)
>  {
> -	struct sock *s =3D unix_get_socket(fp);
> +	struct unix_sock *u =3D unix_get_socket(fp);
> =20
>  	spin_lock(&unix_gc_lock);
> =20
> -	if (s) {
> -		struct unix_sock *u =3D unix_sk(s);
> -
> +	if (u) {
>  		if (!u->inflight) {
>  			BUG_ON(!list_empty(&u->link));
>  			list_add_tail(&u->link, &gc_inflight_list);
> @@ -71,13 +69,11 @@ void unix_inflight(struct user_struct *user, struct f=
ile *fp)
> =20
>  void unix_notinflight(struct user_struct *user, struct file *fp)
>  {
> -	struct sock *s =3D unix_get_socket(fp);
> +	struct unix_sock *u =3D unix_get_socket(fp);
> =20
>  	spin_lock(&unix_gc_lock);
> =20
> -	if (s) {
> -		struct unix_sock *u =3D unix_sk(s);
> -
> +	if (u) {
>  		BUG_ON(!u->inflight);
>  		BUG_ON(list_empty(&u->link));
> =20

Adding the io_uring peoples to the recipient list for awareness. I
guess this deserves an explicit ack from them.

Cheers,

Paolo



