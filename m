Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4115F4F04
	for <lists+io-uring@lfdr.de>; Wed,  5 Oct 2022 06:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJEETN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Oct 2022 00:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiJEETL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Oct 2022 00:19:11 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E3965279;
        Tue,  4 Oct 2022 21:19:10 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id v10-20020a17090a634a00b00205e48cf845so626053pjs.4;
        Tue, 04 Oct 2022 21:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=JqYaSs8nnjKHk4wZ+yCo6aZO+FDfi0LL5kl9tHDj7j8=;
        b=CTFOmMqHKnJPrPJnfFZkFWSrGvYDUeHw5orJcik7dTxKZ4FWH/0cX0PKKWFDr8SaGG
         DpEBF1wLzffxmmTs9mvQBKnXsp2CxOAsVMlPjXmWAjACN4bZwZ6PX5PO53Iz4ofR3XZq
         3qenV/LYxFaLuDxqSDH/7/gwgnlhXFsV+dJ08tDy8y42q5pBvFYj1hUL4AT6eZYFtaax
         zYKAgem7iYTC4gk5OANoklvycbtf2J94WAXdU608Z5jqm3P0E2cI0VGrbYF7WXWibW7s
         lf0IirVcS03jZbYI5JnryvFTq+hUUBJ4fzvtXJDwPMRUONqiQb+LfA0iza+BOEeg0ttH
         QPew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=JqYaSs8nnjKHk4wZ+yCo6aZO+FDfi0LL5kl9tHDj7j8=;
        b=D/b+iDE8m8tukTF6UAWo5TzLPXpZAHl1MqNd/DxPFAEFIH7hoXncEVxuKDTprcebco
         MzG6clzyjO7cVtWmeKKU+CrzwTxqMq+7d7LY1ztfBbcuKthmcOQYVWGZ5S36QeMBtNPD
         XZe1Gyzbc+wpdpanjSS3KUGmUHDOu6piMaD+oxNWDlsfWBCSW+3tcTAjCRRO6G8LN2yu
         Z3kN0k6q5LMP7qM3XpqCFLp4UpquYwH1C1uTULr1S44K82HonxjDaZU23SXrlTYSh9Rw
         U9QW1wSwZ2VIgiOk/ba/HGJiaOaImqpRLyViPD6WoufIY5G+/43pIZ45V+yEd3ru1nbM
         9W1g==
X-Gm-Message-State: ACrzQf3sDmNMvP3R3zqLCHCBAoBbF380rkaiEC0X8/sPZt9SkIHTUxae
        7d64r06Nikp2I2E1VrU5h1E=
X-Google-Smtp-Source: AMsMyM6pF3OTw2eCu6EvKnL05epDKzZm0fc+COF4b5oBhaPgBWskpjcYprU3v0FQYxWiHZuSJUV8hg==
X-Received: by 2002:a17:90b:1a92:b0:20a:f34a:2b9 with SMTP id ng18-20020a17090b1a9200b0020af34a02b9mr40921pjb.74.1664943550031;
        Tue, 04 Oct 2022 21:19:10 -0700 (PDT)
Received: from T590 ([117.136.79.112])
        by smtp.gmail.com with ESMTPSA id j23-20020a63cf17000000b0041cd5ddde6fsm9241347pgg.76.2022.10.04.21.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 21:19:09 -0700 (PDT)
Date:   Wed, 5 Oct 2022 12:18:55 +0800
From:   Ming Lei <tom.leiming@gmail.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        rjones@redhat.com, Xie Yongji <xieyongji@bytedance.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Message-ID: <Yz0FrzJVZTqlQtJ5@T590>
References: <Yza1u1KfKa7ycQm0@T590>
 <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590>
 <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wrote:
> On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail.com> wrote:
> >
> > On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnoczi wrote:
> > > On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > > > ublk-qcow2 is available now.
> > >
> > > Cool, thanks for sharing!
> > >
> > > >
> > > > So far it provides basic read/write function, and compression and snapshot
> > > > aren't supported yet. The target/backend implementation is completely
> > > > based on io_uring, and share the same io_uring with ublk IO command
> > > > handler, just like what ublk-loop does.
> > > >
> > > > Follows the main motivations of ublk-qcow2:
> > > >
> > > > - building one complicated target from scratch helps libublksrv APIs/functions
> > > >   become mature/stable more quickly, since qcow2 is complicated and needs more
> > > >   requirement from libublksrv compared with other simple ones(loop, null)
> > > >
> > > > - there are several attempts of implementing qcow2 driver in kernel, such as
> > > >   ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], so ublk-qcow2
> > > >   might useful be for covering requirement in this field
> > > >
> > > > - performance comparison with qemu-nbd, and it was my 1st thought to evaluate
> > > >   performance of ublk/io_uring backend by writing one ublk-qcow2 since ublksrv
> > > >   is started
> > > >
> > > > - help to abstract common building block or design pattern for writing new ublk
> > > >   target/backend
> > > >
> > > > So far it basically passes xfstest(XFS) test by using ublk-qcow2 block
> > > > device as TEST_DEV, and kernel building workload is verified too. Also
> > > > soft update approach is applied in meta flushing, and meta data
> > > > integrity is guaranteed, 'make test T=qcow2/040' covers this kind of
> > > > test, and only cluster leak is reported during this test.
> > > >
> > > > The performance data looks much better compared with qemu-nbd, see
> > > > details in commit log[1], README[5] and STATUS[6]. And the test covers both
> > > > empty image and pre-allocated image, for example of pre-allocated qcow2
> > > > image(8GB):
> > > >
> > > > - qemu-nbd (make test T=qcow2/002)
> > >
> > > Single queue?
> >
> > Yeah.
> >
> > >
> > > >     randwrite(4k): jobs 1, iops 24605
> > > >     randread(4k): jobs 1, iops 30938
> > > >     randrw(4k): jobs 1, iops read 13981 write 14001
> > > >     rw(512k): jobs 1, iops read 724 write 728
> > >
> > > Please try qemu-storage-daemon's VDUSE export type as well. The
> > > command-line should be similar to this:
> > >
> > >   # modprobe virtio_vdpa # attaches vDPA devices to host kernel
> >
> > Not found virtio_vdpa module even though I enabled all the following
> > options:
> >
> >         --- vDPA drivers
> >           <M>   vDPA device simulator core
> >           <M>     vDPA simulator for networking device
> >           <M>     vDPA simulator for block device
> >           <M>   VDUSE (vDPA Device in Userspace) support
> >           <M>   Intel IFC VF vDPA driver
> >           <M>   Virtio PCI bridge vDPA driver
> >           <M>   vDPA driver for Alibaba ENI
> >
> > BTW, my test environment is VM and the shared data is done in VM too, and
> > can virtio_vdpa be used inside VM?
> 
> I hope Xie Yongji can help explain how to benchmark VDUSE.
> 
> virtio_vdpa is available inside guests too. Please check that
> VIRTIO_VDPA ("vDPA driver for virtio devices") is enabled in "Virtio
> drivers" menu.
> 
> >
> > >   # modprobe vduse
> > >   # qemu-storage-daemon \
> > >       --blockdev file,filename=test.qcow2,cache.direct=of|off,aio=native,node-name=file \
> > >       --blockdev qcow2,file=file,node-name=qcow2 \
> > >       --object iothread,id=iothread0 \
> > >       --export vduse-blk,id=vduse0,name=vduse0,num-queues=$(nproc),node-name=qcow2,writable=on,iothread=iothread0
> > >   # vdpa dev add name vduse0 mgmtdev vduse
> > >
> > > A virtio-blk device should appear and xfstests can be run on it
> > > (typically /dev/vda unless you already have other virtio-blk devices).
> > >
> > > Afterwards you can destroy the device using:
> > >
> > >   # vdpa dev del vduse0
> > >
> > > >
> > > > - ublk-qcow2 (make test T=qcow2/022)
> > >
> > > There are a lot of other factors not directly related to NBD vs ublk. In
> > > order to get an apples-to-apples comparison with qemu-* a ublk export
> > > type is needed in qemu-storage-daemon. That way only the difference is
> > > the ublk interface and the rest of the code path is identical, making it
> > > possible to compare NBD, VDUSE, ublk, etc more precisely.
> >
> > Maybe not true.
> >
> > ublk-qcow2 uses io_uring to handle all backend IO(include meta IO) completely,
> > and so far single io_uring/pthread is for handling all qcow2 IOs and IO
> > command.
> 
> qemu-nbd doesn't use io_uring to handle the backend IO, so we don't

I tried to use it via --aio=io_uring for setting up qemu-nbd, but not succeed.

> know whether the benchmark demonstrates that ublk is faster than NBD,
> that the ublk-qcow2 implementation is faster than qemu-nbd's qcow2,
> whether there are miscellaneous implementation differences between
> ublk-qcow2 and qemu-nbd (like using the same io_uring context for both
> ublk and backend IO), or something else.

The theory shouldn't be too complicated:

1) io uring passthough(pt) communication is fast than socket, and io command
is carried over io_uring pt commands, and should be fast than virio
communication too.

2) io uring io handling is fast than libaio which is taken in the
test on qemu-nbd, and all qcow2 backend io(include meta io) is handled
by io_uring.

https://github.com/ming1/ubdsrv/blob/master/tests/common/qcow2_common

3) ublk uses one single io_uring to handle all io commands and qcow2
backend IOs, so batching handling is common, and it is easy to see
dozens of IOs/io commands handled in single syscall, or even more.

> 
> I'm suggesting measuring changes to just 1 variable at a time.
> Otherwise it's hard to reach a conclusion about the root cause of the
> performance difference. Let's learn why ublk-qcow2 performs well.

Turns out the latest Fedora 37-beta doesn't support vdpa yet, so I built
qemu from the latest github tree, and finally it starts to work. And test kernel
is v6.0 release.

Follows the test result, and all three devices are setup as single
queue, and all tests are run in single job, still done in one VM, and
the test images are stored on XFS/virito-scsi backed SSD.

The 1st group tests all three block device which is backed by empty
qcow2 image.

The 2nd group tests all the three block devices backed by pre-allocated
qcow2 image.

Except for big sequential IO(512K), there is still not small gap between
vdpa-virtio-blk and ublk.

1. run fio on block device over empty qcow2 image
1) qemu-nbd
running qcow2/001
run perf test on empty qcow2 image via nbd
	fio (nbd(/mnt/data/ublk_null_8G_nYbgF.qcow2), libaio, bs 4k, dio, hw queues:1)...
	randwrite: jobs 1, iops 8549
	randread: jobs 1, iops 34829
	randrw: jobs 1, iops read 11363 write 11333
	rw(512k): jobs 1, iops read 590 write 597


2) ublk-qcow2
running qcow2/021
run perf test on empty qcow2 image via ublk
	fio (ublk/qcow2( -f /mnt/data/ublk_null_8G_s761j.qcow2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
	randwrite: jobs 1, iops 16086
	randread: jobs 1, iops 172720
	randrw: jobs 1, iops read 35760 write 35702
	rw(512k): jobs 1, iops read 1140 write 1149

3) vdpa-virtio-blk
running debug/test_dev
run io test on specified device
	fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)...
	randwrite: jobs 1, iops 8626
	randread: jobs 1, iops 126118
	randrw: jobs 1, iops read 17698 write 17665
	rw(512k): jobs 1, iops read 1023 write 1031


2. run fio on block device over pre-allocated qcow2 image
1) qemu-nbd
running qcow2/002
run perf test on pre-allocated qcow2 image via nbd
	fio (nbd(/mnt/data/ublk_data_8G_sc0SB.qcow2), libaio, bs 4k, dio, hw queues:1)...
	randwrite: jobs 1, iops 21439
	randread: jobs 1, iops 30336
	randrw: jobs 1, iops read 11476 write 11449
	rw(512k): jobs 1, iops read 718 write 722

2) ublk-qcow2
running qcow2/022
run perf test on pre-allocated qcow2 image via ublk
	fio (ublk/qcow2( -f /mnt/data/ublk_data_8G_yZiaJ.qcow2), libaio, bs 4k, dio, hw queues:1, uring_comp: 0, get_data: 0).
	randwrite: jobs 1, iops 98757
	randread: jobs 1, iops 110246
	randrw: jobs 1, iops read 47229 write 47161
	rw(512k): jobs 1, iops read 1416 write 1427

3) vdpa-virtio-blk
running debug/test_dev
run io test on specified device
	fio (vdpa(/dev/vdc), libaio, bs 4k, dio, hw queues:1)...
	randwrite: jobs 1, iops 47317
	randread: jobs 1, iops 74092
	randrw: jobs 1, iops read 27196 write 27234
	rw(512k): jobs 1, iops read 1447 write 1458


thanks,
Ming
