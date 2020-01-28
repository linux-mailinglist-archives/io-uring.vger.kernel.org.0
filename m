Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38E514C39A
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 00:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgA1Xhn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 18:37:43 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39018 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgA1Xhn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 18:37:43 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so18087320wrt.6;
        Tue, 28 Jan 2020 15:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=CQxqRf7XpNY/tfLABbzF/HD2OOhhAKKhygwABrhzaTU=;
        b=lg7ulnMsDkolpVToXKNv5vqQRXt2Nt/j17KASyLnkAcYQS0dyDLPeEgvPLd5u7308s
         K3wDPd69C5POKfOHsXEaI/rK7VPjWM1yyjzQuOtLa2f/Mo5GG9uYVAvtoEUEPPu+XjE8
         OLnIzC7g90O2b6e051trqOAECjpIeV7+Ldthv6vZ3ViWKfZPHxSWrsIG10iLAGHZqeCT
         MjxzS8L1F78ikyY6fQiV/CVfh72xen9kQCuTt0jF+dWEKzPEhh0HvWOlnavvMTc4ngbV
         Oxq/nVBuPdYvrJm63bYkiPY7QIzICOBagYPtL+HEe1RJtPrufSbijV1FriW9fd0wgEVT
         bK+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=CQxqRf7XpNY/tfLABbzF/HD2OOhhAKKhygwABrhzaTU=;
        b=MGDWtwM5ihcI7OmWwrFmX9nVU5c8HTHhDPVD0/v0/xOkX+1nK6VSMV0BTMyGeVqMJr
         y5X7toX+J9598HouxWRLmykf4HlwiVbHN1Ct4HoO3NrlJR0dWt12MJx6wWwDc0vG9aOf
         cc6WbuzcHXT5VZJ2u9cdyFM6UHJpHkfg9kgna5HYIYi6Ht+k74BL9LJdtfVgx1p27WOl
         u9HVTepQa4/QLnccAbXkgpc/Kt7tJRqSDqZBl01umfwZEWpHKa/gIfgOcyaQxeItTaSv
         hKlESezvqEcaNfX+EmGrIwFAj8xA0glw9SeRpJd3hLMseD9nFZvXSXgBgrySVXFjLF4V
         tAdg==
X-Gm-Message-State: APjAAAUfANxVxzTwuic35MHa4A9tHqGmSwyi2Q4CHuzLPnDMVwnhLkOO
        i5XIWsIkPXye1O2RfyGRPUqx9LNQ
X-Google-Smtp-Source: APXvYqytdxTndReu8na6Zz/sNtlvbRYMKOETjcqoaqXYLupT64f/EGX+Ku9RqrBwPvrDSvZ7glBhtQ==
X-Received: by 2002:adf:97d6:: with SMTP id t22mr30829557wrb.407.1580254657064;
        Tue, 28 Jan 2020 15:37:37 -0800 (PST)
Received: from [192.168.43.59] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id w7sm68024wmi.9.2020.01.28.15.37.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 15:37:36 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Message-ID: <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
Date:   Wed, 29 Jan 2020 02:36:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rEF2fbPYDZSZbOYsEnSrCcCyk8fNHPtJa"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rEF2fbPYDZSZbOYsEnSrCcCyk8fNHPtJa
Content-Type: multipart/mixed; boundary="xCYP6jDf49GkRAEMQysNnTclfI4fZ0DCL";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>
Cc: io-uring <io-uring@vger.kernel.org>,
 Linux API Mailing List <linux-api@vger.kernel.org>
Message-ID: <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
In-Reply-To: <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>

--xCYP6jDf49GkRAEMQysNnTclfI4fZ0DCL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28/01/2020 22:42, Jens Axboe wrote:
> I didn't like it becoming a bit too complicated, both in terms of
> implementation and use. And the fact that we'd have to jump through
> hoops to make this work for a full chain.
>=20
> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
> This makes it way easier to use. Same branch:
>=20
> https://git.kernel.dk/cgit/linux-block/log/?h=3Dfor-5.6/io_uring-vfs-cr=
eds
>=20
> I'd feel much better with this variant for 5.6.
>=20

Checked out ("don't use static creds/mm assignments")

1. do we miscount cred refs? We grab one in get_current_cred() for each a=
sync
request, but if (worker->creds !=3D work->creds) it will never be put.

2. shouldn't worker->creds be named {old,saved,etc}_creds? It's set as

    worker->creds =3D override_creds(work->creds);

Where override_creds() returns previous creds. And if so, then the follow=
ing
fast check looks strange:

    worker->creds !=3D work->creds

--=20
Pavel Begunkov


--xCYP6jDf49GkRAEMQysNnTclfI4fZ0DCL--

--rEF2fbPYDZSZbOYsEnSrCcCyk8fNHPtJa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4wxXcACgkQWt5b1Glr
+6XIPQ/+JTYE1M2JkCRsNcK/1JXv09mAkVGj/ZSNPna7hmGfykBQEPYdyj2xfOV8
kRsbSF3BnqEEoAakGubgcHcFl+//hfUhu4e3ct3NzmRDY796bkhUdxVvl7D30vln
Qo4Cvh+R6ierzFZ0092TEANyud54fSMUBZqL+2Z7n5XLQkKVbKmbaTDTuzgPztcM
t+wsjWzFRqmoxu4GXLyGWP+SP0GntctdcQbqdxcZ/P4JucbxMTsS2mQrDsmzl3j5
v8AgEudAKabyrzfG3tII7ZVUfZ59GkB1MUXvkLNaKHznHeJx6tsrHES9MhfRiwlz
OTJEW5W7Nxv317X44D4XVe/83oYyG5JL1vVAuT9FjbGZtRPXmvgBa53HcxXl9oBt
88tbmSaOoW9scqgTK/3iOxdqXoWq36v6Ej7uJqAB21ZoZvR58iTWKrvA4iTn0sGg
K4nyY5Xu6SFqmEcIf5SNnzr9adSfZdaCKquOdoEer2TlxAtBiNBzL3qDW6Z7SGc1
2iJlCE0SDzy7agmCX3zvH8qsBStuSdOTcWxhrSHKPgQzJgmlRDANQi+AB/7MYZ/I
LYKAw9Li9+9Ro45DFaePYRrSjKT4NQgQXPYmg427wCNmUkEzCekpmL/YlMCNo0RS
hzrkJDB7Ilme4I2zFAwcWK5vL64BYh7waj5DqPDAj3UKjxfFewk=
=FxiK
-----END PGP SIGNATURE-----

--rEF2fbPYDZSZbOYsEnSrCcCyk8fNHPtJa--
