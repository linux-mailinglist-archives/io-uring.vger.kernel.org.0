Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8AA18EA0A
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 17:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgCVQK3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 12:10:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40854 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgCVQK2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 12:10:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id a81so6025011wmf.5
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 09:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=zIjepPrUYR031Gae0NXzl6VTC/hxlOwV1PvN6JXsefM=;
        b=Ib5gnvHrvk4iHAd1EdIY9+cXnPzovdqeHbxI6+Vj4Lshd0OVM+pecg3D+fy+Y7k0er
         hWi9vuPfgSGA9E/GmGYnL4lyeqKiaE0gtQY3EwvAwjqnJeHeFROgwPZCsS0k3d+A5q7C
         qPQP/3sLGeFdVVdC+8XsdKAtsi7ytTpHLZrQ4g0xYMZvJiOvwAbWnwcVdEKFsjMy0XKO
         +phXLXRDXmXs4QXPKjnwJ/x8tK5cFH301HgfTqNHj870gwnm829YW4LNDj6WXzHTU091
         5G8osPiC1JTqoYWpNFkaY4OBbThbpSc+z+r5fdjUtitQJ5yg9vBCpw25S8PQyaxbf6zU
         nBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=zIjepPrUYR031Gae0NXzl6VTC/hxlOwV1PvN6JXsefM=;
        b=pfVQ5C+M9yLuLOAuf6WjTogW4wb6ubhzrS05ZSXalWTqmrmpuXXNtQ7J6Vs2MCjXPh
         OuSde/dRlspEW7VjFq43zaQuRQszyI3J36x9zbXbIiGWK7J/bGjnupaixbCpUKYNQ9yM
         N5u2VEv24KiQBKL3wDYn6+MwzcMzMYMhr26it+P2tUDcq/VoTs00i5zOrl7x4hm+k6br
         /yrBYbrZy1mDnxFu4YXVVQlyZQoZy8ycx4IlqpjJtG11KTUx6aNobkvCoVrKYJYPdaCr
         iYhd3cvrDrMaVCzypw+edQh2dVxoMrF89NHRholtuiqdJjR4wEyTjYsspI4zH+v5NHO9
         t2zQ==
X-Gm-Message-State: ANhLgQ1nUOoN9Z9KS2fGn/0vDdFm1YpBXN5ZJ7x+8Srq4AHLleOK2Ilt
        OqSeu+2sWtCVydGlPaE31hNFNdKq
X-Google-Smtp-Source: ADFU+vuMaDgQm95nXForr1qmW9N+nnayeTr0ojQ+mnkD19acp/iScndP5eRjFAGWyM0Wt7u+dHXScA==
X-Received: by 2002:a1c:98c4:: with SMTP id a187mr1255964wme.76.1584893425136;
        Sun, 22 Mar 2020 09:10:25 -0700 (PDT)
Received: from [192.168.43.79] ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id z16sm1804642wrr.56.2020.03.22.09.10.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 09:10:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
Message-ID: <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
Date:   Sun, 22 Mar 2020 19:09:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Yj6XZbhePISBx71z0LgcALE4xSt16GCkX"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Yj6XZbhePISBx71z0LgcALE4xSt16GCkX
Content-Type: multipart/mixed; boundary="9EEEA1UikRfWHDWT9DPhDUwK1MqSFa4vZ";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
In-Reply-To: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>

--9EEEA1UikRfWHDWT9DPhDUwK1MqSFa4vZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 19/03/2020 21:56, Jens Axboe wrote:
> We always punt async buffered writes to an io-wq helper, as the core
> kernel does not have IOCB_NOWAIT support for that. Most buffered async
> writes complete very quickly, as it's just a copy operation. This means=

> that doing multiple locking roundtrips on the shared wqe lock for each
> buffered write is wasteful. Additionally, buffered writes are hashed
> work items, which means that any buffered write to a given file is
> serialized.
>=20
> When looking for a new work item, build a chain of identicaly hashed
> work items, and then hand back that batch. Until the batch is done, the=

> caller doesn't have to synchronize with the wqe or worker locks again.
>=20
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>=20
> ---
>=20
> Changes:
> - Don't overwrite passed back work
>=20
>=20
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 9541df2729de..8402c6e417e1 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -380,32 +380,65 @@ static inline unsigned int io_get_work_hash(struc=
t io_wq_work *work)
>  	return work->flags >> IO_WQ_HASH_SHIFT;
>  }
> =20
> -static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
> +/*
> + * Returns the next work item to process, if any. For hashed work that=
 hash
> + * to the same key, we can't process N+1 before N is done. To make the=

> + * processing more efficient, return N+1 and later identically hashed =
work
> + * in the passed in list. This avoids repeated hammering on the wqe lo=
ck for,
> + * as the caller can just process items in the on-stack list.
> + */
> +static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
> +					   struct io_wq_work_list *list)
>  	__must_hold(wqe->lock)
>  {
> -	struct io_wq_work_node *node, *prev;
> -	struct io_wq_work *work;
> -	unsigned int hash;
> +	struct io_wq_work *ret =3D NULL;
> =20
> -	wq_list_for_each(node, prev, &wqe->work_list) {
> -		work =3D container_of(node, struct io_wq_work, list);
> +	do {
> +		unsigned int new_hash, hash;
> +		struct io_wq_work *work;
> +
> +		work =3D wq_first_entry(&wqe->work_list, struct io_wq_work, list);
> +		if (!work)
> +			break;
> =20
>  		/* not hashed, can run anytime */
>  		if (!io_wq_is_hashed(work)) {
> -			wq_node_del(&wqe->work_list, node, prev);
> -			return work;
> +			/* already have hashed work, let new worker get this */
> +			if (ret) {
> +				struct io_wqe_acct *acct;
> +
> +				/* get new worker for unhashed, if none now */
> +				acct =3D io_work_get_acct(wqe, work);
> +				if (!atomic_read(&acct->nr_running))
> +					io_wqe_wake_worker(wqe, acct);
> +				break;
> +			}
> +			wq_node_del(&wqe->work_list, &work->list);
> +			ret =3D work;
> +			break;
>  		}
> =20
>  		/* hashed, can run if not already running */
> -		hash =3D io_get_work_hash(work);
> -		if (!(wqe->hash_map & BIT(hash))) {
> +		new_hash =3D io_get_work_hash(work);
> +		if (wqe->hash_map & BIT(new_hash))
> +			break;

This will always break for subsequent hashed, as the @hash_map bit is set=
=2E
Isn't it? And anyway, it seems it doesn't optimise not-contiguous same-ha=
shed
requests, e.g.

0: Link(hash=3D0)
1: Link(hash=3D1)
2: Link(hash=3D0)
3: Link(not_hashed)
4: Link(hash=3D0)
=2E..

> +
> +		if (!ret) {
> +			hash =3D new_hash;
>  			wqe->hash_map |=3D BIT(hash);
> -			wq_node_del(&wqe->work_list, node, prev);
> -			return work;
> +		} else if (hash !=3D new_hash) {
> +			break;
>  		}
> -	}
> =20
> -	return NULL;
> +		wq_node_del(&wqe->work_list, &work->list);
> +		/* return first node, add subsequent same hash to the list */
> +		if (!ret)
> +			ret =3D work;
> +		else
> +			wq_list_add_tail(&work->list, list);
> +	} while (1);
> +
> +	return ret;
>  }
> =20
>  static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_wor=
k *work)
> @@ -481,6 +514,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, stru=
ct io_wq_work *work);
>  static void io_worker_handle_work(struct io_worker *worker)
>  	__releases(wqe->lock)
>  {
> +	struct io_wq_work_list list =3D { .first =3D NULL, .last =3D NULL };
>  	struct io_wqe *wqe =3D worker->wqe;
>  	struct io_wq *wq =3D wqe->wq;
> =20
> @@ -495,7 +529,7 @@ static void io_worker_handle_work(struct io_worker =
*worker)
>  		 * can't make progress, any work completion or insertion will
>  		 * clear the stalled flag.
>  		 */
> -		work =3D io_get_next_work(wqe);
> +		work =3D io_get_next_work(wqe, &list);
>  		if (work)
>  			__io_worker_busy(wqe, worker, work);
>  		else if (!wq_list_empty(&wqe->work_list))
> @@ -504,6 +538,7 @@ static void io_worker_handle_work(struct io_worker =
*worker)
>  		spin_unlock_irq(&wqe->lock);
>  		if (!work)
>  			break;
> +got_work:
>  		io_assign_current_work(worker, work);
> =20
>  		/* handle a whole dependent link */
> @@ -530,6 +565,24 @@ static void io_worker_handle_work(struct io_worker=
 *worker)
>  				work =3D NULL;
>  			}
>  			if (hash !=3D -1U) {
> +				/*
> +				 * If the local list is non-empty, then we
> +				 * have work that hashed to the same key.
> +				 * No need for a lock round-trip, or fiddling
> +				 * the the free/busy state of the worker, or
> +				 * clearing the hashed state. Just process the
> +				 * next one.
> +				 */
> +				if (!work) {
> +					work =3D wq_first_entry(&list,
> +							      struct io_wq_work,
> +							      list);

Wouldn't it just drop a linked request? Probably works because of the com=
ment above.

> +					if (work) {
> +						wq_node_del(&list, &work->list);

There is a bug, apparently from one of my commits, where it do
io_assign_current_work() but then re-enqueue and reassign new work, thoug=
h there
is a gap for cancel to happen, which would screw everything up.

I'll send a patch, so it'd be more clear. However, this is a good point t=
o look
after for this as well.

> +						goto got_work;
> +					}
> +				}
> +
>  				spin_lock_irq(&wqe->lock);
>  				wqe->hash_map &=3D ~BIT_ULL(hash);
>  				wqe->flags &=3D ~IO_WQE_FLAG_STALLED;
> @@ -910,7 +963,7 @@ static enum io_wq_cancel io_wqe_cancel_work(struct =
io_wqe *wqe,
>  		work =3D container_of(node, struct io_wq_work, list);
> =20
>  		if (match->fn(work, match->data)) {
> -			wq_node_del(&wqe->work_list, node, prev);
> +			__wq_node_del(&wqe->work_list, node, prev);
>  			found =3D true;
>  			break;
>  		}
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index 298b21f4a4d2..9a194339bd9d 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -40,9 +40,9 @@ static inline void wq_list_add_tail(struct io_wq_work=
_node *node,
>  	}
>  }
> =20
> -static inline void wq_node_del(struct io_wq_work_list *list,
> -			       struct io_wq_work_node *node,
> -			       struct io_wq_work_node *prev)
> +static inline void __wq_node_del(struct io_wq_work_list *list,
> +				struct io_wq_work_node *node,
> +				struct io_wq_work_node *prev)
>  {
>  	if (node =3D=3D list->first)
>  		WRITE_ONCE(list->first, node->next);
> @@ -53,6 +53,21 @@ static inline void wq_node_del(struct io_wq_work_lis=
t *list,
>  	node->next =3D NULL;
>  }
> =20
> +
> +static inline void wq_node_del(struct io_wq_work_list *list,
> +			       struct io_wq_work_node *node)
> +{
> +	__wq_node_del(list, node, NULL);
> +}
> +
> +#define wq_first_entry(list, type, member)				\
> +({									\
> +	struct io_wq_work *__work =3D NULL;				\
> +	if (!wq_list_empty((list)))					\
> +		__work =3D container_of((list)->first, type, member);	\
> +	__work;								\
> +})
> +
>  #define wq_list_for_each(pos, prv, head)			\
>  	for (pos =3D (head)->first, prv =3D NULL; pos; prv =3D pos, pos =3D (=
pos)->next)
> =20
>=20

--=20
Pavel Begunkov




--9EEEA1UikRfWHDWT9DPhDUwK1MqSFa4vZ--

--Yj6XZbhePISBx71z0LgcALE4xSt16GCkX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl53jbsACgkQWt5b1Glr
+6XiQg//XnAUcBUAgxwe27lueCOaWw00yTvk+Rkdr6rR6wFlf0LLG1/Y0kCJ+vyG
aobha/1Qa1lurH5zJAMmeA6i9iZsVu6mAQnjMZ1RbYwyF2Rwnj5Ch1Bd+FPTkytR
qyBgcJscBwGnz02BcbbK5GnkXmkmF/8lN5kwM9E5+E212vlLp3DvjBNS3NtFSs4B
HZEPsGbqM6sMc4VRgsQJmzC4QxfRxPDQVWJ7M9rg6RMeG/HoWqZvs8M/08CU1pJ1
JpFcIQtM77jfciHRXOQHA6n9L4+xrhqcM5rXbS4+BO2a2SqDp+ILJ19zYQ89JpoM
1BmR53u90JUQaJE6U5rcPG4clAS9tOBI7AtDxXszM3Qzi0IuMl75y8Iq7MSg7PgD
6I9Px3nJFwKncvouZFoaKD8lnppznfvpcP9G2HEIoxh1gAzGYzTtDPYObVb3Jmwf
HGwN5+Ft4MJ5DED6PtSxq72Fj2gZP+h239w6BhpeF9u50OVK3jHOW0Fb67KcuSfN
PfQgE5v/qH+ZAvYeGacwR41khz4Tmgkk8HNkZC0eQrzytcCJEX/NiEUhUrAZwSAw
httnPowbmJCBoUyy4Qbde5GWlzJHPb85+ieJ1FR/YK+xjXBTE0PUMokAHSwGrmHx
jsA4C+ZGY/kA9R6Or0xLW4iavZ9ev2JyEY/Q+y5ufytAqMd9S08=
=EhKe
-----END PGP SIGNATURE-----

--Yj6XZbhePISBx71z0LgcALE4xSt16GCkX--
