Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AD5750BA3
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 17:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbjGLPBh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 11:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbjGLPBg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 11:01:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6951BD5
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 08:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689174048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ZIW1KwvmIaxIuMhQXrJgeC1DduNF7JkhT3ti1B2t+w=;
        b=Ch7CoyFe7B+4cSdcdFqRkRqNg5ajhdj/E1U3d36rWJRAtP1dW3U/fgr4Zj6WXPHPdasc1k
        kyyLJw/pTpqxMgybaT04l/epRoEdxMWptD00bCCYOEigl1zD3z4hc8Yi/AaBj2/AT0jMyn
        wBEXv/JiAUZDlv/0dPtiK8isE139fUs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-oTZ0gMzAMY2ZXr5-9R4uVQ-1; Wed, 12 Jul 2023 11:00:44 -0400
X-MC-Unique: oTZ0gMzAMY2ZXr5-9R4uVQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1918A1064BF8;
        Wed, 12 Jul 2023 15:00:42 +0000 (UTC)
Received: from localhost (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21E2240C206F;
        Wed, 12 Jul 2023 15:00:40 +0000 (UTC)
Date:   Wed, 12 Jul 2023 11:00:39 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring@vger.kernel.org,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Guillem Jover <guillem@hadrons.org>
Subject: Re: False positives in nolibc check
Message-ID: <20230712150039.GA222963@fedora>
References: <20230620133152.GA2615339@fedora>
 <ZJHKdAf2tPe+6BS6@biznet-home.integral.gnuweeb.org>
 <20230621100447.GD2667602@fedora>
 <ZJLOpuoI5X5IGAdk@biznet-home.integral.gnuweeb.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="blgJMPHa9ceW7C0S"
Content-Disposition: inline
In-Reply-To: <ZJLOpuoI5X5IGAdk@biznet-home.integral.gnuweeb.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--blgJMPHa9ceW7C0S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 21, 2023 at 05:19:18PM +0700, Ammar Faizi wrote:
> On Wed, Jun 21, 2023 at 12:04:47PM +0200, Stefan Hajnoczi wrote:
> > I don't know which features require the toolchain and libc to cooperate.
> > I guess Thread Local Storage won't work and helper functions that
> > compilers emit (like the memset example that Alviro gave).
>=20
> Yeah, thread local storage won't work. But the point of my question is
> about liburing. So I expect the answer that's relevant to liburing.
>=20
> I mean, you can still use libc and TLS in your app even though the
> liburing.so and liburing.a are nolibc.
>=20
> > Disabling hardening because it requires work to support it in a nolibc
> > world seems dubious to me. I don't think it's a good idea for io_uring
> > to lower security because that hurts its image and reduces adoption.
> > Especially right now, when the security of io_uring is being scrutinized
> > (https://security.googleblog.com/2023/06/learnings-from-kctf-vrps-42-li=
nux.html).
> >=20
> > While I'm sharing these opinions with you, I understand that some people
> > want nolibc and are fine with disabling the stack protector. The main
> > thing I would like is for liburing to compile or fail with a clear error
> > message instead of breaking somewhere during the build.
>=20
> Right, my mistake. I think it's fixed in upstream by commit:
>=20
>    319f4be8bd049055c333185928758d0fb445fc43 ("build: Disable stack protec=
tor unconditionally")
>=20
> Please give it a whirl. I apologize for breaking the Fedora build.

No need to apologize! Thanks for taking a look.

I ran an rpmbuild with liburing.git/master and it succeeds now.

Stefan

--blgJMPHa9ceW7C0S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmSuwBcACgkQnKSrs4Gr
c8gF2Af/RmrbAcd0u3gFhgVT4alzfylxdT5QgLuCouF2IM8ZOftMrT2VnOmaYwWr
vnYLQw/hOEioSnARQqvFWQnlRbMbAe3NPwqa6mw6LQNV9hd3WeGHSrn1NK2oboWR
Y2G+ZhGm5nU3agsA2cgVXeQImXb87iv4b40DK+hphiy3nynr4naMaAMQ908Ayi2j
/ppHoyXZnoWpw2JxyxF1jlvVTBo0tyOIQP/yXiyllDCS03vt3CGrIhGKgrH30zdM
3bP0pK72h8yswwPGqzllWTszHxSewqdDFeDxlWCvnqKZf3Ew6jkFbHDBxmuq0Ok3
Cz7PrNtRP3cJNS7Ufz8T9mCOWhM/VA==
=LLKO
-----END PGP SIGNATURE-----

--blgJMPHa9ceW7C0S--

