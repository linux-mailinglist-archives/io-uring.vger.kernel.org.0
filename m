Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED77B45449C
	for <lists+io-uring@lfdr.de>; Wed, 17 Nov 2021 11:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhKQKHr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 05:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbhKQKHr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Nov 2021 05:07:47 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCD8C061570
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 02:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=EdyXouwmxjeeFchfDRRByZqNj1TLue6zCdIyURzxvD4=; b=G1HFQIIyHwe8Gx0tpp4SiLAwl4
        6hIEy0FehpnAw4xr2ssLvUIVT1h1QuKJaGmpVwKfbv3dvGODSVHt48zzIh9dzOhthcLkzIFR4/Q5V
        OrwYoyot7vWABgjKV7Pzt51athKk1JLpA5olzf+gB3vXO70VMeC4amNWPHkp9v/u95ehnxZ0JcA+D
        WP/hQbE8DHbxu7CtHETPkFzLutKh8QXdPElwur12C1OBH7qfpkRAaFSmLm1X7bbfNueAfZX0x3Ftf
        9qE/CMKRQDMM7sz7ht+Ju86+VK5qkNL8ZC8Hd+oG0L+rzc2Zvemjbofa+uFVgWKX9OYhWvS9045WZ
        jD2seCk2FxcsjU0tq6k38UFbzRuPLRykipySu3s3bECCXfBuYRVVMPDSjxrEZwS0C3RvSSpEEfdcn
        Pa5EcS/9K4BpVFcAMV0g3TziC12oNfMAzYn9e8DFDjxcBQIF5Jv44mGU97J28vxRmM93v0/iQHfu0
        hLJrRWAYB2vENVhBh+2YTP2n;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mnHo6-007XC5-T5; Wed, 17 Nov 2021 10:04:46 +0000
To:     Eric Wong <e@80x24.org>, io-uring@vger.kernel.org
Cc:     Liu Changcheng <changcheng.liu@aliyun.com>
References: <20211116224456.244746-1-e@80x24.org>
 <20211116224456.244746-4-e@80x24.org>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 3/4] debian/rules: fix for newer debhelper
Message-ID: <fadf956d-bbbc-0b3a-653d-9e0e979cce80@samba.org>
Date:   Wed, 17 Nov 2021 11:04:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211116224456.244746-4-e@80x24.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qgWW9LPuNUQaykjy6nRu4SqC2w2jDAkhx"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qgWW9LPuNUQaykjy6nRu4SqC2w2jDAkhx
Content-Type: multipart/mixed; boundary="SOGZeMRePanSB70zVIUIxMs7yS08UE0gE";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Eric Wong <e@80x24.org>, io-uring@vger.kernel.org
Cc: Liu Changcheng <changcheng.liu@aliyun.com>
Message-ID: <fadf956d-bbbc-0b3a-653d-9e0e979cce80@samba.org>
Subject: Re: [PATCH 3/4] debian/rules: fix for newer debhelper
References: <20211116224456.244746-1-e@80x24.org>
 <20211116224456.244746-4-e@80x24.org>
In-Reply-To: <20211116224456.244746-4-e@80x24.org>

--SOGZeMRePanSB70zVIUIxMs7yS08UE0gE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Eric,

> When testing on my Debian 11.x (stable) system, --add-udeb
> causes the following build error:
>=20
>   dh_makeshlibs: error: The udeb liburing1-udeb does not contain any sh=
ared librar
>   ies but --add-udeb=3Dliburing1-udeb was passed!?
>   make: *** [debian/rules:82: binary-arch] Error 255
>=20
> Reading the current dh_makeshlibs(1) manpage reveals --add-udeb
> is nowadays implicit as of debhelper 12.3 and no longer
> necessary.  Compatibility with Debian oldstable (buster) remains
> intact.  Tested with debhelper 12.1.1 on Debian 10.x (buster)
> and debhelper 13.3.4 on Debian 11.x (bullseye).
>=20
> Signed-off-by: Eric Wong <e@80x24.org>
> ---
>  debian/rules | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/debian/rules b/debian/rules
> index 1a334b3..2a0d563 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -70,7 +70,14 @@ binary-arch: install-arch
>  	dh_strip -a --ddeb-migration=3D'$(libdbg) (<< 0.3)'
>  	dh_compress -a
>  	dh_fixperms -a
> -	dh_makeshlibs -a --add-udeb '$(libudeb)'
> +
> +# --add-udeb is needed for <=3D 12.3, and breaks with auto-detection
> +#  on debhelper 13.3.4, at least
> +	if perl -MDebian::Debhelper::Dh_Version -e \
> +	'exit(eval("v$$Debian::Debhelper::Dh_Version::version") le v12.3)'; \=

> +		then dh_makeshlibs -a; else \
> +		dh_makeshlibs -a --add-udeb '$(libudeb)'; fi
> +

I think this needs to be 'ge v12.3)' instead of 'le v12.3)'
otherwise I still get the above error on ubuntu 20.04.

metze


--SOGZeMRePanSB70zVIUIxMs7yS08UE0gE--

--qgWW9LPuNUQaykjy6nRu4SqC2w2jDAkhx
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQT7piwqO01BwrlU3LLHuFQ7rrL7egUCYZTTswAKCRDHuFQ7rrL7
eovGAP46y86oLc3QpVgDYgx69m45ohFmekziIpEUM6ub3CNFAwEApeWhVsj+IYUb
FPVux0vhl1fnWpYVrSZzOToRWwwPhQ0=
=MPHX
-----END PGP SIGNATURE-----

--qgWW9LPuNUQaykjy6nRu4SqC2w2jDAkhx--
