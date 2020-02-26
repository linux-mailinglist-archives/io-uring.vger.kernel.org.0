Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5179116F99F
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 09:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgBZIeW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 03:34:22 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55170 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgBZIeW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 03:34:22 -0500
Received: by mail-wm1-f68.google.com with SMTP id z12so1939433wmi.4
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2020 00:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=qjFqGSsOpyY+MZBelZf10b+1xoXTPGQTgnTuGgHj5+4=;
        b=rPj13z9yGF6tkvaX+agcEQ5CzDlC/xVfq/zy++IXKgKA71+XEVMpff/lzfe30eWls2
         wdwTKFjGPkBns/+1B5GTFVBbJcKICSitpDSW3k6xW+b0OYMhQXMFCKmHnkiPN3uQzsbK
         vFXpv2apDMsj5XOa2S/jMygFKAaS6HAkHeBeWsc9BoUa2bUh4NwlV3Dx2ldU0JJ/EPkS
         HcKL6pM3HL+Tj//MjZ6jpfWQfCWDws12tEXsFIBvtvF6pQ/j3Bg6ILwdqsGlfe7XPfIl
         ifc7oIWnMrJnVQc5gYXIdcmnZEWG23V9FFQ3oM38xuVgPTi/y0kdY1TSv2JpePxx+kNF
         LN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=qjFqGSsOpyY+MZBelZf10b+1xoXTPGQTgnTuGgHj5+4=;
        b=Q9uyZkPd5YTDcTf/EQw73tgpb+5oBmOoe9E9sAdkR6UKjWfW5iNrQtaHOhE6TipbOE
         Q5vwOLf7gzI8ds+XD69JTiDUMib8B1dGaRMDn/KrafOkeoglR6Yb0BK8eSlViCrWGrI/
         IODs6gzJp4yjr990AT3B9ZlFBcTxdi+qFKq4fyB/O+QzBif0XNLPJOJ4DDIDptpAqyjH
         SOXEKwkTu3Sh0tN1A8+dX3ORd4hyBQxuHVG1ANSHXs6VeQxCtMTMyTteb8gBLqbzjwi9
         2TCy9tVjcH6AAEUn0+n/pnykrwk+emgv6g/dTAWCMatfq7Uk3ARdMp48Xp4RzO3bsL5Q
         FGMA==
X-Gm-Message-State: APjAAAV+RbwcDXoN7PxFEcloABsjn91MnlyBel8BallmOg9QfBfXWEt8
        q/JcGXIThX3zMMWj8RoNktI0UkWQ
X-Google-Smtp-Source: APXvYqzRJGjeMKnAse+o0BD0Afg/DPPYciyCSY85uSA37C7CItWFsDOBBk5XS2MqP5nJ/hhKgbV0rg==
X-Received: by 2002:a1c:a443:: with SMTP id n64mr3879048wme.141.1582706059073;
        Wed, 26 Feb 2020 00:34:19 -0800 (PST)
Received: from [192.168.43.183] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id 133sm2028360wme.32.2020.02.26.00.34.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 00:34:18 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
 <82423419-1c14-418e-8085-2d8b902b0a2d@gmail.com>
 <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>
 <32c9037d-d515-9065-3315-e023edaa4578@kernel.dk>
 <dfc1fc59-46c5-d985-80f7-3d637cd40b13@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: pick up link work on submit reference drop
Message-ID: <14cc6bff-565a-c41b-bb96-7b2edad163ce@gmail.com>
Date:   Wed, 26 Feb 2020 11:33:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <dfc1fc59-46c5-d985-80f7-3d637cd40b13@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VvaYeFCIufJDVPuJsXaZxQyaOuioRvQrG"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VvaYeFCIufJDVPuJsXaZxQyaOuioRvQrG
Content-Type: multipart/mixed; boundary="b6uZQqTdcTnP86vZtKvfyxruf9LG9OId0";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <14cc6bff-565a-c41b-bb96-7b2edad163ce@gmail.com>
Subject: Re: [PATCH] io_uring: pick up link work on submit reference drop
References: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
 <82423419-1c14-418e-8085-2d8b902b0a2d@gmail.com>
 <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>
 <32c9037d-d515-9065-3315-e023edaa4578@kernel.dk>
 <dfc1fc59-46c5-d985-80f7-3d637cd40b13@kernel.dk>
In-Reply-To: <dfc1fc59-46c5-d985-80f7-3d637cd40b13@kernel.dk>

--b6uZQqTdcTnP86vZtKvfyxruf9LG9OId0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 26/02/2020 01:18, Jens Axboe wrote:
> So this found something funky, we really should only be picking up
> the next request if we're dropping the final reference to the
> request. And io_put_req_find_next() also says that in the comment,
> but it always looks it up. That doesn't seem safe at all, I think
> this is what it should be:

It was weird indeed, it looks good. And now it's safe to do the same in
io_wq_submit_work().

Interestingly, this means that passing @nxt into the handlers is useless,=
 as
they won't ever return !=3DNULL, isn't it? I'll prepare the cleanup.

>=20
> commit eff5fe974f332c1b86c9bb274627e88b4ecbbc85
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Tue Feb 25 13:25:41 2020 -0700
>=20
>     io_uring: pick up link work on submit reference drop
>    =20
>     If work completes inline, then we should pick up a dependent link i=
tem
>     in __io_queue_sqe() as well. If we don't do so, we're forced to go =
async
>     with that item, which is suboptimal.
>    =20
>     This also fixes an issue with io_put_req_find_next(), which always =
looks
>     up the next work item. That should only be done if we're dropping t=
he
>     last reference to the request, to prevent multiple lookups of the s=
ame
>     work item.
>    =20
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ffd9bfa84d86..f79ca494bb56 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1483,10 +1483,10 @@ static void io_free_req(struct io_kiocb *req)
>  __attribute__((nonnull))
>  static void io_put_req_find_next(struct io_kiocb *req, struct io_kiocb=
 **nxtptr)
>  {
> -	io_req_find_next(req, nxtptr);
> -
> -	if (refcount_dec_and_test(&req->refs))
> +	if (refcount_dec_and_test(&req->refs)) {
> +		io_req_find_next(req, nxtptr);
>  		__io_free_req(req);
> +	}
>  }
> =20
>  static void io_put_req(struct io_kiocb *req)
> @@ -4749,7 +4749,7 @@ static void __io_queue_sqe(struct io_kiocb *req, =
const struct io_uring_sqe *sqe)
> =20
>  err:
>  	/* drop submission reference */
> -	io_put_req(req);
> +	io_put_req_find_next(req, &nxt);
> =20
>  	if (linked_timeout) {
>  		if (!ret)
>=20

--=20
Pavel Begunkov


--b6uZQqTdcTnP86vZtKvfyxruf9LG9OId0--

--VvaYeFCIufJDVPuJsXaZxQyaOuioRvQrG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5WLVkACgkQWt5b1Glr
+6W84A/8CoaGmBoWnopCdSdoXbSWoL0Q2fh1fKXeefiBAxGQHCMv3DrnQ/3OiFUd
gLJLzJ2AIgKCpIzBMEty9cXXDTYjAvbhu3rCxK+xkU42CR0pTYhHl6dtm890PIwf
sjnssb4D1Dcmy7YSbvc1mDWtHOzzWy2i+ET9ihbOAO79N49sONHHeVJLIlKf5Bly
lmYWOhqEsFf8U4nB+fgrCdwKPVNIgoUhyLeGX/QLOZeWZk9xthgntR4NJY0CzSzL
jCUrNwL/swb0RIKmkva3zarz1yvQggnOnjp8DN+JiDe5Jo+tftOpyXOfeuNA5RX0
IkRCNjdY5S3BwaWm9BLVhl/n9r/TotAOb7uOOwDZyG4cqtJ6xjWYSk6fRza8g17Y
oORsuzr51ZtXVVlwfocqTfCkCTBjJh5P46fq134TYl+l4pVeEuf0xTi/ETMal0OK
m+GSQc/UtruF+G62LYur3Mg7AwhMVP7FS2CMBcjhu7EuXn1cY1zix+Pdbs1p8bRS
VPZcopYLYyHUSfzyKzbJ8pSA0hq2MG2Tl21Clzaq4yXsXFRBnrT9kss8UMDL7RYe
bq7sRT/uUiK1BbvHRh1QIn3TCboB3kHQwX6NzSFyzYV7RoWW7McYhl6/sjciCW3A
p9ZoHFHmWhN7LV5HjZB7Jyk2HZRT/jMxqqv+LYG+BMDqtqS07MA=
=BKB7
-----END PGP SIGNATURE-----

--VvaYeFCIufJDVPuJsXaZxQyaOuioRvQrG--
