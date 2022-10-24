Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51B260B458
	for <lists+io-uring@lfdr.de>; Mon, 24 Oct 2022 19:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiJXRjc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Oct 2022 13:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbiJXRiz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Oct 2022 13:38:55 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48947D40;
        Mon, 24 Oct 2022 09:14:29 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id o70so11551513yba.7;
        Mon, 24 Oct 2022 09:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ATFwkykOyAaci5wDcDcUKYVL1U6HaRl0qiEFMft9KL8=;
        b=aWFz44F/QL8du5av45lr19sZAQqs7pr6MnQ5zcqA1mvNJ5T9cmr03R4rH1OK4rGXqv
         FNEfnwTrtP7DUXQyzNHrUyq0xOX3V9RlRtsk3OxDzUCwWmwYz+SqmUTAYUfpY/FZqCN2
         HBMiXYgysl5JeL1/sc0ViSnp331OyZtzCRGuyAD1h0W3Mir2cIY10ZO3/URSz2536dkz
         js9ADn9ensvqbtXyby2HpvNsOg9r52Spc+URFueRCak+Z4ba2DaXxWbe+5hV0iEWzrY9
         a8giUZEFb8R+m2TvFGVmPZYmYSQiUDPQmXC1r7KnbRaf6KHqxU1gd5NhMnm9ye8eeQGm
         EA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ATFwkykOyAaci5wDcDcUKYVL1U6HaRl0qiEFMft9KL8=;
        b=tc8J35dY784XKGLqvQk+4jgcI74cS/NCQ1UUS7ag1Ab0jOYe8QxOTweMm9NFsQ2Hfh
         qC2H2dd4aojzcP7dbGQt+/bRDrgA+RfW85M4ZdiiPswCKTyPTfmEVMCTH8JQG0qyNrZ7
         4KqkMHTyYPKiRjoiCcx0OfsC1FUuosTFknlyVm7w/4KvesUeB/cxrQ+8zjDQJzlEFQ8a
         qGRQBxw1J/dwGauIUyb5qv3XFCoQmYimVH9ylbzxClNtB1dvujf1ly1ku2wQfI6btGA5
         W6+Wb6aXJGs43HS2xdPKE1SGD3nRRZDKIx18wwFzH1JUQAvl5ygSC6W9fzKkaNnnx0QJ
         9jPQ==
X-Gm-Message-State: ACrzQf2T1UksWgZCzh090uqFe10XRDqlUVJujjmvhdJMzZ2DDTePZQgu
        AEwj/tJ0c3co0qVq9i0LX5aNkypeucDFlP8j1FU=
X-Google-Smtp-Source: AMsMyM50bchyetcRXhNbsQcJcX0g/9HlmAxvXz+5fzmEhJaaVce0rvzBnz0E3qMTMl/j7jcBecEjSTDdXmow7LMNHpM=
X-Received: by 2002:a25:b098:0:b0:6ca:4484:486c with SMTP id
 f24-20020a25b098000000b006ca4484486cmr19631908ybj.209.1666627918532; Mon, 24
 Oct 2022 09:11:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <Yz0FrzJVZTqlQtJ5@T590> <50827796-af93-4af5-4121-dc13c31a67fc@linux.alibaba.com>
 <CAJSP0QXW9TmuvJpQPRF-AF01aW79jH8tnkHPEf+do5vQ1crGFA@mail.gmail.com>
 <CACycT3ufcN+a_wtWe6ioOWZUCak-JmcMgSa=rqeEsS63_HqSog@mail.gmail.com>
 <Y0lcmZTP5sr467z6@T590> <CACycT3u8yYUS-WnNzgHQtQFYuK-XcyffpFc35HVZzrCS7hH5Sg@mail.gmail.com>
 <Y05OzeC7wImts4p7@T590> <CACycT3sK1AzA4RH1ZfbstV3oax-oeBVtEz+sY+8scBU0=1x46g@mail.gmail.com>
 <CAJSP0QVevA0gvyGABAFSoMhBN9ydZqUJh4qJYgNbGeyRXL8AjA@mail.gmail.com> <Y0++r6NQxbqCzglK@T590>
In-Reply-To: <Y0++r6NQxbqCzglK@T590>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 24 Oct 2022 12:11:46 -0400
Message-ID: <CAJSP0QVgHPKJxBJkzkB_oLVZf6ZKikYTWh+GBUVBsmND_5MwFg@mail.gmail.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
To:     Ming Lei <tom.leiming@gmail.com>
Cc:     Yongji Xie <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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

On Wed, 19 Oct 2022 at 05:09, Ming Lei <tom.leiming@gmail.com> wrote:
>
> On Tue, Oct 18, 2022 at 10:54:45AM -0400, Stefan Hajnoczi wrote:
> > On Tue, 18 Oct 2022 at 09:17, Yongji Xie <xieyongji@bytedance.com> wrot=
e:
> > >
> > > On Tue, Oct 18, 2022 at 2:59 PM Ming Lei <tom.leiming@gmail.com> wrot=
e:
> > > >
> > > > On Mon, Oct 17, 2022 at 07:11:59PM +0800, Yongji Xie wrote:
> > > > > On Fri, Oct 14, 2022 at 8:57 PM Ming Lei <tom.leiming@gmail.com> =
wrote:
> > > > > >
> > > > > > On Thu, Oct 13, 2022 at 02:48:04PM +0800, Yongji Xie wrote:
> > > > > > > On Wed, Oct 12, 2022 at 10:22 PM Stefan Hajnoczi <stefanha@gm=
ail.com> wrote:
> > > > > > > >
> > > > > > > > On Sat, 8 Oct 2022 at 04:43, Ziyang Zhang <ZiyangZhang@linu=
x.alibaba.com> wrote:
> > > > > > > > >
> > > > > > > > > On 2022/10/5 12:18, Ming Lei wrote:
> > > > > > > > > > On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoc=
zi wrote:
> > > > > > > > > >> On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gma=
il.com> wrote:
> > > > > > > > > >>>
> > > > > > > > > >>> On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajn=
oczi wrote:
> > > > > > > > > >>>> On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei w=
rote:
> > > > > > > > > >>>>> ublk-qcow2 is available now.
> > > > > > > > > >>>>
> > > > > > > > > >>>> Cool, thanks for sharing!
> > > > > > > > > >>>>
> > > > > > > > > >>>>>
> > > > > > > > > >>>>> So far it provides basic read/write function, and c=
ompression and snapshot
> > > > > > > > > >>>>> aren't supported yet. The target/backend implementa=
tion is completely
> > > > > > > > > >>>>> based on io_uring, and share the same io_uring with=
 ublk IO command
> > > > > > > > > >>>>> handler, just like what ublk-loop does.
> > > > > > > > > >>>>>
> > > > > > > > > >>>>> Follows the main motivations of ublk-qcow2:
> > > > > > > > > >>>>>
> > > > > > > > > >>>>> - building one complicated target from scratch help=
s libublksrv APIs/functions
> > > > > > > > > >>>>>   become mature/stable more quickly, since qcow2 is=
 complicated and needs more
> > > > > > > > > >>>>>   requirement from libublksrv compared with other s=
imple ones(loop, null)
> > > > > > > > > >>>>>
> > > > > > > > > >>>>> - there are several attempts of implementing qcow2 =
driver in kernel, such as
> > > > > > > > > >>>>>   ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel q=
cow2(ro)`` [4], so ublk-qcow2
> > > > > > > > > >>>>>   might useful be for covering requirement in this =
field
> > > > > > > > > >>>>>
> > > > > > > > > >>>>> - performance comparison with qemu-nbd, and it was =
my 1st thought to evaluate
> > > > > > > > > >>>>>   performance of ublk/io_uring backend by writing o=
ne ublk-qcow2 since ublksrv
> > > > > > > > > >>>>>   is started
> > > > > > > > > >>>>>
> > > > > > > > > >>>>> - help to abstract common building block or design =
pattern for writing new ublk
> > > > > > > > > >>>>>   target/backend
> > > > > > > > > >>>>>
> > > > > > > > > >>>>> So far it basically passes xfstest(XFS) test by usi=
ng ublk-qcow2 block
> > > > > > > > > >>>>> device as TEST_DEV, and kernel building workload is=
 verified too. Also
> > > > > > > > > >>>>> soft update approach is applied in meta flushing, a=
nd meta data
> > > > > > > > > >>>>> integrity is guaranteed, 'make test T=3Dqcow2/040' =
covers this kind of
> > > > > > > > > >>>>> test, and only cluster leak is reported during this=
 test.
> > > > > > > > > >>>>>
> > > > > > > > > >>>>> The performance data looks much better compared wit=
h qemu-nbd, see
> > > > > > > > > >>>>> details in commit log[1], README[5] and STATUS[6]. =
And the test covers both
> > > > > > > > > >>>>> empty image and pre-allocated image, for example of=
 pre-allocated qcow2
> > > > > > > > > >>>>> image(8GB):
> > > > > > > > > >>>>>
> > > > > > > > > >>>>> - qemu-nbd (make test T=3Dqcow2/002)
> > > > > > > > > >>>>
> > > > > > > > > >>>> Single queue?
> > > > > > > > > >>>
> > > > > > > > > >>> Yeah.
> > > > > > > > > >>>
> > > > > > > > > >>>>
> > > > > > > > > >>>>>     randwrite(4k): jobs 1, iops 24605
> > > > > > > > > >>>>>     randread(4k): jobs 1, iops 30938
> > > > > > > > > >>>>>     randrw(4k): jobs 1, iops read 13981 write 14001
> > > > > > > > > >>>>>     rw(512k): jobs 1, iops read 724 write 728
> > > > > > > > > >>>>
> > > > > > > > > >>>> Please try qemu-storage-daemon's VDUSE export type a=
s well. The
> > > > > > > > > >>>> command-line should be similar to this:
> > > > > > > > > >>>>
> > > > > > > > > >>>>   # modprobe virtio_vdpa # attaches vDPA devices to =
host kernel
> > > > > > > > > >>>
> > > > > > > > > >>> Not found virtio_vdpa module even though I enabled al=
l the following
> > > > > > > > > >>> options:
> > > > > > > > > >>>
> > > > > > > > > >>>         --- vDPA drivers
> > > > > > > > > >>>           <M>   vDPA device simulator core
> > > > > > > > > >>>           <M>     vDPA simulator for networking devic=
e
> > > > > > > > > >>>           <M>     vDPA simulator for block device
> > > > > > > > > >>>           <M>   VDUSE (vDPA Device in Userspace) supp=
ort
> > > > > > > > > >>>           <M>   Intel IFC VF vDPA driver
> > > > > > > > > >>>           <M>   Virtio PCI bridge vDPA driver
> > > > > > > > > >>>           <M>   vDPA driver for Alibaba ENI
> > > > > > > > > >>>
> > > > > > > > > >>> BTW, my test environment is VM and the shared data is=
 done in VM too, and
> > > > > > > > > >>> can virtio_vdpa be used inside VM?
> > > > > > > > > >>
> > > > > > > > > >> I hope Xie Yongji can help explain how to benchmark VD=
USE.
> > > > > > > > > >>
> > > > > > > > > >> virtio_vdpa is available inside guests too. Please che=
ck that
> > > > > > > > > >> VIRTIO_VDPA ("vDPA driver for virtio devices") is enab=
led in "Virtio
> > > > > > > > > >> drivers" menu.
> > > > > > > > > >>
> > > > > > > > > >>>
> > > > > > > > > >>>>   # modprobe vduse
> > > > > > > > > >>>>   # qemu-storage-daemon \
> > > > > > > > > >>>>       --blockdev file,filename=3Dtest.qcow2,cache.di=
rect=3Dof|off,aio=3Dnative,node-name=3Dfile \
> > > > > > > > > >>>>       --blockdev qcow2,file=3Dfile,node-name=3Dqcow2=
 \
> > > > > > > > > >>>>       --object iothread,id=3Diothread0 \
> > > > > > > > > >>>>       --export vduse-blk,id=3Dvduse0,name=3Dvduse0,n=
um-queues=3D$(nproc),node-name=3Dqcow2,writable=3Don,iothread=3Diothread0
> > > > > > > > > >>>>   # vdpa dev add name vduse0 mgmtdev vduse
> > > > > > > > > >>>>
> > > > > > > > > >>>> A virtio-blk device should appear and xfstests can b=
e run on it
> > > > > > > > > >>>> (typically /dev/vda unless you already have other vi=
rtio-blk devices).
> > > > > > > > > >>>>
> > > > > > > > > >>>> Afterwards you can destroy the device using:
> > > > > > > > > >>>>
> > > > > > > > > >>>>   # vdpa dev del vduse0
> > > > > > > > > >>>>
> > > > > > > > > >>>>>
> > > > > > > > > >>>>> - ublk-qcow2 (make test T=3Dqcow2/022)
> > > > > > > > > >>>>
> > > > > > > > > >>>> There are a lot of other factors not directly relate=
d to NBD vs ublk. In
> > > > > > > > > >>>> order to get an apples-to-apples comparison with qem=
u-* a ublk export
> > > > > > > > > >>>> type is needed in qemu-storage-daemon. That way only=
 the difference is
> > > > > > > > > >>>> the ublk interface and the rest of the code path is =
identical, making it
> > > > > > > > > >>>> possible to compare NBD, VDUSE, ublk, etc more preci=
sely.
> > > > > > > > > >>>
> > > > > > > > > >>> Maybe not true.
> > > > > > > > > >>>
> > > > > > > > > >>> ublk-qcow2 uses io_uring to handle all backend IO(inc=
lude meta IO) completely,
> > > > > > > > > >>> and so far single io_uring/pthread is for handling al=
l qcow2 IOs and IO
> > > > > > > > > >>> command.
> > > > > > > > > >>
> > > > > > > > > >> qemu-nbd doesn't use io_uring to handle the backend IO=
, so we don't
> > > > > > > > > >
> > > > > > > > > > I tried to use it via --aio=3Dio_uring for setting up q=
emu-nbd, but not succeed.
> > > > > > > > > >
> > > > > > > > > >> know whether the benchmark demonstrates that ublk is f=
aster than NBD,
> > > > > > > > > >> that the ublk-qcow2 implementation is faster than qemu=
-nbd's qcow2,
> > > > > > > > > >> whether there are miscellaneous implementation differe=
nces between
> > > > > > > > > >> ublk-qcow2 and qemu-nbd (like using the same io_uring =
context for both
> > > > > > > > > >> ublk and backend IO), or something else.
> > > > > > > > > >
> > > > > > > > > > The theory shouldn't be too complicated:
> > > > > > > > > >
> > > > > > > > > > 1) io uring passthough(pt) communication is fast than s=
ocket, and io command
> > > > > > > > > > is carried over io_uring pt commands, and should be fas=
t than virio
> > > > > > > > > > communication too.
> > > > > > > > > >
> > > > > > > > > > 2) io uring io handling is fast than libaio which is ta=
ken in the
> > > > > > > > > > test on qemu-nbd, and all qcow2 backend io(include meta=
 io) is handled
> > > > > > > > > > by io_uring.
> > > > > > > > > >
> > > > > > > > > > https://github.com/ming1/ubdsrv/blob/master/tests/commo=
n/qcow2_common
> > > > > > > > > >
> > > > > > > > > > 3) ublk uses one single io_uring to handle all io comma=
nds and qcow2
> > > > > > > > > > backend IOs, so batching handling is common, and it is =
easy to see
> > > > > > > > > > dozens of IOs/io commands handled in single syscall, or=
 even more.
> > > > > > > > > >
> > > > > > > > > >>
> > > > > > > > > >> I'm suggesting measuring changes to just 1 variable at=
 a time.
> > > > > > > > > >> Otherwise it's hard to reach a conclusion about the ro=
ot cause of the
> > > > > > > > > >> performance difference. Let's learn why ublk-qcow2 per=
forms well.
> > > > > > > > > >
> > > > > > > > > > Turns out the latest Fedora 37-beta doesn't support vdp=
a yet, so I built
> > > > > > > > > > qemu from the latest github tree, and finally it starts=
 to work. And test kernel
> > > > > > > > > > is v6.0 release.
> > > > > > > > > >
> > > > > > > > > > Follows the test result, and all three devices are setu=
p as single
> > > > > > > > > > queue, and all tests are run in single job, still done =
in one VM, and
> > > > > > > > > > the test images are stored on XFS/virito-scsi backed SS=
D.
> > > > > > > > > >
> > > > > > > > > > The 1st group tests all three block device which is bac=
ked by empty
> > > > > > > > > > qcow2 image.
> > > > > > > > > >
> > > > > > > > > > The 2nd group tests all the three block devices backed =
by pre-allocated
> > > > > > > > > > qcow2 image.
> > > > > > > > > >
> > > > > > > > > > Except for big sequential IO(512K), there is still not =
small gap between
> > > > > > > > > > vdpa-virtio-blk and ublk.
> > > > > > > > > >
> > > > > > > > > > 1. run fio on block device over empty qcow2 image
> > > > > > > > > > 1) qemu-nbd
> > > > > > > > > > running qcow2/001
> > > > > > > > > > run perf test on empty qcow2 image via nbd
> > > > > > > > > >       fio (nbd(/mnt/data/ublk_null_8G_nYbgF.qcow2), lib=
aio, bs 4k, dio, hw queues:1)...
> > > > > > > > > >       randwrite: jobs 1, iops 8549
> > > > > > > > > >       randread: jobs 1, iops 34829
> > > > > > > > > >       randrw: jobs 1, iops read 11363 write 11333
> > > > > > > > > >       rw(512k): jobs 1, iops read 590 write 597
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > 2) ublk-qcow2
> > > > > > > > > > running qcow2/021
> > > > > > > > > > run perf test on empty qcow2 image via ublk
> > > > > > > > > >       fio (ublk/qcow2( -f /mnt/data/ublk_null_8G_s761j.=
qcow2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > > > > > > > > >       randwrite: jobs 1, iops 16086
> > > > > > > > > >       randread: jobs 1, iops 172720
> > > > > > > > > >       randrw: jobs 1, iops read 35760 write 35702
> > > > > > > > > >       rw(512k): jobs 1, iops read 1140 write 1149
> > > > > > > > > >
> > > > > > > > > > 3) vdpa-virtio-blk
> > > > > > > > > > running debug/test_dev
> > > > > > > > > > run io test on specified device
> > > > > > > > > >       fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queue=
s:1)...
> > > > > > > > > >       randwrite: jobs 1, iops 8626
> > > > > > > > > >       randread: jobs 1, iops 126118
> > > > > > > > > >       randrw: jobs 1, iops read 17698 write 17665
> > > > > > > > > >       rw(512k): jobs 1, iops read 1023 write 1031
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > 2. run fio on block device over pre-allocated qcow2 ima=
ge
> > > > > > > > > > 1) qemu-nbd
> > > > > > > > > > running qcow2/002
> > > > > > > > > > run perf test on pre-allocated qcow2 image via nbd
> > > > > > > > > >       fio (nbd(/mnt/data/ublk_data_8G_sc0SB.qcow2), lib=
aio, bs 4k, dio, hw queues:1)...
> > > > > > > > > >       randwrite: jobs 1, iops 21439
> > > > > > > > > >       randread: jobs 1, iops 30336
> > > > > > > > > >       randrw: jobs 1, iops read 11476 write 11449
> > > > > > > > > >       rw(512k): jobs 1, iops read 718 write 722
> > > > > > > > > >
> > > > > > > > > > 2) ublk-qcow2
> > > > > > > > > > running qcow2/022
> > > > > > > > > > run perf test on pre-allocated qcow2 image via ublk
> > > > > > > > > >       fio (ublk/qcow2( -f /mnt/data/ublk_data_8G_yZiaJ.=
qcow2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > > > > > > > > >       randwrite: jobs 1, iops 98757
> > > > > > > > > >       randread: jobs 1, iops 110246
> > > > > > > > > >       randrw: jobs 1, iops read 47229 write 47161
> > > > > > > > > >       rw(512k): jobs 1, iops read 1416 write 1427
> > > > > > > > > >
> > > > > > > > > > 3) vdpa-virtio-blk
> > > > > > > > > > running debug/test_dev
> > > > > > > > > > run io test on specified device
> > > > > > > > > >       fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queue=
s:1)...
> > > > > > > > > >       randwrite: jobs 1, iops 47317
> > > > > > > > > >       randread: jobs 1, iops 74092
> > > > > > > > > >       randrw: jobs 1, iops read 27196 write 27234
> > > > > > > > > >       rw(512k): jobs 1, iops read 1447 write 1458
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > Hi All,
> > > > > > > > >
> > > > > > > > > We are interested in VDUSE vs UBLK, too. And I have teste=
d them with nullblk backend.
> > > > > > > > > Let me share some results here.
> > > > > > > > >
> > > > > > > > > I setup UBLK with:
> > > > > > > > >   ublk add -t loop -f /dev/nullb0 -d QUEUE_DEPTH -q NR_QU=
EUE
> > > > > > > > >
> > > > > > > > > I setup VDUSE with:
> > > > > > > > >   qemu-storage-daemon \
> > > > > > > > >        --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.=
sock,server=3Don,wait=3Doff \
> > > > > > > > >        --monitor chardev=3Dcharmonitor \
> > > > > > > > >        --blockdev driver=3Dhost_device,cache.direct=3Don,=
filename=3D/dev/nullb0,node-name=3Ddisk0 \
> > > > > > > > >        --export vduse-blk,id=3Dtest,node-name=3Ddisk0,nam=
e=3Dvduse_test,writable=3Don,num-queues=3DNR_QUEUE,queue-size=3DQUEUE_DEPTH
> > > > > > > > >
> > > > > > > > > Here QUEUE_DEPTH is 1, 32 or 128 and NR_QUEUE is 1 or 4.
> > > > > > > > >
> > > > > > > > > Note:
> > > > > > > > > (1) VDUSE requires QUEUE_DEPTH >=3D 2. I cannot setup QUE=
UE_DEPTH to 1.
> > > > > > > > > (2) I use qemu 7.1.0-rc3. It supports vduse-blk.
> > > > > > > > > (3) I do not use ublk null target so that the test is fai=
r.
> > > > > > > > > (4) I setup fio with direct=3D1, bs=3D4k.
> > > > > > > > >
> > > > > > > > > ------------------------------
> > > > > > > > > 1 job 1 iodepth, lat=EF=BC=88usec)
> > > > > > > > >                 vduse   ublk
> > > > > > > > > seq-read        22.55   11.15
> > > > > > > > > rand-read       22.49   11.17
> > > > > > > > > seq-write       25.67   10.25
> > > > > > > > > rand-write      24.13   10.16
> > > > > > > >
> > > > > > > > Thanks for sharing. Any idea what the bottlenecks are for v=
duse and ublk?
> > > > > > > >
> > > > > > >
> > > > > > > I think one reason for the latency gap of sync I/O is that vd=
use uses
> > > > > > > workqueue in the I/O completion path but ublk doesn't.
> > > > > > >
> > > > > > > And one bottleneck for the async I/O in vduse is that vduse w=
ill do
> > > > > > > memcpy inside the critical section of virtqueue's spinlock in=
 the
> > > > > > > virtio-blk driver. That will hurt the performance heavily whe=
n
> > > > > > > virtio_queue_rq() and virtblk_done() run concurrently. And it=
 can be
> > > > > > > mitigated by the advance DMA mapping feature [1] or irq bindi=
ng
> > > > > > > support [2].
> > > > > >
> > > > > > Hi Yongji,
> > > > > >
> > > > > > Yeah, that is the cost you paid for virtio. Wrt. userspace bloc=
k device
> > > > > > or other sort of userspace devices, cmd completion is driven by
> > > > > > userspace, not sure if one such 'irq' is needed.
> > > > >
> > > > > I'm not sure, it can be an optional feature in the future if need=
ed.
> > > > >
> > > > > > Even not sure if virtio
> > > > > > ring is one good choice for such use case, given io_uring has b=
een proved
> > > > > > as very efficient(should be better than virtio ring, IMO).
> > > > > >
> > > > >
> > > > > Since vduse is aimed at creating a generic userspace device frame=
work,
> > > > > virtio should be the right way IMO.
> > > >
> > > > OK, it is the right way, but may not be the effective one.
> > > >
> > >
> > > Maybe, but I think we can try to optimize it.
> > >
> > > > > And with the vdpa framework, the
> > > > > userspace device can serve both virtual machines and containers.
> > > >
> > > > virtio is good for VM, but not sure it is good enough for other
> > > > cases.
> > > >
> > > > >
> > > > > Regarding the performance issue, actually I can't measure how muc=
h of
> > > > > the performance loss is due to the difference between virtio ring=
 and
> > > > > iouring. But I think it should be very small. The main costs come=
 from
> > > > > the two bottlenecks I mentioned before which could be mitigated i=
n the
> > > > > future.
> > > >
> > > > Per my understanding, at least there are two places where virtio ri=
ng is
> > > > less efficient than io_uring:
> > > >
> > >
> > > I might have misunderstood what you mean by virtio ring before. My
> > > previous understanding of the virtio ring does not include the
> > > virtio-blk driver.
> > >
> > > > 1) io_uring uses standalone submission queue(SQ) and completion que=
ue(CQ),
> > > > so no contention exists between submission and completion; but virt=
io queue
> > > > requires per-vq lock in both submission and completion.
> > > >
> > >
> > > Yes, this is the bottleneck of the virtio-blk driver, even in the VM
> > > case. We are also trying to optimize this lock.
> > >
> > > One way to mitigate it is making submission and completion happen in
> > > the same core.
> >
> > QEMU sizes virtio-blk device num-queues to match the vCPU count. The
>
> num-queues is configurable via qemu-storage-daemon command line, and
> single queue is usually common case, more queues often means more
> resources.

Sorry, I didn't make a distinction between the running VM case the and
qemu-storage-daemon case where there is no VM. I described the VM case
here because "submission and completion happen in the same core" as
suggested there.

For qemu-storage-daemon there is no automatic sizing of num-queues.
It's up to the user to decide that manually. qemu-storage-daemon
currently does not fully take advantage of SMP. All queues are
processed by a single thread in qemu-storage-daemon. In the future it
should be possible to assign queues to specific threads (there is
ongoing "multi-queue QEMU block layer" work to do this).

The resource requirements of virtqueues aren't very large:
1. Minimum 4 KB of memory for a packed vring.
2. 1 eventfd for submission notification.
3. 1 eventfd for completion notification.

Having ~64 queues is not a big resource commitment.

>
> > virtio-blk driver is a blk-mq driver, so submissions and completions
> > for a given virtqueue should already be processed by the same vCPU.
> >
> > Unless the device is misconfigured or the guest software chooses a
> > custom vq:vCPU mapping, there should be no vq lock contention between
> > vCPUs.
>
> Single queue or nr_queue less than nr_cpus can't be thought as mis-config=
ured,
> so every vCPU can submit request, but only one or a few vCPUs complete al=
l.

Yes.

>
> >
> > I can think of a reason why submission and completion require
> > coordination: descriptors are occupied until completion. The
> > submission logic chooses free descriptors from the table. The
> > completion logic returns free descriptors so they can be used in
> > future submissions.
>
> Shared descriptors is one fundamental design of virtio ring, and
> looks the reason why vq spin lock is needed in both sides.
>
> >
> > Other ring designs expose the submission ring head AND tail index so
> > that it's clear which submissions have been processed by the other
> > side. Once processed, the descriptors are no longer occupied and can
> > be reused for future submissions immediately. This means that
> > submission and completion do not share state.
> >
> > This is for the split virtqueue layout. For the packed layout I think
> > there is a similar dependency because descriptors are used for both
> > submission and completion.
> >
> > I have CCed Michael Tsirkin in case he has any thoughts on the
> > independence of submission and completion in the vring design.
> >
> > BTW I have written about difference in the VIRTIO, NVMe, and io_uring
> > descriptor ring designs here:
> > https://blog.vmsplice.net/2022/06/comparing-virtio-nvme-and-iouring-que=
ue.html
>
> Except for ring, notification could be another difference.

Yes, the io_uring_enter(2) syscall takes over the control flow of the
current thread and can perform both submission and completion work.

VIRTIO/vhost-user has separate submission and completion
notifications, although they are typically implemented as eventfds
that can be processed with io_uring too.

Stefan
