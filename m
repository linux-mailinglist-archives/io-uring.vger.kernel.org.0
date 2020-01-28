Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6953B14C181
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 21:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgA1UQt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 15:16:49 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34421 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgA1UQs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 15:16:48 -0500
Received: by mail-wm1-f65.google.com with SMTP id s144so2554021wme.1;
        Tue, 28 Jan 2020 12:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=9kZRdKGDQ730A/WKJabHj2waTLH04y6Lq2oEng5J5So=;
        b=dv/sL0SMC+O5NrehW9VLwEJh7wSD5GL8WXHVVkcO/Aj6u6fVDPAUgALtgob29shwBF
         15bsLvHWQifsEtBz+NwKQM758u4oLvswKtQmYb1fcE9f76rBOr8rLYcRbbnJvI+T8UfQ
         ndTD6cdw5sJXYGIZiVxydeCqIJIxW8zmZWOzJNafAB14l4AtNVpOA0Giy+q9j9wDJNwm
         MRc6FiBvqRG752RbtUJvIvVCRYsIqJv7D+6ZxJSZUKPVFLZbFN3KI2RKjbJQFQ8YOscc
         tiiVZpUD56DE9aQKfHJGkDNTH2w43Wb4WSvOLRK3tLrQ+uqASBBgZ4/69SX3TnK/+G9m
         Kjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=9kZRdKGDQ730A/WKJabHj2waTLH04y6Lq2oEng5J5So=;
        b=W4IL3N2QkY55tTymLb0iSt/iY9bOz4wdc0AEDxPs0PK+5MS81TR8znS/cl4dwgbrOr
         enYKDmytBSyl/tVBvYUNtsSvMnvM0MG9kMnn7d3cabqkQMoEpnDya+PK3ZoUN1mhuL8J
         QZ7CZAIU7nXpD6KE24nAK/rrzZWjibtNoecsZS2/TuehKX0d/aZZezHABqwmjxQnmzCE
         d0sdwKZjuEyQ3OcfvrC8FmX7UzrGT+xlQsaMU4VPV/K6op4uiI2s5sa8Swle4B1npawR
         cw93pVlZvnRtYxccvy6MsuqrGVu/U+LQMAEJRrBpDEbZIdJyyg+ItA1scHgnb1/GsD9u
         7Cfg==
X-Gm-Message-State: APjAAAXHqZmTDE08PSG4pUeOAaIck3xkuyQj5X+QrTPSqfw3KmurKuC7
        oyAoP9UmvsjlWr9Ard0R2DTTIvPJ
X-Google-Smtp-Source: APXvYqyTmUFWkjJuS7scYpyWnvfDIwNjr1iioP2+HZ8KIva7r6gcQJw5xIW6F7uzroyTD3/7XcLhiQ==
X-Received: by 2002:a7b:c38c:: with SMTP id s12mr6660954wmj.96.1580242605679;
        Tue, 28 Jan 2020 12:16:45 -0800 (PST)
Received: from [192.168.43.36] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id n3sm25472774wrs.8.2020.01.28.12.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 12:16:44 -0800 (PST)
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
Message-ID: <15ca72fd-5750-db7c-2404-2dd4d53dd196@gmail.com>
Date:   Tue, 28 Jan 2020 23:16:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jWImSDYGvGcCj1J1u1CVHWUv0abybDqj9"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jWImSDYGvGcCj1J1u1CVHWUv0abybDqj9
Content-Type: multipart/mixed; boundary="cAtZwQMO7PbfoXjRRKXxykDWMx3KT7St6";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>
Cc: io-uring <io-uring@vger.kernel.org>,
 Linux API Mailing List <linux-api@vger.kernel.org>
Message-ID: <15ca72fd-5750-db7c-2404-2dd4d53dd196@gmail.com>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
In-Reply-To: <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>

--cAtZwQMO7PbfoXjRRKXxykDWMx3KT7St6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28/01/2020 22:42, Jens Axboe wrote:
> On 1/28/20 11:04 AM, Jens Axboe wrote:
>> On 1/28/20 10:19 AM, Jens Axboe wrote:
>>> On 1/28/20 9:19 AM, Jens Axboe wrote:
>>>> On 1/28/20 9:17 AM, Stefan Metzmacher wrote:
>>> OK, so here are two patches for testing:
>>>
>>> https://git.kernel.dk/cgit/linux-block/log/?h=3Dfor-5.6/io_uring-vfs-=
creds
>>>
>>> #1 adds support for registering the personality of the invoking task,=

>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited t=
o
>>> just having one link, it doesn't support a chain of them.
>>>
>>> I'll try and write a test case for this just to see if it actually wo=
rks,
>>> so far it's totally untested.=20
>>>
>>> Adding Pavel to the CC.
>>
>> Minor tweak to ensuring we do the right thing for async offload as wel=
l,
>> and it tests fine for me. Test case is:
>>
>> - Run as root
>> - Register personality for root
>> - create root only file
>> - check we can IORING_OP_OPENAT the file
>> - switch to user id test
>> - check we cannot IORING_OP_OPENAT the file
>> - check that we can open the file with IORING_OP_USE_CREDS linked
>=20
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

To be honest, sounds pretty dangerous. Especially since somebody started =
talking
about stealing fds from a process, it could lead to a nasty loophole some=
how.
E.g. root registers its credentials, passes io_uring it to non-privileged=

children, and then some process steals the uring fd (though, it would nee=
d
priviledged mode for code-injection or else). Could we Cc here someone re=
ally
keen on security?

Stefan, could you please explain, how this 5 syscalls pattern from the fi=
rst
email came in the first place? Just want to understand the case.

--=20
Pavel Begunkov


--cAtZwQMO7PbfoXjRRKXxykDWMx3KT7St6--

--jWImSDYGvGcCj1J1u1CVHWUv0abybDqj9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4wlocACgkQWt5b1Glr
+6Xovg//UAGAujvB0dz9ESbIMLh98oy43Ex/DBifBBez3BrAovlzVnAB6v2p6xM3
7g+nm8lFw2xONCrvaL2Zs+XoC/lrQ6m/uGmCFkPpnqS1a5CIi6m6NqhOd9MoqnFm
Yxxp8/p7tTgvknkxowQru/eeHVoDrackyzOKNmAPqBgJYsmFUHwW6I00luWPXm2G
MOPeu7Kqvy5h8DkaouBbeXQbiN+Obkm8J1j2qNbocsvo3jj1UDUQTvNCTU6//AOJ
V9BigDj0Jkop7jJFTkTmcAikxO7qaxJDnalwXVoZxSZIU6XCySRXjYJnb2Gu0kNe
CfUcKYhCqxEtwJgAuNLdOJkt6/Um+qPARLHQSpUHQjwJXwxH3N/LO46KQjGlFSea
YOOM+5kEEcx54r9LywBd0VeFpq118dCUw0ebfFoU2L2uGlRwwgUDLfj+bCX1CwQM
2gdASDeTY3SuwbvnOD5PNd8B/jjb+2Y/oKC6RBhBfx4pwPb3PdUaP0NQ5xnhQAXj
LDGinWU/eM8Ylrtf5dUejTBVQGApOd3qt5pWWgLpy+B8rD1Q5Zgc9e51hCAJRXf6
wqc8LSrGVr/Nk+G8ZS0qsvQaJmqI2SkIoB68IqXB6KGNGBpsbuyzynWSVFy3dYlR
yZRzpgSzFn2zP3Fhe6ImHPA0F6JzbjGygBBDz1YjGXltxExZjt8=
=iShe
-----END PGP SIGNATURE-----

--jWImSDYGvGcCj1J1u1CVHWUv0abybDqj9--
