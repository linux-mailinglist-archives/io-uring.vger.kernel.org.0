Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0FAA16AA8E
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgBXP5f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:57:35 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:53061 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbgBXP5f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:57:35 -0500
Received: by mail-wm1-f53.google.com with SMTP id p9so9493054wmc.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=uh7zQa/YMj/IN90JAfIqS4qXW/WXnBw7ej8pdpWyY10=;
        b=jT3YwVVgOEG1tDEYERbW0YcaQv2hqXK7hlYJ//CJ+xTyhaVgsiczzizFqSofjLlm2c
         +uLRlwUeF6WJWwLuT1Up1CqLssV6mmqYrVVcSYjizXLrkUJEjGLxG7hvV8BKcO9q8BT8
         +3jVylsZVBIG+xZlIX7JYBosKpfTdE/1ulE74/qu405dvpHC8JsKB8XpscylmuHYAV/n
         8DA9buvQAGY7AxD0YA8EHdnvgkMGEz5Ucr6gvf0p16ictWenG3B8gmw0zkBgNnM2U06E
         7pvPo83F/e1L961KqLROZhcET6DzAokcPlW7optI7diZ1SaZRMLN7ibCY3jLKwML1Nqi
         FVMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=uh7zQa/YMj/IN90JAfIqS4qXW/WXnBw7ej8pdpWyY10=;
        b=BjX31WbmdkCIKDislEHmgFpN9E/ldQwd+qP7IYUUztsu2g6fFT83R94qEHBvaNVEOf
         CCYNGZo6SesrKlPvJSwAWf3XmzkLdhPYqT3Rx6O+KsoPlNQz1HRaaWnGV2tDva0VENOk
         gIpA3Z9Gw/a24JkWoiEwgWB1xfm1jhXrM9WSm8Km4fqnofgMgXb9QHFNCRR3gGV8qLiP
         MkM7XD/5wcLZIdtJ9YXI4kYYAAxWM7/CRbeG9olmMiZK5B4P9EcLNK7332+qwabB6QJj
         3FoZXRnTwgulksgt8/JhE1jOdP+oL48CwXQG0kvvt+slIm9rnfIcBMCv9de+2pyOYgBw
         fRNQ==
X-Gm-Message-State: APjAAAUwQG3VXVnnwdrqLBK1HroXKu8r6BuWiDm8gxYVc/2IfeQbKw9q
        y1B/hOV1NhIhDQyw8BBbG+XaxU8i
X-Google-Smtp-Source: APXvYqwgPTxQGeKRX6PVia6urXcl0eTV3AtJSFX9nKXtIzriknQ9we04Y/4xsUwKCZFz3cOeWXGvZQ==
X-Received: by 2002:a7b:ca47:: with SMTP id m7mr22765660wml.4.1582559852468;
        Mon, 24 Feb 2020 07:57:32 -0800 (PST)
Received: from [192.168.43.177] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id e1sm18896363wrt.84.2020.02.24.07.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:57:31 -0800 (PST)
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
 <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
 <c17acad2-89f6-b312-f591-c9e887b4fc2b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <ad07fe70-ea45-a1bf-21c3-9af241bdef15@gmail.com>
Date:   Mon, 24 Feb 2020 18:56:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c17acad2-89f6-b312-f591-c9e887b4fc2b@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cPG4IVSUowUrAHJL5uYJYoJO09P1apBr8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cPG4IVSUowUrAHJL5uYJYoJO09P1apBr8
Content-Type: multipart/mixed; boundary="7KhBISCoFt8dSU1XA2vI0H42WTML1mi8Q";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>
Cc: io-uring@vger.kernel.org
Message-ID: <ad07fe70-ea45-a1bf-21c3-9af241bdef15@gmail.com>
Subject: Re: Deduplicate io_*_prep calls?
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
 <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>
 <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
 <c17acad2-89f6-b312-f591-c9e887b4fc2b@kernel.dk>
In-Reply-To: <c17acad2-89f6-b312-f591-c9e887b4fc2b@kernel.dk>

--7KhBISCoFt8dSU1XA2vI0H42WTML1mi8Q
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24/02/2020 18:53, Jens Axboe wrote:
> On 2/24/20 8:50 AM, Pavel Begunkov wrote:
>> On 24/02/2020 18:46, Jens Axboe wrote:
>>> On 2/24/20 8:44 AM, Pavel Begunkov wrote:
>>>>> Fine like this, though easier if you inline the patches so it's eas=
ier
>>>>> to comment on them.
>>>>>
>>>>> Agree that the first patch looks fine, though I don't quite see why=

>>>>> you want to pass in opcode as a separate argument as it's always
>>>>> req->opcode. Seeing it separate makes me a bit nervous, thinking th=
at
>>>>> someone is reading it again from the sqe, or maybe not passing in
>>>>> the right opcode for the given request. So that seems fragile and i=
t
>>>>> should go away.
>>>>
>>>> I suppose it's to hint a compiler, that opcode haven't been changed
>>>> inside the first switch. And any compiler I used breaks analysis the=
re
>>>> pretty easy.  Optimising C is such a pain...
>>>
>>> But if the choice is between confusion/fragility/performance vs obvio=
us
>>> and safe, then I'll go with the latter every time. We should definite=
ly
>>> not pass in req and opcode separately.
>>
>> Yep, and even better to go with the latter, and somehow hint, that it =
won't
>> change. Though, never found a way to do that. Have any tricks in a sle=
eve?
>=20
> We could make it const and just make the assignment a bit hackier... Ap=
art
> from that, don't have any tricks up my sleeve.

Usually doesn't work because of such possible "hackier assignments".
Ok, I have to go and experiment a bit. Anyway, it probably generates a lo=
t of
useless stuff, e.g. for req->ctx

--=20
Pavel Begunkov


--7KhBISCoFt8dSU1XA2vI0H42WTML1mi8Q--

--cPG4IVSUowUrAHJL5uYJYoJO09P1apBr8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5T8jkACgkQWt5b1Glr
+6V6tQ/+Ki+5zbVAw/0FcK/E4G5GLqlPK1wP/9WZigG1NiFd+B4WsAKtx/dg3OEJ
1myu5zm48DIfBZ8uNO5Z7WFTvN6zqAknryJjg8nA65SmqT3Swl9J8mjm94jBX+xM
xMFXjF9LKEPXkabVZa5Hw7jjqypgb9vCR0IgOVfPflpDnYueeeHL0ubff0aBKnM9
5BxoO0Diky8RK811VoNUnghgSDAHCCZ2udrX42f7ojmKnKt1HLh4SJn/UbQuJX+B
02E2aKT+1/mewR8mQm41fXdJ3cauSSJ4sTQOTGm0YQBvzQ/oIidX1iHI9ex3tWem
saLempajqNPSqwfcWpz2s2qZMWngNUkXUj3Nfo4T8ZyWkFJtSRZOkJMC7gqalHC5
9KgSyVC0pH7OWVPHRiN7j23aNBPobgqGk8JwOzZh1S1zv4WFJthXWsRznlnMg4V2
HWwEuH9HWWgGrwcEjTAwlDmCieeMWVYJf0Y0dKRzvXZVqcnEqD21fjk7uagUUqbt
gak7bIbuORiltS07iQxYcUrp7PqvMZfBiyd1qEhzHzcEgJOVrKq33LkPs8jmREDY
IoOTYa83FT5o9/qR5JGYsua8QiU74486LtbTievrVzHwGErQn1rWE5Xag5lgEBw2
71EDxuFCK+yvXHiUmSnAXmsAGh5JGuAfdQN83z8MbPQ5k3PrOB4=
=aIwS
-----END PGP SIGNATURE-----

--cPG4IVSUowUrAHJL5uYJYoJO09P1apBr8--
