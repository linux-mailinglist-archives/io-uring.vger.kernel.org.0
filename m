Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C10A454493
	for <lists+io-uring@lfdr.de>; Wed, 17 Nov 2021 11:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbhKQKFU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 05:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236047AbhKQKFQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Nov 2021 05:05:16 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCCFC06120E
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 02:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=hjHKfANAW3do0izi5DuddFKEG9ZZWQ5UsWy37aNTejU=; b=vV/ZqJee1l154Jlu9nFS9REkdN
        02ZJ+A8Cv+0VieB85ppFars87/1qm9DpLPecHOJwsb49oDDrP7QAKpEulCHyO7tUr8YJmOz5YKplH
        lAiJ8kBBQPn8PkHgE/3WCK91GQJvyHQpkJD+5OffPnQ4ZCPFRDESZgwviOPxje50BR8cShMlOIT+d
        Hxv4zbxs9TTDpzwvGYpTFcTqU90ZNMnus+1C1mc4te/FM+WuASBoc6m93U+ugnESNswsSYXhEikb1
        3kB5I/lzEhD290ew50ieRY1UIpURa7irMF5Z7R0xFQ3UgKwQzDEYLFyZZcqlVxTEm7DdTKIuHOvVt
        9tjeNxMC7049kJ0ojSCuszyON2AdY/M1xEPHtxvLAbLAAaAQbBtHheHE6O82sUF9tW7DfeSBnLfzh
        VAa7Hw4TBC/cL25AEey6+yfGWpk+dmvbCnTM/phfEVPQbckoQiS905XKGITCoqEbY92IQh+Dagpaf
        Eq8GE1KRVx18pdPY9hhRWhLa;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mnHlX-007XB8-C4; Wed, 17 Nov 2021 10:02:07 +0000
To:     Eric Wong <e@80x24.org>, io-uring@vger.kernel.org
Cc:     Liu Changcheng <changcheng.liu@aliyun.com>
References: <20211116224456.244746-1-e@80x24.org>
 <20211116224456.244746-3-e@80x24.org>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 2/4] debian: avoid prompting package builder for signature
Message-ID: <8882014a-fab9-2afa-abd4-05f6941c2aa2@samba.org>
Date:   Wed, 17 Nov 2021 11:01:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211116224456.244746-3-e@80x24.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tImbC4uTb8jwV4KdNiOvJOJMUinPSq6yg"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tImbC4uTb8jwV4KdNiOvJOJMUinPSq6yg
Content-Type: multipart/mixed; boundary="TrwnWYmr2Ff5C1ChOdK5CgeaH3Z07VglR";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Eric Wong <e@80x24.org>, io-uring@vger.kernel.org
Cc: Liu Changcheng <changcheng.liu@aliyun.com>
Message-ID: <8882014a-fab9-2afa-abd4-05f6941c2aa2@samba.org>
Subject: Re: [PATCH 2/4] debian: avoid prompting package builder for signature
References: <20211116224456.244746-1-e@80x24.org>
 <20211116224456.244746-3-e@80x24.org>
In-Reply-To: <20211116224456.244746-3-e@80x24.org>

--TrwnWYmr2Ff5C1ChOdK5CgeaH3Z07VglR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Eric,

> diff --git a/make-debs.sh b/make-debs.sh
> index 136b79e..aea05f0 100755
> --- a/make-debs.sh
> +++ b/make-debs.sh
> @@ -20,7 +20,10 @@ set -o pipefail
> =20
>  # Create dir for build
>  base=3D${1:-/tmp/release}
> -codename=3D$(lsb_release -sc)
> +
> +# UNRELEASED here means debuild won't prompt for signing
> +codename=3DUNRELEASED
> +
>  releasedir=3D$base/$(lsb_release -si)/liburing
>  rm -rf $releasedir
>  mkdir -p $releasedir

You can use DEBUILD_DPKG_BUILDPACKAGE_OPTS=3D"--no-sign" in ~/.devscripts=


Or we could make it possible to pass arguments down to 'debuild',
e.g. '-us -uc'. I'm also fine with doing that by default.

metze



--TrwnWYmr2Ff5C1ChOdK5CgeaH3Z07VglR--

--tImbC4uTb8jwV4KdNiOvJOJMUinPSq6yg
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQT7piwqO01BwrlU3LLHuFQ7rrL7egUCYZTTFQAKCRDHuFQ7rrL7
eps7AQD6i9w/bEyDdRlp6OEyPGky/+C5W3eHYGuyJ6JyrnSv7wD+PNRTQ5rWcSMl
bI/QND57/WH5/tWPf+SXNHMMRkq3Pgw=
=drjd
-----END PGP SIGNATURE-----

--tImbC4uTb8jwV4KdNiOvJOJMUinPSq6yg--
