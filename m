Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A71568077
	for <lists+io-uring@lfdr.de>; Wed,  6 Jul 2022 09:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiGFHvu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jul 2022 03:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiGFHvt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jul 2022 03:51:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B631E22BCA
        for <io-uring@vger.kernel.org>; Wed,  6 Jul 2022 00:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657093907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=94stvIwO+MYjvQTo4x9lvsmOFPV+/t99NLrADFi/T5M=;
        b=fM//aA608R8XMAm+6F+I1t5NnlEQdPfu4Hxca3E8+VzqfjpHLQ/ssijo64sL6xZ9pIQfr9
        7/Nvx8p4NSPuG2jSnYc/HvnagRFHSXq9zp/F2CI31t2ZUyQYgTCLyoyv7z3xEswVQqKejX
        2Qu3+cEAGFcjZqZ9NRKFjQsYwyamqX4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-L0i-dOytNyayPpTMVy5gng-1; Wed, 06 Jul 2022 03:51:38 -0400
X-MC-Unique: L0i-dOytNyayPpTMVy5gng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5C1F8339C2;
        Wed,  6 Jul 2022 07:51:37 +0000 (UTC)
Received: from localhost (unknown [10.39.194.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80A2F4010D2A;
        Wed,  6 Jul 2022 07:51:37 +0000 (UTC)
Date:   Wed, 6 Jul 2022 08:51:36 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Julia Suvorova <jusual@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        qemu block <qemu-block@nongnu.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Filipe Manana <fdmanana@kernel.org>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] io_uring: fix short read slow path
Message-ID: <YsU/CGkl9ZXUI+Tj@stefanha-x1.localdomain>
References: <20220629044957.1998430-1-dominique.martinet@atmark-techno.com>
 <20220630010137.2518851-1-dominique.martinet@atmark-techno.com>
 <20220630154921.ekl45dzer6x4mkvi@sgarzare-redhat>
 <Yr4pLwz5vQJhmvki@atmark-techno.com>
 <YsQ8aM3/ZT+Bs7nC@stefanha-x1.localdomain>
 <YsTAxtvpvIIi8q7M@atmark-techno.com>
 <CAJSP0QUg5g6SDCy52carWRbVUFBhrAoiezinPdfhEOAKNwrN3g@mail.gmail.com>
 <YsU5Q6p17yGsxxk+@atmark-techno.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lVNuZ7hVSoe7+tTM"
Content-Disposition: inline
In-Reply-To: <YsU5Q6p17yGsxxk+@atmark-techno.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--lVNuZ7hVSoe7+tTM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 06, 2022 at 04:26:59PM +0900, Dominique Martinet wrote:
> Stefan Hajnoczi wrote on Wed, Jul 06, 2022 at 08:17:42AM +0100:
> > Great! I've already queued your fix.
>=20
> Thanks!
>=20
> > Do you want to send a follow-up that updates the comment?
>=20
> I don't think I'd add much value at this point, leaving it to you unless
> you really would prefer me to send it.

That's fine. I'll send a patch. Thanks!

Stefan

--lVNuZ7hVSoe7+tTM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmLFPwgACgkQnKSrs4Gr
c8ikiAgAk9fBuxL7+mmmWCbMmxxG81taEowzxPn7NMVhigpgpnuuJzw9TF0bpcAy
pdOviF+4pVYlkpM3hQPhBJvzMs89mKekWx+81rE1cnZOR2hf4QO4Lx1ADO7MCv8S
oSxPDHWEKXCI8lLxE8tPZKHCaveWshvSvDbrIDzDvyuyj/ThXEnHuBbO6JaRwXfg
hZMgpjmqNFBRVUjHvH65E4wegvWEhWqCjDND/LBsfkHjfwpX8DT4elM2CWEBJ5aq
fa/IDQf6PTJABLgqSXZPd5sJz2rpNWjrHe++YzHbmRuZtGziM1BleETCmdTtQr56
QO1rgZZE+5hC9hdJteIo36pr2xXaKA==
=FbMk
-----END PGP SIGNATURE-----

--lVNuZ7hVSoe7+tTM--

