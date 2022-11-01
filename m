Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BD761434D
	for <lists+io-uring@lfdr.de>; Tue,  1 Nov 2022 03:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiKAChv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 22:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiKACht (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 22:37:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC8317883
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 19:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667270207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ICYy2YVYmmJwT4ChzSi3ET7ebzaCrIjFIiYj2W9bdmk=;
        b=JK6hnfZ4YE5jhOlsmS6ghTisM/3mQkMNm9pYvKRxzMrKbi78gG9IQHZgJmwvIKSX+oJC2Q
        x8h8TxA4uNg43c9cE9vbZdnKZyKLCQGvA6czT99ypERffF+Cvn3ekQE0iwqTQKrWyZVAGd
        viXETzVa29Z7jEw7FhNqwrqJsJ9oeeU=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-342-UTFDQA0rO16q5EYUaEu3ww-1; Mon, 31 Oct 2022 22:36:43 -0400
X-MC-Unique: UTFDQA0rO16q5EYUaEu3ww-1
Received: by mail-ot1-f71.google.com with SMTP id f18-20020a9d5e92000000b0066c4f52d043so2533968otl.6
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 19:36:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ICYy2YVYmmJwT4ChzSi3ET7ebzaCrIjFIiYj2W9bdmk=;
        b=wsSfggMdpCVcgCwOytBvxiJ35hJpjeoGM7Ze4LiZ/DrjsiioYK3w6vFAWZhdybA2fg
         M1EIYCac02b2OEIVYVL8spYA83/H6BEJnJMbXZPpYxgJZB9dvaQ1mQEZUuAe4g3crmwD
         Etatv2rOrveLLKzUEQYnwUOHJH7Gtr3MLN7fkyx9iLrkT+IIGkG0AAj3Cs1nBr46GXlQ
         btgCfZpIQzu1DDBggA4qVHJDhX4ESA5c0iau3AhOlLwcCX6yaiduUzsW8qgWb1YP/K+Y
         VUnttQiBrwcsB0m53gEev24oc0+xqKMy8JpjDRydzO8jkSvARUZQyCEezxQZyblJdiZi
         YRfg==
X-Gm-Message-State: ACrzQf2f4LB1RTBnzpge7Y4Gmsu2iudnkxMP53fwhKVCKUqEH4qw3GY4
        Xd/8cCKKmQpWKIUwye/h+rrMEeTQZp+KDkPrtJb1+A5xV6n0md67GSs5hqqS9yFYWYK4nrqgwY/
        4d8KmmYJ2SlD89oOQim9b+s/tQfblf2R1stY=
X-Received: by 2002:a05:6808:1483:b0:354:a36e:5b with SMTP id e3-20020a056808148300b00354a36e005bmr16501385oiw.35.1667270202069;
        Mon, 31 Oct 2022 19:36:42 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5qUKRDkKnH5z7gsaHKtVvhvv6DuYiARB3/zR2BLzX2XXFhNGhqZcwxM80tdm7fv48SUJvfsH3cFIUqaI8Jk8A=
X-Received: by 2002:a05:6808:1483:b0:354:a36e:5b with SMTP id
 e3-20020a056808148300b00354a36e005bmr16501366oiw.35.1667270201628; Mon, 31
 Oct 2022 19:36:41 -0700 (PDT)
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
 <CAJSP0QUGj4t8nYeJvGaO-cWJ+F3Zvxcq007RHOm-=41zaE-v0Q@mail.gmail.com>
In-Reply-To: <CAJSP0QUGj4t8nYeJvGaO-cWJ+F3Zvxcq007RHOm-=41zaE-v0Q@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 1 Nov 2022 10:36:29 +0800
Message-ID: <CACGkMEt+BWCUVQPnfUUd0QXkHz=90LMXxydCgBqWTDB3eGBw-w@mail.gmail.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Yongji Xie <xieyongji@bytedance.com>,
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
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Oct 25, 2022 at 8:02 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Tue, 25 Oct 2022 at 04:17, Yongji Xie <xieyongji@bytedance.com> wrote:
> >
> > On Fri, Oct 21, 2022 at 2:30 PM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > >
> > > =E5=9C=A8 2022/10/21 13:33, Yongji Xie =E5=86=99=E9=81=93:
> > > > On Tue, Oct 18, 2022 at 10:54 PM Stefan Hajnoczi <stefanha@gmail.co=
m> wrote:
> > > >> On Tue, 18 Oct 2022 at 09:17, Yongji Xie <xieyongji@bytedance.com>=
 wrote:
> > > >>> On Tue, Oct 18, 2022 at 2:59 PM Ming Lei <tom.leiming@gmail.com> =
wrote:
> > > >>>> On Mon, Oct 17, 2022 at 07:11:59PM +0800, Yongji Xie wrote:
> > > >>>>> On Fri, Oct 14, 2022 at 8:57 PM Ming Lei <tom.leiming@gmail.com=
> wrote:
> > > >>>>>> On Thu, Oct 13, 2022 at 02:48:04PM +0800, Yongji Xie wrote:
> > > >>>>>>> On Wed, Oct 12, 2022 at 10:22 PM Stefan Hajnoczi <stefanha@gm=
ail.com> wrote:
> > > >>>>>>>> On Sat, 8 Oct 2022 at 04:43, Ziyang Zhang <ZiyangZhang@linux=
.alibaba.com> wrote:
> > > >>>>>>>>> On 2022/10/5 12:18, Ming Lei wrote:
> > > >>>>>>>>>> On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi =
wrote:
> > > >>>>>>>>>>> On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail.=
com> wrote:
> > > >>>>>>>>>>>> On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnocz=
i wrote:
> > > >>>>>>>>>>>>> On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrot=
e:
> > > >>>>>>>>>>>>>> ublk-qcow2 is available now.
> > > >>>>>>>>>>>>> Cool, thanks for sharing!
> > > >>>>>>>>>>>>>
> > > >>>>>>>>>>>>>> So far it provides basic read/write function, and comp=
ression and snapshot
> > > >>>>>>>>>>>>>> aren't supported yet. The target/backend implementatio=
n is completely
> > > >>>>>>>>>>>>>> based on io_uring, and share the same io_uring with ub=
lk IO command
> > > >>>>>>>>>>>>>> handler, just like what ublk-loop does.
> > > >>>>>>>>>>>>>>
> > > >>>>>>>>>>>>>> Follows the main motivations of ublk-qcow2:
> > > >>>>>>>>>>>>>>
> > > >>>>>>>>>>>>>> - building one complicated target from scratch helps l=
ibublksrv APIs/functions
> > > >>>>>>>>>>>>>>    become mature/stable more quickly, since qcow2 is c=
omplicated and needs more
> > > >>>>>>>>>>>>>>    requirement from libublksrv compared with other sim=
ple ones(loop, null)
> > > >>>>>>>>>>>>>>
> > > >>>>>>>>>>>>>> - there are several attempts of implementing qcow2 dri=
ver in kernel, such as
> > > >>>>>>>>>>>>>>    ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qco=
w2(ro)`` [4], so ublk-qcow2
> > > >>>>>>>>>>>>>>    might useful be for covering requirement in this fi=
eld
> > > >>>>>>>>>>>>>>
> > > >>>>>>>>>>>>>> - performance comparison with qemu-nbd, and it was my =
1st thought to evaluate
> > > >>>>>>>>>>>>>>    performance of ublk/io_uring backend by writing one=
 ublk-qcow2 since ublksrv
> > > >>>>>>>>>>>>>>    is started
> > > >>>>>>>>>>>>>>
> > > >>>>>>>>>>>>>> - help to abstract common building block or design pat=
tern for writing new ublk
> > > >>>>>>>>>>>>>>    target/backend
> > > >>>>>>>>>>>>>>
> > > >>>>>>>>>>>>>> So far it basically passes xfstest(XFS) test by using =
ublk-qcow2 block
> > > >>>>>>>>>>>>>> device as TEST_DEV, and kernel building workload is ve=
rified too. Also
> > > >>>>>>>>>>>>>> soft update approach is applied in meta flushing, and =
meta data
> > > >>>>>>>>>>>>>> integrity is guaranteed, 'make test T=3Dqcow2/040' cov=
ers this kind of
> > > >>>>>>>>>>>>>> test, and only cluster leak is reported during this te=
st.
> > > >>>>>>>>>>>>>>
> > > >>>>>>>>>>>>>> The performance data looks much better compared with q=
emu-nbd, see
> > > >>>>>>>>>>>>>> details in commit log[1], README[5] and STATUS[6]. And=
 the test covers both
> > > >>>>>>>>>>>>>> empty image and pre-allocated image, for example of pr=
e-allocated qcow2
> > > >>>>>>>>>>>>>> image(8GB):
> > > >>>>>>>>>>>>>>
> > > >>>>>>>>>>>>>> - qemu-nbd (make test T=3Dqcow2/002)
> > > >>>>>>>>>>>>> Single queue?
> > > >>>>>>>>>>>> Yeah.
> > > >>>>>>>>>>>>
> > > >>>>>>>>>>>>>>      randwrite(4k): jobs 1, iops 24605
> > > >>>>>>>>>>>>>>      randread(4k): jobs 1, iops 30938
> > > >>>>>>>>>>>>>>      randrw(4k): jobs 1, iops read 13981 write 14001
> > > >>>>>>>>>>>>>>      rw(512k): jobs 1, iops read 724 write 728
> > > >>>>>>>>>>>>> Please try qemu-storage-daemon's VDUSE export type as w=
ell. The
> > > >>>>>>>>>>>>> command-line should be similar to this:
> > > >>>>>>>>>>>>>
> > > >>>>>>>>>>>>>    # modprobe virtio_vdpa # attaches vDPA devices to ho=
st kernel
> > > >>>>>>>>>>>> Not found virtio_vdpa module even though I enabled all t=
he following
> > > >>>>>>>>>>>> options:
> > > >>>>>>>>>>>>
> > > >>>>>>>>>>>>          --- vDPA drivers
> > > >>>>>>>>>>>>            <M>   vDPA device simulator core
> > > >>>>>>>>>>>>            <M>     vDPA simulator for networking device
> > > >>>>>>>>>>>>            <M>     vDPA simulator for block device
> > > >>>>>>>>>>>>            <M>   VDUSE (vDPA Device in Userspace) suppor=
t
> > > >>>>>>>>>>>>            <M>   Intel IFC VF vDPA driver
> > > >>>>>>>>>>>>            <M>   Virtio PCI bridge vDPA driver
> > > >>>>>>>>>>>>            <M>   vDPA driver for Alibaba ENI
> > > >>>>>>>>>>>>
> > > >>>>>>>>>>>> BTW, my test environment is VM and the shared data is do=
ne in VM too, and
> > > >>>>>>>>>>>> can virtio_vdpa be used inside VM?
> > > >>>>>>>>>>> I hope Xie Yongji can help explain how to benchmark VDUSE=
.
> > > >>>>>>>>>>>
> > > >>>>>>>>>>> virtio_vdpa is available inside guests too. Please check =
that
> > > >>>>>>>>>>> VIRTIO_VDPA ("vDPA driver for virtio devices") is enabled=
 in "Virtio
> > > >>>>>>>>>>> drivers" menu.
> > > >>>>>>>>>>>
> > > >>>>>>>>>>>>>    # modprobe vduse
> > > >>>>>>>>>>>>>    # qemu-storage-daemon \
> > > >>>>>>>>>>>>>        --blockdev file,filename=3Dtest.qcow2,cache.dire=
ct=3Dof|off,aio=3Dnative,node-name=3Dfile \
> > > >>>>>>>>>>>>>        --blockdev qcow2,file=3Dfile,node-name=3Dqcow2 \
> > > >>>>>>>>>>>>>        --object iothread,id=3Diothread0 \
> > > >>>>>>>>>>>>>        --export vduse-blk,id=3Dvduse0,name=3Dvduse0,num=
-queues=3D$(nproc),node-name=3Dqcow2,writable=3Don,iothread=3Diothread0
> > > >>>>>>>>>>>>>    # vdpa dev add name vduse0 mgmtdev vduse
> > > >>>>>>>>>>>>>
> > > >>>>>>>>>>>>> A virtio-blk device should appear and xfstests can be r=
un on it
> > > >>>>>>>>>>>>> (typically /dev/vda unless you already have other virti=
o-blk devices).
> > > >>>>>>>>>>>>>
> > > >>>>>>>>>>>>> Afterwards you can destroy the device using:
> > > >>>>>>>>>>>>>
> > > >>>>>>>>>>>>>    # vdpa dev del vduse0
> > > >>>>>>>>>>>>>
> > > >>>>>>>>>>>>>> - ublk-qcow2 (make test T=3Dqcow2/022)
> > > >>>>>>>>>>>>> There are a lot of other factors not directly related t=
o NBD vs ublk. In
> > > >>>>>>>>>>>>> order to get an apples-to-apples comparison with qemu-*=
 a ublk export
> > > >>>>>>>>>>>>> type is needed in qemu-storage-daemon. That way only th=
e difference is
> > > >>>>>>>>>>>>> the ublk interface and the rest of the code path is ide=
ntical, making it
> > > >>>>>>>>>>>>> possible to compare NBD, VDUSE, ublk, etc more precisel=
y.
> > > >>>>>>>>>>>> Maybe not true.
> > > >>>>>>>>>>>>
> > > >>>>>>>>>>>> ublk-qcow2 uses io_uring to handle all backend IO(includ=
e meta IO) completely,
> > > >>>>>>>>>>>> and so far single io_uring/pthread is for handling all q=
cow2 IOs and IO
> > > >>>>>>>>>>>> command.
> > > >>>>>>>>>>> qemu-nbd doesn't use io_uring to handle the backend IO, s=
o we don't
> > > >>>>>>>>>> I tried to use it via --aio=3Dio_uring for setting up qemu=
-nbd, but not succeed.
> > > >>>>>>>>>>
> > > >>>>>>>>>>> know whether the benchmark demonstrates that ublk is fast=
er than NBD,
> > > >>>>>>>>>>> that the ublk-qcow2 implementation is faster than qemu-nb=
d's qcow2,
> > > >>>>>>>>>>> whether there are miscellaneous implementation difference=
s between
> > > >>>>>>>>>>> ublk-qcow2 and qemu-nbd (like using the same io_uring con=
text for both
> > > >>>>>>>>>>> ublk and backend IO), or something else.
> > > >>>>>>>>>> The theory shouldn't be too complicated:
> > > >>>>>>>>>>
> > > >>>>>>>>>> 1) io uring passthough(pt) communication is fast than sock=
et, and io command
> > > >>>>>>>>>> is carried over io_uring pt commands, and should be fast t=
han virio
> > > >>>>>>>>>> communication too.
> > > >>>>>>>>>>
> > > >>>>>>>>>> 2) io uring io handling is fast than libaio which is taken=
 in the
> > > >>>>>>>>>> test on qemu-nbd, and all qcow2 backend io(include meta io=
) is handled
> > > >>>>>>>>>> by io_uring.
> > > >>>>>>>>>>
> > > >>>>>>>>>> https://github.com/ming1/ubdsrv/blob/master/tests/common/q=
cow2_common
> > > >>>>>>>>>>
> > > >>>>>>>>>> 3) ublk uses one single io_uring to handle all io commands=
 and qcow2
> > > >>>>>>>>>> backend IOs, so batching handling is common, and it is eas=
y to see
> > > >>>>>>>>>> dozens of IOs/io commands handled in single syscall, or ev=
en more.
> > > >>>>>>>>>>
> > > >>>>>>>>>>> I'm suggesting measuring changes to just 1 variable at a =
time.
> > > >>>>>>>>>>> Otherwise it's hard to reach a conclusion about the root =
cause of the
> > > >>>>>>>>>>> performance difference. Let's learn why ublk-qcow2 perfor=
ms well.
> > > >>>>>>>>>> Turns out the latest Fedora 37-beta doesn't support vdpa y=
et, so I built
> > > >>>>>>>>>> qemu from the latest github tree, and finally it starts to=
 work. And test kernel
> > > >>>>>>>>>> is v6.0 release.
> > > >>>>>>>>>>
> > > >>>>>>>>>> Follows the test result, and all three devices are setup a=
s single
> > > >>>>>>>>>> queue, and all tests are run in single job, still done in =
one VM, and
> > > >>>>>>>>>> the test images are stored on XFS/virito-scsi backed SSD.
> > > >>>>>>>>>>
> > > >>>>>>>>>> The 1st group tests all three block device which is backed=
 by empty
> > > >>>>>>>>>> qcow2 image.
> > > >>>>>>>>>>
> > > >>>>>>>>>> The 2nd group tests all the three block devices backed by =
pre-allocated
> > > >>>>>>>>>> qcow2 image.
> > > >>>>>>>>>>
> > > >>>>>>>>>> Except for big sequential IO(512K), there is still not sma=
ll gap between
> > > >>>>>>>>>> vdpa-virtio-blk and ublk.
> > > >>>>>>>>>>
> > > >>>>>>>>>> 1. run fio on block device over empty qcow2 image
> > > >>>>>>>>>> 1) qemu-nbd
> > > >>>>>>>>>> running qcow2/001
> > > >>>>>>>>>> run perf test on empty qcow2 image via nbd
> > > >>>>>>>>>>        fio (nbd(/mnt/data/ublk_null_8G_nYbgF.qcow2), libai=
o, bs 4k, dio, hw queues:1)...
> > > >>>>>>>>>>        randwrite: jobs 1, iops 8549
> > > >>>>>>>>>>        randread: jobs 1, iops 34829
> > > >>>>>>>>>>        randrw: jobs 1, iops read 11363 write 11333
> > > >>>>>>>>>>        rw(512k): jobs 1, iops read 590 write 597
> > > >>>>>>>>>>
> > > >>>>>>>>>>
> > > >>>>>>>>>> 2) ublk-qcow2
> > > >>>>>>>>>> running qcow2/021
> > > >>>>>>>>>> run perf test on empty qcow2 image via ublk
> > > >>>>>>>>>>        fio (ublk/qcow2( -f /mnt/data/ublk_null_8G_s761j.qc=
ow2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > > >>>>>>>>>>        randwrite: jobs 1, iops 16086
> > > >>>>>>>>>>        randread: jobs 1, iops 172720
> > > >>>>>>>>>>        randrw: jobs 1, iops read 35760 write 35702
> > > >>>>>>>>>>        rw(512k): jobs 1, iops read 1140 write 1149
> > > >>>>>>>>>>
> > > >>>>>>>>>> 3) vdpa-virtio-blk
> > > >>>>>>>>>> running debug/test_dev
> > > >>>>>>>>>> run io test on specified device
> > > >>>>>>>>>>        fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:=
1)...
> > > >>>>>>>>>>        randwrite: jobs 1, iops 8626
> > > >>>>>>>>>>        randread: jobs 1, iops 126118
> > > >>>>>>>>>>        randrw: jobs 1, iops read 17698 write 17665
> > > >>>>>>>>>>        rw(512k): jobs 1, iops read 1023 write 1031
> > > >>>>>>>>>>
> > > >>>>>>>>>>
> > > >>>>>>>>>> 2. run fio on block device over pre-allocated qcow2 image
> > > >>>>>>>>>> 1) qemu-nbd
> > > >>>>>>>>>> running qcow2/002
> > > >>>>>>>>>> run perf test on pre-allocated qcow2 image via nbd
> > > >>>>>>>>>>        fio (nbd(/mnt/data/ublk_data_8G_sc0SB.qcow2), libai=
o, bs 4k, dio, hw queues:1)...
> > > >>>>>>>>>>        randwrite: jobs 1, iops 21439
> > > >>>>>>>>>>        randread: jobs 1, iops 30336
> > > >>>>>>>>>>        randrw: jobs 1, iops read 11476 write 11449
> > > >>>>>>>>>>        rw(512k): jobs 1, iops read 718 write 722
> > > >>>>>>>>>>
> > > >>>>>>>>>> 2) ublk-qcow2
> > > >>>>>>>>>> running qcow2/022
> > > >>>>>>>>>> run perf test on pre-allocated qcow2 image via ublk
> > > >>>>>>>>>>        fio (ublk/qcow2( -f /mnt/data/ublk_data_8G_yZiaJ.qc=
ow2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > > >>>>>>>>>>        randwrite: jobs 1, iops 98757
> > > >>>>>>>>>>        randread: jobs 1, iops 110246
> > > >>>>>>>>>>        randrw: jobs 1, iops read 47229 write 47161
> > > >>>>>>>>>>        rw(512k): jobs 1, iops read 1416 write 1427
> > > >>>>>>>>>>
> > > >>>>>>>>>> 3) vdpa-virtio-blk
> > > >>>>>>>>>> running debug/test_dev
> > > >>>>>>>>>> run io test on specified device
> > > >>>>>>>>>>        fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:=
1)...
> > > >>>>>>>>>>        randwrite: jobs 1, iops 47317
> > > >>>>>>>>>>        randread: jobs 1, iops 74092
> > > >>>>>>>>>>        randrw: jobs 1, iops read 27196 write 27234
> > > >>>>>>>>>>        rw(512k): jobs 1, iops read 1447 write 1458
> > > >>>>>>>>>>
> > > >>>>>>>>>>
> > > >>>>>>>>> Hi All,
> > > >>>>>>>>>
> > > >>>>>>>>> We are interested in VDUSE vs UBLK, too. And I have tested =
them with nullblk backend.
> > > >>>>>>>>> Let me share some results here.
> > > >>>>>>>>>
> > > >>>>>>>>> I setup UBLK with:
> > > >>>>>>>>>    ublk add -t loop -f /dev/nullb0 -d QUEUE_DEPTH -q NR_QUE=
UE
> > > >>>>>>>>>
> > > >>>>>>>>> I setup VDUSE with:
> > > >>>>>>>>>    qemu-storage-daemon \
> > > >>>>>>>>>         --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.s=
ock,server=3Don,wait=3Doff \
> > > >>>>>>>>>         --monitor chardev=3Dcharmonitor \
> > > >>>>>>>>>         --blockdev driver=3Dhost_device,cache.direct=3Don,f=
ilename=3D/dev/nullb0,node-name=3Ddisk0 \
> > > >>>>>>>>>         --export vduse-blk,id=3Dtest,node-name=3Ddisk0,name=
=3Dvduse_test,writable=3Don,num-queues=3DNR_QUEUE,queue-size=3DQUEUE_DEPTH
> > > >>>>>>>>>
> > > >>>>>>>>> Here QUEUE_DEPTH is 1, 32 or 128 and NR_QUEUE is 1 or 4.
> > > >>>>>>>>>
> > > >>>>>>>>> Note:
> > > >>>>>>>>> (1) VDUSE requires QUEUE_DEPTH >=3D 2. I cannot setup QUEUE=
_DEPTH to 1.
> > > >>>>>>>>> (2) I use qemu 7.1.0-rc3. It supports vduse-blk.
> > > >>>>>>>>> (3) I do not use ublk null target so that the test is fair.
> > > >>>>>>>>> (4) I setup fio with direct=3D1, bs=3D4k.
> > > >>>>>>>>>
> > > >>>>>>>>> ------------------------------
> > > >>>>>>>>> 1 job 1 iodepth, lat=EF=BC=88usec)
> > > >>>>>>>>>                  vduse   ublk
> > > >>>>>>>>> seq-read        22.55   11.15
> > > >>>>>>>>> rand-read       22.49   11.17
> > > >>>>>>>>> seq-write       25.67   10.25
> > > >>>>>>>>> rand-write      24.13   10.16
> > > >>>>>>>> Thanks for sharing. Any idea what the bottlenecks are for vd=
use and ublk?
> > > >>>>>>>>
> > > >>>>>>> I think one reason for the latency gap of sync I/O is that vd=
use uses
> > > >>>>>>> workqueue in the I/O completion path but ublk doesn't.
> > > >>>>>>>
> > > >>>>>>> And one bottleneck for the async I/O in vduse is that vduse w=
ill do
> > > >>>>>>> memcpy inside the critical section of virtqueue's spinlock in=
 the
> > > >>>>>>> virtio-blk driver. That will hurt the performance heavily whe=
n
> > > >>>>>>> virtio_queue_rq() and virtblk_done() run concurrently. And it=
 can be
> > > >>>>>>> mitigated by the advance DMA mapping feature [1] or irq bindi=
ng
> > > >>>>>>> support [2].
> > > >>>>>> Hi Yongji,
> > > >>>>>>
> > > >>>>>> Yeah, that is the cost you paid for virtio. Wrt. userspace blo=
ck device
> > > >>>>>> or other sort of userspace devices, cmd completion is driven b=
y
> > > >>>>>> userspace, not sure if one such 'irq' is needed.
> > > >>>>> I'm not sure, it can be an optional feature in the future if ne=
eded.
> > > >>>>>
> > > >>>>>> Even not sure if virtio
> > > >>>>>> ring is one good choice for such use case, given io_uring has =
been proved
> > > >>>>>> as very efficient(should be better than virtio ring, IMO).
> > > >>>>>>
> > > >>>>> Since vduse is aimed at creating a generic userspace device fra=
mework,
> > > >>>>> virtio should be the right way IMO.
> > > >>>> OK, it is the right way, but may not be the effective one.
> > > >>>>
> > > >>> Maybe, but I think we can try to optimize it.
> > > >>>
> > > >>>>> And with the vdpa framework, the
> > > >>>>> userspace device can serve both virtual machines and containers=
.
> > > >>>> virtio is good for VM, but not sure it is good enough for other
> > > >>>> cases.
> > > >>>>
> > > >>>>> Regarding the performance issue, actually I can't measure how m=
uch of
> > > >>>>> the performance loss is due to the difference between virtio ri=
ng and
> > > >>>>> iouring. But I think it should be very small. The main costs co=
me from
> > > >>>>> the two bottlenecks I mentioned before which could be mitigated=
 in the
> > > >>>>> future.
> > > >>>> Per my understanding, at least there are two places where virtio=
 ring is
> > > >>>> less efficient than io_uring:
> > > >>>>
> > > >>> I might have misunderstood what you mean by virtio ring before. M=
y
> > > >>> previous understanding of the virtio ring does not include the
> > > >>> virtio-blk driver.
> > > >>>
> > > >>>> 1) io_uring uses standalone submission queue(SQ) and completion =
queue(CQ),
> > > >>>> so no contention exists between submission and completion; but v=
irtio queue
> > > >>>> requires per-vq lock in both submission and completion.
> > > >>>>
> > > >>> Yes, this is the bottleneck of the virtio-blk driver, even in the=
 VM
> > > >>> case. We are also trying to optimize this lock.
> > > >>>
> > > >>> One way to mitigate it is making submission and completion happen=
 in
> > > >>> the same core.
> > > >> QEMU sizes virtio-blk device num-queues to match the vCPU count. T=
he
> > > >> virtio-blk driver is a blk-mq driver, so submissions and completio=
ns
> > > >> for a given virtqueue should already be processed by the same vCPU=
.
> > > >>
> > > >> Unless the device is misconfigured or the guest software chooses a
> > > >> custom vq:vCPU mapping, there should be no vq lock contention betw=
een
> > > >> vCPUs.
> > > >>
> > > >> I can think of a reason why submission and completion require
> > > >> coordination: descriptors are occupied until completion. The
> > > >> submission logic chooses free descriptors from the table. The
> > > >> completion logic returns free descriptors so they can be used in
> > > >> future submissions.
> > > >>
> > > > Yes, we need to maintain a head pointer of the free descriptors in
> > > > both submission and completion path.
> > >
> > >
> > > Not necessarily after IN_ORDER?
> > >
> >
> > Sounds like a good idea.
>
> Submission and completion are still not 100% independent with IN_ORDER
> because descriptors are still in use until completion. It may not be
> necessary to keep a freelist, but you cannot actually use the
> descriptors for new submissions until existing requests complete. Is
> that correct?

Yes.


>
> Anyway, independent submission and completion rings aren't perfect
> either because independent submission introduces a new point of
> communication: the device must tell the driver when submitted
> descriptors have been processed. That means the driver must access a
> hardware register on the device or the device must DMA to RAM. So it
> involves extra bus traffic that is not necessary if descriptors are in
> use until completion. io_uring gets away with it because the
> io_uring_enter(2) syscall is synchronous and can therefore return the
> number of consumed sq elements for free.

Note that this is a syscall interface not a device/driver API, so
technically if it's useful, it could be added to virtio as well.

>
> There are ways to minimize that cost:
> 1. The driver only needs to fetch the device's sq index when it has
> run out of sq ring space.
> 2. The device can include sq index updates with completions. This is
> what NVMe does with the CQE SQ Head Pointer field, but the
> disadvantage is that the driver has no way of determining the sq index
> until a completion occurs.

Probably, but as replied in another thread, based on the numbers
measured from the networking test, I think the current virtio layout
should be sufficient for block I/O but might not fit for cases like
NFV.

Thanks

>
> Stefan
>

