Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFF4600D77
	for <lists+io-uring@lfdr.de>; Mon, 17 Oct 2022 13:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiJQLMP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Oct 2022 07:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiJQLMP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Oct 2022 07:12:15 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E244E5E304
        for <io-uring@vger.kernel.org>; Mon, 17 Oct 2022 04:12:11 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a26so24082570ejc.4
        for <io-uring@vger.kernel.org>; Mon, 17 Oct 2022 04:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JjjevY4mB+oEb6/UhG6vaazoWplKG7Cf0WLcu9hqNhw=;
        b=G/Gqcv5bBDLCsD9lL6SGAFx77D3mzTLTYXQhoteoApRI5KvViCUpg4QqEb6H0ZRAHl
         w5xYOnEwLmPrBMa7RrDS/1pOwAF1QTGDrNIOPbs30XMAvJ83rGt509J7mYYPxv297E3L
         By/4BHGyK5ojgoPG9rKVl0V5MhRTomT/AYRxMLrLLaieo5jGVRYa2gtIq+OO9aBhSic8
         xaNjjeEEbXPYhLHbgluMnKJXkTe8Ix182sBGOCZyRRy4iSKE+y/z1Ukxcy3jWV6Gmhte
         W+5H8gelt/Tl+xE/fkg8ivBe7oBgNMO9LUzcyRTJsrGxpW0Lgz+Mmukn5ZnzVlzaSj7p
         5Glg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JjjevY4mB+oEb6/UhG6vaazoWplKG7Cf0WLcu9hqNhw=;
        b=N3pfEShK4TxeT0Dc1RY+iTYhTkl3gHWXXuR+BMeh3df25mc4Hw9WbMR+1NVHSgs19N
         AchOH0V6WQvthCUoLvB0X9gDAtF2Gi15VG8Cf7itXXETOYCKiEjkpChTKaA0h2ww5/hi
         FQgBDo43H8StUUdmY3lAlu9lg9OX3d6flxZ+bZfaEBQ+SQn66UUt1XqNRje5X6YS6yVv
         fV/9okcsFIlhJ/e+KJa+3CGjXkhhhyMJPlOuYr38zY+VF0mflVzv5A7wSUzFmuVSGlAL
         8V3+f7QyTVSDcgmjWa7KDRB4PINCAgsP+BQkQylgbDZlW6ab3SKmNnu9JRYQQytPm30z
         bNSQ==
X-Gm-Message-State: ACrzQf1y2K19RVBnKcPiWs6ySNixLeSycTm8MJH6CfNm4aEasXsYEUdF
        IIdV9Yu0n0TTJvMkbi2NAe0w5P6vc5CW1c4aXI0f
X-Google-Smtp-Source: AMsMyM5Ho77HQwshBM2QWzZviW5ZuGUzaH1TGwL+ARE5kBqqVQ1MFxo6g8nAst9gFufcDq+GHK5E6hLFh7YIGrnESUE=
X-Received: by 2002:a17:906:36d1:b0:76c:a723:9445 with SMTP id
 b17-20020a17090636d100b0076ca7239445mr7856425ejc.548.1666005130206; Mon, 17
 Oct 2022 04:12:10 -0700 (PDT)
MIME-Version: 1.0
References: <Yza1u1KfKa7ycQm0@T590> <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590> <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <Yz0FrzJVZTqlQtJ5@T590> <50827796-af93-4af5-4121-dc13c31a67fc@linux.alibaba.com>
 <CAJSP0QXW9TmuvJpQPRF-AF01aW79jH8tnkHPEf+do5vQ1crGFA@mail.gmail.com>
 <CACycT3ufcN+a_wtWe6ioOWZUCak-JmcMgSa=rqeEsS63_HqSog@mail.gmail.com> <Y0lcmZTP5sr467z6@T590>
In-Reply-To: <Y0lcmZTP5sr467z6@T590>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 17 Oct 2022 19:11:59 +0800
Message-ID: <CACycT3u8yYUS-WnNzgHQtQFYuK-XcyffpFc35HVZzrCS7hH5Sg@mail.gmail.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
To:     Ming Lei <tom.leiming@gmail.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
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

On Fri, Oct 14, 2022 at 8:57 PM Ming Lei <tom.leiming@gmail.com> wrote:
>
> On Thu, Oct 13, 2022 at 02:48:04PM +0800, Yongji Xie wrote:
> > On Wed, Oct 12, 2022 at 10:22 PM Stefan Hajnoczi <stefanha@gmail.com> w=
rote:
> > >
> > > On Sat, 8 Oct 2022 at 04:43, Ziyang Zhang <ZiyangZhang@linux.alibaba.=
com> wrote:
> > > >
> > > > On 2022/10/5 12:18, Ming Lei wrote:
> > > > > On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wrote:
> > > > >> On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail.com> wr=
ote:
> > > > >>>
> > > > >>> On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnoczi wrote=
:
> > > > >>>> On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > > > >>>>> ublk-qcow2 is available now.
> > > > >>>>
> > > > >>>> Cool, thanks for sharing!
> > > > >>>>
> > > > >>>>>
> > > > >>>>> So far it provides basic read/write function, and compression=
 and snapshot
> > > > >>>>> aren't supported yet. The target/backend implementation is co=
mpletely
> > > > >>>>> based on io_uring, and share the same io_uring with ublk IO c=
ommand
> > > > >>>>> handler, just like what ublk-loop does.
> > > > >>>>>
> > > > >>>>> Follows the main motivations of ublk-qcow2:
> > > > >>>>>
> > > > >>>>> - building one complicated target from scratch helps libublks=
rv APIs/functions
> > > > >>>>>   become mature/stable more quickly, since qcow2 is complicat=
ed and needs more
> > > > >>>>>   requirement from libublksrv compared with other simple ones=
(loop, null)
> > > > >>>>>
> > > > >>>>> - there are several attempts of implementing qcow2 driver in =
kernel, such as
> > > > >>>>>   ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)``=
 [4], so ublk-qcow2
> > > > >>>>>   might useful be for covering requirement in this field
> > > > >>>>>
> > > > >>>>> - performance comparison with qemu-nbd, and it was my 1st tho=
ught to evaluate
> > > > >>>>>   performance of ublk/io_uring backend by writing one ublk-qc=
ow2 since ublksrv
> > > > >>>>>   is started
> > > > >>>>>
> > > > >>>>> - help to abstract common building block or design pattern fo=
r writing new ublk
> > > > >>>>>   target/backend
> > > > >>>>>
> > > > >>>>> So far it basically passes xfstest(XFS) test by using ublk-qc=
ow2 block
> > > > >>>>> device as TEST_DEV, and kernel building workload is verified =
too. Also
> > > > >>>>> soft update approach is applied in meta flushing, and meta da=
ta
> > > > >>>>> integrity is guaranteed, 'make test T=3Dqcow2/040' covers thi=
s kind of
> > > > >>>>> test, and only cluster leak is reported during this test.
> > > > >>>>>
> > > > >>>>> The performance data looks much better compared with qemu-nbd=
, see
> > > > >>>>> details in commit log[1], README[5] and STATUS[6]. And the te=
st covers both
> > > > >>>>> empty image and pre-allocated image, for example of pre-alloc=
ated qcow2
> > > > >>>>> image(8GB):
> > > > >>>>>
> > > > >>>>> - qemu-nbd (make test T=3Dqcow2/002)
> > > > >>>>
> > > > >>>> Single queue?
> > > > >>>
> > > > >>> Yeah.
> > > > >>>
> > > > >>>>
> > > > >>>>>     randwrite(4k): jobs 1, iops 24605
> > > > >>>>>     randread(4k): jobs 1, iops 30938
> > > > >>>>>     randrw(4k): jobs 1, iops read 13981 write 14001
> > > > >>>>>     rw(512k): jobs 1, iops read 724 write 728
> > > > >>>>
> > > > >>>> Please try qemu-storage-daemon's VDUSE export type as well. Th=
e
> > > > >>>> command-line should be similar to this:
> > > > >>>>
> > > > >>>>   # modprobe virtio_vdpa # attaches vDPA devices to host kerne=
l
> > > > >>>
> > > > >>> Not found virtio_vdpa module even though I enabled all the foll=
owing
> > > > >>> options:
> > > > >>>
> > > > >>>         --- vDPA drivers
> > > > >>>           <M>   vDPA device simulator core
> > > > >>>           <M>     vDPA simulator for networking device
> > > > >>>           <M>     vDPA simulator for block device
> > > > >>>           <M>   VDUSE (vDPA Device in Userspace) support
> > > > >>>           <M>   Intel IFC VF vDPA driver
> > > > >>>           <M>   Virtio PCI bridge vDPA driver
> > > > >>>           <M>   vDPA driver for Alibaba ENI
> > > > >>>
> > > > >>> BTW, my test environment is VM and the shared data is done in V=
M too, and
> > > > >>> can virtio_vdpa be used inside VM?
> > > > >>
> > > > >> I hope Xie Yongji can help explain how to benchmark VDUSE.
> > > > >>
> > > > >> virtio_vdpa is available inside guests too. Please check that
> > > > >> VIRTIO_VDPA ("vDPA driver for virtio devices") is enabled in "Vi=
rtio
> > > > >> drivers" menu.
> > > > >>
> > > > >>>
> > > > >>>>   # modprobe vduse
> > > > >>>>   # qemu-storage-daemon \
> > > > >>>>       --blockdev file,filename=3Dtest.qcow2,cache.direct=3Dof|=
off,aio=3Dnative,node-name=3Dfile \
> > > > >>>>       --blockdev qcow2,file=3Dfile,node-name=3Dqcow2 \
> > > > >>>>       --object iothread,id=3Diothread0 \
> > > > >>>>       --export vduse-blk,id=3Dvduse0,name=3Dvduse0,num-queues=
=3D$(nproc),node-name=3Dqcow2,writable=3Don,iothread=3Diothread0
> > > > >>>>   # vdpa dev add name vduse0 mgmtdev vduse
> > > > >>>>
> > > > >>>> A virtio-blk device should appear and xfstests can be run on i=
t
> > > > >>>> (typically /dev/vda unless you already have other virtio-blk d=
evices).
> > > > >>>>
> > > > >>>> Afterwards you can destroy the device using:
> > > > >>>>
> > > > >>>>   # vdpa dev del vduse0
> > > > >>>>
> > > > >>>>>
> > > > >>>>> - ublk-qcow2 (make test T=3Dqcow2/022)
> > > > >>>>
> > > > >>>> There are a lot of other factors not directly related to NBD v=
s ublk. In
> > > > >>>> order to get an apples-to-apples comparison with qemu-* a ublk=
 export
> > > > >>>> type is needed in qemu-storage-daemon. That way only the diffe=
rence is
> > > > >>>> the ublk interface and the rest of the code path is identical,=
 making it
> > > > >>>> possible to compare NBD, VDUSE, ublk, etc more precisely.
> > > > >>>
> > > > >>> Maybe not true.
> > > > >>>
> > > > >>> ublk-qcow2 uses io_uring to handle all backend IO(include meta =
IO) completely,
> > > > >>> and so far single io_uring/pthread is for handling all qcow2 IO=
s and IO
> > > > >>> command.
> > > > >>
> > > > >> qemu-nbd doesn't use io_uring to handle the backend IO, so we do=
n't
> > > > >
> > > > > I tried to use it via --aio=3Dio_uring for setting up qemu-nbd, b=
ut not succeed.
> > > > >
> > > > >> know whether the benchmark demonstrates that ublk is faster than=
 NBD,
> > > > >> that the ublk-qcow2 implementation is faster than qemu-nbd's qco=
w2,
> > > > >> whether there are miscellaneous implementation differences betwe=
en
> > > > >> ublk-qcow2 and qemu-nbd (like using the same io_uring context fo=
r both
> > > > >> ublk and backend IO), or something else.
> > > > >
> > > > > The theory shouldn't be too complicated:
> > > > >
> > > > > 1) io uring passthough(pt) communication is fast than socket, and=
 io command
> > > > > is carried over io_uring pt commands, and should be fast than vir=
io
> > > > > communication too.
> > > > >
> > > > > 2) io uring io handling is fast than libaio which is taken in the
> > > > > test on qemu-nbd, and all qcow2 backend io(include meta io) is ha=
ndled
> > > > > by io_uring.
> > > > >
> > > > > https://github.com/ming1/ubdsrv/blob/master/tests/common/qcow2_co=
mmon
> > > > >
> > > > > 3) ublk uses one single io_uring to handle all io commands and qc=
ow2
> > > > > backend IOs, so batching handling is common, and it is easy to se=
e
> > > > > dozens of IOs/io commands handled in single syscall, or even more=
.
> > > > >
> > > > >>
> > > > >> I'm suggesting measuring changes to just 1 variable at a time.
> > > > >> Otherwise it's hard to reach a conclusion about the root cause o=
f the
> > > > >> performance difference. Let's learn why ublk-qcow2 performs well=
.
> > > > >
> > > > > Turns out the latest Fedora 37-beta doesn't support vdpa yet, so =
I built
> > > > > qemu from the latest github tree, and finally it starts to work. =
And test kernel
> > > > > is v6.0 release.
> > > > >
> > > > > Follows the test result, and all three devices are setup as singl=
e
> > > > > queue, and all tests are run in single job, still done in one VM,=
 and
> > > > > the test images are stored on XFS/virito-scsi backed SSD.
> > > > >
> > > > > The 1st group tests all three block device which is backed by emp=
ty
> > > > > qcow2 image.
> > > > >
> > > > > The 2nd group tests all the three block devices backed by pre-all=
ocated
> > > > > qcow2 image.
> > > > >
> > > > > Except for big sequential IO(512K), there is still not small gap =
between
> > > > > vdpa-virtio-blk and ublk.
> > > > >
> > > > > 1. run fio on block device over empty qcow2 image
> > > > > 1) qemu-nbd
> > > > > running qcow2/001
> > > > > run perf test on empty qcow2 image via nbd
> > > > >       fio (nbd(/mnt/data/ublk_null_8G_nYbgF.qcow2), libaio, bs 4k=
, dio, hw queues:1)...
> > > > >       randwrite: jobs 1, iops 8549
> > > > >       randread: jobs 1, iops 34829
> > > > >       randrw: jobs 1, iops read 11363 write 11333
> > > > >       rw(512k): jobs 1, iops read 590 write 597
> > > > >
> > > > >
> > > > > 2) ublk-qcow2
> > > > > running qcow2/021
> > > > > run perf test on empty qcow2 image via ublk
> > > > >       fio (ublk/qcow2( -f /mnt/data/ublk_null_8G_s761j.qcow2), li=
baio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > > > >       randwrite: jobs 1, iops 16086
> > > > >       randread: jobs 1, iops 172720
> > > > >       randrw: jobs 1, iops read 35760 write 35702
> > > > >       rw(512k): jobs 1, iops read 1140 write 1149
> > > > >
> > > > > 3) vdpa-virtio-blk
> > > > > running debug/test_dev
> > > > > run io test on specified device
> > > > >       fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)...
> > > > >       randwrite: jobs 1, iops 8626
> > > > >       randread: jobs 1, iops 126118
> > > > >       randrw: jobs 1, iops read 17698 write 17665
> > > > >       rw(512k): jobs 1, iops read 1023 write 1031
> > > > >
> > > > >
> > > > > 2. run fio on block device over pre-allocated qcow2 image
> > > > > 1) qemu-nbd
> > > > > running qcow2/002
> > > > > run perf test on pre-allocated qcow2 image via nbd
> > > > >       fio (nbd(/mnt/data/ublk_data_8G_sc0SB.qcow2), libaio, bs 4k=
, dio, hw queues:1)...
> > > > >       randwrite: jobs 1, iops 21439
> > > > >       randread: jobs 1, iops 30336
> > > > >       randrw: jobs 1, iops read 11476 write 11449
> > > > >       rw(512k): jobs 1, iops read 718 write 722
> > > > >
> > > > > 2) ublk-qcow2
> > > > > running qcow2/022
> > > > > run perf test on pre-allocated qcow2 image via ublk
> > > > >       fio (ublk/qcow2( -f /mnt/data/ublk_data_8G_yZiaJ.qcow2), li=
baio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > > > >       randwrite: jobs 1, iops 98757
> > > > >       randread: jobs 1, iops 110246
> > > > >       randrw: jobs 1, iops read 47229 write 47161
> > > > >       rw(512k): jobs 1, iops read 1416 write 1427
> > > > >
> > > > > 3) vdpa-virtio-blk
> > > > > running debug/test_dev
> > > > > run io test on specified device
> > > > >       fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)...
> > > > >       randwrite: jobs 1, iops 47317
> > > > >       randread: jobs 1, iops 74092
> > > > >       randrw: jobs 1, iops read 27196 write 27234
> > > > >       rw(512k): jobs 1, iops read 1447 write 1458
> > > > >
> > > > >
> > > >
> > > > Hi All,
> > > >
> > > > We are interested in VDUSE vs UBLK, too. And I have tested them wit=
h nullblk backend.
> > > > Let me share some results here.
> > > >
> > > > I setup UBLK with:
> > > >   ublk add -t loop -f /dev/nullb0 -d QUEUE_DEPTH -q NR_QUEUE
> > > >
> > > > I setup VDUSE with:
> > > >   qemu-storage-daemon \
> > > >        --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.sock,serve=
r=3Don,wait=3Doff \
> > > >        --monitor chardev=3Dcharmonitor \
> > > >        --blockdev driver=3Dhost_device,cache.direct=3Don,filename=
=3D/dev/nullb0,node-name=3Ddisk0 \
> > > >        --export vduse-blk,id=3Dtest,node-name=3Ddisk0,name=3Dvduse_=
test,writable=3Don,num-queues=3DNR_QUEUE,queue-size=3DQUEUE_DEPTH
> > > >
> > > > Here QUEUE_DEPTH is 1, 32 or 128 and NR_QUEUE is 1 or 4.
> > > >
> > > > Note:
> > > > (1) VDUSE requires QUEUE_DEPTH >=3D 2. I cannot setup QUEUE_DEPTH t=
o 1.
> > > > (2) I use qemu 7.1.0-rc3. It supports vduse-blk.
> > > > (3) I do not use ublk null target so that the test is fair.
> > > > (4) I setup fio with direct=3D1, bs=3D4k.
> > > >
> > > > ------------------------------
> > > > 1 job 1 iodepth, lat=EF=BC=88usec)
> > > >                 vduse   ublk
> > > > seq-read        22.55   11.15
> > > > rand-read       22.49   11.17
> > > > seq-write       25.67   10.25
> > > > rand-write      24.13   10.16
> > >
> > > Thanks for sharing. Any idea what the bottlenecks are for vduse and u=
blk?
> > >
> >
> > I think one reason for the latency gap of sync I/O is that vduse uses
> > workqueue in the I/O completion path but ublk doesn't.
> >
> > And one bottleneck for the async I/O in vduse is that vduse will do
> > memcpy inside the critical section of virtqueue's spinlock in the
> > virtio-blk driver. That will hurt the performance heavily when
> > virtio_queue_rq() and virtblk_done() run concurrently. And it can be
> > mitigated by the advance DMA mapping feature [1] or irq binding
> > support [2].
>
> Hi Yongji,
>
> Yeah, that is the cost you paid for virtio. Wrt. userspace block device
> or other sort of userspace devices, cmd completion is driven by
> userspace, not sure if one such 'irq' is needed.

I'm not sure, it can be an optional feature in the future if needed.

> Even not sure if virtio
> ring is one good choice for such use case, given io_uring has been proved
> as very efficient(should be better than virtio ring, IMO).
>

Since vduse is aimed at creating a generic userspace device framework,
virtio should be the right way IMO. And with the vdpa framework, the
userspace device can serve both virtual machines and containers.

Regarding the performance issue, actually I can't measure how much of
the performance loss is due to the difference between virtio ring and
iouring. But I think it should be very small. The main costs come from
the two bottlenecks I mentioned before which could be mitigated in the
future.

> ublk uses io_uring pt cmd for handling both io submission and completion,
> turns out the extra latency can be pretty small.
>
> BTW, one un-related topic, I saw the following words in
> Documentation/userspace-api/vduse.rst:
>
> ```
> Note that only virtio block device is supported by VDUSE framework now,
> which can reduce security risks when the userspace process that implement=
s
> the data path is run by an unprivileged user.
> ```
>
> But when I tried to start qemu-storage-daemon for creating vdpa-virtio
> block by nor unprivileged user, 'Permission denied' is still returned,
> can you explain a bit how to start such process by unprivileged user?
> Or maybe I misunderstood the above words, please let me know.
>

Currently vduse should only allow privileged users by default. But
sysadmin can change the permission of the vduse char device or pass
the device fd to an unprivileged process IIUC.

Thanks,
Yongji
