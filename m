Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3579B144A6B
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 04:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgAVD3P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 22:29:15 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:40625 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbgAVD3P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 22:29:15 -0500
Received: by mail-wm1-f45.google.com with SMTP id t14so5624077wmi.5
        for <io-uring@vger.kernel.org>; Tue, 21 Jan 2020 19:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=ViZKXPpcGiNRLaNjqCRL50Bi8hqd37v8Jh08k6Fwck8=;
        b=bxhTJxkXxbEUJ5pog93U3vIkx7yhBXQVMeFqSSGVwBGvNroNA/MQmpI47Mk6yxciHG
         98EFS/3+nHpz3aeKqRoA2zgcrVzsDmnRF4jv5ceZaxO8HlRaWAfGf5GSGqiJjuuar5LT
         TWxv+ibXfnaGxV3zQCc7x8bJWxk1VsCEnCHe1mpqgvIoECzQBOZ3/N3gwYm1Zx2iV82D
         amffb7pGHRRRCJa2a60knhmPIUTOL9PVAc3GDyGxMTy1ZmnaZv6UvvR4DfFwiTDSMAo1
         s1YDVGB+nXZkLAG5DUXUrr1fiFxR7oABgihKjxLqKmBrYU648IIjuITi0u/f0vi+7cSO
         Yn4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=ViZKXPpcGiNRLaNjqCRL50Bi8hqd37v8Jh08k6Fwck8=;
        b=CLz9nmNhRwK1F2tncO9vOWN5g+oDfD3h7Oq7KuerrAAwGllk9Znz/7/R3vIFxPlc4G
         W1INXR0ZOoQ/GLY+R1hzPZvRVX7fEUSAFcpoIlOsot6mfGDhtRvJJdlAwZPndbWVPkoB
         WjqiGhTqx7y6J6Ufp9Ghi5pQaxjcA3/lPf5dYSXgYr9YarkeQ9Z+rPvRRFYCwWMJb7PM
         4KS0qxQtP3kB/EKu68e9bHbYaxaeE7hbgQFAOc1PQQjm+u5UH/Y//3S4aJigZGuOpGZW
         610w0LzzbFSpYIUB1WYPSaRh9NPIpyCW5gF+wbycdxx3RZZgFakfFTcI9+T/VJiqQecg
         EkKA==
X-Gm-Message-State: APjAAAW6pkkWd8UYPv9ZfMIq/3dRClBaW7iB4Pg+rNyKpfefmWgcjp0+
        W/1iRCO6dDOcUNgUoDB8v0f9etOk
X-Google-Smtp-Source: APXvYqyFoO3z3COnBtiHWWT+67HSK/BcR8k5YikZl33ixG4cgU5dLKo4thbVzqEa9YmTBSsQRhXDLg==
X-Received: by 2002:a1c:9cce:: with SMTP id f197mr329921wme.133.1579663751920;
        Tue, 21 Jan 2020 19:29:11 -0800 (PST)
Received: from [192.168.43.234] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id b137sm2118126wme.26.2020.01.21.19.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 19:29:11 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>,
        Dmitry Sychov <dmitry.sychov@gmail.com>,
        io-uring@vger.kernel.org
References: <CADPKF+ew9UEcpmo-pwiVqiLS5SK2ZHd0ApOqhqG1+BfgBaK5MQ@mail.gmail.com>
 <1f98dcc3-165e-2318-7569-e380b5959de7@kernel.dk>
 <CADPKF+e3vzmfhYmGn1MSyjknMWQwCyi9NjWnzL23ADxAvbSNRw@mail.gmail.com>
 <77680e62-881d-5130-2d32-fc3cf5b9e065@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Waiting for requests completions from multiple threads
Message-ID: <366bcd60-f28b-4443-35d5-d8e7bfe7bba8@gmail.com>
Date:   Wed, 22 Jan 2020 06:28:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <77680e62-881d-5130-2d32-fc3cf5b9e065@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JuryWPpIW4zYsllZIUNoEexpV4XEJPbLL"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JuryWPpIW4zYsllZIUNoEexpV4XEJPbLL
Content-Type: multipart/mixed; boundary="K4hWh7hoqzl9i688PGZpTsE5AIfwDVyrZ";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Dmitry Sychov <dmitry.sychov@gmail.com>,
 io-uring@vger.kernel.org
Message-ID: <366bcd60-f28b-4443-35d5-d8e7bfe7bba8@gmail.com>
Subject: Re: Waiting for requests completions from multiple threads
References: <CADPKF+ew9UEcpmo-pwiVqiLS5SK2ZHd0ApOqhqG1+BfgBaK5MQ@mail.gmail.com>
 <1f98dcc3-165e-2318-7569-e380b5959de7@kernel.dk>
 <CADPKF+e3vzmfhYmGn1MSyjknMWQwCyi9NjWnzL23ADxAvbSNRw@mail.gmail.com>
 <77680e62-881d-5130-2d32-fc3cf5b9e065@kernel.dk>
In-Reply-To: <77680e62-881d-5130-2d32-fc3cf5b9e065@kernel.dk>

--K4hWh7hoqzl9i688PGZpTsE5AIfwDVyrZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 22/01/2020 06:16, Jens Axboe wrote:
> On 1/21/20 8:09 PM, Dmitry Sychov wrote:
>> Thank you for quick reply! Yes I understand that I need a sort of
>> serializable-level isolation
>> when accessing the rings - I hope this could be done with a simple
>> atomic cmp-add after optimistic write ring update.
>=20
> That's not a bad idea, that could definitely work, and would be more
> efficient than just grabbing a lock.
>=20

If I got it right, it still will spam the system with atomics.
There is another pattern to consider, (seen in the networking world a lot=
). Just
one thread gets completions (i.e. calls io_uring_enter()), and than distr=
ibutes
jobs to a thread pool.
And for this distribution there are a lot of way to do it efficiently. E.=
g. see
internal techniques in java fork join merge.

That's for completion part.

> Could also be made to work quite nicely with restartable sequences. I'd=

> love to see liburing grow support for smarter sharing of a ring, that's=

> really where that belongs.
>=20
>> Correct me if I'am wrong, but from my understanding the kernel can
>> start to pick up newly written Uring jobs
>> without waiting for the "io_uring_enter" user level call and that's
>> why we need a write barrier(so that
>> the ring state is always valid for the kernel), else "io_uring_enter"
>> could serve as a write barrier itself as well...
>=20
> By uring jobs, you mean SQEs, or submission queue entries? The kernel
> only picks up what you ask it to, it won't randomly just grab entries
> from the SQ ring unless you do an io_uring_enter() and tell it to
> consume N entries. The exception is if you setup the ring with
> IORING_SETUP_SQPOLL, in which case the kernel will maintain a submissio=
n
> thread. For that case, yes, the kernel can pickup an entry as soon as
> the SQ tail is updated by the application.
>=20

--=20
Pavel Begunkov


--K4hWh7hoqzl9i688PGZpTsE5AIfwDVyrZ--

--JuryWPpIW4zYsllZIUNoEexpV4XEJPbLL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4nwWMACgkQWt5b1Glr
+6WjeA/7B+0QSI2h3mG7PKPioO40DwTSVf7+pJY1IGxdY84+ZqcdCcrSgl9Q1JmA
Bx70s0Y05rvjXDJ16j2xGkeIZ32Tg08jHu6ftuQLzPMotsaDEiXQMs2GM5bBvWfk
nCZVoCxWPM8pHSGt8pMy+F4asvpp/E5X/9d3l9QD2sCrOm4Nk2DOVz4G1PFxnHFH
lBv7hyOFyvh/UifpHMmumDfr+DN43A4WyUMuwAEMm8vI1P4VB1Z6kuUk33YnFCAh
h+h5sy3emiTr6yY8OuhqzFLLQBWiySgMnL+gzkGKAfK91y/YqyuGuc6rmK0JYtSr
TwSG29NGu4JH//35hcGWzmp7paxclK7FJW/lt1L1vMo6nVPMQuuxRjqLvVprD+NN
rmj0mWabaj4DQo/kPgK/gbn8KR1Ys/vHh2AsXP6G/MkpRn/Qy2Jwq6EM6+zGnh4W
3/xHRnFXEOPmTxxzBS2l5TljG4IHp9V8VonaiP93S3MYHkFe8OE6S/KicEJicVlG
6RCJ2ZM2uyVM40rKEFLYEFb+E/poL7l6zF4ooa09Y4I0Q7/zwMq6iGS8ZEjETjDh
R0lkDkkPRIDU6xOZmTbJqNOLqjjxG+YJAfwQ1uEJW57gm4TjhJA8mEChczasqnJw
NnLX6wIi9LYzmMsMQlyZU6yE2tvcrzgScerSq3ZX5qDwLp+TqSA=
=xFn0
-----END PGP SIGNATURE-----

--JuryWPpIW4zYsllZIUNoEexpV4XEJPbLL--
