Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9895D5F6D7E
	for <lists+io-uring@lfdr.de>; Thu,  6 Oct 2022 20:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbiJFSaI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Oct 2022 14:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbiJFSaH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Oct 2022 14:30:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A631B286DE
        for <io-uring@vger.kernel.org>; Thu,  6 Oct 2022 11:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665081004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GR/VmE/JFWufoxQNscwIseQIsTcoM3u27LXR33wIOdM=;
        b=IcQerrmivRAi+ZB8uuFw0WQ8k6WuuydHsP6OLqp9SypOYTJ63e+u4gp7jr5/1cK2Uz0Z0H
        iW1ydY3Q9vUONs/KkyphxoNdMwwjB/frQFab0coCGM1yJI9hfPGkXnFHt7tCNgOZ78KuvY
        4kvRPsEqAWSI4qBSYRjYYIJKMGN8EuU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-qRnYg_nkMKS5aQJDVxoO_A-1; Thu, 06 Oct 2022 14:29:59 -0400
X-MC-Unique: qRnYg_nkMKS5aQJDVxoO_A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 682443C0F66F;
        Thu,  6 Oct 2022 18:29:58 +0000 (UTC)
Received: from localhost (unknown [10.39.193.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B6561121330;
        Thu,  6 Oct 2022 18:29:56 +0000 (UTC)
Date:   Thu, 6 Oct 2022 14:29:55 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ming Lei <tom.leiming@gmail.com>
Cc:     "Denis V. Lunev" <den@virtuozzo.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        rjones@redhat.com, Xie Yongji <xieyongji@bytedance.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Mike Christie <mchristi@redhat.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Message-ID: <Yz8eo0IWMAJOwKWn@fedora>
References: <Yza1u1KfKa7ycQm0@T590>
 <Yzs9xQlVuW41TuNC@fedora>
 <6659a0d5-60ab-9ac7-d25d-b4ff1940c6ab@virtuozzo.com>
 <Yz2epPwoufj0mug/@fedora>
 <Yz6tR24T8HPHJ70D@T590>
 <Yz7fTANAxAQ8KT4v@fedora>
 <Yz7vvNKSNRyBVObo@T590>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6RwoVJ4k64p8vK98"
Content-Disposition: inline
In-Reply-To: <Yz7vvNKSNRyBVObo@T590>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--6RwoVJ4k64p8vK98
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 06, 2022 at 11:09:48PM +0800, Ming Lei wrote:
> On Thu, Oct 06, 2022 at 09:59:40AM -0400, Stefan Hajnoczi wrote:
> > On Thu, Oct 06, 2022 at 06:26:15PM +0800, Ming Lei wrote:
> > > On Wed, Oct 05, 2022 at 11:11:32AM -0400, Stefan Hajnoczi wrote:
> > > > On Tue, Oct 04, 2022 at 01:57:50AM +0200, Denis V. Lunev wrote:
> > > > > On 10/3/22 21:53, Stefan Hajnoczi wrote:
> > > > > > On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > > > > > > ublk-qcow2 is available now.
> > > > > > Cool, thanks for sharing!
> > > > > yep
> > > > >=20
> > > > > > > So far it provides basic read/write function, and compression=
 and snapshot
> > > > > > > aren't supported yet. The target/backend implementation is co=
mpletely
> > > > > > > based on io_uring, and share the same io_uring with ublk IO c=
ommand
> > > > > > > handler, just like what ublk-loop does.
> > > > > > >=20
> > > > > > > Follows the main motivations of ublk-qcow2:
> > > > > > >=20
> > > > > > > - building one complicated target from scratch helps libublks=
rv APIs/functions
> > > > > > >    become mature/stable more quickly, since qcow2 is complica=
ted and needs more
> > > > > > >    requirement from libublksrv compared with other simple one=
s(loop, null)
> > > > > > >=20
> > > > > > > - there are several attempts of implementing qcow2 driver in =
kernel, such as
> > > > > > >    ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`=
` [4], so ublk-qcow2
> > > > > > >    might useful be for covering requirement in this field
> > > > > There is one important thing to keep in mind about all partly-use=
rspace
> > > > > implementations though:
> > > > > * any single allocation happened in the context of the
> > > > > =A0=A0 userspace daemon through try_to_free_pages() in
> > > > > =A0=A0 kernel has a possibility to trigger the operation,
> > > > > =A0=A0 which will require userspace daemon action, which
> > > > > =A0=A0 is inside the kernel now.
> > > > > * the probability of this is higher in the overcommitted
> > > > > =A0=A0 environment
> > > > >=20
> > > > > This was the main motivation of us in favor for the in-kernel
> > > > > implementation.
> > > >=20
> > > > CCed Josef Bacik because the Linux NBD driver has dealt with memory
> > > > reclaim hangs in the past.
> > > >=20
> > > > Josef: Any thoughts on userspace block drivers (whether NBD or ublk=
) and
> > > > how to avoid hangs in memory reclaim?
> > >=20
> > > If I remember correctly, there isn't new report after the last NBD(TC=
MU) deadlock
> > > in memory reclaim was addressed by 8d19f1c8e193 ("prctl: PR_{G,S}ET_I=
O_FLUSHER
> > > to support controlling memory reclaim").
> >=20
> > Denis: I'm trying to understand the problem you described. Is this
> > correct:
> >=20
> > Due to memory pressure, the kernel reclaims pages and submits a write to
> > a ublk block device. The userspace process attempts to allocate memory
> > in order to service the write request, but it gets stuck because there
> > is no memory available. As a result reclaim gets stuck, the system is
> > unable to free more memory and therefore it hangs?
>=20
> The process should be killed in this situation if PR_SET_IO_FLUSHER
> is applied since the page allocation is done in VM fault handler.

Thanks for mentioning PR_SET_IO_FLUSHER. There is more info in commit
8d19f1c8e1937baf74e1962aae9f90fa3aeab463 ("prctl: PR_{G,S}ET_IO_FLUSHER
to support controlling memory reclaim").

It requires CAP_SYS_RESOURCE :/. This makes me wonder whether
unprivileged ublk will ever be possible.

I think this addresses Denis' concern about hangs, but it doesn't solve
them because I/O will fail. The real solution is probably what you
mentioned...

> Firstly in theory the userspace part should provide forward progress
> guarantee in code path for handling IO, such as reserving/mlock pages
> for such situation. However, this issue isn't unique for nbd or ublk,
> all userspace block device should have such potential risk, and vduse
> is no exception, IMO.

=2E..here. Userspace needs to minimize memory allocations in the I/O code
path and reserve sufficient resources to make forward progress.

Stefan

--6RwoVJ4k64p8vK98
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmM/HqMACgkQnKSrs4Gr
c8gdMwgAt2uBqb9BuOBYhclEKVi/V4v2vRqAzrMlGSsU3j6ZvtIH+JwfF420xYiA
hhHDMxUwRyexA6SwnBN245+Mi5gxoOLZA/OjwQLyWCIuVNv8CS9UbwXdaQoa5IB1
3iRSALpCD913qK70W/gAYmjX3p3aDq67F05bE8QQoz3F7D82iUmY3Nm96vQPIdzn
4oyvKmSH8OoY4d566nNSqDKwIcQZ/dnRWmuDODjXDdSajoHjNzpKDAwU2L7oa4HF
2CegrkFKNRuBqjdeoA6xfm1F6SXdxgwyfDuIFXoCk0E9o8QkggUX6Dm6Lx5AKW8u
qa3d11zuwWY0scCPDzLp9bTitS7H7w==
=1Utp
-----END PGP SIGNATURE-----

--6RwoVJ4k64p8vK98--

