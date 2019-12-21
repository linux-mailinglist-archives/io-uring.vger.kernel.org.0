Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE79128BC3
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 22:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfLUV5N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 16:57:13 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37986 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbfLUV5N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 16:57:13 -0500
Received: by mail-wm1-f68.google.com with SMTP id u2so12609878wmc.3;
        Sat, 21 Dec 2019 13:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=fqVltKKEroh5pSrzjv5Pvxa1NjRr/F+HSv/v+vj2DC0=;
        b=SEF5VMtLZyjjswWOFjyEWnfWgY/Nhra2y0P32gYmZBWof+YlO7qE9bfaXS7AsXu8Sw
         RQumNBbx0d3mfpFzmD2rWNS5k45thV4RWOTGu2jq1V44MrRW3QgEL1t2UgH1t2C204VL
         emhVcIDXlxbDEnBdX4hN2ROGUHStHPvlxkhmNOQvgYkYMSYHDoSR/aUZ+kwMyvY2E9Vb
         wKir/cG8MZh7xq/0YsOXa9rbgZ/rlfqM4m9T3EWNZna/J0KHGn2yhN46ehBkOl3NvdEi
         u+C1eybLX8A8WmPHaWWCV0+Z++eUZ5hPlfG7qESv5EMwU0cg5mpwX0DoCwXOfIE9Zj0H
         fhWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=fqVltKKEroh5pSrzjv5Pvxa1NjRr/F+HSv/v+vj2DC0=;
        b=t6DDYiPq8WvJrQVG2bJqVhzKB1yPekNbIVQo1eYj2p/Aa2RSYHGxvxHVduDL990Pm+
         QIOZqFOAUZ96PSjIZ8HhPwG5m7TlKckByrNDyYJ8wcbdN5l6+g6D+yxgVEIS4nBc23Hc
         bUWRn4a2tZR5EGbCI1fjbrk4mRnf0dhR2up7VcA+8ZYLw2kWcEDAythrJ1LcDOQy27y/
         dRMJVsC3iZmWnYBDVUa9GoJT5J/tsjb4YVA0zmHeop1Bp+CmRzmbb2q0bjeV/t3qOXuG
         /g88n5CWQntCmWBcQcSsWyN6CbMqv0t/3VmnXh84KuGmRExVyAy2mIlwtUjkF5SlFn3K
         RXfg==
X-Gm-Message-State: APjAAAUHGXWbf+Z+DvtVfI5lLKzzEgDz7EdWX84ufrqsSQgm05ayj9ep
        CmIffyQ+hTiNkFPfVCx7Hab9dvzU
X-Google-Smtp-Source: APXvYqwgEapOmcrP/nvghP1KENeEfDkgq2hQFvvQcMa/UTv+maaPM8i1vUVijEfeQyVQrcuYyVFMGw==
X-Received: by 2002:a1c:1f56:: with SMTP id f83mr23834599wmf.93.1576965429610;
        Sat, 21 Dec 2019 13:57:09 -0800 (PST)
Received: from [192.168.43.30] ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id u14sm14947144wrm.51.2019.12.21.13.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 13:57:09 -0800 (PST)
Subject: Re: [PATCH v3 2/2] io_uring: batch getting pcpu references
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576958402.git.asml.silence@gmail.com>
 <a458f9577c254d6e0587793e317ba69703c7400e.1576958402.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <3ee072fe-e064-e1cf-cf50-a23bdfabd5d0@gmail.com>
Date:   Sun, 22 Dec 2019 00:56:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a458f9577c254d6e0587793e317ba69703c7400e.1576958402.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AFsQ35gw8k5Dqp9A1HPcRIVJ6SEYmazaE"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AFsQ35gw8k5Dqp9A1HPcRIVJ6SEYmazaE
Content-Type: multipart/mixed; boundary="H0UgRVQY7rhdC8t0UlnI2pFOPRpGlAfK9";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <3ee072fe-e064-e1cf-cf50-a23bdfabd5d0@gmail.com>
Subject: Re: [PATCH v3 2/2] io_uring: batch getting pcpu references
References: <cover.1576958402.git.asml.silence@gmail.com>
 <a458f9577c254d6e0587793e317ba69703c7400e.1576958402.git.asml.silence@gmail.com>
In-Reply-To: <a458f9577c254d6e0587793e317ba69703c7400e.1576958402.git.asml.silence@gmail.com>

--H0UgRVQY7rhdC8t0UlnI2pFOPRpGlAfK9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 21/12/2019 23:12, Pavel Begunkov wrote:
> percpu_ref_tryget() has its own overhead. Instead getting a reference
> for each request, grab a bunch once per io_submit_sqes().
>=20
> basic benchmark with submit and wait 128 non-linked nops showed ~5%
> performance gain. (7044 KIOPS vs 7423)
>=20

Hmm, this won't work. Please drop it.

> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>=20
> It's just becoming more bulky with ret for me, and would love to hear,
> hot to make it clearer. This version removes all error handling from
> hot path, though with goto.
>=20
>  fs/io_uring.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 513f1922ce6a..b89a8b975c69 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1045,9 +1045,6 @@ static struct io_kiocb *io_get_req(struct io_ring=
_ctx *ctx,
>  	gfp_t gfp =3D GFP_KERNEL | __GFP_NOWARN;
>  	struct io_kiocb *req;
> =20
> -	if (!percpu_ref_tryget(&ctx->refs))
> -		return NULL;
> -
>  	if (!state) {
>  		req =3D kmem_cache_alloc(req_cachep, gfp);
>  		if (unlikely(!req))
> @@ -4400,6 +4397,9 @@ static int io_submit_sqes(struct io_ring_ctx *ctx=
, unsigned int nr,
>  			return -EBUSY;
>  	}
> =20
> +	if (!percpu_ref_tryget_many(&ctx->refs, nr))
> +		return -EAGAIN;
> +
>  	if (nr > IO_PLUG_THRESHOLD) {
>  		io_submit_state_start(&state, nr);
>  		statep =3D &state;
> @@ -4408,16 +4408,22 @@ static int io_submit_sqes(struct io_ring_ctx *c=
tx, unsigned int nr,
>  	for (i =3D 0; i < nr; i++) {
>  		const struct io_uring_sqe *sqe;
>  		struct io_kiocb *req;
> +		unsigned int unused_refs;
> =20
>  		req =3D io_get_req(ctx, statep);
>  		if (unlikely(!req)) {
> +			unused_refs =3D nr - submitted;
>  			if (!submitted)
>  				submitted =3D -EAGAIN;
> +put_refs:
> +			percpu_ref_put_many(&ctx->refs, unused_refs);
>  			break;
>  		}
>  		if (!io_get_sqring(ctx, req, &sqe)) {
>  			__io_free_req(req);
> -			break;
> +			/* __io_free_req() puts a ref */
> +			unused_refs =3D nr - submitted - 1;
> +			goto put_refs;
>  		}
> =20
>  		/* will complete beyond this point, count as submitted */
>=20

--=20
Pavel Begunkov


--H0UgRVQY7rhdC8t0UlnI2pFOPRpGlAfK9--

--AFsQ35gw8k5Dqp9A1HPcRIVJ6SEYmazaE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl3+lR4ACgkQWt5b1Glr
+6Xg0A//axdZrsLce8D+dVKGEl51LTsWLHfo/t5UktU4oSgfWkitlvJFepAw5YnU
7Xa/n40Y0EK4OWK9J2TpTSXQWK5V9wOtWOGnX/hw6FX0C/bnxu+ab+1fsoK23y46
0wSm0eB7Ng+1B+w48UusReUs+eKDe2G55WZQOQPziy8Yg8VW8961SyfAN1gO6oNj
CplmapaI4RvkxPfvBmhnkbBBwxELLOzLUMml66ATkGAh2vsWBc31ReKYTUlKHa4l
bYM8ia4BY2YedpVmSAUzS26ARUnk1GqztnIxFpRNC736T19a8MLCfV9eEWIMcy72
qb7OmAhR9r/fwv9Y0Q22jEVU1ekqaugwv8XzGmGKQRas44gMPCKcf1EsuLB/CyFN
QO2rlHSoHRtmP2klX8B7T9JWR7VpfCBqXu4P5rdHOJbKQcrR8EUXYaiUC9EyeRTL
wmYy3LYLk8cnRL/vpgbAohdLtlq4xlHZESHn5PKk29X5P/XfmDoS98PED4ReQehL
RUrDMYLSArkz1j4N45VovFB0zVhhXDFv/g27IzjHXXiNKOxpIi1BWES8lDPmGTDX
CxG6FY9dGncOE2hD6ll7u65g23KJulK2WbAu2J1RaywG9oO87FnYkmzd76ck+aQv
yxmfaipUfZZldBGeonx4Lq31KMsGOYWgkVKqpfVUSL80L1T5H6c=
=yMQO
-----END PGP SIGNATURE-----

--AFsQ35gw8k5Dqp9A1HPcRIVJ6SEYmazaE--
