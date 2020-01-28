Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E81EA14C1CF
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 21:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgA1UvS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 15:51:18 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50572 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgA1UvS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 15:51:18 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so4017450wmb.0;
        Tue, 28 Jan 2020 12:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=zOqsl/xXZ/QW6k2HOkYM+8O8g5SzIFTH0NQjXZ3ebq8=;
        b=UBnHavOvhW7yzH4I3btsk5E6F9heKUi8UO5t5TIjBYqSFH3mdVIGYMDekwK3BIZyf7
         3C5oFh9NknnQuYMr2IPxg2AQ7Jh7zurRormL+h7f09tImDO4jo/D1CsoAI/6/NFLoO/j
         Mdcmh8FafkGYcJApawcU69iCx1626OcDbQyV7w2JFXBH7OAr/V4hdv8jf5jt7rUsbFWE
         VOV9jdlY5DVcMaBdwI9IRc0Ydy8ip0x0ICZrsjitgKydBdNTkE68cowTQZW9EHy9G9MH
         Y77FoPwmDOSUt0KTaiIwSLUi243Bc6+FtF4pQz2w1+E+opY9qGj84KwK9mMEsr7XHg1r
         rbYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=zOqsl/xXZ/QW6k2HOkYM+8O8g5SzIFTH0NQjXZ3ebq8=;
        b=k+GQE1WSUkbEFsB0dpQhwAw16tkcMBcgthUyNb1rJT1X15eqAAOEQlHnM+PO8GE/gV
         rEdADu12J7bnLlwyxRAgDY8ITElmI8ILOX9KnSqlqGmdu/th4ST5HSRvSaGEtr0QV+qU
         OyXZiAfItKO8w6/1vSQ5SrX422GgUw2vriXUoZgRwW4Wh+Pn645oPuiFhjiFT1w6/A38
         Ypl9nyqKgd2vV3HIto+hjUlkj/IGPa861PF9Ljca+7BWCAU4ic2Xyxo/Bw+MsX3G1yKb
         IBH3JCYtAm4SZ3GxM5lBJ9863WcDi1eQOVAgPnRIFjV3oDHp68UwSEFGzYS4NjJaZabC
         1bRQ==
X-Gm-Message-State: APjAAAV7sXfdPHUrErpAtvul/jb4ucvky6+Sdf6L8vdN0oExgGlR43fd
        KJOoWYugx1u9MRA2KMhhq1n6OagH
X-Google-Smtp-Source: APXvYqxqwEuzLhjp5Z37C0DBJyMMoEyMEKnHEqqPJWSnF1f48OUmeIlX/tXkiNhFfgEr6q1YIJyhiA==
X-Received: by 2002:a05:600c:2254:: with SMTP id a20mr6631986wmm.97.1580244674348;
        Tue, 28 Jan 2020 12:51:14 -0800 (PST)
Received: from [192.168.43.36] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id x6sm4339898wmi.44.2020.01.28.12.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 12:51:13 -0800 (PST)
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
 <15ca72fd-5750-db7c-2404-2dd4d53dd196@gmail.com>
 <82b20ec2-ceaa-93f1-4cce-889a933f2c7a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Message-ID: <60253bd9-93a7-4d76-93b6-586e4f55138c@gmail.com>
Date:   Tue, 28 Jan 2020 23:50:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <82b20ec2-ceaa-93f1-4cce-889a933f2c7a@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GDuBqivQG276lClroVQehKjSstyRaPJRF"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GDuBqivQG276lClroVQehKjSstyRaPJRF
Content-Type: multipart/mixed; boundary="NJOZ8s4IdoExGm4wgAcztkRx4mt6Zct97";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>
Cc: io-uring <io-uring@vger.kernel.org>,
 Linux API Mailing List <linux-api@vger.kernel.org>
Message-ID: <60253bd9-93a7-4d76-93b6-586e4f55138c@gmail.com>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <15ca72fd-5750-db7c-2404-2dd4d53dd196@gmail.com>
 <82b20ec2-ceaa-93f1-4cce-889a933f2c7a@kernel.dk>
In-Reply-To: <82b20ec2-ceaa-93f1-4cce-889a933f2c7a@kernel.dk>

--NJOZ8s4IdoExGm4wgAcztkRx4mt6Zct97
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28/01/2020 23:19, Jens Axboe wrote:
> On 1/28/20 1:16 PM, Pavel Begunkov wrote:
>> On 28/01/2020 22:42, Jens Axboe wrote:
>>> On 1/28/20 11:04 AM, Jens Axboe wrote:
>>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
>>>>> On 1/28/20 9:19 AM, Jens Axboe wrote:
>>>>>> On 1/28/20 9:17 AM, Stefan Metzmacher wrote:
>>>>> OK, so here are two patches for testing:
>>>>>
>>>>> https://git.kernel.dk/cgit/linux-block/log/?h=3Dfor-5.6/io_uring-vf=
s-creds
>>>>>
>>>>> #1 adds support for registering the personality of the invoking tas=
k,
>>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited=
 to
>>>>> just having one link, it doesn't support a chain of them.
>>>>>
>>>>> I'll try and write a test case for this just to see if it actually =
works,
>>>>> so far it's totally untested.=20
>>>>>
>>>>> Adding Pavel to the CC.
>>>>
>>>> Minor tweak to ensuring we do the right thing for async offload as w=
ell,
>>>> and it tests fine for me. Test case is:
>>>>
>>>> - Run as root
>>>> - Register personality for root
>>>> - create root only file
>>>> - check we can IORING_OP_OPENAT the file
>>>> - switch to user id test
>>>> - check we cannot IORING_OP_OPENAT the file
>>>> - check that we can open the file with IORING_OP_USE_CREDS linked
>>>
>>> I didn't like it becoming a bit too complicated, both in terms of
>>> implementation and use. And the fact that we'd have to jump through
>>> hoops to make this work for a full chain.
>>>
>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>>> This makes it way easier to use. Same branch:
>>>
>>> https://git.kernel.dk/cgit/linux-block/log/?h=3Dfor-5.6/io_uring-vfs-=
creds
>>>
>>> I'd feel much better with this variant for 5.6.
>>>
>>
>> To be honest, sounds pretty dangerous. Especially since somebody start=
ed talking
>> about stealing fds from a process, it could lead to a nasty loophole s=
omehow.
>> E.g. root registers its credentials, passes io_uring it to non-privile=
ged
>> children, and then some process steals the uring fd (though, it would =
need
>> priviledged mode for code-injection or else). Could we Cc here someone=
 really
>> keen on security?
>=20
> Link? If you can steal fds, then surely you've already lost any sense o=
f

https://lwn.net/Articles/808997/
But I didn't looked up it yet.

> security in the first place? Besides, if root registered the ring, the =
root
> credentials are already IN the ring. I don't see how this adds any extr=
a
> holes.

Isn't it what you fixed in ("don't use static creds/mm assignments") ?

I'm not sure what capability (and whether any) it would need, but better =
to
think such cases through. Just saying, I would prefer to ask a person wit=
h
extensive security experience, unlike me.

>> Stefan, could you please explain, how this 5 syscalls pattern from the=
 first
>> email came in the first place? Just want to understand the case.
>=20
> I think if you go back a bit in the archive, Stefan has a fuller explan=
ation
> of how samba does the credentials dance.

Missed it, I'll take a look, thanks

--=20
Pavel Begunkov


--NJOZ8s4IdoExGm4wgAcztkRx4mt6Zct97--

--GDuBqivQG276lClroVQehKjSstyRaPJRF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4wnpgACgkQWt5b1Glr
+6UUYhAAnwyDs5oaj9TJip9NXzylfycRLKnw3z3CP2YfJ9B+RohjpptXDscylO4Y
MhxUUsGp+N+CXS468OiKbo2Wm2Pagtbgrb3OwOr5lRf4Inuy4cq3avk/nu66PYlF
Kvtrr/V/AGRjrVaa9mdVB8yACjFZXihVe5dWGj673HCY4Q7WOkriirAmZoqeb2TO
l4mAspnooyPS+p9LF+f5ZjRQg+TllRLH/EaN3SpMRMXT9vpfe/8hyM0BYUYzynxi
g8G4PMvU6t9jsbRmp5+PocpNKPGPAligAwOBdPwPIZojdt+IDw4TnwY2wrujbsa1
jGb1w3xLjjQho0TscOg9kvT1YTe2wy8PMWwbcX6EwQw/nJBu+KyW5OpqzQ67igZV
IHnsSUQQvc2fVHhhCRmDH3l4EouZAu6tFDawsq7x8eLFpoAjibQHjiflOKROX37B
HOT5P0eObYsN/oTrTiMiCmjCNApN6NxokE+8WIC4aK1G/QUGxrV3EXIZVb59t0vK
tR37m9MtkK0rGpoEtD1zY+5ss6FLPRItHWeagrRsVVeXR8LeO8ajOJdLwdR9R3Al
n7pTrrQr6yj4q93XrevwXQqdMIP+bsGtoATnWGGjw4yXBaxGBdRjB/cxYnlaqMTG
o7gJtsEhGqYv5W0nTZ+RXNppQU6X56AVsYBlmz02KRwypIU3rvE=
=exYt
-----END PGP SIGNATURE-----

--GDuBqivQG276lClroVQehKjSstyRaPJRF--
