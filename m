Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61845F572A
	for <lists+io-uring@lfdr.de>; Wed,  5 Oct 2022 17:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiJEPMH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Oct 2022 11:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiJEPMG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Oct 2022 11:12:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFC96E2C1
        for <io-uring@vger.kernel.org>; Wed,  5 Oct 2022 08:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664982724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/WGubC4HbVqcwNsvts+AiFEUTLkMeqajhao/HLtOsbc=;
        b=YO0e5jqX6ZnXLEVoX+4+3QIOwrxsDlQFFHs6n33ScDjiW/aLoDhCQkTiuHWs/lktPWIsER
        L083E6dRPfBEKdBXFTjwmXqA1FsqtF5MI4wzC44UWgVmMe7O2yllLAddzeWWMq6Pw1o7DK
        Cb2N6GE6SNIudeZxV1xTSENfiV7vaio=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-Pud9b8BxNhaiVC77lbmreg-1; Wed, 05 Oct 2022 11:12:01 -0400
X-MC-Unique: Pud9b8BxNhaiVC77lbmreg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E66C3C0D1A4;
        Wed,  5 Oct 2022 15:11:58 +0000 (UTC)
Received: from localhost (unknown [10.39.193.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59626C15BA4;
        Wed,  5 Oct 2022 15:11:51 +0000 (UTC)
Date:   Wed, 5 Oct 2022 11:11:32 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "Denis V. Lunev" <den@virtuozzo.com>
Cc:     Ming Lei <tom.leiming@gmail.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        rjones@redhat.com, Xie Yongji <xieyongji@bytedance.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Message-ID: <Yz2epPwoufj0mug/@fedora>
References: <Yza1u1KfKa7ycQm0@T590>
 <Yzs9xQlVuW41TuNC@fedora>
 <6659a0d5-60ab-9ac7-d25d-b4ff1940c6ab@virtuozzo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0HJHRezJw1wbMhDd"
Content-Disposition: inline
In-Reply-To: <6659a0d5-60ab-9ac7-d25d-b4ff1940c6ab@virtuozzo.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--0HJHRezJw1wbMhDd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 04, 2022 at 01:57:50AM +0200, Denis V. Lunev wrote:
> On 10/3/22 21:53, Stefan Hajnoczi wrote:
> > On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > > ublk-qcow2 is available now.
> > Cool, thanks for sharing!
> yep
>=20
> > > So far it provides basic read/write function, and compression and sna=
pshot
> > > aren't supported yet. The target/backend implementation is completely
> > > based on io_uring, and share the same io_uring with ublk IO command
> > > handler, just like what ublk-loop does.
> > >=20
> > > Follows the main motivations of ublk-qcow2:
> > >=20
> > > - building one complicated target from scratch helps libublksrv APIs/=
functions
> > >    become mature/stable more quickly, since qcow2 is complicated and =
needs more
> > >    requirement from libublksrv compared with other simple ones(loop, =
null)
> > >=20
> > > - there are several attempts of implementing qcow2 driver in kernel, =
such as
> > >    ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], s=
o ublk-qcow2
> > >    might useful be for covering requirement in this field
> There is one important thing to keep in mind about all partly-userspace
> implementations though:
> * any single allocation happened in the context of the
> =A0=A0 userspace daemon through try_to_free_pages() in
> =A0=A0 kernel has a possibility to trigger the operation,
> =A0=A0 which will require userspace daemon action, which
> =A0=A0 is inside the kernel now.
> * the probability of this is higher in the overcommitted
> =A0=A0 environment
>=20
> This was the main motivation of us in favor for the in-kernel
> implementation.

CCed Josef Bacik because the Linux NBD driver has dealt with memory
reclaim hangs in the past.

Josef: Any thoughts on userspace block drivers (whether NBD or ublk) and
how to avoid hangs in memory reclaim?

Stefan

--0HJHRezJw1wbMhDd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmM9nqQACgkQnKSrs4Gr
c8iEoAf/eIubb5NIhncZ0gl2w50kSq02L7TslR04+6oMZQN+WN/pe3IPaCA2AFEC
5FronSoFT2uNPoARvGAzXKOMgM6L3qLtrstcvVRDm46hBbmJewj6Z3/7oT/KRr5t
vJtZLmOW4vItXWRmC2v41SmKgkOKMqESjCcBrVXUSXRvYCIsD516MjSE3r+0Lawa
hPrbD4/1SAz5P0Qtoh1rqFiDSqIpqA7X86InkW/+GHNv0t3pw6E0Bp/CbPC0UVrf
XU/34RMn/0+ETiTLsrUXgirmHdimpxNdnRgmFGYSsrbwI/Yy0k/2aqQF/JWAo1zi
6el/KNsveFmDYtRkVC1tYgcwFFNFpw==
=xRRN
-----END PGP SIGNATURE-----

--0HJHRezJw1wbMhDd--

