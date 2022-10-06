Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B977A5F68AE
	for <lists+io-uring@lfdr.de>; Thu,  6 Oct 2022 15:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiJFN7v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Oct 2022 09:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiJFN7u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Oct 2022 09:59:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FF4E03B
        for <io-uring@vger.kernel.org>; Thu,  6 Oct 2022 06:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665064787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wvAFTm8FdW2/6pnC/amNx72dguHCE6Nha3ZiXPtT6Ek=;
        b=SGlr3MYGXNCC9JLvoOM4ehGngvBlee55Kvufj3HmNTCxFIcClHqovd25zWhEh4vQuH+D0n
        P2mDX/FqGzs7UPgJsU4htUcFlgD58gt2gXQsmq43mw163AfqhTshrfy3UYZdHmdGsvDnhq
        n/5gnL7Fu2O7kRLZpU9e0iEkVWbQ55E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-pkRHXZp8OU-oqy8cOmgpJQ-1; Thu, 06 Oct 2022 09:59:44 -0400
X-MC-Unique: pkRHXZp8OU-oqy8cOmgpJQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0075855307;
        Thu,  6 Oct 2022 13:59:43 +0000 (UTC)
Received: from localhost (unknown [10.39.193.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1523111E412;
        Thu,  6 Oct 2022 13:59:42 +0000 (UTC)
Date:   Thu, 6 Oct 2022 09:59:40 -0400
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
Message-ID: <Yz7fTANAxAQ8KT4v@fedora>
References: <Yza1u1KfKa7ycQm0@T590>
 <Yzs9xQlVuW41TuNC@fedora>
 <6659a0d5-60ab-9ac7-d25d-b4ff1940c6ab@virtuozzo.com>
 <Yz2epPwoufj0mug/@fedora>
 <Yz6tR24T8HPHJ70D@T590>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="15fzNgcvZDw6D8kW"
Content-Disposition: inline
In-Reply-To: <Yz6tR24T8HPHJ70D@T590>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--15fzNgcvZDw6D8kW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 06, 2022 at 06:26:15PM +0800, Ming Lei wrote:
> On Wed, Oct 05, 2022 at 11:11:32AM -0400, Stefan Hajnoczi wrote:
> > On Tue, Oct 04, 2022 at 01:57:50AM +0200, Denis V. Lunev wrote:
> > > On 10/3/22 21:53, Stefan Hajnoczi wrote:
> > > > On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > > > > ublk-qcow2 is available now.
> > > > Cool, thanks for sharing!
> > > yep
> > >=20
> > > > > So far it provides basic read/write function, and compression and=
 snapshot
> > > > > aren't supported yet. The target/backend implementation is comple=
tely
> > > > > based on io_uring, and share the same io_uring with ublk IO comma=
nd
> > > > > handler, just like what ublk-loop does.
> > > > >=20
> > > > > Follows the main motivations of ublk-qcow2:
> > > > >=20
> > > > > - building one complicated target from scratch helps libublksrv A=
PIs/functions
> > > > >    become mature/stable more quickly, since qcow2 is complicated =
and needs more
> > > > >    requirement from libublksrv compared with other simple ones(lo=
op, null)
> > > > >=20
> > > > > - there are several attempts of implementing qcow2 driver in kern=
el, such as
> > > > >    ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4=
], so ublk-qcow2
> > > > >    might useful be for covering requirement in this field
> > > There is one important thing to keep in mind about all partly-userspa=
ce
> > > implementations though:
> > > * any single allocation happened in the context of the
> > > =A0=A0 userspace daemon through try_to_free_pages() in
> > > =A0=A0 kernel has a possibility to trigger the operation,
> > > =A0=A0 which will require userspace daemon action, which
> > > =A0=A0 is inside the kernel now.
> > > * the probability of this is higher in the overcommitted
> > > =A0=A0 environment
> > >=20
> > > This was the main motivation of us in favor for the in-kernel
> > > implementation.
> >=20
> > CCed Josef Bacik because the Linux NBD driver has dealt with memory
> > reclaim hangs in the past.
> >=20
> > Josef: Any thoughts on userspace block drivers (whether NBD or ublk) and
> > how to avoid hangs in memory reclaim?
>=20
> If I remember correctly, there isn't new report after the last NBD(TCMU) =
deadlock
> in memory reclaim was addressed by 8d19f1c8e193 ("prctl: PR_{G,S}ET_IO_FL=
USHER
> to support controlling memory reclaim").

Denis: I'm trying to understand the problem you described. Is this
correct:

Due to memory pressure, the kernel reclaims pages and submits a write to
a ublk block device. The userspace process attempts to allocate memory
in order to service the write request, but it gets stuck because there
is no memory available. As a result reclaim gets stuck, the system is
unable to free more memory and therefore it hangs?

Stefan

--15fzNgcvZDw6D8kW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmM+30wACgkQnKSrs4Gr
c8iHRQf8CLjA5KPwDOjXvWn297/VU+slSiJzehP2Idpif/5l1xCQuasQWziB8flE
skkANbVPQn8Y+Z/cwWykCx3XjZSoVDM+SO4VG1TMS1ZcPU+ODHzPdA1/yZwArg1J
/6A8HxGpVAQYajnOmAMEBueuSUX30cN32YGh/uNykOU4q0Td8YzXS2ybbRGQfnit
lkU4QvFm6foeKArFelx+8AP3xiQXIHulVtG4Yn72gnAIzZDgJlrsau3x05idY/+L
acGUSyXP2PUnsZqFncWviWOfpa1LnyXDp1/bk4t/XRdrzSCReyOtcEwk/0ahFceh
3AWMJdbDcA+5dP62qT3XyL6dCgaugQ==
=bI8b
-----END PGP SIGNATURE-----

--15fzNgcvZDw6D8kW--

