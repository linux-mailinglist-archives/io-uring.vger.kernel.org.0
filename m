Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9234421C368
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2020 11:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgGKJyU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jul 2020 05:54:20 -0400
Received: from mtel-bg02.venev.name ([77.70.28.44]:50352 "EHLO
        mtel-bg02.venev.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728089AbgGKJyT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jul 2020 05:54:19 -0400
X-Greylist: delayed 973 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Jul 2020 05:54:18 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=venev.name;
         s=default; h=MIME-Version:Content-Type:References:In-Reply-To:Date:Cc:To:
        From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4q/11Z01xoA0C0fUejsQRDef/DQBe0B/WV0Vr547Z/w=; b=nBSu2R6L5VR24rKqgxKgvG5Ssx
        H7+SKxtN2jGePgW2dg4MZNBDX9KZ9K2H1KxZK0+pl9+OL8+vgicnO8amokm/ZIEnQgTzdaUTClynS
        c23GkkTKdt0rklNrTDdlTuKEo5WDYOBvJ35u3bt7Y9J/1cbcJpHVhr4oRgtqomqm3PAEotDfI0Wee
        O++dOl50dj9EAbZNUPD9AzdO2vp3guJxygHtTY9rNH8rhy+sV3u2ovwjHrtIMHGXlx6l4hPRnKLeW
        1KpFhOcnZB7jv3JBfVAEgsk68CL/nhdXTsM+8+4CGbgCXtif/ndNUT7JGCM303Z72gs/Pd+0B3q57
        bazsSb004HtfiAqKPiKRYb40rP5Axk0WytTASrWgkt3ryoQomm6Y47E8eAQGEzo1CvE/00ChzmRu6
        KH21BnuEs7OYfYBjsv+ZBVm1a3EEJuDES3wFlR77fW94CTLqdxY1bo5xyCbFsCMaBqKVbPsWcZwT/
        StFJlXH8OyvFaDPuFJcfCpaHOO85Pu+TBHh/8qAjnKNitgtbnI7UcqsEaUO7R0M/s9gR5c0VEFGr9
        YdHaScPBz+DTlxgsgANDzTC0S+LoAPAMdJuxicg5iuH+61M8eU6LZJWRBZs8QhcF5kdm2PBXvRnHS
        sQVBswvBQCKgSoqdgHIxJ2DltgGrQkowwCG2O0y6A=;
X-Check-Malware: ok
Received: from mtel-bg02.venev.name
        by mtel-bg02.venev.name with esmtpsa
        (TLS1.3:TLS_AES_256_GCM_SHA384:256)
        (envelope-from <hristo@venev.name>)
        id 1juBxG-000TqS-64; Sat, 11 Jul 2020 09:37:58 +0000
Message-ID: <dfeb313f261cea8652b0a12144ff4259ecfbd322.camel@venev.name>
Subject: Re: [PATCH] io_uring: fix sq array offset calculation
From:   Hristo Venev <hristo@venev.name>
To:     Dmitry Vyukov <dvyukov@google.com>, axboe@kernel.dk
Cc:     necip@google.com, io-uring@vger.kernel.org
Date:   Sat, 11 Jul 2020 12:37:56 +0300
In-Reply-To: <20200711093111.2490946-1-dvyukov@google.com>
References: <20200711093111.2490946-1-dvyukov@google.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-mAOXD5uiHPHsoReFQ9GY"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--=-mAOXD5uiHPHsoReFQ9GY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2020-07-11 at 11:31 +0200, Dmitry Vyukov wrote:
> rings_size() sets sq_offset to the total size of the rings
> (the returned value which is used for memory allocation).
> This is wrong: sq array should be located within the rings,
> not after them. Set sq_offset to where it should be.
>=20
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: io-uring@vger.kernel.org
> Cc: Hristo Venev <hristo@venev.name>
> Fixes: 75b28affdd6a ("io_uring: allocate the two rings together")

Oops.

Acked-by: Hristo Venev <hristo@venev.name>

>=20
> ---
> This looks so wrong and yet io_uring works.
> So I am either missing something very obvious here,
> or io_uring worked only due to lucky side-effects
> of rounding size to power-of-2 number of pages
> (which gave it enough slack at the end),
> maybe reading/writing some unrelated memory
> with some sizes.
> If I am wrong, please poke my nose into what I am not seeing.
> Otherwise, we probably need to CC stable as well.
> ---
>  fs/io_uring.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ca8abde48b6c7..c4c3731ed41e9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7063,6 +7063,9 @@ static unsigned long rings_size(unsigned
> sq_entries, unsigned cq_entries,
>  		return SIZE_MAX;
>  #endif
> =20
> +	if (sq_offset)
> +		*sq_offset =3D off;
> +
>  	sq_array_size =3D array_size(sizeof(u32), sq_entries);
>  	if (sq_array_size =3D=3D SIZE_MAX)
>  		return SIZE_MAX;
> @@ -7070,9 +7073,6 @@ static unsigned long rings_size(unsigned
> sq_entries, unsigned cq_entries,
>  	if (check_add_overflow(off, sq_array_size, &off))
>  		return SIZE_MAX;
> =20
> -	if (sq_offset)
> -		*sq_offset =3D off;
> -
>  	return off;
>  }
> =20

--=-mAOXD5uiHPHsoReFQ9GY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJGBAABCgAwFiEEWGQszEdDPeR3PQQhxqlBR4WW3HoFAl8JiHQSHGhyaXN0b0B2
ZW5ldi5uYW1lAAoJEMapQUeFltx69d8P/3GFoULc395m+1nVSzw4SZzhX4skNpEU
J/8bz1ntA8bsJQ8jEbjQpjcIftUPzzWOoAeNGE57n3VVGpDSFxBwX1aaazcMhEAa
jXyuWbtcXec/FCGWHHucF2Ade8gwhtUFME4JYUg/a1efcpIEySHgN9Ivy51Fnc9F
uH2bOLH7CWRn/iJWEeOWRs0eLydxogCsH2NERkhzrWRCvgqeokSzxDtB4WEbxru/
2AZ5MQU0egsSIdTGDOxLjg2Mg6ZlkZnG+hnwGCcqnWxox30cxTM98fOKOsdVQgax
4PpooBJJZugIcurqtmb2MU0N8Ev4eXESF4Wea2iCGeu8RlpWz/PxBnEC6hbjKy65
8wWW39EMPgzre7pVUUba8Cen0fl/yj4UbPRuK8iJ3/McegArzJXcrJCa26vzv4xH
k4MVZoePQF6Z7qpfYTPy+BFZzSEupEdIMZt67lkbrJ7WcnXFi560zEHum5Qeu8xK
WMjtpoxd4v95/q8fxxAcYK6ej3keGumpQiWOkNsGYYOL3TzDc+L+rnNgOaLVAJ8x
8GOgzUorPxirLvgFwK6BiqFdgMLU2nZ2rgxPVGHbfZs61Y76hw0iTLpMqibBMw0C
mFFjBl9w6i1IOAHO5IeGT0JtUyiUr/jB6IChvYBHuqW0Oaww87dP8GS/5ncsFjH6
WNkyzKxgozxD
=y4on
-----END PGP SIGNATURE-----

--=-mAOXD5uiHPHsoReFQ9GY--

