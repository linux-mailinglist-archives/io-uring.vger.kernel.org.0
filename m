Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E514138852
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2020 22:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733179AbgALVVu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jan 2020 16:21:50 -0500
Received: from mail-lj1-f179.google.com ([209.85.208.179]:34908 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732825AbgALVVu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jan 2020 16:21:50 -0500
Received: by mail-lj1-f179.google.com with SMTP id j1so7821257lja.2
        for <io-uring@vger.kernel.org>; Sun, 12 Jan 2020 13:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=GPKsU47+7R5NyejRDCLqSH2KFbmxbaUItrvOjFjF5gU=;
        b=vb+exK57vTx7EqKVKFvMUSLIbm7cw7fVf92gumMp/iHOZfZnLpH6n7EryD1VKOScKA
         AyrlkKva1IG0QIrkRA5/a3B8txgZdfFrJGycOsocUUFRLr9jgLrKw9FX3N35tvp2OofN
         bUhs5MYPzAa0djkaDA5G9oRnN4/NLqTqoghFklJ235+QX6DlQ5P2dAsx7BhFnqZ54/RE
         6xpeDPddS1CNwqSR5P7Aha1cF8edev+U2gQUpVkwiKM8D1nYzV9IBnQuDVO91+WWWoy9
         1kxzujswTbJ1pl4ikR8cb1i2muySFqwGcb7dvpnABYguX2z4bCQpsqH+K0ZEEU6MZ2R/
         ju7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=GPKsU47+7R5NyejRDCLqSH2KFbmxbaUItrvOjFjF5gU=;
        b=foD2SixqJCPTqvcTcPd1auEiNtMQMwXl+qz19M7ZRvhZ90pZU+xQF8HZGMjfxDtGYX
         DZ45GlZ7UZXkHK7H633OI1AbSkzUKAMPL4r6ToezZYnYrZ+A8OfkUgnHfqMr14KQIw0x
         u5vLiLYPlGQd9IAMddWwb/1LMFbGENF7r9vuiDvwuH+JoCfpux8jKV7riC2VkhChf3hI
         OD+uqchsnqr3If7G7THwIV6J83MuSjIsao5hddGsz9Wk5kT0Sqs+cy/DZErYMge/DvTI
         pAw35Tt6US3h0DCziBvpVrHlg+ocJgmzC1qugxTYbgLgNEsdYI3lhHntPmKjXGJrF7mm
         /oeA==
X-Gm-Message-State: APjAAAW77zEA29BZOnvIGU/C0asJXNGpadSZJbIww/uxceNOmkfk8PVF
        LkC/msK/KDWqSww6uoPffCPZTSXL
X-Google-Smtp-Source: APXvYqzfAUuTVsvvrP56h1a9D/TRzrWvsBBn7mudoIiHuDWJLvWDJ2Jlrk4H/aVhVeK3XUk0snQu4w==
X-Received: by 2002:a2e:9d0f:: with SMTP id t15mr8718404lji.171.1578864107939;
        Sun, 12 Jan 2020 13:21:47 -0800 (PST)
Received: from [192.168.43.115] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id q26sm4622031lfb.26.2020.01.12.13.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2020 13:21:47 -0800 (PST)
To:     Mark Papadakis <markuspapadakis@icloud.com>,
        io-uring@vger.kernel.org
References: <CBBC10BD-9497-4248-9E6A-AF2DE788E401@icloud.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Feature: zero-copy splice API/opcode
Message-ID: <457632cf-614c-ac55-b869-39b50a61e1fd@gmail.com>
Date:   Mon, 13 Jan 2020 00:21:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CBBC10BD-9497-4248-9E6A-AF2DE788E401@icloud.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Uozf36OHpdV8rWpAPZhSwjfPluBM7XOBp"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Uozf36OHpdV8rWpAPZhSwjfPluBM7XOBp
Content-Type: multipart/mixed; boundary="eZlxHQrl51HcwXqKQsC06GFbHZwSz0OQV";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Mark Papadakis <markuspapadakis@icloud.com>, io-uring@vger.kernel.org
Message-ID: <457632cf-614c-ac55-b869-39b50a61e1fd@gmail.com>
Subject: Re: Feature: zero-copy splice API/opcode
References: <CBBC10BD-9497-4248-9E6A-AF2DE788E401@icloud.com>
In-Reply-To: <CBBC10BD-9497-4248-9E6A-AF2DE788E401@icloud.com>

--eZlxHQrl51HcwXqKQsC06GFbHZwSz0OQV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 09/01/2020 17:58, Mark Papadakis wrote:
> Greetings,
>=20
> I =E2=80=98ve been trying to replicate the benefits provided by sendfil=
e() using e.g O_DIRECT access, together with IOSQE_IO_LINK in SQE flags a=
nd MSG_ZEROCOPY, but it doesn=E2=80=99t appear to work. Other ideas didn=E2=
=80=99t work either.
>=20
> I would really appreciate a sendfile like SQE opcode, but maybe some so=
rt of generic DMA/zero-copy based opcode based on splice semantics could =
be implemented, so that e.g a vmsplice() like alternative could also work=
=2E
>=20
Sounds interesting, I'll look into this. First, I want to dig a bit into
kernel's zero-copy and get an idea how to cover all use cases with a sing=
le
opcode, and that's probably keeping in mind p2p.

The obvious nuisance from  perspective is that it needs 2 fds. Any other =
concerns?

>=20
> (That would be the last remaining bit of functionality missing from io_=
uring, now that Jens has implemented support for IOSQE_ASYNC, IORING_REGI=
STER_EVENTFD_ASYNC and for managing epoll FDs, for enabling support for i=
o_uring on https://github.com/phaistos-networks/TANK ).
>=20
> Thank you,
> @markpapadakis
>=20

--=20
Pavel Begunkov


--eZlxHQrl51HcwXqKQsC06GFbHZwSz0OQV--

--Uozf36OHpdV8rWpAPZhSwjfPluBM7XOBp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4bjcUACgkQWt5b1Glr
+6UEvhAArrFhTQrYIN2HN7qdpKQj1JyRZt+ncf7HVilrcsrkvPSMRLjVu/UdzYxX
fzVF0GX1w6G68/l4EfYX/XHuZ7RBcsLpi3hV48SvfJ8ifzFWZJeKtjcWs12AXicb
CV3pADiV4+SdRtFbACV8YAyzDt4s8OUnuK+nXGisCW+R1ichGvY4HFF38+r3JD8V
k3+zPWwGFFl76LrBLjJ8x/z80PDDoN3btA0/WjBdKZTM7230sNLqnQV3KF6sy5hD
ZaprqQkRNQCRHnLtUXBnZo1zfsuK/1tLcEvig4kl41LltQXcLXueRFLUb7TnN/sX
ApJAJYYtIErCj9Vfq85J9WrrwTzpshusVukZG853fGOSiXiOd8ozkyz+YjHm3sU2
aQO6QaSEvCidw+FC+oLoT0H9mDzg5ritSfdG7ed8Y+Lmx6Gse6k3Fx9C2FcesB1y
QM1m17GsEyiWSsYVDG5wFvIvgvAFvBOOKOOyQcl41dH8BMgYCNA3+DxYl0n9Ptme
ZOgvuRsVljecDuJZogc5R8poHHTZ8I6sHkb84FhqVqR/WktbHTzWOhTelvvdCw0L
zRLCsbxgsAb88F2xT5JTRYCm1e+vj+/rz1X/tG83mhak4iIlJs5NZmihWHcYLrtX
Yoe7yhBcPoepf7QgmeSHdBMtOrpFPvGEbxy+xPLeN8ZG8DA1uX4=
=80sK
-----END PGP SIGNATURE-----

--Uozf36OHpdV8rWpAPZhSwjfPluBM7XOBp--
