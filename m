Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBDB14FAF2
	for <lists+io-uring@lfdr.de>; Sun,  2 Feb 2020 00:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgBAXax (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 18:30:53 -0500
Received: from mail-wr1-f46.google.com ([209.85.221.46]:38475 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbgBAXax (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 18:30:53 -0500
Received: by mail-wr1-f46.google.com with SMTP id y17so13126532wrh.5
        for <io-uring@vger.kernel.org>; Sat, 01 Feb 2020 15:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=smve11La2Qnfl/+8MAUx0A7ND72wqLsW3xI7ngRaJDg=;
        b=AtpVlG6uAiW8CNW7nTgUZy3VWeuPwgNRGK3HYXSZsVz/E6xKzzkVm16dp3DeJf4Fil
         GUcHC/wqeTxLMjSQMgpmHWDXFeoN3jrm2TiSqwarocOkzgi/McvquLfX4kIfK3MAmOL+
         h/gXP7bbSeCKKpQeV3hzIwUUjwOHZAdsDO154BCqDHFpahE02FG3WFOGO5+BmJEMtTmU
         cqWsz7xRwLHNO6+5hIgAr/EvhCk6+pNypxTxe4Uy87Epe6vDJSTbDKMuDpZfQcCrfIYB
         2B9RfLoY1yhUBvaIxbHL4RGMyaeHa8QtR/kG5B6od+W2QyWmiGHHBpn/0tSCcBiWJWIs
         iCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=smve11La2Qnfl/+8MAUx0A7ND72wqLsW3xI7ngRaJDg=;
        b=CUg0bet6xZ2eI5MtYicaTAzeCtd4iUAxET8LHjAJWTp3O4iU7u3V0x6Q0BN6QrnvOa
         6fOa56e6dF52FgocULIMWtyeiPJwNYeQsR+pL2LHPikBMeWiNxBh7HFneACDnRTK7Y+G
         PZ3RnAEACAhWH0V7/b8er917QC9OL4EndRMNv4EeSrydvuR6liWiKBB++FDUxzNPz6R0
         OK4MmCU5MCd58o9lYeyeHAXn1EWufYu6stRfDteVOkXCyO92fnOD94DlP92oug+CkeyY
         MR90k8jmScsCCqNi2t7rxnWFZXtJ3wjbeN+s7XO2TX7KuTkCqmMtPc74JH0qIWKQh/wp
         E2Rw==
X-Gm-Message-State: APjAAAXn7Mq+QA6EPAo6dxCGD4tSnWPwZ8hCf9bBbuCQwXVCyoyrBTyd
        i4mrEHVjMR7NCDyT/fG4Ts49+mVL
X-Google-Smtp-Source: APXvYqwH1kF9GpuUBEGcjxuO8l9P5WZSdO9v2HZkx7tDJWypkz72k8KMSR/JVFm/nXGylbJlRkkOEQ==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr6637796wre.372.1580599849965;
        Sat, 01 Feb 2020 15:30:49 -0800 (PST)
Received: from [192.168.43.154] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id 25sm16912253wmi.32.2020.02.01.15.30.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 15:30:49 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>,
        io-uring@vger.kernel.org
References: <20200201125350.vkkhezidm6ka6ux5@alap3.anarazel.de>
 <ed2fd00f-b300-6d9d-a6d5-f76bbc26435a@kernel.dk>
 <78A9EC3E-0961-4EF3-A226-1FCA34FAF818@anarazel.de>
 <aac42d1e-24d5-4c2d-d1ce-eb8ceed48b1e@kernel.dk>
 <6f5abe8a-1897-123d-d01d-d8c7c5fba7c4@gmail.com>
 <e57109e7-357f-3ab5-4fd5-0488cf2021a0@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: liburing: expose syscalls?
Message-ID: <9644308d-ef0e-1b94-9a3b-1a4e03bfd314@gmail.com>
Date:   Sun, 2 Feb 2020 02:30:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <e57109e7-357f-3ab5-4fd5-0488cf2021a0@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NElslvWE609yywKzFnyekx2BOgzt8E1Z9"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NElslvWE609yywKzFnyekx2BOgzt8E1Z9
Content-Type: multipart/mixed; boundary="I0MjrXWVK5ZfSANd9uiil9pdCfCs9o165";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>,
 io-uring@vger.kernel.org
Message-ID: <9644308d-ef0e-1b94-9a3b-1a4e03bfd314@gmail.com>
Subject: Re: liburing: expose syscalls?
References: <20200201125350.vkkhezidm6ka6ux5@alap3.anarazel.de>
 <ed2fd00f-b300-6d9d-a6d5-f76bbc26435a@kernel.dk>
 <78A9EC3E-0961-4EF3-A226-1FCA34FAF818@anarazel.de>
 <aac42d1e-24d5-4c2d-d1ce-eb8ceed48b1e@kernel.dk>
 <6f5abe8a-1897-123d-d01d-d8c7c5fba7c4@gmail.com>
 <e57109e7-357f-3ab5-4fd5-0488cf2021a0@kernel.dk>
In-Reply-To: <e57109e7-357f-3ab5-4fd5-0488cf2021a0@kernel.dk>

--I0MjrXWVK5ZfSANd9uiil9pdCfCs9o165
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 02/02/2020 01:51, Jens Axboe wrote:
>>> So you just want to have them exposed? I'd be fine with that. I'll
>>> take a patch :-)
>>>
>>
>> Depends on how it's used, but I'd strive to inline
>> __sys_io_uring_enter() to remove the extra indirect call into the
>> shared lib. Though, not sure about packaging and all this stuff. May
>> be useful to do that for liburing as well.
>=20
> Not sure that actually matters when you're doing a syscall anyway, that=

> should be the long pole for the operation.
>=20

Yeah, but they are starting to stack up (+syscall() from glibc) and can b=
ecame
even more layered on the user side.

--=20
Pavel Begunkov


--I0MjrXWVK5ZfSANd9uiil9pdCfCs9o165--

--NElslvWE609yywKzFnyekx2BOgzt8E1Z9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl42CgAACgkQWt5b1Glr
+6VfYBAAncFUI8RJvckuXILB3fxhgc+ZEVv4n4CUsRhmL0QqJROJ7dsVYoA6egpa
VQKftt3UzB/05In4o17Xigc0M1QQvaVIJ61/lRIkQTyt6lQ1Z+e+UKLQoyKXYzZi
vi/Eaq4VwnJ4ge+Bb1dPfJDJHLUzirrnAVW/V0n5L+M1guOfOIuoh7OSXoQoq2oW
9aqPcYZx/3BDGaKlQEbad79bPg7TArvWC+zeSFL1Qxf0k1vOE3v97vvgN7rCunhI
IgYiJw3wIGdPQyZOiw5p7tW1ngolradpLENgSpqMr/qjKbCJN/EQLSzVbT2N1XsE
KfqUYVNT119P56gqbn9w84ruJxTu53IHGnxhcFYqogwksnnp5BG79G16TcL9B3oJ
2VQacCSjhqpztxxW9Rut4imljU5fzOd0snacZvebzsxcm20/TTdZjok5sIAl9aNd
J5BxhQ4MB2H6cEYTg011LOwYMF55s4bCLVk8Igq6ywSzqTvtSm7CHIjFj70g1guw
OEqL1+ChVAJshoLQ7YVFx08y/eRHL6ETTgEBVG/H7uuTVcIsAv0tqeBoFFVtsqDb
I5MhI2LwPriv8e9i9XeIcS5V7DIgyYZoLp/pgQoLhBCfetu7cbN0FFBs9NIzHtzF
5gdjlxDSVTKYi106ssZfXIdBRvW/CerP/Sv+fDTMvxGzz6Tt+XQ=
=Ox+5
-----END PGP SIGNATURE-----

--NElslvWE609yywKzFnyekx2BOgzt8E1Z9--
