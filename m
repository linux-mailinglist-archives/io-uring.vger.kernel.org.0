Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD8CB16ADAE
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgBXRiO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:38:14 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:36404 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBXRiO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:38:14 -0500
Received: by mail-wm1-f53.google.com with SMTP id p17so206696wma.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 09:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=g3vYJFuN7cYti/fbNWQx9K4s3ln4rutuV3+N2poqhc8=;
        b=IrJKTCLi+fR5rtOeh80OSHL5P2vGS6BbKhv/c5mCccJYcKAhnLW4+VnypaLfK1DlUL
         G61W6NKXMFYIdRIFN//6utExNVx1+GBN06ynU8MwAYJVdvHT6i1D1I4Uzb1KVFCI7ism
         3aojugFbKBMEdho5gDvdPkncnU0B0pbW91FrwxxFd6OVUN5sVINDBRLQWgjbtUQWEped
         cxxHDFdcwtZwMkVSfy/7grAgM/sdVCxrPEJcjk4mIMEOsunx7jnv3JVBQ7qBbyMyFhQG
         jeYH0y58qQLobE4vvf2ywJxyOp6aTDtUfRxdnX0Ak7MNYcSi92slLA/3kjbKJO5maHoU
         r2Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=g3vYJFuN7cYti/fbNWQx9K4s3ln4rutuV3+N2poqhc8=;
        b=AzZ7x/uajvFL9YsJy6qbDkGwMjifqR8ot5uOYnzXLVCOyrHBwRY5WDnBV8ROPw7SCL
         h5owTVRUNZzKxxWl6fTDEMePqZ2AWpxFlCKkCD6DCfsOdb9YXdwAEH5RJnxyPkOjUFS/
         46cjPVynsmlQ605ScDfG4xYRrPCnN0AxfzQjq2Zr8/TovikkE3SIVByKAflxzNDxMc2H
         5mCwTy/SyJxB2tqJDZScX3VfKoznTgkOkcqXngQkmCINE8wAsn23pmrExYK1JHDmkvu2
         YxLdHb728IrG+l0y5m8U0y3ffDpphr6dNsvp76LpZYHj+yM8Ima1HJ7xWlRfRocnlKBs
         hNqw==
X-Gm-Message-State: APjAAAVmyhAOWXz7hVbInz4WM9CIBH5H6ag9MwCZtjs/fhdV4XFGgFsC
        LFnV6ny1JqJsKvy9WC9e9N+znqtf
X-Google-Smtp-Source: APXvYqwmXold/qJMRynjvr8+0rA4Pd7lj7GNRAmzheXzT9qKfIVfQDcRJlEGKkGgFIBxSp0qXneRbw==
X-Received: by 2002:a1c:7411:: with SMTP id p17mr164144wmc.160.1582565891617;
        Mon, 24 Feb 2020 09:38:11 -0800 (PST)
Received: from [192.168.43.177] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id t187sm151681wmt.25.2020.02.24.09.38.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 09:38:10 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <20200224165334.tvz5itodcizpfkmw@alap3.anarazel.de>
 <14eb8dcb-d5ba-9e0a-697d-e4b8fbad3f08@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Deduplicate io_*_prep calls?
Message-ID: <706b2cb9-331f-f2d4-135b-ec9abae7e10e@gmail.com>
Date:   Mon, 24 Feb 2020 20:37:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <14eb8dcb-d5ba-9e0a-697d-e4b8fbad3f08@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vPO5x3teOkzsN7oRK9Cj5sjEGKUrg5aFA"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vPO5x3teOkzsN7oRK9Cj5sjEGKUrg5aFA
Content-Type: multipart/mixed; boundary="pfuM8ygpRrI2aYO2nFaSfzpIDp6z6kpBl";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>
Cc: io-uring@vger.kernel.org
Message-ID: <706b2cb9-331f-f2d4-135b-ec9abae7e10e@gmail.com>
Subject: Re: Deduplicate io_*_prep calls?
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <20200224165334.tvz5itodcizpfkmw@alap3.anarazel.de>
 <14eb8dcb-d5ba-9e0a-697d-e4b8fbad3f08@kernel.dk>
In-Reply-To: <14eb8dcb-d5ba-9e0a-697d-e4b8fbad3f08@kernel.dk>

--pfuM8ygpRrI2aYO2nFaSfzpIDp6z6kpBl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24/02/2020 20:19, Jens Axboe wrote:
> On 2/24/20 9:53 AM, Andres Freund wrote:
>> Hi,
>>
>> On 2020-02-24 08:40:16 -0700, Jens Axboe wrote:
>>> Agree that the first patch looks fine, though I don't quite see why
>>> you want to pass in opcode as a separate argument as it's always
>>> req->opcode. Seeing it separate makes me a bit nervous, thinking that=

>>> someone is reading it again from the sqe, or maybe not passing in
>>> the right opcode for the given request. So that seems fragile and it
>>> should go away.
>>
>> Without extracting it into an argument the compiler can't know that
>> io_kiocb->opcode doesn't change between the two switches - and therefo=
re
>> is unable to merge the switches.
>>
>> To my knowledge there's no easy and general way to avoid that in C,
>> unfortunately. const pointers etc aren't generally a workaround, even
>> they were applicable here - due to the potential for other pointers
>> existing, the compiler can't assume values don't change.  With
>> sufficient annotations of pointers with restrict, pure, etc. one can g=
et
>> it there sometimes.
>>
>> Another possibility is having a const copy of the struct on the stack,=

>> because then the compiler often is able to deduce that the value
>> changing would be undefined behaviour.
>>
>>
>> I'm not sure that means it's worth going for the separate argument - I=

>> was doing that mostly to address your concern about the duplicated
>> switch cost.
>=20
> Yeah I get that, but I don't think that's worth the pain. An alternativ=
e
> solution might be to make the prep an indirect call, and just pair it
> with some variant of INDIRECT_CALL(). This would be trivial, as the
> arguments should be the same, and each call site knows exactly what
> the function should be.

And unfortunately, instead of a nice jump table or offset near-jump, it'l=
l
generate a mess. Though, the attempt itself may prove useful by clarifyin=
g
handler/core/etc API.

--=20
Pavel Begunkov


--pfuM8ygpRrI2aYO2nFaSfzpIDp6z6kpBl--

--vPO5x3teOkzsN7oRK9Cj5sjEGKUrg5aFA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5UCc8ACgkQWt5b1Glr
+6XbEA//Xl09ceHJg32+TBKb+ONBdtYXko/x73PIw1zsR49BOaobUuUINTMYBtj4
n1bYVrkGyOtepJHhO8uhFC9Kj0j5h78INUyeKS9B1qRZ54acubSLO+j8vkltNsjM
WgMGI6EnqXHhqOUMo47Wvi4r8g2J9Zes33jhAy90XB34WPqHElDiuVCARCubaB/E
0tncAPJzlA+DGc1uZMhxwu1RvdHktxY7+zta2vCX0XWqtdWO2wpATfVeDPBIE+9A
rR0z/0cUxkyxCgu+bp2AQ1pJKj/rCbgaKU6EFmaZs7QyFt02eV3CqeHds1BQAgRt
lIOxEuxbYNccT/J7C+scnXmGoJYaAeR15wA8O80P/KvpQwg56tgR8fARAG93E7JK
l09LAaOpZUtFYUXt0i0i/wYhvx6/UCjBQFpot3aRASZPLsXvmG/Pbz5pKQjrhwfv
WUoqvRQjNlp1OctUSJBqkBwsJV0lE5vM5vCJlg+p2kctjRP8VUFdLGrXs9ZKe1dq
cdSEH/EvK7XNMMssx917uQxDh/cV7KlVCw/osVidEcdDn0wqfGF5ytTDAAzCadsC
V3BrzzVwdv3aOgcn4lvpupLd69jCqLZ7jF892lxwgFPLuZlntCISL9gxXGf9FepP
LbqErqaP7g8obg2nGVvcT36ilpBSEiGtr2ikVQdAtsVmSFSwXCM=
=043u
-----END PGP SIGNATURE-----

--vPO5x3teOkzsN7oRK9Cj5sjEGKUrg5aFA--
