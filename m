Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BB760CB78
	for <lists+io-uring@lfdr.de>; Tue, 25 Oct 2022 14:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiJYMCW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Oct 2022 08:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiJYMCV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Oct 2022 08:02:21 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4FB88DD3;
        Tue, 25 Oct 2022 05:02:19 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id r3so14263932yba.5;
        Tue, 25 Oct 2022 05:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4BoUK+JYDPPva7j4PD7TSrYwcj27RYA8797HLT8RhuM=;
        b=e835/8O04RpkidlEaWVZS9q8o2sIfxbfwQShuYhKrXwwI+sF4fy9qsH50KstC4k6CB
         M556TwqZgwffdJB4OiC5nw1d+zXZWWFmSpS7XTyDOnoZZNIxVZr2UgUpaMRA0i5crJwE
         s1CCHOsHs7Wba6ydxNQpuK+l6JPfxx7JZU095fR/NDgd1H/ZeTQmu3nGfrmQJKQOTOwb
         BKKwA/mFbyTUJhtZYW1lCCt5pmeSisehfXMze3TpwP05NQdWk8fcpuAgr0/pJi0Jqemx
         yzaa6Kmh5vDzCEXCpqOsPdkeaAt3/3b8o/16Cv+4SdNxszMbVbDAAC21sTHUQ0YO2DWP
         QxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4BoUK+JYDPPva7j4PD7TSrYwcj27RYA8797HLT8RhuM=;
        b=IqnhexAW/Lb27S9gBlbJseV6O0Ce0XP4/c7L8/cqukbfgIvVSffKRJcb273ZcLhxIo
         3AwHKu4KbgEaUPnzIM73ZSAbYoeE4lnW6U/emX4TjCpg7jBAy5hnFMuBBWM97+5vcXBP
         RteZlwlKDfVhV2sAaOo+rJh0bbrKZzb2N+uEUCWoBYUhEFcMUgOUxEmfLnYKyRjp+xMF
         nqD/LF186MCFgEOYWhvgUJLWSyPJ8r4frfCEXkXo6We9/J1Q7cpYTaTdFrv2P2tEmVwV
         4NehWBMwbPZSuoFeih+pkNVLEC00LztBh6mF9PNFi/C0Juf4ALgUS5rJxFzAbGie3AW0
         1g4A==
X-Gm-Message-State: ACrzQf0vRKd7FZMW9PVKVIZtMQAsyb/HM7DED3l6CF/yrRCLDkLP+1y8
        kNtqs/UEJB26flOwif5y1hyzr+LLpPQSnP4i+8M=
X-Google-Smtp-Source: AMsMyM6AHMEy7EsWdp7yQU+FWqPZK4F7isD+IxeyJ9Luyt0vAt6O/9YrVjaDhUg0wcQJevIhoLDxOhlvIMF/afpABRQ=
X-Received: by 2002:a25:1e89:0:b0:6bf:9e55:5cb4 with SMTP id
 e131-20020a251e89000000b006bf9e555cb4mr34646052ybe.642.1666699338649; Tue, 25
 Oct 2022 05:02:18 -0700 (PDT)
MIME-Version: 1.0
References: <Yza1u1KfKa7ycQm0@T590> <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590> <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <Yz0FrzJVZTqlQtJ5@T590> <50827796-af93-4af5-4121-dc13c31a67fc@linux.alibaba.com>
 <CAJSP0QXW9TmuvJpQPRF-AF01aW79jH8tnkHPEf+do5vQ1crGFA@mail.gmail.com>
 <CACycT3ufcN+a_wtWe6ioOWZUCak-JmcMgSa=rqeEsS63_HqSog@mail.gmail.com>
 <Y0lcmZTP5sr467z6@T590> <CACycT3u8yYUS-WnNzgHQtQFYuK-XcyffpFc35HVZzrCS7hH5Sg@mail.gmail.com>
 <Y05OzeC7wImts4p7@T590> <CACycT3sK1AzA4RH1ZfbstV3oax-oeBVtEz+sY+8scBU0=1x46g@mail.gmail.com>
 <CAJSP0QVevA0gvyGABAFSoMhBN9ydZqUJh4qJYgNbGeyRXL8AjA@mail.gmail.com>
 <CACycT3udzt0nyqweGbAsZB4LDQU=a7OSWKC8ZWieoBpsSfa2FQ@mail.gmail.com>
 <1d051d63-ce34-1bb3-2256-4ced4be6d690@redhat.com> <CACycT3usE0QdJd50bSiLiPwTFxscg-Ur=iZyeGJJBPe7+KxOFQ@mail.gmail.com>
In-Reply-To: <CACycT3usE0QdJd50bSiLiPwTFxscg-Ur=iZyeGJJBPe7+KxOFQ@mail.gmail.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Tue, 25 Oct 2022 08:02:06 -0400
Message-ID: <CAJSP0QUGj4t8nYeJvGaO-cWJ+F3Zvxcq007RHOm-=41zaE-v0Q@mail.gmail.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Jason Wang <jasowang@redhat.com>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 25 Oct 2022 at 04:17, Yongji Xie <xieyongji@bytedance.com> wrote:
>
> On Fri, Oct 21, 2022 at 2:30 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> >
> > =E5=9C=A8 2022/10/21 13:33, Yongji Xie =E5=86=99=E9=81=93:
> > > On Tue, Oct 18, 2022 at 10:54 PM Stefan Hajnoczi <stefanha@gmail.com>=
 wrote:
> > >> On Tue, 18 Oct 2022 at 09:17, Yongji Xie <xieyongji@bytedance.com> w=
rote:
> > >>> On Tue, Oct 18, 2022 at 2:59 PM Ming Lei <tom.leiming@gmail.com> wr=
ote:
> > >>>> On Mon, Oct 17, 2022 at 07:11:59PM +0800, Yongji Xie wrote:
> > >>>>> On Fri, Oct 14, 2022 at 8:57 PM Ming Lei <tom.leiming@gmail.com> =
wrote:
> > >>>>>> On Thu, Oct 13, 2022 at 02:48:04PM +0800, Yongji Xie wrote:
> > >>>>>>> On Wed, Oct 12, 2022 at 10:22 PM Stefan Hajnoczi <stefanha@gmai=
l.com> wrote:
> > >>>>>>>> On Sat, 8 Oct 2022 at 04:43, Ziyang Zhang <ZiyangZhang@linux.a=
libaba.com> wrote:
> > >>>>>>>>> On 2022/10/5 12:18, Ming Lei wrote:
> > >>>>>>>>>> On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wr=
ote:
> > >>>>>>>>>>> On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail.co=
m> wrote:
> > >>>>>>>>>>>> On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnoczi =
wrote:
> > >>>>>>>>>>>>> On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > >>>>>>>>>>>>>> ublk-qcow2 is available now.
> > >>>>>>>>>>>>> Cool, thanks for sharing!
> > >>>>>>>>>>>>>
> > >>>>>>>>>>>>>> So far it provides basic read/write function, and compre=
ssion and snapshot
> > >>>>>>>>>>>>>> aren't supported yet. The target/backend implementation =
is completely
> > >>>>>>>>>>>>>> based on io_uring, and share the same io_uring with ublk=
 IO command
> > >>>>>>>>>>>>>> handler, just like what ublk-loop does.
> > >>>>>>>>>>>>>>
> > >>>>>>>>>>>>>> Follows the main motivations of ublk-qcow2:
> > >>>>>>>>>>>>>>
> > >>>>>>>>>>>>>> - building one complicated target from scratch helps lib=
ublksrv APIs/functions
> > >>>>>>>>>>>>>>    become mature/stable more quickly, since qcow2 is com=
plicated and needs more
> > >>>>>>>>>>>>>>    requirement from libublksrv compared with other simpl=
e ones(loop, null)
> > >>>>>>>>>>>>>>
> > >>>>>>>>>>>>>> - there are several attempts of implementing qcow2 drive=
r in kernel, such as
> > >>>>>>>>>>>>>>    ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2=
(ro)`` [4], so ublk-qcow2
> > >>>>>>>>>>>>>>    might useful be for covering requirement in this fiel=
d
> > >>>>>>>>>>>>>>
> > >>>>>>>>>>>>>> - performance comparison with qemu-nbd, and it was my 1s=
t thought to evaluate
> > >>>>>>>>>>>>>>    performance of ublk/io_uring backend by writing one u=
blk-qcow2 since ublksrv
> > >>>>>>>>>>>>>>    is started
> > >>>>>>>>>>>>>>
> > >>>>>>>>>>>>>> - help to abstract common building block or design patte=
rn for writing new ublk
> > >>>>>>>>>>>>>>    target/backend
> > >>>>>>>>>>>>>>
> > >>>>>>>>>>>>>> So far it basically passes xfstest(XFS) test by using ub=
lk-qcow2 block
> > >>>>>>>>>>>>>> device as TEST_DEV, and kernel building workload is veri=
fied too. Also
> > >>>>>>>>>>>>>> soft update approach is applied in meta flushing, and me=
ta data
> > >>>>>>>>>>>>>> integrity is guaranteed, 'make test T=3Dqcow2/040' cover=
s this kind of
> > >>>>>>>>>>>>>> test, and only cluster leak is reported during this test=
.
> > >>>>>>>>>>>>>>
> > >>>>>>>>>>>>>> The performance data looks much better compared with qem=
u-nbd, see
> > >>>>>>>>>>>>>> details in commit log[1], README[5] and STATUS[6]. And t=
he test covers both
> > >>>>>>>>>>>>>> empty image and pre-allocated image, for example of pre-=
allocated qcow2
> > >>>>>>>>>>>>>> image(8GB):
> > >>>>>>>>>>>>>>
> > >>>>>>>>>>>>>> - qemu-nbd (make test T=3Dqcow2/002)
> > >>>>>>>>>>>>> Single queue?
> > >>>>>>>>>>>> Yeah.
> > >>>>>>>>>>>>
> > >>>>>>>>>>>>>>      randwrite(4k): jobs 1, iops 24605
> > >>>>>>>>>>>>>>      randread(4k): jobs 1, iops 30938
> > >>>>>>>>>>>>>>      randrw(4k): jobs 1, iops read 13981 write 14001
> > >>>>>>>>>>>>>>      rw(512k): jobs 1, iops read 724 write 728
> > >>>>>>>>>>>>> Please try qemu-storage-daemon's VDUSE export type as wel=
l. The
> > >>>>>>>>>>>>> command-line should be similar to this:
> > >>>>>>>>>>>>>
> > >>>>>>>>>>>>>    # modprobe virtio_vdpa # attaches vDPA devices to host=
 kernel
> > >>>>>>>>>>>> Not found virtio_vdpa module even though I enabled all the=
 following
> > >>>>>>>>>>>> options:
> > >>>>>>>>>>>>
> > >>>>>>>>>>>>          --- vDPA drivers
> > >>>>>>>>>>>>            <M>   vDPA device simulator core
> > >>>>>>>>>>>>            <M>     vDPA simulator for networking device
> > >>>>>>>>>>>>            <M>     vDPA simulator for block device
> > >>>>>>>>>>>>            <M>   VDUSE (vDPA Device in Userspace) support
> > >>>>>>>>>>>>            <M>   Intel IFC VF vDPA driver
> > >>>>>>>>>>>>            <M>   Virtio PCI bridge vDPA driver
> > >>>>>>>>>>>>            <M>   vDPA driver for Alibaba ENI
> > >>>>>>>>>>>>
> > >>>>>>>>>>>> BTW, my test environment is VM and the shared data is done=
 in VM too, and
> > >>>>>>>>>>>> can virtio_vdpa be used inside VM?
> > >>>>>>>>>>> I hope Xie Yongji can help explain how to benchmark VDUSE.
> > >>>>>>>>>>>
> > >>>>>>>>>>> virtio_vdpa is available inside guests too. Please check th=
at
> > >>>>>>>>>>> VIRTIO_VDPA ("vDPA driver for virtio devices") is enabled i=
n "Virtio
> > >>>>>>>>>>> drivers" menu.
> > >>>>>>>>>>>
> > >>>>>>>>>>>>>    # modprobe vduse
> > >>>>>>>>>>>>>    # qemu-storage-daemon \
> > >>>>>>>>>>>>>        --blockdev file,filename=3Dtest.qcow2,cache.direct=
=3Dof|off,aio=3Dnative,node-name=3Dfile \
> > >>>>>>>>>>>>>        --blockdev qcow2,file=3Dfile,node-name=3Dqcow2 \
> > >>>>>>>>>>>>>        --object iothread,id=3Diothread0 \
> > >>>>>>>>>>>>>        --export vduse-blk,id=3Dvduse0,name=3Dvduse0,num-q=
ueues=3D$(nproc),node-name=3Dqcow2,writable=3Don,iothread=3Diothread0
> > >>>>>>>>>>>>>    # vdpa dev add name vduse0 mgmtdev vduse
> > >>>>>>>>>>>>>
> > >>>>>>>>>>>>> A virtio-blk device should appear and xfstests can be run=
 on it
> > >>>>>>>>>>>>> (typically /dev/vda unless you already have other virtio-=
blk devices).
> > >>>>>>>>>>>>>
> > >>>>>>>>>>>>> Afterwards you can destroy the device using:
> > >>>>>>>>>>>>>
> > >>>>>>>>>>>>>    # vdpa dev del vduse0
> > >>>>>>>>>>>>>
> > >>>>>>>>>>>>>> - ublk-qcow2 (make test T=3Dqcow2/022)
> > >>>>>>>>>>>>> There are a lot of other factors not directly related to =
NBD vs ublk. In
> > >>>>>>>>>>>>> order to get an apples-to-apples comparison with qemu-* a=
 ublk export
> > >>>>>>>>>>>>> type is needed in qemu-storage-daemon. That way only the =
difference is
> > >>>>>>>>>>>>> the ublk interface and the rest of the code path is ident=
ical, making it
> > >>>>>>>>>>>>> possible to compare NBD, VDUSE, ublk, etc more precisely.
> > >>>>>>>>>>>> Maybe not true.
> > >>>>>>>>>>>>
> > >>>>>>>>>>>> ublk-qcow2 uses io_uring to handle all backend IO(include =
meta IO) completely,
> > >>>>>>>>>>>> and so far single io_uring/pthread is for handling all qco=
w2 IOs and IO
> > >>>>>>>>>>>> command.
> > >>>>>>>>>>> qemu-nbd doesn't use io_uring to handle the backend IO, so =
we don't
> > >>>>>>>>>> I tried to use it via --aio=3Dio_uring for setting up qemu-n=
bd, but not succeed.
> > >>>>>>>>>>
> > >>>>>>>>>>> know whether the benchmark demonstrates that ublk is faster=
 than NBD,
> > >>>>>>>>>>> that the ublk-qcow2 implementation is faster than qemu-nbd'=
s qcow2,
> > >>>>>>>>>>> whether there are miscellaneous implementation differences =
between
> > >>>>>>>>>>> ublk-qcow2 and qemu-nbd (like using the same io_uring conte=
xt for both
> > >>>>>>>>>>> ublk and backend IO), or something else.
> > >>>>>>>>>> The theory shouldn't be too complicated:
> > >>>>>>>>>>
> > >>>>>>>>>> 1) io uring passthough(pt) communication is fast than socket=
, and io command
> > >>>>>>>>>> is carried over io_uring pt commands, and should be fast tha=
n virio
> > >>>>>>>>>> communication too.
> > >>>>>>>>>>
> > >>>>>>>>>> 2) io uring io handling is fast than libaio which is taken i=
n the
> > >>>>>>>>>> test on qemu-nbd, and all qcow2 backend io(include meta io) =
is handled
> > >>>>>>>>>> by io_uring.
> > >>>>>>>>>>
> > >>>>>>>>>> https://github.com/ming1/ubdsrv/blob/master/tests/common/qco=
w2_common
> > >>>>>>>>>>
> > >>>>>>>>>> 3) ublk uses one single io_uring to handle all io commands a=
nd qcow2
> > >>>>>>>>>> backend IOs, so batching handling is common, and it is easy =
to see
> > >>>>>>>>>> dozens of IOs/io commands handled in single syscall, or even=
 more.
> > >>>>>>>>>>
> > >>>>>>>>>>> I'm suggesting measuring changes to just 1 variable at a ti=
me.
> > >>>>>>>>>>> Otherwise it's hard to reach a conclusion about the root ca=
use of the
> > >>>>>>>>>>> performance difference. Let's learn why ublk-qcow2 performs=
 well.
> > >>>>>>>>>> Turns out the latest Fedora 37-beta doesn't support vdpa yet=
, so I built
> > >>>>>>>>>> qemu from the latest github tree, and finally it starts to w=
ork. And test kernel
> > >>>>>>>>>> is v6.0 release.
> > >>>>>>>>>>
> > >>>>>>>>>> Follows the test result, and all three devices are setup as =
single
> > >>>>>>>>>> queue, and all tests are run in single job, still done in on=
e VM, and
> > >>>>>>>>>> the test images are stored on XFS/virito-scsi backed SSD.
> > >>>>>>>>>>
> > >>>>>>>>>> The 1st group tests all three block device which is backed b=
y empty
> > >>>>>>>>>> qcow2 image.
> > >>>>>>>>>>
> > >>>>>>>>>> The 2nd group tests all the three block devices backed by pr=
e-allocated
> > >>>>>>>>>> qcow2 image.
> > >>>>>>>>>>
> > >>>>>>>>>> Except for big sequential IO(512K), there is still not small=
 gap between
> > >>>>>>>>>> vdpa-virtio-blk and ublk.
> > >>>>>>>>>>
> > >>>>>>>>>> 1. run fio on block device over empty qcow2 image
> > >>>>>>>>>> 1) qemu-nbd
> > >>>>>>>>>> running qcow2/001
> > >>>>>>>>>> run perf test on empty qcow2 image via nbd
> > >>>>>>>>>>        fio (nbd(/mnt/data/ublk_null_8G_nYbgF.qcow2), libaio,=
 bs 4k, dio, hw queues:1)...
> > >>>>>>>>>>        randwrite: jobs 1, iops 8549
> > >>>>>>>>>>        randread: jobs 1, iops 34829
> > >>>>>>>>>>        randrw: jobs 1, iops read 11363 write 11333
> > >>>>>>>>>>        rw(512k): jobs 1, iops read 590 write 597
> > >>>>>>>>>>
> > >>>>>>>>>>
> > >>>>>>>>>> 2) ublk-qcow2
> > >>>>>>>>>> running qcow2/021
> > >>>>>>>>>> run perf test on empty qcow2 image via ublk
> > >>>>>>>>>>        fio (ublk/qcow2( -f /mnt/data/ublk_null_8G_s761j.qcow=
2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > >>>>>>>>>>        randwrite: jobs 1, iops 16086
> > >>>>>>>>>>        randread: jobs 1, iops 172720
> > >>>>>>>>>>        randrw: jobs 1, iops read 35760 write 35702
> > >>>>>>>>>>        rw(512k): jobs 1, iops read 1140 write 1149
> > >>>>>>>>>>
> > >>>>>>>>>> 3) vdpa-virtio-blk
> > >>>>>>>>>> running debug/test_dev
> > >>>>>>>>>> run io test on specified device
> > >>>>>>>>>>        fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)=
...
> > >>>>>>>>>>        randwrite: jobs 1, iops 8626
> > >>>>>>>>>>        randread: jobs 1, iops 126118
> > >>>>>>>>>>        randrw: jobs 1, iops read 17698 write 17665
> > >>>>>>>>>>        rw(512k): jobs 1, iops read 1023 write 1031
> > >>>>>>>>>>
> > >>>>>>>>>>
> > >>>>>>>>>> 2. run fio on block device over pre-allocated qcow2 image
> > >>>>>>>>>> 1) qemu-nbd
> > >>>>>>>>>> running qcow2/002
> > >>>>>>>>>> run perf test on pre-allocated qcow2 image via nbd
> > >>>>>>>>>>        fio (nbd(/mnt/data/ublk_data_8G_sc0SB.qcow2), libaio,=
 bs 4k, dio, hw queues:1)...
> > >>>>>>>>>>        randwrite: jobs 1, iops 21439
> > >>>>>>>>>>        randread: jobs 1, iops 30336
> > >>>>>>>>>>        randrw: jobs 1, iops read 11476 write 11449
> > >>>>>>>>>>        rw(512k): jobs 1, iops read 718 write 722
> > >>>>>>>>>>
> > >>>>>>>>>> 2) ublk-qcow2
> > >>>>>>>>>> running qcow2/022
> > >>>>>>>>>> run perf test on pre-allocated qcow2 image via ublk
> > >>>>>>>>>>        fio (ublk/qcow2( -f /mnt/data/ublk_data_8G_yZiaJ.qcow=
2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > >>>>>>>>>>        randwrite: jobs 1, iops 98757
> > >>>>>>>>>>        randread: jobs 1, iops 110246
> > >>>>>>>>>>        randrw: jobs 1, iops read 47229 write 47161
> > >>>>>>>>>>        rw(512k): jobs 1, iops read 1416 write 1427
> > >>>>>>>>>>
> > >>>>>>>>>> 3) vdpa-virtio-blk
> > >>>>>>>>>> running debug/test_dev
> > >>>>>>>>>> run io test on specified device
> > >>>>>>>>>>        fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)=
...
> > >>>>>>>>>>        randwrite: jobs 1, iops 47317
> > >>>>>>>>>>        randread: jobs 1, iops 74092
> > >>>>>>>>>>        randrw: jobs 1, iops read 27196 write 27234
> > >>>>>>>>>>        rw(512k): jobs 1, iops read 1447 write 1458
> > >>>>>>>>>>
> > >>>>>>>>>>
> > >>>>>>>>> Hi All,
> > >>>>>>>>>
> > >>>>>>>>> We are interested in VDUSE vs UBLK, too. And I have tested th=
em with nullblk backend.
> > >>>>>>>>> Let me share some results here.
> > >>>>>>>>>
> > >>>>>>>>> I setup UBLK with:
> > >>>>>>>>>    ublk add -t loop -f /dev/nullb0 -d QUEUE_DEPTH -q NR_QUEUE
> > >>>>>>>>>
> > >>>>>>>>> I setup VDUSE with:
> > >>>>>>>>>    qemu-storage-daemon \
> > >>>>>>>>>         --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.soc=
k,server=3Don,wait=3Doff \
> > >>>>>>>>>         --monitor chardev=3Dcharmonitor \
> > >>>>>>>>>         --blockdev driver=3Dhost_device,cache.direct=3Don,fil=
ename=3D/dev/nullb0,node-name=3Ddisk0 \
> > >>>>>>>>>         --export vduse-blk,id=3Dtest,node-name=3Ddisk0,name=
=3Dvduse_test,writable=3Don,num-queues=3DNR_QUEUE,queue-size=3DQUEUE_DEPTH
> > >>>>>>>>>
> > >>>>>>>>> Here QUEUE_DEPTH is 1, 32 or 128 and NR_QUEUE is 1 or 4.
> > >>>>>>>>>
> > >>>>>>>>> Note:
> > >>>>>>>>> (1) VDUSE requires QUEUE_DEPTH >=3D 2. I cannot setup QUEUE_D=
EPTH to 1.
> > >>>>>>>>> (2) I use qemu 7.1.0-rc3. It supports vduse-blk.
> > >>>>>>>>> (3) I do not use ublk null target so that the test is fair.
> > >>>>>>>>> (4) I setup fio with direct=3D1, bs=3D4k.
> > >>>>>>>>>
> > >>>>>>>>> ------------------------------
> > >>>>>>>>> 1 job 1 iodepth, lat=EF=BC=88usec)
> > >>>>>>>>>                  vduse   ublk
> > >>>>>>>>> seq-read        22.55   11.15
> > >>>>>>>>> rand-read       22.49   11.17
> > >>>>>>>>> seq-write       25.67   10.25
> > >>>>>>>>> rand-write      24.13   10.16
> > >>>>>>>> Thanks for sharing. Any idea what the bottlenecks are for vdus=
e and ublk?
> > >>>>>>>>
> > >>>>>>> I think one reason for the latency gap of sync I/O is that vdus=
e uses
> > >>>>>>> workqueue in the I/O completion path but ublk doesn't.
> > >>>>>>>
> > >>>>>>> And one bottleneck for the async I/O in vduse is that vduse wil=
l do
> > >>>>>>> memcpy inside the critical section of virtqueue's spinlock in t=
he
> > >>>>>>> virtio-blk driver. That will hurt the performance heavily when
> > >>>>>>> virtio_queue_rq() and virtblk_done() run concurrently. And it c=
an be
> > >>>>>>> mitigated by the advance DMA mapping feature [1] or irq binding
> > >>>>>>> support [2].
> > >>>>>> Hi Yongji,
> > >>>>>>
> > >>>>>> Yeah, that is the cost you paid for virtio. Wrt. userspace block=
 device
> > >>>>>> or other sort of userspace devices, cmd completion is driven by
> > >>>>>> userspace, not sure if one such 'irq' is needed.
> > >>>>> I'm not sure, it can be an optional feature in the future if need=
ed.
> > >>>>>
> > >>>>>> Even not sure if virtio
> > >>>>>> ring is one good choice for such use case, given io_uring has be=
en proved
> > >>>>>> as very efficient(should be better than virtio ring, IMO).
> > >>>>>>
> > >>>>> Since vduse is aimed at creating a generic userspace device frame=
work,
> > >>>>> virtio should be the right way IMO.
> > >>>> OK, it is the right way, but may not be the effective one.
> > >>>>
> > >>> Maybe, but I think we can try to optimize it.
> > >>>
> > >>>>> And with the vdpa framework, the
> > >>>>> userspace device can serve both virtual machines and containers.
> > >>>> virtio is good for VM, but not sure it is good enough for other
> > >>>> cases.
> > >>>>
> > >>>>> Regarding the performance issue, actually I can't measure how muc=
h of
> > >>>>> the performance loss is due to the difference between virtio ring=
 and
> > >>>>> iouring. But I think it should be very small. The main costs come=
 from
> > >>>>> the two bottlenecks I mentioned before which could be mitigated i=
n the
> > >>>>> future.
> > >>>> Per my understanding, at least there are two places where virtio r=
ing is
> > >>>> less efficient than io_uring:
> > >>>>
> > >>> I might have misunderstood what you mean by virtio ring before. My
> > >>> previous understanding of the virtio ring does not include the
> > >>> virtio-blk driver.
> > >>>
> > >>>> 1) io_uring uses standalone submission queue(SQ) and completion qu=
eue(CQ),
> > >>>> so no contention exists between submission and completion; but vir=
tio queue
> > >>>> requires per-vq lock in both submission and completion.
> > >>>>
> > >>> Yes, this is the bottleneck of the virtio-blk driver, even in the V=
M
> > >>> case. We are also trying to optimize this lock.
> > >>>
> > >>> One way to mitigate it is making submission and completion happen i=
n
> > >>> the same core.
> > >> QEMU sizes virtio-blk device num-queues to match the vCPU count. The
> > >> virtio-blk driver is a blk-mq driver, so submissions and completions
> > >> for a given virtqueue should already be processed by the same vCPU.
> > >>
> > >> Unless the device is misconfigured or the guest software chooses a
> > >> custom vq:vCPU mapping, there should be no vq lock contention betwee=
n
> > >> vCPUs.
> > >>
> > >> I can think of a reason why submission and completion require
> > >> coordination: descriptors are occupied until completion. The
> > >> submission logic chooses free descriptors from the table. The
> > >> completion logic returns free descriptors so they can be used in
> > >> future submissions.
> > >>
> > > Yes, we need to maintain a head pointer of the free descriptors in
> > > both submission and completion path.
> >
> >
> > Not necessarily after IN_ORDER?
> >
>
> Sounds like a good idea.

Submission and completion are still not 100% independent with IN_ORDER
because descriptors are still in use until completion. It may not be
necessary to keep a freelist, but you cannot actually use the
descriptors for new submissions until existing requests complete. Is
that correct?

Anyway, independent submission and completion rings aren't perfect
either because independent submission introduces a new point of
communication: the device must tell the driver when submitted
descriptors have been processed. That means the driver must access a
hardware register on the device or the device must DMA to RAM. So it
involves extra bus traffic that is not necessary if descriptors are in
use until completion. io_uring gets away with it because the
io_uring_enter(2) syscall is synchronous and can therefore return the
number of consumed sq elements for free.

There are ways to minimize that cost:
1. The driver only needs to fetch the device's sq index when it has
run out of sq ring space.
2. The device can include sq index updates with completions. This is
what NVMe does with the CQE SQ Head Pointer field, but the
disadvantage is that the driver has no way of determining the sq index
until a completion occurs.

Stefan
