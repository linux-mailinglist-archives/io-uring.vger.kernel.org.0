Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E45A14B082
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 08:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgA1Hm5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 02:42:57 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55459 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgA1Hm5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 02:42:57 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so1325845wmj.5;
        Mon, 27 Jan 2020 23:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=EFZUsCCpYbGtRZQ5nf0ELVBxl95PGaXXfGM6bASnSFQ=;
        b=gqABSPo6XpQEQqp9jhD2tcP2kGz8z+1BCoJDoL1n2qXZmXWC2A2xTlR9+vIZVeTgSy
         amOizvU4eSXiRyC5JuNkQCy5uWN9Q/j/LwddQQinng29csnreVFiJjwkm7G3dynfbfYh
         bt3AWyW2D7hKOYfB4f75LwQpzdYRdXjofriC2hIsDESZfjST6mwLdGMe1KRCdVZ4GMCQ
         cK41dlK5iza2NjqaXYJdzaZF+4RC4cuRBj5niurqNwUzVObq5U5I/+vzoOfB3CQrhpRN
         wxxzfK0uPCDElA+DvyWgiG6if0PRcHXMNjAk5OM9r5dXGChZii1E+iTEH5ajoQkyNRsz
         2I4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=EFZUsCCpYbGtRZQ5nf0ELVBxl95PGaXXfGM6bASnSFQ=;
        b=iAp/WHvjVFtHSVdEq/ybe/p7izUv38GGxk2Q4Me7OlMg1V0pqcIk8YWnPrlnMPLWr9
         6ZvDCV3GzhKcmRcQtJyTjt0wGMtKMtDeQSbLvye4YkoB4G92sR8eqZ88ulTTY5ontmfi
         GqmIWrLmEWOEnCql/ickP/iMYq6T13IVLbMT5iJbl1OhGlm2iJ/oqaTyO0eBJSiwA4sP
         fKd7MsdF/38vn+K944R6pOBhYqw/tJHdz4ldiJ5EnV8AWlKuGsj6FM7hVtxsJXMqQHX+
         KGuoZg5uSEUzTKwVGFNcK3XrXXzxWRtyCsou2TJMFcvgA7UUlaygzKRZ4IFxoM6fBDrF
         pAEQ==
X-Gm-Message-State: APjAAAVbKTUPtIgZb879NbC0wvJTSgkIdVsVHAuvMPlw3SIuSG/68Nv+
        aqAmn3FL2cn/QE71/+yjUiGvi7zk
X-Google-Smtp-Source: APXvYqz11oPCwfuy7HXvgaO0+HRgva2hFhmbMsm2TQs52tyF6Lboc8h1zFy1dbIBTeF5oECMwsdsZA==
X-Received: by 2002:a1c:1c4:: with SMTP id 187mr3321458wmb.77.1580197373794;
        Mon, 27 Jan 2020 23:42:53 -0800 (PST)
Received: from [192.168.43.36] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id n28sm25138113wra.48.2020.01.27.23.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 23:42:53 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580169415.git.asml.silence@gmail.com>
 <cover.1580170474.git.asml.silence@gmail.com>
 <2b1e23c3-71a3-2d5c-05c5-4aa393aee19b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 0/2] io-wq sharing
Message-ID: <c76577ea-4d55-a3ce-66b7-02c1cb05c2da@gmail.com>
Date:   Tue, 28 Jan 2020 10:41:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <2b1e23c3-71a3-2d5c-05c5-4aa393aee19b@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="esgNFRx76p9vSFYUL8xgJmquo8AeiHgpJ"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--esgNFRx76p9vSFYUL8xgJmquo8AeiHgpJ
Content-Type: multipart/mixed; boundary="BXJxk4gQksxknHC0BXEdp9dNJ5CLqKI5w";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <c76577ea-4d55-a3ce-66b7-02c1cb05c2da@gmail.com>
Subject: Re: [PATCH v2 0/2] io-wq sharing
References: <cover.1580169415.git.asml.silence@gmail.com>
 <cover.1580170474.git.asml.silence@gmail.com>
 <2b1e23c3-71a3-2d5c-05c5-4aa393aee19b@kernel.dk>
In-Reply-To: <2b1e23c3-71a3-2d5c-05c5-4aa393aee19b@kernel.dk>

--BXJxk4gQksxknHC0BXEdp9dNJ5CLqKI5w
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28/01/2020 03:29, Jens Axboe wrote:
> On 1/27/20 5:15 PM, Pavel Begunkov wrote:
>> rip-off of Jens io-wq sharing patches allowing multiple io_uring
>> instances to be bound to a single io-wq. The differences are:
>> - io-wq, which we would like to be shared, is passed as io_uring fd
>> - fail, if can't share. IMHO, it's always better to fail fast and loud=

>>
>> I didn't tested it after rebasing, but hopefully won't be a problem.
>>
>> p.s. on top of ("io_uring/io-wq: don't use static creds/mm assignments=
")
>=20
> Applied with the following changes:
>=20
> - Return -EINVAL for invalid ringfd when attach is specified
> - Remove the wq_fd check for attach not specified

The check was there to be able to reuse the wq_fd field, if the flag isn'=
t
specified.

>=20
> Tested here, works for me. Pushing out the updated test case.
>=20
Thanks!

--=20
Pavel Begunkov


--BXJxk4gQksxknHC0BXEdp9dNJ5CLqKI5w--

--esgNFRx76p9vSFYUL8xgJmquo8AeiHgpJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4v5bAACgkQWt5b1Glr
+6XSzA/+NQjoakNOOLS+Q9dsxrKgaiMS41RSZItTWmdeGjZ3qOz8gOMenyDit4h7
IANzmPZiGGDYPzIldmww7/pbg+2m2Ps6VwoMrm8yK50W2Nz2jKTINimWF7vyzguW
zoCcFUKWYwQh7PUPc2Tynvs3kg1eRTFEFb7/0qwYxWEJyrSCPTA8WL4oFouhIXkI
BuIbSAHjxaeM3k8DpaxrGYRR3gKi47xLWDMEuK/MRCnpALVlfeOxQyE7WycCGuvT
qYFlL745MRtZ9cmRLVC5u8UQhh6oyiLQVblU8Qm76qQRZ+gF/FVIYzHnmAAbvS5W
Zr0//GQBremZ9+ZLJzwg6kdP3vXf1Psjk8Evf3HHBciUDt2BO2r7vmcZXgQcrsyT
LjZCWLwALH86YSWR9vX9rVAx6cmotPtTAvtt18W5qmmpcjX6m8BgnoUvOZ2KG5PX
nuYXN3nCz5XWZ6KyY4NQOh658czbuXSPgn5CfP6oR8Y6e4Uj9DeoNYf0qzloe6W7
47+Sq/UCtr+7YoL7kuumjrqBh4vu1a9jszOJp4fyvIG46uo1RIVtWK5OoFdp/Xh7
PFIyskFmsgkjhZc+TulHuk/nk9GjRoSgUbf77S3Afg+brLmUSNYmHMSEkhH5O3Iv
xjMycV8LGP2QT7tlQ2enaFH3hudWm+mTZhtl+oo6QX4a2bPhqWs=
=Wf+P
-----END PGP SIGNATURE-----

--esgNFRx76p9vSFYUL8xgJmquo8AeiHgpJ--
