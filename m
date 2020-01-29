Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E77714C8A7
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 11:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgA2KRz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 05:17:55 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:36286 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgA2KRz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 05:17:55 -0500
Received: by mail-wm1-f49.google.com with SMTP id p17so5794981wma.1;
        Wed, 29 Jan 2020 02:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=Zxf9S7yHU5B95BHuLaVpdD0vQSuE0QvGwB8OBc609WM=;
        b=oj8v7BgDsAgS/Sz8sLYCWTavGPSAA2YmpYN1prpdeNZAptbr6bePqacqQa7CgXa09f
         Q5fwyA4Q6yHwcRzbvBxEQCiN+QtzkH1Ff5Hs3HGceU2StrhZDBp9UQhfWtnkI67Yc/FE
         XcvQzuW3Xea1SOAIi2UQzlip8mqBz9xX1metXKddVIeKEaUprUm/ljrSUa+INs7Hm06F
         vhBsNn256OO3Alk+d6AVp2ollCt3/RPn6pWNa1pvZs6To7BAVjVOCgAmQGHmdc2dQx0t
         JSm3ELMcOegMoTmeteD0Ab6FgreNgSSFBMypqr8cu5h0kEiY9h6lWxR3f0DaJHaRSa/a
         koKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=Zxf9S7yHU5B95BHuLaVpdD0vQSuE0QvGwB8OBc609WM=;
        b=N4J/pVzNn/xpgvTCu9QFjj+6Sq7qWnnireQTxpVS5yBR6VCBmD5iDw9/SmASoD6r6J
         LuXeKasEra9j+lb3fx5dr94ZJeQ2BtzO1TjdO4peZIbOH8zMPBJ6YMAhkG+at506Mkpp
         c/ZI0AzQBDnxE6QUAon4x3018viNpIjdlIBc0I82oSQUZxm9Il+1mwL6ygSKfezGeevH
         YVwbO/1PexFFCDVJ4gcmLGH1iE521AZv+gY0mgIQ1E1nLeEV7mwcWkBhD9mgs2vGYZF8
         9mLUQK8z3TCLQv16qq+eDY04D4MsLdlSJeTtoDK8nV/rH7aBZTm7eNaThBezmZB5wCAQ
         Mlsw==
X-Gm-Message-State: APjAAAWJPnprSQeVksDDzD8N5DCmjY7ltdS9hPXyPBeamXSaw4Ok9QYz
        6BF9jnbM5hHyDLdFJk3Uez+f2iD/
X-Google-Smtp-Source: APXvYqwwtqp/bb3zJghcSTXi/r54lvjsWcVrIjCDxwY0GiOiJbD2VSE3678s1zdIhpqoIc98bJITog==
X-Received: by 2002:a7b:c242:: with SMTP id b2mr3354659wmj.19.1580293072318;
        Wed, 29 Jan 2020 02:17:52 -0800 (PST)
Received: from [192.168.43.59] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id g7sm2243668wrq.21.2020.01.29.02.17.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 02:17:51 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
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
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
 <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
 <c9e58b5c-f66e-8406-16d5-fd6df1a27e77@kernel.dk>
 <6e5ab6bf-6ff1-14df-1988-a80a7c6c9294@gmail.com>
 <2019e952-df2a-6b57-3571-73c525c5ba1a@kernel.dk>
 <0df4904f-780b-5d5f-8700-41df47a1b470@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <5406612e-299d-9d6e-96fc-c962eb93887f@gmail.com>
Date:   Wed, 29 Jan 2020 13:17:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0df4904f-780b-5d5f-8700-41df47a1b470@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NKiS9UZcCjL2ZSFkMpy7wiDHkdnUqw5qk"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NKiS9UZcCjL2ZSFkMpy7wiDHkdnUqw5qk
Content-Type: multipart/mixed; boundary="oxXz7yUoNiNZGjTTa7SyCwONU3gCbMVKy";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>
Cc: io-uring <io-uring@vger.kernel.org>,
 Linux API Mailing List <linux-api@vger.kernel.org>
Message-ID: <5406612e-299d-9d6e-96fc-c962eb93887f@gmail.com>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
 <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
 <c9e58b5c-f66e-8406-16d5-fd6df1a27e77@kernel.dk>
 <6e5ab6bf-6ff1-14df-1988-a80a7c6c9294@gmail.com>
 <2019e952-df2a-6b57-3571-73c525c5ba1a@kernel.dk>
 <0df4904f-780b-5d5f-8700-41df47a1b470@kernel.dk>
In-Reply-To: <0df4904f-780b-5d5f-8700-41df47a1b470@kernel.dk>

--oxXz7yUoNiNZGjTTa7SyCwONU3gCbMVKy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 29/01/2020 03:54, Jens Axboe wrote:
> On 1/28/20 5:24 PM, Jens Axboe wrote:
>> On 1/28/20 5:21 PM, Pavel Begunkov wrote:
>>> On 29/01/2020 03:20, Jens Axboe wrote:
>>>> On 1/28/20 5:10 PM, Pavel Begunkov wrote:
>>>>>>>> Checked out ("don't use static creds/mm assignments")
>>>>>>>>
>>>>>>>> 1. do we miscount cred refs? We grab one in get_current_cred() f=
or each async
>>>>>>>> request, but if (worker->creds !=3D work->creds) it will never b=
e put.
>>>>>>>
>>>>>>> Yeah I think you're right, that needs a bit of fixing up.
>>>>>>
>>>>>
>>>>> Hmm, it seems it leaks it unconditionally, as it grabs in a ref in
>>>>> override_creds().
>>>>>
>>>>
>>>> We grab one there, and an extra one. Then we drop one of them inline=
,
>>>> and the other in __io_req_aux_free().
>>>>
>>> Yeah, with the last patch it should make it even
>>
>> OK good we agree on that. I should probably pull back that bit to the
>> original patch to avoid having a hole in there...
>=20
> Done
>=20

("io_uring/io-wq: don't use static creds/mm assignments") and ("io_uring:=

support using a registered personality for commands") looks good now.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>


BTW, why do use decided to use idr, but not linear buffer scheme as for t=
he rest
registered ones? We can rework it later for performance with linear searc=
h in
the buffer upon registration.

--=20
Pavel Begunkov


--oxXz7yUoNiNZGjTTa7SyCwONU3gCbMVKy--

--NKiS9UZcCjL2ZSFkMpy7wiDHkdnUqw5qk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4xW6oACgkQWt5b1Glr
+6VI4g/+J/aF9jE1Rk9qQ5aR4LxbxJ2T7dX+5oLJ5QX48LbxG5YXKQGoBKeR5h7c
Qwq6qDTyAZGfzMbn/cJWNpdGQM2dUGxibIidF6jcZYNzMi/nM+TZvJc6BxFJYqqL
h/l4ewCGTWD1rnEr+sEJ2Mu02Z8ojRZOPMj6PkKww+7GDQOYGqClK9Y3Qz93qbrw
Cv1HlA3poEoNt54SN4QU8IrWunUGxc5t5OtS5RZO6/9hZ+me/tQNvRH3VB9BGMgp
AjcQC874n63xjyExpSSJ3RzVColNxs0sVAuc9Z/P4HfiCz1/zS7CDAluH1hvA2Bm
TNNG4RHUFfClF81gdeyNAdOx/PogNXE9UIH55WhjK+aqd7rUQFucurqRoclpCjz9
W2Oe72MW8fL9kf/Kt1J6cGHEL0doQ9ugkWYSCTwKB0wvqaKgXbjaV005FH1bqo4P
J5Hq0xJ4H1NKkY/GonsuceI0v8kfVw0Hy+Lx5R8NT1+7+hzUxVi4l+RHwSpX4EhG
7EKkSRyPAtUDDsLNPIDZil8ZCecNuvTRL7CkS/aCSe4DR9/FFIImURP42QKA2345
7fFRrleOkI66kYB2VMEGGjsVlrHWzaD45DABXYRHtwdNaM6ySJAYTBhsKA5Ueiei
QEOaJrYi72k0vf1oEl649vuni6NOcXOMxZL2YumK3AzF+oxRmvU=
=bBLT
-----END PGP SIGNATURE-----

--NKiS9UZcCjL2ZSFkMpy7wiDHkdnUqw5qk--
