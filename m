Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628C36024D2
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 08:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJRG7k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Oct 2022 02:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiJRG7j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 02:59:39 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D116140;
        Mon, 17 Oct 2022 23:59:36 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o9-20020a17090a0a0900b0020ad4e758b3so13131791pjo.4;
        Mon, 17 Oct 2022 23:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eyNTcfaMGG+fmB2qVJkLz/okOQkeSUP+5M1GHdfaRbQ=;
        b=LdAGaTzJsK7AQB0PnKvTuiZqlsZiy0MF3IZxym/GakknVTC6Af7amGshFG7CYu7za2
         EiCHSvvScEWEu3acZq7LfV+/hrhGWXYiWwi8eEOYvdo2zU/3Zx5PI+9ir4KM90VbfCJG
         bqSuHYG5cfRH4wqKvuBfvIP7dKkBirNx77yvTs1Z3z8oGjRu9NZ2gsIdGaDH2aJhUgS4
         TmWN4geFWyFb/r7uz1aAUKeZNeQ9AkxHF0cID4nkKu82+ZgzTEAgFiIMo5za6M2Ap7m7
         TBTxup3afGQLvOJlC20QPFS2r/iCdl7o2L0x6bRm/OuX5dmuptp1QxYnA3SBCeSrgEAw
         mlig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eyNTcfaMGG+fmB2qVJkLz/okOQkeSUP+5M1GHdfaRbQ=;
        b=slhRJFwZE6LlIo1TVjDuTgF7194r5UF3s8McC3eX0fBV1nHBFisCUFNfG8gFa2KdIh
         BTkGW95Tkj3UTdE29AfhQBzsPW/LM86XUb6TpqBWWs34wLC561aQ326VetGbZDSHetcC
         ZoGlelA2lzlxHfGbRguZl0I1Y/sP5zHsRSagfWJvZpZi1Rg/Y4dtBzvMT6okm/ykMiG2
         KODVXEzD0REJLY0kdh2DfXuF0+TIYaZ9z0AyQ3hZptu8NH6SpG1hwmw5Tih3wrPu0sYS
         3eTbDqY1hN6F4wY7tMGJOqXX76hdtDQyQPsawGNG14rinP8fH1GjU7cDh6hXf/Szgcbd
         9VUw==
X-Gm-Message-State: ACrzQf2Zz7EGW26VZmCh0UKMzp7sGDMjH7SX0CfnRNDF0gYzh7rAc3Oh
        88LgVk1OrqFl8lQTXlNth7U=
X-Google-Smtp-Source: AMsMyM5QLc+vPCOQIvOSEsC+gOyjANJr7hAE8ZWpXb0D3+lY6cwgrQZr2W2/em6L3W526wg4aVT3XA==
X-Received: by 2002:a17:902:8e88:b0:185:3cea:6335 with SMTP id bg8-20020a1709028e8800b001853cea6335mr1649605plb.96.1666076375583;
        Mon, 17 Oct 2022 23:59:35 -0700 (PDT)
Received: from T590 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a188-20020a6366c5000000b00460ea630c1bsm7396991pgc.46.2022.10.17.23.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 23:59:34 -0700 (PDT)
Date:   Tue, 18 Oct 2022 14:59:25 +0800
From:   Ming Lei <tom.leiming@gmail.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Message-ID: <Y05OzeC7wImts4p7@T590>
References: <Yza1u1KfKa7ycQm0@T590>
 <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590>
 <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <Yz0FrzJVZTqlQtJ5@T590>
 <50827796-af93-4af5-4121-dc13c31a67fc@linux.alibaba.com>
 <CAJSP0QXW9TmuvJpQPRF-AF01aW79jH8tnkHPEf+do5vQ1crGFA@mail.gmail.com>
 <CACycT3ufcN+a_wtWe6ioOWZUCak-JmcMgSa=rqeEsS63_HqSog@mail.gmail.com>
 <Y0lcmZTP5sr467z6@T590>
 <CACycT3u8yYUS-WnNzgHQtQFYuK-XcyffpFc35HVZzrCS7hH5Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACycT3u8yYUS-WnNzgHQtQFYuK-XcyffpFc35HVZzrCS7hH5Sg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Oct 17, 2022 at 07:11:59PM +0800, Yongji Xie wrote:
> On Fri, Oct 14, 2022 at 8:57 PM Ming Lei <tom.leiming@gmail.com> wrote:
> >
> > On Thu, Oct 13, 2022 at 02:48:04PM +0800, Yongji Xie wrote:
> > > On Wed, Oct 12, 2022 at 10:22 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
> > > >
> > > > On Sat, 8 Oct 2022 at 04:43, Ziyang Zhang <ZiyangZhang@linux.alibaba.com> wrote:
> > > > >
> > > > > On 2022/10/5 12:18, Ming Lei wrote:
> > > > > > On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wrote:
> > > > > >> On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail.com> wrote:
> > > > > >>>
> > > > > >>> On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnoczi wrote:
> > > > > >>>> On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > > > > >>>>> ublk-qcow2 is available now.
> > > > > >>>>
> > > > > >>>> Cool, thanks for sharing!
> > > > > >>>>
> > > > > >>>>>
> > > > > >>>>> So far it provides basic read/write function, and compression and snapshot
> > > > > >>>>> aren't supported yet. The target/backend implementation is completely
> > > > > >>>>> based on io_uring, and share the same io_uring with ublk IO command
> > > > > >>>>> handler, just like what ublk-loop does.
> > > > > >>>>>
> > > > > >>>>> Follows the main motivations of ublk-qcow2:
> > > > > >>>>>
> > > > > >>>>> - building one complicated target from scratch helps libublksrv APIs/functions
> > > > > >>>>>   become mature/stable more quickly, since qcow2 is complicated and needs more
> > > > > >>>>>   requirement from libublksrv compared with other simple ones(loop, null)
> > > > > >>>>>
> > > > > >>>>> - there are several attempts of implementing qcow2 driver in kernel, such as
> > > > > >>>>>   ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], so ublk-qcow2
> > > > > >>>>>   might useful be for covering requirement in this field
> > > > > >>>>>
> > > > > >>>>> - performance comparison with qemu-nbd, and it was my 1st thought to evaluate
> > > > > >>>>>   performance of ublk/io_uring backend by writing one ublk-qcow2 since ublksrv
> > > > > >>>>>   is started
> > > > > >>>>>
> > > > > >>>>> - help to abstract common building block or design pattern for writing new ublk
> > > > > >>>>>   target/backend
> > > > > >>>>>
> > > > > >>>>> So far it basically passes xfstest(XFS) test by using ublk-qcow2 block
> > > > > >>>>> device as TEST_DEV, and kernel building workload is verified too. Also
> > > > > >>>>> soft update approach is applied in meta flushing, and meta data
> > > > > >>>>> integrity is guaranteed, 'make test T=qcow2/040' covers this kind of
> > > > > >>>>> test, and only cluster leak is reported during this test.
> > > > > >>>>>
> > > > > >>>>> The performance data looks much better compared with qemu-nbd, see
> > > > > >>>>> details in commit log[1], README[5] and STATUS[6]. And the test covers both
> > > > > >>>>> empty image and pre-allocated image, for example of pre-allocated qcow2
> > > > > >>>>> image(8GB):
> > > > > >>>>>
> > > > > >>>>> - qemu-nbd (make test T=qcow2/002)
> > > > > >>>>
> > > > > >>>> Single queue?
> > > > > >>>
> > > > > >>> Yeah.
> > > > > >>>
> > > > > >>>>
> > > > > >>>>>     randwrite(4k): jobs 1, iops 24605
> > > > > >>>>>     randread(4k): jobs 1, iops 30938
> > > > > >>>>>     randrw(4k): jobs 1, iops read 13981 write 14001
> > > > > >>>>>     rw(512k): jobs 1, iops read 724 write 728
> > > > > >>>>
> > > > > >>>> Please try qemu-storage-daemon's VDUSE export type as well. The
> > > > > >>>> command-line should be similar to this:
> > > > > >>>>
> > > > > >>>>   # modprobe virtio_vdpa # attaches vDPA devices to host kernel
> > > > > >>>
> > > > > >>> Not found virtio_vdpa module even though I enabled all the following
> > > > > >>> options:
> > > > > >>>
> > > > > >>>         --- vDPA drivers
> > > > > >>>           <M>   vDPA device simulator core
> > > > > >>>           <M>     vDPA simulator for networking device
> > > > > >>>           <M>     vDPA simulator for block device
> > > > > >>>           <M>   VDUSE (vDPA Device in Userspace) support
> > > > > >>>           <M>   Intel IFC VF vDPA driver
> > > > > >>>           <M>   Virtio PCI bridge vDPA driver
> > > > > >>>           <M>   vDPA driver for Alibaba ENI
> > > > > >>>
> > > > > >>> BTW, my test environment is VM and the shared data is done in VM too, and
> > > > > >>> can virtio_vdpa be used inside VM?
> > > > > >>
> > > > > >> I hope Xie Yongji can help explain how to benchmark VDUSE.
> > > > > >>
> > > > > >> virtio_vdpa is available inside guests too. Please check that
> > > > > >> VIRTIO_VDPA ("vDPA driver for virtio devices") is enabled in "Virtio
> > > > > >> drivers" menu.
> > > > > >>
> > > > > >>>
> > > > > >>>>   # modprobe vduse
> > > > > >>>>   # qemu-storage-daemon \
> > > > > >>>>       --blockdev file,filename=test.qcow2,cache.direct=of|off,aio=native,node-name=file \
> > > > > >>>>       --blockdev qcow2,file=file,node-name=qcow2 \
> > > > > >>>>       --object iothread,id=iothread0 \
> > > > > >>>>       --export vduse-blk,id=vduse0,name=vduse0,num-queues=$(nproc),node-name=qcow2,writable=on,iothread=iothread0
> > > > > >>>>   # vdpa dev add name vduse0 mgmtdev vduse
> > > > > >>>>
> > > > > >>>> A virtio-blk device should appear and xfstests can be run on it
> > > > > >>>> (typically /dev/vda unless you already have other virtio-blk devices).
> > > > > >>>>
> > > > > >>>> Afterwards you can destroy the device using:
> > > > > >>>>
> > > > > >>>>   # vdpa dev del vduse0
> > > > > >>>>
> > > > > >>>>>
> > > > > >>>>> - ublk-qcow2 (make test T=qcow2/022)
> > > > > >>>>
> > > > > >>>> There are a lot of other factors not directly related to NBD vs ublk. In
> > > > > >>>> order to get an apples-to-apples comparison with qemu-* a ublk export
> > > > > >>>> type is needed in qemu-storage-daemon. That way only the difference is
> > > > > >>>> the ublk interface and the rest of the code path is identical, making it
> > > > > >>>> possible to compare NBD, VDUSE, ublk, etc more precisely.
> > > > > >>>
> > > > > >>> Maybe not true.
> > > > > >>>
> > > > > >>> ublk-qcow2 uses io_uring to handle all backend IO(include meta IO) completely,
> > > > > >>> and so far single io_uring/pthread is for handling all qcow2 IOs and IO
> > > > > >>> command.
> > > > > >>
> > > > > >> qemu-nbd doesn't use io_uring to handle the backend IO, so we don't
> > > > > >
> > > > > > I tried to use it via --aio=io_uring for setting up qemu-nbd, but not succeed.
> > > > > >
> > > > > >> know whether the benchmark demonstrates that ublk is faster than NBD,
> > > > > >> that the ublk-qcow2 implementation is faster than qemu-nbd's qcow2,
> > > > > >> whether there are miscellaneous implementation differences between
> > > > > >> ublk-qcow2 and qemu-nbd (like using the same io_uring context for both
> > > > > >> ublk and backend IO), or something else.
> > > > > >
> > > > > > The theory shouldn't be too complicated:
> > > > > >
> > > > > > 1) io uring passthough(pt) communication is fast than socket, and io command
> > > > > > is carried over io_uring pt commands, and should be fast than virio
> > > > > > communication too.
> > > > > >
> > > > > > 2) io uring io handling is fast than libaio which is taken in the
> > > > > > test on qemu-nbd, and all qcow2 backend io(include meta io) is handled
> > > > > > by io_uring.
> > > > > >
> > > > > > https://github.com/ming1/ubdsrv/blob/master/tests/common/qcow2_common
> > > > > >
> > > > > > 3) ublk uses one single io_uring to handle all io commands and qcow2
> > > > > > backend IOs, so batching handling is common, and it is easy to see
> > > > > > dozens of IOs/io commands handled in single syscall, or even more.
> > > > > >
> > > > > >>
> > > > > >> I'm suggesting measuring changes to just 1 variable at a time.
> > > > > >> Otherwise it's hard to reach a conclusion about the root cause of the
> > > > > >> performance difference. Let's learn why ublk-qcow2 performs well.
> > > > > >
> > > > > > Turns out the latest Fedora 37-beta doesn't support vdpa yet, so I built
> > > > > > qemu from the latest github tree, and finally it starts to work. And test kernel
> > > > > > is v6.0 release.
> > > > > >
> > > > > > Follows the test result, and all three devices are setup as single
> > > > > > queue, and all tests are run in single job, still done in one VM, and
> > > > > > the test images are stored on XFS/virito-scsi backed SSD.
> > > > > >
> > > > > > The 1st group tests all three block device which is backed by empty
> > > > > > qcow2 image.
> > > > > >
> > > > > > The 2nd group tests all the three block devices backed by pre-allocated
> > > > > > qcow2 image.
> > > > > >
> > > > > > Except for big sequential IO(512K), there is still not small gap between
> > > > > > vdpa-virtio-blk and ublk.
> > > > > >
> > > > > > 1. run fio on block device over empty qcow2 image
> > > > > > 1) qemu-nbd
> > > > > > running qcow2/001
> > > > > > run perf test on empty qcow2 image via nbd
> > > > > >       fio (nbd(/mnt/data/ublk_null_8G_nYbgF.qcow2), libaio, bs 4k, dio, hw queues:1)...
> > > > > >       randwrite: jobs 1, iops 8549
> > > > > >       randread: jobs 1, iops 34829
> > > > > >       randrw: jobs 1, iops read 11363 write 11333
> > > > > >       rw(512k): jobs 1, iops read 590 write 597
> > > > > >
> > > > > >
> > > > > > 2) ublk-qcow2
> > > > > > running qcow2/021
> > > > > > run perf test on empty qcow2 image via ublk
> > > > > >       fio (ublk/qcow2( -f /mnt/data/ublk_null_8G_s761j.qcow2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > > > > >       randwrite: jobs 1, iops 16086
> > > > > >       randread: jobs 1, iops 172720
> > > > > >       randrw: jobs 1, iops read 35760 write 35702
> > > > > >       rw(512k): jobs 1, iops read 1140 write 1149
> > > > > >
> > > > > > 3) vdpa-virtio-blk
> > > > > > running debug/test_dev
> > > > > > run io test on specified device
> > > > > >       fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)...
> > > > > >       randwrite: jobs 1, iops 8626
> > > > > >       randread: jobs 1, iops 126118
> > > > > >       randrw: jobs 1, iops read 17698 write 17665
> > > > > >       rw(512k): jobs 1, iops read 1023 write 1031
> > > > > >
> > > > > >
> > > > > > 2. run fio on block device over pre-allocated qcow2 image
> > > > > > 1) qemu-nbd
> > > > > > running qcow2/002
> > > > > > run perf test on pre-allocated qcow2 image via nbd
> > > > > >       fio (nbd(/mnt/data/ublk_data_8G_sc0SB.qcow2), libaio, bs 4k, dio, hw queues:1)...
> > > > > >       randwrite: jobs 1, iops 21439
> > > > > >       randread: jobs 1, iops 30336
> > > > > >       randrw: jobs 1, iops read 11476 write 11449
> > > > > >       rw(512k): jobs 1, iops read 718 write 722
> > > > > >
> > > > > > 2) ublk-qcow2
> > > > > > running qcow2/022
> > > > > > run perf test on pre-allocated qcow2 image via ublk
> > > > > >       fio (ublk/qcow2( -f /mnt/data/ublk_data_8G_yZiaJ.qcow2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
> > > > > >       randwrite: jobs 1, iops 98757
> > > > > >       randread: jobs 1, iops 110246
> > > > > >       randrw: jobs 1, iops read 47229 write 47161
> > > > > >       rw(512k): jobs 1, iops read 1416 write 1427
> > > > > >
> > > > > > 3) vdpa-virtio-blk
> > > > > > running debug/test_dev
> > > > > > run io test on specified device
> > > > > >       fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)...
> > > > > >       randwrite: jobs 1, iops 47317
> > > > > >       randread: jobs 1, iops 74092
> > > > > >       randrw: jobs 1, iops read 27196 write 27234
> > > > > >       rw(512k): jobs 1, iops read 1447 write 1458
> > > > > >
> > > > > >
> > > > >
> > > > > Hi All,
> > > > >
> > > > > We are interested in VDUSE vs UBLK, too. And I have tested them with nullblk backend.
> > > > > Let me share some results here.
> > > > >
> > > > > I setup UBLK with:
> > > > >   ublk add -t loop -f /dev/nullb0 -d QUEUE_DEPTH -q NR_QUEUE
> > > > >
> > > > > I setup VDUSE with:
> > > > >   qemu-storage-daemon \
> > > > >        --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server=on,wait=off \
> > > > >        --monitor chardev=charmonitor \
> > > > >        --blockdev driver=host_device,cache.direct=on,filename=/dev/nullb0,node-name=disk0 \
> > > > >        --export vduse-blk,id=test,node-name=disk0,name=vduse_test,writable=on,num-queues=NR_QUEUE,queue-size=QUEUE_DEPTH
> > > > >
> > > > > Here QUEUE_DEPTH is 1, 32 or 128 and NR_QUEUE is 1 or 4.
> > > > >
> > > > > Note:
> > > > > (1) VDUSE requires QUEUE_DEPTH >= 2. I cannot setup QUEUE_DEPTH to 1.
> > > > > (2) I use qemu 7.1.0-rc3. It supports vduse-blk.
> > > > > (3) I do not use ublk null target so that the test is fair.
> > > > > (4) I setup fio with direct=1, bs=4k.
> > > > >
> > > > > ------------------------------
> > > > > 1 job 1 iodepth, lat（usec)
> > > > >                 vduse   ublk
> > > > > seq-read        22.55   11.15
> > > > > rand-read       22.49   11.17
> > > > > seq-write       25.67   10.25
> > > > > rand-write      24.13   10.16
> > > >
> > > > Thanks for sharing. Any idea what the bottlenecks are for vduse and ublk?
> > > >
> > >
> > > I think one reason for the latency gap of sync I/O is that vduse uses
> > > workqueue in the I/O completion path but ublk doesn't.
> > >
> > > And one bottleneck for the async I/O in vduse is that vduse will do
> > > memcpy inside the critical section of virtqueue's spinlock in the
> > > virtio-blk driver. That will hurt the performance heavily when
> > > virtio_queue_rq() and virtblk_done() run concurrently. And it can be
> > > mitigated by the advance DMA mapping feature [1] or irq binding
> > > support [2].
> >
> > Hi Yongji,
> >
> > Yeah, that is the cost you paid for virtio. Wrt. userspace block device
> > or other sort of userspace devices, cmd completion is driven by
> > userspace, not sure if one such 'irq' is needed.
> 
> I'm not sure, it can be an optional feature in the future if needed.
> 
> > Even not sure if virtio
> > ring is one good choice for such use case, given io_uring has been proved
> > as very efficient(should be better than virtio ring, IMO).
> >
> 
> Since vduse is aimed at creating a generic userspace device framework,
> virtio should be the right way IMO.

OK, it is the right way, but may not be the effective one.

> And with the vdpa framework, the
> userspace device can serve both virtual machines and containers.

virtio is good for VM, but not sure it is good enough for other
cases.

> 
> Regarding the performance issue, actually I can't measure how much of
> the performance loss is due to the difference between virtio ring and
> iouring. But I think it should be very small. The main costs come from
> the two bottlenecks I mentioned before which could be mitigated in the
> future.

Per my understanding, at least there are two places where virtio ring is
less efficient than io_uring:

1) io_uring uses standalone submission queue(SQ) and completion queue(CQ),
so no contention exists between submission and completion; but virtio queue
requires per-vq lock in both submission and completion.

2) io_uring can use single system call of io_uring_enter() for both
submitting and completing, so one context switch is enough, together
with natural batch processing for both submission and completion, and
it is observed that dozens or more than one hundred of IOs can be
covered in single syscall; virtio requires one notification for submission and
another one for completion, looks at least two context switch are required
for handling one IO(s).

> 
> > ublk uses io_uring pt cmd for handling both io submission and completion,
> > turns out the extra latency can be pretty small.
> >
> > BTW, one un-related topic, I saw the following words in
> > Documentation/userspace-api/vduse.rst:
> >
> > ```
> > Note that only virtio block device is supported by VDUSE framework now,
> > which can reduce security risks when the userspace process that implements
> > the data path is run by an unprivileged user.
> > ```
> >
> > But when I tried to start qemu-storage-daemon for creating vdpa-virtio
> > block by nor unprivileged user, 'Permission denied' is still returned,
> > can you explain a bit how to start such process by unprivileged user?
> > Or maybe I misunderstood the above words, please let me know.
> >
> 
> Currently vduse should only allow privileged users by default. But
> sysadmin can change the permission of the vduse char device or pass
> the device fd to an unprivileged process IIUC.

I appreciate if you may provide a bit detailed steps for the above?

BTW, I changed privilege of /dev/vduse/control to normal user, but
qemu-storage-daemon still returns 'Permission denied'. And if the
char dev is /dev/vduse/vduse0N, which is created by qemu-storage-daemon,
so how to change user of qemu-storage-daemon to unprivileged after
/dev/vduse/vduse0N is created?



Thanks,
Ming
