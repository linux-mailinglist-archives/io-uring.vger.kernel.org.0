Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B125816993A
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2020 18:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgBWR4v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 12:56:51 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45085 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgBWR4u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 12:56:50 -0500
Received: by mail-wr1-f65.google.com with SMTP id g3so7661878wrs.12
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 09:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=2NNeaxrR+NMRhzaVOnCUXI/8neCm6ZucbRf4oZlkR9w=;
        b=JVem1VAMj8fMTzna7QJKxKciW0bk7i4UlVNwx839H0g4ZP5jEHgP1snkw7f/OC9hxq
         x+/klcLobRh3Xx6nvWK0BfxWrMhRN3nFfMpyUJhB6A5JD09MQTg2aB8zbT75mUn8xwCi
         1ZDOXL4Nj8n31afDKOsbuwisO2LOXxdHud5TzPPdiMyPdmRoEODa4gk8Y8sWL3fOKbiO
         vM9C6dQ19cDli6IemWG7qEfmhdnR6nB5xFjTwm13DcilJGpOaW/reSmFqMINfS9VehWm
         k+iVR1kbUAo5bGbvYoaas/ov7Zzz3QHeEiOZUJdCfypCNy54L4OnZ73noWAXhe47iVfS
         qrXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=2NNeaxrR+NMRhzaVOnCUXI/8neCm6ZucbRf4oZlkR9w=;
        b=EjYM13OiVyjD05DXIln6HWK3FhKDt3Z3/vDf+FDGZkWZOmF/D7R+5sYC/4yzyf6Rga
         vDnhouCntvfE76ljYffJmZ69DTEvvIUbQhwE0DZau0dmrq82p6v8t8nuNvHLqohifGf+
         eBUrdvinxSj4RX/epi30lCFnChSDd+gjnKDB3O3chFknCiG/TrFFEjbtahMthnK8FkVn
         nqi5HTa2RpnHJxuvDBTXTnB6OyyOCHZFJIvgdaaIGsBRCD7digOnfxUJIKnrHa4SA3eY
         6ZwkEH+thxMVMx26RFLiYHFIELxErQckL6rYmZwOl+TmXkD/r9yvtoUu57Dt8JEguuaQ
         yntg==
X-Gm-Message-State: APjAAAX4Zq+KnoyyZ3YYoLS/ayo95bRuNoSSd6ljz7gWduGQ8QKYAo81
        Qc3opTArNqrnp7ksb4HlmTA=
X-Google-Smtp-Source: APXvYqzu/BdpF6twOVjPdJKoWrfx85xP/hoB6/s9cUrS98W6PlohiMpXPEYzOw4LjM9biu0GSVwCnw==
X-Received: by 2002:a5d:4692:: with SMTP id u18mr62166309wrq.206.1582480607524;
        Sun, 23 Feb 2020 09:56:47 -0800 (PST)
Received: from [192.168.43.74] ([109.126.153.91])
        by smtp.gmail.com with ESMTPSA id a7sm7428647wrm.29.2020.02.23.09.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 09:56:46 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org,
        Jann Horn <jannh@google.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <862fb96f-cebe-dfd8-0042-3284985d8704@gmail.com>
 <3c9a3fca-a780-6d04-65cb-c08ef382a2eb@kernel.dk>
 <a5258ad9-ab20-8068-2cb8-848756cf568d@gmail.com>
 <2d869361-18d0-a0fa-cc53-970078d8b826@kernel.dk>
 <08564f4e-8dd1-d656-a22a-325cc1c3e38f@kernel.dk>
 <231dc76e-697f-d8dd-46cb-53776bdc920d@kernel.dk>
 <fcfcf572-f808-6b3a-f9eb-379657babba5@gmail.com>
 <18d38bb6-70e2-24ce-a668-d279b8e3ce4c@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <b89fa7be-68de-bd17-22e0-813b93272120@gmail.com>
Date:   Sun, 23 Feb 2020 20:55:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <18d38bb6-70e2-24ce-a668-d279b8e3ce4c@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NHmZW9rMxMrgHjP2rPe4lSpHJbzkxE16l"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NHmZW9rMxMrgHjP2rPe4lSpHJbzkxE16l
Content-Type: multipart/mixed; boundary="elJQXN1FLUJZ4n7XXDOlaGeVwtqwv98Qy";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: glauber@scylladb.com, peterz@infradead.org, Jann Horn <jannh@google.com>
Message-ID: <b89fa7be-68de-bd17-22e0-813b93272120@gmail.com>
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <862fb96f-cebe-dfd8-0042-3284985d8704@gmail.com>
 <3c9a3fca-a780-6d04-65cb-c08ef382a2eb@kernel.dk>
 <a5258ad9-ab20-8068-2cb8-848756cf568d@gmail.com>
 <2d869361-18d0-a0fa-cc53-970078d8b826@kernel.dk>
 <08564f4e-8dd1-d656-a22a-325cc1c3e38f@kernel.dk>
 <231dc76e-697f-d8dd-46cb-53776bdc920d@kernel.dk>
 <fcfcf572-f808-6b3a-f9eb-379657babba5@gmail.com>
 <18d38bb6-70e2-24ce-a668-d279b8e3ce4c@kernel.dk>
In-Reply-To: <18d38bb6-70e2-24ce-a668-d279b8e3ce4c@kernel.dk>

--elJQXN1FLUJZ4n7XXDOlaGeVwtqwv98Qy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 23/02/2020 17:49, Jens Axboe wrote:
> On 2/23/20 4:02 AM, Pavel Begunkov wrote:
>> Looking at
>>
>> io_async_task_func() {
>> 	...
>> 	/* ensure req->work.creds is valid for __io_queue_sqe() */
>> 	req->work.creds =3D apoll->work.creds;
>> }
>>
>> It copies creds, but doesn't touch the rest req->work fields. And if y=
ou have
>> one, you most probably got all of them in *grab_env(). Are you sure it=
 doesn't
>> leak, e.g. mmgrab()'ed mm?
>=20
> You're looking at a version that only existed for about 20 min, had to
> check I pushed it out. But ce21471abe0fef is the current one, it does
> a full memcpy() of it.

Lucky me, great then

>=20
> Thanks, I'll fold this in, if you don't mind.

Sure

--=20
Pavel Begunkov


--elJQXN1FLUJZ4n7XXDOlaGeVwtqwv98Qy--

--NHmZW9rMxMrgHjP2rPe4lSpHJbzkxE16l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5SvLMACgkQWt5b1Glr
+6W6lQ//XtNsNYGSfnS1Uozx0u6JGADFSjemP5Lloa6Zh301bNh0izhe4pDVJzuP
YRmYh6qZUPBcfbgPi6DT4Pl/CsmHu0e/WQFOVtUYWstURiqWiTukB8LiPaA8W6Rf
lKUoh/Jz80J10tcfYblu1zvKlQ7sPH2h/Cv1gEY01vQMNJQ1WinFUrCEFFOKg0zg
bYoP51d0d7NyNmNxiXGLs7EqTUY+mi8ieNKnW+oPHu+V4k90a9ZumUa4WmQVWHIh
zoueHVxNPjeibTZmW8kVnwiPhlMQE+wnkvo9etpMKeNjG/RyUcT56d7IJK90icls
gcnWL/VBNnGCTCaoUwm2Org5zmSzfQ2Xesv5bwb0UA5DTE9sxLm+1xO0PMzbOSua
ymC7hGtbahJ/VQ933GBfWwuG/q0vOshddIJ32CIIyN/6MVkiaZqQ5aifI7kfBc9G
Lkkgnl1D+XKLchpBgNd0JnjP/lOFBIfqQ9RQIDeAYbyApKq2xrz/rjaRe+Bit5rh
RmE2WE0ahBNprko9+kXFsXbPzi5tAjigtiJZ17+g45IiYORsFV0qTQMEk/GxmjFp
xHLRKmPRCYD436SfXjBKW4uzWq+2el0/X+Nq7Rd2e52MkdmuvlmGRc8EJAsqN/9L
u9h0JySsOlFndcIvyRumwIQYAAj1l2qxEgWqjwQMO80mdzZ0gcs=
=ohy7
-----END PGP SIGNATURE-----

--NHmZW9rMxMrgHjP2rPe4lSpHJbzkxE16l--
