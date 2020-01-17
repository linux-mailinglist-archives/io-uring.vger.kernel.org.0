Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 941B71414C1
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2020 00:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgAQXPj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 18:15:39 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45614 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgAQXPj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 18:15:39 -0500
Received: by mail-wr1-f67.google.com with SMTP id j42so24183360wrj.12;
        Fri, 17 Jan 2020 15:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=AH/jUQhTT6JmzuLvAlDbM00D09VzV5w8OtXrHIRBi7c=;
        b=cK2UOQLbhOHuqmRTcgtAl7dXWkypPDmR6BIysCW02t8Nae3oILxNpQ/eJoCmrucj5f
         PnuGvcKyLN9RhysBFSD4vSUh85cej92KthYCjFRW4H9o1iRkQx9Pyu+QgPGeWIVjqVAJ
         ONCbqh1Ghgbhcvq0gWy85rcuQacTKgJnm02dxFOgpM//MOXYpGGCavna6xx8zXVCUCJK
         9Q4AeLI+GEHmQSXR28tW8CHRuPmVsO3eN0a4sDiV0cQdd6apoAoMy73mYzW6YocZ/lqM
         Ge02fBrEBRcxD1NovI5oVT/6FAdJdpBCHv5AhrdFFOism0yrDVrlVqW95TRzPkseG0mB
         v97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=AH/jUQhTT6JmzuLvAlDbM00D09VzV5w8OtXrHIRBi7c=;
        b=HChLXZYId8S7Sprueqq97mMJo4XHZMLBcNGVZsOp28zEFZla+Zuk5chaLkeu9oupPW
         I/EkBuU7wah5yf3F2m4/CVftbyA1Lk3ySd7InkWDbY7uPmneCQCt0L+CWCzB8dxoqI+i
         PPuuEB19kg1gRUfkmMeMD/BOZaeGCXpaenEyIZH+6YLwBUvdthrrvLeV8E+IvIL1T59i
         I1iUR5b3O/Agzw1GI9P5LmZa4gIIzHWgAQ/XKSNiJdHsgu7K4IW+p+O94W2HWJ16eezC
         jbUKtLNboAn22Ng9k7etnoZTClv8mVsFo1+ZV5e2YksxrOj8sIBmmX03m3U0m7J4Tic1
         RSuw==
X-Gm-Message-State: APjAAAV1lQ7CUhexwDl0wnzG0kMHMvgUnp1Apu9wlR6AIcytzgMJ5tRr
        50kdlO3lxS1OtOZJAMW2kKsp8c4T
X-Google-Smtp-Source: APXvYqyAVdaDtOtN0R6uSQCCUTfb7kTsYSQC1D+5v8R+0XFThqqI2fv3LvGLAPhyTEO/eODTMnqi3w==
X-Received: by 2002:adf:ea0f:: with SMTP id q15mr5643156wrm.324.1579302935782;
        Fri, 17 Jan 2020 15:15:35 -0800 (PST)
Received: from [192.168.43.134] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id k7sm3169478wmi.19.2020.01.17.15.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 15:15:35 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <37a04c11e980f49cb17a4fd071d2d71a291a8fd5.1579299684.git.asml.silence@gmail.com>
 <cover.1579300317.git.asml.silence@gmail.com>
 <cf0b8769-0365-2fd1-c87e-fe2e44052b51@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/2] optimise sqe-to-req flags
Message-ID: <fa7b4b9a-b0a4-7c1f-d3e9-c5bfa8fff74b@gmail.com>
Date:   Sat, 18 Jan 2020 02:14:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cf0b8769-0365-2fd1-c87e-fe2e44052b51@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HtH6ZyO0HhlkxDivhICsp4B8tL01mmhAq"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HtH6ZyO0HhlkxDivhICsp4B8tL01mmhAq
Content-Type: multipart/mixed; boundary="2soa8hgoM5OZvAd8Mrev0PPxljXQz00xS";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <fa7b4b9a-b0a4-7c1f-d3e9-c5bfa8fff74b@gmail.com>
Subject: Re: [PATCH 0/2] optimise sqe-to-req flags
References: <37a04c11e980f49cb17a4fd071d2d71a291a8fd5.1579299684.git.asml.silence@gmail.com>
 <cover.1579300317.git.asml.silence@gmail.com>
 <cf0b8769-0365-2fd1-c87e-fe2e44052b51@kernel.dk>
In-Reply-To: <cf0b8769-0365-2fd1-c87e-fe2e44052b51@kernel.dk>

--2soa8hgoM5OZvAd8Mrev0PPxljXQz00xS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 18/01/2020 01:49, Jens Axboe wrote:
> On 1/17/20 3:41 PM, Pavel Begunkov wrote:
>> *lost the cover-letter, but here we go*
>>
>> The main idea is to optimise code like the following by directly
>> copying sqe flags:
>>
>> if (sqe_flags & IOSQE_IO_HARDLINK)
>> 	req->flags |=3D REQ_F_HARDLINK;
>>
>> The first patch is a minor cleanup, and the second one do the
>> trick. No functional changes.
>>
>> The other thing to consider is whether to use such flags as=20
>> REQ_F_LINK =3D IOSQE_IO_LINK, or directly use IOSQE_IO_LINK instead.
>=20
> I think we should keep the names separate. I think it looks fine, thoug=
h
> I do wish that we could just have both in an enum and not have to do
> weird naming. We sometimes do:
>=20
> enum {
> 	__REQ_F_FOO
> };
>=20
> #define REQ_F_FOO	(1U << __REQ_F_FOO)
>

I thought it will be too bulky as it needs retyping the same name many ti=
mes.
Though, it solves numbering problem and is less error-prone indeed. Let m=
e to
play with it a bit.

BTW, there is another issue from development perspective -- it's harder t=
o find
from where a flag is came. E.g. search for REQ_F_FOO won't give you a pla=
ce,
where it was set. SQE_INHERITED_FLAGS is close in the code to its usage e=
xactly
for this reason.


> and with that we could have things Just Work in terms of numbering, if
> we keep the overlapped values at the start. Would need IOSQE_* to also
> use an enum, ala:
>=20
> enum {
> 	__IOSQE_FIXED_FILE,
> 	__IOSQE_IO_DRAIN,
> 	...
> };
>=20

I tried to not modify the userspace header. Wouldn't it be better to add =
_BIT
postfix instead of the underscores?

> and then do
>=20
> #define IOSQE_FIXED_FILE	(1U << __IOSQE_FIXED_FILE)
>=20
> and have the __REQ enum start with
>=20
> enum {
> 	__REQ_F_FIXED_FILE =3D __IOSQE_FIXED_FILE,
> 	__REQ_F_IO_DRAIN =3D __IOSQE_IO_DRAIN,
> 	...
> 	__REQ_F_LINK_NEXT,
> 	__REQ_F_FAIL_LINK,
> 	...
> };
>=20

--=20
Pavel Begunkov


--2soa8hgoM5OZvAd8Mrev0PPxljXQz00xS--

--HtH6ZyO0HhlkxDivhICsp4B8tL01mmhAq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4iP/AACgkQWt5b1Glr
+6WTeRAAkmrvDTMrEDVgE43duThVOdO7S4rz1dqBkv4QRjutTrDzt1UxXuhwFnW5
1W337bdXXQiJbXZEabY/DfwJLWFbGPK1KPblPOhzKK2jVgY+Nlu8cIHvVwu70Z3H
57pNclXOuScaoyDmrD0D/UIVpEJmL+E7XKbce/9QEVajkncbbFcyXhYG6MV2CTGl
ppQ/4z5rYfYuCK9kffgNHbU+Z7IqTtRavvq2a+eo3qohUkeUBM+aEOgmBjkbx1Ji
osZtXhUpPPVbxl0cSnDRyp5oSKwCQyzKOyjXI2K/MYewxtFFKfPcIf7CfFeQLRyR
dcmT4OyXaud7J/zWPVYVYqNYh7Bw8KXWlunsvvQWAEDtlCcpyTaHM6rp34yYpLD8
v00AmI1Fz+prT+xZyyXu9piX3nHrDwNmtjeLN4yLOxi+3QrOl6Pi77GFFPxtUi1S
bHGvJ6bHLgMcZyvq161jmYuDreDOgwzIGibck3HUl7DS1R4l5d6ncpj07cc9LyYT
YgAYwTC3bF48qi+QiX9mnwGc7q1SXDv57lcaXusBJuugBCHqKO+3S4SDlhjFpckt
w+OD/Hd1M3gHWp26ZmsQXnHAdMjbPR5KfjoCIwuPbHIHhxqmKXppd5DPIP1UqCbg
aI36zbXg5MSbiESltnEZC4Wo3Cd/j6BgO2ez8yy3wE8OTaVgHlU=
=949l
-----END PGP SIGNATURE-----

--HtH6ZyO0HhlkxDivhICsp4B8tL01mmhAq--
