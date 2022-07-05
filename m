Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D40566FEC
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 15:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiGENxA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 09:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiGENwZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 09:52:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10B07DFE
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 06:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657027701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aiDh6ZiIoDwxx2WVwd6SCVxNEeLguSVbhwWzTAGC810=;
        b=Auyw3pJhq6Y4jt3coQAEDRIgj7R9Y5YNVUjiPjxG0Xjj9TeJcisViuSweDVwjx6tCAlulQ
        8YWENmZt91/jXxIQD+wpCfc4jDPyXD/+NZEnpOsTgnNU9DvmpqvaRM+eumkg2OpS1bmuu6
        eDE6pR5qOHKjWEn6R3Cm6XVJabjGG34=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-Kp_etqA_MqWtY7x0TjJuHQ-1; Tue, 05 Jul 2022 09:28:11 -0400
X-MC-Unique: Kp_etqA_MqWtY7x0TjJuHQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B329E1019C89;
        Tue,  5 Jul 2022 13:28:10 +0000 (UTC)
Received: from localhost (unknown [10.39.194.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11ED3492C3B;
        Tue,  5 Jul 2022 13:28:09 +0000 (UTC)
Date:   Tue, 5 Jul 2022 14:28:08 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Julia Suvorova <jusual@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        qemu-block@nongnu.org, qemu-devel@nongnu.org,
        Filipe Manana <fdmanana@kernel.org>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] io_uring: fix short read slow path
Message-ID: <YsQ8aM3/ZT+Bs7nC@stefanha-x1.localdomain>
References: <20220629044957.1998430-1-dominique.martinet@atmark-techno.com>
 <20220630010137.2518851-1-dominique.martinet@atmark-techno.com>
 <20220630154921.ekl45dzer6x4mkvi@sgarzare-redhat>
 <Yr4pLwz5vQJhmvki@atmark-techno.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Mk1wzxCN7Pk8Bj2u"
Content-Disposition: inline
In-Reply-To: <Yr4pLwz5vQJhmvki@atmark-techno.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--Mk1wzxCN7Pk8Bj2u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 01, 2022 at 07:52:31AM +0900, Dominique Martinet wrote:
> Stefano Garzarella wrote on Thu, Jun 30, 2022 at 05:49:21PM +0200:
> > > so when we ask for more we issue an extra short reads, making sure we=
 go
> > > through the two short reads path.
> > > (Unfortunately I wasn't quite sure what to fiddle with to issue short
> > > reads in the first place, I tried cutting one of the iovs short in
> > > luring_do_submit() but I must not have been doing it properly as I en=
ded
> > > up with 0 return values which are handled by filling in with 0 (reads
> > > after eof) and that didn't work well)
> >=20
> > Do you remember the kernel version where you first saw these problems?
>=20
> Since you're quoting my paragraph about testing two short reads, I've
> never seen any that I know of; but there's also no reason these couldn't
> happen.
>=20
> Single short reads have been happening for me with O_DIRECT (cache=3Dnone)
> on btrfs for a while, but unfortunately I cannot remember which was the
> first kernel I've seen this on -- I think rather than a kernel update it
> was due to file manipulations that made the file eligible for short
> reads in the first place (I started running deduplication on the backing
> file)
>=20
> The older kernel I have installed right now is 5.16 and that can
> reproduce it --  I'll give my laptop some work over the weekend to test
> still maintained stable branches if that's useful.

Hi Dominique,
Linux 5.16 contains commit 9d93a3f5a0c ("io_uring: punt short reads to
async context"). The comment above QEMU's luring_resubmit_short_read()
claims that short reads are a bug that was fixed by Linux commit
9d93a3f5a0c.

If the comment is inaccurate it needs to be fixed. Maybe short writes
need to be handled too.

I have CCed Jens and the io_uring mailing list to clarify:
1. Are short IORING_OP_READV reads possible on files/block devices?
2. Are short IORING_OP_WRITEV writes possible on files/block devices?

Thanks,
Stefan

--Mk1wzxCN7Pk8Bj2u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmLEPGgACgkQnKSrs4Gr
c8jh9Qf7BmQH3KNRbt5BkMcqyWA/phMoqkQAcHckkXc/cYm3HbNChN+rkOjO2Y6Z
w8u39noDsYpkqhzlSj59V0lNnyqJl1GmcVlJ/hEVz+cOS9B8aV82KlMGjIV/1qD1
lDLOZmws/63URuV/rOHB7dwLhXM0cypiIMEf0HND32SvQ60SM5zFKNMftrXgHp+/
na47gcINRJokmWIALIbLzaKin8aWiKGPercmbQZGe226JJsAQ6Fsi4dSQGkPkvnE
6BrUKuyhMz3t382JJcIPXgJ3gtz/JnVcK8vQrMujVwuGcOcqUgxbBbB0NursE5Sw
TJ2WR/pQ6d1w3kR/JSZBGiBiBN5E6A==
=ePtD
-----END PGP SIGNATURE-----

--Mk1wzxCN7Pk8Bj2u--

