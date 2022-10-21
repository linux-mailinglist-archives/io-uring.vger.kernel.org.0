Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C82606F77
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 07:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiJUFdd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 01:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiJUFdc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 01:33:32 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417E522C61D
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 22:33:28 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ud5so984078ejc.4
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 22:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QGugNrzxVvPhjD0W+lOvXY2M4elSfs9l3QZ1SL4TuZk=;
        b=RHmhqSMA1w5TKNqwyl4AN6sRBHN9ykhNjsqlDfojRu/vQ5Jzotw9TGJ5V9qRdAtGit
         Lo08Mh1kmczLGQImwYkExy6C3qfoq7lICh7ldOGLdCFoVMFBnRvosHd0sO0KGlIf9qJ/
         GZFZ45tAHUgUP/Y9wYhHV9Ca0D1yCYLRq9ivUhk9vXMHMQqf9ZIY9y42Y7AOO3A1SJ/J
         aASW5IgNew0FsQ5yWQiP2fxTv3lN0saOVGTE+8BH0AjOGa6a8AuMcF4EZbJi4zam3Oek
         xh+5wVoR6PIoRiKA+rM1SwEslxFPVssPH/cCJu+k4saNqSOe5QNOb+Qt3C6HQkugXDPr
         cgdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QGugNrzxVvPhjD0W+lOvXY2M4elSfs9l3QZ1SL4TuZk=;
        b=rhpS5acJDlewsas0AF+hHI1sKIfAm1gXtL0+AmZgleVVyqmW7neiwBX19OtgikEUar
         g4QGtK8aGlSZUh6hV6n0oThPtgTEL1xFNOhXtSN4U3A+2PUzcqVcxL4FaaBKJYINKSbm
         p5hLv27Y+YBrNzIQ19Qb2OFblKCKdsYNcIdXhAZbj6lxgi4nWR25SC0JGdkGPhoZ/v66
         chlWZcrr1ubLEz46ZZyaD5vMkuVgU4kSnS/Pv7bcLpAK9uYluOuv2a1MBWCzaqHMp+UI
         J6z//+WYtIMlQGus50Z76SAP45tIDRyT2SI2S73CniovoULgFRR9QHjnwS2abegh1hvW
         hjYA==
X-Gm-Message-State: ACrzQf1JBR3ijUBS3jWo60iwxijq03H0LUabAjstExhEFWa9eXBg/23o
        prGRuD0Ws1DcYfso7lKyOvpGWICaPWYkVBkJAzx7
X-Google-Smtp-Source: AMsMyM4yNLtNVZkvex1mqdTUQ+MV/Y5Emg7iAh1vNI5EEA1wMLVOX881W0NF3mEIz2m7btig/Y1hU6jLE0BXlOySc4U=
X-Received: by 2002:a17:906:36d1:b0:76c:a723:9445 with SMTP id
 b17-20020a17090636d100b0076ca7239445mr13272503ejc.548.1666330406630; Thu, 20
 Oct 2022 22:33:26 -0700 (PDT)
MIME-Version: 1.0
References: <Yza1u1KfKa7ycQm0@T590> <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590> <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <Yz0FrzJVZTqlQtJ5@T590> <50827796-af93-4af5-4121-dc13c31a67fc@linux.alibaba.com>
 <CAJSP0QXW9TmuvJpQPRF-AF01aW79jH8tnkHPEf+do5vQ1crGFA@mail.gmail.com>
 <CACycT3ufcN+a_wtWe6ioOWZUCak-JmcMgSa=rqeEsS63_HqSog@mail.gmail.com>
 <Y0lcmZTP5sr467z6@T590> <CACycT3u8yYUS-WnNzgHQtQFYuK-XcyffpFc35HVZzrCS7hH5Sg@mail.gmail.com>
 <Y05OzeC7wImts4p7@T590> <CACycT3sK1AzA4RH1ZfbstV3oax-oeBVtEz+sY+8scBU0=1x46g@mail.gmail.com>
 <CAJSP0QVevA0gvyGABAFSoMhBN9ydZqUJh4qJYgNbGeyRXL8AjA@mail.gmail.com>
In-Reply-To: <CAJSP0QVevA0gvyGABAFSoMhBN9ydZqUJh4qJYgNbGeyRXL8AjA@mail.gmail.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 21 Oct 2022 13:33:15 +0800
Message-ID: <CACycT3udzt0nyqweGbAsZB4LDQU=a7OSWKC8ZWieoBpsSfa2FQ@mail.gmail.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Ming Lei <tom.leiming@gmail.com>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Oct 18, 2022 at 10:54 PM Stefan Hajnoczi <stefanha@gmail.com> wrote=
:
>
> On Tue, 18 Oct 2022 at 09:17, Yongji Xie <xieyongji@bytedance.com> wrote:
> >
> > On Tue, Oct 18, 2022 at 2:59 PM Ming Lei <tom.leiming@gmail.com> wrote:
> > >
> > > On Mon, Oct 17, 2022 at 07:11:59PM +0800, Yongji Xie wrote:
> > > > On Fri, Oct 14, 2022 at 8:57 PM Ming Lei <tom.leiming@gmail.com> wr=
ote:
> > > > >
> > > > > On Thu, Oct 13, 2022 at 02:48:04PM +0800, Yongji Xie wrote:
> > > > > > On Wed, Oct 12, 2022 at 10:22 PM Stefan Hajnoczi <stefanha@gmai=
l.com> wrote:
> > > > > > >
> > > > > > > On Sat, 8 Oct 2022 at 04:43, Ziyang Zhang <ZiyangZhang@linux.=
alibaba.com> wrote:
> > > > > > > >
> > > > > > > > On 2022/10/5 12:18, Ming Lei wrote:
> > > > > > > > > On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi=
 wrote:
> > > > > > > > >> On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail=
.com> wrote:
> > > > > > > > >>>
> > > > > > > > >>> On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnoc=
zi wrote:
> > > > > > > > >>>> On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wro=
te:
> > > > > > > > >>>>> ublk-qcow2 is available now.
> > > > > > > > >>>>
> > > > > > > > >>>> Cool, thanks for sharing!
> > > > > > > > >>>>
> > > > > > > > >>>>>
> > > > > > > > >>>>> So far it provides basic read/write function, and com=
pression and snapshot
> > > > > > > > >>>>> aren't supported yet. The target/backend implementati=
on is completely
> > > > > > > > >>>>> based on io_uring, and share the same io_uring with u=
blk IO command
> > > > > > > > >>>>> handler, just like what ublk-loop does.
> > > > > > > > >>>>>
> > > > > > > > >>>>> Follows the main motivations of ublk-qcow2:
> > > > > > > > >>>>>
> > > > > > > > >>>>> - building one complicated target from scratch helps =
libublksrv APIs/functions
> > > > > > > > >>>>>   become mature/stable more quickly, since qcow2 is c=
omplicated and needs more
> > > > > > > > >>>>>   requirement from libublksrv compared with other sim=
ple ones(loop, null)
> > > > > > > > >>>>>
> > > > > > > > >>>>> - there are several attempts of implementing qcow2 dr=
iver in kernel, such as
> > > > > > > > >>>>>   ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qco=
w2(ro)`` [4], so ublk-qcow2
> > > > > > > > >>>>>   might useful be for covering requirement in this fi=
eld
> > > > > > > > >>>>>
> > > > > > > > >>>>> - performance comparison with qemu-nbd, and it was my=
 1st thought to evaluate
> > > > > > > > >>>>>   performance of ublk/io_uring backend by writing one=
 ublk-qcow2 since ublksrv
> > > > > > > > >>>>>   is started
> > > > > > > > >>>>>
> > > > > > > > >>>>> - help to abstract common building block or design pa=
ttern for writing new ublk
> > > > > > > > >>>>>   target/backend
> > > > > > > > >>>>>
> > > > > > > > >>>>> So far it basically passes xfstest(XFS) test by using=
 ublk-qcow2 block
> > > > > > > > >>>>> device as TEST_DEV, and kernel building workload is v=
erified too. Also
> > > > > > > > >>>>> soft update approach is applied in meta flushing, and=
 meta data
> > > > > > > > >>>>> integrity is guaranteed, 'make test T=3Dqcow2/040' co=
vers this kind of
> > > > > > > > >>>>> test, and only cluster leak is reported during this t=
est.
> > > > > > > > >>>>>
> > > > > > > > >>>>> The performance data looks much better compared with =
qemu-nbd, see
> > > > > > > > >>>>> details in commit log[1], README[5] and STATUS[6]. An=
d the test covers both
> > > > > > > > >>>>> empty image and pre-allocated image, for example of p=
re-allocated qcow2
> > > > > > > > >>>>> image(8GB):
> > > > > > > > >>>>>
> > > > > > > > >>>>> - qemu-nbd (make test T=3Dqcow2/002)
> > > > > > > > >>>>
> > > > > > > > >>>> Single queue?
> > > > > > > > >>>
> > > > > > > > >>> Yeah.
> > > > > > > > >>>
> > > > > > > > >>>>
> > > > > > > > >>>>>     randwrite(4k): jobs 1, iops 24605
> > > > > > > > >>>>>     randread(4k): jobs 1, iops 30938
> > > > > > > > >>>>>     randrw(4k): jobs 1, iops read 13981 write 14001
> > > > > > > > >>>>>     rw(512k): jobs 1, iops read 724 write 728
> > > > > > > > >>>>
> > > > > > > > >>>> Please try qemu-storage-daemon's VDUSE export type as =
well. The
> > > > > > > > >>>> command-line should be similar to this:
> > > > > > > > >>>>
> > > > > > > > >>>>   # modprobe virtio_vdpa # attaches vDPA devices to ho=
st kernel
> > > > > > > > >>>
> > > > > > > > >>> Not found virtio_vdpa module even though I enabled all =
the following
> > > > > > > > >>> options:
> > > > > > > > >>>
> > > > > > > > >>>         --- vDPA drivers
> > > > > > > > >>>           <M>   vDPA device simulator core
> > > > > > > > >>>           <M>     vDPA simulator for networking device
> > > > > > > > >>>           <M>     vDPA simulator for block device
> > > > > > > > >>>           <M>   VDUSE (vDPA Device in Userspace) suppor=
t
> > > > > > > > >>>           <M>   Intel IFC VF vDPA driver
> > > > > > > > >>>           <M>   Virtio PCI bridge vDPA driver
> > > > > > > > >>>           <M>   vDPA driver for Alibaba ENI
> > > > > > > > >>>
> > > > > > > > >>> BTW, my test environment is VM and the shared data is d=
one in VM too, and
> > > > > > > > >>> can virtio_vdpa be used inside VM?
> > > > > > > > >>
> > > > > > > > >> I hope Xie Yongji can help explain how to benchmark VDUS=
E.
> > > > > > > > >>
> > > > > > > > >> virtio_vdpa is available inside guests too. Please check=
 that
> > > > > > > > >> VIRTIO_VDPA ("vDPA driver for virtio devices") is enable=
d in "Virtio
> > > > > > > > >> drivers" menu.
> > > > > > > > >>
> > > > > > > > >>>
> > > > > > > > >>>>   # modprobe vduse
> > > > > > > > >>>>   # qemu-storage-daemon \
> > > > > > > > >>>>       --blockdev file,filename=3Dtest.qcow2,cache.dire=
ct=3Dof|off,aio=3Dnative,node-name=3Dfile \
> > > > > > > > >>>>       --blockdev qcow2,file=3Dfile,node-name=3Dqcow2 \
> > > > > > > > >>>>       --object iothread,id=3Diothread0 \
> > > > > > > > >>>>       --export vduse-blk,id=3Dvduse0,name=3Dvduse0,num=
-queues=3D$(nproc),node-name=3Dqcow2,writable=3Don,iothread=3Diothread0
> > > > > > > > >>>>   # vdpa dev add name vduse0 mgmtdev vduse
> > > > > > > > >>>>
> > > > > > > > >>>> A virtio-blk device should appear and xfstests can be =
run on it
> > > > > > > > >>>> (typically /dev/vda unless you already have other virt=
io-blk devices).
> > > > > > > > >>>>
> > > > > > > > >>>> Afterwards you can destroy the device using:
> > > > > > > > >>>>
> > > > > > > > >>>>   # vdpa dev del vduse0
> > > > > > > > >>>>
> > > > > > > > >>>>>
> > > > > > > > >>>>> - ublk-qcow2 (make test T=3Dqcow2/022)
> > > > > > > > >>>>
> > > > > > > > >>>> There are a lot of other factors not directly related =
to NBD vs ublk. In
> > > > > > > > >>>> order to get an apples-to-apples comparison with qemu-=
* a ublk export
> > > > > > > > >>>> type is needed in qemu-storage-daemon. That way only t=
he difference is
> > > > > > > > >>>> the ublk interface and the rest of the code path is id=
entical, making it
> > > > > > > > >>>> possible to compare NBD, VDUSE, ublk, etc more precise=
ly.
> > > > > > > > >>>
> > > > > > > > >>> Maybe not true.
> > > > > > > > >>>
> > > > > > > > >>> ublk-qcow2 uses io_uring to handle all backend IO(inclu=
de meta IO) completely,
> > > > > > > > >>> and so far single io_uring/pthread is for handling all =
qcow2 IOs and IO
> > > > > > > > >>> command.
> > > > > > > > >>
> > > > > > > > >> qemu-nbd doesn't use io_uring to handle the backend IO, =
so we don't
> > > > > > > > >
> > > > > > > > > I tried to use it via --aio=3Dio_uring for setting up qem=
u-nbd, but not succeed.
> > > > > > > > >
> > > > > > > > >> know whether the benchmark demonstrates that ublk is fas=
ter than NBD,
> > > > > > > > >> that the ublk-qcow2 implementation is faster than qemu-n=
bd's qcow2,
> > > > > > > > >> whether there are miscellaneous implementation differenc=
es between
> > > > > > > > >> ublk-qcow2 and qemu-nbd (like using the same io_uring co=
ntext for both
> > > > > > > > >> ublk and backend IO), or something else.
> > > > > > > > >
> > > > > > > > > The theory shouldn't be too complicated:
> > > > > > > > >
> > > > > > > > > 1) io uring passthough(pt) communication is fast than soc=
ket, and io command
> > > > > > > > > is carried over io_uring pt commands, and should be fast =
than virio
> > > > > > > > > communication too.
> > > > > > > > >
> > > > > > > > > 2) io uring io handling is fast than libaio which is take=
n in the
> > > > > > > > > test on qemu-nbd, and all qcow2 backend io(include meta i=
o) is handled
> > > > > > > > > by io_uring.
> > > > > > > > >
> > > > > > > > > https://github.com/ming1/ubdsrv/blob/master/tests/common/=
qcow2_common
> > > > > > > > >
> > > > > > > > > 3) ublk uses one single io_uring to handle all io command=
s and qcow2
> > > > > > > > > backend IOs, so batching handling is common, and it is ea=
sy to see
> > > > > > > > > dozens of IOs/io commands handled in single syscall, or e=
ven more.
> > > > > > > > >
> > > > > > > > >>
> > > > > > > > >> I'm suggesting measuring changes to just 1 variable at a=
 time.
> > > > > > > > >> Otherwise it's hard to reach a conclusion about the root=
 cause of the
> > > > > > > > >> performance difference. Let's learn why ublk-qcow2 perfo=
rms well.
> > > > > > > > >
> > > > > > > > > Turns out the latest Fedora 37-beta doesn't support vdpa =
yet, so I built
> > > > > > > > > qemu from the latest github tree, and finally it starts t=
o work. And test kernel
> > > > > > > > > is v6.0 release.
> > > > > > > > >
> > > > > > > > > Follows the test result, and all three devices are setup =
as single
> > > > > > > > > queue, and all tests are run in single job, still done in=
 one VM, and
> > > > > > > > > the test images are stored on XFS/virito-scsi backed SSD.
> > > > > > > > >
> > > > > > > > > The 1st group tests all three block device which is backe=
d by empty
> > > > > > > > > qcow2 image.
> > > > > > > > >
> > > > > > > > > The 2nd group tests all the three block devices backed by=
 pre-allocated
> > > > > > > > > qcow2 image.
> > > > > > > > >
> > > > > > > > > Except for big sequential IO(512K), there is still not sm=
all gap between
> > > > > > > > > vdpa-virtio-blk and ublk.
> > > > > > > > >
> > > > > > > > > 1. run fio on block device over empty qcow2 image
> > > > > > > > > 1) qemu-nbd
> > > > > > > > > running qcow2/001
> > > > > > > > > run perf test on empty qcow2 image via nbd
> > > > > > > > >       fio (nbd(/mnt/data/ublk_null_8G_nYbgF.qcow2), libai=
o, bs 4k, dio, hw queues:1)...
> > > > > > > > >       randwrite: jobs 1, iops 8549
> > > > > > > > >       randread: jobs 1, iops 34829
> > > > > > > > >       randrw: jobs 1, iops read 11363 write 11333
> > > > > > > > >       rw(512k): jobs 1, iops read 590 write 597
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > 2) ublk-qcow2
> > > > > > > > > running qcow2/021
> > > > > > > > > run perf test on empty qcow2 image via ublk
> > > > > > > > >       fio (ublk/qcow2( -f /mnt/data/ublk_null_8G_s761j.qc=
ow2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > > > > > > > >       randwrite: jobs 1, iops 16086
> > > > > > > > >       randread: jobs 1, iops 172720
> > > > > > > > >       randrw: jobs 1, iops read 35760 write 35702
> > > > > > > > >       rw(512k): jobs 1, iops read 1140 write 1149
> > > > > > > > >
> > > > > > > > > 3) vdpa-virtio-blk
> > > > > > > > > running debug/test_dev
> > > > > > > > > run io test on specified device
> > > > > > > > >       fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:=
1)...
> > > > > > > > >       randwrite: jobs 1, iops 8626
> > > > > > > > >       randread: jobs 1, iops 126118
> > > > > > > > >       randrw: jobs 1, iops read 17698 write 17665
> > > > > > > > >       rw(512k): jobs 1, iops read 1023 write 1031
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > 2. run fio on block device over pre-allocated qcow2 image
> > > > > > > > > 1) qemu-nbd
> > > > > > > > > running qcow2/002
> > > > > > > > > run perf test on pre-allocated qcow2 image via nbd
> > > > > > > > >       fio (nbd(/mnt/data/ublk_data_8G_sc0SB.qcow2), libai=
o, bs 4k, dio, hw queues:1)...
> > > > > > > > >       randwrite: jobs 1, iops 21439
> > > > > > > > >       randread: jobs 1, iops 30336
> > > > > > > > >       randrw: jobs 1, iops read 11476 write 11449
> > > > > > > > >       rw(512k): jobs 1, iops read 718 write 722
> > > > > > > > >
> > > > > > > > > 2) ublk-qcow2
> > > > > > > > > running qcow2/022
> > > > > > > > > run perf test on pre-allocated qcow2 image via ublk
> > > > > > > > >       fio (ublk/qcow2( -f /mnt/data/ublk_data_8G_yZiaJ.qc=
ow2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > > > > > > > >       randwrite: jobs 1, iops 98757
> > > > > > > > >       randread: jobs 1, iops 110246
> > > > > > > > >       randrw: jobs 1, iops read 47229 write 47161
> > > > > > > > >       rw(512k): jobs 1, iops read 1416 write 1427
> > > > > > > > >
> > > > > > > > > 3) vdpa-virtio-blk
> > > > > > > > > running debug/test_dev
> > > > > > > > > run io test on specified device
> > > > > > > > >       fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:=
1)...
> > > > > > > > >       randwrite: jobs 1, iops 47317
> > > > > > > > >       randread: jobs 1, iops 74092
> > > > > > > > >       randrw: jobs 1, iops read 27196 write 27234
> > > > > > > > >       rw(512k): jobs 1, iops read 1447 write 1458
> > > > > > > > >
> > > > > > > > >
> > > > > > > >
> > > > > > > > Hi All,
> > > > > > > >
> > > > > > > > We are interested in VDUSE vs UBLK, too. And I have tested =
them with nullblk backend.
> > > > > > > > Let me share some results here.
> > > > > > > >
> > > > > > > > I setup UBLK with:
> > > > > > > >   ublk add -t loop -f /dev/nullb0 -d QUEUE_DEPTH -q NR_QUEU=
E
> > > > > > > >
> > > > > > > > I setup VDUSE with:
> > > > > > > >   qemu-storage-daemon \
> > > > > > > >        --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.so=
ck,server=3Don,wait=3Doff \
> > > > > > > >        --monitor chardev=3Dcharmonitor \
> > > > > > > >        --blockdev driver=3Dhost_device,cache.direct=3Don,fi=
lename=3D/dev/nullb0,node-name=3Ddisk0 \
> > > > > > > >        --export vduse-blk,id=3Dtest,node-name=3Ddisk0,name=
=3Dvduse_test,writable=3Don,num-queues=3DNR_QUEUE,queue-size=3DQUEUE_DEPTH
> > > > > > > >
> > > > > > > > Here QUEUE_DEPTH is 1, 32 or 128 and NR_QUEUE is 1 or 4.
> > > > > > > >
> > > > > > > > Note:
> > > > > > > > (1) VDUSE requires QUEUE_DEPTH >=3D 2. I cannot setup QUEUE=
_DEPTH to 1.
> > > > > > > > (2) I use qemu 7.1.0-rc3. It supports vduse-blk.
> > > > > > > > (3) I do not use ublk null target so that the test is fair.
> > > > > > > > (4) I setup fio with direct=3D1, bs=3D4k.
> > > > > > > >
> > > > > > > > ------------------------------
> > > > > > > > 1 job 1 iodepth, lat=EF=BC=88usec)
> > > > > > > >                 vduse   ublk
> > > > > > > > seq-read        22.55   11.15
> > > > > > > > rand-read       22.49   11.17
> > > > > > > > seq-write       25.67   10.25
> > > > > > > > rand-write      24.13   10.16
> > > > > > >
> > > > > > > Thanks for sharing. Any idea what the bottlenecks are for vdu=
se and ublk?
> > > > > > >
> > > > > >
> > > > > > I think one reason for the latency gap of sync I/O is that vdus=
e uses
> > > > > > workqueue in the I/O completion path but ublk doesn't.
> > > > > >
> > > > > > And one bottleneck for the async I/O in vduse is that vduse wil=
l do
> > > > > > memcpy inside the critical section of virtqueue's spinlock in t=
he
> > > > > > virtio-blk driver. That will hurt the performance heavily when
> > > > > > virtio_queue_rq() and virtblk_done() run concurrently. And it c=
an be
> > > > > > mitigated by the advance DMA mapping feature [1] or irq binding
> > > > > > support [2].
> > > > >
> > > > > Hi Yongji,
> > > > >
> > > > > Yeah, that is the cost you paid for virtio. Wrt. userspace block =
device
> > > > > or other sort of userspace devices, cmd completion is driven by
> > > > > userspace, not sure if one such 'irq' is needed.
> > > >
> > > > I'm not sure, it can be an optional feature in the future if needed=
.
> > > >
> > > > > Even not sure if virtio
> > > > > ring is one good choice for such use case, given io_uring has bee=
n proved
> > > > > as very efficient(should be better than virtio ring, IMO).
> > > > >
> > > >
> > > > Since vduse is aimed at creating a generic userspace device framewo=
rk,
> > > > virtio should be the right way IMO.
> > >
> > > OK, it is the right way, but may not be the effective one.
> > >
> >
> > Maybe, but I think we can try to optimize it.
> >
> > > > And with the vdpa framework, the
> > > > userspace device can serve both virtual machines and containers.
> > >
> > > virtio is good for VM, but not sure it is good enough for other
> > > cases.
> > >
> > > >
> > > > Regarding the performance issue, actually I can't measure how much =
of
> > > > the performance loss is due to the difference between virtio ring a=
nd
> > > > iouring. But I think it should be very small. The main costs come f=
rom
> > > > the two bottlenecks I mentioned before which could be mitigated in =
the
> > > > future.
> > >
> > > Per my understanding, at least there are two places where virtio ring=
 is
> > > less efficient than io_uring:
> > >
> >
> > I might have misunderstood what you mean by virtio ring before. My
> > previous understanding of the virtio ring does not include the
> > virtio-blk driver.
> >
> > > 1) io_uring uses standalone submission queue(SQ) and completion queue=
(CQ),
> > > so no contention exists between submission and completion; but virtio=
 queue
> > > requires per-vq lock in both submission and completion.
> > >
> >
> > Yes, this is the bottleneck of the virtio-blk driver, even in the VM
> > case. We are also trying to optimize this lock.
> >
> > One way to mitigate it is making submission and completion happen in
> > the same core.
>
> QEMU sizes virtio-blk device num-queues to match the vCPU count. The
> virtio-blk driver is a blk-mq driver, so submissions and completions
> for a given virtqueue should already be processed by the same vCPU.
>
> Unless the device is misconfigured or the guest software chooses a
> custom vq:vCPU mapping, there should be no vq lock contention between
> vCPUs.
>
> I can think of a reason why submission and completion require
> coordination: descriptors are occupied until completion. The
> submission logic chooses free descriptors from the table. The
> completion logic returns free descriptors so they can be used in
> future submissions.
>

Yes, we need to maintain a head pointer of the free descriptors in
both submission and completion path.

> Other ring designs expose the submission ring head AND tail index so
> that it's clear which submissions have been processed by the other
> side. Once processed, the descriptors are no longer occupied and can
> be reused for future submissions immediately. This means that
> submission and completion do not share state.
>
> This is for the split virtqueue layout. For the packed layout I think
> there is a similar dependency because descriptors are used for both
> submission and completion.
>
> I have CCed Michael Tsirkin in case he has any thoughts on the
> independence of submission and completion in the vring design.
>
> BTW I have written about difference in the VIRTIO, NVMe, and io_uring
> descriptor ring designs here:
> https://blog.vmsplice.net/2022/06/comparing-virtio-nvme-and-iouring-queue=
.html
>

Good to know that!

Thanks,
Yongji
