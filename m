Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA5718EC59
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 21:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgCVU5P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 16:57:15 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55105 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgCVU5O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 16:57:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id c81so2010782wmd.4
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 13:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=ko+9eCkxI+c9dXjeL4SAcO1F0b6O+rcd3hmOLE24dcM=;
        b=FQjiLg5C3PBbx3GpKTZxvypdUn/Y/sBStlqhltqwN+VObSySdvgLtfcIJXl4Iq1NMx
         1d0w5iukUOQBUDFjtJztdcxhlFKWK2FITITyqWMrcdW90Ff8sHtZeqLVrwMFPWpGdh0u
         Ss6BelBvkU3J6gpdrjCiTQojkTD42fCNazJ61alk0rbMDg74Cd2z1fTPEO4iI+wCMGjt
         b6rRlIQevCWYxd8YUgCu2XQzt/YQa25PRSMEZeOYCjNaNNxeB5NTO0W0+RXXAukar+fz
         OCVskF6TDVFj7yWzyccLpOFTX8YJUSpT9nJsGXSyIe1r4zO+hAC3FHPh5uw22XeBpiNG
         sNYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=ko+9eCkxI+c9dXjeL4SAcO1F0b6O+rcd3hmOLE24dcM=;
        b=cqN22Jc0LODYIIfw3KYNe8E6MLRsi86VIIOsNgr9t6ZbZcHeGMO6+4KacC7hwNJIUp
         QE6Q2uq7SzycMgllcSQp+o8DZG/P6sxtku3qgr+gnkJpfmSpoiQwsw6MGuSYqauN22Ep
         OoO8VZdHbbwFEtYuc1e2N89fDE8apL4YXDlcnvH3qdSgSu1DH6xVZJMIlggWU+ygPtnn
         jzyr3FNqqr5bUFwVq1jLNldc1T5eo3TBNsIidXbe901pHtNxDZ4dW7qz0AC6mBO6SQmv
         pimTptiPWOFP+a3dI/oAlLFXhtMeMSl2r/Y7nuW/ji/zlYP2r0XDTTd11IW3OCcS+4a8
         xMoA==
X-Gm-Message-State: ANhLgQ1AREOj9EX9JwKSqVZ+r+TKhdNjg4jE7VmcOdXQLLCEisHUaIoX
        BYBqQolphA1mgRHuBBPtDt0OH8OP
X-Google-Smtp-Source: ADFU+vsgW/dKmTJZKxNkrjdnj4QhB3MFF47qewqfUBEBqQ3ZN6JvTBdPKzC0ZsRh0NA+K09yOyRwFA==
X-Received: by 2002:a1c:4486:: with SMTP id r128mr21523044wma.32.1584910631804;
        Sun, 22 Mar 2020 13:57:11 -0700 (PDT)
Received: from [192.168.43.118] ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id m12sm12256347wmi.3.2020.03.22.13.57.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 13:57:11 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
Message-ID: <cc1ad5fc-dce1-cece-a34d-0894a3e556d6@gmail.com>
Date:   Sun, 22 Mar 2020 23:56:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RHi3NPpOHqBPTbFxXU32dmPx8dUS4QMM1"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RHi3NPpOHqBPTbFxXU32dmPx8dUS4QMM1
Content-Type: multipart/mixed; boundary="FSRq5ImmSgRqNb9UIwzQ2IZfg4xc8QwDJ";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <cc1ad5fc-dce1-cece-a34d-0894a3e556d6@gmail.com>
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
In-Reply-To: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>

--FSRq5ImmSgRqNb9UIwzQ2IZfg4xc8QwDJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 19/03/2020 21:56, Jens Axboe wrote:

>  			if (hash !=3D -1U) {
> +				/*
> +				 * If the local list is non-empty, then we
> +				 * have work that hashed to the same key.
> +				 * No need for a lock round-trip, or fiddling
> +				 * the the free/busy state of the worker, or
> +				 * clearing the hashed state. Just process the
> +				 * next one.
> +				 */
> +				if (!work) {
> +					work =3D wq_first_entry(&list,
> +							      struct io_wq_work,
> +							      list);
> +					if (work) {
> +						wq_node_del(&list, &work->list);
> +						goto got_work;
> +					}
> +				}
> +
>  				spin_lock_irq(&wqe->lock);
>  				wqe->hash_map &=3D ~BIT_ULL(hash);
>  				wqe->flags &=3D ~IO_WQE_FLAG_STALLED;

Let's have an example, where "->" is a link
req0(hash=3D0) -> req1(not_hashed)
req2(hash=3D0)

1. it grabs @req0 (@work=3D@req0) and @req1 (in the local @list)
2. it do @req0->func(), sets @work=3D@req1 and goes to the hash updating =
code (see
above).

3. ```if (!work)``` check  fails, and it clears @hash_map, even though th=
ere is
one of the same hash in the list. It messes up @hash_map accounting, but
probably even can continue working fine.

4. Next, it goes for the second iteration (work =3D=3D req1), do ->func()=
=2E
Then checks @hash, which is -1 for non-hashed req1, and exits leaving req=
2 in
the @list.

Can miss something by looking at diff only, but there are 2 potential poi=
nts to
fix.

BTW, yours patch executes all linked requests first and then goes to the =
next
hashed. Mine do hashed first, and re-enqueue linked requests. The downsid=
e in my
version is the extra re-enqueue. And your approach can't do some cases in=

parallel, e.g. the following is purely sequential:

req0(hash0) -> ... long link ->
req1(hash0) -> ... long link ->
req2(hash0) -> ... long link ->
req3(hash0) -> ... long link ->

It's not hard to convert, though

--=20
Pavel Begunkov


--FSRq5ImmSgRqNb9UIwzQ2IZfg4xc8QwDJ--

--RHi3NPpOHqBPTbFxXU32dmPx8dUS4QMM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl530O0ACgkQWt5b1Glr
+6W6Kw//UtXtolpyNA1Q4GBMFzGG+qV3wA5m6d/CHsuhOlDb/bG9cUj0NlGx9ZWf
aAK+2mCbiNJ5iindav6YSmVQgOD6SLTUGv1mvmLYa6KwHW13UhPyTEYq6fV2QEYH
AIjxmko8zcMei/q70YLAuPShn/KLPV2xvamse+hJRa4Tpc3fWNfdR4fLakDoRdTW
kMCZj6YTEQTH5zvTGy+BnfFu/2/19N3KGyRED3lPlHXRLxi+4n/VY9gq/YEqwIhz
R3MI848NIuxK7z7QU5UNURmfo96y1WUFbsFQVRMQ10F359ULlzxzFYCjCzPvOWtw
U18hhgXWTjUZxMhCh9Mdn4DE+FF2iyIhISv7MuD8kS5CFl5te7pA50dBA1Pscr+d
2rw0rNE4HBap1gtfaOWwbEcDZib4ZacXe55f7w7xIa5D+iBZ/24H19Ru4ZAtBft9
qRbd0VCflw5DicIvQxn+JPfn3o5gdxpyoI/Vmv6IJ9Ddb8/NZSvi0dVFvmzdDTX7
5O2+UEwTlcPFPxwEz9HmlWoXmZ/J2AgiO6ipkZ+/clV2M6JqPgu6KocWfRMhkMSK
RjPlQF0jTemFlJ0mdXXjrDtb0dS0S7F4wUaX9c8qX9OQ7GWkmxosu8/6G16jO4uv
Zznpax843JrTdLPRUO5VVz47qpKtsqTUQCuNit+DpxhKCHfP1xQ=
=a8B8
-----END PGP SIGNATURE-----

--RHi3NPpOHqBPTbFxXU32dmPx8dUS4QMM1--
