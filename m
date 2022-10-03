Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7E05F37E5
	for <lists+io-uring@lfdr.de>; Mon,  3 Oct 2022 23:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiJCVgK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Oct 2022 17:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiJCVfp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Oct 2022 17:35:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B6C3B1
        for <io-uring@vger.kernel.org>; Mon,  3 Oct 2022 14:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664832732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WyJJ2FzJrDN4Y29SDxUEPGCuBekc4KziQ+5yZ8f9tJU=;
        b=Jr3JNCOdLk9ObskWOngpllZiaaD6HzdinvMXtGlgwFcZmdC2NAl1fAC4qUkEnPS5wRfExU
        QtPJ+9z5AGoq0fXTKEqodZILGn9ephAu6s67vPPCZYPRj1DfFbFKBD8/OTH7yGU8Fbojah
        ISkrgbaRLvACDLHyzqFBTApUyd/IE+U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-jX31pjvoO_GnSwv5xXLG8A-1; Mon, 03 Oct 2022 17:32:09 -0400
X-MC-Unique: jX31pjvoO_GnSwv5xXLG8A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E27DD85A59D;
        Mon,  3 Oct 2022 21:32:08 +0000 (UTC)
Received: from localhost (unknown [10.39.192.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA00C2027061;
        Mon,  3 Oct 2022 21:32:07 +0000 (UTC)
Date:   Mon, 3 Oct 2022 15:53:41 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ming Lei <tom.leiming@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        rjones@redhat.com, Xie Yongji <xieyongji@bytedance.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Message-ID: <Yzs9xQlVuW41TuNC@fedora>
References: <Yza1u1KfKa7ycQm0@T590>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bJI59MQn0KJiUKNL"
Content-Disposition: inline
In-Reply-To: <Yza1u1KfKa7ycQm0@T590>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,URI_DOTEDU autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--bJI59MQn0KJiUKNL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> ublk-qcow2 is available now.

Cool, thanks for sharing!

>=20
> So far it provides basic read/write function, and compression and snapshot
> aren't supported yet. The target/backend implementation is completely
> based on io_uring, and share the same io_uring with ublk IO command
> handler, just like what ublk-loop does.
>=20
> Follows the main motivations of ublk-qcow2:
>=20
> - building one complicated target from scratch helps libublksrv APIs/func=
tions
>   become mature/stable more quickly, since qcow2 is complicated and needs=
 more
>   requirement from libublksrv compared with other simple ones(loop, null)
>=20
> - there are several attempts of implementing qcow2 driver in kernel, such=
 as
>   ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], so ubl=
k-qcow2
>   might useful be for covering requirement in this field
>=20
> - performance comparison with qemu-nbd, and it was my 1st thought to eval=
uate
>   performance of ublk/io_uring backend by writing one ublk-qcow2 since ub=
lksrv
>   is started
>=20
> - help to abstract common building block or design pattern for writing ne=
w ublk
>   target/backend
>=20
> So far it basically passes xfstest(XFS) test by using ublk-qcow2 block
> device as TEST_DEV, and kernel building workload is verified too. Also
> soft update approach is applied in meta flushing, and meta data
> integrity is guaranteed, 'make test T=3Dqcow2/040' covers this kind of
> test, and only cluster leak is reported during this test.
>=20
> The performance data looks much better compared with qemu-nbd, see
> details in commit log[1], README[5] and STATUS[6]. And the test covers bo=
th
> empty image and pre-allocated image, for example of pre-allocated qcow2
> image(8GB):
>=20
> - qemu-nbd (make test T=3Dqcow2/002)

Single queue?

> 	randwrite(4k): jobs 1, iops 24605
> 	randread(4k): jobs 1, iops 30938
> 	randrw(4k): jobs 1, iops read 13981 write 14001
> 	rw(512k): jobs 1, iops read 724 write 728

Please try qemu-storage-daemon's VDUSE export type as well. The
command-line should be similar to this:

  # modprobe virtio_vdpa # attaches vDPA devices to host kernel
  # modprobe vduse
  # qemu-storage-daemon \
      --blockdev file,filename=3Dtest.qcow2,cache.direct=3Dof|off,aio=3Dnat=
ive,node-name=3Dfile \
      --blockdev qcow2,file=3Dfile,node-name=3Dqcow2 \
      --object iothread,id=3Diothread0 \
      --export vduse-blk,id=3Dvduse0,name=3Dvduse0,num-queues=3D$(nproc),no=
de-name=3Dqcow2,writable=3Don,iothread=3Diothread0
  # vdpa dev add name vduse0 mgmtdev vduse

A virtio-blk device should appear and xfstests can be run on it
(typically /dev/vda unless you already have other virtio-blk devices).

Afterwards you can destroy the device using:

  # vdpa dev del vduse0

>=20
> - ublk-qcow2 (make test T=3Dqcow2/022)

There are a lot of other factors not directly related to NBD vs ublk. In
order to get an apples-to-apples comparison with qemu-* a ublk export
type is needed in qemu-storage-daemon. That way only the difference is
the ublk interface and the rest of the code path is identical, making it
possible to compare NBD, VDUSE, ublk, etc more precisely.

I think that comparison is interesting before comparing different qcow2
implementations because qcow2 sits on top of too much other code. It's
hard to know what should be accounted to configuration differences,
implementation differences, or fundamental differences that cannot be
overcome (this is the interesting part!).

> 	randwrite(4k): jobs 1, iops 104481
> 	randread(4k): jobs 1, iops 114937
> 	randrw(4k): jobs 1, iops read 53630 write 53577
> 	rw(512k): jobs 1, iops read 1412 write 1423
>=20
> Also ublk-qcow2 aligns queue's chunk_sectors limit with qcow2's cluster s=
ize,
> which is 64KB at default, this way simplifies backend io handling, but
> it could be increased to 512K or more proper size for improving sequential
> IO perf, just need one coroutine to handle more than one IOs.
>=20
>=20
> [1] https://github.com/ming1/ubdsrv/commit/9faabbec3a92ca83ddae92335c66ea=
bbeff654e7
> [2] https://upcommons.upc.edu/bitstream/handle/2099.1/9619/65757.pdf?sequ=
ence=3D1&isAllowed=3Dy
> [3] https://lwn.net/Articles/889429/
> [4] https://lab.ks.uni-freiburg.de/projects/kernel-qcow2/repository
> [5] https://github.com/ming1/ubdsrv/blob/master/qcow2/README.rst
> [6] https://github.com/ming1/ubdsrv/blob/master/qcow2/STATUS.rst
>=20
> Thanks,
> Ming
>=20

--bJI59MQn0KJiUKNL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmM7PcUACgkQnKSrs4Gr
c8i93AgAib2dawkTdAYrOmjuCQb+qNpv+e7Zq8oKjll/V+/Gw8MFTcfmruW0vMex
zgWcQ4oWWarMgU/YbP0rYTGpTRNG3NWbw4gozRrdT6akOfYD7I6pyZxIcXu9KNTM
qInj7AqgdQxmwwVCH1s3zDuK0acVUt6cq6lIC+yt4/0FvSuQdqNmYXgwEimFGgaO
RptJk6qB57zOAeOy8Y3c2N8ZLuqOEcNiOeh74ahVJsaPmBNOOg22ltzkNRJbfTuU
oyaPqKKjGNZepksZoaSaWPdWbFrF/inEtwyRFWutd5wdyDX3gfkEFCKh3csgku3E
BciwRjNcVdsrkTiv/Nnd4XRurHCEqA==
=7gpZ
-----END PGP SIGNATURE-----

--bJI59MQn0KJiUKNL--

