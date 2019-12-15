Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E15611F89D
	for <lists+io-uring@lfdr.de>; Sun, 15 Dec 2019 16:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfLOPsv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Dec 2019 10:48:51 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:32994 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfLOPsu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Dec 2019 10:48:50 -0500
Received: by mail-lj1-f194.google.com with SMTP id 21so4038532ljr.0;
        Sun, 15 Dec 2019 07:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=VkkUqKsHd2dwOIO/Xg/JSf/WkBogcFEzgjutQEh4zvc=;
        b=WGeZdFYakxx+I5Qc7DKBe70qAlS295m82HC5vkft01iypiXw5abNpG0Z9PF3lR0k0m
         srlU3LV96uUHqG/XQMBZCcecq/XXNKOYQq/p/ckSh2ZvyRll3aPXwd2aMNVkZ6hTtcDC
         M7+NboIZ1TaegD4zOHPSHgDTbMp6qVsLV+Su9qmQRktVEfXxYmSiYiqqXucKJfOsKiq+
         HL53SU1itbmMsS6dBzX9zpwm/JKPIR1Hcf2mp411Ul1e3yiJGaZnbSfCW7gQw0OgIwXh
         s0qzo7a+dqQ3QarNc+a+Y2HtR0AzaRmwSgfWHlmNXZzgTEY+qrH6lC4UDHgOLxpQkHd6
         +sdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=VkkUqKsHd2dwOIO/Xg/JSf/WkBogcFEzgjutQEh4zvc=;
        b=pUT9+iufcqkgEO5wgpAogO3yYAsVsryCIMALPpSSJW42iMRUWUvW6DYO7urRETSFtA
         pDuHB/kf5cl3Ygy2jg0BRchuCAFD1fdOD5f+1ekJGeFbkoHqAhzZXoLp4jtCwOujVJ2n
         KmZFnJtnTt0xwV0Hg+FfEE8jgC4Gte4VrFAoNbIkr+ftkmsRYyBkIuTYtpUR9gHvd89E
         2CyLqSkPR21RI6/fumvB17NOGxKRDGHqEDbJ3Nkoi5cBKfzR2eEE6gohcj1byOh9MVXc
         kPeAiGrQyICM45Vg7ehRvVljbnWL9/aHWVSA1czmQxkh9sIQR+o6IGo3WZE77a3LeWrL
         +fnQ==
X-Gm-Message-State: APjAAAVaq4JXronQcFlY6N6q1s4LSH7qnNC7iTVJCh3gXESJEtSlpXaA
        m2FoSNDyCicVCcPnMKqIrs23Bq4It/U=
X-Google-Smtp-Source: APXvYqyQ6HIGMLKPwJR4sMacmqi8wF/AyZX/+uOHY6plDkExZ8q5qC/8/33KkAet5deodRJSi15KIQ==
X-Received: by 2002:a2e:9606:: with SMTP id v6mr16760530ljh.223.1576424927433;
        Sun, 15 Dec 2019 07:48:47 -0800 (PST)
Received: from [192.168.72.83] (h-235-202.litrail.lt. [109.205.235.202])
        by smtp.gmail.com with ESMTPSA id s22sm8599406ljm.41.2019.12.15.07.48.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Dec 2019 07:48:46 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
 <c6f625bdb27ea3b929d0717ebf2aaa33ad5410da.1576335142.git.asml.silence@gmail.com>
 <a1f0a9ed-085f-dd6f-9038-62d701f4c354@kernel.dk>
 <3a102881-3cc3-ba05-2f86-475145a87566@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3] io_uring: don't wait when under-submitting
Message-ID: <900dbb63-ae9e-40e6-94f9-8faa1c14389e@gmail.com>
Date:   Sun, 15 Dec 2019 18:48:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3a102881-3cc3-ba05-2f86-475145a87566@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UMMulyKq9dUZjpD0zuVJ021dmaSoYrByv"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UMMulyKq9dUZjpD0zuVJ021dmaSoYrByv
Content-Type: multipart/mixed; boundary="DCNTUnmK3E0hZSIvJaRjxh8hQ2GTe7IcP";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <900dbb63-ae9e-40e6-94f9-8faa1c14389e@gmail.com>
Subject: Re: [PATCH v3] io_uring: don't wait when under-submitting
References: <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
 <c6f625bdb27ea3b929d0717ebf2aaa33ad5410da.1576335142.git.asml.silence@gmail.com>
 <a1f0a9ed-085f-dd6f-9038-62d701f4c354@kernel.dk>
 <3a102881-3cc3-ba05-2f86-475145a87566@kernel.dk>
In-Reply-To: <3a102881-3cc3-ba05-2f86-475145a87566@kernel.dk>

--DCNTUnmK3E0hZSIvJaRjxh8hQ2GTe7IcP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 15/12/2019 08:42, Jens Axboe wrote:
> On 12/14/19 11:43 AM, Jens Axboe wrote:
>> On 12/14/19 7:53 AM, Pavel Begunkov wrote:
>>> There is no reliable way to submit and wait in a single syscall, as
>>> io_submit_sqes() may under-consume sqes (in case of an early error).
>>> Then it will wait for not-yet-submitted requests, deadlocking the use=
r
>>> in most cases.
>>>
>>> In such cases adjust min_complete, so it won't wait for more than
>>> what have been submitted in the current call to io_uring_enter(). It
>>> may be less than totally in-flight including previous submissions,
>>> but this shouldn't do harm and up to a user.
>>
>> Thanks, applied.
>=20
> This causes a behavioral change where if you ask to submit 1 but
> there's nothing in the SQ ring, then you would get 0 before. Now
> you get -EAGAIN. This doesn't make a lot of sense, since there's no
> point in retrying as that won't change anything.
>=20
> Can we please just do something like the one I sent, instead of trying
> to over-complicate it?
>=20

Ok, when I get to a compiler.

--=20
Pavel Begunkov


--DCNTUnmK3E0hZSIvJaRjxh8hQ2GTe7IcP--

--UMMulyKq9dUZjpD0zuVJ021dmaSoYrByv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl32VcQACgkQWt5b1Glr
+6VgnA/7BhwDS0X1P/h88c7DGyl8y3VWkFH01TDMVwJVVXL/8Le2WCh3pW+Qga2p
YcwlSES7mU24A0CEJiV6WQfQABOJWS4AQ/u7AP5vivktJAOO12t+ZiC2ln1d9FLV
GllTtB+wNwK/RLWwa6v7Rhgokp/xdkTFkIl+jKBffMZg682qB5j5AIeLykRcxTKc
rL40GT0EzzwSV5UOShYBYzH8xmCIJYpm3v/xxtYczqYf8by7PJEZt3bc+az4MXgb
/CavUNK+L1mz08V2E4cYhAPUGnC0rP3eXHfAEqiEvEKcqAVSuDkvRriF5kOYA0es
ZpgQt32TASsjj2NIJ0C3rsMvbG0rTTephpe6AAbBb7YtWlIBxOk1zlQVvnLutXst
jIFbCILpD1l1egaUOyJ7lWVjXwsdHabwDe7RyzyXGwoF8j/J6nJf8oM6BKNcOPLS
VWK68osVxKpiSBEQnu+AI0V8xf1Y8XoKe3WSBPSQAzWdNK6u1EZKgPOprDbkXJ0L
nM3AbiQXvxz3gEELaE3A3+HBwQ5vQMVvpsxh+Cuwd5FVPnKkNMOLbpdLy7ejBtAM
3DqD6LvAf9OnjjBOZgGACJekwljeTI5sdDggIuPWCycn/7qUjEXWNOg3H8hsuH+b
G5kTNh4AhknG/yhuUp4RrG491v31dz4maEvDysqik8C7NC7BN28=
=kKXG
-----END PGP SIGNATURE-----

--UMMulyKq9dUZjpD0zuVJ021dmaSoYrByv--
