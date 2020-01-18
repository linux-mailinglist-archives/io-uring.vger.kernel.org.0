Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C398014189C
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2020 18:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgARRLQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jan 2020 12:11:16 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40603 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgARRLP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jan 2020 12:11:15 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so25533860wrn.7;
        Sat, 18 Jan 2020 09:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=6KAupvpYXibRFjCwgZ/Dym8AX2CDcVnEUkg77z+Fy84=;
        b=qINgBfmKU0wU73hCj5590Il9uJAqckGhZTOb9RXiE8iZn4sn/anrzjZstbcyYJzCaY
         tn67XKTO/YeA4I2LGF0/Mej7o74oaveqyNztbz6184F0RqW7EhLkbTBFnaCumewQuJUF
         v2Fu7BjTmfeA0G9ivzHwTp3K2dtlajNgXMUmHYtvTqBJdvddkD9UhLwk/kHfV3HAYeb2
         OIh1Gw/EQAePY/24ILJLifSX8ViksXz8DiRSIQg9AkuVZy4p54zgaFlfgm5Jhklvck9b
         Bg5KC/MfftaO/3ptu4MyuZAW2bdAKka83eX1nyyPeSQ3foPAw9MISYrE42CRE8IO+EjR
         g6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=6KAupvpYXibRFjCwgZ/Dym8AX2CDcVnEUkg77z+Fy84=;
        b=t5MXFJ9u9cNMT/w9g/v9QviEkwb8fmVL7C5blNW8T2wtApRXJB5Io+gmvRH7oSkX1T
         aTBfUt1C2yi7vPi6uGEMd5KAGYKGjdtYLMKT4nKTEr9iXDhG/kCT5HnvZNsJSdNVjeul
         yXmRpKFvyrRqqrbb3UdyByMfekog1j3BUkMYk03wVXD2ciLZZqJoii/UubGb66qTXGYY
         kuWZU0rxU+IJb1wKA15rI1RVFAbsq5uPnPE1g8E1aNekWU4x/gdZIgWoGR7FIMPEUJpT
         eczgZ9pu1Sr5QJKAoHmvyVgOXePsoA780S/MH+fEKAHNKi99mysny2ia7PuuzFMGjIJB
         u9Rw==
X-Gm-Message-State: APjAAAWiDAV0DzCgBwg7RVvEn/fKKkyiHELEYiRKdMLvuIKR8SczhdmA
        WPlH5XBiJbvgaBYd6m8m4XEeeut0
X-Google-Smtp-Source: APXvYqwe2SIu2obTiCtAIQc3c3EupQ7XZmH3UifDHguEPqosY9771xOiwKuNzjteCYDnKKCeBf+Uig==
X-Received: by 2002:a5d:6388:: with SMTP id p8mr9355666wru.299.1579367472478;
        Sat, 18 Jan 2020 09:11:12 -0800 (PST)
Received: from [192.168.43.97] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id v3sm39053998wru.32.2020.01.18.09.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 09:11:11 -0800 (PST)
Subject: Re: [PATCH v2] io_uring: optimise sqe-to-req flags translation
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <b507d39e-ec2b-5c9f-0fd0-6ab1b0491cad@kernel.dk>
 <06bcf64774c4730b33d1ef65e4fcb67f381cae08.1579340590.git.asml.silence@gmail.com>
 <b773df2f-8873-77f3-d25d-b59c66f3a04b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <ad7c75c3-b660-9814-e3fe-ef5a3acd7e8f@gmail.com>
Date:   Sat, 18 Jan 2020 20:10:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b773df2f-8873-77f3-d25d-b59c66f3a04b@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VaLzrURkBKtSW7q8os4X3INVznB4BgG5l"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VaLzrURkBKtSW7q8os4X3INVznB4BgG5l
Content-Type: multipart/mixed; boundary="NMwEfu6mC54wnwHXyA8NuxVNzM0M8M5CT";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <ad7c75c3-b660-9814-e3fe-ef5a3acd7e8f@gmail.com>
Subject: Re: [PATCH v2] io_uring: optimise sqe-to-req flags translation
References: <b507d39e-ec2b-5c9f-0fd0-6ab1b0491cad@kernel.dk>
 <06bcf64774c4730b33d1ef65e4fcb67f381cae08.1579340590.git.asml.silence@gmail.com>
 <b773df2f-8873-77f3-d25d-b59c66f3a04b@kernel.dk>
In-Reply-To: <b773df2f-8873-77f3-d25d-b59c66f3a04b@kernel.dk>

--NMwEfu6mC54wnwHXyA8NuxVNzM0M8M5CT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 18/01/2020 19:34, Jens Axboe wrote:
>> +enum {
>> +	/* correspond one-to-one to IOSQE_IO_* flags*/
>> +	REQ_F_FIXED_FILE	=3D BIT(REQ_F_FIXED_FILE_BIT),	/* ctx owns file */
>=20
> I'd put the comment on top of the line instead, these lines are way too=

> long.

I find it less readable, but let's see

>=20
> Let's please not use BIT() for the user visible part, though. And I'd
> leave these as defines, sometimes apps do things ala:
>=20
> #ifndef IOSQE_IO_LINK
> #define IOSQE_IO_LINK ...
> #endif
>=20
> to make it easier to co-exist with old and new headers.
>Yeah, good point!

--=20
Pavel Begunkov


--NMwEfu6mC54wnwHXyA8NuxVNzM0M8M5CT--

--VaLzrURkBKtSW7q8os4X3INVznB4BgG5l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4jPAoACgkQWt5b1Glr
+6XAgA/+NcL8MSNI1xVGJ4BHFNYRSXt7rPxNMRdXU1HMLVwCDGTvBxISSgwROftF
hwrTTgqvAPUnZI74AVbiUSLpjIbfjDw4VTB/K24FeF0JLXkz0FARDXQiNCczYW+I
xAGTcTKghrnYTInVajBZGeD6Qc/lH7B6RLOZniRrR5n+Yta+YsGHd0S5GEhEPjyp
pq6PjyTHq1P5pqY+Mmc77vZ5LMhL5ij1EseyZhHLqjBu6KxfL/dvwnM66d0kmD5m
liJzDl5Ys3f9i+VIjW8ly5U4gMxS/F6Zfc1X5W6iN5LhWra1KigfVklqqtf8JJC2
o4DAeUC/TGeZKY5swB2T1drbb6EucZennVRC4xnA75W3i4rJ6oFvF+fvxbTo3sN0
Zu2OWZNKxlMrgdXnsQ6fuRlCi7OSLaZz4i27AaZl4KGanGFjUfCh9Y2fAaOf+Yyb
/YoVkBN91ZM3gPele/FtLOt3qs4+1XEFKl6c/jW0/bxJAn4LGkHz9JFjNT/r2lPc
BPl08dRbWbKQURy9/qxR1g2RaLEpL/KW+RCsI3y3+Wt5l8K9tZ0UbPIt7baAxlnM
oJtWJ6PAmnDSNdFOsh808AeIqZoM6RUCg5dPt5j38VBHZNnTktjimCniCjlZLL4u
t14tHVdFWEHeldEqcg4FNE/Mx2zQKxRVu9cx6Y1jJLs8QffFKUc=
=SijY
-----END PGP SIGNATURE-----

--VaLzrURkBKtSW7q8os4X3INVznB4BgG5l--
