Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC21159A20
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbgBKUCH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:02:07 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:50698 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgBKUCG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:02:06 -0500
Received: by mail-wm1-f48.google.com with SMTP id a5so5283235wmb.0
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2020 12:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=drSvcF9Mllz73jJiGPtp0odqf0GjXGRBObxDTED6JBM=;
        b=A/mSBNq21R1Vpn6+0Tpjvh8G028j/J/5zSwJZd+8XN955aC4Hl8v+ImDvcuJJJqKCa
         vNKq17OHsh5A1Khf0yfZysnSTfOss0Fyhwp0/QI7GUpSryA3t1m7BK2xxjPpFITZzchN
         pc8wfj7WNoSMaxp7SdF+8nBHG8ykoEh48nfsp0GjkuiDp9ttn9SBLaecXIJJ7jqaVUhV
         BKK90VxnobsuzpEPRDxurI7KnOekqfIofr9eiyVU1EHck9XFuDKgw/1fQqlPF+wjyuj5
         pztD2TZFDDssRG4KZNuCH7GRLIaGHmWZnbVzip/RyPRsWIA8fsWu1ICsoGDeubj+yQZc
         KADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=drSvcF9Mllz73jJiGPtp0odqf0GjXGRBObxDTED6JBM=;
        b=lwfArN1/iC6zKcdLzVzZXQwT6jtD53kFC34n04S1PKPAWlGX9RQvOqpDD+kQJTjLXP
         EGdZWbwwutX0fb0K+WBpKoN9XnBqH3wsY1ZAsmvS9i06uyZ65Ye6F1HNOjrPC8pIXEmT
         t7JLNR4UblryXg1rRuh4kfEDiMbpOiIyhn/ls92HFP3gWzo1ZXxG5S2sXIGSVY+VkUhC
         3O/Y94t92YiwHFYydfzzeGRWGjaFzi0QgX3YPPsOW6cprElGmOOSo4T35xzfi/fVMfsd
         u1/V9suQ0jjU6nNh2t5f23FcTvYyqYJVFDiXDtIZdwzVNLZrPx6xg1yDTZ0eApk1TFYh
         RKAw==
X-Gm-Message-State: APjAAAXRtwf+FXtArZ/wNXnamxGuQ3kEw8ijkNOGRAgqMGfwwU19Hsxm
        Kx1EIJRmceFx9jkKpyu1wmD+bdtl
X-Google-Smtp-Source: APXvYqwUwBE1Tp96mzUvPUtYm4eD5Yg+CLNogYe+IOO4AX0ROc1WTkVD9r836p3NCYbdtUA5SmSASQ==
X-Received: by 2002:a1c:6408:: with SMTP id y8mr7521908wmb.130.1581451324749;
        Tue, 11 Feb 2020 12:02:04 -0800 (PST)
Received: from [192.168.43.18] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id c9sm5056668wmc.47.2020.02.11.12.02.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 12:02:04 -0800 (PST)
Subject: Re: [PATCHSET 0/3] io_uring: make POLL_ADD support multiple waitqs
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20200210205650.14361-1-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <c3fd3aa0-4358-6148-7486-ea52b410a5a6@gmail.com>
Date:   Tue, 11 Feb 2020 23:01:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200210205650.14361-1-axboe@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="O8yEtNO2UyQfUmPDzTXWURAdXgbEbZiCf"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--O8yEtNO2UyQfUmPDzTXWURAdXgbEbZiCf
Content-Type: multipart/mixed; boundary="8B9hLwbSuA5UMnUmAhG2v2uqxws3flDxx";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <c3fd3aa0-4358-6148-7486-ea52b410a5a6@gmail.com>
Subject: Re: [PATCHSET 0/3] io_uring: make POLL_ADD support multiple waitqs
References: <20200210205650.14361-1-axboe@kernel.dk>
In-Reply-To: <20200210205650.14361-1-axboe@kernel.dk>

--8B9hLwbSuA5UMnUmAhG2v2uqxws3flDxx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/02/2020 23:56, Jens Axboe wrote:
> As mentioned in the previous email, here are the three patches that add=

> support for multiple waitqueues for polling with io_uring.
>=20
> Patches 1-2 are just basic prep patches, and should not have any
> functional changes in them. Patch 3 adds support for allocating a new
> io_poll_iocb unit if we get multiple additions through our queue proc
> for the wait queues. This new 'poll' addition is queued up as well, and=

> it grabs a reference to the original poll request.
>=20
> Please do review, would love to get this (long standing) issue fixed as=

> it's a real problem for various folks.
>=20

I need to dig a bit deeper into poll to understand some moments, but ther=
e is a
question: don't we won't to support arbitrary number of waitqueues then?

--=20
Pavel Begunkov


--8B9hLwbSuA5UMnUmAhG2v2uqxws3flDxx--

--O8yEtNO2UyQfUmPDzTXWURAdXgbEbZiCf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5DCBUACgkQWt5b1Glr
+6WrQw/8CEcfWZOLTmFDGJx8/UwWTTykZiEq2qnmhkI9NrFeFsAVzF3QmOkHHLpQ
oBtN9UNji/Mku2GjldqxRq8/FeP/f8yWn2g7TdpjdkJ0q0KE3+/Hya0LccfBNX20
wEO/00kOpm+fPysq4IoyJ9RkT9OHOdchHjQJlgDQLPHC1kvTNq/Ks/9DI0fdJ/cT
34vlU/xJa/gCE/MfUWdNOMS2OBqcnWEvT6sLKlndNSM1SIeoh9XEoNfMpIb+xZ0T
EFgdVe6+tfDKeJVCvXHSOb5h3EJYzEVp2oMmyQnbVQSugsPHGu0kt0qKKja7O39w
wo6VqHJGIOeTtYphw02xlNQnVT/w0ePZ93Lj+ksz4h5/EnAPVAQBRzR2CdDSkZXA
g31IqB9mpHIZtqZaAGvvi6N3e/FHw7T2VZnhKgYmZMihPX0AO06FIAyKTb88A4/4
LNjohEoPM8Z4DtDlFLIKpUb33PJI+bsNBbb40iMIY9upQ1YYbTAPRctoJpRncDJk
imjToDa9/LtciP/sAKT6OzEi733oFgnwu9k9ZVohyyh9Qi441WpS2RQjZiiF5nO+
RKggTgnl1B9AAYhGyukY5nyAm3gLLFPnIewcJOEmkD9p2N2ZH48UuJApO+RJrIVl
SB9v5ahpQUN1m5V5NLNUrBfWognkccTOWjv5CitMCfrfwSZo65k=
=RdVJ
-----END PGP SIGNATURE-----

--O8yEtNO2UyQfUmPDzTXWURAdXgbEbZiCf--
