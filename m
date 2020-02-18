Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 088F31634F4
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 22:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgBRV3O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 16:29:14 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40935 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgBRV3O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 16:29:14 -0500
Received: by mail-wr1-f65.google.com with SMTP id t3so25736237wru.7
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2020 13:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=qsO2AdX09nUwh5Vn6DJWl1Qsm1lGlwgjYhNKw0DiswU=;
        b=hMdjOgtxR1Qq4lThmM19U4pX0wVvaIJXEl1kUoktD3AJxgHNVEoqUIotw/Mz3V7sP/
         MPh74ZtQdaKUUHxVsju3MEf3BFPfdtkjHmoM+SJw6ZM6Z5l2Fvy3sCJ+Osq+rv/PJ60l
         YJ7eGLcV6t+fjK1cAA9qlHxdTVb4yz2oR1fwciYpy1j5m6lfXYpzNzNx0cDycr3WwcRr
         qKCn7E4FPAPmclY/HUKiLjcKDOodSISIGnMxlvxS3itd3iU1lSBumOgk/5M0JyO1iTGC
         jmH1dKKzKccKp4Zz0d9QGNcfIF2amiGGA/Fm2b9o2hpzxJ8SnKZ15my5vuDvNenEc6qW
         NUcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=qsO2AdX09nUwh5Vn6DJWl1Qsm1lGlwgjYhNKw0DiswU=;
        b=ob9dPLE8KTwHKYWudoH+L9BiT2cRbvO19e6NjSMklP53qQ+p9iKUgGyw05/RIANWgx
         j85E2wb/E3cKR+1tlIQOkpzABWKt+mA9s/BC0H+0KJ/Qyg6kIFpOOGuajykjiUNssEe0
         BYwxb6GDsuQXs2GQqbDrHBPaMZAYxY0Km8JdFjBOtQM1qgdJ5XT2ihhpHCQJQwTF33Jz
         gh0I/WHj97Vu2oVKYBwjVy6r7o4mQgIov1l9gf+mqODtAPzEtot/XWEGzE+ghNruOVrG
         Nj6VUOOn1OpiWxrahCW5vukQONkCGHI5J9c7lbJfFysbt/124xp94szfKElZw826X41V
         QJBQ==
X-Gm-Message-State: APjAAAUETWGiXwckSSIL9CJTMc7m8c8yigqHY+A35xr52VniMLGEBSpS
        2P90iRrcOap0D6/++mBzn+mjAhas
X-Google-Smtp-Source: APXvYqxIQFJ/P0/X4P/agWzdAhhCWGZSA9X8Ryuq9UTM0R+dzOLXLErjym+ztSNEfnIHsefht28PgQ==
X-Received: by 2002:adf:f787:: with SMTP id q7mr31125963wrp.297.1582061350993;
        Tue, 18 Feb 2020 13:29:10 -0800 (PST)
Received: from [192.168.43.74] ([109.126.149.56])
        by smtp.gmail.com with ESMTPSA id t131sm112289wmb.13.2020.02.18.13.29.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 13:29:10 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <a0ee1817fd82ae102607714825ed35833a7d6a3d.1582060617.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH for-5.6] io_uring: fix use-after-free by io_cleanup_req()
Message-ID: <f207dd71-b478-8aac-7dee-c1b28e85b3d7@gmail.com>
Date:   Wed, 19 Feb 2020 00:28:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a0ee1817fd82ae102607714825ed35833a7d6a3d.1582060617.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZSf8cZlQQk5joNitmQ9bn95K0CZrWjebV"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZSf8cZlQQk5joNitmQ9bn95K0CZrWjebV
Content-Type: multipart/mixed; boundary="LJK2zdp0vOoVYdHkEvAl5R3BvvG67ogbm";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <f207dd71-b478-8aac-7dee-c1b28e85b3d7@gmail.com>
Subject: Re: [PATCH for-5.6] io_uring: fix use-after-free by io_cleanup_req()
References: <a0ee1817fd82ae102607714825ed35833a7d6a3d.1582060617.git.asml.silence@gmail.com>
In-Reply-To: <a0ee1817fd82ae102607714825ed35833a7d6a3d.1582060617.git.asml.silence@gmail.com>

--LJK2zdp0vOoVYdHkEvAl5R3BvvG67ogbm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 19/02/2020 00:19, Pavel Begunkov wrote:
> io_cleanup_req() should be called before req->io is freed, and so
> shouldn't be after __io_free_req() -> __io_req_aux_free(). Also,
> it will be ignored for in io_free_req_many(), which use
> __io_req_aux_free().

My bad, this got into rc2, and should be pretty easy to hit.
Please, patch this up.

> Place cleanup_req() into __io_req_aux_free().
>=20
> Fixes: 99bc4c38537d774 ("io_uring: fix iovec leaks")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 11627818104e..c39a81f8f83d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1296,6 +1296,9 @@ static void __io_req_aux_free(struct io_kiocb *re=
q)
>  {
>  	struct io_ring_ctx *ctx =3D req->ctx;
> =20
> +	if (req->flags & REQ_F_NEED_CLEANUP)
> +		io_cleanup_req(req);
> +
>  	kfree(req->io);
>  	if (req->file)
>  		io_put_file(ctx, req->file, (req->flags & REQ_F_FIXED_FILE));
> @@ -1307,9 +1310,6 @@ static void __io_free_req(struct io_kiocb *req)
>  {
>  	__io_req_aux_free(req);
> =20
> -	if (req->flags & REQ_F_NEED_CLEANUP)
> -		io_cleanup_req(req);
> -
>  	if (req->flags & REQ_F_INFLIGHT) {
>  		struct io_ring_ctx *ctx =3D req->ctx;
>  		unsigned long flags;
>=20

--=20
Pavel Begunkov


--LJK2zdp0vOoVYdHkEvAl5R3BvvG67ogbm--

--ZSf8cZlQQk5joNitmQ9bn95K0CZrWjebV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5MVv0ACgkQWt5b1Glr
+6W3Rg/+MO8jfJjQgzbC0UbDcl4jmFG16UbpASQnuKyiycdCciUgL9zBAkUiiVFH
ih8UDuR+Qi/HdT5T8GNMxPs3frIpeh3OnRIvPTl+/2XeFnsMLzPgWUweN0G4KTOs
eCvQdmB1ExbmOptJjPXvwMNqR+xx6xU+iUFyfMmMAN4n/jFqiSYb1OoCcqrynsku
os6OamGyy3yGfiHk5cY7Igy+xjOa/J/CtvNasoMkMUfwy+ghffFWuPZ9n4IitsJS
kOQHQ4xeMsDlojjfnGDhf8cBRu/Gk/DrRLPNJyAFNu3faBjMC6Zx1v32voUf+GB8
q1ATthiyQVqi6rMs0y4OLgU8f+Fnnxnf0bHR2ZRR2tx93xrJ7TnmZYWVu0Eky88q
oCNf5oSncoNh9zb09u7LYakw0jEf9hP+y/spqfbPAPC84Um9WWQRu2CwPCXjtfNG
JRxpipuFvbyBFyiHF0b0TfnrGSPy+s2U/i5g254pQf3YUgchVPi0VMDxD+WJ04qD
MU78M/UHIh3wQWFKLIZqKSgpIh5vFQLyaj/uQkEAfEbIn91M9GiHirmdIsVaGLib
wisrpZtQxzMemomIUVvK6sHTY0UrUT8uy9dBEziL/Q3JnRgyJYfEpMShhY4N7uYB
XU2egGSYDehSe2FGto4Rh5KN21RGTxu+JVoS0C7Kx4l5SeXvuOs=
=5vor
-----END PGP SIGNATURE-----

--ZSf8cZlQQk5joNitmQ9bn95K0CZrWjebV--
