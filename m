Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8F8159A93
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgBKUha (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:37:30 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:55317 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728063AbgBKUha (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:37:30 -0500
Received: by mail-wm1-f52.google.com with SMTP id q9so5408645wmj.5
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2020 12:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=C3QZTQIYRWGAtNZp7z8mDoQRBNDxIrCwVKe/a6Yio2A=;
        b=Bm1fHiQfB6GFi6g0C9Eq0RFU2vpqb/0ftZ+27fcgfEKgxBlfB+pB/DqBNWbTEnTxdD
         UPyy+VHqQEkzZGIR1/CFoSR9U9jIshHNoxd/S5TSxFfyiaxOo6aLyXorxkxnnFe3hV4P
         q3a6VNziyXitePTrNNYJX055G7MTCrfYy2PdZfeUS32BB0qrq2ZhvE7TsrbrI2kBO0Wy
         L5Cp+GONEiyGiQn406nH96i8EJ3giaCJfb2Dfh53DSd24g/v6g4kqdIIs+YChw10FYTz
         bqAc/oQK76jR2dNY+j2ksuqlAHf6nCPg0ILfxYZ4v5gK+tnk5ztS6gzwGrPX3+otufC3
         I3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=C3QZTQIYRWGAtNZp7z8mDoQRBNDxIrCwVKe/a6Yio2A=;
        b=oDsQNg5lLqhu8himVuzHfYwqoBXFZ0MU+gg6UBskPLJTc9z1uPvS5wozOX7+QeDxcN
         n+Hc93i9avqUY3vdtkEOtfb9oJ5pkQRtD6YbMgp1kGbn6FCTBtRZ096Kf0rCvmnyICNk
         4c4UhLyidqgd0Zfi1kK9gkDvzUvLaXNDLJ1cqnnjXOtRGXXazf9ZQ/BR/rXzKHtNE0Du
         at4E95RjlDueQSzymLZI0seHeFSSQJvQ9yd2BdBNmYAtpI2XsL1kxnSG1bdCeYospl5+
         8ZORSSG6fjgUies1SwTz7fh13hiDbQvs53ZOnuESOrms55/+p9GenqJ3QQn+2PKpIgBB
         n1gg==
X-Gm-Message-State: APjAAAWjhLi5pp4ireulm8FNEeuDTHseHgRWPXtdLphtvs037BpoPWh/
        o6F7CWXAK808s9+nhPdtiHHkjBA8
X-Google-Smtp-Source: APXvYqwScAbXX8MSqa6hJRzwioX2e/Ix5A+AOBJrgfK87Z0EPJDy3bK/gGdYvnB5QQfAbsYy0M5MfQ==
X-Received: by 2002:a05:600c:2c50:: with SMTP id r16mr7533904wmg.74.1581453447211;
        Tue, 11 Feb 2020 12:37:27 -0800 (PST)
Received: from [192.168.43.18] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id s8sm5152424wmh.26.2020.02.11.12.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 12:37:26 -0800 (PST)
Subject: Re: [RFC] do_hashed and wq enqueue
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <f0662f54-3964-9cef-151d-3102c9280757@gmail.com>
 <00a3935a-043a-ee60-2206-2e62ec8c2936@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <31a63d75-5022-a427-d123-90b2e2ca6350@gmail.com>
Date:   Tue, 11 Feb 2020 23:36:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <00a3935a-043a-ee60-2206-2e62ec8c2936@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zcADxSWOdNcyYTEBPaqvdoVyWrK9NLyKg"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zcADxSWOdNcyYTEBPaqvdoVyWrK9NLyKg
Content-Type: multipart/mixed; boundary="Prpz8ZaYCrVfJm3IqM7NFSUFh58gjWo71";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <31a63d75-5022-a427-d123-90b2e2ca6350@gmail.com>
Subject: Re: [RFC] do_hashed and wq enqueue
References: <f0662f54-3964-9cef-151d-3102c9280757@gmail.com>
 <00a3935a-043a-ee60-2206-2e62ec8c2936@kernel.dk>
In-Reply-To: <00a3935a-043a-ee60-2206-2e62ec8c2936@kernel.dk>

--Prpz8ZaYCrVfJm3IqM7NFSUFh58gjWo71
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/02/2020 23:30, Jens Axboe wrote:
> On 2/11/20 1:20 PM, Pavel Begunkov wrote:
>> Hi,
>>
>> I've been looking for hashed io-wq enqueuing, but not fully understand=
 the
>> issue. As I remember, it was something about getting around blocking f=
or
>> buffered I/O. Is that so? Is there any write-up of a thread for this i=
ssue?
>=20
> Not sure if there's a writeup, but the issue is that buffered writes al=
l
> need to grab the per-inode mutex. Hence if you don't serialize these wr=
ites,
> you end up having potentially quite a few threads banging on the same m=
utex.
> This causes a high level of lock contention (and scheduling). By serial=
izing
> by inode hash we avoid that, and yield the same performance.
>=20
> Dave Chinner is working on lifting this restriction, at which point we'=
ll
> have to gate the hashing based on whether or not the fs is smart or dum=
b
> when it comes to buffered writes and locking.

Got it, thanks!

>> My case is 2-fd request, and I'm not sure how it should look. For spli=
ce() it's
>> probably Ok to hash the non-pipe end (if any), but I wonder how it sho=
uld work,
>> if, for example, the restriction will be removed.
>=20
> Probably just do the same, but for the output fd only (and following th=
e
> same restrictions in terms of file type).
>=20

--=20
Pavel Begunkov


--Prpz8ZaYCrVfJm3IqM7NFSUFh58gjWo71--

--zcADxSWOdNcyYTEBPaqvdoVyWrK9NLyKg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5DEF0ACgkQWt5b1Glr
+6WnyxAAuP14nGCHGIt3/E2mkaWFjo57ezoh3pto3BKThMFrKXwCu3wgnKoE2oZc
kA0rXv+TSk4eDlcmSFID5rn/hwVqh9Qp3r2wYa/IS39887En4Wgs5TjQ3QMImRZx
stoHvQ8Iqhe4BdosQGLqyN0Wpay3y3TRs3faye6FIfEnw8iEWTUBarEiEBkpzr7v
m2CEMqO9LSkf/kCUgIW6tqaRr3Rxh6mDCFkQ92ZwKzgqVxYnlti0jZPkCS7DvJSG
DjTdfgAX3t184slGfAW9+VUe2maKiaaU8Hdp7cCiU1Z8cyDfmPwcU9cS4/CfNzOB
SiOcuIln0kFQynOCpWNb0TlNgbXfEE7dSQdAdGLBCc6RuBjm7FnmOApKYdvcOIpg
/TX1MMCRzqvXXABcEln3MWAC0s9nHlXltR4vZo8hWfF7u1E8fp+Y5VuosjZvdCbI
wUsPswnQcB77QCD74S7tZQU66ZPRk7dj41YyBrs3iMKRyatKbyyCRJaWz3ImQwT4
5rtC376U5DAzyVo7/9VYeJDPykfnPh7ovwsJ4dTYnKzOC0sinBvym1VhWT11pUdS
ozeWmgIj3Z46+RDZlf0wHFPi9DwuONe2LutBi+8LGggbIKir2ckfP7VnCvRphEkT
lgX2rUaBlDil9C7h07D5470PVFUA9lhPKY0oRkBxBCHdyCwSEgo=
=SIAx
-----END PGP SIGNATURE-----

--zcADxSWOdNcyYTEBPaqvdoVyWrK9NLyKg--
