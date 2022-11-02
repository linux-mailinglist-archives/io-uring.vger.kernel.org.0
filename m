Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C833616DA0
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 20:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiKBTPY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 15:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiKBTOq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 15:14:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1905A10B43
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 12:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667416434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sfmdRZi2oRqTqcnLT5pjPUSkV22lKIz3gi/HpKleL5o=;
        b=hI4YxzkIqTCkajFp2yWwdZdG7DiEKlhkv65dzGULf0YtvvTgr2BFgRJIDemDJj8fVt3FzF
        ktCJ98QXsYlnGbgAdsdX6tpufBWL74cNj+mRGQsA0ujl1GhTpJ7nvw+qfgZzgrYfUBm+Gu
        qecSTF7G9wmW/bR4c5ff5KfHRsnFrjg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-PxzAMl8kMMG9hH5Z1BqGww-1; Wed, 02 Nov 2022 15:13:51 -0400
X-MC-Unique: PxzAMl8kMMG9hH5Z1BqGww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABA5E87B2A1;
        Wed,  2 Nov 2022 19:13:50 +0000 (UTC)
Received: from localhost (unknown [10.39.192.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC2C21121320;
        Wed,  2 Nov 2022 19:13:49 +0000 (UTC)
Date:   Wed, 2 Nov 2022 15:13:47 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ming Lei <tom.leiming@gmail.com>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Message-ID: <Y2LBa/ePKiSN2phm@fedora>
References: <Y0lcmZTP5sr467z6@T590>
 <CACycT3u8yYUS-WnNzgHQtQFYuK-XcyffpFc35HVZzrCS7hH5Sg@mail.gmail.com>
 <Y05OzeC7wImts4p7@T590>
 <CACycT3sK1AzA4RH1ZfbstV3oax-oeBVtEz+sY+8scBU0=1x46g@mail.gmail.com>
 <CAJSP0QVevA0gvyGABAFSoMhBN9ydZqUJh4qJYgNbGeyRXL8AjA@mail.gmail.com>
 <CACycT3udzt0nyqweGbAsZB4LDQU=a7OSWKC8ZWieoBpsSfa2FQ@mail.gmail.com>
 <1d051d63-ce34-1bb3-2256-4ced4be6d690@redhat.com>
 <CACycT3usE0QdJd50bSiLiPwTFxscg-Ur=iZyeGJJBPe7+KxOFQ@mail.gmail.com>
 <CAJSP0QUGj4t8nYeJvGaO-cWJ+F3Zvxcq007RHOm-=41zaE-v0Q@mail.gmail.com>
 <CACGkMEt+BWCUVQPnfUUd0QXkHz=90LMXxydCgBqWTDB3eGBw-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jPo3x6rSJt98BRBl"
Content-Disposition: inline
In-Reply-To: <CACGkMEt+BWCUVQPnfUUd0QXkHz=90LMXxydCgBqWTDB3eGBw-w@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--jPo3x6rSJt98BRBl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 01, 2022 at 10:36:29AM +0800, Jason Wang wrote:
> On Tue, Oct 25, 2022 at 8:02 PM Stefan Hajnoczi <stefanha@gmail.com> wrot=
e:
> >
> > On Tue, 25 Oct 2022 at 04:17, Yongji Xie <xieyongji@bytedance.com> wrot=
e:
> > >
> > > On Fri, Oct 21, 2022 at 2:30 PM Jason Wang <jasowang@redhat.com> wrot=
e:
> > > >
> > > >
> > > > =E5=9C=A8 2022/10/21 13:33, Yongji Xie =E5=86=99=E9=81=93:
> > > > > On Tue, Oct 18, 2022 at 10:54 PM Stefan Hajnoczi <stefanha@gmail.=
com> wrote:
> > > > >> On Tue, 18 Oct 2022 at 09:17, Yongji Xie <xieyongji@bytedance.co=
m> wrote:
> > > > >>> On Tue, Oct 18, 2022 at 2:59 PM Ming Lei <tom.leiming@gmail.com=
> wrote:
> > > > >>>> On Mon, Oct 17, 2022 at 07:11:59PM +0800, Yongji Xie wrote:
> > > > >>>>> On Fri, Oct 14, 2022 at 8:57 PM Ming Lei <tom.leiming@gmail.c=
om> wrote:
> > > > >>>>>> On Thu, Oct 13, 2022 at 02:48:04PM +0800, Yongji Xie wrote:
> > > > >>>>>>> On Wed, Oct 12, 2022 at 10:22 PM Stefan Hajnoczi <stefanha@=
gmail.com> wrote:
> > > > >>>>>>>> On Sat, 8 Oct 2022 at 04:43, Ziyang Zhang <ZiyangZhang@lin=
ux.alibaba.com> wrote:
> > > > >>>>>>>>> On 2022/10/5 12:18, Ming Lei wrote:
> > > > >>>>>>>>>> On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnocz=
i wrote:
> > > > >>>>>>>>>>> On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmai=
l.com> wrote:
> > > > >>>>>>>>>>>> On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajno=
czi wrote:
> > > > >>>>>>>>>>>>> On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wr=
ote:
> > There are ways to minimize that cost:
> > 1. The driver only needs to fetch the device's sq index when it has
> > run out of sq ring space.
> > 2. The device can include sq index updates with completions. This is
> > what NVMe does with the CQE SQ Head Pointer field, but the
> > disadvantage is that the driver has no way of determining the sq index
> > until a completion occurs.
>=20
> Probably, but as replied in another thread, based on the numbers
> measured from the networking test, I think the current virtio layout
> should be sufficient for block I/O but might not fit for cases like
> NFV.

I remember that the Linux virtio_net driver doesn't rely on vq spinlocks
because CPU affinity and the NAPI architecture ensure that everything is
CPU-local. There is no need to protect the freelist explicitly because
the functions cannot race.

Maybe virtio_blk can learn from virtio_net...

Stefan

--jPo3x6rSJt98BRBl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmNiwWsACgkQnKSrs4Gr
c8gbrgf/WHP+3xc/eWo3qZHzOaLwMBStLXxphQCA3G+/eYczr4GsFdkMmSs6FiAD
dKoF7y4iBSKkRyJk0IsDA/57yrnYv9ygPUXHYsYz0UmyJ7ax5G7t7nJZ0CpEJjsF
/ZlpRCb4NCuW4tIYih1QW5edo564pjwF9VKH6VUu0lZhSgZSZCYh3VruUBaF4x1C
Jsw9qxoSUb0+EyqhaS8DbKDWF7ah1TO+oXI62N4RVbimJYewxUBIveYCtGh6IPdO
7/efT8LICrNRehiUGDzC7pnOOwc9MiKwjaIX/qFOxsmQlYr3BRZ1pd7LSvVC6s4p
87ZYdPu20YwF1RMeDkq399nbEu8mQQ==
=kHlQ
-----END PGP SIGNATURE-----

--jPo3x6rSJt98BRBl--

