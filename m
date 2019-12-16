Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D10121F08
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 00:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfLPXig (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Dec 2019 18:38:36 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40917 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfLPXif (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Dec 2019 18:38:35 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so1093661wmi.5;
        Mon, 16 Dec 2019 15:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=6lfwIVTfqonTYB+TS2Y2U3KUYW2USnHyGje3ynKio9M=;
        b=LgqUudnwAMjG8rere9AZkYU68RoGVOrpvgYGozU/yqoqAln5WVTvcZqYafISF/QpF1
         WiBr1fUcNZoAB8fBvAeS+D1aEVM8TqMMSRUS3l05NEVYiIQijlhYSZcQpWxJk+5mOJ+F
         gpJQ+OLak2/hy+MNxMMrZ2/QX1mxy0qA2x/ua8tsnrVy27D+wtcdhCQgUewzNDIjJRAr
         F5OwCNtCgiJapnEx4PQaMMpLn47ExIaXmxG5B7L66+/zaGr5LKB8dyEgKazi5L4MdgLB
         Nu8Nj2Igf5gvqaVQb+7RPUmupH0xpUI3+B5Tc9I4WLlZuOAMEAP04Z1AymGatmhvRbdJ
         RkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=6lfwIVTfqonTYB+TS2Y2U3KUYW2USnHyGje3ynKio9M=;
        b=Ps6mEh3j34J/5mRu0yrQFlFrXncxtdR9spA4Rfdo6qRi7UnJKZcfKwj78xpcYaW2mu
         hIAtkOuJrdfoS3oDQzms33lRrh7XyrdQ6E7lNUqSh6VxlO8R8twkR8IYJnCviTdtSgj8
         J71RpqA/F9NKWsMeNY2zlhDrCs3KS/RGkig1unWrjf7zzdwwfjgnmkWEXzzxihlNKmdY
         /9VPeD65ibd7Okb6Jhf3hxhuibU6q8ed7rh85iMhO5nzG8KT4jb5wxcW0ggh5viswUah
         S1J1kZ1WuTxADGVsdUswp/uHuYm2Ib17uvZ5Bz6Lhu01tWPNYORA0+0tMGmJi7h36wXk
         ac9w==
X-Gm-Message-State: APjAAAXOnSHgR9u2cGohJ/U2xLi2fWC0gAoq95qAcZd7vuHZVK6z7kOM
        RPiVIcGJQXprzJ9ARQx4NCfgBYP9
X-Google-Smtp-Source: APXvYqzpM9yF3Yrp/p3VCFDDqq0heXhksac0m98RBWyg6HpGsMafsklbRNNIYX9iwxtAdK1xGNr97g==
X-Received: by 2002:a1c:9dd7:: with SMTP id g206mr1713300wme.61.1576539512129;
        Mon, 16 Dec 2019 15:38:32 -0800 (PST)
Received: from [192.168.43.97] ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id q8sm971397wmq.3.2019.12.16.15.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 15:38:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
Message-ID: <17f7900c-385f-0dfa-11bf-af99d080f894@gmail.com>
Date:   Tue, 17 Dec 2019 02:38:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C7S0tkHwjcStuGlt7fvdT11hp6MQXVShU"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C7S0tkHwjcStuGlt7fvdT11hp6MQXVShU
Content-Type: multipart/mixed; boundary="yFO8RYBx2MIVzHGVJe03in1ZOfmp8Aca2";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <17f7900c-385f-0dfa-11bf-af99d080f894@gmail.com>
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
In-Reply-To: <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>

--yFO8RYBx2MIVzHGVJe03in1ZOfmp8Aca2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 17/12/2019 02:22, Pavel Begunkov wrote:
> Move io_queue_link_head() to links handling code in io_submit_sqe(),
> so it wouldn't need extra checks and would have better data locality.
>=20
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 32 ++++++++++++++------------------
>  1 file changed, 14 insertions(+), 18 deletions(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index bac9e711e38d..a880ed1409cb 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3373,13 +3373,15 @@ static bool io_submit_sqe(struct io_kiocb *req,=
 struct io_submit_state *state,
>  			  struct io_kiocb **link)
>  {
>  	struct io_ring_ctx *ctx =3D req->ctx;
> +	unsigned int sqe_flags;
>  	int ret;
> =20
> +	sqe_flags =3D READ_ONCE(req->sqe->flags);
>  	req->user_data =3D READ_ONCE(req->sqe->user_data);
>  	trace_io_uring_submit_sqe(ctx, req->user_data, true, req->in_async);
> =20
>  	/* enforce forwards compatibility on users */
> -	if (unlikely(req->sqe->flags & ~SQE_VALID_FLAGS)) {
> +	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
>  		ret =3D -EINVAL;
>  		goto err_req;
>  	}
> @@ -3402,10 +3404,10 @@ static bool io_submit_sqe(struct io_kiocb *req,=
 struct io_submit_state *state,
>  	if (*link) {
>  		struct io_kiocb *head =3D *link;
> =20
> -		if (req->sqe->flags & IOSQE_IO_DRAIN)
> +		if (sqe_flags & IOSQE_IO_DRAIN)
>  			head->flags |=3D REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
> =20
> -		if (req->sqe->flags & IOSQE_IO_HARDLINK)
> +		if (sqe_flags & IOSQE_IO_HARDLINK)
>  			req->flags |=3D REQ_F_HARDLINK;
> =20
>  		if (io_alloc_async_ctx(req)) {
> @@ -3421,9 +3423,15 @@ static bool io_submit_sqe(struct io_kiocb *req, =
struct io_submit_state *state,
>  		}
>  		trace_io_uring_link(ctx, req, head);
>  		list_add_tail(&req->link_list, &head->link_list);
> -	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
> +
> +		/* last request of a link, enqueue the link */
> +		if (!(sqe_flags & IOSQE_IO_LINK)) {

This looks suspicious (as well as in the current revision). Returning bac=
k
to my questions a few days ago can sqe->flags have IOSQE_IO_HARDLINK, but=
 not
IOSQE_IO_LINK? I don't find any check.

In other words, should it be as follows?
!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))

> +			io_queue_link_head(head);
> +			*link =3D NULL;
> +		}
> +	} else if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>  		req->flags |=3D REQ_F_LINK;
> -		if (req->sqe->flags & IOSQE_IO_HARDLINK)
> +		if (sqe_flags & IOSQE_IO_HARDLINK)
>  			req->flags |=3D REQ_F_HARDLINK;
> =20
>  		INIT_LIST_HEAD(&req->link_list);
> @@ -3540,10 +3548,8 @@ static int io_submit_sqes(struct io_ring_ctx *ct=
x, unsigned int nr,
>  	}
> =20
>  	for (i =3D 0; i < nr; i++) {
> -		struct io_kiocb *req;
> -		unsigned int sqe_flags;
> +		struct io_kiocb *req =3D io_get_req(ctx, statep);
> =20
> -		req =3D io_get_req(ctx, statep);
>  		if (unlikely(!req)) {
>  			if (!submitted)
>  				submitted =3D -EAGAIN;
> @@ -3563,8 +3569,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx=
, unsigned int nr,
>  		}
> =20
>  		submitted++;
> -		sqe_flags =3D req->sqe->flags;
> -
>  		req->ring_file =3D ring_file;
>  		req->ring_fd =3D ring_fd;
>  		req->has_user =3D *mm !=3D NULL;
> @@ -3572,14 +3576,6 @@ static int io_submit_sqes(struct io_ring_ctx *ct=
x, unsigned int nr,
>  		req->needs_fixed_file =3D async;
>  		if (!io_submit_sqe(req, statep, &link))
>  			break;
> -		/*
> -		 * If previous wasn't linked and we have a linked command,
> -		 * that's the end of the chain. Submit the previous link.
> -		 */
> -		if (!(sqe_flags & IOSQE_IO_LINK) && link) {
> -			io_queue_link_head(link);
> -			link =3D NULL;
> -		}
>  	}
> =20
>  	if (link)
>=20

--=20
Pavel Begunkov


--yFO8RYBx2MIVzHGVJe03in1ZOfmp8Aca2--

--C7S0tkHwjcStuGlt7fvdT11hp6MQXVShU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl34FWIACgkQWt5b1Glr
+6VTMg//UX504vCQR4vLbo8GO0tzZBv3qvSQ3FxdL8fpHa8WLSZkRAXp9M2DRaF6
T93044csOQ+qq/kKkXVpScwlYpu7wtZaTtyy9xUwmkEMjl8kiWezBu+EfuKg+Pp/
yCv5yYjAVLxy5htNTSiR+3vQnN7GO30zmv0u4ykJ8kAKEkkS+9i16aFTsWUcODq6
wl3E2dLhqT260kRa5iNmAkJl0U5BHHuSj7NhzspPrNlxTOtCLfzdGr4ssW7kOFRs
bYZf3TtAeNywbUPGXrd6pwro4teHCsFazkXGqdg/Af2GjJmLQreeE0Sujr517HW5
VeO7K51vTRSh1JwbcPQDJhfv6WirbR9waLjGElOsVPPfjNslCKB3OWQTXwft2zFY
781xl8rJmJMQj93vmcFGpWwTe3ftjewFwjeADhl2jxAAcIJR6660GrtSMEvsuvAX
eXg3O1PumeDv8DpPbnCX7eyx/bN00caFkX05a9Opwi8Lx/AolsqtEtvDMozH7hxb
ReMRxf3BF5mZi1biwyXRLp3IZ+HHHRTiKXIWejKeHv9AB3NUfFzjLL2VEKPeVILA
y/Jso5IfQbQYvq5JEtJDFNzpwZu/9C0ci21QWZqBGVLsKgyLHPzWCtVqOqebT4gX
7nKHRwo0RMSgXoOQ3EDFTGAOqWYmfrVI0lbmrOtMDOACU0c3Wzo=
=efnH
-----END PGP SIGNATURE-----

--C7S0tkHwjcStuGlt7fvdT11hp6MQXVShU--
