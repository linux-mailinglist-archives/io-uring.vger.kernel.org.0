Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CCD73807D
	for <lists+io-uring@lfdr.de>; Wed, 21 Jun 2023 13:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjFUKJC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 06:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbjFUKIs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 06:08:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6872C26AD
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 03:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687341893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QMlBAyzwRUFWKr4jcHorq7GnryXOXAlBCyYm2+bxgWQ=;
        b=MKLxKBV6ks9hcnBKJ7h3uwAH4bMTmADUowDhXd4i5tyKtqlv8s3MluE+PUhxLMnr9YhH3o
        GdBGWp75f4yAWND+kLjyRac87NrhtgjiFSsmgNkolE8UYyWs/ZO2tFZLJwgm+b3Zck/WrZ
        /nKpMf9ylS9ZTa2VC8eKzbZEyHQIgRs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-M1kGpoOONdSm9RoskYdZDQ-1; Wed, 21 Jun 2023 06:04:49 -0400
X-MC-Unique: M1kGpoOONdSm9RoskYdZDQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B463185A78B;
        Wed, 21 Jun 2023 10:04:49 +0000 (UTC)
Received: from localhost (unknown [10.39.195.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9CA31131F;
        Wed, 21 Jun 2023 10:04:48 +0000 (UTC)
Date:   Wed, 21 Jun 2023 12:04:47 +0200
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring@vger.kernel.org,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Guillem Jover <guillem@hadrons.org>
Subject: Re: False positives in nolibc check
Message-ID: <20230621100447.GD2667602@fedora>
References: <20230620133152.GA2615339@fedora>
 <ZJHKdAf2tPe+6BS6@biznet-home.integral.gnuweeb.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JwPv0aUHyCO8658c"
Content-Disposition: inline
In-Reply-To: <ZJHKdAf2tPe+6BS6@biznet-home.integral.gnuweeb.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--JwPv0aUHyCO8658c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 20, 2023 at 10:49:08PM +0700, Ammar Faizi wrote:
> On Tue, Jun 20, 2023 at 03:31:52PM +0200, Stefan Hajnoczi wrote:
> > This is caused by the stack protector compiler options, which depend on
> > the libc __stack_chk_fail_local symbol.
>=20
> Guillem fixed it last week. Does this commit fix the stack protector
> problem? https://github.com/axboe/liburing/commit/319f4be8bd049055c333185=
928758d0fb445fc43
>=20
> > In general, I'm concerned that nolibc is fragile because the toolchain
> > and libc sometimes have dependencies that are activated by certain
> > compiler options. Some users will want libc and others will not. Maybe
> > make it an explicit option instead of probing?
>=20
> I made nolibc always enabled because I don't see the need of using libc
> in liburing. If we have a real reason of using libc, maybe adding
> '--use-libc' is better than bringing back '--nolibc'.=20
>=20
> I agree with what Alviro said that using stack protector in liburing is
> too overkill. That's why I see no reason for the upstream to support it.
>=20
> Can you mention other dependencies that do need libc? That information
> would be useful to consider bringing back libc to liburing.

I don't know which features require the toolchain and libc to cooperate.
I guess Thread Local Storage won't work and helper functions that
compilers emit (like the memset example that Alviro gave).

Disabling hardening because it requires work to support it in a nolibc
world seems dubious to me. I don't think it's a good idea for io_uring
to lower security because that hurts its image and reduces adoption.
Especially right now, when the security of io_uring is being scrutinized
(https://security.googleblog.com/2023/06/learnings-from-kctf-vrps-42-linux.=
html).

While I'm sharing these opinions with you, I understand that some people
want nolibc and are fine with disabling the stack protector. The main
thing I would like is for liburing to compile or fail with a clear error
message instead of breaking somewhere during the build.

Stefan

--JwPv0aUHyCO8658c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmSSyz4ACgkQnKSrs4Gr
c8g8nAf/XeC88xFL72SZ680EFdeKZYQU6u2+5BeN0IwiatrBTXS4Q988V1J4kGmW
bsn0vP13oBGsQFmsSU2RAW0IB2rSTfkYsu4sBGkUhQdA+GsXHjCaxcHtIOnADMxm
hFPvL0g4EgSmsKaF8nhP65I99mD3K4cJ/nxqtzh+KrqqaQDbMtFNBfXg1V2KQwg2
P86zTgza1xQpUTq2pvifC5At9X32u68PHolozund4hLGNyoquLrXWj/aSzHdfPr1
ANJLC/0RG2GsZe2lRqF+DYJmoeQdUE6sDMfZt7ux5lJ3OFd9k+XVaG75lYgDPMjY
cw3IehIWZ7iOTArbqAHOpwsGLUnqxg==
=xZNV
-----END PGP SIGNATURE-----

--JwPv0aUHyCO8658c--

