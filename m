Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E5260C62F
	for <lists+io-uring@lfdr.de>; Tue, 25 Oct 2022 10:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbiJYIRw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Oct 2022 04:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbiJYIRu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Oct 2022 04:17:50 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209E4C2C8E
        for <io-uring@vger.kernel.org>; Tue, 25 Oct 2022 01:17:47 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id a5so21982142edb.11
        for <io-uring@vger.kernel.org>; Tue, 25 Oct 2022 01:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uReB/Ptp2ISgZua1vja00OdAAxuE9UvI1yi/3W7gtmQ=;
        b=zmZxcv2MRXqmhGwk5VoX9FaEB5pjRbgd480ucHf55c1ey0oqC1+ivsQ2IYL5X5LmIa
         84yPBCLppWdqoO9leWdLQLEdspVAu09sW6UCUfCYg+uYc7WLXzsqfH9vYRveUqraIUER
         s8xCbKHdXxg/NotjSHqmCZ6kkWfMGRljvh7mHj12gYBZS69uzrpxDkBLWUTPXE7PA7ZT
         AfTLXG6nAQwuotphkHMs6PC/pz7NRBu7/qOgTK3j59Rr+BJ/YGhGWQsTmRH+pl8yOZok
         E7Wwbpa4UElyY07zULsZEn+DqKgxZ5wg8VpAbCNaiUVeuh88BSP/N2IgiYrlMyuJ4X8V
         d4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uReB/Ptp2ISgZua1vja00OdAAxuE9UvI1yi/3W7gtmQ=;
        b=GG0BO8THLlmjg9/xCz/jQ5Xe1TIjoBiQaRgokJ+aVBAYrK8J2YaEhBAvhKKYheWOAn
         poeJ6WHS+RAXR6W4kv5AYQhlawDj49cp20oHga3vAP4PBP1dg3UBRPNK0cVgaaUHHWqh
         aDNQN7qje5otZbgQ5B4nw0qzDoqNb7u7tWvGxBJznYfSFFcTdyuRE9C0ERP72ZnEcSGz
         CS2N6NWBpTx4BMSvO5SP839iqw1fEjo5S0VBMlhmUSUP5QGnwm3Y9XOY+4+kO70wjkId
         GJg6Vu0/Gu3GKZ+s0938ajR9I0YE2VDVY2MLhDterwLWQhaTjHtEfd8JMcshPakkHPxx
         ar8A==
X-Gm-Message-State: ACrzQf2o+pBC9vYI1AGMa+pEN8OXskR/ai0FEDyIlt2rFbXTp3onDZKG
        RYi6mGA1ftZjidrh01znX8hSCHJue/Mv3JxVCKd9
X-Google-Smtp-Source: AMsMyM7k3i+5MyvD21oT5YFCSShz5blyU7LTl69jLdf0/UpWKR2ZQbsnkZCL0oBLI99FcMBYoeiXyleErl3jcmf1jwM=
X-Received: by 2002:a05:6402:5024:b0:440:e4ad:f7b6 with SMTP id
 p36-20020a056402502400b00440e4adf7b6mr35123998eda.358.1666685865550; Tue, 25
 Oct 2022 01:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <Yza1u1KfKa7ycQm0@T590> <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590> <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <Yz0FrzJVZTqlQtJ5@T590> <50827796-af93-4af5-4121-dc13c31a67fc@linux.alibaba.com>
 <CAJSP0QXW9TmuvJpQPRF-AF01aW79jH8tnkHPEf+do5vQ1crGFA@mail.gmail.com>
 <CACycT3ufcN+a_wtWe6ioOWZUCak-JmcMgSa=rqeEsS63_HqSog@mail.gmail.com>
 <Y0lcmZTP5sr467z6@T590> <CACycT3u8yYUS-WnNzgHQtQFYuK-XcyffpFc35HVZzrCS7hH5Sg@mail.gmail.com>
 <Y05OzeC7wImts4p7@T590> <CACycT3sK1AzA4RH1ZfbstV3oax-oeBVtEz+sY+8scBU0=1x46g@mail.gmail.com>
 <CAJSP0QVevA0gvyGABAFSoMhBN9ydZqUJh4qJYgNbGeyRXL8AjA@mail.gmail.com>
 <CACycT3udzt0nyqweGbAsZB4LDQU=a7OSWKC8ZWieoBpsSfa2FQ@mail.gmail.com> <1d051d63-ce34-1bb3-2256-4ced4be6d690@redhat.com>
In-Reply-To: <1d051d63-ce34-1bb3-2256-4ced4be6d690@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 25 Oct 2022 16:17:33 +0800
Message-ID: <CACycT3usE0QdJd50bSiLiPwTFxscg-Ur=iZyeGJJBPe7+KxOFQ@mail.gmail.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 21, 2022 at 2:30 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/10/21 13:33, Yongji Xie =E5=86=99=E9=81=93:
> > On Tue, Oct 18, 2022 at 10:54 PM Stefan Hajnoczi <stefanha@gmail.com> w=
rote:
> >> On Tue, 18 Oct 2022 at 09:17, Yongji Xie <xieyongji@bytedance.com> wro=
te:
> >>> On Tue, Oct 18, 2022 at 2:59 PM Ming Lei <tom.leiming@gmail.com> wrot=
e:
> >>>> On Mon, Oct 17, 2022 at 07:11:59PM +0800, Yongji Xie wrote:
> >>>>> On Fri, Oct 14, 2022 at 8:57 PM Ming Lei <tom.leiming@gmail.com> wr=
ote:
> >>>>>> On Thu, Oct 13, 2022 at 02:48:04PM +0800, Yongji Xie wrote:
> >>>>>>> On Wed, Oct 12, 2022 at 10:22 PM Stefan Hajnoczi <stefanha@gmail.=
com> wrote:
> >>>>>>>> On Sat, 8 Oct 2022 at 04:43, Ziyang Zhang <ZiyangZhang@linux.ali=
baba.com> wrote:
> >>>>>>>>> On 2022/10/5 12:18, Ming Lei wrote:
> >>>>>>>>>> On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wrot=
e:
> >>>>>>>>>>> On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail.com>=
 wrote:
> >>>>>>>>>>>> On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnoczi wr=
ote:
> >>>>>>>>>>>>> On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> >>>>>>>>>>>>>> ublk-qcow2 is available now.
> >>>>>>>>>>>>> Cool, thanks for sharing!
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>> So far it provides basic read/write function, and compress=
ion and snapshot
> >>>>>>>>>>>>>> aren't supported yet. The target/backend implementation is=
 completely
> >>>>>>>>>>>>>> based on io_uring, and share the same io_uring with ublk I=
O command
> >>>>>>>>>>>>>> handler, just like what ublk-loop does.
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Follows the main motivations of ublk-qcow2:
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> - building one complicated target from scratch helps libub=
lksrv APIs/functions
> >>>>>>>>>>>>>>    become mature/stable more quickly, since qcow2 is compl=
icated and needs more
> >>>>>>>>>>>>>>    requirement from libublksrv compared with other simple =
ones(loop, null)
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> - there are several attempts of implementing qcow2 driver =
in kernel, such as
> >>>>>>>>>>>>>>    ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(r=
o)`` [4], so ublk-qcow2
> >>>>>>>>>>>>>>    might useful be for covering requirement in this field
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> - performance comparison with qemu-nbd, and it was my 1st =
thought to evaluate
> >>>>>>>>>>>>>>    performance of ublk/io_uring backend by writing one ubl=
k-qcow2 since ublksrv
> >>>>>>>>>>>>>>    is started
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> - help to abstract common building block or design pattern=
 for writing new ublk
> >>>>>>>>>>>>>>    target/backend
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> So far it basically passes xfstest(XFS) test by using ublk=
-qcow2 block
> >>>>>>>>>>>>>> device as TEST_DEV, and kernel building workload is verifi=
ed too. Also
> >>>>>>>>>>>>>> soft update approach is applied in meta flushing, and meta=
 data
> >>>>>>>>>>>>>> integrity is guaranteed, 'make test T=3Dqcow2/040' covers =
this kind of
> >>>>>>>>>>>>>> test, and only cluster leak is reported during this test.
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> The performance data looks much better compared with qemu-=
nbd, see
> >>>>>>>>>>>>>> details in commit log[1], README[5] and STATUS[6]. And the=
 test covers both
> >>>>>>>>>>>>>> empty image and pre-allocated image, for example of pre-al=
located qcow2
> >>>>>>>>>>>>>> image(8GB):
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> - qemu-nbd (make test T=3Dqcow2/002)
> >>>>>>>>>>>>> Single queue?
> >>>>>>>>>>>> Yeah.
> >>>>>>>>>>>>
> >>>>>>>>>>>>>>      randwrite(4k): jobs 1, iops 24605
> >>>>>>>>>>>>>>      randread(4k): jobs 1, iops 30938
> >>>>>>>>>>>>>>      randrw(4k): jobs 1, iops read 13981 write 14001
> >>>>>>>>>>>>>>      rw(512k): jobs 1, iops read 724 write 728
> >>>>>>>>>>>>> Please try qemu-storage-daemon's VDUSE export type as well.=
 The
> >>>>>>>>>>>>> command-line should be similar to this:
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>    # modprobe virtio_vdpa # attaches vDPA devices to host k=
ernel
> >>>>>>>>>>>> Not found virtio_vdpa module even though I enabled all the f=
ollowing
> >>>>>>>>>>>> options:
> >>>>>>>>>>>>
> >>>>>>>>>>>>          --- vDPA drivers
> >>>>>>>>>>>>            <M>   vDPA device simulator core
> >>>>>>>>>>>>            <M>     vDPA simulator for networking device
> >>>>>>>>>>>>            <M>     vDPA simulator for block device
> >>>>>>>>>>>>            <M>   VDUSE (vDPA Device in Userspace) support
> >>>>>>>>>>>>            <M>   Intel IFC VF vDPA driver
> >>>>>>>>>>>>            <M>   Virtio PCI bridge vDPA driver
> >>>>>>>>>>>>            <M>   vDPA driver for Alibaba ENI
> >>>>>>>>>>>>
> >>>>>>>>>>>> BTW, my test environment is VM and the shared data is done i=
n VM too, and
> >>>>>>>>>>>> can virtio_vdpa be used inside VM?
> >>>>>>>>>>> I hope Xie Yongji can help explain how to benchmark VDUSE.
> >>>>>>>>>>>
> >>>>>>>>>>> virtio_vdpa is available inside guests too. Please check that
> >>>>>>>>>>> VIRTIO_VDPA ("vDPA driver for virtio devices") is enabled in =
"Virtio
> >>>>>>>>>>> drivers" menu.
> >>>>>>>>>>>
> >>>>>>>>>>>>>    # modprobe vduse
> >>>>>>>>>>>>>    # qemu-storage-daemon \
> >>>>>>>>>>>>>        --blockdev file,filename=3Dtest.qcow2,cache.direct=
=3Dof|off,aio=3Dnative,node-name=3Dfile \
> >>>>>>>>>>>>>        --blockdev qcow2,file=3Dfile,node-name=3Dqcow2 \
> >>>>>>>>>>>>>        --object iothread,id=3Diothread0 \
> >>>>>>>>>>>>>        --export vduse-blk,id=3Dvduse0,name=3Dvduse0,num-que=
ues=3D$(nproc),node-name=3Dqcow2,writable=3Don,iothread=3Diothread0
> >>>>>>>>>>>>>    # vdpa dev add name vduse0 mgmtdev vduse
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> A virtio-blk device should appear and xfstests can be run o=
n it
> >>>>>>>>>>>>> (typically /dev/vda unless you already have other virtio-bl=
k devices).
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Afterwards you can destroy the device using:
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>    # vdpa dev del vduse0
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>> - ublk-qcow2 (make test T=3Dqcow2/022)
> >>>>>>>>>>>>> There are a lot of other factors not directly related to NB=
D vs ublk. In
> >>>>>>>>>>>>> order to get an apples-to-apples comparison with qemu-* a u=
blk export
> >>>>>>>>>>>>> type is needed in qemu-storage-daemon. That way only the di=
fference is
> >>>>>>>>>>>>> the ublk interface and the rest of the code path is identic=
al, making it
> >>>>>>>>>>>>> possible to compare NBD, VDUSE, ublk, etc more precisely.
> >>>>>>>>>>>> Maybe not true.
> >>>>>>>>>>>>
> >>>>>>>>>>>> ublk-qcow2 uses io_uring to handle all backend IO(include me=
ta IO) completely,
> >>>>>>>>>>>> and so far single io_uring/pthread is for handling all qcow2=
 IOs and IO
> >>>>>>>>>>>> command.
> >>>>>>>>>>> qemu-nbd doesn't use io_uring to handle the backend IO, so we=
 don't
> >>>>>>>>>> I tried to use it via --aio=3Dio_uring for setting up qemu-nbd=
, but not succeed.
> >>>>>>>>>>
> >>>>>>>>>>> know whether the benchmark demonstrates that ublk is faster t=
han NBD,
> >>>>>>>>>>> that the ublk-qcow2 implementation is faster than qemu-nbd's =
qcow2,
> >>>>>>>>>>> whether there are miscellaneous implementation differences be=
tween
> >>>>>>>>>>> ublk-qcow2 and qemu-nbd (like using the same io_uring context=
 for both
> >>>>>>>>>>> ublk and backend IO), or something else.
> >>>>>>>>>> The theory shouldn't be too complicated:
> >>>>>>>>>>
> >>>>>>>>>> 1) io uring passthough(pt) communication is fast than socket, =
and io command
> >>>>>>>>>> is carried over io_uring pt commands, and should be fast than =
virio
> >>>>>>>>>> communication too.
> >>>>>>>>>>
> >>>>>>>>>> 2) io uring io handling is fast than libaio which is taken in =
the
> >>>>>>>>>> test on qemu-nbd, and all qcow2 backend io(include meta io) is=
 handled
> >>>>>>>>>> by io_uring.
> >>>>>>>>>>
> >>>>>>>>>> https://github.com/ming1/ubdsrv/blob/master/tests/common/qcow2=
_common
> >>>>>>>>>>
> >>>>>>>>>> 3) ublk uses one single io_uring to handle all io commands and=
 qcow2
> >>>>>>>>>> backend IOs, so batching handling is common, and it is easy to=
 see
> >>>>>>>>>> dozens of IOs/io commands handled in single syscall, or even m=
ore.
> >>>>>>>>>>
> >>>>>>>>>>> I'm suggesting measuring changes to just 1 variable at a time=
.
> >>>>>>>>>>> Otherwise it's hard to reach a conclusion about the root caus=
e of the
> >>>>>>>>>>> performance difference. Let's learn why ublk-qcow2 performs w=
ell.
> >>>>>>>>>> Turns out the latest Fedora 37-beta doesn't support vdpa yet, =
so I built
> >>>>>>>>>> qemu from the latest github tree, and finally it starts to wor=
k. And test kernel
> >>>>>>>>>> is v6.0 release.
> >>>>>>>>>>
> >>>>>>>>>> Follows the test result, and all three devices are setup as si=
ngle
> >>>>>>>>>> queue, and all tests are run in single job, still done in one =
VM, and
> >>>>>>>>>> the test images are stored on XFS/virito-scsi backed SSD.
> >>>>>>>>>>
> >>>>>>>>>> The 1st group tests all three block device which is backed by =
empty
> >>>>>>>>>> qcow2 image.
> >>>>>>>>>>
> >>>>>>>>>> The 2nd group tests all the three block devices backed by pre-=
allocated
> >>>>>>>>>> qcow2 image.
> >>>>>>>>>>
> >>>>>>>>>> Except for big sequential IO(512K), there is still not small g=
ap between
> >>>>>>>>>> vdpa-virtio-blk and ublk.
> >>>>>>>>>>
> >>>>>>>>>> 1. run fio on block device over empty qcow2 image
> >>>>>>>>>> 1) qemu-nbd
> >>>>>>>>>> running qcow2/001
> >>>>>>>>>> run perf test on empty qcow2 image via nbd
> >>>>>>>>>>        fio (nbd(/mnt/data/ublk_null_8G_nYbgF.qcow2), libaio, b=
s 4k, dio, hw queues:1)...
> >>>>>>>>>>        randwrite: jobs 1, iops 8549
> >>>>>>>>>>        randread: jobs 1, iops 34829
> >>>>>>>>>>        randrw: jobs 1, iops read 11363 write 11333
> >>>>>>>>>>        rw(512k): jobs 1, iops read 590 write 597
> >>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> 2) ublk-qcow2
> >>>>>>>>>> running qcow2/021
> >>>>>>>>>> run perf test on empty qcow2 image via ublk
> >>>>>>>>>>        fio (ublk/qcow2( -f /mnt/data/ublk_null_8G_s761j.qcow2)=
, libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> >>>>>>>>>>        randwrite: jobs 1, iops 16086
> >>>>>>>>>>        randread: jobs 1, iops 172720
> >>>>>>>>>>        randrw: jobs 1, iops read 35760 write 35702
> >>>>>>>>>>        rw(512k): jobs 1, iops read 1140 write 1149
> >>>>>>>>>>
> >>>>>>>>>> 3) vdpa-virtio-blk
> >>>>>>>>>> running debug/test_dev
> >>>>>>>>>> run io test on specified device
> >>>>>>>>>>        fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)..=
.
> >>>>>>>>>>        randwrite: jobs 1, iops 8626
> >>>>>>>>>>        randread: jobs 1, iops 126118
> >>>>>>>>>>        randrw: jobs 1, iops read 17698 write 17665
> >>>>>>>>>>        rw(512k): jobs 1, iops read 1023 write 1031
> >>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> 2. run fio on block device over pre-allocated qcow2 image
> >>>>>>>>>> 1) qemu-nbd
> >>>>>>>>>> running qcow2/002
> >>>>>>>>>> run perf test on pre-allocated qcow2 image via nbd
> >>>>>>>>>>        fio (nbd(/mnt/data/ublk_data_8G_sc0SB.qcow2), libaio, b=
s 4k, dio, hw queues:1)...
> >>>>>>>>>>        randwrite: jobs 1, iops 21439
> >>>>>>>>>>        randread: jobs 1, iops 30336
> >>>>>>>>>>        randrw: jobs 1, iops read 11476 write 11449
> >>>>>>>>>>        rw(512k): jobs 1, iops read 718 write 722
> >>>>>>>>>>
> >>>>>>>>>> 2) ublk-qcow2
> >>>>>>>>>> running qcow2/022
> >>>>>>>>>> run perf test on pre-allocated qcow2 image via ublk
> >>>>>>>>>>        fio (ublk/qcow2( -f /mnt/data/ublk_data_8G_yZiaJ.qcow2)=
, libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> >>>>>>>>>>        randwrite: jobs 1, iops 98757
> >>>>>>>>>>        randread: jobs 1, iops 110246
> >>>>>>>>>>        randrw: jobs 1, iops read 47229 write 47161
> >>>>>>>>>>        rw(512k): jobs 1, iops read 1416 write 1427
> >>>>>>>>>>
> >>>>>>>>>> 3) vdpa-virtio-blk
> >>>>>>>>>> running debug/test_dev
> >>>>>>>>>> run io test on specified device
> >>>>>>>>>>        fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)..=
.
> >>>>>>>>>>        randwrite: jobs 1, iops 47317
> >>>>>>>>>>        randread: jobs 1, iops 74092
> >>>>>>>>>>        randrw: jobs 1, iops read 27196 write 27234
> >>>>>>>>>>        rw(512k): jobs 1, iops read 1447 write 1458
> >>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>> Hi All,
> >>>>>>>>>
> >>>>>>>>> We are interested in VDUSE vs UBLK, too. And I have tested them=
 with nullblk backend.
> >>>>>>>>> Let me share some results here.
> >>>>>>>>>
> >>>>>>>>> I setup UBLK with:
> >>>>>>>>>    ublk add -t loop -f /dev/nullb0 -d QUEUE_DEPTH -q NR_QUEUE
> >>>>>>>>>
> >>>>>>>>> I setup VDUSE with:
> >>>>>>>>>    qemu-storage-daemon \
> >>>>>>>>>         --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.sock,=
server=3Don,wait=3Doff \
> >>>>>>>>>         --monitor chardev=3Dcharmonitor \
> >>>>>>>>>         --blockdev driver=3Dhost_device,cache.direct=3Don,filen=
ame=3D/dev/nullb0,node-name=3Ddisk0 \
> >>>>>>>>>         --export vduse-blk,id=3Dtest,node-name=3Ddisk0,name=3Dv=
duse_test,writable=3Don,num-queues=3DNR_QUEUE,queue-size=3DQUEUE_DEPTH
> >>>>>>>>>
> >>>>>>>>> Here QUEUE_DEPTH is 1, 32 or 128 and NR_QUEUE is 1 or 4.
> >>>>>>>>>
> >>>>>>>>> Note:
> >>>>>>>>> (1) VDUSE requires QUEUE_DEPTH >=3D 2. I cannot setup QUEUE_DEP=
TH to 1.
> >>>>>>>>> (2) I use qemu 7.1.0-rc3. It supports vduse-blk.
> >>>>>>>>> (3) I do not use ublk null target so that the test is fair.
> >>>>>>>>> (4) I setup fio with direct=3D1, bs=3D4k.
> >>>>>>>>>
> >>>>>>>>> ------------------------------
> >>>>>>>>> 1 job 1 iodepth, lat=EF=BC=88usec)
> >>>>>>>>>                  vduse   ublk
> >>>>>>>>> seq-read        22.55   11.15
> >>>>>>>>> rand-read       22.49   11.17
> >>>>>>>>> seq-write       25.67   10.25
> >>>>>>>>> rand-write      24.13   10.16
> >>>>>>>> Thanks for sharing. Any idea what the bottlenecks are for vduse =
and ublk?
> >>>>>>>>
> >>>>>>> I think one reason for the latency gap of sync I/O is that vduse =
uses
> >>>>>>> workqueue in the I/O completion path but ublk doesn't.
> >>>>>>>
> >>>>>>> And one bottleneck for the async I/O in vduse is that vduse will =
do
> >>>>>>> memcpy inside the critical section of virtqueue's spinlock in the
> >>>>>>> virtio-blk driver. That will hurt the performance heavily when
> >>>>>>> virtio_queue_rq() and virtblk_done() run concurrently. And it can=
 be
> >>>>>>> mitigated by the advance DMA mapping feature [1] or irq binding
> >>>>>>> support [2].
> >>>>>> Hi Yongji,
> >>>>>>
> >>>>>> Yeah, that is the cost you paid for virtio. Wrt. userspace block d=
evice
> >>>>>> or other sort of userspace devices, cmd completion is driven by
> >>>>>> userspace, not sure if one such 'irq' is needed.
> >>>>> I'm not sure, it can be an optional feature in the future if needed=
.
> >>>>>
> >>>>>> Even not sure if virtio
> >>>>>> ring is one good choice for such use case, given io_uring has been=
 proved
> >>>>>> as very efficient(should be better than virtio ring, IMO).
> >>>>>>
> >>>>> Since vduse is aimed at creating a generic userspace device framewo=
rk,
> >>>>> virtio should be the right way IMO.
> >>>> OK, it is the right way, but may not be the effective one.
> >>>>
> >>> Maybe, but I think we can try to optimize it.
> >>>
> >>>>> And with the vdpa framework, the
> >>>>> userspace device can serve both virtual machines and containers.
> >>>> virtio is good for VM, but not sure it is good enough for other
> >>>> cases.
> >>>>
> >>>>> Regarding the performance issue, actually I can't measure how much =
of
> >>>>> the performance loss is due to the difference between virtio ring a=
nd
> >>>>> iouring. But I think it should be very small. The main costs come f=
rom
> >>>>> the two bottlenecks I mentioned before which could be mitigated in =
the
> >>>>> future.
> >>>> Per my understanding, at least there are two places where virtio rin=
g is
> >>>> less efficient than io_uring:
> >>>>
> >>> I might have misunderstood what you mean by virtio ring before. My
> >>> previous understanding of the virtio ring does not include the
> >>> virtio-blk driver.
> >>>
> >>>> 1) io_uring uses standalone submission queue(SQ) and completion queu=
e(CQ),
> >>>> so no contention exists between submission and completion; but virti=
o queue
> >>>> requires per-vq lock in both submission and completion.
> >>>>
> >>> Yes, this is the bottleneck of the virtio-blk driver, even in the VM
> >>> case. We are also trying to optimize this lock.
> >>>
> >>> One way to mitigate it is making submission and completion happen in
> >>> the same core.
> >> QEMU sizes virtio-blk device num-queues to match the vCPU count. The
> >> virtio-blk driver is a blk-mq driver, so submissions and completions
> >> for a given virtqueue should already be processed by the same vCPU.
> >>
> >> Unless the device is misconfigured or the guest software chooses a
> >> custom vq:vCPU mapping, there should be no vq lock contention between
> >> vCPUs.
> >>
> >> I can think of a reason why submission and completion require
> >> coordination: descriptors are occupied until completion. The
> >> submission logic chooses free descriptors from the table. The
> >> completion logic returns free descriptors so they can be used in
> >> future submissions.
> >>
> > Yes, we need to maintain a head pointer of the free descriptors in
> > both submission and completion path.
>
>
> Not necessarily after IN_ORDER?
>

Sounds like a good idea.

Thanks,
Yongji
