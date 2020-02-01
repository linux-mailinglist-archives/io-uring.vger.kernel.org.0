Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C80AA14F7A4
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 12:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgBALng (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 06:43:36 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35055 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgBALnf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 06:43:35 -0500
Received: by mail-wr1-f68.google.com with SMTP id w12so838230wrt.2
        for <io-uring@vger.kernel.org>; Sat, 01 Feb 2020 03:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=+ZC7rLgdkHDsL2R/AAsEOTLJdEGrrizRPClMAMV6TDM=;
        b=f1LMyIMhbcFCFlCz0b+uU8cfRRgrOzi812k0alW2LpbpbK4+zYpoGGdKeGC2DiZHsn
         ZPDh7Ounpi7ukg3Mf5rnXtfRxW+LhlXcfihm2E45Asg5lGThYG7+0TxiubX6InszL7zM
         xbzRuACTohWrRrWDEGmf+iWX+f4B8Te3hK/fU77qulpEGHNV0zmX2wKSVTdA69lLixuf
         byJd/QN6yleqnSad310+mWapUsQmcjH/YckUbKiQt1+0MU8vkkm9O+XwO7XMvKSusZqj
         SdJ42NoeJjYj0rDU/dVZs1dSb+achr11FSBeEB5tx0sz1AZSxzsKbuLkpW3ocJGIDOF4
         xg8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=+ZC7rLgdkHDsL2R/AAsEOTLJdEGrrizRPClMAMV6TDM=;
        b=YFwgQ/zpMZs+gog+6DnkzjfgeUa1WPzFbcLAVwQQGAJKl29F7IojotrpfL+02OLGVQ
         cG+uA1v+XQNfwim4vh4LewyVR2WD0iHYmCvpCrrr2sg+taanq/wH/riRsbVUh9tXzOfa
         p93apAj91glCPtuugUsh9dZ61goCqEzJkWZjeljKNmqcoKxSsX5iOqKlVYFRb/+Y35WT
         ovcy+6guYlCmVUa69eHQZac1SE6j9S+yZPNwe31K1PXJUIR2tnwxQ3puynw7nUywJ5LN
         yQg2AIkg6Pils8uLQt4adGmeL4sCBAhiFImWQKgRbG4xh0VR67uimvuyV13E0p82Yo/W
         Kt6A==
X-Gm-Message-State: APjAAAUlB3H0ujyFjTuT2Egbjfkh095tw7FByaF/nuoENHpnwEExJCGZ
        yUp5mmc/62njDjgeTJk+QEvzvfVD
X-Google-Smtp-Source: APXvYqxlkmTbEzqH3uMqWM56zhsRhnzePKXrAtXB6U5PkhxnkdTGTrNDT0psT3SVemvcixu8+XENvw==
X-Received: by 2002:adf:db84:: with SMTP id u4mr4331549wri.317.1580557411269;
        Sat, 01 Feb 2020 03:43:31 -0800 (PST)
Received: from [192.168.43.154] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id d23sm16388385wra.30.2020.02.01.03.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 03:43:30 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1580508735.git.asml.silence@gmail.com>
 <6492ccd2-e829-df13-ab6e-e62590375fd1@kernel.dk>
 <199731e7-ca3f-ea6c-0813-6aa5dec6fa66@gmail.com>
 <18b43ead-0056-f975-a6ed-35fb645461e9@gmail.com>
 <1124e9e0-cf3b-767e-40a5-57297e5ec17b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 0/6] add persistent submission state
Message-ID: <19522299-39e3-2839-c809-204acbd59b01@gmail.com>
Date:   Sat, 1 Feb 2020 14:42:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1124e9e0-cf3b-767e-40a5-57297e5ec17b@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IB8GdpGwgHxRqHAQsH3wn4fW77qqL7qzN"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IB8GdpGwgHxRqHAQsH3wn4fW77qqL7qzN
Content-Type: multipart/mixed; boundary="k5ROsZqGC6Fajfq8iwQaLBO3Fs14yoKz6";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <19522299-39e3-2839-c809-204acbd59b01@gmail.com>
Subject: Re: [PATCH v3 0/6] add persistent submission state
References: <cover.1580508735.git.asml.silence@gmail.com>
 <6492ccd2-e829-df13-ab6e-e62590375fd1@kernel.dk>
 <199731e7-ca3f-ea6c-0813-6aa5dec6fa66@gmail.com>
 <18b43ead-0056-f975-a6ed-35fb645461e9@gmail.com>
 <1124e9e0-cf3b-767e-40a5-57297e5ec17b@kernel.dk>
In-Reply-To: <1124e9e0-cf3b-767e-40a5-57297e5ec17b@kernel.dk>

--k5ROsZqGC6Fajfq8iwQaLBO3Fs14yoKz6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 01/02/2020 05:10, Jens Axboe wrote:
> On 1/31/20 5:31 PM, Pavel Begunkov wrote:
>> On 01/02/2020 01:32, Pavel Begunkov wrote:
>>> On 01/02/2020 01:22, Jens Axboe wrote:
>>>> On 1/31/20 3:15 PM, Pavel Begunkov wrote:
>>>>> Apart from unrelated first patch, this persues two goals:
>>>>>
>>>>> 1. start preparing io_uring to move resources handling into
>>>>> opcode specific functions
>>>>>
>>>>> 2. make the first step towards long-standing optimisation ideas
>>>>>
>>>>> Basically, it makes struct io_submit_state embedded into ctx, so
>>>>> easily accessible and persistent, and then plays a bit around that.=

>>>>
>>>> Do you have any perf/latency numbers for this? Just curious if we
>>>> see any improvements on that front, cross submit persistence of
>>>> alloc caches should be a nice sync win, for example, or even
>>>> for peak iops by not having to replenish the pool for each batch.
>>>>
>>>> I can try and run some here too.
>>>>
>>>
>>> I tested the first version, but my drive is too slow, so it was only =
nops and
>>> hence no offloading. Honestly, there waren't statistically significan=
t results.
>>> I'll rerun anyway.
>>>
>>> I have a plan to reuse it for a tricky optimisation, but thinking twi=
ce, I can
>>> just stash it until everything is done. That's not the first thing in=
 TODO and
>>> will take a while.
>>>
>>
>> I've got numbers, but there is nothing really interesting. Throughput =
is
>> insignificantly better with the patches, but I'd need much more experi=
ments
>> across reboots to confirm that.
>>
>> Let's postpone the patchset for later
>=20
> Sounds fine to me, no need to do it unless it's a nice cleanup, and/or
> provides some nice improvements.
>=20
> It would be great to see the splice stuff revamped, though :-)
>=20
Yep, I didn't abandon it.

--=20
Pavel Begunkov


--k5ROsZqGC6Fajfq8iwQaLBO3Fs14yoKz6--

--IB8GdpGwgHxRqHAQsH3wn4fW77qqL7qzN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl41ZDQACgkQWt5b1Glr
+6Uklg//XLhwtf+v/UdheuUQYoDSp3L0vrHR7EOrnkpa/QPazMgaWRtswYD63iYL
XapR5KfLCNQNeF/sKzOOUI693CFwImeoU+oS42uoHofVeN1wMsUfoXtjABXKwtEo
76TLNSNOjrcXeMwyoaMTi1YeN0fmbsxNSDh1aCNEXCxoFMT/8+CLNpeARAwCMHNy
gHu9bYhYwH9wRlXOwpP1LdRVtlc3dVvSf/Qp6RmE5FZDE/EJgPwqc5L/1sMTqBK0
2G9NN5iN/KQctZfOqPvr9lEWwQOOsTWp0PhRA3pdqvhYNbCvKEiTISzuNJDAyJRe
gVxLqYmFFKhuQzx5GKQOWb7dA5xl9d7PsSM1lbOiJe7fkfs/ydb0ZpZgaElifAWR
iKN6Rn++gLR+8uTZm2rSJlqeETdb5KLmrmehEp6LMgntDMYvW0eugy7+bszsT5rM
oe3V5yrToZmv1wV10jRcBM7RcMPB0SXqznc7bYak+v0DgFzOVVbhDnaIzyOMTl86
CnfFoacSuGkdfBWCKYMgSxNZ/xKChkze8hwhQZE2YEfgiFqWW8ooiQhurevJuNTW
mM/39+x4vi2YJpiuxIS01I/KbjHU3eAPgLLbWCdZPalMbhAYhpYoXWAP67wJna0n
7VN+MBOSNNDhDngSysA89VNjYtVdgok/99BY6WOSEw0KXtlmChE=
=jGpH
-----END PGP SIGNATURE-----

--IB8GdpGwgHxRqHAQsH3wn4fW77qqL7qzN--
