Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D8618ECB4
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 22:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgCVVcX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 17:32:23 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33032 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgCVVcW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 17:32:22 -0400
Received: by mail-wm1-f65.google.com with SMTP id r7so11809716wmg.0
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 14:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=LyA+HeBJExNv0dPQ1sDuHKuYYu4K8xVDZTU3esDNXWk=;
        b=A+FLCSQpNMQWl8FvRsDEtC1wKUdCiQOVKULl3GClTUbdwqOHdwdu8DGmQ/D1XxjyNa
         3pvgxcAi1/4GLHv8XXj6g1XFXouFOQ1VVsuePnIPVi9qBykhwQ0K2BgeO/lPtUl5Drsg
         kD7CrrTgN3tX6zHA401xoz7fwP6SUqz1lII+j6WGdtPgH9D7IaSA2CDLMSMRjEkuvODk
         Xui2UYt4SU5Q4ER7Gj7jlndpEHA21IsrekJP2mcdHefVniY+gkjHPdkp5+PDezSb2Vds
         Tn+TxnQCoXKMZNLcVCaqWqsW5xu5MT2MaMg4kFtHM4ThEDtJEjSMC1Nop8b9DozmN7+m
         SFbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=LyA+HeBJExNv0dPQ1sDuHKuYYu4K8xVDZTU3esDNXWk=;
        b=YK5+pwM6+IVL5AviRviwO0FNJPiiRG2Lp7kP/9lZGxfpG5nxBhe+TjqdIz3huseVIb
         bF17MYFxCYPx4QCqWsMpMqH5+rCzd/OtrcKQ6wfAk50kDilRUuYSJbF0Ev90rBNGIEq4
         u7Xr95ZwxZbgXb9wgP0336nCib2vcuaknYDGXONL6CBrbYD6e2NHa/Z/mDAGGY+u/ckv
         aWvXnzLAi3DH4CwNvd5rYWMrAhSr3B2WWLcn9facUJAHU3OVGjze0smAA2xRBgveGeA6
         GM/g7gx/49g0U/vTGHrQN4b+BYsnGN4VIXfmfrhdU3K24PANK3XtDPmiiJ0PDziRqUOc
         o2pg==
X-Gm-Message-State: ANhLgQ1pA6LmeX4sUySspOzArSGlsvwVAkbURYbzEomimFzxG4+fx3ML
        /AsXToLA0+17AFLk86LdL5kiIRMj
X-Google-Smtp-Source: ADFU+vvmCwEMz7WUjpLPcSrdXCD13C6E43mhy0bU0VkQzJtVp2jWZFGkycO9kqhSMc6LtkNMAHJPVA==
X-Received: by 2002:a1c:de82:: with SMTP id v124mr22934899wmg.70.1584912739296;
        Sun, 22 Mar 2020 14:32:19 -0700 (PDT)
Received: from [192.168.43.123] ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id u17sm21768234wra.63.2020.03.22.14.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 14:32:18 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
 <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
 <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
 <cd75e37f-b7c8-91ad-d804-3c4fdf45d3ed@kernel.dk>
 <0f487c49-3394-0434-f91c-72c8e6b8d6f3@kernel.dk>
 <31fb5dbc-203e-36f9-341a-f39022a68637@gmail.com>
 <4275f713-7fc6-d288-d381-dc521fb044db@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <5d09b396-56ca-0a90-732d-ae1dc31195bb@gmail.com>
Date:   Mon, 23 Mar 2020 00:31:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <4275f713-7fc6-d288-d381-dc521fb044db@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UFOU2Bvxxc9CPCtgwYSXGyxgVsTk2pWFY"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UFOU2Bvxxc9CPCtgwYSXGyxgVsTk2pWFY
Content-Type: multipart/mixed; boundary="xZWYTy6YGNkNbXp7YB1KXpzhjSEXQNM04";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <5d09b396-56ca-0a90-732d-ae1dc31195bb@gmail.com>
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
 <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
 <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
 <cd75e37f-b7c8-91ad-d804-3c4fdf45d3ed@kernel.dk>
 <0f487c49-3394-0434-f91c-72c8e6b8d6f3@kernel.dk>
 <31fb5dbc-203e-36f9-341a-f39022a68637@gmail.com>
 <4275f713-7fc6-d288-d381-dc521fb044db@gmail.com>
In-Reply-To: <4275f713-7fc6-d288-d381-dc521fb044db@gmail.com>

--xZWYTy6YGNkNbXp7YB1KXpzhjSEXQNM04
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 23/03/2020 00:16, Pavel Begunkov wrote:
> On 22/03/2020 23:20, Pavel Begunkov wrote:
>> On 22/03/2020 23:15, Jens Axboe wrote:
>>> On 3/22/20 2:05 PM, Jens Axboe wrote:
>>>> On 3/22/20 1:51 PM, Jens Axboe wrote:
>>>>>> Please, tell if you see a hole in the concept. And as said, there =
is
>>>>>> still a bug somewhere.
>>>>
>>>> One quick guess would be that you're wanting to use both work->list =
and
>>>> work->data, the latter is used by links which is where you are crash=
ing.
>>>> Didn't check your list management yet so don't know if that's the ca=
se,
>>>> but if you're still on the list (or manipulating it after), then tha=
t
>>>> would be a bug.
>>>
>>> IOW, by the time you do work->func(&work), the item must be off the
>>> list. Does indeed look like that's exactly the bug you have.
>>>
>>
>> Good guess. I made sure to grab next before ->func(), see next_hashed.=
 And it's
>> not in @work_list, because io_get_next_work() removes it. However, som=
ebody may
>> expect it to be NULL or something. Thanks! I'll check it
>=20
> You're right. Re-enqueue corrupts ->data, so should be fixed for previo=
us
> patches as well. I'll send it
>=20

And the diff works fine if put on top of the fix!

--=20
Pavel Begunkov


--xZWYTy6YGNkNbXp7YB1KXpzhjSEXQNM04--

--UFOU2Bvxxc9CPCtgwYSXGyxgVsTk2pWFY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl532S0ACgkQWt5b1Glr
+6XbtRAAm9LGkOsruXaWyQj6B9PANWe0/LgsakUn+nXD3LTIE9dju9uEthtYEvIJ
npEG4uTppcprigm6u9JGsAj/oQwuNgjtEsHxsZjeOsN4yh+yNP6/6H7ZD5m1cICG
6hYq32P4IyKrOTFGJMAC0IBGX+u9RZOmguMmY+EqdK7jBox+5eB/wX3htZLjIL6a
DhCwDDZOt0Sj+U+KjV9uta3JsH8BIFM44a4taWm3jdNVw5xuMIsW4ckyqmvflT8Y
ARBqKsSuMdY7DVLXyax/GPwcZI/ERM9VmGUstD7lQaM7WVT4CzFV5PvUn+RGJz6d
S5t9dvIPG35nCDPwhIvT6sen9DFP6EK9GeU3f4oz4p0lpZ4hqXY44x7EDY/PvhYW
VbjJM5G5UhxPPruPFpiEwqpW+AmdfOeHXn20k3Zga4/4R3iXUGWaSi/JzNz3hVTx
Pxkc61nAdKX/s12Af4auU9I7u6p+9Tke7VKfPdzoEPnFppYh97pBwfGOvNEwlHFd
JUcjPTFXUrC1aZL3lpdXxcF3TlSA2ydnIhlqCRvyjYmJDUDbeOSC/psJdORPzzgW
xx7y+LeJXrzOPep5CB0WrpqkQ2cWiPWX8xVaGgchk5no0iGv/2kDoqyPKiutpzsu
4OLOdKuhqEsG24Ay0MY3NeIJwjGtlaSrCD0IIO7Ph45NYZVYZ8w=
=ShZZ
-----END PGP SIGNATURE-----

--UFOU2Bvxxc9CPCtgwYSXGyxgVsTk2pWFY--
