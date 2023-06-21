Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA41738181
	for <lists+io-uring@lfdr.de>; Wed, 21 Jun 2023 13:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjFUJsP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 05:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjFUJsP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 05:48:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C26E9B
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 02:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687340845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BdEtDnx5DIh6xvK38+OajhNuKiIdOO3lb1K+osjftnU=;
        b=VgfTlcZ0XIxM7s+Diib2CNqDmhHdEAxJpthakKwrBpdRNvrTe/qpdA8MDpX43GSfWwmGvw
        uj01UwyNXY81E1wx2Ggu83xgYzZmfwcMeA1Ny2IIn/YH0Cs+cdOnl30z2NGmx147l6pAJn
        6ZMIp0xyIUHOXDz0MwEq8RQVWGzs0QY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-nAyrFvc0PpGdilbZzmq8aQ-1; Wed, 21 Jun 2023 05:47:23 -0400
X-MC-Unique: nAyrFvc0PpGdilbZzmq8aQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B5CC104458C;
        Wed, 21 Jun 2023 09:47:23 +0000 (UTC)
Received: from localhost (unknown [10.39.195.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A15C4422B0;
        Wed, 21 Jun 2023 09:47:21 +0000 (UTC)
Date:   Wed, 21 Jun 2023 11:47:19 +0200
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc:     io-uring@vger.kernel.org,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: False positives in nolibc check
Message-ID: <20230621094719.GC2667602@fedora>
References: <20230620133152.GA2615339@fedora>
 <CAOG64qNrFTnY74g-hTUbOFBhsmxf6ojUiYP_heD-iXm0-VKMkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qRjPleEA/ILrXQHJ"
Content-Disposition: inline
In-Reply-To: <CAOG64qNrFTnY74g-hTUbOFBhsmxf6ojUiYP_heD-iXm0-VKMkQ@mail.gmail.com>
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


--qRjPleEA/ILrXQHJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 20, 2023 at 09:39:46PM +0700, Alviro Iskandar Setiawan wrote:
> Hello Stefan,
>=20
> On Tue, Jun 20, 2023 at 8:32=E2=80=AFPM Stefan Hajnoczi wrote:
> > This is caused by the stack protector compiler options, which depend on
> > the libc __stack_chk_fail_local symbol.
>=20
> liburing itself explicitly disables the stack protector, even when
> compiled with libc. You customize the build and use something that
> needs libc (stack protector). So I would say liburing upstream has
> taken care of this problem in the normal build.

Do you mean this:

src/Makefile:CFLAGS ?=3D -g -O3 -Wall -Wextra -fno-stack-protector

?

CFLAGS is set in the rpmbuild environment and therefore the ?=3D operator
has no effect. Here is the build log:
https://kojipkgs.fedoraproject.org//packages/liburing/2.4/2.fc38/data/logs/=
i686/build.log

If -fno-stack-protector is required, then the build system should fail
and let the user know that an unsupported flag was detected instead of
silently allowing an unsupported flag.

>=20
> > The compile_prog check in ./configure should use the final
> > CFLAGS/LDFLAGS (including -ffreestanding) that liburing is compiled with
> > to avoid false positives. That way it can detect that nolibc won't work
> > with these compiler options and fall back to using libc.
> >
> > In general, I'm concerned that nolibc is fragile because the toolchain
> > and libc sometimes have dependencies that are activated by certain
> > compiler options. Some users will want libc and others will not. Maybe
> > make it an explicit option instead of probing?
>=20
> I'm not sure it's worth using libc in liburing (x86(-64) and aarch64)
> just to activate the stack protector. Do you have other convincing use
> cases where libc is strictly needed on architectures that support
> liburing nolibc?

libc isn't strictly needed for stack protector. liburing could go
further down the path of duplicating libc symbols and implement
__stack_chk_fail_local itself.

However, I don't understand the reason for nolibc in the first place. Is
it because liburing is used by non-C languages where libc conflicts with
their runtime environment/library? I'm surprised by that since
FFI-friendly languages should be used to the presence of libc. Also, I'm
not sure why liburing.so should be nolibc for this use case, since there
is liburing-ffi.so specifically for FFI users.

> I think using stack protector for liburing is just too overkill, but I
> may be wrong, please tell me a good reason for using it in liburing.

I think that should be left up to packagers. Some distributions may want
to compile with a standard set of hardening options. I'm not sure what
the justification for making an exception for liburing should be?
Security folks won't be happy :).

> I admit that nolibc brings problems. For example, the memset() issue
> on aarch64 recently (it's fixed). If you have similar problems, please
> tell. We probably should consider bringing back the "--nolibc" option
> in the "./configure" file?

I don't have a strong opinion on the solution here, just that liburing
should compile successfully.

Thanks,
Stefan

--qRjPleEA/ILrXQHJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmSSxycACgkQnKSrs4Gr
c8gk9gf/bEt3fqt93Gbs0yVFpQKV8LWuDSP4dOzPeWLi1I9mGU7vk6zNA9wohEBu
6A6LPDCzb1jRg+0MAyCxUVNKGTBJpwvGjtNjlJLYV6Mfj750WC797bYvEAJsOJh1
GpE+IYPmz3VyoQy1O2xyT5EEi+NVdxi/PxNl08Vrdu5hxvBAzc04YjAIjAU0Obcl
Q5E7xxuywbX8BuQI30ARLfD7uU9ynPBg6MUY5Yfl6ADJpqcYUxdz6tdP7wSh3CQE
/LwXjJOJZGYiwUyooroM/4tWiGKKyRMX26MdT6CwCVIgMXLQ1VhFWK/WJtMB1hHM
Gyu7HFFxmmGmVj61ACJPxUXfjcGg5A==
=0fY+
-----END PGP SIGNATURE-----

--qRjPleEA/ILrXQHJ--

