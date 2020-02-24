Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E0C16AA80
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgBXPvr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:51:47 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:35013 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbgBXPvr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:51:47 -0500
Received: by mail-wr1-f43.google.com with SMTP id w12so10973496wrt.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=09VOxUWFkpeErLTK9WDJjfQhP65HkKzNFD/Pp53jrmg=;
        b=ndh//c2bBO9VlPX8Zb+H68RCU2C4SluVukfDMs82SMFte2UtDWMoqSUDZs87YVDVOx
         LNw0mHsXJIDR2T392ae4C9y+ZWBaWW/aGUNz9qEPrdxDM3uiWd5Eib+Q5B7CouODkAn5
         o01XPn9mhF9MBQdLPD3bOi+l407FoE7Wt9hX9craK/Sg1lqH8HH14Eovk9JO/ADzQpLV
         TpseQOsWbKviOhBk/xShQIL64saDVJtyTsTwQoftU81ojNIoPadlbPc+Fg0LILiv92ii
         CTkdvBFeSYVoXY4HKfkI7J4+cNtJV7+IunOK9SZ/jJ0G15VqIJSFDQfh3hROHS86WWTp
         armg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=09VOxUWFkpeErLTK9WDJjfQhP65HkKzNFD/Pp53jrmg=;
        b=FwUG9MJxR4RJv7XBbguEryjYD/n2JHX1y6GEG19GkdwQnb5WP8K0suZZSamUYCTQUy
         zre0Jw0i5DfhAmwz/PcY0Mx/95y1Gsq4rHFl6v/uFeaXOEUpukIgtErmkN+RonjKm0Km
         qhq0CgT3/MDs3Iafgp5gwktUDzlW3o4oSiLSOKmNQyOzNEwZQhhfwuwieyOP+ruaBmfs
         kQndkIwUn7PH7SMb/D+dSX88kZ1g6X4x/wz5SOjkxftfA82Z7lYjZetWekf3KZ9AYzcm
         e/5TNoZqawvJ9pnf+/4Tywvm6N2ZiQv0p3EZ6RL9u3mJy39QZaX/hEsVNbuVHmSWe8iX
         hLxQ==
X-Gm-Message-State: APjAAAX2lY+kJ2aoUOVuZLX1cQMkHpr69UE+PIK7an2L/wdra36Cggg6
        0bMuiac7/sIEXxypkts5f9lI0+mo
X-Google-Smtp-Source: APXvYqxboO92teNDXMKGb/Rl4zbMBqheTwCB85Z6WTCFeN766wB2EHwqCeHvqwr5k5HceOYOpg7U8Q==
X-Received: by 2002:adf:cc8b:: with SMTP id p11mr17112745wrj.8.1582559503881;
        Mon, 24 Feb 2020 07:51:43 -0800 (PST)
Received: from [192.168.43.177] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id u8sm19092393wmm.15.2020.02.24.07.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:51:43 -0800 (PST)
Subject: Re: Deduplicate io_*_prep calls?
To:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
 <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
Date:   Mon, 24 Feb 2020 18:50:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gl9bfTSP80sQavgBLCb0eYjtA7NOzupuB"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gl9bfTSP80sQavgBLCb0eYjtA7NOzupuB
Content-Type: multipart/mixed; boundary="YYezAY2l2WlDLrt6P6RFF5e7E2FK94Uwh";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>
Cc: io-uring@vger.kernel.org
Message-ID: <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
Subject: Re: Deduplicate io_*_prep calls?
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
 <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>
In-Reply-To: <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>

--YYezAY2l2WlDLrt6P6RFF5e7E2FK94Uwh
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24/02/2020 18:46, Jens Axboe wrote:
> On 2/24/20 8:44 AM, Pavel Begunkov wrote:
>>> Fine like this, though easier if you inline the patches so it's easie=
r
>>> to comment on them.
>>>
>>> Agree that the first patch looks fine, though I don't quite see why
>>> you want to pass in opcode as a separate argument as it's always
>>> req->opcode. Seeing it separate makes me a bit nervous, thinking that=

>>> someone is reading it again from the sqe, or maybe not passing in
>>> the right opcode for the given request. So that seems fragile and it
>>> should go away.
>>
>> I suppose it's to hint a compiler, that opcode haven't been changed
>> inside the first switch. And any compiler I used breaks analysis there=

>> pretty easy.  Optimising C is such a pain...
>=20
> But if the choice is between confusion/fragility/performance vs obvious=

> and safe, then I'll go with the latter every time. We should definitely=

> not pass in req and opcode separately.

Yep, and even better to go with the latter, and somehow hint, that it won=
't
change. Though, never found a way to do that. Have any tricks in a sleeve=
?


--=20
Pavel Begunkov


--YYezAY2l2WlDLrt6P6RFF5e7E2FK94Uwh--

--gl9bfTSP80sQavgBLCb0eYjtA7NOzupuB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5T8OMACgkQWt5b1Glr
+6Vo/Q//RI4TjbKnKQStLSuiAgzUsfP0FV7biFav30Mt6RyNULyA/1AVilYGjrw4
EnZkfj5vSebc3fmRxYd9LE+jUHt2eMOXcYZABkETSjzZYGCfq++cueEh1WAw9rNx
2KYzo3Iy5Ij3xOwLIOhSBzQyaP1rL0ANsl9gkyz4Pl87c3za8XbFZsZ/Xg5qKaUf
3lEboYFncyP8cYuobITdndThrH0zCWygXs7NHAqACGKOKZhnVXKmpeqtSzNwq7p+
Z2TSYOJFmUA7NhGPrv3itVJkJeohr7zG4gOzMHiHfLI8lg6M50ghEJ4XWBeCQa+U
axP4Bhb8Nx9jVB40+Jvn2QcNbmweL/zpiGUFyuf8Z8GDxV3pfolN5Vr0AYw0+AZ+
tEWnMjNtQnGBUBkbUGwfhTGC46fSTwDGhMdGFvZkRth642A40o25+4AW5Wbyd7vt
k7rodNypMDuTDZubGf+keUKFytNeS4Quo/5EhS4xvahsAg3pQoHgQ+C2dC+n2Tnl
gMTMZJrMAYhawYqbCmpZzcsUj19kdrixGqBhui4vIcv9jNJA0yq4a+indDHLjM3K
MlWeDko9Zn0eJTwq1DzVVHIs23lQNYAKPnxcBE97G1jwxeZi7pPhBToKqwtqOexU
iSFULd39iZ1JxTGevjsqP51ijjaH4eXSUxiQ7+OjIJ/Ti6XTN14=
=VK0t
-----END PGP SIGNATURE-----

--gl9bfTSP80sQavgBLCb0eYjtA7NOzupuB--
