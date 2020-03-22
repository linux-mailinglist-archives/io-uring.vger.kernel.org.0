Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2A3F18EC24
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 21:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCVU03 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 16:26:29 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55181 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgCVU03 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 16:26:29 -0400
Received: by mail-wm1-f66.google.com with SMTP id c81so1943685wmd.4
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 13:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=DzkpJY9+lEh8KA7/IvlDEDoXlDl5tLZbdFJkiDZLtfk=;
        b=dY5NFbdTccUwhyR9rewUHiV6s0K1YNkI/wGaOL7Igj8DtlZTDrmUC/xUKlUPFaackX
         lt+Qe2R6ltUipOZShWBLUUgM5p95StNMDN0J7NK/iRDPVu42el2BJ0+oqocmJTu19bns
         24s6i7h13nYvBzOmg4s1Qqy9smnZMwi5iSkAWN2QNSRh0gtc3n+18mWh10JbM9rjleWZ
         8MyiYcO+rce/xYP+EpQOoyXCNPEwN+Ent1KjbhZM8DwmURJhombpaG2b6kZX/bX5Ot3w
         Q0upbjLa07PpLxyOOPnuNao1mq3GtJnhLBOsE8eV8J5cyk72PsrY5oxAXWAKHVPvFT8t
         WqnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=DzkpJY9+lEh8KA7/IvlDEDoXlDl5tLZbdFJkiDZLtfk=;
        b=QoLx4lLRhr1wRgAygpRLnBf4qZFd78Z5c9+D1MwhMaus6qxLu5+H4k/3iiow0S3cag
         x2SRDYz4kMyKEnGyD/Wikjre/sqP25oacJCvKo6dWaD0Z9DJv3u/VQcLLHXsGA8QOn8Q
         wi56Ar7+4uAT3JkyxuQXwwzHyUPHWgUKb3RYcJX0XZgXiAcbiG8HWhU5dMfvPYQ13xxE
         AYwRw+3Yq0LFwUtsHaTTuggFSwTsSyjthren3Tj9iBgNXawh0Q+pdkwH1YSZuBXtZFoH
         n+DN24Spn/5Q+iRnKobdYI9pFlq8SQC3XDt3B/6rG18Bb81b9LyiDZXqQU41iZ03hPVP
         d8lQ==
X-Gm-Message-State: ANhLgQ0ju/2R81jCQF6AFwFxdKA2XuOmNznLXyGOMmagKkhgWnAk1an5
        h8EGCCt4ryHYL5smYLas0q28U3rp
X-Google-Smtp-Source: ADFU+vupCwDHs8zsL00az56YfcbMOK/5Pf6ypBNkPHnE0oHx5ap3pj+4Ex/D5Dr/Eivi/dB3bif7PQ==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr18781014wmi.9.1584908785659;
        Sun, 22 Mar 2020 13:26:25 -0700 (PDT)
Received: from [192.168.43.118] ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id d124sm14608665wmd.37.2020.03.22.13.26.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 13:26:25 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
 <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
 <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
Message-ID: <b8bc3645-a918-f058-7358-b2a541927202@gmail.com>
Date:   Sun, 22 Mar 2020 23:25:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CRiAO4ie2qRtd5OyvDeIHZmpu4oehZbx2"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CRiAO4ie2qRtd5OyvDeIHZmpu4oehZbx2
Content-Type: multipart/mixed; boundary="HHLsypKBgtAnbuATg0FO9RifVXFvzZAjH";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <b8bc3645-a918-f058-7358-b2a541927202@gmail.com>
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
 <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
 <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
In-Reply-To: <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>

--HHLsypKBgtAnbuATg0FO9RifVXFvzZAjH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 22/03/2020 22:51, Jens Axboe wrote:
> commit f1d96a8fcbbbb22d4fbc1d69eaaa678bbb0ff6e2
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Fri Mar 13 22:29:14 2020 +0300
>=20
>     io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}
>=20
> which is what I ran into as well last week...

I picked it before testing

> The extra memory isn't a bit deal, it's very minor. My main concern
> would be fairness, since we'd then be grabbing non-contig hashed chunks=
,
> before we did not. May not be a concern as long as we ensure the
> non-hasned (and differently hashed) work can proceed in parallel. For m=
y
> end, I deliberately added:

Don't think it's really a problem, all ordering/scheduling is up to users=
 (i.e.
io_uring), and it can't infinitely postpone a work, because it's processi=
ng
spliced requests without taking more, even if new ones hash to the same b=
it.

> +	/* already have hashed work, let new worker get this */
> +	if (ret) {
> +		struct io_wqe_acct *acct;
> +
> +		/* get new worker for unhashed, if none now */
> +		acct =3D io_work_get_acct(wqe, work);
> +		if (!atomic_read(&acct->nr_running))
> +			io_wqe_wake_worker(wqe, acct);
> +		break;
> +	}
>=20
> to try and improve that.

Is there performance problems with your patch without this chunk? I may s=
ee
another problem with yours, I need to think it through.

>=20
> I'll run a quick test with yours.

--=20
Pavel Begunkov


--HHLsypKBgtAnbuATg0FO9RifVXFvzZAjH--

--CRiAO4ie2qRtd5OyvDeIHZmpu4oehZbx2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl53yboACgkQWt5b1Glr
+6UXrBAAoTyAPp+HIFpM944rAt5+hdu03j6ephvSmCmljea7/+YZ6wr0dVMcvoKq
4N6s/t1/2Z81MRZwa2YaxYPSaANQLk3KZsvE9ppONIeNtVyhy3jPPSF2B0GLAoPo
K9lROY3EfjFijfAtgcYeldN8PHkoO2GdvMz4l8AUsdfDB5WfecZ7ZtnZAyArnVYq
zxVq1H/lmcDu/Oo+s7mk4r3SqhDNqzH1n9JTLGqIG2p0NCF47HAsibr8qhyyjuEi
5zo23odE0xHcbk42zLwfayyyNS/wZeE/2xQInw36B9wiZuqKm1pXpwvq4zJc7A1U
5pB/1LfszqOW3xtEHsZUgd7JJLYALZaj2xcEQY8wX1cmOvT4s9LpMjg4/aCqhLw7
N9q6B+yuacELh1XbdRZes8Xkh0xA4j1Yau9PlzJMuVruSgEkMMnQJvUjw+vaZFbM
FenekR1rCw9ZIWBQZ7RG/LEmjyljdNtrzMrbBSb/z+rBW1556M//HfaE1DiKDZNq
shrKHiLP1UdOIWStBF7jC8XyA1pkwLW9mQRCLxW8u9+4w5SCYiB2z2tafCoqquFz
w9W7OqEDsk496cdatdruOj0Ll0bUNwQt31ZkXcA853jVLWsitBqKarfgHrfUa4GX
snIA2faxQhM4W/bqGAPYfaXrPVu13Kb4EXVq98e2WiEVgBlw1tM=
=LdgA
-----END PGP SIGNATURE-----

--CRiAO4ie2qRtd5OyvDeIHZmpu4oehZbx2--
