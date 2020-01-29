Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E03114D3BC
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 00:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgA2Xjc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 18:39:32 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38248 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgA2Xjc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 18:39:32 -0500
Received: by mail-wr1-f66.google.com with SMTP id y17so1694589wrh.5
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 15:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=/zW+ih5S9I7R6t7PVvSPh8szJz8Sz+0gh+u0k1R+Sv8=;
        b=BQRp13Aw9QDWXHSayv2vPAQ4iXRLYKDe4EmLCFqwT8CPeMIhf+WSWNPvZxxl0dQEV8
         QbD3XiIY7X4K886BGnS14+5hcJoCmiJMiNbqKyisiSTYMylgizkh0BPWUgNu/RZj6wBY
         yhLr2s55iy6THXT1EeZLSGi1f8mE/IypNDatSzkKc3LW2hzlFxmxqGyHf4tFCMsVw/9e
         59w+t9ueGmyZKWCr2MyHwCecxU6+tseyA3DB69U+8BaC7zSSXKb5j1si5JNyiT8hyy5u
         mLJNtzDwAWY8LY7RvmrBurYe0EdF1BlGwjIya3EVnKEvenYK7l+EHfaOTrHiZFMWKFNL
         mrKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=/zW+ih5S9I7R6t7PVvSPh8szJz8Sz+0gh+u0k1R+Sv8=;
        b=TjkRr1VCafo8Lnsg4615PupGTOD7b7SMJ/oYZ7atmTxqSmuaXL3l2Ilp+vckTEFkSi
         aMp9hTKn8ko9Ifudx/e6tm6A/jc1Vwin0F+exvvXqYHBBQDzqmrPN0kGTsD6Jb+dIsS4
         4UHmH9wSzi87Pb1fyka6SNTOqtaWf3SjmRZxCf0ziZPKF9Yq8g+0yrGaXKS0ftnQrSvI
         BnEn1zkcVELg2+C4FBAnPfYpB7fykXk1GB6j9vl1oJnnAh9NMXACv1UZU92D5+Z4X+yJ
         PXBcq20qVlmIdNR3daDoOiJLEWl7QFkwrgtgQpnUrbwvORhPuslRzPdpj1j2ONzxZw2Q
         KLjw==
X-Gm-Message-State: APjAAAVtToQqrK4ZTz2AoOeb2r+rqUDoo23+L7wekOYFE4qb8TkQomPB
        3fxs90Rc54WWLgCX4q4FQ2E77o1f
X-Google-Smtp-Source: APXvYqyWH2DUhtPQH6GEhGmAY6WJjlXmBwoR8a9Xim3cCf3TNuIUnIdaRuzXd7bJ6E7DKXOYpAR5Ng==
X-Received: by 2002:adf:eec3:: with SMTP id a3mr1272987wrp.337.1580341169117;
        Wed, 29 Jan 2020 15:39:29 -0800 (PST)
Received: from [192.168.43.140] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id 2sm4885865wrq.31.2020.01.29.15.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 15:39:28 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix linked command file table usage
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <c2d0d637-85db-3500-f1ae-335bc1fec6c8@kernel.dk>
 <4a826524-4f77-2126-03e9-802c3567f73f@gmail.com>
 <828c41db-163e-c6db-5fdb-3f87246ac0ed@kernel.dk>
 <60df3f6c-7174-a306-47bd-92ca82e2c432@gmail.com>
 <eeae146a-1268-bab3-043b-dffe6dfb21d0@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <41b233d5-f8d7-5656-7bd4-72e3658a0653@gmail.com>
Date:   Thu, 30 Jan 2020 02:38:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <eeae146a-1268-bab3-043b-dffe6dfb21d0@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pliPNVYRGdxlzcN3HoN0fgagr6X4BeMmW"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pliPNVYRGdxlzcN3HoN0fgagr6X4BeMmW
Content-Type: multipart/mixed; boundary="hGwgXJEj0Zqg6ZDo0o6N7raBlZBXsr2QC";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <41b233d5-f8d7-5656-7bd4-72e3658a0653@gmail.com>
Subject: Re: [PATCH] io_uring: fix linked command file table usage
References: <c2d0d637-85db-3500-f1ae-335bc1fec6c8@kernel.dk>
 <4a826524-4f77-2126-03e9-802c3567f73f@gmail.com>
 <828c41db-163e-c6db-5fdb-3f87246ac0ed@kernel.dk>
 <60df3f6c-7174-a306-47bd-92ca82e2c432@gmail.com>
 <eeae146a-1268-bab3-043b-dffe6dfb21d0@kernel.dk>
In-Reply-To: <eeae146a-1268-bab3-043b-dffe6dfb21d0@kernel.dk>

--hGwgXJEj0Zqg6ZDo0o6N7raBlZBXsr2QC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 30/01/2020 02:31, Jens Axboe wrote:
> On 1/29/20 4:19 PM, Pavel Begunkov wrote:
>> On 30/01/2020 01:44, Jens Axboe wrote:
>>> On 1/29/20 3:37 PM, Pavel Begunkov wrote:
>>>> FYI, for-next
>>>>
>>>> fs/io_uring.c: In function =E2=80=98io_epoll_ctl=E2=80=99:
>>>> fs/io_uring.c:2661:22: error: =E2=80=98IO_WQ_WORK_NEEDS_FILES=E2=80=99=
 undeclared (first use in
>>>> this function)
>>>>  2661 |   req->work.flags |=3D IO_WQ_WORK_NEEDS_FILES;
>>>>       |                      ^~~~~~~~~~~~~~~~~~~~~~
>>>> fs/io_uring.c:2661:22: note: each undeclared identifier is reported =
only once
>>>> for each function it appears in
>>>> make[1]: *** [scripts/Makefile.build:266: fs/io_uring.o] Error 1
>>>> make: *** [Makefile:1693: fs] Error 2
>>>
>>> Oops thanks, forgot that the epoll bits aren't in the 5.6 main branch=

>>> yet, but they are in for-next. I'll fix it up there, thanks.
>>>
>>
>> Great. Also, it seems revert of ("io_uring: only allow submit from own=
ing task
>> ") didn't get into for-next nor for-5.6/io_uring-vfs.
>=20
> That's on purpose, didn't want to fold that in since it's already in
> master. Once this goes out to Linus (tomorrow/Friday), then it'll
> be resolved there.

I see, thanks

>=20
> For local testing, I've been reverting it manually.
>=20

--=20
Pavel Begunkov


--hGwgXJEj0Zqg6ZDo0o6N7raBlZBXsr2QC--

--pliPNVYRGdxlzcN3HoN0fgagr6X4BeMmW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4yF30ACgkQWt5b1Glr
+6WwNQ//Qx5b6heDUjnO+P5orr7c52XInQRljHUFNYyNfThrD5Unmxf4VEgbZcmt
9Q8LmP++iETNrIF9Syd4O0NjgWzPPy02iWsbVzupFvDQGV46r5ar8sbvCoUXZaPS
UoF1n+e3bv41rG/wOfJ32PFm3OH3BwnPMOt2aa08Ib7RaC8Y3zuLIoWSd3WTHnL0
1v+WH9EVo0qOkvUbyUxesn7H6LdR6CCcg9bQe/6FAsGNt34KhkLX4yFT6qO0+Z3w
GjVhs1OfOAnV0PTCqfAUYmveFba69kyszrds0u61I3WvP4vPPFeXOvkykv1MN1ov
rDonbDYKBZsMNxX1eYr62FHWhtQXoWETqbcBIYbnxUuW1l0oC2WoTFmVh6TQm4nq
hthXko2NgiPzWfxnk74dCtfw4RaXrwsf/bRsGLEQA0A4Sn9ZkQo+16/g4l+FNKi+
NPpdAx4hyZDusIzxFmntMp6eeoKdE3oRhC6fyuywukCtnePMEqoKP92+XLXTYsX4
XIZx8nkVB3hnqWJunM1/lyB+2c+xfkWYIHAYOAOgxWMni6AJqP+Ft+70deiI8h9Q
wJGM2ffCWfr+HKiSqC2VijB0WbCLgtGucshbnToVx/Qv5G1HMtFSGxTb7d/k3ezD
85MVndgnE2XmPU0s3NnCiDlOqhnBNndbscLWJHGhwyhCOO+asLY=
=c+cF
-----END PGP SIGNATURE-----

--pliPNVYRGdxlzcN3HoN0fgagr6X4BeMmW--
