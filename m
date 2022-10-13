Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDB15FD522
	for <lists+io-uring@lfdr.de>; Thu, 13 Oct 2022 08:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiJMGsU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Oct 2022 02:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiJMGsT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Oct 2022 02:48:19 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21470141108
        for <io-uring@vger.kernel.org>; Wed, 12 Oct 2022 23:48:17 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ot12so1877514ejb.1
        for <io-uring@vger.kernel.org>; Wed, 12 Oct 2022 23:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YG7DLKEULEaHW9XJY/mj4Ksv/+si3ZrbapEr0+c+dK8=;
        b=7dW1XwxIDVKi7BjxTu3xFZV/0aSW94uoeP/JEL+sOCBTA7hJRqXPOFnDm+JH+MLLGh
         VS2/9fcz2C2zF0z8cODL2vduvHm7UHV9vYz50wP7FMr8pGoxUTen6rxrqjtzG5CUlBem
         V0CPiRqEQLIgjenUHwnCs9jAoZD4BDewzloo2f/HbM7XCmB2YC5IO/ue1RFw1Q3x7j/t
         GPzBbaTRkRYhPzmc7dFi1erI42jEQGAT3jW86TfMLdn2btWAu2v6XGP2zY0PsVk5xgLg
         gQzynjTxQkzKmZAKt9fpvBKVHbnD85xmdtVdeuIj1G7otbHvrzC7TE7J06sZR+nuQJ77
         QMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YG7DLKEULEaHW9XJY/mj4Ksv/+si3ZrbapEr0+c+dK8=;
        b=mbwZm7zalP/AdKzqa3lNzuEDqIGx/8hVOWxw8wtvVww/ypl+C+tVIMRz155UEcJftT
         J49+ICcHs9mVneMIxQ2hAt6punISA+S1Dj88m/YGrVWE7s/Xb/FPl4rJFZ+692j1WlqU
         wNQC9qORrCQrbvGwa5/NrQve4F0RwqHlhbBpDjgZYqNr77ARWPGe9hQlEQK5Nq3OgGCX
         FFeg+JXORwj0H80e6D6lonDgC9G7kGW5jBAOX8SdSrbzbppI/qyABXrOHzu6bbT85V3T
         7cxLC6LDsWwQ/KoQ5VUAQ90yQoGzhysunMtm+oNt4PZsEEaWF7EFzN+pLT+u2yKkXTDO
         8N8Q==
X-Gm-Message-State: ACrzQf2sruW8R+gFSSc0QUmlvHp6V82TngdQOROVBnnjvWCmS2HS65Uq
        MeOc+03k8nyjANZXolRGH+mpmMs+fPoiGFifF0NI
X-Google-Smtp-Source: AMsMyM7X5dDoP8tgtodKjcru3ynn7UNOe2+DW/xbx++32ADbdarVbWpCvD+2ti/4EU3NW+lASLNyNT+FHr5hqMphe5w=
X-Received: by 2002:a17:907:6090:b0:78d:1b32:bf81 with SMTP id
 ht16-20020a170907609000b0078d1b32bf81mr26514831ejc.141.1665643695558; Wed, 12
 Oct 2022 23:48:15 -0700 (PDT)
MIME-Version: 1.0
References: <Yza1u1KfKa7ycQm0@T590> <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590> <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <Yz0FrzJVZTqlQtJ5@T590> <50827796-af93-4af5-4121-dc13c31a67fc@linux.alibaba.com>
 <CAJSP0QXW9TmuvJpQPRF-AF01aW79jH8tnkHPEf+do5vQ1crGFA@mail.gmail.com>
In-Reply-To: <CAJSP0QXW9TmuvJpQPRF-AF01aW79jH8tnkHPEf+do5vQ1crGFA@mail.gmail.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 13 Oct 2022 14:48:04 +0800
Message-ID: <CACycT3ufcN+a_wtWe6ioOWZUCak-JmcMgSa=rqeEsS63_HqSog@mail.gmail.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <tom.leiming@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Oct 12, 2022 at 10:22 PM Stefan Hajnoczi <stefanha@gmail.com> wrote=
:
>
> On Sat, 8 Oct 2022 at 04:43, Ziyang Zhang <ZiyangZhang@linux.alibaba.com>=
 wrote:
> >
> > On 2022/10/5 12:18, Ming Lei wrote:
> > > On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wrote:
> > >> On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail.com> wrote:
> > >>>
> > >>> On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnoczi wrote:
> > >>>> On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > >>>>> ublk-qcow2 is available now.
> > >>>>
> > >>>> Cool, thanks for sharing!
> > >>>>
> > >>>>>
> > >>>>> So far it provides basic read/write function, and compression and=
 snapshot
> > >>>>> aren't supported yet. The target/backend implementation is comple=
tely
> > >>>>> based on io_uring, and share the same io_uring with ublk IO comma=
nd
> > >>>>> handler, just like what ublk-loop does.
> > >>>>>
> > >>>>> Follows the main motivations of ublk-qcow2:
> > >>>>>
> > >>>>> - building one complicated target from scratch helps libublksrv A=
PIs/functions
> > >>>>>   become mature/stable more quickly, since qcow2 is complicated a=
nd needs more
> > >>>>>   requirement from libublksrv compared with other simple ones(loo=
p, null)
> > >>>>>
> > >>>>> - there are several attempts of implementing qcow2 driver in kern=
el, such as
> > >>>>>   ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4]=
, so ublk-qcow2
> > >>>>>   might useful be for covering requirement in this field
> > >>>>>
> > >>>>> - performance comparison with qemu-nbd, and it was my 1st thought=
 to evaluate
> > >>>>>   performance of ublk/io_uring backend by writing one ublk-qcow2 =
since ublksrv
> > >>>>>   is started
> > >>>>>
> > >>>>> - help to abstract common building block or design pattern for wr=
iting new ublk
> > >>>>>   target/backend
> > >>>>>
> > >>>>> So far it basically passes xfstest(XFS) test by using ublk-qcow2 =
block
> > >>>>> device as TEST_DEV, and kernel building workload is verified too.=
 Also
> > >>>>> soft update approach is applied in meta flushing, and meta data
> > >>>>> integrity is guaranteed, 'make test T=3Dqcow2/040' covers this ki=
nd of
> > >>>>> test, and only cluster leak is reported during this test.
> > >>>>>
> > >>>>> The performance data looks much better compared with qemu-nbd, se=
e
> > >>>>> details in commit log[1], README[5] and STATUS[6]. And the test c=
overs both
> > >>>>> empty image and pre-allocated image, for example of pre-allocated=
 qcow2
> > >>>>> image(8GB):
> > >>>>>
> > >>>>> - qemu-nbd (make test T=3Dqcow2/002)
> > >>>>
> > >>>> Single queue?
> > >>>
> > >>> Yeah.
> > >>>
> > >>>>
> > >>>>>     randwrite(4k): jobs 1, iops 24605
> > >>>>>     randread(4k): jobs 1, iops 30938
> > >>>>>     randrw(4k): jobs 1, iops read 13981 write 14001
> > >>>>>     rw(512k): jobs 1, iops read 724 write 728
> > >>>>
> > >>>> Please try qemu-storage-daemon's VDUSE export type as well. The
> > >>>> command-line should be similar to this:
> > >>>>
> > >>>>   # modprobe virtio_vdpa # attaches vDPA devices to host kernel
> > >>>
> > >>> Not found virtio_vdpa module even though I enabled all the followin=
g
> > >>> options:
> > >>>
> > >>>         --- vDPA drivers
> > >>>           <M>   vDPA device simulator core
> > >>>           <M>     vDPA simulator for networking device
> > >>>           <M>     vDPA simulator for block device
> > >>>           <M>   VDUSE (vDPA Device in Userspace) support
> > >>>           <M>   Intel IFC VF vDPA driver
> > >>>           <M>   Virtio PCI bridge vDPA driver
> > >>>           <M>   vDPA driver for Alibaba ENI
> > >>>
> > >>> BTW, my test environment is VM and the shared data is done in VM to=
o, and
> > >>> can virtio_vdpa be used inside VM?
> > >>
> > >> I hope Xie Yongji can help explain how to benchmark VDUSE.
> > >>
> > >> virtio_vdpa is available inside guests too. Please check that
> > >> VIRTIO_VDPA ("vDPA driver for virtio devices") is enabled in "Virtio
> > >> drivers" menu.
> > >>
> > >>>
> > >>>>   # modprobe vduse
> > >>>>   # qemu-storage-daemon \
> > >>>>       --blockdev file,filename=3Dtest.qcow2,cache.direct=3Dof|off,=
aio=3Dnative,node-name=3Dfile \
> > >>>>       --blockdev qcow2,file=3Dfile,node-name=3Dqcow2 \
> > >>>>       --object iothread,id=3Diothread0 \
> > >>>>       --export vduse-blk,id=3Dvduse0,name=3Dvduse0,num-queues=3D$(=
nproc),node-name=3Dqcow2,writable=3Don,iothread=3Diothread0
> > >>>>   # vdpa dev add name vduse0 mgmtdev vduse
> > >>>>
> > >>>> A virtio-blk device should appear and xfstests can be run on it
> > >>>> (typically /dev/vda unless you already have other virtio-blk devic=
es).
> > >>>>
> > >>>> Afterwards you can destroy the device using:
> > >>>>
> > >>>>   # vdpa dev del vduse0
> > >>>>
> > >>>>>
> > >>>>> - ublk-qcow2 (make test T=3Dqcow2/022)
> > >>>>
> > >>>> There are a lot of other factors not directly related to NBD vs ub=
lk. In
> > >>>> order to get an apples-to-apples comparison with qemu-* a ublk exp=
ort
> > >>>> type is needed in qemu-storage-daemon. That way only the differenc=
e is
> > >>>> the ublk interface and the rest of the code path is identical, mak=
ing it
> > >>>> possible to compare NBD, VDUSE, ublk, etc more precisely.
> > >>>
> > >>> Maybe not true.
> > >>>
> > >>> ublk-qcow2 uses io_uring to handle all backend IO(include meta IO) =
completely,
> > >>> and so far single io_uring/pthread is for handling all qcow2 IOs an=
d IO
> > >>> command.
> > >>
> > >> qemu-nbd doesn't use io_uring to handle the backend IO, so we don't
> > >
> > > I tried to use it via --aio=3Dio_uring for setting up qemu-nbd, but n=
ot succeed.
> > >
> > >> know whether the benchmark demonstrates that ublk is faster than NBD=
,
> > >> that the ublk-qcow2 implementation is faster than qemu-nbd's qcow2,
> > >> whether there are miscellaneous implementation differences between
> > >> ublk-qcow2 and qemu-nbd (like using the same io_uring context for bo=
th
> > >> ublk and backend IO), or something else.
> > >
> > > The theory shouldn't be too complicated:
> > >
> > > 1) io uring passthough(pt) communication is fast than socket, and io =
command
> > > is carried over io_uring pt commands, and should be fast than virio
> > > communication too.
> > >
> > > 2) io uring io handling is fast than libaio which is taken in the
> > > test on qemu-nbd, and all qcow2 backend io(include meta io) is handle=
d
> > > by io_uring.
> > >
> > > https://github.com/ming1/ubdsrv/blob/master/tests/common/qcow2_common
> > >
> > > 3) ublk uses one single io_uring to handle all io commands and qcow2
> > > backend IOs, so batching handling is common, and it is easy to see
> > > dozens of IOs/io commands handled in single syscall, or even more.
> > >
> > >>
> > >> I'm suggesting measuring changes to just 1 variable at a time.
> > >> Otherwise it's hard to reach a conclusion about the root cause of th=
e
> > >> performance difference. Let's learn why ublk-qcow2 performs well.
> > >
> > > Turns out the latest Fedora 37-beta doesn't support vdpa yet, so I bu=
ilt
> > > qemu from the latest github tree, and finally it starts to work. And =
test kernel
> > > is v6.0 release.
> > >
> > > Follows the test result, and all three devices are setup as single
> > > queue, and all tests are run in single job, still done in one VM, and
> > > the test images are stored on XFS/virito-scsi backed SSD.
> > >
> > > The 1st group tests all three block device which is backed by empty
> > > qcow2 image.
> > >
> > > The 2nd group tests all the three block devices backed by pre-allocat=
ed
> > > qcow2 image.
> > >
> > > Except for big sequential IO(512K), there is still not small gap betw=
een
> > > vdpa-virtio-blk and ublk.
> > >
> > > 1. run fio on block device over empty qcow2 image
> > > 1) qemu-nbd
> > > running qcow2/001
> > > run perf test on empty qcow2 image via nbd
> > >       fio (nbd(/mnt/data/ublk_null_8G_nYbgF.qcow2), libaio, bs 4k, di=
o, hw queues:1)...
> > >       randwrite: jobs 1, iops 8549
> > >       randread: jobs 1, iops 34829
> > >       randrw: jobs 1, iops read 11363 write 11333
> > >       rw(512k): jobs 1, iops read 590 write 597
> > >
> > >
> > > 2) ublk-qcow2
> > > running qcow2/021
> > > run perf test on empty qcow2 image via ublk
> > >       fio (ublk/qcow2( -f /mnt/data/ublk_null_8G_s761j.qcow2), libaio=
, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > >       randwrite: jobs 1, iops 16086
> > >       randread: jobs 1, iops 172720
> > >       randrw: jobs 1, iops read 35760 write 35702
> > >       rw(512k): jobs 1, iops read 1140 write 1149
> > >
> > > 3) vdpa-virtio-blk
> > > running debug/test_dev
> > > run io test on specified device
> > >       fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)...
> > >       randwrite: jobs 1, iops 8626
> > >       randread: jobs 1, iops 126118
> > >       randrw: jobs 1, iops read 17698 write 17665
> > >       rw(512k): jobs 1, iops read 1023 write 1031
> > >
> > >
> > > 2. run fio on block device over pre-allocated qcow2 image
> > > 1) qemu-nbd
> > > running qcow2/002
> > > run perf test on pre-allocated qcow2 image via nbd
> > >       fio (nbd(/mnt/data/ublk_data_8G_sc0SB.qcow2), libaio, bs 4k, di=
o, hw queues:1)...
> > >       randwrite: jobs 1, iops 21439
> > >       randread: jobs 1, iops 30336
> > >       randrw: jobs 1, iops read 11476 write 11449
> > >       rw(512k): jobs 1, iops read 718 write 722
> > >
> > > 2) ublk-qcow2
> > > running qcow2/022
> > > run perf test on pre-allocated qcow2 image via ublk
> > >       fio (ublk/qcow2( -f /mnt/data/ublk_data_8G_yZiaJ.qcow2), libaio=
, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > >       randwrite: jobs 1, iops 98757
> > >       randread: jobs 1, iops 110246
> > >       randrw: jobs 1, iops read 47229 write 47161
> > >       rw(512k): jobs 1, iops read 1416 write 1427
> > >
> > > 3) vdpa-virtio-blk
> > > running debug/test_dev
> > > run io test on specified device
> > >       fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)...
> > >       randwrite: jobs 1, iops 47317
> > >       randread: jobs 1, iops 74092
> > >       randrw: jobs 1, iops read 27196 write 27234
> > >       rw(512k): jobs 1, iops read 1447 write 1458
> > >
> > >
> >
> > Hi All,
> >
> > We are interested in VDUSE vs UBLK, too. And I have tested them with nu=
llblk backend.
> > Let me share some results here.
> >
> > I setup UBLK with:
> >   ublk add -t loop -f /dev/nullb0 -d QUEUE_DEPTH -q NR_QUEUE
> >
> > I setup VDUSE with:
> >   qemu-storage-daemon \
> >        --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.sock,server=3D=
on,wait=3Doff \
> >        --monitor chardev=3Dcharmonitor \
> >        --blockdev driver=3Dhost_device,cache.direct=3Don,filename=3D/de=
v/nullb0,node-name=3Ddisk0 \
> >        --export vduse-blk,id=3Dtest,node-name=3Ddisk0,name=3Dvduse_test=
,writable=3Don,num-queues=3DNR_QUEUE,queue-size=3DQUEUE_DEPTH
> >
> > Here QUEUE_DEPTH is 1, 32 or 128 and NR_QUEUE is 1 or 4.
> >
> > Note:
> > (1) VDUSE requires QUEUE_DEPTH >=3D 2. I cannot setup QUEUE_DEPTH to 1.
> > (2) I use qemu 7.1.0-rc3. It supports vduse-blk.
> > (3) I do not use ublk null target so that the test is fair.
> > (4) I setup fio with direct=3D1, bs=3D4k.
> >
> > ------------------------------
> > 1 job 1 iodepth, lat=EF=BC=88usec)
> >                 vduse   ublk
> > seq-read        22.55   11.15
> > rand-read       22.49   11.17
> > seq-write       25.67   10.25
> > rand-write      24.13   10.16
>
> Thanks for sharing. Any idea what the bottlenecks are for vduse and ublk?
>

I think one reason for the latency gap of sync I/O is that vduse uses
workqueue in the I/O completion path but ublk doesn't.

And one bottleneck for the async I/O in vduse is that vduse will do
memcpy inside the critical section of virtqueue's spinlock in the
virtio-blk driver. That will hurt the performance heavily when
virtio_queue_rq() and virtblk_done() run concurrently. And it can be
mitigated by the advance DMA mapping feature [1] or irq binding
support [2].

[1] https://lwn.net/Articles/886029/
[2] https://www.spinics.net/lists/kvm/msg236244.html

Thanks,
Yongji

> Stefan
>
> >
> > ------------------------------
> > 1 job 32 iodepth, iops=EF=BC=88k)
> >                 vduse   ublk
> > seq-read        166     207
> > rand-read       150     204
> > seq-write       131     359
> > rand-write      129     363
> >
> > ------------------------------
> > 4job 128 iodepth, iops (k)
> >
> >                 vduse   ublk
> > seq-read        318     984
> > rand-read       307     929
> > seq-write       221     924
> > rand-write      217     917
> >
> > Regards,
> > Zhang
