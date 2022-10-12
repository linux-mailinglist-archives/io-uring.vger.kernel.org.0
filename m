Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204F25FC729
	for <lists+io-uring@lfdr.de>; Wed, 12 Oct 2022 16:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiJLOWb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Oct 2022 10:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJLOWa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Oct 2022 10:22:30 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE9BCAE58;
        Wed, 12 Oct 2022 07:22:28 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-358bf076f1fso157055817b3.9;
        Wed, 12 Oct 2022 07:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QxzSr1Szho0p7M7vHyOqsR+IqEkQH6pC6p2Puz8LmVw=;
        b=WZWIElW7Asloukx7iiEHkkre0aCBTS6CZ2VHy1k2JRaqpwQN7+HfSBmEmjkRwqebS/
         TNb1nhgdATf+PlrwOmYj7EKWeUrtKlkaRfKqt4vk/u0FZLNXdKwi1hMOJCaOFONuSSZN
         wkawqGbOdCTuU29SV8FdHIkIrLFWiQd3AHjUsRs3Kx97OQCtWydsFk5fgDPZsur1zuF/
         UuTB4EQ6NqOCMgfT9fTETaiV9iHEQKAlC9cA581WrquyRtXwnbN1bhXvIThBzr4D6nnL
         rMnOIpPZmrD8ClDqoSRwwWFCnjXiSUHGU8iR7VKGBZnTGZ+jJ1o7AVq67b81Yz09wGOP
         3ARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QxzSr1Szho0p7M7vHyOqsR+IqEkQH6pC6p2Puz8LmVw=;
        b=UeBwz3132V+V7NirLMpY7kvxd4PbDS/6nkrtNKTQFW48mQRIIY2nEH68SFq3yFeqte
         t1IoRMHeCQGXX1KkD2xmaA9cfoG5CTevDMvjGE++71cuxUhimb+yI71JR+P9JDIX2j31
         ILQdEyEwgOvGqKtCseBn4YxO/nGOn0fOcJoh9POmrHbIT/D7tAefc8kRAHWx7YMJut0K
         mJ+U4RPzYcEidF2ydDxr1cSrd+d9SjNB4paLN0oh9/iv+PYFbCGK4ap52+QZgULTeTuu
         ddT8ma1pB/Zq73Ab+f8CiUZxnrJglntxk/WtwgxGyQR6dg9qPRQ47NRf4K+WggBGs0BH
         DS2Q==
X-Gm-Message-State: ACrzQf2aDRVUdFNyBWxsKhNaN9mfVNepw0NubJmenUoofvEbuWU/RrnJ
        zkx5KD24L5IuyR9/DuXFlmVtmv7vacX3M6BFXdM=
X-Google-Smtp-Source: AMsMyM42CYWglGVVOeRwr1o/XqqvGMEMnqHJEPU2x3AC4sj1In/oZ2I9VJjiLtR2S6bWmr562dIJvbQT7psfnDAaDHs=
X-Received: by 2002:a0d:ebc1:0:b0:360:5a77:4d78 with SMTP id
 u184-20020a0debc1000000b003605a774d78mr23381474ywe.336.1665584547832; Wed, 12
 Oct 2022 07:22:27 -0700 (PDT)
MIME-Version: 1.0
References: <Yza1u1KfKa7ycQm0@T590> <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590> <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <Yz0FrzJVZTqlQtJ5@T590> <50827796-af93-4af5-4121-dc13c31a67fc@linux.alibaba.com>
In-Reply-To: <50827796-af93-4af5-4121-dc13c31a67fc@linux.alibaba.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Wed, 12 Oct 2022 10:22:15 -0400
Message-ID: <CAJSP0QXW9TmuvJpQPRF-AF01aW79jH8tnkHPEf+do5vQ1crGFA@mail.gmail.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     Ming Lei <tom.leiming@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Xie Yongji <xieyongji@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 8 Oct 2022 at 04:43, Ziyang Zhang <ZiyangZhang@linux.alibaba.com> w=
rote:
>
> On 2022/10/5 12:18, Ming Lei wrote:
> > On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wrote:
> >> On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail.com> wrote:
> >>>
> >>> On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnoczi wrote:
> >>>> On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> >>>>> ublk-qcow2 is available now.
> >>>>
> >>>> Cool, thanks for sharing!
> >>>>
> >>>>>
> >>>>> So far it provides basic read/write function, and compression and s=
napshot
> >>>>> aren't supported yet. The target/backend implementation is complete=
ly
> >>>>> based on io_uring, and share the same io_uring with ublk IO command
> >>>>> handler, just like what ublk-loop does.
> >>>>>
> >>>>> Follows the main motivations of ublk-qcow2:
> >>>>>
> >>>>> - building one complicated target from scratch helps libublksrv API=
s/functions
> >>>>>   become mature/stable more quickly, since qcow2 is complicated and=
 needs more
> >>>>>   requirement from libublksrv compared with other simple ones(loop,=
 null)
> >>>>>
> >>>>> - there are several attempts of implementing qcow2 driver in kernel=
, such as
> >>>>>   ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], =
so ublk-qcow2
> >>>>>   might useful be for covering requirement in this field
> >>>>>
> >>>>> - performance comparison with qemu-nbd, and it was my 1st thought t=
o evaluate
> >>>>>   performance of ublk/io_uring backend by writing one ublk-qcow2 si=
nce ublksrv
> >>>>>   is started
> >>>>>
> >>>>> - help to abstract common building block or design pattern for writ=
ing new ublk
> >>>>>   target/backend
> >>>>>
> >>>>> So far it basically passes xfstest(XFS) test by using ublk-qcow2 bl=
ock
> >>>>> device as TEST_DEV, and kernel building workload is verified too. A=
lso
> >>>>> soft update approach is applied in meta flushing, and meta data
> >>>>> integrity is guaranteed, 'make test T=3Dqcow2/040' covers this kind=
 of
> >>>>> test, and only cluster leak is reported during this test.
> >>>>>
> >>>>> The performance data looks much better compared with qemu-nbd, see
> >>>>> details in commit log[1], README[5] and STATUS[6]. And the test cov=
ers both
> >>>>> empty image and pre-allocated image, for example of pre-allocated q=
cow2
> >>>>> image(8GB):
> >>>>>
> >>>>> - qemu-nbd (make test T=3Dqcow2/002)
> >>>>
> >>>> Single queue?
> >>>
> >>> Yeah.
> >>>
> >>>>
> >>>>>     randwrite(4k): jobs 1, iops 24605
> >>>>>     randread(4k): jobs 1, iops 30938
> >>>>>     randrw(4k): jobs 1, iops read 13981 write 14001
> >>>>>     rw(512k): jobs 1, iops read 724 write 728
> >>>>
> >>>> Please try qemu-storage-daemon's VDUSE export type as well. The
> >>>> command-line should be similar to this:
> >>>>
> >>>>   # modprobe virtio_vdpa # attaches vDPA devices to host kernel
> >>>
> >>> Not found virtio_vdpa module even though I enabled all the following
> >>> options:
> >>>
> >>>         --- vDPA drivers
> >>>           <M>   vDPA device simulator core
> >>>           <M>     vDPA simulator for networking device
> >>>           <M>     vDPA simulator for block device
> >>>           <M>   VDUSE (vDPA Device in Userspace) support
> >>>           <M>   Intel IFC VF vDPA driver
> >>>           <M>   Virtio PCI bridge vDPA driver
> >>>           <M>   vDPA driver for Alibaba ENI
> >>>
> >>> BTW, my test environment is VM and the shared data is done in VM too,=
 and
> >>> can virtio_vdpa be used inside VM?
> >>
> >> I hope Xie Yongji can help explain how to benchmark VDUSE.
> >>
> >> virtio_vdpa is available inside guests too. Please check that
> >> VIRTIO_VDPA ("vDPA driver for virtio devices") is enabled in "Virtio
> >> drivers" menu.
> >>
> >>>
> >>>>   # modprobe vduse
> >>>>   # qemu-storage-daemon \
> >>>>       --blockdev file,filename=3Dtest.qcow2,cache.direct=3Dof|off,ai=
o=3Dnative,node-name=3Dfile \
> >>>>       --blockdev qcow2,file=3Dfile,node-name=3Dqcow2 \
> >>>>       --object iothread,id=3Diothread0 \
> >>>>       --export vduse-blk,id=3Dvduse0,name=3Dvduse0,num-queues=3D$(np=
roc),node-name=3Dqcow2,writable=3Don,iothread=3Diothread0
> >>>>   # vdpa dev add name vduse0 mgmtdev vduse
> >>>>
> >>>> A virtio-blk device should appear and xfstests can be run on it
> >>>> (typically /dev/vda unless you already have other virtio-blk devices=
).
> >>>>
> >>>> Afterwards you can destroy the device using:
> >>>>
> >>>>   # vdpa dev del vduse0
> >>>>
> >>>>>
> >>>>> - ublk-qcow2 (make test T=3Dqcow2/022)
> >>>>
> >>>> There are a lot of other factors not directly related to NBD vs ublk=
. In
> >>>> order to get an apples-to-apples comparison with qemu-* a ublk expor=
t
> >>>> type is needed in qemu-storage-daemon. That way only the difference =
is
> >>>> the ublk interface and the rest of the code path is identical, makin=
g it
> >>>> possible to compare NBD, VDUSE, ublk, etc more precisely.
> >>>
> >>> Maybe not true.
> >>>
> >>> ublk-qcow2 uses io_uring to handle all backend IO(include meta IO) co=
mpletely,
> >>> and so far single io_uring/pthread is for handling all qcow2 IOs and =
IO
> >>> command.
> >>
> >> qemu-nbd doesn't use io_uring to handle the backend IO, so we don't
> >
> > I tried to use it via --aio=3Dio_uring for setting up qemu-nbd, but not=
 succeed.
> >
> >> know whether the benchmark demonstrates that ublk is faster than NBD,
> >> that the ublk-qcow2 implementation is faster than qemu-nbd's qcow2,
> >> whether there are miscellaneous implementation differences between
> >> ublk-qcow2 and qemu-nbd (like using the same io_uring context for both
> >> ublk and backend IO), or something else.
> >
> > The theory shouldn't be too complicated:
> >
> > 1) io uring passthough(pt) communication is fast than socket, and io co=
mmand
> > is carried over io_uring pt commands, and should be fast than virio
> > communication too.
> >
> > 2) io uring io handling is fast than libaio which is taken in the
> > test on qemu-nbd, and all qcow2 backend io(include meta io) is handled
> > by io_uring.
> >
> > https://github.com/ming1/ubdsrv/blob/master/tests/common/qcow2_common
> >
> > 3) ublk uses one single io_uring to handle all io commands and qcow2
> > backend IOs, so batching handling is common, and it is easy to see
> > dozens of IOs/io commands handled in single syscall, or even more.
> >
> >>
> >> I'm suggesting measuring changes to just 1 variable at a time.
> >> Otherwise it's hard to reach a conclusion about the root cause of the
> >> performance difference. Let's learn why ublk-qcow2 performs well.
> >
> > Turns out the latest Fedora 37-beta doesn't support vdpa yet, so I buil=
t
> > qemu from the latest github tree, and finally it starts to work. And te=
st kernel
> > is v6.0 release.
> >
> > Follows the test result, and all three devices are setup as single
> > queue, and all tests are run in single job, still done in one VM, and
> > the test images are stored on XFS/virito-scsi backed SSD.
> >
> > The 1st group tests all three block device which is backed by empty
> > qcow2 image.
> >
> > The 2nd group tests all the three block devices backed by pre-allocated
> > qcow2 image.
> >
> > Except for big sequential IO(512K), there is still not small gap betwee=
n
> > vdpa-virtio-blk and ublk.
> >
> > 1. run fio on block device over empty qcow2 image
> > 1) qemu-nbd
> > running qcow2/001
> > run perf test on empty qcow2 image via nbd
> >       fio (nbd(/mnt/data/ublk_null_8G_nYbgF.qcow2), libaio, bs 4k, dio,=
 hw queues:1)...
> >       randwrite: jobs 1, iops 8549
> >       randread: jobs 1, iops 34829
> >       randrw: jobs 1, iops read 11363 write 11333
> >       rw(512k): jobs 1, iops read 590 write 597
> >
> >
> > 2) ublk-qcow2
> > running qcow2/021
> > run perf test on empty qcow2 image via ublk
> >       fio (ublk/qcow2( -f /mnt/data/ublk_null_8G_s761j.qcow2), libaio, =
bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> >       randwrite: jobs 1, iops 16086
> >       randread: jobs 1, iops 172720
> >       randrw: jobs 1, iops read 35760 write 35702
> >       rw(512k): jobs 1, iops read 1140 write 1149
> >
> > 3) vdpa-virtio-blk
> > running debug/test_dev
> > run io test on specified device
> >       fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)...
> >       randwrite: jobs 1, iops 8626
> >       randread: jobs 1, iops 126118
> >       randrw: jobs 1, iops read 17698 write 17665
> >       rw(512k): jobs 1, iops read 1023 write 1031
> >
> >
> > 2. run fio on block device over pre-allocated qcow2 image
> > 1) qemu-nbd
> > running qcow2/002
> > run perf test on pre-allocated qcow2 image via nbd
> >       fio (nbd(/mnt/data/ublk_data_8G_sc0SB.qcow2), libaio, bs 4k, dio,=
 hw queues:1)...
> >       randwrite: jobs 1, iops 21439
> >       randread: jobs 1, iops 30336
> >       randrw: jobs 1, iops read 11476 write 11449
> >       rw(512k): jobs 1, iops read 718 write 722
> >
> > 2) ublk-qcow2
> > running qcow2/022
> > run perf test on pre-allocated qcow2 image via ublk
> >       fio (ublk/qcow2( -f /mnt/data/ublk_data_8G_yZiaJ.qcow2), libaio, =
bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> >       randwrite: jobs 1, iops 98757
> >       randread: jobs 1, iops 110246
> >       randrw: jobs 1, iops read 47229 write 47161
> >       rw(512k): jobs 1, iops read 1416 write 1427
> >
> > 3) vdpa-virtio-blk
> > running debug/test_dev
> > run io test on specified device
> >       fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)...
> >       randwrite: jobs 1, iops 47317
> >       randread: jobs 1, iops 74092
> >       randrw: jobs 1, iops read 27196 write 27234
> >       rw(512k): jobs 1, iops read 1447 write 1458
> >
> >
>
> Hi All,
>
> We are interested in VDUSE vs UBLK, too. And I have tested them with null=
blk backend.
> Let me share some results here.
>
> I setup UBLK with:
>   ublk add -t loop -f /dev/nullb0 -d QUEUE_DEPTH -q NR_QUEUE
>
> I setup VDUSE with:
>   qemu-storage-daemon \
>        --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.sock,server=3Don=
,wait=3Doff \
>        --monitor chardev=3Dcharmonitor \
>        --blockdev driver=3Dhost_device,cache.direct=3Don,filename=3D/dev/=
nullb0,node-name=3Ddisk0 \
>        --export vduse-blk,id=3Dtest,node-name=3Ddisk0,name=3Dvduse_test,w=
ritable=3Don,num-queues=3DNR_QUEUE,queue-size=3DQUEUE_DEPTH
>
> Here QUEUE_DEPTH is 1, 32 or 128 and NR_QUEUE is 1 or 4.
>
> Note:
> (1) VDUSE requires QUEUE_DEPTH >=3D 2. I cannot setup QUEUE_DEPTH to 1.
> (2) I use qemu 7.1.0-rc3. It supports vduse-blk.
> (3) I do not use ublk null target so that the test is fair.
> (4) I setup fio with direct=3D1, bs=3D4k.
>
> ------------------------------
> 1 job 1 iodepth, lat=EF=BC=88usec)
>                 vduse   ublk
> seq-read        22.55   11.15
> rand-read       22.49   11.17
> seq-write       25.67   10.25
> rand-write      24.13   10.16

Thanks for sharing. Any idea what the bottlenecks are for vduse and ublk?

Stefan

>
> ------------------------------
> 1 job 32 iodepth, iops=EF=BC=88k)
>                 vduse   ublk
> seq-read        166     207
> rand-read       150     204
> seq-write       131     359
> rand-write      129     363
>
> ------------------------------
> 4job 128 iodepth, iops (k)
>
>                 vduse   ublk
> seq-read        318     984
> rand-read       307     929
> seq-write       221     924
> rand-write      217     917
>
> Regards,
> Zhang
