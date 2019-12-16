Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D32121007
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2019 17:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfLPQr4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Dec 2019 11:47:56 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35432 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfLPQr4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Dec 2019 11:47:56 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so28059wmb.0;
        Mon, 16 Dec 2019 08:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=aOmtNATovh1ggBETYGigyYuXJNCeDlmL+LT1h4FcVdo=;
        b=QvwAEgGx52hW6s0d51bNTcuFomeFfUOPBuK7F6CIKiWsd2i07PlOw86Kf1Kc5clzeG
         COyOQpaWNIsxbNSLohe4TrNm1zFV7BuJ8dWqway0Sr9T1VEJuSCACoKDTlvqfr+MwYnJ
         gyYt9M1IWZHM3FVewLPfM+Ru/4/lxx1hZiHRaAqXOtyHg79hqGzGDapWOstIEdRMu8pw
         fWXKjqtEM6hxTc+CmxlW1EtmQTtJLQUBLmDpzRPUmBBfzMhWsMVC/fKyLpThVP/BJURw
         U9yCUWfM1aLpHerQHoxfcpDc+BjAcz1rcUmlm/me7CuSjG/yMGGJZUHbyk+0OiAi6/aE
         xr9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=aOmtNATovh1ggBETYGigyYuXJNCeDlmL+LT1h4FcVdo=;
        b=mjnh5ZGI/tok5k1X24Z8yrcyaz9rGGHXp9qTABUzuyye454i/pngRJWDHNfDUKdTG3
         TyK5yUWUKOGXrGbqIo5mvaY8WaXFhYdSfJAkxTneZE9jU1VOUX67ryY5fEgBiseLa2Oa
         YXGK+1TNnKUDUHGgeRSkP89gMYpmp8cl2bF9Z0kK53oa1CwojHhsugeBg5Qz41RvIwc+
         vJuyL86H8VUP0/BQZjrjSOnwH0/CcjLluRTB9UpU6v1ihzMKcn9dnGonp98jv8PhG2mR
         G4T//pr4yeuW2485xVERKcZsVpldRM6UuGsWD058+YupcJocQA3rmQLlu1LQZ07n8ki8
         d2MA==
X-Gm-Message-State: APjAAAXhQIF1+/wrAxJTh6w7tYGxtB4EFHlOhbMAUSu23Jorn86IH9Ej
        pqM29zR9XMaA6blhM+twKJU0BHnxBMk=
X-Google-Smtp-Source: APXvYqzBMErQI8MMXiTDJlrcw49NkxmjcFESFyRybYnY+wYQ9T3E4dRSEcNpww3ibTxcsx14sDMrDg==
X-Received: by 2002:a7b:cd11:: with SMTP id f17mr22586544wmj.48.1576514872645;
        Mon, 16 Dec 2019 08:47:52 -0800 (PST)
Received: from [192.168.43.176] ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id w8sm408046wmd.2.2019.12.16.08.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 08:47:52 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
 <c6f625bdb27ea3b929d0717ebf2aaa33ad5410da.1576335142.git.asml.silence@gmail.com>
 <a1f0a9ed-085f-dd6f-9038-62d701f4c354@kernel.dk>
 <3a102881-3cc3-ba05-2f86-475145a87566@kernel.dk>
 <900dbb63-ae9e-40e6-94f9-8faa1c14389e@gmail.com>
 <9b422273-cee6-8fdb-0108-dc304e4b5ccb@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3] io_uring: don't wait when under-submitting
Message-ID: <279b9435-6050-c15a-440d-c196c6184556@gmail.com>
Date:   Mon, 16 Dec 2019 19:47:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <9b422273-cee6-8fdb-0108-dc304e4b5ccb@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fia9c39BoNAzl6CFYfBiYunGN9SLhccnz"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fia9c39BoNAzl6CFYfBiYunGN9SLhccnz
Content-Type: multipart/mixed; boundary="6o2dx0fo4baOvOO1LsTLMrsxchoQg4tLP";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <279b9435-6050-c15a-440d-c196c6184556@gmail.com>
Subject: Re: [PATCH v3] io_uring: don't wait when under-submitting
References: <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
 <c6f625bdb27ea3b929d0717ebf2aaa33ad5410da.1576335142.git.asml.silence@gmail.com>
 <a1f0a9ed-085f-dd6f-9038-62d701f4c354@kernel.dk>
 <3a102881-3cc3-ba05-2f86-475145a87566@kernel.dk>
 <900dbb63-ae9e-40e6-94f9-8faa1c14389e@gmail.com>
 <9b422273-cee6-8fdb-0108-dc304e4b5ccb@kernel.dk>
In-Reply-To: <9b422273-cee6-8fdb-0108-dc304e4b5ccb@kernel.dk>

--6o2dx0fo4baOvOO1LsTLMrsxchoQg4tLP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 16/12/2019 00:33, Jens Axboe wrote:
> On 12/15/19 8:48 AM, Pavel Begunkov wrote:
>> On 15/12/2019 08:42, Jens Axboe wrote:
>>> On 12/14/19 11:43 AM, Jens Axboe wrote:
>>>> On 12/14/19 7:53 AM, Pavel Begunkov wrote:
>>>>> There is no reliable way to submit and wait in a single syscall, as=

>>>>> io_submit_sqes() may under-consume sqes (in case of an early error)=
=2E
>>>>> Then it will wait for not-yet-submitted requests, deadlocking the u=
ser
>>>>> in most cases.
>>>>>
>>>>> In such cases adjust min_complete, so it won't wait for more than
>>>>> what have been submitted in the current call to io_uring_enter(). I=
t
>>>>> may be less than totally in-flight including previous submissions,
>>>>> but this shouldn't do harm and up to a user.
>>>>
>>>> Thanks, applied.
>>>
>>> This causes a behavioral change where if you ask to submit 1 but
>>> there's nothing in the SQ ring, then you would get 0 before. Now
>>> you get -EAGAIN. This doesn't make a lot of sense, since there's no
>>> point in retrying as that won't change anything.
>>>
>>> Can we please just do something like the one I sent, instead of tryin=
g
>>> to over-complicate it?
>>>
>>
>> Ok, when I get to a compiler.
>=20
> Great, thanks. BTW, I noticed when a regression test failed.
>=20

Yeah, I properly tested only the first one. Clearly, not as easy as
I thought, and there were more to consider.

I sent the next version, but that's odd basically taking your code.
Probably, it would have been easier for you to just commit it yourself.


--=20
Pavel Begunkov


--6o2dx0fo4baOvOO1LsTLMrsxchoQg4tLP--

--fia9c39BoNAzl6CFYfBiYunGN9SLhccnz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl33tSMACgkQWt5b1Glr
+6WcvA//Xe9Sr6OkL35dxFzAXuY6A6E2vHGBUNdoIjJijLPZlSaGKg+GyzCEFwhw
SwcU5sKdHETa1KgpI6p7flwm13N6oN9h6PNtIXUwEjdADD5F3b878k99Jb2tTezt
TBarkCO6X8rPqP1I+eY6zJEYGzcNbFnJk8RkORV5q9XvM41Ph0zWd2IzBVH5MC6v
Ow7I07mM7Wwg9fHGYv0DXbyyZvW2fCRBY01lfLmRiYXcygc00UzzbGO7bp+Z1gIG
GVCw3es5BrqmoRta8rHD5zYGm8jgCZkrYjQJsNtutoPkOFvd1ckUqC7mT5eYfwhq
ymynr3rmZ54XiVMcN8dS877JKD/CLKfjARCjGErW7iIKAYfxHijikxpkELX+wfGW
aJtcNfypQABLnsW511fxl5nsl8mybNyV7oZbLvqnAo6hcjs2zBUZLv9Q247zV0Tx
VIg7dw4Ep46Ng3S455Coa4O/4BD+jWKHk3qgksG3nJWMjRUJ615/LhLtedE+OYja
TdqJb7qZLU91nnW3zEUYCS6kkbLtgqWvkkSabKHVHQh1ZcuwYdq6m1k1uvvltqgT
J3+99HzrKqRZJKK5u6yuz/7COqdoUaADX2gRiq3Vq8sPLXSqL6/mj9vPoyEiFLtn
rLEsLg9tWrjmvOn0Qij3jQcY3CH9ofbg/jwy2nc3FvW8dzMW0H0=
=Z5S8
-----END PGP SIGNATURE-----

--fia9c39BoNAzl6CFYfBiYunGN9SLhccnz--
