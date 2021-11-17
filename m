Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F614544D4
	for <lists+io-uring@lfdr.de>; Wed, 17 Nov 2021 11:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbhKQKU5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 05:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbhKQKUz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Nov 2021 05:20:55 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32255C061570
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 02:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=mOSVZdIgQo9tZlTGmu72cTPogQTtTvGs0rWvLxZYmu0=; b=lOxxPy4H50tMoiZ59cJKrNoaAX
        xqFWG0ZKzGsiB0J9mpQifIee+Jl1dckjwPsp/2pMGxn0+HkYAQdm6VJtaeQ+JKD5WTlQfQiaPmvSA
        dtGjWC9fUW+CPyKesH/+x8pr6ejS5vFVvjhAvAawt/sV7V6lVvzXEzq+pvSDKs5WHrZtNzC2D7XN+
        Uwna2Lfg0cLQCi5P2h0ZZ1O24qPTdACVAprGV98q57ADycQLLK+bejd656WOQqUBNammZ8szBzxgl
        TBfXEyXm/lTcTxx208ZNQ/H4/1k56qm5ufaYSoG+/rHr2Wb2cD3nAQOxS0bpG23yoJ7oCKpQAKLfx
        /u3mlNGW4JpDanjk5AK7CFU4UJ/BsYnxEimcuJIQkMaVWSUpIkOGWCw7DET1FVNKKWT23n5uoAqOk
        V3NBO9PrjMP5mX+6cn4lqFsvlsTu3lFMwOvX4MQLpDPcRf/xqobSQdhp0x0LKYU/m1Fk9UWYdrqYy
        3HfUO7FcrUfU0L+EP5v5TU2+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mnI0o-007XL5-No; Wed, 17 Nov 2021 10:17:54 +0000
To:     Eric Wong <e@80x24.org>, io-uring@vger.kernel.org
Cc:     Liu Changcheng <changcheng.liu@aliyun.com>,
        Bikal Lem <gbikal+git@gmail.com>
References: <20211116224456.244746-1-e@80x24.org>
 <20211116224456.244746-2-e@80x24.org>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 1/4] make-debs: fix version detection
Message-ID: <0178c27e-4f22-ac44-1f9f-f2c8f5f176b5@samba.org>
Date:   Wed, 17 Nov 2021 11:17:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211116224456.244746-2-e@80x24.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EQfpFoVX770x5UdY5wo8ldQ8QPyXLIEC1"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EQfpFoVX770x5UdY5wo8ldQ8QPyXLIEC1
Content-Type: multipart/mixed; boundary="xXdc2dTolgMu1Sm5kCqjopcxaKcFLmwxo";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Eric Wong <e@80x24.org>, io-uring@vger.kernel.org
Cc: Liu Changcheng <changcheng.liu@aliyun.com>,
 Bikal Lem <gbikal+git@gmail.com>
Message-ID: <0178c27e-4f22-ac44-1f9f-f2c8f5f176b5@samba.org>
Subject: Re: [PATCH 1/4] make-debs: fix version detection
References: <20211116224456.244746-1-e@80x24.org>
 <20211116224456.244746-2-e@80x24.org>
In-Reply-To: <20211116224456.244746-2-e@80x24.org>

--xXdc2dTolgMu1Sm5kCqjopcxaKcFLmwxo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


Hi Eric,

a comment on versioning in general not really about your commit.

Is it still correct to have liburing1* in debian/control, shouldn't
it be liburing2 now?

Also shouldn't we get version=3D out of liburing.spec as that seems to co=
ntain the current
version number... instead of using git describe --match "lib*" | cut -d '=
-' -f 2

I also noticed that this
commit c0b43df28a982747e081343f23289357ab4615db
Author: Bikal Lem <gbikal+git@gmail.com>
Date:   Mon Nov 15 13:09:30 2021 +0000

    src/Makefile: use VERSION variable consistently

    src/Makefile defines incorrect 'liburing.so' version, i.e 2.1 as
    opposed to 2.2. This commit makes src/Makefile use correct version
    defined in liburing.spec. Along the way we refactor the use of common=

    variables into Makefile.common and include it into both src/Makefile
    and Makefile.

    Signed-off-by: Bikal Lem <gbikal+git@gmail.com>

changed the library soname from liburing.so.2 to just liburing.so, which =
seems wrong.

metze


--xXdc2dTolgMu1Sm5kCqjopcxaKcFLmwxo--

--EQfpFoVX770x5UdY5wo8ldQ8QPyXLIEC1
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQT7piwqO01BwrlU3LLHuFQ7rrL7egUCYZTWygAKCRDHuFQ7rrL7
et2xAP4vnqEXWstuTS7qvzR+bXRPH7q4deYb9WPw8yQCjcXy7QEAi4/VSFCVcheJ
T5R8sm1adKk3YTMyIkDlq/+WZyhRhQU=
=2MQ7
-----END PGP SIGNATURE-----

--EQfpFoVX770x5UdY5wo8ldQ8QPyXLIEC1--
