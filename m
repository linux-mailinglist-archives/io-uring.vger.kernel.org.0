Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D4C14F86D
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 16:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgBAP3B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 10:29:01 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:40452 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgBAP3B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 10:29:01 -0500
Received: by mail-wr1-f48.google.com with SMTP id j104so12215377wrj.7
        for <io-uring@vger.kernel.org>; Sat, 01 Feb 2020 07:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=mL+uVO67pQij1vpF/K02DbToFsy1JMLXgXD6Zu96et8=;
        b=SytppGYSTXfauQs2sffuGJWf23b9C8BPDptI/MkUz1hPH17Tr3J/vbuqKbpZXkCXb5
         QpPYAbWDXL7/UKlhrNfETE1gXNGQZShZ8sbAXx/Ofk+Nfj4abABk63JxjpXKxibkEFA6
         dlnwaSNIv7Ps1BO9Qf2LeGFc0/9kM7bcIwKMSLHMoHQJT4QAolCBleqtxJLB/u+mGVS1
         IjlXi9MRe2gP577Q6YFWhXC3gN+SJ4HowpGLXHGMj39B9eXMSF7sCvrm+LRWk34evqKq
         8s0hA2HZ9rRaps5P/Ho8lBhrwvUNOr5MCdbI9ONHRI3XGngBItMwJLUhdCioFhVwUEY7
         deWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=mL+uVO67pQij1vpF/K02DbToFsy1JMLXgXD6Zu96et8=;
        b=ST3xACU65qmU64HKGcN6fC5vvxWYE2ituZN5DiBonKGTxOsKGyLMhKUZzJN4+3A2l8
         eBT0cKsZlfmN8OsCG5jMRSedoc3m3YfCa6FKTjXtV+pChdFFkLkze0tEFB1Kw/rn8t3Y
         K4qdeo0SfiCV6JazuvbK9he4FK8WSRq3uO4Y8rr3xoD7a/TNbBZOlIMnAs33wjkgwS2d
         mfF6xHOgVBgisb9sTY777HSH0hu1vjldaS1Lhmd1w6W5SvPYzbdJMQ7IZB7FUVw5rwh1
         KrJVqwxpduvWW47tf+fwyymytQJCgadMWRrwNguCM05q1uX+Nr3oTi1oeAH2zqbLbBQQ
         cj3A==
X-Gm-Message-State: APjAAAVw8YGDqIGxzA9+5UYmtrJ0zb8Ba6ShbMoE/v+7FTI7eWV9kc0S
        DaYGrmai6gkb6aG2aqVolFMmihSC
X-Google-Smtp-Source: APXvYqyB7BAZ9ypNlc+YduYrW6nuB+WmlI6w9Y5QyDJT5xOshBNRKFB0k4/IwO3fm9LNIYxN30oBWw==
X-Received: by 2002:a5d:5263:: with SMTP id l3mr4908358wrc.405.1580570936852;
        Sat, 01 Feb 2020 07:28:56 -0800 (PST)
Received: from [192.168.43.154] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id y7sm15010089wrr.56.2020.02.01.07.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 07:28:56 -0800 (PST)
To:     Andres Freund <andres@anarazel.de>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20200201091839.eji7fwudvozr3deb@alap3.anarazel.de>
 <a7d492a6-b8cf-4128-fdde-879371b7913f@gmail.com>
 <20200201120229.l7krkt6zstiruckf@alap3.anarazel.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: What does IOSQE_IO_[HARD]LINK actually mean?
Message-ID: <fea55a53-9c78-8073-97da-de0bd71fc9c2@gmail.com>
Date:   Sat, 1 Feb 2020 18:28:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200201120229.l7krkt6zstiruckf@alap3.anarazel.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cVJj2cBW87o0jxY5taEqrdK1ofi5aTvzS"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cVJj2cBW87o0jxY5taEqrdK1ofi5aTvzS
Content-Type: multipart/mixed; boundary="9mfaamrxrZ0oMHBEvwup6BJ0VKawoVAmK";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <fea55a53-9c78-8073-97da-de0bd71fc9c2@gmail.com>
Subject: Re: What does IOSQE_IO_[HARD]LINK actually mean?
References: <20200201091839.eji7fwudvozr3deb@alap3.anarazel.de>
 <a7d492a6-b8cf-4128-fdde-879371b7913f@gmail.com>
 <20200201120229.l7krkt6zstiruckf@alap3.anarazel.de>
In-Reply-To: <20200201120229.l7krkt6zstiruckf@alap3.anarazel.de>

--9mfaamrxrZ0oMHBEvwup6BJ0VKawoVAmK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 01/02/2020 15:02, Andres Freund wrote:
>> Right, after a "failure" occurred for a IOSQE_IO_LINK request, all sub=
sequent
>> requests in the link won't be executed, but completed with -ECANCELED.=
 However,
>> if IOSQE_IO_HARDLINK set for the request, it won't sever/break the lin=
k and will
>> continue to the next one.
>=20
> I think something along those lines should be added to the manpage... I=

> think severing the link isn't really a good description, because it's
> not like it's separating off the tail to be independent, or such. If
> anything it's the opposite.
>=20
>=20
>>> Looks like it's defined in a somewhat adhoc manner. For file read/wri=
te
>>> subsequent requests are failed if they are a short read/write. But
>>> e.g. for sendmsg that looks not to be the case.
>>>
>>
>> As you said, it's defined rather sporadically. We should unify for it =
to make
>> sense. I'd prefer to follow the read/write pattern.
>=20
> I think one problem with that is that it's not necessarily useful to
> insist on the length being the maximum allowed length. E.g. for a
> recvmsg you'd likely want to not fail the request if you read less than=

> what you provided for, because that's just a normal occurance. It could=

> e.g. be useful to just start the next recv (with a different buffer)
> immediately> I'm not even sure it's generally sensible for read either,=
 as that
> doesn't work well for EOF, non-file FDs, ... Perhaps there's just no
> good solution though.

People already asked about such stuff, you can find the discussion somewh=
ere in
github issues for liburing. In short, there are a lot of different patter=
ns, and
that's not viable to implement them in the kernel. There are thoughts, id=
eas and
plans around using BPF to deal with that.
I've sent LSF/MM/BPF topic proposal exactly about that.

>=20
>=20
>>> Perhaps it'd make sense to reject use of IOSQE_IO_LINK outside ops wh=
ere
>>> it's meaningful?
>>
>> If we disregard it for either length-based operations or the rest ones=
 (or
>> whatever combination), the feature won't be flexible enough to be usef=
ul,
>> but in combination it allows to remove much of context switches.
>=20
> I really don't want to make it less useful ;) - In fact I'm pretty
> excited about having it. I haven't yet implemented / benchmarked that,
> but I think for databases it is likely to be very good to achieve low
> but consistent IO queue depths for background tasks like checkpointing,=

> readahead, writeback etc, while still having a low context switch
> rates. Without something like IOSQE_IO_LINK it's considerably harder to=

> have continuous IO that doesn't impact higher priority IO like journal
> flushes.
>=20
> Andres Freund
>=20

--=20
Pavel Begunkov


--9mfaamrxrZ0oMHBEvwup6BJ0VKawoVAmK--

--cVJj2cBW87o0jxY5taEqrdK1ofi5aTvzS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl41mQwACgkQWt5b1Glr
+6Wrjw/+I3H5NGbpZY6Cn1m0SCEmPMy0R+O7ClqP2xibfLX/DnyWGyr+pno2H+Zh
8sr7yprwRwKo+n4BHCVsxSv7VPPkkuBsq883fSysWY9OS8b49wLnFsyPI53uHGZc
bfQT4/vt1+ByGzelaUFtJmlMLMO+JOVB67GyTwcgGUj9yv3G57Q/XV6NBRVd3tNu
vOvBEj3JY4JNvYTORm4wqcV3zr4KDrYLHz76+rH4TVY3rldz8Y4vQQEjBuSDBhcT
yvY87frOKpwR7aADomoImpIzvN8ueIrlhIUMRjvYJezyTR3cE9TtRO8lYF+qNA4g
jFeKpsjxD+P5rUxs936aXSGGh0yx3jF3GCe5PcO7KqZziMhTXTqLSrCdioqUAMC0
7i0nQW7SNZoS+ID/5IAa4/2iRGpyHU2ahBMSABvYlmUIellnPNysySdjMCT4dn28
7SeggzCq6zUiZavISmHjRwvLwveMjLWsMyKBw9L/CN12UDqmnHBBXyukT3NiOx1S
3z2v8bUXNWQjveO2CdGBW1W7mkDmJp4IzI5Jn1ECWR4RijHKz8v9dsru6we5ogT6
sF40shr51OEd+vARxMZONrasfcsnxECEVCU4RPlqPRoxDQVAFXWsg/4rvlkCCJFj
yoVmF87xPggJ/v0FGJFHgJVjp9UG8KG39aKgsTmHhKnida7S6WY=
=rEMm
-----END PGP SIGNATURE-----

--cVJj2cBW87o0jxY5taEqrdK1ofi5aTvzS--
