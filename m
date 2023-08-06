Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5397713C9
	for <lists+io-uring@lfdr.de>; Sun,  6 Aug 2023 08:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjHFGm6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Aug 2023 02:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjHFGm5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Aug 2023 02:42:57 -0400
X-Greylist: delayed 28440 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 05 Aug 2023 23:42:55 PDT
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6091FD4;
        Sat,  5 Aug 2023 23:42:55 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4RJVJC40Wmz9sd7;
        Sun,  6 Aug 2023 08:42:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyphar.com; s=MBO0001;
        t=1691304171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TKUhKDbUC2/JSkRExIBVVYTgnPGLNw5xhGLizhZFaHo=;
        b=0nHhRGGKpevO0jS9yjWDUb1TZ5f6D4nVFvWmJdx6fQ1GxYReNPVZzuSzFZOlXqxQgPy5xU
        gDHuynxSoFBJ1fZl/lzJdVvwLSE33BtTsC/e1J9N3zVk2gkALsL0ZZM/ZTytvry27UYdBi
        4pKzRWBPIBWu4GvJ5bKSpdYliUFrAlbPP16bbiNXj04qjo4b+N76EecgznCYkVWPZz6HdT
        V9XJke6raTUWhnoK3E8QuxrgfztQF2A5fvkQxOU/5Gx385NoF6/rwZT8OnP3I67Fwk6kaT
        531fC1WASz3rSgkjRJbDnnfMNrORpEiI5VI6iLFJOMDkQNqAuNqUsZ1M/9+1OQ==
Date:   Sun, 6 Aug 2023 16:42:37 +1000
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] io_uring: correct check for O_TMPFILE
Message-ID: <20230806.063800-dusky.orc.woody.spectrum-98W6qtUkFLgk@cyphar.com>
References: <20230806-resolve_cached-o_tmpfile-v2-0-058bff24fb16@cyphar.com>
 <20230806-resolve_cached-o_tmpfile-v2-2-058bff24fb16@cyphar.com>
 <41b5f092-5422-e461-b9bf-3a5a04c0b9e2@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hguio7qt6czmuq3q"
Content-Disposition: inline
In-Reply-To: <41b5f092-5422-e461-b9bf-3a5a04c0b9e2@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--hguio7qt6czmuq3q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-08-05, Jens Axboe <axboe@kernel.dk> wrote:
> On 8/5/23 4:48?PM, Aleksa Sarai wrote:
> > O_TMPFILE is actually __O_TMPFILE|O_DIRECTORY. This means that the old
> > check for whether RESOLVE_CACHED can be used would incorrectly think
> > that O_DIRECTORY could not be used with RESOLVE_CACHED.
> >=20
> > Cc: stable@vger.kernel.org # v5.12+
> > Fixes: 3a81fd02045c ("io_uring: enable LOOKUP_CACHED path resolution fo=
r filename lookups")
> > Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> > ---
> >  io_uring/openclose.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/io_uring/openclose.c b/io_uring/openclose.c
> > index 10ca57f5bd24..a029c230119f 100644
> > --- a/io_uring/openclose.c
> > +++ b/io_uring/openclose.c
> > @@ -35,9 +35,9 @@ static bool io_openat_force_async(struct io_open *ope=
n)
> >  {
> >  	/*
> >  	 * Don't bother trying for O_TRUNC, O_CREAT, or O_TMPFILE open,
> > -	 * it'll always -EAGAIN
> > +	 * it'll always -EAGAIN.
>=20
> Please don't make this change, it just detracts from the actual change.
> And if we are making changes in there, why not change O_TMPFILE as well
> since this is what the change is about?

Userspace can't pass just __O_TMPFILE, so to me "__O_TMPFILE open"
sounds strange. The intention is to detect open(O_TMPFILE), it just so
happens that the correct check is __O_TMPFILE.

But I can change it if you prefer.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--hguio7qt6czmuq3q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQS2TklVsp+j1GPyqQYol/rSt+lEbwUCZM9A3QAKCRAol/rSt+lE
b6q1AQCfpbiZQ3YBX5RjN7wlBlTKoVIIWmi3jbLZIfwsLpbALQEAxjj7JrE5m2QB
Ef3B/oTCkUaU5I9BTzF90EexiV0qAww=
=mPYA
-----END PGP SIGNATURE-----

--hguio7qt6czmuq3q--
