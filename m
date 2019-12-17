Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02FFC12347E
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 19:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfLQSNO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 13:13:14 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33214 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfLQSNO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 13:13:14 -0500
Received: by mail-wr1-f68.google.com with SMTP id b6so12393338wrq.0;
        Tue, 17 Dec 2019 10:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=IK8AMSTnEyo4Pjjo7rB0HLbh91Jrgv4cE5r4CdUfwm0=;
        b=XCFutX4oKihgQvnFcDe/rff+StMHTxt+RC37qKzelK/HUEnBA4tpOECBn1Ug7eA6u/
         7qP5b6X4j7or+tvg9xeFVDhyH6UFbd295uvqKbSvhHBNBtaM9+ashDiDY43kq7OoKDMk
         yVe2gl+V0QvQRhbqcYH0aPWnrQYgwQoRsHSfr090jRrUZ4ZjrIAhCiXzqXFBYg+5IKru
         x3Rq+i0qJf2kTQI08RckFTILBioUBBkkcA7gDRqyoqyTBIgVyZl3Vbmxvd25XtyDZa7V
         x1H/+cSgCL7PLnRSw6OVY2ctdrN9db4MeT0/a6wHYb+RNBFgNh9nIVLdPCsKXFaLbwHn
         X1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=IK8AMSTnEyo4Pjjo7rB0HLbh91Jrgv4cE5r4CdUfwm0=;
        b=HdeuUW843hnqwedfVtbhYlc2jWTjwdU+AYc+M+qwXDgkDDLbPKQMrgAQ/7E218n2Vz
         Ztg+2o6c+LBXf4viVWmigYdt5wlafADZ4byXvV9sZ6MGkmj+b9qgcTEWTbryeWL6TGGX
         psgOfx58qWd1FTj3H9ZZEmOEtZfSHw7zWSiR588/LNc2PRSiUBiAkAooG3KEVRgz8xPY
         d43p+w1I00l84J7e/ciWvCftG8PFRVUtoKfnfDMC1jlBV2HzfOjlozYbKPmC3tkulGly
         uoUjf7HVNOjx4t9ieJxveTow5ST6fhshxRvcV441sjJ/aKLOp8KMpsqy43PRUyEG3RmB
         zEhg==
X-Gm-Message-State: APjAAAVdlTSRW26UKd78PfeQ89lwjbwHQScaZZscxmL97qMZjFc60XjG
        3WuwABs9Fry2nLydw30N5ThOp4wB
X-Google-Smtp-Source: APXvYqwR9ae5fzdGRA0Qm6THVwCA5pzkcK0lQ6ynao6KgOGfnmfetxgPUEdfz0Pmje6mrYkTIW9lFA==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr36439801wre.372.1576606390631;
        Tue, 17 Dec 2019 10:13:10 -0800 (PST)
Received: from [192.168.43.142] ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id i5sm3794900wml.31.2019.12.17.10.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 10:13:10 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
 <17f7900c-385f-0dfa-11bf-af99d080f894@gmail.com>
 <76917820-052d-9597-133d-424fee3edade@kernel.dk>
 <5d4af2f6-26a2-b241-5131-3a0155cbbf22@kernel.dk>
 <3b5100a7-2922-a9f2-e4e2-76252318959d@gmail.com>
 <7edd6631-326c-ac9c-7c5b-fa4bab3932d3@kernel.dk>
 <4f3f9b65-6e9f-b650-65b8-1e0844321697@gmail.com>
 <69cb864c-9fa9-2d5a-7b75-f72633cb32f5@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <e7bb74e8-0cbe-40f8-9d10-192a8512e1f7@gmail.com>
Date:   Tue, 17 Dec 2019 21:12:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <69cb864c-9fa9-2d5a-7b75-f72633cb32f5@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zVeI1w3A3FylcW2gBXjb1YYgTgAqxJLK8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zVeI1w3A3FylcW2gBXjb1YYgTgAqxJLK8
Content-Type: multipart/mixed; boundary="DaddbFasQNuVPg5p4mHw2bbG8IePXXq4A";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <e7bb74e8-0cbe-40f8-9d10-192a8512e1f7@gmail.com>
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
 <17f7900c-385f-0dfa-11bf-af99d080f894@gmail.com>
 <76917820-052d-9597-133d-424fee3edade@kernel.dk>
 <5d4af2f6-26a2-b241-5131-3a0155cbbf22@kernel.dk>
 <3b5100a7-2922-a9f2-e4e2-76252318959d@gmail.com>
 <7edd6631-326c-ac9c-7c5b-fa4bab3932d3@kernel.dk>
 <4f3f9b65-6e9f-b650-65b8-1e0844321697@gmail.com>
 <69cb864c-9fa9-2d5a-7b75-f72633cb32f5@kernel.dk>
In-Reply-To: <69cb864c-9fa9-2d5a-7b75-f72633cb32f5@kernel.dk>

--DaddbFasQNuVPg5p4mHw2bbG8IePXXq4A
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 17/12/2019 21:07, Jens Axboe wrote:
> On 12/17/19 11:05 AM, Pavel Begunkov wrote:
>> On 17/12/2019 21:01, Jens Axboe wrote:
>>> On 12/17/19 10:52 AM, Pavel Begunkov wrote:
>>>> On 17/12/2019 20:37, Jens Axboe wrote:
>>>>> On 12/17/19 9:45 AM, Jens Axboe wrote:
>>>>>> On 12/16/19 4:38 PM, Pavel Begunkov wrote:
>>>>>>> On 17/12/2019 02:22, Pavel Begunkov wrote:
>>>>>>>> -	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)=
) {
>>>>>>>> +
>>>>>>>> +		/* last request of a link, enqueue the link */
>>>>>>>> +		if (!(sqe_flags & IOSQE_IO_LINK)) {
>>>>>>>
>>>>>>> This looks suspicious (as well as in the current revision). Retur=
ning back
>>>>>>> to my questions a few days ago can sqe->flags have IOSQE_IO_HARDL=
INK, but not
>>>>>>> IOSQE_IO_LINK? I don't find any check.
>>>>>>>
>>>>>>> In other words, should it be as follows?
>>>>>>> !(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))
>>>>>>
>>>>>> Yeah, I think that should check for both. I'm fine with either app=
roach
>>>>>> in general:
>>>>>>
>>>>>> - IOSQE_IO_HARDLINK must have IOSQE_IO_LINK set
>>>>>>
>>>>>> or
>>>>>>
>>>>>> - IOSQE_IO_HARDLINK implies IOSQE_IO_LINK
>>>>>>
>>>>>> Seems like the former is easier to verify in terms of functionalit=
y,
>>>>>> since we can rest easy if we check this early and -EINVAL if that =
isn't
>>>>>> the case.
>>>>>>
>>>>>> What do you think?
>>>>>
>>>>> If you agree, want to send in a patch for that for 5.5? Then I can =
respin
>>>>> for-5.6/io_uring on top of that, and we can apply your cleanups the=
re.
>>>>>
>>>> Yes, that's the idea. Already got a patch, if you haven't done it ye=
t.
>>>
>>> I haven't.
>>>
>>>> Just was thinking, whether to add a check for not setting both flags=

>>>> at the same moment in the "imply" case. Would give us 1 state in 2 b=
its
>>>> for future use.
>>>
>>> Not sure I follow what you're saying here, can you elaborate?
>>>
>>
>> Sure
>>
>> #define IOSQE_IO_LINK		(1U << 2)	/* links next sqe */
>> #define IOSQE_IO_HARDLINK	(1U << 3)	/* like LINK, but stronger */
>>
>> That's 2 consequent bits, so 4 states:
>> 0,0 -> not a link
>> 1,0 -> common link
>> 0,1 -> hard link
>> 1,1 -> reserved, space for another link-quirk type
>>
>> But that would require additional check, i.e.
>>
>> if (flags&(LINK|HARDLINK) =3D=3D (LINK|HARDLINK)) ...
>=20
> Ah, I see. In terms of usability, I think it makes more sense to have
>=20
> IOSQE_LINK | IOSQE_HARDLINK
>=20
> be the same as just IOSQE_LINK. It would be nice to retain that for

Probably, you meant it to be the same as __IOSQE_HARDLINK__

> something else, but I think it'll be more confusing to users.
>=20

Yeah, and it's easier for something like:

sqe->flags |=3D IOSQE_LINK;
[some code]
if (timer_or_whatever())
	sqe->flags |=3D IOSQE_HARDLINK;

--=20
Pavel Begunkov


--DaddbFasQNuVPg5p4mHw2bbG8IePXXq4A--

--zVeI1w3A3FylcW2gBXjb1YYgTgAqxJLK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl35GpwACgkQWt5b1Glr
+6Xm5w/+Py5sgWj31AS3rhNGDS6qyJCS4ZrimKu4/WjxTk09JYgO78ndf3/8RnUi
MyKeoaNRWExRVsCfWJ6Nowr93f5ztP8Dyag1v57lKdlbYfh6ERnS9mhbAcTl907i
r32U7obrmNtgFeMWphsDCwfHwclwX4YM25n58/TMtIVLU4BIVmVMTCtz7NUID0q8
Kn4naoNkPD+qoA70N9QLeC1+6RACzpG7xDS4ABrtWXA+rFkGO8y8HTOUE0U4xu/l
U86zLc6FDS7ElotKEVKyce7XL56Dq732H6opifajcnZTyECeRByce/C42NogM7LB
eDDij8okKZMY3RwzRtWxts9mkMosGAu7IqmhuOVto7owbWbHOZbF7BqbFySqrGM5
EHf3EAYw9SZwY1h0aUdvHPTNh/Tu+rGwF9OoI5wi6LO7d2Vz5kZSIJvbRinBJBAV
g8VOHSeG9kB+/Yd7FKWSddl5Fcdtf5lpV8QlXglJs2a0aNwk2Q70//jJmrYWyZIy
DWuuK8dmlJ/BxUUvMPYngft7lnkGNBUxvFEgb2UImHaxTktgC38YJ9M1IA+xohNb
TiaxTdKLGvtHeo8sXnMAfAiz5eBSZfENBcCS3Emu4q3IHRadDzO+oGiprMODqsNW
LesI3G6wagevoSTkyEWalLamtHe4+9/+0pA+vvqbWLdRORgJ37M=
=FGRQ
-----END PGP SIGNATURE-----

--zVeI1w3A3FylcW2gBXjb1YYgTgAqxJLK8--
