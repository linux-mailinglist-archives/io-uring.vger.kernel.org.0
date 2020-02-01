Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F47214FAA1
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 22:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgBAVRj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 16:17:39 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39807 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbgBAVRi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 16:17:38 -0500
Received: by mail-wm1-f65.google.com with SMTP id c84so12613265wme.4
        for <io-uring@vger.kernel.org>; Sat, 01 Feb 2020 13:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=/ppmutYx8mggSNj0vwBG95jm8cZONw7x83+Xc5FgTAo=;
        b=iU4JjTgXkwRI05MKqSSOEw5uJnuDOUOQtvdLZ90uZ0b1pjxItuXiJ4Yl6QwXLeK7nL
         3KLJ6CTY2udPlVGXL23nfaw0b2qySeZz0hk6uxzZqEOr73Ye5oJYvI1C0azRHfH8WljI
         zOL1d1eFBLfSKe7P8amxJphDnApFBZBGcWc7VRwdsHQ5q5G+r4xPkIQ6WPJa4NbBHpAH
         NU/cXQYG/9WepQ44FzPnlsYfZ2it4z960XBT66mLL1APUJUDvGOXse433x8VTRXF06Aj
         cmgqPXYgXzslLvuQLcqhS89vY0KoFkePhLAj0G5XQpU4YM1m65sYE5BZK73aiXF0mHLV
         /BIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=/ppmutYx8mggSNj0vwBG95jm8cZONw7x83+Xc5FgTAo=;
        b=l8AIC+X7mG/0XWRMJbeEvJNy7rMoeIInk8/kJgtt83haBwfDWVuYq7vsEN5CujGrKv
         YSUOcF1GUDWm2Umaq0bYnp4+MY0qDL/7RC0We6sKP5xxYTne/QGt2qML/Pfeyvg9YCS/
         t/vyXxU9BoOZdYfIWX5nrt/DccjkZk4DtiBVlR7RoBvUX3Eiw2pryDmKhhOhIqVoozm3
         BwuSUtfaHoNmPPXodhMBVuzk3OekV2oYjUFq1DrkM0UsLCqCD3BE7JBaRJaN8CHAyzyY
         2eSBe5svcRF6k4sfJmciKo2fZgdceyINNtR+9c0jHR/13OdNfwrdxArfKgML25aOx+4V
         3cSw==
X-Gm-Message-State: APjAAAVEXC9qPLBMzfOvx58iw97bA01BfJG7id66B1NVEe6BRlAcou1H
        XZLY4AfrcntSe8xbs4UiFu6H6yMV
X-Google-Smtp-Source: APXvYqzcngHF1dE1vvJpeDuP687qlKi60jjGfkNaVuFLvNXdphRHVVMRobSMFZT5v8lquFPcW9at+g==
X-Received: by 2002:a1c:8156:: with SMTP id c83mr19149003wmd.164.1580591855831;
        Sat, 01 Feb 2020 13:17:35 -0800 (PST)
Received: from [192.168.43.154] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id r3sm18683957wrn.34.2020.02.01.13.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 13:17:35 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>,
        io-uring@vger.kernel.org
References: <20200201125350.vkkhezidm6ka6ux5@alap3.anarazel.de>
 <ed2fd00f-b300-6d9d-a6d5-f76bbc26435a@kernel.dk>
 <78A9EC3E-0961-4EF3-A226-1FCA34FAF818@anarazel.de>
 <aac42d1e-24d5-4c2d-d1ce-eb8ceed48b1e@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: liburing: expose syscalls?
Message-ID: <6f5abe8a-1897-123d-d01d-d8c7c5fba7c4@gmail.com>
Date:   Sun, 2 Feb 2020 00:16:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <aac42d1e-24d5-4c2d-d1ce-eb8ceed48b1e@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="APeBgFtPN5IFRnHr3edLYeVKJPF0Zcpx9"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--APeBgFtPN5IFRnHr3edLYeVKJPF0Zcpx9
Content-Type: multipart/mixed; boundary="oQEm7HgHDjEhC2BRRjKzl7V5nZCKYSuDi";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>,
 io-uring@vger.kernel.org
Message-ID: <6f5abe8a-1897-123d-d01d-d8c7c5fba7c4@gmail.com>
Subject: Re: liburing: expose syscalls?
References: <20200201125350.vkkhezidm6ka6ux5@alap3.anarazel.de>
 <ed2fd00f-b300-6d9d-a6d5-f76bbc26435a@kernel.dk>
 <78A9EC3E-0961-4EF3-A226-1FCA34FAF818@anarazel.de>
 <aac42d1e-24d5-4c2d-d1ce-eb8ceed48b1e@kernel.dk>
In-Reply-To: <aac42d1e-24d5-4c2d-d1ce-eb8ceed48b1e@kernel.dk>

--oQEm7HgHDjEhC2BRRjKzl7V5nZCKYSuDi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 01/02/2020 20:52, Jens Axboe wrote:
> On 2/1/20 10:49 AM, Andres Freund wrote:
>> Hi,=20
>>
>> On February 1, 2020 6:39:41 PM GMT+01:00, Jens Axboe <axboe@kernel.dk>=
 wrote:
>>> On 2/1/20 5:53 AM, Andres Freund wrote:
>>>> Hi,
>>>>
>>>> As long as the syscalls aren't exposed by glibc it'd be useful - at
>>>> least for me - to have liburing expose the syscalls without really
>>> going
>>>> through liburing facilities...
>>>>
>>>> Right now I'm e.g. using a "raw"
>>> io_uring_enter(IORING_ENTER_GETEVENTS)
>>>> to be able to have multiple processes safely wait for events on the
>>> same
>>>> uring, without needing to hold the lock [1] protecting the ring [2].=
=20
>>> It's
>>>> probably a good idea to add a liburing function to be able to do so,=

>>> but
>>>> I'd guess there are going to continue to be cases like that. In a bi=
t
>>>> of time it seems likely that at least open source users of uring tha=
t
>>>> are included in databases, have to work against multiple versions of=

>>>> liburing (as usually embedding libs is not allowed), and sometimes
>>> that
>>>> is easier if one can backfill a function or two if necessary.
>>>>
>>>> That syscall should probably be under a name that won't conflict wit=
h
>>>> eventual glibc implementation of the syscall.
>>>>
>>>> Obviously I can just do the syscall() etc myself, but it seems
>>>> unnecessary to have a separate copy of the ifdefs for syscall number=
s
>>>> etc.
>>>>
>>>> What do you think?
>>>
>>> Not sure what I'm missing here, but liburing already has
>>> __sys_io_uring_enter() for this purpose, and ditto for the register
>>> and setup functions?
>>
>> Aren't they hidden to the outside by the symbol versioning script?
>=20
> So you just want to have them exposed? I'd be fine with that. I'll
> take a patch :-)
>=20

Depends on how it's used, but I'd strive to inline __sys_io_uring_enter()=

to remove the extra indirect call into the shared lib. Though, not sure a=
bout
packaging and all this stuff. May be useful to do that for liburing as we=
ll.

--=20
Pavel Begunkov


--oQEm7HgHDjEhC2BRRjKzl7V5nZCKYSuDi--

--APeBgFtPN5IFRnHr3edLYeVKJPF0Zcpx9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl416skACgkQWt5b1Glr
+6UrQg//X4xxrZegP/HmFxQOYuIMlV5HEpnvPiXJSwVrzGiCq3a62A2HwGB8YFT3
XSBgZGe6U8aA1dmi7X5s2K3+57bWt0zCKqWYs7mEsaeC8NQGe3ilpCW25WGqvy0c
v1BCemg/C3me/bYrJfkTEqwrb4Pg4FPUm0vpMikWbbm+tMvVVcfzQEuZ+wc5yaKx
IOlXNqBqLp+6fhEuPv/FapNq1C7lmGwJpPaVdwI42q9d60JVTy2rzeaZZqwQ7SfW
le5kgHdI5dT4ADuJl/C3QxiKmqTsW4qvT2y3PVybbSoF469NMFk3BH5gfIVTavAz
3GRxtMvcg2QNSTN/BQnyhoXa+sZIMIQbni8atMGONaTm4cdwBi9mNptAOUhVfVub
PHfb+S3TEuhVlt5Zk9WbmmAvk1xTmmCsMV3AKLB5FU7YPRdOxUDBSxf2WGmqK+ls
VfkkHGnYY/ouej3xQLnUxPhW2V7mRPnLE65riL4hcNrI3xa0km/ADGIru7ijH7EH
buvmckbDrZgnbp7ikyMla/iESPtCdRuoz/RDfO/DFXBBwh8SZICuSBrRVDYdw8oz
7Lwhxx736lqS8RXQmJfkE1Ng9Q8sJ4XvjDY9M+3lS9UPRQSApC1P1+z/PMLmwTZ6
9/dksGu4tmIlUzyBa+eNeD+k7YpYWLFTJU6BR2ZSWlbsjBU1W1M=
=4+nF
-----END PGP SIGNATURE-----

--APeBgFtPN5IFRnHr3edLYeVKJPF0Zcpx9--
