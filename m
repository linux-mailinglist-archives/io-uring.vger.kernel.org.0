Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567A375E41B
	for <lists+io-uring@lfdr.de>; Sun, 23 Jul 2023 20:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjGWSGj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Jul 2023 14:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjGWSGi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Jul 2023 14:06:38 -0400
Received: from vulcan.natalenko.name (vulcan.natalenko.name [104.207.131.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E39BE4E;
        Sun, 23 Jul 2023 11:06:35 -0700 (PDT)
Received: from spock.localnet (unknown [94.142.239.106])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id B39F1146A156;
        Sun, 23 Jul 2023 20:06:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1690135591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3/Q/y5BV8s5ndvdwgTPFAV48mdLYdi966EHVL5SMeGI=;
        b=Pv734e6/iyPncmGFhKp0bb4K4GsE9nFzNmu1Zua8pWm+5U43vGsYmnUwLaFUNIyWk0NUdS
        gwtAItr210eX8w/x2q504TDgN4bL9WhaHpwpU/DJMWM0tCDwU0kHiy1QRD1RfNZE+iIelB
        wV0dJ5KKNd1u0F5ktzk+YPQJE+xEFaI=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        Genes Lists <lists@sapience.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Freund <andres@anarazel.de>
Subject: Re: [PATCH 6.4 800/800] io_uring: Use io_schedule* in cqring wait
Date:   Sun, 23 Jul 2023 20:06:19 +0200
Message-ID: <2691683.mvXUDI8C0e@natalenko.name>
In-Reply-To: <70e5349a-87af-a2ea-f871-95270f57c6e3@sapience.com>
References: <20230716194949.099592437@linuxfoundation.org>
 <538065ee-4130-6a00-dcc8-f69fbc7d7ba0@kernel.dk>
 <70e5349a-87af-a2ea-f871-95270f57c6e3@sapience.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart12252023.O9o76ZdvQC";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--nextPart12252023.O9o76ZdvQC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Oleksandr Natalenko <oleksandr@natalenko.name>
Date: Sun, 23 Jul 2023 20:06:19 +0200
Message-ID: <2691683.mvXUDI8C0e@natalenko.name>
In-Reply-To: <70e5349a-87af-a2ea-f871-95270f57c6e3@sapience.com>
MIME-Version: 1.0

Hello.

On ned=C4=9Ble 23. =C4=8Dervence 2023 19:43:50 CEST Genes Lists wrote:
> On 7/23/23 11:31, Jens Axboe wrote:
> ...
> > Just read the first one, but this is very much expected. It's now just
> > correctly reflecting that one thread is waiting on IO. IO wait being
> > 100% doesn't mean that one core is running 100% of the time, it just
> > means it's WAITING on IO 100% of the time.
> >=20
>=20
> Seems reasonable thank you.
>=20
> Question - do you expect the iowait to stay high for a freshly created=20
> mariadb doing nothing (as far as I can tell anyway) until process=20
> exited? Or Would you think it would drop in this case prior to the=20
> process exiting.
>=20
> For example I tried the following - is the output what you expect?
>=20
> Create a fresh mariab with no databases - monitor the core showing the=20
> iowaits with:
>=20
>     mpstat -P ALL 2 100
>=20
> # rm -f /var/lib/mysql/*
> # mariadb-install-db --user=3Dmysql --basedir=3D/usr --datadir=3D/var/lib=
/mysql
>=20
> # systemctl start mariadb      (iowaits -> 100%)=20
> =20
>=20
> # iotop -bo |grep maria        (shows no output, iowait stays 100%)
>=20
> (this persists until mariadb process exits)
> =20
>=20
> # systemctl stop mariadb       (iowait drops to 0%)=20

This is a visible userspace behaviour change with no changes in the userspa=
ce itself, so we cannot just ignore it. If for some reason this is how it s=
hould be now, how do we explain it to MariaDB devs to get this fixed?

Thanks.

=2D-=20
Oleksandr Natalenko (post-factum)
--nextPart12252023.O9o76ZdvQC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEZUOOw5ESFLHZZtOKil/iNcg8M0sFAmS9bBsACgkQil/iNcg8
M0um0g//ajPoGUR8cLcGZ2a+l4uWXZyDdD8YMAzNwnb02ovSl7doi1V1z5BA9Kx6
Q64wfedIE5FNPHfVRoORIx29zbOWFOw7qXu4AGi5IR01teIvTfZhYtXoEahhUL8S
hu+SCSqCR5mO6o99Nx+Zhen4dc41oOUKVEfPRv9w4CpZNN1ou+w7mMkaXM3S3pme
cTSoBDW6ftKyVIpV0z3vDQXw1+dqPVTZJ9KAYgqeIsxrTYHY3kEdgjy2wcxKXo6u
KHNyxc8jLfm2QQDBeX7iHTB3PH9H8+Ajes059DvBjqvG3Oe7tcxIKsRF6Q8mt/9F
gKAs3vpJ7r/ORB0aFcTTOjteuN51nl6dsGpOay3ltT86+BmqJQaHuUc7whILXKIa
qxzCZj7C+PaXQ7Q3agUAYWS6XNz4BYeqOkMFPpHYcESUpnVbJnNfs+1CuGWhelpy
OuGQ/RafxbThkmoSUdX8mFM+WMYdVyQDSDZhqqrhENMgd2VxY17FkbWipMwQw4oT
/yzQWGm4n+9YzWm8/bBLTo5A254ZuizIDIYsitSYPp1kd+wf+9NZkQ2+m3Z1b/mQ
nvp04Xs0XCgu8LxVe3Gfr+ri4axrIC1xkYrxdiPH/hroKdFpLuuh/yg4BG52OrSW
u/oFkF9FvwbMwcixWJy8mrGVcwyQzn1XtDOBxyNaKhgdJfoMVgc=
=bqKi
-----END PGP SIGNATURE-----

--nextPart12252023.O9o76ZdvQC--



