Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A2A62438D
	for <lists+io-uring@lfdr.de>; Thu, 10 Nov 2022 14:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiKJNsM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Nov 2022 08:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiKJNsK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Nov 2022 08:48:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DD565848
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 05:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668088032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wuf9noReeDTnEejiioybQ/q0wC+8BYRrkgoqDNlpdD0=;
        b=AMs+wfjvc6WLVtJULcUOJuOqzN6kuYl0CQiTgB9AB7TCNkVSJ/9mqbWkHRQZ9mpVG6bE+e
        8KVNp6q8MSiGKnYcpSRzSzByNsZT2kLaoqZDKghUCo92rlPyVnUkaEyJFEnhBCdqm1aBF7
        KueSnN4UoARV3nonzjJrUJqZyl6xnBE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-AEp9Y6V-Nnq58A-iQprDFQ-1; Thu, 10 Nov 2022 08:47:08 -0500
X-MC-Unique: AEp9Y6V-Nnq58A-iQprDFQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BF938027F5;
        Thu, 10 Nov 2022 13:47:08 +0000 (UTC)
Received: from localhost (unknown [10.39.192.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9536B40C6F73;
        Thu, 10 Nov 2022 13:46:54 +0000 (UTC)
Date:   Thu, 10 Nov 2022 08:46:52 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Dylan Yudaken <dylany@meta.com>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "dominik@thalhammer.it" <dominik@thalhammer.it>,
        "rjones@redhat.com" <rjones@redhat.com>
Subject: Re: liburing 2.3 API/ABI breakage
Message-ID: <Y20AzFN03U3+1rUi@fedora>
References: <Y2xaz5HwrGcbKJK8@fedora>
 <baf1f51132d42319a6a845ba391b21731ef80d6a.camel@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BOjdgTgdt3+JE/Ok"
Content-Disposition: inline
In-Reply-To: <baf1f51132d42319a6a845ba391b21731ef80d6a.camel@fb.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--BOjdgTgdt3+JE/Ok
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 10, 2022 at 09:43:48AM +0000, Dylan Yudaken wrote:
> On Wed, 2022-11-09 at 20:58 -0500, Stefan Hajnoczi wrote:
> > > 2. Going from size_t to unsigned int is ABI breakage. This is
> > > mitigated
> > > =A0=A0 on CPU architectures that share 32-bit/64-bit registers (i.e.
> > > rax/eax
> > > =A0=A0 on x86-64 and r0/x0/w0 on aarch64). There's no guarantee this
> > > works
> > > =A0=A0 on all architectures, especially when the calling convention
> > > passes
> > > =A0=A0 arguments on the stack.
> >=20
> > Good news, I realized that io_uring_prep_getxattr() and friends are
> > static inline functions. ABI breakage doesn't come into play because
> > they are compiled into the application.
>=20
> Additionally the inline code was doing the narrowing cast anyway, so
> there was no narrowing issues.
>=20
> I really should have put this explanation in the commit message though
> - will remember for next time.

Thanks, that will help!

Stefan

--BOjdgTgdt3+JE/Ok
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmNtAMwACgkQnKSrs4Gr
c8i5/ggAiwRcRUd933XAprxoOEf79Idt3fpiIKsSAKiy4OMv0nEyqYP/6fuGimNq
f/RR5LRDCTnFHVBfoYH30TZtfQjyzwtTzmHSaSmg0+WoT2UNJ0+gq439m/sYXDrd
6eJwgmAbfkawMEB+Je2sAkhTWjkFKabr5z/bsqBHUtRg2cHICzMYeHI3pf+JKS44
S1Cc/HTXIumkvDwVKyE/bQtmiqkD4OTvYy44MyJvZxYD4D/SzNgyCxsDUnHbXLkT
Cl9+uKsKjXxY11ImR59zEhdsviDCfJpYdh5JeE7x2CO/2CYGiZLhlt+gSZa/IBWf
aghZmDXgkdAcJKU2XmX3yicUmbiVBQ==
=e+sA
-----END PGP SIGNATURE-----

--BOjdgTgdt3+JE/Ok--

