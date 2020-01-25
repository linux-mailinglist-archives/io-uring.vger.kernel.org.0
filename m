Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A279414976F
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 20:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgAYT2o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 14:28:44 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40013 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAYT2n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jan 2020 14:28:43 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so2764011wmi.5;
        Sat, 25 Jan 2020 11:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=K2p6QzpMG//lv6KHQiuaepkl0VRRhGVtYDXG4vDc+uc=;
        b=KIvHkDXe3U/Nvay+9VdOich23don7+s7oP2/KU5ftckQ8UiaBEjkmwBfvLXZeEBjqw
         ygXycQGlXRW8rBpcCdLbidFc2z9kB7dk7TUniqG62KyBN4nv0N3KY0lHpXlrdXvszDFt
         F9imNuC7sqABr8S9zI2rH70exCNBfdXNO2vhOk4+Bq4WafvYGDm6YsBgmCTfBjPHU/Ak
         eAb+zAVzd788BOVxkbrpXVOY5QtXwtznZuf7glacZTXLbHiq/Z8ADxpUfMx7SxBImz/Q
         cBl7lLzuQ1Zjzfc9ILSMUjY4ZSk6hKui3Z+1WmlSgRAMVtPKsgeDFun4/cWjZXDvPN5z
         naGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=K2p6QzpMG//lv6KHQiuaepkl0VRRhGVtYDXG4vDc+uc=;
        b=qkgPcJuz7kPFsobDlTJO3gBk9uXumQIGhIzd9yintrqPy1cexZypFNLASY+1lir81N
         XAFW/2YU8HGddhobxJLrsAqhWyRs7XQnlqR1CufRHZpaNwve7ifF2jdMb/nId4DW+2dW
         rMmenDoUkbR/7k61/f1i4WWtgC8derpQXuTQ4LqXsWLxTXe7JJUTmi439oPi90VRAgsp
         Rvozs4I1YJyUo702ox3G9NMTcqQ4PkV9LxdKUr/j7OOpPdemLS5Yu7UNnu7Z7zYPatn6
         kPgLr0CU5GhWGnyvol6dJXRkiPcvz6AP3SPxEGff4kB2G6kxETM7Xfz22izH4ScKC0BE
         Vulg==
X-Gm-Message-State: APjAAAXu8lZDv9ACIekmaWkHG7duN2QbTlT3FhcSRAK+zZEsOdCjDLiy
        gahKfSqB83CAbfmZjd0x5iZqQDT8
X-Google-Smtp-Source: APXvYqw1B3lD3OLSnfYAmgKJHktIxjgSDYb4UjuKq5YWFOroVTWKpzLufU8rNhUG+i5BPfE4SP3yug==
X-Received: by 2002:a1c:960c:: with SMTP id y12mr5318245wmd.9.1579980520905;
        Sat, 25 Jan 2020 11:28:40 -0800 (PST)
Received: from [192.168.43.247] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id z25sm12627116wmf.14.2020.01.25.11.28.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 11:28:40 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: fix refcounting with OOM
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <fa69cae513308ef3f681e13888a4f551c67ef3a2.1579942715.git.asml.silence@gmail.com>
 <78a57f0e-2412-472a-86c2-5e634a74147f@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <7b4c1986-97ef-4f29-673c-afea847f8799@gmail.com>
Date:   Sat, 25 Jan 2020 22:27:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <78a57f0e-2412-472a-86c2-5e634a74147f@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="J89vpxR0mwqKYTsXwxg8A6unXsPlNHh6j"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J89vpxR0mwqKYTsXwxg8A6unXsPlNHh6j
Content-Type: multipart/mixed; boundary="PPJBDkZCEmnDHg7rQst2K1Arxl5upPFu6";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <7b4c1986-97ef-4f29-673c-afea847f8799@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix refcounting with OOM
References: <fa69cae513308ef3f681e13888a4f551c67ef3a2.1579942715.git.asml.silence@gmail.com>
 <78a57f0e-2412-472a-86c2-5e634a74147f@kernel.dk>
In-Reply-To: <78a57f0e-2412-472a-86c2-5e634a74147f@kernel.dk>

--PPJBDkZCEmnDHg7rQst2K1Arxl5upPFu6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 25/01/2020 19:46, Jens Axboe wrote:
> On 1/25/20 1:59 AM, Pavel Begunkov wrote:
>> In case of out of memory the second argument of percpu_ref_put_many() =
in
>> io_submit_sqes() may evaluate into "nr - (-EAGAIN)", that is clearly
>> wrong.
>=20
> Can you reorder this one before your series, I haven't had time
> to take a look at that yet and I don't think this bug fix should
> depend on it.
>=20
Sure.

--=20
Pavel Begunkov


--PPJBDkZCEmnDHg7rQst2K1Arxl5upPFu6--

--J89vpxR0mwqKYTsXwxg8A6unXsPlNHh6j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4slsUACgkQWt5b1Glr
+6XXdBAAml5FsQkzM9JMAruE70RlVmakXc+d0SYNAlEbUERp6qZ9jTgYpaO3XNR8
xO0s6I9AauTnTGf18mAxfkOHtwEKqb8FcpifnVnvy89Fepj8gel/T4f0sHB15vM3
piH38KZ4Prth9FtgpP3B67TtxIezvBtT8sz5VJyGyALkJrntz2kiFYYIPzdzv5vV
cMMJAy9nBpixxpQA751QuVGOQvcWFrGdbnc9DYZ+A6MZsd3npAvNoyY4kuE9WRTE
jzJT9a1tRF+3wFROkl6pt8v5kLfwPGbNtoUfvsnxmVpYrcs2gdpFv/AOlAXkkM1S
U4PQn17X+28CO1AuuEggda08hkH045HlQVXyDhTuoOzdWgL5lQdtyc5BdRgYk7hv
CUafnomgRnYVdGqQ1r4ykK8nPs8hSPPfAztkDY4ZUt1PamnOih9satH/hTtuIfhq
lcIf6HFCQ2l6t73zLjC3xPceitsrG8KncD67gILcVP3J5FClGzhLSRDc0JhCyLVu
wcJkMMXLVEt0zIfqvQ7erP7AbFQe1KfbrOHXasbKuy+xKSKqajEoMGvnZOlrm7CA
ip3G0nc/wAfpP6O8DJ/r0Nedn8gJclUmc2HoT0XCCfc+0mfiILQHb4sthVuO1k3S
OuX5uhyr72RgBuREK/510CSMCDX4+X1G61fEou3AKtI+zYy7Oq8=
=c0+i
-----END PGP SIGNATURE-----

--J89vpxR0mwqKYTsXwxg8A6unXsPlNHh6j--
