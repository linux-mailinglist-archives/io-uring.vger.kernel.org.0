Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476C65FEE3D
	for <lists+io-uring@lfdr.de>; Fri, 14 Oct 2022 14:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiJNM5M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Oct 2022 08:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJNM5I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Oct 2022 08:57:08 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1A7E986C;
        Fri, 14 Oct 2022 05:57:07 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y1so4838185pfr.3;
        Fri, 14 Oct 2022 05:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MBBXMGlOLmrN07MccWneqD/LoPRVYmS0f4zwgY9YgHg=;
        b=d91bvhGxWhoKLB/8vlpPdGYb2nmLgGv8cD0VWx8gB5QaiE6CaErdSO+Nm3p716vra5
         haaxBPgLsE/zxNdCmegwVBhUlyqH6+tlQuK8MxkK/ahQYpWxUoqKtuLHgaBOeQWhSdvX
         1pzscwLcOYubZkCsBTR+HdRGlBNCH9Y3wKwtOWJGoo+Bsja7ddxQKhKlqMR4wQmcoezv
         SON/ZV79yy+980BN3dN4qUAi+6yJtld26MxoEiSIvyn4084WfMVecB6ieCpftxNObiTy
         kjtYLIa7AK+ld2wuJ3WbleTzhfUzY9MXSOOepUOIOIed18PHcq5d5Paaj7A/QUY/nc8w
         a1pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MBBXMGlOLmrN07MccWneqD/LoPRVYmS0f4zwgY9YgHg=;
        b=JyjtaC5oTg9oc/GqI/a9Sji67FIQ72PbxLtVWwZAzp6VkDWHvPO3PO6/6iO6Ha+t9j
         NSzAk1cPRN+XkbuP2xk0ZsfnLMj2D5DvyCfSuYzwOasVAAuyxdjYO8z2uyha9nZVm341
         wbeznY2Akjv21nPdrYxzwd+Lpq5VBVq2fXj+6IiVkoq9sgWOdNhNMZRVECK6ccEip4Lg
         6WU1X8pDqtuHGQHwtrfXHzb0syRrG11Hg/3/GzemRuNuq8edbivDLA8nyzy24x4o9K+i
         0ls8dfGBDEzuD0Hr0Qfxnj9xQpvS8B4dKW8xIMHU6pGBGqOVWpNQbjCZKNRQwiGXpgRc
         CEzw==
X-Gm-Message-State: ACrzQf0489YrQ/CUGdVir1Qbu464N20QheGyV8dWi3TxFvoP3/OhAPb0
        jQp3CW25DgLUaOqeUp1u5Jg=
X-Google-Smtp-Source: AMsMyM6yJwQUvHRkKQ1voS4lDM1ZTIevbha0BoKQfff2fMSSUwuAQGNGBynd4U/90aQWCW4Kfwt9kA==
X-Received: by 2002:a05:6a00:a8f:b0:563:3a3f:9d5c with SMTP id b15-20020a056a000a8f00b005633a3f9d5cmr5219348pfl.50.1665752226688;
        Fri, 14 Oct 2022 05:57:06 -0700 (PDT)
Received: from T590 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm1665693pfq.165.2022.10.14.05.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 05:57:05 -0700 (PDT)
Date:   Fri, 14 Oct 2022 20:56:57 +0800
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
Message-ID: <Y0lcmZTP5sr467z6@T590>
References: <Yza1u1KfKa7ycQm0@T590>
 <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590>
 <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <Yz0FrzJVZTqlQtJ5@T590>
 <50827796-af93-4af5-4121-dc13c31a67fc@linux.alibaba.com>
 <CAJSP0QXW9TmuvJpQPRF-AF01aW79jH8tnkHPEf+do5vQ1crGFA@mail.gmail.com>
 <CACycT3ufcN+a_wtWe6ioOWZUCak-JmcMgSa=rqeEsS63_HqSog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACycT3ufcN+a_wtWe6ioOWZUCak-JmcMgSa=rqeEsS63_HqSog@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 13, 2022 at 02:48:04PM +0800, Yongji Xie wrote:
> On Wed, Oct 12, 2022 at 10:22 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
> >
> > On Sat, 8 Oct 2022 at 04:43, Ziyang Zhang <ZiyangZhang@linux.alibaba.com> wrote:
> > >
> > > On 2022/10/5 12:18, Ming Lei wrote:
> > > > On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wrote:
> > > >> On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail.com> wrote:
> > > >>>
> > > >>> On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnoczi wrote:
> > > >>>> On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > > >>>>> ublk-qcow2 is available now.
> > > >>>>
> > > >>>> Cool, thanks for sharing!
> > > >>>>
> > > >>>>>
> > > >>>>> So far it provides basic read/write function, and compression and snapshot
> > > >>>>> aren't supported yet. The target/backend implementation is completely
> > > >>>>> based on io_uring, and share the same io_uring with ublk IO command
> > > >>>>> handler, just like what ublk-loop does.
> > > >>>>>
> > > >>>>> Follows the main motivations of ublk-qcow2:
> > > >>>>>
> > > >>>>> - building one complicated target from scratch helps libublksrv APIs/functions
> > > >>>>>   become mature/stable more quickly, since qcow2 is complicated and needs more
> > > >>>>>   requirement from libublksrv compared with other simple ones(loop, null)
> > > >>>>>
> > > >>>>> - there are several attempts of implementing qcow2 driver in kernel, such as
> > > >>>>>   ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], so ublk-qcow2
> > > >>>>>   might useful be for covering requirement in this field
> > > >>>>>
> > > >>>>> - performance comparison with qemu-nbd, and it was my 1st thought to evaluate
> > > >>>>>   performance of ublk/io_uring backend by writing one ublk-qcow2 since ublksrv
> > > >>>>>   is started
> > > >>>>>
> > > >>>>> - help to abstract common building block or design pattern for writing new ublk
> > > >>>>>   target/backend
> > > >>>>>
> > > >>>>> So far it basically passes xfstest(XFS) test by using ublk-qcow2 block
> > > >>>>> device as TEST_DEV, and kernel building workload is verified too. Also
> > > >>>>> soft update approach is applied in meta flushing, and meta data
> > > >>>>> integrity is guaranteed, 'make test T=qcow2/040' covers this kind of
> > > >>>>> test, and only cluster leak is reported during this test.
> > > >>>>>
> > > >>>>> The performance data looks much better compared with qemu-nbd, see
> > > >>>>> details in commit log[1], README[5] and STATUS[6]. And the test covers both
> > > >>>>> empty image and pre-allocated image, for example of pre-allocated qcow2
> > > >>>>> image(8GB):
> > > >>>>>
> > > >>>>> - qemu-nbd (make test T=qcow2/002)
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
> > > >>> Not found virtio_vdpa module even though I enabled all the following
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
> > > >>> BTW, my test environment is VM and the shared data is done in VM too, and
> > > >>> can virtio_vdpa be used inside VM?
> > > >>
> > > >> I hope Xie Yongji can help explain how to benchmark VDUSE.
> > > >>
> > > >> virtio_vdpa is available inside guests too. Please check that
> > > >> VIRTIO_VDPA ("vDPA driver for virtio devices") is enabled in "Virtio
> > > >> drivers" menu.
> > > >>
> > > >>>
> > > >>>>   # modprobe vduse
> > > >>>>   # qemu-storage-daemon \
> > > >>>>       --blockdev file,filename=test.qcow2,cache.direct=of|off,aio=native,node-name=file \
> > > >>>>       --blockdev qcow2,file=file,node-name=qcow2 \
> > > >>>>       --object iothread,id=iothread0 \
> > > >>>>       --export vduse-blk,id=vduse0,name=vduse0,num-queues=$(nproc),node-name=qcow2,writable=on,iothread=iothread0
> > > >>>>   # vdpa dev add name vduse0 mgmtdev vduse
> > > >>>>
> > > >>>> A virtio-blk device should appear and xfstests can be run on it
> > > >>>> (typically /dev/vda unless you already have other virtio-blk devices).
> > > >>>>
> > > >>>> Afterwards you can destroy the device using:
> > > >>>>
> > > >>>>   # vdpa dev del vduse0
> > > >>>>
> > > >>>>>
> > > >>>>> - ublk-qcow2 (make test T=qcow2/022)
> > > >>>>
> > > >>>> There are a lot of other factors not directly related to NBD vs ublk. In
> > > >>>> order to get an apples-to-apples comparison with qemu-* a ublk export
> > > >>>> type is needed in qemu-storage-daemon. That way only the difference is
> > > >>>> the ublk interface and the rest of the code path is identical, making it
> > > >>>> possible to compare NBD, VDUSE, ublk, etc more precisely.
> > > >>>
> > > >>> Maybe not true.
> > > >>>
> > > >>> ublk-qcow2 uses io_uring to handle all backend IO(include meta IO) completely,
> > > >>> and so far single io_uring/pthread is for handling all qcow2 IOs and IO
> > > >>> command.
> > > >>
> > > >> qemu-nbd doesn't use io_uring to handle the backend IO, so we don't
> > > >
> > > > I tried to use it via --aio=io_uring for setting up qemu-nbd, but not succeed.
> > > >
> > > >> know whether the benchmark demonstrates that ublk is faster than NBD,
> > > >> that the ublk-qcow2 implementation is faster than qemu-nbd's qcow2,
> > > >> whether there are miscellaneous implementation differences between
> > > >> ublk-qcow2 and qemu-nbd (like using the same io_uring context for both
> > > >> ublk and backend IO), or something else.
> > > >
> > > > The theory shouldn't be too complicated:
> > > >
> > > > 1) io uring passthough(pt) communication is fast than socket, and io command
> > > > is carried over io_uring pt commands, and should be fast than virio
> > > > communication too.
> > > >
> > > > 2) io uring io handling is fast than libaio which is taken in the
> > > > test on qemu-nbd, and all qcow2 backend io(include meta io) is handled
> > > > by io_uring.
> > > >
> > > > https://github.com/ming1/ubdsrv/blob/master/tests/common/qcow2_common
> > > >
> > > > 3) ublk uses one single io_uring to handle all io commands and qcow2
> > > > backend IOs, so batching handling is common, and it is easy to see
> > > > dozens of IOs/io commands handled in single syscall, or even more.
> > > >
> > > >>
> > > >> I'm suggesting measuring changes to just 1 variable at a time.
> > > >> Otherwise it's hard to reach a conclusion about the root cause of the
> > > >> performance difference. Let's learn why ublk-qcow2 performs well.
> > > >
> > > > Turns out the latest Fedora 37-beta doesn't support vdpa yet, so I built
> > > > qemu from the latest github tree, and finally it starts to work. And test kernel
> > > > is v6.0 release.
> > > >
> > > > Follows the test result, and all three devices are setup as single
> > > > queue, and all tests are run in single job, still done in one VM, and
> > > > the test images are stored on XFS/virito-scsi backed SSD.
> > > >
> > > > The 1st group tests all three block device which is backed by empty
> > > > qcow2 image.
> > > >
> > > > The 2nd group tests all the three block devices backed by pre-allocated
> > > > qcow2 image.
> > > >
> > > > Except for big sequential IO(512K), there is still not small gap between
> > > > vdpa-virtio-blk and ublk.
> > > >
> > > > 1. run fio on block device over empty qcow2 image
> > > > 1) qemu-nbd
> > > > running qcow2/001
> > > > run perf test on empty qcow2 image via nbd
> > > >       fio (nbd(/mnt/data/ublk_null_8G_nYbgF.qcow2), libaio, bs 4k, dio, hw queues:1)...
> > > >       randwrite: jobs 1, iops 8549
> > > >       randread: jobs 1, iops 34829
> > > >       randrw: jobs 1, iops read 11363 write 11333
> > > >       rw(512k): jobs 1, iops read 590 write 597
> > > >
> > > >
> > > > 2) ublk-qcow2
> > > > running qcow2/021
> > > > run perf test on empty qcow2 image via ublk
> > > >       fio (ublk/qcow2( -f /mnt/data/ublk_null_8G_s761j.qcow2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
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
> > > >       fio (nbd(/mnt/data/ublk_data_8G_sc0SB.qcow2), libaio, bs 4k, dio, hw queues:1)...
> > > >       randwrite: jobs 1, iops 21439
> > > >       randread: jobs 1, iops 30336
> > > >       randrw: jobs 1, iops read 11476 write 11449
> > > >       rw(512k): jobs 1, iops read 718 write 722
> > > >
> > > > 2) ublk-qcow2
> > > > running qcow2/022
> > > > run perf test on pre-allocated qcow2 image via ublk
> > > >       fio (ublk/qcow2( -f /mnt/data/ublk_data_8G_yZiaJ.qcow2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
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
> > > We are interested in VDUSE vs UBLK, too. And I have tested them with nullblk backend.
> > > Let me share some results here.
> > >
> > > I setup UBLK with:
> > >   ublk add -t loop -f /dev/nullb0 -d QUEUE_DEPTH -q NR_QUEUE
> > >
> > > I setup VDUSE with:
> > >   qemu-storage-daemon \
> > >        --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server=on,wait=off \
> > >        --monitor chardev=charmonitor \
> > >        --blockdev driver=host_device,cache.direct=on,filename=/dev/nullb0,node-name=disk0 \
> > >        --export vduse-blk,id=test,node-name=disk0,name=vduse_test,writable=on,num-queues=NR_QUEUE,queue-size=QUEUE_DEPTH
> > >
> > > Here QUEUE_DEPTH is 1, 32 or 128 and NR_QUEUE is 1 or 4.
> > >
> > > Note:
> > > (1) VDUSE requires QUEUE_DEPTH >= 2. I cannot setup QUEUE_DEPTH to 1.
> > > (2) I use qemu 7.1.0-rc3. It supports vduse-blk.
> > > (3) I do not use ublk null target so that the test is fair.
> > > (4) I setup fio with direct=1, bs=4k.
> > >
> > > ------------------------------
> > > 1 job 1 iodepth, lat（usec)
> > >                 vduse   ublk
> > > seq-read        22.55   11.15
> > > rand-read       22.49   11.17
> > > seq-write       25.67   10.25
> > > rand-write      24.13   10.16
> >
> > Thanks for sharing. Any idea what the bottlenecks are for vduse and ublk?
> >
> 
> I think one reason for the latency gap of sync I/O is that vduse uses
> workqueue in the I/O completion path but ublk doesn't.
> 
> And one bottleneck for the async I/O in vduse is that vduse will do
> memcpy inside the critical section of virtqueue's spinlock in the
> virtio-blk driver. That will hurt the performance heavily when
> virtio_queue_rq() and virtblk_done() run concurrently. And it can be
> mitigated by the advance DMA mapping feature [1] or irq binding
> support [2].

Hi Yongji,

Yeah, that is the cost you paid for virtio. Wrt. userspace block device
or other sort of userspace devices, cmd completion is driven by
userspace, not sure if one such 'irq' is needed. Even not sure if virtio
ring is one good choice for such use case, given io_uring has been proved
as very efficient(should be better than virtio ring, IMO).

ublk uses io_uring pt cmd for handling both io submission and completion,
turns out the extra latency can be pretty small.

BTW, one un-related topic, I saw the following words in
Documentation/userspace-api/vduse.rst:

```
Note that only virtio block device is supported by VDUSE framework now,
which can reduce security risks when the userspace process that implements
the data path is run by an unprivileged user.
```

But when I tried to start qemu-storage-daemon for creating vdpa-virtio
block by nor unprivileged user, 'Permission denied' is still returned,
can you explain a bit how to start such process by unprivileged user?
Or maybe I misunderstood the above words, please let me know.


thanks,
Ming
