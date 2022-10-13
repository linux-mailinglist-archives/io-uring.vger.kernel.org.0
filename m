Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5AD5FDDE3
	for <lists+io-uring@lfdr.de>; Thu, 13 Oct 2022 18:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiJMQCg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Oct 2022 12:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiJMQCd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Oct 2022 12:02:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C77B32EE5
        for <io-uring@vger.kernel.org>; Thu, 13 Oct 2022 09:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665676950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QAEadMmwtSWk7jIsNig6ebwX12HPHFKKzISFhVsQXlE=;
        b=UlVAirgITyocW8DqPLaPdlgT7em4qvtkuJXGYjaCY+N+/qrJdTc66u8wB07efGTraOBdw0
        0JhZ4Idu2dtegCltz7ryKI+5JsNa+2f83wMZ+4L6/h282LY7LOGwdjcNQ5wUtUHSMAhTm/
        ZhNBvYwr0blZkUWFkwDUdslKqMlDK5M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-fvgWsj-fPQ-rxIQxwUv6vQ-1; Thu, 13 Oct 2022 12:02:28 -0400
X-MC-Unique: fvgWsj-fPQ-rxIQxwUv6vQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02B27811E84;
        Thu, 13 Oct 2022 16:02:27 +0000 (UTC)
Received: from localhost (unknown [10.39.194.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 421ED40369AB;
        Thu, 13 Oct 2022 16:02:25 +0000 (UTC)
Date:   Thu, 13 Oct 2022 12:02:23 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <tom.leiming@gmail.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Message-ID: <Y0g2j0HvxLnPVGdx@fedora>
References: <Yza1u1KfKa7ycQm0@T590>
 <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590>
 <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <Yz0FrzJVZTqlQtJ5@T590>
 <50827796-af93-4af5-4121-dc13c31a67fc@linux.alibaba.com>
 <CAJSP0QXW9TmuvJpQPRF-AF01aW79jH8tnkHPEf+do5vQ1crGFA@mail.gmail.com>
 <CACycT3ufcN+a_wtWe6ioOWZUCak-JmcMgSa=rqeEsS63_HqSog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6LmWUr7zOCud/8Xx"
Content-Disposition: inline
In-Reply-To: <CACycT3ufcN+a_wtWe6ioOWZUCak-JmcMgSa=rqeEsS63_HqSog@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--6LmWUr7zOCud/8Xx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 13, 2022 at 02:48:04PM +0800, Yongji Xie wrote:
> On Wed, Oct 12, 2022 at 10:22 PM Stefan Hajnoczi <stefanha@gmail.com> wro=
te:
> >
> > On Sat, 8 Oct 2022 at 04:43, Ziyang Zhang <ZiyangZhang@linux.alibaba.co=
m> wrote:
> > >
> > > On 2022/10/5 12:18, Ming Lei wrote:
> > > > On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wrote:
> > > >> On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail.com> wrot=
e:
> > > >>>
> > > >>> On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnoczi wrote:
> > > >>>> On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > > >>>>> ublk-qcow2 is available now.
> > > >>>>
> > > >>>> Cool, thanks for sharing!
> > > >>>>
> > > >>>>>
> > > >>>>> So far it provides basic read/write function, and compression a=
nd snapshot
> > > >>>>> aren't supported yet. The target/backend implementation is comp=
letely
> > > >>>>> based on io_uring, and share the same io_uring with ublk IO com=
mand
> > > >>>>> handler, just like what ublk-loop does.
> > > >>>>>
> > > >>>>> Follows the main motivations of ublk-qcow2:
> > > >>>>>
> > > >>>>> - building one complicated target from scratch helps libublksrv=
 APIs/functions
> > > >>>>>   become mature/stable more quickly, since qcow2 is complicated=
 and needs more
> > > >>>>>   requirement from libublksrv compared with other simple ones(l=
oop, null)
> > > >>>>>
> > > >>>>> - there are several attempts of implementing qcow2 driver in ke=
rnel, such as
> > > >>>>>   ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [=
4], so ublk-qcow2
> > > >>>>>   might useful be for covering requirement in this field
> > > >>>>>
> > > >>>>> - performance comparison with qemu-nbd, and it was my 1st thoug=
ht to evaluate
> > > >>>>>   performance of ublk/io_uring backend by writing one ublk-qcow=
2 since ublksrv
> > > >>>>>   is started
> > > >>>>>
> > > >>>>> - help to abstract common building block or design pattern for =
writing new ublk
> > > >>>>>   target/backend
> > > >>>>>
> > > >>>>> So far it basically passes xfstest(XFS) test by using ublk-qcow=
2 block
> > > >>>>> device as TEST_DEV, and kernel building workload is verified to=
o. Also
> > > >>>>> soft update approach is applied in meta flushing, and meta data
> > > >>>>> integrity is guaranteed, 'make test T=3Dqcow2/040' covers this =
kind of
> > > >>>>> test, and only cluster leak is reported during this test.
> > > >>>>>
> > > >>>>> The performance data looks much better compared with qemu-nbd, =
see
> > > >>>>> details in commit log[1], README[5] and STATUS[6]. And the test=
 covers both
> > > >>>>> empty image and pre-allocated image, for example of pre-allocat=
ed qcow2
> > > >>>>> image(8GB):
> > > >>>>>
> > > >>>>> - qemu-nbd (make test T=3Dqcow2/002)
> > > >>>>
> > > >>>> Single queue?
> > > >>>
> > > >>> Yeah.
> > > >>>
> > > >>>>
> > > >>>>>     randwrite(4k): jobs 1, iops 24605
> > > >>>>>     randread(4k): jobs 1, iops 30938
> > > >>>>>     randrw(4k): jobs 1, iops read 13981 write 14001
> > > >>>>>     rw(512k): jobs 1, iops read 724 write 728
> > > >>>>
> > > >>>> Please try qemu-storage-daemon's VDUSE export type as well. The
> > > >>>> command-line should be similar to this:
> > > >>>>
> > > >>>>   # modprobe virtio_vdpa # attaches vDPA devices to host kernel
> > > >>>
> > > >>> Not found virtio_vdpa module even though I enabled all the follow=
ing
> > > >>> options:
> > > >>>
> > > >>>         --- vDPA drivers
> > > >>>           <M>   vDPA device simulator core
> > > >>>           <M>     vDPA simulator for networking device
> > > >>>           <M>     vDPA simulator for block device
> > > >>>           <M>   VDUSE (vDPA Device in Userspace) support
> > > >>>           <M>   Intel IFC VF vDPA driver
> > > >>>           <M>   Virtio PCI bridge vDPA driver
> > > >>>           <M>   vDPA driver for Alibaba ENI
> > > >>>
> > > >>> BTW, my test environment is VM and the shared data is done in VM =
too, and
> > > >>> can virtio_vdpa be used inside VM?
> > > >>
> > > >> I hope Xie Yongji can help explain how to benchmark VDUSE.
> > > >>
> > > >> virtio_vdpa is available inside guests too. Please check that
> > > >> VIRTIO_VDPA ("vDPA driver for virtio devices") is enabled in "Virt=
io
> > > >> drivers" menu.
> > > >>
> > > >>>
> > > >>>>   # modprobe vduse
> > > >>>>   # qemu-storage-daemon \
> > > >>>>       --blockdev file,filename=3Dtest.qcow2,cache.direct=3Dof|of=
f,aio=3Dnative,node-name=3Dfile \
> > > >>>>       --blockdev qcow2,file=3Dfile,node-name=3Dqcow2 \
> > > >>>>       --object iothread,id=3Diothread0 \
> > > >>>>       --export vduse-blk,id=3Dvduse0,name=3Dvduse0,num-queues=3D=
$(nproc),node-name=3Dqcow2,writable=3Don,iothread=3Diothread0
> > > >>>>   # vdpa dev add name vduse0 mgmtdev vduse
> > > >>>>
> > > >>>> A virtio-blk device should appear and xfstests can be run on it
> > > >>>> (typically /dev/vda unless you already have other virtio-blk dev=
ices).
> > > >>>>
> > > >>>> Afterwards you can destroy the device using:
> > > >>>>
> > > >>>>   # vdpa dev del vduse0
> > > >>>>
> > > >>>>>
> > > >>>>> - ublk-qcow2 (make test T=3Dqcow2/022)
> > > >>>>
> > > >>>> There are a lot of other factors not directly related to NBD vs =
ublk. In
> > > >>>> order to get an apples-to-apples comparison with qemu-* a ublk e=
xport
> > > >>>> type is needed in qemu-storage-daemon. That way only the differe=
nce is
> > > >>>> the ublk interface and the rest of the code path is identical, m=
aking it
> > > >>>> possible to compare NBD, VDUSE, ublk, etc more precisely.
> > > >>>
> > > >>> Maybe not true.
> > > >>>
> > > >>> ublk-qcow2 uses io_uring to handle all backend IO(include meta IO=
) completely,
> > > >>> and so far single io_uring/pthread is for handling all qcow2 IOs =
and IO
> > > >>> command.
> > > >>
> > > >> qemu-nbd doesn't use io_uring to handle the backend IO, so we don't
> > > >
> > > > I tried to use it via --aio=3Dio_uring for setting up qemu-nbd, but=
 not succeed.
> > > >
> > > >> know whether the benchmark demonstrates that ublk is faster than N=
BD,
> > > >> that the ublk-qcow2 implementation is faster than qemu-nbd's qcow2,
> > > >> whether there are miscellaneous implementation differences between
> > > >> ublk-qcow2 and qemu-nbd (like using the same io_uring context for =
both
> > > >> ublk and backend IO), or something else.
> > > >
> > > > The theory shouldn't be too complicated:
> > > >
> > > > 1) io uring passthough(pt) communication is fast than socket, and i=
o command
> > > > is carried over io_uring pt commands, and should be fast than virio
> > > > communication too.
> > > >
> > > > 2) io uring io handling is fast than libaio which is taken in the
> > > > test on qemu-nbd, and all qcow2 backend io(include meta io) is hand=
led
> > > > by io_uring.
> > > >
> > > > https://github.com/ming1/ubdsrv/blob/master/tests/common/qcow2_comm=
on
> > > >
> > > > 3) ublk uses one single io_uring to handle all io commands and qcow2
> > > > backend IOs, so batching handling is common, and it is easy to see
> > > > dozens of IOs/io commands handled in single syscall, or even more.
> > > >
> > > >>
> > > >> I'm suggesting measuring changes to just 1 variable at a time.
> > > >> Otherwise it's hard to reach a conclusion about the root cause of =
the
> > > >> performance difference. Let's learn why ublk-qcow2 performs well.
> > > >
> > > > Turns out the latest Fedora 37-beta doesn't support vdpa yet, so I =
built
> > > > qemu from the latest github tree, and finally it starts to work. An=
d test kernel
> > > > is v6.0 release.
> > > >
> > > > Follows the test result, and all three devices are setup as single
> > > > queue, and all tests are run in single job, still done in one VM, a=
nd
> > > > the test images are stored on XFS/virito-scsi backed SSD.
> > > >
> > > > The 1st group tests all three block device which is backed by empty
> > > > qcow2 image.
> > > >
> > > > The 2nd group tests all the three block devices backed by pre-alloc=
ated
> > > > qcow2 image.
> > > >
> > > > Except for big sequential IO(512K), there is still not small gap be=
tween
> > > > vdpa-virtio-blk and ublk.
> > > >
> > > > 1. run fio on block device over empty qcow2 image
> > > > 1) qemu-nbd
> > > > running qcow2/001
> > > > run perf test on empty qcow2 image via nbd
> > > >       fio (nbd(/mnt/data/ublk_null_8G_nYbgF.qcow2), libaio, bs 4k, =
dio, hw queues:1)...
> > > >       randwrite: jobs 1, iops 8549
> > > >       randread: jobs 1, iops 34829
> > > >       randrw: jobs 1, iops read 11363 write 11333
> > > >       rw(512k): jobs 1, iops read 590 write 597
> > > >
> > > >
> > > > 2) ublk-qcow2
> > > > running qcow2/021
> > > > run perf test on empty qcow2 image via ublk
> > > >       fio (ublk/qcow2( -f /mnt/data/ublk_null_8G_s761j.qcow2), liba=
io, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > > >       randwrite: jobs 1, iops 16086
> > > >       randread: jobs 1, iops 172720
> > > >       randrw: jobs 1, iops read 35760 write 35702
> > > >       rw(512k): jobs 1, iops read 1140 write 1149
> > > >
> > > > 3) vdpa-virtio-blk
> > > > running debug/test_dev
> > > > run io test on specified device
> > > >       fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)...
> > > >       randwrite: jobs 1, iops 8626
> > > >       randread: jobs 1, iops 126118
> > > >       randrw: jobs 1, iops read 17698 write 17665
> > > >       rw(512k): jobs 1, iops read 1023 write 1031
> > > >
> > > >
> > > > 2. run fio on block device over pre-allocated qcow2 image
> > > > 1) qemu-nbd
> > > > running qcow2/002
> > > > run perf test on pre-allocated qcow2 image via nbd
> > > >       fio (nbd(/mnt/data/ublk_data_8G_sc0SB.qcow2), libaio, bs 4k, =
dio, hw queues:1)...
> > > >       randwrite: jobs 1, iops 21439
> > > >       randread: jobs 1, iops 30336
> > > >       randrw: jobs 1, iops read 11476 write 11449
> > > >       rw(512k): jobs 1, iops read 718 write 722
> > > >
> > > > 2) ublk-qcow2
> > > > running qcow2/022
> > > > run perf test on pre-allocated qcow2 image via ublk
> > > >       fio (ublk/qcow2( -f /mnt/data/ublk_data_8G_yZiaJ.qcow2), liba=
io, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > > >       randwrite: jobs 1, iops 98757
> > > >       randread: jobs 1, iops 110246
> > > >       randrw: jobs 1, iops read 47229 write 47161
> > > >       rw(512k): jobs 1, iops read 1416 write 1427
> > > >
> > > > 3) vdpa-virtio-blk
> > > > running debug/test_dev
> > > > run io test on specified device
> > > >       fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)...
> > > >       randwrite: jobs 1, iops 47317
> > > >       randread: jobs 1, iops 74092
> > > >       randrw: jobs 1, iops read 27196 write 27234
> > > >       rw(512k): jobs 1, iops read 1447 write 1458
> > > >
> > > >
> > >
> > > Hi All,
> > >
> > > We are interested in VDUSE vs UBLK, too. And I have tested them with =
nullblk backend.
> > > Let me share some results here.
> > >
> > > I setup UBLK with:
> > >   ublk add -t loop -f /dev/nullb0 -d QUEUE_DEPTH -q NR_QUEUE
> > >
> > > I setup VDUSE with:
> > >   qemu-storage-daemon \
> > >        --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.sock,server=
=3Don,wait=3Doff \
> > >        --monitor chardev=3Dcharmonitor \
> > >        --blockdev driver=3Dhost_device,cache.direct=3Don,filename=3D/=
dev/nullb0,node-name=3Ddisk0 \
> > >        --export vduse-blk,id=3Dtest,node-name=3Ddisk0,name=3Dvduse_te=
st,writable=3Don,num-queues=3DNR_QUEUE,queue-size=3DQUEUE_DEPTH
> > >
> > > Here QUEUE_DEPTH is 1, 32 or 128 and NR_QUEUE is 1 or 4.
> > >
> > > Note:
> > > (1) VDUSE requires QUEUE_DEPTH >=3D 2. I cannot setup QUEUE_DEPTH to =
1.
> > > (2) I use qemu 7.1.0-rc3. It supports vduse-blk.
> > > (3) I do not use ublk null target so that the test is fair.
> > > (4) I setup fio with direct=3D1, bs=3D4k.
> > >
> > > ------------------------------
> > > 1 job 1 iodepth, lat=EF=BC=88usec)
> > >                 vduse   ublk
> > > seq-read        22.55   11.15
> > > rand-read       22.49   11.17
> > > seq-write       25.67   10.25
> > > rand-write      24.13   10.16
> >
> > Thanks for sharing. Any idea what the bottlenecks are for vduse and ubl=
k?
> >
>=20
> I think one reason for the latency gap of sync I/O is that vduse uses
> workqueue in the I/O completion path but ublk doesn't.
>=20
> And one bottleneck for the async I/O in vduse is that vduse will do
> memcpy inside the critical section of virtqueue's spinlock in the
> virtio-blk driver. That will hurt the performance heavily when
> virtio_queue_rq() and virtblk_done() run concurrently. And it can be
> mitigated by the advance DMA mapping feature [1] or irq binding
> support [2].
>=20
> [1] https://lwn.net/Articles/886029/
> [2] https://www.spinics.net/lists/kvm/msg236244.html

Thanks!

Stefan

--6LmWUr7zOCud/8Xx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmNINo8ACgkQnKSrs4Gr
c8igXwgAhCjzhmL3oO5vNnRpRAsXBnH9HAmNVDaWOe+LN3l043ZTqL32uLVPz/la
R3OXf82bSy8fWZ/gXTqEIEKDnBBucNt7kOLv8vJh9aEY6a00pX/mGbGmd9A/NwBx
tpcj9DhxQ54aOIWBhpMjFr4j2pX4fgmff1EAVlagXkJOWwLcsMCkZDV5wUSmkwaE
n+ZVFwWslCgBdNdKGgyHqKhtssmSRhTVHO6RrunibG8n4Ipv/NsTQpPQrbp1elpK
TuywI9zSZdDvYD0SjLvpQ5AhOXBvD8OdrYmVt692zCss1Khy7U4U+ucuFzTRodgu
0G9M/6FeqzpvgmRPZmX7cTH5OAapVA==
=51po
-----END PGP SIGNATURE-----

--6LmWUr7zOCud/8Xx--

