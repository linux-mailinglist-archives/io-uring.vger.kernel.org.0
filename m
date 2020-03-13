Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAC23184F5B
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2020 20:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgCMTlL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Mar 2020 15:41:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38811 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgCMTlK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Mar 2020 15:41:10 -0400
Received: by mail-wr1-f66.google.com with SMTP id x11so8847914wrv.5;
        Fri, 13 Mar 2020 12:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=oFgDWqJLcIt8LRMfp2CtIFo918FXysndJI98quJZeeY=;
        b=dx6M4V1vlrUKaOFHHn0QxpCB4MiAxjfI89YkiisX3qLYFDm7n9o5MHirRDmaEhTkmx
         FAoqD1ioBsDjFHjNtnKQD5qYUwBQUcPiE5JVMkkZi7e52RPG2xlLEMz1NXPEi0pAY5NK
         dSVPJnsHAoStO2S0CXuVwkcRZkRJFWrUmWuNpVj5OK4ostUiG8Q/DXziZwX4OTFczdTu
         wEgQRhQWSXbINe6/3vWwJH05J1fGAYg19v+u2SUSznoQhZNqce1lQmMbMqbpwOPZk/J2
         5kPutHmXRB05i5jgH6ojV70qrx9Ei2+qqT6NJMtz8OcJ4gNBjAFXcTLRIioG59W0s7vf
         LTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=oFgDWqJLcIt8LRMfp2CtIFo918FXysndJI98quJZeeY=;
        b=VYZjLHtI/RxjTf3Mpj3/o9M4byAFlnyubJ4oCYqwwQtMq21sNFAqzthFE8bI/nKPsc
         CxRUKO1zMsPZoTgx59soICNb2hfqkUiqu/5q45IhH7q6rAG2nloyuqZyEHoEd1xT5O5I
         i1gD8c20a+HY2s4Sl4AnQJKVTqiSAgwuT6aQ2pZQ7Kq5IPnkXd+oVFrY+OFc9bfh7mdC
         i4K2H5UMsd1cAFGF2dH1RYI/1ggBo2dLko+ou4E+/mdQ00JGGzKBvBCtpl35ZF83C994
         YYdMwqebP0lqfhcQ2pLiGNRYb/s0x9n5XBMeHcS4C7dolg8IJ8nNrhFltq3WnRivEpXi
         9Vrw==
X-Gm-Message-State: ANhLgQ1U4ge+wvLjPbRJcXefDvNjXx29XOHrGvNmAXDMN0gNy0GMK5PY
        Qy1pOk8hDNmJaGt/U6ifZKejj9A/
X-Google-Smtp-Source: ADFU+vvF5s61/rR0nF2XeFYs70jr90V3p5nnrevnEAM5O6tZZY4E2/g/FKcUz+/Qnrkd62Brb3EtPg==
X-Received: by 2002:adf:de8b:: with SMTP id w11mr15086490wrl.258.1584128468316;
        Fri, 13 Mar 2020 12:41:08 -0700 (PDT)
Received: from [192.168.43.52] ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id f207sm19825794wme.9.2020.03.13.12.41.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 12:41:07 -0700 (PDT)
Subject: Re: [PATCH 5.6] io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <3fff749b19ae1c3c2d59e88462a8a5bfc9e6689f.1584127615.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <cffb0da4-bb52-8e42-c8ab-a09d0b678426@gmail.com>
Date:   Fri, 13 Mar 2020 22:40:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3fff749b19ae1c3c2d59e88462a8a5bfc9e6689f.1584127615.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cCA3GJdAKQEr0LutJdLQgksPPGILFBrIc"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cCA3GJdAKQEr0LutJdLQgksPPGILFBrIc
Content-Type: multipart/mixed; boundary="D0TMx2328THvUEcSx0ZZ8Mu6TKzxxN1cu";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <cffb0da4-bb52-8e42-c8ab-a09d0b678426@gmail.com>
Subject: Re: [PATCH 5.6] io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}
References: <3fff749b19ae1c3c2d59e88462a8a5bfc9e6689f.1584127615.git.asml.silence@gmail.com>
In-Reply-To: <3fff749b19ae1c3c2d59e88462a8a5bfc9e6689f.1584127615.git.asml.silence@gmail.com>

--D0TMx2328THvUEcSx0ZZ8Mu6TKzxxN1cu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 13/03/2020 22:29, Pavel Begunkov wrote:
> Processing links, io_submit_sqe() prepares requests, drops sqes, and
> passes them with sqe=3DNULL to io_queue_sqe(). There IOSQE_DRAIN and/or=

> IOSQE_ASYNC requests will go through the same prep, which doesn't expec=
t
> sqe=3DNULL and fail with NULL pointer deference.
>=20
> Always do full prepare including io_alloc_async_ctx() for linked
> requests, and then it can skip the second preparation.

BTW, linked_timeout test fails for a good reason. The test passes NULL bu=
ffer to
writev and expects it to -EFAULT in io_req_defer_prep(). However,
io_submit_sqe() catches this case (see head of a link case), sets
REQ_F_FAIL_LINK and allows it to fail with -ECANCELED in io_queue_link_he=
ad().


> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 55afae6f0cf4..9d43efbec960 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4813,6 +4813,9 @@ static int io_req_defer_prep(struct io_kiocb *req=
,
>  {
>  	ssize_t ret =3D 0;
> =20
> +	if (!sqe)
> +		return 0;
> +
>  	if (io_op_defs[req->opcode].file_table) {
>  		ret =3D io_grab_files(req);
>  		if (unlikely(ret))
> @@ -5655,6 +5658,11 @@ static bool io_submit_sqe(struct io_kiocb *req, =
const struct io_uring_sqe *sqe,
>  		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>  			req->flags |=3D REQ_F_LINK;
>  			INIT_LIST_HEAD(&req->link_list);
> +
> +			if (io_alloc_async_ctx(req)) {
> +				ret =3D -EAGAIN;
> +				goto err_req;
> +			}
>  			ret =3D io_req_defer_prep(req, sqe);
>  			if (ret)
>  				req->flags |=3D REQ_F_FAIL_LINK;
>=20

--=20
Pavel Begunkov


--D0TMx2328THvUEcSx0ZZ8Mu6TKzxxN1cu--

--cCA3GJdAKQEr0LutJdLQgksPPGILFBrIc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5r4aAACgkQWt5b1Glr
+6Wm+A//aKpCUcBSZcsjq2n/tBNz7BxOkTDViGlZer1feq+qPFICwUceghpDWE4S
uRAm+gOGN8ud/RpQPcKVzhyOY0J+tJh4IK/Si3BHlCceh8MO1vVY+WfiKbzx8/TZ
qE5ZL94qH4cWWCI/f+Rzkuf6ZbHjmkh7KNcJf9lghsb1ei/DU0aMn6KEYDa2aqwN
5z0qyLVqiXltj9sSmL6I3F3BJAC5caFOk/K9DudoX2SfmYoR9EVxpbzVjEcfbahU
RSTFA8YopkZ9fa8s8wTHd1BqLfOCZC5CubUEl8n8BXlCQj8iqQYK3mZ+I/nIrT+b
/JhN3FOlkOxDbKqNWanA5+x8KJAuQJN5FcdgigtI4laFKyYSPOT7YXLpuCewnEac
9SUpJu1xpOPiJbRX112RkyD0raOf7yGpwXLCUC0H6IJHbbzQf/T5oOq4OzRg1JH7
bGAVwM209pW9CUtXZkBpz182NRuxcsoMF+W/bE52zt3n43jercRRG3mt5DzyEZxP
KJwEZLWIF/FQIWsr1PYC6AAgRG8e77ITYNf0moaAibhXjwYKbuTciIbLq58bnKBs
HnqcEpo5uHymy3H1oLhzqK/hhafbCb1LbLf8AtpBlsCiPS4YsdI6rlZc/aeC/VF7
hAIJSsYEHkZ8UkqpN2CTdeZx3wmcOUab5dH+fXrTanoVkDfz6s4=
=+VzN
-----END PGP SIGNATURE-----

--cCA3GJdAKQEr0LutJdLQgksPPGILFBrIc--
